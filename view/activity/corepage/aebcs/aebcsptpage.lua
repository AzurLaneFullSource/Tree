local var0_0 = class("AEBCSPtPage", import("view.activity.CorePage.CorePtTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD/task_bg")
	arg0_1.progress = arg0_1.bg:Find("progress")
	arg0_1.progres = arg0_1.bg:Find("progres")
	arg0_1.slider = arg0_1.bg:Find("slider")
	arg0_1.step = arg0_1.bg:Find("step")
	arg0_1.displayBtn = arg0_1.bg:Find("display_btn")
	arg0_1.awardTF = arg0_1.bg:Find("award")
	arg0_1.getBtn = arg0_1.bg:Find("get_btn")
	arg0_1.gotBtn = arg0_1.bg:Find("got_btn")
	arg0_1.battleBtn = arg0_1.bg:Find("battle_btn")

	setText(arg0_1.displayBtn:Find("Text"), i18n("other_world_temple_award"))
	setText(arg0_1.bg:Find("Text"), i18n("Outpost_20250904_Progress"))
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)

	local var0_4, var1_4, var2_4 = arg0_4.ptData:GetResProgress()

	setText(arg0_4.progress, "/" .. var1_4)
	setText(arg0_4.progres, var2_4 >= 1 and setColorStr(var0_4, "#6ef0ff") or var0_4)
end

return var0_0
