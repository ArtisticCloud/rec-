for _,net in pairs(workspace:GetDescendants()) do
    if net.Name == 'Net' then net:Destroy() end
end

pcall(function()
    workspace:FindFirstChild('Fake Plaza',true):Destroy()
end)


function set_particle_emmitters()
    for _,em in pairs(game.Workspace:GetDescendants()) do
        if em.ClassName == 'ParticleEmitter' then
            em.Rate = em.Rate * 100 ; 
            -- em.Lifetime = part.Lifetime * 2
            -- em.LightInfluence = math.huge
            -- em.LightEmission = math.huge
        end ; 
    end ; 
end ; 

set_particle_emmitters()

game.Workspace.DescendantAdded:Connect(function(part)
    if part.ClassName == 'ParticleEmitter' then
        part.Rate = part.Rate * 100 ; 
        part.Lifetime = part.Lifetime * 2
        part.LightInfluence = math.huge
        part.LightEmission = math.huge
    end
end)



