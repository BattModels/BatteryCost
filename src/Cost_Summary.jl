#=
    - Julia Version : 1.4.0
    - Author        : Alexander Bills and Abhinav Misalkar
    - Date          : 14th May 2020
    - Title         : Overhead Costs and Summary
=#


function OEM(input_OEM,cost,breakdown,materials_breakdown)


    cost_per_cell_positive_active_material              = input_OEM[1]                       ##   $/cell
    cost_per_cell_negative_active_material              = input_OEM[2]                       ##   $/cell
    cost_per_cell_positive_conductive                   = input_OEM[3]                       ##   $/cell
    cost_per_cell_positive_binder                       = input_OEM[4]                       ##   $/cell
    cost_per_cell_binder_solvent_NMP                    = input_OEM[5]                       ##   $/cell
    cost_per_cell_negative_conductive                   = input_OEM[6]                       ##   $/cell
    cost_per_cell_negative_binder                       = input_OEM[7]                       ##   $/cell
    cost_per_cell_positive_current_collector            = input_OEM[8]                       ##   $/cell
    cost_per_cell_negative_current_collector            = input_OEM[9]                       ##   $/cell
    cost_per_cell_separator                             = input_OEM[10]                      ##   $/cell
    cost_per_cell_electrolyte                           = input_OEM[11]                      ##   $/cell
    cost_per_cell_positive_terminal_assembly            = input_OEM[12]                      ##   $/unit
    cost_per_cell_negative_terminal_assembly            = input_OEM[13]                      ##   $/unit
    cost_per_cell_cell_container                        = input_OEM[14]                      ##   $/unit

    receiving_direct_labor                              = input_OEM[15]                      ##   hours/year
    positive_material_preparation_direct_labor          = input_OEM[16]                      ##   hours/year
    negative_material_preparation_direct_labor          = input_OEM[17]                      ##   hours/year
    positive_electrode_coating_direct_labor             = input_OEM[18]                      ##   hours/year
    negative_electrode_coating_direct_labor             = input_OEM[19]                      ##   hours/year
    binder_solvent_NMP_recovery_direct_labor            = input_OEM[20]                      ##   hours/year
    positive_calendering_direct_labor                   = input_OEM[21]                      ##   hours/year
    negative_calendering_direct_labor                   = input_OEM[22]                      ##   hours/year
    inter_process_material_handling_direct_labor        = input_OEM[23]                      ##   hours/year
    electrode_slitting_direct_labor                     = input_OEM[24]                      ##   hours/year
    vacuum_drying_direct_labor                          = input_OEM[25]                      ##   hours/year
    control_laboratory_direct_labor                     = input_OEM[26]                      ##   hours/year
    cell_stacking_direct_labor                          = input_OEM[27]                      ##   hours/year
    current_collector_welding_direct_labor              = input_OEM[28]                      ##   hours/year
    cell_insertion_container_direct_labor               = input_OEM[29]                      ##   hours/year
    electrolyte_filling_and_cell_sealing_direct_labor   = input_OEM[30]                      ##   hours/year
    dry_room_control_direct_labor                       = input_OEM[31]                      ##   hours/year
    formation_cycling_direct_labor                      = input_OEM[32]                      ##   hours/year
    cell_sealing_rack_unloading_direct_labor            = input_OEM[33]                      ##   hours/year
    charge_retention_testing_direct_labor               = input_OEM[34]                      ##   hours/year
    rejected_cell_scrap_recycle_assembly_direct_labor   = input_OEM[35]                      ##   hours/year
    shipping_direct_labor                               = input_OEM[36]                      ##   hours/year

    total_plant_area                                    = input_OEM[37]                      ##   m2
    total_capital_equipment                             = input_OEM[38]                      ##   USD Million
    total_units_mfg_per_year                            = input_OEM[39]                      ##   units/year
    cell_energy_storage                                 = input_OEM[40]                      ##   kWh
    cost_verbosity                                      = input_OEM[41]                      ##   1 or 0
    mfg_capacity                                        = input_OEM[42]                      ## MWh/year
    system                                              = input_OEM[43]                      ## Cell or Pack
    if system == 1
        system = "Cell"
    elseif system == 2
        system = "Pack"
    end


    ## Investment Costs
    building_investment = (cost.general_costs.building * total_plant_area)


                            ###################### Cost Breakdown Analysis #####################


    total_cost_carbon_and_binders =
            cost_per_cell_positive_conductive  +
            cost_per_cell_positive_binder      +
            cost_per_cell_binder_solvent_NMP   +
            cost_per_cell_negative_conductive  +
            cost_per_cell_negative_binder

    total_cost_materials =
            cost_per_cell_positive_active_material      +
            cost_per_cell_negative_active_material      +
            total_cost_carbon_and_binders               +
            cost_per_cell_positive_current_collector    +
            cost_per_cell_negative_current_collector    +
            cost_per_cell_separator                     +
            cost_per_cell_electrolyte

    total_purchased_items =
            cost_per_cell_positive_terminal_assembly    +
            cost_per_cell_negative_terminal_assembly    +
            cost_per_cell_cell_container

    total_unit_cost_all_materials =
            total_cost_materials + total_purchased_items



                                            ### Direct Labor Cost Breakdown ###

    direct_labor_per_unit_electrode_processing =
        (cost.general_costs.dir_labor / total_units_mfg_per_year) * (
            positive_material_preparation_direct_labor +
            negative_material_preparation_direct_labor +
            positive_electrode_coating_direct_labor +
            negative_electrode_coating_direct_labor +
            binder_solvent_NMP_recovery_direct_labor +
            positive_calendering_direct_labor +
            negative_calendering_direct_labor +
            inter_process_material_handling_direct_labor +
            electrode_slitting_direct_labor +
            vacuum_drying_direct_labor)

    direct_labor_per_unit_cell_assembly =
        (cost.general_costs.dir_labor / total_units_mfg_per_year) * (
            cell_stacking_direct_labor +
            current_collector_welding_direct_labor +
            cell_insertion_container_direct_labor +
            electrolyte_filling_and_cell_sealing_direct_labor +
            dry_room_control_direct_labor)

    direct_labor_per_unit_formation_cycling_testing_sealing =
        (cost.general_costs.dir_labor / total_units_mfg_per_year) * (
            formation_cycling_direct_labor +
            charge_retention_testing_direct_labor +
            cell_sealing_rack_unloading_direct_labor)


    direct_labor_per_unit_cell_materials_rejection_recycling =
        (cost.general_costs.dir_labor / total_units_mfg_per_year) *
        (rejected_cell_scrap_recycle_assembly_direct_labor)

    direct_labor_per_unit_receiving_shipping =
        (cost.general_costs.dir_labor / total_units_mfg_per_year) *
        (receiving_direct_labor + shipping_direct_labor)

    direct_labor_per_unit_control_laboratory =
        (cost.general_costs.dir_labor / total_units_mfg_per_year) *
        (control_laboratory_direct_labor)

    total_direct_labor_per_unit =
        direct_labor_per_unit_electrode_processing                  +
        direct_labor_per_unit_cell_assembly                         +
        direct_labor_per_unit_formation_cycling_testing_sealing     +
        direct_labor_per_unit_cell_materials_rejection_recycling    +
        direct_labor_per_unit_receiving_shipping                    +
        direct_labor_per_unit_control_laboratory


                                    ###################### Overhead Costs #####################
    depreciation_per_unit =
        ((cost.ovhd_rate.depr_capital_equip * total_capital_equipment +                 # total_capital_equipment currently USD
          cost.ovhd_rate.depr_building_inv * building_investment)                       # building_investment currently USD
        ) / total_units_mfg_per_year

    variable_overhead_per_unit =
        total_direct_labor_per_unit * cost.ovhd_rate.var_ovhd_dir_labor +
        depreciation_per_unit * cost.ovhd_rate.var_ovhd_depr

    GSA_per_unit =
        cost.ovhd_rate.GSA_dir_labor_var_ovhd *
        (total_direct_labor_per_unit + variable_overhead_per_unit) +
        cost.ovhd_rate.GSA_depr * depreciation_per_unit

    R_and_D_per_unit = depreciation_per_unit * cost.ovhd_rate.RnD_depr

    total_fixed_expenses_per_unit =
        GSA_per_unit + R_and_D_per_unit + depreciation_per_unit


    total_variable_cost_per_unit =
        total_direct_labor_per_unit +
        variable_overhead_per_unit +
        total_unit_cost_all_materials



                                    ###################### Investment Costs #####################
    total_launch_cost =
        (
            cost.ovhd_rate.launch_dir_annual_materials                  *
            total_unit_cost_all_materials                               +
            cost.ovhd_rate.launch_dir_labor_var_ovhd                    *
            (total_direct_labor_per_unit + variable_overhead_per_unit)) *
            (total_units_mfg_per_year)

    # print("\ncost.ovhd_rate.launch_dir_annual_materials = ", cost.ovhd_rate.launch_dir_annual_materials)
    # print("\ntotal_unit_cost_all_materials = ", total_unit_cost_all_materials)
    # print("\ncost.ovhd_rate.launch_dir_labor_var_ovhd = ", cost.ovhd_rate.launch_dir_labor_var_ovhd)
    # print("\ntotal_direct_labor_per_unit = ", total_direct_labor_per_unit)
    # print("\nvariable_overhead_per_unit = ", variable_overhead_per_unit)
    # print("\ntotal_units_mfg_per_year = ", total_units_mfg_per_year)
    # print("\ntotal_launch_cost = ", total_launch_cost)

    total_working_capital =
        (total_variable_cost_per_unit    *
            total_units_mfg_per_year     *
            cost.ovhd_rate.working_capital_rate)

    total_investment =                                                                                  # currently USD
        building_investment     +
        total_capital_equipment +                                                                       # currently USD
        total_launch_cost       +                                                                       # currently USD
        total_working_capital                                                                           # currently USD

    profits_after_taxes_per_unit =
        (cost.ovhd_rate.profit_after_taxes * total_investment) /                                        # USD
        total_units_mfg_per_year

    warrant_cost_per_unit =
        cost.ovhd_rate.warranty            * (
            total_unit_cost_all_materials  +
            total_direct_labor_per_unit    +
            variable_overhead_per_unit     +
            GSA_per_unit                   +
            R_and_D_per_unit               +
            depreciation_per_unit          +
            profits_after_taxes_per_unit)


                                        ###################### Cost to OEM #####################
    cell_price_to_OEM =
    total_unit_cost_all_materials                 +
    total_direct_labor_per_unit                   +
    variable_overhead_per_unit                    +
    GSA_per_unit                                  +
    R_and_D_per_unit                              +
    depreciation_per_unit                         +
    profits_after_taxes_per_unit                  +
    warrant_cost_per_unit




    dollars_per_kWh = cell_price_to_OEM / cell_energy_storage



    # # if cost_verbosity == 0
    # print("\n")
    # # println("\n\n************************************************ Results ************************************************")
    # print("\nNo of cells mfg (Million)  =  ", total_units_mfg_per_year)
    # print("\nProduction Capacity (MWh)  =  ", mfg_capacity)
    # print("\nJulia dollars/kWh          =  ", dollars_per_kWh)
    # print("\ntotal_cell_cost_to_OEM     =  ", cell_price_to_OEM)
    # end


    if cost_verbosity == 1
        print("\n\n************************************************ Invsetment Costs (Million USD) ************************************************ ")

        print("\n\nbuilding_investment       = ", building_investment)
        print("\ntotal_launch_cost           = ", total_launch_cost)
        print("\ntotal_working_capital       = ", total_working_capital)
        print("\ntotal_investment            = ", total_investment)


        print("\n\n************************************************ Unit Cost Battery Pack (USD) ************************************************ ")
        if system == "Pack"
            print("\nVariable Cost")
            print("\n\tMaterials and Purchased Items")
            print("\n\t\ttotal_cost_pack_cell_materials     = ",total_cost_pack_cell_materials)
            print("\n\t\ttotal_pack_purchased_items         = ",total_pack_purchased_items)
            print("\n\t\ttotal_cost_module_material         = ",total_cost_module_materials)
            print("\n\t\ttotal_cost_pack_materials          = ",total_cost_pack_materials)
            print("\n\t\ttotal_pack_cost_all_materials      = ",total_pack_cost_all_materials)
        else
            print("\nVariable Cost")
            print("\n\tMaterials and Purchased Items")
            print("\n\t\ttotal_cost_materials               = ",total_cost_materials)
            print("\n\t\ttotal_purchased_items              = ",total_purchased_items)
            print("\n\t\ttotal_unit_cost_all_materials      = ",total_unit_cost_all_materials)

        end

        print("\n\nDirect Labor @ USD", cost.general_costs.dir_labor , "/ hour")
        print("\n\t\tdirect_labor_per_unit_electrode_processing                = ",direct_labor_per_unit_electrode_processing , " ")
        print("\n\t\tdirect_labor_per_unit_cell_assembly                       = ",direct_labor_per_unit_cell_assembly , " ")
        print("\n\t\tdirect_labor_per_unit_formation_cycling_testing_sealing   = ",direct_labor_per_unit_formation_cycling_testing_sealing , " ")

        if system == "Pack"
            print("\n\t\tdirect_labor_per_unit_module_and_battery_assembly     = ",direct_labor_per_unit_module_and_battery_assembly , " ")
        end

        print("\n\t\tdirect_labor_per_unit_cell_materials_rejection_recycling  = ",direct_labor_per_unit_cell_materials_rejection_recycling , " ")
        print("\n\t\tdirect_labor_per_unit_receiving_shipping                  = ",direct_labor_per_unit_receiving_shipping , " ")
        print("\n\t\tdirect_labor_per_unit_control_laboratory                  = ",direct_labor_per_unit_control_laboratory , " ")
        print("\n\t\ttotal_direct_labor_per_unit                               = ",total_direct_labor_per_unit , " ")

        print("\n\nvariable_overhead_per_unit                                  = ",variable_overhead_per_unit , " ")
        print("\ntotal_variable_cost_per_unit                                  = ",total_variable_cost_per_unit , " ")


        print("\n\nFixed Expenses")
        print("\n\tGSA_per_unit                     = ",GSA_per_unit ," ")
        print("\n\tR_and_D_per_unit                 = ",R_and_D_per_unit ," ")
        print("\n\tdepreciation_per_unit            = ",depreciation_per_unit ," ")
        print("\n\ttotal_fixed_expenses_per_unit    = ",total_fixed_expenses_per_unit ," ")
        print("\n\tprofits_after_taxes_per_unit     = ",profits_after_taxes_per_unit ," ")


        print("\n\n************************************************ Summary of Unit Costs (USD) ************************************************ ")
        print("\ntotal_cost_pack_cell_materials     = ",total_cost_materials)

        if system == "Pack"
            print("\ntotal purchased items              = ", (cost_per_unit_hardware + total_cost_module_materials + total_cost_pack_materials) ," ")
        else
            print("\ntotal purchased items              = ", (total_purchased_items))
        end

        print("\ntotal_direct_labor_per_unit        = ",total_direct_labor_per_unit , " ")
        print("\nvariable_overhead_per_unit         = ",variable_overhead_per_unit , " ")
        print("\nGSA_per_unit                       = ",GSA_per_unit ," ")
        print("\nR_and_D_per_unit                   = ",R_and_D_per_unit ," ")
        print("\ndepreciation_per_unit              = ",depreciation_per_unit ," ")
        print("\nprofits_after_taxes_per_unit       =  ",profits_after_taxes_per_unit ," ")
        print("\nwarrant_cost_per_unit              = ",warrant_cost_per_unit)

        if system == "Pack"
            print("\nbattery_pack_price_to_OEM_without_BMS_Integration = ",battery_pack_price_to_OEM_without_BMS_Integration ," ")
            print("\ntotal_battery_cost_to_OEM = ",total_battery_cost_to_OEM ," ")
        else
            print("\ntotal_cell_cost_to_OEM             = ", cell_price_to_OEM)
        end

        println("\n\n************************************************ Results ************************************************")
        # println("\nBattery ", i)
        print("\nMFG Capacity                       = ", mfg_capacity, " MWh")
        print("\nCell kWh                           = ", cell_energy_storage)
        print("\nJulia dollars/kWh                  = ", dollars_per_kWh)
    end

    if breakdown
        return total_unit_cost_all_materials  ,
        total_direct_labor_per_unit           ,
        variable_overhead_per_unit            ,
        GSA_per_unit                          ,
        R_and_D_per_unit                      ,
        depreciation_per_unit                 ,
        profits_after_taxes_per_unit          ,
        warrant_cost_per_unit                 ,
        cell_energy_storage


    elseif materials_breakdown
        cathode_cost =cost_per_cell_positive_active_material+
            cost_per_cell_positive_current_collector+
            cost_per_cell_positive_conductive+
            cost_per_cell_binder_solvent_NMP+
            cost_per_cell_positive_binder

        anode_cost = cost_per_cell_negative_active_material+
            cost_per_cell_negative_binder+
            cost_per_cell_negative_conductive+
            cost_per_cell_negative_current_collector

        electrolyte_cost = cost_per_cell_electrolyte

        others_cost = cost_per_cell_cell_container+
            cost_per_cell_negative_terminal_assembly+
            cost_per_cell_positive_terminal_assembly+
            cost_per_cell_separator

        return cathode_cost,anode_cost,electrolyte_cost,others_cost
    else
        return dollars_per_kWh, mfg_capacity
    end
end
