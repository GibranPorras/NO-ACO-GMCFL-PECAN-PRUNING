% este script es para saber desde que punto partimos en cuanto a la calidad
% de la estructura de la poda del nogal inicial

parametros = struct('alfa', {}, 'alfa_far', {}, 'm', {}, 'M', {}, 'lambda', {}, 'nadir', {}, 'ideal', {}, 'prioridad', {}, 'max_prioridad', {});
base_path = 'results/PruebasPoda/manual/finales/tree1-line1/';
archivo = fullfile(base_path, 'NogalInicial.mat');
datos = load(archivo);
Nogal = datos.Nogal;

branches_data = Nogal.branch;
treeData = Nogal.treedata;
volumenInicial = Nogal.treedata.TotalVolume;
ramas_primarias = find(branches_data.order == 1);
cant_primarias = length(ramas_primarias);
ramas_finas = find(branches_data.order > 1 & branches_data.length > .6);
cant_finas = length(ramas_finas);

parametros(1).nadir = [3, 35, 110, 6, floor(cant_finas/3), cant_primarias * 25, 0];
parametros(1).ideal = [10, 0, 0, 2, cant_finas, 0, 30];
parametros(1).lambda = [10, 20, 70, 2, floor(cant_finas/2), 25, 30];
t99 = [3, 0, 0, 6, cant_finas, 0, 0];
parametros(1).m = [.5, 0, 0, .5, 1, 0, .5];
parametros(1).alfa = calcular_alpha(parametros(1).lambda, t99);
parametros(1).M = calcular_M(parametros.m);

[valor_objetivos, valores_verdad,  Valor_Predicado] = CFL_closeness_model(0, parametros, branches_data, treeData, volumenInicial);

disp(['Primarias ', 'Verical ', 'Helicodidal ', 'LAI ', 'Finas ', 'Apertura ', 'Podado '])

disp('Valor de los objetivos');
disp(valor_objetivos);

disp('Valor de las variables linguisticas');
disp(valores_verdad);

disp('Valor del predicado');
disp(Valor_Predicado);

disp('=========================================');



function alfa = calcular_alpha(lambda, t99)

    alfa = log(99) ./ abs((t99 - lambda));

end

function M = calcular_M(m)

    M = (m .^ m) .* ((1-m) .^ (1-m));

end
