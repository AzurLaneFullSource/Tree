local var0 = class("EducateCharWordHelper")

var0.WORD_KEY_CHRISTMAS = "shengdan"
var0.WORD_KEY_NEWYEAR = "xinnian"
var0.WORD_KEY_LUNARNEWYEAR = "chuxi"
var0.WORD_KEY_VALENTINE = "qingrenjie"
var0.WORD_KEY_MIDAUTUMNFESTIVAL = "zhongqiu"
var0.WORD_KEY_ALLHALLOWSDAY = "wansheng"
var0.WORD_KEY_TELL_TIME = "chime_"
var0.WORD_KEY_ACT = "huodong"
var0.WORD_KEY_CHANGE_TB = "genghuan"

local var1 = pg.secretary_special_ship
local var2 = pg.character_voice_special
local var3 = pg.secretary_special_ship_expression

local function var4(arg0, arg1)
	local var0 = var2[arg0]

	if not var0 then
		return nil, nil, nil
	end

	return "event:/educate-cv/" .. arg1 .. "/" .. var0.resource_key, var0.resource_key
end

function var0.GetWordAndCV(arg0, arg1, arg2)
	local var0
	local var1
	local var2
	local var3
	local var4 = var1[arg0]
	local var5 = arg1

	if string.find(arg1, ShipWordHelper.WORD_TYPE_MAIN) then
		local var6 = string.split(arg1, "_")

		arg1 = ShipWordHelper.WORD_TYPE_MAIN

		local var7 = tonumber(var6[2] or "1")
		local var8 = var4[arg1] or ""

		var2 = string.split(var8 or "", "|")[var7] or ""
		var5 = arg1 .. "" .. var7
	else
		var2 = var4[arg1] or ""
	end

	if var4.voice and var4.voice ~= "" then
		var0 = var4.voice
		var1, var3 = var4(var5, var0)
	end

	if var2 and arg2 then
		var2 = SwitchSpecialChar(var2, true)
	end

	var2 = var2 and HXSet.hxLan(var2)

	return var0, var1, var2, var3
end

function var0.ExistWord(arg0, arg1)
	local var0 = var1[arg0]

	if string.find(arg1, ShipWordHelper.WORD_TYPE_MAIN) then
		local var1 = string.split(var0.main, "|")
		local var2 = string.split(arg1, "_")

		return tonumber(var2[2]) <= #var1
	else
		return var0[arg1] ~= nil and var0[arg1] ~= ""
	end
end

function var0.RawGetCVKey(arg0)
	return var1[arg0].voice
end

function var0.GetExpression(arg0, arg1)
	local var0 = var3[arg0]
	local var1 = ""

	if string.find(arg1, ShipWordHelper.WORD_TYPE_MAIN) then
		local var2 = string.split(arg1, "_")
		local var3 = tonumber(var2[2] or "1")
		local var4 = var0[ShipWordHelper.WORD_TYPE_MAIN] or ""

		var1 = string.split(var4, "|")[var3] or ""

		if var1 == "0" or var1 == "nil" then
			var1 = ""
		end
	else
		var1 = var0[arg1] or ""
	end

	return var1
end

return var0
