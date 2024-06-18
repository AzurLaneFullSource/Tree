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

function var0_0.AddPublicGuild(arg0_14, arg1_14)
	arg0_14.publicGuild = arg1_14
end

function var0_0.GetPublicGuild(arg0_15)
	return arg0_15.publicGuild
end

function var0_0.Init(arg0_16)
	arg0_16.data = nil
	arg0_16.chatMsgs = {}
	arg0_16.bossRanks = {}
	arg0_16.isGetChatMsg = false
	arg0_16.refreshActivationEventTime = 0
	arg0_16.nextRequestBattleRankTime = 0
	arg0_16.refreshBossTime = 0
	arg0_16.bossRankUpdateTime = 0
	arg0_16.isFetchAssaultFleet = false
	arg0_16.battleRanks = {}
	arg0_16.ranks = {}
	arg0_16.requests = nil
	arg0_16.rankUpdateTime = 0
	arg0_16.requestReportTime = 0
	arg0_16.newChatMsgCnt = 0
	arg0_16.requestCount = 0
	arg0_16.cdTime = {
		0,
		0
	}
end

function var0_0.AddNewMsg(arg0_17, arg1_17)
	arg0_17.newChatMsgCnt = arg0_17.newChatMsgCnt + 1

	arg0_17:addMsg(arg1_17)
	arg0_17:sendNotification(var0_0.NEW_MSG_ADDED, arg1_17)
end

function var0_0.ResetRequestCount(arg0_18)
	arg0_18.requestCount = 0
end

function var0_0.UpdatePosCdTime(arg0_19, arg1_19, arg2_19)
	arg0_19.cdTime[arg1_19] = arg2_19
end

function var0_0.GetNextCanFormationTime(arg0_20, arg1_20)
	local var0_20 = pg.guildset.operation_assault_team_cd.key_value

	return (arg0_20.cdTime[arg1_20] or 0) + var0_20
end

function var0_0.CanFormationPos(arg0_21, arg1_21)
	return arg0_21:GetNextCanFormationTime(arg1_21) <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.ClearNewChatMsgCnt(arg0_22)
	arg0_22.newChatMsgCnt = 0
end

function var0_0.GetNewChatMsgCnt(arg0_23)
	return arg0_23.newChatMsgCnt
end

function var0_0.setRequestList(arg0_24, arg1_24)
	arg0_24.requests = arg1_24
end

function var0_0.addGuild(arg0_25, arg1_25)
	assert(isa(arg1_25, Guild), "guild should instance of Guild")

	arg0_25.data = arg1_25

	arg0_25:sendNotification(var0_0.NEW_GUILD_ADDED, Clone(arg1_25))
end

function var0_0.updateGuild(arg0_26, arg1_26)
	assert(isa(arg1_26, Guild), "guild should instance of Guild")

	arg0_26.data = arg1_26

	arg0_26:sendNotification(var0_0.GUILD_UPDATED, Clone(arg1_26))
end

function var0_0.exitGuild(arg0_27)
	arg0_27:Init()
	arg0_27:sendNotification(var0_0.EXIT_GUILD)
	pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildEvent")
	pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildBossEvent")
end

function var0_0.getRequests(arg0_28)
	return arg0_28.requests
end

function var0_0.getSortRequest(arg0_29)
	if not arg0_29.requests then
		return nil
	end

	local var0_29 = {}

	for iter0_29, iter1_29 in pairs(arg0_29.requests) do
		table.insert(var0_29, iter1_29)
	end

	return var0_29
end

function var0_0.deleteRequest(arg0_30, arg1_30)
	if not arg0_30.requests then
		return
	end

	arg0_30.requests[arg1_30] = nil

	arg0_30:sendNotification(var0_0.REQUEST_DELETED, arg1_30)
end

function var0_0.addMsg(arg0_31, arg1_31)
	table.insert(arg0_31.chatMsgs, arg1_31)

	if #arg0_31.chatMsgs > GuildConst.CHAT_LOG_MAX_COUNT then
		table.remove(arg0_31.chatMsgs, 1)
	end
end

function var0_0.getChatMsgs(arg0_32)
	return arg0_32.chatMsgs
end

function var0_0.GetMessagesByUniqueId(arg0_33, arg1_33)
	return _.select(arg0_33.chatMsgs, function(arg0_34)
		return arg0_34.uniqueId == arg1_33
	end)
end

function var0_0.UpdateMsg(arg0_35, arg1_35)
	for iter0_35, iter1_35 in ipairs(arg0_35.chatMsgs) do
		if iter1_35:IsSame(arg1_35.uniqueId) then
			arg0_35.data[iter0_35] = arg1_35
		end
	end
end

function var0_0.ShouldFetchActivationEvent(arg0_36)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_36.refreshActivationEventTime
end

function var0_0.AddFetchActivationEventCDTime(arg0_37)
	arg0_37.refreshActivationEventTime = GuildConst.REFRESH_ACTIVATION_EVENT_TIME + pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.AddActivationEventTimer(arg0_38, arg1_38)
	return
end

function var0_0.RemoveActivationEventTimer(arg0_39)
	if arg0_39.timer then
		arg0_39.timer:Stop()

		arg0_39.timer = nil
	end
end

function var0_0.remove(arg0_40)
	arg0_40:RemoveActivationEventTimer()
end

function var0_0.SetRank(arg0_41, arg1_41, arg2_41)
	arg0_41.ranks[arg1_41] = arg2_41
	arg0_41["rankTimer" .. arg1_41] = pg.TimeMgr.GetInstance():GetServerTime() + 1800
end

function var0_0.GetRanks(arg0_42)
	return arg0_42.ranks
end

function var0_0.ShouldRefreshRank(arg0_43, arg1_43)
	if not arg0_43["rankTimer" .. arg1_43] or pg.TimeMgr.GetInstance():GetServerTime() >= arg0_43["rankTimer" .. arg1_43] then
		return true
	end

	return false
end

function var0_0.SetReports(arg0_44, arg1_44)
	arg0_44.reports = arg1_44
end

function var0_0.GetReports(arg0_45)
	return arg0_45.reports or {}
end

function var0_0.GetReportById(arg0_46, arg1_46)
	return arg0_46.reports[arg1_46]
end

function var0_0.AddReport(arg0_47, arg1_47)
	if not arg0_47.reports then
		arg0_47.reports = {}
	end

	arg0_47.reports[arg1_47.id] = arg1_47
end

function var0_0.GetMaxReportId(arg0_48)
	local var0_48 = arg0_48:GetReports()
	local var1_48 = 0

	for iter0_48, iter1_48 in pairs(var0_48) do
		if var1_48 < iter1_48.id then
			var1_48 = iter1_48.id
		end
	end

	return var1_48
end

function var0_0.AnyRepoerCanGet(arg0_49)
	return #arg0_49:GetCanGetReports() > 0
end

function var0_0.GetCanGetReports(arg0_50)
	local var0_50 = {}
	local var1_50 = arg0_50:GetReports()

	for iter0_50, iter1_50 in pairs(var1_50) do
		if iter1_50:CanSubmit() then
			table.insert(var0_50, iter1_50.id)
		end
	end

	return var0_50
end

function var0_0.ShouldRequestReport(arg0_51)
	if not arg0_51.requestReportTime then
		arg0_51.requestReportTime = 0
	end

	local function var0_51()
		local var0_52 = arg0_51:getRawData():GetActiveEvent()

		if var0_52 and var0_52:GetMissionFinishCnt() > 0 then
			return true
		end

		return false
	end

	local var1_51 = pg.TimeMgr.GetInstance():GetServerTime()

	if not arg0_51.reports and var0_51() or var1_51 > arg0_51.requestReportTime then
		arg0_51.requestReportTime = var1_51 + GuildConst.REQUEST_REPORT_CD

		return true
	end

	return false
end

function var0_0.ShouldRequestForamtion(arg0_53)
	if not arg0_53.requestFormationTime then
		arg0_53.requestFormationTime = 0
	end

	local var0_53 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0_53 > arg0_53.requestFormationTime then
		arg0_53.requestFormationTime = var0_53 + GuildConst.REQUEST_FORMATION_CD

		return true
	end

	return false
end

function var0_0.GetRecommendShipsForMission(arg0_54, arg1_54)
	if arg1_54:IsEliteType() then
		return arg0_54:GetRecommendShipsForEliteMission(arg1_54)
	else
		local var0_54 = {}
		local var1_54 = getProxy(BayProxy):getRawData()
		local var2_54 = {}

		for iter0_54, iter1_54 in pairs(var1_54) do
			table.insert(var2_54, {
				id = iter1_54.id,
				power = iter1_54:getShipCombatPower(),
				nation = iter1_54:getNation(),
				type = iter1_54:getShipType(),
				level = iter1_54.level,
				tagList = iter1_54:getConfig("tag_list"),
				configId = iter1_54.configId,
				attrs = iter1_54:getProperties(),
				isActivityNpc = function()
					return iter1_54:isActivityNpc()
				end
			})
		end

		local var3_54 = arg1_54:GetRecommendShipNation()
		local var4_54 = arg1_54:GetRecommendShipTypes()

		table.sort(var2_54, CompareFuncs({
			function(arg0_56)
				return table.contains(var3_54, arg0_56.nation) and 0 or 1
			end,
			function(arg0_57)
				return table.contains(var4_54, arg0_57.type) and 0 or 1
			end,
			function(arg0_58)
				return -arg0_58.level
			end,
			function(arg0_59)
				return -arg0_59.power
			end
		}))

		for iter2_54, iter3_54 in ipairs(var2_54) do
			if GuildEventMediator.OnCheckMissionShip(arg1_54.id, var0_54, iter3_54) then
				table.insert(var0_54, iter3_54.id)
			end

			if #var0_54 == 4 then
				break
			end
		end

		return var0_54
	end
end

function var0_0.GetRecommendShipsForEliteMission(arg0_60, arg1_60)
	assert(arg1_60:IsEliteType())

	local var0_60 = {}
	local var1_60 = getProxy(BayProxy):getRawData()
	local var2_60 = {}
	local var3_60 = {}
	local var4_60 = {}

	for iter0_60, iter1_60 in pairs(var1_60) do
		local var5_60 = {
			id = iter1_60.id,
			power = iter1_60:getShipCombatPower(),
			nation = iter1_60:getNation(),
			type = iter1_60:getShipType(),
			level = iter1_60.level,
			tagList = iter1_60:getConfig("tag_list"),
			configId = iter1_60.configId,
			attrs = iter1_60:getProperties(),
			isActivityNpc = function()
				return iter1_60:isActivityNpc()
			end
		}

		if arg1_60:SameSquadron(var5_60) then
			table.insert(var3_60, var5_60)
		else
			table.insert(var4_60, var5_60)
		end
	end

	local function var6_60(arg0_62)
		if arg0_62 and not table.contains(var0_60, arg0_62.id) and GuildEventMediator.OnCheckMissionShip(arg1_60.id, var0_60, arg0_62) then
			table.insert(var0_60, arg0_62.id)
		end
	end

	local var7_60 = arg1_60:GetEffectAttr()
	local var8_60 = CompareFuncs({
		function(arg0_63)
			return arg1_60:MatchAttr(arg0_63) and 0 or 1
		end,
		function(arg0_64)
			return arg1_60:MatchNation(arg0_64) and 0 or 1
		end,
		function(arg0_65)
			return arg1_60:MatchShipType(arg0_65) and 0 or 1
		end,
		function(arg0_66)
			return -(arg0_66.attrs[var7_60] or 0)
		end,
		function(arg0_67)
			return -arg0_67.level
		end,
		function(arg0_68)
			return -arg0_68.power
		end
	})
	local var9_60 = arg1_60:GetSquadronTargetCnt()

	if #var3_60 > 0 and var9_60 > 0 then
		table.sort(var3_60, var8_60)

		for iter2_60 = 1, var9_60 do
			var6_60(var3_60[iter2_60])
		end
	end

	if #var0_60 < 4 and #var4_60 > 0 then
		table.sort(var4_60, var8_60)

		for iter3_60 = 1, #var4_60 do
			if #var0_60 == 4 then
				break
			end

			var6_60(var4_60[iter3_60])
		end
	end

	if #var0_60 < 4 and var9_60 > 0 and var9_60 < #var3_60 then
		for iter4_60 = var9_60 + 1, #var3_60 do
			if #var0_60 == 4 then
				break
			end

			var6_60(var3_60[iter4_60])
		end
	end

	return var0_60
end

function var0_0.ShouldShowApplyTip(arg0_69)
	if arg0_69.data and GuildMember.IsAdministrator(arg0_69.data:getSelfDuty()) then
		if not arg0_69.requests then
			return arg0_69.requestCount > 0
		end

		return table.getCount(arg0_69.requests) + arg0_69.requestCount > 0
	end

	return false
end

function var0_0.ShouldShowBattleTip(arg0_70)
	local var0_70 = arg0_70:getData()
	local var1_70 = false

	local function var2_70(arg0_71)
		if arg0_71 and arg0_71:IsParticipant() then
			local var0_71 = arg0_71:GetBossMission()

			return var0_71 and var0_71:IsActive() and var0_71:CanEnterBattle()
		end

		return false
	end

	local function var3_70()
		for iter0_72, iter1_72 in ipairs(pg.guild_operation_template.all) do
			local var0_72 = pg.guild_operation_template[iter1_72]

			if var0_70.level >= var0_72.unlock_guild_level and var0_70:getCapital() >= var0_72.consume then
				return true
			end
		end

		return false
	end

	if var0_70 then
		local var4_70 = var0_70:GetActiveEvent()
		local var5_70 = GuildMember.IsAdministrator(var0_70:getSelfDuty()) and var0_70:ShouldTipActiveEvent()

		var1_70 = arg0_70:ShouldShowMainTip() or not var4_70 and var5_70 and var3_70() or var4_70 and not arg0_70:GetBattleBtnRecord()

		if var4_70 and not var1_70 then
			local var6_70 = var4_70:IsParticipant()

			var1_70 = var6_70 and var4_70:AnyMissionCanFormation() or var2_70(var4_70) or not var6_70 and not var4_70:IsLimitedJoin()
		end
	end

	return var1_70
end

function var0_0.SetBattleBtnRecord(arg0_73)
	if not arg0_73:GetBattleBtnRecord() then
		local var0_73 = arg0_73:getRawData()

		if var0_73 and var0_73:GetActiveEvent() then
			local var1_73 = getProxy(PlayerProxy):getRawData()

			PlayerPrefs.SetInt("guild_battle_btn_flag" .. var1_73.id, 1)
			PlayerPrefs.Save()
			arg0_73:sendNotification(var0_0.BATTLE_BTN_FLAG_CHANGE)
		end
	end
end

function var0_0.GetBattleBtnRecord(arg0_74)
	local var0_74 = getProxy(PlayerProxy):getRawData()

	return PlayerPrefs.GetInt("guild_battle_btn_flag" .. var0_74.id, 0) > 0
end

function var0_0.ShouldShowMainTip(arg0_75)
	local function var0_75()
		local var0_76 = getProxy(PlayerProxy):getRawData().id

		return arg0_75.data:getMemberById(var0_76):IsRecruit()
	end

	return _.any(arg0_75.reports or {}, function(arg0_77)
		return arg0_77:CanSubmit()
	end) and not var0_75()
end

function var0_0.ShouldShowTip(arg0_78)
	local var0_78 = {}
	local var1_78 = arg0_78:getData()

	if var1_78 then
		table.insert(var0_78, var1_78:ShouldShowDonateTip())
		table.insert(var0_78, arg0_78:ShouldShowApplyTip())
		table.insert(var0_78, var1_78:ShouldWeeklyTaskTip())
		table.insert(var0_78, var1_78:ShouldShowSupplyTip())
		table.insert(var0_78, var1_78:ShouldShowTechTip())

		if not LOCK_GUILD_BATTLE then
			table.insert(var0_78, arg0_78:ShouldShowBattleTip())
		end
	end

	return #var0_78 > 0 and _.any(var0_78, function(arg0_79)
		return arg0_79 == true
	end)
end

function var0_0.SetRefreshBossTime(arg0_80, arg1_80)
	arg0_80.refreshBossTime = arg1_80 + GuildConst.REFRESH_BOSS_TIME
end

function var0_0.ShouldRefreshBoss(arg0_81)
	local var0_81 = arg0_81:getRawData():GetActiveEvent()

	return var0_81 and not var0_81:IsExpired() and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_81.refreshBossTime
end

function var0_0.ResetRefreshBossTime(arg0_82)
	arg0_82.refreshBossTime = 0
end

function var0_0.ShouldRefreshBossRank(arg0_83)
	local var0_83 = arg0_83:getRawData():GetActiveEvent()
	local var1_83 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0_83 and var1_83 - arg0_83.bossRankUpdateTime >= GuildConst.REFRESH_MISSION_BOSS_RANK_TIME
end

function var0_0.UpdateBossRank(arg0_84, arg1_84)
	arg0_84.bossRanks = arg1_84
end

function var0_0.GetBossRank(arg0_85)
	return arg0_85.bossRanks
end

function var0_0.ResetBossRankTime(arg0_86)
	arg0_86.rankUpdateTime = 0
end

function var0_0.UpdateBossRankRefreshTime(arg0_87, arg1_87)
	arg0_87.rankUpdateTime = arg1_87
end

function var0_0.GetAdditionGuild(arg0_88)
	if arg0_88.data == nil then
		return arg0_88.publicGuild
	else
		return arg0_88.data
	end
end

function var0_0.SetReportRankList(arg0_89, arg1_89, arg2_89)
	if not arg0_89.reportRankList then
		arg0_89.reportRankList = {}
	end

	arg0_89.reportRankList[arg1_89] = arg2_89
end

function var0_0.GetReportRankList(arg0_90, arg1_90)
	if arg0_90.reportRankList then
		return arg0_90.reportRankList[arg1_90]
	end

	return nil
end

return var0_0
