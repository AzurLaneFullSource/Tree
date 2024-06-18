local var0_0 = class("ShanchengPTOilPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)

	var0_0.scrolltext = arg0_1:findTF("name", arg0_1.awardTF)
end

function var0_0.OnUpdateFlush(arg0_2)
	var0_0.super.OnUpdateFlush(arg0_2)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	arg0_2:SetAwardName()

	local var0_2, var1_2, var2_2 = arg0_2.ptData:GetResProgress()

	setText(arg0_2.progress, (var2_2 >= 1 and setColorStr(var0_2, "#A2A2A2FF") or var0_2) .. "/" .. var1_2)
end

function var0_0.SetAwardName(arg0_4)
	local var0_4 = arg0_4.ptData:GetAward()

	if Item.getConfigData(var0_4.id) then
		changeToScrollText(var0_0.scrolltext, var0_4:getName())
	else
		setActive(arg0_4:findTF("name", arg0_4.awardTF), false)
	end
end

return var0_0
