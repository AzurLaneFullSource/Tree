local var0_0 = class("IslandFurniture")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.count = arg1_1.count or 1
	arg0_1.time = arg1_1.time or arg1_1.id
	arg0_1.isNew = defaultValue(arg1_1.isNew, false)
end

function var0_0.SetNew(arg0_2, arg1_2)
	arg0_2.isNew = arg1_2
end

function var0_0.SetTime(arg0_3, arg1_3)
	arg0_3.time = arg1_3
end

return var0_0
