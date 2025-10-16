local var0_0 = class("IslandDistanceView", import("..IslandBaseOpView"))

function var0_0.GetUIName(arg0_1)
	return "IslandDistanceUI"
end

function var0_0.SetUIParent(arg0_2, arg1_2)
	return arg0_2:GetView().interactionContainer
end

function var0_0.OnInit(arg0_3, arg1_3)
	arg0_3.targetTracker = IslandTargetTracker.New(arg0_3._tf)
end

function var0_0.OnUpdate(arg0_4)
	arg0_4.targetTracker:Update()
end

function var0_0.SetTrackingTarget(arg0_5, arg1_5, arg2_5, arg3_5)
	arg0_5.targetTracker:Tracking(arg1_5._go, arg2_5._go, arg3_5)
end

function var0_0.CancelTracking(arg0_6)
	arg0_6.targetTracker:UnTracking()
end

function var0_0.ShowHud(arg0_7, arg1_7)
	arg0_7.targetTracker:OnShowHud(arg1_7)
end

function var0_0.HideHud(arg0_8, arg1_8)
	arg0_8.targetTracker:OnHideHud(arg1_8)
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9.targetTracker then
		arg0_9.targetTracker:Dispose()

		arg0_9.targetTracker = nil
	end
end

return var0_0
