local var0_0 = class("BuildShipProxy", import(".NetProxy"))

var0_0.ADDED = "BuildShipProxy ADDED"
var0_0.TIMEUP = "BuildShipProxy TIMEUP"
var0_0.UPDATED = "BuildShipProxy UPDATED"
var0_0.REMOVED = "BuildShipProxy REMOVED"
var0_0.DRAW_COUNT_UPDATE = "BuildShipProxy DRAW_COUNT_UPDATE"
var0_0.REGULAR_BUILD_POOL_COUNT_UPDATE = "BuildShipProxy.REGULAR_BUILD_POOL_COUNT_UPDATE"

function var0_0.register(arg0_1)
	arg0_1:on(12024, function(arg0_2)
		arg0_1.data = {}
		arg0_1.workCount = arg0_2.worklist_count
		arg0_1.drawCount1 = arg0_2.draw_count_1
		arg0_1.drawCount10 = arg0_2.draw_count_10

		for iter0_2, iter1_2 in ipairs(arg0_2.worklist_list) do
			local var0_2 = BuildShip.New(iter1_2)

			var0_2:setId(iter0_2)
			table.insert(arg0_1.data, var0_2)
		end

		arg0_1:setBuildShipState()

		arg0_1.regularExchangeCount = arg0_2.exchange_count
	end)
end

function var0_0.GetPools(arg0_3)
	local var0_3 = {}
	local var1_3 = getProxy(ActivityProxy)

	for iter0_3, iter1_3 in ipairs(var1_3:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})) do
		local var2_3 = {}

		table.insert(var2_3, function(arg0_4)
			if iter1_3 and not iter1_3:isEnd() then
				arg0_4()
			end
		end)
		table.insert(var2_3, function(arg0_5)
			local var0_5 = pg.ship_data_create_exchange[iter1_3.id] or {}

			if iter1_3:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD or iter1_3.data2 < (var0_5.exchange_available_times or 0) then
				arg0_5()
			end
		end)
		seriesAsync(var2_3, function()
			table.insert(var0_3, BuildShipActivityPool.New({
				activityId = iter1_3.id,
				id = iter1_3:getConfig("config_id"),
				mark = BuildShipPool.BUILD_POOL_MARK_NEW
			}))
		end)
	end

	table.insert(var0_3, BuildShipPool.New({
		id = 2,
		mark = BuildShipPool.BUILD_POOL_MARK_LIGHT
	}))
	table.insert(var0_3, BuildShipPool.New({
		id = 3,
		mark = BuildShipPool.BUILD_POOL_MARK_HEAVY
	}))
	table.insert(var0_3, BuildShipPool.New({
		id = 1,
		mark = BuildShipPool.BUILD_POOL_MARK_SPECIAL
	}))

	return var0_3
end

function var0_0.GetPoolsWithoutNewServer(arg0_7)
	local var0_7 = arg0_7:GetPools()

	return _.select(var0_7, function(arg0_8)
		return not (arg0_8:IsActivity() and arg0_8:IsNewServerBuild())
	end)
end

function var0_0.setBuildShipState(arg0_9)
	arg0_9:removeBuildTimer()

	arg0_9.buildIndex = 0
	arg0_9.buildTimers = {}

	local var0_9 = 0

	for iter0_9, iter1_9 in ipairs(arg0_9.data or {}) do
		if var0_9 == arg0_9:getMaxWorkCount() then
			break
		end

		if not iter1_9:isFinish() then
			arg0_9.buildIndex = iter0_9
			var0_9 = var0_9 + 1

			arg0_9:addBuildTimer()
		end

		iter1_9.state = iter1_9:isFinish() and BuildShip.FINISH or BuildShip.ACTIVE
	end
end

function var0_0.getNextBuildShip(arg0_10)
	local var0_10
	local var1_10 = arg0_10.data[arg0_10.buildIndex + 1]

	if var1_10 and var1_10.state == BuildShip.INACTIVE then
		arg0_10.buildIndex = arg0_10.buildIndex + 1
		var0_10 = var1_10
	end

	return var0_10
end

function var0_0.activeNextBuild(arg0_11)
	local var0_11 = arg0_11:getNextBuildShip()

	if var0_11 then
		var0_11:active()
		arg0_11:updateBuildShip(arg0_11.buildIndex, var0_11)
		arg0_11:addBuildTimer()
	end
end

function var0_0.addBuildTimer(arg0_12)
	local var0_12 = arg0_12.buildIndex

	if arg0_12.buildTimers[var0_12] then
		arg0_12.buildTimers[var0_12]:Stop()

		arg0_12.buildTimers[var0_12] = nil
	end

	local function var1_12()
		arg0_12:activeNextBuild()
		arg0_12.data[var0_12]:finish()
		arg0_12.data[var0_12]:display("- build finish -")
		arg0_12:updateBuildShip(var0_12, arg0_12.data[var0_12])
	end

	local var2_12 = arg0_12.data[var0_12].finishTime - pg.TimeMgr.GetInstance():GetServerTime()

	if var2_12 > 0 then
		arg0_12.buildTimers[var0_12] = Timer.New(function()
			arg0_12.buildTimers[var0_12]:Stop()

			arg0_12.buildTimers[var0_12] = nil

			var1_12()
		end, var2_12, 1)

		arg0_12.buildTimers[var0_12]:Start()
	else
		var1_12()
	end
end

function var0_0.getMaxWorkCount(arg0_15)
	return arg0_15.workCount
end

function var0_0.getBuildShipCount(arg0_16)
	return table.getCount(arg0_16.data)
end

function var0_0.removeBuildTimer(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.buildTimers or {}) do
		iter1_17:Stop()
	end

	arg0_17.buildTimers = nil
end

function var0_0.remove(arg0_18)
	arg0_18:removeBuildTimer()

	if arg0_18.exchangeItemTimer then
		arg0_18.exchangeItemTimer:Stop()

		arg0_18.exchangeItemTimer = nil
	end
end

function var0_0.getBuildShip(arg0_19, arg1_19)
	return Clone(arg0_19.data[arg1_19])
end

function var0_0.getFinishCount(arg0_20)
	local var0_20 = 0

	for iter0_20, iter1_20 in pairs(arg0_20.data) do
		if iter1_20.state == BuildShip.FINISH then
			var0_20 = var0_20 + 1
		end
	end

	return var0_20
end

function var0_0.getNeedFinishCount(arg0_21)
	return table.getCount(arg0_21.data) - arg0_21:getFinishCount()
end

function var0_0.getActiveCount(arg0_22)
	local var0_22 = 0

	for iter0_22, iter1_22 in pairs(arg0_22.data) do
		if iter1_22.state == BuildShip.ACTIVE then
			var0_22 = var0_22 + 1
		end
	end

	return var0_22
end

function var0_0.getFinishedIndex(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.data) do
		if iter1_23.state == BuildShip.FINISH then
			return iter0_23
		end
	end
end

function var0_0.canBuildShip(arg0_24, arg1_24)
	local var0_24 = arg0_24:getActiveCount()
	local var1_24 = pg.ship_data_create_material[arg1_24]
	local var2_24 = getProxy(BagProxy):getItemById(var1_24.use_item)

	if var2_24 and var2_24.count >= var1_24.number_1 then
		return getProxy(PlayerProxy):getData().gold >= var1_24.use_gold and var0_24 == 0
	end
end

function var0_0.getActiveOrFinishedCount(arg0_25)
	local var0_25 = 0

	for iter0_25, iter1_25 in pairs(arg0_25.data) do
		if iter1_25.state == BuildShip.ACTIVE or iter1_25.state == BuildShip.FINISH then
			var0_25 = var0_25 + 1
		end
	end

	return var0_25
end

function var0_0.getDrawCount(arg0_26)
	return {
		drawCount1 = arg0_26.drawCount1,
		drawCount10 = arg0_26.drawCount10
	}
end

function var0_0.increaseDrawCount(arg0_27, arg1_27)
	if arg1_27 == 1 then
		arg0_27.drawCount1 = arg0_27.drawCount1 + 1
	elseif arg1_27 == 10 then
		arg0_27.drawCount10 = arg0_27.drawCount10 + 1
	end

	arg0_27:sendNotification(var0_0.DRAW_COUNT_UPDATE, arg0_27:getDrawCount())
end

function var0_0.addBuildShip(arg0_28, arg1_28)
	assert(isa(arg1_28, BuildShip), "should be an instance of BuildShip")
	table.insert(arg0_28.data, arg1_28)

	local var0_28 = arg0_28:getActiveCount()
	local var1_28 = arg0_28:getMaxWorkCount()

	if var0_28 < var1_28 then
		arg1_28:setState(BuildShip.ACTIVE)

		arg0_28.buildIndex = #arg0_28.data

		arg0_28:addBuildTimer()
	elseif var0_28 == var1_28 then
		arg1_28:setState(BuildShip.INACTIVE)
	else
		assert(false, "激活的建船数量大于最大数量")
	end

	arg0_28:sendNotification(var0_0.ADDED, arg1_28:clone())
end

function var0_0.finishBuildShip(arg0_29, arg1_29)
	if arg0_29.buildTimers[arg1_29] then
		arg0_29.buildTimers[arg1_29].func()
	end
end

function var0_0.updateBuildShip(arg0_30, arg1_30, arg2_30)
	assert(isa(arg2_30, BuildShip), "should be an instance of BuildShip")

	arg0_30.data[arg1_30] = arg2_30:clone()

	arg0_30:sendNotification(var0_0.UPDATED, {
		index = arg1_30,
		buildShip = arg2_30:clone()
	})
end

function var0_0.removeBuildShipByIndex(arg0_31, arg1_31)
	local var0_31 = arg0_31.data[arg1_31]:clone()

	assert(var0_31 ~= nil, "buildShip should exist")

	arg0_31.lastPoolType = arg0_31.data[arg1_31].type

	table.remove(arg0_31.data, arg1_31)
	arg0_31:sendNotification(var0_0.REMOVED, {
		index = arg1_31,
		buildShip = var0_31
	})
end

function var0_0.getSkipBatchBuildFlag(arg0_32)
	return arg0_32.skipBatchFlag or false
end

function var0_0.setSkipBatchBuildFlag(arg0_33, arg1_33)
	arg0_33.skipBatchFlag = arg1_33
end

function var0_0.getLastBuildShipPoolType(arg0_34)
	return arg0_34.lastPoolType or 0
end

function var0_0.getSupportShipCost(arg0_35)
	return pg.gameset.supports_config.description[1]
end

function var0_0.changeRegularExchangeCount(arg0_36, arg1_36)
	arg0_36.regularExchangeCount = math.clamp(arg0_36.regularExchangeCount + arg1_36, 0, pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request)

	arg0_36:sendNotification(var0_0.REGULAR_BUILD_POOL_COUNT_UPDATE)
end

function var0_0.getRegularExchangeCount(arg0_37)
	return arg0_37.regularExchangeCount
end

return var0_0
