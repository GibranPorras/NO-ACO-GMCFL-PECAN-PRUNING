function NSlocal = obtener_ns_local(O, nlocal, n_hormigas)

    NSlocal = [nlocal, O];
    valores = [NSlocal.predicado];
    [~, indices] = sort(valores, 'descend');
    NSlocal = NSlocal(indices);

    % Eliminar duplicados por 'cortes'
    % Convertimos cada 'cortes' a string para comparar estructuras de arreglos
    cortesStrs = arrayfun(@(x) mat2str(x.puntos_corte), NSlocal, 'UniformOutput', false);
    
    % Usamos 'unique' para quedarnos con uno por cada arreglo único de 'cortes'
    [~, uniqueIdx] = unique(cortesStrs, 'stable');  % 'stable' conserva el orden original
    NSlocal = NSlocal(uniqueIdx);
    NSlocal = NSlocal(1:min(n_hormigas, numel(NSlocal)));

end