function expr_out = removeTime(expr_in)
%Zhiheng Chen
%created: 7/8/2023
%This function removes the "(t)"s in symbolic expressions with terms
%"x(t)"s

expr = char(expr_in);
expr = strrep(expr,"(t)","");
expr = str2sym(expr);
expr_out = expr;

end