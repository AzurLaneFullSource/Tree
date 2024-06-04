local var0 = class("ShipProfileMainExCvBtn", import(".ShipProfileCvBtn"))

function var0.Init(arg0, arg1, arg2, arg3, arg4)
	arg0.shipGroup = arg1
	arg0.isLive2d = arg3
	arg0.skin = arg2

	local var0 = "main" .. arg4
	local var1 = pg.character_voice[var0]
	local var2 = i18n("word_cv_key_main") .. arg4 .. "Ex"

	if var1 then
		arg0.voice = Clone(var1)
		arg0.voice.voice_name = var2
	else
		arg0.voice = {
			profile_index = 5,
			spine_action = "normal",
			l2d_action = "main_3",
			key = var0,
			voice_name = var2,
			resource_key = "main_" .. arg4,
			unlock_condition = {
				0,
				0
			}
		}
	end

	local var3 = arg0.voice

	arg0.words = pg.ship_skin_words[arg0.skin.id]

	local var4
	local var5
	local var6
	local var7
	local var8
	local var9
	local var10 = var3.key
	local var11 = arg0.shipGroup:GetMaxIntimacy()

	if string.find(var10, ShipWordHelper.WORD_TYPE_MAIN) then
		local var12 = string.gsub(var10, ShipWordHelper.WORD_TYPE_MAIN, "")

		var7 = tonumber(var12)
		var4, var5, var6 = ShipWordHelper.GetWordAndCV(arg0.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var7, nil, var11)

		if arg0.isLive2d then
			var8 = ShipWordHelper.GetL2dCvCalibrate(arg0.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var7)
			var9 = ShipWordHelper.GetL2dSoundEffect(arg0.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var7)
		end
	else
		var4, var5, var6 = ShipWordHelper.GetWordAndCV(arg0.skin.id, var10)

		if arg0.isLive2d then
			var8 = ShipWordHelper.GetL2dCvCalibrate(arg0.skin.id, var10)
			var9 = ShipWordHelper.GetL2dSoundEffect(arg0.skin.id, var10)
		end
	end

	arg0.wordData = {
		cvKey = var4,
		cvPath = var5,
		textContent = var6,
		mainIndex = var7,
		voiceCalibrate = var8,
		se = var9,
		maxfavor = var11
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
	local var1 = arg0.shipGroup
	local var2 = true
	local var3
	local var4 = var2 and var0.voice_name or "???"

	arg0.nameTxt.text = var4

	local var5 = arg0.shipGroup:GetMaxIntimacy()
	local var6 = ShipWordHelper.ExistDifferentMainExWord(arg0.skin.id, var0.key, arg0.wordData.mainIndex, var5)

	setActive(arg0.tagDiff, var6)
end

return var0
