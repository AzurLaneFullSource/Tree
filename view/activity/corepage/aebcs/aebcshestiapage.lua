local var0_0 = class("AEBCSHestiaPage", import("view.activity.CorePage.BRS.HeiYanPtPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	setText(arg0_1.displayBtn:Find("Text"), i18n("other_world_temple_award"))
	setText(arg0_1.task_bg:Find("schedule"), i18n("Outpost_20250904_Progress"))
end

function var0_0.OnUpdateFlush(arg0_2)
	arg0_2.super.OnUpdateFlush(arg0_2)

	local var0_2, var1_2, var2_2 = arg0_2.ptData:GetResProgress()

	setText(arg0_2.progress, "/" .. var1_2)
	setText(arg0_2.progres, var2_2 >= 1 and setColorStr(var0_2, "#2572ff") or var0_2)
	setSlider(arg0_2.slider, 0, 1, var2_2)
end

return var0_0
