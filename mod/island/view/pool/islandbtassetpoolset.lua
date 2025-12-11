local var0_0 = class("IslandBtAssetPoolSet", import(".IslandObjectPoolSet"))

function var0_0.CreatePool(arg0_1, arg1_1, arg2_1)
	return IslandBtAssetPool.New(arg0_1.root, arg1_1, arg2_1, arg0_1.poolCapacity)
end

return var0_0
