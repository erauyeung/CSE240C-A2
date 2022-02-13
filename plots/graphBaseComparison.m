function graphBaseComparison(sortedData, figurenum)
% cells are of form  51×4 cell array
% trace name, baseMPKI, multiMPKI, shipMPKI
% 51×1 cell array of MPKIs
baseMPKI = cell2mat(sortedData(:,2));
multiMPKI = cell2mat(sortedData(:,3));
shipMPKI = cell2mat(sortedData(:,4));

figure(figurenum)
xlim([0 52])
title('MPKI S-Curve')
ylabel('MPKI')
hold on
plot(baseMPKI,'k.-')
plot(multiMPKI,'r.-')
plot(shipMPKI,'b.-')
legend('Baseline', 'MPPBP', 'SHiP++','Location','north')
hold off

figure(figurenum+1)
xlim('auto')
title('MPKI Bar Graph')
ylabel('MPKI')
traces = sortedData(:,1);
X = categorical(traces');
% needs to match given order which is sorted by MPKI
X = reordercats(X, traces');
hold on
Y = [baseMPKI, multiMPKI, shipMPKI];
b = bar(X, Y);
alpha = 0.6;
b(1).FaceAlpha = alpha;
b(1).FaceColor = 'k';
b(2).FaceAlpha = alpha;
b(2).FaceColor = 'r';
b(3).FaceAlpha = alpha;
b(3).FaceColor = 'b';

legend('Baseline', 'MPPBP', 'SHiP++','Location','north')
hold off
end