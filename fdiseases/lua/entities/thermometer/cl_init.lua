include('shared.lua')

surface.CreateFont( "FDiseases.Font", {
	font = "Trebuchet24",
	extended = false,
	size = 300,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

function ENT:Draw()
    self:DrawModel()
    local pos = self:LocalToWorld(Vector(6, 0 ,0))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(self:GetAngles():Right(), 270)
    ang:RotateAroundAxis(self:GetAngles():Forward(), 90)

    local temperature = GetGlobalInt("FDiseases.Temperature")
    local clr
    if temperature >= 0 then
        clr = Color(255, 255, 255)
    elseif temperature < 0 && temperature >= -10 then 
        clr = Color(255, 255, 0)
    elseif temperature < -10 then
        clr = Color(255, 0, 0)
    end

    cam.Start3D2D(pos, ang, 0.1)        
        draw.SimpleText(temperature.."°C", "FDiseases.Font", -10, -260, clr, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end