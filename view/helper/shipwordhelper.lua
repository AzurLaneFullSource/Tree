local var0_0 = class("ShipWordHelper")
local var1_0 = pg.ship_skin_template
local var2_0 = pg.ship_skin_words
local var3_0 = pg.ship_skin_words_extra
local var4_0 = pg.ship_skin_words_add
local var5_0 = pg.character_voice
local var6_0 = pg.voice_actor_CN

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

local var7_0 = false

local function var8_0(...)
	if var7_0 and IsUnityEditor then
		print(...)
	end
end

local function var9_0(arg0_2)
	if not arg0_2 or arg0_2 == "" or arg0_2 == "nil" then
		return true
	end
end

local function var10_0(arg0_3)
	return var3_0[arg0_3] ~= nil
end

local function var11_0(arg0_4)
	return var2_0[arg0_4] ~= nil
end

local function var12_0(arg0_5)
	local var0_5 = var1_0[arg0_5].ship_group

	return ShipGroup.getDefaultSkin(var0_5).id
end

local function var13_0(arg0_6, arg1_6)
	arg0_6 = arg0_6 or ""

	if type(arg0_6) == "table" then
		return arg0_6
	else
		local var0_6 = string.split(arg0_6, "|")

		arg1_6[1] = arg1_6[1] or math.random(#var0_6)

		return var0_6[arg1_6[1]]
	end
end

local function var14_0(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = var12_0(arg0_7)
	local var1_7 = var11_0(arg0_7) and arg0_7 or var0_7
	local var2_7 = var2_0[var1_7]

	if not var2_0[var1_7] then
		return nil
	end

	local var3_7 = var1_7 == var0_7

	if var3_7 and arg0_7 ~= var0_7 and arg3_7 then
		arg3_7[1] = true
	end

	local var4_7 = var13_0(var2_7[arg1_7], arg2_7)

	if (type(var4_7) == "table" and #var4_7 == 0 or var9_0(var4_7)) and not var3_7 then
		if arg3_7 then
			arg3_7[1] = true
		end

		var2_7 = var2_0[var0_7]
	end

	return var2_7
end

local function var15_0(arg0_8, arg1_8, arg2_8)
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
		return var13_0(var0_8[2], arg2_8), var0_8[1]
	end
end

local function var16_0(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = var12_0(arg0_9)
	local var1_9 = var11_0(arg0_9) and arg0_9 or var0_9
	local var2_9 = var3_0[var1_9]

	if not var2_9 then
		return nil
	end

	local var3_9 = var2_9[arg1_9]

	if var1_9 == var0_9 and arg0_9 ~= var0_9 and arg4_9 then
		arg4_9[1] = true
	end

	if var9_0(var3_9) then
		return nil
	end

	return var15_0(var3_9, arg3_9, arg2_9)
end

local function var17_0(arg0_10)
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
	return var17_0(arg0_11)
end

local function var18_0(arg0_12, arg1_12, arg2_12)
	local var0_12 = "event:/cv/" .. arg1_12 .. "/" .. arg0_12

	if arg2_12 then
		var0_12 = var0_12 .. "_" .. arg2_12
	end

	return var0_12
end

local function var19_0(arg0_13, arg1_13)
	local var0_13 = var2_0[arg1_13]

	if not var0_13 then
		return -1
	end

	local function var1_13(arg0_14)
		return arg0_13 == 2 and arg0_14.voice_key_2 >= 0 and arg0_14.voice_key_2 or arg0_14.voice_key
	end

	local var2_13 = var1_13(var0_13)

	if var2_13 == 0 or var2_13 == -2 then
		local var3_13 = var12_0(arg1_13)
		local var4_13 = var2_0[var3_13]

		var2_13 = var1_13(var4_13)
	end

	return var2_13
end

local function var20_0(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	if arg0_15 then
		local var0_15
		local var1_15
		local var2_15 = var17_0(arg1_15)
		local var3_15 = var2_15 == 2 and arg0_15.voice_key_2 or arg0_15.voice_key
		local var4_15 = arg2_15 == var0_0.WORD_TYPE_MAIN
		local var5_15 = var4_15 and arg2_15 .. arg3_15[1] or arg2_15
		local var6_15 = var5_0[var5_15]
		local var7_15 = var6_15 and var6_15.resource_key

		if not var7_15 and var4_15 then
			var7_15 = arg2_15 .. "_" .. arg3_15[1]
		end

		if var3_15 ~= var0_0.CV_KEY_BAN and var7_15 then
			var0_15 = var19_0(var2_15, arg1_15)

			local var8_15

			if arg4_15 and var3_15 == var0_0.CV_KEY_REPALCE then
				local var9_15 = var1_0[arg1_15].group_index

				if var9_15 ~= 0 then
					var8_15 = var9_15
				end
			end

			var1_15 = var18_0(var7_15, var0_15, var8_15)
		end

		return var0_15, var1_15
	end
end

local function var21_0(arg0_16, arg1_16, arg2_16)
	local var0_16 = var0_0.ExistDifferentWord(arg0_16, arg1_16, arg2_16)
	local var1_16 = var2_0[arg0_16].voice_key == var0_0.CV_KEY_BAN_NEW

	return var0_16 and var1_16
end

local function var22_0(arg0_17, arg1_17)
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

local var23_0

local function var24_0(arg0_18, arg1_18)
	local var0_18 = var2_0[arg0_18]

	if not var0_18 then
		return
	end

	if not var0_18[arg1_18] and var4_0[arg0_18] and var4_0[arg0_18][arg1_18] then
		local var1_18 = var12_0(arg0_18)

		if var1_18 ~= arg0_18 then
			var24_0(var1_18, arg1_18)
		end

		setmetatable(var2_0[arg0_18], {
			__index = function(arg0_19, arg1_19)
				return var4_0[arg0_18][arg1_19]
			end
		})
	end
end

function var0_0.GetWordAndCV(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	local var0_20
	local var1_20
	local var2_20
	local var3_20 = {
		false
	}
	local var4_20 = {
		arg2_20
	}
	local var5_20, var6_20 = var16_0(arg0_20, arg1_20, var4_20, arg4_20, var3_20)

	if not var9_0(var5_20) then
		var0_20 = var5_20
		var1_20 = var14_0(arg0_20, arg1_20, var4_20)
	else
		var4_20 = {
			arg2_20
		}
		var3_20 = {
			false
		}
		var1_20 = var14_0(arg0_20, arg1_20, var4_20, var3_20)

		if var0_0.WORD_TYPE_MAIN == arg1_20 then
			local var7_20
			local var8_20 = {}
			local var9_20, var10_20 = var22_0(arg0_20, arg4_20)

			if var9_20 then
				var4_20 = {
					arg2_20
				}
			end

			local var11_20

			if var9_20 and var1_20 and var1_20[arg1_20] then
				var11_20 = var1_20[arg1_20] .. "|" .. var9_20
			elseif var9_20 and (not var1_20 or not var1_20[arg1_20]) then
				var11_20 = var9_20
			elseif not var9_20 and var1_20 and var1_20[arg1_20] then
				var11_20 = var1_20[arg1_20]
			end

			var0_20 = var13_0(var11_20, var4_20)
			var2_20 = var10_20 and var10_20[var0_20]
		elseif var1_20 then
			var0_20 = var13_0(var1_20[arg1_20], var4_20)
		end
	end

	local var12_20
	local var13_20

	if not var21_0(arg0_20, arg1_20, arg2_20) then
		var12_20, var13_20 = var20_0(var1_20, arg0_20, arg1_20, var4_20, not var3_20[1])

		if var13_20 and not var9_0(var5_20) and var6_20 then
			var13_20 = var13_20 .. "_ex" .. var6_20
		elseif var13_20 and var2_20 then
			var13_20 = var13_20 .. "_ex" .. var2_20
		end
	end

	if type(var0_20) ~= "table" then
		if var0_20 and arg3_20 then
			var0_20 = SwitchSpecialChar(var0_20, true)
		end

		var0_20 = var0_20 and HXSet.hxLan(var0_20)
	end

	var8_0("cv:", var13_20, "cvkey:", var12_20, "word:", var0_20)

	return var12_20, var13_20, var0_20
end

function var0_0.RawGetWord(arg0_21, arg1_21)
	return var2_0[arg0_21][arg1_21]
end

function var0_0.RawGetCVKey(arg0_22)
	local var0_22 = var17_0(arg0_22)

	return var19_0(var0_22, arg0_22)
end

function var0_0.GetDefaultSkin(arg0_23)
	return var12_0(arg0_23)
end

function var0_0.GetMainSceneWordCnt(arg0_24, arg1_24)
	local var0_24 = var2_0[arg0_24]

	if not var0_24 or not var0_24[var0_0.WORD_TYPE_MAIN] or var0_24[var0_0.WORD_TYPE_MAIN] == "" then
		local var1_24 = var12_0(arg0_24)

		var0_24 = var2_0[var1_24]
	end

	local var2_24 = 0

	if var0_24 and var0_24[var0_0.WORD_TYPE_MAIN] and var0_24[var0_0.WORD_TYPE_MAIN] ~= "" then
		var2_24 = #string.split(var0_24[var0_0.WORD_TYPE_MAIN], "|")
	end

	local var3_24, var4_24 = var22_0(arg0_24, arg1_24)

	if var3_24 then
		var2_24 = var2_24 + table.getCount(var4_24)
	end

	return var2_24
end

function var0_0.GetL2dCvCalibrate(arg0_25, arg1_25, arg2_25)
	local var0_25 = var1_0[arg0_25]

	if not var0_25 then
		return 0
	end

	if type(var0_25.l2d_voice_calibrate) == "table" and var0_25.l2d_voice_calibrate.use_event then
		return -1
	end

	if arg1_25 == var0_0.WORD_TYPE_MAIN then
		arg1_25 = arg1_25 .. "_" .. arg2_25
	end

	return var0_25.l2d_voice_calibrate[arg1_25]
end

function var0_0.GetL2dSoundEffect(arg0_26, arg1_26, arg2_26)
	local var0_26 = var1_0[arg0_26]

	if not var0_26 then
		return 0
	end

	if arg1_26 == var0_0.WORD_TYPE_MAIN then
		arg1_26 = arg1_26 .. "_" .. arg2_26
	end

	return var0_26.l2d_se[arg1_26]
end

function var0_0.ExistVoiceKey(arg0_27)
	local var0_27 = var2_0[arg0_27]

	return var0_27 and var0_27.voice_key ~= var0_0.CV_KEY_BAN
end

function var0_0.GetCVAuthor(arg0_28)
	local var0_28 = var1_0[arg0_28]
	local var1_28 = var17_0(arg0_28) == 2 and var0_28.voice_actor_2 or var0_28.voice_actor
	local var2_28 = ""

	return var1_28 == var0_0.CV_KEY_BAN and "-" or var6_0[var1_28].actor_name
end

function var0_0.GetCVList()
	local var0_29 = {}

	for iter0_29, iter1_29 in pairs(pg.character_voice) do
		if not pg.AssistantInfo.isDisableSpecialClick(iter1_29.key) and iter1_29.unlock_condition[1] >= 0 then
			var0_29[#var0_29 + 1] = setmetatable({}, {
				__index = iter1_29
			})
		end
	end

	return var0_29
end

function var0_0.ExistDifferentWord(arg0_30, arg1_30, arg2_30)
	if var12_0(arg0_30) == arg0_30 then
		return false
	end

	local var0_30 = var2_0[arg0_30]
	local var1_30

	if string.find(arg1_30, "main") then
		local var2_30 = var0_30[var0_0.WORD_TYPE_MAIN]

		var1_30 = string.split(var2_30, "|")[arg2_30]
	else
		var1_30 = var0_30[arg1_30]
	end

	return not not var1_30 and var1_30 ~= "" and var1_30 ~= "nil"
end

function var0_0.ExistDifferentExWord(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = var12_0(arg0_31)

	if arg0_31 == var0_31 then
		return false
	end

	local var1_31 = arg1_31

	if string.find(arg1_31, "main") then
		var1_31 = var0_0.WORD_TYPE_MAIN
	end

	local var2_31 = var16_0(arg0_31, var1_31, {
		arg2_31
	}, arg3_31)
	local var3_31 = var16_0(var0_31, var1_31, {
		arg2_31
	}, arg3_31)

	return not var9_0(var2_31) and var2_31 ~= var3_31
end

function var0_0.ExistDifferentMainExWord(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = var12_0(arg0_32)

	if arg0_32 == var0_32 then
		return false
	end

	local var1_32, var2_32, var3_32 = var0_0.GetWordAndCV(arg0_32, arg1_32, arg2_32, nil, arg3_32)
	local var4_32, var5_32, var6_32 = var0_0.GetWordAndCV(var0_32, arg1_32, arg2_32, nil, arg3_32)

	return not var9_0(var3_32) and var3_32 ~= var6_32
end

function var0_0.ExistExCv(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33, var1_33 = var16_0(arg0_33, arg1_33, {
		arg2_33
	}, arg3_33)

	if var0_33 then
		return HXSet.hxLan(var0_33), var1_33
	end
end

function var0_0.GetCvDataForShip(arg0_34, arg1_34)
	if arg1_34 == "" then
		return nil
	end

	local var0_34 = arg0_34:getCVIntimacy()
	local var1_34 = string.split(arg1_34, "_")
	local var2_34
	local var3_34
	local var4_34
	local var5_34
	local var6_34
	local var7_34

	if var1_34[1] == "main" then
		var2_34, var4_34, var3_34 = ShipWordHelper.GetWordAndCV(arg0_34.skinId, var1_34[1], tonumber(var1_34[2]), nil, var0_34)
		var5_34 = ShipWordHelper.GetL2dCvCalibrate(arg0_34.skinId, var1_34[1], tonumber(var1_34[2]))
		var6_34 = ShipWordHelper.GetL2dSoundEffect(arg0_34.skinId, var1_34[1], tonumber(var1_34[2]))
	else
		var2_34, var4_34, var3_34 = ShipWordHelper.GetWordAndCV(arg0_34.skinId, arg1_34, nil, nil, var0_34)
		var5_34 = ShipWordHelper.GetL2dCvCalibrate(arg0_34.skinId, arg1_34)
		var6_34 = ShipWordHelper.GetL2dSoundEffect(arg0_34.skinId, arg1_34)
	end

	local var8_34 = var5_34 == -1

	return var2_34, var4_34, var3_34, var5_34, var6_34, var8_34
end

return var0_0
