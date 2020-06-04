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
                            1000.0,
                            1000.0,
                            1000.0,
                            1000.0,

                            10000.0,
                            10000.0,

                            10.0,
                            10.0,

                            10000.0,
                            10000.0,

                            10000.0,
                            10000.0,

                            10.0,
                            10.0,

                            10000.0,

                            #---------------------------------------------------------#

                            1000.0,
                            1000.0,
                            1000.0,
                            10000.0,
                            10000.0,
                            10000.0,
                            1000.0,
                            10000.0,

                            #---------------------------------------------------------#

                            1/1000000.0
                        )



function converter(initial_value,mult)
   return initial_value ./ mult
end


function convert_all(cell_general, cost, mult)
   cell_general.cathode.fc_sp_cap =
      converter(cell_general.cathode.fc_sp_cap, mult.fc_pos_sp_cap)
   cell_general.anode.fc_sp_cap =
      converter(cell_general.anode.fc_sp_cap, mult.fc_neg_sp_cap)
   cell_general.cathode.rev_sp_cap =
      converter(cell_general.cathode.rev_sp_cap, mult.rev_pos_sp_cap)
   cell_general.anode.rev_sp_cap =
      converter(cell_general.anode.rev_sp_cap, mult.rev_neg_sp_cap)

   cell_general.cathode.th = converter(cell_general.cathode.th, mult.pos_th)
   cell_general.anode.th = converter(cell_general.anode.th, mult.neg_th)

   cell_general.cathode.extra_length =
      converter(cell_general.cathode.extra_length, mult.pos_extra_l)
   cell_general.anode.extra_length =
      converter(cell_general.anode.extra_length, mult.neg_extra_l)

   cell_general.cathode.CC_th =
      converter(cell_general.cathode.CC_th, mult.pos_CC_th)
   cell_general.anode.CC_th =
      converter(cell_general.anode.CC_th, mult.neg_CC_th)

   cell_general.cathode.tab_th =
      converter(cell_general.cathode.tab_th, mult.pos_tab_t)
   cell_general.anode.tab_th =
      converter(cell_general.anode.tab_th, mult.neg_tab_t)

   cell_general.cathode.tab_width =
      converter(cell_general.cathode.tab_width, mult.pos_tab_width)
   cell_general.anode.tab_width =
      converter(cell_general.anode.tab_width, mult.neg_tab_width)

   cell_general.sep_th = converter(cell_general.sep_th, mult.sep_th)

   cost.general_costs.no_units_mfg =
      converter(cost.general_costs.no_units_mfg, mult.units_mfg)
   return cell_general, cost
end
