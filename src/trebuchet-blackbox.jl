# SEESAW BLACKBOX -----------------------------------------------------------------------------------------------------

immutable BlackBoxTrebuchet <: TrebuchetBasic
    m::Float64                      # Projectile mass
    M::Float64                      # Counterweight mass
    H::Float64                      # Counterweight height
end

function maximum_range(trebuchet::BlackBoxTrebuchet)
    2 * trebuchet.M / trebuchet.m * trebuchet.H
end

b1 = BlackBoxTrebuchet(1, 90, 5)
