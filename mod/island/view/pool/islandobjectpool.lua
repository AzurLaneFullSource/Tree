local var0_0 = class("IslandObjectPool")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.root = arg1_1
	arg0_1.assetPath = arg2_1
	arg0_1.assetType = arg3_1
	arg0_1.capacity = arg4_1 or 3
	arg0_1.asset = nil
	arg0_1.key = arg0_1.assetPath
	arg0_1.items = {}
	arg0_1.isLoading = false
	arg0_1.insIdList = {}
end

function var0_0.SetInstanceDestroyPreProcessor(arg0_2, arg1_2)
	arg0_2.instanceDestroyPreProcessor = arg1_2
end

function var0_0.Isloaded(arg0_3)
	return arg0_3.asset ~= nil
end

function var0_0.IsLoading(arg0_4)
	return arg0_4.isLoading
end

function var0_0.CanDelete(arg0_5)
	return arg0_5:Isloaded() and #arg0_5.items > 0
end

function var0_0.ActiveOrDisactiveItem(arg0_6, arg1_6, arg2_6)
	SetActive(arg1_6, arg2_6)
end

function var0_0.Load(arg0_7, arg1_7)
	arg0_7.isLoading = true
	arg0_7.loadingId = IslandAssetLoadDispatcher.Instance:Enqueue(arg0_7.assetPath, "", arg0_7.assetType, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_8)
		assert(arg0_8, "asset is nil >>>" .. arg0_7.assetPath)

		arg0_7.asset = arg0_8

		if arg0_7:Isloaded() then
			arg1_7()
		end

		arg0_7.isLoading = false
	end), true, true)
end

function var0_0.NewItem(arg0_9)
	assert(arg0_9:Isloaded(), "call load first")

	return Object.Instantiate(arg0_9.asset)
end

function var0_0.NewItemAsyn(arg0_10, arg1_10)
	assert(arg0_10:Isloaded(), "call load first")

	local var0_10 = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_10.asset, function(arg0_11)
		arg1_10(arg0_11)
	end)

	table.insert(arg0_10.insIdList, var0_10)
end

function var0_0.DequeueAsyn(arg0_12, arg1_12)
	if #arg0_12.items > 0 then
		local var0_12 = table.remove(arg0_12.items, 1)

		if UIUtil.IsGameObject(var0_12) then
			arg0_12:ActiveOrDisactiveItem(var0_12, true)
		end

		arg1_12(var0_12)
	else
		arg0_12:NewItemAsyn(function(arg0_13)
			if UIUtil.IsGameObject(arg0_13) then
				arg0_12:ActiveOrDisactiveItem(arg0_13, true)
			end

			arg1_12(arg0_13)
		end)
	end
end

function var0_0.Dequeue(arg0_14)
	local var0_14

	if #arg0_14.items > 0 then
		var0_14 = table.remove(arg0_14.items, 1)
	else
		var0_14 = arg0_14:NewItem()
	end

	if UIUtil.IsGameObject(var0_14) then
		arg0_14:ActiveOrDisactiveItem(var0_14, true)
	end

	assert(var0_14, "item is nil", arg0_14.assetPath)

	return var0_14
end

function var0_0.Enqueue(arg0_15, arg1_15)
	assert(arg1_15, "item is nil")

	if #arg0_15.items >= arg0_15.capacity then
		existCall(arg0_15.instanceDestroyPreProcessor, arg1_15)
		Object.Destroy(arg1_15)

		return
	end

	if UIUtil.IsGameObject(arg1_15) then
		setParent(arg1_15, arg0_15.root)
		arg0_15:ActiveOrDisactiveItem(arg1_15, false)
	end

	table.insert(arg0_15.items, arg1_15)
end

function var0_0.Clear(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.items) do
		existCall(arg0_16.instanceDestroyPreProcessor, iter1_16)
		Object.Destroy(iter1_16)
	end

	arg0_16.items = {}

	for iter2_16, iter3_16 in ipairs(arg0_16.insIdList) do
		FrameAsyncInstantiateManager.Instance:Cancel(iter3_16)
	end

	arg0_16.insIdList = {}
end

function var0_0.Dispose(arg0_17)
	arg0_17:Clear()

	arg0_17.items = nil
	arg0_17.asset = nil

	if arg0_17.loadingId then
		IslandAssetLoadDispatcher.Instance:Cancel(arg0_17.loadingId)

		arg0_17.loadingId = nil
	end
end

return var0_0
