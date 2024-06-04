local var0 = class("YingxiV3VictoryPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()
	local var3, var4, var5 = arg0.ptData:GetResProgress()

	setText(arg0.step, var0)
	setText(arg0.progress, (var5 >= 1 and setColorStr(var3, COLOR_GREEN) or setColorStr(var3, "#e7dfc7")) .. "/" .. var4)
end

return var0
