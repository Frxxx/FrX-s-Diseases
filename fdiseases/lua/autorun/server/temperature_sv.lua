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

local function SetTemperature(ply, c, arg)
    if !ply:IsAdmin() then ply:PrintMessage( HUD_PRINTCONSOLE, "[FrX's Diseases] Masz zbyt niską rangę żeby to zrobić.") return end
    if !arg[1] then ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Użycie: fdiseases_settemperature <temperatura>") return end
    FDiseases.Temperature = tonumber(arg[1])
    SetGlobalInt("FDiseases.Temperature", tonumber(arg[1]))
    for _, v in ipairs(player.GetAll()) do
        v:SetNWInt("FDiseases.Temperature", FDiseases.Temperature + ply:GetNWInt("FDiseases.Clothing"))
    end
end
concommand.Add("fdiseases_settemperature", SetTemperature)