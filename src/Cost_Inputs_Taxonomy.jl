#=
  - Julia Version: 1.4.0
  - Author       : Alexander Bills and Abhinav Misalkar
  - Date         : 12th May 2020
  - Title        : Taxonomy for Cost Inputs
=#

mutable struct struct_electrode_costs
    AM::Array{Float64,1}
    cond::Array{Float64,1}
    bind::Array{Float64,1}
    solvent::Array{Float64,1}
    baseline_AM_required::Array{Float64,1}
    baseline_solvent_evap::Array{Float64,1}
    bind_mult::Array{Float64,1}
    CC::Array{Float64,1}
    terminal_assembly::Array{Float64,1}
    material_yield::Array{Float64,1}
    cc_yield::Array{Float64,1}
end

mutable struct struct_cell_costs
    container::Array{Float64,1}
    seperator_cost
    seperator_yield
    electrolyte_cost
    electrolyte_yield
    cell_yield::Float64
    cathode::struct_electrode_costs
    anode::struct_electrode_costs

end

mutable struct struct_manufacturing
    receiving::Array{Float64,2}
    pos_mat_prep::Array{Float64, 2}
    neg_mat_prep::Array{Float64, 2}
    pos_electrode_coat::Array{Float64, 2}
    neg_electrode_coat::Array{Float64, 2}
    bind_slvnt_recov::Array{Float64, 2}
    pos_calendr::Array{Float64, 2}
    neg_calendr::Array{Float64, 2}
    intr_process_mat_handling::Array{Float64, 2}
    electrode_slitting::Array{Float64, 2}
    vacuum_drying::Array{Float64, 2}
    control_lab::Array{Float64, 2}
    cell_stacking::Array{Float64, 2}
    CC_welding::Array{Float64, 2}
    cell_insertion_container::Array{Float64, 2}
    electrolyte_filling_and_cell_sealing::Array{Float64, 2}
    dry_room_control::Array{Float64, 2}
    formation_cycling::Array{Float64, 2}
    cell_sealing::Array{Float64, 2}
    charge_retention_testing::Array{Float64, 2}
    rejected_cell_scrap_recycle_assembly::Array{Float64, 2}
    shipping::Array{Float64, 2}
end



mutable struct struct_general_costs
        pack_int::Float64                                # Pack Integration Cost                                  # USD/Pack
        building::Float64                                # Building cost                                          # USD/m2
        dir_labor::Float64                               # Labor cost                                             # $/hr
        no_units_mfg::Float64
        pos_bindr_slvnt_recovery::Float64                # Positive Binder Solvent Recovery percentage
        manufacturing::struct_manufacturing
        formation_cycling_mult::Float64
        cell_stacking_mult::Float64
        pos_electrode_coating_solvent_SR::Float64
        neg_electrode_coating_solvent_SR::Float64
end


mutable struct struct_baseline
    energy::Float64                          # Baseline annual energy                                   # kWh/year
    cells_adjusted_yield::Float64            # Baseline annual cells adjusted for yield                 # cells/year
    electrode_area::Float64                  # Baseline annual electrode area                           # m2/year
    dry_room_area::Float64                   # Baseline annual dry room area required                   # m2
end


mutable struct struct_pack_level
    no_cells_per_pack::Float64

end


mutable struct struct_ovhd_rate
    launch_dir_annual_materials::Float64             # Launch cost percent direct annual materials
    launch_dir_labor_var_ovhd::Float64               # Launch cost percent direct labor plus variable overhead
    depr_capital_equip::Float64                      # Depreciation rate capital equipment
    depr_building_inv::Float64                       # Depreciation rate building investment
    GSA_dir_labor_var_ovhd::Float64                  # General, Sales and Administration rate direct labor plus variable overhead
    GSA_depr::Float64                                # General, Sales and Administration rate depreciation
    RnD_depr::Float64                                # R & D rate depreciation
    var_ovhd_dir_labor::Float64                      # Variable overhead rate direct labor
    var_ovhd_depr::Float64                           # Variable overhead rate depreciation
    profit_after_taxes::Float64                      # Profit rate after taxes
    working_capital_rate::Float64                    # Working capital rate
    warranty::Float64                                # Warranty cost added to the price rate
end


mutable struct struct_cost
    cell_costs::struct_cell_costs
    manufacturing_costs::struct_manufacturing
    general_costs::struct_general_costs
    baseline::struct_baseline
    ovhd_rate::struct_ovhd_rate

end
