local var0_0 = class("GuildProxy", import(".NetProxy"))

var0_0.NEW_GUILD_ADDED = "GuildProxy:NEW_GUILD_ADDED"
var0_0.GUILD_UPDATED = "GuildProxy:GUILD_UPDATED"
var0_0.EXIT_GUILD = "GuildProxy:EXIT_GUILD"
var0_0.REQUEST_ADDED = "GuildProxy:REQUEST_ADDED"
var0_0.REQUEST_DELETED = "GuildProxy:REQUEST_DELETED"
var0_0.NEW_MSG_ADDED = "GuildProxy:NEW_MSG_ADDED"
var0_0.REQUEST_COUNT_UPDATED = "GuildProxy:REQUEST_COUNT_UPDATED"
var0_0.LOG_ADDED = "GuildProxy:LOG_ADDED"
var0_0.WEEKLYTASK_UPDATED = "GuildProxy:WEEKLYTASK_UPDATED"
var0_0.SUPPLY_STARTED = "GuildProxy:SUPPLY_STARTED"
var0_0.WEEKLYTASK_ADDED = "GuildProxy:WEEKLYTASK_ADDED"
var0_0.DONATE_UPDTAE = "GuildProxy:DONATE_UPDTAE"
var0_0.TECHNOLOGY_START = "GuildProxy:TECHNOLOGY_START"
var0_0.TECHNOLOGY_STOP = "GuildProxy:TECHNOLOGY_STOP"
var0_0.CAPITAL_UPDATED = "GuildProxy:CAPITAL_UPDATED"
var0_0.GUILD_BATTLE_STARTED = "GuildProxy:GUILD_BATTLE_STARTED"
var0_0.GUILD_BATTLE_CLOSED = "GuildProxy:GUILD_BATTLE_CLOSED"
var0_0.ON_DELETED_MEMBER = "GuildProxy:ON_DELETED_MEMBER"
var0_0.ON_ADDED_MEMBER = "GuildProxy:ON_ADDED_MEMBER"
var0_0.BATTLE_BTN_FLAG_CHANGE = "GuildProxy:BATTLE_BTN_FLAG_CHANGE"
var0_0.ON_EXIST_DELETED_MEMBER = "GuildProxy:ON_EXIST_DELETED_MEMBER"
var0_0.ON_DONATE_LIST_UPDATED = "GuildProxy:ON_DONATE_LIST_UPDATED"

function var0_0.register(arg0_1)
	arg0_1:Init()
	arg0_1:on(60000, function(arg0_2)
		local var0_2 = Guild.New(arg0_2.guild)

		if var0_2.id == 0 then
			arg0_1:exitGuild()
		elseif arg0_1.data == nil then
			arg0_1:addGuild(var0_2)

			if not getProxy(GuildProxy).isGetChatMsg then
				arg0_1:sendNotification(GAME.GET_GUILD_CHAT_LIST)
			end

			arg0_1:sendNotification(GAME.GUILD_GET_USER_INFO)
			arg0_1:sendNotification(GAME.GUILD_GET_MY_ASSAULT_FLEET, {})
			arg0_1:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {})
			arg0_1:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
				force = true
			})
			arg0_1:sendNotification(GAME.GUILD_GET_REQUEST_LIST, var0_2.id)
		else
			arg0_1:updateGuild(var0_2)
		end
	end)
	arg0_1:on(60009, function(arg0_3)
		arg0_1.requestCount = arg0_3.count

		arg0_1:sendNotification(var0_0.REQUEST_COUNT_UPDATED, arg0_3.count)
	end)
	arg0_1:on(60030, function(arg0_4)
		local var0_4 = arg0_1:getData()

		if not var0_4 then
			return
		end

		var0_4:updateBaseInfo({
			base = arg0_4.guild
		})
		arg0_1:updateGuild(var0_4)
	end)
	arg0_1:on(60031, function(arg0_5)
		local var0_5 = arg0_1:getData()

		if not var0_5 then
			return
		end

		local var1_5 = false

		for iter0_5, iter1_5 in ipairs(arg0_5.member_list) do
			local var2_5 = GuildMember.New(iter1_5)

			if var2_5.duty == 0 then
				local var3_5 = var0_5:getMemberById(var2_5.id):clone()

				var0_5:deleteMember(var2_5.id)
				arg0_1:sendNotification(GuildProxy.ON_DELETED_MEMBER, {
					member = var3_5
				})

				var1_5 = true
			elseif var0_5.member[var2_5.id] then
				var0_5:updateMember(var2_5)
			else
				var0_5:addMember(var2_5)
				arg0_1:sendNotification(GuildProxy.ON_ADDED_MEMBER, {
					member = var2_5
				})
			end
		end

		for iter2_5, iter3_5 in ipairs(arg0_5.log_list) do
			local var4_5 = GuildLogInfo.New(iter3_5)

			var0_5:addLog(var4_5)
			arg0_1:sendNotification(var0_0.LOG_ADDED, Clone(var4_5))
		end

		var0_5:setMemberCount(table.getCount(var0_5.member or {}))
		arg0_1:updateGuild(var0_5)

		if var1_5 then
			arg0_1:sendNotification(GuildProxy.ON_EXIST_DELETED_MEMBER)
		end
	end)
	arg0_1:on(60032, function(arg0_6)
		local var0_6 = arg0_1:getData()

		if not var0_6 then
			return
		end

		var0_6:updateExp(arg0_6.exp)
		var0_6:updateLevel(arg0_6.lv)
		arg0_1:updateGuild(var0_6)
	end)
	arg0_1:on(60008, function(arg0_7)
		local var0_7 = arg0_7.chat
		local var1_7 = arg0_1.data:warpChatInfo(var0_7)

		if var1_7 then
			arg0_1:AddNewMsg(var1_7)
		end
	end)
	arg0_1:on(62004, function(arg0_8)
		local var0_8 = arg0_1:getData()

		if not var0_8 or not var0_8:IsCompletion() then
			return
		end

		local var1_8 = GuildTask.New(arg0_8.this_weekly_tasks)

		var0_8:updateWeeklyTask(var1_8)
		var0_8:setWeeklyTaskFlag(0)
		arg0_1:updateGuild(var0_8)
		arg0_1:sendNotification(var0_0.WEEKLYTASK_ADDED)
	end)
	arg0_1:on(62005, function(arg0_9)
		local var0_9 = arg0_1:getData()

		if not var0_9 or not var0_9:IsCompletion() then
			return
		end

		var0_9:startSupply(arg0_9.benefit_finish_time)

		local var1_9 = var0_9:getSupplyConsume()

		var0_9:consumeCapital(var1_9)
		arg0_1:updateGuild(var0_9)
		arg0_1:sendNotification(var0_0.CAPITAL_UPDATED)
		arg0_1:sendNotification(var0_0.SUPPLY_STARTED)
	end)
	arg0_1:on(62018, function(arg0_10)
		local var0_10 = arg0_1:getData()

		if not var0_10 or not var0_10:IsCompletion() then
			return
		end

		local var1_10 = pg.guild_technology_template[arg0_10.id].group
		local var2_10 = var0_10:getActiveTechnologyGroup()

		if var2_10 then
			var2_10:Stop()
		end

		var0_10:getTechnologyGroupById(var1_10):Start()
		var0_10:UpdateTechCancelCnt()
		arg0_1:updateGuild(var0_10)
		arg0_1:sendNotification(var0_0.TECHNOLOGY_START)
	end)
	arg0_1:on(62019, function(arg0_11)
		local var0_11 = arg0_1:getData()

		if not var0_11 or not var0_11:IsCompletion() then
			return
		end

		local var1_11 = GuildDonateTask.New({
			id = arg0_11.id
		})
		local var2_11 = arg0_11.has_capital == 1
		local var3_11 = arg0_11.has_tech_point == 1
		local var4_11 = arg0_11.user_id
		local var5_11 = getProxy(PlayerProxy):getRawData().id

		if var2_11 then
			local var6_11 = var1_11:getCapital()
			local var7_11 = var0_11:getCapital()

			var0_11:updateCapital(var7_11 + var6_11)

			if var5_11 == var4_11 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_addition_capital_tip", var6_11))
			end
		end

		if var3_11 then
			local var8_11 = var0_11:getActiveTechnologyGroup()

			if var8_11 then
				local var9_11 = var8_11.pid
				local var10_11 = var1_11:getConfig("award_tech_exp")

				var8_11:AddProgress(var10_11)

				local var11_11 = var8_11.pid

				if var9_11 ~= var11_11 and var8_11:GuildMemberCntType() then
					local var12_11 = var0_11:getTechnologyById(var8_11.id)

					assert(var12_11)
					var12_11:Update(var11_11, var8_11)
				end

				if var5_11 == var4_11 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_addition_techpoint_tip", var10_11))
				end
			end
		end

		if var2_11 or var3_11 then
			arg0_1:updateGuild(var0_11)
			arg0_1:sendNotification(var0_0.DONATE_UPDTAE)
		end

		if var2_11 then
			arg0_1:sendNotification(var0_0.CAPITAL_UPDATED)
		end

		if not var2_11 and var4_11 == var5_11 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_capital_toplimit"))
		end

		if not var3_11 and var4_11 == var5_11 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_techpoint_toplimit"))
		end
	end)
	arg0_1:on(62031, function(arg0_12)
		local var0_12 = arg0_1:getData()

		if not var0_12 or not var0_12:IsCompletion() then
			return
		end

		local var1_12 = {}

		for iter0_12, iter1_12 in ipairs(arg0_12.donate_tasks) do
			local var2_12 = GuildDonateTask.New({
				id = iter1_12
			})

			table.insert(var1_12, var2_12)
		end

		if var0_12 then
			var0_12.donateCount = 0

			var0_12:updateDonateTasks(var1_12)
			arg0_1:updateGuild(var0_12)
			arg0_1:sendNotification(var0_0.ON_DONATE_LIST_UPDATED)
		else
			local var3_12 = arg0_1:GetPublicGuild()

			if var3_12 then
				var3_12:ResetDonateCnt()
				var3_12:UpdateDonateTasks(var1_12)
				arg0_1:sendNotification(GAME.PUBLIC_GUILD_REFRESH_DONATE_LIST_DONE)
			end
		end
	end)
	arg0_1:on(61021, function(arg0_13)
		local var0_13 = getProxy(PlayerProxy):getData()

		arg0_1.refreshActivationEventTime = 0

		if arg0_13.user_id ~= var0_13.id then
			arg0_1:sendNotification(var0_0.GUILD_BATTLE_STARTED)
		end
	end)
end

function var0_0.timeCall(arg0_14)
	return {
		[ProxyRegister.DayCall] = function(arg0_15)
			local var0_15 = arg0_14:getRawData()

			if var0_15 then
				var0_15:ResetTechCancelCnt()

				local var1_15 = var0_15:getWeeklyTask()

				if var1_15 and var1_15:isExpire() then
					local var2_15 = var1_15:GetPresonTaskId()

					getProxy(TaskProxy):removeTaskById(var2_15)

					var0_15.weeklyTaskFlag = 0
				end

				local var3_15 = var0_15:GetActiveEvent()

				if var3_15 then
					var3_15:GetBossMission():ResetDailyCnt()
				end

				if arg0_15 == 1 then
					var0_15:ResetActiveEventCnt()
				end

				arg0_14:updateGuild(var0_15)
			end

			if arg0_14:GetPublicGuild() then
				onDelayTick(function()
					arg0_14:sendNotification(GAME.GET_PUBLIC_GUILD_USER_DATA, {
						flag = true
					})
				end, math.random(2, 5))
			end
		end
	}
end

function var0_0.AddPublicGuild(arg0_17, arg1_17)
	arg0_17.publicGuild = arg1_17
end

function var0_0.GetPublicGuild(arg0_18)
	return arg0_18.publicGuild
end

function var0_0.Init(arg0_19)
	arg0_19.data = nil
	arg0_19.chatMsgs = {}
	arg0_19.bossRanks = {}
	arg0_19.isGetChatMsg = false
	arg0_19.refreshActivationEventTime = 0
	arg0_19.nextRequestBattleRankTime = 0
	arg0_19.refreshBossTime = 0
	arg0_19.bossRankUpdateTime = 0
	arg0_19.isFetchAssaultFleet = false
	arg0_19.battleRanks = {}
	arg0_19.ranks = {}
	arg0_19.requests = nil
	arg0_19.rankUpdateTime = 0
	arg0_19.requestReportTime = 0
	arg0_19.newChatMsgCnt = 0
	arg0_19.requestCount = 0
	arg0_19.cdTime = {
		0,
		0
	}
end

function var0_0.AddNewMsg(arg0_20, arg1_20)
	arg0_20.newChatMsgCnt = arg0_20.newChatMsgCnt + 1

	arg0_20:addMsg(arg1_20)
	arg0_20:sendNotification(var0_0.NEW_MSG_ADDED, arg1_20)
end

function var0_0.ResetRequestCount(arg0_21)
	arg0_21.requestCount = 0
end

function var0_0.UpdatePosCdTime(arg0_22, arg1_22, arg2_22)
	arg0_22.cdTime[arg1_22] = arg2_22
end

function var0_0.GetNextCanFormationTime(arg0_23, arg1_23)
	local var0_23 = pg.guildset.operation_assault_team_cd.key_value

	return (arg0_23.cdTime[arg1_23] or 0) + var0_23
end

function var0_0.CanFormationPos(arg0_24, arg1_24)
	return arg0_24:GetNextCanFormationTime(arg1_24) <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.ClearNewChatMsgCnt(arg0_25)
	arg0_25.newChatMsgCnt = 0
end

function var0_0.GetNewChatMsgCnt(arg0_26)
	return arg0_26.newChatMsgCnt
end

function var0_0.setRequestList(arg0_27, arg1_27)
	arg0_27.requests = arg1_27
end

function var0_0.addGuild(arg0_28, arg1_28)
	assert(isa(arg1_28, Guild), "guild should instance of Guild")

	arg0_28.data = arg1_28

	arg0_28:sendNotification(var0_0.NEW_GUILD_ADDED, Clone(arg1_28))
end

function var0_0.updateGuild(arg0_29, arg1_29)
	assert(isa(arg1_29, Guild), "guild should instance of Guild")

	arg0_29.data = arg1_29

	arg0_29:sendNotification(var0_0.GUILD_UPDATED, Clone(arg1_29))
end

function var0_0.exitGuild(arg0_30)
	arg0_30:Init()
	arg0_30:sendNotification(var0_0.EXIT_GUILD)
	pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildEvent")
	pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildBossEvent")
end

function var0_0.getRequests(arg0_31)
	return arg0_31.requests
end

function var0_0.getSortRequest(arg0_32)
	if not arg0_32.requests then
		return nil
	end

	local var0_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.requests) do
		table.insert(var0_32, iter1_32)
	end

	return var0_32
end

function var0_0.deleteRequest(arg0_33, arg1_33)
	if not arg0_33.requests then
		return
	end

	arg0_33.requests[arg1_33] = nil

	arg0_33:sendNotification(var0_0.REQUEST_DELETED, arg1_33)
end

function var0_0.addMsg(arg0_34, arg1_34)
	table.insert(arg0_34.chatMsgs, arg1_34)

	if #arg0_34.chatMsgs > GuildConst.CHAT_LOG_MAX_COUNT then
		table.remove(arg0_34.chatMsgs, 1)
	end
end

function var0_0.getChatMsgs(arg0_35)
	return arg0_35.chatMsgs
end

function var0_0.GetMessagesByUniqueId(arg0_36, arg1_36)
	return _.select(arg0_36.chatMsgs, function(arg0_37)
		return arg0_37.uniqueId == arg1_36
	end)
end

function var0_0.UpdateMsg(arg0_38, arg1_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.chatMsgs) do
		if iter1_38:IsSame(arg1_38.uniqueId) then
			arg0_38.data[iter0_38] = arg1_38
		end
	end
end

function var0_0.ShouldFetchActivationEvent(arg0_39)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_39.refreshActivationEventTime
end

function var0_0.AddFetchActivationEventCDTime(arg0_40)
	arg0_40.refreshActivationEventTime = GuildConst.REFRESH_ACTIVATION_EVENT_TIME + pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.AddActivationEventTimer(arg0_41, arg1_41)
	return
end

function var0_0.RemoveActivationEventTimer(arg0_42)
	if arg0_42.timer then
		arg0_42.timer:Stop()

		arg0_42.timer = nil
	end
end

function var0_0.remove(arg0_43)
	arg0_43:RemoveActivationEventTimer()
end

function var0_0.SetRank(arg0_44, arg1_44, arg2_44)
	arg0_44.ranks[arg1_44] = arg2_44
	arg0_44["rankTimer" .. arg1_44] = pg.TimeMgr.GetInstance():GetServerTime() + 1800
end

function var0_0.GetRanks(arg0_45)
	return arg0_45.ranks
end

function var0_0.ShouldRefreshRank(arg0_46, arg1_46)
	if not arg0_46["rankTimer" .. arg1_46] or pg.TimeMgr.GetInstance():GetServerTime() >= arg0_46["rankTimer" .. arg1_46] then
		return true
	end

	return false
end

function var0_0.SetReports(arg0_47, arg1_47)
	arg0_47.reports = arg1_47
end

function var0_0.GetReports(arg0_48)
	return arg0_48.reports or {}
end

function var0_0.GetReportById(arg0_49, arg1_49)
	return arg0_49.reports[arg1_49]
end

function var0_0.AddReport(arg0_50, arg1_50)
	if not arg0_50.reports then
		arg0_50.reports = {}
	end

	arg0_50.reports[arg1_50.id] = arg1_50
end

function var0_0.GetMaxReportId(arg0_51)
	local var0_51 = arg0_51:GetReports()
	local var1_51 = 0

	for iter0_51, iter1_51 in pairs(var0_51) do
		if var1_51 < iter1_51.id then
			var1_51 = iter1_51.id
		end
	end

	return var1_51
end

function var0_0.AnyRepoerCanGet(arg0_52)
	return #arg0_52:GetCanGetReports() > 0
end

function var0_0.GetCanGetReports(arg0_53)
	local var0_53 = {}
	local var1_53 = arg0_53:GetReports()

	for iter0_53, iter1_53 in pairs(var1_53) do
		if iter1_53:CanSubmit() then
			table.insert(var0_53, iter1_53.id)
		end
	end

	return var0_53
end

function var0_0.ShouldRequestReport(arg0_54)
	if not arg0_54.requestReportTime then
		arg0_54.requestReportTime = 0
	end

	local function var0_54()
		local var0_55 = arg0_54:getRawData():GetActiveEvent()

		if var0_55 and var0_55:GetMissionFinishCnt() > 0 then
			return true
		end

		return false
	end

	local var1_54 = pg.TimeMgr.GetInstance():GetServerTime()

	if not arg0_54.reports and var0_54() or var1_54 > arg0_54.requestReportTime then
		arg0_54.requestReportTime = var1_54 + GuildConst.REQUEST_REPORT_CD

		return true
	end

	return false
end

function var0_0.ShouldRequestForamtion(arg0_56)
	if not arg0_56.requestFormationTime then
		arg0_56.requestFormationTime = 0
	end

	local var0_56 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0_56 > arg0_56.requestFormationTime then
		arg0_56.requestFormationTime = var0_56 + GuildConst.REQUEST_FORMATION_CD

		return true
	end

	return false
end

function var0_0.GetRecommendShipsForMission(arg0_57, arg1_57)
	if arg1_57:IsEliteType() then
		return arg0_57:GetRecommendShipsForEliteMission(arg1_57)
	else
		local var0_57 = {}
		local var1_57 = getProxy(BayProxy):getRawData()
		local var2_57 = {}

		for iter0_57, iter1_57 in pairs(var1_57) do
			table.insert(var2_57, {
				id = iter1_57.id,
				power = iter1_57:getShipCombatPower(),
				nation = iter1_57:getNation(),
				type = iter1_57:getShipType(),
				level = iter1_57.level,
				tagList = iter1_57:getConfig("tag_list"),
				configId = iter1_57.configId,
				attrs = iter1_57:getProperties(),
				isActivityNpc = function()
					return iter1_57:isActivityNpc()
				end
			})
		end

		local var3_57 = arg1_57:GetRecommendShipNation()
		local var4_57 = arg1_57:GetRecommendShipTypes()

		table.sort(var2_57, CompareFuncs({
			function(arg0_59)
				return table.contains(var3_57, arg0_59.nation) and 0 or 1
			end,
			function(arg0_60)
				return table.contains(var4_57, arg0_60.type) and 0 or 1
			end,
			function(arg0_61)
				return -arg0_61.level
			end,
			function(arg0_62)
				return -arg0_62.power
			end
		}))

		for iter2_57, iter3_57 in ipairs(var2_57) do
			if GuildEventMediator.OnCheckMissionShip(arg1_57.id, var0_57, iter3_57) then
				table.insert(var0_57, iter3_57.id)
			end

			if #var0_57 == 4 then
				break
			end
		end

		return var0_57
	end
end

function var0_0.GetRecommendShipsForEliteMission(arg0_63, arg1_63)
	assert(arg1_63:IsEliteType())

	local var0_63 = {}
	local var1_63 = getProxy(BayProxy):getRawData()
	local var2_63 = {}
	local var3_63 = {}
	local var4_63 = {}

	for iter0_63, iter1_63 in pairs(var1_63) do
		local var5_63 = {
			id = iter1_63.id,
			power = iter1_63:getShipCombatPower(),
			nation = iter1_63:getNation(),
			type = iter1_63:getShipType(),
			level = iter1_63.level,
			tagList = iter1_63:getConfig("tag_list"),
			configId = iter1_63.configId,
			attrs = iter1_63:getProperties(),
			isActivityNpc = function()
				return iter1_63:isActivityNpc()
			end
		}

		if arg1_63:SameSquadron(var5_63) then
			table.insert(var3_63, var5_63)
		else
			table.insert(var4_63, var5_63)
		end
	end

	local function var6_63(arg0_65)
		if arg0_65 and not table.contains(var0_63, arg0_65.id) and GuildEventMediator.OnCheckMissionShip(arg1_63.id, var0_63, arg0_65) then
			table.insert(var0_63, arg0_65.id)
		end
	end

	local var7_63 = arg1_63:GetEffectAttr()
	local var8_63 = CompareFuncs({
		function(arg0_66)
			return arg1_63:MatchAttr(arg0_66) and 0 or 1
		end,
		function(arg0_67)
			return arg1_63:MatchNation(arg0_67) and 0 or 1
		end,
		function(arg0_68)
			return arg1_63:MatchShipType(arg0_68) and 0 or 1
		end,
		function(arg0_69)
			return -(arg0_69.attrs[var7_63] or 0)
		end,
		function(arg0_70)
			return -arg0_70.level
		end,
		function(arg0_71)
			return -arg0_71.power
		end
	})
	local var9_63 = arg1_63:GetSquadronTargetCnt()

	if #var3_63 > 0 and var9_63 > 0 then
		table.sort(var3_63, var8_63)

		for iter2_63 = 1, var9_63 do
			var6_63(var3_63[iter2_63])
		end
	end

	if #var0_63 < 4 and #var4_63 > 0 then
		table.sort(var4_63, var8_63)

		for iter3_63 = 1, #var4_63 do
			if #var0_63 == 4 then
				break
			end

			var6_63(var4_63[iter3_63])
		end
	end

	if #var0_63 < 4 and var9_63 > 0 and var9_63 < #var3_63 then
		for iter4_63 = var9_63 + 1, #var3_63 do
			if #var0_63 == 4 then
				break
			end

			var6_63(var3_63[iter4_63])
		end
	end

	return var0_63
end

function var0_0.ShouldShowApplyTip(arg0_72)
	if arg0_72.data and GuildMember.IsAdministrator(arg0_72.data:getSelfDuty()) then
		if not arg0_72.requests then
			return arg0_72.requestCount > 0
		end

		return table.getCount(arg0_72.requests) + arg0_72.requestCount > 0
	end

	return false
end

function var0_0.ShouldShowBattleTip(arg0_73)
	local var0_73 = arg0_73:getData()
	local var1_73 = false

	local function var2_73(arg0_74)
		if arg0_74 and arg0_74:IsParticipant() then
			local var0_74 = arg0_74:GetBossMission()

			return var0_74 and var0_74:IsActive() and var0_74:CanEnterBattle()
		end

		return false
	end

	local function var3_73()
		for iter0_75, iter1_75 in ipairs(pg.guild_operation_template.all) do
			local var0_75 = pg.guild_operation_template[iter1_75]

			if var0_73.level >= var0_75.unlock_guild_level and var0_73:getCapital() >= var0_75.consume then
				return true
			end
		end

		return false
	end

	if var0_73 then
		local var4_73 = var0_73:GetActiveEvent()
		local var5_73 = GuildMember.IsAdministrator(var0_73:getSelfDuty()) and var0_73:ShouldTipActiveEvent()

		var1_73 = arg0_73:ShouldShowMainTip() or not var4_73 and var5_73 and var3_73() or var4_73 and not arg0_73:GetBattleBtnRecord()

		if var4_73 and not var1_73 then
			local var6_73 = var4_73:IsParticipant()

			var1_73 = var6_73 and var4_73:AnyMissionCanFormation() or var2_73(var4_73) or not var6_73 and not var4_73:IsLimitedJoin()
		end
	end

	return var1_73
end

function var0_0.SetBattleBtnRecord(arg0_76)
	if not arg0_76:GetBattleBtnRecord() then
		local var0_76 = arg0_76:getRawData()

		if var0_76 and var0_76:GetActiveEvent() then
			local var1_76 = getProxy(PlayerProxy):getRawData()

			PlayerPrefs.SetInt("guild_battle_btn_flag" .. var1_76.id, 1)
			PlayerPrefs.Save()
			arg0_76:sendNotification(var0_0.BATTLE_BTN_FLAG_CHANGE)
		end
	end
end

function var0_0.GetBattleBtnRecord(arg0_77)
	local var0_77 = getProxy(PlayerProxy):getRawData()

	return PlayerPrefs.GetInt("guild_battle_btn_flag" .. var0_77.id, 0) > 0
end

function var0_0.ShouldShowMainTip(arg0_78)
	local function var0_78()
		local var0_79 = getProxy(PlayerProxy):getRawData().id

		return arg0_78.data:getMemberById(var0_79):IsRecruit()
	end

	return _.any(arg0_78.reports or {}, function(arg0_80)
		return arg0_80:CanSubmit()
	end) and not var0_78()
end

function var0_0.ShouldShowTip(arg0_81)
	local var0_81 = {}
	local var1_81 = arg0_81:getData()

	if var1_81 then
		table.insert(var0_81, var1_81:ShouldShowDonateTip())
		table.insert(var0_81, arg0_81:ShouldShowApplyTip())
		table.insert(var0_81, var1_81:ShouldWeeklyTaskTip())
		table.insert(var0_81, var1_81:ShouldShowSupplyTip())
		table.insert(var0_81, var1_81:ShouldShowTechTip())

		if not LOCK_GUILD_BATTLE then
			table.insert(var0_81, arg0_81:ShouldShowBattleTip())
		end
	end

	return #var0_81 > 0 and _.any(var0_81, function(arg0_82)
		return arg0_82 == true
	end)
end

function var0_0.SetRefreshBossTime(arg0_83, arg1_83)
	arg0_83.refreshBossTime = arg1_83 + GuildConst.REFRESH_BOSS_TIME
end

function var0_0.ShouldRefreshBoss(arg0_84)
	local var0_84 = arg0_84:getRawData():GetActiveEvent()

	return var0_84 and not var0_84:IsExpired() and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_84.refreshBossTime
end

function var0_0.ResetRefreshBossTime(arg0_85)
	arg0_85.refreshBossTime = 0
end

function var0_0.ShouldRefreshBossRank(arg0_86)
	local var0_86 = arg0_86:getRawData():GetActiveEvent()
	local var1_86 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0_86 and var1_86 - arg0_86.bossRankUpdateTime >= GuildConst.REFRESH_MISSION_BOSS_RANK_TIME
end

function var0_0.UpdateBossRank(arg0_87, arg1_87)
	arg0_87.bossRanks = arg1_87
end

function var0_0.GetBossRank(arg0_88)
	return arg0_88.bossRanks
end

function var0_0.ResetBossRankTime(arg0_89)
	arg0_89.rankUpdateTime = 0
end

function var0_0.UpdateBossRankRefreshTime(arg0_90, arg1_90)
	arg0_90.rankUpdateTime = arg1_90
end

function var0_0.GetAdditionGuild(arg0_91)
	if arg0_91.data == nil then
		return arg0_91.publicGuild
	else
		return arg0_91.data
	end
end

function var0_0.SetReportRankList(arg0_92, arg1_92, arg2_92)
	if not arg0_92.reportRankList then
		arg0_92.reportRankList = {}
	end

	arg0_92.reportRankList[arg1_92] = arg2_92
end

function var0_0.GetReportRankList(arg0_93, arg1_93)
	if arg0_93.reportRankList then
		return arg0_93.reportRankList[arg1_93]
	end

	return nil
end

return var0_0
