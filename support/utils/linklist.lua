ys = ys or {}

local var0_0 = ys

var0_0.LinkList = class("LinkList")

local var1_0 = var0_0.LinkList

var1_0.Head = nil
var1_0.Tail = nil
var1_0.Count = 0

function var1_0.Ctor(arg0_1)
	return
end

function var1_0.Clear(arg0_2)
	arg0_2.Head = nil
	arg0_2.Tail = nil
	arg0_2.Count = 0
end

function var1_0.NewNode(arg0_3, arg1_3)
	return {
		Data = arg1_3
	}
end

function var1_0.IsEmpty(arg0_4)
	return arg0_4.Count == 0
end

function var1_0.AddBefore(arg0_5, arg1_5, arg2_5)
	if arg1_5 == nil then
		return nil
	end

	local var0_5 = arg0_5:NewNode(arg2_5)

	if arg1_5.Before ~= nil then
		arg1_5.Before.Next = var0_5
	end

	var0_5.Before = arg1_5.Before
	var0_5.Next = arg1_5
	arg1_5.Before = var0_5

	if arg0_5.Head == arg1_5 then
		arg0_5.Head = var0_5
	end

	arg0_5.Count = arg0_5.Count + 1

	return var0_5
end

function var1_0.AddAfter(arg0_6, arg1_6, arg2_6)
	if arg1_6 == nil then
		return nil
	end

	local var0_6 = arg0_6:NewNode(arg2_6)

	if arg1_6.Next ~= nil then
		arg1_6.Next.Before = var0_6
	end

	var0_6.Next = arg1_6.Next
	arg1_6.Next = var0_6
	var0_6.Before = arg1_6

	if arg0_6.Tail == arg1_6 then
		arg0_6.Tail = var0_6
	end

	arg0_6.Count = arg0_6.Count + 1

	return var0_6
end

function var1_0.AddFirst(arg0_7, arg1_7)
	local var0_7 = arg0_7:NewNode(arg1_7)

	return arg0_7:AddNodeFirst(var0_7)
end

function var1_0.AddNodeFirst(arg0_8, arg1_8)
	if arg0_8.Head ~= nil then
		arg0_8.Head.Before = arg1_8
	end

	arg1_8.Next = arg0_8.Head
	arg1_8.Before = nil
	arg0_8.Head = arg1_8

	if arg0_8.Tail == nil then
		arg0_8.Tail = arg1_8
	end

	arg0_8.Count = arg0_8.Count + 1

	return arg1_8
end

function var1_0.AddLast(arg0_9, arg1_9)
	local var0_9 = arg0_9:NewNode(arg1_9)

	return arg0_9:AddNodeLast(var0_9)
end

function var1_0.AddNodeLast(arg0_10, arg1_10)
	if arg0_10.Tail ~= nil then
		arg0_10.Tail.Next = arg1_10
	end

	arg1_10.Before = arg0_10.Tail
	arg1_10.Next = nil
	arg0_10.Tail = arg1_10

	if arg0_10.Head == nil then
		arg0_10.Head = arg1_10
	end

	arg0_10.Count = arg0_10.Count + 1

	return arg1_10
end

function var1_0.CopyTo(arg0_11, arg1_11, arg2_11)
	if arg1_11 == nil then
		return
	end

	if arg2_11 == nil then
		arg2_11 = 1
	end

	local var0_11 = arg0_11.Head

	for iter0_11 = 1, arg0_11.Count do
		table.insert(arg1_11, arg2_11, var0_11.Data)

		var0_11 = var0_11.Next
		arg2_11 = arg2_11 + 1
	end
end

function var1_0.Find(arg0_12, arg1_12)
	local var0_12 = arg0_12.Head

	for iter0_12 = 1, arg0_12.Count do
		if var0_12.Data == arg1_12 then
			return var0_12
		end

		var0_12 = var0_12.Next
	end

	return nil
end

function var1_0.FindLast(arg0_13, arg1_13)
	local var0_13 = arg0_13.Tail

	for iter0_13 = 1, arg0_13.Count do
		if var0_13.Data == arg1_13 then
			return var0_13
		end

		var0_13 = var0_13.Before
	end

	return nil
end

function var1_0.RemoveFirst(arg0_14)
	arg0_14:Remove(arg0_14.Head)
end

function var1_0.RemoveLast(arg0_15)
	arg0_15:Remove(arg0_15.Tail)
end

function var1_0.Remove(arg0_16, arg1_16)
	if arg1_16 == nil then
		return
	end

	if arg0_16.Head == arg1_16 then
		arg0_16.Head = arg1_16.Next
	end

	if arg0_16.Tail == arg1_16 then
		arg0_16.Tail = arg1_16.Before
	end

	if arg1_16.Next ~= nil then
		arg1_16.Next.Before = arg1_16.Before
	end

	if arg1_16.Before ~= nil then
		arg1_16.Before.Next = arg1_16.Next
	end

	arg0_16.Count = arg0_16.Count - 1
end

function var1_0.RemoveData(arg0_17, arg1_17)
	local var0_17 = arg0_17:Find(arg1_17)

	arg0_17:Remove(var0_17)

	return var0_17
end

local function var2_0(arg0_18, arg1_18)
	if arg1_18 == nil then
		return arg0_18.Head
	else
		return arg1_18.Next
	end
end

function var1_0.Iterator(arg0_19)
	return var2_0, arg0_19
end

function var1_0.Show(arg0_20)
	print("-------- list ++ begin --------")

	for iter0_20 in arg0_20:Iterator() do
		print(iter0_20.Data)
	end

	print("-------- list -- end ----------")
end
