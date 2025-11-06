local var0_0 = class("IslandDistanceView", import("..IslandBaseOpView"))

function var0_0.GetUIName(arg0_1)
	return "IslandDistanceUI"
end

function var0_0.SetUIParent(arg0_2, arg1_2)
	return arg0_2:GetView().interactionContainer
end

function var0_0.OnInit(arg0_3, arg1_3)
	arg0_3.targetTracker = IslandTargetTracker.New(arg0_3._tf:Find("distance"))
	arg0_3.iconImg = arg0_3._tf:Find("distance/Image"):GetComponent(typeof(Image))
	arg0_3.arrImg = arg0_3._tf:Find("distance/arr/arr"):GetComponent(typeof(Image))
	arg0_3.mainTargetTracker = IslandTargetTracker.New(arg0_3._tf:Find("main_distance"))
end

function var0_0.OnUpdate(arg0_4)
	arg0_4.mainTargetTracker:Update()
	arg0_4.targetTracker:Update(arg0_4.mainTargetTracker:GetShowTargetPosition())
end

function var0_0.SetTrackingTarget(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	if arg5_5 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_5.mainTargetTracker:Tracking(arg1_5._go, arg2_5._go, arg3_5)
	elseif arg5_5 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_5:UpdateTrackerStyle(arg4_5)
		arg0_5.targetTracker:Tracking(arg1_5._go, arg2_5._go, arg3_5)
	end
end

function var0_0.UpdateTrackerStyle(arg0_6, arg1_6)
	local var0_6 = IslandTaskType.GetTrackingIconName(arg1_6 or IslandTaskType.MAIN)
	local var1_6 = GetSpriteFromAtlas("ui/IslandUI_atlas", var0_6)

	arg0_6.iconImg.sprite = var1_6

	arg0_6.iconImg:SetNativeSize()

	local var2_6 = GetSpriteFromAtlas("ui/IslandUI_atlas", var0_6 .. "_1")

	arg0_6.arrImg.sprite = var2_6

	arg0_6.arrImg:SetNativeSize()
end

function var0_0.CancelTracking(arg0_7, arg1_7)
	if arg1_7 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_7.mainTargetTracker:UnTracking()
	elseif arg1_7 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_7.targetTracker:UnTracking()
	end
end

function var0_0.ShowHud(arg0_8, arg1_8)
	arg0_8.mainTargetTracker:OnShowHud(arg1_8)
	arg0_8.targetTracker:OnShowHud(arg1_8)
end

function var0_0.HideHud(arg0_9, arg1_9)
	arg0_9.mainTargetTracker:OnHideHud(arg1_9)
	arg0_9.targetTracker:OnHideHud(arg1_9)
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10.targetTracker then
		arg0_10.targetTracker:Dispose()

		arg0_10.targetTracker = nil
	end

	if arg0_10.mainTargetTracker then
		arg0_10.mainTargetTracker:Dispose()

		arg0_10.mainTargetTracker = nil
	end
end

return var0_0
