% main para usar el software por consola

% ejecutar_poda Ejecuta el algoritmo de poda para un archivo .las
%   nombre_archivo: ruta del archivo .las a procesar

% === CONFIGURACIÓN INICIAL ===
chechboxes = {}; % Se omiten, ya que no se usan fuera de UI
nombresObjetivos = {'primarias', 'disVertical', 'helicoidal', 'LAI', 'finas', 'apertura', 'madera', 'primarias_podadas'};
parametros = struct('alfa', {}, 'alfa_far', {}, 'm', {}, 'M', {}, 'lambda', {}, 'nadir', {}, 'ideal', {}, 'prioridad', {}, 'max_prioridad', {});
nombre_archivo = 'instancias/tree1-line6.las';
objetivos = 8;
n_hormigas = 100;
iter_max = 30;
rep_max = 3;
a1 = .75; 
a2 = .90;
p = .10; 
W = .6;

lasReader = lasFileReader(nombre_archivo);
ptCloud = readPointCloud(lasReader);
P = ptCloud.Location;
P = P - mean(P);

inputs = define_input(P,1,1,1);
Nogal_Inicial = treeqsm(P, inputs, 1, []);
%Nogal_Inicial = load('results/PruebasPoda/tree2-line2/NogalInicial.mat');
%Nogal_Inicial = Nogal_Inicial.Nogal;
volumen_tree_original = Nogal_Inicial(1).treedata.TotalVolume;
branches_data = Nogal_Inicial(1).branch;
treeData = Nogal_Inicial(1).treedata;
%ramas_finas = find(branches_data.order > 1 & branches_data.length > 0.6);
ramas_finas = find(branches_data.order > 1);
ramas_primarias = find(branches_data.order == 1);
ramas_finas_inicial = length(ramas_finas);
cant_primarias = length(ramas_primarias);
array_branch_cylinder = Nogal_Inicial.cylinder.branch;
array_order = Nogal_Inicial.cylinder.BranchOrder;
cant_cilindros = length(array_branch_cylinder);
cylinder = Nogal_Inicial.cylinder;
NumberBranches = numel(find(branches_data.order > 0));
% === GENERAR PROBABILIDADES DE CORTE ===

tercio_ramas = floor(NumberBranches / 3);
limite_alta = min(10, NumberBranches);  % límite superior de zona1

% Zona 1: primeros cortes, con peso fijo alto
zona1 = 1:limite_alta;
pesos1 = ones(1, numel(zona1)) * 5;

% Zona 2: hasta el tercio de las ramas, pesos decrecientes
zona2 = (limite_alta+1):min(tercio_ramas, NumberBranches);
if ~isempty(zona2)
    pesos2 = linspace(3, 1, numel(zona2));
else
    pesos2 = [];
end

% Combinar pesos solo de zona1 y zona2
valores = [zona1 zona2];  % Actualizamos también los índices válidos
pesos_cuts = [pesos1, pesos2];
pesos_cuts = pesos_cuts / sum(pesos_cuts);  % Normalizar

% Verificación
assert(numel(pesos_cuts) == numel(valores), 'Error en la generación de pesos.');

% === MATRIZ DE DEPENDENCIAS Y VARIABLES DERIVADAS ===
matriz_dependencias = construir_matriz_dependencia(Nogal_Inicial.cylinder);



% obtener el estado inicial del nogal, respecto a las recomendaciones del
% lider central
[valor_objetivos_NI, valores_verdad_NI,  Valor_Predicado_NI] = get_state_nogalInicial(branches_data, treeData, volumen_tree_original, cant_primarias, ramas_finas_inicial, NumberBranches);
% disp('de este nogal partimos');
% disp(valor_objetivos_NI);
% disp(valores_verdad_NI);
% disp(Valor_Predicado_NI);
% disp('estas son las ramas finas');
% disp(ramas_finas_inicial);

% definir las metas a partir de el estado inicial del nogal
metas = metas_lider_central(cant_primarias, ramas_finas_inicial, valor_objetivos_NI, NumberBranches); 

parametros = update_parametros_script(0, metas, parametros);


[probabilidad_de_cortar, a, b] = getProbabilidadcorte(array_order);
[validos, pesos_validos] = getProbabilidadSeleccionar(array_order);

%get_info_nogal(Nogal_Inicial, probabilidad_de_cortar, a, b, valores, pesos_cuts, matriz_dependencias, validos, pesos_validos);

% === CICLO DE PRUEBAS ===
for k = 1:30
   
    fprintf("\n⏳ Inicia prueba %d\n", k);
    tic;

    % Inicializar estructuras
    iter = 0; rep = 0; phase = 0;
    Eliteants = struct('valor_objetivos', {}, 'valor_verdad', {}, 'predicado', {}, 'predicado_round', {},'ant', {}, 'puntos_corte', {}, 'cortes', {}, 'cylinder',{}, 'treeData', {}, 'branchData', {});
    NSlocal = struct('valor_objetivos', {}, 'valor_verdad', {}, 'predicado', {}, 'predicado_round', {},'ant', {}, 'puntos_corte', {}, 'cortes', {}, 'cylinder',{}, 'treeData', {}, 'branchData', {});

    w = W * rand(n_hormigas * 5, 1);
    feromona = ones(length(Nogal_Inicial.cylinder.branch));
    %feromona_cortes = ones(1, NumberBranches);

    parametros.prioridad = definir_prioridad(valores_verdad_NI);

    %[hormigas, cortes] = Generar_Poblacion_I(matriz_dependencias, n_hormigas, cant_cilindros, branches_data, array_branch_cylinder, pesos_cuts, valores, probabilidad_de_cortar, a, b);
    [hormigas, cortes] = Generar_Poblacion_II(matriz_dependencias, n_hormigas, cant_cilindros, pesos_cuts, valores,  cylinder, pesos_validos);
    QSM_hormigas_info = treeqsmNogal(P, inputs, n_hormigas, hormigas, Nogal_Inicial.segment2, Nogal_Inicial.cover2, Nogal_Inicial.cylinder);
    feromona = evaporar_feromona(feromona, p);
    O = obtener_info_soluciones(volumen_tree_original, cant_primarias, ramas_finas_inicial, NumberBranches, QSM_hormigas_info, phase, parametros, hormigas, cortes, n_hormigas);
    NSlocal = obtener_ns_local(O, NSlocal, n_hormigas);
    best = NSlocal(1);
    first_predicado = NSlocal(1).predicado;
    feromona = intensificar_feromona(NSlocal, feromona);
    mejor_predicado = zeros(1, 6);


    while phase <= 0
        fprintf("Fase actual: %d\n", phase);
        [NSlocal, Eliteants, best, feromona] = NOACO(NSlocal, Eliteants, best, Nogal_Inicial, cant_primarias, ramas_finas_inicial, NumberBranches, P, p, inputs, phase, feromona, parametros, n_hormigas, cant_cilindros, matriz_dependencias, rep_max, iter_max, a1, a2, w, volumen_tree_original, pesos_cuts, valores, validos, pesos_validos, probabilidad_de_cortar, a, b);
        mejor_predicado(phase + 1) = best(1).predicado;
        phase = phase + 1;
        parametros = update_parametros_script(0, metas, parametros);
        if phase == 5
            [parametros.max_prioridad, idx] = definir_max_prioridad(best(1).valor_verdad, parametros.prioridad);
            parametros.prioridad(idx) = 0;
        end
     
    end

    tiempo = toc;
    
    if isempty(Eliteants)
        disp('esto es best');
        disp(best(1).predicado);
        disp(best(1).valor_objetivos);
        disp(best(1).valor_verdad);
        disp(best(1).cortes);
        Eliteants = NSlocal(1:min(10, numel(NSlocal)));
    end

    parametros = update_parametros_script(0, metas, parametros);
    prueba = sprintf('prueba%d', k);
    save_nogal_inicial(Nogal_Inicial, nombre_archivo);
    save_test(Eliteants, nombre_archivo, prueba, first_predicado, mejor_predicado, tiempo, parametros.prioridad, parametros.max_prioridad, valor_objetivos_NI, metas);
end

fprintf("\n✅ Termina algoritmo\n");

