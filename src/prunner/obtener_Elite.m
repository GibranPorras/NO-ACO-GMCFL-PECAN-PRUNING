function Elite = obtener_Elite(nlocal, elite, n_hormigas)

    aux = [nlocal, elite];
    valores = [aux.predicado];
    [~, indices] = sort(valores, 'descend');
    aux = aux(indices);

    indices = [];
    for i=1 : numel(aux)
        close_to_true = closeness_to_true(aux(i).predicado);
        if close_to_true
            indices(end+1) = i;
        else
            break;
        end
    end

    if ~isempty(indices)
        Elite = aux(indices);
        % Eliminar duplicados por 'cortes'
        % Convertimos cada 'cortes' a string para comparar estructuras de arreglos
        cortesStrs = arrayfun(@(x) mat2str(x.puntos_corte), Elite, 'UniformOutput', false);
        
        % Usamos 'unique' para quedarnos con uno por cada arreglo único de 'cortes'
        [~, uniqueIdx] = unique(cortesStrs, 'stable');  % 'stable' conserva el orden original
        Elite = Elite(uniqueIdx);
        Elite = Elite(1:min(n_hormigas, numel(Elite)));
    else

        Elite = [];

    end

end

function close_to_true = closeness_to_true(predicado)
    close_to_true = false;

    if .9 <= predicado
        close_to_true = true;
    end

end