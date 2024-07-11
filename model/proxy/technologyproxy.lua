local var0_0 = class("TechnologyProxy", import(".NetProxy"))

var0_0.TECHNOLOGY_UPDATED = "TechnologyProxy:TECHNOLOGY_UPDATED"
var0_0.BLUEPRINT_ADDED = "TechnologyProxy:BLUEPRINT_ADDED"
var0_0.BLUEPRINT_UPDATED = "TechnologyProxy:BLUEPRINT_UPDATED"
var0_0.REFRESH_UPDATED = "TechnologyProxy:REFRESH_UPDATED"

function var0_0.register(arg0_1)
	arg0_1.tendency = {}

	arg0_1:on(63000, function(arg0_2)
		arg0_1:updateTechnologys(arg0_2.refresh_list)

		arg0_1.refreshTechnologysFlag = arg0_2.refresh_flag

		arg0_1:updateTecCatchup(arg0_2.catchup)
		arg0_1:updateTechnologyQueue(arg0_2.queue)
	end)

	arg0_1.bluePrintData = {}
	arg0_1.item2blueprint = {}
	arg0_1.maxConfigVersion = 0

	_.each(pg.ship_data_blueprint.all, function(arg0_3)
		local var0_3 = ShipBluePrint.New({
			id = arg0_3
		})

		arg0_1.maxConfigVersion = math.max(arg0_1.maxConfigVersion, var0_3:getConfig("blueprint_version"))
		arg0_1.bluePrintData[var0_3.id] = var0_3
		arg0_1.item2blueprint[var0_3:getItemId()] = var0_3.id
	end)
	arg0_1:on(63100, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4.blueprint_list) do
			local var0_4 = arg0_1.bluePrintData[iter1_4.id]

			assert(var0_4, "miss config ship_data_blueprint>>>>>>>>" .. iter1_4.id)
			var0_4:updateInfo(iter1_4)
		end

		arg0_1.coldTime = arg0_4.cold_time or 0
		arg0_1.pursuingTimes = arg0_4.daily_catchup_strengthen or 0
		arg0_1.pursuingTimesUR = arg0_4.daily_catchup_strengthen_ur or 0
	end)
end

function var0_0.timeCall(arg0_5)
	return {
		[ProxyRegister.DayCall] = function(arg0_6)
			arg0_5:updateRefreshFlag(0)
		end,
		[ProxyRegister.HourCall] = function(arg0_7)
			if arg0_7 == 4 then
				arg0_5:resetPursuingTimes()
			end
		end
	}
end

function var0_0.setVersion(arg0_8, arg1_8)
	PlayerPrefs.SetInt("technology_version", arg1_8)
	PlayerPrefs.Save()
end

function var0_0.getVersion(arg0_9)
	if not PlayerPrefs.HasKey("technology_version") then
		arg0_9:setVersion(1)

		return 1
	else
		return PlayerPrefs.GetInt("technology_version")
	end
end

function var0_0.getConfigMaxVersion(arg0_10)
	return arg0_10.maxConfigVersion
end

function var0_0.setTendency(arg0_11, arg1_11, arg2_11)
	arg0_11.tendency[arg1_11] = arg2_11
end

function var0_0.getTendency(arg0_12, arg1_12)
	return arg0_12.tendency[arg1_12]
end

function var0_0.updateBlueprintStates(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.bluePrintData or {}) do
		iter1_13:updateState()
	end
end

function var0_0.getColdTime(arg0_14)
	return arg0_14.coldTime
end

function var0_0.updateColdTime(arg0_15)
	arg0_15.coldTime = pg.TimeMgr.GetInstance():GetServerTime() + 86400
end

function var0_0.updateRefreshFlag(arg0_16, arg1_16)
	arg0_16.refreshTechnologysFlag = arg1_16

	arg0_16:sendNotification(var0_0.REFRESH_UPDATED, arg0_16.refreshTechnologysFlag)
end

function var0_0.updateTechnologys(arg0_17, arg1_17)
	arg0_17.data = {}

	for iter0_17, iter1_17 in ipairs(arg1_17) do
		arg0_17.tendency[iter1_17.id] = iter1_17.target

		for iter2_17, iter3_17 in ipairs(iter1_17.technologys) do
			arg0_17.data[iter3_17.id] = Technology.New({
				id = iter3_17.id,
				time = iter3_17.time,
				pool_id = iter1_17.id
			})
		end
	end
end

function var0_0.updateTecCatchup(arg0_18, arg1_18)
	arg0_18.curCatchupTecID = arg1_18.version
	arg0_18.curCatchupGroupID = arg1_18.target
	arg0_18.catchupData = {}

	for iter0_18, iter1_18 in ipairs(arg1_18.pursuings) do
		local var0_18 = TechnologyCatchup.New(iter1_18)

		arg0_18.catchupData[var0_18.id] = var0_18
	end

	arg0_18.curCatchupPrintsNum = arg0_18:getCurCatchNum()

	print("初始下发的科研追赶信息", arg0_18.curCatchupTecID, arg0_18.curCatchupGroupID, arg0_18.curCatchupPrintsNum)
end

function var0_0.updateTechnologyQueue(arg0_19, arg1_19)
	arg0_19.queue = {}

	for iter0_19, iter1_19 in ipairs(arg1_19) do
		table.insert(arg0_19.queue, Technology.New({
			queue = true,
			id = iter1_19.id,
			time = iter1_19.time
		}))
	end

	table.sort(arg0_19.queue, function(arg0_20, arg1_20)
		return arg0_20.time < arg1_20.time
	end)
end

function var0_0.moveTechnologyToQueue(arg0_21, arg1_21)
	local var0_21 = arg0_21.data[arg1_21]

	var0_21.inQueue = true

	table.insert(arg0_21.queue, var0_21)

	arg0_21.data[arg1_21] = nil
end

function var0_0.removeFirstQueueTechnology(arg0_22)
	assert(#arg0_22.queue > 0)
	table.remove(arg0_22.queue, 1)
end

function var0_0.getActivateTechnology(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23.data or {}) do
		if iter1_23:isActivate() then
			return Clone(iter1_23)
		end
	end
end

function var0_0.getTechnologyById(arg0_24, arg1_24)
	assert(arg0_24.data[arg1_24], "technology should exist>>" .. arg1_24)

	return arg0_24.data[arg1_24]:clone()
end

function var0_0.updateTechnology(arg0_25, arg1_25)
	assert(arg0_25.data[arg1_25.id], "technology should exist>>" .. arg1_25.id)
	assert(isa(arg1_25, Technology), "technology should be instance of Technology")

	arg0_25.data[arg1_25.id] = arg1_25

	arg0_25:sendNotification(var0_0.TECHNOLOGY_UPDATED, arg1_25:clone())
end

function var0_0.getTechnologys(arg0_26)
	return underscore.values(arg0_26.data)
end

function var0_0.getPlanningTechnologys(arg0_27)
	return table.mergeArray(arg0_27.queue, {
		arg0_27:getActivateTechnology()
	})
end

function var0_0.getBluePrints(arg0_28)
	return Clone(arg0_28.bluePrintData)
end

function var0_0.getBluePrintById(arg0_29, arg1_29)
	return Clone(arg0_29.bluePrintData[arg1_29])
end

function var0_0.getRawBluePrintById(arg0_30, arg1_30)
	return arg0_30.bluePrintData[arg1_30]
end

function var0_0.addBluePrint(arg0_31, arg1_31)
	assert(isa(arg1_31, ShipBluePrint), "bluePrint should be instance of ShipBluePrint")
	assert(arg0_31.bluePrintData[arg1_31.id] == nil, "use function updateBluePrint instead")

	arg0_31.bluePrintData[arg1_31.id] = arg1_31

	arg0_31:sendNotification(var0_0.BLUEPRINT_ADDED, arg1_31:clone())
end

function var0_0.updateBluePrint(arg0_32, arg1_32)
	assert(isa(arg1_32, ShipBluePrint), "bluePrint should be instance of ShipBluePrint")
	assert(arg0_32.bluePrintData[arg1_32.id], "use function addBluePrint instead")

	arg0_32.bluePrintData[arg1_32.id] = arg1_32

	arg0_32:sendNotification(var0_0.BLUEPRINT_UPDATED, arg1_32:clone())
end

function var0_0.getBuildingBluePrint(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.bluePrintData) do
		if iter1_33:isDeving() or iter1_33:isFinished() then
			return iter1_33
		end
	end
end

function var0_0.GetBlueprint4Item(arg0_34, arg1_34)
	return arg0_34.item2blueprint[arg1_34]
end

function var0_0.getCatchupData(arg0_35, arg1_35)
	if not arg0_35.catchupData[arg1_35] then
		local var0_35 = TechnologyCatchup.New({
			version = arg1_35
		})

		arg0_35.catchupData[arg1_35] = var0_35
	end

	return arg0_35.catchupData[arg1_35]
end

function var0_0.updateCatchupData(arg0_36, arg1_36, arg2_36, arg3_36)
	arg0_36.catchupData[arg1_36]:addTargetNum(arg2_36, arg3_36)
end

function var0_0.getCurCatchNum(arg0_37)
	if arg0_37.curCatchupTecID ~= 0 and arg0_37.curCatchupGroupID ~= 0 then
		return arg0_37.catchupData[arg0_37.curCatchupTecID]:getTargetNum(arg0_37.curCatchupGroupID)
	else
		return 0
	end
end

function var0_0.getCatchupState(arg0_38, arg1_38)
	if not arg0_38.catchupData[arg1_38] then
		return TechnologyCatchup.STATE_UNSELECT
	end

	return arg0_38.catchupData[arg1_38]:getState()
end

function var0_0.updateCatchupStates(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.catchupData) do
		iter1_39:updateState()
	end
end

function var0_0.isOpenTargetCatchup(arg0_40)
	return pg.technology_catchup_template ~= nil and #pg.technology_catchup_template.all > 0
end

function var0_0.getNewestCatchupTecID(arg0_41)
	return math.max(unpack(pg.technology_catchup_template.all))
end

function var0_0.isOnCatchup(arg0_42)
	return arg0_42.curCatchupTecID ~= 0 and arg0_42.curCatchupGroupID ~= 0
end

function var0_0.getBluePrintVOByGroupID(arg0_43, arg1_43)
	return arg0_43.bluePrintData[arg1_43]
end

function var0_0.getCurCatchupTecInfo(arg0_44)
	return {
		tecID = arg0_44.curCatchupTecID,
		groupID = arg0_44.curCatchupGroupID,
		printNum = arg0_44.curCatchupPrintsNum
	}
end

function var0_0.setCurCatchupTecInfo(arg0_45, arg1_45, arg2_45)
	arg0_45.curCatchupTecID = arg1_45
	arg0_45.curCatchupGroupID = arg2_45
	arg0_45.curCatchupPrintsNum = arg0_45:getCurCatchNum()

	arg0_45:updateCatchupStates()
	print("设置后的科研追赶信息", arg0_45.curCatchupTecID, arg0_45.curCatchupGroupID, arg0_45.curCatchupPrintsNum)
end

function var0_0.addCatupPrintsNum(arg0_46, arg1_46)
	arg0_46:updateCatchupData(arg0_46.curCatchupTecID, arg0_46.curCatchupGroupID, arg1_46)

	arg0_46.curCatchupPrintsNum = arg0_46:getCurCatchNum()

	print("增加科研图纸", arg1_46, arg0_46.curCatchupPrintsNum)
end

function var0_0.IsShowTip(arg0_47)
	local var0_47 = SelectTechnologyMediator.onTechnologyNotify()
	local var1_47 = SelectTechnologyMediator.onBlueprintNotify()
	local var2_47, var3_47 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "TechnologyMediator")

	return OPEN_TEC_TREE_SYSTEM and getProxy(TechnologyNationProxy):getShowRedPointTag() or (var1_47 or var0_47) and var2_47
end

function var0_0.addPursuingTimes(arg0_48, arg1_48, arg2_48)
	if arg2_48 then
		arg0_48.pursuingTimesUR = arg0_48.pursuingTimesUR + arg1_48
	else
		arg0_48.pursuingTimes = arg0_48.pursuingTimes + arg1_48
	end
end

function var0_0.resetPursuingTimes(arg0_49)
	arg0_49.pursuingTimes = 0
	arg0_49.pursuingTimesUR = 0

	arg0_49:sendNotification(GAME.PURSUING_RESET_DONE)
end

function var0_0.getPursuingTimes(arg0_50, arg1_50)
	if arg1_50 then
		return arg0_50.pursuingTimesUR
	else
		return arg0_50.pursuingTimes
	end
end

function var0_0.calcMaxPursuingCount(arg0_51, arg1_51)
	local var0_51 = pg.gameset[arg1_51:isRarityUR() and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr"].description
	local var1_51 = getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold)
	local var2_51 = 0

	local function var3_51(arg0_52)
		local var0_52 = #var0_51

		while arg0_52 < var0_51[var0_52][1] do
			var0_52 = var0_52 - 1
		end

		return var0_51[var0_52][2]
	end

	local var4_51

	for iter0_51 = arg0_51:getPursuingTimes(arg1_51:isRarityUR()) + 1, var0_51[#var0_51][1] - 1 do
		local var5_51 = arg1_51:getPursuingPrice(var3_51(iter0_51))

		if var1_51 < var5_51 then
			return var2_51
		else
			var1_51 = var1_51 - var5_51
			var2_51 = var2_51 + 1
		end
	end

	return var2_51 + math.floor(var1_51 / arg1_51:getPursuingPrice())
end

function var0_0.calcPursuingCost(arg0_53, arg1_53, arg2_53)
	local var0_53 = pg.gameset[arg1_53:isRarityUR() and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr"].description
	local var1_53 = 0

	local function var2_53(arg0_54)
		local var0_54 = #var0_53

		while arg0_54 < var0_53[var0_54][1] do
			var0_54 = var0_54 - 1
		end

		return var0_53[var0_54][2]
	end

	local var3_53

	for iter0_53 = arg0_53:getPursuingTimes(arg1_53:isRarityUR()) + 1, var0_53[#var0_53][1] - 1 do
		local var4_53 = arg1_53:getPursuingPrice(var2_53(iter0_53))

		if arg2_53 == 0 then
			return var1_53
		else
			var1_53 = var1_53 + var4_53
			arg2_53 = arg2_53 - 1
		end
	end

	return var1_53 + arg2_53 * arg1_53:getPursuingPrice()
end

function var0_0.getPursuingDiscount(arg0_55, arg1_55)
	local var0_55 = getGameset(arg1_55 and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr")[2]
	local var1_55 = #var0_55

	while arg0_55 < var0_55[var1_55][1] do
		var1_55 = var1_55 - 1
	end

	return var0_55[var1_55][2]
end

function var0_0.getItemCanUnlockBluePrint(arg0_56, arg1_56)
	if not arg0_56.unlockItemDic then
		arg0_56.unlockItemDic = {}

		for iter0_56, iter1_56 in ipairs(pg.ship_data_blueprint.all) do
			local var0_56 = arg0_56.bluePrintData[iter1_56]

			for iter2_56, iter3_56 in ipairs(var0_56:getConfig("gain_item_id")) do
				arg0_56.unlockItemDic[iter3_56] = arg0_56.unlockItemDic[iter3_56] or {}

				table.insert(arg0_56.unlockItemDic[iter3_56], iter1_56)
			end
		end
	end

	return arg0_56.unlockItemDic[arg1_56]
end

function var0_0.CheckPursuingCostTip(arg0_57, arg1_57)
	if var0_0.getPursuingDiscount(arg0_57.pursuingTimes + 1, false) > 0 and var0_0.getPursuingDiscount(arg0_57.pursuingTimesUR + 1, true) > 0 then
		return false
	end

	local var0_57 = {}

	if arg1_57 then
		for iter0_57, iter1_57 in ipairs(arg1_57) do
			var0_57[iter1_57] = true
		end
	else
		for iter2_57 = 1, arg0_57.maxConfigVersion do
			var0_57[iter2_57] = true
		end
	end

	for iter3_57, iter4_57 in pairs(arg0_57.bluePrintData) do
		if var0_57[iter4_57:getConfig("blueprint_version")] and iter4_57:isPursuingCostTip() then
			return true
		end
	end

	return false
end

return var0_0
