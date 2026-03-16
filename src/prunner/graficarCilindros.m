% graficar modelo qsm cilindros

% Si tienes un archivo .mat
lasReader = lasFileReader("instanciasmatlab/Manual/tree1-line1.las");
ptCloud = readPointCloud(lasReader);
P = ptCloud.Location;
P = P-mean(P);
inputs = define_input(P, 1, 1, 1);
Nogal_inicial = treeqsm(P, inputs, 1, []);
fig = figure;
ax = axes('Parent', fig);  % crea un objeto axes dentro de la figura
plot_cylinder_model(Nogal_inicial(1).cylinder, 'order', ax, 10);
