# SEESAW TREBUCHET ----------------------------------------------------------------------------------------------------

# This could be derived from a Trebuchet by setting L3 and L4 to zero in constructor.

immutable SeeSawTrebuchet <: Trebuchet.TrebuchetBasic
    M::Float64                      # Counterweight mass
    m::Float64                      # Projectile mass
    L1::Float64                     # Length of counterweight arm
    L2::Float64                     # Length of projectile arm
    h::Float64                      # Height of pivot
    SeeSawTrebuchet(M, m, L1, L2, h) = new(M, m, L1, L2, h)
end
