local var0_0 = class("IslandObjectPoolSet", import(".IslandPoolBase"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.root = arg1_1
	arg0_1.pools = {}
	arg0_1.capacity = arg2_1
	arg0_1.poolCapacity = arg3_1
	arg0_1.loadingCallbacks = {}
end

function var0_0.SetInstanceDestroyPreProcessor(arg0_2, arg1_2)
	arg0_2.instanceDestroyPreProcessor = arg1_2
end

function var0_0.CreatePool(arg0_3, arg1_3, arg2_3)
	local var0_3 = IslandObjectPool.New(arg0_3.root, arg1_3, arg2_3, arg0_3.poolCapacity)

	var0_3:SetInstanceDestroyPreProcessor(arg0_3.instanceDestroyPreProcessor)

	return var0_3
end

function var0_0.GetPool(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.pools[arg1_4]

	if not var0_4 then
		var0_4 = arg0_4:CreatePool(arg1_4, arg2_4)
		arg0_4.pools[arg1_4] = var0_4
	end

	return var0_4
end

function var0_0.RawGetPool(arg0_5, arg1_5)
	return arg0_5.pools[arg1_5]
end

function var0_0.GetObject(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg0_6:GetPool(arg1_6, arg2_6)

	if not arg0_6.loadingCallbacks[var0_6.key] then
		arg0_6.loadingCallbacks[var0_6.key] = {}
	end

	table.insert(arg0_6.loadingCallbacks[var0_6.key], arg3_6)

	if var0_6:IsLoading() then
		return
	end

	local var1_6 = {}

	if not var0_6:Isloaded() then
		table.insert(var1_6, function(arg0_7)
			var0_6:Load(arg0_7)
		end)
	end

	seriesAsync(var1_6, function()
		arg0_6:CheckOverFlow(var0_6)

		local var0_8 = {}
		local var1_8 = Clone(arg0_6.loadingCallbacks[var0_6.key])

		arg0_6.loadingCallbacks[var0_6.key] = {}

		for iter0_8, iter1_8 in ipairs(var1_8) do
			table.insert(var0_8, function(arg0_9)
				var0_6:DequeueAsyn(function(arg0_10)
					iter1_8(arg0_10)
					arg0_9()
				end)
			end)
		end

		parallelAsync(var0_8)
	end)
end

function var0_0.ReturnObject(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:RawGetPool(arg1_11)

	if not var0_11 then
		existCall(arg0_11.instanceDestroyPreProcessor, arg2_11)
		Object.Destroy(arg2_11)

		return
	end

	var0_11:Enqueue(arg2_11)
end

function var0_0.CheckOverFlow(arg0_12, arg1_12)
	local var0_12 = table.getCount(arg0_12.pools)

	if var0_12 > arg0_12.capacity then
		arg0_12:DeleteOverflowPools(var0_12 - arg0_12.capacity, arg1_12)
	end
end

function var0_0.DeleteOverflowPools(arg0_13, arg1_13, arg2_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13.pools) do
		if iter1_13 ~= arg2_13 and arg1_13 > #var0_13 and iter1_13:CanDelete() and (not arg0_13.loadingCallbacks[iter1_13.key] or #arg0_13.loadingCallbacks[iter1_13.key] == 0) then
			table.insert(var0_13, iter0_13)
		end
	end

	if #var0_13 <= 0 then
		return
	end

	for iter2_13, iter3_13 in pairs(var0_13) do
		arg0_13.pools[iter3_13]:Dispose()

		arg0_13.pools[iter3_13] = nil
	end
end

function var0_0.Clear(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.pools) do
		iter1_14:Clear()
	end

	arg0_14.pools = {}
	arg0_14.loadingCallbacks = {}
end

function var0_0.Dispose(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.pools) do
		iter1_15:Dispose()
	end

	arg0_15.pools = nil
	arg0_15.loadingCallbacks = {}
end

return var0_0
