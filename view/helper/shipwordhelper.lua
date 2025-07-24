local var0_0 = class("ShipWordHelper")
local var1_0 = pg.ship_skin_template
local var2_0 = pg.ship_skin_words
local var3_0 = pg.ship_skin_words_extra
local var4_0 = pg.character_voice
local var5_0 = pg.voice_actor_CN

var0_0.WORD_TYPE_MAIN = "main"
var0_0.WORD_TYPE_SKILL = "skill"
var0_0.WORD_TYPE_UNLOCK = "unlock"
var0_0.WORD_TYPE_PROFILE = "profile"
var0_0.WORD_TYPE_DROP = "drop_descrip"
var0_0.WORD_TYPE_MVP = "win_mvp"
var0_0.WORD_TYPE_LOSE = "lose"
var0_0.WORD_TYPE_UPGRADE = "upgrade"
var0_0.CV_KEY_REPALCE = 0
var0_0.CV_KEY_BAN = -1
var0_0.CV_KEY_BAN_NEW = -2
var0_0.CVBattleKey = {
	skill = "skill",
	link2 = "link2",
	lose = "lose",
	link5 = "link5",
	mvp = "mvp",
	link3 = "link3",
	link6 = "link6",
	hp = "hp",
	link1 = "link1",
	link4 = "link4",
	warcry = "warcry",
	link7 = "link7"
}

local var6_0 = false

local function var7_0(...)
	if var6_0 and IsUnityEditor then
		print(...)
	end
end

local function var8_0(arg0_2)
	if not arg0_2 or arg0_2 == "" or arg0_2 == "nil" then
		return true
	end
end

local function var9_0(arg0_3)
	return var3_0[arg0_3] ~= nil
end

local function var10_0(arg0_4)
	return var2_0[arg0_4] ~= nil
end

local function var11_0(arg0_5)
	local var0_5 = var1_0[arg0_5].ship_group

	return ShipGroup.getDefaultSkin(var0_5).id
end

local function var12_0(arg0_6, arg1_6)
	arg0_6 = arg0_6 or ""

	if type(arg0_6) == "table" then
		return arg0_6
	else
		local var0_6 = string.split(arg0_6, "|")

		arg1_6[1] = arg1_6[1] or math.random(#var0_6)

		return var0_6[arg1_6[1]]
	end
end

local function var13_0(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = var11_0(arg0_7)
	local var1_7 = var10_0(arg0_7) and arg0_7 or var0_7
	local var2_7 = var2_0[var1_7]

	if not var2_0[var1_7] then
		return nil
	end

	local var3_7 = var1_7 == var0_7

	if var3_7 and arg0_7 ~= var0_7 and arg3_7 then
		arg3_7[1] = true
	end

	local var4_7 = var12_0(var2_7[arg1_7], arg2_7)

	if (type(var4_7) == "table" and #var4_7 == 0 or var8_0(var4_7)) and not var3_7 then
		if arg3_7 then
			arg3_7[1] = true
		end

		var2_7 = var2_0[var0_7]
	end

	return var2_7
end

local function var14_0(arg0_8, arg1_8, arg2_8)
	arg1_8 = arg1_8 or 0

	local var0_8

	for iter0_8, iter1_8 in ipairs(arg0_8) do
		local var1_8 = iter1_8[1]
		local var2_8 = iter1_8[2]

		if var1_8 <= arg1_8 then
			var0_8 = iter1_8

			break
		end
	end

	if var0_8 then
		return var12_0(var0_8[2], arg2_8), var0_8[1]
	end
end

local function var15_0(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = var11_0(arg0_9)
	local var1_9 = var10_0(arg0_9) and arg0_9 or var0_9
	local var2_9 = var3_0[var1_9]

	if not var2_9 then
		return nil
	end

	local var3_9 = var2_9[arg1_9]

	if var1_9 == var0_9 and arg0_9 ~= var0_9 and arg4_9 then
		arg4_9[1] = true
	end

	if var8_0(var3_9) then
		return nil
	end

	return var14_0(var3_9, arg3_9, arg2_9)
end

local function var16_0(arg0_10)
	local var0_10 = pg.ship_skin_words[arg0_10]
	local var1_10 = var1_0[arg0_10].ship_group
	local var2_10 = PlayerPrefs.GetInt(CV_LANGUAGE_KEY .. var1_10)

	if PLATFORM_CODE == PLATFORM_CH and (arg0_10 == 407010 or arg0_10 == 407020 or arg0_10 == 204010 or arg0_10 == 204040 or arg0_10 == 9704040 or arg0_10 == 303120 or arg0_10 == 305070 or arg0_10 == 307020) and var2_10 == 2 then
		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var1_10, 1)
		PlayerPrefs.Save()

		var2_10 = 1
	end

	return var2_10
end

function var0_0.GetLanguageSetting(arg0_11)
	return var16_0(arg0_11)
end

local function var17_0(arg0_12, arg1_12, arg2_12)
	local var0_12 = "event:/cv/" .. arg1_12 .. "/" .. arg0_12

	if arg2_12 then
		var0_12 = var0_12 .. "_" .. arg2_12
	end

	return var0_12
end

local function var18_0(arg0_13, arg1_13)
	local var0_13 = var2_0[arg1_13]

	if not var0_13 then
		return -1
	end

	local function var1_13(arg0_14)
		return arg0_13 == 2 and arg0_14.voice_key_2 >= 0 and arg0_14.voice_key_2 or arg0_14.voice_key
	end

	local var2_13 = var1_13(var0_13)

	if var2_13 == 0 or var2_13 == -2 then
		local var3_13 = var11_0(arg1_13)
		local var4_13 = var2_0[var3_13]

		var2_13 = var1_13(var4_13)
	end

	return var2_13
end

local function var19_0(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	if arg0_15 then
		local var0_15
		local var1_15
		local var2_15 = var16_0(arg1_15)
		local var3_15 = var2_15 == 2 and arg0_15.voice_key_2 or arg0_15.voice_key
		local var4_15 = arg2_15 == var0_0.WORD_TYPE_MAIN
		local var5_15 = var4_15 and arg2_15 .. arg3_15[1] or arg2_15
		local var6_15 = var4_0[var5_15]
		local var7_15 = var6_15 and var6_15.resource_key

		if not var7_15 and var4_15 then
			var7_15 = arg2_15 .. "_" .. arg3_15[1]
		end

		if var3_15 ~= var0_0.CV_KEY_BAN and var7_15 then
			var0_15 = var18_0(var2_15, arg1_15)

			local var8_15

			if arg4_15 and var3_15 == var0_0.CV_KEY_REPALCE then
				local var9_15 = var1_0[arg1_15].group_index

				if var9_15 ~= 0 then
					var8_15 = var9_15
				end
			end

			var1_15 = var17_0(var7_15, var0_15, var8_15)
		end

		return var0_15, var1_15
	end
end

local function var20_0(arg0_16, arg1_16, arg2_16)
	local var0_16 = var0_0.ExistDifferentWord(arg0_16, arg1_16, arg2_16)
	local var1_16 = var2_0[arg0_16].voice_key == var0_0.CV_KEY_BAN_NEW

	return var0_16 and var1_16
end

local function var21_0(arg0_17, arg1_17)
	arg1_17 = arg1_17 or -1

	local var0_17 = var3_0[arg0_17]

	if not var0_17 or not var0_17.main_extra or var0_17.main_extra == "" or type(var0_17.main_extra) == "table" and #var0_17.main_extra == 0 then
		return nil
	end

	local var1_17
	local var2_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17.main_extra) do
		local var3_17 = iter1_17[1]
		local var4_17 = iter1_17[2]

		if var3_17 <= arg1_17 then
			var1_17 = var1_17 and var1_17 .. "|" .. var4_17 or var4_17

			local var5_17 = string.split(var4_17, "|")

			for iter2_17, iter3_17 in ipairs(var5_17) do
				var2_17[iter3_17] = var3_17
			end
		end
	end

	return var1_17, var2_17
end

function var0_0.GetWordAndCV(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	local var0_18
	local var1_18
	local var2_18
	local var3_18 = {
		false
	}
	local var4_18 = {
		arg2_18
	}
	local var5_18, var6_18 = var15_0(arg0_18, arg1_18, var4_18, arg4_18, var3_18)

	if not var8_0(var5_18) then
		var0_18 = var5_18
		var1_18 = var13_0(arg0_18, arg1_18, var4_18)
	else
		var4_18 = {
			arg2_18
		}
		var3_18 = {
			false
		}
		var1_18 = var13_0(arg0_18, arg1_18, var4_18, var3_18)

		if var0_0.WORD_TYPE_MAIN == arg1_18 then
			local var7_18
			local var8_18 = {}
			local var9_18, var10_18 = var21_0(arg0_18, arg4_18)

			if var9_18 then
				var4_18 = {
					arg2_18
				}
			end

			local var11_18

			if var9_18 and var1_18 and var1_18[arg1_18] then
				var11_18 = var1_18[arg1_18] .. "|" .. var9_18
			elseif var9_18 and (not var1_18 or not var1_18[arg1_18]) then
				var11_18 = var9_18
			elseif not var9_18 and var1_18 and var1_18[arg1_18] then
				var11_18 = var1_18[arg1_18]
			end

			var0_18 = var12_0(var11_18, var4_18)
			var2_18 = var10_18 and var10_18[var0_18]
		elseif var1_18 then
			var0_18 = var12_0(var1_18[arg1_18], var4_18)
		end
	end

	local var12_18
	local var13_18

	if not var20_0(arg0_18, arg1_18, arg2_18) then
		var12_18, var13_18 = var19_0(var1_18, arg0_18, arg1_18, var4_18, not var3_18[1])

		if var13_18 and not var8_0(var5_18) and var6_18 then
			var13_18 = var13_18 .. "_ex" .. var6_18
		elseif var13_18 and var2_18 then
			var13_18 = var13_18 .. "_ex" .. var2_18
		end
	end

	if type(var0_18) ~= "table" then
		if var0_18 and arg3_18 then
			var0_18 = SwitchSpecialChar(var0_18, true)
		end

		var0_18 = var0_18 and HXSet.hxLan(var0_18)
	end

	var7_0("cv:", var13_18, "cvkey:", var12_18, "word:", var0_18)

	return var12_18, var13_18, var0_18
end

function var0_0.RawGetWord(arg0_19, arg1_19)
	return var2_0[arg0_19][arg1_19]
end

function var0_0.RawGetCVKey(arg0_20)
	local var0_20 = var16_0(arg0_20)

	return var18_0(var0_20, arg0_20)
end

function var0_0.GetDefaultSkin(arg0_21)
	return var11_0(arg0_21)
end

function var0_0.GetMainSceneWordCnt(arg0_22, arg1_22)
	local var0_22 = var2_0[arg0_22]

	if not var0_22 or not var0_22[var0_0.WORD_TYPE_MAIN] or var0_22[var0_0.WORD_TYPE_MAIN] == "" then
		local var1_22 = var11_0(arg0_22)

		var0_22 = var2_0[var1_22]
	end

	local var2_22 = 0

	if var0_22 and var0_22[var0_0.WORD_TYPE_MAIN] and var0_22[var0_0.WORD_TYPE_MAIN] ~= "" then
		var2_22 = #string.split(var0_22[var0_0.WORD_TYPE_MAIN], "|")
	end

	local var3_22, var4_22 = var21_0(arg0_22, arg1_22)

	if var3_22 then
		var2_22 = var2_22 + table.getCount(var4_22)
	end

	return var2_22
end

function var0_0.GetL2dCvCalibrate(arg0_23, arg1_23, arg2_23)
	local var0_23 = var1_0[arg0_23]

	if not var0_23 then
		return 0
	end

	if type(var0_23.l2d_voice_calibrate) == "table" and var0_23.l2d_voice_calibrate.use_event then
		return -1
	end

	if arg1_23 == var0_0.WORD_TYPE_MAIN then
		arg1_23 = arg1_23 .. "_" .. arg2_23
	end

	return var0_23.l2d_voice_calibrate[arg1_23]
end

function var0_0.GetL2dSoundEffect(arg0_24, arg1_24, arg2_24)
	local var0_24 = var1_0[arg0_24]

	if not var0_24 then
		return 0
	end

	if arg1_24 == var0_0.WORD_TYPE_MAIN then
		arg1_24 = arg1_24 .. "_" .. arg2_24
	end

	return var0_24.l2d_se[arg1_24]
end

function var0_0.ExistVoiceKey(arg0_25)
	local var0_25 = var2_0[arg0_25]

	return var0_25 and var0_25.voice_key ~= var0_0.CV_KEY_BAN
end

function var0_0.GetCVAuthor(arg0_26)
	local var0_26 = var1_0[arg0_26]
	local var1_26 = var16_0(arg0_26) == 2 and var0_26.voice_actor_2 or var0_26.voice_actor
	local var2_26 = ""

	return var1_26 == var0_0.CV_KEY_BAN and "-" or var5_0[var1_26].actor_name
end

function var0_0.GetCVList()
	local var0_27 = {}

	for iter0_27, iter1_27 in pairs(pg.character_voice) do
		if not pg.AssistantInfo.isDisableSpecialClick(iter1_27.key) and iter1_27.unlock_condition[1] >= 0 then
			var0_27[#var0_27 + 1] = setmetatable({}, {
				__index = iter1_27
			})
		end
	end

	return var0_27
end

function var0_0.ExistDifferentWord(arg0_28, arg1_28, arg2_28)
	if var11_0(arg0_28) == arg0_28 then
		return false
	end

	local var0_28 = var2_0[arg0_28]
	local var1_28

	if string.find(arg1_28, "main") then
		local var2_28 = var0_28[var0_0.WORD_TYPE_MAIN]

		var1_28 = string.split(var2_28, "|")[arg2_28]
	else
		var1_28 = var0_28[arg1_28]
	end

	return not not var1_28 and var1_28 ~= "" and var1_28 ~= "nil"
end

function var0_0.ExistDifferentExWord(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = var11_0(arg0_29)

	if arg0_29 == var0_29 then
		return false
	end

	local var1_29 = arg1_29

	if string.find(arg1_29, "main") then
		var1_29 = var0_0.WORD_TYPE_MAIN
	end

	local var2_29 = var15_0(arg0_29, var1_29, {
		arg2_29
	}, arg3_29)
	local var3_29 = var15_0(var0_29, var1_29, {
		arg2_29
	}, arg3_29)

	return not var8_0(var2_29) and var2_29 ~= var3_29
end

function var0_0.ExistDifferentMainExWord(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = var11_0(arg0_30)

	if arg0_30 == var0_30 then
		return false
	end

	local var1_30, var2_30, var3_30 = var0_0.GetWordAndCV(arg0_30, arg1_30, arg2_30, nil, arg3_30)
	local var4_30, var5_30, var6_30 = var0_0.GetWordAndCV(var0_30, arg1_30, arg2_30, nil, arg3_30)

	return not var8_0(var3_30) and var3_30 ~= var6_30
end

function var0_0.ExistExCv(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31, var1_31 = var15_0(arg0_31, arg1_31, {
		arg2_31
	}, arg3_31)

	if var0_31 then
		return HXSet.hxLan(var0_31), var1_31
	end
end

function var0_0.GetCvDataForShip(arg0_32, arg1_32)
	if arg1_32 == "" then
		return nil
	end

	local var0_32 = arg0_32:getSkinId()
	local var1_32 = arg0_32:getCVIntimacy()
	local var2_32 = string.split(arg1_32, "_")
	local var3_32
	local var4_32
	local var5_32
	local var6_32
	local var7_32
	local var8_32

	if var2_32[1] == "main" then
		var3_32, var5_32, var4_32 = ShipWordHelper.GetWordAndCV(var0_32, var2_32[1], tonumber(var2_32[2]), nil, var1_32)
		var6_32 = ShipWordHelper.GetL2dCvCalibrate(var0_32, var2_32[1], tonumber(var2_32[2]))
		var7_32 = ShipWordHelper.GetL2dSoundEffect(var0_32, var2_32[1], tonumber(var2_32[2]))
	else
		var3_32, var5_32, var4_32 = ShipWordHelper.GetWordAndCV(var0_32, arg1_32, nil, nil, var1_32)
		var6_32 = ShipWordHelper.GetL2dCvCalibrate(var0_32, arg1_32)
		var7_32 = ShipWordHelper.GetL2dSoundEffect(var0_32, arg1_32)
	end

	local var9_32 = var6_32 == -1

	return var3_32, var5_32, var4_32, var6_32, var7_32, var9_32
end

return var0_0
