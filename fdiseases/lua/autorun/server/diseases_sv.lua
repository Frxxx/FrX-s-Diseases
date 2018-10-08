local Ply = FindMetaTable("Player")
local NewInfection = CurTime()
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

function Ply:Infect(disease)
	self:SetNWBool("isInfected", true)
	self:SetNWString("disease", disease)
	self.TemporaryTimer = CurTime()
	self.TemporaryTimer2 = CurTime()
	self.timer = CurTime()
	if disease == "cold" then
		self:ChatPrint("Zacząłeś się źle czuć. Przeszły cię dreszcze i zrobiło ci się zimno.")
	elseif disease == "flu" then
		self:ChatPrint("Zacząłeś się bardzo źle czuć. Mocno się pocisz i boli cię gardło. To początek czegoś poważnego.")
	elseif disease == "tuberculosis" then
		self:ChatPrint("")
	end
end

function Ply:Cure()
	self:SetNWBool("isInfected", false)
	self:SetNWString("disease", "")
	self:PrintMessage(HUD_PRINTTALK, "Poczułeś się lepiej.")
end

function Ply:IsInfected()
	return self:GetNWBool("isInfected", false)
end

function Ply:GetDisease()
	if self:IsInfected() then
		return self:GetNWString("disease")
	end
end

hook.Add("Think", "FDiseases::Think", function()
	if CurTime() > NewInfection + FDiseases.Config.InfectionInterval then
		local randomply = table.Random(player.GetAll())
		if !randomply:IsInfected() then
			NewInfection = CurTime()
			randomply:Infect(GetAutoInfection())
		end
	end

	for i, v in ipairs(player.GetAll()) do
		if v:GetDisease() == "cold" then
			if CurTime() > v.TemporaryTimer + FDiseases.Config.ColdInterval then -- temporary effects
				v.TemporaryTimer = CurTime()
				v:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
				v:ChatPrint("*Kaszlesz*")
			end
			if CurTime() > v.timer + FDiseases.Config.ColdUpTime then
				v.timer = CurTime()
				v:Cure()
			end

		elseif v:GetDisease() == "flu" then
			if CurTime() > v.TemporaryTimer + FDiseases.Config.FluInterval then
				v.TemporaryTimer = CurTime()
				v:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
				v:ChatPrint("*Kaszlesz*")
			end
			if CurTime() > v.timer + FDiseases.Config.FluUpTime then
				v.timer = CurTime()
				v:Kill()
				v:SetNWBool("IsInfected", false)
				v:SetNWString("disease", "")
			end

		elseif v:GetDisease() == "tuberculosis" then
			if CurTime() > v.TemporaryTimer + FDiseases.Config.TuberculosisInterval then
				v.TemporaryTimer = CurTime()
				v:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
				v:ChatPrint("*Kaszlesz i robi ci się duszno*")
			end
			if CurTime() > v.TemporaryTimer2 + FDiseases.Config.TuberculosisInterval2 then
				v.TemporaryTimer2 = CurTime()
				v:TakeDamage(20, v, nil)
				v:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
				v:ChatPrint("*Kaszlesz krwią*")
			end
			if CurTime() > v.timer + FDiseases.Config.TuberculosisUpTime then
				v.timer = CurTime()
				v:Kill()
				v:SetNWBool("IsInfected", false)
				v:SetNWString("disease", "")
			end
		end
	end
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
		ply:PrintMessage(HUD_PRINTCONSOLE, v.." - ".."fdiseases_infect <gracz> "..v)
	end
end
concommand.Add("fdiseases_list", DiseasesList)