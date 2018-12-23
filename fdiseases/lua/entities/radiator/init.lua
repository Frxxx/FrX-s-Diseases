AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
local TemperatureAdd = 60
local TemperatureAddCurtime = CurTime()
local TemperatureDrop = 20
local TemperatureDropCurtime = CurTime()

function ENT:Initialize()
	self:SetModel("models/props/de_inferno/radiator01a.mdl")
	self:SetPos(self:GetPos()+Vector(0,0,100))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Think()
	if CurTime() > TemperatureAddCurtime + TemperatureAdd then
		for _, v in ipairs(ents.FindInSphere(self:LocalToWorld(Vector(110, 0, -15)), 110)) do
			v.temperature = v.temperature or 0
			if v:IsPlayer() && v.temperature < 30 then
				v.temperature = v.temperature  + 0.5 
				v:SetNWInt("FDiseases.Temperature", v:GetNWInt("FDiseases.Temperature") + 0.5)				
			end
		end
		TemperatureAddCurtime = CurTime()
	end
	for _, ply in ipairs(player.GetAll()) do
		if CurTime() > TemperatureDropCurtime + TemperatureDrop then
			if !table.HasValue(ents.FindInSphere(self:LocalToWorld(Vector(110, 0, -15)), 110), ply) && ply.temperature > 0 then
				ply:SetNWInt("FDiseases.Temperature", ply:GetNWInt("FDiseases.Temperature") - 0.5)
				ply.temperature = ply.temperature - 0.5
			end
			TemperatureDropCurtime = CurTime()
		end
	end
end