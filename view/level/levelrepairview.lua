local var0_0 = class("LevelRepairView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelRepairView"
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
	arg0_5.desc = arg0_5:findTF("window/desc")
	arg0_5.descFree = arg0_5:findTF("window/text_free")
	arg0_5.descCharge = arg0_5:findTF("window/text_charge")
	arg0_5.free = arg0_5:findTF("window/text_free/time")
	arg0_5.charge = arg0_5:findTF("window/text_charge/time")
	arg0_5.diamond = arg0_5:findTF("window/diamond")
	arg0_5.cost = findTF(arg0_5.diamond, "cost")
	arg0_5.cancel = arg0_5:findTF("window/actions/cancel_button")
	arg0_5.confirm = arg0_5:findTF("window/actions/use_button")
	arg0_5.back = arg0_5:findTF("top/btnBack")
end

function var0_0.set(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	arg0_6.repairTimes = arg1_6
	arg0_6.freeTimes = arg2_6
	arg0_6.chargeTimes = arg3_6
	arg0_6.chargeDiamond = arg4_6

	local var0_6 = arg0_6.freeTimes - math.min(arg0_6.repairTimes, arg0_6.freeTimes)
	local var1_6 = arg0_6.chargeTimes - (arg0_6.repairTimes - (arg0_6.freeTimes - var0_6))

	setText(arg0_6.free, var0_6 .. "/" .. arg0_6.freeTimes)
	setText(arg0_6.charge, var1_6 .. "/" .. arg0_6.chargeTimes)
	setText(arg0_6.cost, arg0_6.chargeDiamond)
	setActive(arg0_6.descFree, var0_6 > 0)
	setActive(arg0_6.descCharge, var0_6 <= 0)
	setText(arg0_6.desc, i18n("battle_repair_special_tip"))
	setText(arg0_6.descFree, i18n("battle_repair_normal_name"))
	setText(arg0_6.descCharge, i18n("battle_repair_special_name"))

	local var2_6 = arg0_6.repairTimes < arg0_6.freeTimes + arg0_6.chargeTimes

	setActive(arg0_6.diamond, var2_6 and arg0_6.repairTimes >= arg0_6.freeTimes)
	setButtonEnabled(arg0_6.confirm, var2_6)
	setGray(arg0_6.confirm, not var2_6, true)
	onButton(arg0_6, arg0_6.back, function()
		if arg0_6.onCancel then
			arg0_6.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.cancel, function()
		if arg0_6.onCancel then
			arg0_6.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.confirm, function()
		if arg0_6.onConfirm then
			arg0_6.onConfirm()
		end
	end, SFX_CONFIRM)
end

return var0_0
