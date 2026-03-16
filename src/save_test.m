function save_test(elite, savename, prueba, first_predicado, mejor_predicado, tiempo, prioridad, max_prioridad, valor_objetivos_NI, metas)

    %extraer nombre de la instancia
    [~, name, ~] = fileparts(savename);

    % crear el directorio
    folderPath = fullfile('results', 'PruebasPoda', name, prueba);

    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end

    save(fullfile(folderPath, 'elite.mat'), "elite");

    % guardar informacion relevante en txt, mejor solución
    saveTxt(elite, folderPath, first_predicado, mejor_predicado, tiempo, prioridad, max_prioridad, valor_objetivos_NI, metas);

    disp(['se guardo con exito la ' prueba]);
    disp("-----------------------");
    disp('');

end


function saveTxt(best, path, first_predicado, mejor_predicado, tiempo, prioridad, max_prioridad, valor_objetivos_NI, metas)

    % crear archivo txt para escritura
    str = fullfile(path, 'resultados.txt');
    fid = fopen(str, 'w');

    fprintf(fid, '--- RESULTADOS ---\n');

    % Recorrer cada estructura del arreglo
    for i = 1:length(best)
        fprintf(fid, 'Ant Elite #%d\n', i);
        fprintf(fid, 'Valor objetivos: %s\n', mat2str(best(i).valor_objetivos));
        fprintf(fid, 'Valor verdad: %s\n', mat2str(best(i).valor_verdad));
        fprintf(fid, 'Predicado: %s\n', mat2str(best(i).predicado));
        fprintf(fid, 'Puntos de corte: %s\n', mat2str(best(i).puntos_corte));
        fprintf(fid, 'Cortes: %s\n', mat2str(best(i).cortes));
        fprintf(fid, '------------------------\n');
    end

    % Escribir predicado partida
    fprintf(fid, '\n--- PRIMER PREDICADO ---\n');
    fprintf(fid, '%s\n', mat2str(first_predicado));

    % Escribir mejor predicado
    fprintf(fid, '\n--- MEJOR PREDICADO ---\n');
    fprintf(fid, '%s\n', mat2str(mejor_predicado));

    % Escribir los objetivos prioritarios
    fprintf(fid, '\n--- OBJETIVOS CON PRIORIDAD ---\n');
    fprintf(fid, 'Prioridad: %s\n', mat2str(prioridad));
    fprintf(fid, 'Max Prioridad: %s\n', mat2str(max_prioridad));

    fprintf(fid, '\n--- OBJETIVOS NOGAL INICIAL ---\n');
    fprintf(fid, 'Objetivos NI: %s\n', mat2str(valor_objetivos_NI));

    fprintf(fid, '\n--- METAS ---\n');
    fprintf(fid, 'Primarias: %s\n', mat2str(metas(1).primarias));
    fprintf(fid, 'Vertical: %s\n', mat2str(metas(1).disVertical));
    fprintf(fid, 'Helicoidal: %s\n', mat2str(metas(1).helicoidal));
    fprintf(fid, 'LAI: %s\n', mat2str(metas(1).LAI));
    fprintf(fid, 'Tercio ramas: %s\n', mat2str(metas(1).finas));
    fprintf(fid, 'Apertura: %s\n', mat2str(metas(1).apertura));
    fprintf(fid, 'Volumen: %s\n', mat2str(metas(1).madera));
    fprintf(fid, 'Primarias podadas: %s\n', mat2str(metas(1).primarias_podadas));
   
    % Escribir tiempo total de ejecución
    fprintf(fid, '\n--- TIEMPO TOTAL ---\n');
    fprintf(fid, '%.1f segundos\n', tiempo);

    % Cerrar archivo
    fclose(fid);


    cylinder = best(1).cylinder;
    branch = best(1).branchData;
    treedata = best(1).treeData;

    %% Form cylinder data, branch data and tree data
    % Use less decimals
    Rad = round(10000*cylinder.radius)/10000; % radius (m)
    Len = round(10000*cylinder.length)/10000; % length (m)
    Sta = round(10000*cylinder.start)/10000; % starting point (m)
    Axe = round(10000*cylinder.axis)/10000; % axis (m)
    CPar = single(cylinder.parent); % parent cylinder
    CExt = single(cylinder.extension); % extension cylinder
    Added = single(cylinder.added); % is cylinder added to fil a gap
    Rad0 = round(10000*cylinder.UnmodRadius)/10000; % unmodified radius (m)
    B = single(cylinder.branch); % branch index of the cylinder
    BO = single(cylinder.BranchOrder); % branch order of the branch
    PIB = single(cylinder.PositionInBranch); % position of the cyl. in the branch
    Mad = single(round(10000*cylinder.mad)/10000); % mean abso. distance (m)
    SC = single(round(10000*cylinder.SurfCov)/10000); % surface coverage
    pd = cylinder.podar; %indica que rama ha sido podada
    CylData = [Rad Len Sta Axe CPar CExt B BO PIB Mad SC Added Rad0 pd];
    NamesC = ['radius (m)',"length (m)","start_point","axis_direction",...
      "parent","extension","branch","branch_order","position_in_branch",...
      "mad","SurfCov","added","UnmodRadius (m)", "Rama_podada"];
    
    BOrd = single(branch.order); % branch order
    BPar = single(branch.parent); % parent branch
    BDia = round(10000*branch.diameter)/10000; % diameter (m)
    BVol = round(10000*branch.volume)/10000; % volume (L)
    BAre = round(10000*branch.area)/10000; % area (m^2)
    BLen = round(1000*branch.length)/1000; % length (m)
    BAng = round(10*branch.angle)/10; % angle (deg)
    BHei = round(1000*branch.height)/1000; % height (m)
    BAzi = round(10*branch.azimuth)/10; % azimuth (deg)
    BZen = round(10*branch.zenith)/10; % zenith (deg)
    BranchData = [BOrd BPar BDia BVol BAre BLen BHei BAng BAzi BZen];
    NamesB = ["order","parent","diameter (m)","volume (L)","area (m^2)",...
      "length (m)","height (m)","angle (deg)","azimuth (deg)","zenith (deg)"];

    % Extract the field names of treedata
    Names = fieldnames(treedata);
    n = 1;
    while ~strcmp(Names{n},'location')
        n = n+1;
    end
    n = n-1;
    Names = Names(1:n);
    
    TreeData = zeros(n,1); 
    % TreeData contains TotalVolume, TrunkVolume, BranchVolume, etc
    % disp('esto es tree data');
    % disp(treedata);
    
    for i = 1:n
        TreeData(i) = treedata.(Names{i,:});
    end
    TreeData = change_precision(TreeData); % use less decimals
    NamesD = string(Names);

    %% Save the data as text-files
    str = fullfile(path, 'cylinderBest.txt');
    fid = fopen(str, 'wt');
    fprintf(fid, [repmat('%s\t', 1, size(NamesC,2)-1) '%s\n'], NamesC.');
    fprintf(fid, [repmat('%g\t', 1, size(CylData,2)-1) '%g\n'], CylData.');
    fclose(fid);
    
    str = fullfile(path, 'branchBest.txt');
    fid = fopen(str, 'wt');
    fprintf(fid, [repmat('%s\t', 1, size(NamesB,2)-1) '%s\n'], NamesB.');
    fprintf(fid, [repmat('%g\t', 1, size(BranchData,2)-1) '%g\n'], BranchData.');
    fclose(fid);
    
    str = fullfile(path, 'treedataBest.txt');
    fid = fopen(str, 'wt');
    NamesD(:,2) = TreeData;
    fprintf(fid,'%s\t %g\n',NamesD.');
    fclose(fid);

end
