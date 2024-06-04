local var0 = class("LeMarsReOilPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var2 >= 1 and setColorStr(var0, "#1EA2ACFF") or var0) .. "/" .. var1)
end

return var0
