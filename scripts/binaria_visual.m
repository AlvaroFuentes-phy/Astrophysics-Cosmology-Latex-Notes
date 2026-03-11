
clear; clc; close all;

% --- Parámetros Físicos ---
R1 = 1.2;      % Radio estrella 1
R2 = 0.8;      % Radio estrella 2
L1 = 1.5;      % Luminosidad (brillo) estrella 1
L2 = 0.5;      % Luminosidad estrella 2
a = 5;         % Separación orbital
periodo = 100; % Pasos de tiempo por órbita
t = linspace(0, 2*pi, periodo);

% --- Preparación de la Interfaz ---
figure('Color', 'k', 'Name', 'Simulación de Sistema Binario');
subplot(2,1,1);
hold on; axis equal; grid off;
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
title('Vista del Plano Orbital', 'Color', 'w');

subplot(2,1,2);
hold on;
h_luz = animatedline('Color', 'y', 'LineWidth', 2);
axis([0 2*pi 0 (L1 + L2 + 0.2)]);
xlabel('Fase Orbital'); ylabel('Luminosidad Total');
title('Curva de Luz en Tiempo Real', 'Color', 'w');
set(gca, 'Color', '[0.1 0.1 0.1]', 'XColor', 'w', 'YColor', 'w');

% --- Bucle de Animación ---
for i = 1:length(t)
    subplot(2,1,1);
    cla;
    
    % Posiciones (simplificadas: circular en el plano x-z para ver eclipses)
    x1 = (a/2) * cos(t(i));
    z1 = 0; % Profundidad (para orden de dibujo)
    x2 = -(a/2) * cos(t(i));
    
    % Profundidad relativa para simular el eclipse (Eje Y es la línea de visión)
    y1 = (a/2) * sin(t(i));
    y2 = -(a/2) * sin(t(i));
    
    % Cálculo de la luminosidad observada
    dist_proyectada = abs(x1 - x2);
    brillo_total = L1 + L2;
    
    % Lógica de Eclipse simple (proyección en el plano X)
    if dist_proyectada < (R1 + R2)
        % Área de superposición simplificada
        interseccion = max(0, (R1 + R2) - dist_proyectada) / (R1 + R2);
        if y1 > y2 % Estrella 1 está detrás
            brillo_total = brillo_total - (L1 * 0.5 * interseccion);
        else      % Estrella 2 está detrás
            brillo_total = brillo_total - (L2 * 0.5 * interseccion);
        end
    end
    
    % Dibujar Estrellas
    rectangle('Position', [x1-R1, -R1, 2*R1, 2*R1], 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'y');
    rectangle('Position', [x2-R2, -R2, 2*R2, 2*R2], 'Curvature', [1 1], 'FaceColor', [1 0.5 0], 'EdgeColor', 'r');
    
    % Actualizar Gráfico de Luz
    addpoints(h_luz, t(i), brillo_total);
    
    drawnow;
    pause(0.05);
end
