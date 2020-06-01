include("../src/PBCM.jl")

cell_general = cell_default()
cell_design_op = cylindrical_cell_designer(cell_general)
cost = cost_default()

include("../unit_conversion_file.jl")

using PyPlot

cost.general_costs.no_units_mfg
cell_general.cathode.th
cell_general.cathode.por = 0.3
cell_general.anode.th
cell_general.anode.por
cost.cell_costs.anode.AM[1] = 10.57


data_per_cell = zeros(3)
data_per_kWh  = zeros(3)
data_materials = zeros(3)
data_cap_equip = zeros(3)
data_labor = zeros(3)
data_ovhd_cost = zeros(3)

data_per_cell_more_cells = zeros(3)
data_per_kWh_more_cells  = zeros(3)
data_materials_more_cells = zeros(3)
data_cap_equip_more_cells = zeros(3)
data_labor_more_cells = zeros(3)
data_ovhd_cost_more_cells = zeros(3)


  ##### NCA #####
cell_general.cathode.rev_sp_cap = 0.200
cost.cell_costs.cathode.AM[1] = 26.43
cost.general_costs.no_units_mfg = converter([150.0, mult.units_mfg[2], mult.units_mfg[3]])
cost_calc(cell_general, cost, system="Cell", cost_verbosity = 1)
per_cell = 2.3599272883247138
per_kWh  = 213.15310961050176
data_per_cell[1] = per_cell
data_per_kWh[1]  = per_kWh
materials_cost_per_cell = 0.9255882547519859 + 0.36043531874103896
labor_cost_per_cell     = 0.11511483694692036
equip_depr_per_cell     = 0.32367778451636275
ovhd_costs_per_cell     = 0.1107814916820407 + 0.13739352828633095 + 0.1294711138065451 + 0.1323173003641483 + 0.12514765922934087
total_cell_cost         = materials_cost_per_cell+
                      labor_cost_per_cell+
                      equip_depr_per_cell+
                      ovhd_costs_per_cell
materials_cost_per_kWh = (materials_cost_per_cell/per_cell) * per_kWh
labor_cost_per_kWh = (labor_cost_per_cell/per_cell) * per_kWh
equip_depr_per_kWh = (equip_depr_per_cell/per_cell) * per_kWh
ovhd_costs_per_kWh = (ovhd_costs_per_cell/per_cell) * per_kWh
(materials_cost_per_kWh/per_kWh)*100
(labor_cost_per_kWh/per_kWh)*100
(equip_depr_per_kWh/per_kWh)*100
(ovhd_costs_per_kWh/per_kWh)*100

data_materials[1] = materials_cost_per_kWh
data_cap_equip[1] = equip_depr_per_kWh
data_labor[1] = labor_cost_per_kWh
data_ovhd_cost[1] = ovhd_costs_per_kWh


cost.general_costs.no_units_mfg = converter([400.0, mult.units_mfg[2], mult.units_mfg[3]])
cost_calc(cell_general, cost, system="Cell", cost_verbosity = 1)
per_cell = 1.9893273036534684
per_kWh  = 179.67981594374749
data_per_cell_more_cells[1] = per_cell
data_per_kWh_more_cells[1]  = per_kWh

materials_cost_per_cell = 0.8693029713868116 + 0.29623310730160357
labor_cost_per_cell     = 0.07948144589738391
equip_depr_per_cell     = 0.25037677489587773
ovhd_costs_per_cell     = 0.08186793333812911 + 0.10293153853284769 + 0.1001507099583511 + 0.10348819260326464 + 0.10549462973919908
total_cell_cost         = materials_cost_per_cell+
                      labor_cost_per_cell+
                      equip_depr_per_cell+
                      ovhd_costs_per_cell
materials_cost_per_kWh = (materials_cost_per_cell/per_cell) * per_kWh
labor_cost_per_kWh = (labor_cost_per_cell/per_cell) * per_kWh
equip_depr_per_kWh = (equip_depr_per_cell/per_cell) * per_kWh
ovhd_costs_per_kWh = (ovhd_costs_per_cell/per_cell) * per_kWh
(materials_cost_per_kWh/per_kWh)*100
(labor_cost_per_kWh/per_kWh)*100
(equip_depr_per_kWh/per_kWh)*100
(ovhd_costs_per_kWh/per_kWh)*100

data_materials_more_cells[1] = materials_cost_per_kWh
data_cap_equip_more_cells[1] = equip_depr_per_kWh
data_labor_more_cells[1] = labor_cost_per_kWh
data_ovhd_cost_more_cells[1] = ovhd_costs_per_kWh


  ##### NMC-622 #####

cell_general.cathode.rev_sp_cap
cost.cell_costs.cathode.AM[1] = 17.83
cost.general_costs.no_units_mfg = converter([150.0, mult.units_mfg[2], mult.units_mfg[3]])
cost_calc(cell_general, cost, system="Cell", cost_verbosity = 1)
per_cell = 2.168187032799368
per_kWh  = 217.59418443138733
materials_cost_per_cell = 0.7474579772711781 + 0.36043531874103896
labor_cost_per_cell     = 0.11483846875820813
equip_depr_per_cell     = 0.3231695929562566
ovhd_costs_per_cell     = 0.11056930609453458 + 0.13714434195224984 + 0.12926783718250265 + 0.1303245744676752 + 0.11497961537572406
total_cell_cost         = materials_cost_per_cell+
                          labor_cost_per_cell+
                          equip_depr_per_cell+
                          ovhd_costs_per_cell

materials_cost_per_kWh = (materials_cost_per_cell/per_cell) * per_kWh
labor_cost_per_kWh = (labor_cost_per_cell/per_cell) * per_kWh
equip_depr_per_kWh = (equip_depr_per_cell/per_cell) * per_kWh
ovhd_costs_per_kWh = (ovhd_costs_per_cell/per_cell) * per_kWh
(materials_cost_per_kWh/per_kWh)*100
(labor_cost_per_kWh/per_kWh)*100
(equip_depr_per_kWh/per_kWh)*100
(ovhd_costs_per_kWh/per_kWh)*100

data_per_cell[2] = per_cell
data_per_kWh[2]  = per_kWh

data_materials[2] = materials_cost_per_kWh
data_cap_equip[2] = equip_depr_per_kWh
data_labor[2] = labor_cost_per_kWh
data_ovhd_cost[2] = ovhd_costs_per_kWh


cost.general_costs.no_units_mfg = converter([400.0, mult.units_mfg[2], mult.units_mfg[3]])
cost_calc(cell_general, cost, system="Cell", cost_verbosity = 1)
per_cell = 1.8160387926860846
per_kWh  = 182.25340988230866
data_per_cell_more_cells[2] = per_cell
data_per_kWh_more_cells[2]  = per_kWh

materials_cost_per_cell = 0.7079562024668135 + 0.29623310730160357
labor_cost_per_cell     = 0.07931464628772433
equip_depr_per_cell     = 0.25000933690945665
ovhd_costs_per_cell     = 0.08172772589698107 + 0.10276292727354051 + 0.10000373476378266 + 0.10172602429525367 + 0.09630508749092871
total_cell_cost         = materials_cost_per_cell+
                          labor_cost_per_cell+
                          equip_depr_per_cell+
                          ovhd_costs_per_cell
materials_cost_per_kWh = (materials_cost_per_cell/per_cell) * per_kWh
labor_cost_per_kWh = (labor_cost_per_cell/per_cell) * per_kWh
equip_depr_per_kWh = (equip_depr_per_cell/per_cell) * per_kWh
ovhd_costs_per_kWh = (ovhd_costs_per_cell/per_cell) * per_kWh
(materials_cost_per_kWh/per_kWh)*100
(labor_cost_per_kWh/per_kWh)*100
(equip_depr_per_kWh/per_kWh)*100
(ovhd_costs_per_kWh/per_kWh)*100

data_materials_more_cells[2] = materials_cost_per_kWh
data_cap_equip_more_cells[2] = equip_depr_per_kWh
data_labor_more_cells[2] = labor_cost_per_kWh
data_ovhd_cost_more_cells[2] = ovhd_costs_per_kWh


    ##### LFP #####
cell_general.cathode.rev_sp_cap = 0.150
cost.cell_costs.cathode.AM[1] = 5.07
cost.general_costs.no_units_mfg = converter([150.0, mult.units_mfg[2], mult.units_mfg[3]])
cost_calc(cell_general, cost, system="Cell", cost_verbosity = 1)
per_cell = 1.883262046892017
per_kWh  = 226.79973432087556
data_per_cell[3] = per_cell
data_per_kWh[3]  = per_kWh
materials_cost_per_cell = 0.482935048468765 + 0.36043531874103896
labor_cost_per_cell     = 0.11439232155293755
equip_depr_per_cell     = 0.3223640168046151
ovhd_costs_per_cell     = 0.11022973198209804 + 0.13674651758491269 + 0.12894560672184605 + 0.12734352800365115 + 0.0998699570321524
total_cell_cost         = materials_cost_per_cell+
                          labor_cost_per_cell+
                          equip_depr_per_cell+
                          ovhd_costs_per_cell

materials_cost_per_kWh = (materials_cost_per_cell/per_cell) * per_kWh
labor_cost_per_kWh     = (labor_cost_per_cell/per_cell)     * per_kWh
equip_depr_per_kWh     = (equip_depr_per_cell/per_cell)     * per_kWh
ovhd_costs_per_kWh     = (ovhd_costs_per_cell/per_cell)     * per_kWh
(materials_cost_per_kWh/per_kWh)*100
(labor_cost_per_kWh/per_kWh)*100
(equip_depr_per_kWh/per_kWh)*100
(ovhd_costs_per_kWh/per_kWh)*100

data_materials[3] = materials_cost_per_kWh
data_cap_equip[3] = equip_depr_per_kWh
data_labor[3] = labor_cost_per_kWh
data_ovhd_cost[3] = ovhd_costs_per_kWh


cost.general_costs.no_units_mfg = converter([400.0, mult.units_mfg[2], mult.units_mfg[3]])
cost_calc(cell_general, cost, system="Cell", cost_verbosity = 1)
per_cell = 1.558570937885646
per_kWh  = 187.69744508793283

data_per_cell_more_cells[3] = per_cell
data_per_kWh_more_cells[3]  = per_kWh
materials_cost_per_cell = 0.46835240586760807 + 0.29623310730160357
labor_cost_per_cell     = 0.07904542591808231
equip_depr_per_cell     = 0.24942666020777882
ovhd_costs_per_cell     = 0.08150350240878869 + 0.10249389713366246 + 0.09977066408311153 + 0.09909378583471119 + 0.0826514891302994
total_cell_cost         = materials_cost_per_cell+
                          labor_cost_per_cell+
                          equip_depr_per_cell+
                          ovhd_costs_per_cell

materials_cost_per_kWh = (materials_cost_per_cell/per_cell) * per_kWh
labor_cost_per_kWh = (labor_cost_per_cell/per_cell) * per_kWh
equip_depr_per_kWh = (equip_depr_per_cell/per_cell) * per_kWh
ovhd_costs_per_kWh = (ovhd_costs_per_cell/per_cell) * per_kWh
(materials_cost_per_kWh/per_kWh)*100
(labor_cost_per_kWh/per_kWh)*100
(equip_depr_per_kWh/per_kWh)*100
(ovhd_costs_per_kWh/per_kWh)*100

data_materials_more_cells[3] = materials_cost_per_kWh
data_cap_equip_more_cells[3] = equip_depr_per_kWh
data_labor_more_cells[3] = labor_cost_per_kWh
data_ovhd_cost_more_cells[3] = ovhd_costs_per_kWh

a = [1, 1.4, 1.8]
clf()

bar(a, data_materials, width = 0.35 , color="darkslategrey", edgecolor="black")
bar(a, data_cap_equip, width = 0.35, bottom=data_materials, color="turquoise", edgecolor="black")
bar(a, data_labor, width = 0.35, bottom= data_materials .+ data_cap_equip, color="lightseagreen", edgecolor="black")
bar(a, data_ovhd_cost, width = 0.35, bottom= data_materials .+ data_cap_equip .+ data_labor, color="dodgerblue", edgecolor="black")

bar(a .+ 1.5, data_materials_more_cells, width = 0.35, color="darkslategrey", edgecolor="black")
bar(a .+ 1.5, data_cap_equip_more_cells, width = 0.35, bottom=data_materials_more_cells, color="turquoise", edgecolor="black")
bar(a .+ 1.5, data_labor_more_cells, width = 0.35, bottom= data_materials_more_cells .+ data_cap_equip_more_cells, color="lightseagreen", edgecolor="black")
bar(a .+ 1.5, data_ovhd_cost_more_cells, width = 0.35, bottom= data_materials_more_cells .+ data_cap_equip_more_cells .+ data_labor_more_cells, color="dodgerblue", edgecolor="black")


ylabel("\$/kWh")
xticks([1, 1.4, 1.8, 2.5, 2.9, 3.3] , ["NCA","NMC", "LFP", "NCA","NMC", "LFP"])
xlabel("Chemistry")
ylim(0, 300)
legend(["Material", "Capital Depreciation", "Labor", "Overhead"])
figure(2)

savefig("Breakdown_MFG_Cap_4.png", dpi=500)



 ############### 26 GWh/Year LFP ###############
cost.general_costs.no_units_mfg = converter([3150.0, mult.units_mfg[2], mult.units_mfg[3]])
cost_calc(cell_general, cost, system="Cell", cost_verbosity = 1)

per_cell = 1.107467013635347
per_kWh  = 133.37136214057205
data_per_cell_more_cells[3] = per_cell
data_per_kWh_more_cells[3]  = per_kWh
materials_cost_per_cell = 0.44125227725986815 + 0.19605750952070727
labor_cost_per_cell     = 0.03763535149961152
equip_depr_per_cell     = 0.1499263476505559
ovhd_costs_per_cell     = 0.04503941012995579 + 0.05815027732003081  + 0.059970539060222365 + 0.06070598986524793 + 0.05872931132914719
total_cell_cost         = materials_cost_per_cell+
                          labor_cost_per_cell+
                          equip_depr_per_cell+
                          ovhd_costs_per_cell
materials_cost_per_kWh = (materials_cost_per_cell/per_cell) * per_kWh
labor_cost_per_kWh = (labor_cost_per_cell/per_cell) * per_kWh
equip_depr_per_kWh = (equip_depr_per_cell/per_cell) * per_kWh
ovhd_costs_per_kWh = (ovhd_costs_per_cell/per_cell) * per_kWh
q = (materials_cost_per_kWh/per_kWh)*100
w = (labor_cost_per_kWh/per_kWh)*100
e = (equip_depr_per_kWh/per_kWh)*100
r = (ovhd_costs_per_kWh/per_kWh)*100
clf()
pie([q,w,e,r], labels = ["Material", "Labor", "Capital Depreciation", "Overhead"], startangle=90, autopct="%1.1f%%")
title("Material Cost Breakdown LFP 26 GWh/Year")

figure(2)
