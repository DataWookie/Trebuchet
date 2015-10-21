using ODE
using DataFrames
using PhysicalConstants

# The ODE for theta should look familiar. It takes the form:
#
#   theta'' = k sin(theta)
#
# which is the equation for a simple pendulum. However, since we cannot assume that theta remains small, we cannot
# make the simplifying approximation
#
#   sin(theta) ~ theta
#
# and, as a result, we need to use numerical techniques even for the simplest model of the trebuchet.
#
function solve(trebuchet::SeeSawTrebuchet)
    # Only follow dynamics until the arm has reached vertical.
    #
    # y[1] - theta
    # y[2] - dtheta / dt
    #
    function deriv(t, y)
        (y[1] < pi) ?
        [
            y[2];
            PhysicalConstants.MKS.GravAccel * (trebuchet.M * trebuchet.L1 - trebuchet.m * trebuchet.L2) /
                                              (trebuchet.M * trebuchet.L1^2 + trebuchet.m * trebuchet.L2^2) * sin(y[1])
        ] : [0.; 0.]
    end

    # Initial conditions.
    #
    initial = [Trebuchet.initial_theta(trebuchet), 0];

    T, theta = ode23(deriv, initial, [0.; 5]; maxstep= 0.0005);

    result = convert(DataFrame, hcat(T, hcat(theta...).'));
    names!(result, [symbol(i) for i in ["time", "theta", "thetadot"]])

    result[:psi] = Trebuchet.launch_angle(result);
    result[:speed] = Trebuchet.launch_speed(trebuchet, result);
    result[:range] = Trebuchet.launch_range(trebuchet, result);

    result[result[:theta] .< pi,:]
end

# Note: This does not yet take into account the effect of the sling.
#
function launch_angle(solution)
    pi - solution[:theta]
end

# Note: This does not yet take into account the effect of the sling.
#
function launch_speed(trebuchet::SeeSawTrebuchet, solution)
    trebuchet.L2 .* solution[:thetadot]
end

# Note: This does not yet take into account the effect of the sling.
#
# This makes the simplifying assumption of not adding in the additional height of the launch point. Effectively the
# projectile is launched from ground level.
#
function launch_range(trebuchet::SeeSawTrebuchet, solution)
    psi = launch_angle(solution)
    2 * launch_speed(trebuchet, solution).^2 .* sin(psi) .* cos(psi) / PhysicalConstants.MKS.GravAccel
end
