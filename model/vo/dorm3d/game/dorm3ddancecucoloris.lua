local var0_0 = class("Dorm3dDanceCucoloris", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_dance_cucoloris
end

function var0_0.GetTime(arg0_2)
	return arg0_2:getConfig("time")
end

function var0_0.GetCamera(arg0_3)
	return arg0_3:getConfig("target_camera")
end

function var0_0.GetIcon(arg0_4)
	return "dorm3dcucoloris/" .. arg0_4:getConfig("icon")
end

function var0_0.GetOutline(arg0_5)
	return arg0_5:GetIcon() .. "_outline"
end

function var0_0.CalcScore(arg0_6, arg1_6)
	local var0_6 = math.abs(arg1_6.time - arg0_6:GetTime())

	if arg1_6.camera ~= arg0_6:GetCamera() then
		return 0, 0, var0_6
	end

	local var1_6 = 100

	if var0_6 > 0.2 then
		var1_6 = var1_6 - math.floor(math.min(var0_6 - 0.2, 0.8) / 0.04)
	end

	if var0_6 > 1 then
		var1_6 = var1_6 - math.floor((var0_6 - 1) / 0.02)
	end

	if var1_6 < 0 then
		var1_6 = 0
	end

	return var1_6 * 10, var1_6, var0_6
end

return var0_0
