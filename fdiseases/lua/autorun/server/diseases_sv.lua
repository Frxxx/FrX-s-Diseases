local PLAYER = FindMetaTable("Player")
local NewInfection = CurTime()
local players = {}
FDiseases.Registered = {"cold", "flu", "tuberculosis"}

local function SortByChance(a, b)
	return a[1] > b[1]
end
local function PickRandomNumber(t)
	table.sort(t, SortByChance)

	local max = 0
	for i, tbl in ipairs(t) do
		max = max + tbl[2]
	end
	local PickedNumber = math.Rand(0, max)

	local ct = 0
	for i, tbl in ipairs(t) do
		if PickedNumber < ct + tbl[2] then
    		return tbl[1]
    	end
	ct = ct + tbl[2]
	end
end
local function GetAutoInfection()
    return tostring(PickRandomNumber(FDiseases.Config.InfectionPercent))
end 

function PLAYER:Infect(disease)
	self:SetNWBool("isInfected", true)
	self:SetNWString("disease", disease)
	self.TemporaryTimer = CurTime()
	self.TemporaryTimer2 = CurTime()
	self.timer = CurTime()
	if disease == "cold" then
		self:ChatPrint("*Zacząłeś się źle czuć. Przeszły cię dreszcze i zrobiło ci się zimno.*")
	elseif disease == "flu" then
		self:ChatPrint("*Zacząłeś się bardzo źle czuć. Mocno się pocisz i boli cię gardło. To początek czegoś poważnego.*")
	elseif disease == "tuberculosis" then
		self:ChatPrint("*Czujesz się bardzo źle, boli cię gardło.*")
	elseif disease == "hypotermia" then
		self:ChatPrint("*Trzęsiesz się z zimna, przechodzą cię dreszcze, twoja skóra zrobiła się sina.*")
	end
end

function PLAYER:Cure()
	self:SetNWBool("isInfected", false)
	self:SetNWString("disease", "")
	self:PrintMessage(HUD_PRINTTALK, "Poczułeś się lepiej.")
end

function PLAYER:IsInfected()
	return self:GetNWBool("isInfected", false)
end

function PLAYER:GetDisease()
	if self:IsInfected() then
		return self:GetNWString("disease")
	end
end

local function Cold(ply)
	if CurTime() > ply.TemporaryTimer + FDiseases.Config.ColdInterval then
		ply.TemporaryTimer = CurTime()
		ply:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
		ply:ChatPrint("*Kaszlesz*")
	end
	if CurTime() > ply.timer + FDiseases.Config.ColdUpTime then
		ply.timer = CurTime()
		ply:Cure()
	end
end

local function Flu(ply)
	if CurTime() > ply.TemporaryTimer + FDiseases.Config.FluInterval then
		ply.TemporaryTimer = CurTime()
		ply:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
		ply:ChatPrint("*Kaszlesz*")
	end
	if CurTime() > ply.timer + FDiseases.Config.FluUpTime then
		ply.timer = CurTime()
		ply:Kill()
		ply:SetNWBool("IsInfected", false)
		ply:SetNWString("disease", "")
	end
end

local function Tuberculosis(ply)
	if CurTime() > ply.TemporaryTimer + FDiseases.Config.TuberculosisInterval then
		ply.TemporaryTimer = CurTime()
		ply:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
		ply:ChatPrint("*Kaszlesz*")
	end
	if CurTime() > ply.TemporaryTimer2 + FDiseases.Config.TuberculosisInterval2 then
		ply.TemporaryTimer2 = CurTime()
		ply:TakeDamage(20, ply, nil)
		ply:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
		ply:ChatPrint("*Kaszlesz*")
	end
	if CurTime() > ply.timer + FDiseases.Config.TuberculosisUpTime then
		ply.timer = CurTime()
		ply:Kill()
		ply:SetNWBool("IsInfected", false)
		ply:SetNWString("disease", "")
	end
end

local function Hypotermia(ply)
	if CurTime() > ply.TemporaryTimer + 120 then
		ply:TakeDamage(25, ply, nil)
		ply:SetWalkSpeed(ply:GetWalkSpeed() - 20)
		ply:SetRunSpeed(ply:GetRunSpeed() - 20)
		ply.TemporaryTimer = CurTime()
	end
	if CurTime() > ply.TemporaryTimer2 + 400 then
		ply:Kill()
		ply:SetNWBool("isInfected", false)
		ply:SetNWString("disease", "")
		ply:SetWalkSpeed(ply:GetWalkSpeed() + 60)
		ply:SetRunSpeed(ply:GetRunSpeed() + 60)
		ply.TemporaryTimer2 = CurTime()
	end 
	if ply:GetNWInt("FDiseases.Temperature") > 10 then 
		if CurTime() + ply.timer + 45 then
			ply.hasHypotermia = false
			ply:Cure()
			ply:SetWalkSpeed(ply:GetWalkSpeed() + 60)
			ply:SetWalkSpeed(ply:GetWalkSpeed() + 120)
			ply.timer = CurTime()
		end
	end
end

hook.Add("Think", "FDiseases::Think", function()
	if player.GetCount() > 5 && FDiseases.Temperature < -5 then
		if CurTime() > NewInfection + FDiseases.Config.InfectionInterval then
			for _, v in ipairs(player.GetAll()) do
				if !v:IsInfected() then
					table.insert(players, v)
				end
			end
			table.sort(players, function( a, b ) return a:GetNWInt("FDiseases.Temperature") < b:GetNWInt("FDiseases.Temperature") end)
			local ply = players[1]
			ply:Infect(GetAutoInfection())
			NewInfection = CurTime()
		end 
	end	
	for _, v in ipairs(player.GetAll()) do
		if v:GetNWInt("FDiseases.Temperature") <= -20 then
			if !v.hasHypotermia then
				timer.Create("FDiseases::Hypotermia", 120, 0, function()
					if v:GetNWInt("FDiseases.Temperature") <= -20 then
						v:Infect("hypotermia")
					end
				end)
				v.hasHypotermia = true
			end
		end
		if v:GetDisease() == "cold" then
			Cold(v)
		elseif v:GetDisease() == "flu" then
			Flu(v)
		elseif v:GetDisease() == "tuberculosis" then
			Tuberculosis(v)
		elseif v:GetDisease() == "hypotermia" then
			Hypotermia(v)
		end	
	end
end)

hook.Add("PlayerSpawn", "FDiseases::PlayerSpawn", function(ply)
	ply.hasHypotermia = false
end)

hook.Add("PlayerDeath", "FDiseases::PlayerDeath", function(ply)
	ply.hasHypotermia = false
	ply:SetNWBool("isInfected", false)
	ply:SetNWString("disease", "")
end)

local function InfectPlayer(ply, c, arg)
	if !ply:IsAdmin() then ply:PrintMessage( HUD_PRINTCONSOLE, "[FrX's Diseases] Masz zbyt niską rangę żeby to zrobić.") return end
	if !arg[1] or !arg[2] then ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Użycie: fdiseases_infect <gracz> <choroba>") return end

	local found
	for i, v in ipairs(player.GetAll()) do
		if string.find(string.lower(v:GetName()), string.lower(arg[1])) then found = v break end
	end
	if !found then ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Nie udało się znaleźć takiego gracza na serwerze.") return end

	if !found:IsInfected() then
		local exists = false
		for i, v in ipairs(FDiseases.Registered) do
			if string.find(string.lower(arg[2]), v) then
				exists = true
				break
			elseif !string.find(arg[2], v) then
				exists = false
				continue
			end
		end

		if exists then
			found:Infect(string.lower(arg[2]))
			ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Udało ci się zainfekować tego gracza chorbą: "..string.lower(arg[2]))
		elseif !exists then
			ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Taka choroba nie istnieje.")
		end

	elseif found:IsInfected() then
		return ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Ten gracz jest już zarażony.")
	end
end
concommand.Add("fdiseases_infect", InfectPlayer)

local function CurePlayer(ply, c, arg)
	if !ply:IsAdmin() then ply:PrintMessage( HUD_PRINTCONSOLE, "[FrX's Diseases] Masz zbyt niską rangę żeby to zrobić.") return end
	if !arg[1] then ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Użycie: fdiseases_cure <gracz>") return end

	local found
	for i, v in ipairs(player.GetAll()) do
		if string.find(string.lower(v:GetName()), string.lower(arg[1])) then found = v break end
	end
	if !found then ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Nie udało się znaleźć takiego gracza na serwerze.") return end

	if found:IsInfected() then
		found:Cure()
		ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Udało ci się uleczyć tego gracza.")	
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "[FrX's Diseases] Ten gracz nie jest zarażony żadną chrobą.")
	end
end
concommand.Add("fdiseases_cure", CurePlayer)

local function DiseasesList(ply, c)
	ply:PrintMessage(HUD_PRINTCONSOLE,"[FrX's diseases] Lista chorób:")
	for i, v in ipairs(FDiseases.Registered) do
		ply:PrintMessage(HUD_PRINTCONSOLE, v.." - ".."fdiseases_infect <ply> "..v)
	end
end
concommand.Add("fdiseases_list", DiseasesList)
