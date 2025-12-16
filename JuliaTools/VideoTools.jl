using Pkg;Pkg.activate(raw"D:\Toolboxes\JuliaTools");Pkg.instantiate()  # change to the path of the folder PDFTools.jl is in

module VideoTools 

export bilateralFilter,interpVideo_opticalFlow,reverseVideo

using PythonCall 
using CondaPkg

function bilateralFilter(inputPath::String;outputPath::String="",
                         diameter::Int=9,sigma_color::Float64=2500.0,sigma_space::Float64=50.0)
    # diameter: range of pixels of blur; 9 by default
    # sigma_color: range of colors to mix（to what extent to "trust" different colors; larger=more blurred); 100 by default
    # sigma_space: to what extent to "trust" farther away pixels; 75 by defalt

    # import inside function ensures it works even if module is precompiled
    cv2 = pyimport("cv2")

    if !isfile(inputPath)
        error("input video not found: $inputPath")
    end
    if isempty(outputPath)
        outputPath = replace(inputPath,".mp4"=>"_Filtered.mp4")
    end

    # open video capture
    cap = cv2.VideoCapture(inputPath)
    
    # get video properties
    fps = pyconvert(Float64,cap.get(cv2.CAP_PROP_FPS))
    width = pyconvert(Int,cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = pyconvert(Int,cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    frameCount = pyconvert(Int,cap.get(cv2.CAP_PROP_FRAME_COUNT))

    # setup video writer
    # Python: cv2.VideoWriter_fourcc(*'mp4v')
    # Julia: pass characters individually
    fourcc = cv2.VideoWriter_fourcc("m","p","4","v")
    out = cv2.VideoWriter(outputPath,fourcc,fps,(width,height))

    println("starting bilateral filter on $frameCount frames...")
    
    currentFrame = 0
    
    try
        while true
            # read frame
            # cap.read() returns a Python tuple (ret, frame)
            # PythonCall allows 0-based indexing on Python objects
            res = cap.read()
            ret = pyconvert(Bool,res[0]) # convert Python boolean to Julia Bool
            
            if !ret
                break
            end
            
            frame = res[1] # keep this as a Python object rather than a Julia array
            # apply filter
            # we pass the Python object 'frame' directly back to OpenCV
            filtered = cv2.bilateralFilter(frame,diameter,sigma_color,sigma_space)
            
            # write frame
            out.write(filtered)

            currentFrame += 1
            if currentFrame % 10 == 0
                print("\rprogress: $currentFrame / $frameCount")
                GC.gc()
            end
        end
        println("\nfinished; output saved to: $outputPath")
        
    catch e
        println("\nerror during processing: $e")
        rethrow(e)
    finally
        # cleanup resources safely
        cap.release()
        out.release()
    end
end

function interpVideo_opticalFlow(inputPath::String;outputPath::String="",interpolation::String="2x")
    cv2 = pyimport("cv2")
    np = pyimport("numpy") # need numpy for meshgrid and array math

    if !isfile(inputPath)
        error("input video not found: $inputPath")
    end
    if isempty(outputPath)
        outputPath = replace(inputPath,".mp4"=>"_Interpolated.mp4")
    end

    # parse multiplier (e.g., "4x"->4)
    multiplier = try
        parse(Int,interpolation[1:end-1])
    catch
        error("invalid interpolation format; use '2x', '4x', etc.")
    end

    cap = cv2.VideoCapture(inputPath)
    
    # get properties and convert to Julia types
    fps = pyconvert(Float64,cap.get(cv2.CAP_PROP_FPS))
    width = pyconvert(Int,cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = pyconvert(Int,cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    totalFrames = pyconvert(Int,cap.get(cv2.CAP_PROP_FRAME_COUNT))

    # setup VideoWriter
    fourcc = cv2.VideoWriter_fourcc("m","p","4","v")
    fps_out = fps*multiplier
    out = cv2.VideoWriter(outputPath,fourcc,fps_out,(width,height))

    println("starting interpolation ($interpolation) on $totalFrames frames...")

    # read first frame
    res = cap.read()
    if !pyconvert(Bool,res[0])
        error("failed to read first frame")
    end
    prev_frame = res[1]
    prev_gray = cv2.cvtColor(prev_frame,cv2.COLOR_BGR2GRAY)

    # pre-calculate the coordinate grid
    # equivalent to: grid_x,grid_y = np.meshgrid(np.arange(w),np.arange(h))
    grid_x,grid_y = np.meshgrid(np.arange(width),np.arange(height))
    
    # equivalent to: np.dstack((grid_x, grid_y)).astype(np.float32)
    # note: must pass a Python List/Tuple to dstack
    base_map = np.dstack((grid_x,grid_y)).astype(np.float32)

    currentFrame = 0
    
    try
        while true
            res = cap.read()
            if !pyconvert(Bool,res[0])
                break
            end
            next_frame = res[1]
            next_gray = cv2.cvtColor(next_frame, cv2.COLOR_BGR2GRAY)

            # calculate Optical Flow (Farneback)
            # returns a NumPy array (Py object)
            flow = cv2.calcOpticalFlowFarneback(prev_gray,next_gray,nothing,
                                                pyr_scale=0.5,levels=3,winsize=15,
                                                iterations=3,poly_n=5,poly_sigma=1.2,flags=0)

            # write original frame
            out.write(prev_frame)

            # interpolate intermediate frames
            for i in 1:(multiplier - 1)
                alpha = i / multiplier
                
                # math on PyObjects
                # PythonCall forwards these operators to Python's __add__ and __mul__
                # this runs effectively as: flow_map = base_map + (flow * alpha)
                interp_map = base_map+(flow*alpha)
                
                # remap
                mid_frame = cv2.remap(prev_frame,interp_map,nothing,cv2.INTER_LINEAR)
                out.write(mid_frame)
            end

            # update state
            prev_frame = next_frame
            prev_gray = next_gray

            currentFrame += 1
            if currentFrame % 10 == 0
                print("\rprogress: $currentFrame / $totalFrames frames processed")
                GC.gc()
            end
        end

        # write the very last frame
        out.write(prev_frame)
        println("\nfinished; output saved to: $outputPath")

    catch e
        println("\nerror: $e")
        rethrow(e)
    finally
        cap.release()
        out.release()
    end
end

function reverseVideo(inputPath::String;outputPath::String="")
    if !isfile(inputPath)
        error("input video not found: $inputPath")
    end
    if isempty(outputPath)
        outputPath = replace(inputPath,".mp4"=>"_Reversed.mp4")
    end

    # locate ffmpeg inside the Conda environment
    # this guarantees we find the tool we just installed
    ffmpeg_exe = CondaPkg.which("ffmpeg")

    # define temporary filenames
    # use the output name as a base to avoid collisions
    temp_video = replace(outputPath, r"\.mp4$"i => "_temp_rev_video.mp4")
    temp_audio = replace(outputPath, r"\.mp4$"i => "_temp_rev_audio.m4a")

    println("starting reverse process on: $inputPath")

    try
        # reverse video (no audio)
        println(" - reversing video stream...")
        cmd_v = `$ffmpeg_exe -y -v error -i $inputPath -an -vf reverse -preset ultrafast $temp_video`
        run(cmd_v)

        # reverse audio (no video)
        println(" - reversing audio stream...")
        cmd_a = `$ffmpeg_exe -y -v error -i $inputPath -vn -af areverse $temp_audio`
        run(cmd_a)

        # combine
        println(" - muxing streams...")
        cmd_merge = `$ffmpeg_exe -y -v error -i $temp_video -i $temp_audio -c:v copy -c:a aac -shortest $outputPath`
        run(cmd_merge)

        println("reverse finished; output: $outputPath")

    catch e
        error("FFmpeg failed: $e")
    finally
        # Step D: Cleanup intermediate files
        # This runs even if an error occurs, keeping your folder clean
        rm(temp_video, force=true)
        rm(temp_audio, force=true)
    end
end

end

using .VideoTools