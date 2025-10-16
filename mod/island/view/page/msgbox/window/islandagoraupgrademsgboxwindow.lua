local var0_0 = class("IslandAgoraUpgradeMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandAgoraUpgradeMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("confirm/Text"), i18n("island_agora_extend"))
	setText(arg0_2._tf:Find("condition/title/Text"), i18n("island_agora_extend_consume"))
	setText(arg0_2._tf:Find("capacity/Text"), i18n("island_agora_extend_capacity"))

	arg0_2.dropTpl = arg0_2._tf:Find("condition/tpl")
	arg0_2.dropCntTxt = arg0_2._tf:Find("condition/tpl/icon_bg/count_bg/count"):GetComponent(typeof(Text))
	arg0_2.oldCapacityTxt = arg0_2._tf:Find("capacity/Text_1"):GetComponent(typeof(Text))
	arg0_2.newCapacityTxt = arg0_2._tf:Find("capacity/Text_2"):GetComponent(typeof(Text))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)

	local var0_3 = arg0_3.settings.island
	local var1_3 = var0_3:GetAgoraAgency()
	local var2_3 = var0_3:GetInventoryAgency()

	arg0_3:UpdateCapacity(var1_3)
	arg0_3:UpdateConsume(var1_3, var2_3)
end

function var0_0.FlushBtn(arg0_4, arg1_4)
	return
end

function var0_0.UpdateCapacity(arg0_5, arg1_5)
	arg0_5.oldCapacityTxt.text = arg1_5:GetCapacity()
	arg0_5.newCapacityTxt.text = arg1_5:GetNextCapacity()
end

function var0_0.UpdateConsume(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetUpgradeConsume()

	updateCustomDrop(arg0_6.dropTpl, var0_6)

	local var1_6 = arg2_6:GetOwnCount(var0_6.id)

	arg0_6.dropCntTxt.text = setColorStr(var1_6, var1_6 >= var0_6.count and "#FFFFFF" or "#EB5F5F") .. "/" .. var0_6.count
end

return var0_0
