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

function var0_0.updateShipGroup(arg0_11, arg1_11)
	assert(arg1_11, "update ship group: group cannot be nil.")

	arg0_11.shipGroups[arg1_11.id] = Clone(arg1_11)
end

function var0_0.getGroups(arg0_12)
	return Clone(arg0_12.shipGroups)
end

function var0_0.RawgetGroups(arg0_13)
	return arg0_13.shipGroups
end

function var0_0.getAwards(arg0_14)
	return Clone(arg0_14.awards)
end

function var0_0.hasFinish(arg0_15)
	local var0_15 = pg.storeup_data_template

	for iter0_15, iter1_15 in ipairs(var0_15.all) do
		if Favorite.New({
			id = iter1_15
		}):canGetRes(arg0_15.shipGroups, arg0_15.awards) then
			return true
		end
	end

	return false
end

function var0_0.getCollectionRate(arg0_16)
	local var0_16 = arg0_16:getCollectionCount()
	local var1_16 = arg0_16:getCollectionTotal()

	return string.format("%0.3f", var0_16 / var1_16), var0_16, var1_16
end

function var0_0.getCollectionCount(arg0_17)
	return _.reduce(_.values(arg0_17.shipGroups), 0, function(arg0_18, arg1_18)
		return arg0_18 + (Nation.IsLinkType(arg1_18:getNation()) and 0 or arg1_18.trans and 2 or 1)
	end)
end

function var0_0.getCollectionTotal(arg0_19)
	return _.reduce(pg.ship_data_group.all, 0, function(arg0_20, arg1_20)
		local var0_20 = pg.ship_data_group[arg1_20].group_type
		local var1_20 = ShipGroup.getDefaultShipConfig(var0_20)

		return arg0_20 + (Nation.IsLinkType(var1_20.nationality) and 0 or 1)
	end) + #pg.ship_data_trans.all
end

function var0_0.getLinkCollectionCount(arg0_21)
	return _.reduce(_.values(arg0_21.shipGroups), 0, function(arg0_22, arg1_22)
		return arg0_22 + (Nation.IsLinkType(arg1_22:getNation()) and 1 or 0)
	end)
end

function var0_0.flushCollection(arg0_23, arg1_23)
	local var0_23 = arg0_23:getShipGroup(arg1_23.groupId)
	local var1_23

	if not var0_23 then
		var0_23 = ShipGroup.New({
			heart_count = 0,
			heart_flag = 0,
			lv_max = 1,
			id = arg1_23.groupId,
			star = arg1_23:getStar(),
			marry_flag = arg1_23.propose and 1 or 0,
			intimacy_max = arg1_23.intimacy
		})

		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg1_23.groupId, 1) then
			var1_23 = true
		end
	else
		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg1_23.groupId, 1) then
			if var0_23.star < arg1_23:getStar() and arg1_23:getStar() == pg.fleet_tech_ship_template[arg1_23.groupId].max_star then
				var1_23 = true

				local var2_23 = pg.fleet_tech_ship_template[arg1_23.groupId].pt_upgrage

				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
					point = var2_23
				})
			end

			if var0_23.maxLV < arg1_23.level and arg1_23.level == TechnologyConst.SHIP_LEVEL_FOR_BUFF then
				var1_23 = true

				local var3_23 = pg.fleet_tech_ship_template[arg1_23.groupId].pt_level
				local var4_23 = ShipType.FilterOverQuZhuType(pg.fleet_tech_ship_template[arg1_23.groupId].add_level_shiptype)
				local var5_23 = pg.fleet_tech_ship_template[arg1_23.groupId].add_level_attr
				local var6_23 = pg.fleet_tech_ship_template[arg1_23.groupId].add_level_value

				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
					point = var3_23,
					typeList = var4_23,
					attr = var5_23,
					value = var6_23
				})
			end
		end

		var0_23.star = math.max(var0_23.star, arg1_23:getStar())
		var0_23.maxIntimacy = math.max(var0_23.maxIntimacy, arg1_23.intimacy)
		var0_23.married = math.max(var0_23.married, arg1_23.propose and 1 or 0)
		var0_23.maxLV = math.max(var0_23.maxLV, arg1_23.level)
	end

	arg0_23:updateShipGroup(var0_23)

	if var1_23 then
		getProxy(TechnologyNationProxy):flushData()
	end
end

function var0_0.updateTrophyClaim(arg0_24, arg1_24, arg2_24)
	arg0_24.trophy[arg1_24]:updateTimeStamp(arg2_24)
end

function var0_0.unlockNewTrophy(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg1_25) do
		arg0_25.trophy[iter1_25.id] = iter1_25
	end

	arg0_25:bindTrophyGroup()
	arg0_25:bindComplexTrophy()
	arg0_25:hiddenTrophyAutoClaim()
end

function var0_0.getTrophyGroup(arg0_26)
	return Clone(arg0_26.trophyGroup)
end

function var0_0.getTrophys(arg0_27)
	local var0_27 = Clone(arg0_27.trophy)

	for iter0_27, iter1_27 in pairs(arg0_27.trophy) do
		iter1_27:clearNew()
	end

	return var0_27
end

function var0_0.hiddenTrophyAutoClaim(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.trophy) do
		if iter1_28:getHideType() ~= Trophy.ALWAYS_SHOW and iter1_28:getHideType() ~= Trophy.COMING_SOON and iter1_28:canClaimed() and not iter1_28:isClaimed() then
			arg0_28:sendNotification(GAME.TROPHY_CLAIM, {
				trophyID = iter0_28
			})
		end
	end
end

function var0_0.unclaimTrophyCount(arg0_29)
	local var0_29 = 0

	for iter0_29, iter1_29 in pairs(arg0_29.trophy) do
		if iter1_29:getHideType() == Trophy.ALWAYS_SHOW and iter1_29:canClaimed() and not iter1_29:isClaimed() then
			var0_29 = var0_29 + 1
		end
	end

	return var0_29
end

function var0_0.updateTrophy(arg0_30)
	arg0_30:sendNotification(var0_0.TROPHY_UPDATE, Clone(arg0_30.trophy))
end

function var0_0.dispatchClaimRemind(arg0_31, arg1_31)
	pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TROPHY, {
		id = arg1_31
	})
end

function var0_0.bindComplexTrophy(arg0_32)
	for iter0_32, iter1_32 in pairs(arg0_32.trophyGroup) do
		local var0_32 = iter1_32:getTrophyList()

		for iter2_32, iter3_32 in pairs(var0_32) do
			if iter3_32:isComplexTrophy() then
				for iter4_32, iter5_32 in ipairs(iter3_32:getTargetID()) do
					local var1_32 = arg0_32.trophy[iter5_32] or Trophy.generateDummyTrophy(iter5_32)

					iter3_32:bindTrophys(var1_32)
				end
			end
		end
	end
end

function var0_0.bindTrophyGroup(arg0_33)
	local var0_33 = pg.medal_template

	for iter0_33, iter1_33 in ipairs(var0_33.all) do
		if var0_33[iter1_33].hide == Trophy.ALWAYS_SHOW then
			local var1_33 = math.floor(iter1_33 / 10)

			if not arg0_33.trophyGroup[var1_33] then
				arg0_33.trophyGroup[var1_33] = TrophyGroup.New(var1_33)
			end

			local var2_33 = arg0_33.trophyGroup[var1_33]

			if arg0_33.trophy[iter1_33] then
				var2_33:addTrophy(arg0_33.trophy[iter1_33])
			else
				var2_33:addDummyTrophy(iter1_33)
			end
		end
	end

	for iter2_33, iter3_33 in pairs(arg0_33.trophyGroup) do
		iter3_33:sortGroup()
	end

	table.sort(arg0_33.trophyGroup, function(arg0_34, arg1_34)
		return arg0_34:getGroupID() < arg1_34:getGroupID()
	end)
end

return var0_0
