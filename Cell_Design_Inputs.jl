#=
  - Julia Version: 1.4.0
  - Author: Alexanders Bills and Abhinav Misalkar
  - Date: 12th May 2020
  - Inputs to the Cell Designer
=#

cathode_info = struct_electrode("NCA",              # Chemistry type

                              0.03,                 # binder weight fraction
                              0.03,                 # conductive weight fraction

                              4.71,                 # AM density
                              1.77,                 # binder density
                              1.77,                 # conductive density

                              192.0,                # first charge specific capacity
                              180.0,                # reversible specific capacity

                              150.0,                # total thickness cathode
                              0.2,                  # porosity

                              0.0,                  # Extra length                                   mm

                              15.0,                 # Pos foil (Al) thickness                      microns
                              2.7,                  # Pos foil (Al) density                         g/cm3

                              7.0,                  # Tab thickness                                microns
                              6.0,                  # Tab width                                      mm
                              8.88,                 # Tab density (Ni)                              g/cm3
                              )


anode_info = struct_electrode("Graphite",           # Chemistry type

                          0.03,                     # binder weight fraction
                          0.03,                     # conductive weight fraction

                          2.24,                     # AM density
                          1.77,                     # binder density
                          1.77,                     # conductive density

                          371.93,                   # first charge specific capacity
                          350.0,                    # reversible specific capacity

                          150.0,                    # total thickness cathode
                          0.3,                      # porosity

                          40.0,                     # Extra length                                   mm

                          8.0,                      # Neg foil (Cu) thickness                      microns
                          8.92,                     # Neg foil (Cu) density                         g/cm3

                          7.0,                      # Tab thickness                                microns
                          6.0,                      # Tab width                                      mm
                          8.88,                     # Tab density (Ni)                              g/cm3
                          )


cell_general = struct_cell_general("Cyl",           # Form factor                           ["Cyl","Pris","Pou"]
                                   "18650",         # Cell size                                    5 digits
                                   0.01,             # dimensional_delta                               %
                                   0.05,             # canister thickness                             (mm)
                                   7.7,             # Stainless Steel density                        g/cm3

                                   20.0,            # Separator thickness                          microns
                                   1.2,             # Separator density                             g/cm3
                                   0.4,             # Separator porosity

                                   3.6,             # Nominal voltage                                 V

                                   "EC:DMC",        # Electrolyte name
                                   1.2,             # Electrolyte density                           g/cm3

                                   1.15,            # N to P ratio


                                   anode_info,      # Anode Struct
                                   cathode_info,    # Cathode Struct
                                   0                # Design Verbosity
                                   )

# cell_general.design_verbosity = 1
# cell_general.cathode.th                         # microns
