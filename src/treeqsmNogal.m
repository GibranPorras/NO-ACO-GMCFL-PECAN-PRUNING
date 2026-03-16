function QSM = treeqsmNogal(P,inputs, n_hormigas, hormigas, segment2, cover2, cylinder)
%Este es una adaptación del codigo para recalcular la información al podar
%   cilindros de la estructura original, y que no haya cambios al calcular
%   las nuevas estructuras de poda.

% Input parameters
PatchDiam1 = inputs.PatchDiam1;
PatchDiam2Min = inputs.PatchDiam2Min;
PatchDiam2Max = inputs.PatchDiam2Max;
BallRad1 = inputs.BallRad1; 
BallRad2 = inputs.BallRad2; 
nd = length(PatchDiam1);
ni = length(PatchDiam2Min);
na = length(PatchDiam2Max);

%% Make the point cloud into proper form
% only 3-dimensional data
if size(P,2) > 3
    P = P(:,1:3);
end
% Only double precision data
if ~isa(P,'double')
    P = double(P);
end

%% Initialize the output file
% QSM(1:n_hormigas) = struct('cylinder',{},'branch',{},'treedata',{},'rundata',{},...
%     'pmdistance',{},'triangulation',{}, 'units', {}, 'segment2', {},... 
%     'cover2', {});
empty_qsm = struct( ...
    'cylinder', [], ...
    'branch', [], ...
    'treedata', [], ...
    'rundata', struct('inputs', [], 'time', [], 'date', [], 'version', ''), ...
    'pmdistance', [], ...
    'triangulation', [], ...
    'units', [], ...
    'segment2', [], ...
    'cover2', []);
QSM = repmat(empty_qsm, 1, n_hormigas);
Inputs = inputs;
Inputs.PatchDiam1 = PatchDiam1(1);
Inputs.BallRad1 = BallRad1(1);
Time = zeros(11,1); % Save computation times for modelling steps
Date = zeros(2,6); % Starting and stopping dates of the computation
Date(1,:) = clock;
parfor ant = 1:n_hormigas

   hormiga = find(hormigas(ant, :) == 1);
   %aux_ramas_podar = [];
   
   %for d = 1: length(hormiga)
       %idx_dep_poda = find(matriz_dependencias(hormiga(d),:) == 1);
       %aux_ramas_podar = cat(2, aux_ramas_podar, idx_dep_poda);
   %end

   %aux_ramas_podar = cat(1, ramas_podar, aux_ramas_podar.');
   cylinder_local = cylinder;
   cylinder_local.podar(hormiga, :) = 1;

   %% Determine the branches
   branch = branches(cylinder_local);

   %% Compute (and display) model attributes
   T = segment2.segments{1};
   T = vertcat(T{:});
   T = vertcat(cover2.ball{T});
   trunk = P(T,:); % point cloud of the trunk

   % Compute attributes and distibutions from the cylinder model
   % and possibly some from a triangulation
   [treedata,triangulation, units] = tree_data(cylinder_local,branch,trunk,inputs);

   % Display the mean point-model distances and surface coverages
   pmdis = point_model_distance(P,cylinder_local);
          % for stem, branch, 1branc and 2branch cylinders
           %if inputs.disp >= 1
             
          %   D = [pmdis.TrunkMean pmdis.BranchMean ...
          %       pmdis.Branch1Mean pmdis.Branch2Mean];
          %   D = round(10000*D)/10;
          % 
          %   T = cylinder_local.branch == 1;
          %   B1 = cylinder_local.BranchOrder == 1;
          %   B2 = cylinder_local.BranchOrder == 2;
          %   SC = 100*cylinder_local.SurfCov;
          %   S = [mean(SC(T)) mean(SC(~T)) mean(SC(B1)) mean(SC(B2))];
          %   S = round(10*S)/10;
          % 
          %   %disp('  ----------')
          %   str = ['  PatchDiam1 = ',num2str(PatchDiam1(1)), ...
          %       ', PatchDiam2Max = ',num2str(PatchDiam2Max(1)), ...
          %       ', PatchDiam2Min = ',num2str(PatchDiam2Min(1))];
          %   %disp(str)
          %   str = ['  Distances and surface coverages for ',...
          %       'trunk, branch, 1branch, 2branch:'];
          %   %disp(str)
          %   str = ['  Average cylinder-point distance:  '...
          %       num2str(D(1)),'  ',num2str(D(2)),'  ',...
          %       num2str(D(3)),'  ',num2str(D(4)),' mm'];
          %   %disp(str)
          %   str = ['  Average surface coverage:  '...
          %       num2str(S(1)),'  ',num2str(S(2)),'  ',...
          %       num2str(S(3)),'  ',num2str(S(4)),' %'];
          %   %disp(str)
          %   %disp('  ----------')
           %end
          
    %% Reconstruct the output "QSM"

        QSM(ant).cylinder = cylinder_local;
        QSM(ant).branch = branch;
        QSM(ant).treedata = treedata;
        QSM(ant).segment2 = segment2;
        QSM(ant).cover2 = cover2;
        QSM(ant).rundata.inputs = Inputs;
        QSM(ant).rundata.time = single(Time);
        QSM(ant).rundata.date = single(Date);
        QSM(ant).rundata.version = '2.4.1';
        QSM(ant).units = units;
        QSM(ant).pmdistance = pmdis;

    %% Save the output into results-folder
        % matlab-format (.mat)
        % if inputs.savemat
        %   str = [inputs.name,'_t',num2str(inputs.tree),'_m',...
        %     num2str(inputs.model)];
        %   save(['results/QSM_',str],'QSM')
        % end
        % text-format (.txt)
        % if inputs.savetxt
        %   if nd > 1 || na > 1 || ni > 1
        %     str = [inputs.name,'_t',num2str(inputs.tree),'_m',...
        %       num2str(inputs.model)];
        %     if nd > 1
        %       str = [str,'_D',num2str(PatchDiam1(1))];
        %     end
        %     if na > 1
        %       str = [str,'_DA',num2str(PatchDiam2Max(1))];
        %     end
        %     if ni > 1
        %       str = [str,'_DI',num2str(PatchDiam2Min(1))];
        %     end
        %   elseif n_hormigas > 1
        %     str = [inputs.name,'_t',num2str(inputs.tree),'_m',...
        %       num2str(inputs.model), '_P', num2str(ant)];
        %   else
        %       str = [inputs.name,'_t',num2str(inputs.tree),'_m',...
        %       num2str(inputs.model), '_NogalInicial'];
        %   end
        %   save_model_text(qsm,str)
        % end
   
end

end