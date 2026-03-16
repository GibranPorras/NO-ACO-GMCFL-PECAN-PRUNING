function txt = displayDatatipInfo(~, event)
            % Obtener la información del Data Tip
                pos = event.Position;
                txt = {['X: ', num2str(pos(1))], ['Y: ', num2str(pos(2))], ['Z: ', num2str(pos(3))]};

             % Change color of selected point
                selectedPoint = event.Target;
                selectedPoint.MarkerFaceColor = 'red';

            % Imprimir la información del Data Tip por consola
                disp('Información del Data Tip:');
                disp(txt);
            
        end