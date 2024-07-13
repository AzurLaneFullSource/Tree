local var0_0 = class("OreEnemiesControl")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.binder = arg1_1
	arg0_1.collisionMgr = arg3_1
	arg0_1._tf = arg2_1
	arg0_1.poolTF = findTF(arg0_1._tf, "pool")

	arg0_1:Init()
end

function var0_0.AddListener(arg0_2)
	arg0_2.binder:bind(OreGameConfig.EVENT_ENEMY_DESTROY, function(arg0_3, arg1_3)
		arg0_2.enemyList[arg1_3.roadID][arg1_3.index] = nil

		arg0_2:ReturnEnemy(findTF(arg0_2.roadTFs[arg1_3.roadID], arg1_3.index), arg1_3.id)
	end)
end

function var0_0.Init(arg0_4)
	arg0_4:AddListener()

	arg0_4.roadTFs = {
		findTF(arg0_4._tf, "road_1"),
		findTF(arg0_4._tf, "road_2"),
		(findTF(arg0_4._tf, "road_3"))
	}
	arg0_4.tpls = findTF(arg0_4._tf, "tpls")
	arg0_4.enemyList = {}

	arg0_4:Reset()
end

function var0_0.InitCreatList(arg0_5)
	local function var0_5(arg0_6, arg1_6)
		if not arg0_5.createList[arg0_6] then
			local var0_6 = {
				arg1_6
			}

			arg0_5.createList[arg0_6] = var0_6
		else
			table.insert(arg0_5.createList[arg0_6], arg1_6)
		end
	end

	local function var1_5(arg0_7, arg1_7, arg2_7)
		local var0_7 = OreGameConfig.CREATE_CONFIG[arg2_7].num
		local var1_7 = Clone(OreGameConfig.CREATE_CONFIG[arg2_7].enemy)

		assert(var0_7 <= #var1_7, "create cfg illegal. ID: " .. arg2_7)

		local var2_7 = arg0_7

		for iter0_7 = 1, var0_7 do
			local var3_7 = math.random(1, #var1_7)
			local var4_7 = var1_7[var3_7]

			table.remove(var1_7, var3_7)

			local var5_7 = {
				roadID = arg1_7,
				enemyID = var4_7
			}

			var0_5(var2_7, var5_7)

			var2_7 = var2_7 + 1
		end
	end

	arg0_5.roadDir = OreGameConfig.ROAD_DIRECTION[math.random(#OreGameConfig.ROAD_DIRECTION)]

	for iter0_5, iter1_5 in ipairs(arg0_5.roadTFs) do
		local var2_5 = OreGameConfig["CREATE_ENEMY_ROAD_" .. iter0_5]
		local var3_5 = OreGameConfig.ROAD_CONFIG_TYPE[iter0_5]

		if var3_5 == 1 then
			for iter2_5, iter3_5 in ipairs(var2_5) do
				var1_5(iter3_5.time, iter0_5, iter3_5.create)
			end
		elseif var3_5 == 2 then
			for iter4_5, iter5_5 in ipairs(var2_5) do
				local var4_5 = iter5_5.time

				while var4_5 < iter5_5.stop do
					var1_5(var4_5, iter0_5, iter5_5.create)

					var4_5 = var4_5 + math.random(iter5_5.step[1], iter5_5.step[2])
				end
			end
		end
	end
end

function var0_0.CreateEnemy(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var0_8 = arg0_8.indexTags[iter1_8.roadID] + 1

		arg0_8.indexTags[iter1_8.roadID] = var0_8

		local var1_8 = arg0_8:GetEnemy(iter1_8.enemyID)

		var1_8:SetParent(tf(arg0_8.roadTFs[iter1_8.roadID]), false)

		var1_8.name = var0_8

		SetActive(var1_8, true)

		if not arg0_8.enemyList[iter1_8.roadID] then
			arg0_8.enemyList[iter1_8.roadID] = {}
		end

		arg0_8.enemyList[iter1_8.roadID][var0_8] = OreEnemy.New(arg0_8.binder, var1_8, arg0_8.collisionMgr, iter1_8.enemyID, iter1_8.roadID, arg0_8.roadDir[iter1_8.roadID])
	end
end

function var0_0.Reset(arg0_9)
	arg0_9.time = 0
	arg0_9.createList = {}

	for iter0_9, iter1_9 in pairs(arg0_9.enemyList) do
		for iter2_9, iter3_9 in pairs(iter1_9) do
			iter3_9:Dispose()
		end
	end

	arg0_9.enemyList = {}
	arg0_9.indexTags = {
		0,
		0,
		0
	}

	for iter4_9, iter5_9 in pairs(arg0_9.roadTFs) do
		removeAllChildren(iter5_9)
	end

	arg0_9:InitCreatList()

	arg0_9.pools = {}

	removeAllChildren(arg0_9.poolTF)
end

function var0_0.OnTimer(arg0_10, arg1_10)
	arg0_10.time = arg0_10.time + arg1_10

	for iter0_10, iter1_10 in pairs(arg0_10.createList) do
		if iter0_10 <= arg0_10.time then
			arg0_10:CreateEnemy(iter1_10)

			arg0_10.createList[iter0_10] = nil
		end
	end

	for iter2_10, iter3_10 in pairs(arg0_10.enemyList) do
		for iter4_10, iter5_10 in pairs(iter3_10) do
			iter5_10:OnTimer(arg1_10)
		end
	end
end

function var0_0.GetEnemy(arg0_11, arg1_11)
	if arg0_11.pools[arg1_11] and #arg0_11.pools[arg1_11] > 0 then
		return table.remove(arg0_11.pools[arg1_11])
	end

	return (tf(Instantiate(findTF(arg0_11.tpls, arg1_11))))
end

function var0_0.ReturnEnemy(arg0_12, arg1_12, arg2_12)
	if not arg0_12.pools[arg2_12] then
		arg0_12.pools[arg2_12] = {}
	end

	arg1_12:SetParent(tf(arg0_12.poolTF), false)
	setActive(arg1_12, false)
	table.insert(arg0_12.pools[arg2_12], tf(arg1_12))
end

return var0_0
