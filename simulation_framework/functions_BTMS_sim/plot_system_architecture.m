function plot_system_architecture(config)

[sys_ID, mod_ID, SysSpec, ~, SysPara, ~, ~, SysInfo, BTMSConfig] = expand_config(config);

fig_name = sprintf('Configuration sys_ID: %i, mod_ID: %i', sys_ID, mod_ID);

%% Create figure
figure1 = figure('Name',fig_name);
set(figure1,'units','normalized','Position',[0.1,0.1,0.8,0.8]);

%% Create subplot for dimensions
subplot1 = subplot(2,1,1,'Parent',figure1);

hold on

% Plot max allowed dimensions

x_dim_max = SysSpec.dim_x_sys_max;
y_dim_max = SysSpec.dim_y_sys_max;
z_dim_max = SysSpec.dim_z_sys_max;
p_1 = [0 0 0];
p_2 = [0 y_dim_max 0];
p_3 = [0 0 z_dim_max];
p_4 = [0 y_dim_max z_dim_max];
p_5 = [x_dim_max 0 0];
p_6 = [x_dim_max y_dim_max 0];
p_7 = [x_dim_max 0 z_dim_max];
p_8 = [x_dim_max y_dim_max z_dim_max];

x = [p_1(1), p_2(1), p_3(1), p_4(1), p_5(1), p_6(1), p_7(1), p_8(1)];
y = [p_1(2), p_2(2), p_3(2), p_4(2), p_5(2), p_6(2), p_7(2), p_8(2)];
z = [p_1(3), p_2(3), p_3(3), p_4(3), p_5(3), p_6(3), p_7(3), p_8(3)];

plot3([x(1) x(2) x(4) x(3) x(1)],[y(1) y(2) y(4) y(3) y(1)],[z(1) z(2) z(4) z(3) z(1)],'Color','k');
plot3([x(2) x(4) x(8) x(6) x(2)],[y(2) y(4) y(8) y(6) y(2)],[z(2) z(4) z(8) z(6) z(2)],'Color','k');
plot3([x(1) x(2) x(6) x(5) x(1)],[y(1) y(2) y(6) y(5) y(1)],[z(1) z(2) z(6) z(5) z(1)],'Color','k');
plot3([x(1) x(2) x(4) x(3) x(1)]+x_dim_max,[y(1) y(2) y(4) y(3) y(1)],[z(1) z(2) z(4) z(3) z(1)],'Color','k');
plot3([x(2) x(4) x(8) x(6) x(2)],[y(2) y(4) y(8) y(6) y(2)]-y_dim_max,[z(2) z(4) z(8) z(6) z(2)],'Color','k');
plot3([x(1) x(2) x(6) x(5) x(1)],[y(1) y(2) y(6) y(5) y(1)],[z(1) z(2) z(6) z(5) z(1)]+z_dim_max,'Color','k');

% Plot actual dimensions

% Plot max allowed dimensions

x_dim_act = SysInfo.dim_x_sys_BTMS;
y_dim_act = SysInfo.dim_y_sys_BTMS;
z_dim_act = SysInfo.dim_z_sys_BTMS;
p_1 = [0 0 0];
p_2 = [0 y_dim_act 0];
p_3 = [0 0 z_dim_act];
p_4 = [0 y_dim_act z_dim_act];
p_5 = [x_dim_act 0 0];
p_6 = [x_dim_act y_dim_act 0];
p_7 = [x_dim_act 0 z_dim_act];
p_8 = [x_dim_act y_dim_act z_dim_act];

x = [p_1(1), p_2(1), p_3(1), p_4(1), p_5(1), p_6(1), p_7(1), p_8(1)];
y = [p_1(2), p_2(2), p_3(2), p_4(2), p_5(2), p_6(2), p_7(2), p_8(2)];
z = [p_1(3), p_2(3), p_3(3), p_4(3), p_5(3), p_6(3), p_7(3), p_8(3)];

plot3([x(1) x(2) x(4) x(3) x(1)],[y(1) y(2) y(4) y(3) y(1)],[z(1) z(2) z(4) z(3) z(1)],'Color','b');
plot3([x(2) x(4) x(8) x(6) x(2)],[y(2) y(4) y(8) y(6) y(2)],[z(2) z(4) z(8) z(6) z(2)],'Color','b');
plot3([x(1) x(2) x(6) x(5) x(1)],[y(1) y(2) y(6) y(5) y(1)],[z(1) z(2) z(6) z(5) z(1)],'Color','b');
plot3([x(1) x(2) x(4) x(3) x(1)]+x_dim_act,[y(1) y(2) y(4) y(3) y(1)],[z(1) z(2) z(4) z(3) z(1)],'Color','b');
plot3([x(2) x(4) x(8) x(6) x(2)],[y(2) y(4) y(8) y(6) y(2)]-y_dim_act,[z(2) z(4) z(8) z(6) z(2)],'Color','b');
plot3([x(1) x(2) x(6) x(5) x(1)],[y(1) y(2) y(6) y(5) y(1)],[z(1) z(2) z(6) z(5) z(1)]+z_dim_act,'Color','b');

hold off

view(subplot1,[-37.5 30]);
grid(subplot1,'on');
zlabel('Length in z-dir in m');
ylabel('Length in y-dir in m');
xlabel('Length in x-dir in m');
title('Dimensions of battery system. (black = allowed size, blue = actual size');


%% Create subplot for inner structure
subplot2 = subplot(2,1,2,'Parent',figure1);

e  = SysPara.e_sys;
pe = SysPara.pe_sys;
s  = SysPara.s_sys;
num_cells = e * pe * s;

hold on

% Plot of cells
[Lay1,Row1,Col1] = get_cell_IDs(e, pe, s, 1:num_cells);
plot3(Col1,Row1,Lay1,'.k');

channel_orientation = BTMSConfig.channel_orientation;
channel_start_layer = BTMSConfig.info.channel_start_layers;

for ii = 1:length(channel_orientation)
    
    layer = channel_start_layer(ii);
    switch channel_orientation(ii)
       case 'x'
           p1 = [layer 0 0];
           p2 = [layer pe 0];
           p3 = [layer pe e];
           p4 = [layer 0 e];

       case 'y'
           p1 = [0 layer 0];
           p2 = [0 layer e];
           p3 = [s layer e];
           p4 = [s layer 0];


       case 'z'
           p1 = [0 0 layer];
           p2 = [0 pe layer];
           p3 = [s pe layer];
           p4 = [s 0 layer];

   end
   
   x = [p1(1), p2(1), p3(1), p4(1)] + 0.5;
   y = [p1(2), p2(2), p3(2), p4(2)] + 0.5;
   z = [p1(3), p2(3), p3(3), p4(3)] + 0.5;
   h = fill3(x, y, z, [0 82 147]/256);
   set(h,'facealpha',.2)
    
end

hold off

view(subplot2,[-37.5 30]);
grid(subplot2,'on');
zlabel('Cell count in z-dir');
ylabel('Cell count in y-dir');
xlabel('Cell count in x-dir');
title('3D visualization of battery system');

end

function [Lay,Row,Col] = get_cell_IDs(nLays, nRows, nCols, Id_vec)

% Based on the function plot_system_geometry from 'https://github.com/TUMFTM/sim_battery_system'

% Get the cell IDs for a battery system with several layers
% 
%  nLays: Number of layers
%  nRows: Number of parallel cells
%  nCols: Number of serial cells
%  Id: Vektor mit linearen Indizes der gewünschten Zellen

if any(Id_vec) > nLays*nRows*nCols || any(Id_vec) < 1
    error('Index exceeds matrix dimensions.')
else
    Col = ceil(Id_vec/(nLays*nRows));
    Lay = ceil((Id_vec-(Col-1)*(nLays*nRows))/nRows);
    Row = Id_vec-(Col-1)*(nLays*nRows)-(Lay-1)*nRows;
end

end