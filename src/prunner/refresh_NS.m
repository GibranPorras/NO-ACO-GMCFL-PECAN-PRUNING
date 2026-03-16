function [ants, antscut] = refresh_NS(matriz_dependencias, cant_sol, cant_cilindros, pesos_cuts, valores, cylinder, pesos_validos)

    [ants, antscut] = Generar_Poblacion_II(matriz_dependencias, cant_sol, cant_cilindros, pesos_cuts, valores, cylinder, pesos_validos);

end