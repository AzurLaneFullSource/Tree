local var0_0 = class("EducateCharWordHelper")

var0_0.WORD_KEY_CHRISTMAS = "shengdan"
var0_0.WORD_KEY_NEWYEAR = "xinnian"
var0_0.WORD_KEY_LUNARNEWYEAR = "chuxi"
var0_0.WORD_KEY_VALENTINE = "qingrenjie"
var0_0.WORD_KEY_MIDAUTUMNFESTIVAL = "zhongqiu"
var0_0.WORD_KEY_ALLHALLOWSDAY = "wansheng"
var0_0.WORD_KEY_TELL_TIME = "chime_"
var0_0.WORD_KEY_ACT = "huodong"
var0_0.WORD_KEY_CHANGE_TB = "genghuan"

local var1_0 = pg.secretary_special_ship
local var2_0 = pg.character_voice_special
local var3_0 = pg.secretary_special_ship_expression

local function var4_0(arg0_1, arg1_1)
	local var0_1 = var2_0[arg0_1]

	if not var0_1 then
		return nil, nil, nil
	end

	return "event:/educate-cv/" .. arg1_1 .. "/" .. var0_1.resource_key, var0_1.resource_key
end

function var0_0.GetWordAndCV(arg0_2, arg1_2, arg2_2)
	local var0_2
	local var1_2
	local var2_2
	local var3_2
	local var4_2 = var1_0[arg0_2]
	local var5_2 = arg1_2

	if string.find(arg1_2, ShipWordHelper.WORD_TYPE_MAIN) then
		local var6_2 = string.split(arg1_2, "_")

		arg1_2 = ShipWordHelper.WORD_TYPE_MAIN

		local var7_2 = tonumber(var6_2[2] or "1")
		local var8_2 = var4_2[arg1_2] or ""

		var2_2 = string.split(var8_2 or "", "|")[var7_2] or ""
		var5_2 = arg1_2 .. "" .. var7_2
	else
		var2_2 = var4_2[arg1_2] or ""
	end

	if var4_2.voice and var4_2.voice ~= "" then
		var0_2 = var4_2.voice
		var1_2, var3_2 = var4_0(var5_2, var0_2)
	end

	if var2_2 and arg2_2 then
		var2_2 = SwitchSpecialChar(var2_2, true)
	end

	var2_2 = var2_2 and HXSet.hxLan(var2_2)

	return var0_2, var1_2, var2_2, var3_2
end

function var0_0.ExistWord(arg0_3, arg1_3)
	local var0_3 = var1_0[arg0_3]

	if string.find(arg1_3, ShipWordHelper.WORD_TYPE_MAIN) then
		local var1_3 = string.split(var0_3.main, "|")
		local var2_3 = string.split(arg1_3, "_")

		return tonumber(var2_3[2]) <= #var1_3
	else
		return var0_3[arg1_3] ~= nil and var0_3[arg1_3] ~= ""
	end
end

function var0_0.RawGetCVKey(arg0_4)
	return var1_0[arg0_4].voice
end

function var0_0.GetExpression(arg0_5, arg1_5)
	local var0_5 = var3_0[arg0_5]
	local var1_5 = ""

	if string.find(arg1_5, ShipWordHelper.WORD_TYPE_MAIN) then
		local var2_5 = string.split(arg1_5, "_")
		local var3_5 = tonumber(var2_5[2] or "1")
		local var4_5 = var0_5[ShipWordHelper.WORD_TYPE_MAIN] or ""

		var1_5 = string.split(var4_5, "|")[var3_5] or ""

		if var1_5 == "0" or var1_5 == "nil" then
			var1_5 = ""
		end
	else
		var1_5 = var0_5[arg1_5] or ""
	end

	return var1_5
end

return var0_0
