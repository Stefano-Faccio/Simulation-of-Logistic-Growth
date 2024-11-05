function plotAll(data, title, color)
    %Sord data
    dataSorted = sort(data);
    %Plot histogram
    figure('Name',strcat('Histogram - ', title));
    h = histogram(data);
    xlabel("" +title + " stream data point(x)");
    ylabel("Frequency(x)");
    h.FaceColor = color;
    %Plot hopefully a straight line (bisector of the first and third quadrant)
    figure('Name',strcat('2D Plot - ', title));
    p = plot(dataSorted);
    p.Color = color;
    xlabel("" +title + " stream data point(x)")
    ylabel("" +title + " stream data point (implicit x)")
end
