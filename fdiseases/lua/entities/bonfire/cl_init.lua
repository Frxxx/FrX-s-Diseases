include('shared.lua')
local isPicked = false
surface.CreateFont( "FDiseases.Font3", {
	font = "Trebuchet24",
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

function ENT:Draw()
    self:DrawModel()
    local pos = self:LocalToWorld(Vector(0,0,6))
    if isPicked then
        cam.Start3D2D(pos, self:GetAngles(), 1)
            surface.DrawCircle(0, 0, 110, 255, 0, 0)
        cam.End3D2D()
    end
end

hook.Add("HUDPaint", "Bonfire::HUDPaint", function()
    local tr = LocalPlayer():GetEyeTrace()

    if tr.Entity:GetClass() == "bonfire" then
        draw.SimpleText("Wciśnij 'E' żeby zapalić/zgasić ognisko.", "FDiseases.Font3", ScrW()/2- surface.GetTextSize("Wciśnij 'E' żeby zapalić/zgasić ognisko.")/2, ScrH() * 0.6, Color(255, 0, 0))
    end
end)

hook.Add("PhysgunPickup", "Bonfire::PhysgunPickup", function(_, ent)
    if ent:GetClass() == "bonfire" then
        isPicked = true
    end
end)

hook.Add("PhysgunDrop", "Bonfire::PhysgunDrop", function(_, ent)
    if ent:GetClass() == "bonfire" then
        isPicked = false
    end
end)
