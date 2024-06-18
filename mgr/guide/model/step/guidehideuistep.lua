local var0_0 = class("GuideHideUIStep", import(".GuideStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.nodes = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.hideui) do
		table.insert(arg0_1.nodes, {
			path = iter1_1.path,
			delay = iter1_1.delay or 0,
			pathIndex = iter1_1.pathIndex or -1,
			hideFlag = iter1_1.ishide
		})
	end
end

function var0_0.GetType(arg0_2)
	return GuideStep.TYPE_HIDEUI
end

function var0_0.GetHideNodes(arg0_3)
	return arg0_3.nodes
end

return var0_0
