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

function var0_0.Isloaded(arg0_2)
	return arg0_2.asset ~= nil
end

function var0_0.IsLoading(arg0_3)
	return arg0_3.isLoading
end

function var0_0.CanDelete(arg0_4)
	return arg0_4:Isloaded() and #arg0_4.items > 0
end

function var0_0.ActiveOrDisactiveItem(arg0_5, arg1_5, arg2_5)
	SetActive(arg1_5, arg2_5)
end

function var0_0.Load(arg0_6, arg1_6)
	arg0_6.isLoading = true
	arg0_6.loadingId = IslandAssetLoadDispatcher.Instance:Enqueue(arg0_6.assetPath, "", arg0_6.assetType, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
		assert(arg0_7, "asset is nil >>>" .. arg0_6.assetPath)

		arg0_6.asset = arg0_7

		if arg0_6:Isloaded() then
			arg1_6()
		end

		arg0_6.isLoading = false
	end), true, true)
end

function var0_0.NewItem(arg0_8)
	assert(arg0_8:Isloaded(), "call load first")

	return Object.Instantiate(arg0_8.asset)
end

function var0_0.NewItemAsyn(arg0_9, arg1_9)
	assert(arg0_9:Isloaded(), "call load first")

	local var0_9 = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_9.asset, function(arg0_10)
		arg1_9(arg0_10)
	end)

	table.insert(arg0_9.insIdList, var0_9)
end

function var0_0.DequeueAsyn(arg0_11, arg1_11)
	if #arg0_11.items > 0 then
		local var0_11 = table.remove(arg0_11.items, 1)

		if UIUtil.IsGameObject(var0_11) then
			arg0_11:ActiveOrDisactiveItem(var0_11, true)
		end

		arg1_11(var0_11)
	else
		arg0_11:NewItemAsyn(function(arg0_12)
			if UIUtil.IsGameObject(arg0_12) then
				arg0_11:ActiveOrDisactiveItem(arg0_12, true)
			end

			arg1_11(arg0_12)
		end)
	end
end

function var0_0.Dequeue(arg0_13)
	local var0_13

	if #arg0_13.items > 0 then
		var0_13 = table.remove(arg0_13.items, 1)
	else
		var0_13 = arg0_13:NewItem()
	end

	if UIUtil.IsGameObject(var0_13) then
		arg0_13:ActiveOrDisactiveItem(var0_13, true)
	end

	assert(var0_13, "item is nil", arg0_13.assetPath)

	return var0_13
end

function var0_0.Enqueue(arg0_14, arg1_14)
	assert(arg1_14, "item is nil")

	if #arg0_14.items >= arg0_14.capacity then
		Object.Destroy(arg1_14)

		return
	end

	if UIUtil.IsGameObject(arg1_14) then
		setParent(arg1_14, arg0_14.root)
		arg0_14:ActiveOrDisactiveItem(arg1_14, false)
	end

	table.insert(arg0_14.items, arg1_14)
end

function var0_0.Clear(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.items) do
		Object.Destroy(iter1_15)
	end

	arg0_15.items = {}

	for iter2_15, iter3_15 in ipairs(arg0_15.insIdList) do
		FrameAsyncInstantiateManager.Instance:Cancel(iter3_15)
	end

	arg0_15.insIdList = {}
end

function var0_0.Dispose(arg0_16)
	arg0_16:Clear()

	arg0_16.items = nil
	arg0_16.asset = nil

	if arg0_16.loadingId then
		IslandAssetLoadDispatcher.Instance:Cancel(arg0_16.loadingId)

		arg0_16.loadingId = nil
	end
end

return var0_0
