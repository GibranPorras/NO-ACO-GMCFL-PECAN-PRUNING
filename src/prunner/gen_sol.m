function [ants, antscut] = gen_sol(Nogal_Inicial, feromona, n_hormigas, cant_cilindros, matriz_dependencias, a1, a2, w, pesos_cuts, valores, validos, pesos_validos, probabilidad, a, b)

    no_trunk = find(Nogal_Inicial.cylinder.BranchOrder > 0);
    total_cilindros = no_trunk';
    max_intentos = 5 * n_hormigas;  % Se pueden ajustar

    % informacion de las ramas
    branchData = Nogal_Inicial.branch;
    array_branch_cylinder = Nogal_Inicial.cylinder.branch;
    array_branch_cylinder = array_branch_cylinder';
    volumen_ramas = branchData.volume;
    ramas_validas = find(volumen_ramas > 0);
    array_order_rama = branchData.order(ramas_validas);

    ants_tmp = zeros(max_intentos, cant_cilindros);
    antscut_tmp = cell(max_intentos, 1);
    es_valida = false(max_intentos, 1);

    
    parfor h = 1:max_intentos
        % t = getCurrentTask();
        % if isempty(t)
        %      disp(['Iteración gen_sol' num2str(h) ' en el cliente (NO paralelo)']);
        % else
        %      disp(['Iteración gen_sol' num2str(h) ' en worker ' num2str(t.ID)]);
        % end


        num_cortes = randsample(valores, 1, true, pesos_cuts);
        % obtener candidatos
        ramas_candidato = find(array_order_rama > 0);
        % Obtener los valores correspondientes a los índices de ramas_candidato
        valores_ramas = array_order_rama(ramas_candidato);
        % Ordenar esos valores y obtener los índices de ordenamiento
        [~, orden_indices] = sort(valores_ramas, 'ascend');
        % Aplicar ese orden a ramas_candidato
        ramas_candidato = ramas_candidato(orden_indices);

        cilindros = total_cilindros;
        r = rand;

        cant = randsample(valores, 1, true, pesos_cuts);

        % if r <= a1
        %     [~, cant] = max(feromona_cortes);
        % elseif r <= a2
        %     cant = randsample(valores, 1, true, pesos_cuts);
        % else
        %     cant = randi(length(feromona_cortes));
        % end

        cuts = zeros(1, cant);
        corte = 1;
        already_prune = [];
        already_prune_rama = [];

        for i = 1:length(ramas_candidato)

            if length(cuts) >= num_cortes
                break;
            end

            rama = ramas_candidato(i);
            orden_rama = array_order_rama(rama);
            numeroAleatorio = a + (b - a) * rand;
            cilindros_candidato = find(array_branch_cylinder == rama);

            if ~ismember(rama, already_prune_rama) & ~isempty(cilindros_candidato) && numeroAleatorio < probabilidad(orden_rama)
                
                r = rand;
                aux_cuts = cuts(cuts ~= 0);
    
                if r <= a1
                    cilindro = intensificacion(aux_cuts, cilindros_candidato, h, cant_cilindros, feromona, w);
                elseif r <= a2
                    cilindro = intermedio(aux_cuts, cilindros_candidato, h, cant_cilindros, feromona, w);
                else
                    cilindro = randsample(validos, 1, true, pesos_validos);
                end
    
                if ~ismember(cilindro, already_prune)
                    cuts(end + 1) = cilindro;
                    idx_dep_poda = find(matriz_dependencias(cilindro, :) == 1);
                    % cilindros(ismember(cilindros, idx_dep_poda)) = [];
                    ramas_dep_poda = array_branch_cylinder(idx_dep_poda);
                    ramas_dep_poda = unique(ramas_dep_poda);
                    already_prune_rama = cat(2, already_prune_rama, ramas_dep_poda);
    
                    cuts = sort(cuts, 'descend');
                    already_prune = [already_prune, idx_dep_poda];
              
                end
            end
        end

        already_prune = unique(already_prune);

        if 0 < numel(already_prune) && numel(already_prune) < numel(total_cilindros)
            ant = zeros(1, cant_cilindros);
            ant(already_prune) = 1;
            ants_tmp(h, :) = ant;
            antscut_tmp{h} = cuts(cuts > 0);
            es_valida(h) = true;
        end
    end
    
    if  length(find(es_valida)) >= n_hormigas
    % Filtrar las válidas
    ants_validos = ants_tmp(es_valida, :);
    antscut_validos = antscut_tmp(es_valida);
    % Tomar solo los primeros n_hormigas
    ants = ants_validos(1:n_hormigas, :);
    antscut = antscut_validos(1:n_hormigas);
    else
         error('No se pudieron generar suficientes soluciones válidas.');
    end


end


function cilindro = intermedio(aux_cuts, cilindros, h, cant_cilindros, feromona, w)
            omega_cilindros = zeros(1, cant_cilindros);
            for c = 1: length(cilindros)
                cil = cilindros(c);
                omega_cilindros(cil) = evaluacion(aux_cuts, cil, h, feromona, cant_cilindros, w);
            end
            probabilidades = omega_cilindros / sum(omega_cilindros);
            acumulado = cumsum(probabilidades);
            r = rand;
            cilindro = find(r <= acumulado, 1);
 end


 function cilindro = intensificacion(aux_cuts, cilindros, h, cant_cilindros, feromona, w)
            omega_cilindros = zeros(1, cant_cilindros);
            for c = 1:length(cilindros)
                cil = cilindros(c);
                omega_cilindros(cil) = evaluacion(aux_cuts, cil, h, feromona, cant_cilindros, w);
            end

            [valor, cilindro] = max(omega_cilindros);
            idx_max = find(omega_cilindros == valor);
            cant_max = length(idx_max);
            if cant_max > 1
                indice_aleatorio = randi(cant_max);
                cilindro = idx_max(indice_aleatorio);
            end
end


function omega = evaluacion(aux_cuts, cilindro, h, feromona, cant_cilindros, w)
            cilindros_activos = zeros(1, cant_cilindros);
            aux_cuts = [aux_cuts, cilindro];
            cardinalidad = length(aux_cuts);
            cilindros_activos(aux_cuts) = 1;
            sum_feromona = sum(cilindros_activos .* feromona(cilindro, :));
            T = sum_feromona / cardinalidad;
            omega = (1 - w(h)) * T;
end
