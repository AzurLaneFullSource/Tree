local var0_0 = class("IslandStoryRecordPanel", import("Mgr.Story.NewStoryRecordPanel"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.view = arg1_1

	var0_0.super.Ctor(arg0_1)
end

function var0_0.GetUIName(arg0_2)
	return "IslandStoryRecordUI"
end

function var0_0.GetParent(arg0_3)
	return arg0_3.view._tf
end

function var0_0.UpdateIcon(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4.icon

	GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var0_4, "", arg2_4:Find("Image"))
end

function var0_0.BlurPanel(arg0_5)
	return
end

function var0_0.UnblurPanel(arg0_6)
	return
end

return var0_0
