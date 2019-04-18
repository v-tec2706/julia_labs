using DifferentialEquations
using ParameterizedFunctions
using DataFrames
using CSV
#using Plots
using RDatasets
using Gadfly
#using Winston

function lorentzVolterr(du,u,p,t)
 du[1] = (p[1]-p[2]*u[2])*u[1]
 du[2] = (p[3]*u[1]-p[4])*u[2]
end
function findSolution(a::Float64,b::Float64,c::Float64,d::Float64,x_init::Float64,y_init::Float64,id::Int64)

    u0 = [x_init,y_init]
    tspan = (0.0,10.0)
    p = [a,b,c,d]
    prob = ODEProblem(lorentzVolterr,u0,tspan,p)
    sol = solve(prob,RK4(),dt = 0.01)  # dt - step size

    fname = "./experiment" * string(id) * ".csv"
    csvfile = open(fname, "w")
    write(csvfile, "t, x, y, experiment\n")
    i=1
    for (u,t) in tuples(sol)
        tup(i)=tuple(sol.t[i],sol.u[i][1],sol.u[i][2],id)
        write(csvfile, join(tup(i),","), "\n")
        i+=1
    end
    close(csvfile)

end

function experiments()
    for i=1:4
        findSolution(rand(),rand(),rand(),rand(),rand(),rand(),i)
    end
    mydata=CSV.read("./experiment1.csv")
    for i=2:4
        input = "./experiment" * string(i) * ".csv"
        mydata2=CSV.read(input)
        append!(mydata, mydata2)
    end

    println("Prey")

for i=1:4
        println("Experiment: "*string(i)*" max:" * string(maximum(mydata[mydata[:experiment] .== i, :x]))*", min"*string(minimum(mydata[mydata[:experiment] .== i, :x]))*", mean "*string(mean(mydata[mydata[:experiment] .== i, :x])))
    end
    println("Predators")

    for i=1:4
        println("Experiment: "*string(i)*" max:" * string(maximum(mydata[mydata[:experiment] .== i, :y]))*", min"*string(minimum(mydata[mydata[:experiment] .== i, :y]))*", mean "*string(mean(mydata[mydata[:experiment] .== i, :y])))
    end
    mydata[:difference] = abs.(mydata[:x] - mydata[:y])

println(mydata)
#for i=1:4
    p = Array{Plot}(8)
    set_default_plot_size(42cm, 25cm)
    for i=1:4
#i=1
        input = "./experiment" * string(i) * ".csv"
        mydata2=CSV.read(input)
        p[i]=plot(mydata2,y=:x, x=:t, Geom.point, Geom.line, Guide.title("Exp:"*string(i)*" Prey"))
        p[i+4]=plot(mydata2,x=:t, y=:y, Geom.point, Geom.line, Guide.title("Exp:"*string(i)*" Predators"))
    end
        p = hstack(p[1],p[5],p[2],p[6],p[3],p[7],p[4],p[8])

end

function draw()
    set_default_plot_size(42cm, 25cm)


        mydata1=CSV.read("./experiment1.csv")
        mydata2=CSV.read("./experiment2.csv")
        mydata3=CSV.read("./experiment3.csv")
        mydata4=CSV.read("./experiment4.csv")
        plot(
              layer(x=mydata1[:x], y=mydata1[:y], color=[colorant"orange"],Geom.point, Geom.line),
              layer(x=mydata2[:x], y=mydata2[:y], color=[colorant"blue"],Geom.point),
              layer(x=mydata3[:x], y=mydata3[:y], color=[colorant"red"],Geom.point),
              layer(x=mydata4[:x], y=mydata4[:y], color=[colorant"green"],Geom.point),
              Guide.xlabel("Pray"),
              Guide.ylabel("Predator"),
              Guide.title("Phase-space plot"))

end
