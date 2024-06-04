local var0 = class("ShipWordHelper")
local var1 = pg.ship_skin_template
local var2 = pg.ship_skin_words
local var3 = pg.ship_skin_words_extra
local var4 = pg.ship_skin_words_add
local var5 = pg.character_voice
local var6 = pg.voice_actor_CN

var0.WORD_TYPE_MAIN = "main"
var0.WORD_TYPE_SKILL = "skill"
var0.WORD_TYPE_UNLOCK = "unlock"
var0.WORD_TYPE_PROFILE = "profile"
var0.WORD_TYPE_DROP = "drop_descrip"
var0.WORD_TYPE_MVP = "win_mvp"
var0.WORD_TYPE_LOSE = "lose"
var0.WORD_TYPE_UPGRADE = "upgrade"
var0.CV_KEY_REPALCE = 0
var0.CV_KEY_BAN = -1
var0.CV_KEY_BAN_NEW = -2
var0.CVBattleKey = {
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

local var7 = false

local function var8(...)
	if var7 and IsUnityEditor then
		print(...)
	end
end

local function var9(arg0)
	if not arg0 or arg0 == "" or arg0 == "nil" then
		return true
	end
end

local function var10(arg0)
	return var3[arg0] ~= nil
end

local function var11(arg0)
	return var2[arg0] ~= nil
end

local function var12(arg0)
	local var0 = var1[arg0].ship_group

	return ShipGroup.getDefaultSkin(var0).id
end

local function var13(arg0, arg1)
	arg0 = arg0 or ""

	if type(arg0) == "table" then
		return arg0
	else
		local var0 = string.split(arg0, "|")

		arg1[1] = arg1[1] or math.random(#var0)

		return var0[arg1[1]]
	end
end

local function var14(arg0, arg1, arg2, arg3)
	local var0 = var12(arg0)
	local var1 = var11(arg0) and arg0 or var0
	local var2 = var2[var1]

	if not var2[var1] then
		return nil
	end

	local var3 = var1 == var0

	if var3 and arg0 ~= var0 and arg3 then
		arg3[1] = true
	end

	local var4 = var13(var2[arg1], arg2)

	if (type(var4) == "table" and #var4 == 0 or var9(var4)) and not var3 then
		if arg3 then
			arg3[1] = true
		end

		var2 = var2[var0]
	end

	return var2
end

local function var15(arg0, arg1, arg2)
	arg1 = arg1 or 0

	local var0

	for iter0, iter1 in ipairs(arg0) do
		local var1 = iter1[1]
		local var2 = iter1[2]

		if var1 <= arg1 then
			var0 = iter1

			break
		end
	end

	if var0 then
		return var13(var0[2], arg2), var0[1]
	end
end

local function var16(arg0, arg1, arg2, arg3, arg4)
	local var0 = var12(arg0)
	local var1 = var11(arg0) and arg0 or var0
	local var2 = var3[var1]

	if not var2 then
		return nil
	end

	local var3 = var2[arg1]

	if var1 == var0 and arg0 ~= var0 and arg4 then
		arg4[1] = true
	end

	if var9(var3) then
		return nil
	end

	return var15(var3, arg3, arg2)
end

local function var17(arg0)
	local var0 = pg.ship_skin_words[arg0]
	local var1 = var1[arg0].ship_group
	local var2 = PlayerPrefs.GetInt(CV_LANGUAGE_KEY .. var1)

	if PLATFORM_CODE == PLATFORM_CH and (arg0 == 407010 or arg0 == 407020 or arg0 == 204010 or arg0 == 204040 or arg0 == 9704040 or arg0 == 303120 or arg0 == 305070 or arg0 == 307020) and var2 == 2 then
		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var1, 1)
		PlayerPrefs.Save()

		var2 = 1
	end

	return var2
end

function var0.GetLanguageSetting(arg0)
	return var17(arg0)
end

local function var18(arg0, arg1, arg2)
	local var0 = "event:/cv/" .. arg1 .. "/" .. arg0

	if arg2 then
		var0 = var0 .. "_" .. arg2
	end

	return var0
end

local function var19(arg0, arg1)
	local var0 = var2[arg1]

	if not var0 then
		return -1
	end

	local function var1(arg0)
		return arg0 == 2 and arg0.voice_key_2 >= 0 and arg0.voice_key_2 or arg0.voice_key
	end

	local var2 = var1(var0)

	if var2 == 0 or var2 == -2 then
		local var3 = var12(arg1)
		local var4 = var2[var3]

		var2 = var1(var4)
	end

	return var2
end

local function var20(arg0, arg1, arg2, arg3, arg4)
	if arg0 then
		local var0
		local var1
		local var2 = var17(arg1)
		local var3 = var2 == 2 and arg0.voice_key_2 or arg0.voice_key
		local var4 = arg2 == var0.WORD_TYPE_MAIN
		local var5 = var4 and arg2 .. arg3[1] or arg2
		local var6 = var5[var5]
		local var7 = var6 and var6.resource_key

		if not var7 and var4 then
			var7 = arg2 .. "_" .. arg3[1]
		end

		if var3 ~= var0.CV_KEY_BAN and var7 then
			var0 = var19(var2, arg1)

			local var8

			if arg4 and var3 == var0.CV_KEY_REPALCE then
				local var9 = var1[arg1].group_index

				if var9 ~= 0 then
					var8 = var9
				end
			end

			var1 = var18(var7, var0, var8)
		end

		return var0, var1
	end
end

local function var21(arg0, arg1, arg2)
	local var0 = var0.ExistDifferentWord(arg0, arg1, arg2)
	local var1 = var2[arg0].voice_key == var0.CV_KEY_BAN_NEW

	return var0 and var1
end

local function var22(arg0, arg1)
	arg1 = arg1 or -1

	local var0 = var3[arg0]

	if not var0 or not var0.main_extra or var0.main_extra == "" or type(var0.main_extra) == "table" and #var0.main_extra == 0 then
		return nil
	end

	local var1
	local var2 = {}

	for iter0, iter1 in ipairs(var0.main_extra) do
		local var3 = iter1[1]
		local var4 = iter1[2]

		if var3 <= arg1 then
			var1 = var1 and var1 .. "|" .. var4 or var4

			local var5 = string.split(var4, "|")

			for iter2, iter3 in ipairs(var5) do
				var2[iter3] = var3
			end
		end
	end

	return var1, var2
end

local var23

local function var24(arg0, arg1)
	local var0 = var2[arg0]

	if not var0 then
		return
	end

	if not var0[arg1] and var4[arg0] and var4[arg0][arg1] then
		local var1 = var12(arg0)

		if var1 ~= arg0 then
			var24(var1, arg1)
		end

		setmetatable(var2[arg0], {
			__index = function(arg0, arg1)
				return var4[arg0][arg1]
			end
		})
	end
end

function var0.GetWordAndCV(arg0, arg1, arg2, arg3, arg4)
	local var0
	local var1
	local var2
	local var3 = {
		false
	}
	local var4 = {
		arg2
	}
	local var5, var6 = var16(arg0, arg1, var4, arg4, var3)

	if not var9(var5) then
		var0 = var5
		var1 = var14(arg0, arg1, var4)
	else
		var4 = {
			arg2
		}
		var3 = {
			false
		}
		var1 = var14(arg0, arg1, var4, var3)

		if var0.WORD_TYPE_MAIN == arg1 then
			local var7
			local var8 = {}
			local var9, var10 = var22(arg0, arg4)

			if var9 then
				var4 = {
					arg2
				}
			end

			local var11

			if var9 and var1 and var1[arg1] then
				var11 = var1[arg1] .. "|" .. var9
			elseif var9 and (not var1 or not var1[arg1]) then
				var11 = var9
			elseif not var9 and var1 and var1[arg1] then
				var11 = var1[arg1]
			end

			var0 = var13(var11, var4)
			var2 = var10 and var10[var0]
		elseif var1 then
			var0 = var13(var1[arg1], var4)
		end
	end

	local var12
	local var13

	if not var21(arg0, arg1, arg2) then
		var12, var13 = var20(var1, arg0, arg1, var4, not var3[1])

		if var13 and not var9(var5) and var6 then
			var13 = var13 .. "_ex" .. var6
		elseif var13 and var2 then
			var13 = var13 .. "_ex" .. var2
		end
	end

	if type(var0) ~= "table" then
		if var0 and arg3 then
			var0 = SwitchSpecialChar(var0, true)
		end

		var0 = var0 and HXSet.hxLan(var0)
	end

	var8("cv:", var13, "cvkey:", var12, "word:", var0)

	return var12, var13, var0
end

function var0.RawGetWord(arg0, arg1)
	return var2[arg0][arg1]
end

function var0.RawGetCVKey(arg0)
	local var0 = var17(arg0)

	return var19(var0, arg0)
end

function var0.GetDefaultSkin(arg0)
	return var12(arg0)
end

function var0.GetMainSceneWordCnt(arg0, arg1)
	local var0 = var2[arg0]

	if not var0 or not var0[var0.WORD_TYPE_MAIN] or var0[var0.WORD_TYPE_MAIN] == "" then
		local var1 = var12(arg0)

		var0 = var2[var1]
	end

	local var2 = 0

	if var0 and var0[var0.WORD_TYPE_MAIN] and var0[var0.WORD_TYPE_MAIN] ~= "" then
		var2 = #string.split(var0[var0.WORD_TYPE_MAIN], "|")
	end

	local var3, var4 = var22(arg0, arg1)

	if var3 then
		var2 = var2 + table.getCount(var4)
	end

	return var2
end

function var0.GetL2dCvCalibrate(arg0, arg1, arg2)
	local var0 = var1[arg0]

	if not var0 then
		return 0
	end

	if type(var0.l2d_voice_calibrate) == "table" and var0.l2d_voice_calibrate.use_event then
		return -1
	end

	if arg1 == var0.WORD_TYPE_MAIN then
		arg1 = arg1 .. "_" .. arg2
	end

	return var0.l2d_voice_calibrate[arg1]
end

function var0.GetL2dSoundEffect(arg0, arg1, arg2)
	local var0 = var1[arg0]

	if not var0 then
		return 0
	end

	if arg1 == var0.WORD_TYPE_MAIN then
		arg1 = arg1 .. "_" .. arg2
	end

	return var0.l2d_se[arg1]
end

function var0.ExistVoiceKey(arg0)
	local var0 = var2[arg0]

	return var0 and var0.voice_key ~= var0.CV_KEY_BAN
end

function var0.GetCVAuthor(arg0)
	local var0 = var1[arg0]
	local var1 = var17(arg0) == 2 and var0.voice_actor_2 or var0.voice_actor
	local var2 = ""

	return var1 == var0.CV_KEY_BAN and "-" or var6[var1].actor_name
end

function var0.GetCVList()
	local var0 = {}

	for iter0, iter1 in pairs(pg.character_voice) do
		if not pg.AssistantInfo.isDisableSpecialClick(iter1.key) and iter1.unlock_condition[1] >= 0 then
			var0[#var0 + 1] = setmetatable({}, {
				__index = iter1
			})
		end
	end

	return var0
end

function var0.ExistDifferentWord(arg0, arg1, arg2)
	if var12(arg0) == arg0 then
		return false
	end

	local var0 = var2[arg0]
	local var1

	if string.find(arg1, "main") then
		local var2 = var0[var0.WORD_TYPE_MAIN]

		var1 = string.split(var2, "|")[arg2]
	else
		var1 = var0[arg1]
	end

	return not not var1 and var1 ~= "" and var1 ~= "nil"
end

function var0.ExistDifferentExWord(arg0, arg1, arg2, arg3)
	local var0 = var12(arg0)

	if arg0 == var0 then
		return false
	end

	local var1 = arg1

	if string.find(arg1, "main") then
		var1 = var0.WORD_TYPE_MAIN
	end

	local var2 = var16(arg0, var1, {
		arg2
	}, arg3)
	local var3 = var16(var0, var1, {
		arg2
	}, arg3)

	return not var9(var2) and var2 ~= var3
end

function var0.ExistDifferentMainExWord(arg0, arg1, arg2, arg3)
	local var0 = var12(arg0)

	if arg0 == var0 then
		return false
	end

	local var1, var2, var3 = var0.GetWordAndCV(arg0, arg1, arg2, nil, arg3)
	local var4, var5, var6 = var0.GetWordAndCV(var0, arg1, arg2, nil, arg3)

	return not var9(var3) and var3 ~= var6
end

function var0.ExistExCv(arg0, arg1, arg2, arg3)
	local var0, var1 = var16(arg0, arg1, {
		arg2
	}, arg3)

	if var0 then
		return HXSet.hxLan(var0), var1
	end
end

function var0.GetCvDataForShip(arg0, arg1)
	if arg1 == "" then
		return nil
	end

	local var0 = arg0:getCVIntimacy()
	local var1 = string.split(arg1, "_")
	local var2
	local var3
	local var4
	local var5
	local var6
	local var7

	if var1[1] == "main" then
		var2, var4, var3 = ShipWordHelper.GetWordAndCV(arg0.skinId, var1[1], tonumber(var1[2]), nil, var0)
		var5 = ShipWordHelper.GetL2dCvCalibrate(arg0.skinId, var1[1], tonumber(var1[2]))
		var6 = ShipWordHelper.GetL2dSoundEffect(arg0.skinId, var1[1], tonumber(var1[2]))
	else
		var2, var4, var3 = ShipWordHelper.GetWordAndCV(arg0.skinId, arg1, nil, nil, var0)
		var5 = ShipWordHelper.GetL2dCvCalibrate(arg0.skinId, arg1)
		var6 = ShipWordHelper.GetL2dSoundEffect(arg0.skinId, arg1)
	end

	local var8 = var5 == -1

	return var2, var4, var3, var5, var6, var8
end

return var0
