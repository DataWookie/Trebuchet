# SEESAW TREBUCHET ----------------------------------------------------------------------------------------------------

immutable SeeSawTrebuchet <: Trebuchet.TrebuchetBasic
    M::Float64                      # Counterweight mass
    m::Float64                      # Projectile mass
    L1::Float64                     # Length of counterweight arm
    L2::Float64                     # Length of projectile arm
    L3::Float64                     # Length of the projectile sling
    L4::Float64                     # Length of the counterweight sling
    h::Float64                      # Height of pivot
    SeeSawTrebuchet(M, m, L1, L2, h) = new(M, m, L1, L2, 0, 0, h)
end
