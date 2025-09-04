local var0_0 = class("IslandObjectPool")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.root = arg1_1
	arg0_1.assetPath = arg2_1
	arg0_1.assetType = arg3_1
	arg0_1.capacity = arg4_1 or 3
	arg0_1.asset = nil
	arg0_1.items = {}
end

function var0_0.Isloaded(arg0_2)
	return arg0_2.asset ~= nil
end

function var0_0.CanDelete(arg0_3)
	return arg0_3:Isloaded() and #arg0_3.items > 0
end

function var0_0.Load(arg0_4, arg1_4)
	ResourceMgr.Inst:getAssetAsync(arg0_4.assetPath, "", arg0_4.assetType, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_5)
		assert(arg0_5, "asset is nil >>>" .. arg0_4.assetPath)

		arg0_4.asset = arg0_5

		if arg0_4:Isloaded() then
			arg1_4()
		end
	end), true, true)
end

function var0_0.NewItem(arg0_6)
	assert(arg0_6:Isloaded(), "call load first")

	return Object.Instantiate(arg0_6.asset)
end

function var0_0.Dequeue(arg0_7)
	local var0_7

	if #arg0_7.items > 0 then
		var0_7 = table.remove(arg0_7.items, 1)
	else
		var0_7 = arg0_7:NewItem()
	end

	if UIUtil.IsGameObject(var0_7) then
		setActive(var0_7, true)
	end

	assert(var0_7, "item is nil", arg0_7.assetPath)

	return var0_7
end

function var0_0.Enqueue(arg0_8, arg1_8)
	assert(arg1_8, "item is nil")

	if #arg0_8.items >= arg0_8.capacity then
		Object.Destroy(arg1_8)

		return
	end

	if UIUtil.IsGameObject(arg1_8) then
		setParent(arg1_8, arg0_8.root)
		setActive(arg1_8, false)
	end

	table.insert(arg0_8.items, arg1_8)
end

function var0_0.Clear(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.items) do
		Object.Destroy(iter1_9)
	end

	arg0_9.items = {}
end

function var0_0.Dispose(arg0_10)
	arg0_10:Clear()

	arg0_10.items = nil
	arg0_10.asset = nil
end

return var0_0
