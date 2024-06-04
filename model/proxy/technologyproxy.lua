local var0 = class("TechnologyProxy", import(".NetProxy"))

var0.TECHNOLOGY_UPDATED = "TechnologyProxy:TECHNOLOGY_UPDATED"
var0.BLUEPRINT_ADDED = "TechnologyProxy:BLUEPRINT_ADDED"
var0.BLUEPRINT_UPDATED = "TechnologyProxy:BLUEPRINT_UPDATED"
var0.REFRESH_UPDATED = "TechnologyProxy:REFRESH_UPDATED"

function var0.register(arg0)
	arg0.tendency = {}

	arg0:on(63000, function(arg0)
		arg0:updateTechnologys(arg0.refresh_list)

		arg0.refreshTechnologysFlag = arg0.refresh_flag

		arg0:updateTecCatchup(arg0.catchup)
		arg0:updateTechnologyQueue(arg0.queue)
	end)

	arg0.bluePrintData = {}
	arg0.item2blueprint = {}
	arg0.maxConfigVersion = 0

	_.each(pg.ship_data_blueprint.all, function(arg0)
		local var0 = ShipBluePrint.New({
			id = arg0
		})

		arg0.maxConfigVersion = math.max(arg0.maxConfigVersion, var0:getConfig("blueprint_version"))
		arg0.bluePrintData[var0.id] = var0
		arg0.item2blueprint[var0:getItemId()] = var0.id
	end)
	arg0:on(63100, function(arg0)
		for iter0, iter1 in ipairs(arg0.blueprint_list) do
			local var0 = arg0.bluePrintData[iter1.id]

			assert(var0, "miss config ship_data_blueprint>>>>>>>>" .. iter1.id)
			var0:updateInfo(iter1)
		end

		arg0.coldTime = arg0.cold_time or 0
		arg0.pursuingTimes = arg0.daily_catchup_strengthen or 0
		arg0.pursuingTimesUR = arg0.daily_catchup_strengthen_ur or 0
	end)
end

function var0.setVersion(arg0, arg1)
	PlayerPrefs.SetInt("technology_version", arg1)
	PlayerPrefs.Save()
end

function var0.getVersion(arg0)
	if not PlayerPrefs.HasKey("technology_version") then
		arg0:setVersion(1)

		return 1
	else
		return PlayerPrefs.GetInt("technology_version")
	end
end

function var0.getConfigMaxVersion(arg0)
	return arg0.maxConfigVersion
end

function var0.setTendency(arg0, arg1, arg2)
	arg0.tendency[arg1] = arg2
end

function var0.getTendency(arg0, arg1)
	return arg0.tendency[arg1]
end

function var0.updateBlueprintStates(arg0)
	for iter0, iter1 in pairs(arg0.bluePrintData or {}) do
		iter1:updateState()
	end
end

function var0.getColdTime(arg0)
	return arg0.coldTime
end

function var0.updateColdTime(arg0)
	arg0.coldTime = pg.TimeMgr.GetInstance():GetServerTime() + 86400
end

function var0.updateRefreshFlag(arg0, arg1)
	arg0.refreshTechnologysFlag = arg1

	arg0:sendNotification(var0.REFRESH_UPDATED, arg0.refreshTechnologysFlag)
end

function var0.updateTechnologys(arg0, arg1)
	arg0.data = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.tendency[iter1.id] = iter1.target

		for iter2, iter3 in ipairs(iter1.technologys) do
			arg0.data[iter3.id] = Technology.New({
				id = iter3.id,
				time = iter3.time,
				pool_id = iter1.id
			})
		end
	end
end

function var0.updateTecCatchup(arg0, arg1)
	arg0.curCatchupTecID = arg1.version
	arg0.curCatchupGroupID = arg1.target
	arg0.catchupData = {}

	for iter0, iter1 in ipairs(arg1.pursuings) do
		local var0 = TechnologyCatchup.New(iter1)

		arg0.catchupData[var0.id] = var0
	end

	arg0.curCatchupPrintsNum = arg0:getCurCatchNum()

	print("初始下发的科研追赶信息", arg0.curCatchupTecID, arg0.curCatchupGroupID, arg0.curCatchupPrintsNum)
end

function var0.updateTechnologyQueue(arg0, arg1)
	arg0.queue = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0.queue, Technology.New({
			queue = true,
			id = iter1.id,
			time = iter1.time
		}))
	end

	table.sort(arg0.queue, function(arg0, arg1)
		return arg0.time < arg1.time
	end)
end

function var0.moveTechnologyToQueue(arg0, arg1)
	local var0 = arg0.data[arg1]

	var0.inQueue = true

	table.insert(arg0.queue, var0)

	arg0.data[arg1] = nil
end

function var0.removeFirstQueueTechnology(arg0)
	assert(#arg0.queue > 0)
	table.remove(arg0.queue, 1)
end

function var0.getActivateTechnology(arg0)
	for iter0, iter1 in pairs(arg0.data or {}) do
		if iter1:isActivate() then
			return Clone(iter1)
		end
	end
end

function var0.getTechnologyById(arg0, arg1)
	assert(arg0.data[arg1], "technology should exist>>" .. arg1)

	return arg0.data[arg1]:clone()
end

function var0.updateTechnology(arg0, arg1)
	assert(arg0.data[arg1.id], "technology should exist>>" .. arg1.id)
	assert(isa(arg1, Technology), "technology should be instance of Technology")

	arg0.data[arg1.id] = arg1

	arg0:sendNotification(var0.TECHNOLOGY_UPDATED, arg1:clone())
end

function var0.getTechnologys(arg0)
	return underscore.values(arg0.data)
end

function var0.getPlanningTechnologys(arg0)
	return table.mergeArray(arg0.queue, {
		arg0:getActivateTechnology()
	})
end

function var0.getBluePrints(arg0)
	return Clone(arg0.bluePrintData)
end

function var0.getBluePrintById(arg0, arg1)
	return Clone(arg0.bluePrintData[arg1])
end

function var0.getRawBluePrintById(arg0, arg1)
	return arg0.bluePrintData[arg1]
end

function var0.addBluePrint(arg0, arg1)
	assert(isa(arg1, ShipBluePrint), "bluePrint should be instance of ShipBluePrint")
	assert(arg0.bluePrintData[arg1.id] == nil, "use function updateBluePrint instead")

	arg0.bluePrintData[arg1.id] = arg1

	arg0:sendNotification(var0.BLUEPRINT_ADDED, arg1:clone())
end

function var0.updateBluePrint(arg0, arg1)
	assert(isa(arg1, ShipBluePrint), "bluePrint should be instance of ShipBluePrint")
	assert(arg0.bluePrintData[arg1.id], "use function addBluePrint instead")

	arg0.bluePrintData[arg1.id] = arg1

	arg0:sendNotification(var0.BLUEPRINT_UPDATED, arg1:clone())
end

function var0.getBuildingBluePrint(arg0)
	for iter0, iter1 in pairs(arg0.bluePrintData) do
		if iter1:isDeving() or iter1:isFinished() then
			return iter1
		end
	end
end

function var0.GetBlueprint4Item(arg0, arg1)
	return arg0.item2blueprint[arg1]
end

function var0.getCatchupData(arg0, arg1)
	if not arg0.catchupData[arg1] then
		local var0 = TechnologyCatchup.New({
			version = arg1
		})

		arg0.catchupData[arg1] = var0
	end

	return arg0.catchupData[arg1]
end

function var0.updateCatchupData(arg0, arg1, arg2, arg3)
	arg0.catchupData[arg1]:addTargetNum(arg2, arg3)
end

function var0.getCurCatchNum(arg0)
	if arg0.curCatchupTecID ~= 0 and arg0.curCatchupGroupID ~= 0 then
		return arg0.catchupData[arg0.curCatchupTecID]:getTargetNum(arg0.curCatchupGroupID)
	else
		return 0
	end
end

function var0.getCatchupState(arg0, arg1)
	if not arg0.catchupData[arg1] then
		return TechnologyCatchup.STATE_UNSELECT
	end

	return arg0.catchupData[arg1]:getState()
end

function var0.updateCatchupStates(arg0)
	for iter0, iter1 in pairs(arg0.catchupData) do
		iter1:updateState()
	end
end

function var0.isOpenTargetCatchup(arg0)
	return pg.technology_catchup_template ~= nil and #pg.technology_catchup_template.all > 0
end

function var0.getNewestCatchupTecID(arg0)
	return math.max(unpack(pg.technology_catchup_template.all))
end

function var0.isOnCatchup(arg0)
	return arg0.curCatchupTecID ~= 0 and arg0.curCatchupGroupID ~= 0
end

function var0.getBluePrintVOByGroupID(arg0, arg1)
	return arg0.bluePrintData[arg1]
end

function var0.getCurCatchupTecInfo(arg0)
	return {
		tecID = arg0.curCatchupTecID,
		groupID = arg0.curCatchupGroupID,
		printNum = arg0.curCatchupPrintsNum
	}
end

function var0.setCurCatchupTecInfo(arg0, arg1, arg2)
	arg0.curCatchupTecID = arg1
	arg0.curCatchupGroupID = arg2
	arg0.curCatchupPrintsNum = arg0:getCurCatchNum()

	arg0:updateCatchupStates()
	print("设置后的科研追赶信息", arg0.curCatchupTecID, arg0.curCatchupGroupID, arg0.curCatchupPrintsNum)
end

function var0.addCatupPrintsNum(arg0, arg1)
	arg0:updateCatchupData(arg0.curCatchupTecID, arg0.curCatchupGroupID, arg1)

	arg0.curCatchupPrintsNum = arg0:getCurCatchNum()

	print("增加科研图纸", arg1, arg0.curCatchupPrintsNum)
end

function var0.IsShowTip(arg0)
	local var0 = SelectTechnologyMediator.onTechnologyNotify()
	local var1 = SelectTechnologyMediator.onBlueprintNotify()
	local var2, var3 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "TechnologyMediator")

	return OPEN_TEC_TREE_SYSTEM and getProxy(TechnologyNationProxy):getShowRedPointTag() or (var1 or var0) and var2
end

function var0.addPursuingTimes(arg0, arg1, arg2)
	if arg2 then
		arg0.pursuingTimesUR = arg0.pursuingTimesUR + arg1
	else
		arg0.pursuingTimes = arg0.pursuingTimes + arg1
	end
end

function var0.resetPursuingTimes(arg0)
	arg0.pursuingTimes = 0
	arg0.pursuingTimesUR = 0

	arg0:sendNotification(GAME.PURSUING_RESET_DONE)
end

function var0.getPursuingTimes(arg0, arg1)
	if arg1 then
		return arg0.pursuingTimesUR
	else
		return arg0.pursuingTimes
	end
end

function var0.calcMaxPursuingCount(arg0, arg1)
	local var0 = pg.gameset[arg1:isRarityUR() and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr"].description
	local var1 = getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold)
	local var2 = 0

	local function var3(arg0)
		local var0 = #var0

		while arg0 < var0[var0][1] do
			var0 = var0 - 1
		end

		return var0[var0][2]
	end

	local var4

	for iter0 = arg0:getPursuingTimes(arg1:isRarityUR()) + 1, var0[#var0][1] - 1 do
		local var5 = arg1:getPursuingPrice(var3(iter0))

		if var1 < var5 then
			return var2
		else
			var1 = var1 - var5
			var2 = var2 + 1
		end
	end

	return var2 + math.floor(var1 / arg1:getPursuingPrice())
end

function var0.calcPursuingCost(arg0, arg1, arg2)
	local var0 = pg.gameset[arg1:isRarityUR() and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr"].description
	local var1 = 0

	local function var2(arg0)
		local var0 = #var0

		while arg0 < var0[var0][1] do
			var0 = var0 - 1
		end

		return var0[var0][2]
	end

	local var3

	for iter0 = arg0:getPursuingTimes(arg1:isRarityUR()) + 1, var0[#var0][1] - 1 do
		local var4 = arg1:getPursuingPrice(var2(iter0))

		if arg2 == 0 then
			return var1
		else
			var1 = var1 + var4
			arg2 = arg2 - 1
		end
	end

	return var1 + arg2 * arg1:getPursuingPrice()
end

function var0.getPursuingDiscount(arg0, arg1)
	local var0 = getGameset(arg1 and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr")[2]
	local var1 = #var0

	while arg0 < var0[var1][1] do
		var1 = var1 - 1
	end

	return var0[var1][2]
end

function var0.getItemCanUnlockBluePrint(arg0, arg1)
	if not arg0.unlockItemDic then
		arg0.unlockItemDic = {}

		for iter0, iter1 in ipairs(pg.ship_data_blueprint.all) do
			local var0 = arg0.bluePrintData[iter1]

			for iter2, iter3 in ipairs(var0:getConfig("gain_item_id")) do
				arg0.unlockItemDic[iter3] = arg0.unlockItemDic[iter3] or {}

				table.insert(arg0.unlockItemDic[iter3], iter1)
			end
		end
	end

	return arg0.unlockItemDic[arg1]
end

function var0.CheckPursuingCostTip(arg0, arg1)
	if var0.getPursuingDiscount(arg0.pursuingTimes + 1, false) > 0 and var0.getPursuingDiscount(arg0.pursuingTimesUR + 1, true) > 0 then
		return false
	end

	local var0 = {}

	if arg1 then
		for iter0, iter1 in ipairs(arg1) do
			var0[iter1] = true
		end
	else
		for iter2 = 1, arg0.maxConfigVersion do
			var0[iter2] = true
		end
	end

	for iter3, iter4 in pairs(arg0.bluePrintData) do
		if var0[iter4:getConfig("blueprint_version")] and iter4:isPursuingCostTip() then
			return true
		end
	end

	return false
end

return var0
