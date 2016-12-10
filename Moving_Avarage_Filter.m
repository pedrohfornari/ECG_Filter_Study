function filteredSignal = Moving_Avarage_Filter(input, terms)
%%
%Essa funcao eh um filtro de media movel,
%Depende do sinal de entrada (input)
%Depende do numero de termos do filtro (terms)
%This function implements a move avarage filter
%input -> signal to be processed
%terms -> number of samples that are used

%%Creates the filter coeficients
filter_coef = ones(terms, 1) * (1/terms);

filteredSignal = filter(filter_coef, 1, input);

end
