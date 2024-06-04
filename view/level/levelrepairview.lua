local var0 = class("LevelRepairView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "LevelRepairView"
end

function var0.OnInit(arg0)
	arg0:InitUI()
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.OnDestroy(arg0)
	arg0.onConfirm = nil
	arg0.onCancel = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.setCBFunc(arg0, arg1, arg2)
	arg0.onConfirm = arg1
	arg0.onCancel = arg2
end

function var0.InitUI(arg0)
	arg0.desc = arg0:findTF("window/desc")
	arg0.descFree = arg0:findTF("window/text_free")
	arg0.descCharge = arg0:findTF("window/text_charge")
	arg0.free = arg0:findTF("window/text_free/time")
	arg0.charge = arg0:findTF("window/text_charge/time")
	arg0.diamond = arg0:findTF("window/diamond")
	arg0.cost = findTF(arg0.diamond, "cost")
	arg0.cancel = arg0:findTF("window/actions/cancel_button")
	arg0.confirm = arg0:findTF("window/actions/use_button")
	arg0.back = arg0:findTF("top/btnBack")
end

function var0.set(arg0, arg1, arg2, arg3, arg4)
	arg0.repairTimes = arg1
	arg0.freeTimes = arg2
	arg0.chargeTimes = arg3
	arg0.chargeDiamond = arg4

	local var0 = arg0.freeTimes - math.min(arg0.repairTimes, arg0.freeTimes)
	local var1 = arg0.chargeTimes - (arg0.repairTimes - (arg0.freeTimes - var0))

	setText(arg0.free, var0 .. "/" .. arg0.freeTimes)
	setText(arg0.charge, var1 .. "/" .. arg0.chargeTimes)
	setText(arg0.cost, arg0.chargeDiamond)
	setActive(arg0.descFree, var0 > 0)
	setActive(arg0.descCharge, var0 <= 0)
	setText(arg0.desc, i18n("battle_repair_special_tip"))
	setText(arg0.descFree, i18n("battle_repair_normal_name"))
	setText(arg0.descCharge, i18n("battle_repair_special_name"))

	local var2 = arg0.repairTimes < arg0.freeTimes + arg0.chargeTimes

	setActive(arg0.diamond, var2 and arg0.repairTimes >= arg0.freeTimes)
	setButtonEnabled(arg0.confirm, var2)
	setGray(arg0.confirm, not var2, true)
	onButton(arg0, arg0.back, function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.cancel, function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.confirm, function()
		if arg0.onConfirm then
			arg0.onConfirm()
		end
	end, SFX_CONFIRM)
end

return var0
