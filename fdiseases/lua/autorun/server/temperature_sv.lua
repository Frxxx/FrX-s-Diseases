FDiseases.Temperature = 0
local TemperatureChange = CurTime()

hook.Add("Think", "Temperature::Think", function()
    if CurTime() > TemperatureChange + FDiseases.Config.TemperatureChangeInterval then
        local change = math.random(-3, 3)
        if FDiseases.Temperature + change <= FDiseases.Config.MaxTemperature && FDiseases.Temperature + change >= FDiseases.Config.MinTemperature then
            FDiseases.Temperature = FDiseases.Temperature + change
        else
            FDiseases.Temperature = FDiseases.Temperature - change
        end
        SetGlobalInt("FDiseases.Temperature", FDiseases.Temperature)
        TemperatureChange = CurTime()
        if player.GetCount() >= 1 then
            for _, ply in ipairs(player.GetAll()) do
                ply:SetNWInt("FDiseases.Temperature", FDiseases.Temperature + ply:GetNWInt("FDiseases.Clothing"))
            end
        end
    end 
end)

hook.Add("PlayerSpawn", "Temperature::PlayerSpawn", function(ply)
    ply:SetNWInt("FDiseases.Temperature",FDiseases.Temperature)
end)

hook.Add("Initialize", "Temperature::Initialize", function()
    SetGlobalInt("FDiseases.Temperature", FDiseases.Temperature)
end)