% in order of base, 1, 2, 3
% row1: param value
% row2: MPKI
% row3: IPC
ship_param1s = [0, 10, 25, 50; ...
    0.0249340908489 * 1000, 0.0244619804582 * 1000, 0.0240203398852 * 1000, 0.0232765739988 * 1000; ...
    0.67970545098, 0.681217862745, 0.680289117647, 0.677016784314];

figure(1)
plot(ship_param1s(1,:), ship_param1s(2,:))
%title('Override percentage against MPKI')
xlabel('Override percentage')
ylabel('MPKI')

figure(2)
plot(ship_param1s(1,:), ship_param1s(3,:))
%title('Override percentage against IPC')
xlabel('Override percentage')
ylabel('IPC')

ship_param2s = [3, 7, 15, 31; ...
    0.0249340908489 * 1000, 0.025524438091 * 1000, 0.0258909031791 * 1000, 0.0259644449479 * 1000;...
    0.67970545098, 0.677401509804, 0.675248215686, 0.675249176471];

figure(3)
plot(ship_param2s(1,:), ship_param2s(2,:))
%title('Maximum RRPV against MPKI')
xlabel('Maximum RRPV')
ylabel('MPKI')

figure(4)
plot(ship_param2s(1,:), ship_param2s(3,:))
%title('Maximum RRPV against IPC')
xlabel('Maximum RRPV')
ylabel('IPC')