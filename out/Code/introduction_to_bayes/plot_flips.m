function plot_flips(flips,visibility)
% function plot_flips(flips,visibility)
%
% generate a "flips" plot for the {0,1} vector of flips from 1:visibility
%


clf %clear the current figure
hdls = scatter(1:visibility,flips(1:visibility),'ko'); % draw a scatter plot
for i=1:length(hdls) % modify line widths of graphics objects
    set(hdls,'LineWidth',1)
end
xlim([0 length(flips)]) % set the display area of the plot
xlabel('Part Number')
ylabel('Outcome -- 0 = defective, 1 = not defective')