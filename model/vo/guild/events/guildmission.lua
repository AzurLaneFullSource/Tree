local var0 = class("GuildMission", import("...BaseVO"))

function var0.CompleteData2FullData(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return {
		efficiency = 0,
		server_finish = true,
		event_id = arg0.event_id,
		position = arg0.position,
		join_number = arg0.join_number,
		start_time = var0,
		complete_time = var0 - 10,
		shipinevent = {},
		attr_acc_list = {},
		attr_count_list = {},
		eventnodes = {},
		personship = {}
	}
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.event_id
	arg0.configId = arg0.id
	arg0.position = arg1.position
	arg0.serverFinish = arg1.server_finish
	arg0.myFleets = {}
	arg0.myShips = {}
	arg0.nodeAnimPosistion = 0
	arg0.formationTime = 0
	arg0.nations = {}

	local var0 = arg0:getConfig("ship_camp_effect")

	for iter0, iter1 in ipairs(var0) do
		if not table.contains(arg0.nations, iter1[1]) then
			table.insert(arg0.nations, iter1[1])
		end
	end

	arg0.shiptypes = {}

	local var1 = arg0:getConfig("ship_type_effect")

	for iter2, iter3 in ipairs(var1) do
		table.insert(arg0.shiptypes, iter3[1])
	end

	arg0:Flush(arg1, 0)

	arg0.formationTipIndex = PlayerPrefs.GetInt("guild_mission_formation_tip" .. arg0.configId, 0)
end

function var0.Flush(arg0, arg1, arg2)
	arg0.nextRefreshTime = arg2 + pg.TimeMgr.GetInstance():GetServerTime()
	arg0.startTime = arg1.start_time
	arg0.finishTime = arg1.complete_time
	arg0.efficiency = arg1.efficiency or 0
	arg0.totalTimeCost = arg0.finishTime - arg0.startTime
	arg0.ships = {}

	for iter0, iter1 in ipairs(arg1.shipinevent) do
		local var0 = {
			userId = iter1.user_id,
			shipId = iter1.ship_id,
			configId = iter1.template_id,
			skin = iter1.skin
		}

		table.insert(arg0.ships, var0)
	end

	local var1 = {}

	for iter2, iter3 in ipairs(arg1.personship or {}) do
		var1[iter3.page_id] = {}

		for iter4, iter5 in ipairs(iter3.ship_ids) do
			table.insert(var1[iter3.page_id], iter5)
		end
	end

	arg0:UpdateMyFleets(var1)

	arg0.attrAccList = {}

	local var2 = {}

	for iter6, iter7 in ipairs(arg1.attr_acc_list) do
		var2[iter7.key] = iter7.value
	end

	local var3 = arg0:getConfig("event_attr_acc_effect")

	for iter8, iter9 in ipairs(var3) do
		local var4 = var2[iter9[1]] or 0

		arg0.attrAccList[iter9[1]] = {
			value = var4,
			op = iter9[2],
			goal = iter9[3],
			score = iter9[4]
		}
	end

	arg0.attrCntList = {}

	local var5 = {}

	for iter10, iter11 in ipairs(arg1.attr_count_list) do
		var5[iter11.key] = iter11.value
	end

	local var6 = arg0:getConfig("event_attr_count_effect")

	for iter12, iter13 in ipairs(var6) do
		local var7 = var5[iter13[1]] or 0

		arg0.attrCntList[iter13[1]] = {
			value = var7,
			total = iter13[2],
			goal = iter13[3],
			score = iter13[4]
		}
	end

	arg0.nodes = {}
	arg0.nodeLogs = {}

	for iter14, iter15 in ipairs(arg1.eventnodes) do
		local var8 = GuildMissionNode.New(iter15)

		table.insert(arg0.nodes, var8)

		local var9 = var8:GetLog()

		if var9 then
			table.insert(arg0.nodeLogs, var9)
		end
	end
end

function var0.IsFinishedByServer(arg0)
	return arg0.serverFinish
end

function var0.GetTotalTimeCost(arg0)
	return arg0.totalTimeCost
end

function var0.GetStartTime(arg0)
	return arg0.startTime
end

function var0.GetRemainingTime(arg0)
	return arg0:GetTotalTimeCost() - (pg.TimeMgr.GetInstance():GetServerTime() - arg0:GetStartTime())
end

function var0.IsBoss(arg0)
	return false
end

function var0.UpdateNodeAnimFlagIndex(arg0, arg1)
	arg0.nodeAnimPosistion = arg1
end

function var0.GetNodeAnimPosistion(arg0)
	return arg0.nodeAnimPosistion
end

function var0.GetNewestSuccessNode(arg0)
	for iter0 = #arg0.nodes, 1, -1 do
		local var0 = arg0.nodes[iter0]

		if var0:IsSuccess() then
			return var0
		end
	end
end

function var0.UpdateFormationTime(arg0, arg1)
	arg0.formationTime = arg1 or 0
end

function var0.CanFormation(arg0)
	if table.getCount(arg0.myFleets) == GuildConst.MISSION_MAX_FLEET_CNT then
		return false
	end

	if arg0.formationTime == 0 then
		return true
	end

	local var0 = arg0:GetNextFormationTime() - pg.TimeMgr.GetInstance():GetServerTime()

	return var0 <= 0, var0
end

function var0.GetNextFormationTime(arg0)
	local var0 = arg0.formationTime
	local var1 = GetZeroTime()
	local var2 = GetZeroTime() - 86400
	local var3 = pg.guildset.operation_member_dispatch_reset.key_args
	local var4 = _.map(var3, function(arg0)
		return var2 + arg0 * 3600
	end)
	local var5 = _.detect(var4, function(arg0)
		return arg0 > var0
	end)

	if var5 then
		if var0 < var2 - 86400 + var3[4] * 3600 then
			return pg.TimeMgr.GetInstance():GetServerTime()
		else
			return var5
		end
	else
		return var1 + var3[1] * 3600
	end
end

function var0.UpdateMyFleets(arg0, arg1)
	arg0.myFleets = arg1
	arg0.myShips = {}

	for iter0, iter1 in pairs(arg0.myFleets) do
		for iter2, iter3 in ipairs(iter1) do
			table.insert(arg0.myShips, iter3)
		end
	end
end

function var0.UpdateFleet(arg0, arg1, arg2)
	arg0.myFleets[arg1] = {}

	for iter0, iter1 in ipairs(arg2) do
		table.insert(arg0.myFleets[arg1], iter1)
		table.insert(arg0.myShips, iter1)
	end
end

function var0.GetFleetByIndex(arg0, arg1)
	return arg0.myFleets[arg1]
end

function var0.GetMaxFleet(arg0)
	return arg0:GetFleetCnt() + (arg0:CanFormation() and 1 or 0)
end

function var0.GetFleetCnt(arg0)
	return table.getCount(arg0.myFleets)
end

function var0.IsMaxFleetCnt(arg0)
	return arg0:GetFleetCnt() == GuildConst.MISSION_MAX_FLEET_CNT
end

function var0.GetCanFormationIndex(arg0)
	if arg0:CanFormation() then
		return table.getCount(arg0.myFleets) + 1
	end

	return -1
end

function var0.ShouldRefresh(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0.nextRefreshTime
end

function var0.bindConfigTable(arg0)
	return pg.guild_base_event
end

function var0.GetPosition(arg0)
	return arg0.position
end

function var0.GetIcon(arg0)
	return arg0:getConfig("pic")
end

function var0.GetSubType(arg0)
	return arg0:getConfig("sub_type")
end

function var0.IsMain(arg0)
	return arg0:GetSubType() == 1
end

function var0.IsFinish(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0.finishTime > 0 and var0 >= arg0.finishTime
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetTag(arg0)
	return arg0:getConfig("type")
end

function var0.IsActive(arg0)
	return true
end

function var0.IsEliteType(arg0)
	return arg0:getConfig("type") == 2
end

function var0.GetJoinMemberCnt(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.ships) do
		if not table.contains(var0, iter1.userId) then
			table.insert(var0, iter1.userId)
		end
	end

	return #var0
end

function var0.GetEfficiency(arg0)
	return arg0.efficiency
end

function var0.GetShipsByNation(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.ships) do
		if arg1 == pg.ship_data_statistics[iter1.configId].nationality then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetNations(arg0)
	return arg0.nations
end

function var0.GetAttrAcc(arg0)
	return arg0.attrAccList
end

function var0.GetAttrCntAcc(arg0)
	return arg0.attrCntList
end

function var0.GetNodes(arg0)
	return arg0.nodes
end

function var0.GetProgress(arg0)
	local var0 = arg0:GetTotalTimeCost()

	if var0 > 0 then
		local var1 = arg0:GetStartTime()

		return (pg.TimeMgr.GetInstance():GetServerTime() - var1) / var0
	else
		return 0
	end
end

function var0.GetMyFlagShip(arg0)
	return arg0.myShips[1]
end

function var0.GetLogs(arg0)
	local var0 = arg0:GetMyFlagShip()

	if var0 then
		local var1 = getProxy(BayProxy):getShipById(var0)

		do return _.map(arg0.nodeLogs, function(arg0)
			return string.gsub(arg0, "$2", "<color=#92FC63FF>" .. var1:getName() .. "</color>")
		end) end
		return
	end

	return {}
end

function var0.GetMyShips(arg0)
	return arg0.myShips
end

function var0.GetBattleShipType(arg0)
	return arg0:getConfig("ship_type_display")
end

function var0.GetAwards(arg0)
	return arg0:getConfig("award_list")
end

function var0.CalcMyEffect(arg0)
	if not arg0 or #arg0 == 0 then
		return 0
	end

	local var0 = getProxy(BayProxy)
	local var1 = 0
	local var2 = 0

	for iter0, iter1 in ipairs(arg0) do
		local var3 = var0:getShipById(iter1)

		if var3 then
			var1 = var3.level + var1
			var2 = var2 + var3:getShipCombatPower({})
		end
	end

	return math.floor((20 + math.pow(var1, 0.7)) * (1 + var2 / (var2 + 12500)))
end

function var0.GetMyEffect(arg0)
	return var0.CalcMyEffect(arg0.myShips)
end

function var0.GetRecommendShipTypes(arg0)
	return arg0.shiptypes
end

function var0.GetRecommendShipNation(arg0)
	return arg0.nations
end

function var0.GetSquadron(arg0)
	return arg0:getConfig("extra_squadron")
end

function var0.GetSquadronDisplay(arg0)
	return arg0:getConfig("extra_squadron_display")
end

function var0.GetSquadronTargetCnt(arg0)
	return arg0:getConfig("extra_squadron_num")
end

function var0.GetSquadronRatio(arg0)
	return arg0:getConfig("extra_squedron_ratio") / 100
end

function var0.GetOtherShips(arg0)
	local var0 = getProxy(GuildProxy):getRawData()
	local var1 = {}

	for iter0, iter1 in pairs(arg0.ships) do
		local var2 = var0:getMemberById(iter1.userId)

		if var2 then
			local var3 = iter1.skin

			if var3 == 0 then
				var3 = pg.ship_data_statistics[iter1.configId].skin_id
			end

			table.insert(var1, {
				id = iter1.configId,
				skin = var3,
				name = var2 and var2.name or ""
			})
		end
	end

	return var1
end

function var0.RecordFormationTip(arg0)
	local var0 = arg0:GetCanFormationIndex()

	if var0 > 0 then
		PlayerPrefs.SetInt("guild_mission_formation_tip" .. arg0.configId, var0)
	end
end

function var0.ShouldShowFormationTip(arg0)
	return arg0.formationTipIndex < arg0:GetCanFormationIndex()
end

function var0.FirstFleetCanFormation(arg0)
	return arg0:GetFleetCnt() == 0
end

function var0.SameSquadron(arg0, arg1)
	if arg0:IsEliteType() then
		return table.contains(arg1.tagList, arg0:getConfig("extra_squadron"))
	end

	return false
end

function var0.GetEffectAttr(arg0)
	local var0 = arg0:getConfig("event_attr_count_effect")
	local var1 = arg0:getConfig("event_attr_acc_effect")
	local var2
	local var3

	if #var0 > 0 then
		var2 = var0[1][1]
		var3 = var0[1][2]
	end

	if #var1 > 0 then
		var2 = var1[1][1]
	end

	local var4 = pg.attribute_info_by_type

	return var4[var2] and var4[var2].name, var3
end

function var0.MatchAttr(arg0, arg1)
	if arg0:IsEliteType() then
		local var0, var1 = arg0:GetEffectAttr()
		local var2 = arg1.attrs[var0] or 0

		if var1 then
			return var1 <= var2
		else
			return var2 > 0
		end
	end

	return false
end

function var0.MatchNation(arg0, arg1)
	if arg0:IsEliteType() then
		local var0 = arg0:GetRecommendShipNation()

		return table.contains(var0, arg1.nation)
	end

	return false
end

function var0.MatchShipType(arg0, arg1)
	if arg0:IsEliteType() then
		local var0 = arg0:GetRecommendShipTypes()

		return table.contains(var0, arg1.type)
	end

	return false
end

return var0
