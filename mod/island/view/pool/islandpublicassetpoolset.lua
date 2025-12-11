local var0_0 = class("IslandPublicAssetPoolSet", import(".IslandObjectPoolSet"))

function var0_0.CreatePool(arg0_1, arg1_1, arg2_1)
	return IslandPublicAssetPool.New(arg0_1.root, arg1_1, arg2_1, arg0_1.poolCapacity)
end

function var0_0.ReturnObject(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:RawGetPool(arg1_2)

	if not var0_2 then
		return
	end

	var0_2:Enqueue(arg2_2)
end

return var0_0
