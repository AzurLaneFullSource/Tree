local var0_0 = class("CommanderProxy", import(".NetProxy"))

var0_0.COMMANDER_UPDATED = "CommanderProxy:COMMANDER_UPDATED"
var0_0.COMMANDER_ADDED = "CommanderProxy:COMMANDER_ADDED"
var0_0.COMMANDER_DELETED = "CommanderProxy:COMMANDER_DELETED"
var0_0.RESERVE_CNT_UPDATED = "CommanderProxy:RESERVE_CNT_UPDATED"
var0_0.COMMANDER_BOX_FINISHED = "CommanderProxy:COMMANDER_BOX_FINISHED"
var0_0.PREFAB_FLEET_UPDATE = "CommanderProxy:PREFAB_FLEET_UPDATE"
var0_0.MAX_WORK_COUNT = 4
var0_0.MAX_SLOT = 10
var0_0.MAX_PREFAB_FLEET = 3

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.boxes = {}
	arg0_1.prefabFleet = {}
	arg0_1.openCommanderScene = false

	for iter0_1 = 1, var0_0.MAX_PREFAB_FLEET do
		arg0_1.prefabFleet[iter0_1] = CommnaderFleet.New({
			id = iter0_1
		})
	end

	local var0_1 = pg.gameset.commander_box_count.key_value

	for iter1_1 = 1, var0_1 do
		local var1_1 = CommanderBox.New({
			id = iter1_1
		})

		arg0_1:addBox(var1_1)
	end

	arg0_1.pools = {}

	for iter2_1, iter3_1 in ipairs(pg.commander_data_create_material.all) do
		local var2_1 = CommanderBuildPool.New({
			id = iter3_1
		})

		table.insert(arg0_1.pools, var2_1)
	end

	arg0_1.boxUsageCount = 0

	arg0_1:on(25001, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.commanders) do
			local var0_2 = Commander.New(iter1_2)

			arg0_1:addCommander(var0_2)
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.box) do
			local var1_2 = CommanderBox.New(iter3_2, iter2_2)

			arg0_1:updateBox(var1_2)
		end

		for iter4_2, iter5_2 in ipairs(arg0_2.presets) do
			local var2_2 = iter5_2.id
			local var3_2 = iter5_2.commandersid
			local var4_2 = {}

			for iter6_2, iter7_2 in ipairs(var3_2) do
				local var5_2 = arg0_1:getCommanderById(iter7_2.id)

				if var5_2 then
					var4_2[iter7_2.pos] = var5_2
				end
			end

			arg0_1.prefabFleet[var2_2]:Update({
				id = var2_2,
				name = arg0_2.name,
				commanders = var4_2
			})
		end

		arg0_1.boxUsageCount = arg0_2.usage_count or 0

		if not LOCK_CATTERY then
			arg0_1:sendNotification(GAME.GET_COMMANDER_HOME)
		end
	end)

	arg0_1.newCommanderList = {}

	arg0_1:on(25039, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3.commander_list) do
			local var0_3 = Commander.New(iter1_3)

			arg0_1:addCommander(var0_3)
			table.insert(arg0_1.newCommanderList, var0_3)
		end
	end)
end

function var0_0.GetNewestCommander(arg0_4, arg1_4, arg2_4)
	local var0_4 = defaultValue(arg2_4, true)

	if arg1_4 >= #arg0_4.newCommanderList then
		return arg0_4.newCommanderList
	else
		local var1_4 = {}

		for iter0_4 = #arg0_4.newCommanderList - arg1_4 + 1, #arg0_4.newCommanderList do
			table.insert(var1_4, arg0_4.newCommanderList[iter0_4])
		end

		return var1_4
	end

	if var0_4 then
		arg0_4.newCommanderList = {}
	end
end

function var0_0.getPrefabFleetById(arg0_5, arg1_5)
	return arg0_5.prefabFleet[arg1_5]
end

function var0_0.getPrefabFleet(arg0_6)
	return Clone(arg0_6.prefabFleet)
end

function var0_0.updatePrefabFleet(arg0_7, arg1_7)
	arg0_7.prefabFleet[arg1_7.id] = arg1_7

	arg0_7:sendNotification(var0_0.PREFAB_FLEET_UPDATE)
end

function var0_0.updatePrefabFleetName(arg0_8, arg1_8, arg2_8)
	arg0_8.prefabFleet[arg1_8]:updateName(arg2_8)
	arg0_8:sendNotification(var0_0.PREFAB_FLEET_UPDATE)
end

function var0_0.getCommanderCnt(arg0_9)
	return table.getCount(arg0_9.data)
end

function var0_0.getPoolById(arg0_10, arg1_10)
	return _.detect(arg0_10:getPools(), function(arg0_11)
		return arg0_11.id == arg1_10
	end)
end

function var0_0.getPools(arg0_12)
	return arg0_12.pools
end

function var0_0.getBoxUseCnt(arg0_13)
	return arg0_13.boxUsageCount
end

function var0_0.updateBoxUseCnt(arg0_14, arg1_14)
	arg0_14.boxUsageCount = arg0_14.boxUsageCount + arg1_14

	arg0_14:sendNotification(var0_0.RESERVE_CNT_UPDATED, arg0_14.boxUsageCount)
end

function var0_0.resetBoxUseCnt(arg0_15)
	arg0_15.boxUsageCount = 0

	arg0_15:sendNotification(var0_0.RESERVE_CNT_UPDATED, 0)
end

function var0_0.updateBox(arg0_16, arg1_16)
	arg0_16.boxes[arg1_16.id] = arg1_16
end

function var0_0.addBox(arg0_17, arg1_17)
	arg0_17.boxes[arg1_17.id] = arg1_17
end

function var0_0.getBoxes(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in ipairs(arg0_18.boxes) do
		table.insert(var0_18, iter1_18)
	end

	return var0_18
end

function var0_0.getBoxById(arg0_19, arg1_19)
	assert(arg0_19.boxes[arg1_19], "attemp to get a nil box" .. arg1_19)

	return arg0_19.boxes[arg1_19]
end

function var0_0.getCommanderById(arg0_20, arg1_20)
	local var0_20 = arg0_20.data[arg1_20]

	if var0_20 then
		return var0_20:clone()
	end
end

function var0_0.RawGetCommanderById(arg0_21, arg1_21)
	local var0_21 = arg0_21.data[arg1_21]

	if var0_21 then
		return var0_21
	end
end

function var0_0.GetSameConfigIdCommanderCount(arg0_22, arg1_22)
	local var0_22 = 0

	for iter0_22, iter1_22 in pairs(arg0_22.data) do
		if iter1_22.configId == arg1_22 then
			var0_22 = var0_22 + 1
		end
	end

	return var0_22
end

function var0_0.addCommander(arg0_23, arg1_23)
	arg0_23.data[arg1_23.id] = arg1_23

	if getProxy(PlayerProxy):getInited() then
		arg0_23:sendNotification(var0_0.COMMANDER_ADDED, arg1_23:clone())
	end
end

function var0_0.updateCommander(arg0_24, arg1_24)
	assert(arg0_24.data[arg1_24.id], "commander can not be nil")
	assert(isa(arg1_24, Commander), "commander should be and instance of Commander")

	arg0_24.data[arg1_24.id] = arg1_24

	arg0_24:sendNotification(var0_0.COMMANDER_UPDATED, arg1_24:clone())
end

function var0_0.removeCommanderById(arg0_25, arg1_25)
	arg0_25:checkPrefabFleet(arg1_25)
	assert(arg0_25.data[arg1_25], "commander can not be nil")

	arg0_25.data[arg1_25] = nil

	arg0_25:sendNotification(var0_0.COMMANDER_DELETED, arg1_25)
end

function var0_0.checkPrefabFleet(arg0_26, arg1_26)
	for iter0_26, iter1_26 in pairs(arg0_26.prefabFleet) do
		if iter1_26:contains(arg1_26) then
			iter1_26:removeCommander(arg1_26)
		end
	end
end

function var0_0.haveFinishedBox(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.boxes) do
		if iter1_27:getState() == CommanderBox.STATE_FINISHED then
			return true
		end
	end

	return false
end

function var0_0.IsFinishAllBox(arg0_28)
	local var0_28 = 0
	local var1_28 = 0
	local var2_28 = 0

	for iter0_28, iter1_28 in pairs(arg0_28.boxes) do
		local var3_28 = iter1_28:getState()

		if var3_28 == CommanderBox.STATE_FINISHED then
			var0_28 = var0_28 + 1
		elseif var3_28 == CommanderBox.STATE_EMPTY then
			var1_28 = var1_28 + 1
		end

		var2_28 = var2_28 + 1
	end

	return var0_28 > 0 and var0_28 + var1_28 == var2_28
end

function var0_0.onRemove(arg0_29)
	arg0_29:RemoveCalcExpTimer()
	var0_0.super.onRemove(arg0_29)

	arg0_29.openCommanderScene = false
end

function var0_0.AddCommanderHome(arg0_30, arg1_30)
	arg0_30.commanderHome = arg1_30

	local var0_30 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_30 = GetNextHour(1) - var0_30

	arg0_30:StartCalcExpTimer(var1_30)
end

function var0_0.GetCommanderHome(arg0_31)
	return arg0_31.commanderHome
end

function var0_0.StartCalcExpTimer(arg0_32, arg1_32)
	arg0_32:RemoveCalcExpTimer()

	arg0_32.calcExpTimer = Timer.New(function()
		arg0_32:RemoveCalcExpTimer()
		arg0_32:sendNotification(GAME.CALC_CATTERY_EXP, {
			isPeriod = arg1_32 == 3600
		})
		arg0_32:StartCalcExpTimer(3600)
	end, arg1_32, 1)

	arg0_32.calcExpTimer:Start()
end

function var0_0.RemoveCalcExpTimer(arg0_34)
	if arg0_34.calcExpTimer then
		arg0_34.calcExpTimer:Stop()

		arg0_34.calcExpTimer = nil
	end
end

function var0_0.AnyCatteryExistOP(arg0_35)
	local var0_35 = arg0_35:GetCommanderHome()

	if var0_35 then
		return var0_35:AnyCatteryExistOP()
	end

	return false
end

function var0_0.AnyCatteryCanUse(arg0_36)
	local var0_36 = arg0_36:GetCommanderHome()

	if var0_36 then
		return var0_36:AnyCatteryCanUse()
	end

	return false
end

function var0_0.IsHome(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetCommanderHome()

	if var0_37 then
		return var0_37:CommanderInHome(arg1_37)
	end

	return false
end

function var0_0.UpdateOpenCommanderScene(arg0_38, arg1_38)
	arg0_38.openCommanderScene = arg1_38
end

function var0_0.InCommanderScene(arg0_39)
	return arg0_39.openCommanderScene
end

function var0_0.AnyPoolIsWaiting(arg0_40)
	local var0_40 = 0

	for iter0_40, iter1_40 in pairs(arg0_40.boxes) do
		local var1_40 = iter1_40:getState()

		if var1_40 == CommanderBox.STATE_WAITING or var1_40 == CommanderBox.STATE_STARTING then
			return false
		end

		if var1_40 == CommanderBox.STATE_FINISHED then
			var0_40 = var0_40 + 1
		end
	end

	return var0_40 > 0
end

function var0_0.ShouldTipBox(arg0_41)
	local function var0_41()
		local var0_42 = 0

		for iter0_42, iter1_42 in pairs(arg0_41.pools) do
			var0_42 = var0_42 + iter1_42:getItemCount()
		end

		return var0_42 > 0
	end

	local function var1_41()
		for iter0_43, iter1_43 in pairs(arg0_41.boxes) do
			if iter1_43:getState() == CommanderBox.STATE_EMPTY then
				return true
			end
		end

		return false
	end

	if var0_41() then
		if var1_41() then
			return true
		else
			return arg0_41:IsFinishAllBox()
		end
	else
		return arg0_41:IsFinishAllBox()
	end
end

function var0_0.CalcQuickItemUsageCnt(arg0_44)
	local var0_44 = Item.COMMANDER_QUICKLY_TOOL_ID
	local var1_44 = Item.getConfigData(var0_44).usage_arg[1]

	local function var2_44(arg0_45, arg1_45)
		local var0_45 = arg1_45 - arg0_45

		return math.ceil(var0_45 / var1_44)
	end

	local var3_44 = getProxy(BagProxy):getItemCountById(var0_44)
	local var4_44 = 0
	local var5_44 = 0
	local var6_44 = 0
	local var7_44 = {}
	local var8_44 = {}

	for iter0_44, iter1_44 in pairs(arg0_44.boxes) do
		table.insert(var8_44, iter1_44)
	end

	table.sort(var8_44, function(arg0_46, arg1_46)
		local var0_46 = arg0_46.state
		local var1_46 = arg1_46.state

		if var0_46 == var1_46 then
			return arg0_46.index < arg1_46.index
		else
			return var1_46 < var0_46
		end
	end)

	for iter2_44, iter3_44 in ipairs(var8_44) do
		local var9_44 = var6_44
		local var10_44 = iter3_44:getState()

		if var10_44 == CommanderBox.STATE_WAITING then
			var4_44 = var4_44 + 1
			var6_44 = var6_44 + 1

			table.insert(var7_44, iter3_44)

			var5_44 = var5_44 + var2_44(iter3_44.beginTime, iter3_44.finishTime)
		elseif var10_44 == CommanderBox.STATE_STARTING then
			var4_44 = var4_44 + 1
			var6_44 = var6_44 + 1

			table.insert(var7_44, iter3_44)

			local var11_44 = pg.TimeMgr.GetInstance():GetServerTime()

			var5_44 = var5_44 + var2_44(var11_44, iter3_44.finishTime)
		end

		if var5_44 == var3_44 then
			break
		elseif var3_44 < var5_44 then
			var5_44 = var3_44
			var6_44 = var6_44 - 1

			table.remove(var7_44, #var7_44)

			break
		end
	end

	local var12_44 = {
		0,
		0,
		0
	}

	for iter4_44, iter5_44 in ipairs(var7_44) do
		local var13_44 = iter5_44.pool:getRarity()

		var12_44[var13_44] = var12_44[var13_44] + 1
	end

	return var5_44, var4_44, var6_44, var12_44
end

return var0_0
