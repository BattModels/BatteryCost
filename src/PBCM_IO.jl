function readcell(cell_filename)
    cellstring = open(cell_filename,"r") do f
        cellstring = read(f,String)
    end

    cell_object = JSON2.read(cellstring,struct_cell_general)

    return cell_object
end


function writecell(cell_filename,cell)
    cellstring = JSON2.write(cell)

    return_code = open(cell_filename,"w") do f
        write(f,cellstring)
    end

    return return_code
end
