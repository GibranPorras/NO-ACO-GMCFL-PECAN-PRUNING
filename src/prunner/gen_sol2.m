function [ants, antscut] = gen_sol2(Nogal_Inicial, feromona, n_hormigas, cant_cilindros, matriz_dependencias, a1, a2, w, pesos_cuts, valores, validos, pesos_validos)

    no_trunk = find(Nogal_Inicial.cylinder.BranchOrder > 0);
    total_cilindros = no_trunk';

    array_branch_cylinder = Nogal_Inicial.cylinder.branch;
    array_branch_cylinder = array_branch_cylinder';
    array_order = Nogal_Inicial.cylinder.BranchOrder;
    cilindros_candidato = find(array_order > 0);


    max_intentos = 2 * n_hormigas;  % Se pueden ajustar
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

        % if r <= a1
        %     [~, cant] = max(feromona_cortes);
        % elseif r <= a2
        %     cant = randsample(valores, 1, true, pesos_cuts);
        % else
        %     cant = randi(length(feromona_cortes));
        % end

        cuts = [];
        already_prune_rama = [];
        ramas_dep_poda = [];
        already_prune = [];
        cantidad_ramas_podadas = 0;
        num_cortes = randsample(valores, 1, true, pesos_cuts);


        while numel(cuts) < num_cortes && cantidad_ramas_podadas < num_cortes
     

            r = rand;
            

            disponibles = ~ismember(cilindros_candidato, already_prune);
            cilindros_disponibles = cilindros_candidato(disponibles);
            pesos_disponibles = pesos_validos(disponibles);

            if r <= a1
                cilindro = intensificacion(cuts, cilindros_disponibles, h, cant_cilindros, feromona, w);
            elseif r <= a2
                cilindro = intermedio(cuts, cilindros_disponibles, h, cant_cilindros, feromona, w);
            else
                cilindro = randsample(cilindros_disponibles, 1, true, pesos_disponibles);
            end

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


        if numel(already_prune) < numel(total_cilindros)
            ant = zeros(1, cant_cilindros);
            ant(already_prune) = 1;
            ants_tmp(h, :) = ant;
            antscut_tmp{h} = sort(cuts, 'descend');
            es_valida(h) = true;
        end
    end
    
    % Filtrar las válidas
    ants_validos = ants_tmp(es_valida, :);
    antscut_validos = antscut_tmp(es_valida);
    % Tomar solo los primeros n_hormigas
    ants = ants_validos(1:n_hormigas, :);
    antscut = antscut_validos(1:n_hormigas);


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
