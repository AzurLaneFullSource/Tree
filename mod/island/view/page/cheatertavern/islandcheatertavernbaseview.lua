local var0_0 = class("IslandCheaterTavernBaseView", import("view.base.BasePanel"))

function var0_0.AddListeners(arg0_1)
	return
end

function var0_0.RemoveListeners(arg0_2)
	return
end

function var0_0.SetActiveState(arg0_3, arg1_3)
	setActive(arg0_3._tf, arg1_3)
end

function var0_0.OnCheaterEveryRoundStart(arg0_4)
	return
end

function var0_0.OnCheaterEveryRoundStartDone(arg0_5)
	return
end

function var0_0.IsSelf(arg0_6, arg1_6)
	return getProxy(PlayerProxy):getRawData().id == arg1_6
end

function var0_0.Hide(arg0_7)
	arg0_7:OnHide()
end

function var0_0.Init(arg0_8)
	arg0_8.cheaterTavernAgency = arg0_8.parent:GetIsland():GetCheaterTavernAgency()

	arg0_8:OnInit()
end

function var0_0.OnHide(arg0_9)
	return
end

function var0_0.OnInit(arg0_10)
	return
end

return var0_0
