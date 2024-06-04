local var0 = class("SettingsResRepairBtn")

function var0.InitTpl(arg0, arg1)
	local var0 = arg1.tpl
	local var1 = arg1.container
	local var2 = arg1.iconSP

	arg0._tf = cloneTplTo(var0, var1, "REPAIR")
	arg0._go = arg0._tf.gameObject

	setImageSprite(arg0._tf:Find("icon"), var2)
end

function var0.Ctor(arg0, arg1)
	arg0:InitTpl(arg1)
	pg.DelegateInfo.New(arg0)

	arg0.Progress = arg0._tf:Find("progress")
	arg0.ProgressHandle = arg0._tf:Find("progress/handle")
	arg0.Info1 = arg0._tf:Find("status")
	arg0.Info2 = arg0._tf:Find("version")
	arg0.LabelNew = arg0._tf:Find("version/new")
	arg0.Dot = arg0._tf:Find("new")
	arg0.Loading = arg0._tf:Find("loading")

	setText(arg0._tf:Find("title"), i18n("repair_setting_label"))
	arg0:Init()
end

function var0.Init(arg0)
	arg0:UpdateRepairStatus()
	onButton(arg0, arg0._tf, function()
		pg.RepairResMgr.GetInstance():Repair()
	end, SFX_PANEL)
end

function var0.UpdateRepairStatus(arg0)
	setSlider(arg0.Progress, 0, 1, 0)
	setActive(arg0.Dot, false)
	setActive(arg0.Loading, false)

	local var0 = i18n("word_files_repair")
	local var1 = ""

	setText(arg0.Info1, var0)
	setText(arg0.Info2, var1)

	local var2 = 1

	setSlider(arg0.Progress, 0, 1, var2)
	setActive(arg0.ProgressHandle, var2 ~= 0 and var2 ~= 1)
	setActive(arg0.Dot, false)
	setActive(arg0.Loading, false)
	setActive(arg0.LabelNew, false)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
