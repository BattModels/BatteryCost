#=
    - Julia Version : 1.4.0
    - Author        : Alexander Bills and Abhinav Misalkar
    - Date          : 14th May 2020
    - Title         : Manufacturing Cost Calculations
=#



function AM(mass_AM, electrode_costs, total_units_mfg_per_year, baseline_AM, cell_yield)

  #     Direct Material Costs
  mass_per_cell = (mass_AM) / (cell_yield * electrode_costs.material_yield)

  #     Annual Cell Materials Rates
  total_active_material = (total_units_mfg_per_year * mass_per_cell)                         # in kg

  # Unit Cell Material Cost Rates
  unit_cost_active_material = electrode_costs.AM[1] * ((baseline_AM[1] / total_active_material[1])^(1 - electrode_costs.AM[2]))

  # Cell material costs
  cost_per_cell_active_material = unit_cost_active_material * mass_per_cell                 # USD

  return mass_per_cell, total_active_material, unit_cost_active_material, cost_per_cell_active_material

end

function cond(mass_AM, electrode_costs, electrode, total_units_mfg_per_year, baseline_AM, total_active_material, cell_yield)

  # Direct Material Costs
  mass_per_cell = ((mass_AM) / ((1 - electrode.cond_wt_fr - electrode.bind_wt_fr))) *
                  ((electrode.cond_wt_fr)) / (cell_yield * electrode_costs.material_yield)

  # Annual Cell Materials Rates
  total_mass_conductive = (total_units_mfg_per_year * mass_per_cell)                       # in kg

  # Unit Cell Material Cost Rates
  unit_cost = electrode_costs.cond[1] * ((baseline_AM[1] / total_active_material[1])^(1 - electrode_costs.cond[2]))

  # Cell material costs
  cost_per_cell_conductive = unit_cost * mass_per_cell                                     # in kg

  return mass_per_cell, total_mass_conductive, unit_cost, cost_per_cell_conductive
end


function bind(mass_AM, electrode_costs, electrode, total_units_mfg_per_year, baseline_AM, total_active_material, cell_yield)

  #     Direct Material Costs
   mass_per_cell = ((mass_AM) / ((1 - electrode.cond_wt_fr - electrode.bind_wt_fr)) *
                   ((electrode.bind_wt_fr)) / (cell_yield * electrode_costs.material_yield))

  #     Annual Cell Materials Rates
  total_mass_binder = (total_units_mfg_per_year * mass_per_cell)                             # in kg

  #     Unit Cell Material Cost Rates
  unit_cost = electrode_costs.bind[1] * ((baseline_AM[1] / total_active_material[1])^(1 - electrode_costs.bind[2]))

  #     Cell material costs
  cost_per_cell_binder = unit_cost * mass_per_cell

  return mass_per_cell, total_mass_binder, unit_cost, cost_per_cell_binder
end


function CC(CC_area, cell_yield, electrode_costs, baseline_electrode_area, total_units_mfg_per_year, electrode_area_per_year)

  #     Direct Material Costs
  area_per_cell = (CC_area /(electrode_costs.cc_yield * cell_yield))                                  # m2

  #     Annual Cell Materials Rates
  total_area = total_units_mfg_per_year * area_per_cell                                               # m2/year

  # Unit Cell Material Cost Rates
  unit_cost = electrode_costs.CC[1] .* ((baseline_electrode_area ./ electrode_area_per_year).^
              (1 .- electrode_costs.CC[2]))                                                           # USD/m2

  # Cell material costs
  cost_per_cell_current_collector = unit_cost * area_per_cell                                         # USD

  return area_per_cell, total_area, unit_cost, cost_per_cell_current_collector
end


function sep(sep_area, cell_costs, cell_yield, total_units_mfg_per_year, baseline_electrode_area, electrode_area_per_year)

  # Direct Material Costs
  separator_area_per_cell = ((sep_area) / (cell_costs.seperator_yield * cell_yield))

  # Annual Cell Materials Rates
  total_separator_area = total_units_mfg_per_year * separator_area_per_cell                           # in m2

  # Unit Cell Material Cost Rates
  unit_cost_separator = cell_costs.seperator_cost[1] * ((baseline_electrode_area / electrode_area_per_year)^(1 - cell_costs.seperator_cost[2]))

  # Cell material costs
  cost_per_cell_separator = unit_cost_separator * separator_area_per_cell

  return separator_area_per_cell, total_separator_area, unit_cost_separator, cost_per_cell_separator

end


function electrolyte(electrolyte_volm, cell_costs, cell_yield, total_units_mfg_per_year)

  # Direct Material Costs
  electrolyte_per_cell = electrolyte_volm / (cell_costs.electrolyte_yield * cell_yield)                 # L

  # Annual Cell Materials Rates
  total_electrolyte_volume = (total_units_mfg_per_year * (electrolyte_per_cell))                        # L

  # Unit Cell Material Cost Rates
  unit_cost_electrolyte = cell_costs.electrolyte_cost

  # Cell material costs
  cost_per_cell_electrolyte = unit_cost_electrolyte[1] * electrolyte_per_cell

  return electrolyte_per_cell, total_electrolyte_volume, unit_cost_electrolyte, cost_per_cell_electrolyte
end


function ta(total_units_mfg_per_year, cell_yield, electrode_costs, struct_baseline)

  # Direct Material Costs

  # Annual Cell Materials Rates
  total_terminal_assemblies = total_units_mfg_per_year / cell_yield

  # Unit Cell Material Cost Rates
  unit_cost_terminal = electrode_costs.terminal_assembly[1]

  # Cell material costs
  cost_per_cell_terminal_assembly = unit_cost_terminal * ((cost.baseline.cells_adjusted_yield / total_terminal_assemblies)^
                                    (1 - electrode_costs.terminal_assembly[2]))

    return total_terminal_assemblies, unit_cost_terminal, cost_per_cell_terminal_assembly

  end

function can_al_condr(total_units_mfg_per_year, cell_yield, cell_costs, struct_baseline)

  # Direct Material Costs
  # Annual Cell Materials Rates
  total_cell_containers = total_units_mfg_per_year / cell_yield
  total_aluminum_thermal_conductors = total_units_mfg_per_year

  # Unit Cell Material Cost Rates
  unit_cost_cell_container = cell_costs.container[1]

  # Cell material costs
  cost_per_cell_cell_container =
    unit_cost_cell_container * ((cost.baseline.cells_adjusted_yield  / total_cell_containers)^(1 - cell_costs.container[2]))

  return total_cell_containers, total_aluminum_thermal_conductors, unit_cost_cell_container, cost_per_cell_cell_container

end



function cell_assembly(cell_capacity, cost, energy_kwh_per_year,  electrode_area_per_year,
                       number_of_cells_adjusted_for_yield, positive_active_material_kg_per_year,
                       negative_active_material_kg_per_year, total_positive_binder_solvent_evaporated,
                       total_negative_binder_solvent_evaporated)

      baseline_cell_assembly_data = cost.manufacturing_costs

      count = 0
      total_dir_labor = 0
      labor_data = []

      total_cap_equip = 0
      total_pl_area = 0

      VR_kwH_energy = energy_kwh_per_year/cost.baseline.energy
      VR_m2_electrode_area = electrode_area_per_year/cost.baseline.electrode_area
      VR_total_cells = number_of_cells_adjusted_for_yield/cost.baseline.cells_adjusted_yield


      dry_room_area = 0.0

      process_names = fieldnames(typeof(baseline_cell_assembly_data))


      dry_room_processes = [:cell_stacking,:CC_welding,
                            :cell_insertion_container,
                            :electrolyte_filling_and_cell_sealing,
                            :intr_process_mat_handling]

      for process in process_names


          if getfield(baseline_cell_assembly_data, process)[4,1] == 1.0
              count += 1
              volm_ratio = VR_kwH_energy

              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])
              total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2])
              total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))

          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 2.0
              count += 1
              volm_ratio = positive_active_material_kg_per_year[1]/cost.cell_costs.cathode.baseline_AM_required[1]

              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])
              total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2])
              total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))

          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 3.0
              count += 1
              volm_ratio = negative_active_material_kg_per_year[1]/cost.cell_costs.anode.baseline_AM_required[1]

              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])
              total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2])
              total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))

          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 4.0 && getfield(baseline_cell_assembly_data, process)[4,2] == 0.0
              count += 1
              volm_ratio = VR_m2_electrode_area

              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])
              total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2])
              total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))

          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 4.0 && getfield(baseline_cell_assembly_data, process)[4,2] == 1.0

              volm_ratio = VR_m2_electrode_area

              baseline_pos_solvent_evap_per_m2 = cost.cell_costs.cathode.baseline_solvent_evap[1]/cost.baseline.electrode_area
              baseline_neg_solvent_evap_per_m2 = cost.cell_costs.anode.baseline_solvent_evap[1]/cost.baseline.electrode_area


              pos_solvent_evap_per_m2 = total_positive_binder_solvent_evaporated[1] / electrode_area_per_year
              neg_solvent_evap_per_m2 = total_negative_binder_solvent_evaporated[1] / electrode_area_per_year

              volm_ratio = VR_m2_electrode_area
              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])

              if process == :pos_electrode_coat
                  count += 1
                  total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2]) * (pos_solvent_evap_per_m2/baseline_pos_solvent_evap_per_m2)^(cost.general_costs.pos_electrode_coating_solvent_SR)

              elseif process == :neg_electrode_coat
                  count += 1
                  total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2]) * (neg_solvent_evap_per_m2/baseline_neg_solvent_evap_per_m2)^(cost.general_costs.neg_electrode_coating_solvent_SR)
              end

              total_pl_area += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))

          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 5.0
              count += 1
              volm_ratio = total_positive_binder_solvent_evaporated[1]/cost.cell_costs.cathode.baseline_solvent_evap[1]

              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])
              total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2])
              total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))

          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 6.0 && getfield(baseline_cell_assembly_data, process)[4,2] == 0.0
              count += 1
              volm_ratio = VR_total_cells
              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])
              total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2])
              total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])


              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))

          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 6.0 && getfield(baseline_cell_assembly_data, process)[4,2] == 2.0

              volm_ratio = VR_total_cells

              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])

              if cell_capacity > 80.0
                  count += 1
                  total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2]) * (cost.general_costs.formation_cycling_mult)
              else
                  count += 1
                  total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2])
              end

              total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))

          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 6.0 && getfield(baseline_cell_assembly_data, process)[4,2] == 3.0
              volm_ratio = VR_total_cells
              total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])
              total_cap_equip +=
              total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

              append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))



          elseif getfield(baseline_cell_assembly_data, process)[4,1] == 7.0
              continue
          end

          if process == :intr_process_mat_handling
            dry_room_area += (getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2]))/3.0


          elseif process in dry_room_processes
            dry_room_area += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])
          end

      end
      process = :dry_room_control

      if process in process_names
        count += 1

        volm_ratio = dry_room_area/cost.baseline.dry_room_area

        total_dir_labor += getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2])
        total_cap_equip += getfield(baseline_cell_assembly_data, process)[2,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[2,2])
        total_pl_area   += getfield(baseline_cell_assembly_data, process)[3,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[3,2])

        append!(labor_data, getfield(baseline_cell_assembly_data, process)[1,1] * (volm_ratio ^ getfield(baseline_cell_assembly_data, process)[1,2]))
      else
        @warn("No Dry Room Control")
      end

      return total_dir_labor,
      total_cap_equip * 1000000.0,  # Converted from Mill USD to USD as all the parameters in Cost_Summary are in USD
      total_pl_area,
      count,
      labor_data
  end





function cost_calc(cell, cost ; system, cost_verbosity,breakdown=false)


  #Inputs from Design Routine
  cell_design_op = cylindrical_cell_designer(cell)

  cell_design_op.energy                       = converter(cell_design_op.energy                    , mult.energy_cell)
  cell_design_op.mass_cathode_AM              = converter(cell_design_op.mass_cathode_AM           , mult.mass_pos_AM)
  cell_design_op.mass_anode_AM                = converter(cell_design_op.mass_anode_AM             , mult.mass_neg_AM)
  cell_design_op.pos_CC_area                  = converter(cell_design_op.pos_CC_area               , mult.pos_CC_area)
  cell_design_op.neg_CC_area                  = converter(cell_design_op.neg_CC_area               , mult.neg_CC_area)
  cell_design_op.sep_area                     = converter(cell_design_op.sep_area                  , mult.sep_area)
  cell_design_op.electrolyte_volm             = converter(cell_design_op.electrolyte_volm          , mult.electrolyte_volm)
  cell_design_op.total_coated_area_cathode    = converter(cell_design_op.total_coated_area_cathode , mult.total_coated_area_cathode)


    ######################################################################################################################
    #                                  CELL DESIGN INPUTS FROM THE BATTERY DATA STRUCTURE                                #
    ######################################################################################################################

  cell_capacity                               = cell_design_op.rev_cap                                 ##      Ah       ##

  # cell_energy_storage                 = cell_design_op.energy                                        ##      kWh      ##

  # mass_positive_active_material       = cell_design_op.mass_cathode_AM                               ##     grams     ##
  # mass_negative_active_material       = cell_design_op.mass_anode_AM                                 ##     grams     ##
  # positive_current_collector_area     = cell_design_op.pos_CC_area/10000.0                           ##      m2       ##
  # negative_current_collector_area     = cell_design_op.neg_CC_area/10000.0                           ##      m2       ##
  # separator_area                      = cell_design_op.sep_area/10000.0                              ##      m2       ##
  # electrolyte_per_cell_without_yield  = cell_design_op.electrolyte_volm/1000.0                       ##     litre     ##
  # positive_terminal_assmebly_mass     = cell_design_op.mass_tab                                      ##     grams     ##
  # negative_terminal_assmebly_mass     = cell_design_op.mass_tab                                      ##     grams     ##
  # can_weight                          = cell_design_op.mass_of_cannister                             ##     grams     ##
  # total_cell_electrode_area           = cell_design_op.total_coated_area_cathode/10000.0             ##      m2       ##

  positive_active_material_weight_fraction     = cell_design_op.pos_AM_wt_fr                    ##       decimal values       ##
  positive_conductive_weight_fraction          = cell.cathode.cond_wt_fr                        ##       decimal values       ##
  positive_binder_weight_fraction              = cell.cathode.bind_wt_fr                        ##       decimal values       ##
  negative_active_material_weight_fraction     = cell_design_op.neg_AM_wt_fr                    ##       decimal values       ##
  negative_conductive_weight_fraction          = cell.anode.cond_wt_fr                          ##       decimal values       ##
  negative_binder_weight_fraction              = cell.anode.bind_wt_fr                          ##       decimal values       ##




                  ###############################################################################################
                  #                            BATPAC MANUFACTURING COST CALCULATIONS                           #
                  ###############################################################################################


                          #####################     Annual Processing Rates     #####################

  if system == "Pack"

    total_units_mfg_per_year = cost.general_costs.no_units_mfg * cost.battery_pack.no_cells_per_pack

  elseif system == "Cell"

    total_units_mfg_per_year = cost.general_costs.no_units_mfg
  else
    @warn "System is neither pack nor cell, so calculating cost as if cell"
    total_units_mfg_per_year = cost.general_costs.no_units_mfg
  end



  # Same for all
  energy_kwh_per_year = cell_design_op.energy * total_units_mfg_per_year
  number_of_cells_adjusted_for_yield = total_units_mfg_per_year / cost.cell_costs.cell_yield
  electrode_area_per_year = number_of_cells_adjusted_for_yield * cell_design_op.total_coated_area_cathode


  #Material Costs
  positive_active_material_kg_per_year =
  ((cell_design_op.mass_cathode_AM) * total_units_mfg_per_year) / (cost.cell_costs.cell_yield * cost.cell_costs.cathode.material_yield)


  negative_active_material_kg_per_year =
    ((cell_design_op.mass_anode_AM) * total_units_mfg_per_year) / (cost.cell_costs.cell_yield * cost.cell_costs.anode.material_yield)


  mass_positive_active_material_per_cell,
  total_positive_active_material,
  unit_cost_positive_active_material,
  cost_per_cell_positive_active_material = AM(cell_design_op.mass_cathode_AM, cost.cell_costs.cathode,
                                              total_units_mfg_per_year, cost.cell_costs.cathode.baseline_AM_required, cost.cell_costs.cell_yield)

  mass_negative_active_material_per_cell,
  total_negative_active_material,
  unit_cost_negative_active_material,
  cost_per_cell_negative_active_material = AM(cell_design_op.mass_anode_AM, cost.cell_costs.anode,
                                              total_units_mfg_per_year, cost.cell_costs.anode.baseline_AM_required, cost.cell_costs.cell_yield)


  mass_conductive_positive_per_cell,
  total_mass_positive_conductive,
  unit_cost_carbon,
  cost_per_cell_positive_conductive = cond(cell_design_op.mass_cathode_AM, cost.cell_costs.cathode, cell.cathode,
                                          total_units_mfg_per_year, cost.cell_costs.cathode.baseline_AM_required,
                                          total_positive_active_material, cost.cell_costs.cell_yield)

  mass_conductive_negative_per_cell,
  total_mass_negative_conductive,
  unit_cost_carbon_black,
  cost_per_cell_negative_conductive = cond(cell_design_op.mass_anode_AM, cost.cell_costs.anode, cell.anode,
                                           total_units_mfg_per_year, cost.cell_costs.anode.baseline_AM_required,
                                           total_negative_active_material, cost.cell_costs.cell_yield)


  mass_binder_positive_per_cell,
  total_mass_positive_binder,
  unit_cost_binder_PVDF,
  cost_per_cell_positive_binder = bind(cell_design_op.mass_cathode_AM, cost.cell_costs.cathode, cell.cathode,
                                       total_units_mfg_per_year, cost.cell_costs.cathode.baseline_AM_required,
                                       total_positive_active_material, cost.cell_costs.cell_yield)

  mass_binder_negative_per_cell,
  total_mass_negative_binder,
  unit_cost_negative_binder,
  cost_per_cell_negative_binder = bind(cell_design_op.mass_anode_AM, cost.cell_costs.anode, cell.anode,
                                       total_units_mfg_per_year, cost.cell_costs.anode.baseline_AM_required,
                                       total_negative_active_material, cost.cell_costs.cell_yield)



  positive_current_collector_area_per_cell,
  total_positive_current_collector_area,
  unit_cost_positive_current_collector,
  cost_per_cell_positive_current_collector = CC(cell_design_op.pos_CC_area, cost.cell_costs.cell_yield,
                                                cost.cell_costs.cathode, cost.baseline.electrode_area,
                                                total_units_mfg_per_year, electrode_area_per_year)


  negative_current_collector_area_per_cell,
  total_negative_current_collector_area,
  unit_cost_negative_current_collector,
  cost_per_cell_negative_current_collector = CC(cell_design_op.neg_CC_area, cost.cell_costs.cell_yield,
                                                cost.cell_costs.anode, cost.baseline.electrode_area,
                                                total_units_mfg_per_year, electrode_area_per_year)

  separator_area_per_cell,
  total_separator_area,
  unit_cost_separator,
  cost_per_cell_separator = sep(cell_design_op.sep_area, cost.cell_costs, cost.cell_costs.cell_yield,
                                total_units_mfg_per_year, cost.baseline.electrode_area,
                                electrode_area_per_year)

  electrolyte_per_cell,
  total_electrolyte_volume,
  unit_cost_electrolyte,
  cost_per_cell_electrolyte = electrolyte(cell_design_op.electrolyte_volm, cost.cell_costs,
                                          cost.cell_costs.cell_yield, total_units_mfg_per_year)

  total_positive_terminal_assemblies,
  unit_cost_positive_terminal,
  cost_per_cell_positive_terminal_assembly = ta(total_units_mfg_per_year, cost.cell_costs.cell_yield, cost.cell_costs.cathode, struct_baseline)

  total_negative_terminal_assemblies,
  unit_cost_negative_terminal,
  cost_per_cell_negative_terminal_assembly = ta(total_units_mfg_per_year, cost.cell_costs.cell_yield, cost.cell_costs.anode, struct_baseline)

  total_cell_containers,
  total_aluminum_thermal_conductors,
  unit_cost_cell_container,
  cost_per_cell_cell_container = can_al_condr(total_units_mfg_per_year,cost.cell_costs.cell_yield, cost.cell_costs, struct_baseline)



                            #####################     Direct Material Costs     #####################


  mass_binder_solvent_NMP_per_cell = (cost.cell_costs.cathode.bind_mult[1]) * (mass_binder_positive_per_cell)                           # in kg

  positive_dry_mass_per_cell =
    mass_positive_active_material_per_cell +
    mass_conductive_positive_per_cell +
    mass_binder_positive_per_cell


  mass_binder_solvent_water_per_cell = (cost.cell_costs.anode.bind_mult[1]) * (mass_binder_negative_per_cell)                              # in kg

  negative_dry_mass_per_cell =
    mass_negative_active_material_per_cell +
    mass_conductive_negative_per_cell +
    mass_binder_negative_per_cell




                            #####################     Annual Cell Materials Rates     #####################



  total_binder_solvent_NMP_makeup =
    ((mass_binder_solvent_NMP_per_cell *
    total_units_mfg_per_year)) *
    (1 - (cost.general_costs.pos_bindr_slvnt_recovery))                                                                        # in kg


  total_positive_binder_solvent_evaporated =
    (mass_binder_solvent_NMP_per_cell *
    total_units_mfg_per_year)                                                                                                        # in kg

  total_negative_binder_solvent_evaporated =
    (mass_binder_solvent_water_per_cell *
    total_units_mfg_per_year)                                                                                                          # in kg



  binder_solvent_kg_per_year = total_positive_binder_solvent_evaporated


                            #####################     Unit Cell Material Costs     #####################



  unit_cost_binder_solvent_NMP = cost.cell_costs.cathode.solvent[1] *
                                 ((cost.cell_costs.cathode.baseline_AM_required[1] / total_positive_active_material[1])^(1 - cost.cell_costs.cathode.solvent[2]))



                            #####################     Cell material costs     #####################




  cost_per_cell_binder_solvent_NMP =
    ((unit_cost_binder_solvent_NMP * mass_binder_solvent_NMP_per_cell)) * (1 - (cost.general_costs.pos_bindr_slvnt_recovery))



  cost_per_cell_carbon_and_binders =
    cost_per_cell_positive_conductive[1] +
    cost_per_cell_positive_binder[1] +
    cost_per_cell_binder_solvent_NMP[1] +
    cost_per_cell_negative_conductive[1] +
    cost_per_cell_negative_binder[1]

  cost_per_cell_hardware_cost =
    cost_per_cell_positive_terminal_assembly +
    cost_per_cell_negative_terminal_assembly +
    cost_per_cell_cell_container

  total_cost_cell_winding_materials =
    cost_per_cell_positive_active_material[1] +
    cost_per_cell_positive_conductive[1] +
    cost_per_cell_positive_binder[1] +
    cost_per_cell_binder_solvent_NMP[1] +
    cost_per_cell_negative_active_material[1] +
    cost_per_cell_negative_conductive[1] +
    cost_per_cell_negative_binder[1] +
    cost_per_cell_positive_current_collector[1] +
    cost_per_cell_negative_current_collector[1] +
    cost_per_cell_separator[1] +
    cost_per_cell_electrolyte[1]

  total_cost_cell_materials =
    total_cost_cell_winding_materials +
    unit_cost_cell_container +
    unit_cost_negative_terminal +
    unit_cost_positive_terminal


                              ################################     Cell Assembly     ################################




  total_cell_labor,
  total_cell_capital_equip,
  total_cell_pl_area , count,
  labor_data = cell_assembly(cell_design_op.rev_cap, cost, energy_kwh_per_year,  electrode_area_per_year,
                              number_of_cells_adjusted_for_yield, positive_active_material_kg_per_year,
                              negative_active_material_kg_per_year, total_positive_binder_solvent_evaporated,
                              total_negative_binder_solvent_evaporated)

  # print("\n\n")
  # print("Process count: ", count)
  # print("\nDir labor: ", total_cell_labor)
  # print("\nCap equip: ", total_cell_capital_equip)
  # print("\nPlant area: ", total_cell_pl_area)
  # print("\n",length(labor_data))

  inputs_to_OEM = zeros(43)
  inputs_to_OEM[1] = cost_per_cell_positive_active_material[1]            # 1
  inputs_to_OEM[2] = cost_per_cell_negative_active_material[1]            # 2
  inputs_to_OEM[3] = cost_per_cell_positive_conductive[1]                 # 3
  inputs_to_OEM[4] = cost_per_cell_positive_binder[1]                     # 4
  inputs_to_OEM[5] = cost_per_cell_binder_solvent_NMP[1]                  # 5
  inputs_to_OEM[6] = cost_per_cell_negative_conductive[1]                 # 6
  inputs_to_OEM[7] = cost_per_cell_negative_binder[1]                     # 7
  inputs_to_OEM[8] = cost_per_cell_positive_current_collector[1]          # 8
  inputs_to_OEM[9] = cost_per_cell_negative_current_collector[1]          # 9
  inputs_to_OEM[10] = cost_per_cell_separator[1]                          # 10
  inputs_to_OEM[11] = cost_per_cell_electrolyte[1]                        # 11
  inputs_to_OEM[12] = cost_per_cell_positive_terminal_assembly[1]         # 12
  inputs_to_OEM[13] = cost_per_cell_negative_terminal_assembly[1]         # 13
  inputs_to_OEM[14] = cost_per_cell_cell_container[1]                     # 14




                                                     # labor_data[1]      # 15   receiving_direct_labor
                                                     # labor_data[2]      # 16   positive_material_preparation_direct_labor
                                                     # labor_data[3]      # 17   negative_material_preparation_direct_labor
                                                     # labor_data[4]      # 18   positive_electrode_coating_direct_labor
                                                     # labor_data[5]      # 19   negative_electrode_coating_direct_labor
                                                     # labor_data[6]      # 20   binder_solvent_NMP_recovery_direct_labor
                                                     # labor_data[7]      # 21   positive_calendering_direct_labor
                                                     # labor_data[8]      # 22   negative_calendering_direct_labor
                                                     # labor_data[9]      # 23   inter_process_material_handling_direct_labor
                                                     # labor_data[10]     # 24   electrode_slitting_direct_labor
  inputs_to_OEM[15:36] .= labor_data                 # labor_data[11]     # 25   vacuum_drying_direct_labor
                                                     # labor_data[12]     # 26   control_laboratory_direct_labor
                                                     # labor_data[13]     # 27   cell_stacking_direct_labor
                                                     # labor_data[14]     # 28   current_collector_welding_direct_labor
                                                     # labor_data[15]     # 29   cell_insertion_container_direct_labor
                                                     # labor_data[16]     # 30   electrolyte_filling_and_cell_sealing_direct_labor
                                                     # labor_data[17]     # 31   dry_room_control_direct_labor
                                                     # labor_data[18]     # 32   formation_cycling_direct_labor
                                                     # labor_data[19]     # 33   cell_sealing_rack_unloading_direct_labor
                                                     # labor_data[20]     # 34   charge_retention_testing_direct_labor
                                                     # labor_data[21]     # 35   rejected_cel)l_scrap_recycle_assembly_direct_labor
                                                     # labor_data[22]     # 36   shipping_direct_labor



  inputs_to_OEM[37] = total_cell_pl_area                                  # 37
  inputs_to_OEM[38] = total_cell_capital_equip                            # 38
  inputs_to_OEM[39] = total_units_mfg_per_year                            # 39
  inputs_to_OEM[40] = cell_design_op.energy                               # 40
  inputs_to_OEM[41] = cost_verbosity                                      # 41
  inputs_to_OEM[42] = energy_kwh_per_year/1000.0                          # 42   manufacturing capacity (MWh) used only for print statements
  if system == "Cell"
    inputs_to_OEM[43] = 1                                                 # 43   Cell Level Analysis
  elseif system == "Pack"
    inputs_to_OEM[43] = 2                                                 # 43   Cell Level Analysis
  end
  # print(inputs_to_OEM)

  if cost_verbosity == 1
          println("")
          println("\n\n************************************************ Annual Processing Rates ************************************************")
          if system == "Pack"
              println("\n\ttotal_battery_packs_manufactured_per_year = \t", total_units_mfg_per_year)
          else
              println("\n\ttotal_cells_manufactured_per_year         = \t", total_units_mfg_per_year)
          end
          println("\tenergy_kwh_per_year                             = \t", energy_kwh_per_year, "\t\t kWh")
          println("\ttotal_units_mfg_per_year               = \t", total_units_mfg_per_year)
          println("\tnumber_of_cells_adjusted_for_yield              = \t", number_of_cells_adjusted_for_yield)
          println("\telectrode_area_per_year                         = \t", electrode_area_per_year, "\t\t m2")
          println("\tpositive_active_material_kg_per_year            = \t", positive_active_material_kg_per_year, "\t\t kg")
          println("\tnegative_active_material_kg_per_year            = \t", negative_active_material_kg_per_year, "\t\t kg")
          println("\tbinder_solvent_kg_per_year                      = \t", binder_solvent_kg_per_year)
          # println("\tdry_room_operating_area                         = \t", dry_room_operating_area)


          println("\n\n************************************************ Direct Materials Costs ************************************************")
          println("\n\tTotal Cell Materials per Accepted Cell Yield")
          println("\n\t\tPositive Electrode Materials (dry), grams")
          println("\t\t\tmass_positive_active_material_per_cell   = \t ", mass_positive_active_material_per_cell, "\t\t kg")
          println("\t\t\tmass_conductive_positive_per_cell        = \t ", mass_conductive_positive_per_cell, "\t\t kg")
          println("\t\t\tmass_binder_positive_per_cell            = \t ", mass_binder_positive_per_cell, "\t\t kg")
          println("\t\t\tmass_binder_solvent_NMP_per_cell         = \t ", mass_binder_solvent_NMP_per_cell, "\t\t kg")
          println("\t\t\tpositive_dry_mass_per_cell               = \t ", positive_dry_mass_per_cell, "\t\t kg")

          println("\n\t\tNegative Electrode Materials (dry), grams")
          println("\t\t\tmass_negative_active_material_per_cell   = \t ", mass_negative_active_material_per_cell, "\t\t kg")
          println("\t\t\tmass_conductive_negative_per_cell        = \t ", mass_conductive_negative_per_cell, "\t\t kg")
          println("\t\t\tmass_binder_negative_per_cell            = \t ", mass_binder_negative_per_cell, "\t\t kg")
          println("\t\t\tmass_binder_solvent_water_per_cell       = \t ", mass_binder_solvent_water_per_cell, "\t\t kg")
          println("\t\t\tnegative_dry_mass_per_cell               = \t ", negative_dry_mass_per_cell, "\t\t kg")

          println("\n\t\tpositive_current_collector_area_per_cell = \t ", positive_current_collector_area_per_cell, "\t\t m2")
          println("\t\tnegative_current_collector_area_per_cell   = \t ", negative_current_collector_area_per_cell, "\t\t m2")
          println("\t\tseparator_area_per_cell                    = \t ", separator_area_per_cell, "\t\t m2")
          println("\t\telectrolyte_per_cell                       = \t ", electrolyte_per_cell, "\t\t Litre")



          println("\n\n************************************************ Annual Cell Material Rates ************************************************")
          println("\n\t\tPositive Electrode")
          println("\t\t\tpositive active material           = \t ", total_positive_active_material, " \t\tkg/year")
          println("\t\t\tpositive conductive                = \t ", total_mass_positive_conductive, " \t\tkg/year")
          println("\t\t\tpositive binder                    = \t ", total_mass_positive_binder, " \t\tkg/year")

          println("\n\t\tNegative Electrode")
          println("\t\t\tnegative active material           = \t ", total_negative_active_material, " \t\tkg/year")
          println("\t\t\tnegative conductive                = \t ", total_mass_negative_conductive, " \t\tkg/year")
          println("\t\t\tnegative binder                    = \t ", total_mass_negative_binder," \t\tkg/year")

          println("\n\t\tpositive current collector         = \t ", total_positive_current_collector_area, " \t\tm2/year")
          println("\t\tnegative current collector           = \t ", total_negative_current_collector_area, " \t\tm2/year")

          println("\t\tseparator area                       = \t ", total_separator_area, " \t\tm2/year")
          println("\t\telectrolyte volume                   = \t ", total_electrolyte_volume, " \t\tlitre/year")

          println("\t\tpositive terminal assemblies         = \t " , total_positive_terminal_assemblies, " \t\t/year")
          println("\t\tnegative terminal assemblies         = \t " , total_negative_terminal_assemblies, " \t\t/year")

          println("\t\tcell containers                      = \t ", total_cell_containers, "\t\t /year")
          println("\n\t\tpositive binder solvent evaporated = \t ", total_positive_binder_solvent_evaporated, " \t\tkg/year")
          println("\t\tnegative binder solvent evaporateds  = \t ", total_negative_binder_solvent_evaporated, " \t\tkg/year")



          println("\n\n************************************************ Unit Cell Material Costs ************************************************")
          println("\n\t\tPositive Electrode")
          println("\t\t\tunit_cost_positive_active_material   = \t\tUSD  ", unit_cost_positive_active_material, "/kg")
          println("\t\t\tunit_cost_carbon                     = \t\tUSD  ", unit_cost_carbon, "/kg")
          println("\t\t\tunit_cost_binder_PVDF                = \t\tUSD  ", unit_cost_binder_PVDF, "/kg")
          println("\t\t\tunit_cost_binder_solvent_NMP         = \t\tUSD  ", unit_cost_binder_solvent_NMP, "/kg")

          println("\n\t\tNegative Electrode")
          println("\t\t\tunit_cost_negative_active_material   = \t\tUSD  ", unit_cost_negative_active_material, "/kg")
          println("\t\t\tunit_cost_carbon_black               = \t\tUSD  ", unit_cost_carbon_black, "/kg")
          println("\t\t\tunit_cost_negative_binder            = \t\tUSD  ", unit_cost_negative_binder, "/kg")

          println("\n\t\tunit_cost_positive_current_collector = \t\tUSD  ", unit_cost_positive_current_collector, "/m2")
          println("\t\tunit_cost_negative_current_collector   = \t\tUSD  ", unit_cost_negative_current_collector, "/m2")
          println("\t\tunit_cost_separator                    = \t\tUSD  ", unit_cost_separator, "/m2")
          println("\t\tunit_cost_electrolyte                  = \t\tUSD  ", unit_cost_electrolyte, "/L")

          println("\n\t\tHardware Costs (dollars/unit)")
          println("\t\t\tunit_cost_positive_terminal          = \t\tUSD  ", unit_cost_positive_terminal, " / unit")
          println("\t\t\tunit_cost_negative_terminal          = \t\tUSD  ", unit_cost_negative_terminal, " / unit")
          println("\t\t\tunit_cost_cell_container             = \t\tUSD  ", unit_cost_cell_container, " / unit")



          println("\n\n************************************************ Cell Materials Costs (USD/cell) ************************************************")
          println("\n\t\tPositive Electrode")
          println("\t\t\tPositive active material                 = ", cost_per_cell_positive_active_material)
          println("\t\t\tConductive                               = ", cost_per_cell_positive_conductive)
          println("\t\t\tcost_per_cell_positive_binder            = ", cost_per_cell_positive_binder)
          println("\t\t\tcost_per_cell_binder_solvent_NMP         = ", cost_per_cell_binder_solvent_NMP)

          println("\n\t\tNegative Electrode")
          println("\t\t\tNegative active material                 = ", cost_per_cell_negative_active_material)
          println("\t\t\tConductive                               = ", cost_per_cell_negative_conductive)
          println("\t\t\tnegative binder                          = ", cost_per_cell_negative_binder)

          println("\n\t\tpositive current collector               = ", cost_per_cell_positive_current_collector)
          println("\t\tnegative current collector                 = ", cost_per_cell_negative_current_collector)
          println("\t\tseparator                                  = ", cost_per_cell_separator)
          println("\t\telectrolyte                                = ", cost_per_cell_electrolyte)

          println("\n\t\tcost_per_cell_positive_terminal_assembly = ", cost_per_cell_positive_terminal_assembly, " / unit")
          println("\t\tcost_per_cell_negative_terminal_assembly   = ", cost_per_cell_negative_terminal_assembly, " / unit")
          println("\t\tcost_per_cell_cell_container               = ", cost_per_cell_cell_container, " / unit")

          println("\n\t\ttotal cost of cell winding materials     = ", total_cost_cell_winding_materials)
          println("\t\ttotal cost of cell materials               = ", total_cost_cell_materials)

          println("\n\n************************************************ Cell Assembly Summary ************************************************")
          print("\n\nTotal direct labor cells only      = ", total_cell_labor)
          print("\n\nTotal plant area cells only        = ", total_cell_pl_area)
          print("\n\nTotal capital equipment cells only = ", total_cell_capital_equip)

    end


    # inputs_to_OEM is given as an input to the function OEM().
    # It is called at the bottom of this file or the before the cost function ends.


    OEM(inputs_to_OEM,breakdown)

end
