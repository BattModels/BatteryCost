#=
    - Julia Version : 1.4.0
    - Author        : Alexander Bills and Abhinav Misalkar
    - Date          : 14th May 2020
    - Title         : Unit Converter
=#

struct unit_conversion

 ################################################### Design Input Unit Conversion ###################################################

    fc_pos_sp_cap           # mAh/g --> Ah/g
    fc_neg_sp_cap           # mAh/g --> Ah/g
    rev_pos_sp_cap          # mAh/g --> Ah/g
    rev_neg_sp_cap          # mAh/g --> Ah/g

    pos_th                  # microns --> cm
    neg_th                  # microns --> cm

    pos_extra_l             # mm --> cm
    neg_extra_l             # mm --> cm

    pos_CC_th               # microns --> cm
    neg_CC_th               # microns --> cm

    pos_tab_t               # microsn --> cm
    neg_tab_t               # microsn --> cm

    pos_tab_width           # mm --> cm
    neg_tab_width           # mm --> cm

    sep_th                  # microns --> cm


 ################################################### Design Output Unit Conversion ###################################################

    energy_cell                  #  Wh   -->   kWh

    mass_pos_AM                  #  g    -->   kg
    mass_neg_AM                  #  g    -->   kg

    pos_CC_area                  #  cm2  -->   m2
    neg_CC_area                  #  cm2  -->   m2

    sep_area                     #  cm2  -->   m2

    electrolyte_volm             #  mL   -->   L

    total_coated_area_cathode    #  cm2  -->   m2

 ################################################### Cost Input Unit Conversion ###################################################

    units_mfg               # unit to million units


end

mult = unit_conversion(
                            [cell_general.cathode.fc_sp_cap            1000.0        1],
                            [cell_general.anode.fc_sp_cap              1000.0        1],
                            [cell_general.cathode.rev_sp_cap           1000.0        1],
                            [cell_general.anode.rev_sp_cap             1000.0        1],

                            [cell_general.cathode.th                   10000.0       1],
                            [cell_general.anode.th                     10000.0       1],

                            [cell_general.cathode.extra_length         10.0          1],
                            [cell_general.anode.extra_length           10.0          1],

                            [cell_general.cathode.CC_th                10000.0       1],
                            [cell_general.anode.CC_th                  10000.0       1],

                            [cell_general.cathode.tab_th               10000.0       1],
                            [cell_general.anode.tab_th                 10000.0       1],

                            [cell_general.cathode.tab_width            10.0          1],
                            [cell_general.anode.tab_width              10.0          1],

                            [cell_general.sep_th                       10000.0       1],

                            #---------------------------------------------------------#

                            [cell_design_op.energy                      1000.0       1],
                            [cell_design_op.mass_cathode_AM             1000.0       1],
                            [cell_design_op.mass_anode_AM               1000.0       1],
                            [cell_design_op.pos_CC_area                 10000.0      1],
                            [cell_design_op.neg_CC_area                 10000.0      1],
                            [cell_design_op.sep_area                    10000.0      1],
                            [cell_design_op.electrolyte_volm            1000.0       1],
                            [cell_design_op.total_coated_area_cathode   10000.0      1],

                            #---------------------------------------------------------#

                            [cost.general_costs.no_units_mfg            1000000.0    0]
                        )


function converter(inp)

      if inp[3] == 1
         inp[1] = inp[1] / inp[2]

      elseif inp[3] == 0
         inp[1] = inp[1] * inp[2]

      end

   return inp[1]
end


# parameters_to_be_converted = fieldnames(unit_conversion)

# for parameter in parameters_to_be_converted
#           converter([cell_general.cathode.fc_sp_cap    , mult.fc_pos_sp_cap[2]  , mult.fc_pos_sp_cap[3]])
# end




cell_general.cathode.fc_sp_cap    = converter([cell_general.cathode.fc_sp_cap    , mult.fc_pos_sp_cap[2]  , mult.fc_pos_sp_cap[3]])
cell_general.anode.fc_sp_cap      = converter([cell_general.anode.fc_sp_cap      , mult.fc_neg_sp_cap[2]  , mult.fc_neg_sp_cap[3]])
cell_general.cathode.rev_sp_cap   = converter([cell_general.cathode.rev_sp_cap   , mult.rev_pos_sp_cap[2] , mult.rev_pos_sp_cap[3]])
cell_general.anode.rev_sp_cap     = converter([cell_general.anode.rev_sp_cap     , mult.rev_neg_sp_cap[2] , mult.rev_neg_sp_cap[3]])

cell_general.cathode.th           = converter([cell_general.cathode.th           , mult.pos_th[2]         , mult.pos_th[3]])
cell_general.anode.th             = converter([cell_general.anode.th             , mult.neg_th[2]         , mult.neg_th[3]])

cell_general.cathode.extra_length = converter([cell_general.cathode.extra_length , mult.pos_extra_l[2]    , mult.pos_extra_l[3]])
cell_general.anode.extra_length   = converter([cell_general.anode.extra_length   , mult.neg_extra_l[2]    , mult.neg_extra_l[3]])

cell_general.cathode.CC_th        = converter([cell_general.cathode.CC_th        , mult.pos_CC_th[2]      , mult.pos_CC_th[3]])
cell_general.anode.CC_th          = converter([cell_general.anode.CC_th          , mult.neg_CC_th[2]      , mult.neg_CC_th[3]])

cell_general.cathode.tab_th       = converter([cell_general.cathode.tab_th       , mult.pos_tab_t[2]      , mult.pos_tab_t[3]])
cell_general.anode.tab_th         = converter([cell_general.anode.tab_th         , mult.neg_tab_t[2]      , mult.neg_tab_t[3]])

cell_general.cathode.tab_width    = converter([cell_general.cathode.tab_width    , mult.pos_tab_width[2]  , mult.pos_tab_width[3]])
cell_general.anode.tab_width      = converter([cell_general.anode.tab_width      , mult.neg_tab_width[2]  , mult.neg_tab_width[3]])

cell_general.sep_th               = converter([cell_general.sep_th               , mult.sep_th[2]         , mult.sep_th[3]])

cost.general_costs.no_units_mfg   = converter([cost.general_costs.no_units_mfg   , mult.units_mfg[2]      , mult.units_mfg[3]])
