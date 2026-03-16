function get_info_nogal(NogalInicial, probabilidad_de_cortar, a, b, valores, pesos_cuts, matriz_dependencias, validos, pesos_validos)
   branch = NogalInicial.branch;
   cylinder = NogalInicial.cylinder;
   %disp('Esta es la cantidad de ramas');
   %disp(numel(branch.order));
   ramas_validas = find(branch.order > 1 & branch.length > 0.6);
   %disp('estas son las ramas validas');
   %disp(ramas_validas);

   disp('estos son los pesos_cuts');
   disp(numel(pesos_cuts));

   %disp('esta es la tabla');
   T = table(branch.order, branch.parent, branch.diameter, branch.volume, ...
          branch.area, branch.length, branch.angle, branch.height, ...
          branch.azimuth, branch.zenith, ...
          'VariableNames', {'Order', 'Parent', 'Diameter', 'Volume', ...
                            'Area', 'Length', 'Angle', 'Height', ...
                            'Azimuth', 'Zenith'});

    T_validas = T(ramas_validas, :);
    %disp(T_validas(:, {'Length'}));  % Imprime en formato tabla en consola

    conteo_ordenes = groupcounts(T_validas.Order);
    ordenes_unicos = unique(T_validas.Order);
    
    % Mostrar resultados como tabla
    tabla_conteo = table(ordenes_unicos, conteo_ordenes, ...
        'VariableNames', {'Order', 'Cantidad'});
    %disp(tabla_conteo);

    cilindros = NogalInicial.cylinder;
    
    %disp(['esta es la cantidad de ramas de orden' int2str(order)]);
    %disp(numel(ramas_de_orden'));
    Tcilindros = table( ...
    cilindros.radius, ...
    cilindros.length, ...
    cilindros.start(:,1), cilindros.start(:,2), cilindros.start(:,3), ...
    cilindros.axis(:,1), cilindros.axis(:,2), cilindros.axis(:,3), ...
    cilindros.parent, ...
    cilindros.extension, ...
    cilindros.added, ...
    cilindros.UnmodRadius, ...
    cilindros.branch, ...
    cilindros.SurfCov, ...
    cilindros.mad, ...
    cilindros.podar, ...
    cilindros.BranchOrder, ...
    cilindros.PositionInBranch, ...
    'VariableNames', { ...
        'Radius', 'Length', ...
        'StartX', 'StartY', 'StartZ', ...
        'AxisX', 'AxisY', 'AxisZ', ...
        'Parent', 'Extension', 'Added', ...
        'UnmodRadius', 'Branch', 'SurfCov', 'MAD', 'Podar', ...
        'BranchOrder', 'PositionInBranch'});
    filtrado = ismember(Tcilindros.Branch, ramas_validas);
    T_filtrado = Tcilindros(filtrado, {'Branch', 'Length'});
    conteos = groupcounts(T_filtrado, 'Branch');
    %disp(conteos)

    % disp('==============================================');
    % for rama = 1 : numel(ramas_validas)
    %     disp(['Esta es la rama: ' int2str(ramas_validas(rama))]);
    %     disp(T_validas(rama, {'Length'}));
    %     disp(conteos(rama, :));
    %     filtrado2 = ismember(Tcilindros.Branch, ramas_validas(rama));
    %     T_filtrado2 = Tcilindros(filtrado2, {'Branch', 'Length', 'PositionInBranch'});
    %     disp(T_filtrado2);
    %     disp('==============================================');
    % end

    % esta funcion es para ver como funciona la seleccion de ramas
    % genPoblacionI(probabilidad_de_cortar, a, b, branch, cylinder, valores, pesos_cuts, matriz_dependencias, validos, pesos_validos)

end


function genPoblacionI(probabilidad_de_cortar, a, b, branch, cylinder, valores, pesos_cuts, matriz_dependencias, validos, pesos_validos)
   
    array_branch_cylinder = cylinder.branch;
    array_order = cylinder.BranchOrder;
    cilindros_candidato = find(array_order > 0);



   
    if isequal(cilindros_candidato, validos)
        disp('si son iguales');
    end
  
    array_branch_cylinder = array_branch_cylinder';
   


    disp('aqui comienza el for');
    for k=1 : 100
        disp(['Informacion sobre la solucion ' int2str(k)]);
        cuts = [];
        already_prune = [];
        already_prune_rama = [];
        ramas_dep_poda = [];
        count = 0;
        cantidad_ramas_podadas = 0;
        num_cortes = randsample(valores, 1, true, pesos_cuts);
        disp(['cantidad de cortes: ' int2str(num_cortes)]);

        while numel(cuts) < num_cortes && cantidad_ramas_podadas < num_cortes
         
            disponibles = ~ismember(cilindros_candidato, already_prune);
            cilindros_disponibles = cilindros_candidato(disponibles);
            pesos_disponibles = pesos_validos(disponibles);
            cilindro = randsample(cilindros_disponibles, 1, true, pesos_disponibles);
           
            if ~ismember(cilindro, already_prune)
                
                
                    idx_dep_poda = find(matriz_dependencias(cilindro, :) == 1);

                    for j = length(cuts):-1:1  % Recorremos al revés para eliminar sin problemas
                        if ismember(cuts(j), idx_dep_poda)
                            cuts(j) = [];  % Eliminar corte redundante
                            % No incrementamos la cantidad de cortes: se mantiene
                        end
                    end

                     % Agregamos el nuevo corte
                    cuts(end + 1) = cilindro;
                    ramas_dep_poda = array_branch_cylinder(idx_dep_poda);
                    ramas_dep_poda = unique(ramas_dep_poda);
                    already_prune_rama = cat(2, already_prune_rama, ramas_dep_poda);
                    cantidad_ramas_podadas = numel(unique(already_prune_rama));
                    % Actualizamos los ya podados
                    already_prune = cat(2, already_prune, idx_dep_poda);
                    already_prune = unique(already_prune);

              
               
            end
                
           
          

        end
        disp(['esta es la cantidad de cortes hechos: ' int2str(numel(cuts)) ' de un total de ' int2str(num_cortes) ' cilindros: ' int2str(cuts)]);
        disp(['este es el orden de los cilindros: ' int2str(array_order(cuts)')]);
        disp(['esta es la cantidad de ramas podadas: ' int2str(cantidad_ramas_podadas)]);
        disp('=========================================================================');
     end
    
        
    end
    

