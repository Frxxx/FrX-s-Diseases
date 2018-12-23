include('shared.lua')
local isPicked = false

function ENT:Draw()
    self:DrawModel()
    local pos = self:LocalToWorld(Vector(110, 0, -15))
    if isPicked then
        cam.Start3D2D(pos, self:GetAngles(), 1)
            surface.DrawCircle(0, 0, 110, 255, 0, 0)
        cam.End3D2D()
    end
end

hook.Add("PhysgunPickup", "Radiator::PhysgunPickup", function(_, ent)
    if ent:GetClass() == "radiator" then
        isPicked = true
    end
end)

hook.Add("PhysgunDrop", "Radiator::PhysgunDrop", function(_, ent)
    if ent:GetClass() == "radiator" then
        isPicked = false
    end
end)