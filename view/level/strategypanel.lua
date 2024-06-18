local var0_0 = class("StrategyPanel", import("..base.BasePanel"))

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)

	arg0_1.icon = arg0_1:findTF("window/panel/item/icon_bg/icon")
	arg0_1.count = arg0_1:findTF("window/panel/item/icon_bg/count")
	arg0_1.name = arg0_1:findTF("window/panel/item/name")
	arg0_1.desc = arg0_1:findTF("window/panel/item/desc")
	arg0_1.btnCancel = arg0_1:findTF("window/panel/actions/cancel_button")
	arg0_1.btnUse = arg0_1:findTF("window/panel/actions/use_button")
	arg0_1.btnBack = arg0_1:findTF("top/btnBack")
	arg0_1.tips = arg0_1:findTF("window/panel/tips")
	arg0_1.txSwitch = findTF(arg0_1.btnUse, "switch")
	arg0_1.txUse = findTF(arg0_1.btnUse, "use")
	arg0_1.onConfirm = nil
	arg0_1.onCancel = nil
end

function var0_0.set(arg0_2, arg1_2)
	arg0_2.strategy = arg1_2

	local var0_2 = pg.strategy_data_template[arg1_2.id]

	GetImageSpriteFromAtlasAsync("strategyicon/" .. var0_2.icon, "", arg0_2.icon)

	if var0_2.type == 1 then
		setText(arg0_2.count, "")
		setActive(arg0_2.tips, true)
		setActive(arg0_2.txSwitch, true)
		setActive(arg0_2.txUse, false)
	else
		setText(arg0_2.count, arg1_2.count)
		setActive(arg0_2.tips, false)
		setActive(arg0_2.txSwitch, false)
		setActive(arg0_2.txUse, true)
	end

	setText(arg0_2.name, var0_2.name)
	setText(arg0_2.desc, var0_2.desc)
	onButton(arg0_2, arg0_2.btnBack, function()
		if arg0_2.onCancel then
			arg0_2.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnCancel, function()
		if arg0_2.onCancel then
			arg0_2.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnUse, function()
		if arg0_2.onConfirm then
			arg0_2.onConfirm()
		end
	end, SFX_CONFIRM)
end

return var0_0
