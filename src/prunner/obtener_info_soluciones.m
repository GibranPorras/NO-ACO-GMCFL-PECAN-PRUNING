function info_sol = obtener_info_soluciones(volumen_inicial, cant_primarias_inicial, ramas_finas_inicial, NumberBranches, QSM_hormigas_info, phase, parametros, hormigas, cortes, n_hormigas)
       
  info_sol(1:n_hormigas) = struct( ...
    'valor_objetivos', [], 'valor_verdad', [], ...
    'predicado', [], 'predicado_round', [], 'ant', [], ...
    'puntos_corte', [], 'cortes', [], 'cylinder', [], ...
    'treeData', [], 'branchData', []);
    
    parfor i = 1: n_hormigas

        branches_data = QSM_hormigas_info(i).branch;
        treeData = QSM_hormigas_info(i).treedata;
        volumenInicial = volumen_inicial;

        [valor_objetivos, valores_verdad,  Valor_Predicado] = CFL_closeness_model(phase, parametros, branches_data, treeData, volumenInicial, ramas_finas_inicial, NumberBranches, cant_primarias_inicial);
        info_sol(i).valor_objetivos = valor_objetivos;
        info_sol(i).predicado = Valor_Predicado;
        info_sol(i).predicado_round = round(Valor_Predicado, 2);
        info_sol(i).valor_verdad = valores_verdad;
        info_sol(i).ant = hormigas(i, :);
        info_sol(i).puntos_corte = cortes{i};
        info_sol(i).cortes = length(cortes{i});
        info_sol(i).cylinder = QSM_hormigas_info(i).cylinder;
        info_sol(i).treeData = QSM_hormigas_info(i).treedata;
        info_sol(i).branchData = branches_data;

    end
 end