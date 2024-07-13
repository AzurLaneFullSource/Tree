ys = ys or {}

local var0_0 = class("Sequence")

ys.Sequence = var0_0
var0_0.Name = ""
var0_0._list = nil
var0_0.Center = nil
var0_0._wait = false

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.Name = arg1_1
	arg0_1._list = ys.LinkList.New()
	arg0_1.Center = arg2_1

	arg2_1:AddSeq(arg0_1)
end

function var0_0.Dispose(arg0_2)
	local var0_2 = arg0_2._list.Head

	for iter0_2 = 1, arg0_2._list.Count do
		var0_2.Data:Dispose()

		var0_2 = var0_2.Next
	end

	arg0_2._list:Clear()
end

function var0_0.Add(arg0_3, arg1_3)
	arg0_3._list:AddLast(arg1_3)
end

function var0_0.Wait(arg0_4)
	arg0_4._wait = true
end

function var0_0.Resume(arg0_5)
	arg0_5._wait = false
end

function var0_0.Update(arg0_6)
	if arg0_6._wait then
		return false
	end

	while arg0_6._list.Count > 0 do
		local var0_6 = arg0_6._list.Head.Data

		if not var0_6.Finish then
			var0_6:UpdateNode()

			if not var0_6.Finish then
				return false
			else
				arg0_6._list:RemoveFirst()
			end
		else
			arg0_6._list:RemoveFirst()
		end
	end

	return true
end

function var0_0.IsFinish(arg0_7)
	local var0_7 = arg0_7._list.Head

	for iter0_7 = 1, arg0_7._list.Count do
		if not var0_7.Data.Finish then
			return false
		end
	end

	return true
end
