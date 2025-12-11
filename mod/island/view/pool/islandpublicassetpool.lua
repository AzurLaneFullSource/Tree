local var0_0 = class("IslandPublicAssetPool", import(".IslandObjectPool"))

function var0_0.CanDelete(arg0_1)
	return arg0_1:Isloaded()
end

function var0_0.Dequeue(arg0_2)
	return arg0_2:NewItem()
end

function var0_0.DequeueAsyn(arg0_3, arg1_3)
	arg1_3(arg0_3:NewItem())
end

function var0_0.NewItem(arg0_4)
	assert(arg0_4:Isloaded(), "call load first")

	return arg0_4.asset
end

function var0_0.Enqueue(arg0_5, arg1_5)
	return
end

return var0_0
