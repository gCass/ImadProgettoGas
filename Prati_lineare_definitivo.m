clc 
clear
close all 

load outputIdentificazione.mat
load deviazione.mat
load media.mat
load inputIdentificazione.mat

load outputValidazione.mat
load inputValidazione.mat
%%
[row_identificazione, column_identificazione] = size(inputIdentificazione);
[row_validazione, column_validazione] = size(outputValidazione);

numeroSettimaneDellaPhi = row_identificazione;

%% blocco da 1
gradoDesiderato = 2;

numeroVariabili = 7; % ovvero 7 variabili
phi_linear = [ones(row_identificazione, 1), inputIdentificazione];

k = 1;
for i= 1 : gradoDesiderato % la i serve a fare le potenze
    for j= 1 : numeroVariabili % mi aiuta a tener conto delle posizioni
        vect = phi_linear(:, j+1); % il +1 esclude il primo vettore di soli uni
        phi_blocchiDaUno_2grado(:, k) = vect.^i;
        k = k + 1;
    end
end

%% blocco da 2 pari

phi_bloccoDaDuePrimo = ones(numeroSettimaneDellaPhi,1); % giusto per ricordarmi che sono tot settimane
vect = 0;
k = 1;
for i= 1 : numeroVariabili
    for j= i+1 : numeroVariabili
        for z= 2: gradoDesiderato 
            if(mod(z, 2) == 0)
                vect = (phi_linear(:, i+1).^(z/2)).* phi_linear(:, j+1).^(z/2); 
                phi_bloccoDaDuePrimo_2grado(:, k) = vect;
                k = k+1;
            end
        end
    end
end

%% blocco da 1 
gradoDesiderato = 3;

numeroVariabili = 7; % ovvero 7 variabili

k = 1;
for i= 1 : gradoDesiderato % la i serve a fare le potenze
    for j= 1 : numeroVariabili % mi aiuta a tener conto delle posizioni
        vect = phi_linear(:, j+1); % il +1 esclude il primo vettore di soli uni
        phi_blocchiDaUno_3grado(:, k) = vect.^i;
        k = k + 1;
    end
end

%% blocco da 2 pari

phi_bloccoDaDuePrimo = ones(numeroSettimaneDellaPhi,1); % giusto per ricordarmi che sono tot settimane
vect = 0;
k = 1;
for i= 1 : numeroVariabili
    for j= i+1 : numeroVariabili
        for z= 2: gradoDesiderato 
            if(mod(z, 2) == 0)
                vect = (phi_linear(:, i+1).^(z/2)).* phi_linear(:, j+1).^(z/2); 
                phi_bloccoDaDuePrimo_3grado(:, k) = vect;
                k = k+1;
            end
        end
    end
end

%% blocco da 2 dispari

phi_bloccoDaDueSecondo = ones(numeroSettimaneDellaPhi, 1);
c = 1;
for a= 1 : numeroVariabili
    for b= 1 : numeroVariabili
        if(a ~= b)
           for k= 1 : gradoDesiderato % da controllare con un if
                for j= k+1 : gradoDesiderato
                    %disp(j)
                    if(k+j <= gradoDesiderato)
                        vect = (phi_linear(:, a).^j).* phi_linear(:, b).^ k;
                        phi_bloccoDaDueSecondo_3grado(:, c) = vect;
                        c = c + 1;
                    end
                end
           end
        end
    end
end

phi_bloccoDaDue_3grado = [phi_bloccoDaDuePrimo_3grado, phi_bloccoDaDueSecondo_3grado];

%% blocco da 3

phi_bloccoDaTrePrimo = ones(numeroSettimaneDellaPhi,1); % giusto per ricordarmi che sono tot settimane
vect = 0;
k = 1;
for a= 1 : numeroVariabili
    for b= a+1 : numeroVariabili
        for c= b+1 : numeroVariabili
           
            for z= 3: gradoDesiderato 
                if(mod(z, 3) == 0)
                    vect = (phi_linear(:, a+1).^(z/3)).* (phi_linear(:, b+1).^(z/3)).* phi_linear(:, c+1).^(z/3); 
                    phi_bloccoDaTrePrimo_3grado(:, k) = vect;
                    k = k+1;
                end
            end
            
        end
    end
end

%%

X_vect_val = 1:row_validazione;

phi_validazione_ar = inputValidazione;
phi_validazione = [ones(row_validazione), inputValidazione];

phi_linear_ar = inputIdentificazione;
phi_linear_1 = [ones(row_identificazione, 1), inputIdentificazione];
phi_linear_2 = [ones(row_identificazione, 1), phi_blocchiDaUno_2grado, phi_bloccoDaDuePrimo_2grado];
phi_linear_3 = [ones(row_identificazione, 1), phi_blocchiDaUno_3grado, phi_bloccoDaDue_3grado, phi_bloccoDaTrePrimo_3grado];


[theta_1, std_1] = lscov(phi_linear_1, outputIdentificazione);
[theta_2, std_2] = lscov(phi_linear_2, outputIdentificazione);
[theta_3, std_3] = lscov(phi_linear_3, outputIdentificazione);


ordinataStimata_1 = phi_validazione_ar * theta_1;
ordinataStimata_2 = phi_validazione * theta_2;
ordinataStimata_3 = phi_validazione * theta_3;

figure(1)
plot(X_vect_val, outputValidazione, 'b', 'o');
xlabel('Numero settimana')
ylabel('Valore gas')
hold on
grid on
plot(X_vect_val, outputValidazione, 'r', 'x');
legend('Dati', 'Previsioni')









