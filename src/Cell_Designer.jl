#=
  - Julia Version : 1.4.0
  - Author        : Alexander Bills and Abhinav Misalkar
  - Date          : 14th May 2020
  - Title         : Cylindrical Cell Designer
=#


mutable struct struct_electrode
       chem::String                                   # Chemistry type


       bind_wt_fr::Float64                            # binder weight fraction
       cond_wt_fr::Float64                            # conductive weight fraction

       AM_rho::Float64                                # AM density                                      g/cm3
       bind_rho::Float64                              # binder density                                  g/cm3
       cond_rho::Float64                              # conductive density                              g/cm3

       fc_sp_cap::Float64                             # first charge specific capacity                  mAh/g   --> Ah/g
       rev_sp_cap::Float64                            # reversible specific capacity                    mAh/g   --> Ah/g

       th::Float64                                    # total thickness cathode                       microns   --> cm
       por::Float64                                   # porosity

       extra_length::Float64                          # extra length                                     mm     --> cm

       CC_th::Float64                                 # Current Collector Thickness                   microns   --> cm
       CC_rho::Float64                                # Current Collector                               g/cm3

       tab_th::Float64                                # Tab thickness
       tab_width::Float64                             # Tab width
       tab_rho::Float64                               # Tab Density
end


mutable struct struct_cell_general
    form_factor::String              # ["Cyl","Pris","Pou"]
    size::String                     # ["18650", "21700", etc]
    dimensional_delta::Float64
    can_th::Float64
    can_rho::Float64

    sep_th::Float64
    sep_rho::Float64
    sep_por::Float64

    nom_volt::Float64

    electrolyte_type::String
    electrolyte_rho::Float64

    N_P_ratio::Float64               # N to P ratio


    anode::struct_electrode
    cathode::struct_electrode
end


mutable struct struct_cell_design_op
    rev_cap::Float64
    energy::Float64
    mass_cathode_AM::Float64
    mass_anode_AM::Float64
    pos_CC_area::Float64
    neg_CC_area::Float64
    sep_area::Float64
    electrolyte_volm::Float64
    mass_tab::Float64
    mass_of_cannister::Float64
    total_coated_area_cathode::Float64
    pos_AM_wt_fr::Float64
    neg_AM_wt_fr::Float64
end


function electrode_geometry(electrode, volm_jellyroll, jellyroll_length, height_jellyroll)
    # Calculate Eletrode Geometry Characteristics
    # Calculate Weight Fraction

    AM_wt_fr = 1 - electrode.bind_wt_fr - electrode.cond_wt_fr

    dry_electrode_density  = (1 - electrode.por) * electrode.AM_rho                             # g/cm3

    single_side_coating_thickness = (electrode.th - electrode.CC_th) / 2.0                      # microns  --> cm2          - done

    mass_loading  = (dry_electrode_density  *  single_side_coating_thickness) #/ 10.0           # mg/cm2   --> g/cm2        - done

    capacity_loading = (mass_loading  *   electrode.rev_sp_cap) #/ 1000.0                       # mAh/cm2  --> Ah/cm2       - done

    length_electrode = jellyroll_length + electrode.extra_length                                # mm --> cm                 - done

    total_coated_length_electrode = 2 * length_electrode                                        # mm --> cm - done
    total_coated_area   = height_jellyroll * total_coated_length_electrode                      # cm2


    volm_electrode =  (total_coated_length_electrode ) *                                        # cm3
                      (single_side_coating_thickness) *
                      height_jellyroll

    mass_AM = volm_electrode * dry_electrode_density * AM_wt_fr                                 # grams

    mass_electrode    = volm_electrode * dry_electrode_density                                  # grams

    volm_electrode_AM = mass_AM / electrode.AM_rho                                              # cm3

    mass_electrode_bind = (mass_AM / AM_wt_fr) * electrode.bind_wt_fr                           # grams
    mass_electrode_cond = (mass_AM / AM_wt_fr) * electrode.cond_wt_fr                           # grams

    volm_bind  =  mass_electrode_bind * electrode.bind_rho                                      # cm3
    volm_cond  =  mass_electrode_cond * electrode.cond_rho                                      # cm3

    return electrode, mass_AM, capacity_loading, dry_electrode_density,
    single_side_coating_thickness, mass_electrode, total_coated_area,
    mass_electrode_bind, AM_wt_fr, total_coated_length_electrode,
    mass_loading, volm_electrode

end


function CC_geometry(electrode, jellyroll_length, height_jellyroll)
    CC_length = jellyroll_length + electrode.extra_length                                       # mm --> cm - done
    CC_area = (CC_length) * height_jellyroll                                                    # cm2 --> done
    CC_volm = CC_area * (electrode.CC_th)                                                       # cm3 --> done
    CC_mass = CC_volm * electrode.CC_rho                                                        # grams --> done
    return CC_mass, CC_area
end


function np_designer(electrode,capacity_loading)
    mass_loading = (capacity_loading) / (electrode.rev_sp_cap)                                  # mg/cm2 --> g/cm2
    single_side_coating_thickness = (electrode.th - electrode.CC_th) / 2.0                      # microns --> cm
    dry_electrode_density = (mass_loading) / (single_side_coating_thickness)                    # g/cm3
    electrode.por = 1 - (dry_electrode_density / electrode.AM_rho)
    return electrode
end

function anode_free_designer(cell;verbosity=0)
    cathode = cell.cathode

    external_height_of_cell = (parse(Float64, SubString(cell.size, 3:4)))/10.0 #note that these are in mm
    
    external_width_of_cell = (parse(Float64, SubString(cell.size, 1:2)))/10.0 #in mm
    cell_area = external_width_of_cell*external_height_of_cell
    cathode_coating_thickness = cell.cathode.th-cell.cathode.CC_th
    cathode = cell.cathode
    mass_cathode_AM = cathode.AM_rho*(1-cathode.bind_wt_fr-cathode.cond_wt_fr)*(1-cathode.por)*cathode_coating_thickness*cell_area
    mass_anode_AM = 0.0
    pos_CC_area = deepcopy(cell_area)
    neg_CC_area = deepcopy(pos_CC_area)
    sep_area = deepcopy(pos_CC_area)
    electrolyte_volm_cathode = cathode.por*cell_area
    electrolyte_volm_sep = cell.sep_por*cell.sep_th*cell_area
    electrolyte_volm = electrolyte_volm_cathode+electrolyte_volm_sep
    mass_tab = 0.
    mass_of_cannister = 0.
    total_coated_area_cathode = cell_area
    pos_AM_wt_fr = 0.
    neg_AM_wt_fr = 0.0
    reversible_capacity = cathode.rev_sp_cap*mass_cathode_AM
    energy = reversible_capacity*cell.nom_volt                          # Ah

    energy_cell = reversible_capacity * cell.nom_volt

    return struct_cell_design_op(
        reversible_capacity,
        energy_cell,
        mass_cathode_AM,
        mass_anode_AM,
        pos_CC_area,
        neg_CC_area,
        sep_area,
        electrolyte_volm,
        mass_tab,
        mass_of_cannister,
        total_coated_area_cathode,
        pos_AM_wt_fr,
        neg_AM_wt_fr
    )



end

function cylindrical_cell_designer(cell;verbosity=0)
    cathode = cell.cathode
    anode = cell.anode

                    ###################################### Cell Parameters #####################################

    external_height_of_cell = (parse(Float64, SubString(cell.size, 3:4)))/10.0                              # mm --> cm - done
    internal_height_of_cell = external_height_of_cell * (1 - (cell.dimensional_delta))                      #  cm - done

    external_radius_of_cell = (parse(Float64, SubString(cell.size, 1:2))/2)/10.0                           # mm --> cm - done
    internal_radius_of_cell = (external_radius_of_cell - cell.can_th)                                       # mm --> cm - done

    external_radius_of_jellyroll = internal_radius_of_cell * (1 - (cell.dimensional_delta))                 # mm --> cm - done

    internal_radius_of_jellyroll = external_radius_of_cell/3.0                                              # mm --> cm - done
    height_jellyroll = internal_height_of_cell                                                              # cm

    height_of_tab = height_jellyroll                                                                        # cm




    volm_jellyroll =
        π *(external_radius_of_jellyroll^2 - internal_radius_of_jellyroll^2) *
        (height_jellyroll)                                                                                  # mm3 --> cm3 - done

    # print("\nvolm_jellyroll = ", volm_jellyroll, " cm3")

    single_side_anode_coating_thickness = (cell.anode.th - cell.anode.CC_th) / 2.0                          # microns --> cm - done

    single_side_cathode_coating_thickness = (cell.cathode.th - cell.cathode.CC_th) / 2.0                    # microns --> cm - done

    # print("\nsingle_side_anode_coating_thickness = ", single_side_anode_coating_thickness, " cm")
    # print("\nsingle_side_cathode_coating_thickness = ", single_side_cathode_coating_thickness, " cm")
    # print("\nheight_jellyroll = ", height_jellyroll, " cm")


    jellyroll_length =                                                                                      # mm --> cm  - done
        (volm_jellyroll) / ((height_jellyroll ) *
               (
                2 * (single_side_anode_coating_thickness ) +
                2 * (single_side_cathode_coating_thickness ) +
                (cell.cathode.CC_th ) +
                (cell.anode.CC_th ) +
                2 * (cell.sep_th )))

    # print("\njellyroll_length = ",jellyroll_length, " cm")

                        ###################################### Volume and Mass #####################################

   pos_electrode, mass_pos_AM, pos_capacity_loading, pos_dry_electrode_density,
   pos_single_side_coating_thickness, mass_pos_electrode, total_coated_area_cathode,
   mass_pos_bind, pos_AM_wt_fr, total_coated_length_cathode, pos_mass_loading,
   volm_pos_electrode = electrode_geometry(cathode, volm_jellyroll, jellyroll_length, height_jellyroll)

   anode_capacity_loading = cell.N_P_ratio * pos_capacity_loading                                             #  mAh/cm2

   anode = np_designer(anode,anode_capacity_loading)


   neg_electrode, mass_neg_AM, neg_capacity_loading, neg_dry_electrode_density,
   neg_single_side_coating_thickness, mass_neg_electrode, total_coated_area_anode,
   mass_neg_bind, neg_AM_wt_fr, total_coated_length_anode, neg_mass_loading,
   volm_neg_electrode  = electrode_geometry(anode,volm_jellyroll, jellyroll_length,height_jellyroll)

   if cell.cathode.por > 1 || cell.cathode.por < 0
        # print(cell.cathode.por)
       @error "Invalid cathode porosity value"
   end

    if cell.anode.por > 1 || cell.anode.por < 0
        print("\n1. Neg por",cell.anode.por)
       @error "Invalid anode porosity value"
   end

    sep_area = 2*(jellyroll_length + max(cathode.extra_length, anode.extra_length)) *                         # cm2
                height_jellyroll

    separator_volm = sep_area * (cell.sep_th)                                                                 # cm3

    separator_mass = separator_volm * cell.sep_rho * (1 - cell.sep_por)                                       # grams

    pos_CC_mass, pos_CC_area = CC_geometry(cathode, jellyroll_length, height_jellyroll)                       # grams, cm2
    neg_CC_mass, neg_CC_area = CC_geometry(anode,   jellyroll_length, height_jellyroll)                       # grams, cm2

    electrolyte_volm =
           (total_coated_area_cathode * ((cell.cathode.th - cell.cathode.CC_th)))* cell.cathode.por +
           (total_coated_area_anode   * ((cell.anode.th - cell.anode.CC_th)/2.0)) * cell.anode.por +
           2* sep_area * (cell.sep_th) * (cell.sep_por)                                                       # cm3

    electrolyte_mass = electrolyte_volm * cell.electrolyte_rho                                        # grams


    volume_canister_material = pi * (
        (((external_radius_of_cell)^2.0) * (external_height_of_cell))   -
        (((internal_radius_of_cell)^2.0) * (internal_height_of_cell)) )                                       # cm3



    mass_of_cannister = volume_canister_material * cell.can_rho                                       # grams


    mass_tab = cathode.tab_rho * (cathode.tab_th) * (height_of_tab) * (cathode.tab_width)                     # grams


    electrode_area = (mass_pos_electrode / pos_dry_electrode_density) / (pos_single_side_coating_thickness)   # cm2

    total_cell_mass =                                                                                          # grams
        mass_pos_AM +
        mass_neg_AM +
        separator_mass +
        electrolyte_mass +
        mass_pos_bind +
        mass_neg_bind +
        pos_CC_mass +
        neg_CC_mass +
        2 * mass_tab +
        mass_of_cannister



                        ###################################### Performance #####################################

    first_charge_capacity_cathode = (mass_pos_AM * cell.cathode.fc_sp_cap)                             # Ah
    first_charge_capacity_anode   = (mass_neg_AM * cell.anode.fc_sp_cap)                               # Ah

    reversible_capacity_cathode = (mass_pos_AM * cell.cathode.rev_sp_cap)                              # Ah
    reversible_capacity_anode   = (mass_neg_AM * cell.anode.rev_sp_cap)                                # Ah

    reversible_capacity = min(reversible_capacity_anode, reversible_capacity_cathode)                           # Ah

    energy_cell = reversible_capacity * cell.nom_volt                                                   # Wh


                        ###################################### Verbosity #####################################

    if verbosity == 1
        print("\n")
        print("\n\n\n******************************** \t\t\t\t\t\t\t\tDesign Report \t\t\t\t\t\t\t\t********************************")

        print("\n\n\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t  Cathode\t\t\t\t\t  Anode ")
        print("\n\n\tTotal Coated Length (cm)                   = \t\t\t",total_coated_length_cathode,"\t\t\t",total_coated_length_anode,)
        print("\n\n\tTotal Coated Area (cm2)                    = \t\t\t",total_coated_area_cathode,"\t\t\t",total_coated_area_anode,)
        print("\n\n\tPorosity                                   = \t\t\t\t",cell.cathode.por,"\t\t\t\t\t\t\t",cell.anode.por,)
        print("\n\n\tCapacity_loading (Ah/cm2)                  = \t\t\t\t",pos_capacity_loading,"\t\t\t\t",neg_capacity_loading,)
        print("\n\n\tMass_loading (g/cm2)                       = \t\t\t",pos_mass_loading,"\t\t\t\t\t",neg_mass_loading,)
        print("\n\n\tDry_electrode_density (g/cm3)              = \t\t\t",pos_dry_electrode_density,"\t\t\t",neg_dry_electrode_density,)
        print("\n\n\tActive Material Used (g)                   = \t\t\t",mass_pos_AM,"\t\t\t",mass_neg_AM,)
        print("\n\n\tMass of Electrode (g)                      = \t\t\t",mass_pos_electrode,"\t\t\t",mass_neg_electrode,)
        print("\n\n\tFirst Charge Capacity (Ah)                 = \t\t\t",first_charge_capacity_cathode,"\t\t\t",first_charge_capacity_anode,)
        print("\n\n\tReversible Capacity (Ah)                   = \t\t\t",reversible_capacity_cathode,"\t\t\t",reversible_capacity_anode,)


        print("\n\n\n******************************** \t\t\t\t\t\t\t\tCell Sizing \t\t\t\t\t\t\t\t********************************")
        print("\n\n\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tWeight (g)\t\t\t\t  Volume(mL)")
        print("\n\n\tCathode Active Material                    = \t\t\t",mass_pos_AM)  #,"\t\t\t",volm_cathode_AM,)
        print("\n\n\tAnode Active Material                      = \t\t\t",mass_neg_AM)  #,"\t\t\t\t",volm_anode_AM,)
        print("\n\n\tSeparator                                  = \t\t\t",separator_mass)   #,"\t\t\t",separator_volm,)
        print("\n\n\tElectrolyte                                = \t\t\t",electrolyte_mass) #,"\t\t\t",electrolyte_volm,)
        print("\n\n\tCathode Electrode Binder                   = \t\t\t",mass_pos_bind)    #,"\t\t\t",volm_pos_bind,)
        print("\n\n\tAnode Electrode Binder                     = \t\t\t",mass_neg_bind)    #,"\t\t\t",volm_neg_bind,)
        print("\n\n\tCathode Current Collector                  = \t\t\t",pos_CC_mass)  #,"\t\t\t",pos_CC_volm,)
        print("\n\n\tAnode Current Collector                    = \t\t\t",neg_CC_mass)  #,"\t\t\t",neg_CC_volm,)
        print("\n\n\tcannister                                  = \t\t\t",mass_of_cannister)    #,"\t\t\t",volume_canister_material,)


        print("\n\n\n******************************** \t\t\t\t\t\t\t\tCell Specs \t\t\t\t\t\t\t\t********************************")
        print("\n\n\tCell Mass (g)                              = \t\t\t\t",total_cell_mass,)
        print("\n\n\tCell Energy (Wh)                           = \t\t\t\t",energy_cell,)
        print("\n\n\tSeparator Area (cm2)                       = \t\t\t\t",sep_area,)
        print("\n\n\tSeparator Area (m2)                        = \t\t\t\t",sep_area/10000,)
        print("\n\n\tMass of each Tab (g)                       = \t\t\t\t",mass_tab,)
        print("\n\n\tBATPAC_electrode_area (cm2)                = \t\t\t\t",electrode_area,)

        print("\n\n\n******************************** \t\t\t\t\t\t\t\tOther Details \t\t\t\t\t\t\t\t********************************")
        print("\n\n\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t  Cathode\t\t\t\t\t\t  Anode ")
        print("\n\n\n\tSingle_side_coating_thickness (microns)  = \t\t\t\t\t\t",single_side_cathode_coating_thickness,"\t\t\t\t\t\t\t",single_side_anode_coating_thickness,)
        print("\n\n\tElectrode Thickness (microns)              = \t\t\t\t\t",cell.cathode.th,"\t\t\t\t\t\t\t",cell.anode.th,)
        print("\n\n\tElectrode Volume (cm3)                     = \t\t\t\t\t",volm_pos_electrode,"\t\t\t",volm_neg_electrode,)
        print("\n\n\tCurrent Collector Area (cm2)               = \t\t\t\t\t",pos_CC_area,"\t\t\t",neg_CC_area,)
        print("\n\n\tCurrent Collector Area (m2)                = \t\t\t\t\t",pos_CC_area/10000,"\t\t",neg_CC_area/10000,)

        print("\n")
    end



    cell_design_op = struct_cell_design_op(reversible_capacity_cathode,
                                             energy_cell,                       # kWh
                                             mass_pos_AM,                       # kg
                                             mass_neg_AM,                       # kg
                                             pos_CC_area,                       # m2
                                             neg_CC_area,                       # m2
                                             sep_area,                          # m2
                                             electrolyte_volm,                  # L
                                             mass_tab,
                                             mass_of_cannister,
                                             total_coated_area_cathode,         # m2
                                             pos_AM_wt_fr,
                                             neg_AM_wt_fr
                                             )


    return cell_design_op
end
