local var0_0 = class("IslandDeviceOrderBtn", import(".IslandDeviceBaseBtn"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	arg0_1.normalTxt = arg0_1.unlockTF:Find("normal/Text"):GetComponent(typeof(Text))
	arg0_1.urgencyTxt = arg0_1.unlockTF:Find("urgency/Text"):GetComponent(typeof(Text))
end

function var0_0.FlushDataUI(arg0_2)
	local var0_2 = getProxy(IslandProxy):GetIsland():GetOrderAgency()
	local var1_2 = var0_2:GetMaxFinishCount()
	local var2_2 = var0_2:GetFinishCnt()

	arg0_2.normalTxt.text = var1_2 - var2_2 .. "/" .. var1_2

	local var3_2 = var0_2:GetMaxUrgentFinishCnt()
	local var4_2 = var0_2:GetLeftUrgentCnt()

	arg0_2.urgencyTxt.text = var4_2 .. "/" .. var3_2
end

return var0_0
