function [ants, antscut] = Generar_Poblacion_I(matriz_dependencias, n_hormigas, cant_cilindros, branchData, array_branch_cylinder, pesos_cuts, valores, probabilidad, a, b)
    
    volumen_ramas = branchData.volume;
    ramas_validas = find(volumen_ramas > 0);
    array_order_rama = branchData.order(ramas_validas);
    max_intentos = n_hormigas * 5;
    ants_tmp = zeros(max_intentos, cant_cilindros);
    antscut_tmp = cell(max_intentos, 1);
    es_valida = false(max_intentos, 1);
    array_branch_cylinder = array_branch_cylinder';
    
    parfor h = 1:max_intentos
        % t = getCurrentTask();
        % if isempty(t)
        %     disp(['Iteración GENI' num2str(h) ' en el cliente (NO paralelo)']);
        % else
        %     disp(['Iteración GENI' num2str(h) ' en worker ' num2str(t.ID)]);
        % end

        cuts = [];
        already_prune = [];
        already_prune_rama = [];

        num_cortes = randsample(valores, 1, true, pesos_cuts);
        % obtener candidatos
        ramas_candidato = find(array_order_rama > 0);
        % Obtener los valores correspondientes a los índices de ramas_candidato
        valores_ramas = array_order_rama(ramas_candidato);
        % Ordenar esos valores y obtener los índices de ordenamiento
        [~, orden_indices] = sort(valores_ramas, 'ascend');
        % Aplicar ese orden a ramas_candidato
        ramas_candidato = ramas_candidato(orden_indices);
       

        for i = 1:length(ramas_candidato)
            if length(cuts) >= num_cortes
                break;
            end
        
            rama = ramas_candidato(i);
            orden_rama = array_order_rama(rama);
        
            if ~ismember(rama, already_prune_rama)
                numeroAleatorio = a + (b - a) * rand;
                if numeroAleatorio < probabilidad(orden_rama)
                    
                    cilindros_candidato = find(array_branch_cylinder == rama);
                    if ~isempty(cilindros_candidato)
                        cilindro = cilindros_candidato(randi(length(cilindros_candidato)));
                        
                        % Dependientes de este nuevo cilindro
                        idx_dep_poda = find(matriz_dependencias(cilindro, :) == 1);
                        ramas_dep_poda = array_branch_cylinder(idx_dep_poda);
                        ramas_dep_poda = unique(ramas_dep_poda);
                        already_prune_rama = cat(2, already_prune_rama, ramas_dep_poda);
                        % Agregamos el nuevo corte
                        cuts(end + 1) = cilindro;
            
                        % Actualizamos los ya podados
                        already_prune = cat(2, already_prune, idx_dep_poda);
                    end
                end
            end
        end

        already_prune = unique(already_prune);

        if 0 < numel(already_prune) && numel(already_prune) < cant_cilindros
            ant = zeros(1, cant_cilindros);
            ant(already_prune) = 1;
            ants_tmp(h, :) = ant;
            antscut_tmp{h} = sort(cuts, 'descend');
            es_valida(h) = true;
        end
    end

    % Filtrar las válidas y recortar a n_hormigas
    validos = find(es_valida);
    if  length(validos) >= n_hormigas
        ants = ants_tmp(validos(1:n_hormigas), :);
        antscut = antscut_tmp(validos(1:n_hormigas));
        for i = 1 : numel(antscut)
            disp(['esto es cuts de ' int2str(i)]);
            disp(antscut(i));
            disp('estp es lo podado: ');
            disp(numel(find(ants(i, :) == 1)));
        end
    else
        error('No se pudieron generar suficientes soluciones válidas.');
    end
end
