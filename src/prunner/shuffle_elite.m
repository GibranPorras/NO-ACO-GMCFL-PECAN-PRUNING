function NSlocal = shuffle_elite(NSlocal)
    
    % numero de elementos de NSlocal
    n = numel(NSlocal);

    %indices aleatorios
    idx = randperm(n);

    % reordenar el struct
    NSlocal = NSlocal(idx);

end
