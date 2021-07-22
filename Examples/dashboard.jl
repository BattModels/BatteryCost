#First try: Just going to allow users to edit cell parameters

using Makie

AbstractPlotting.inline!(false)
fig = Figure(resolution=(1200,1200))
phsl = Slider(fig[2,1],range=0.01:.01:2π)
phlabel = Label(fig[2,2],text="Phase")
frsl = Slider(fig[3,1],range=0.01:.01:20π)
frlabel = Label(fig[3,2],text="Frequency")
ph = phsl.value
fr = frsl.value
frfr = lift(ph,fr) do ph,fr
    tot=ph+fr
    frfr=fr/tot
    return frfr
end
phfr = lift(ph,fr) do ph,fr
    tot=ph+fr
    phfr=ph/tot
    return phfr
end

thing = lift(phfr,frfr) do phfr,frfr
    thing = [phfr,frfr]
end

p = pie(fig[1,1],thing,color=[:red,:blue])

elem_5 = PolyElement(color = :red, strokecolor = :black,
        polypoints = Point2f0[(0, 0), (1, 0), (1, 1),(0,1)])
elem_6 = PolyElement(color = :blue, strokecolor = :black,
        polypoints = Point2f0[(0, 0), (1, 0), (1, 1),(0,1)])

Legend(fig[1,2],
        [elem_5,elem_6],
        ["g", "Pa"],
        patchsize = (35, 35))