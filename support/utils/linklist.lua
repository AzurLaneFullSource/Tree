ys = ys or {}

local var0 = ys

var0.LinkList = class("LinkList")

local var1 = var0.LinkList

var1.Head = nil
var1.Tail = nil
var1.Count = 0

function var1.Ctor(arg0)
	return
end

function var1.Clear(arg0)
	arg0.Head = nil
	arg0.Tail = nil
	arg0.Count = 0
end

function var1.NewNode(arg0, arg1)
	return {
		Data = arg1
	}
end

function var1.IsEmpty(arg0)
	return arg0.Count == 0
end

function var1.AddBefore(arg0, arg1, arg2)
	if arg1 == nil then
		return nil
	end

	local var0 = arg0:NewNode(arg2)

	if arg1.Before ~= nil then
		arg1.Before.Next = var0
	end

	var0.Before = arg1.Before
	var0.Next = arg1
	arg1.Before = var0

	if arg0.Head == arg1 then
		arg0.Head = var0
	end

	arg0.Count = arg0.Count + 1

	return var0
end

function var1.AddAfter(arg0, arg1, arg2)
	if arg1 == nil then
		return nil
	end

	local var0 = arg0:NewNode(arg2)

	if arg1.Next ~= nil then
		arg1.Next.Before = var0
	end

	var0.Next = arg1.Next
	arg1.Next = var0
	var0.Before = arg1

	if arg0.Tail == arg1 then
		arg0.Tail = var0
	end

	arg0.Count = arg0.Count + 1

	return var0
end

function var1.AddFirst(arg0, arg1)
	local var0 = arg0:NewNode(arg1)

	return arg0:AddNodeFirst(var0)
end

function var1.AddNodeFirst(arg0, arg1)
	if arg0.Head ~= nil then
		arg0.Head.Before = arg1
	end

	arg1.Next = arg0.Head
	arg1.Before = nil
	arg0.Head = arg1

	if arg0.Tail == nil then
		arg0.Tail = arg1
	end

	arg0.Count = arg0.Count + 1

	return arg1
end

function var1.AddLast(arg0, arg1)
	local var0 = arg0:NewNode(arg1)

	return arg0:AddNodeLast(var0)
end

function var1.AddNodeLast(arg0, arg1)
	if arg0.Tail ~= nil then
		arg0.Tail.Next = arg1
	end

	arg1.Before = arg0.Tail
	arg1.Next = nil
	arg0.Tail = arg1

	if arg0.Head == nil then
		arg0.Head = arg1
	end

	arg0.Count = arg0.Count + 1

	return arg1
end

function var1.CopyTo(arg0, arg1, arg2)
	if arg1 == nil then
		return
	end

	if arg2 == nil then
		arg2 = 1
	end

	local var0 = arg0.Head

	for iter0 = 1, arg0.Count do
		table.insert(arg1, arg2, var0.Data)

		var0 = var0.Next
		arg2 = arg2 + 1
	end
end

function var1.Find(arg0, arg1)
	local var0 = arg0.Head

	for iter0 = 1, arg0.Count do
		if var0.Data == arg1 then
			return var0
		end

		var0 = var0.Next
	end

	return nil
end

function var1.FindLast(arg0, arg1)
	local var0 = arg0.Tail

	for iter0 = 1, arg0.Count do
		if var0.Data == arg1 then
			return var0
		end

		var0 = var0.Before
	end

	return nil
end

function var1.RemoveFirst(arg0)
	arg0:Remove(arg0.Head)
end

function var1.RemoveLast(arg0)
	arg0:Remove(arg0.Tail)
end

function var1.Remove(arg0, arg1)
	if arg1 == nil then
		return
	end

	if arg0.Head == arg1 then
		arg0.Head = arg1.Next
	end

	if arg0.Tail == arg1 then
		arg0.Tail = arg1.Before
	end

	if arg1.Next ~= nil then
		arg1.Next.Before = arg1.Before
	end

	if arg1.Before ~= nil then
		arg1.Before.Next = arg1.Next
	end

	arg0.Count = arg0.Count - 1
end

function var1.RemoveData(arg0, arg1)
	local var0 = arg0:Find(arg1)

	arg0:Remove(var0)

	return var0
end

local function var2(arg0, arg1)
	if arg1 == nil then
		return arg0.Head
	else
		return arg1.Next
	end
end

function var1.Iterator(arg0)
	return var2, arg0
end

function var1.Show(arg0)
	print("-------- list ++ begin --------")

	for iter0 in arg0:Iterator() do
		print(iter0.Data)
	end

	print("-------- list -- end ----------")
end
