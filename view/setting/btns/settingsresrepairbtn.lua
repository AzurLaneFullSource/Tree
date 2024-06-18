local var0_0 = class("SettingsResRepairBtn")

function var0_0.InitTpl(arg0_1, arg1_1)
	local var0_1 = arg1_1.tpl
	local var1_1 = arg1_1.container
	local var2_1 = arg1_1.iconSP

	arg0_1._tf = cloneTplTo(var0_1, var1_1, "REPAIR")
	arg0_1._go = arg0_1._tf.gameObject

	setImageSprite(arg0_1._tf:Find("icon"), var2_1)
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2:InitTpl(arg1_2)
	pg.DelegateInfo.New(arg0_2)

	arg0_2.Progress = arg0_2._tf:Find("progress")
	arg0_2.ProgressHandle = arg0_2._tf:Find("progress/handle")
	arg0_2.Info1 = arg0_2._tf:Find("status")
	arg0_2.Info2 = arg0_2._tf:Find("version")
	arg0_2.LabelNew = arg0_2._tf:Find("version/new")
	arg0_2.Dot = arg0_2._tf:Find("new")
	arg0_2.Loading = arg0_2._tf:Find("loading")

	setText(arg0_2._tf:Find("title"), i18n("repair_setting_label"))
	arg0_2:Init()
end

function var0_0.Init(arg0_3)
	arg0_3:UpdateRepairStatus()
	onButton(arg0_3, arg0_3._tf, function()
		pg.RepairResMgr.GetInstance():Repair()
	end, SFX_PANEL)
end

function var0_0.UpdateRepairStatus(arg0_5)
	setSlider(arg0_5.Progress, 0, 1, 0)
	setActive(arg0_5.Dot, false)
	setActive(arg0_5.Loading, false)

	local var0_5 = i18n("word_files_repair")
	local var1_5 = ""

	setText(arg0_5.Info1, var0_5)
	setText(arg0_5.Info2, var1_5)

	local var2_5 = 1

	setSlider(arg0_5.Progress, 0, 1, var2_5)
	setActive(arg0_5.ProgressHandle, var2_5 ~= 0 and var2_5 ~= 1)
	setActive(arg0_5.Dot, false)
	setActive(arg0_5.Loading, false)
	setActive(arg0_5.LabelNew, false)
end

function var0_0.Dispose(arg0_6)
	pg.DelegateInfo.Dispose(arg0_6)
end

return var0_0
