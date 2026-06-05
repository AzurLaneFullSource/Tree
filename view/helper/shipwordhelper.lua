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
var0_0.CVGiftKey = {
	gift_prefer = "gift_prefer",
	present_like = "present_like"
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

	if not var3_7 and (type(var4_7) == "table" and #var4_7 == 0 or var8_0(var4_7)) then
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

	if var2_10 == 2 and underscore.any(getGameset("profile_cvchange_button_block")[2], function(arg0_11)
		return arg0_10 == arg0_11
	end) then
		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var1_10, 1)
		PlayerPrefs.Save()

		var2_10 = 1
	end

	return var2_10
end

function var0_0.GetLanguageSetting(arg0_12)
	return var16_0(arg0_12)
end

local function var17_0(arg0_13, arg1_13, arg2_13)
	local var0_13 = "event:/cv/" .. arg1_13 .. "/" .. arg0_13

	if arg2_13 then
		var0_13 = var0_13 .. "_" .. arg2_13
	end

	return var0_13
end

local function var18_0(arg0_14, arg1_14)
	local var0_14 = var2_0[arg1_14]

	if not var0_14 then
		return -1
	end

	local function var1_14(arg0_15)
		return arg0_14 == 2 and arg0_15.voice_key_2 >= 0 and arg0_15.voice_key_2 or arg0_15.voice_key
	end

	local var2_14 = var1_14(var0_14)

	if var2_14 == 0 or var2_14 == -2 then
		local var3_14 = var11_0(arg1_14)
		local var4_14 = var2_0[var3_14]

		var2_14 = var1_14(var4_14)
	end

	return var2_14
end

local function var19_0(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	if arg0_16 then
		local var0_16
		local var1_16
		local var2_16 = var16_0(arg1_16)
		local var3_16 = var2_16 == 2 and arg0_16.voice_key_2 or arg0_16.voice_key
		local var4_16 = arg2_16 == var0_0.WORD_TYPE_MAIN
		local var5_16 = var4_16 and arg2_16 .. arg3_16[1] or arg2_16
		local var6_16 = var4_0[var5_16]
		local var7_16 = var6_16 and var6_16.resource_key

		if not var7_16 and var4_16 then
			var7_16 = arg2_16 .. "_" .. arg3_16[1]
		end

		if var3_16 ~= var0_0.CV_KEY_BAN and var7_16 then
			var0_16 = var18_0(var2_16, arg1_16)

			local var8_16

			if arg4_16 and var3_16 == var0_0.CV_KEY_REPALCE then
				local var9_16 = var1_0[arg1_16].group_index

				if var9_16 ~= 0 then
					var8_16 = var9_16
				end
			end

			var1_16 = var17_0(var7_16, var0_16, var8_16)
		end

		return var0_16, var1_16
	end
end

local function var20_0(arg0_17, arg1_17, arg2_17)
	local var0_17 = var0_0.ExistDifferentWord(arg0_17, arg1_17, arg2_17)
	local var1_17 = var2_0[arg0_17].voice_key == var0_0.CV_KEY_BAN_NEW

	return var0_17 and var1_17
end

local function var21_0(arg0_18, arg1_18)
	arg1_18 = arg1_18 or -1

	local var0_18 = var3_0[arg0_18]

	if not var0_18 or not var0_18.main_extra or var0_18.main_extra == "" or type(var0_18.main_extra) == "table" and #var0_18.main_extra == 0 then
		return nil
	end

	local var1_18
	local var2_18 = {}

	for iter0_18, iter1_18 in ipairs(var0_18.main_extra) do
		local var3_18 = iter1_18[1]
		local var4_18 = iter1_18[2]

		if var3_18 <= arg1_18 then
			var1_18 = var1_18 and var1_18 .. "|" .. var4_18 or var4_18

			local var5_18 = string.split(var4_18, "|")

			for iter2_18, iter3_18 in ipairs(var5_18) do
				var2_18[iter3_18] = var3_18
			end
		end
	end

	return var1_18, var2_18
end

function var0_0.GetWordAndCV(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19
	local var1_19
	local var2_19
	local var3_19 = {
		false
	}
	local var4_19 = {
		arg2_19
	}
	local var5_19, var6_19 = var15_0(arg0_19, arg1_19, var4_19, arg4_19, var3_19)

	if not var8_0(var5_19) then
		var0_19 = var5_19
		var1_19 = var13_0(arg0_19, arg1_19, var4_19)
	else
		var4_19 = {
			arg2_19
		}
		var3_19 = {
			false
		}
		var1_19 = var13_0(arg0_19, arg1_19, var4_19, var3_19)

		if var0_0.WORD_TYPE_MAIN == arg1_19 then
			local var7_19
			local var8_19 = {}
			local var9_19, var10_19 = var21_0(arg0_19, arg4_19)

			if var9_19 then
				var4_19 = {
					arg2_19
				}
			end

			local var11_19

			if var9_19 and var1_19 and var1_19[arg1_19] then
				var11_19 = var1_19[arg1_19] .. "|" .. var9_19
			elseif var9_19 and (not var1_19 or not var1_19[arg1_19]) then
				var11_19 = var9_19
			elseif not var9_19 and var1_19 and var1_19[arg1_19] then
				var11_19 = var1_19[arg1_19]
			end

			var0_19 = var12_0(var11_19, var4_19)
			var2_19 = var10_19 and var10_19[var0_19]
		elseif var1_19 then
			var0_19 = var12_0(var1_19[arg1_19], var4_19)
		end
	end

	local var12_19
	local var13_19

	if not var20_0(arg0_19, arg1_19, arg2_19) then
		var12_19, var13_19 = var19_0(var1_19, arg0_19, arg1_19, var4_19, not var3_19[1])

		if var13_19 and not var8_0(var5_19) and var6_19 then
			var13_19 = var13_19 .. "_ex" .. var6_19
		elseif var13_19 and var2_19 then
			var13_19 = var13_19 .. "_ex" .. var2_19
		end
	end

	if type(var0_19) ~= "table" then
		if var0_19 and arg3_19 then
			var0_19 = SwitchSpecialChar(var0_19, true)
		end

		var0_19 = var0_19 and HXSet.hxLan(var0_19)
	end

	var7_0("cv:", var13_19, "cvkey:", var12_19, "word:", var0_19)

	return var12_19, var13_19, var0_19
end

function var0_0.RawGetWord(arg0_20, arg1_20)
	return var2_0[arg0_20][arg1_20]
end

function var0_0.RawGetCVKey(arg0_21)
	local var0_21 = var16_0(arg0_21)

	return var18_0(var0_21, arg0_21)
end

function var0_0.GetDefaultSkin(arg0_22)
	return var11_0(arg0_22)
end

function var0_0.GetMainSceneWordCnt(arg0_23, arg1_23)
	local var0_23 = var2_0[arg0_23]

	if not var0_23 or not var0_23[var0_0.WORD_TYPE_MAIN] or var0_23[var0_0.WORD_TYPE_MAIN] == "" then
		local var1_23 = var11_0(arg0_23)

		var0_23 = var2_0[var1_23]
	end

	local var2_23 = 0

	if var0_23 and var0_23[var0_0.WORD_TYPE_MAIN] and var0_23[var0_0.WORD_TYPE_MAIN] ~= "" then
		var2_23 = #string.split(var0_23[var0_0.WORD_TYPE_MAIN], "|")
	end

	local var3_23, var4_23 = var21_0(arg0_23, arg1_23)

	if var3_23 then
		var2_23 = var2_23 + table.getCount(var4_23)
	end

	return var2_23
end

function var0_0.GetL2dCvCalibrate(arg0_24, arg1_24, arg2_24)
	local var0_24 = var1_0[arg0_24]

	if not var0_24 then
		return 0
	end

	if type(var0_24.l2d_voice_calibrate) == "table" and var0_24.l2d_voice_calibrate.use_event then
		return -1
	end

	if arg1_24 == var0_0.WORD_TYPE_MAIN then
		arg1_24 = arg1_24 .. "_" .. arg2_24
	end

	return var0_24.l2d_voice_calibrate[arg1_24]
end

function var0_0.GetL2dSoundEffect(arg0_25, arg1_25, arg2_25)
	local var0_25 = var1_0[arg0_25]

	if not var0_25 then
		return 0
	end

	if arg1_25 == var0_0.WORD_TYPE_MAIN then
		arg1_25 = arg1_25 .. "_" .. arg2_25
	end

	return var0_25.l2d_se[arg1_25]
end

function var0_0.ExistVoiceKey(arg0_26)
	local var0_26 = var2_0[arg0_26]

	return var0_26 and var0_26.voice_key ~= var0_0.CV_KEY_BAN
end

function var0_0.GetCVAuthor(arg0_27)
	local var0_27 = var1_0[arg0_27]
	local var1_27 = var16_0(arg0_27) == 2 and var0_27.voice_actor_2 or var0_27.voice_actor
	local var2_27 = ""

	return var1_27 == var0_0.CV_KEY_BAN and "-" or var5_0[var1_27].actor_name
end

function var0_0.GetCVList()
	local var0_28 = {}

	for iter0_28, iter1_28 in ipairs(pg.character_voice.all) do
		local var1_28 = pg.character_voice[iter1_28]

		if not pg.AssistantInfo.isDisableSpecialClick(var1_28.key) and var1_28.unlock_condition[1] >= 0 then
			var0_28[#var0_28 + 1] = setmetatable({}, {
				__index = var1_28
			})
		end
	end

	return var0_28
end

function var0_0.ExistDifferentWord(arg0_29, arg1_29, arg2_29)
	if var11_0(arg0_29) == arg0_29 then
		return false
	end

	local var0_29 = var2_0[arg0_29]
	local var1_29

	if string.find(arg1_29, "main") then
		local var2_29 = var0_29[var0_0.WORD_TYPE_MAIN]

		var1_29 = string.split(var2_29, "|")[arg2_29]
	else
		var1_29 = var0_29[arg1_29]
	end

	return not not var1_29 and var1_29 ~= "" and var1_29 ~= "nil"
end

function var0_0.ExistDifferentExWord(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = var11_0(arg0_30)

	if arg0_30 == var0_30 then
		return false
	end

	local var1_30 = arg1_30

	if string.find(arg1_30, "main") then
		var1_30 = var0_0.WORD_TYPE_MAIN
	end

	local var2_30 = var15_0(arg0_30, var1_30, {
		arg2_30
	}, arg3_30)
	local var3_30 = var15_0(var0_30, var1_30, {
		arg2_30
	}, arg3_30)

	return not var8_0(var2_30) and var2_30 ~= var3_30
end

function var0_0.ExistDifferentMainExWord(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = var11_0(arg0_31)

	if arg0_31 == var0_31 then
		return false
	end

	local var1_31, var2_31, var3_31 = var0_0.GetWordAndCV(arg0_31, arg1_31, arg2_31, nil, arg3_31)
	local var4_31, var5_31, var6_31 = var0_0.GetWordAndCV(var0_31, arg1_31, arg2_31, nil, arg3_31)

	return not var8_0(var3_31) and var3_31 ~= var6_31
end

function var0_0.ExistExCv(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32, var1_32 = var15_0(arg0_32, arg1_32, {
		arg2_32
	}, arg3_32)

	if var0_32 then
		return HXSet.hxLan(var0_32), var1_32
	end
end

function var0_0.GetCvDataForShip(arg0_33, arg1_33)
	if arg1_33 == "" then
		return nil
	end

	local var0_33 = arg0_33:getSkinId()
	local var1_33 = arg0_33:getCVIntimacy()
	local var2_33 = string.split(arg1_33, "_")
	local var3_33
	local var4_33
	local var5_33
	local var6_33
	local var7_33
	local var8_33

	if var2_33[1] == "main" then
		var3_33, var5_33, var4_33 = ShipWordHelper.GetWordAndCV(var0_33, var2_33[1], tonumber(var2_33[2]), nil, var1_33)
		var6_33 = ShipWordHelper.GetL2dCvCalibrate(var0_33, var2_33[1], tonumber(var2_33[2]))
		var7_33 = ShipWordHelper.GetL2dSoundEffect(var0_33, var2_33[1], tonumber(var2_33[2]))
	else
		var3_33, var5_33, var4_33 = ShipWordHelper.GetWordAndCV(var0_33, arg1_33, nil, nil, var1_33)
		var6_33 = ShipWordHelper.GetL2dCvCalibrate(var0_33, arg1_33)
		var7_33 = ShipWordHelper.GetL2dSoundEffect(var0_33, arg1_33)
	end

	local var9_33 = var6_33 == -1

	return var3_33, var5_33, var4_33, var6_33, var7_33, var9_33
end

return var0_0
