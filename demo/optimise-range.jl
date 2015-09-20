using NLopt

count = 0

using PhysicalConstants
#
g = PhysicalConstants.MKS.GravAccel

# The objective function. The gradient is only required for gradient-based algorithms.
#
# We'll attempt to optimise the function
#
#   2 * sin(x[3]) * cos(x[3]) * x[4]^2 / g
#
# which characterises the range of a Trebuchet with
#
#   x[1] = counterweight mass,
#   x[2] = projectile mass,
#   x[3] = initial angle of projectile and
#   x[4] = initial speed of projectile.
#
function range(x::Vector, grad::Vector)
    if length(grad) > 0
        grad[1] = 0
        grad[2] = 0
        grad[3] = 2 * (2 * cos(x[3])^2 - 1) * x[4]^2 / g
        grad[4] = 4 * sin(x[3]) * cos(x[3]) * x[4] / g
    end

    global count
    count::Int += 1
    println("Iteration $count: $x")

    2 * sin(x[3]) * cos(x[3]) * x[4]^2 / g
end

# The constraint function is interpreted as ... <= 0.
#
# We'll apply the following constraints to the projectile and counterweight masses:
#
# x[1] / x[2] >= 1          - Counterweight is at least as heavy as projectile
# x[1] / x[2] <= 100        - Counterweight mass is not more than 100x projectile mass
#
# These are transformed to
#
# 0 >= 1 - x[1] / x[2]    = a + b * x[1] / x[2] for a = 1 and b = -1,
# 0 >= -100 + x[1] / x[2] = a + b * x[1] / x[2] for a = -100 and b =  1.
#
function mass_constraint(x::Vector, grad::Vector, a, b)
    if length(grad) > 0
        grad[1] = b / x[2]
        grad[2] = - b * x[1] / x[2]^2
        grad[3] = 0
        grad[4] = 0
    end
    a + b * x[1] / x[2]
end

# The kinetic energy of the projectile is determined by the initial potential energy of the mass and the energy
# efficiency of the Trebuchet:
#
#   x[2] * x[4]^2 / 2 = x[1] * g * h * efficiency
#
# where g is gravitational acceleration and h is initial height of counterweight.
#
function energy_constraint(x::Vector, grad::Vector, h, efficiency)
     if length(grad) > 0
        grad[1] = - g * h
        grad[2] = x[4]^2 / 2
        grad[3] = 0
        grad[4] = x[2] * x[4]
    end
    x[2] * x[4]^2 / 2 - x[1] * g * h * efficiency
end

opt = Opt(:LD_MMA, 4)                           # Algorithm and dimension of problem
ndims(opt)
algorithm(opt)
algorithm_name(opt)                             # Text description of algorithm

lower_bounds!(opt, [10, 0.5, 0., 0.])           # Lower bounds on optimisation parameters
upper_bounds!(opt, [1000, 10, pi/2, 1e5])       # Upper bounds on optimisation parameters

xtol_rel!(opt, 1e-6)                            # Relative tolerance on optimisation parameters

max_objective!(opt, range)                      # Specify objective function

# Apply the mass constraints (using values for a and b mentioned above).
#
inequality_constraint!(opt, (x, g) -> mass_constraint(x, g,    1, -1), 1e-8)
inequality_constraint!(opt, (x, g) -> mass_constraint(x, g, -100,  1), 1e-8)

# Apply energy constraint.
#
# Assuming
#
#   - counterweight dropped from height of 4m;
#   - energy efficiency of 100%.
#
inequality_constraint!(opt, (x, g) -> energy_constraint(x, g, 4, 1.00))

initial = [20, 1, pi/2, 100];                   # Initial guess

(maxf, maxx, ret) = optimize(opt, initial)      # Perform optimisation
println("got $maxf at $maxx after $count iterations.")
#
# Note that this model does not take into account the actual mechanics of a Trebuchet, but rather treats it as a
# black box which converts potential energy into kinetic energy.
#
# Repeat the calculation with a lower energy efficiency, say 50%. See what happens to the mass of the counterweight
# as well as the initial angle and speed of the trajectory.
