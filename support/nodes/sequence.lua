ys = ys or {}

local var0 = class("Sequence")

ys.Sequence = var0
var0.Name = ""
var0._list = nil
var0.Center = nil
var0._wait = false

function var0.Ctor(arg0, arg1, arg2)
	arg0.Name = arg1
	arg0._list = ys.LinkList.New()
	arg0.Center = arg2

	arg2:AddSeq(arg0)
end

function var0.Dispose(arg0)
	local var0 = arg0._list.Head

	for iter0 = 1, arg0._list.Count do
		var0.Data:Dispose()

		var0 = var0.Next
	end

	arg0._list:Clear()
end

function var0.Add(arg0, arg1)
	arg0._list:AddLast(arg1)
end

function var0.Wait(arg0)
	arg0._wait = true
end

function var0.Resume(arg0)
	arg0._wait = false
end

function var0.Update(arg0)
	if arg0._wait then
		return false
	end

	while arg0._list.Count > 0 do
		local var0 = arg0._list.Head.Data

		if not var0.Finish then
			var0:UpdateNode()

			if not var0.Finish then
				return false
			else
				arg0._list:RemoveFirst()
			end
		else
			arg0._list:RemoveFirst()
		end
	end

	return true
end

function var0.IsFinish(arg0)
	local var0 = arg0._list.Head

	for iter0 = 1, arg0._list.Count do
		if not var0.Data.Finish then
			return false
		end
	end

	return true
end
