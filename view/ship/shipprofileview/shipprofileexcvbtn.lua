local var0 = class("ShipProfileExCvBtn", import(".ShipProfileCvBtn"))

function var0.Init(arg0, arg1, arg2, arg3, arg4, arg5)
	var0.super.Init(arg0, arg1, arg2, arg3, arg4)

	arg0.favor = arg5

	local var0 = arg4.key
	local var1
	local var2

	if string.find(var0, ShipWordHelper.WORD_TYPE_MAIN) then
		local var3 = string.gsub(var0, ShipWordHelper.WORD_TYPE_MAIN, "")

		mainIndex = tonumber(var3)
		var1, var2 = ShipWordHelper.ExistExCv(arg2.id, ShipWordHelper.WORD_TYPE_MAIN, mainIndex, arg5)
	else
		var1, var2 = ShipWordHelper.ExistExCv(arg2.id, var0, nil, arg5)
	end

	if arg0.wordData.cvPath and var2 then
		arg0.wordData.cvPath = arg0.wordData.cvPath .. "_ex" .. var2
	end

	arg0.wordData.matchFavor = var2
	arg0.wordData.textContent = var1
	arg0.wordData.maxfavor = arg5
end

function var0.Update(arg0)
	local var0 = arg0.voice.unlock_condition[1] < 0
	local var1 = arg0.wordData.textContent == nil or arg0.wordData.textContent == "nil" or arg0.wordData.textContent == ""

	var0 = var0 or var1

	setActive(arg0._tf, not var0)

	if not var0 then
		arg0:UpdateCvBtn()
		arg0:UpdateIcon()
	end
end

function var0.UpdateCvBtn(arg0)
	local var0 = arg0.voice
	local var1, var2 = arg0.shipGroup:VoiceReplayCodition(var0)
	local var3 = var1 and var0.voice_name .. "Ex" or "???"

	arg0.nameTxt.text = var3

	local var4 = ShipWordHelper.ExistDifferentExWord(arg0.skin.id, var0.key, arg0.wordData.mainIndex, arg0.favor)

	setActive(arg0.tagDiff, var4)

	if not var1 then
		onButton(nil, arg0._tf, function()
			pg.TipsMgr.GetInstance():ShowTips(var2)
		end, SFX_PANEL)
	end
end

function var0.isEx(arg0)
	return arg0.shipGroup:VoiceReplayCodition(arg0.voice)
end

return var0
