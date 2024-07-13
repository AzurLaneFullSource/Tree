ys = ys or {}

local var0_0 = class("SeqCenter")

ys.SeqCenter = var0_0
var0_0._list = nil
var0_0._destroyed = false

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._list = ys.LinkList.New()
end

function var0_0.NewSeq(arg0_2, arg1_2)
	return ys.Sequence.New(arg1_2, arg0_2)
end

function var0_0.AddSeq(arg0_3, arg1_3)
	arg0_3._list:AddLast(arg1_3)
end

function var0_0.Update(arg0_4)
	if arg0_4._destroyed then
		return
	end

	local var0_4 = arg0_4._list.Head

	while var0_4 ~= nil do
		local var1_4 = var0_4.Data

		var1_4:Update()

		if arg0_4._destroyed then
			return
		end

		if var1_4:IsFinish() then
			local var2_4 = var0_4

			var0_4 = var0_4.Next

			arg0_4._list:Remove(var2_4)
		else
			var0_4 = var0_4.Next
		end
	end
end

function var0_0.Dispose(arg0_5)
	local var0_5 = arg0_5._list.Head

	for iter0_5 = 1, arg0_5._list.Count do
		var0_5.Data.Dispose()

		var0_5 = var0_5.Next
	end

	arg0_5._list = nil
	arg0_5._destroyed = true
end

function var0_0.IsFinish(arg0_6)
	if arg0_6._list == nil then
		return true
	end

	local var0_6 = arg0_6._list.Head

	for iter0_6 = 1, arg0_6._list.Count do
		if not var0_6.Data:IsFinish() then
			return false
		end

		var0_6 = var0_6.Next
	end

	return true
end
