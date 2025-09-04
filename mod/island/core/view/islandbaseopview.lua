local var0_0 = class("IslandBaseOpView", import(".IslandBaseSubView"))

function var0_0.SetUIParent(arg0_1, arg1_1)
	setParent(arg1_1, arg0_1:GetView().opContainer)
end

return var0_0
