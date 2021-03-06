%june 9 2022
%goal: ber vs snr in anoma
%ref:https://in.mathworks.com/matlabcentral/...
%answers/383872-matrix-dimensions-must-agree-using-integral
clear all; 
clc;

%initial input data 
mod_order = 4;
timeoff_min = 0.01;
timeoff_max = 0.5;
p_a = 1000; %40 dB
p_b = 500;
p_c = 100;
noise = 0.1;

% bit error rate for general case 
delta_i = 0.3;
fun = @(delta_i) (qfunc(sqrt(3*p_a./(2.*(mod_order-1).*(delta_i.*p_b/2+noise))))).^2;
q   = integral(fun,0.1,1)
p_err_sym = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bit = p_err_sym/log(mod_order)

%% first user BER
% bit error rate symbol wise 

%A1 -> interf by B1
delta_21 = 0.5;
delta_22 = 0.3;
delta_23 = 0.2;
delta_i = delta_21;
fun = @(delta_i) (1-(1 - qfunc(sqrt(3*p_a./(2.*(mod_order-1).*...
    (delta_i.*p_b/2+noise))))).^2);
q   = integral(fun,timeoff_min,timeoff_max);
p_err_sym1 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bita1 = p_err_sym1/log(mod_order)

%A2-> interf by B1 and B2
delta_i = (1-delta_21) + delta_22;
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_a./(2.*(mod_order-1).*...
    (delta_i.*p_b/2+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_err_sym2 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bita2 = p_err_sym2/log(mod_order)

%A3-> interf by B2 and B3
delta_i = (1-delta_22) + delta_23;
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_a./(2.*(mod_order-1).*...
    (delta_i.*p_b/2+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_err_sym3 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bita3 = p_err_sym3/log(mod_order)

%% second user BER
% second user second symbol s = 12 %B1
%B1-> interf by A1 and A2, and C1
delta_11 = 0.6;
delta_12 = 0.3;
delta_31 = 0.4;
delta_i = delta_11 + delta_12+delta_31; %interference from first user detected symbols

fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_b./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_a/2+ delta_31*p_c/2+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interb1 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_sym = p_interb1*p_err_sym1*p_err_sym2;
p_bit1 = p_err_sym/log(mod_order);

delta_i = delta_11+delta_31; %interference from first user detected symbols
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_b./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_a/2+delta_31*p_c/2+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interb2 =(1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_sym = p_interb2*(1-p_err_sym1)*p_err_sym2;
p_bit2 = p_err_sym/log(mod_order);

delta_i = delta_12+delta_31; %interference from first user detected symbols
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_b./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_a/2+delta_31*p_c/2+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interb3 =(1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_sym = p_interb3*p_err_sym1*(1-p_err_sym2);
p_bit3 = p_err_sym/log(mod_order);

delta_i = delta_31;%interference from first user detected symbols
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_b./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_a/2+delta_31*p_c+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interb4 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_sym = p_interb4*(1-p_err_sym1)*(1-p_err_sym2);
p_bit4 = p_err_sym/log(mod_order);

p_bitb1 = p_bit1 + p_bit2 + p_bit3 + p_bit4 

%B2-> interf by A2 and A3, C1 and C2
delta_13 = 0.2;
delta_32 = 0.1;
delta_i = delta_12 + delta_13 + delta_31 + delta_32; %interference from first user detected symbols
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_b./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_a/2+(delta_31+delta_32)*p_c+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interb4 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_sym = p_interb4*(p_err_sym2)*(p_err_sym3);
p_bitb21 = p_err_sym/log(mod_order);

fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_b./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_a/2+(delta_31+delta_32)*p_c+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interb4 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_sym = p_interb4*(1-p_err_sym2)*(p_err_sym3);
p_bitb22 = p_err_sym/log(mod_order);

fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_b./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_a/2+(delta_31+delta_32)*p_c+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interb4 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_sym = p_interb4*(p_err_sym2)*(1-p_err_sym3);
p_bitb23 = p_err_sym/log(mod_order);

fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_b./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_a/2+(delta_31+delta_32)*p_c+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interb4 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_syma = p_interb4*(1-p_err_sym2)*(1-p_err_sym3);
p_bitb24 = p_err_syma/log(mod_order);

p_bitb2 =p_bitb21+p_bitb22+p_bitb23+p_bitb24

%% third user BER
%C1-> interf by B1 and B2
delta_21 = 0.2;
delta_22 = 0.1;
delta_i = delta_21 + delta_22; %interference from first user detected symbols

fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_c./(2.*(mod_order-1).*...
    (delta_i.*(6/(mod_order-1))*p_b/2+noise))))).^2;
q   = integral(fun,timeoff_min,timeoff_max);
p_interc = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_err_symc = p_interc*(p_bitb1*log(mod_order))*(p_bitb2*log(mod_order));
p_bitc1 = p_err_symc/log(mod_order)


%% first user BER for 2nd time
% bit error rate symbol wise 

%A1 -> interf by B1
delta_21 = 0.5;
delta_22 = 0.3;
delta_23 = 0.2;
delta_i = delta_21;
fun = @(delta_i) (1-(1 - qfunc(sqrt(3*p_a./(2.*(mod_order-1).*...
    (delta_i.*p_b/2+noise))))).^2);
q   = integral(fun,timeoff_min,timeoff_max);
p_err_sym1 = (1/(timeoff_max -timeoff_min))*q*delta_i*...
    (p_bitb1*log(mod_order));
p_bita1 = p_err_sym1/log(mod_order)

%A2-> interf by B1 and B2
delta_i = (1-delta_21) + delta_22;
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_a./(2.*(mod_order-1).*...
    (delta_i.*p_b/2+noise))))).^2;
p_err_sym2 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bita2 = p_err_sym2/log(mod_order)

%A3-> interf by B2 and B3
delta_i = (1-delta_22) + delta_23;
fun = @(delta_i) 1-(1 - qfunc(sqrt(3*p_a./(2.*(mod_order-1).*...
    (delta_i.*p_b/2+noise))))).^2;
p_err_sym3 = (1/(timeoff_max -timeoff_min))*q*delta_i;
p_bita3 = p_err_sym3/log(mod_order)


%function 
%continue here