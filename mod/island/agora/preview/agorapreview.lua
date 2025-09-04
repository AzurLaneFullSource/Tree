local var0_0 = class("AgoraPreview", import("..view.AgoraView"))

function var0_0.OnSceneInited(arg0_1, arg1_1)
	var0_0.super.OnSceneInited(arg0_1, arg1_1)
	arg0_1:Op("EnterEditMode")

	for iter0_1, iter1_1 in pairs(arg0_1.moulds) do
		arg0_1:Op("TrySelectItemById", iter0_1)
	end
end

function var0_0.CreateDecorationView(arg0_2)
	return AgoraDecorationPreview.New(arg0_2)
end

return var0_0
