# SEESAW TREBUCHET ----------------------------------------------------------------------------------------------------

immutable SeeSawTrebuchet <: TrebuchetBasic
    m::Float64                      # Projectile mass
    M::Float64                      # Counterweight mass
    L1::Float64                     # Length of counterweight arm
    L2::Float64                     # Length of projectile arm
    L3::Float64 = 0                 # Length of the projectile sling
    L4::Float64 = 0
    h::Float64                      # Height of pivot
    SeeSawTrebuchet(m::Float64, M::Float64, L1::Float64, L2::Float64, h::Float64) = new(m, M, L1, L2, h)
end
