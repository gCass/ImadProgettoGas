clc
clear
close all
%Cic
load matPhiLinearDatiIdentificazioneTotali.mat
load vettoreMercolediTarget.mat

% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 12-May-2020 19:20:05
%
% This script assumes these variables are defined:
%
%   phi_linear - input data.
%   Y - target data.

%Devo fare la trasposta poichè prende come colonna il vettore
%degli input e ogni colonna è l'i-esimo vettore input 
%Lo stesso viene fatto per il target
%Con questa prima cosa scelgo se includere la colonna di uni o meno
%nell'identificazione

%Da qui inizia lo script da copiare
phi_data = phi_linear(:,2:8);
phi_data = normalize(phi_data);
x = phi_data';
t = normalize(Y)'; 

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Fitting Network
%Dopo l'incontro con garau ho messo cinque neuroni 
hiddenLayerSize = 6;
net = fitnet(hiddenLayerSize,trainFcn);

%Versione creata dal codice automatizzato che testa e valida dividendo in modo
%causale il set che gli passo.
%Setup Division of Data for Training, Validation, Testing
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio = 15/100;
% net.divideParam.testRatio = 15/100;

%Versione mia che provo a specificare io quali sono quelli da usare per
%testing e validazione ecc..

net.dividefcn = 'divideind';
%numeroSettimaneValidazione = 30;
%numeroSettimaneTraining = 104 - numeroSettimaneValidazione;
%indicePartenzaValidazione = 104 - numeroSettimaneValidazione;
[trainInd,valInd,testInd] = divideind(...
                            1:104,...
                            1:70,...
                            71:86,...%indicePartenzaValidazione
                            87:104);

net.divideParam.trainInd = trainInd;
net.divideParam.valInd = valInd;
net.divideParam.testInd = testInd;
%Fine parte del codice mio che sostituisce il dividerand automatico


% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);

% View the Network
%view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

%Fine script della rete 

%%Faccio io lo scatter delle ultime quindici settimane e degli ultimi dati
settimane_di_validazione = 30;
punto_di_partenza= length(Y) - settimane_di_validazione+1;
vettoreOriginale = normalize(Y(punto_di_partenza:length(Y)));
%Ricordarsi che bisogna fare la trasposta per i dati di stima
%Prendo le ultime righe della matrice e tutte e 8 le colonne, poi faccio
%la trasposta poich� le reti neurali funzionano in modo trasposto rispetto
%a come ragioniamo noi
matriceDatiStima = phi_data(punto_di_partenza:length(Y), :)';
vettoreStimato = net(matriceDatiStima);

performanceValidazione = perform(net,vettoreOriginale,vettoreStimato);


settimane = (1:settimane_di_validazione)';
ordinataOriginale = vettoreOriginale;
ordinataStimata = vettoreStimato';

figure(1)
%Non mi vanno le label xlabel('Numero della settimana')
%ylabel('Gas consumato nel mercoled� di quella settimana')
scatter (settimane,ordinataOriginale,'r','x')
hold on
grid on
scatter (settimane, ordinataStimata, 'b')
legend('Dati', 'Previsioni')

%Ora calcolo il vettore dei residui e lo plotto per ogni settimana
%(attenzione che il vettore stimato è una riga e non una colonna)
residui = ordinataOriginale - ordinataStimata;
residuiInValoreAssoluto = abs(residui);

%Calcolo anche SSR
residuiAlQuadrato = residui.^2;
SSR = sum(residuiAlQuadrato);
%Calcolo massimo e minimo residuo in valore assoluto
maxResiduoAbs = max(residuiInValoreAssoluto);
minResiduoAbs = min(residuiInValoreAssoluto);


figure(2)
xlabel('Numero della settimana')
ylabel('Gas consumato nel mercoled� di quella settimana')
scatter(settimane, residui, 'g','o');
grid on
hold on
scatter(settimane, residuiInValoreAssoluto, 'r', 'x');
legend('Valore residui', 'Valore residui in modulo');

