using ODE
using DataFrames
using PhysicalConstants

function solve(trebuchet::SeeSawTrebuchet)
    # Only follow dynamics until the arm has reached vertical.
    #
    # y[1] - theta
    # y[2] - dtheta / dt
    #
    function lagrangian(t, y)
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

    T, theta = ode23(lagrangian, initial, [0.; 5]);

    result = convert(DataFrame, hcat(T, hcat(theta...).'));
    names!(result, [symbol(i) for i in ["time", "theta", "thetadot"]])

    result[result[:theta] .< pi,:]
end
