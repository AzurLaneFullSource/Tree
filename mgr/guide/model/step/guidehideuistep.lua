local var0 = class("GuideHideUIStep", import(".GuideStep"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.nodes = {}

	for iter0, iter1 in ipairs(arg1.hideui) do
		table.insert(arg0.nodes, {
			path = iter1.path,
			delay = iter1.delay or 0,
			pathIndex = iter1.pathIndex or -1,
			hideFlag = iter1.ishide
		})
	end
end

function var0.GetType(arg0)
	return GuideStep.TYPE_HIDEUI
end

function var0.GetHideNodes(arg0)
	return arg0.nodes
end

return var0
