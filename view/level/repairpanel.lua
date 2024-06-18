local var0_0 = class("RepairPanel", import("..base.BasePanel"))

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)

	arg0_1.desc = arg0_1:findTF("window/desc")
	arg0_1.descFree = arg0_1:findTF("window/text_free")
	arg0_1.descCharge = arg0_1:findTF("window/text_charge")
	arg0_1.free = arg0_1:findTF("window/text_free/time")
	arg0_1.charge = arg0_1:findTF("window/text_charge/time")
	arg0_1.diamond = arg0_1:findTF("window/diamond")
	arg0_1.cost = findTF(arg0_1.diamond, "cost")
	arg0_1.cancel = arg0_1:findTF("window/actions/cancel_button")
	arg0_1.confirm = arg0_1:findTF("window/actions/use_button")
	arg0_1.back = arg0_1:findTF("top/btnBack")
	arg0_1.onConfirm = nil
	arg0_1.onCancel = nil
end

function var0_0.set(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.repairTimes = arg1_2
	arg0_2.freeTimes = arg2_2
	arg0_2.chargeTimes = arg3_2
	arg0_2.chargeDiamond = arg4_2

	local var0_2 = arg0_2.freeTimes - math.min(arg0_2.repairTimes, arg0_2.freeTimes)
	local var1_2 = arg0_2.chargeTimes - (arg0_2.repairTimes - (arg0_2.freeTimes - var0_2))

	setText(arg0_2.free, var0_2 .. "/" .. arg0_2.freeTimes)
	setText(arg0_2.charge, var1_2 .. "/" .. arg0_2.chargeTimes)
	setText(arg0_2.cost, arg0_2.chargeDiamond)
	setActive(arg0_2.descFree, var0_2 > 0)
	setActive(arg0_2.descCharge, var0_2 <= 0)
	setText(arg0_2.desc, i18n("battle_repair_special_tip"))
	setText(arg0_2.descFree, i18n("battle_repair_normal_name"))
	setText(arg0_2.descCharge, i18n("battle_repair_special_name"))

	local var2_2 = arg0_2.repairTimes < arg0_2.freeTimes + arg0_2.chargeTimes

	setActive(arg0_2.diamond, var2_2 and arg0_2.repairTimes >= arg0_2.freeTimes)
	setButtonEnabled(arg0_2.confirm, var2_2)
	setGray(arg0_2.confirm, not var2_2, true)
	onButton(arg0_2, arg0_2.back, function()
		if arg0_2.onCancel then
			arg0_2.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.cancel, function()
		if arg0_2.onCancel then
			arg0_2.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.confirm, function()
		if arg0_2.onConfirm then
			arg0_2.onConfirm()
		end
	end, SFX_CONFIRM)
end

return var0_0
