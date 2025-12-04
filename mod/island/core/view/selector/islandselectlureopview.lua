local var0_0 = class("IslandSelectLureOpView", import(".IslandSelectableOpView"))

function var0_0.GetDisplayData(arg0_1)
	return (arg0_1:GetIsland():GetInventoryAgency():GetFishingItems())
end

function var0_0.GetTargetTr(arg0_2)
	return arg0_2:GetView():GetSubView(IslandOpView).lureBtn
end

function var0_0.GetSelectedId(arg0_3)
	return arg0_3:GetIsland():GetFishingAgency():GetBaitId()
end

function var0_0.OnSelected(arg0_4, arg1_4)
	arg0_4:NotifiyMeditor(IslandBaseMediator.EXCHANGE_LURE, arg1_4, arg0_4:GetView():GetSubView(IslandOpView).unitId)
end

function var0_0.IsShowItemCount(arg0_5)
	return false
end

return var0_0
