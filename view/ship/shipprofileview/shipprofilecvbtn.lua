local var0 = class("ShipProfileCvBtn")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0._go = go(arg1)
	arg0.nameTxt = arg0._tf:Find("Text"):GetComponent(typeof(Text))

	setActive(arg0._tf:Find("tag_common"), true)

	arg0.tagDiff = arg0._tf:Find("tag_diff")
	arg0.playIcon = arg0._tf:Find("play_icon")
end

function var0.Init(arg0, arg1, arg2, arg3, arg4)
	arg0.shipGroup = arg1
	arg0.isLive2d = arg3
	arg0.skin = arg2
	arg0.voice = arg4
	arg0.words = pg.ship_skin_words[arg0.skin.id]

	local var0 = arg0.voice.key
	local var1 = arg1:getIntimacyName(var0)

	if var1 then
		arg0.voice = setmetatable({
			voice_name = var1
		}, {
			__index = arg4
		})
	end

	local var2
	local var3
	local var4
	local var5
	local var6
	local var7
	local var8 = arg4.key

	if string.find(var8, ShipWordHelper.WORD_TYPE_MAIN) then
		local var9 = string.gsub(var8, ShipWordHelper.WORD_TYPE_MAIN, "")

		var5 = tonumber(var9)
		var2, var3, var4 = ShipWordHelper.GetWordAndCV(arg0.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var5)

		if arg0.isLive2d then
			var6 = ShipWordHelper.GetL2dCvCalibrate(arg0.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var5)
			var7 = ShipWordHelper.GetL2dSoundEffect(arg0.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var5)
		end
	else
		var2, var3, var4 = ShipWordHelper.GetWordAndCV(arg0.skin.id, var8)

		if arg0.isLive2d then
			var6 = ShipWordHelper.GetL2dCvCalibrate(arg0.skin.id, var8)
			var7 = ShipWordHelper.GetL2dSoundEffect(arg0.skin.id, var8)
		end
	end

	arg0.l2dEventFlag = var6 == -1
	var6 = arg0.l2dEventFlag and 0 or var6
	arg0.wordData = {
		maxfavor = 0,
		cvKey = var2,
		cvPath = var3,
		textContent = var4,
		mainIndex = var5,
		voiceCalibrate = var6,
		se = var7
	}
end

function var0.Update(arg0)
	local var0 = arg0.voice
	local var1 = var0.unlock_condition[1] < 0
	local var2 = arg0.wordData.textContent == nil or arg0.wordData.textContent == "nil" or arg0.wordData.textContent == ""

	if not arg0.isLive2d then
		var1 = var1 or var2
	else
		local var3 = var0.l2d_action:match("^" .. ShipWordHelper.WORD_TYPE_MAIN .. "_")

		var1 = var1 or var2 and var3
	end

	setActive(arg0._tf, not var1)

	if not var1 then
		arg0:UpdateCvBtn()
		arg0:UpdateIcon()
	end
end

function var0.UpdateCvBtn(arg0)
	local var0 = arg0.voice
	local var1, var2 = arg0.shipGroup:VoiceReplayCodition(var0)
	local var3 = var1 and var0.voice_name or "???"

	arg0.nameTxt.text = var3

	local var4 = ShipWordHelper.ExistDifferentWord(arg0.skin.id, var0.key, arg0.wordData.mainIndex)

	setActive(arg0.tagDiff, var4)

	if not var1 then
		onButton(nil, arg0._tf, function()
			pg.TipsMgr.GetInstance():ShowTips(var2)
		end, SFX_PANEL)
	end
end

function var0.UpdateIcon(arg0)
	local var0 = arg0.voice.key == "unlock" and checkABExist("ui/skinunlockanim/star_level_unlock_anim_" .. arg0.skin.id)

	setActive(arg0.playIcon, var0)
end

function var0.L2dHasEvent(arg0)
	return arg0.l2dEventFlag
end

function var0.isEx(arg0)
	return false
end

function var0.Destroy(arg0)
	Destroy(arg0._go)
	removeOnButton(arg0._tf)
end

return var0
