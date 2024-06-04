local var0 = class("Guild", import(".base.BaseGuild"))
local var1 = pg.guild_technology_template
local var2 = pg.guild_operation_template
local var3 = true

function var0.Ctor(arg0, arg1)
	arg0.member = {}

	for iter0, iter1 in ipairs(arg1.member or {}) do
		local var0 = GuildMember.New(iter1)

		arg0.member[var0.id] = var0
	end

	arg0.logInfo = {}

	for iter2, iter3 in ipairs(arg1.log or {}) do
		local var1 = GuildLogInfo.New(iter3)

		table.insert(arg0.logInfo, var1)
	end

	arg0.events = {}

	for iter4, iter5 in ipairs(var2.all) do
		table.insert(arg0.events, GuildEvent.New({
			id = iter5
		}))
	end

	arg0:updateBaseInfo(arg1)
	arg0:updateExtraInfo(arg1)
	arg0:updateUserInfo({})

	arg0.completion = false
end

function var0.updateBaseInfo(arg0, arg1)
	local var0 = arg1.base or {}

	arg0.id = var0.id
	arg0.policy = var0.policy
	arg0.faction = var0.faction
	arg0.name = var0.name
	arg0.manifesto = var0.manifesto
	arg0.level = var0.level or 1
	arg0.memberCount = var0.member_count or 1
	arg0.announce = var0.announce or ""
	arg0.exp = var0.exp or 0
	arg0.changeFactionTime = var0.change_faction_cd or 0
	arg0.kickLeaderTime = var0.kick_leader_cd or 0
end

function var0.updateExtraInfo(arg0, arg1)
	local var0 = arg1.guild_ex or {}

	arg0.capital = var0.capital or 0

	local var1 = GuildTask.New(var0.this_weekly_tasks or {})

	arg0:updateWeeklyTask(var1)

	arg0.benefitFinishTime = var0.benefit_finish_time or 0
	arg0.lastBenefitFinishTime = var0.last_benefit_finish_time or 0
	arg0.technologyGroups = {}

	for iter0, iter1 in pairs(var1.get_id_list_by_group) do
		local var2 = GuildTechnologyGroup.New({
			id = iter0
		})

		arg0.technologyGroups[var2.id] = var2
	end

	for iter2, iter3 in ipairs(var0.technologys or {}) do
		local var3 = var1[iter3.id]

		arg0.technologyGroups[var3.group]:update(iter3)
	end

	arg0.maxMemberCntAddition = 0
	arg0.capitalLogs = {}
	arg0.requestCapitalLogTime = 0
	arg0.retreatCnt = var0.retreat_cnt or 0
	arg0.techCancelCnt = var0.tech_cancel_cnt or 0
	arg0.activeEventCnt = var0.active_event_cnt or 0
	arg0.tipActiveEventCnt = pg.guildset.operation_monthly_time.key_value
end

function var0.SetMaxMemberCntAddition(arg0, arg1)
	arg0.maxMemberCntAddition = arg1
end

function var0.updateUserInfo(arg0, arg1)
	local var0 = arg1.user_info or {}

	arg0.donateCount = var0.donate_count or 0
	arg0.benefitTime = var0.benefit_time and var0.benefit_time > 0 and var0.benefit_time or 0
	arg0.weeklyTaskFlag = var0.weekly_task_flag or 0

	arg0:setRefreshWeeklyTaskProgressTime()

	arg0.refreshCaptialTime = 0
	arg0.donateTasks = {}

	for iter0, iter1 in ipairs(var0.donate_tasks or {}) do
		local var1 = GuildDonateTask.New({
			id = iter1
		})

		table.insert(arg0.donateTasks, var1)
	end

	arg0.technologys = {}

	for iter2, iter3 in pairs(var1.get_id_list_by_group) do
		local var2 = arg0.technologyGroups[iter2]
		local var3 = GuildTechnology.New(var2)

		arg0.technologys[iter2] = var3
	end

	for iter4, iter5 in ipairs(var0.tech_id or {}) do
		local var4 = var1[iter5].group
		local var5 = arg0.technologyGroups[var4]

		arg0.technologys[var4]:Update(iter5, var5)
	end

	arg0.extraDonateCnt = var0.extra_donate or 0
	arg0.extraBattleCnt = var0.extra_operation or 0
	arg0.completion = true
end

function var0.IsCompletion(arg0)
	return arg0.completion
end

function var0.AddExtraDonateCnt(arg0, arg1)
	arg0.extraDonateCnt = arg0.extraDonateCnt + arg1
end

function var0.ReduceExtraDonateCnt(arg0, arg1)
	if arg0.extraDonateCnt <= 0 then
		return
	end

	assert(arg1 <= arg0.extraDonateCnt)

	arg0.extraDonateCnt = arg0.extraDonateCnt - arg1
end

function var0.GetExtraDonateCnt(arg0)
	return arg0.extraDonateCnt
end

function var0.AddExtraBattleCnt(arg0, arg1)
	arg0.extraBattleCnt = arg0.extraBattleCnt + arg1
end

function var0.ReduceExtraBattleCnt(arg0, arg1)
	if arg0.extraBattleCnt <= 0 then
		return
	end

	assert(arg1 <= arg0.extraBattleCnt)

	arg0.extraBattleCnt = arg0.extraBattleCnt - arg1
end

function var0.GetExtraBattleCnt(arg0)
	return arg0.extraBattleCnt
end

function var0.StartTech(arg0, arg1)
	local var0 = pg.guild_technology_template[arg1].group

	arg0.technologyGroups[var0]:Start()
end

function var0.GetEvents(arg0)
	return arg0.events
end

function var0.GetEventById(arg0, arg1)
	return _.detect(arg0.events, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.GetActiveEvent(arg0)
	return _.detect(arg0.events, function(arg0)
		return arg0:IsActive()
	end)
end

function var0.CanCancelTech(arg0)
	return arg0.techCancelCnt == 0
end

function var0.UpdateTechCancelCnt(arg0)
	arg0.techCancelCnt = arg0.techCancelCnt + 1
end

function var0.ResetTechCancelCnt(arg0)
	arg0.techCancelCnt = 0
end

function var0.shouldRefreshCaptial(arg0)
	return arg0.refreshCaptialTime < pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.setRefreshCaptialTime(arg0)
	arg0.refreshCaptialTime = pg.TimeMgr.GetInstance():GetServerTime() + GuildConst.REFRESH_CAPITAL_TIME
end

function var0.shouldRefreshWeeklyTaskProgress(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.weeklyTaskNextRefreshTime
end

function var0.setRefreshWeeklyTaskProgressTime(arg0)
	arg0.weeklyTaskNextRefreshTime = pg.TimeMgr.GetInstance():GetServerTime() + GuildConst.WEEKLY_TASK_PROGRESS_REFRESH_TIME
end

function var0.hasWeeklyTaskFlag(arg0)
	return arg0.weeklyTaskFlag ~= 0
end

function var0.setWeeklyTaskFlag(arg0, arg1)
	arg0.weeklyTaskFlag = arg1
end

function var0.getTechnologyGroups(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.technologyGroups) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.getTechnologyGroupById(arg0, arg1)
	return arg0.technologyGroups[arg1]
end

function var0.getActiveTechnologyGroup(arg0)
	for iter0, iter1 in pairs(arg0.technologyGroups) do
		if iter1:isStarting() then
			return iter1
		end
	end
end

function var0.GetTechnologys(arg0)
	return arg0.technologys
end

function var0.getTechnologyById(arg0, arg1)
	return arg0.technologys[arg1]
end

function var0.getTechnologys(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.technologys) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.getSupplyConsume(arg0)
	local var0 = pg.guildset.guild_award_consume.key_value
	local var1 = arg0:getSupplyDuration()

	return var0, math.ceil(var1 / 86400)
end

function var0.getSupplyAwardId(arg0)
	return pg.guildset.guild_award_id.key_value
end

function var0.updateSupplyTime(arg0, arg1)
	arg0.benefitTime = arg1
end

function var0.getSupplyCnt(arg0)
	local var0 = 0
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0.benefitFinishTime > 0 then
		var1 = math.min(arg0.benefitFinishTime, var1)
	end

	local var2 = arg0:getSupplyStartTime()

	if arg0.benefitTime == 0 or var2 > arg0.benefitTime then
		var0 = math.ceil((var1 - var2) / 86400)
	else
		local var3 = math.max(0, var1 - arg0.benefitTime)

		var0 = math.floor(var3 / 86400)
	end

	local var4 = arg0:getMemberById(getProxy(PlayerProxy):getRawData().id):GetJoinZeroTime()

	if arg0.lastBenefitFinishTime > 0 and arg0.lastBenefitFinishTime > arg0.benefitTime and var4 <= arg0.lastBenefitFinishTime then
		local var5 = arg0.benefitTime <= 0 and var4 or arg0.benefitTime

		var0 = math.ceil((arg0.lastBenefitFinishTime - var5) / 86400) + var0
	end

	return math.min(var0, GuildConst.MAX_SUPPLY_CNT)
end

function var0.startSupply(arg0, arg1)
	arg0.benefitFinishTime = arg1
end

function var0.GetSupplyEndTime(arg0)
	return arg0.benefitFinishTime
end

function var0.getSupplyLeftCnt(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return math.floor((arg0.benefitFinishTime - var0) / 86400)
end

function var0.getSupplyDuration(arg0)
	return pg.guildset.guild_award_duration.key_value
end

function var0.getSupplyStartTime(arg0)
	local var0 = arg0.benefitFinishTime - arg0:getSupplyDuration() + 1
	local var1 = arg0:getMemberById(getProxy(PlayerProxy):getRawData().id):GetJoinZeroTime()

	if var0 < var1 then
		return var1
	else
		return var0
	end
end

function var0.ExistSupply(arg0)
	return arg0.benefitFinishTime > 0 and arg0.benefitFinishTime > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.isOpenedSupply(arg0)
	return arg0.benefitFinishTime > 0 and (arg0.benefitFinishTime > pg.TimeMgr.GetInstance():GetServerTime() or arg0:getSupplyCnt() > 0)
end

function var0.getSelectableWeeklyTasks(arg0)
	local var0 = {}

	if GuildMember.IsAdministrator(arg0:getSelfDuty()) then
		local var1 = pg.guild_mission_template

		for iter0, iter1 in ipairs(var1.all) do
			local var2 = GuildTask.New({
				progress = 0,
				id = iter1
			})

			table.insert(var0, var2)
		end
	end

	return var0
end

function var0.shouldRequestCapitalLog(arg0)
	if pg.TimeMgr.GetInstance():GetServerTime() - arg0.requestCapitalLogTime > GuildConst.REQUEST_LOG_TIME then
		return true
	end

	return false
end

function var0.updateCapitalLogs(arg0, arg1)
	arg0.capitalLogs = arg1
	arg0.requestCapitalLogTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.getCapitalLogs(arg0)
	return arg0.capitalLogs
end

function var0.getMaxDonateCnt(arg0)
	return pg.guildset.contribution_task_num.key_value
end

function var0.getRemainDonateCnt(arg0)
	return arg0:getMaxDonateCnt() - arg0.donateCount
end

function var0.updateDonateCount(arg0)
	if arg0:getRemainDonateCnt() > 0 then
		arg0.donateCount = arg0.donateCount + 1
	else
		arg0:ReduceExtraDonateCnt(1)
	end
end

function var0.canDonate(arg0)
	return arg0:getRemainDonateCnt() > 0 or arg0.extraDonateCnt > 0
end

function var0.getDonateTasks(arg0)
	return arg0.donateTasks
end

function var0.updateDonateTasks(arg0, arg1)
	arg0.donateTasks = arg1
end

function var0.getDonateTaskById(arg0, arg1)
	return _.detect(arg0.donateTasks, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.updateWeeklyTask(arg0, arg1)
	arg0.weeklyTask = arg1
end

function var0.getWeeklyTask(arg0)
	return arg0.weeklyTask
end

function var0.GetActiveWeeklyTask(arg0)
	if arg0.weeklyTask and arg0.weeklyTask.id ~= 0 then
		return arg0.weeklyTask
	end

	return nil
end

function var0.addCapital(arg0, arg1)
	arg0:updateCapital(arg0.capital + arg1)
end

function var0.updateCapital(arg0, arg1)
	arg0.capital = arg1
end

function var0.consumeCapital(arg0, arg1)
	arg0:updateCapital(arg0.capital - arg1)
end

function var0.getCapital(arg0)
	return arg0.capital
end

function var0.setkickLeaderTime(arg0, arg1)
	arg0.kickLeaderTime = arg1
end

function var0.getKickLeftTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0.kickLeaderTime - var0
end

function var0.inKickTime(arg0)
	return arg0.kickLeaderTime ~= 0
end

function var0.getAssistantMaxCount(arg0)
	return pg.guild_data_level[arg0.level].assistant_commander
end

function var0.getAssistantCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.member) do
		if iter1.duty == GuildConst.DUTY_DEPUTY_COMMANDER then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.setMemberCount(arg0, arg1)
	arg0.memberCount = arg1
end

function var0.getSortMember(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.member) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.getBgName(arg0)
	if arg0.faction == GuildConst.FACTION_TYPE_BLHX then
		return "bg/bg_guild_blue_n"
	elseif arg0.faction == GuildConst.FACTION_TYPE_CSZZ then
		return "bg/bg_guild_red_n"
	end
end

function var0.addLog(arg0, arg1)
	table.insert(arg0.logInfo, 1, arg1)

	if #arg0.logInfo > 100 then
		table.remove(arg0.logInfo, #arg0.logInfo)
	end
end

function var0.getLogs(arg0)
	return arg0.logInfo
end

function var0.getMemberById(arg0, arg1)
	return arg0.member[arg1]
end

function var0.updateMember(arg0, arg1)
	arg0.member[arg1.id] = arg1
end

function var0.addMember(arg0, arg1)
	arg0.member[arg1.id] = arg1
end

function var0.deleteMember(arg0, arg1)
	arg0.member[arg1] = nil
end

function var0.getDutyByMemberId(arg0, arg1)
	for iter0, iter1 in pairs(arg0.member) do
		if iter1.id == arg1 then
			return iter1.duty
		end
	end
end

function var0.setId(arg0, arg1)
	arg0.id = arg1
end

function var0.setName(arg0, arg1)
	arg0.name = arg1
end

function var0.getPolicyName(arg0)
	return GuildConst.POLICY_NAME[arg0.policy]
end

function var0.getFactionName(arg0)
	return GuildConst.FACTION_NAME[arg0.faction]
end

function var0.getName(arg0)
	return arg0.name
end

function var0.setPolicy(arg0, arg1)
	arg0.policy = arg1
end

function var0.getPolicy(arg0)
	return arg0.policy
end

function var0.setFaction(arg0, arg1)
	arg0.faction = arg1
end

function var0.getFaction(arg0)
	return arg0.faction
end

function var0.setManifesto(arg0, arg1)
	arg0.manifesto = arg1
end

function var0.getManifesto(arg0)
	return arg0.manifesto or ""
end

local var4 = 86400

function var0.inChangefactionTime(arg0)
	local var0 = arg0.changeFactionTime - pg.TimeMgr.GetInstance():GetServerTime()

	if arg0.changeFactionTime ~= 0 and not (var0 < 0) then
		return true
	end
end

function var0.changeFactionLeftTime(arg0)
	local var0 = arg0.changeFactionTime - pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():parseTimeFrom(var0)
end

function var0.getLevelMaxExp(arg0)
	local var0 = pg.guild_data_level

	if not var0[arg0.level] then
		return var0[var0.all[#var0.all]].exp
	else
		return var0[arg0.level].exp
	end
end

function var0.getMaxMember(arg0)
	local var0 = pg.guild_data_level
	local var1 = var0.all[#var0.all]
	local var2 = var0[math.min(arg0.level, var1)].member_num
	local var3 = arg0.maxMemberCntAddition or 0

	return var2 + arg0:GetGuildMemberCntAddition() + var3
end

function var0.updateExp(arg0, arg1)
	arg0.exp = arg1
end

function var0.updateLevel(arg0, arg1)
	arg0.level = arg1
end

function var0.getCommader(arg0)
	for iter0, iter1 in pairs(arg0.member) do
		if iter1.duty == GuildConst.DUTY_COMMANDER then
			return iter1
		end
	end
end

function var0.getCommaderName(arg0)
	local var0 = arg0:getCommader()

	if var0 then
		return var0.name
	else
		return ""
	end
end

function var0.setAnnounce(arg0, arg1)
	arg0.announce = arg1
end

function var0.GetAnnounce(arg0)
	return arg0.announce
end

function var0.getEnableDuty(arg0, arg1, arg2)
	if arg2 == GuildConst.DUTY_RECRUIT then
		return {}
	end

	local var0 = {}

	if arg1 == GuildConst.DUTY_COMMANDER then
		if arg0:getAssistantMaxCount() == arg0:getAssistantCount() then
			var0 = arg2 == GuildConst.DUTY_DEPUTY_COMMANDER and {
				GuildConst.DUTY_COMMANDER,
				GuildConst.DYTY_PICKED,
				GuildConst.DUTY_ORDINARY
			} or {
				GuildConst.DYTY_PICKED,
				GuildConst.DUTY_ORDINARY
			}
		else
			var0 = arg2 == GuildConst.DUTY_DEPUTY_COMMANDER and {
				GuildConst.DUTY_COMMANDER,
				GuildConst.DUTY_DEPUTY_COMMANDER,
				GuildConst.DYTY_PICKED,
				GuildConst.DUTY_ORDINARY
			} or {
				GuildConst.DUTY_DEPUTY_COMMANDER,
				GuildConst.DYTY_PICKED,
				GuildConst.DUTY_ORDINARY
			}
		end
	elseif arg1 == GuildConst.DUTY_DEPUTY_COMMANDER then
		var0 = {
			GuildConst.DYTY_PICKED,
			GuildConst.DUTY_ORDINARY
		}
	end

	for iter0, iter1 in ipairs(var0) do
		if iter1 == arg2 then
			table.remove(var0, iter0)

			break
		end
	end

	return var0
end

function var0.warpChatInfo(arg0, arg1)
	local var0, var1 = wordVer(arg1.content, {
		isReplace = true
	})
	local var2 = GuildMember.New(arg1.player)

	if var2 then
		local var3 = arg0:getDutyByMemberId(var2.id)

		assert(var3, "palyer duty has not been found" .. var2.id)
		var2:setDuty(var3)

		local var4

		string.gsub(var1, ChatConst.EmojiCodeMatch, function(arg0)
			var4 = tonumber(arg0)
		end)

		if var4 then
			local var5 = pg.emoji_template[var4]

			if var5 then
				var1 = var5.desc
			else
				var4 = nil
			end
		end

		return (ChatMsg.New(ChatConst.ChannelGuild, {
			player = var2,
			content = var1,
			emojiId = var4,
			timestamp = arg1.time
		}))
	end
end

function var0.getSelfDuty(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	return arg0:getDutyByMemberId(var0.id)
end

function var0.GetOfficePainting(arg0)
	local var0 = arg0:getFaction()

	if var0 == GuildConst.FACTION_TYPE_BLHX then
		return "guild_office_blue"
	elseif var0 == GuildConst.FACTION_TYPE_CSZZ then
		return "guild_office_red"
	end
end

function var0.ShouldShowDonateTip(arg0)
	return arg0:getMaxDonateCnt() > arg0.donateCount
end

function var0.ShouldWeeklyTaskTip(arg0)
	local var0 = arg0.weeklyTask:getState()

	return GuildTask.STATE_EMPTY == var0 and GuildMember.IsAdministrator(arg0:getSelfDuty())
end

function var0.ShouldShowOfficeTip(arg0)
	return arg0:ShouldShowDonateTip() or arg0:ShouldWeeklyTaskTip() or arg0:ShouldShowSupplyTip()
end

function var0.ShouldShowTechTip(arg0)
	local var0 = arg0:getActiveTechnologyGroup()

	return var0 and var0:isMaxLevel() and not arg0:IsFinishAllTechnologyGroup()
end

function var0.IsFinishAllTechnologyGroup(arg0)
	for iter0, iter1 in pairs(arg0.technologyGroups) do
		if not iter1:isMaxLevel() then
			return false
		end
	end

	return true
end

function var0.ShouldShowSupplyTip(arg0)
	local function var0()
		local var0 = getProxy(PlayerProxy):getRawData().id
		local var1 = arg0:getMemberById(var0)

		return not var1:IsRecruit() and not var1:isNewMember()
	end

	local var1 = arg0:getSupplyCnt()

	return arg0:isOpenedSupply() and var1 > 0 and var0()
end

function var0.GetMembers(arg0)
	return arg0.member
end

function var0.GetAllAssaultShip(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.member) do
		local var1 = iter1:GetAssaultFleet():GetShipList()

		for iter2, iter3 in ipairs(var1) do
			table.insert(var0, iter3)
		end
	end

	return var0
end

function var0.GetRecomForBossEvent(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.member) do
		if not table.contains(arg3, iter1.id) then
			local var1 = iter1:GetAssaultFleet():GetStrongestShip(arg1)

			if var1 then
				table.insert(var0, var1)
			end
		end
	end

	table.sort(var0, function(arg0, arg1)
		return arg0.level > arg1.level
	end)

	return _.slice(var0, 1, math.min(arg2, #var0))
end

function var0.GetMemberShips(arg0, arg1)
	local var0 = {}
	local var1 = {}
	local var2 = getProxy(PlayerProxy):getRawData().id

	local function var3(arg0)
		return var2 == arg0.id
	end

	for iter0, iter1 in pairs(arg0.member) do
		local var4 = iter1:GetShip()
		local var5 = iter1:IsCommander()

		var4.isCommander = var5

		if var5 or var3(iter1) then
			table.insert(var1, var4)
		else
			table.insert(var0, var4)
		end
	end

	for iter2 = 1, arg1 do
		if #var1 == arg1 then
			break
		end

		local var6 = var0[iter2]

		if var6 then
			table.insert(var1, var6)
		end
	end

	return var1
end

function var0.IsAdministrator(arg0)
	return GuildMember.IsAdministrator(arg0:getSelfDuty())
end

function var0.GetMissionAndAssultFleetShips(arg0)
	local var0 = {}
	local var1 = arg0:GetActiveEvent()

	if var1 and not var1:IsExpired() then
		local var2 = var1:GetJoinShips()

		for iter0, iter1 in ipairs(var2) do
			table.insert(var0, iter1)
		end
	end

	local var3 = getProxy(PlayerProxy):getRawData().id
	local var4 = arg0.member[var3]
	local var5 = var4:GetAssaultFleet()
	local var6 = var4:GetExternalAssaultFleet()
	local var7 = var5:GetShipList()

	for iter2, iter3 in pairs(var7) do
		local var8 = GuildAssaultFleet.GetRealId(iter3.id)

		table.insert(var0, var8)
	end

	local var9 = var6:GetShipList()

	for iter4, iter5 in pairs(var9) do
		local var10 = GuildAssaultFleet.GetRealId(iter5.id)

		table.insert(var0, var10)
	end

	return var0
end

function var0.GetBossMissionShips(arg0)
	local var0 = {}
	local var1 = arg0:GetActiveEvent()

	if var1 and not var1:IsExpired() then
		local var2 = var1:GetBossShipIds()

		for iter0, iter1 in ipairs(var2) do
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.ExistCommander(arg0, arg1)
	local var0 = arg0:GetActiveEvent()

	if var0 then
		local var1 = var0:GetBossMission()

		return var1:IsActive() and var1:ExistCommander(arg1)
	end

	return false
end

function var0.IncActiveEventCnt(arg0)
	arg0.activeEventCnt = arg0.activeEventCnt + 1
end

function var0.ResetActiveEventCnt(arg0)
	arg0.activeEventCnt = 0
end

function var0.ShouldTipActiveEvent(arg0)
	return arg0.activeEventCnt + 1 <= arg0.tipActiveEventCnt
end

function var0.GetActiveEventCnt(arg0)
	return arg0.activeEventCnt
end

return var0
