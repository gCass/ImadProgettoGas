%% script per fare tutti i test




%% facciamo test f  con alpha = 0.05
    % confrontiamo a 2 modelli diversi 
    
    
    SSR1 = 1; 
    SSR2 = 2;
    
    %{
        la formula del test F  f= (n-k)*(SSR1-SSR2)/SSR2
        k = grado del modello di grado più alto 
        ricordiamoci che f è un indice della riduzione % del SSR che ho
        passando da un modello di grado  k-1 a un modello di  grado  k 
    %}
    n = 720
    k = 2
    
    f=(n-k)*((SSR1-SSR2)/SSR2);
    
alpha = 0.005 
f_alpha = finv(1-alpha,1,n-k)

if(f<f_alpha)
    gr =  k-1;
    display("scelgo il modello di grado "+  gr + " respingo il modello di grado "+  k)
    
    else(f>f_alpha)
        gr =  k-1
        display("scelgo il modello di grado " + gr + " respingo il modello di grado " + k)
end 

 %% test FPE 
 
 
   


    
    
    
    
    