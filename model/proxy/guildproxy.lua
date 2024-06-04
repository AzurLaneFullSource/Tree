local var0 = class("GuildProxy", import(".NetProxy"))

var0.NEW_GUILD_ADDED = "GuildProxy:NEW_GUILD_ADDED"
var0.GUILD_UPDATED = "GuildProxy:GUILD_UPDATED"
var0.EXIT_GUILD = "GuildProxy:EXIT_GUILD"
var0.REQUEST_ADDED = "GuildProxy:REQUEST_ADDED"
var0.REQUEST_DELETED = "GuildProxy:REQUEST_DELETED"
var0.NEW_MSG_ADDED = "GuildProxy:NEW_MSG_ADDED"
var0.REQUEST_COUNT_UPDATED = "GuildProxy:REQUEST_COUNT_UPDATED"
var0.LOG_ADDED = "GuildProxy:LOG_ADDED"
var0.WEEKLYTASK_UPDATED = "GuildProxy:WEEKLYTASK_UPDATED"
var0.SUPPLY_STARTED = "GuildProxy:SUPPLY_STARTED"
var0.WEEKLYTASK_ADDED = "GuildProxy:WEEKLYTASK_ADDED"
var0.DONATE_UPDTAE = "GuildProxy:DONATE_UPDTAE"
var0.TECHNOLOGY_START = "GuildProxy:TECHNOLOGY_START"
var0.TECHNOLOGY_STOP = "GuildProxy:TECHNOLOGY_STOP"
var0.CAPITAL_UPDATED = "GuildProxy:CAPITAL_UPDATED"
var0.GUILD_BATTLE_STARTED = "GuildProxy:GUILD_BATTLE_STARTED"
var0.GUILD_BATTLE_CLOSED = "GuildProxy:GUILD_BATTLE_CLOSED"
var0.ON_DELETED_MEMBER = "GuildProxy:ON_DELETED_MEMBER"
var0.ON_ADDED_MEMBER = "GuildProxy:ON_ADDED_MEMBER"
var0.BATTLE_BTN_FLAG_CHANGE = "GuildProxy:BATTLE_BTN_FLAG_CHANGE"
var0.ON_EXIST_DELETED_MEMBER = "GuildProxy:ON_EXIST_DELETED_MEMBER"
var0.ON_DONATE_LIST_UPDATED = "GuildProxy:ON_DONATE_LIST_UPDATED"

function var0.register(arg0)
	arg0:Init()
	arg0:on(60000, function(arg0)
		local var0 = Guild.New(arg0.guild)

		if var0.id == 0 then
			arg0:exitGuild()
		elseif arg0.data == nil then
			arg0:addGuild(var0)

			if not getProxy(GuildProxy).isGetChatMsg then
				arg0:sendNotification(GAME.GET_GUILD_CHAT_LIST)
			end

			arg0:sendNotification(GAME.GUILD_GET_USER_INFO)
			arg0:sendNotification(GAME.GUILD_GET_MY_ASSAULT_FLEET, {})
			arg0:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {})
			arg0:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
				force = true
			})
			arg0:sendNotification(GAME.GUILD_GET_REQUEST_LIST, var0.id)
		else
			arg0:updateGuild(var0)
		end
	end)
	arg0:on(60009, function(arg0)
		arg0.requestCount = arg0.count

		arg0:sendNotification(var0.REQUEST_COUNT_UPDATED, arg0.count)
	end)
	arg0:on(60030, function(arg0)
		local var0 = arg0:getData()

		if not var0 then
			return
		end

		var0:updateBaseInfo({
			base = arg0.guild
		})
		arg0:updateGuild(var0)
	end)
	arg0:on(60031, function(arg0)
		local var0 = arg0:getData()

		if not var0 then
			return
		end

		local var1 = false

		for iter0, iter1 in ipairs(arg0.member_list) do
			local var2 = GuildMember.New(iter1)

			if var2.duty == 0 then
				local var3 = var0:getMemberById(var2.id):clone()

				var0:deleteMember(var2.id)
				arg0:sendNotification(GuildProxy.ON_DELETED_MEMBER, {
					member = var3
				})

				var1 = true
			elseif var0.member[var2.id] then
				var0:updateMember(var2)
			else
				var0:addMember(var2)
				arg0:sendNotification(GuildProxy.ON_ADDED_MEMBER, {
					member = var2
				})
			end
		end

		for iter2, iter3 in ipairs(arg0.log_list) do
			local var4 = GuildLogInfo.New(iter3)

			var0:addLog(var4)
			arg0:sendNotification(var0.LOG_ADDED, Clone(var4))
		end

		var0:setMemberCount(table.getCount(var0.member or {}))
		arg0:updateGuild(var0)

		if var1 then
			arg0:sendNotification(GuildProxy.ON_EXIST_DELETED_MEMBER)
		end
	end)
	arg0:on(60032, function(arg0)
		local var0 = arg0:getData()

		if not var0 then
			return
		end

		var0:updateExp(arg0.exp)
		var0:updateLevel(arg0.lv)
		arg0:updateGuild(var0)
	end)
	arg0:on(60008, function(arg0)
		local var0 = arg0.chat
		local var1 = arg0.data:warpChatInfo(var0)

		if var1 then
			arg0:AddNewMsg(var1)
		end
	end)
	arg0:on(62004, function(arg0)
		local var0 = arg0:getData()

		if not var0 or not var0:IsCompletion() then
			return
		end

		local var1 = GuildTask.New(arg0.this_weekly_tasks)

		var0:updateWeeklyTask(var1)
		var0:setWeeklyTaskFlag(0)
		arg0:updateGuild(var0)
		arg0:sendNotification(var0.WEEKLYTASK_ADDED)
	end)
	arg0:on(62005, function(arg0)
		local var0 = arg0:getData()

		if not var0 or not var0:IsCompletion() then
			return
		end

		var0:startSupply(arg0.benefit_finish_time)

		local var1 = var0:getSupplyConsume()

		var0:consumeCapital(var1)
		arg0:updateGuild(var0)
		arg0:sendNotification(var0.CAPITAL_UPDATED)
		arg0:sendNotification(var0.SUPPLY_STARTED)
	end)
	arg0:on(62018, function(arg0)
		local var0 = arg0:getData()

		if not var0 or not var0:IsCompletion() then
			return
		end

		local var1 = pg.guild_technology_template[arg0.id].group
		local var2 = var0:getActiveTechnologyGroup()

		if var2 then
			var2:Stop()
		end

		var0:getTechnologyGroupById(var1):Start()
		var0:UpdateTechCancelCnt()
		arg0:updateGuild(var0)
		arg0:sendNotification(var0.TECHNOLOGY_START)
	end)
	arg0:on(62019, function(arg0)
		local var0 = arg0:getData()

		if not var0 or not var0:IsCompletion() then
			return
		end

		local var1 = GuildDonateTask.New({
			id = arg0.id
		})
		local var2 = arg0.has_capital == 1
		local var3 = arg0.has_tech_point == 1
		local var4 = arg0.user_id
		local var5 = getProxy(PlayerProxy):getRawData().id

		if var2 then
			local var6 = var1:getCapital()
			local var7 = var0:getCapital()

			var0:updateCapital(var7 + var6)

			if var5 == var4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_addition_capital_tip", var6))
			end
		end

		if var3 then
			local var8 = var0:getActiveTechnologyGroup()

			if var8 then
				local var9 = var8.pid
				local var10 = var1:getConfig("award_tech_exp")

				var8:AddProgress(var10)

				local var11 = var8.pid

				if var9 ~= var11 and var8:GuildMemberCntType() then
					local var12 = var0:getTechnologyById(var8.id)

					assert(var12)
					var12:Update(var11, var8)
				end

				if var5 == var4 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_addition_techpoint_tip", var10))
				end
			end
		end

		if var2 or var3 then
			arg0:updateGuild(var0)
			arg0:sendNotification(var0.DONATE_UPDTAE)
		end

		if var2 then
			arg0:sendNotification(var0.CAPITAL_UPDATED)
		end

		if not var2 and var4 == var5 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_capital_toplimit"))
		end

		if not var3 and var4 == var5 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_techpoint_toplimit"))
		end
	end)
	arg0:on(62031, function(arg0)
		local var0 = arg0:getData()

		if not var0 or not var0:IsCompletion() then
			return
		end

		local var1 = {}

		for iter0, iter1 in ipairs(arg0.donate_tasks) do
			local var2 = GuildDonateTask.New({
				id = iter1
			})

			table.insert(var1, var2)
		end

		if var0 then
			var0.donateCount = 0

			var0:updateDonateTasks(var1)
			arg0:updateGuild(var0)
			arg0:sendNotification(var0.ON_DONATE_LIST_UPDATED)
		else
			local var3 = arg0:GetPublicGuild()

			if var3 then
				var3:ResetDonateCnt()
				var3:UpdateDonateTasks(var1)
				arg0:sendNotification(GAME.PUBLIC_GUILD_REFRESH_DONATE_LIST_DONE)
			end
		end
	end)
	arg0:on(61021, function(arg0)
		local var0 = getProxy(PlayerProxy):getData()

		arg0.refreshActivationEventTime = 0

		if arg0.user_id ~= var0.id then
			arg0:sendNotification(var0.GUILD_BATTLE_STARTED)
		end
	end)
end

function var0.AddPublicGuild(arg0, arg1)
	arg0.publicGuild = arg1
end

function var0.GetPublicGuild(arg0)
	return arg0.publicGuild
end

function var0.Init(arg0)
	arg0.data = nil
	arg0.chatMsgs = {}
	arg0.bossRanks = {}
	arg0.isGetChatMsg = false
	arg0.refreshActivationEventTime = 0
	arg0.nextRequestBattleRankTime = 0
	arg0.refreshBossTime = 0
	arg0.bossRankUpdateTime = 0
	arg0.isFetchAssaultFleet = false
	arg0.battleRanks = {}
	arg0.ranks = {}
	arg0.requests = nil
	arg0.rankUpdateTime = 0
	arg0.requestReportTime = 0
	arg0.newChatMsgCnt = 0
	arg0.requestCount = 0
	arg0.cdTime = {
		0,
		0
	}
end

function var0.AddNewMsg(arg0, arg1)
	arg0.newChatMsgCnt = arg0.newChatMsgCnt + 1

	arg0:addMsg(arg1)
	arg0:sendNotification(var0.NEW_MSG_ADDED, arg1)
end

function var0.ResetRequestCount(arg0)
	arg0.requestCount = 0
end

function var0.UpdatePosCdTime(arg0, arg1, arg2)
	arg0.cdTime[arg1] = arg2
end

function var0.GetNextCanFormationTime(arg0, arg1)
	local var0 = pg.guildset.operation_assault_team_cd.key_value

	return (arg0.cdTime[arg1] or 0) + var0
end

function var0.CanFormationPos(arg0, arg1)
	return arg0:GetNextCanFormationTime(arg1) <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.ClearNewChatMsgCnt(arg0)
	arg0.newChatMsgCnt = 0
end

function var0.GetNewChatMsgCnt(arg0)
	return arg0.newChatMsgCnt
end

function var0.setRequestList(arg0, arg1)
	arg0.requests = arg1
end

function var0.addGuild(arg0, arg1)
	assert(isa(arg1, Guild), "guild should instance of Guild")

	arg0.data = arg1

	arg0:sendNotification(var0.NEW_GUILD_ADDED, Clone(arg1))
end

function var0.updateGuild(arg0, arg1)
	assert(isa(arg1, Guild), "guild should instance of Guild")

	arg0.data = arg1

	arg0:sendNotification(var0.GUILD_UPDATED, Clone(arg1))
end

function var0.exitGuild(arg0)
	arg0:Init()
	arg0:sendNotification(var0.EXIT_GUILD)
	pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildEvent")
	pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildBossEvent")
end

function var0.getRequests(arg0)
	return arg0.requests
end

function var0.getSortRequest(arg0)
	if not arg0.requests then
		return nil
	end

	local var0 = {}

	for iter0, iter1 in pairs(arg0.requests) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.deleteRequest(arg0, arg1)
	if not arg0.requests then
		return
	end

	arg0.requests[arg1] = nil

	arg0:sendNotification(var0.REQUEST_DELETED, arg1)
end

function var0.addMsg(arg0, arg1)
	table.insert(arg0.chatMsgs, arg1)

	if #arg0.chatMsgs > GuildConst.CHAT_LOG_MAX_COUNT then
		table.remove(arg0.chatMsgs, 1)
	end
end

function var0.getChatMsgs(arg0)
	return arg0.chatMsgs
end

function var0.GetMessagesByUniqueId(arg0, arg1)
	return _.select(arg0.chatMsgs, function(arg0)
		return arg0.uniqueId == arg1
	end)
end

function var0.UpdateMsg(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.chatMsgs) do
		if iter1:IsSame(arg1.uniqueId) then
			arg0.data[iter0] = arg1
		end
	end
end

function var0.ShouldFetchActivationEvent(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0.refreshActivationEventTime
end

function var0.AddFetchActivationEventCDTime(arg0)
	arg0.refreshActivationEventTime = GuildConst.REFRESH_ACTIVATION_EVENT_TIME + pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.AddActivationEventTimer(arg0, arg1)
	return
end

function var0.RemoveActivationEventTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.remove(arg0)
	arg0:RemoveActivationEventTimer()
end

function var0.SetRank(arg0, arg1, arg2)
	arg0.ranks[arg1] = arg2
	arg0["rankTimer" .. arg1] = pg.TimeMgr.GetInstance():GetServerTime() + 1800
end

function var0.GetRanks(arg0)
	return arg0.ranks
end

function var0.ShouldRefreshRank(arg0, arg1)
	if not arg0["rankTimer" .. arg1] or pg.TimeMgr.GetInstance():GetServerTime() >= arg0["rankTimer" .. arg1] then
		return true
	end

	return false
end

function var0.SetReports(arg0, arg1)
	arg0.reports = arg1
end

function var0.GetReports(arg0)
	return arg0.reports or {}
end

function var0.GetReportById(arg0, arg1)
	return arg0.reports[arg1]
end

function var0.AddReport(arg0, arg1)
	if not arg0.reports then
		arg0.reports = {}
	end

	arg0.reports[arg1.id] = arg1
end

function var0.GetMaxReportId(arg0)
	local var0 = arg0:GetReports()
	local var1 = 0

	for iter0, iter1 in pairs(var0) do
		if var1 < iter1.id then
			var1 = iter1.id
		end
	end

	return var1
end

function var0.AnyRepoerCanGet(arg0)
	return #arg0:GetCanGetReports() > 0
end

function var0.GetCanGetReports(arg0)
	local var0 = {}
	local var1 = arg0:GetReports()

	for iter0, iter1 in pairs(var1) do
		if iter1:CanSubmit() then
			table.insert(var0, iter1.id)
		end
	end

	return var0
end

function var0.ShouldRequestReport(arg0)
	if not arg0.requestReportTime then
		arg0.requestReportTime = 0
	end

	local function var0()
		local var0 = arg0:getRawData():GetActiveEvent()

		if var0 and var0:GetMissionFinishCnt() > 0 then
			return true
		end

		return false
	end

	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	if not arg0.reports and var0() or var1 > arg0.requestReportTime then
		arg0.requestReportTime = var1 + GuildConst.REQUEST_REPORT_CD

		return true
	end

	return false
end

function var0.ShouldRequestForamtion(arg0)
	if not arg0.requestFormationTime then
		arg0.requestFormationTime = 0
	end

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0 > arg0.requestFormationTime then
		arg0.requestFormationTime = var0 + GuildConst.REQUEST_FORMATION_CD

		return true
	end

	return false
end

function var0.GetRecommendShipsForMission(arg0, arg1)
	if arg1:IsEliteType() then
		return arg0:GetRecommendShipsForEliteMission(arg1)
	else
		local var0 = {}
		local var1 = getProxy(BayProxy):getRawData()
		local var2 = {}

		for iter0, iter1 in pairs(var1) do
			table.insert(var2, {
				id = iter1.id,
				power = iter1:getShipCombatPower(),
				nation = iter1:getNation(),
				type = iter1:getShipType(),
				level = iter1.level,
				tagList = iter1:getConfig("tag_list"),
				configId = iter1.configId,
				attrs = iter1:getProperties(),
				isActivityNpc = function()
					return iter1:isActivityNpc()
				end
			})
		end

		local var3 = arg1:GetRecommendShipNation()
		local var4 = arg1:GetRecommendShipTypes()

		table.sort(var2, CompareFuncs({
			function(arg0)
				return table.contains(var3, arg0.nation) and 0 or 1
			end,
			function(arg0)
				return table.contains(var4, arg0.type) and 0 or 1
			end,
			function(arg0)
				return -arg0.level
			end,
			function(arg0)
				return -arg0.power
			end
		}))

		for iter2, iter3 in ipairs(var2) do
			if GuildEventMediator.OnCheckMissionShip(arg1.id, var0, iter3) then
				table.insert(var0, iter3.id)
			end

			if #var0 == 4 then
				break
			end
		end

		return var0
	end
end

function var0.GetRecommendShipsForEliteMission(arg0, arg1)
	assert(arg1:IsEliteType())

	local var0 = {}
	local var1 = getProxy(BayProxy):getRawData()
	local var2 = {}
	local var3 = {}
	local var4 = {}

	for iter0, iter1 in pairs(var1) do
		local var5 = {
			id = iter1.id,
			power = iter1:getShipCombatPower(),
			nation = iter1:getNation(),
			type = iter1:getShipType(),
			level = iter1.level,
			tagList = iter1:getConfig("tag_list"),
			configId = iter1.configId,
			attrs = iter1:getProperties(),
			isActivityNpc = function()
				return iter1:isActivityNpc()
			end
		}

		if arg1:SameSquadron(var5) then
			table.insert(var3, var5)
		else
			table.insert(var4, var5)
		end
	end

	local function var6(arg0)
		if arg0 and not table.contains(var0, arg0.id) and GuildEventMediator.OnCheckMissionShip(arg1.id, var0, arg0) then
			table.insert(var0, arg0.id)
		end
	end

	local var7 = arg1:GetEffectAttr()
	local var8 = CompareFuncs({
		function(arg0)
			return arg1:MatchAttr(arg0) and 0 or 1
		end,
		function(arg0)
			return arg1:MatchNation(arg0) and 0 or 1
		end,
		function(arg0)
			return arg1:MatchShipType(arg0) and 0 or 1
		end,
		function(arg0)
			return -(arg0.attrs[var7] or 0)
		end,
		function(arg0)
			return -arg0.level
		end,
		function(arg0)
			return -arg0.power
		end
	})
	local var9 = arg1:GetSquadronTargetCnt()

	if #var3 > 0 and var9 > 0 then
		table.sort(var3, var8)

		for iter2 = 1, var9 do
			var6(var3[iter2])
		end
	end

	if #var0 < 4 and #var4 > 0 then
		table.sort(var4, var8)

		for iter3 = 1, #var4 do
			if #var0 == 4 then
				break
			end

			var6(var4[iter3])
		end
	end

	if #var0 < 4 and var9 > 0 and var9 < #var3 then
		for iter4 = var9 + 1, #var3 do
			if #var0 == 4 then
				break
			end

			var6(var3[iter4])
		end
	end

	return var0
end

function var0.ShouldShowApplyTip(arg0)
	if arg0.data and GuildMember.IsAdministrator(arg0.data:getSelfDuty()) then
		if not arg0.requests then
			return arg0.requestCount > 0
		end

		return table.getCount(arg0.requests) + arg0.requestCount > 0
	end

	return false
end

function var0.ShouldShowBattleTip(arg0)
	local var0 = arg0:getData()
	local var1 = false

	local function var2(arg0)
		if arg0 and arg0:IsParticipant() then
			local var0 = arg0:GetBossMission()

			return var0 and var0:IsActive() and var0:CanEnterBattle()
		end

		return false
	end

	local function var3()
		for iter0, iter1 in ipairs(pg.guild_operation_template.all) do
			local var0 = pg.guild_operation_template[iter1]

			if var0.level >= var0.unlock_guild_level and var0:getCapital() >= var0.consume then
				return true
			end
		end

		return false
	end

	if var0 then
		local var4 = var0:GetActiveEvent()
		local var5 = GuildMember.IsAdministrator(var0:getSelfDuty()) and var0:ShouldTipActiveEvent()

		var1 = arg0:ShouldShowMainTip() or not var4 and var5 and var3() or var4 and not arg0:GetBattleBtnRecord()

		if var4 and not var1 then
			local var6 = var4:IsParticipant()

			var1 = var6 and var4:AnyMissionCanFormation() or var2(var4) or not var6 and not var4:IsLimitedJoin()
		end
	end

	return var1
end

function var0.SetBattleBtnRecord(arg0)
	if not arg0:GetBattleBtnRecord() then
		local var0 = arg0:getRawData()

		if var0 and var0:GetActiveEvent() then
			local var1 = getProxy(PlayerProxy):getRawData()

			PlayerPrefs.SetInt("guild_battle_btn_flag" .. var1.id, 1)
			PlayerPrefs.Save()
			arg0:sendNotification(var0.BATTLE_BTN_FLAG_CHANGE)
		end
	end
end

function var0.GetBattleBtnRecord(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	return PlayerPrefs.GetInt("guild_battle_btn_flag" .. var0.id, 0) > 0
end

function var0.ShouldShowMainTip(arg0)
	local function var0()
		local var0 = getProxy(PlayerProxy):getRawData().id

		return arg0.data:getMemberById(var0):IsRecruit()
	end

	return _.any(arg0.reports or {}, function(arg0)
		return arg0:CanSubmit()
	end) and not var0()
end

function var0.ShouldShowTip(arg0)
	local var0 = {}
	local var1 = arg0:getData()

	if var1 then
		table.insert(var0, var1:ShouldShowDonateTip())
		table.insert(var0, arg0:ShouldShowApplyTip())
		table.insert(var0, var1:ShouldWeeklyTaskTip())
		table.insert(var0, var1:ShouldShowSupplyTip())
		table.insert(var0, var1:ShouldShowTechTip())

		if not LOCK_GUILD_BATTLE then
			table.insert(var0, arg0:ShouldShowBattleTip())
		end
	end

	return #var0 > 0 and _.any(var0, function(arg0)
		return arg0 == true
	end)
end

function var0.SetRefreshBossTime(arg0, arg1)
	arg0.refreshBossTime = arg1 + GuildConst.REFRESH_BOSS_TIME
end

function var0.ShouldRefreshBoss(arg0)
	local var0 = arg0:getRawData():GetActiveEvent()

	return var0 and not var0:IsExpired() and pg.TimeMgr.GetInstance():GetServerTime() >= arg0.refreshBossTime
end

function var0.ResetRefreshBossTime(arg0)
	arg0.refreshBossTime = 0
end

function var0.ShouldRefreshBossRank(arg0)
	local var0 = arg0:getRawData():GetActiveEvent()
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0 and var1 - arg0.bossRankUpdateTime >= GuildConst.REFRESH_MISSION_BOSS_RANK_TIME
end

function var0.UpdateBossRank(arg0, arg1)
	arg0.bossRanks = arg1
end

function var0.GetBossRank(arg0)
	return arg0.bossRanks
end

function var0.ResetBossRankTime(arg0)
	arg0.rankUpdateTime = 0
end

function var0.UpdateBossRankRefreshTime(arg0, arg1)
	arg0.rankUpdateTime = arg1
end

function var0.GetAdditionGuild(arg0)
	if arg0.data == nil then
		return arg0.publicGuild
	else
		return arg0.data
	end
end

function var0.SetReportRankList(arg0, arg1, arg2)
	if not arg0.reportRankList then
		arg0.reportRankList = {}
	end

	arg0.reportRankList[arg1] = arg2
end

function var0.GetReportRankList(arg0, arg1)
	if arg0.reportRankList then
		return arg0.reportRankList[arg1]
	end

	return nil
end

return var0
