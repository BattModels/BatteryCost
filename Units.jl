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



function converter(inp)

      if inp[3] == 1
         inp[1] = inp[1] / inp[2]

      elseif inp[3] == 0
         inp[1] = inp[1] * inp[2]

      end

   return inp[1]
end
