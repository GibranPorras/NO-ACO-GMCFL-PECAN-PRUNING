function [probabilidad, a, b] = getProbabilidadcorte(array_order)
    array_order_branch = array_order(array_order ~= 0);
    
    % Obtener valores únicos y sus índices
    [orders_raw, ~, idx] = unique(array_order_branch);
    
    % Convertir a double explícitamente
    orders = double(orders_raw);
    conteo = accumarray(idx, 1);
    conteo = double(conteo);  % <-- muy importante

    % Parámetro de redistribución
    alpha = 1;  % < 1 aplanará la distribución; ajusta a gusto (0.3–0.7 recomendado)

    % Aplicar suavizado proporcional (redistribución)
    conteo_modificado = conteo .^ alpha;

    % parametro para suavisar
    
    % Cálculo de pesos y probabilidad
    pesos = orders / sum(orders);
    probabilidad = pesos ./ conteo_modificado;
    
    % Normalizar si quieres que sumen 1
    probabilidad = probabilidad / sum(probabilidad);
    
    a = probabilidad(1) - 0.00020;
    b = probabilidad(end) + 0.01;


end

