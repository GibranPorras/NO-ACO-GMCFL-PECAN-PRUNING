function [max_prioridad, idx] = definir_max_prioridad(valores_verdad_best,vector_prioridad)
    objetivos = numel(valores_verdad_best);
    max_prioridad = zeros(1, objetivos);
    mascara = logical(vector_prioridad);
    valores_verdad_prioridad = valores_verdad_best(mascara);
    [~, idx] = min(valores_verdad_prioridad);
    max_prioridad(idx) = 1;
end