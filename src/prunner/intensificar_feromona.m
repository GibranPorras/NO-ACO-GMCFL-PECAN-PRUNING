function feromona = intensificar_feromona(NSlocal, feromona)
    sol_NSlocal = numel(NSlocal);
    for ant = 1:sol_NSlocal
        %cant_cortes = NSlocal(ant).cortes;
        %delta_cortes = ((sol_NSlocal - ant + 1) / sol_NSlocal) * (1 - feromona_cortes(cant_cortes));
        %feromona_cortes(cant_cortes) = feromona_cortes(cant_cortes) + delta_cortes;
        vector_hormiga = NSlocal(ant).puntos_corte;
        %vector_hormiga = find(NSlocal(ant).ant == 1);
        for c=1:length(vector_hormiga)
            delta = ((sol_NSlocal - ant + 1) / sol_NSlocal) .* (1 - feromona(vector_hormiga(c), vector_hormiga));
            feromona(vector_hormiga(c), vector_hormiga) = feromona(vector_hormiga(c), vector_hormiga) + delta;
        end
    end
end