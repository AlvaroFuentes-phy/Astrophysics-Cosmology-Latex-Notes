% Simulación de Efecto Doppler Relativista
clear; clc;

% Parámetros
c = 1;              % Velocidad de la luz normalizada
v = 0.7 * c;        % Velocidad de la fuente (70% de c)
beta = v/c;
gamma = 1 / sqrt(1 - beta^2); % Factor de Lorentz

% Configuración de la figura
figure('Color', 'k');
hold on; axis equal;
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
title(['Efecto Doppler Relativista (v = ', num2str(v), 'c)'], 'Color', 'w');
xlim([-15 25]); ylim([-20 20]);

% Simulación temporal
t_max = 20;
dt = 0.5;
fuente_x = [];

for t = 0:dt:t_max
    cla;
    % Posición actual de la fuente
    curr_x = v * t;
    fuente_x = [fuente_x, curr_x];
    
    % Dibujar frentes de onda emitidos anteriormente
    for i = 1:length(fuente_x)
        t_emision = (i-1) * dt;
        edad = t - t_emision;
        
        % Radio de la onda (se expande a velocidad c)
        % En el marco del observador, la frecuencia cambia
        radio = c * edad;
        
        % Dibujar círculo (frente de onda)
        theta = linspace(0, 2*pi, 100);
        x = fuente_x(i) + radio * cos(theta);
        y = radio * sin(theta);
        
        % Color según desplazamiento (Blue/Redshift)
        if fuente_x(i) < curr_x
            color = [0.4 0.6 1]; % Azulado (acercamiento)
        else
            color = [1 0.3 0.3]; % Rojizo
        end
        
        plot(x, y, 'Color', color, 'LineWidth', 0.5);
    end
    
    % Dibujar la fuente
    plot(curr_x, 0, 'yo', 'MarkerFaceColor', 'y', 'MarkerSize', 8);
    
    drawnow;
    pause(0.05);
end
