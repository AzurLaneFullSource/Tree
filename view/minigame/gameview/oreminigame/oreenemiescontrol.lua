local var0 = class("OreEnemiesControl")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.binder = arg1
	arg0.collisionMgr = arg3
	arg0._tf = arg2
	arg0.poolTF = findTF(arg0._tf, "pool")

	arg0:Init()
end

function var0.AddListener(arg0)
	arg0.binder:bind(OreGameConfig.EVENT_ENEMY_DESTROY, function(arg0, arg1)
		arg0.enemyList[arg1.roadID][arg1.index] = nil

		arg0:ReturnEnemy(findTF(arg0.roadTFs[arg1.roadID], arg1.index), arg1.id)
	end)
end

function var0.Init(arg0)
	arg0:AddListener()

	arg0.roadTFs = {
		findTF(arg0._tf, "road_1"),
		findTF(arg0._tf, "road_2"),
		(findTF(arg0._tf, "road_3"))
	}
	arg0.tpls = findTF(arg0._tf, "tpls")
	arg0.enemyList = {}

	arg0:Reset()
end

function var0.InitCreatList(arg0)
	local function var0(arg0, arg1)
		if not arg0.createList[arg0] then
			local var0 = {
				arg1
			}

			arg0.createList[arg0] = var0
		else
			table.insert(arg0.createList[arg0], arg1)
		end
	end

	local function var1(arg0, arg1, arg2)
		local var0 = OreGameConfig.CREATE_CONFIG[arg2].num
		local var1 = Clone(OreGameConfig.CREATE_CONFIG[arg2].enemy)

		assert(var0 <= #var1, "create cfg illegal. ID: " .. arg2)

		local var2 = arg0

		for iter0 = 1, var0 do
			local var3 = math.random(1, #var1)
			local var4 = var1[var3]

			table.remove(var1, var3)

			local var5 = {
				roadID = arg1,
				enemyID = var4
			}

			var0(var2, var5)

			var2 = var2 + 1
		end
	end

	arg0.roadDir = OreGameConfig.ROAD_DIRECTION[math.random(#OreGameConfig.ROAD_DIRECTION)]

	for iter0, iter1 in ipairs(arg0.roadTFs) do
		local var2 = OreGameConfig["CREATE_ENEMY_ROAD_" .. iter0]
		local var3 = OreGameConfig.ROAD_CONFIG_TYPE[iter0]

		if var3 == 1 then
			for iter2, iter3 in ipairs(var2) do
				var1(iter3.time, iter0, iter3.create)
			end
		elseif var3 == 2 then
			for iter4, iter5 in ipairs(var2) do
				local var4 = iter5.time

				while var4 < iter5.stop do
					var1(var4, iter0, iter5.create)

					var4 = var4 + math.random(iter5.step[1], iter5.step[2])
				end
			end
		end
	end
end

function var0.CreateEnemy(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = arg0.indexTags[iter1.roadID] + 1

		arg0.indexTags[iter1.roadID] = var0

		local var1 = arg0:GetEnemy(iter1.enemyID)

		var1:SetParent(tf(arg0.roadTFs[iter1.roadID]), false)

		var1.name = var0

		SetActive(var1, true)

		if not arg0.enemyList[iter1.roadID] then
			arg0.enemyList[iter1.roadID] = {}
		end

		arg0.enemyList[iter1.roadID][var0] = OreEnemy.New(arg0.binder, var1, arg0.collisionMgr, iter1.enemyID, iter1.roadID, arg0.roadDir[iter1.roadID])
	end
end

function var0.Reset(arg0)
	arg0.time = 0
	arg0.createList = {}

	for iter0, iter1 in pairs(arg0.enemyList) do
		for iter2, iter3 in pairs(iter1) do
			iter3:Dispose()
		end
	end

	arg0.enemyList = {}
	arg0.indexTags = {
		0,
		0,
		0
	}

	for iter4, iter5 in pairs(arg0.roadTFs) do
		removeAllChildren(iter5)
	end

	arg0:InitCreatList()

	arg0.pools = {}

	removeAllChildren(arg0.poolTF)
end

function var0.OnTimer(arg0, arg1)
	arg0.time = arg0.time + arg1

	for iter0, iter1 in pairs(arg0.createList) do
		if iter0 <= arg0.time then
			arg0:CreateEnemy(iter1)

			arg0.createList[iter0] = nil
		end
	end

	for iter2, iter3 in pairs(arg0.enemyList) do
		for iter4, iter5 in pairs(iter3) do
			iter5:OnTimer(arg1)
		end
	end
end

function var0.GetEnemy(arg0, arg1)
	if arg0.pools[arg1] and #arg0.pools[arg1] > 0 then
		return table.remove(arg0.pools[arg1])
	end

	return (tf(Instantiate(findTF(arg0.tpls, arg1))))
end

function var0.ReturnEnemy(arg0, arg1, arg2)
	if not arg0.pools[arg2] then
		arg0.pools[arg2] = {}
	end

	arg1:SetParent(tf(arg0.poolTF), false)
	setActive(arg1, false)
	table.insert(arg0.pools[arg2], tf(arg1))
end

return var0
