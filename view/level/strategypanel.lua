local var0 = class("StrategyPanel", import("..base.BasePanel"))

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.icon = arg0:findTF("window/panel/item/icon_bg/icon")
	arg0.count = arg0:findTF("window/panel/item/icon_bg/count")
	arg0.name = arg0:findTF("window/panel/item/name")
	arg0.desc = arg0:findTF("window/panel/item/desc")
	arg0.btnCancel = arg0:findTF("window/panel/actions/cancel_button")
	arg0.btnUse = arg0:findTF("window/panel/actions/use_button")
	arg0.btnBack = arg0:findTF("top/btnBack")
	arg0.tips = arg0:findTF("window/panel/tips")
	arg0.txSwitch = findTF(arg0.btnUse, "switch")
	arg0.txUse = findTF(arg0.btnUse, "use")
	arg0.onConfirm = nil
	arg0.onCancel = nil
end

function var0.set(arg0, arg1)
	arg0.strategy = arg1

	local var0 = pg.strategy_data_template[arg1.id]

	GetImageSpriteFromAtlasAsync("strategyicon/" .. var0.icon, "", arg0.icon)

	if var0.type == 1 then
		setText(arg0.count, "")
		setActive(arg0.tips, true)
		setActive(arg0.txSwitch, true)
		setActive(arg0.txUse, false)
	else
		setText(arg0.count, arg1.count)
		setActive(arg0.tips, false)
		setActive(arg0.txSwitch, false)
		setActive(arg0.txUse, true)
	end

	setText(arg0.name, var0.name)
	setText(arg0.desc, var0.desc)
	onButton(arg0, arg0.btnBack, function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnCancel, function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnUse, function()
		if arg0.onConfirm then
			arg0.onConfirm()
		end
	end, SFX_CONFIRM)
end

return var0
