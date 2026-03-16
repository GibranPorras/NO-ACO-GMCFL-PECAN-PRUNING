% escrip para leer la informacion general de las pruebas


base_path = 'results/PruebasPoda/manual/finales/tree1-line1/';
num_pruebas = 1;

for i = 1:num_pruebas
    folder_name = sprintf('prueba%d', i);
    file_path = fullfile(base_path, folder_name, 'resultados.txt');

    if exist(file_path, 'file')
        % Leer el archivo completo como texto
        file_content = fileread(file_path);

        % Extraer Mejor predicado
        mejor_predicado = regexp(file_content, '--- MEJOR PREDICADO ---\s*\[([^\]]+)\]', 'tokens');
        if ~isempty(mejor_predicado)
            mejor_predicado_val = str2num(mejor_predicado{1}{1});
        else
            mejor_predicado_val = [];
        end

        % Extraer Puntos de corte
        puntos_de_corte = regexp(file_content, 'Puntos de corte:\s*\[([^\]]+)\]', 'tokens');
        if ~isempty(puntos_de_corte)
            puntos_val = str2num(puntos_de_corte{1}{1});
        else
            puntos_val = [];
        end

        % Extraer Cortes
        cortes = regexp(file_content, 'Cortes:\s*(\d+)', 'tokens');
        if ~isempty(cortes)
            cortes_val = str2double(cortes{1}{1});
        else
            cortes_val = NaN;
        end

        % Extraer Tiempo total
        tiempo = regexp(file_content, '--- TIEMPO TOTAL ---\s*([\d\.]+)', 'tokens');
        if ~isempty(tiempo)
            tiempo_val = str2double(tiempo{1}{1});
        else
            tiempo_val = NaN;
        end

        % Imprimir resultados
        fprintf('Prueba %d:\n', i);
        fprintf('  Mejor predicado: [%s]\n', num2str(mejor_predicado_val));
        fprintf('  Puntos de corte: [%s]\n', num2str(puntos_val));
        fprintf('  Cortes: %d\n', cortes_val);
        fprintf('  Tiempo total: %.2f segundos\n\n', tiempo_val);
    else
        fprintf('Archivo no encontrado: %s\n', file_path);
    end
end
