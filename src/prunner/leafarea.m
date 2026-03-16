base_path = 'results/PruebasPoda/manual/tree2-line7';
prueba = 30;
nogal = 1;  % índice del nogal a graficar

fprintf('\n============== Prueba %d ==============\n', prueba);

folder_name = sprintf('prueba%d', prueba);
archivo = fullfile(base_path, folder_name, 'elite.mat');
datos = load(archivo);
elite = datos.elite;

CrownLength = elite(nogal).treeData.CrownLength;
DBHcyl = elite(nogal).treeData.DBHcyl * 100;
treeHeight = elite(nogal).treeData.TreeHeight;
branchData = elite(nogal).branchData;
ramas = branchData.order > 0;
diametros = branchData.diameter(ramas) .* 100;
CSAs = pi .* ((diametros ./ 2) .^ 2);
BLA = 0.280 .* (CSAs .^ 1.081);
AFE = sum(BLA);
fprintf('Area total de ramas:\n');
disp(AFE);
disp('Cantidad de ramas');
disp(numel(branchData.diameter(ramas)));
% Mostrar información
fprintf('CrownLenght:\n');
disp(CrownLength);

fprintf('DBHcyl:\n');
disp(DBHcyl);

fprintf('TreeHeight:\n');
disp(treeHeight);

fprintf('Calculo de PLA:\n');
PLA = (CrownLength ^ 1.532) * exp((DBHcyl / treeHeight));
disp(PLA);

disp('nueva formula para calcular LAI');
crownAreaConv = elite(nogal).treeData.CrownAreaConv; 
LAI = PLA / crownAreaConv;
disp(LAI);

