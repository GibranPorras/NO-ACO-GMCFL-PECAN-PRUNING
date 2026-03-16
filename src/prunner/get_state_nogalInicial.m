function [valor_objetivos, valores_verdad,  Valor_Predicado] = get_state_nogalInicial(branches_data, treeData, volumenInicial, cant_primary, ramas_finas_inicial, NumberBranches)
     % estructura de las metas = [ideal, indiferente, nadir]
    metas = struct('apertura', {}, 'disVertical', {}, 'LAI', {}, 'primarias', {}, 'helicoidal', {}, 'madera', {}, 'finas', {});
    parametros = struct('alfa', {}, 'alfa_far', {}, 'm', {}, 'M', {}, 'lambda', {}, 'nadir', {}, 'ideal', {}, 'prioridad', {}, 'max_prioridad', {});

    metas(1).apertura = [0, 25, cant_primary * 25];
    metas(1).disVertical = [0, 20, 35];
    metas(1).LAI = [2, 4, 6];
    metas(1).primarias = [10, 5, 3];
    metas(1).helicoidal = [0, 70, 110];
    metas(1).madera = [0, 10, 20];
    metas(1).finas = [0, floor(ramas_finas_inicial/2), ramas_finas_inicial];
    metas(1).primarias_podadas = [1, 3, 5];

    valor_objetivos = get_objectives(branches_data, treeData, volumenInicial, ramas_finas_inicial, NumberBranches, cant_primary);
    valor_objetivos(5) = 0;
    valor_objetivos(7) = 0;

    parametros(1).nadir = [metas(1).primarias(3), metas(1).disVertical(3), metas(1).helicoidal(3), metas(1).LAI(3), metas(1).finas(3), metas(1).apertura(3), metas(1).madera(3), metas(1).primarias_podadas(3)];
    parametros(1).ideal = [metas(1).primarias(1), metas(1).disVertical(1), metas(1).helicoidal(1), metas(1).LAI(1), metas(1).finas(1), metas(1).apertura(1), metas(1).madera(1), metas(1).primarias_podadas(1)];
    parametros(1).lambda = [metas(1).primarias(1), metas(1).disVertical(2), metas(1).helicoidal(2), metas(1).LAI(1), metas(1).finas(2), metas(1).apertura(2), metas(1).madera(2), metas(1).primarias_podadas(2)];
    t99 = [metas(1).primarias(3), metas(1).disVertical(1), metas(1).helicoidal(1), metas(1).LAI(3), metas(1).finas(1), metas(1).apertura(1), metas(1).madera(1), metas(1).primarias_podadas(1)];
    parametros(1).m = [.5, 0, 0, .5, 0, 0, 0, 0];
    parametros(1).alfa = calcular_alpha(parametros.lambda, t99); % adaptar
    parametros(1).M = calcular_M(parametros.m); % adaptar

    [valores_verdad,  Valor_Predicado] = phase0(valor_objetivos, parametros);


end

function [valores_verdad,  Valor_Predicado] = phase0(valor_objetivos, parametros)
     
    valores_verdad = zeros(1, numel(valor_objetivos));

    for i = 1 : numel(valor_objetivos)

        t = valor_objetivos(i);
        Miu = calcular_miu(parametros.m(i), parametros.lambda(i), parametros.alfa(i), t, parametros.M(i));
        valores_verdad(i) = Miu;

    end


    Valor_Predicado = (prod(valores_verdad)) ^ (1/7);


    
end


function alfa = calcular_alpha(lambda, t99)

    alfa = log(99) ./ abs((t99 - lambda));

end

function M = calcular_M(m)

    M = (m .^ m) .* ((1-m) .^ (1-m));

end

function miu = calcular_miu(m, lambda, alfa, t, M)

    sigma = calcular_sigma(lambda, alfa, t);
    miu = ((sigma ^ m) * ((1 - sigma)^(1-m))) / M;

end

function sigma = calcular_sigma(lambda, alfa, t1)

   X = alfa*(t1 - lambda);
   sigma = logsig(X);
    
end


