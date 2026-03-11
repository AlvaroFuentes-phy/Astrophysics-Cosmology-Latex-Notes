
clear; clc; close all;

% Parámetros físicos
P = 12; a1 = 1.6; a2 = 2.8; v_scale = 35; t = 0; dt = 0.05;

% Configuración de la figura
fig = figure('Color', [0.05 0.05 0.1], 'Position', [100, 100, 1000, 750]);

% --- Subplot 1: Sistema Orbital ---
ax1 = subplot('Position', [0.1, 0.45, 0.8, 0.5]);
hold on; axis equal; axis off; xlim([-4.5 4.5]); ylim([-4.5 4.5]);
title('Movimiento Orbital y Efecto Doppler', 'Color', 'w', 'FontSize', 16);
theta_orb = linspace(0, 2*pi, 200);
plot(ax1, a1*cos(theta_orb), a1*sin(theta_orb), 'w:', 'LineWidth', 1, 'Color', [1 1 1 0.2]);
plot(ax1, a2*cos(theta_orb), a2*sin(theta_orb), 'w:', 'LineWidth', 1, 'Color', [1 1 1 0.2]);
plot(ax1, 0, 0, 'y+', 'MarkerSize', 10); % Centro de masas

% Estrellas y Estelas
h1_tail = animatedline('Color', [0.5 0.7 1], 'LineWidth', 1.5, 'MaximumNumPoints', 30);
h2_tail = animatedline('Color', [1 0.6 0.2], 'LineWidth', 1.5, 'MaximumNumPoints', 30);
h1 = scatter(0, 0, 160, 'white', 'filled', 'MarkerEdgeColor', [0.4 0.6 1]);
h2 = scatter(0, 0, 90, [1 0.8 0.4], 'filled', 'MarkerEdgeColor', [1 0.4 0]);

% --- Subplot 2: Espectro Continuo ---
ax2 = subplot('Position', [0.1, 0.1, 0.8, 0.25]);
hold on; set(ax2, 'Color', 'k', 'XColor', 'w', 'YColor', 'none', 'Box', 'on');
xlim([400 700]); ylim([0 1]);
xlabel('Longitud de Onda [nm]', 'Color', 'w', 'FontSize', 12);

% Generación de degradado espectral suave (Interpolación CIE-like)
wv_pts = [400 440 490 510 580 645 700]; % Puntos de control (nm)
rgbs = [0.4 0 0.5;   % Violeta
        0 0 1;       % Azul
        0 1 1;       % Cian
        0 1 0;       % Verde
        1 1 0;       % Amarillo
        1 0 0;       % Rojo
        0.4 0 0];    % Rojo oscuro

lambda_axis = linspace(400, 700, 1000);
full_spec = interp1(wv_pts, rgbs, lambda_axis, 'pchip'); % 'pchip' para suavidad máxima
full_spec = max(0, min(1, full_spec)); % Asegurar rango [0,1]

% Dibujar el fondo del espectro
image([400 700], [0 1], reshape(full_spec, [1, 1000, 3]), 'Parent', ax2);

% Líneas de absorción dinámicas
lineA = plot([550 550], [0 1], 'k', 'LineWidth', 4, 'Parent', ax2);
lineB = plot([550 550], [0 1], 'k', 'LineWidth', 2, 'Parent', ax2);
uistack(lineA, 'top'); uistack(lineB, 'top'); % Líneas negras SIEMPRE arriba

% --- Bucle de Animación ---
while ishandle(fig)
    theta = 2 * pi * t / P;
    
    % Posiciones
    x1 = a1 * cos(theta); y1 = a1 * sin(theta);
    x2 = -a2 * cos(theta); y2 = -a2 * sin(theta);
    
    % Actualizar estrellas y estelas
    set(h1, 'XData', x1, 'YData', y1);
    set(h2, 'XData', x2, 'YData', y2);
    
    % Velocidad radial (proyección vertical hacia el observador)
    vr1 = y1 / a1; 
    vr2 = y2 / a2;
    
    % Desplazamiento Doppler
    lamA = 550 + (vr1 * v_scale);
    lamB = 550 + (vr2 * v_scale);
    
    % Actualizar líneas
    set(lineA, 'XData', [lamA lamA]);
    set(lineB, 'XData', [lamB lamB]);
    
    t = t + dt;
    drawnow limitrate;
    pause(0.01);
end
