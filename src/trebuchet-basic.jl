# Initial value of theta for Trebuchet prior to initiating launch.
#
function initial_theta(trebuchet::TrebuchetBasic)
    acos(trebuchet.h / trebuchet.L2)
end

# This assumes that the beam is initially vertical with the counterweight at the top. Obviously this is an unrealistic
# configuration, but it represents the one with the most potential energy.
#
function maximum_theoretical_range(trebuchet::TrebuchetBasic)
    2 * trebuchet.M / trebuchet.m * (trebuchet.h + trebuchet.L1 - trebuchet.L4)
end
