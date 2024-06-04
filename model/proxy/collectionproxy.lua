local var0 = class("CollectionProxy", import(".NetProxy"))

var0.AWARDS_UPDATE = "awards update"
var0.GROUP_INFO_UPDATE = "group info update"
var0.GROUP_EVALUATION_UPDATE = "group evaluation update"
var0.TROPHY_UPDATE = "trophy update"
var0.MAX_DAILY_EVA_COUNT = 1
var0.KEY_17001_TIME_STAMP = "KEY_17001_TIME_STAMP"

function var0.register(arg0)
	arg0.shipGroups = {}
	arg0.awards = {}
	arg0.trophy = {}
	arg0.trophyGroup = {}
	arg0.dailyEvaCount = 0

	arg0:on(17001, function(arg0)
		arg0.shipGroups = {}

		for iter0, iter1 in ipairs(arg0.ship_info_list) do
			arg0.shipGroups[iter1.id] = ShipGroup.New(iter1)
		end

		for iter2, iter3 in ipairs(arg0.transform_list) do
			if arg0.shipGroups[iter3] then
				arg0.shipGroups[iter3].trans = true
			end
		end

		arg0.awards = {}

		for iter4, iter5 in ipairs(arg0.ship_award_list) do
			table.sort(iter5.award_index)

			arg0.awards[iter5.id] = iter5.award_index[#iter5.award_index]
		end

		for iter6, iter7 in ipairs(arg0.progress_list) do
			arg0.trophy[iter7.id] = Trophy.New(iter7)
		end

		arg0:bindTrophyGroup()
		arg0:bindComplexTrophy()
		arg0:hiddenTrophyAutoClaim()
		arg0:updateTrophy()
	end)
	arg0:on(17002, function(arg0)
		for iter0, iter1 in ipairs(arg0.progress_list) do
			local var0 = false
			local var1 = iter1.id

			if arg0.trophy[var1] then
				local var2 = arg0.trophy[var1]
				local var3 = var2:canClaimed()

				var2:update(iter1)

				local var4 = var2:canClaimed()

				if not var2:isHide() and var3 ~= var4 then
					var0 = true
				end
			else
				arg0.trophy[var1] = Trophy.New(iter1)

				if arg0.trophy[var1]:canClaimed() then
					var0 = true
				end
			end

			if var0 then
				arg0:dispatchClaimRemind(var1)
			end
		end

		arg0:hiddenTrophyAutoClaim()
		arg0:updateTrophy()
	end)
	arg0:on(17004, function(arg0)
		local var0 = arg0.ship_info

		arg0.shipGroups[var0.id] = ShipGroup.New(var0)
	end)
end

function var0.resetEvaCount(arg0)
	for iter0, iter1 in pairs(arg0.shipGroups) do
		local var0 = iter1.evaluation

		if var0 then
			var0.ievaCount = 0
		end
	end
end

function var0.updateDailyEvaCount(arg0, arg1)
	arg0.dailyEvaCount = arg1
end

function var0.updateAward(arg0, arg1, arg2)
	arg0.awards[arg1] = arg2

	arg0:sendNotification(var0.AWARDS_UPDATE, Clone(arg0.awards))
end

function var0.getShipGroup(arg0, arg1)
	return Clone(arg0.shipGroups[arg1])
end

function var0.updateShipGroup(arg0, arg1)
	assert(arg1, "update ship group: group cannot be nil.")

	arg0.shipGroups[arg1.id] = Clone(arg1)
end

function var0.getGroups(arg0)
	return Clone(arg0.shipGroups)
end

function var0.RawgetGroups(arg0)
	return arg0.shipGroups
end

function var0.getAwards(arg0)
	return Clone(arg0.awards)
end

function var0.hasFinish(arg0)
	local var0 = pg.storeup_data_template

	for iter0, iter1 in ipairs(var0.all) do
		if Favorite.New({
			id = iter1
		}):canGetRes(arg0.shipGroups, arg0.awards) then
			return true
		end
	end

	return false
end

function var0.getCollectionRate(arg0)
	local var0 = arg0:getCollectionCount()
	local var1 = arg0:getCollectionTotal()

	return string.format("%0.3f", var0 / var1), var0, var1
end

function var0.getCollectionCount(arg0)
	return _.reduce(_.values(arg0.shipGroups), 0, function(arg0, arg1)
		return arg0 + (Nation.IsLinkType(arg1:getNation()) and 0 or arg1.trans and 2 or 1)
	end)
end

function var0.getCollectionTotal(arg0)
	return _.reduce(pg.ship_data_group.all, 0, function(arg0, arg1)
		local var0 = pg.ship_data_group[arg1].group_type
		local var1 = ShipGroup.getDefaultShipConfig(var0)

		return arg0 + (Nation.IsLinkType(var1.nationality) and 0 or 1)
	end) + #pg.ship_data_trans.all
end

function var0.getLinkCollectionCount(arg0)
	return _.reduce(_.values(arg0.shipGroups), 0, function(arg0, arg1)
		return arg0 + (Nation.IsLinkType(arg1:getNation()) and 1 or 0)
	end)
end

function var0.flushCollection(arg0, arg1)
	local var0 = arg0:getShipGroup(arg1.groupId)
	local var1

	if not var0 then
		var0 = ShipGroup.New({
			heart_count = 0,
			heart_flag = 0,
			lv_max = 1,
			id = arg1.groupId,
			star = arg1:getStar(),
			marry_flag = arg1.propose and 1 or 0,
			intimacy_max = arg1.intimacy
		})

		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg1.groupId, 1) then
			var1 = true
		end
	else
		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg1.groupId, 1) then
			if var0.star < arg1:getStar() and arg1:getStar() == pg.fleet_tech_ship_template[arg1.groupId].max_star then
				var1 = true

				local var2 = pg.fleet_tech_ship_template[arg1.groupId].pt_upgrage

				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
					point = var2
				})
			end

			if var0.maxLV < arg1.level and arg1.level == TechnologyConst.SHIP_LEVEL_FOR_BUFF then
				var1 = true

				local var3 = pg.fleet_tech_ship_template[arg1.groupId].pt_level
				local var4 = ShipType.FilterOverQuZhuType(pg.fleet_tech_ship_template[arg1.groupId].add_level_shiptype)
				local var5 = pg.fleet_tech_ship_template[arg1.groupId].add_level_attr
				local var6 = pg.fleet_tech_ship_template[arg1.groupId].add_level_value

				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
					point = var3,
					typeList = var4,
					attr = var5,
					value = var6
				})
			end
		end

		var0.star = math.max(var0.star, arg1:getStar())
		var0.maxIntimacy = math.max(var0.maxIntimacy, arg1.intimacy)
		var0.married = math.max(var0.married, arg1.propose and 1 or 0)
		var0.maxLV = math.max(var0.maxLV, arg1.level)
	end

	arg0:updateShipGroup(var0)

	if var1 then
		getProxy(TechnologyNationProxy):flushData()
	end
end

function var0.updateTrophyClaim(arg0, arg1, arg2)
	arg0.trophy[arg1]:updateTimeStamp(arg2)
end

function var0.unlockNewTrophy(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0.trophy[iter1.id] = iter1
	end

	arg0:bindTrophyGroup()
	arg0:bindComplexTrophy()
	arg0:hiddenTrophyAutoClaim()
end

function var0.getTrophyGroup(arg0)
	return Clone(arg0.trophyGroup)
end

function var0.getTrophys(arg0)
	local var0 = Clone(arg0.trophy)

	for iter0, iter1 in pairs(arg0.trophy) do
		iter1:clearNew()
	end

	return var0
end

function var0.hiddenTrophyAutoClaim(arg0)
	for iter0, iter1 in pairs(arg0.trophy) do
		if iter1:getHideType() ~= Trophy.ALWAYS_SHOW and iter1:getHideType() ~= Trophy.COMING_SOON and iter1:canClaimed() and not iter1:isClaimed() then
			arg0:sendNotification(GAME.TROPHY_CLAIM, {
				trophyID = iter0
			})
		end
	end
end

function var0.unclaimTrophyCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.trophy) do
		if iter1:getHideType() == Trophy.ALWAYS_SHOW and iter1:canClaimed() and not iter1:isClaimed() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.updateTrophy(arg0)
	arg0:sendNotification(var0.TROPHY_UPDATE, Clone(arg0.trophy))
end

function var0.dispatchClaimRemind(arg0, arg1)
	pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TROPHY, {
		id = arg1
	})
end

function var0.bindComplexTrophy(arg0)
	for iter0, iter1 in pairs(arg0.trophyGroup) do
		local var0 = iter1:getTrophyList()

		for iter2, iter3 in pairs(var0) do
			if iter3:isComplexTrophy() then
				for iter4, iter5 in ipairs(iter3:getTargetID()) do
					local var1 = arg0.trophy[iter5] or Trophy.generateDummyTrophy(iter5)

					iter3:bindTrophys(var1)
				end
			end
		end
	end
end

function var0.bindTrophyGroup(arg0)
	local var0 = pg.medal_template

	for iter0, iter1 in ipairs(var0.all) do
		if var0[iter1].hide == Trophy.ALWAYS_SHOW then
			local var1 = math.floor(iter1 / 10)

			if not arg0.trophyGroup[var1] then
				arg0.trophyGroup[var1] = TrophyGroup.New(var1)
			end

			local var2 = arg0.trophyGroup[var1]

			if arg0.trophy[iter1] then
				var2:addTrophy(arg0.trophy[iter1])
			else
				var2:addDummyTrophy(iter1)
			end
		end
	end

	for iter2, iter3 in pairs(arg0.trophyGroup) do
		iter3:sortGroup()
	end

	table.sort(arg0.trophyGroup, function(arg0, arg1)
		return arg0:getGroupID() < arg1:getGroupID()
	end)
end

return var0
