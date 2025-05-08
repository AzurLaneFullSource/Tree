local var0_0 = class("SpinePaintingDrag")
local var1_0 = "spine_painting_idle_init_"

function var0_0.SetPaintingInitIdle(arg0_1, arg1_1, arg2_1)
	local var0_1 = var1_0 .. tostring(arg0_1) .. tostring(arg1_1)

	PlayerPrefs.SetString(var0_1, arg2_1)
end

function var0_0.GetPaintingInitIdle(arg0_2, arg1_2)
	local var0_2 = var1_0 .. tostring(arg0_2) .. tostring(arg1_2)
	local var1_2 = PlayerPrefs.GetString(var0_2)

	if var1_2 and #var1_2 > 0 then
		return var1_2
	end

	return nil
end

return var0_0
