include("../src/PBCM.jl")

cell_general = cell_default()
cell_design_op = cylindrical_cell_designer(cell_general)
cost = cost_default()

include("../unit_conversion_file.jl")



    ###################################################### USD/kWh vs Thickness Cathode  ######################################################

param_x = []
param_y = []

cost.cell_costs.cathode.AM[1]   = 17.0
cost.general_costs.no_units_mfg = converter([20.0, mult.units_mfg[2], mult.units_mfg[3]])
cell_general.cathode.por        = 0.25

for i in range(110, 200, length=100000)
    # cost.material.pos_AM[1] = i
    cell_general.cathode.th = converter([i, mult.pos_th[2], mult.pos_th[3]])
    dollars_per_kWh, mfg_capacity = cost_calc(cell_general, cost, system="Cell", cost_verbosity=0)
    append!(param_y, dollars_per_kWh)
    append!(param_x, i)
end

# print(param_y)

clf()
plot(param_x, param_y)
xlabel(String("Cathode thickness (microns)"))
ylabel("Dollars per kWh")
title("Cost vs. Cathode Thickness")
figure(2)
