function save_nogal_inicial(Nogal,nombre_archivo)
    %extraer nombre de la instancia
    [~, name, ~] = fileparts(nombre_archivo);

    % crear el directorio
    folderPath = fullfile('results', 'PruebasPoda', 'manual', name);

    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end
    
    save(fullfile(folderPath, 'NogalInicial.mat'), "Nogal");

end