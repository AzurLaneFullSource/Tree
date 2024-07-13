local var0_0 = class("Guild", import(".base.BaseGuild"))
local var1_0 = pg.guild_technology_template
local var2_0 = pg.guild_operation_template
local var3_0 = true

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.member = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.member or {}) do
		local var0_1 = GuildMember.New(iter1_1)

		arg0_1.member[var0_1.id] = var0_1
	end

	arg0_1.logInfo = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.log or {}) do
		local var1_1 = GuildLogInfo.New(iter3_1)

		table.insert(arg0_1.logInfo, var1_1)
	end

	arg0_1.events = {}

	for iter4_1, iter5_1 in ipairs(var2_0.all) do
		table.insert(arg0_1.events, GuildEvent.New({
			id = iter5_1
		}))
	end

	arg0_1:updateBaseInfo(arg1_1)
	arg0_1:updateExtraInfo(arg1_1)
	arg0_1:updateUserInfo({})

	arg0_1.completion = false
end

function var0_0.updateBaseInfo(arg0_2, arg1_2)
	local var0_2 = arg1_2.base or {}

	arg0_2.id = var0_2.id
	arg0_2.policy = var0_2.policy
	arg0_2.faction = var0_2.faction
	arg0_2.name = var0_2.name
	arg0_2.manifesto = var0_2.manifesto
	arg0_2.level = var0_2.level or 1
	arg0_2.memberCount = var0_2.member_count or 1
	arg0_2.announce = var0_2.announce or ""
	arg0_2.exp = var0_2.exp or 0
	arg0_2.changeFactionTime = var0_2.change_faction_cd or 0
	arg0_2.kickLeaderTime = var0_2.kick_leader_cd or 0
end

function var0_0.updateExtraInfo(arg0_3, arg1_3)
	local var0_3 = arg1_3.guild_ex or {}

	arg0_3.capital = var0_3.capital or 0

	local var1_3 = GuildTask.New(var0_3.this_weekly_tasks or {})

	arg0_3:updateWeeklyTask(var1_3)

	arg0_3.benefitFinishTime = var0_3.benefit_finish_time or 0
	arg0_3.lastBenefitFinishTime = var0_3.last_benefit_finish_time or 0
	arg0_3.technologyGroups = {}

	for iter0_3, iter1_3 in pairs(var1_0.get_id_list_by_group) do
		local var2_3 = GuildTechnologyGroup.New({
			id = iter0_3
		})

		arg0_3.technologyGroups[var2_3.id] = var2_3
	end

	for iter2_3, iter3_3 in ipairs(var0_3.technologys or {}) do
		local var3_3 = var1_0[iter3_3.id]

		arg0_3.technologyGroups[var3_3.group]:update(iter3_3)
	end

	arg0_3.maxMemberCntAddition = 0
	arg0_3.capitalLogs = {}
	arg0_3.requestCapitalLogTime = 0
	arg0_3.retreatCnt = var0_3.retreat_cnt or 0
	arg0_3.techCancelCnt = var0_3.tech_cancel_cnt or 0
	arg0_3.activeEventCnt = var0_3.active_event_cnt or 0
	arg0_3.tipActiveEventCnt = pg.guildset.operation_monthly_time.key_value
end

function var0_0.SetMaxMemberCntAddition(arg0_4, arg1_4)
	arg0_4.maxMemberCntAddition = arg1_4
end

function var0_0.updateUserInfo(arg0_5, arg1_5)
	local var0_5 = arg1_5.user_info or {}

	arg0_5.donateCount = var0_5.donate_count or 0
	arg0_5.benefitTime = var0_5.benefit_time and var0_5.benefit_time > 0 and var0_5.benefit_time or 0
	arg0_5.weeklyTaskFlag = var0_5.weekly_task_flag or 0

	arg0_5:setRefreshWeeklyTaskProgressTime()

	arg0_5.refreshCaptialTime = 0
	arg0_5.donateTasks = {}

	for iter0_5, iter1_5 in ipairs(var0_5.donate_tasks or {}) do
		local var1_5 = GuildDonateTask.New({
			id = iter1_5
		})

		table.insert(arg0_5.donateTasks, var1_5)
	end

	arg0_5.technologys = {}

	for iter2_5, iter3_5 in pairs(var1_0.get_id_list_by_group) do
		local var2_5 = arg0_5.technologyGroups[iter2_5]
		local var3_5 = GuildTechnology.New(var2_5)

		arg0_5.technologys[iter2_5] = var3_5
	end

	for iter4_5, iter5_5 in ipairs(var0_5.tech_id or {}) do
		local var4_5 = var1_0[iter5_5].group
		local var5_5 = arg0_5.technologyGroups[var4_5]

		arg0_5.technologys[var4_5]:Update(iter5_5, var5_5)
	end

	arg0_5.extraDonateCnt = var0_5.extra_donate or 0
	arg0_5.extraBattleCnt = var0_5.extra_operation or 0
	arg0_5.completion = true
end

function var0_0.IsCompletion(arg0_6)
	return arg0_6.completion
end

function var0_0.AddExtraDonateCnt(arg0_7, arg1_7)
	arg0_7.extraDonateCnt = arg0_7.extraDonateCnt + arg1_7
end

function var0_0.ReduceExtraDonateCnt(arg0_8, arg1_8)
	if arg0_8.extraDonateCnt <= 0 then
		return
	end

	assert(arg1_8 <= arg0_8.extraDonateCnt)

	arg0_8.extraDonateCnt = arg0_8.extraDonateCnt - arg1_8
end

function var0_0.GetExtraDonateCnt(arg0_9)
	return arg0_9.extraDonateCnt
end

function var0_0.AddExtraBattleCnt(arg0_10, arg1_10)
	arg0_10.extraBattleCnt = arg0_10.extraBattleCnt + arg1_10
end

function var0_0.ReduceExtraBattleCnt(arg0_11, arg1_11)
	if arg0_11.extraBattleCnt <= 0 then
		return
	end

	assert(arg1_11 <= arg0_11.extraBattleCnt)

	arg0_11.extraBattleCnt = arg0_11.extraBattleCnt - arg1_11
end

function var0_0.GetExtraBattleCnt(arg0_12)
	return arg0_12.extraBattleCnt
end

function var0_0.StartTech(arg0_13, arg1_13)
	local var0_13 = pg.guild_technology_template[arg1_13].group

	arg0_13.technologyGroups[var0_13]:Start()
end

function var0_0.GetEvents(arg0_14)
	return arg0_14.events
end

function var0_0.GetEventById(arg0_15, arg1_15)
	return _.detect(arg0_15.events, function(arg0_16)
		return arg0_16.id == arg1_15
	end)
end

function var0_0.GetActiveEvent(arg0_17)
	return _.detect(arg0_17.events, function(arg0_18)
		return arg0_18:IsActive()
	end)
end

function var0_0.CanCancelTech(arg0_19)
	return arg0_19.techCancelCnt == 0
end

function var0_0.UpdateTechCancelCnt(arg0_20)
	arg0_20.techCancelCnt = arg0_20.techCancelCnt + 1
end

function var0_0.ResetTechCancelCnt(arg0_21)
	arg0_21.techCancelCnt = 0
end

function var0_0.shouldRefreshCaptial(arg0_22)
	return arg0_22.refreshCaptialTime < pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.setRefreshCaptialTime(arg0_23)
	arg0_23.refreshCaptialTime = pg.TimeMgr.GetInstance():GetServerTime() + GuildConst.REFRESH_CAPITAL_TIME
end

function var0_0.shouldRefreshWeeklyTaskProgress(arg0_24)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_24.weeklyTaskNextRefreshTime
end

function var0_0.setRefreshWeeklyTaskProgressTime(arg0_25)
	arg0_25.weeklyTaskNextRefreshTime = pg.TimeMgr.GetInstance():GetServerTime() + GuildConst.WEEKLY_TASK_PROGRESS_REFRESH_TIME
end

function var0_0.hasWeeklyTaskFlag(arg0_26)
	return arg0_26.weeklyTaskFlag ~= 0
end

function var0_0.setWeeklyTaskFlag(arg0_27, arg1_27)
	arg0_27.weeklyTaskFlag = arg1_27
end

function var0_0.getTechnologyGroups(arg0_28)
	local var0_28 = {}

	for iter0_28, iter1_28 in pairs(arg0_28.technologyGroups) do
		table.insert(var0_28, iter1_28)
	end

	return var0_28
end

function var0_0.getTechnologyGroupById(arg0_29, arg1_29)
	return arg0_29.technologyGroups[arg1_29]
end

function var0_0.getActiveTechnologyGroup(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.technologyGroups) do
		if iter1_30:isStarting() then
			return iter1_30
		end
	end
end

function var0_0.GetTechnologys(arg0_31)
	return arg0_31.technologys
end

function var0_0.getTechnologyById(arg0_32, arg1_32)
	return arg0_32.technologys[arg1_32]
end

function var0_0.getTechnologys(arg0_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.technologys) do
		table.insert(var0_33, iter1_33)
	end

	return var0_33
end

function var0_0.getSupplyConsume(arg0_34)
	local var0_34 = pg.guildset.guild_award_consume.key_value
	local var1_34 = arg0_34:getSupplyDuration()

	return var0_34, math.ceil(var1_34 / 86400)
end

function var0_0.getSupplyAwardId(arg0_35)
	return pg.guildset.guild_award_id.key_value
end

function var0_0.updateSupplyTime(arg0_36, arg1_36)
	arg0_36.benefitTime = arg1_36
end

function var0_0.getSupplyCnt(arg0_37)
	local var0_37 = 0
	local var1_37 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_37.benefitFinishTime > 0 then
		var1_37 = math.min(arg0_37.benefitFinishTime, var1_37)
	end

	local var2_37 = arg0_37:getSupplyStartTime()

	if arg0_37.benefitTime == 0 or var2_37 > arg0_37.benefitTime then
		var0_37 = math.ceil((var1_37 - var2_37) / 86400)
	else
		local var3_37 = math.max(0, var1_37 - arg0_37.benefitTime)

		var0_37 = math.floor(var3_37 / 86400)
	end

	local var4_37 = arg0_37:getMemberById(getProxy(PlayerProxy):getRawData().id):GetJoinZeroTime()

	if arg0_37.lastBenefitFinishTime > 0 and arg0_37.lastBenefitFinishTime > arg0_37.benefitTime and var4_37 <= arg0_37.lastBenefitFinishTime then
		local var5_37 = arg0_37.benefitTime <= 0 and var4_37 or arg0_37.benefitTime

		var0_37 = math.ceil((arg0_37.lastBenefitFinishTime - var5_37) / 86400) + var0_37
	end

	return math.min(var0_37, GuildConst.MAX_SUPPLY_CNT)
end

function var0_0.startSupply(arg0_38, arg1_38)
	arg0_38.benefitFinishTime = arg1_38
end

function var0_0.GetSupplyEndTime(arg0_39)
	return arg0_39.benefitFinishTime
end

function var0_0.getSupplyLeftCnt(arg0_40)
	local var0_40 = pg.TimeMgr.GetInstance():GetServerTime()

	return math.floor((arg0_40.benefitFinishTime - var0_40) / 86400)
end

function var0_0.getSupplyDuration(arg0_41)
	return pg.guildset.guild_award_duration.key_value
end

function var0_0.getSupplyStartTime(arg0_42)
	local var0_42 = arg0_42.benefitFinishTime - arg0_42:getSupplyDuration() + 1
	local var1_42 = arg0_42:getMemberById(getProxy(PlayerProxy):getRawData().id):GetJoinZeroTime()

	if var0_42 < var1_42 then
		return var1_42
	else
		return var0_42
	end
end

function var0_0.ExistSupply(arg0_43)
	return arg0_43.benefitFinishTime > 0 and arg0_43.benefitFinishTime > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.isOpenedSupply(arg0_44)
	return arg0_44.benefitFinishTime > 0 and (arg0_44.benefitFinishTime > pg.TimeMgr.GetInstance():GetServerTime() or arg0_44:getSupplyCnt() > 0)
end

function var0_0.getSelectableWeeklyTasks(arg0_45)
	local var0_45 = {}

	if GuildMember.IsAdministrator(arg0_45:getSelfDuty()) then
		local var1_45 = pg.guild_mission_template

		for iter0_45, iter1_45 in ipairs(var1_45.all) do
			local var2_45 = GuildTask.New({
				progress = 0,
				id = iter1_45
			})

			table.insert(var0_45, var2_45)
		end
	end

	return var0_45
end

function var0_0.shouldRequestCapitalLog(arg0_46)
	if pg.TimeMgr.GetInstance():GetServerTime() - arg0_46.requestCapitalLogTime > GuildConst.REQUEST_LOG_TIME then
		return true
	end

	return false
end

function var0_0.updateCapitalLogs(arg0_47, arg1_47)
	arg0_47.capitalLogs = arg1_47
	arg0_47.requestCapitalLogTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.getCapitalLogs(arg0_48)
	return arg0_48.capitalLogs
end

function var0_0.getMaxDonateCnt(arg0_49)
	return pg.guildset.contribution_task_num.key_value
end

function var0_0.getRemainDonateCnt(arg0_50)
	return arg0_50:getMaxDonateCnt() - arg0_50.donateCount
end

function var0_0.updateDonateCount(arg0_51)
	if arg0_51:getRemainDonateCnt() > 0 then
		arg0_51.donateCount = arg0_51.donateCount + 1
	else
		arg0_51:ReduceExtraDonateCnt(1)
	end
end

function var0_0.canDonate(arg0_52)
	return arg0_52:getRemainDonateCnt() > 0 or arg0_52.extraDonateCnt > 0
end

function var0_0.getDonateTasks(arg0_53)
	return arg0_53.donateTasks
end

function var0_0.updateDonateTasks(arg0_54, arg1_54)
	arg0_54.donateTasks = arg1_54
end

function var0_0.getDonateTaskById(arg0_55, arg1_55)
	return _.detect(arg0_55.donateTasks, function(arg0_56)
		return arg0_56.id == arg1_55
	end)
end

function var0_0.updateWeeklyTask(arg0_57, arg1_57)
	arg0_57.weeklyTask = arg1_57
end

function var0_0.getWeeklyTask(arg0_58)
	return arg0_58.weeklyTask
end

function var0_0.GetActiveWeeklyTask(arg0_59)
	if arg0_59.weeklyTask and arg0_59.weeklyTask.id ~= 0 then
		return arg0_59.weeklyTask
	end

	return nil
end

function var0_0.addCapital(arg0_60, arg1_60)
	arg0_60:updateCapital(arg0_60.capital + arg1_60)
end

function var0_0.updateCapital(arg0_61, arg1_61)
	arg0_61.capital = arg1_61
end

function var0_0.consumeCapital(arg0_62, arg1_62)
	arg0_62:updateCapital(arg0_62.capital - arg1_62)
end

function var0_0.getCapital(arg0_63)
	return arg0_63.capital
end

function var0_0.setkickLeaderTime(arg0_64, arg1_64)
	arg0_64.kickLeaderTime = arg1_64
end

function var0_0.getKickLeftTime(arg0_65)
	local var0_65 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_65.kickLeaderTime - var0_65
end

function var0_0.inKickTime(arg0_66)
	return arg0_66.kickLeaderTime ~= 0
end

function var0_0.getAssistantMaxCount(arg0_67)
	return pg.guild_data_level[arg0_67.level].assistant_commander
end

function var0_0.getAssistantCount(arg0_68)
	local var0_68 = 0

	for iter0_68, iter1_68 in pairs(arg0_68.member) do
		if iter1_68.duty == GuildConst.DUTY_DEPUTY_COMMANDER then
			var0_68 = var0_68 + 1
		end
	end

	return var0_68
end

function var0_0.setMemberCount(arg0_69, arg1_69)
	arg0_69.memberCount = arg1_69
end

function var0_0.getSortMember(arg0_70)
	local var0_70 = {}

	for iter0_70, iter1_70 in pairs(arg0_70.member) do
		table.insert(var0_70, iter1_70)
	end

	return var0_70
end

function var0_0.getBgName(arg0_71)
	if arg0_71.faction == GuildConst.FACTION_TYPE_BLHX then
		return "bg/bg_guild_blue_n"
	elseif arg0_71.faction == GuildConst.FACTION_TYPE_CSZZ then
		return "bg/bg_guild_red_n"
	end
end

function var0_0.addLog(arg0_72, arg1_72)
	table.insert(arg0_72.logInfo, 1, arg1_72)

	if #arg0_72.logInfo > 100 then
		table.remove(arg0_72.logInfo, #arg0_72.logInfo)
	end
end

function var0_0.getLogs(arg0_73)
	return arg0_73.logInfo
end

function var0_0.getMemberById(arg0_74, arg1_74)
	return arg0_74.member[arg1_74]
end

function var0_0.updateMember(arg0_75, arg1_75)
	arg0_75.member[arg1_75.id] = arg1_75
end

function var0_0.addMember(arg0_76, arg1_76)
	arg0_76.member[arg1_76.id] = arg1_76
end

function var0_0.deleteMember(arg0_77, arg1_77)
	arg0_77.member[arg1_77] = nil
end

function var0_0.getDutyByMemberId(arg0_78, arg1_78)
	for iter0_78, iter1_78 in pairs(arg0_78.member) do
		if iter1_78.id == arg1_78 then
			return iter1_78.duty
		end
	end
end

function var0_0.setId(arg0_79, arg1_79)
	arg0_79.id = arg1_79
end

function var0_0.setName(arg0_80, arg1_80)
	arg0_80.name = arg1_80
end

function var0_0.getPolicyName(arg0_81)
	return GuildConst.POLICY_NAME[arg0_81.policy]
end

function var0_0.getFactionName(arg0_82)
	return GuildConst.FACTION_NAME[arg0_82.faction]
end

function var0_0.getName(arg0_83)
	return arg0_83.name
end

function var0_0.setPolicy(arg0_84, arg1_84)
	arg0_84.policy = arg1_84
end

function var0_0.getPolicy(arg0_85)
	return arg0_85.policy
end

function var0_0.setFaction(arg0_86, arg1_86)
	arg0_86.faction = arg1_86
end

function var0_0.getFaction(arg0_87)
	return arg0_87.faction
end

function var0_0.setManifesto(arg0_88, arg1_88)
	arg0_88.manifesto = arg1_88
end

function var0_0.getManifesto(arg0_89)
	return arg0_89.manifesto or ""
end

local var4_0 = 86400

function var0_0.inChangefactionTime(arg0_90)
	local var0_90 = arg0_90.changeFactionTime - pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_90.changeFactionTime ~= 0 and not (var0_90 < 0) then
		return true
	end
end

function var0_0.changeFactionLeftTime(arg0_91)
	local var0_91 = arg0_91.changeFactionTime - pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():parseTimeFrom(var0_91)
end

function var0_0.getLevelMaxExp(arg0_92)
	local var0_92 = pg.guild_data_level

	if not var0_92[arg0_92.level] then
		return var0_92[var0_92.all[#var0_92.all]].exp
	else
		return var0_92[arg0_92.level].exp
	end
end

function var0_0.getMaxMember(arg0_93)
	local var0_93 = pg.guild_data_level
	local var1_93 = var0_93.all[#var0_93.all]
	local var2_93 = var0_93[math.min(arg0_93.level, var1_93)].member_num
	local var3_93 = arg0_93.maxMemberCntAddition or 0

	return var2_93 + arg0_93:GetGuildMemberCntAddition() + var3_93
end

function var0_0.updateExp(arg0_94, arg1_94)
	arg0_94.exp = arg1_94
end

function var0_0.updateLevel(arg0_95, arg1_95)
	arg0_95.level = arg1_95
end

function var0_0.getCommader(arg0_96)
	for iter0_96, iter1_96 in pairs(arg0_96.member) do
		if iter1_96.duty == GuildConst.DUTY_COMMANDER then
			return iter1_96
		end
	end
end

function var0_0.getCommaderName(arg0_97)
	local var0_97 = arg0_97:getCommader()

	if var0_97 then
		return var0_97.name
	else
		return ""
	end
end

function var0_0.setAnnounce(arg0_98, arg1_98)
	arg0_98.announce = arg1_98
end

function var0_0.GetAnnounce(arg0_99)
	return arg0_99.announce
end

function var0_0.getEnableDuty(arg0_100, arg1_100, arg2_100)
	if arg2_100 == GuildConst.DUTY_RECRUIT then
		return {}
	end

	local var0_100 = {}

	if arg1_100 == GuildConst.DUTY_COMMANDER then
		if arg0_100:getAssistantMaxCount() == arg0_100:getAssistantCount() then
			var0_100 = arg2_100 == GuildConst.DUTY_DEPUTY_COMMANDER and {
				GuildConst.DUTY_COMMANDER,
				GuildConst.DYTY_PICKED,
				GuildConst.DUTY_ORDINARY
			} or {
				GuildConst.DYTY_PICKED,
				GuildConst.DUTY_ORDINARY
			}
		else
			var0_100 = arg2_100 == GuildConst.DUTY_DEPUTY_COMMANDER and {
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
	elseif arg1_100 == GuildConst.DUTY_DEPUTY_COMMANDER then
		var0_100 = {
			GuildConst.DYTY_PICKED,
			GuildConst.DUTY_ORDINARY
		}
	end

	for iter0_100, iter1_100 in ipairs(var0_100) do
		if iter1_100 == arg2_100 then
			table.remove(var0_100, iter0_100)

			break
		end
	end

	return var0_100
end

function var0_0.warpChatInfo(arg0_101, arg1_101)
	local var0_101, var1_101 = wordVer(arg1_101.content, {
		isReplace = true
	})
	local var2_101 = GuildMember.New(arg1_101.player)

	if var2_101 then
		local var3_101 = arg0_101:getDutyByMemberId(var2_101.id)

		assert(var3_101, "palyer duty has not been found" .. var2_101.id)
		var2_101:setDuty(var3_101)

		local var4_101

		string.gsub(var1_101, ChatConst.EmojiCodeMatch, function(arg0_102)
			var4_101 = tonumber(arg0_102)
		end)

		if var4_101 then
			local var5_101 = pg.emoji_template[var4_101]

			if var5_101 then
				var1_101 = var5_101.desc
			else
				var4_101 = nil
			end
		end

		return (ChatMsg.New(ChatConst.ChannelGuild, {
			player = var2_101,
			content = var1_101,
			emojiId = var4_101,
			timestamp = arg1_101.time
		}))
	end
end

function var0_0.getSelfDuty(arg0_103)
	local var0_103 = getProxy(PlayerProxy):getRawData()

	return arg0_103:getDutyByMemberId(var0_103.id)
end

function var0_0.GetOfficePainting(arg0_104)
	local var0_104 = arg0_104:getFaction()

	if var0_104 == GuildConst.FACTION_TYPE_BLHX then
		return "guild_office_blue"
	elseif var0_104 == GuildConst.FACTION_TYPE_CSZZ then
		return "guild_office_red"
	end
end

function var0_0.ShouldShowDonateTip(arg0_105)
	return arg0_105:getMaxDonateCnt() > arg0_105.donateCount
end

function var0_0.ShouldWeeklyTaskTip(arg0_106)
	local var0_106 = arg0_106.weeklyTask:getState()

	return GuildTask.STATE_EMPTY == var0_106 and GuildMember.IsAdministrator(arg0_106:getSelfDuty())
end

function var0_0.ShouldShowOfficeTip(arg0_107)
	return arg0_107:ShouldShowDonateTip() or arg0_107:ShouldWeeklyTaskTip() or arg0_107:ShouldShowSupplyTip()
end

function var0_0.ShouldShowTechTip(arg0_108)
	local var0_108 = arg0_108:getActiveTechnologyGroup()

	return var0_108 and var0_108:isMaxLevel() and not arg0_108:IsFinishAllTechnologyGroup()
end

function var0_0.IsFinishAllTechnologyGroup(arg0_109)
	for iter0_109, iter1_109 in pairs(arg0_109.technologyGroups) do
		if not iter1_109:isMaxLevel() then
			return false
		end
	end

	return true
end

function var0_0.ShouldShowSupplyTip(arg0_110)
	local function var0_110()
		local var0_111 = getProxy(PlayerProxy):getRawData().id
		local var1_111 = arg0_110:getMemberById(var0_111)

		return not var1_111:IsRecruit() and not var1_111:isNewMember()
	end

	local var1_110 = arg0_110:getSupplyCnt()

	return arg0_110:isOpenedSupply() and var1_110 > 0 and var0_110()
end

function var0_0.GetMembers(arg0_112)
	return arg0_112.member
end

function var0_0.GetAllAssaultShip(arg0_113)
	local var0_113 = {}

	for iter0_113, iter1_113 in pairs(arg0_113.member) do
		local var1_113 = iter1_113:GetAssaultFleet():GetShipList()

		for iter2_113, iter3_113 in ipairs(var1_113) do
			table.insert(var0_113, iter3_113)
		end
	end

	return var0_113
end

function var0_0.GetRecomForBossEvent(arg0_114, arg1_114, arg2_114, arg3_114)
	local var0_114 = {}

	for iter0_114, iter1_114 in pairs(arg0_114.member) do
		if not table.contains(arg3_114, iter1_114.id) then
			local var1_114 = iter1_114:GetAssaultFleet():GetStrongestShip(arg1_114)

			if var1_114 then
				table.insert(var0_114, var1_114)
			end
		end
	end

	table.sort(var0_114, function(arg0_115, arg1_115)
		return arg0_115.level > arg1_115.level
	end)

	return _.slice(var0_114, 1, math.min(arg2_114, #var0_114))
end

function var0_0.GetMemberShips(arg0_116, arg1_116)
	local var0_116 = {}
	local var1_116 = {}
	local var2_116 = getProxy(PlayerProxy):getRawData().id

	local function var3_116(arg0_117)
		return var2_116 == arg0_117.id
	end

	for iter0_116, iter1_116 in pairs(arg0_116.member) do
		local var4_116 = iter1_116:GetShip()
		local var5_116 = iter1_116:IsCommander()

		var4_116.isCommander = var5_116

		if var5_116 or var3_116(iter1_116) then
			table.insert(var1_116, var4_116)
		else
			table.insert(var0_116, var4_116)
		end
	end

	for iter2_116 = 1, arg1_116 do
		if #var1_116 == arg1_116 then
			break
		end

		local var6_116 = var0_116[iter2_116]

		if var6_116 then
			table.insert(var1_116, var6_116)
		end
	end

	return var1_116
end

function var0_0.IsAdministrator(arg0_118)
	return GuildMember.IsAdministrator(arg0_118:getSelfDuty())
end

function var0_0.GetMissionAndAssultFleetShips(arg0_119)
	local var0_119 = {}
	local var1_119 = arg0_119:GetActiveEvent()

	if var1_119 and not var1_119:IsExpired() then
		local var2_119 = var1_119:GetJoinShips()

		for iter0_119, iter1_119 in ipairs(var2_119) do
			table.insert(var0_119, iter1_119)
		end
	end

	local var3_119 = getProxy(PlayerProxy):getRawData().id
	local var4_119 = arg0_119.member[var3_119]
	local var5_119 = var4_119:GetAssaultFleet()
	local var6_119 = var4_119:GetExternalAssaultFleet()
	local var7_119 = var5_119:GetShipList()

	for iter2_119, iter3_119 in pairs(var7_119) do
		local var8_119 = GuildAssaultFleet.GetRealId(iter3_119.id)

		table.insert(var0_119, var8_119)
	end

	local var9_119 = var6_119:GetShipList()

	for iter4_119, iter5_119 in pairs(var9_119) do
		local var10_119 = GuildAssaultFleet.GetRealId(iter5_119.id)

		table.insert(var0_119, var10_119)
	end

	return var0_119
end

function var0_0.GetBossMissionShips(arg0_120)
	local var0_120 = {}
	local var1_120 = arg0_120:GetActiveEvent()

	if var1_120 and not var1_120:IsExpired() then
		local var2_120 = var1_120:GetBossShipIds()

		for iter0_120, iter1_120 in ipairs(var2_120) do
			table.insert(var0_120, iter1_120)
		end
	end

	return var0_120
end

function var0_0.ExistCommander(arg0_121, arg1_121)
	local var0_121 = arg0_121:GetActiveEvent()

	if var0_121 then
		local var1_121 = var0_121:GetBossMission()

		return var1_121:IsActive() and var1_121:ExistCommander(arg1_121)
	end

	return false
end

function var0_0.IncActiveEventCnt(arg0_122)
	arg0_122.activeEventCnt = arg0_122.activeEventCnt + 1
end

function var0_0.ResetActiveEventCnt(arg0_123)
	arg0_123.activeEventCnt = 0
end

function var0_0.ShouldTipActiveEvent(arg0_124)
	return arg0_124.activeEventCnt + 1 <= arg0_124.tipActiveEventCnt
end

function var0_0.GetActiveEventCnt(arg0_125)
	return arg0_125.activeEventCnt
end

return var0_0
