include("../src/PBCM.jl")

cell_general = cell_default()
cell_design_op = cylindrical_cell_designer(cell_general)
cost = cost_default()

using PyPlot

# cost.general_costs.no_units_mfg = converter([80.0, mult.units_mfg[2], mult.units_mfg[3]])

# cost_calc(cell_general, cost; system="Cell", cost_verbosity = 1)



cost_per_cell_positive_active_material    = 0.4103396224997103

cost_per_cell_negative_active_material    = 0.17423714016776168

cost_per_cell_positive_conductive         = 0.004226191869903126
cost_per_cell_negative_conductive         = 0.002674542254690152
cost_per_cell_positive_binder             = 0.0060831549642545
cost_per_cell_negative_binder             = 0.004052336749530533
cost_per_cell_carbon_n_binders            = cost_per_cell_positive_conductive +
                                            cost_per_cell_negative_conductive +
                                            cost_per_cell_positive_binder +
                                            cost_per_cell_negative_binder


cost_per_cell_positive_current_collector  = 0.012867227973018914
cost_per_cell_negative_current_collector  = 0.055073533201446645
cost_per_cell_CC                          = cost_per_cell_positive_current_collector +
                                            cost_per_cell_negative_current_collector

cost_per_cell_separator                   = 0.09293190415386968



cost_per_cell_positive_terminal_assembly  = 0.11790046293774381
cost_per_cell_negative_terminal_assembly  = 0.11790046293774381
cost_per_cell_tabs                        = cost_per_cell_positive_terminal_assembly +
                                            cost_per_cell_negative_terminal_assembly

cost_per_cell_cathode = cost_per_cell_positive_active_material +
                        cost_per_cell_positive_conductive +
                        cost_per_cell_positive_binder +
                        cost_per_cell_positive_current_collector


cost_per_cell_anode   = cost_per_cell_negative_active_material +
                        cost_per_cell_negative_conductive +
                        cost_per_cell_negative_binder +
                        cost_per_cell_negative_current_collector


cost_per_cell_electrolyte = 0.059557787817324674

cost_per_cell_cell_container  = 0.1729206789753576

remaining_cell_material_cost = cost_per_cell_cell_container +
                               cost_per_cell_separator +
                               cost_per_cell_tabs


total_cost_tally = cost_per_cell_positive_active_material +
                   cost_per_cell_negative_active_material +
                   cost_per_cell_carbon_n_binders +
                   cost_per_cell_positive_current_collector +
                   cost_per_cell_negative_current_collector +
                   cost_per_cell_separator +
                   cost_per_cell_tabs +
                   cost_per_cell_electrolyte +
                   cost_per_cell_cell_container

total_cost_1 = cost_per_cell_cathode +
             cost_per_cell_anode +
             cost_per_cell_electrolyte +
             remaining_cell_material_cost

materials_data = zeros(4)

materials_data[1] = cost_per_cell_cathode
materials_data[2] = cost_per_cell_anode
materials_data[3] = cost_per_cell_electrolyte
materials_data[4] = remaining_cell_material_cost

materials_labels = ["Cathode",
                    "Anode",
                    "Electrolyte",
                    "Other Cell Materials"]

font = Dict("fontname"=>"Sans", "size"=>"smaller")
clf()
pie(materials_data, labels = materials_labels, startangle=90, autopct="%1.1f%%", textprops=font)
title("Material Cost Breakdown")
figure(3)
savefig("Material_Cost.png", dpi=500)
