local var0_0 = class("ShipProfileCvBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1._go = go(arg1_1)
	arg0_1.nameTxt = arg0_1._tf:Find("Text"):GetComponent(typeof(Text))

	setActive(arg0_1._tf:Find("tag_common"), true)

	arg0_1.tagDiff = arg0_1._tf:Find("tag_diff")
	arg0_1.playIcon = arg0_1._tf:Find("play_icon")
end

function var0_0.Init(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.shipGroup = arg1_2
	arg0_2.isLive2d = arg3_2
	arg0_2.skin = arg2_2
	arg0_2.voice = arg4_2
	arg0_2.words = pg.ship_skin_words[arg0_2.skin.id]

	local var0_2 = arg0_2.voice.key
	local var1_2 = arg1_2:getIntimacyName(var0_2)

	if var1_2 then
		arg0_2.voice = setmetatable({
			voice_name = var1_2
		}, {
			__index = arg4_2
		})
	end

	local var2_2
	local var3_2
	local var4_2
	local var5_2
	local var6_2
	local var7_2
	local var8_2 = arg4_2.key

	if string.find(var8_2, ShipWordHelper.WORD_TYPE_MAIN) then
		local var9_2 = string.gsub(var8_2, ShipWordHelper.WORD_TYPE_MAIN, "")

		var5_2 = tonumber(var9_2)
		var2_2, var3_2, var4_2 = ShipWordHelper.GetWordAndCV(arg0_2.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var5_2)

		if arg0_2.isLive2d then
			var6_2 = ShipWordHelper.GetL2dCvCalibrate(arg0_2.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var5_2)
			var7_2 = ShipWordHelper.GetL2dSoundEffect(arg0_2.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var5_2)
		end
	else
		var2_2, var3_2, var4_2 = ShipWordHelper.GetWordAndCV(arg0_2.skin.id, var8_2)

		if arg0_2.isLive2d then
			var6_2 = ShipWordHelper.GetL2dCvCalibrate(arg0_2.skin.id, var8_2)
			var7_2 = ShipWordHelper.GetL2dSoundEffect(arg0_2.skin.id, var8_2)
		end
	end

	arg0_2.l2dEventFlag = var6_2 == -1
	var6_2 = arg0_2.l2dEventFlag and 0 or var6_2
	arg0_2.wordData = {
		maxfavor = 0,
		cvKey = var2_2,
		cvPath = var3_2,
		textContent = var4_2,
		mainIndex = var5_2,
		voiceCalibrate = var6_2,
		se = var7_2
	}
end

function var0_0.Update(arg0_3)
	local var0_3 = arg0_3.voice
	local var1_3 = var0_3.unlock_condition[1] < 0
	local var2_3 = arg0_3.wordData.textContent == nil or arg0_3.wordData.textContent == "nil" or arg0_3.wordData.textContent == ""

	if not arg0_3.isLive2d then
		var1_3 = var1_3 or var2_3
	else
		local var3_3 = var0_3.l2d_action:match("^" .. ShipWordHelper.WORD_TYPE_MAIN .. "_")

		var1_3 = var1_3 or var2_3 and var3_3
	end

	setActive(arg0_3._tf, not var1_3)

	if not var1_3 then
		arg0_3:UpdateCvBtn()
		arg0_3:UpdateIcon()
	end
end

function var0_0.UpdateCvBtn(arg0_4)
	local var0_4 = arg0_4.voice
	local var1_4, var2_4 = arg0_4.shipGroup:VoiceReplayCodition(var0_4)
	local var3_4 = var1_4 and var0_4.voice_name or "???"

	arg0_4.nameTxt.text = var3_4

	local var4_4 = ShipWordHelper.ExistDifferentWord(arg0_4.skin.id, var0_4.key, arg0_4.wordData.mainIndex)

	setActive(arg0_4.tagDiff, var4_4)

	if not var1_4 then
		onButton(nil, arg0_4._tf, function()
			pg.TipsMgr.GetInstance():ShowTips(var2_4)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateIcon(arg0_6)
	local var0_6 = arg0_6.voice.key == "unlock" and checkABExist("ui/skinunlockanim/star_level_unlock_anim_" .. arg0_6.skin.id)

	setActive(arg0_6.playIcon, var0_6)
end

function var0_0.L2dHasEvent(arg0_7)
	return arg0_7.l2dEventFlag
end

function var0_0.isEx(arg0_8)
	return false
end

function var0_0.Destroy(arg0_9)
	Destroy(arg0_9._go)
	removeOnButton(arg0_9._tf)
end

return var0_0
