local var0_0 = class("CollectionProxy", import(".NetProxy"))

var0_0.AWARDS_UPDATE = "awards update"
var0_0.GROUP_INFO_UPDATE = "group info update"
var0_0.GROUP_EVALUATION_UPDATE = "group evaluation update"
var0_0.TROPHY_UPDATE = "trophy update"
var0_0.MAX_DAILY_EVA_COUNT = 1
var0_0.KEY_17001_TIME_STAMP = "KEY_17001_TIME_STAMP"

function var0_0.register(arg0_1)
	arg0_1.shipGroups = {}
	arg0_1.awards = {}
	arg0_1.trophy = {}
	arg0_1.trophyGroup = {}
	arg0_1.dailyEvaCount = 0

	arg0_1:on(17001, function(arg0_2)
		arg0_1.shipGroups = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.ship_info_list) do
			arg0_1.shipGroups[iter1_2.id] = ShipGroup.New(iter1_2)
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.transform_list) do
			if arg0_1.shipGroups[iter3_2] then
				arg0_1.shipGroups[iter3_2].trans = true
			end
		end

		arg0_1.awards = {}

		for iter4_2, iter5_2 in ipairs(arg0_2.ship_award_list) do
			table.sort(iter5_2.award_index)

			arg0_1.awards[iter5_2.id] = iter5_2.award_index[#iter5_2.award_index]
		end

		for iter6_2, iter7_2 in ipairs(arg0_2.progress_list) do
			arg0_1.trophy[iter7_2.id] = Trophy.New(iter7_2)
		end

		arg0_1:bindTrophyGroup()
		arg0_1:bindComplexTrophy()
		arg0_1:hiddenTrophyAutoClaim()
		arg0_1:updateTrophy()
	end)
	arg0_1:on(17002, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3.progress_list) do
			local var0_3 = false
			local var1_3 = iter1_3.id

			if arg0_1.trophy[var1_3] then
				local var2_3 = arg0_1.trophy[var1_3]
				local var3_3 = var2_3:canClaimed()

				var2_3:update(iter1_3)

				local var4_3 = var2_3:canClaimed()

				if not var2_3:isHide() and var3_3 ~= var4_3 then
					var0_3 = true
				end
			else
				arg0_1.trophy[var1_3] = Trophy.New(iter1_3)

				if arg0_1.trophy[var1_3]:canClaimed() then
					var0_3 = true
				end
			end

			if var0_3 then
				arg0_1:dispatchClaimRemind(var1_3)
			end
		end

		arg0_1:hiddenTrophyAutoClaim()
		arg0_1:updateTrophy()
	end)
	arg0_1:on(17004, function(arg0_4)
		local var0_4 = arg0_4.ship_info

		arg0_1.shipGroups[var0_4.id] = ShipGroup.New(var0_4)
	end)
end

function var0_0.resetEvaCount(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.shipGroups) do
		local var0_5 = iter1_5.evaluation

		if var0_5 then
			var0_5.ievaCount = 0
		end
	end
end

function var0_0.updateDailyEvaCount(arg0_6, arg1_6)
	arg0_6.dailyEvaCount = arg1_6
end

function var0_0.updateAward(arg0_7, arg1_7, arg2_7)
	arg0_7.awards[arg1_7] = arg2_7

	arg0_7:sendNotification(var0_0.AWARDS_UPDATE, Clone(arg0_7.awards))
end

function var0_0.getShipGroup(arg0_8, arg1_8)
	return Clone(arg0_8.shipGroups[arg1_8])
end

function var0_0.updateShipGroup(arg0_9, arg1_9)
	assert(arg1_9, "update ship group: group cannot be nil.")

	arg0_9.shipGroups[arg1_9.id] = Clone(arg1_9)
end

function var0_0.getGroups(arg0_10)
	return Clone(arg0_10.shipGroups)
end

function var0_0.RawgetGroups(arg0_11)
	return arg0_11.shipGroups
end

function var0_0.getAwards(arg0_12)
	return Clone(arg0_12.awards)
end

function var0_0.hasFinish(arg0_13)
	local var0_13 = pg.storeup_data_template

	for iter0_13, iter1_13 in ipairs(var0_13.all) do
		if Favorite.New({
			id = iter1_13
		}):canGetRes(arg0_13.shipGroups, arg0_13.awards) then
			return true
		end
	end

	return false
end

function var0_0.getCollectionRate(arg0_14)
	local var0_14 = arg0_14:getCollectionCount()
	local var1_14 = arg0_14:getCollectionTotal()

	return string.format("%0.3f", var0_14 / var1_14), var0_14, var1_14
end

function var0_0.getCollectionCount(arg0_15)
	return _.reduce(_.values(arg0_15.shipGroups), 0, function(arg0_16, arg1_16)
		return arg0_16 + (Nation.IsLinkType(arg1_16:getNation()) and 0 or arg1_16.trans and 2 or 1)
	end)
end

function var0_0.getCollectionTotal(arg0_17)
	return _.reduce(pg.ship_data_group.all, 0, function(arg0_18, arg1_18)
		local var0_18 = pg.ship_data_group[arg1_18].group_type
		local var1_18 = ShipGroup.getDefaultShipConfig(var0_18)

		return arg0_18 + (Nation.IsLinkType(var1_18.nationality) and 0 or 1)
	end) + #pg.ship_data_trans.all
end

function var0_0.getLinkCollectionCount(arg0_19)
	return _.reduce(_.values(arg0_19.shipGroups), 0, function(arg0_20, arg1_20)
		return arg0_20 + (Nation.IsLinkType(arg1_20:getNation()) and 1 or 0)
	end)
end

function var0_0.flushCollection(arg0_21, arg1_21)
	local var0_21 = arg0_21:getShipGroup(arg1_21.groupId)
	local var1_21

	if not var0_21 then
		var0_21 = ShipGroup.New({
			heart_count = 0,
			heart_flag = 0,
			lv_max = 1,
			id = arg1_21.groupId,
			star = arg1_21:getStar(),
			marry_flag = arg1_21.propose and 1 or 0,
			intimacy_max = arg1_21.intimacy
		})

		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg1_21.groupId, 1) then
			var1_21 = true
		end
	else
		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg1_21.groupId, 1) then
			if var0_21.star < arg1_21:getStar() and arg1_21:getStar() == pg.fleet_tech_ship_template[arg1_21.groupId].max_star then
				var1_21 = true

				local var2_21 = pg.fleet_tech_ship_template[arg1_21.groupId].pt_upgrage

				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
					point = var2_21
				})
			end

			if var0_21.maxLV < arg1_21.level and arg1_21.level == TechnologyConst.SHIP_LEVEL_FOR_BUFF then
				var1_21 = true

				local var3_21 = pg.fleet_tech_ship_template[arg1_21.groupId].pt_level
				local var4_21 = ShipType.FilterOverQuZhuType(pg.fleet_tech_ship_template[arg1_21.groupId].add_level_shiptype)
				local var5_21 = pg.fleet_tech_ship_template[arg1_21.groupId].add_level_attr
				local var6_21 = pg.fleet_tech_ship_template[arg1_21.groupId].add_level_value

				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
					point = var3_21,
					typeList = var4_21,
					attr = var5_21,
					value = var6_21
				})
			end
		end

		var0_21.star = math.max(var0_21.star, arg1_21:getStar())
		var0_21.maxIntimacy = math.max(var0_21.maxIntimacy, arg1_21.intimacy)
		var0_21.married = math.max(var0_21.married, arg1_21.propose and 1 or 0)
		var0_21.maxLV = math.max(var0_21.maxLV, arg1_21.level)
	end

	arg0_21:updateShipGroup(var0_21)

	if var1_21 then
		getProxy(TechnologyNationProxy):flushData()
	end
end

function var0_0.updateTrophyClaim(arg0_22, arg1_22, arg2_22)
	arg0_22.trophy[arg1_22]:updateTimeStamp(arg2_22)
end

function var0_0.unlockNewTrophy(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg1_23) do
		arg0_23.trophy[iter1_23.id] = iter1_23
	end

	arg0_23:bindTrophyGroup()
	arg0_23:bindComplexTrophy()
	arg0_23:hiddenTrophyAutoClaim()
end

function var0_0.getTrophyGroup(arg0_24)
	return Clone(arg0_24.trophyGroup)
end

function var0_0.getTrophys(arg0_25)
	local var0_25 = Clone(arg0_25.trophy)

	for iter0_25, iter1_25 in pairs(arg0_25.trophy) do
		iter1_25:clearNew()
	end

	return var0_25
end

function var0_0.hiddenTrophyAutoClaim(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.trophy) do
		if iter1_26:getHideType() ~= Trophy.ALWAYS_SHOW and iter1_26:getHideType() ~= Trophy.COMING_SOON and iter1_26:canClaimed() and not iter1_26:isClaimed() then
			arg0_26:sendNotification(GAME.TROPHY_CLAIM, {
				trophyID = iter0_26
			})
		end
	end
end

function var0_0.unclaimTrophyCount(arg0_27)
	local var0_27 = 0

	for iter0_27, iter1_27 in pairs(arg0_27.trophy) do
		if iter1_27:getHideType() == Trophy.ALWAYS_SHOW and iter1_27:canClaimed() and not iter1_27:isClaimed() then
			var0_27 = var0_27 + 1
		end
	end

	return var0_27
end

function var0_0.updateTrophy(arg0_28)
	arg0_28:sendNotification(var0_0.TROPHY_UPDATE, Clone(arg0_28.trophy))
end

function var0_0.dispatchClaimRemind(arg0_29, arg1_29)
	pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TROPHY, {
		id = arg1_29
	})
end

function var0_0.bindComplexTrophy(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.trophyGroup) do
		local var0_30 = iter1_30:getTrophyList()

		for iter2_30, iter3_30 in pairs(var0_30) do
			if iter3_30:isComplexTrophy() then
				for iter4_30, iter5_30 in ipairs(iter3_30:getTargetID()) do
					local var1_30 = arg0_30.trophy[iter5_30] or Trophy.generateDummyTrophy(iter5_30)

					iter3_30:bindTrophys(var1_30)
				end
			end
		end
	end
end

function var0_0.bindTrophyGroup(arg0_31)
	local var0_31 = pg.medal_template

	for iter0_31, iter1_31 in ipairs(var0_31.all) do
		if var0_31[iter1_31].hide == Trophy.ALWAYS_SHOW then
			local var1_31 = math.floor(iter1_31 / 10)

			if not arg0_31.trophyGroup[var1_31] then
				arg0_31.trophyGroup[var1_31] = TrophyGroup.New(var1_31)
			end

			local var2_31 = arg0_31.trophyGroup[var1_31]

			if arg0_31.trophy[iter1_31] then
				var2_31:addTrophy(arg0_31.trophy[iter1_31])
			else
				var2_31:addDummyTrophy(iter1_31)
			end
		end
	end

	for iter2_31, iter3_31 in pairs(arg0_31.trophyGroup) do
		iter3_31:sortGroup()
	end

	table.sort(arg0_31.trophyGroup, function(arg0_32, arg1_32)
		return arg0_32:getGroupID() < arg1_32:getGroupID()
	end)
end

return var0_0
