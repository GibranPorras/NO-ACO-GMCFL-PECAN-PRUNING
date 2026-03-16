function feromona = evaporar_feromona(feromona, p)
    feromona = (1 - p) .* feromona; % evaporacion de feromona en cada elemento
    %feromona_cortes = (feromona_cortes - p) .* feromona_cortes; % evaporacion de feromona_cortes en cada elemento.
end