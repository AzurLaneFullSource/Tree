local var0_0 = class("ShopMeshPainting")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._painting = arg1_1
end

function var0_0.Load(arg0_2, arg1_2, arg2_2, arg3_2)
	setShopPaintingPrefab(arg0_2._painting, arg1_2, arg2_2 or "chuanwu")
	arg3_2()
end

function var0_0.Action(arg0_3, arg1_3)
	return
end

function var0_0.UnLoad(arg0_4, arg1_4)
	retShopPaintingPrefab(arg0_4._painting, arg1_4)
end

return var0_0
