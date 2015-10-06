# Initial value of theta for Trebuchet prior to initiating launch.
#
function initial_theta(trebuchet::TrebuchetBasic)
    acos(trebuchet.h / trebuchet.L2)
end

