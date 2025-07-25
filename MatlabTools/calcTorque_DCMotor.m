function tau = calcTorque_DCMotor(V_applied,omega,R_winding,k_t)
%This function calculates DC motor torque at steady state
I = (V_applied-k_t*omega)/R_winding;
tau = k_t*I;

end