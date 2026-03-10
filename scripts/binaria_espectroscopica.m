% Simulación de Binaria Espectroscópica 
clear; clc; close all;

% --- Parámetros de la Simulación ---
P = 15;             % Periodo orbital (más alto = más lento)
a1 = 1.8; a2 = 3;   % Radios de las órbitas
v_max = 0.08;       % Amplitud del desplazamiento (exagerado para visualización)
t = 0;
dt = 0.05;          % Paso de tiempo pequeño para suavidad

% --- Configuración de la Figura ---
fig = figure('Color', 'k', 'Position', [100, 100, 900, 600]);

% Subplot 1: Vista Orbital
ax1 = subplot(2,1,1);
hold on; axis equal; axis off;
xlim([-5 5]); ylim([-5 5]);
title('Sistema Binario Espectroscópico', 'Color', 'w', 'FontSize', 14);

% Dibujar órbitas
theta_range = linspace(0, 2*pi, 100);
plot(a1*cos(theta_range), a1*sin(theta_range), 'w:', 'LineWidth', 0.5);
plot(a2*cos(theta_range), a2*sin(theta_range), 'w:', 'LineWidth', 0.5);
plot(0, 0, 'r+', 'MarkerSize', 8); % Centro de masas

% Estrellas
h1 = plot(0,0, 'wo', 'MarkerSize', 12, 'MarkerFaceColor', [0.8 0.9 1]); % Estrella A
h2 = plot(0,0, 'wo', 'MarkerSize', 8, 'MarkerFaceColor', [1 0.7 0.4]);  % Estrella B
text_a = text(0,0,'A','Color','w','VerticalAlignment','bottom');
text_b = text(0,0,'B','Color','w','VerticalAlignment','bottom');

% Subplot 2: Espectro Completo
ax2 = subplot(2,1,2);
hold on;
set(gca, 'Color', 'none', 'XColor', 'w', 'YColor', 'none', 'Box', 'on');
xlim([400 700]); ylim([0 1]);
xlabel('Longitud de Onda (nm)', 'Color', 'w');

% Crear fondo de arcoíris (gradiente espectral)
map = jet(256); % Usamos el colormap 'jet' para simular el espectro
imagesc([400 700], [0 1], repmat(reshape(map, [1, 256, 3]), 10, 1));
set(gca, 'YTick', []);

% Líneas de absorción (Negras)
lineA = plot([550 550], [0.1 0.9], 'k', 'LineWidth', 2.5);
lineB = plot([550 550], [0.1 0.9], 'k', 'LineWidth', 1.5);
text(410, 0.95, 'Espectro Observado', 'Color', 'w', 'FontWeight', 'bold');
legend([lineA, lineB], {'Línea Estrella A', 'Línea Estrella B'}, 'TextColor', 'w', 'Location', 'northeast');

% --- Bucle de Animación ---
while ishandle(fig)
    % Posiciones orbitales
    theta = 2 * pi * t / P;
    x1 = a1 * cos(theta); y1 = a1 * sin(theta);
    x2 = -a2 * cos(theta); y2 = -a2 * sin(theta);
    
    % Actualizar estrellas
    set(h1, 'XData', x1, 'YData', y1);
    set(h2, 'XData', x2, 'YData', y2);
    set(text_a, 'Position', [x1+0.2, y1+0.2]);
    set(text_b, 'Position', [x2+0.2, y2+0.2]);
    
    % Velocidad Radial (Eje X hacia el observador)
    % Suponemos observador en el eje X lejano
    vr1 = v_max * sin(theta);
    vr2 = -v_max * (a2/a1) * sin(theta);
    
    % Longitudes de onda desplazadas (Base 550 nm)
    lamA = 550 * (1 + vr1);
    lamB = 550 * (1 + vr2);
    
    % Actualizar líneas en el espectro
    set(lineA, 'XData', [lamA lamA]);
    set(lineB, 'XData', [lamB lamB]);
    
    t = t + dt;
    drawnow;
    pause(0.02); % Pausa para controlar la velocidad
end
