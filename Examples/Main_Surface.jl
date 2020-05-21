include("src/Main_Include.jl")
include("Cell_Design_Inputs.jl")
include("Cost_Inputs.jl")
include("Cell_Design_Inputs.jl")
cell_design_op = cylindrical_cell_designer(cell_general)
include("src/Units.jl")

using PyPlot
using ForwardDiff

using3D()

cost.general_costs.no_units_mfg = converter([20.0, mult.units_mfg[2], mult.units_mfg[3]])
cost.cell_costs.cathode.AM[1]
n = 35

thic = range(150, stop=200, length=n)
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
    cell_general.cathode.th   = converter([ thic[i], mult.pos_th[2], mult.pos_th[3]])


    dollars_kWh, MWh_per_year = cost_calc(cell_general, cost, system="Cell", cost_verbosity=0)
    z[j, i]                   = dollars_kWh


    cell_general.cathode.por  = poro[j]
    cell_general.cathode.th   = converter([ (150.0 + (200.0 - 150.0) * thic[1]), mult.pos_th[2], mult.pos_th[3]])
    new_cost_x(thickness)     = cost_calc(cell_general, cost, system="Cell", cost_verbosity=0)[1]
    new_cost_grad_x(u)        = ForwardDiff.gradient(new_cost_x, u)

    cell_general.cathode.th   = converter([ thic[i], mult.pos_th[2], mult.pos_th[3]])
    cell_general.cathode.por  = (0.3 + (0.4 - 0.3) * poro[1])
    new_cost_y(porosity)      = cost_calc(cell_general, cost, system="Cell", cost_verbosity=0)[1]
    new_cost_grad_y(v)        = ForwardDiff.gradient(new_cost_y, v)

    z_grad_x[j, i]            = new_cost_grad_x([normalized_thic[i]])[1]
    z_grad_y[j, i]            = new_cost_grad_y([normalized_poro[j]])[1]


end


clf()
fig = figure("pyplot_surfaceplot",figsize=(8,8))
plot_surface(xgrid, ygrid, z, rstride=3,edgecolors="r", cstride=3, cmap=ColorMap("gray"), alpha=1, linewidth=0.25)
xlabel("Cathode Thickness (um)")
ylabel("Porosity")
zlabel("dollars/kWh")
title("Surface Plot")
figure(2)
