function [validos, pesos] = getProbabilidadSeleccionar(array_order)

    validos = find(array_order > 0);
    array_order = array_order(validos);

    % Paso 1: contar frecuencias de cada valor
    [valoresUnicos, ~, idxGrupo] = unique(array_order);
    frecuencias = accumarray(idxGrupo(:), 1);  % cuántas veces aparece cada valor

    % Paso 2: asignar peso inverso a cada posición (1/frecuencia del valor en esa posición)
    pesos = 1 ./ frecuencias(idxGrupo);  % pesos inversos según la frecuencia

    
end

