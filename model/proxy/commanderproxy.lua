local var0 = class("CommanderProxy", import(".NetProxy"))

var0.COMMANDER_UPDATED = "CommanderProxy:COMMANDER_UPDATED"
var0.COMMANDER_ADDED = "CommanderProxy:COMMANDER_ADDED"
var0.COMMANDER_DELETED = "CommanderProxy:COMMANDER_DELETED"
var0.RESERVE_CNT_UPDATED = "CommanderProxy:RESERVE_CNT_UPDATED"
var0.COMMANDER_BOX_FINISHED = "CommanderProxy:COMMANDER_BOX_FINISHED"
var0.PREFAB_FLEET_UPDATE = "CommanderProxy:PREFAB_FLEET_UPDATE"
var0.MAX_WORK_COUNT = 4
var0.MAX_SLOT = 10
var0.MAX_PREFAB_FLEET = 3

function var0.register(arg0)
	arg0.data = {}
	arg0.boxes = {}
	arg0.prefabFleet = {}
	arg0.openCommanderScene = false

	for iter0 = 1, var0.MAX_PREFAB_FLEET do
		arg0.prefabFleet[iter0] = CommnaderFleet.New({
			id = iter0
		})
	end

	local var0 = pg.gameset.commander_box_count.key_value

	for iter1 = 1, var0 do
		local var1 = CommanderBox.New({
			id = iter1
		})

		arg0:addBox(var1)
	end

	arg0.pools = {}

	for iter2, iter3 in ipairs(pg.commander_data_create_material.all) do
		local var2 = CommanderBuildPool.New({
			id = iter3
		})

		table.insert(arg0.pools, var2)
	end

	arg0.boxUsageCount = 0

	arg0:on(25001, function(arg0)
		for iter0, iter1 in ipairs(arg0.commanders) do
			local var0 = Commander.New(iter1)

			arg0:addCommander(var0)
		end

		for iter2, iter3 in ipairs(arg0.box) do
			local var1 = CommanderBox.New(iter3, iter2)

			arg0:updateBox(var1)
		end

		for iter4, iter5 in ipairs(arg0.presets) do
			local var2 = iter5.id
			local var3 = iter5.commandersid
			local var4 = {}

			for iter6, iter7 in ipairs(var3) do
				local var5 = arg0:getCommanderById(iter7.id)

				if var5 then
					var4[iter7.pos] = var5
				end
			end

			arg0.prefabFleet[var2]:Update({
				id = var2,
				name = arg0.name,
				commanders = var4
			})
		end

		arg0.boxUsageCount = arg0.usage_count or 0

		if not LOCK_CATTERY then
			arg0:sendNotification(GAME.GET_COMMANDER_HOME)
		end
	end)

	arg0.newCommanderList = {}

	arg0:on(25039, function(arg0)
		for iter0, iter1 in ipairs(arg0.commander_list) do
			local var0 = Commander.New(iter1)

			arg0:addCommander(var0)
			table.insert(arg0.newCommanderList, var0)
		end
	end)
end

function var0.GetNewestCommander(arg0, arg1, arg2)
	local var0 = defaultValue(arg2, true)

	if arg1 >= #arg0.newCommanderList then
		return arg0.newCommanderList
	else
		local var1 = {}

		for iter0 = #arg0.newCommanderList - arg1 + 1, #arg0.newCommanderList do
			table.insert(var1, arg0.newCommanderList[iter0])
		end

		return var1
	end

	if var0 then
		arg0.newCommanderList = {}
	end
end

function var0.getPrefabFleetById(arg0, arg1)
	return arg0.prefabFleet[arg1]
end

function var0.getPrefabFleet(arg0)
	return Clone(arg0.prefabFleet)
end

function var0.updatePrefabFleet(arg0, arg1)
	arg0.prefabFleet[arg1.id] = arg1

	arg0:sendNotification(var0.PREFAB_FLEET_UPDATE)
end

function var0.updatePrefabFleetName(arg0, arg1, arg2)
	arg0.prefabFleet[arg1]:updateName(arg2)
	arg0:sendNotification(var0.PREFAB_FLEET_UPDATE)
end

function var0.getCommanderCnt(arg0)
	return table.getCount(arg0.data)
end

function var0.getPoolById(arg0, arg1)
	return _.detect(arg0:getPools(), function(arg0)
		return arg0.id == arg1
	end)
end

function var0.getPools(arg0)
	return arg0.pools
end

function var0.getBoxUseCnt(arg0)
	return arg0.boxUsageCount
end

function var0.updateBoxUseCnt(arg0, arg1)
	arg0.boxUsageCount = arg0.boxUsageCount + arg1

	arg0:sendNotification(var0.RESERVE_CNT_UPDATED, arg0.boxUsageCount)
end

function var0.resetBoxUseCnt(arg0)
	arg0.boxUsageCount = 0

	arg0:sendNotification(var0.RESERVE_CNT_UPDATED, 0)
end

function var0.updateBox(arg0, arg1)
	arg0.boxes[arg1.id] = arg1
end

function var0.addBox(arg0, arg1)
	arg0.boxes[arg1.id] = arg1
end

function var0.getBoxes(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.boxes) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.getBoxById(arg0, arg1)
	assert(arg0.boxes[arg1], "attemp to get a nil box" .. arg1)

	return arg0.boxes[arg1]
end

function var0.getCommanderById(arg0, arg1)
	local var0 = arg0.data[arg1]

	if var0 then
		return var0:clone()
	end
end

function var0.RawGetCommanderById(arg0, arg1)
	local var0 = arg0.data[arg1]

	if var0 then
		return var0
	end
end

function var0.GetSameConfigIdCommanderCount(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.configId == arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.addCommander(arg0, arg1)
	arg0.data[arg1.id] = arg1

	if getProxy(PlayerProxy):getInited() then
		arg0:sendNotification(var0.COMMANDER_ADDED, arg1:clone())
	end
end

function var0.updateCommander(arg0, arg1)
	assert(arg0.data[arg1.id], "commander can not be nil")
	assert(isa(arg1, Commander), "commander should be and instance of Commander")

	arg0.data[arg1.id] = arg1

	arg0:sendNotification(var0.COMMANDER_UPDATED, arg1:clone())
end

function var0.removeCommanderById(arg0, arg1)
	arg0:checkPrefabFleet(arg1)
	assert(arg0.data[arg1], "commander can not be nil")

	arg0.data[arg1] = nil

	arg0:sendNotification(var0.COMMANDER_DELETED, arg1)
end

function var0.checkPrefabFleet(arg0, arg1)
	for iter0, iter1 in pairs(arg0.prefabFleet) do
		if iter1:contains(arg1) then
			iter1:removeCommander(arg1)
		end
	end
end

function var0.haveFinishedBox(arg0)
	for iter0, iter1 in pairs(arg0.boxes) do
		if iter1:getState() == CommanderBox.STATE_FINISHED then
			return true
		end
	end

	return false
end

function var0.IsFinishAllBox(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = 0

	for iter0, iter1 in pairs(arg0.boxes) do
		local var3 = iter1:getState()

		if var3 == CommanderBox.STATE_FINISHED then
			var0 = var0 + 1
		elseif var3 == CommanderBox.STATE_EMPTY then
			var1 = var1 + 1
		end

		var2 = var2 + 1
	end

	return var0 > 0 and var0 + var1 == var2
end

function var0.onRemove(arg0)
	arg0:RemoveCalcExpTimer()
	var0.super.onRemove(arg0)

	arg0.openCommanderScene = false
end

function var0.AddCommanderHome(arg0, arg1)
	arg0.commanderHome = arg1

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = GetNextHour(1) - var0

	arg0:StartCalcExpTimer(var1)
end

function var0.GetCommanderHome(arg0)
	return arg0.commanderHome
end

function var0.StartCalcExpTimer(arg0, arg1)
	arg0:RemoveCalcExpTimer()

	arg0.calcExpTimer = Timer.New(function()
		arg0:RemoveCalcExpTimer()
		arg0:sendNotification(GAME.CALC_CATTERY_EXP, {
			isPeriod = arg1 == 3600
		})
		arg0:StartCalcExpTimer(3600)
	end, arg1, 1)

	arg0.calcExpTimer:Start()
end

function var0.RemoveCalcExpTimer(arg0)
	if arg0.calcExpTimer then
		arg0.calcExpTimer:Stop()

		arg0.calcExpTimer = nil
	end
end

function var0.AnyCatteryExistOP(arg0)
	local var0 = arg0:GetCommanderHome()

	if var0 then
		return var0:AnyCatteryExistOP()
	end

	return false
end

function var0.AnyCatteryCanUse(arg0)
	local var0 = arg0:GetCommanderHome()

	if var0 then
		return var0:AnyCatteryCanUse()
	end

	return false
end

function var0.IsHome(arg0, arg1)
	local var0 = arg0:GetCommanderHome()

	if var0 then
		return var0:CommanderInHome(arg1)
	end

	return false
end

function var0.UpdateOpenCommanderScene(arg0, arg1)
	arg0.openCommanderScene = arg1
end

function var0.InCommanderScene(arg0)
	return arg0.openCommanderScene
end

function var0.AnyPoolIsWaiting(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.boxes) do
		local var1 = iter1:getState()

		if var1 == CommanderBox.STATE_WAITING or var1 == CommanderBox.STATE_STARTING then
			return false
		end

		if var1 == CommanderBox.STATE_FINISHED then
			var0 = var0 + 1
		end
	end

	return var0 > 0
end

function var0.ShouldTipBox(arg0)
	local function var0()
		local var0 = 0

		for iter0, iter1 in pairs(arg0.pools) do
			var0 = var0 + iter1:getItemCount()
		end

		return var0 > 0
	end

	local function var1()
		for iter0, iter1 in pairs(arg0.boxes) do
			if iter1:getState() == CommanderBox.STATE_EMPTY then
				return true
			end
		end

		return false
	end

	if var0() then
		if var1() then
			return true
		else
			return arg0:IsFinishAllBox()
		end
	else
		return arg0:IsFinishAllBox()
	end
end

function var0.CalcQuickItemUsageCnt(arg0)
	local var0 = Item.COMMANDER_QUICKLY_TOOL_ID
	local var1 = Item.getConfigData(var0).usage_arg[1]

	local function var2(arg0, arg1)
		local var0 = arg1 - arg0

		return math.ceil(var0 / var1)
	end

	local var3 = getProxy(BagProxy):getItemCountById(var0)
	local var4 = 0
	local var5 = 0
	local var6 = 0
	local var7 = {}
	local var8 = {}

	for iter0, iter1 in pairs(arg0.boxes) do
		table.insert(var8, iter1)
	end

	table.sort(var8, function(arg0, arg1)
		local var0 = arg0.state
		local var1 = arg1.state

		if var0 == var1 then
			return arg0.index < arg1.index
		else
			return var1 < var0
		end
	end)

	for iter2, iter3 in ipairs(var8) do
		local var9 = var6
		local var10 = iter3:getState()

		if var10 == CommanderBox.STATE_WAITING then
			var4 = var4 + 1
			var6 = var6 + 1

			table.insert(var7, iter3)

			var5 = var5 + var2(iter3.beginTime, iter3.finishTime)
		elseif var10 == CommanderBox.STATE_STARTING then
			var4 = var4 + 1
			var6 = var6 + 1

			table.insert(var7, iter3)

			local var11 = pg.TimeMgr.GetInstance():GetServerTime()

			var5 = var5 + var2(var11, iter3.finishTime)
		end

		if var5 == var3 then
			break
		elseif var3 < var5 then
			var5 = var3
			var6 = var6 - 1

			table.remove(var7, #var7)

			break
		end
	end

	local var12 = {
		0,
		0,
		0
	}

	for iter4, iter5 in ipairs(var7) do
		local var13 = iter5.pool:getRarity()

		var12[var13] = var12[var13] + 1
	end

	return var5, var4, var6, var12
end

return var0
