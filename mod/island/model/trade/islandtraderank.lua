local var0_0 = class("IslandTradeRank")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.value = arg1_1.value
	arg0_1.skinId = arg1_1.skinId
	arg0_1.islandLevel = arg1_1.islandLevel
	arg0_1.name = arg1_1.name
end

function var0_0.IsSelf(arg0_2)
	local var0_2 = getProxy(PlayerProxy):getRawData()

	return arg0_2.id == var0_2.id
end

function var0_0.SetValue(arg0_3, arg1_3)
	arg0_3.value = arg1_3
end

return var0_0
