% funcion principal de optimizacion    
function [NSlocal, Eliteants, best, feromona] = NOACO(NSlocal, Eliteants, best, Nogal_Inicial, cant_primarias, ramas_finas_inicial, NumberBranches, P, p, inputs, phase, feromona, parametros, n_hormigas, cant_cilindros, matriz_dependencias, rep_max, iter_max, a1, a2, w, volumen_tree_original, pesos_cuts, valores, validos, pesos_validos, probabilidad, a, b)
    iter = 0;
    rep = 0;
    lastNSlocal = [];
    cylinder = Nogal_Inicial.cylinder;
    % aqui comienza el ciclo de optimizacion
    while iter < iter_max

        disp(['Inicia poblacion ' num2str(iter + 1)]);
        %[hormigas, cortes] = gen_sol(Nogal_Inicial, feromona, n_hormigas, cant_cilindros, matriz_dependencias, a1, a2, w, pesos_cuts, valores, validos, pesos_validos, probabilidad, a, b);
        [hormigas, cortes] = gen_sol2(Nogal_Inicial, feromona, n_hormigas, cant_cilindros, matriz_dependencias, a1, a2, w, pesos_cuts, valores, validos, pesos_validos);
        QSM_hormigas_info = treeqsmNogal(P, inputs, n_hormigas, hormigas, Nogal_Inicial.segment2, Nogal_Inicial.cover2, Nogal_Inicial.cylinder);
        O = obtener_info_soluciones(volumen_tree_original, cant_primarias, ramas_finas_inicial, NumberBranches, QSM_hormigas_info, phase, parametros, hormigas, cortes, n_hormigas);
        feromona = evaporar_feromona(feromona, p);
        NSlocal = obtener_ns_local(O, NSlocal, n_hormigas);

        % re ordeanr NSlocal para promover busqueda por otros cilindros
        if rep == rep_max
            disp('ya alcanzo el max de reps');
            cant_sol = round(n_hormigas * .10);
            rep = 0;
            %NSlocal_shuffle = shuffle_elite(NSlocal);
            %NSlocal_flip = flip(NSlocal);
            [ants_r, antscut_r] = refresh_NS(matriz_dependencias, cant_sol, cant_cilindros, pesos_cuts, valores, cylinder, pesos_validos);
            QSM_hormigas_r = treeqsmNogal(P, inputs, cant_sol, ants_r, Nogal_Inicial.segment2, Nogal_Inicial.cover2, Nogal_Inicial.cylinder);
            NSlocal_refresh = obtener_info_soluciones(volumen_tree_original, cant_primarias, ramas_finas_inicial, NumberBranches, QSM_hormigas_r, phase, parametros, hormigas, antscut_r, cant_sol);
            feromona = intensificar_feromona(NSlocal_refresh, feromona);
            NSlocal = obtener_ns_local(NSlocal_refresh, NSlocal, n_hormigas);
        else
            feromona = intensificar_feromona(NSlocal, feromona);
        end
        Eliteants = obtener_Elite(NSlocal, Eliteants, n_hormigas);

        % cantidad de veces que se repite best
        n = 3;
        predicado_best = best.predicado;
        best_trunc = floor(predicado_best * 10^n) / 10^n;
        predicado_ns = NSlocal(1).predicado;
        ns_local = floor(predicado_ns * 10^n) / 10^n;
        if isequal(best, NSlocal(1)) || best_trunc == ns_local || isequal(lastNSlocal, NSlocal(1))
            rep = rep + 1;
        elseif best.predicado < NSlocal(1).predicado
            rep = 0;
            best = NSlocal(1);
        end

        for n = 1 : 1
            if numel(NSlocal) > 0
                disp(NSlocal(n).predicado);
                disp(NSlocal(n).valor_objetivos);
                disp(NSlocal(n).valor_verdad);
                disp(NSlocal(n).cortes);
            end
        end

        if numel(NSlocal) > 0
            lastNSlocal = NSlocal(1);
        end
        iter = iter + 1;
     
    end

end