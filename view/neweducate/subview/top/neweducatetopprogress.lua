local var0_0 = class("NewEducateTopProgress")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.event = arg2_1
	arg0_1.hardTF = arg0_1._tf:Find("hard")
	arg0_1.detailTF = arg0_1._tf:Find("detail")
	arg0_1.endlessTF = arg0_1._tf:Find("endless")

	setText(arg0_1.endlessTF:Find("title/Text"), i18n("child2_endless_stage"))

	arg0_1.resetTF = arg0_1._tf:Find("reset")

	setText(arg0_1.resetTF:Find("Text"), i18n("child2_reset_stage"))

	arg0_1.endingTF = arg0_1._tf:Find("ending")

	setText(arg0_1.endingTF:Find("Text"), i18n("child2_ending_stage"))
	onButton(arg0_1.event, arg0_1._tf:Find("back"), function()
		arg0_1.event:emit(NewEducateBaseUI.ON_BACK)
	end, SFX_PANEL)
end

function var0_0.Update(arg0_3, arg1_3, arg2_3)
	arg0_3.char = arg1_3

	local var0_3 = arg2_3 or arg0_3.char:GetFSM():GetSystemNo()

	setActive(arg0_3.hardTF, arg0_3.char.difficulty == NewEducateChar.DIFFICULTY.HARD)

	local var1_3 = var0_3 ~= NewEducateFSM.SYSTEM.ENDING

	setActive(arg0_3.detailTF, var1_3)
	setActive(arg0_3.endlessTF, var1_3)
	setActive(arg0_3.endingTF, not var1_3)
	setActive(arg0_3.resetTF, not var1_3)

	if var1_3 then
		if arg0_3.char:GetRoundData():IsEndless() then
			arg0_3:FlushEndless()
		else
			arg0_3:FlushNormal()
		end
	else
		local var2_3 = arg0_3.char:GetFSM():GetState(NewEducateFSM.SYSTEM.ENDING)
		local var3_3 = var2_3 and var2_3:IsFinish()

		setActive(arg0_3.endingTF, not var3_3)
		setActive(arg0_3.resetTF, var3_3)
	end
end

function var0_0.FlushNormal(arg0_4)
	setActive(arg0_4.detailTF, true)
	setActive(arg0_4.endlessTF, false)

	local var0_4 = arg0_4.char:GetRoundData()
	local var1_4, var2_4, var3_4 = var0_4:GetProgressInfo()
	local var4_4 = var0_4:IsTemp() and i18n("child2_cur_round_temp") or i18n("child2_cur_round", var1_4)

	setText(arg0_4.detailTF:Find("round/Text"), var4_4)

	local var5_4 = arg0_4.detailTF:Find("round/assess")

	setText(var5_4, i18n("child2_assess_round", var2_4))

	local var6_4 = var2_4 > 0 and "39bfff" or "ff6767"

	setTextColor(var5_4, Color.NewHex(var6_4))

	local var7_4 = arg0_4.detailTF:Find("target/content/value")
	local var8_4 = arg0_4.char:GetAttrSum()

	setText(var7_4, i18n("child2_assess_target", var8_4, var3_4))

	local var9_4 = var3_4 <= var8_4 and "39bfff" or "848498"

	setTextColor(var7_4, Color.NewHex(var9_4))
end

function var0_0.FlushEndless(arg0_5)
	setActive(arg0_5.detailTF, false)
	setActive(arg0_5.endlessTF, true)

	local var0_5, var1_5, var2_5 = arg0_5.char:GetRoundData():GetEndlessProgressInfos()

	setText(arg0_5.endlessTF:Find("title/wave"), i18n("child2_cur_wave", var0_5))
	setActive(arg0_5.endlessTF:Find("title/new"), var1_5)
	setText(arg0_5.endlessTF:Find("target/boss"), i18n("child2_endless_boss_value", var2_5))
	setText(arg0_5.endlessTF:Find("target/attrs/value"), i18n("child2_endless_attrs_value", arg0_5.char:GetAttrSum()))
end

function var0_0.Dispose(arg0_6)
	return
end

return var0_0
