local var0_0 = class("GuildMission", import("...BaseVO"))

function var0_0.CompleteData2FullData(arg0_1)
	local var0_1 = pg.TimeMgr.GetInstance():GetServerTime()

	return {
		efficiency = 0,
		server_finish = true,
		event_id = arg0_1.event_id,
		position = arg0_1.position,
		join_number = arg0_1.join_number,
		start_time = var0_1,
		complete_time = var0_1 - 10,
		shipinevent = {},
		attr_acc_list = {},
		attr_count_list = {},
		eventnodes = {},
		personship = {}
	}
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.event_id
	arg0_2.configId = arg0_2.id
	arg0_2.position = arg1_2.position
	arg0_2.serverFinish = arg1_2.server_finish
	arg0_2.myFleets = {}
	arg0_2.myShips = {}
	arg0_2.nodeAnimPosistion = 0
	arg0_2.formationTime = 0
	arg0_2.nations = {}

	local var0_2 = arg0_2:getConfig("ship_camp_effect")

	for iter0_2, iter1_2 in ipairs(var0_2) do
		if not table.contains(arg0_2.nations, iter1_2[1]) then
			table.insert(arg0_2.nations, iter1_2[1])
		end
	end

	arg0_2.shiptypes = {}

	local var1_2 = arg0_2:getConfig("ship_type_effect")

	for iter2_2, iter3_2 in ipairs(var1_2) do
		table.insert(arg0_2.shiptypes, iter3_2[1])
	end

	arg0_2:Flush(arg1_2, 0)

	arg0_2.formationTipIndex = PlayerPrefs.GetInt("guild_mission_formation_tip" .. arg0_2.configId, 0)
end

function var0_0.Flush(arg0_3, arg1_3, arg2_3)
	arg0_3.nextRefreshTime = arg2_3 + pg.TimeMgr.GetInstance():GetServerTime()
	arg0_3.startTime = arg1_3.start_time
	arg0_3.finishTime = arg1_3.complete_time
	arg0_3.efficiency = arg1_3.efficiency or 0
	arg0_3.totalTimeCost = arg0_3.finishTime - arg0_3.startTime
	arg0_3.ships = {}

	for iter0_3, iter1_3 in ipairs(arg1_3.shipinevent) do
		local var0_3 = {
			userId = iter1_3.user_id,
			shipId = iter1_3.ship_id,
			configId = iter1_3.template_id,
			skin = iter1_3.skin
		}

		table.insert(arg0_3.ships, var0_3)
	end

	local var1_3 = {}

	for iter2_3, iter3_3 in ipairs(arg1_3.personship or {}) do
		var1_3[iter3_3.page_id] = {}

		for iter4_3, iter5_3 in ipairs(iter3_3.ship_ids) do
			table.insert(var1_3[iter3_3.page_id], iter5_3)
		end
	end

	arg0_3:UpdateMyFleets(var1_3)

	arg0_3.attrAccList = {}

	local var2_3 = {}

	for iter6_3, iter7_3 in ipairs(arg1_3.attr_acc_list) do
		var2_3[iter7_3.key] = iter7_3.value
	end

	local var3_3 = arg0_3:getConfig("event_attr_acc_effect")

	for iter8_3, iter9_3 in ipairs(var3_3) do
		local var4_3 = var2_3[iter9_3[1]] or 0

		arg0_3.attrAccList[iter9_3[1]] = {
			value = var4_3,
			op = iter9_3[2],
			goal = iter9_3[3],
			score = iter9_3[4]
		}
	end

	arg0_3.attrCntList = {}

	local var5_3 = {}

	for iter10_3, iter11_3 in ipairs(arg1_3.attr_count_list) do
		var5_3[iter11_3.key] = iter11_3.value
	end

	local var6_3 = arg0_3:getConfig("event_attr_count_effect")

	for iter12_3, iter13_3 in ipairs(var6_3) do
		local var7_3 = var5_3[iter13_3[1]] or 0

		arg0_3.attrCntList[iter13_3[1]] = {
			value = var7_3,
			total = iter13_3[2],
			goal = iter13_3[3],
			score = iter13_3[4]
		}
	end

	arg0_3.nodes = {}
	arg0_3.nodeLogs = {}

	for iter14_3, iter15_3 in ipairs(arg1_3.eventnodes) do
		local var8_3 = GuildMissionNode.New(iter15_3)

		table.insert(arg0_3.nodes, var8_3)

		local var9_3 = var8_3:GetLog()

		if var9_3 then
			table.insert(arg0_3.nodeLogs, var9_3)
		end
	end
end

function var0_0.IsFinishedByServer(arg0_4)
	return arg0_4.serverFinish
end

function var0_0.GetTotalTimeCost(arg0_5)
	return arg0_5.totalTimeCost
end

function var0_0.GetStartTime(arg0_6)
	return arg0_6.startTime
end

function var0_0.GetRemainingTime(arg0_7)
	return arg0_7:GetTotalTimeCost() - (pg.TimeMgr.GetInstance():GetServerTime() - arg0_7:GetStartTime())
end

function var0_0.IsBoss(arg0_8)
	return false
end

function var0_0.UpdateNodeAnimFlagIndex(arg0_9, arg1_9)
	arg0_9.nodeAnimPosistion = arg1_9
end

function var0_0.GetNodeAnimPosistion(arg0_10)
	return arg0_10.nodeAnimPosistion
end

function var0_0.GetNewestSuccessNode(arg0_11)
	for iter0_11 = #arg0_11.nodes, 1, -1 do
		local var0_11 = arg0_11.nodes[iter0_11]

		if var0_11:IsSuccess() then
			return var0_11
		end
	end
end

function var0_0.UpdateFormationTime(arg0_12, arg1_12)
	arg0_12.formationTime = arg1_12 or 0
end

function var0_0.CanFormation(arg0_13)
	if table.getCount(arg0_13.myFleets) == GuildConst.MISSION_MAX_FLEET_CNT then
		return false
	end

	if arg0_13.formationTime == 0 then
		return true
	end

	local var0_13 = arg0_13:GetNextFormationTime() - pg.TimeMgr.GetInstance():GetServerTime()

	return var0_13 <= 0, var0_13
end

function var0_0.GetNextFormationTime(arg0_14)
	local var0_14 = arg0_14.formationTime
	local var1_14 = GetZeroTime()
	local var2_14 = GetZeroTime() - 86400
	local var3_14 = pg.guildset.operation_member_dispatch_reset.key_args
	local var4_14 = _.map(var3_14, function(arg0_15)
		return var2_14 + arg0_15 * 3600
	end)
	local var5_14 = _.detect(var4_14, function(arg0_16)
		return arg0_16 > var0_14
	end)

	if var5_14 then
		if var0_14 < var2_14 - 86400 + var3_14[4] * 3600 then
			return pg.TimeMgr.GetInstance():GetServerTime()
		else
			return var5_14
		end
	else
		return var1_14 + var3_14[1] * 3600
	end
end

function var0_0.UpdateMyFleets(arg0_17, arg1_17)
	arg0_17.myFleets = arg1_17
	arg0_17.myShips = {}

	for iter0_17, iter1_17 in pairs(arg0_17.myFleets) do
		for iter2_17, iter3_17 in ipairs(iter1_17) do
			table.insert(arg0_17.myShips, iter3_17)
		end
	end
end

function var0_0.UpdateFleet(arg0_18, arg1_18, arg2_18)
	arg0_18.myFleets[arg1_18] = {}

	for iter0_18, iter1_18 in ipairs(arg2_18) do
		table.insert(arg0_18.myFleets[arg1_18], iter1_18)
		table.insert(arg0_18.myShips, iter1_18)
	end
end

function var0_0.GetFleetByIndex(arg0_19, arg1_19)
	return arg0_19.myFleets[arg1_19]
end

function var0_0.GetMaxFleet(arg0_20)
	return arg0_20:GetFleetCnt() + (arg0_20:CanFormation() and 1 or 0)
end

function var0_0.GetFleetCnt(arg0_21)
	return table.getCount(arg0_21.myFleets)
end

function var0_0.IsMaxFleetCnt(arg0_22)
	return arg0_22:GetFleetCnt() == GuildConst.MISSION_MAX_FLEET_CNT
end

function var0_0.GetCanFormationIndex(arg0_23)
	if arg0_23:CanFormation() then
		return table.getCount(arg0_23.myFleets) + 1
	end

	return -1
end

function var0_0.ShouldRefresh(arg0_24)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_24.nextRefreshTime
end

function var0_0.bindConfigTable(arg0_25)
	return pg.guild_base_event
end

function var0_0.GetPosition(arg0_26)
	return arg0_26.position
end

function var0_0.GetIcon(arg0_27)
	return arg0_27:getConfig("pic")
end

function var0_0.GetSubType(arg0_28)
	return arg0_28:getConfig("sub_type")
end

function var0_0.IsMain(arg0_29)
	return arg0_29:GetSubType() == 1
end

function var0_0.IsFinish(arg0_30)
	local var0_30 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_30.finishTime > 0 and var0_30 >= arg0_30.finishTime
end

function var0_0.GetName(arg0_31)
	return arg0_31:getConfig("name")
end

function var0_0.GetTag(arg0_32)
	return arg0_32:getConfig("type")
end

function var0_0.IsActive(arg0_33)
	return true
end

function var0_0.IsEliteType(arg0_34)
	return arg0_34:getConfig("type") == 2
end

function var0_0.GetJoinMemberCnt(arg0_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg0_35.ships) do
		if not table.contains(var0_35, iter1_35.userId) then
			table.insert(var0_35, iter1_35.userId)
		end
	end

	return #var0_35
end

function var0_0.GetEfficiency(arg0_36)
	return arg0_36.efficiency
end

function var0_0.GetShipsByNation(arg0_37, arg1_37)
	local var0_37 = {}

	for iter0_37, iter1_37 in ipairs(arg0_37.ships) do
		if arg1_37 == pg.ship_data_statistics[iter1_37.configId].nationality then
			table.insert(var0_37, iter1_37)
		end
	end

	return var0_37
end

function var0_0.GetNations(arg0_38)
	return arg0_38.nations
end

function var0_0.GetAttrAcc(arg0_39)
	return arg0_39.attrAccList
end

function var0_0.GetAttrCntAcc(arg0_40)
	return arg0_40.attrCntList
end

function var0_0.GetNodes(arg0_41)
	return arg0_41.nodes
end

function var0_0.GetProgress(arg0_42)
	local var0_42 = arg0_42:GetTotalTimeCost()

	if var0_42 > 0 then
		local var1_42 = arg0_42:GetStartTime()

		return (pg.TimeMgr.GetInstance():GetServerTime() - var1_42) / var0_42
	else
		return 0
	end
end

function var0_0.GetMyFlagShip(arg0_43)
	return arg0_43.myShips[1]
end

function var0_0.GetLogs(arg0_44)
	local var0_44 = arg0_44:GetMyFlagShip()

	if var0_44 then
		local var1_44 = getProxy(BayProxy):getShipById(var0_44)

		do return _.map(arg0_44.nodeLogs, function(arg0_45)
			return string.gsub(arg0_45, "$2", "<color=#92FC63FF>" .. var1_44:getName() .. "</color>")
		end) end
		return
	end

	return {}
end

function var0_0.GetMyShips(arg0_46)
	return arg0_46.myShips
end

function var0_0.GetBattleShipType(arg0_47)
	return arg0_47:getConfig("ship_type_display")
end

function var0_0.GetAwards(arg0_48)
	return arg0_48:getConfig("award_list")
end

function var0_0.CalcMyEffect(arg0_49)
	if not arg0_49 or #arg0_49 == 0 then
		return 0
	end

	local var0_49 = getProxy(BayProxy)
	local var1_49 = 0
	local var2_49 = 0

	for iter0_49, iter1_49 in ipairs(arg0_49) do
		local var3_49 = var0_49:getShipById(iter1_49)

		if var3_49 then
			var1_49 = var3_49.level + var1_49
			var2_49 = var2_49 + var3_49:getShipCombatPower({})
		end
	end

	return math.floor((20 + math.pow(var1_49, 0.7)) * (1 + var2_49 / (var2_49 + 12500)))
end

function var0_0.GetMyEffect(arg0_50)
	return var0_0.CalcMyEffect(arg0_50.myShips)
end

function var0_0.GetRecommendShipTypes(arg0_51)
	return arg0_51.shiptypes
end

function var0_0.GetRecommendShipNation(arg0_52)
	return arg0_52.nations
end

function var0_0.GetSquadron(arg0_53)
	return arg0_53:getConfig("extra_squadron")
end

function var0_0.GetSquadronDisplay(arg0_54)
	return arg0_54:getConfig("extra_squadron_display")
end

function var0_0.GetSquadronTargetCnt(arg0_55)
	return arg0_55:getConfig("extra_squadron_num")
end

function var0_0.GetSquadronRatio(arg0_56)
	return arg0_56:getConfig("extra_squedron_ratio") / 100
end

function var0_0.GetOtherShips(arg0_57)
	local var0_57 = getProxy(GuildProxy):getRawData()
	local var1_57 = {}

	for iter0_57, iter1_57 in pairs(arg0_57.ships) do
		local var2_57 = var0_57:getMemberById(iter1_57.userId)

		if var2_57 then
			local var3_57 = iter1_57.skin

			if var3_57 == 0 then
				var3_57 = pg.ship_data_statistics[iter1_57.configId].skin_id
			end

			table.insert(var1_57, {
				id = iter1_57.configId,
				skin = var3_57,
				name = var2_57 and var2_57.name or ""
			})
		end
	end

	return var1_57
end

function var0_0.RecordFormationTip(arg0_58)
	local var0_58 = arg0_58:GetCanFormationIndex()

	if var0_58 > 0 then
		PlayerPrefs.SetInt("guild_mission_formation_tip" .. arg0_58.configId, var0_58)
	end
end

function var0_0.ShouldShowFormationTip(arg0_59)
	return arg0_59.formationTipIndex < arg0_59:GetCanFormationIndex()
end

function var0_0.FirstFleetCanFormation(arg0_60)
	return arg0_60:GetFleetCnt() == 0
end

function var0_0.SameSquadron(arg0_61, arg1_61)
	if arg0_61:IsEliteType() then
		return table.contains(arg1_61.tagList, arg0_61:getConfig("extra_squadron"))
	end

	return false
end

function var0_0.GetEffectAttr(arg0_62)
	local var0_62 = arg0_62:getConfig("event_attr_count_effect")
	local var1_62 = arg0_62:getConfig("event_attr_acc_effect")
	local var2_62
	local var3_62

	if #var0_62 > 0 then
		var2_62 = var0_62[1][1]
		var3_62 = var0_62[1][2]
	end

	if #var1_62 > 0 then
		var2_62 = var1_62[1][1]
	end

	local var4_62 = pg.attribute_info_by_type

	return var4_62[var2_62] and var4_62[var2_62].name, var3_62
end

function var0_0.MatchAttr(arg0_63, arg1_63)
	if arg0_63:IsEliteType() then
		local var0_63, var1_63 = arg0_63:GetEffectAttr()
		local var2_63 = arg1_63.attrs[var0_63] or 0

		if var1_63 then
			return var1_63 <= var2_63
		else
			return var2_63 > 0
		end
	end

	return false
end

function var0_0.MatchNation(arg0_64, arg1_64)
	if arg0_64:IsEliteType() then
		local var0_64 = arg0_64:GetRecommendShipNation()

		return table.contains(var0_64, arg1_64.nation)
	end

	return false
end

function var0_0.MatchShipType(arg0_65, arg1_65)
	if arg0_65:IsEliteType() then
		local var0_65 = arg0_65:GetRecommendShipTypes()

		return table.contains(var0_65, arg1_65.type)
	end

	return false
end

return var0_0
