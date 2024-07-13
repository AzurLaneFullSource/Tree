local var0_0 = class("LeMarsReOilPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3, var1_3, var2_3 = arg0_3.ptData:GetResProgress()

	setText(arg0_3.progress, (var2_3 >= 1 and setColorStr(var0_3, "#1EA2ACFF") or var0_3) .. "/" .. var1_3)
end

return var0_0
