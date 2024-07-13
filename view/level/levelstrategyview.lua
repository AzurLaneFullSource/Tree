local var0_0 = class("LevelStrategyView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelStrategyView"
end

function var0_0.OnInit(arg0_2)
	arg0_2:InitUI()
	setActive(arg0_2._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.onConfirm = nil
	arg0_3.onCancel = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_3._tf, arg0_3._parentTf)
end

function var0_0.setCBFunc(arg0_4, arg1_4, arg2_4)
	arg0_4.onConfirm = arg1_4
	arg0_4.onCancel = arg2_4
end

function var0_0.InitUI(arg0_5)
	arg0_5.icon = arg0_5:findTF("window/panel/item/icon_bg/icon")
	arg0_5.count = arg0_5:findTF("window/panel/item/icon_bg/count")
	arg0_5.name = arg0_5:findTF("window/panel/item/name")
	arg0_5.desc = arg0_5:findTF("window/panel/item/desc")
	arg0_5.btnCancel = arg0_5:findTF("window/panel/actions/cancel_button")
	arg0_5.btnUse = arg0_5:findTF("window/panel/actions/use_button")
	arg0_5.btnBack = arg0_5:findTF("top/btnBack")
	arg0_5.tips = arg0_5:findTF("window/panel/tips")
	arg0_5.txSwitch = findTF(arg0_5.btnUse, "switch")
	arg0_5.txUse = findTF(arg0_5.btnUse, "use")
end

function var0_0.set(arg0_6, arg1_6)
	arg0_6.strategy = arg1_6

	local var0_6 = pg.strategy_data_template[arg1_6.id]

	GetImageSpriteFromAtlasAsync("strategyicon/" .. var0_6.icon, "", arg0_6.icon)

	if var0_6.type == 1 then
		setText(arg0_6.count, "")
		setActive(arg0_6.tips, true)
		setActive(arg0_6.txSwitch, true)
		setActive(arg0_6.txUse, false)
	else
		setText(arg0_6.count, arg1_6.count)
		setActive(arg0_6.tips, false)
		setActive(arg0_6.txSwitch, false)
		setActive(arg0_6.txUse, true)
	end

	setText(arg0_6.name, var0_6.name)
	setText(arg0_6.desc, var0_6.desc)
	onButton(arg0_6, arg0_6.btnBack, function()
		if arg0_6.onCancel then
			arg0_6.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.btnCancel, function()
		if arg0_6.onCancel then
			arg0_6.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.btnUse, function()
		if arg0_6.onConfirm then
			arg0_6.onConfirm()
		end
	end, SFX_CONFIRM)
end

return var0_0
