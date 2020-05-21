include("../src/PBCM.jl")

cell_general = cell_default()
cell_design_op = cylindrical_cell_designer(cell_general)
cost = cost_default()

include("../unit_conversion_file.jl")


using PyPlot

    ###################################################### USD/kWh vs MWH/year  #####################################################################

cost.cell_costs.cathode.AM[1] = 17.0
cell_general.cathode.por      = 0.25
cell_general.cathode.th       = converter([150.0, mult.pos_th[2], mult.pos_th[3]])


param_x = []
param_y = []

for i in range(10, 200, length=100000)
    # cost.material.pos_AM[1] = i
    cost.general_costs.no_units_mfg = converter([i, mult.units_mfg[2], mult.units_mfg[3]])
    dollars_per_kWh, mfg_capacity = cost_calc(cell_general, cost, system="Cell", cost_verbosity=0)
    append!(param_y, dollars_per_kWh)
    append!(param_x, mfg_capacity)
end

# print(param_y)


cla()
plot(param_x, param_y)
xlabel(String("MWh/year"))
ylabel("Dollars per kWh")
title("Cost vs. MFG Capacity")
figure(2)
