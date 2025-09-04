local var0_0 = class("IslandPreviewCore", import("Mod.Island.Core.IslandCore"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1.furnitrueId = arg4_1
	arg0_1.lastExitPosition = arg5_1

	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
end

function var0_0.GetViewAndController(arg0_2, arg1_2)
	local var0_2 = AgoraPreviewController.New(arg0_2, arg1_2, arg0_2.furnitrueId, arg0_2.lastExitPosition)
	local var1_2 = var0_2:GetAgora()

	return AgoraPreview.New(arg0_2, var1_2), var0_2
end

return var0_0
