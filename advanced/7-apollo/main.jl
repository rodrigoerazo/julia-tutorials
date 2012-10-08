# Problem: Save the Apollo 13 Astronauts

load("types.jl")
load("constants.jl")
load("physics.jl")
load("moon.jl")
load("command-module.jl")
load("system.jl")

# initialization of our bodies
earth = Body(ME, [0.0, 0.0], RE, ORIGIN)
moon = Moon(MM, [0., 0.], RM, moon_position(0.0))
command_module = Command_Module(MCM, INITIAL_VELOCITY, 5.0, INITIAL_POSITION, INITIAL_POSITION, INITIAL_POSITION, INITIAL_VELOCITY, INITIAL_VELOCITY)
world = System(0.0, earth, moon, command_module)

function simulate()
    boost = -10. # m/s Change this to the correct value from the list above after everything else is done.
    position_list = Vector{Float64}[] # m
    current_time = 1.
    h = 0.1 # s, set as initial step size right now but will store current step size
    h_new = h # s, will store the adaptive step size of the next step
    mcc2_burn_done = false
    dps1_burn_done = false
    
    while current_time <= TOTAL_DURATION
        update(world, current_time, h)

        if !mcc2_burn_done && current_time >= 101104
            println("mcc2_burn fired")
            world.command_module.velocity -= 7.04 / norm(world.command_module.velocity) * world.command_module.velocity

            mcc2_burn_done = true
        end
        
        if !dps1_burn_done && current_time >= 212100
            println("dps1_burn5 fired")
            world.command_module.velocity += boost / norm(world.command_module.velocity) * world.command_module.velocity

            dps1_burn_done = true
        end
        
        positionE = world.command_module.positionE
        positionH = world.command_module.positionH
        velocityE = world.command_module.velocityE
        velocityH = world.command_module.velocityH

        error_amt = norm(positionE - positionH) + TOTAL_DURATION * norm(velocityE - velocityH)
        h_new = min(0.5 * MARKER_TIME, max(0.1, h * sqrt(TOLERANCE / error_amt))) # restrict step size to reasonable range
            
        current_time += h
        h = h_new

        push(position_list, copy(world.command_module.position))
    end

    return position_list
end
println("starting")
@time pos = simulate()
csvwrite("output.csv", pos)
