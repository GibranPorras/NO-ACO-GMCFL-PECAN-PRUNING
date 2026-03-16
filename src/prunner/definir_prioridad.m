function prioridad = definir_prioridad(valores_verdad_NI)
    objetivos = numel(valores_verdad_NI);
    prioridad = zeros(1, objetivos);
    obj_prioritarios = [1, 4, 5, 7, 8];
    prioridad(obj_prioritarios) = 1;
end

% quiero definir las prioridades de los que importan y de los que no
% importan tanto... esto sera estatico y tiene que ver con lo que se puede
% de cierta forma controlar y lo que no 

%% se pude controlar:
% Primarias
% LAI
% Ramas finas
% Madera Podada

%% Lo que no se puede controlar
% Distribucion Helicoidal
% Distribucion Vertical
% Apertura del arbol

%% si esto ya no funciona
% agregar un 8vo objetivo que controla las ramas primarias que se pueden 
% podar, lo cual el limite es 3.... 1 es lo ideal, en 3 ya se duda y 4 no
% queremos tanto.