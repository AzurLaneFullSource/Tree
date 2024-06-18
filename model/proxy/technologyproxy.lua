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

function var0_0.setVersion(arg0_5, arg1_5)
	PlayerPrefs.SetInt("technology_version", arg1_5)
	PlayerPrefs.Save()
end

function var0_0.getVersion(arg0_6)
	if not PlayerPrefs.HasKey("technology_version") then
		arg0_6:setVersion(1)

		return 1
	else
		return PlayerPrefs.GetInt("technology_version")
	end
end

function var0_0.getConfigMaxVersion(arg0_7)
	return arg0_7.maxConfigVersion
end

function var0_0.setTendency(arg0_8, arg1_8, arg2_8)
	arg0_8.tendency[arg1_8] = arg2_8
end

function var0_0.getTendency(arg0_9, arg1_9)
	return arg0_9.tendency[arg1_9]
end

function var0_0.updateBlueprintStates(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.bluePrintData or {}) do
		iter1_10:updateState()
	end
end

function var0_0.getColdTime(arg0_11)
	return arg0_11.coldTime
end

function var0_0.updateColdTime(arg0_12)
	arg0_12.coldTime = pg.TimeMgr.GetInstance():GetServerTime() + 86400
end

function var0_0.updateRefreshFlag(arg0_13, arg1_13)
	arg0_13.refreshTechnologysFlag = arg1_13

	arg0_13:sendNotification(var0_0.REFRESH_UPDATED, arg0_13.refreshTechnologysFlag)
end

function var0_0.updateTechnologys(arg0_14, arg1_14)
	arg0_14.data = {}

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		arg0_14.tendency[iter1_14.id] = iter1_14.target

		for iter2_14, iter3_14 in ipairs(iter1_14.technologys) do
			arg0_14.data[iter3_14.id] = Technology.New({
				id = iter3_14.id,
				time = iter3_14.time,
				pool_id = iter1_14.id
			})
		end
	end
end

function var0_0.updateTecCatchup(arg0_15, arg1_15)
	arg0_15.curCatchupTecID = arg1_15.version
	arg0_15.curCatchupGroupID = arg1_15.target
	arg0_15.catchupData = {}

	for iter0_15, iter1_15 in ipairs(arg1_15.pursuings) do
		local var0_15 = TechnologyCatchup.New(iter1_15)

		arg0_15.catchupData[var0_15.id] = var0_15
	end

	arg0_15.curCatchupPrintsNum = arg0_15:getCurCatchNum()

	print("初始下发的科研追赶信息", arg0_15.curCatchupTecID, arg0_15.curCatchupGroupID, arg0_15.curCatchupPrintsNum)
end

function var0_0.updateTechnologyQueue(arg0_16, arg1_16)
	arg0_16.queue = {}

	for iter0_16, iter1_16 in ipairs(arg1_16) do
		table.insert(arg0_16.queue, Technology.New({
			queue = true,
			id = iter1_16.id,
			time = iter1_16.time
		}))
	end

	table.sort(arg0_16.queue, function(arg0_17, arg1_17)
		return arg0_17.time < arg1_17.time
	end)
end

function var0_0.moveTechnologyToQueue(arg0_18, arg1_18)
	local var0_18 = arg0_18.data[arg1_18]

	var0_18.inQueue = true

	table.insert(arg0_18.queue, var0_18)

	arg0_18.data[arg1_18] = nil
end

function var0_0.removeFirstQueueTechnology(arg0_19)
	assert(#arg0_19.queue > 0)
	table.remove(arg0_19.queue, 1)
end

function var0_0.getActivateTechnology(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.data or {}) do
		if iter1_20:isActivate() then
			return Clone(iter1_20)
		end
	end
end

function var0_0.getTechnologyById(arg0_21, arg1_21)
	assert(arg0_21.data[arg1_21], "technology should exist>>" .. arg1_21)

	return arg0_21.data[arg1_21]:clone()
end

function var0_0.updateTechnology(arg0_22, arg1_22)
	assert(arg0_22.data[arg1_22.id], "technology should exist>>" .. arg1_22.id)
	assert(isa(arg1_22, Technology), "technology should be instance of Technology")

	arg0_22.data[arg1_22.id] = arg1_22

	arg0_22:sendNotification(var0_0.TECHNOLOGY_UPDATED, arg1_22:clone())
end

function var0_0.getTechnologys(arg0_23)
	return underscore.values(arg0_23.data)
end

function var0_0.getPlanningTechnologys(arg0_24)
	return table.mergeArray(arg0_24.queue, {
		arg0_24:getActivateTechnology()
	})
end

function var0_0.getBluePrints(arg0_25)
	return Clone(arg0_25.bluePrintData)
end

function var0_0.getBluePrintById(arg0_26, arg1_26)
	return Clone(arg0_26.bluePrintData[arg1_26])
end

function var0_0.getRawBluePrintById(arg0_27, arg1_27)
	return arg0_27.bluePrintData[arg1_27]
end

function var0_0.addBluePrint(arg0_28, arg1_28)
	assert(isa(arg1_28, ShipBluePrint), "bluePrint should be instance of ShipBluePrint")
	assert(arg0_28.bluePrintData[arg1_28.id] == nil, "use function updateBluePrint instead")

	arg0_28.bluePrintData[arg1_28.id] = arg1_28

	arg0_28:sendNotification(var0_0.BLUEPRINT_ADDED, arg1_28:clone())
end

function var0_0.updateBluePrint(arg0_29, arg1_29)
	assert(isa(arg1_29, ShipBluePrint), "bluePrint should be instance of ShipBluePrint")
	assert(arg0_29.bluePrintData[arg1_29.id], "use function addBluePrint instead")

	arg0_29.bluePrintData[arg1_29.id] = arg1_29

	arg0_29:sendNotification(var0_0.BLUEPRINT_UPDATED, arg1_29:clone())
end

function var0_0.getBuildingBluePrint(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.bluePrintData) do
		if iter1_30:isDeving() or iter1_30:isFinished() then
			return iter1_30
		end
	end
end

function var0_0.GetBlueprint4Item(arg0_31, arg1_31)
	return arg0_31.item2blueprint[arg1_31]
end

function var0_0.getCatchupData(arg0_32, arg1_32)
	if not arg0_32.catchupData[arg1_32] then
		local var0_32 = TechnologyCatchup.New({
			version = arg1_32
		})

		arg0_32.catchupData[arg1_32] = var0_32
	end

	return arg0_32.catchupData[arg1_32]
end

function var0_0.updateCatchupData(arg0_33, arg1_33, arg2_33, arg3_33)
	arg0_33.catchupData[arg1_33]:addTargetNum(arg2_33, arg3_33)
end

function var0_0.getCurCatchNum(arg0_34)
	if arg0_34.curCatchupTecID ~= 0 and arg0_34.curCatchupGroupID ~= 0 then
		return arg0_34.catchupData[arg0_34.curCatchupTecID]:getTargetNum(arg0_34.curCatchupGroupID)
	else
		return 0
	end
end

function var0_0.getCatchupState(arg0_35, arg1_35)
	if not arg0_35.catchupData[arg1_35] then
		return TechnologyCatchup.STATE_UNSELECT
	end

	return arg0_35.catchupData[arg1_35]:getState()
end

function var0_0.updateCatchupStates(arg0_36)
	for iter0_36, iter1_36 in pairs(arg0_36.catchupData) do
		iter1_36:updateState()
	end
end

function var0_0.isOpenTargetCatchup(arg0_37)
	return pg.technology_catchup_template ~= nil and #pg.technology_catchup_template.all > 0
end

function var0_0.getNewestCatchupTecID(arg0_38)
	return math.max(unpack(pg.technology_catchup_template.all))
end

function var0_0.isOnCatchup(arg0_39)
	return arg0_39.curCatchupTecID ~= 0 and arg0_39.curCatchupGroupID ~= 0
end

function var0_0.getBluePrintVOByGroupID(arg0_40, arg1_40)
	return arg0_40.bluePrintData[arg1_40]
end

function var0_0.getCurCatchupTecInfo(arg0_41)
	return {
		tecID = arg0_41.curCatchupTecID,
		groupID = arg0_41.curCatchupGroupID,
		printNum = arg0_41.curCatchupPrintsNum
	}
end

function var0_0.setCurCatchupTecInfo(arg0_42, arg1_42, arg2_42)
	arg0_42.curCatchupTecID = arg1_42
	arg0_42.curCatchupGroupID = arg2_42
	arg0_42.curCatchupPrintsNum = arg0_42:getCurCatchNum()

	arg0_42:updateCatchupStates()
	print("设置后的科研追赶信息", arg0_42.curCatchupTecID, arg0_42.curCatchupGroupID, arg0_42.curCatchupPrintsNum)
end

function var0_0.addCatupPrintsNum(arg0_43, arg1_43)
	arg0_43:updateCatchupData(arg0_43.curCatchupTecID, arg0_43.curCatchupGroupID, arg1_43)

	arg0_43.curCatchupPrintsNum = arg0_43:getCurCatchNum()

	print("增加科研图纸", arg1_43, arg0_43.curCatchupPrintsNum)
end

function var0_0.IsShowTip(arg0_44)
	local var0_44 = SelectTechnologyMediator.onTechnologyNotify()
	local var1_44 = SelectTechnologyMediator.onBlueprintNotify()
	local var2_44, var3_44 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "TechnologyMediator")

	return OPEN_TEC_TREE_SYSTEM and getProxy(TechnologyNationProxy):getShowRedPointTag() or (var1_44 or var0_44) and var2_44
end

function var0_0.addPursuingTimes(arg0_45, arg1_45, arg2_45)
	if arg2_45 then
		arg0_45.pursuingTimesUR = arg0_45.pursuingTimesUR + arg1_45
	else
		arg0_45.pursuingTimes = arg0_45.pursuingTimes + arg1_45
	end
end

function var0_0.resetPursuingTimes(arg0_46)
	arg0_46.pursuingTimes = 0
	arg0_46.pursuingTimesUR = 0

	arg0_46:sendNotification(GAME.PURSUING_RESET_DONE)
end

function var0_0.getPursuingTimes(arg0_47, arg1_47)
	if arg1_47 then
		return arg0_47.pursuingTimesUR
	else
		return arg0_47.pursuingTimes
	end
end

function var0_0.calcMaxPursuingCount(arg0_48, arg1_48)
	local var0_48 = pg.gameset[arg1_48:isRarityUR() and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr"].description
	local var1_48 = getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold)
	local var2_48 = 0

	local function var3_48(arg0_49)
		local var0_49 = #var0_48

		while arg0_49 < var0_48[var0_49][1] do
			var0_49 = var0_49 - 1
		end

		return var0_48[var0_49][2]
	end

	local var4_48

	for iter0_48 = arg0_48:getPursuingTimes(arg1_48:isRarityUR()) + 1, var0_48[#var0_48][1] - 1 do
		local var5_48 = arg1_48:getPursuingPrice(var3_48(iter0_48))

		if var1_48 < var5_48 then
			return var2_48
		else
			var1_48 = var1_48 - var5_48
			var2_48 = var2_48 + 1
		end
	end

	return var2_48 + math.floor(var1_48 / arg1_48:getPursuingPrice())
end

function var0_0.calcPursuingCost(arg0_50, arg1_50, arg2_50)
	local var0_50 = pg.gameset[arg1_50:isRarityUR() and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr"].description
	local var1_50 = 0

	local function var2_50(arg0_51)
		local var0_51 = #var0_50

		while arg0_51 < var0_50[var0_51][1] do
			var0_51 = var0_51 - 1
		end

		return var0_50[var0_51][2]
	end

	local var3_50

	for iter0_50 = arg0_50:getPursuingTimes(arg1_50:isRarityUR()) + 1, var0_50[#var0_50][1] - 1 do
		local var4_50 = arg1_50:getPursuingPrice(var2_50(iter0_50))

		if arg2_50 == 0 then
			return var1_50
		else
			var1_50 = var1_50 + var4_50
			arg2_50 = arg2_50 - 1
		end
	end

	return var1_50 + arg2_50 * arg1_50:getPursuingPrice()
end

function var0_0.getPursuingDiscount(arg0_52, arg1_52)
	local var0_52 = getGameset(arg1_52 and "blueprint_pursue_discount_ur" or "blueprint_pursue_discount_ssr")[2]
	local var1_52 = #var0_52

	while arg0_52 < var0_52[var1_52][1] do
		var1_52 = var1_52 - 1
	end

	return var0_52[var1_52][2]
end

function var0_0.getItemCanUnlockBluePrint(arg0_53, arg1_53)
	if not arg0_53.unlockItemDic then
		arg0_53.unlockItemDic = {}

		for iter0_53, iter1_53 in ipairs(pg.ship_data_blueprint.all) do
			local var0_53 = arg0_53.bluePrintData[iter1_53]

			for iter2_53, iter3_53 in ipairs(var0_53:getConfig("gain_item_id")) do
				arg0_53.unlockItemDic[iter3_53] = arg0_53.unlockItemDic[iter3_53] or {}

				table.insert(arg0_53.unlockItemDic[iter3_53], iter1_53)
			end
		end
	end

	return arg0_53.unlockItemDic[arg1_53]
end

function var0_0.CheckPursuingCostTip(arg0_54, arg1_54)
	if var0_0.getPursuingDiscount(arg0_54.pursuingTimes + 1, false) > 0 and var0_0.getPursuingDiscount(arg0_54.pursuingTimesUR + 1, true) > 0 then
		return false
	end

	local var0_54 = {}

	if arg1_54 then
		for iter0_54, iter1_54 in ipairs(arg1_54) do
			var0_54[iter1_54] = true
		end
	else
		for iter2_54 = 1, arg0_54.maxConfigVersion do
			var0_54[iter2_54] = true
		end
	end

	for iter3_54, iter4_54 in pairs(arg0_54.bluePrintData) do
		if var0_54[iter4_54:getConfig("blueprint_version")] and iter4_54:isPursuingCostTip() then
			return true
		end
	end

	return false
end

return var0_0
