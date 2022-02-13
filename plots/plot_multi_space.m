% order: 40, base, 160, 337
multi_space = [40, 80, 160, 337; ...
    27.2367121805, 27.0388104185, 26.9518559099, 26.9790421999; ...
    0.678464980392, 0.679128627451, 0.679908137255, 0.679911254902];

figure(1)
plot(multi_space(1,:), multi_space(2,:))
xlabel('Number of samplers')
ylabel('MPKI')

figure(2)
plot(multi_space(1,:), multi_space(3,:))
xlabel('Number of samplers')
ylabel('IPC')