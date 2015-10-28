include("Trebuchet.jl")

using Trebuchet

# trebuchet = Trebuchet.SeeSawTrebuchet(1.0, 90.0, 0.5, 2.0, sqrt(2))
L1 = 3.0
L2 = 10.0
M = 1000
m = 10

trebuchet = Trebuchet.SeeSawTrebuchet(M, m, L1, L2, L2 * cos(pi/4))

solution = Trebuchet.solve(trebuchet)

using Gadfly

plot(x = solution[:theta] / pi * 180, y = solution[:speed], Geom.line(), Theme(default_color = colorant"black"),
    Guide.xlabel("Theta"),
    Guide.ylabel("Projectile Speed [m/s]"))

plot(x = solution[:theta] / pi * 180, y = solution[:range], Geom.line(),
    Guide.xlabel("Theta"),
    Guide.ylabel("Projectile Range [m]"))

# Convert columns to degrees.
#
solution[:theta] /= (pi / 180);
solution[:thetadot] /= (pi / 180);
solution[:psi] /= (pi / 180);

writetable("seesaw-solution.csv", solution)

# =====================================================================================================================

# "Trebuchet Mechanics" considers a Seesaw Trebuchet with M = 100 lb, m = 1 lb, L1 = 1 ft and L2 = 4 ft. The optimal
# range of 38.4 ft is obtained for a release angle of 38.0°.

# =====================================================================================================================

# Ross's Trebuchet.
#
# m = 5 g
# M = 180 g
# L1 = 71 mm
# L2 = 147 mm

# =====================================================================================================================

# Projectiles to consider:
#
# - golf ball (mass: 46 g)
# - pumpkin (mass: 4 kg)
# - cow (mass: 1000 kg)
