local var0_0 = class("PoolObjPack")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.key = arg1_1
	arg0_1.ab = arg2_1
	arg0_1.items = {}
	arg0_1.typeDic = {}
end

function var0_0.Get(arg0_2, arg1_2, arg2_2)
	if not arg0_2.items[arg1_2] then
		arg0_2.items[arg1_2] = arg0_2.ab:LoadAssetSync(arg1_2, arg2_2, false, false)
		arg0_2.typeDic[arg1_2] = arg2_2
	end

	return arg0_2.items[arg1_2]
end

function var0_0.Remove(arg0_3, arg1_3)
	return table.removebykey(arg0_3.items, arg1_3)
end

function var0_0.GetAmount(arg0_4)
	return table.getCount(arg0_4.items)
end

function var0_0.Clear(arg0_5)
	arg0_5.items = nil
	arg0_5.typeDic = nil

	arg0_5.ab:Dispose()

	arg0_5.ab = nil
end

return var0_0
