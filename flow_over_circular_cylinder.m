function vortex_strength_gui()
    x = linspace(-2, 2, 500); 
    y = linspace(-2, 2, 500); 
    [X, Y] = meshgrid(x, y);
    R = 1; 
    U_inf = 1; 
    r = sqrt(X.^2 + Y.^2); 
    theta = atan2(Y, X); 
    fig = figure('Position', [100, 100, 800, 600], 'Name', 'Vortex Strength GUI');
    slider = uicontrol('Style', 'slider', ...
                       'Min', -20, 'Max', 20, 'Value', 0, ...
                       'Position', [150, 30, 500, 40], ...
                       'Callback', @update_plot);
    uicontrol('Style', 'text', ...
              'Position', [50, 30, 90, 30], ...
              'String', 'Gamma (Vortex Strength)', ...
              'HorizontalAlignment', 'right');
    gamma_display = uicontrol('Style', 'text', ...
                               'Position', [670, 10, 60, 50], ...
                               'String', '0', ...
                               'HorizontalAlignment', 'left','FontSize',15);

    ax = axes('Parent', fig, 'Position', [0.1, 0.2, 0.8, 0.7]);
    axis(ax,"equal")
    title(ax, 'Flow Over a Cylinder with Varying Vortex Strength');
    xlabel(ax, 'X-axis');
    ylabel(ax, 'Y-axis');
    axis(ax, 'equal');
    xlim(ax, [-2, 2]);
    ylim(ax, [-2, 2]);
    grid(ax, 'on');
    
    function update_plot(~, ~)
    Gamma = slider.Value;
    set(gamma_display, 'String', num2str(Gamma, '%.2f'));
    Psi = U_inf * (r - R^2 ./ r) .* sin(theta) + Gamma / (2 * pi) * log(r);
    Psi(r < R) = NaN;
    cla(ax);
    contour(ax, X, Y, Psi, 50, 'LineWidth', 1.2);
    hold(ax, 'on');
    theta_cylinder = linspace(0, 2 * pi, 200);
    xc = R * cos(theta_cylinder);
    yc = R * sin(theta_cylinder);
    fill(ax, xc, yc, 'r', 'FaceAlpha', 0.5);
    axis(ax, 'equal');
    xlim(ax, [-2, 2]);
    ylim(ax, [-2, 2]);

    warning_message = findall(fig, 'Type', 'uicontrol', 'String', 'Stagnation points do not exist');
    if ~isempty(warning_message)
        delete(warning_message);
    end
    if abs(Gamma) <= 4 * pi * U_inf
        stagnation_points_x1 = -R * cos(asin(Gamma / (4 * pi * U_inf)));
        stagnation_points_y1 = -R * sin(asin(Gamma / (4 * pi * U_inf)));
        stagnation_points_x2 = R * cos(asin(-Gamma / (4 * pi * U_inf)));
        stagnation_points_y2 = R * sin(asin(-Gamma / (4 * pi * U_inf)));
        plot(ax, stagnation_points_x1, stagnation_points_y1, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
        plot(ax, stagnation_points_x2, stagnation_points_y2, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    else
        uicontrol('Style', 'text', ...
                  'Position', [300, 80, 200, 30], ...
                  'String', 'Stagnation points do not exist', ...
                  'BackgroundColor', 'yellow', ...
                  'HorizontalAlignment', 'center');
    end

    legend(ax, 'Streamlines', 'Cylinder', 'Stagnation Points');
end
    update_plot();
end

