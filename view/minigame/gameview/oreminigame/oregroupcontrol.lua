local var0_0 = class("OreGroupControl")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1.collisionMgr = arg3_1
	arg0_1.tpls = findTF(arg0_1._tf, "tpl")
	arg0_1.oresTF = findTF(arg0_1._tf, "ores")
	arg0_1.oreList = {}
	arg0_1.poolTF = findTF(arg0_1._tf, "pool")

	arg0_1:AddListener()
end

function var0_0.AddListener(arg0_2)
	arg0_2.binder:bind(OreGameConfig.EVENT_ORE_NEW, function(arg0_3, arg1_3)
		arg0_2:NewOre(arg1_3.index, arg1_3.pos)
	end)
	arg0_2.binder:bind(OreGameConfig.EVENT_ORE_DESTROY, function(arg0_4, arg1_4)
		arg0_2.oreList[arg1_4.index] = nil

		arg0_2:ReturnOre(findTF(arg0_2.oresTF, arg1_4.index), arg1_4.id)
	end)
end

function var0_0.NewOre(arg0_5, arg1_5, arg2_5)
	if not findTF(arg0_5.oresTF, arg1_5) then
		local var0_5, var1_5 = arg0_5:GetNewOreConfig()
		local var2_5 = arg0_5:GetOre(var0_5)

		var2_5:SetParent(arg0_5.oresTF, false)

		var2_5.name = arg1_5

		SetActive(var2_5, true)

		local var3_5 = Ore.New(arg0_5.binder, var2_5, arg0_5.collisionMgr, var0_5, arg2_5)

		arg0_5.oreList[arg1_5] = var3_5

		arg0_5.binder:emit(OreGameConfig.EVENT_ORE_EF_MINED, {
			index = arg1_5
		})
	end
end

function var0_0.Reset(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.oreList) do
		iter1_6:Dispose()
	end

	arg0_6.oreList = {}

	removeAllChildren(arg0_6.oresTF)

	arg0_6.weightTable = OreGameConfig.ORE_REFRESH_WEIGHT[math.random(#OreGameConfig.ORE_REFRESH_WEIGHT)]
	arg0_6.count = 0
	arg0_6.pools = {}

	removeAllChildren(arg0_6.poolTF)
end

function var0_0.GetNewOreConfig(arg0_7)
	if arg0_7.count == OreGameConfig.DIAMOND_CONFIH.count then
		local var0_7 = OreGameConfig.DIAMOND_CONFIH.probability[1] > math.random() and 7 or 8

		arg0_7.count = 0

		return var0_7, OreGameConfig.ORE_CONFIG[var0_7]
	end

	local var1_7 = OreGameHelper.GetOreIDWithWeight(arg0_7.weightTable)
	local var2_7 = OreGameConfig.ORE_CONFIG[var1_7]

	arg0_7.count = var2_7.type == 4 and 0 or arg0_7.count + 1

	return var1_7, var2_7
end

function var0_0.OnTimer(arg0_8, arg1_8)
	for iter0_8, iter1_8 in pairs(arg0_8.oreList) do
		iter1_8:OnTimer(arg1_8)
	end
end

function var0_0.GetOre(arg0_9, arg1_9)
	if arg0_9.pools[arg1_9] and #arg0_9.pools[arg1_9] > 0 then
		return table.remove(arg0_9.pools[arg1_9])
	end

	return (tf(Instantiate(findTF(arg0_9.tpls, "tpl_" .. arg1_9))))
end

function var0_0.ReturnOre(arg0_10, arg1_10, arg2_10)
	if not arg0_10.pools[arg2_10] then
		arg0_10.pools[arg2_10] = {}
	end

	arg1_10:SetParent(tf(arg0_10.poolTF), false)
	setActive(arg1_10, false)
	table.insert(arg0_10.pools[arg2_10], tf(arg1_10))
end

return var0_0
