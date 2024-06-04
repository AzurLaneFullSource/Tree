local var0 = class("BuildShipProxy", import(".NetProxy"))

var0.ADDED = "BuildShipProxy ADDED"
var0.TIMEUP = "BuildShipProxy TIMEUP"
var0.UPDATED = "BuildShipProxy UPDATED"
var0.REMOVED = "BuildShipProxy REMOVED"
var0.DRAW_COUNT_UPDATE = "BuildShipProxy DRAW_COUNT_UPDATE"
var0.REGULAR_BUILD_POOL_COUNT_UPDATE = "BuildShipProxy.REGULAR_BUILD_POOL_COUNT_UPDATE"

function var0.register(arg0)
	arg0:on(12024, function(arg0)
		arg0.data = {}
		arg0.workCount = arg0.worklist_count
		arg0.drawCount1 = arg0.draw_count_1
		arg0.drawCount10 = arg0.draw_count_10

		for iter0, iter1 in ipairs(arg0.worklist_list) do
			local var0 = BuildShip.New(iter1)

			var0:setId(iter0)
			table.insert(arg0.data, var0)
		end

		arg0:setBuildShipState()

		arg0.regularExchangeCount = arg0.exchange_count
	end)
end

function var0.GetPools(arg0)
	local var0 = {}
	local var1 = getProxy(ActivityProxy)

	for iter0, iter1 in ipairs(var1:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})) do
		local var2 = {}

		table.insert(var2, function(arg0)
			if iter1 and not iter1:isEnd() then
				arg0()
			end
		end)
		table.insert(var2, function(arg0)
			local var0 = pg.ship_data_create_exchange[iter1.id] or {}

			if iter1:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD or iter1.data2 < (var0.exchange_available_times or 0) then
				arg0()
			end
		end)
		seriesAsync(var2, function()
			table.insert(var0, BuildShipActivityPool.New({
				activityId = iter1.id,
				id = iter1:getConfig("config_id"),
				mark = BuildShipPool.BUILD_POOL_MARK_NEW
			}))
		end)
	end

	table.insert(var0, BuildShipPool.New({
		id = 2,
		mark = BuildShipPool.BUILD_POOL_MARK_LIGHT
	}))
	table.insert(var0, BuildShipPool.New({
		id = 3,
		mark = BuildShipPool.BUILD_POOL_MARK_HEAVY
	}))
	table.insert(var0, BuildShipPool.New({
		id = 1,
		mark = BuildShipPool.BUILD_POOL_MARK_SPECIAL
	}))

	return var0
end

function var0.GetPoolsWithoutNewServer(arg0)
	local var0 = arg0:GetPools()

	return _.select(var0, function(arg0)
		return not (arg0:IsActivity() and arg0:IsNewServerBuild())
	end)
end

function var0.setBuildShipState(arg0)
	arg0:removeBuildTimer()

	arg0.buildIndex = 0
	arg0.buildTimers = {}

	local var0 = 0

	for iter0, iter1 in ipairs(arg0.data or {}) do
		if var0 == arg0:getMaxWorkCount() then
			break
		end

		if not iter1:isFinish() then
			arg0.buildIndex = iter0
			var0 = var0 + 1

			arg0:addBuildTimer()
		end

		iter1.state = iter1:isFinish() and BuildShip.FINISH or BuildShip.ACTIVE
	end
end

function var0.getNextBuildShip(arg0)
	local var0
	local var1 = arg0.data[arg0.buildIndex + 1]

	if var1 and var1.state == BuildShip.INACTIVE then
		arg0.buildIndex = arg0.buildIndex + 1
		var0 = var1
	end

	return var0
end

function var0.activeNextBuild(arg0)
	local var0 = arg0:getNextBuildShip()

	if var0 then
		var0:active()
		arg0:updateBuildShip(arg0.buildIndex, var0)
		arg0:addBuildTimer()
	end
end

function var0.addBuildTimer(arg0)
	local var0 = arg0.buildIndex

	if arg0.buildTimers[var0] then
		arg0.buildTimers[var0]:Stop()

		arg0.buildTimers[var0] = nil
	end

	local function var1()
		arg0:activeNextBuild()
		arg0.data[var0]:finish()
		arg0.data[var0]:display("- build finish -")
		arg0:updateBuildShip(var0, arg0.data[var0])
	end

	local var2 = arg0.data[var0].finishTime - pg.TimeMgr.GetInstance():GetServerTime()

	if var2 > 0 then
		arg0.buildTimers[var0] = Timer.New(function()
			arg0.buildTimers[var0]:Stop()

			arg0.buildTimers[var0] = nil

			var1()
		end, var2, 1)

		arg0.buildTimers[var0]:Start()
	else
		var1()
	end
end

function var0.getMaxWorkCount(arg0)
	return arg0.workCount
end

function var0.getBuildShipCount(arg0)
	return table.getCount(arg0.data)
end

function var0.removeBuildTimer(arg0)
	for iter0, iter1 in pairs(arg0.buildTimers or {}) do
		iter1:Stop()
	end

	arg0.buildTimers = nil
end

function var0.remove(arg0)
	arg0:removeBuildTimer()

	if arg0.exchangeItemTimer then
		arg0.exchangeItemTimer:Stop()

		arg0.exchangeItemTimer = nil
	end
end

function var0.getBuildShip(arg0, arg1)
	return Clone(arg0.data[arg1])
end

function var0.getFinishCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.state == BuildShip.FINISH then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.getNeedFinishCount(arg0)
	return table.getCount(arg0.data) - arg0:getFinishCount()
end

function var0.getActiveCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.state == BuildShip.ACTIVE then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.getFinishedIndex(arg0)
	for iter0, iter1 in ipairs(arg0.data) do
		if iter1.state == BuildShip.FINISH then
			return iter0
		end
	end
end

function var0.canBuildShip(arg0, arg1)
	local var0 = arg0:getActiveCount()
	local var1 = pg.ship_data_create_material[arg1]
	local var2 = getProxy(BagProxy):getItemById(var1.use_item)

	if var2 and var2.count >= var1.number_1 then
		return getProxy(PlayerProxy):getData().gold >= var1.use_gold and var0 == 0
	end
end

function var0.getActiveOrFinishedCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.state == BuildShip.ACTIVE or iter1.state == BuildShip.FINISH then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.getDrawCount(arg0)
	return {
		drawCount1 = arg0.drawCount1,
		drawCount10 = arg0.drawCount10
	}
end

function var0.increaseDrawCount(arg0, arg1)
	if arg1 == 1 then
		arg0.drawCount1 = arg0.drawCount1 + 1
	elseif arg1 == 10 then
		arg0.drawCount10 = arg0.drawCount10 + 1
	end

	arg0:sendNotification(var0.DRAW_COUNT_UPDATE, arg0:getDrawCount())
end

function var0.addBuildShip(arg0, arg1)
	assert(isa(arg1, BuildShip), "should be an instance of BuildShip")
	table.insert(arg0.data, arg1)

	local var0 = arg0:getActiveCount()
	local var1 = arg0:getMaxWorkCount()

	if var0 < var1 then
		arg1:setState(BuildShip.ACTIVE)

		arg0.buildIndex = #arg0.data

		arg0:addBuildTimer()
	elseif var0 == var1 then
		arg1:setState(BuildShip.INACTIVE)
	else
		assert(false, "激活的建船数量大于最大数量")
	end

	arg0:sendNotification(var0.ADDED, arg1:clone())
end

function var0.finishBuildShip(arg0, arg1)
	if arg0.buildTimers[arg1] then
		arg0.buildTimers[arg1].func()
	end
end

function var0.updateBuildShip(arg0, arg1, arg2)
	assert(isa(arg2, BuildShip), "should be an instance of BuildShip")

	arg0.data[arg1] = arg2:clone()

	arg0:sendNotification(var0.UPDATED, {
		index = arg1,
		buildShip = arg2:clone()
	})
end

function var0.removeBuildShipByIndex(arg0, arg1)
	local var0 = arg0.data[arg1]:clone()

	assert(var0 ~= nil, "buildShip should exist")

	arg0.lastPoolType = arg0.data[arg1].type

	table.remove(arg0.data, arg1)
	arg0:sendNotification(var0.REMOVED, {
		index = arg1,
		buildShip = var0
	})
end

function var0.getSkipBatchBuildFlag(arg0)
	return arg0.skipBatchFlag or false
end

function var0.setSkipBatchBuildFlag(arg0, arg1)
	arg0.skipBatchFlag = arg1
end

function var0.getLastBuildShipPoolType(arg0)
	return arg0.lastPoolType or 0
end

function var0.getSupportShipCost(arg0)
	return pg.gameset.supports_config.description[1]
end

function var0.changeRegularExchangeCount(arg0, arg1)
	arg0.regularExchangeCount = math.clamp(arg0.regularExchangeCount + arg1, 0, pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request)

	arg0:sendNotification(var0.REGULAR_BUILD_POOL_COUNT_UPDATE)
end

function var0.getRegularExchangeCount(arg0)
	return arg0.regularExchangeCount
end

return var0
