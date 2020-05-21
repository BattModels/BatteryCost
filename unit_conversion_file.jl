
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
