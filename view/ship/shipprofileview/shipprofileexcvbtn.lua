local var0_0 = class("ShipProfileExCvBtn", import(".ShipProfileCvBtn"))

function var0_0.Init(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	var0_0.super.Init(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)

	arg0_1.favor = arg5_1

	local var0_1 = arg4_1.key
	local var1_1
	local var2_1

	if string.find(var0_1, ShipWordHelper.WORD_TYPE_MAIN) then
		local var3_1 = string.gsub(var0_1, ShipWordHelper.WORD_TYPE_MAIN, "")

		mainIndex = tonumber(var3_1)
		var1_1, var2_1 = ShipWordHelper.ExistExCv(arg2_1.id, ShipWordHelper.WORD_TYPE_MAIN, mainIndex, arg5_1)
	else
		var1_1, var2_1 = ShipWordHelper.ExistExCv(arg2_1.id, var0_1, nil, arg5_1)
	end

	if arg0_1.wordData.cvPath and var2_1 then
		arg0_1.wordData.cvPath = arg0_1.wordData.cvPath .. "_ex" .. var2_1
	end

	arg0_1.wordData.matchFavor = var2_1
	arg0_1.wordData.textContent = var1_1
	arg0_1.wordData.maxfavor = arg5_1
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.voice.unlock_condition[1] < 0
	local var1_2 = arg0_2.wordData.textContent == nil or arg0_2.wordData.textContent == "nil" or arg0_2.wordData.textContent == ""

	var0_2 = var0_2 or var1_2

	setActive(arg0_2._tf, not var0_2)

	if not var0_2 then
		arg0_2:UpdateCvBtn()
		arg0_2:UpdateIcon()
	end
end

function var0_0.UpdateCvBtn(arg0_3)
	local var0_3 = arg0_3.voice
	local var1_3, var2_3 = arg0_3.shipGroup:VoiceReplayCodition(var0_3)
	local var3_3 = var1_3 and var0_3.voice_name .. "Ex" or "???"

	arg0_3.nameTxt.text = var3_3

	local var4_3 = ShipWordHelper.ExistDifferentExWord(arg0_3.skin.id, var0_3.key, arg0_3.wordData.mainIndex, arg0_3.favor)

	setActive(arg0_3.tagDiff, var4_3)

	if not var1_3 then
		onButton(nil, arg0_3._tf, function()
			pg.TipsMgr.GetInstance():ShowTips(var2_3)
		end, SFX_PANEL)
	end
end

function var0_0.isEx(arg0_5)
	return arg0_5.shipGroup:VoiceReplayCodition(arg0_5.voice)
end

return var0_0
