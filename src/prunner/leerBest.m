% Script para graficar la mejor solución de múltiples pruebas
base_path = 'results/PruebasPoda/manual/finales/tree1-line1';
num_pruebas = 5;
nogal = 1;  % índice del nogal a graficar

for i = 1:num_pruebas
    fprintf('\n============== Prueba %d ==============\n', i);

    folder_name = sprintf('prueba%d', i);
    archivo = fullfile(base_path, folder_name, 'elite.mat');

    if exist(archivo, 'file')
        datos = load(archivo);
        elite = datos.elite;

        % Mostrar información
        fprintf('Predicado:\n');
        disp(elite(nogal).predicado);
        fprintf('Cortes:\n');
        disp(elite(nogal).cortes);
        fprintf('Cilindros de corte:\n');
        disp(elite(nogal).puntos_corte);

        % Graficar cilindros
        disp('Graficar cilindros...');
        modalElegido = modalFinal();
        modalElegido.setGrafica(elite(nogal).cylinder);

        % Objetivos
        modalElegido.Primarias.Value      = double(elite(nogal).valor_objetivos(1));
        modalElegido.Finas.Value          = double(elite(nogal).valor_objetivos(5));
        modalElegido.Dishelicoidal.Value  = double(elite(nogal).valor_objetivos(3));
        modalElegido.Volpodado.Value      = double(elite(nogal).valor_objetivos(7));
        modalElegido.Disvertical.Value    = double(elite(nogal).valor_objetivos(2));
        modalElegido.Angulos.Value        = double(elite(nogal).valor_objetivos(6));
        modalElegido.Luz.Value            = double(elite(nogal).valor_objetivos(4));

        % Datos generales del nogal
        modalElegido.ElegidoAltura.Value             = double(elite(nogal).treeData.TreeHeight);
        modalElegido.ElegidoCantidadramas.Value      = double(elite(nogal).treeData.NumberBranches);
        modalElegido.ElegidoMaxorden.Value           = double(elite(nogal).treeData.MaxBranchOrder);
        modalElegido.ElegidoLargotronco.Value        = double(elite(nogal).treeData.TrunkLength);
        modalElegido.ElegidoLargocopa.Value          = double(elite(nogal).treeData.CrownLength);
        modalElegido.ElegidoVolumencopa.Value        = double(elite(nogal).treeData.CrownVolumeConv);
        modalElegido.ElegidoDiametrocopa.Value       = double(elite(nogal).treeData.CrownDiamMax);
        
    else
        fprintf('Archivo no encontrado: %s\n', archivo);
    end
end
