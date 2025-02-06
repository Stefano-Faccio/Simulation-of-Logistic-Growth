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
    p_der = plot(N_t, firstDerivativeN_t, '-', Color = "#FD151B", LineWidth=4);
    xlabel("N (population)");
    % relevant x values (about N)
    p_middle = xline(L/2, "m-", {"", "N*=L/2"},'LabelOrientation', 'horizontal',LineWidth=2.5);
    p_stop = xline(L, "k--", {"", "N=L"}, 'LabelOrientation', 'horizontal',LineWidth=1.5);
    p2start = xline(N_0, "-", {"", "","N_0"},'LabelOrientation', 'horizontal',LineWidth=2.5, Color="#00ff00", LabelVerticalAlignment="middle");
    %xline(0, "b--",'LabelOrientation', 'horizontal',LineWidth=1.5)
    maxN_t = max(N_t);
    p2stop= xline(maxN_t, "-", {"", "","N_{max}"}, 'LabelOrientation', 'horizontal',LineWidth=2.5, Color="#ffc61a", LabelHorizontalAlignment="left", LabelVerticalAlignment="middle");
    ylabel(" dN/dt(N_t') ");

    ax = gca;
    fontsize(ax, scale=2.0);
    leg = legend([p_der, p2start, p2stop, p_middle], "First Derivative", "N_0", "N_{max}", "N*=L/2", Location="northwest");
    title(leg, 'Growth rate curve');

    title("Logistic growth phase plot");
    subtitle_ = "N_0: " + N_0 + "; N_{max}: " + round(maxN_t,2)+"; c: " + C + "; k: " + k + "; L: " + L+"; L/2: " + L/2 + ";"; 
    subtitle(subtitle_);

    axis tight;
    xlim([0 xlimit])
    box on;
    hold off;

end