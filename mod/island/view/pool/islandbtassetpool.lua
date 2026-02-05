local var0_0 = class("IslandBtAssetPool", import(".IslandObjectPool"))

function var0_0.CanDelete(arg0_1)
	return arg0_1:Isloaded()
end

function var0_0.Dequeue(arg0_2)
	return arg0_2:NewItem()
end

function var0_0.DequeueAsyn(arg0_3, arg1_3)
	assert(arg0_3:Isloaded(), "call load first")
	arg1_3(Object.Instantiate(arg0_3.asset))
end

function var0_0.Enqueue(arg0_4, arg1_4)
	return
end

return var0_0
