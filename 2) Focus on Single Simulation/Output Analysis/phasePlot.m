% This function takes as input the following arguments: 
% 1) the continuous growth rate
% 2) the crowding coefficient
% 3) the initial population
% 4) time (unit steps)
% 5) upper limit on the x axis, depending on carrying capacity (L + 5)

% This function returns as output the following arguments:
% 1) the phase plot dN/dt (or N_t', the first derivative of N_t) versus N,
% with additional information

function phasePlot(k,C,N_0,t,xlimit)

    L = k/C;
    coeff =(L/N_0)-1;
    N_t =  (L * N_0) ./ ( (L - N_0) .* exp((-k) .* t) + N_0 );
    firstDerivativeN_t = (L * coeff * k .* exp((-k) .* t)) ./ ((1 + coeff.* exp((-k) .* t)).^2);
    
    figure;
    hold on;
    plot(N_t, firstDerivativeN_t, '-', Color ='#5A5A5A', LineWidth=1.25);
    xlabel("N (population)");
    % relevant x values (about N)
    xline(L/2, "m-", "L/2",'LabelOrientation', 'horizontal',LineWidth=1.5)
    xline(L, "r--", "L", 'LabelOrientation', 'horizontal',LineWidth=1.5)
    xline(N_0, "g-", "N_0",'LabelOrientation', 'horizontal',LineWidth=1.5)
    xline(0, "b--",'LabelOrientation', 'horizontal',LineWidth=1.5)
    maxN_t = max(N_t);
    xline(maxN_t, "-", "N_{max}", 'LabelOrientation', 'aligned',LineWidth=1.5, Color="#EDB120")
    ylabel(" dN/dt (N_t') ");
    %title("Logistic growth phase plot");    
    %subtitle_ = "N_0: " + N_0 + "; N_{max}: " + round(maxN_t,2)+"; c: " + C + "; k: " + k + "; L: " + L+"; L/2: " + L/2 + ";"; 
    %subtitle(subtitle_);
    %disp("Logistic growth phase plot")
    %disp(subtitle_)
    axis tight;
    xlim([0 xlimit])
    box on;
    hold off;

end