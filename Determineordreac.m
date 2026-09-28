% ==================== PRIMERA SECCIÓN: ====================

datos_str = input('Ingresa tu matriz de datos: ', 's');   % [C](M) [t](min)

datos = eval(datos_str);                                 % Convierte string a matriz

C = datos(:, 1);                                         % Concentración (mol/L)

t = datos(:, 2);                                         % Tiempo (minutos) - YA EN MINUTOS

% ====================  Preparar los datos ====================

lnC = log(C);                                            % ln(concentración) (adimensional)

invC = 1./C;                                             % 1/concentración (L/mol)

invC2 = 1./(C.^2);                                       % 1/concentración² (L²/mol²)

% ====================  REGRESIÓN LINEAL ====================
p1 = polyfit(t, C, 1);                                   % [A] vs t: pendiente (mol·L⁻¹·min⁻¹), intercepto (mol/L)

C_pred = polyval(p1, t);                                 % Valores predichos de [A] (mol/L)

R2_1 = 1 - sum((C - C_pred).^2) / sum((C - mean(C)).^2); % R² para gráfica 1 (adimensional)

p2 = polyfit(t, lnC, 1);                                 % ln[A] vs t: pendiente (min⁻¹), intercepto (adimensional)

lnC_pred = polyval(p2, t);                               % Valores predichos de ln[A] (adimensional)

R2_2 = 1 - sum((lnC - lnC_pred).^2) / sum((lnC - mean(lnC)).^2); % R² para gráfica 2 (adimensional)

p3 = polyfit(t, invC, 1);                                % 1/[A] vs t: pendiente (L·mol⁻¹·min⁻¹), intercepto (L/mol)

invC_pred = polyval(p3, t);                              % Valores predichos de 1/[A] (L/mol)

R2_3 = 1 - sum((invC - invC_pred).^2) / sum((invC - mean(invC)).^2); % R² para gráfica 3 (adimensional)

p4 = polyfit(t, invC2, 1);          % 1/[A]² vs t: pendiente (L²·mol⁻²·min⁻¹), intercepto (L²/mol²)

invC2_pred = polyval(p4, t);                             % Valores predichos de 1/[A]² (L²/mol²)


R2_4 = 1 - sum((invC2 - invC2_pred).^2) / sum((invC2 - mean(invC2)).^2); % R² para gráfica 4 (adimensional)


% ====================  Mostrar R² ====================


fprintf('\n--- COEFICIENTES DE DETERMINACIÓN (R²) ---\n');


fprintf('[A] vs t: R² = %.6f\n', R2_1);                  % R² gráfica 1 (adimensional, entre 0 y 1)

fprintf('ln[A] vs t: R² = %.6f\n', R2_2);                % R² gráfica 2 (adimensional, entre 0 y 1)

fprintf('1/[A] vs t: R² = %.6f\n', R2_3);                % R² gráfica 3 (adimensional, entre 0 y 1)

fprintf('1/[A]² vs t: R² = %.6f\n', R2_4);               % R² gráfica 4 (adimensional, entre 0 y 1)


% ====================  Determinar mejor gráfica ====================

[R2_max, idx] = max([R2_1, R2_2, R2_3, R2_4]);          % Mayor R² (adimensional)


% ==================== IF-ELSE para orden y k ====================

if idx == 1

    orden = 0;                                            % Orden de reacción: 0
		
    k = -p1(1);                                           % k = -pendiente (mol·L⁻¹·min⁻¹)
		
    unidades = 'mol·L⁻¹·min⁻¹';                           % Unidades de k para orden 0
		
    fprintf('\n MEJOR GRÁFICA: [A] vs t (R² = %.6f)\n', R2_max);
		
elseif idx == 2

    orden = 1;                                            % Orden de reacción: 1
		
    k = -p2(1);                                           % k = -pendiente (min⁻¹)
		
    unidades = 'min⁻¹';                                   % Unidades de k para orden 1
		
    fprintf('\n MEJOR GRÁFICA: ln[A] vs t (R² = %.6f)\n', R2_max);
		
elseif idx == 3

    orden = 2;                                            % Orden de reacción: 2
		
    k = p3(1);                                            % k = pendiente (L·mol⁻¹·min⁻¹)
		
    unidades = 'L·mol⁻¹·min⁻¹';                           % Unidades de k para orden 2
		
    fprintf('\n MEJOR GRÁFICA: 1/[A] vs t (R² = %.6f)\n', R2_max);
		
else
    orden = 3;                                            % Orden de reacción: 3
		
    k = p4(1) / 2;                                        % k = pendiente/2 (L²·mol⁻²·min⁻¹)
		
    unidades = 'L²·mol⁻²·min⁻¹';                          % Unidades de k para orden 3
		
    fprintf('\n MEJOR GRÁFICA: 1/[A]² vs t (R² = %.6f)\n', R2_max);
		
end
% ====================Mostrar resultados ====================


fprintf('\n--- RESULTADOS FINALES ---\n');

fprintf('Orden de reacción: %d\n', orden);               % 0, 1, 2 o 3 (adimensional)

fprintf('k = %.6f %s\n', k, unidades);                  % Constante de velocidad con sus unidades

fprintf('\n-----------------------------------\n');

% ==================== GRÁFICAS ====================

figure('Position', [100, 100, 1200, 800]);               % Ventana: [x, y, ancho, alto] en pixeles pq si 

subplot(2,2,1);

plot(t, C, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5);     % Datos: tiempo(min) vs [A](mol/L)

hold on;

plot(t, C_pred, 'r-', 'LineWidth', 2);                  % Regresión: tiempo(min) vs [A]_pred(mol/L)

xlabel('Tiempo (min)');                                 % Eje X: minutos

ylabel('[A] (mol/L)');                                  % Eje Y: concentración en mol/L

title(sprintf('[A] vs t - R² = %.4f', R2_1));           % Título con R²

grid on;

legend('Datos', 'Regresión', 'Location', 'best');

subplot(2,2,2);

plot(t, lnC, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5);   % Datos: tiempo(min) vs ln[A] (adimensional)

hold on;

plot(t, lnC_pred, 'r-', 'LineWidth', 2);                 % Regresión: tiempo(min) vs ln[A]_pred

xlabel('Tiempo (min)');                                 % Eje X: minutos

ylabel('ln[A]');                                         % Eje Y: adimensional

title(sprintf('ln[A] vs t - R² = %.4f', R2_2));         % Título con R²

grid on;

legend('Datos', 'Regresión', 'Location', 'best');

subplot(2,2,3);

plot(t, invC, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5);  % Datos: tiempo(min) vs 1/[A] (L/mol)

hold on;

plot(t, invC_pred, 'r-', 'LineWidth', 2);                % Regresión: tiempo(min) vs 1/[A]_pred

xlabel('Tiempo (min)');                                 % Eje X: minutos

ylabel('1/[A] (L/mol)');                                % Eje Y: L/mol

title(sprintf('1/[A] vs t - R² = %.4f', R2_3));         % Título con R²

grid on;

legend('Datos', 'Regresión', 'Location', 'best');

subplot(2,2,4);

plot(t, invC2, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5); % Datos: tiempo(min) vs 1/[A]² (L²/mol²)

hold on;

plot(t, invC2_pred, 'r-', 'LineWidth', 2);               % Regresión: tiempo(min) vs 1/[A]²_pred

xlabel('Tiempo (min)');                                 % Eje X: minutos

ylabel('1/[A]² (L²/mol²)');                             % Eje Y: L²/mol²

title(sprintf('1/[A]² vs t - R² = %.4f', R2_4));        % Título con R²
grid on;
legend('Datos', 'Regresión', 'Location', 'best');
