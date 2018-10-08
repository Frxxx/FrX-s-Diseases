local tab = {
	["$pp_colour_colour"] = 0.2,
	["$pp_colour_contrast"] = 0.8,
}

hook.Add("Think", "CheckDiseasesStatus", function()
	if LocalPlayer():GetNWBool("IsInfected") == true then
		if LocalPlayer():GetNWString("disease") == "cold" then 
			hook.Add("RenderScreenspaceEffects", "VisualEffects", function()
				DrawMotionBlur( 0.2, 0.8, 0.01 )
			end)
		elseif LocalPlayer():GetNWString("disease") == "tuberculosis" then
			hook.Add("RenderScreenspaceEffects", "VisualEffects", function()
				DrawColorModify(tab)
				DrawMotionBlur( 0.2, 0.8, 0.01 )
			end)	
		end
	else
		hook.Remove("RenderScreenspaceEffects", "VisualEffects")
	end
end)