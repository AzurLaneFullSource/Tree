local var0 = class("ShopMeshPainting")

function var0.Ctor(arg0, arg1)
	arg0._painting = arg1
end

function var0.Load(arg0, arg1, arg2, arg3)
	setShopPaintingPrefab(arg0._painting, arg1, arg2 or "chuanwu")
	arg3()
end

function var0.Action(arg0, arg1)
	return
end

function var0.UnLoad(arg0, arg1)
	retShopPaintingPrefab(arg0._painting, arg1)
end

return var0
