local var0_0 = class("IslandAgoraFurnitureTplPool", import(".IslandPoolBase"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.root = arg1_1
	arg0_1.pool = IslandObjectPool.New(arg0_1.root, "ui/agorafurnituretpl", typeof(GameObject), arg3_1)
end

function var0_0.Init(arg0_2, arg1_2)
	if arg0_2.pool:Isloaded() then
		arg1_2()

		return
	end

	arg0_2.pool:Load(arg1_2)
end

function var0_0.GetObject(arg0_3)
	return arg0_3.pool:Dequeue()
end

function var0_0.ReturnObject(arg0_4, arg1_4)
	arg0_4.pool:Enqueue(arg1_4)
end

function var0_0.Clear(arg0_5)
	arg0_5.pool:Clear()
end

function var0_0.Dispose(arg0_6)
	arg0_6.pool:Dispose()
end

return var0_0
