AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
local TemperatureAdd = 60
local TemperatureAddCurtime = CurTime()
local TemperatureDrop = 20
local TemperatureDropCurtime = CurTime()
local isBurning = false

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage128_composite001a.mdl")
	self:SetPos(self:GetPos()+Vector(0,0,100))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Think()
	for _, ply in ipairs(player.GetAll()) do
		ply.temperature = ply.temperature or 0
	end	
	if CurTime() > TemperatureAddCurtime + TemperatureAdd then
		for _, v in ipairs(ents.FindInSphere(self:LocalToWorld(Vector(0,0,6)), 110)) do
			if v:IsPlayer() && isBurning && v.temperature < 30 then
				v.temperature = v.temperature  + 0.5 
				v:SetNWInt("FDiseases.Temperature", v:GetNWInt("FDiseases.Temperature") + 0.5)				
			end
		end
		TemperatureAddCurtime = CurTime()
	end
	for _, ply in ipairs(player.GetAll()) do
		if CurTime() > TemperatureDropCurtime + TemperatureDrop then
			if !table.HasValue(ents.FindInSphere(self:LocalToWorld(Vector(0,0,6)), 110), ply) || !isBurning && ply.temperature > 0 then
				ply:SetNWInt("FDiseases.Temperature", ply:GetNWInt("FDiseases.Temperature") - 0.5)
				ply.temperature = ply.temperature - 0.5
			end
			TemperatureDropCurtime = CurTime()
		end
	end
end

function ENT:Use(_, caller)
	if !isBurning then
		isBurning = true
		self:Ignite(600, 10)
	elseif isBurning then
		isBurning = false
		self:Extinguish()
	end
end