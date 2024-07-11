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

function var0_0.timeCall(arg0_4)
	return {
		[ProxyRegister.DayCall] = function(arg0_5)
			arg0_4:resetBoxUseCnt()

			local var0_5 = arg0_4:GetCommanderHome()

			if var0_5 then
				var0_5:ResetCatteryOP()
				var0_5:ReduceClean()
			end
		end
	}
end

function var0_0.GetNewestCommander(arg0_6, arg1_6, arg2_6)
	local var0_6 = defaultValue(arg2_6, true)

	if arg1_6 >= #arg0_6.newCommanderList then
		return arg0_6.newCommanderList
	else
		local var1_6 = {}

		for iter0_6 = #arg0_6.newCommanderList - arg1_6 + 1, #arg0_6.newCommanderList do
			table.insert(var1_6, arg0_6.newCommanderList[iter0_6])
		end

		return var1_6
	end

	if var0_6 then
		arg0_6.newCommanderList = {}
	end
end

function var0_0.getPrefabFleetById(arg0_7, arg1_7)
	return arg0_7.prefabFleet[arg1_7]
end

function var0_0.getPrefabFleet(arg0_8)
	return Clone(arg0_8.prefabFleet)
end

function var0_0.updatePrefabFleet(arg0_9, arg1_9)
	arg0_9.prefabFleet[arg1_9.id] = arg1_9

	arg0_9:sendNotification(var0_0.PREFAB_FLEET_UPDATE)
end

function var0_0.updatePrefabFleetName(arg0_10, arg1_10, arg2_10)
	arg0_10.prefabFleet[arg1_10]:updateName(arg2_10)
	arg0_10:sendNotification(var0_0.PREFAB_FLEET_UPDATE)
end

function var0_0.getCommanderCnt(arg0_11)
	return table.getCount(arg0_11.data)
end

function var0_0.getPoolById(arg0_12, arg1_12)
	return _.detect(arg0_12:getPools(), function(arg0_13)
		return arg0_13.id == arg1_12
	end)
end

function var0_0.getPools(arg0_14)
	return arg0_14.pools
end

function var0_0.getBoxUseCnt(arg0_15)
	return arg0_15.boxUsageCount
end

function var0_0.updateBoxUseCnt(arg0_16, arg1_16)
	arg0_16.boxUsageCount = arg0_16.boxUsageCount + arg1_16

	arg0_16:sendNotification(var0_0.RESERVE_CNT_UPDATED, arg0_16.boxUsageCount)
end

function var0_0.resetBoxUseCnt(arg0_17)
	arg0_17.boxUsageCount = 0

	arg0_17:sendNotification(var0_0.RESERVE_CNT_UPDATED, 0)
end

function var0_0.updateBox(arg0_18, arg1_18)
	arg0_18.boxes[arg1_18.id] = arg1_18
end

function var0_0.addBox(arg0_19, arg1_19)
	arg0_19.boxes[arg1_19.id] = arg1_19
end

function var0_0.getBoxes(arg0_20)
	local var0_20 = {}

	for iter0_20, iter1_20 in ipairs(arg0_20.boxes) do
		table.insert(var0_20, iter1_20)
	end

	return var0_20
end

function var0_0.getBoxById(arg0_21, arg1_21)
	assert(arg0_21.boxes[arg1_21], "attemp to get a nil box" .. arg1_21)

	return arg0_21.boxes[arg1_21]
end

function var0_0.getCommanderById(arg0_22, arg1_22)
	local var0_22 = arg0_22.data[arg1_22]

	if var0_22 then
		return var0_22:clone()
	end
end

function var0_0.RawGetCommanderById(arg0_23, arg1_23)
	local var0_23 = arg0_23.data[arg1_23]

	if var0_23 then
		return var0_23
	end
end

function var0_0.GetSameConfigIdCommanderCount(arg0_24, arg1_24)
	local var0_24 = 0

	for iter0_24, iter1_24 in pairs(arg0_24.data) do
		if iter1_24.configId == arg1_24 then
			var0_24 = var0_24 + 1
		end
	end

	return var0_24
end

function var0_0.addCommander(arg0_25, arg1_25)
	arg0_25.data[arg1_25.id] = arg1_25

	if getProxy(PlayerProxy):getInited() then
		arg0_25:sendNotification(var0_0.COMMANDER_ADDED, arg1_25:clone())
	end
end

function var0_0.updateCommander(arg0_26, arg1_26)
	assert(arg0_26.data[arg1_26.id], "commander can not be nil")
	assert(isa(arg1_26, Commander), "commander should be and instance of Commander")

	arg0_26.data[arg1_26.id] = arg1_26

	arg0_26:sendNotification(var0_0.COMMANDER_UPDATED, arg1_26:clone())
end

function var0_0.removeCommanderById(arg0_27, arg1_27)
	arg0_27:checkPrefabFleet(arg1_27)
	assert(arg0_27.data[arg1_27], "commander can not be nil")

	arg0_27.data[arg1_27] = nil

	arg0_27:sendNotification(var0_0.COMMANDER_DELETED, arg1_27)
end

function var0_0.checkPrefabFleet(arg0_28, arg1_28)
	for iter0_28, iter1_28 in pairs(arg0_28.prefabFleet) do
		if iter1_28:contains(arg1_28) then
			iter1_28:removeCommander(arg1_28)
		end
	end
end

function var0_0.haveFinishedBox(arg0_29)
	for iter0_29, iter1_29 in pairs(arg0_29.boxes) do
		if iter1_29:getState() == CommanderBox.STATE_FINISHED then
			return true
		end
	end

	return false
end

function var0_0.IsFinishAllBox(arg0_30)
	local var0_30 = 0
	local var1_30 = 0
	local var2_30 = 0

	for iter0_30, iter1_30 in pairs(arg0_30.boxes) do
		local var3_30 = iter1_30:getState()

		if var3_30 == CommanderBox.STATE_FINISHED then
			var0_30 = var0_30 + 1
		elseif var3_30 == CommanderBox.STATE_EMPTY then
			var1_30 = var1_30 + 1
		end

		var2_30 = var2_30 + 1
	end

	return var0_30 > 0 and var0_30 + var1_30 == var2_30
end

function var0_0.onRemove(arg0_31)
	arg0_31:RemoveCalcExpTimer()
	var0_0.super.onRemove(arg0_31)

	arg0_31.openCommanderScene = false
end

function var0_0.AddCommanderHome(arg0_32, arg1_32)
	arg0_32.commanderHome = arg1_32

	local var0_32 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_32 = GetNextHour(1) - var0_32

	arg0_32:StartCalcExpTimer(var1_32)
end

function var0_0.GetCommanderHome(arg0_33)
	return arg0_33.commanderHome
end

function var0_0.StartCalcExpTimer(arg0_34, arg1_34)
	arg0_34:RemoveCalcExpTimer()

	arg0_34.calcExpTimer = Timer.New(function()
		arg0_34:RemoveCalcExpTimer()
		arg0_34:sendNotification(GAME.CALC_CATTERY_EXP, {
			isPeriod = arg1_34 == 3600
		})
		arg0_34:StartCalcExpTimer(3600)
	end, arg1_34, 1)

	arg0_34.calcExpTimer:Start()
end

function var0_0.RemoveCalcExpTimer(arg0_36)
	if arg0_36.calcExpTimer then
		arg0_36.calcExpTimer:Stop()

		arg0_36.calcExpTimer = nil
	end
end

function var0_0.AnyCatteryExistOP(arg0_37)
	local var0_37 = arg0_37:GetCommanderHome()

	if var0_37 then
		return var0_37:AnyCatteryExistOP()
	end

	return false
end

function var0_0.AnyCatteryCanUse(arg0_38)
	local var0_38 = arg0_38:GetCommanderHome()

	if var0_38 then
		return var0_38:AnyCatteryCanUse()
	end

	return false
end

function var0_0.IsHome(arg0_39, arg1_39)
	local var0_39 = arg0_39:GetCommanderHome()

	if var0_39 then
		return var0_39:CommanderInHome(arg1_39)
	end

	return false
end

function var0_0.UpdateOpenCommanderScene(arg0_40, arg1_40)
	arg0_40.openCommanderScene = arg1_40
end

function var0_0.InCommanderScene(arg0_41)
	return arg0_41.openCommanderScene
end

function var0_0.AnyPoolIsWaiting(arg0_42)
	local var0_42 = 0

	for iter0_42, iter1_42 in pairs(arg0_42.boxes) do
		local var1_42 = iter1_42:getState()

		if var1_42 == CommanderBox.STATE_WAITING or var1_42 == CommanderBox.STATE_STARTING then
			return false
		end

		if var1_42 == CommanderBox.STATE_FINISHED then
			var0_42 = var0_42 + 1
		end
	end

	return var0_42 > 0
end

function var0_0.ShouldTipBox(arg0_43)
	local function var0_43()
		local var0_44 = 0

		for iter0_44, iter1_44 in pairs(arg0_43.pools) do
			var0_44 = var0_44 + iter1_44:getItemCount()
		end

		return var0_44 > 0
	end

	local function var1_43()
		for iter0_45, iter1_45 in pairs(arg0_43.boxes) do
			if iter1_45:getState() == CommanderBox.STATE_EMPTY then
				return true
			end
		end

		return false
	end

	if var0_43() then
		if var1_43() then
			return true
		else
			return arg0_43:IsFinishAllBox()
		end
	else
		return arg0_43:IsFinishAllBox()
	end
end

function var0_0.CalcQuickItemUsageCnt(arg0_46)
	local var0_46 = Item.COMMANDER_QUICKLY_TOOL_ID
	local var1_46 = Item.getConfigData(var0_46).usage_arg[1]

	local function var2_46(arg0_47, arg1_47)
		local var0_47 = arg1_47 - arg0_47

		return math.ceil(var0_47 / var1_46)
	end

	local var3_46 = getProxy(BagProxy):getItemCountById(var0_46)
	local var4_46 = 0
	local var5_46 = 0
	local var6_46 = 0
	local var7_46 = {}
	local var8_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.boxes) do
		table.insert(var8_46, iter1_46)
	end

	table.sort(var8_46, function(arg0_48, arg1_48)
		local var0_48 = arg0_48.state
		local var1_48 = arg1_48.state

		if var0_48 == var1_48 then
			return arg0_48.index < arg1_48.index
		else
			return var1_48 < var0_48
		end
	end)

	for iter2_46, iter3_46 in ipairs(var8_46) do
		local var9_46 = var6_46
		local var10_46 = iter3_46:getState()

		if var10_46 == CommanderBox.STATE_WAITING then
			var4_46 = var4_46 + 1
			var6_46 = var6_46 + 1

			table.insert(var7_46, iter3_46)

			var5_46 = var5_46 + var2_46(iter3_46.beginTime, iter3_46.finishTime)
		elseif var10_46 == CommanderBox.STATE_STARTING then
			var4_46 = var4_46 + 1
			var6_46 = var6_46 + 1

			table.insert(var7_46, iter3_46)

			local var11_46 = pg.TimeMgr.GetInstance():GetServerTime()

			var5_46 = var5_46 + var2_46(var11_46, iter3_46.finishTime)
		end

		if var5_46 == var3_46 then
			break
		elseif var3_46 < var5_46 then
			var5_46 = var3_46
			var6_46 = var6_46 - 1

			table.remove(var7_46, #var7_46)

			break
		end
	end

	local var12_46 = {
		0,
		0,
		0
	}

	for iter4_46, iter5_46 in ipairs(var7_46) do
		local var13_46 = iter5_46.pool:getRarity()

		var12_46[var13_46] = var12_46[var13_46] + 1
	end

	return var5_46, var4_46, var6_46, var12_46
end

return var0_0
