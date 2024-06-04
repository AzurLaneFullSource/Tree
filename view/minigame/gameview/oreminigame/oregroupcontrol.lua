local var0 = class("OreGroupControl")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.binder = arg1
	arg0._tf = arg2
	arg0.collisionMgr = arg3
	arg0.tpls = findTF(arg0._tf, "tpl")
	arg0.oresTF = findTF(arg0._tf, "ores")
	arg0.oreList = {}
	arg0.poolTF = findTF(arg0._tf, "pool")

	arg0:AddListener()
end

function var0.AddListener(arg0)
	arg0.binder:bind(OreGameConfig.EVENT_ORE_NEW, function(arg0, arg1)
		arg0:NewOre(arg1.index, arg1.pos)
	end)
	arg0.binder:bind(OreGameConfig.EVENT_ORE_DESTROY, function(arg0, arg1)
		arg0.oreList[arg1.index] = nil

		arg0:ReturnOre(findTF(arg0.oresTF, arg1.index), arg1.id)
	end)
end

function var0.NewOre(arg0, arg1, arg2)
	if not findTF(arg0.oresTF, arg1) then
		local var0, var1 = arg0:GetNewOreConfig()
		local var2 = arg0:GetOre(var0)

		var2:SetParent(arg0.oresTF, false)

		var2.name = arg1

		SetActive(var2, true)

		local var3 = Ore.New(arg0.binder, var2, arg0.collisionMgr, var0, arg2)

		arg0.oreList[arg1] = var3

		arg0.binder:emit(OreGameConfig.EVENT_ORE_EF_MINED, {
			index = arg1
		})
	end
end

function var0.Reset(arg0)
	for iter0, iter1 in pairs(arg0.oreList) do
		iter1:Dispose()
	end

	arg0.oreList = {}

	removeAllChildren(arg0.oresTF)

	arg0.weightTable = OreGameConfig.ORE_REFRESH_WEIGHT[math.random(#OreGameConfig.ORE_REFRESH_WEIGHT)]
	arg0.count = 0
	arg0.pools = {}

	removeAllChildren(arg0.poolTF)
end

function var0.GetNewOreConfig(arg0)
	if arg0.count == OreGameConfig.DIAMOND_CONFIH.count then
		local var0 = OreGameConfig.DIAMOND_CONFIH.probability[1] > math.random() and 7 or 8

		arg0.count = 0

		return var0, OreGameConfig.ORE_CONFIG[var0]
	end

	local var1 = OreGameHelper.GetOreIDWithWeight(arg0.weightTable)
	local var2 = OreGameConfig.ORE_CONFIG[var1]

	arg0.count = var2.type == 4 and 0 or arg0.count + 1

	return var1, var2
end

function var0.OnTimer(arg0, arg1)
	for iter0, iter1 in pairs(arg0.oreList) do
		iter1:OnTimer(arg1)
	end
end

function var0.GetOre(arg0, arg1)
	if arg0.pools[arg1] and #arg0.pools[arg1] > 0 then
		return table.remove(arg0.pools[arg1])
	end

	return (tf(Instantiate(findTF(arg0.tpls, "tpl_" .. arg1))))
end

function var0.ReturnOre(arg0, arg1, arg2)
	if not arg0.pools[arg2] then
		arg0.pools[arg2] = {}
	end

	arg1:SetParent(tf(arg0.poolTF), false)
	setActive(arg1, false)
	table.insert(arg0.pools[arg2], tf(arg1))
end

return var0
