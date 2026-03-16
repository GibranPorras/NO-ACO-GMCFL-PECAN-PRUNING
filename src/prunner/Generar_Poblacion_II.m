function [ants, antscut] = Generar_Poblacion_II(matriz_dependencias, n_hormigas, cant_cilindros, pesos_cuts, valores, cylinder, pesos_validos)

    array_branch_cylinder = cylinder.branch;
    array_branch_cylinder = array_branch_cylinder';
    array_order = cylinder.BranchOrder;
    cilindros_candidato = find(array_order > 0);

    % parametros para parfor
    max_intentos = n_hormigas * 2;
    ants_tmp = zeros(max_intentos, cant_cilindros);
    antscut_tmp = cell(max_intentos, 1);
    es_valida = false(max_intentos, 1);
    
    parfor h = 1:max_intentos
        % t = getCurrentTask();
        % if isempty(t)
        %      disp(['Iteración GENI' num2str(h) ' en el cliente (NO paralelo)']);
        % else
        %     disp(['Iteración GENI' num2str(h) ' en worker ' num2str(t.ID)]);
        % end

        cuts = [];
        already_prune = [];
        already_prune_rama = [];
        ramas_dep_poda = [];
        cantidad_ramas_podadas = 0;
        num_cortes = randsample(valores, 1, true, pesos_cuts);

        while numel(cuts) < num_cortes && cantidad_ramas_podadas < num_cortes

            disponibles = ~ismember(cilindros_candidato, already_prune);
            cilindros_disponibles = cilindros_candidato(disponibles);
            pesos_disponibles = pesos_validos(disponibles);
            cilindro = randsample(cilindros_disponibles, 1, true, pesos_disponibles);

            if ~ismember(cilindro, already_prune)
                
                idx_dep_poda = find(matriz_dependencias(cilindro, :) == 1);

                for j = length(cuts):-1:1  % Recorremos al revés para eliminar sin problemas
                        if ismember(cuts(j), idx_dep_poda)
                            cuts(j) = [];  % Eliminar corte redundante
                            % No incrementamos la cantidad de cortes: se mantiene
                        end
                end

                cuts(end + 1) = cilindro;
                ramas_dep_poda = array_branch_cylinder(idx_dep_poda);
                ramas_dep_poda = unique(ramas_dep_poda);
                already_prune_rama = cat(2, already_prune_rama, ramas_dep_poda);
                cantidad_ramas_podadas = numel(unique(already_prune_rama));
                
                % Actualizamos los ya podados
                already_prune = cat(2, already_prune, idx_dep_poda);
                already_prune = unique(already_prune);


            end

        end


        
        if numel(already_prune) < numel(cilindros_candidato)
            ant = zeros(1, cant_cilindros);
            ant(already_prune) = 1;
            ants_tmp(h, :) = ant;
            antscut_tmp{h} = sort(cuts, 'descend');
            es_valida(h) = true;
        end
    end

    % Filtrar las válidas y recortar a n_hormigas
    validos = find(es_valida);
    if length(validos) >= n_hormigas
        ants = ants_tmp(validos(1:n_hormigas), :);
        antscut = antscut_tmp(validos(1:n_hormigas));
    else
        error('No se pudieron generar suficientes soluciones válidas.');
    end
end
