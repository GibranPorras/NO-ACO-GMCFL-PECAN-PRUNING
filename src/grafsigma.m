% Definir el rango de valores para x
x = 0:.01:1;
lambda = .75;
t99 = .01;
a =  log(99) / abs((t99 - lambda));
m = 0; % 0 es para min y 1 es para max
t = 4;
ideal = 1;
nadir = 5;
proportional_distance = abs(get_proportional_difference(t, ideal, nadir));
sigma2 = 1 - calcular_sigma(lambda, a, proportional_distance);
% a = (log(.99) - log(.01)) / abs((lambda - beta));
M = (m^m) * ((1-m)^(1-m));
% Calcular la función sigmoide para cada valor de x
X = a .* (x - lambda);
sigma = logsig(X);
GCLV = ((sigma .^ m) .* ((1 - sigma).^(1-m))) / M;
% Graficar la función
plot(x, sigma, 'b', 'DisplayName', '\sigma(x)');
hold on
plot(x, 1 - sigma, 'r', 'DisplayName', '1 - \sigma(x)');
xlabel('x')
ylabel('\sigma(x)')
title('Gráfico de funciones sigmoides')
legend show
grid on
disp('==================================');
disp('esta es la distancia proporcional');
disp(proportional_distance);
disp('este es el valor de alpha');
disp(a);
disp('este es mi valor de sigma: ');
disp(sigma2);
disp('===================================');




function proportional_difference = get_proportional_difference(t, ideal, nadir)

    proportional_difference = (t - ideal) / (nadir - ideal);

end

function sigma = calcular_sigma(lambda, alfa, t1)

  X = alfa*(t1 - lambda);
   sigma = logsig(X);
    
end
