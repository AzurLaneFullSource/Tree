ys = ys or {}
ys.Story = ys.Story or {}
ys.Story.NodeData = class("NodeData")

local var0_0 = ys.Story.NodeData

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._data = arg1_1 or {}
	arg0_1._allSeq = {
		arg2_1
	}
end

function var0_0.AddSeq(arg0_2, arg1_2)
	table.insert(arg0_2._allSeq, arg1_2)
end

function var0_0.GetAllSeq(arg0_3)
	return arg0_3._allSeq
end
