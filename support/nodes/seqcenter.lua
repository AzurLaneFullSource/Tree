ys = ys or {}

local var0 = class("SeqCenter")

ys.SeqCenter = var0
var0._list = nil
var0._destroyed = false

function var0.Ctor(arg0, arg1)
	arg0._list = ys.LinkList.New()
end

function var0.NewSeq(arg0, arg1)
	return ys.Sequence.New(arg1, arg0)
end

function var0.AddSeq(arg0, arg1)
	arg0._list:AddLast(arg1)
end

function var0.Update(arg0)
	if arg0._destroyed then
		return
	end

	local var0 = arg0._list.Head

	while var0 ~= nil do
		local var1 = var0.Data

		var1:Update()

		if arg0._destroyed then
			return
		end

		if var1:IsFinish() then
			local var2 = var0

			var0 = var0.Next

			arg0._list:Remove(var2)
		else
			var0 = var0.Next
		end
	end
end

function var0.Dispose(arg0)
	local var0 = arg0._list.Head

	for iter0 = 1, arg0._list.Count do
		var0.Data.Dispose()

		var0 = var0.Next
	end

	arg0._list = nil
	arg0._destroyed = true
end

function var0.IsFinish(arg0)
	if arg0._list == nil then
		return true
	end

	local var0 = arg0._list.Head

	for iter0 = 1, arg0._list.Count do
		if not var0.Data:IsFinish() then
			return false
		end

		var0 = var0.Next
	end

	return true
end
