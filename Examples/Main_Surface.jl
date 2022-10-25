using BatteryCost

cell_general = cell()
cell_design_op = BatteryCost.cylindrical_cell_designer(cell_general)
cost = BatteryCost.cost_default()
cell_general, cost = BatteryCost.convert_all(cell_general, cost, BatteryCost.mult)


using PyPlot
using ForwardDiff

using3D()

cost.general_costs.no_units_mfg = BatteryCost.converter(20.0, BatteryCost.mult.units_mfg)
cost.cell_costs.cathode.AM[1]
n = 35

thic = range(125, stop=170, length=n)
poro = range(0.3, stop=0.4, length=n)

normalized_thic = range(0, 1, length = n)
normalized_poro = range(0, 1, length = n)


xgrid = repeat(thic', n, 1)
ygrid = repeat(poro, 1, n)

z = zeros(n,n)

z_grad_x = zeros(n,n)
z_grad_y = zeros(n,n)

legend_data = []


for i in 1:n, j in 1:n

    cell_general.cathode.por  = poro[j]
    cell_general.cathode.th   = BatteryCost.converter(thic[i], BatteryCost.mult.pos_th)


    dollars_kWh, MWh_per_year = cost_calc(cell_general, cost, system="Cell", cost_verbosity=0)
    z[j, i]                   = dollars_kWh

end


clf()
fig = figure("pyplot_surfaceplot", figsize=(8,8))
plot_surface(xgrid, ygrid, z, rstride=1, edgecolors="b", cstride=1, cmap=ColorMap("gray"), alpha=0.5, linewidth=0.1)
xlabel("Cathode Thickness (um)")
ylabel("Porosity")
zlabel("dollars/kWh")
title("Surface Plot")
figure(2)
