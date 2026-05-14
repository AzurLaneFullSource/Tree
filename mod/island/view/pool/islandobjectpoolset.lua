local var0_0 = class("IslandObjectPoolSet", import(".IslandPoolBase"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.root = arg1_1
	arg0_1.pools = {}
	arg0_1.capacity = arg2_1
	arg0_1.poolCapacity = arg3_1
	arg0_1.loadingCallbacks = {}
	arg0_1.dequeueingCounts = {}
	arg0_1.poolUseIndex = 0
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

	arg0_4:MarkPoolUsed(var0_4)

	return var0_4
end

function var0_0.RawGetPool(arg0_5, arg1_5)
	if not arg0_5.pools then
		return nil
	end

	return arg0_5.pools[arg1_5]
end

function var0_0.MarkPoolUsed(arg0_6, arg1_6)
	if not arg1_6 then
		return
	end

	arg0_6.poolUseIndex = arg0_6.poolUseIndex + 1
	arg1_6.lastUseIndex = arg0_6.poolUseIndex
end

function var0_0.IsPoolBusy(arg0_7, arg1_7)
	if arg1_7:IsLoading() then
		return true
	end

	if arg0_7.loadingCallbacks[arg1_7.key] and #arg0_7.loadingCallbacks[arg1_7.key] > 0 then
		return true
	end

	return arg0_7.dequeueingCounts[arg1_7.key] and arg0_7.dequeueingCounts[arg1_7.key] > 0
end

function var0_0.BeginDequeue(arg0_8, arg1_8, arg2_8)
	if arg2_8 <= 0 then
		return
	end

	arg0_8.dequeueingCounts[arg1_8.key] = (arg0_8.dequeueingCounts[arg1_8.key] or 0) + arg2_8
end

function var0_0.EndDequeue(arg0_9, arg1_9)
	local var0_9 = arg1_9.key

	if not arg0_9.dequeueingCounts[var0_9] then
		return
	end

	arg0_9.dequeueingCounts[var0_9] = arg0_9.dequeueingCounts[var0_9] - 1

	if arg0_9.dequeueingCounts[var0_9] <= 0 then
		arg0_9.dequeueingCounts[var0_9] = nil
	end
end

function var0_0.GetObject(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg0_10:GetPool(arg1_10, arg2_10)

	if not arg0_10.loadingCallbacks[var0_10.key] then
		arg0_10.loadingCallbacks[var0_10.key] = {}
	end

	table.insert(arg0_10.loadingCallbacks[var0_10.key], arg3_10)

	if var0_10:IsLoading() then
		return
	end

	local var1_10 = {}

	if not var0_10:Isloaded() then
		table.insert(var1_10, function(arg0_11)
			var0_10:Load(arg0_11)
		end)
	end

	seriesAsync(var1_10, function()
		arg0_10:CheckOverFlow(var0_10)

		local var0_12 = {}
		local var1_12 = Clone(arg0_10.loadingCallbacks[var0_10.key])

		arg0_10.loadingCallbacks[var0_10.key] = {}

		arg0_10:BeginDequeue(var0_10, #var1_12)

		for iter0_12, iter1_12 in ipairs(var1_12) do
			table.insert(var0_12, function(arg0_13)
				var0_10:DequeueAsyn(function(arg0_14)
					iter1_12(arg0_14)
					arg0_10:EndDequeue(var0_10)
					arg0_13()
				end)
			end)
		end

		parallelAsync(var0_12, function()
			arg0_10:CheckOverFlow(var0_10)
		end)
	end)
end

function var0_0.ReturnObject(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16:RawGetPool(arg1_16)

	if not var0_16 then
		existCall(arg0_16.instanceDestroyPreProcessor, arg2_16)
		Object.Destroy(arg2_16)

		return
	end

	var0_16:Enqueue(arg2_16)
	arg0_16:CheckOverFlow()
end

function var0_0.CheckOverFlow(arg0_17, arg1_17)
	if not arg0_17.pools or not arg0_17.capacity then
		return
	end

	local var0_17 = table.getCount(arg0_17.pools)

	if var0_17 > arg0_17.capacity then
		arg0_17:DeleteOverflowPools(var0_17 - arg0_17.capacity, arg1_17)
	end
end

function var0_0.DeleteOverflowPools(arg0_18, arg1_18, arg2_18)
	if arg1_18 <= 0 then
		return
	end

	local var0_18 = {}

	for iter0_18, iter1_18 in pairs(arg0_18.pools) do
		if iter1_18 ~= arg2_18 and iter1_18:CanDelete() and not arg0_18:IsPoolBusy(iter1_18) then
			table.insert(var0_18, {
				key = iter0_18,
				pool = iter1_18,
				index = iter1_18.lastUseIndex or 0
			})
		end
	end

	if #var0_18 <= 0 then
		return
	end

	table.sort(var0_18, function(arg0_19, arg1_19)
		if arg0_19.index == arg1_19.index then
			return tostring(arg0_19.key) < tostring(arg1_19.key)
		end

		return arg0_19.index < arg1_19.index
	end)

	local var1_18 = math.min(arg1_18, #var0_18)

	for iter2_18 = 1, var1_18 do
		local var2_18 = var0_18[iter2_18].key
		local var3_18 = arg0_18.pools[var2_18]

		if var3_18 and var3_18 == var0_18[iter2_18].pool and var3_18 ~= arg2_18 and var3_18:CanDelete() and not arg0_18:IsPoolBusy(var3_18) then
			var3_18:Dispose()

			arg0_18.pools[var2_18] = nil
			arg0_18.loadingCallbacks[var2_18] = nil
			arg0_18.dequeueingCounts[var2_18] = nil
		end
	end
end

function var0_0.Clear(arg0_20)
	if not arg0_20.pools then
		return
	end

	for iter0_20, iter1_20 in pairs(arg0_20.pools) do
		iter1_20:Clear()
	end

	arg0_20.pools = {}
	arg0_20.loadingCallbacks = {}
	arg0_20.dequeueingCounts = {}
end

function var0_0.Dispose(arg0_21)
	if not arg0_21.pools then
		return
	end

	for iter0_21, iter1_21 in pairs(arg0_21.pools) do
		iter1_21:Dispose()
	end

	arg0_21.pools = nil
	arg0_21.loadingCallbacks = {}
	arg0_21.dequeueingCounts = {}
end

return var0_0
