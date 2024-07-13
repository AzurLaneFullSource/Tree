local var0_0 = class("YingxiV3VictoryPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3, var1_3, var2_3 = arg0_3.ptData:GetLevelProgress()
	local var3_3, var4_3, var5_3 = arg0_3.ptData:GetResProgress()

	setText(arg0_3.step, var0_3)
	setText(arg0_3.progress, (var5_3 >= 1 and setColorStr(var3_3, COLOR_GREEN) or setColorStr(var3_3, "#e7dfc7")) .. "/" .. var4_3)
end

return var0_0
