ys = ys or {}
ys.Story = ys.Story or {}
ys.Story.NodeData = class("NodeData")

local var0 = ys.Story.NodeData

function var0.Ctor(arg0, arg1, arg2)
	arg0._data = arg1 or {}
	arg0._allSeq = {
		arg2
	}
end

function var0.AddSeq(arg0, arg1)
	table.insert(arg0._allSeq, arg1)
end

function var0.GetAllSeq(arg0)
	return arg0._allSeq
end
