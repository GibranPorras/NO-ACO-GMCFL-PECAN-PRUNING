function metas  = metas_lider_central(cant_primary, cant_finas, valor_objetivos, NumberBranches)

    % estructura de las metas = [ideal, indiferente, nadir]
    metas = struct('apertura', {}, 'disVertical', {}, 'LAI', {}, 'primarias', {}, 'helicoidal', {}, 'madera', {}, 'finas', {}, 'primarias_podadas', {});

    metas(1).apertura = [0, floor((cant_primary * 25)) / 2, cant_primary * 25];

    metas(1).disVertical = [0, 20, max(35, valor_objetivos(2))];

    LAI_inicial = round(valor_objetivos(4));
    metas(1).LAI = [floor(LAI_inicial / 2), LAI_inicial - 2, LAI_inicial];
    metas(1).LAI = [2, 6, 8];

    primarias = valor_objetivos(1);

    if primarias < 6
        metas(1).primarias = [primarias, primarias - 1, primarias - 2];
    elseif primarias > 13
        metas(1).primarias = [primarias - 3, primarias - 4, primarias - 5];
    else
        metas(1).primarias = [max(min(10, valor_objetivos(1)), 6), 5, 3];
    end

    % es max por que es lo peor que podemos estar en este caso
    metas(1).helicoidal = [0, 70, 110];

    % es lo que queremos podar del arbol 30
    metas(1).madera = [30, 10, 0];

    % podemos mejorar cortando las ramas por encima de 65 cm
    metas(1).finas = [cant_finas - floor(cant_finas/3), cant_finas - floor(cant_finas/2), 0];

    % esto objetivo es para controlar la cantidad de ramas primarias

    % podadas ya que se espera un maximo de 3 y 4 ya es de pensar
    if primarias <= 6
        metas(1).primarias_podadas = [0, 4, 6];
    else
        metas(1).primarias_podadas = [1, 4, 6];
    end


    disp(['metas primarias: ' mat2str(metas(1).primarias)]);
    disp(['metas vertical: ' mat2str(metas(1).disVertical)]);
    disp(['metas helicoidal: ' mat2str(metas(1).helicoidal)]);
    disp(['metas LAI: ' mat2str(metas(1).LAI)]);
    disp(['metas finas: ' mat2str(metas(1).finas)]);
    disp(['metas apertura: ' mat2str(metas(1).apertura)]);
    disp(['metas volumen: ' mat2str(metas(1).madera)]);
    disp(['metas primarias podads: ' mat2str(metas(1).primarias_podadas)]);



end