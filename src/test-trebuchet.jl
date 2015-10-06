include("Trebuchet.jl")

using Trebuchet

trebuchet = Trebuchet.SeeSawTrebuchet(1.0, 90.0, 0.5, 2.0, sqrt(2))

solution = Trebuchet.solve(trebuchet)

using Gadfly

plot(layer(x = solution[:time], y = solution[:theta], Geom.line(), Theme(default_color = colorant"black")),
    layer(x = solution[:time], y = solution[:thetadot], Geom.line()),
    Guide.xlabel("Time"),
    Guide.ylabel(""),
    Guide.title("Angular Displacement and Velocity of a Seesaw Trebuchet"))


