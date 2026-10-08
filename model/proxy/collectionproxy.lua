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

function var0_0.timeCall(arg0_5)
	return {
		[ProxyRegister.DayCall] = function(arg0_6)
			arg0_5:resetEvaCount()
		end
	}
end

function var0_0.resetEvaCount(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.shipGroups) do
		local var0_7 = iter1_7.evaluation

		if var0_7 then
			var0_7.ievaCount = 0
		end
	end
end

function var0_0.updateDailyEvaCount(arg0_8, arg1_8)
	arg0_8.dailyEvaCount = arg1_8
end

function var0_0.updateAward(arg0_9, arg1_9, arg2_9)
	arg0_9.awards[arg1_9] = arg2_9

	arg0_9:sendNotification(var0_0.AWARDS_UPDATE, Clone(arg0_9.awards))
end

function var0_0.getShipGroup(arg0_10, arg1_10)
	return Clone(arg0_10.shipGroups[arg1_10])
end

function var0_0.RawGetShipGroup(arg0_11, arg1_11)
	return arg0_11.shipGroups[arg1_11]
end

function var0_0.updateShipGroup(arg0_12, arg1_12)
	assert(arg1_12, "update ship group: group cannot be nil.")

	arg0_12.shipGroups[arg1_12.id] = Clone(arg1_12)
end

function var0_0.getGroups(arg0_13)
	return Clone(arg0_13.shipGroups)
end

function var0_0.RawgetGroups(arg0_14)
	return arg0_14.shipGroups
end

function var0_0.getAwards(arg0_15)
	return Clone(arg0_15.awards)
end

function var0_0.hasFinish(arg0_16)
	local var0_16 = pg.storeup_data_template

	for iter0_16, iter1_16 in ipairs(var0_16.all) do
		if Favorite.New({
			id = iter1_16
		}):canGetRes(arg0_16.shipGroups, arg0_16.awards) then
			return true
		end
	end

	return false
end

function var0_0.getCollectionRate(arg0_17)
	local var0_17 = arg0_17:getCollectionCount()
	local var1_17 = arg0_17:getCollectionTotal()

	return string.format("%0.3f", var0_17 / var1_17), var0_17, var1_17
end

function var0_0.getCollectionCount(arg0_18)
	return _.reduce(_.values(arg0_18.shipGroups), 0, function(arg0_19, arg1_19)
		return arg0_19 + (Nation.IsLinkType(arg1_19:getNation()) and 0 or arg1_19.trans and 2 or 1)
	end)
end

function var0_0.getCollectionTotal(arg0_20)
	return _.reduce(pg.ship_data_group.all, 0, function(arg0_21, arg1_21)
		local var0_21 = pg.ship_data_group[arg1_21].group_type
		local var1_21 = ShipGroup.getDefaultShipConfig(var0_21)

		return arg0_21 + (Nation.IsLinkType(var1_21.nationality) and 0 or 1)
	end) + #pg.ship_data_trans.all
end

function var0_0.getLinkCollectionCount(arg0_22)
	return _.reduce(_.values(arg0_22.shipGroups), 0, function(arg0_23, arg1_23)
		return arg0_23 + (Nation.IsLinkType(arg1_23:getNation()) and 1 or 0)
	end)
end

function var0_0.flushCollection(arg0_24, arg1_24)
	local var0_24 = arg0_24:getShipGroup(arg1_24.groupId)
	local var1_24

	if not var0_24 then
		var0_24 = ShipGroup.New({
			heart_count = 0,
			heart_flag = 0,
			lv_max = 1,
			id = arg1_24.groupId,
			star = arg1_24:getStar(),
			marry_flag = arg1_24.propose and 1 or 0,
			intimacy_max = arg1_24.intimacy
		})

		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg1_24.groupId, 1) then
			var1_24 = true
		end
	else
		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg1_24.groupId, 1) then
			if var0_24.star < arg1_24:getStar() and arg1_24:getStar() == pg.fleet_tech_ship_template[arg1_24.groupId].max_star then
				var1_24 = true

				local var2_24 = pg.fleet_tech_ship_template[arg1_24.groupId].pt_upgrage

				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
					point = var2_24
				})
			end

			if var0_24.maxLV < arg1_24.level and arg1_24.level == TechnologyConst.SHIP_LEVEL_FOR_BUFF then
				var1_24 = true

				local var3_24 = pg.fleet_tech_ship_template[arg1_24.groupId].pt_level
				local var4_24 = ShipType.FilterOverQuZhuType(pg.fleet_tech_ship_template[arg1_24.groupId].add_level_shiptype)
				local var5_24 = pg.fleet_tech_ship_template[arg1_24.groupId].add_level_attr
				local var6_24 = pg.fleet_tech_ship_template[arg1_24.groupId].add_level_value

				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
					point = var3_24,
					typeList = var4_24,
					attr = var5_24,
					value = var6_24
				})
			end
		end

		var0_24.star = math.max(var0_24.star, arg1_24:getStar())
		var0_24.maxIntimacy = math.max(var0_24.maxIntimacy, arg1_24.intimacy)
		var0_24.married = math.max(var0_24.married, arg1_24.propose and 1 or 0)
		var0_24.maxLV = math.max(var0_24.maxLV, arg1_24.level)
	end

	arg0_24:updateShipGroup(var0_24)

	if var1_24 then
		getProxy(TechnologyNationProxy):flushData()
	end
end

function var0_0.updateTrophyClaim(arg0_25, arg1_25, arg2_25)
	arg0_25.trophy[arg1_25]:updateTimeStamp(arg2_25)
end

function var0_0.unlockNewTrophy(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg1_26) do
		arg0_26.trophy[iter1_26.id] = iter1_26
	end

	arg0_26:bindTrophyGroup()
	arg0_26:bindComplexTrophy()
	arg0_26:hiddenTrophyAutoClaim()
end

function var0_0.getTrophyGroup(arg0_27)
	return Clone(arg0_27.trophyGroup)
end

function var0_0.getTrophys(arg0_28)
	local var0_28 = Clone(arg0_28.trophy)

	for iter0_28, iter1_28 in pairs(arg0_28.trophy) do
		iter1_28:clearNew()
	end

	return var0_28
end

function var0_0.GetTrophyById(arg0_29, arg1_29)
	return arg0_29.trophy[arg1_29]
end

function var0_0.hiddenTrophyAutoClaim(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.trophy) do
		if iter1_30:getHideType() ~= Trophy.ALWAYS_SHOW and iter1_30:getHideType() ~= Trophy.COMING_SOON and iter1_30:canClaimed() and not iter1_30:isClaimed() then
			arg0_30:sendNotification(GAME.TROPHY_CLAIM, {
				trophyID = iter0_30
			})
		end
	end
end

function var0_0.unclaimTrophyCount(arg0_31)
	local var0_31 = 0

	for iter0_31, iter1_31 in pairs(arg0_31.trophy) do
		if iter1_31:getHideType() == Trophy.ALWAYS_SHOW and iter1_31:canClaimed() and not iter1_31:isClaimed() then
			var0_31 = var0_31 + 1
		end
	end

	return var0_31
end

function var0_0.updateTrophy(arg0_32)
	arg0_32:sendNotification(var0_0.TROPHY_UPDATE, Clone(arg0_32.trophy))
end

function var0_0.dispatchClaimRemind(arg0_33, arg1_33)
	pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TROPHY, {
		id = arg1_33
	})
end

function var0_0.bindComplexTrophy(arg0_34)
	for iter0_34, iter1_34 in pairs(arg0_34.trophyGroup) do
		local var0_34 = iter1_34:getTrophyList()

		for iter2_34, iter3_34 in pairs(var0_34) do
			if iter3_34:isComplexTrophy() then
				for iter4_34, iter5_34 in ipairs(iter3_34:getTargetID()) do
					local var1_34 = arg0_34.trophy[iter5_34] or Trophy.generateDummyTrophy(iter5_34)

					iter3_34:bindTrophys(var1_34)
				end
			end
		end
	end
end

function var0_0.bindTrophyGroup(arg0_35)
	local var0_35 = pg.medal_template

	for iter0_35, iter1_35 in ipairs(var0_35.all) do
		if var0_35[iter1_35].hide == Trophy.ALWAYS_SHOW then
			local var1_35 = math.floor(iter1_35 / 10)

			if not arg0_35.trophyGroup[var1_35] then
				arg0_35.trophyGroup[var1_35] = TrophyGroup.New(var1_35)
			end

			local var2_35 = arg0_35.trophyGroup[var1_35]

			if arg0_35.trophy[iter1_35] then
				var2_35:addTrophy(arg0_35.trophy[iter1_35])
			else
				var2_35:addDummyTrophy(iter1_35)
			end
		end
	end

	for iter2_35, iter3_35 in pairs(arg0_35.trophyGroup) do
		iter3_35:sortGroup()
	end

	table.sort(arg0_35.trophyGroup, function(arg0_36, arg1_36)
		return arg0_36:getGroupID() < arg1_36:getGroupID()
	end)
end

return var0_0
