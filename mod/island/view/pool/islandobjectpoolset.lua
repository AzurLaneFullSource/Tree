local var0_0 = class("IslandObjectPoolSet", import(".IslandPoolBase"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.root = arg1_1
	arg0_1.pools = {}
	arg0_1.capacity = arg2_1
	arg0_1.poolCapacity = arg3_1
end

function var0_0.CreatePool(arg0_2, arg1_2, arg2_2)
	return IslandObjectPool.New(arg0_2.root, arg1_2, arg2_2, arg0_2.poolCapacity)
end

function var0_0.GetPool(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3.pools[arg1_3]

	if not var0_3 then
		var0_3 = arg0_3:CreatePool(arg1_3, arg2_3)
		arg0_3.pools[arg1_3] = var0_3
	end

	return var0_3
end

function var0_0.RawGetPool(arg0_4, arg1_4)
	return arg0_4.pools[arg1_4]
end

function var0_0.GetObject(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg0_5:GetPool(arg1_5, arg2_5)

	arg0_5:CheckOverFlow(var0_5)

	local var1_5 = {}

	if not var0_5:Isloaded() then
		table.insert(var1_5, function(arg0_6)
			var0_5:Load(arg0_6)
		end)
	end

	seriesAsync(var1_5, function()
		local var0_7 = var0_5:Dequeue()

		arg3_5(var0_7)
	end)
end

function var0_0.ReturnObject(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8:RawGetPool(arg1_8)

	if not var0_8 then
		Object.Destroy(arg2_8)

		return
	end

	var0_8:Enqueue(arg2_8)
end

function var0_0.CheckOverFlow(arg0_9, arg1_9)
	local var0_9 = table.getCount(arg0_9.pools)

	if var0_9 > arg0_9.capacity then
		arg0_9:DeleteOverflowPools(var0_9 - arg0_9.capacity, arg1_9)
	end
end

function var0_0.DeleteOverflowPools(arg0_10, arg1_10, arg2_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.pools) do
		if iter1_10 ~= arg2_10 and arg1_10 > #var0_10 and iter1_10:CanDelete() then
			table.insert(var0_10, iter0_10)
		end
	end

	if #var0_10 <= 0 then
		return
	end

	for iter2_10, iter3_10 in pairs(var0_10) do
		arg0_10.pools[iter3_10]:Dispose()

		arg0_10.pools[iter3_10] = nil
	end
end

function var0_0.Clear(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.pools) do
		iter1_11:Clear()
	end

	arg0_11.pools = {}
end

function var0_0.Dispose(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.pools) do
		iter1_12:Dispose()
	end

	arg0_12.pools = nil
end

return var0_0
