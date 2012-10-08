type Body{T}
    mass::T
    velocity::Vector{T}
    radius::T
    position::Vector{T}
end

typealias Moon Body

type Command_Module{T}
    mass::T
    velocity::Vector{T}
    radius::T
    position::Vector{T}
    positionE::Vector{T}
    positionH::Vector{T}
    velocityE::Vector{T}
    velocityH::Vector{T}
end

type System
    time::Float64
    earth::Body
    moon::Moon
    command_module::Command_Module
end