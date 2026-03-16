function parametros = update_parametros_script(phase, metas, parametros)
% Actualiza estructura de parámetros basada en fase y metas
% Entradas:
%   - phase: entero (0 a 5)
%   - metas: struct con campos .primarias, .disVertical, etc. (cada uno es un vector [ideal, lambda, nadir])
%   - objetivos: número de objetivos (usualmente 7)



parametros(1).nadir = [metas(1).primarias(3), metas(1).disVertical(3), metas(1).helicoidal(3), metas(1).LAI(3), metas(1).finas(3), metas(1).apertura(3), metas(1).madera(3), metas(1).primarias_podadas(3)];
parametros(1).ideal = [metas(1).primarias(1), metas(1).disVertical(1), metas(1).helicoidal(1), metas(1).LAI(1), metas(1).finas(1), metas(1).apertura(1), metas(1).madera(1), metas(1).primarias_podadas(1)];

if phase == 0
    % parametros(1).lambda = [metas(1).primarias(1), metas(1).disVertical(2), metas(1).helicoidal(2), metas(1).LAI(1), metas(1).finas(2), metas(1).apertura(2), metas(1).madera(1)];
    % t99 = [metas(1).primarias(3), metas(1).disVertical(1), metas(1).helicoidal(1), metas(1).LAI(3), metas(1).finas(1), metas(1).apertura(1), metas(1).madera(3)];
    % parametros(1).m = [.5, 0, 0, .5, 1, 0, .5];
    % parametros(1).alfa = calcular_alpha(parametros.lambda, t99); % adaptar
    % parametros(1).M = calcular_M(parametros.m); % adaptar

    t99 = [.01, .5]; % closeness, farness
    lambda = [metas(1).primarias(2), metas(1).disVertical(2), metas(1).helicoidal(2), metas(1).LAI(2), metas(1).finas(2), metas(1).apertura(2), metas(1).madera(2), metas(1).primarias_podadas(2)];
    parametros(1).lambda = distancia_proporcional(lambda, parametros.ideal, parametros.nadir);
    parametros(1).alfa = calcular_alpha(parametros.lambda, t99(1));
    punto_medio = floor((parametros(1).nadir + lambda) / 2);
    t99_far = distancia_proporcional(punto_medio, parametros.ideal, parametros.nadir);
    parametros(1).alfa_far = calcular_alpha(parametros(1).lambda, t99_far);
    
    % disp('estos son mis t99');
    % disp(t99_far);
    % disp('estas son las metas, lambda, alfa y alfa far de primarias');
    % disp(metas(1).primarias);
    % disp(parametros.lambda(1));
    % disp(parametros.alfa(1));
    % disp(parametros.alfa_far(1));
    % disp('estas son las metas, lambda, alfa y alfa far de vertical');
    % disp(metas(1).disVertical);
    % disp(parametros.lambda(2));
    % disp(parametros.alfa(2));
    % disp(parametros.alfa_far(2));
    % disp('estas son las metas, lambda, alfa y alfa far de helicoidal');
    % disp(metas(1).helicoidal);
    % disp(parametros.lambda(3));
    % disp(parametros.alfa(3));
    % disp(parametros.alfa_far(3));
    % disp('estas son las metas, lambda, alfa y alfa far de LAI');
    % disp(metas(1).LAI);
    % disp(parametros.lambda(4));
    % disp(parametros.alfa(4));
    % disp(parametros.alfa_far(4));
    % disp('estas son las metas, lambda, alfa y alfa far de finas');
    % disp(metas(1).finas);
    % disp(parametros.lambda(5));
    % disp(parametros.alfa(5));
    % disp(parametros.alfa_far(5));
    % disp('estas son las metas, lambda, alfa y alfa far de apertura');
    % disp(metas(1).apertura);
    % disp(parametros.lambda(6));
    % disp(parametros.alfa(6));
    % disp(parametros.alfa_far(6));
    % disp('estas son las metas, lambda, alfa y alfa far de madera');
    % disp(metas(1).madera);
    % disp(parametros.lambda(7));
    % disp(parametros.alfa(7));
    % disp(parametros.alfa_far(7));


else
    lambda = [metas(1).primarias(2), metas(1).disVertical(2), metas(1).helicoidal(2), metas(1).LAI(2), metas(1).finas(2), metas(1).apertura(2), metas(1).madera(2)];
    parametros(1).lambda = distancia_proporcional(lambda, parametros.ideal, parametros.nadir); % adaptar
    t99 = [.01, .5]; % closeness, farness
    parametros(1).m = [0, 1];
    parametros(1).alfa = calcular_alpha(parametros.lambda, t99(1));
    parametros(1).alfa_far = calcular_alpha(parametros.lambda, t99(2));
    parametros(1).M = calcular_M(parametros.m);

end

end

function M = calcular_M(m)

    M = (m .^ m) .* ((1-m) .^ (1-m));

end


function alfa = calcular_alpha(lambda, t99)

    alfa = log(99) ./ abs((t99 - lambda));

end

function alfa = calcular_alpha2(lambda, t99)

    alfa = log(99) / (t99 - lambda);

end

function dis_lambda = distancia_proporcional(lambda, ideal, nadir)
    dis_lambda = (lambda - ideal) ./ (nadir - ideal);
end
