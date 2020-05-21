#=
  - Julia Version: 1.4.0
  - Author: Alexanders Bills and Abhinav Misalkar
  - Date: 12th May 2020
  - Inputs to the Cost Model
=#


cathode = struct_electrode_costs([24.0, 0.9],          # Cost of Positive Active Material                       # USD/kg
                               [6.6, 1.0],             # Cost of Positive Conductive                            # USD/kg
                               [9.5, 1.0],             # Cost of Positive Binder                                # USD/kg
                               [3.1, 1.0],             # Cost of Positive Binder Solvent                        # USD/kg
                               [10193620.403506],      # Baseline annual positive active material               # kg/year
                               [13744207.2856261],     # Baseline annual positive binder solvent evaporated     # kg/year
                               [96.0/4.0],             # Multiplier for binder solvent requirement
                               [0.3, 1.0],             # Cost of Positive Current Collector                     # USD/m2
                               [0.15, 0.8],             # Cost of Positive Terminal Assembly                     # USD/cell
                               [0.922],                # Positive Electrode Material (dry) yield
                               [0.902],                # Positive Current Collector yield
                               )


anode = struct_electrode_costs([12.5, 0.95],            # Cost of Negative Active Material                       # USD/kg
                           [6.6, 1.0],                  # Cost of Negative Conductive                            # USD/kg
                           [10.0, 1.0],                 # Cost of Negative Binder                                # USD/kg
                           ########### Negative binder solvent cost - water
                           [0.0, 0.9],                  # !!!!!!!!!!! Check !!!!!!!!!!!!!!!!!
                           [6564082.00851682],          # Baseline annual negative active material                 # kg/year
                           [8291472.01075809],          # Baseline annual negative binder solvent evaporated       # kg/year
                           [96.0/4.0],                  # Multiplier for binder solvent requirement
                           [1.2, 1.0],                  # Cost of Negative Current Collector                     # USD/m2
                           [0.15, 0.8],                 # Cost of Negative Terminal Assembly                     # USD/cell
                           [0.922],                     # Negative Electrode Material (dry) yield
                           [0.902]                      # Negative Current Collector yield
                           )


cell_costs = struct_cell_costs([0.22, 0.8],            # Cost of Cell Canister                                  # USD/cell
                               [1.1, 1.0],             # Cost of Separator                                      # USD/m2
                                0.98,                  # Separator yield
                               [15.0, 1.0],            # Cost of Electrolyte                                    # USD/L
                                0.94,                  # Electrolyte yield
                                0.95,                  # Cell yield
                                cathode,
                                anode
                              )



baseline_cell_assembly_data = struct_manufacturing(
                                            # Receiving
                                            [14400.0 0.4;           # Direct Labor
                                             3.6 0.6;               # Capital Equipment
                                             900.0 0.5;             # Plant Area
                                             1.0 0.0],              # [volume ratio, special case]

                                            # pos_mat_prep
                                            [14400.0 0.5;           # Direct Labor
                                             2.0 0.7;               # Capital Equipment
                                             600.0 0.6;             # Plant Area
                                             2.0 0.0],              # [volume ratio, special case]

                                            # neg_mat_prep
                                            [14400.0 0.5;           # Direct Labor
                                             2.0 0.7;               # Capital Equipment
                                             600.0 0.6;             # Plant Area
                                             3.0 0.0],              # [volume ratio, special case]

                                            # pos_electrode_coat
                                            [28800.0 0.5;           # Direct Labor
                                             8.0 0.8;               # Capital Equipment
                                             750.0 0.8;             # Plant Area
                                             4.0 1.0],              # [volume ratio, special case]

                                            # neg_electrode_coat
                                            [28800.0 0.5;           # Direct Labor
                                             8.0 0.8;               # Capital Equipment
                                             750.0 0.8;             # Plant Area
                                             4.0 1.0],              # [volume ratio, special case]

                                            # bind_slvnt_recov
                                            [14400.0 0.4;           # Direct Labor
                                             3.0 0.6;               # Capital Equipment
                                             225.0 0.6;             # Plant Area
                                             5.0 0.0],              # [volume ratio, special case]

                                            # pos_calendr
                                            [14400.0 0.5;           # Direct Labor
                                             1.0 0.7;               # Capital Equipment
                                             225.0 0.6;             # Plant Area
                                             4.0 0.0],              # [volume ratio, special case]

                                            # neg_calendr
                                            [7200.0 0.5;            # Direct Labor
                                             1.0 0.7;               # Capital Equipment
                                             225.0 0.6;             # Plant Area
                                             4.0 0.0],              # [volume ratio, special case]

                                            # intr_process_mat_handling
                                            [28800.0 0.7;           # Direct Labor
                                             1.5 0.7;               # Capital Equipment
                                             900.0 0.6;             # Plant Area
                                             4.0 0.0],              # [volume ratio, special case]

                                            # electrode_slitting
                                            [28800.0 0.5;           # Direct Labor
                                             2.0 0.7;               # Capital Equipment
                                             300.0 0.6;             # Plant Area
                                             4.0 0.0],              # [volume ratio, special case]

                                            # vacuum_drying
                                            [14400.0 0.5;           # Direct Labor
                                             1.6 0.7;               # Capital Equipment
                                             300.0 0.6;             # Plant Area
                                             4.0 0.0],              # [volume ratio, special case]

                                            # control_lab
                                            [28800.0 0.5;           # Direct Labor
                                             1.5 0.7;               # Capital Equipment
                                             300.0 0.6;             # Plant Area
                                             1.0 0.0],              # [volume ratio, special case]

                                            # cell_winding
                                            [36000.0 0.7;           # Direct Labor
                                             4.0 0.8;               # Capital Equipment
                                             600.0 0.8;             # Plant Area
                                             6.0 2.0],              # [volume ratio, special case]

                                            # CC_welding
                                            [36000.0 0.7;           # Direct Labor
                                             4.0 0.8;               # Capital Equipment
                                             600.0 0.8;             # Plant Area
                                             6.0 0.0],              # [volume ratio, special case]

                                            # cell_insertion_container
                                            [21600.0 0.5;           # Direct Labor
                                             3.0 0.7;               # Capital Equipment
                                             600.0 0.6;             # Plant Area
                                             6.0 0.0],              # [volume ratio, special case]

                                            # electrolyte_filling_and_cell_sealing
                                            [36000.0 0.5;           # Direct Labor
                                             5.0 0.7;               # Capital Equipment
                                             900.0 0.6;             # Plant Area
                                             6.0 0.0],              # [volume ratio, special case]

                                            # dry_room_control
                                            [14400.0 0.4;           # Direct Labor
                                             20.0 0.6;              # Capital Equipment
                                             100.0 0.4;             # Plant Area
                                             7.0 0.0],              # [volume ratio, special case]

                                            # formation_cycling
                                            [57600.0 0.7;           # Direct Labor
                                             30.0 0.8;              # Capital Equipment
                                             2200.0 0.8;            # Plant Area
                                             6.0 2.0],              # [volume ratio, special case]

                                            # cell_sealing
                                            [14400.0 0.5;           # Direct Labor
                                             2.0 0.7;               # Capital Equipment
                                             450.0 0.6;             # Plant Area
                                             6.0 0.0],              # [volume ratio, special case]

                                            # charge_retention_testing
                                            [21600.0 0.4;           # Direct Labor
                                             4.75 0.7;              # Capital Equipment
                                             900.0 0.6;             # Plant Area
                                             6.0 0.0],              # [volume ratio, special case]

                                            # rejected_cell_scrap_recycle_assembly
                                            [36000.0 0.7;           # Direct Labor
                                             2.5 0.7;               # Capital Equipment
                                             600.0 0.6;             # Plant Area
                                             6.0 0.0],              # [volume ratio, special case]

                                            # Shipping
                                            [28800.0 0.5;           # Direct Labor
                                              5.0 0.7;              # Capital Equipment
                                              900.0 0.6;            # Plant Area
                                              1.0 0.0],             # [volume ratio, special case]
                                             )


costs_data = struct_general_costs(
                    715.0,                       # Pack Integration Cost                                  # USD/Pack
                    3000.0,                      # Building cost                                          #  USD/m2
                    18.0,                        # Labor cost                                             # $/hr
                    150.0,                        # No of units mfg per energy_kwh_per_year                Million
                    0.995,                        # Positive Binder Solvent Recovery percentage
                    baseline_cell_assembly_data,
                    1.1,                         # formation_cycling_mult
                    1.1,                         # cell_stacking_mult
                    0.2,                         # pos_electrode_coating_solvent_SR
                    0.2                          # neg_electrode_coating_solvent_SR
                  )


baseline_data = struct_baseline(6000000.0,               # Baseline annual energy                                   # kWh/year
                                25263158.0,              # Baseline annual cells adjusted for yield                 # cells/year
                                67669329.6866343,        # Baseline annual electrode area                           # m2/year
                                6100.0,                  # Baseline annual dry room area required

                         )


battery_pack_data = struct_pack_level(240.0,             # No of cells per pack

                                )





ovhd_rate_data = struct_ovhd_rate(5.0 / 100.0,        # Launch cost percent direct annual materials
                    10.0 / 100.0,                     # Launch cost percent direct labor plus variable overhead
                    16.666667/100.0,                  # Depreciation rate capital equipment                          # 6-year rate
                    5.0 / 100.0 ,                     # Depreciation rate building investment                        # 20 year rate
                    25.0 / 100.0,                     # General, Sales and Administration rate direct labor plus variable overhead
                    25.0 / 100.0,                     # General, Sales and Administration rate depreciation
                    40.0 / 100.0,                     # R & D rate depreciation
                    40.0 / 100.0,                     # Variable overhead rate direct labor
                    20.0 / 100.0,                     # Variable overhead rate depreciation
                    5.0 / 100.0,                      # Profit rate after taxes                                      # % of investment
                    15.0 / 100.0,                     # Working capital rate                                         # % of annual variable cost
                    5.6 / 100.0                       # Warranty cost added to the price rate
                   )



cost = struct_cost(cell_costs,
                   baseline_cell_assembly_data,
                   costs_data,
                   baseline_data,
                   ovhd_rate_data
                   )
