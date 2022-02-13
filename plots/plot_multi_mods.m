% order: 1, 2, base, 3
% row1: param value
% row2: MPKI
% row3: IPC
multi_param1s = [0, 64, 128, 192; ...
    27.0263608108, 27.0263608108, 27.0388104185, 27.1757706127; ...
    0.679504156863, 0.679504156863, 0.679128627451, 0.678223215686];

figure(1)
plot(multi_param1s(1,:), multi_param1s(2,:))
xlabel('Perceptron threshold')
ylabel('MPKI')

figure(2)
plot(multi_param1s(1,:), multi_param1s(3,:))
xlabel('Perceptron threshold')
ylabel('IPC')

% bar graph for upper/lower bound, because they come in pairs
% order (like param1): 1, 2, base, 3
% row1: lower bound
% row2: upper bound
% row3: MPKI
% row4: IPC
multi_param2s = [0, 64, 135, 110; ...
    0, 64, 109, 210; ...
    32.5260564227, 26.9376380722, 27.0388104185, 27.4381557233; ...
    0.650418801961, 0.680067862745, 0.679128627451, 0.676657196078];

X = categorical({'0,0','-64,64','-135,109','-110,210'});
X = reordercats(X,{'0,0','-64,64','-135,109','-110,210'});

figure(3)
bar(X,multi_param2s(3,:))
ylim([26 33]);
xlabel('Perceptron range')
ylabel('MPKI')

figure(4)
bar(X,multi_param2s(4,:))
ylim([0.64 0.685]);
xlabel('Perceptron range')
ylabel('IPC')