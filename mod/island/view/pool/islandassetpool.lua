local var0_0 = class("IslandAssetPool", import(".IslandObjectPool"))

function var0_0.CanDelete(arg0_1)
	return true
end

function var0_0.Dequeue(arg0_2)
	return arg0_2:NewItem()
end

function var0_0.Enqueue(arg0_3, arg1_3)
	Object.Destroy(arg1_3)
end

return var0_0
