# SEESAW BLACKBOX -----------------------------------------------------------------------------------------------------

immutable BlackBoxTrebuchet <: Trebuchet.TrebuchetBasic
    M::Float64                      # Counterweight mass
    m::Float64                      # Projectile mass
    H::Float64                      # Counterweight height
    efficiency::Float64             # Energy efficiency
    BlackBoxTrebuchet(M, m, H, efficiency = 1) = new(M, m, H, efficiency)
end

function maximum_range(trebuchet::BlackBoxTrebuchet)
    2 * trebuchet.M / trebuchet.m * trebuchet.H * trebuchet.efficiency
end

println(maximum_range(BlackBoxTrebuchet(500, 20, 5)))
