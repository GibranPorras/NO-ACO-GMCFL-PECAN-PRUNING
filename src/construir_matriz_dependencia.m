function matriz_dependencia = construir_matriz_dependencia(cilindros)
cant_cilindros = length(cilindros.BranchOrder);
matriz_dependencia = zeros(cant_cilindros);
max_order = max(cilindros.BranchOrder);
for c = 1: length(cilindros.BranchOrder)
    order = cilindros.BranchOrder(c) + 1;
    dependientes_cilindro = [];
    cilindros_siguientes = get_cilindros_siguientes(c, cilindros);
    ram_dep = cilindros_siguientes;
    version = 0;
    for o=order:max_order
        ram_dep = dependencia_por_rama(o, ram_dep, cilindros, version);
        if isempty(ram_dep)
           break;
        else
           dependientes_cilindro = cat(1, dependientes_cilindro, ram_dep);
           version = 1;
        end
     end
 
     for i = 1 : length(dependientes_cilindro)
         rama_completa = get_cilindros(dependientes_cilindro(i), cilindros);
         cilindros_siguientes = cat(1, cilindros_siguientes, rama_completa);
     end
     matriz_dependencia(c, cilindros_siguientes) = 1;
end
end


function dependientes_cilindro = dependecia_por_cilindro(order, cilindro, cilindros)
parents = find(cilindros.parent == cilindro);
dependientes_cilindro = parents(cilindros.BranchOrder(parents) == order);
% para concatenar: cat(1, array 1, array2) conatenar la misma columna 
end

function dependientes_rama = dependencia_por_rama(order, rama, cilindros, version)
dep = [];
if version == 1
   for r = 1:length(rama)
       cil = get_cilindros(rama(r), cilindros);
       for c = 1: length(cil)
           depC = dependecia_por_cilindro(order, cil(c), cilindros);
           if ~isempty(depC)
              dep = cat(1, dep, depC);
           end
       end
  end
else
    for r = 1: length(rama)
        depC = dependecia_por_cilindro(order, rama(r), cilindros);
        if ~isempty(depC)
           dep = cat(1, dep, depC);
        end
    end
end


dependientes_rama = dep;
end

function cilindros_rama = get_cilindros(cilindro, cilindros)
id_rama = cilindros.branch(cilindro);
cilindros_rama = find(cilindros.branch == id_rama);
end

function cilindros_siguientes = get_cilindros_siguientes(cilindro, cilindros)
ramas = length(cilindros.BranchOrder);
cilindros_siguientes = [];
indice = 1;
for r = cilindro: ramas
      if cilindros.extension(r) == 0
          cilindros_siguientes(indice, :) = r;
          break;
      else
          cilindros_siguientes(indice, :) = r;
          indice = indice + 1;
      end
end
end
