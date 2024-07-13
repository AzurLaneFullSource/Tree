local var0_0 = class("ShipProfileMainExCvBtn", import(".ShipProfileCvBtn"))

function var0_0.Init(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.shipGroup = arg1_1
	arg0_1.isLive2d = arg3_1
	arg0_1.skin = arg2_1

	local var0_1 = "main" .. arg4_1
	local var1_1 = pg.character_voice[var0_1]
	local var2_1 = i18n("word_cv_key_main") .. arg4_1 .. "Ex"

	if var1_1 then
		arg0_1.voice = Clone(var1_1)
		arg0_1.voice.voice_name = var2_1
	else
		arg0_1.voice = {
			profile_index = 5,
			spine_action = "normal",
			l2d_action = "main_3",
			key = var0_1,
			voice_name = var2_1,
			resource_key = "main_" .. arg4_1,
			unlock_condition = {
				0,
				0
			}
		}
	end

	local var3_1 = arg0_1.voice

	arg0_1.words = pg.ship_skin_words[arg0_1.skin.id]

	local var4_1
	local var5_1
	local var6_1
	local var7_1
	local var8_1
	local var9_1
	local var10_1 = var3_1.key
	local var11_1 = arg0_1.shipGroup:GetMaxIntimacy()

	if string.find(var10_1, ShipWordHelper.WORD_TYPE_MAIN) then
		local var12_1 = string.gsub(var10_1, ShipWordHelper.WORD_TYPE_MAIN, "")

		var7_1 = tonumber(var12_1)
		var4_1, var5_1, var6_1 = ShipWordHelper.GetWordAndCV(arg0_1.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var7_1, nil, var11_1)

		if arg0_1.isLive2d then
			var8_1 = ShipWordHelper.GetL2dCvCalibrate(arg0_1.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var7_1)
			var9_1 = ShipWordHelper.GetL2dSoundEffect(arg0_1.skin.id, ShipWordHelper.WORD_TYPE_MAIN, var7_1)
		end
	else
		var4_1, var5_1, var6_1 = ShipWordHelper.GetWordAndCV(arg0_1.skin.id, var10_1)

		if arg0_1.isLive2d then
			var8_1 = ShipWordHelper.GetL2dCvCalibrate(arg0_1.skin.id, var10_1)
			var9_1 = ShipWordHelper.GetL2dSoundEffect(arg0_1.skin.id, var10_1)
		end
	end

	arg0_1.wordData = {
		cvKey = var4_1,
		cvPath = var5_1,
		textContent = var6_1,
		mainIndex = var7_1,
		voiceCalibrate = var8_1,
		se = var9_1,
		maxfavor = var11_1
	}
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.voice
	local var1_2 = var0_2.unlock_condition[1] < 0
	local var2_2 = arg0_2.wordData.textContent == nil or arg0_2.wordData.textContent == "nil" or arg0_2.wordData.textContent == ""

	if not arg0_2.isLive2d then
		var1_2 = var1_2 or var2_2
	else
		local var3_2 = var0_2.l2d_action:match("^" .. ShipWordHelper.WORD_TYPE_MAIN .. "_")

		var1_2 = var1_2 or var2_2 and var3_2
	end

	setActive(arg0_2._tf, not var1_2)

	if not var1_2 then
		arg0_2:UpdateCvBtn()
		arg0_2:UpdateIcon()
	end
end

function var0_0.UpdateCvBtn(arg0_3)
	local var0_3 = arg0_3.voice
	local var1_3 = arg0_3.shipGroup
	local var2_3 = true
	local var3_3
	local var4_3 = var2_3 and var0_3.voice_name or "???"

	arg0_3.nameTxt.text = var4_3

	local var5_3 = arg0_3.shipGroup:GetMaxIntimacy()
	local var6_3 = ShipWordHelper.ExistDifferentMainExWord(arg0_3.skin.id, var0_3.key, arg0_3.wordData.mainIndex, var5_3)

	setActive(arg0_3.tagDiff, var6_3)
end

return var0_0
