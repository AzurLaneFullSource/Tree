local var0_0 = class("SpinePaintingDrag")
local var1_0 = "spine_painting_idle_init_"
local var2_0 = "spine_painting_skin_init_"
local var3_0 = "spine_painting_lite_"

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

function var0_0.SetPaintingInitSkin(arg0_3, arg1_3, arg2_3)
	local var0_3 = var2_0 .. tostring(arg0_3) .. tostring(arg1_3)

	PlayerPrefs.SetString(var0_3, arg2_3)
end

function var0_0.GetPaintingInitSkin(arg0_4, arg1_4)
	local var0_4 = var2_0 .. tostring(arg0_4) .. tostring(arg1_4)
	local var1_4 = PlayerPrefs.GetString(var0_4)

	if var1_4 and #var1_4 > 0 then
		return var1_4
	end

	return nil
end

function var0_0.SetPaintingLite(arg0_5, arg1_5, arg2_5)
	local var0_5 = var3_0 .. tostring(arg0_5) .. "_" .. tostring(arg1_5)

	PlayerPrefs.SetFloat(var0_5, arg2_5)
end

function var0_0.GetPaintingLite(arg0_6, arg1_6)
	local var0_6 = var3_0 .. tostring(arg0_6) .. "_" .. tostring(arg1_6)
	local var1_6 = PlayerPrefs.GetFloat(var0_6)

	if var1_6 and var1_6 >= 0 then
		return var1_6
	end

	return 0.5
end

return var0_0
