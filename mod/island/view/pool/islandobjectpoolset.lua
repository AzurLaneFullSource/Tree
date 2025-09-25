local var0_0 = class("IslandObjectPoolSet", import(".IslandPoolBase"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.root = arg1_1
	arg0_1.pools = {}
	arg0_1.capacity = arg2_1
	arg0_1.poolCapacity = arg3_1
	arg0_1.loadingCallbacks = {}
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

	if not arg0_5.loadingCallbacks[var0_5.key] then
		arg0_5.loadingCallbacks[var0_5.key] = {}
	end

	table.insert(arg0_5.loadingCallbacks[var0_5.key], arg3_5)

	if var0_5:IsLoading() then
		return
	end

	local var1_5 = {}

	if not var0_5:Isloaded() then
		table.insert(var1_5, function(arg0_6)
			var0_5:Load(arg0_6)
		end)
	end

	seriesAsync(var1_5, function()
		arg0_5:CheckOverFlow(var0_5)

		local var0_7 = {}

		for iter0_7, iter1_7 in ipairs(arg0_5.loadingCallbacks[var0_5.key]) do
			table.insert(var0_7, function(arg0_8)
				var0_5:DequeueAsyn(function(arg0_9)
					iter1_7(arg0_9)
					arg0_8()
				end)
			end)
		end

		parallelAsync(var0_7)

		arg0_5.loadingCallbacks[var0_5.key] = {}
	end)
end

function var0_0.ReturnObject(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:RawGetPool(arg1_10)

	if not var0_10 then
		Object.Destroy(arg2_10)

		return
	end

	var0_10:Enqueue(arg2_10)
end

function var0_0.CheckOverFlow(arg0_11, arg1_11)
	local var0_11 = table.getCount(arg0_11.pools)

	if var0_11 > arg0_11.capacity then
		arg0_11:DeleteOverflowPools(var0_11 - arg0_11.capacity, arg1_11)
	end
end

function var0_0.DeleteOverflowPools(arg0_12, arg1_12, arg2_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.pools) do
		if iter1_12 ~= arg2_12 and arg1_12 > #var0_12 and iter1_12:CanDelete() and (not arg0_12.loadingCallbacks[iter1_12.key] or #arg0_12.loadingCallbacks[iter1_12.key] == 0) then
			table.insert(var0_12, iter0_12)
		end
	end

	if #var0_12 <= 0 then
		return
	end

	for iter2_12, iter3_12 in pairs(var0_12) do
		arg0_12.pools[iter3_12]:Dispose()

		arg0_12.pools[iter3_12] = nil
	end
end

function var0_0.Clear(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.pools) do
		iter1_13:Clear()
	end

	arg0_13.pools = {}
	arg0_13.loadingCallbacks = {}
end

function var0_0.Dispose(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.pools) do
		iter1_14:Dispose()
	end

	arg0_14.pools = nil
	arg0_14.loadingCallbacks = {}
end

return var0_0
