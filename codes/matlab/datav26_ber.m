%june 9 2022
%goal: ber vs snr in anoma
%ref:https://in.mathworks.com/matlabcentral/...
%answers/383872-matrix-dimensions-must-agree-using-integral

%initial input data 
mod_order = 256;
timeoff_min = 0.1;
timeoff_max = 1;
pk = 1;
noise = 0.001;
p1  = 1;
delta_i = 0.03;

% bit error rate general 
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*pk./(2.*(mod_order-1).*(delta_i.*pi/2+noise))))).^2;
q   = integral(fun,0.1,1)

p_err_sym = (1/(timeoff_max -timeoff_min))*q

p_bit = p_err_sym/log(mod_order)

% bit error rate symbol wise 

delta_21 = 0.1
delta_22 = 0.05

%first user first symbol %s = 11
s = 1;
delta_i = delta_21
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*pk./(2.*(mod_order-1).*(delta_i.*pi/2+noise))))).^2;
p_err_sym = (1/(timeoff_max -timeoff_min))*q

p_bit = p_err_sym/log(mod_order)

% first user second symbol s = 12
s = 2;
delta_i = delta_21+ delta_22
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*pk./(2.*(mod_order-1).*(delta_i.*pi/2+noise))))).^2;
p_err_sym = (1/(timeoff_max -timeoff_min))*q

p_bit = p_err_sym/log(mod_order)
fprintf('first user ber %f\n',p_bit)

% second user second symbol s = 12
s = 1;
delta_11 = 0.002;
delta_12 = 0.001;
delta_i = delta_11+ delta_12; %interference from first user detected symbols
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*pk./(2.*(mod_order-1).*(delta_i.(6/(mod_order-1))*pi/2+noise))))).^2;
p_err_sym = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bit1 = p_err_sym/log(mod_order)

delta_i = delta_11; %interference from first user detected symbols
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*pk./(2.*(mod_order-1).*(delta_i.(6/(mod_order-1))*pi/2+noise))))).^2;
p_err_sym = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bit2 = p_err_sym/log(mod_order)

delta_i = delta_12; %interference from first user detected symbols
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*pk./(2.*(mod_order-1).*(delta_i.(6/(mod_order-1))*pi/2+noise))))).^2;
p_err_sym = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bit3 = p_err_sym/log(mod_order)

delta_i = 0 ;%interference from first user detected symbols
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*pk./(2.*(mod_order-1).*(delta_i.(6/(mod_order-1))*pi/2+noise))))).^2;
p_err_sym = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bit4 = p_err_sym/log(mod_order)

pbit = p_bit1 + p_bit2 + p_bit3 + p_bit4 
fprintf('second user ber %f\n',p_bit)