local var0 = class("ActivityProxy", import(".NetProxy"))

var0.ACTIVITY_ADDED = "ActivityProxy ACTIVITY_ADDED"
var0.ACTIVITY_UPDATED = "ActivityProxy ACTIVITY_UPDATED"
var0.ACTIVITY_DELETED = "ActivityProxy ACTIVITY_DELETED"
var0.ACTIVITY_OPERATION_DONE = "ActivityProxy ACTIVITY_OPERATION_DONE"
var0.ACTIVITY_SHOW_AWARDS = "ActivityProxy ACTIVITY_SHOW_AWARDS"
var0.ACTIVITY_SHOP_SHOW_AWARDS = "ActivityProxy ACTIVITY_SHOP_SHOW_AWARDS"
var0.ACTIVITY_SHOW_BB_RESULT = "ActivityProxy ACTIVITY_SHOW_BB_RESULT"
var0.ACTIVITY_LOTTERY_SHOW_AWARDS = "ActivityProxy ACTIVITY_LOTTERY_SHOW_AWARDS"
var0.ACTIVITY_HITMONSTER_SHOW_AWARDS = "ActivityProxy ACTIVITY_HITMONSTER_SHOW_AWARDS"
var0.ACTIVITY_SHOW_REFLUX_AWARDS = "ActivityProxy ACTIVITY_SHOW_REFLUX_AWARDS"
var0.ACTIVITY_OPERATION_ERRO = "ActivityProxy ACTIVITY_OPERATION_ERRO"
var0.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT = "ActivityProxy ACTIVITY_SHOW_LOTTERY_AWARD_RESULT"
var0.ACTIVITY_SHOW_RED_PACKET_AWARDS = "ActivityProxy ACTIVITY_SHOW_RED_PACKET_AWARDS"
var0.ACTIVITY_SHOW_SHAKE_BEADS_RESULT = "ActivityProxy ACTIVITY_SHOW_SHAKE_BEADS_RESULT"
var0.ACTIVITY_PT_ID = 110

function var0.register(arg0)
	arg0:on(11200, function(arg0)
		arg0.data = {}
		arg0.params = {}
		arg0.hxList = {}
		arg0.buffActs = {}

		if arg0.hx_list then
			for iter0, iter1 in ipairs(arg0.hx_list) do
				table.insert(arg0.hxList, iter1)
			end
		end

		for iter2, iter3 in ipairs(arg0.activity_list) do
			if not pg.activity_template[iter3.id] then
				Debugger.LogError("活动acvitity_template不存在: " .. iter3.id)
			else
				local var0 = Activity.Create(iter3)
				local var1 = var0:getConfig("type")

				if var1 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
					if var0:checkBattleTimeInBossAct() then
						arg0:InitActtivityFleet(var0, iter3)
					end
				elseif var1 == ActivityConst.ACTIVITY_TYPE_CHALLENGE then
					arg0:InitActtivityFleet(var0, iter3)
				elseif var1 == ActivityConst.ACTIVITY_TYPE_PARAMETER then
					arg0:addActivityParameter(var0)
				elseif var1 == ActivityConst.ACTIVITY_TYPE_BUFF then
					table.insert(arg0.buffActs, var0.id)
				elseif var1 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
					arg0:InitActtivityFleet(var0, iter3)
				elseif var1 == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE then
					arg0:InitActtivityFleet(var0, iter3)
				elseif var1 == ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE then
					arg0:CheckDailyEventRequest(var0)
				end

				arg0.data[iter3.id] = var0
			end
		end

		arg0:refreshActivityBuffs()

		for iter4, iter5 in pairs(arg0.data) do
			arg0:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
				isInit = true,
				activity = iter5
			})
		end

		if arg0.data[ActivityConst.MILITARY_EXERCISE_ACTIVITY_ID] then
			getProxy(MilitaryExerciseProxy):addSeasonOverTimer()
		end

		local var2 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

		if var2 and not var2:isEnd() then
			arg0:sendNotification(GAME.CHALLENGE2_INFO, {})
		end

		local var3 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

		if var3 and not var3:isEnd() and var3.data1 == 0 then
			arg0:monitorTaskList(var3)
		end

		local var4 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

		if var4 and not var4:isEnd() then
			local var5 = arg0.data[var4.id]

			arg0:InitActivityBossData(var5)
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
		;(function()
			local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not var0 then
				return
			end

			arg0:sendNotification(GAME.REQUEST_ATELIER, var0.id)
		end)()
	end)
	arg0:on(11201, function(arg0)
		local var0 = Activity.Create(arg0.activity_info)

		assert(var0.id, "should exist activity")

		local var1 = var0:getConfig("type")

		if var1 == ActivityConst.ACTIVITY_TYPE_PARAMETER then
			arg0:addActivityParameter(var0)
		end

		if not arg0.data[var0.id] then
			arg0:addActivity(var0)
		else
			arg0:updateActivity(var0)
		end

		if var1 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			arg0:InitActtivityFleet(var0, arg0.activity_info)
			arg0:InitActivityBossData(var0)
		end

		arg0:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
			activity = var0
		})
	end)
	arg0:on(40009, function(arg0)
		local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)
		local var1

		if var0 then
			var1 = var0:GetSeriesData()
		end

		local var2 = BossRushSettlementCommand.ConcludeEXP(arg0, var0, var1 and var1:GetBattleStatistics())

		;(function()
			getProxy(ActivityProxy):GetBossRushRuntime(var0.id).settlementData = var2
		end)()
	end)
	arg0:on(24100, function(arg0)
		(function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK)

			if not var0 then
				return
			end

			var0:Record(arg0.score)
			arg0:updateActivity(var0)
		end)()

		local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

		if not var0 then
			return
		end

		local var1 = var0:GetSeriesData()

		if not var1 then
			return
		end

		var1:AddEXScore(arg0)
		arg0:updateActivity(var0)
	end)
	arg0:on(11028, function(arg0)
		print("接受到问卷状态", arg0.result)

		if arg0.result == 0 then
			arg0:setSurveyState(arg0.result)
		elseif arg0.result > 0 then
			arg0:setSurveyState(arg0.result)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
	arg0:on(26033, function(arg0)
		local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

		if not var0 then
			return
		end

		local var1 = arg0.point
		local var2 = var0:UpdateHighestScore(var1)

		arg0:GetActivityBossRuntime(var0.id).spScore = {
			score = var1,
			new = var2
		}

		arg0:updateActivity(var0)
	end)

	arg0.requestTime = {}
	arg0.extraDatas = {}
end

function var0.getAliveActivityByType(arg0, arg1)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1:getConfig("type") == arg1 and not iter1:isEnd() then
			return iter1
		end
	end
end

function var0.getActivityByType(arg0, arg1)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1:getConfig("type") == arg1 then
			return iter1
		end
	end
end

function var0.getActivitiesByType(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:getConfig("type") == arg1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getActivitiesByTypes(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if table.contains(arg1, iter1:getConfig("type")) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetEarliestActByType(arg0, arg1)
	local var0 = arg0:getActivitiesByType(arg1)
	local var1 = _.select(var0, function(arg0)
		return not arg0:isEnd()
	end)

	table.sort(var1, function(arg0, arg1)
		return arg0.id < arg1.id
	end)

	return var1[1]
end

function var0.getMilitaryExerciseActivity(arg0)
	local var0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			var0 = iter1

			break
		end
	end

	return Clone(var0)
end

function var0.getPanelActivities(arg0)
	local function var0(arg0)
		local var0 = arg0:getConfig("type")
		local var1 = arg0:isShow() and not arg0:isAfterShow()

		if var1 then
			if var0 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				var1 = arg0.data2 == 0
			elseif var0 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				var1 = arg0.data1 < 7 or not arg0.achieved
			end
		end

		return var1 and not arg0:isEnd()
	end

	local var1 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if var0(iter1) then
			table.insert(var1, iter1)
		end
	end

	table.sort(var1, function(arg0, arg1)
		local var0 = arg0:getConfig("login_pop")
		local var1 = arg1:getConfig("login_pop")

		if var0 == var1 then
			return arg0.id < arg1.id
		else
			return var1 < var0
		end
	end)

	return var1
end

function var0.checkHxActivity(arg0, arg1)
	if arg0.hxList and #arg0.hxList > 0 then
		for iter0 = 1, #arg0.hxList do
			if arg0.hxList[iter0] == arg1 then
				return true
			end
		end
	end

	return false
end

function var0.getBannerDisplays(arg0)
	return _(pg.activity_banner.all):chain():map(function(arg0)
		return pg.activity_banner[arg0]
	end):filter(function(arg0)
		return pg.TimeMgr.GetInstance():inTime(arg0.time) and arg0.type ~= GAMEUI_BANNER_9 and arg0.type ~= GAMEUI_BANNER_11 and arg0.type ~= GAMEUI_BANNER_10 and arg0.type ~= GAMEUI_BANNER_12 and arg0.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0.getActiveBannerByType(arg0, arg1)
	local var0 = pg.activity_banner.get_id_list_by_type[arg1]

	if not var0 then
		return nil
	end

	for iter0, iter1 in ipairs(var0) do
		local var1 = pg.activity_banner[iter1]

		if pg.TimeMgr.GetInstance():inTime(var1.time) then
			return var1
		end
	end

	return nil
end

function var0.getNoticeBannerDisplays(arg0)
	return _.map(pg.activity_banner_notice.all, function(arg0)
		return pg.activity_banner_notice[arg0]
	end)
end

function var0.findNextAutoActivity(arg0)
	local var0
	local var1 = pg.TimeMgr.GetInstance()
	local var2 = var1:GetServerTime()

	for iter0, iter1 in ipairs(arg0:getPanelActivities()) do
		if iter1:isShow() and not iter1.autoActionForbidden then
			local var3 = iter1:getConfig("type")

			if var3 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var4 = iter1:getConfig("config_id")
				local var5 = pg.activity_7_day_sign[var4].front_drops

				if iter1.data1 < #var5 and not var1:IsSameDay(var2, iter1.data2) and var2 > iter1.data2 then
					var0 = iter1

					break
				end
			elseif var3 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var6 = getProxy(ChapterProxy)

				if iter1.data1 < 7 and not var1:IsSameDay(var2, iter1.data2) or iter1.data1 == 7 and not iter1.achieved and var6:isClear(204) then
					var0 = iter1

					break
				end
			elseif var3 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var7 = pg.TimeMgr.GetInstance():STimeDescS(var2, "*t")

				iter1:setSpecialData("reMonthSignDay", nil)

				if var7.year ~= iter1.data1 or var7.month ~= iter1.data2 then
					iter1.data1 = var7.year
					iter1.data2 = var7.month
					iter1.data1_list = {}
					var0 = iter1

					break
				elseif not table.contains(iter1.data1_list, var7.day) then
					var0 = iter1

					break
				elseif var7.day > #iter1.data1_list and pg.activity_month_sign[iter1.data2].resign_count > iter1.data3 then
					for iter2 = var7.day, 1, -1 do
						if not table.contains(iter1.data1_list, iter2) then
							iter1:setSpecialData("reMonthSignDay", iter2)

							break
						end
					end

					var0 = iter1
				end
			elseif iter1.id == ActivityConst.SHADOW_PLAY_ID and iter1.clientData1 == 0 then
				local var8 = iter1:getConfig("config_data")[1]
				local var9 = getProxy(TaskProxy)
				local var10 = var9:getTaskById(var8) or var9:getFinishTaskById(var8)

				if var10 and not var10:isReceive() then
					var0 = iter1

					break
				end
			end
		end
	end

	if not var0 then
		for iter3, iter4 in pairs(arg0.data) do
			if not iter4:isShow() and iter4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var11 = iter4:getConfig("config_id")
				local var12 = pg.activity_7_day_sign[var11].front_drops

				if iter4.data1 < #var12 and not var1:IsSameDay(var2, iter4.data2) and var2 > iter4.data2 then
					var0 = iter4

					break
				end
			end
		end
	end

	return var0
end

function var0.findRefluxAutoActivity(arg0)
	local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0 and not var0:isEnd() and not var0.autoActionForbidden then
		local var1 = pg.TimeMgr.GetInstance()

		if var0.data1_list[2] < #pg.return_sign_template.all and not var1:IsSameDay(var1:GetServerTime(), var0.data1_list[1]) then
			return 1
		end
	end
end

function var0.existRefluxAwards(arg0)
	local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0 and not var0:isEnd() then
		local var1 = pg.return_pt_template

		for iter0 = #var1.all, 1, -1 do
			local var2 = var1.all[iter0]
			local var3 = var1[var2]

			if var0.data3 >= var3.pt_require and var2 > var0.data4 then
				return true
			end
		end

		local var4 = getProxy(TaskProxy)
		local var5 = _(var0:getConfig("config_data")[7]):chain():map(function(arg0)
			return arg0[2]
		end):flatten():map(function(arg0)
			return var4:getTaskById(arg0) or var4:getFinishTaskById(arg0) or false
		end):filter(function(arg0)
			return not not arg0
		end):value()

		if _.any(var5, function(arg0)
			return arg0:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0.getActivityById(arg0, arg1)
	return Clone(arg0.data[arg1])
end

function var0.RawGetActivityById(arg0, arg1)
	return arg0.data[arg1]
end

function var0.updateActivity(arg0, arg1)
	assert(arg0.data[arg1.id], "activity should exist" .. arg1.id)
	assert(isa(arg1, Activity), "activity should instance of Activity")

	if arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0 = pg.battlepass_event_pt[arg1.id].target

		if arg0.data[arg1.id].data1 < var0[#var0] and arg1.data1 - arg0.data[arg1.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1.id].pt,
				ptCount = arg1.data1 - arg0.data[arg1.id].data1
			})
		end
	end

	arg0.data[arg1.id] = arg1

	arg0.facade:sendNotification(var0.ACTIVITY_UPDATED, arg1:clone())
	arg0.facade:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1.id
	})
end

function var0.addActivity(arg0, arg1)
	assert(arg0.data[arg1.id] == nil, "activity already exist" .. arg1.id)
	assert(isa(arg1, Activity), "activity should instance of Activity")

	arg0.data[arg1.id] = arg1

	arg0.facade:sendNotification(var0.ACTIVITY_ADDED, arg1:clone())

	if arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		table.insert(arg0.buffActs, arg1.id)
		arg0:refreshActivityBuffs()
	end
end

function var0.deleteActivityById(arg0, arg1)
	assert(arg0.data[arg1], "activity should exist" .. arg1)

	arg0.data[arg1] = nil

	arg0.facade:sendNotification(var0.ACTIVITY_DELETED, arg1)
end

function var0.IsActivityNotEnd(arg0, arg1)
	return arg0.data[arg1] and not arg0.data[arg1]:isEnd()
end

function var0.readyToAchieveByType(arg0, arg1)
	local var0 = false
	local var1 = arg0:getActivitiesByType(arg1)

	for iter0, iter1 in ipairs(var1) do
		if iter1:readyToAchieve() then
			var0 = true

			break
		end
	end

	return var0
end

function var0.getBuildActivityCfgByID(arg0, arg1)
	local var0 = arg0:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})

	for iter0, iter1 in ipairs(var0) do
		if not iter1:isEnd() then
			local var1 = iter1:getConfig("config_client")

			if var1 and var1.id == arg1 then
				return var1
			end
		end
	end

	return nil
end

function var0.getNoneActBuildActivityCfgByID(arg0, arg1)
	local var0 = arg0:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0, iter1 in ipairs(var0) do
		if not iter1:isEnd() then
			local var1 = iter1:getConfig("config_client")

			if var1 and var1.id == arg1 then
				return var1
			end
		end
	end

	return nil
end

function var0.getBuffShipList(arg0)
	local var0 = {}
	local var1 = arg0:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1, function(arg0)
		if arg0 and not arg0:isEnd() then
			local var0 = arg0:getConfig("config_id")
			local var1 = pg.activity_expup_ship[var0]

			if not var1 then
				return
			end

			local var2 = var1.expup

			for iter0, iter1 in pairs(var2) do
				var0[iter1[1]] = iter1[2]
			end
		end
	end)

	return var0
end

function var0.getVirtualItemNumber(arg0, arg1)
	local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0 and not var0:isEnd() then
		return var0.data1KeyValueList[1][arg1] and var0.data1KeyValueList[1][arg1] or 0
	end

	return 0
end

function var0.removeVitemById(arg0, arg1, arg2)
	local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0, "vbagType invalid")

	if var0 and not var0:isEnd() then
		var0.data1KeyValueList[1][arg1] = var0.data1KeyValueList[1][arg1] - arg2
	end

	arg0:updateActivity(var0)
end

function var0.addVitemById(arg0, arg1, arg2)
	local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0, "vbagType invalid")

	if var0 and not var0:isEnd() then
		if not var0.data1KeyValueList[1][arg1] then
			var0.data1KeyValueList[1][arg1] = 0
		end

		var0.data1KeyValueList[1][arg1] = var0.data1KeyValueList[1][arg1] + arg2
	end

	arg0:updateActivity(var0)

	local var1 = Item.getConfigData(arg1).link_id

	if var1 ~= 0 then
		local var2 = arg0:getActivityById(var1)

		if var2 and not var2:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2, arg2)
		end
	end
end

function var0.monitorTaskList(arg0, arg1)
	if arg1 and not arg1:isEnd() and arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0 = arg1:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0) then
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1.id
			})
		end
	end
end

function var0.InitActtivityFleet(arg0, arg1, arg2)
	getProxy(FleetProxy):addActivityFleet(arg1, arg2.group_list)
end

function var0.InitActivityBossData(arg0, arg1)
	local var0 = pg.activity_event_worldboss[arg1:getConfig("config_id")]

	if not var0 then
		return
	end

	local var1 = arg1.data1KeyValueList

	for iter0, iter1 in pairs(var0.normal_expedition_drop_num or {}) do
		for iter2, iter3 in pairs(iter1[1]) do
			local var2 = iter1[2]
			local var3 = var1[1][iter3] or 0

			var1[1][iter3] = math.max(var2 - var3, 0)
			var1[2][iter3] = var1[2][iter3] or 0
		end
	end
end

function var0.AddInstagramTimer(arg0, arg1)
	arg0:RemoveInstagramTimer()

	local var0, var1 = arg0.data[arg1]:GetNextPushTime()

	if var0 then
		local var2 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

		local function var3()
			arg0:sendNotification(GAME.ACT_INSTAGRAM_OP, {
				arg2 = 0,
				activity_id = arg1,
				cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
				arg1 = var1
			})
		end

		if var2 <= 0 then
			var3()
		else
			arg0.instagramTimer = Timer.New(function()
				var3()
				arg0:RemoveInstagramTimer()
			end, var2, 1)

			arg0.instagramTimer:Start()
		end
	end
end

function var0.RemoveInstagramTimer(arg0)
	if arg0.instagramTimer then
		arg0.instagramTimer:Stop()

		arg0.instagramTimer = nil
	end
end

function var0.RegisterRequestTime(arg0, arg1, arg2)
	if not arg1 or arg1 <= 0 then
		return
	end

	arg0.requestTime[arg1] = arg2
end

function var0.remove(arg0)
	arg0:RemoveInstagramTimer()
end

function var0.addActivityParameter(arg0, arg1)
	local var0 = arg1:getConfig("config_data")
	local var1 = arg1.stopTime

	for iter0, iter1 in ipairs(var0) do
		arg0.params[iter1[1]] = {
			iter1[2],
			var1
		}
	end
end

function var0.getActivityParameter(arg0, arg1)
	if arg0.params[arg1] then
		local var0, var1 = unpack(arg0.params[arg1])

		if not (var1 > 0) or not (var1 <= pg.TimeMgr.GetInstance():GetServerTime()) then
			return var0
		end
	end
end

function var0.IsShowFreeBuildMark(arg0, arg1)
	for iter0, iter1 in ipairs(arg0:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter1 and not iter1:isEnd() and iter1.data1 > 0 and iter1.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 and tobool(arg1) == (PlayerPrefs.GetString("Free_Build_Ticket_" .. iter1.id, "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")) then
			return iter1
		end
	end

	return false
end

function var0.getBuildFreeActivityByBuildId(arg0, arg1)
	for iter0, iter1 in ipairs(arg0:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if underscore.any(iter1:getConfig("config_data"), function(arg0)
			return arg0 == arg1
		end) then
			return iter1
		end
	end
end

function var0.getBuildPoolActivity(arg0, arg1)
	if arg1:IsActivity() then
		return arg0:getActivityById(arg1.activityId)
	end
end

function var0.getEnterReadyActivity(arg0)
	local var0 = {
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0)
			return not arg0:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = false
	}
	local var1 = _.keys(var0)
	local var2 = {}

	for iter0, iter1 in ipairs(var1) do
		var2[iter1] = 0
	end

	for iter2, iter3 in pairs(arg0.data) do
		local var3 = iter3:getConfig("type")

		if var2[var3] and not iter3:isEnd() and not existCall(var0[var3], iter3) then
			var2[var3] = math.max(var2[var3], iter2)
		end
	end

	table.sort(var1)

	for iter4, iter5 in ipairs(var1) do
		if var2[iter5] > 0 then
			return arg0.data[var2[iter5]]
		end
	end
end

function var0.AtelierActivityAllSlotIsEmpty(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0 or var0:isEnd() then
		return false
	end

	local var1 = var0:GetSlots()

	for iter0, iter1 in pairs(var1) do
		if iter1[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0.OwnAtelierActivityItemCnt(arg0, arg1, arg2)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0 or var0:isEnd() then
		return false
	end

	local var1 = var0:GetItems()[arg1]

	return var1 and arg2 <= var1.count
end

function var0.refreshActivityBuffs(arg0)
	arg0.actBuffs = {}

	local var0 = 1

	while var0 <= #arg0.buffActs do
		local var1 = arg0.data[arg0.buffActs[var0]]

		if not var1 or var1:isEnd() then
			table.remove(arg0.buffActs, var0)
		else
			var0 = var0 + 1

			local var2 = {
				var1:getConfig("config_id")
			}

			if var2[1] == 0 then
				var2 = var1:getConfig("config_data")
			end

			for iter0, iter1 in ipairs(var2) do
				local var3 = ActivityBuff.New(var1.id, iter1)

				if var3:isActivate() then
					table.insert(arg0.actBuffs, var3)
				end
			end
		end
	end
end

function var0.getActivityBuffs(arg0)
	if underscore.any(arg0.buffActs, function(arg0)
		return not arg0.data[arg0] or arg0.data[arg0]:isEnd()
	end) or underscore.any(arg0.actBuffs, function(arg0)
		return not arg0:isActivate()
	end) then
		arg0:refreshActivityBuffs()
	end

	return arg0.actBuffs
end

function var0.getShipModExpActivity(arg0)
	return underscore.select(arg0:getActivityBuffs(), function(arg0)
		return arg0:ShipModExpUsage()
	end)
end

function var0.getBackyardEnergyActivityBuffs(arg0)
	return underscore.select(arg0:getActivityBuffs(), function(arg0)
		return arg0:BackyardEnergyUsage()
	end)
end

function var0.InitContinuousTime(arg0, arg1)
	arg0.continuousOpeartionTime = arg1
	arg0.continuousOpeartionTotalTime = arg1
end

function var0.UseContinuousTime(arg0)
	if not arg0.continuousOpeartionTime then
		return
	end

	arg0.continuousOpeartionTime = arg0.continuousOpeartionTime - 1
end

function var0.GetContinuousTime(arg0)
	return arg0.continuousOpeartionTime, arg0.continuousOpeartionTotalTime
end

function var0.AddBossRushAwards(arg0, arg1)
	arg0.bossrushAwards = arg0.bossrushAwards or {}

	table.insertto(arg0.bossrushAwards, arg1)
end

function var0.PopBossRushAwards(arg0)
	local var0 = arg0.bossrushAwards or {}

	arg0.bossrushAwards = nil

	return var0
end

function var0.GetBossRushRuntime(arg0, arg1)
	if not arg0.extraDatas[arg1] then
		arg0.extraDatas[arg1] = {
			record = 0
		}
	end

	return arg0.extraDatas[arg1]
end

function var0.GetActivityBossRuntime(arg0, arg1)
	if not arg0.extraDatas[arg1] then
		arg0.extraDatas[arg1] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0.extraDatas[arg1]
end

function var0.GetTaskActivities(arg0)
	local var0 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0, arg1)
		if not isa(arg1, ITaskActivity) then
			return
		end

		table.insertto(var0, arg0:getActivitiesByType(arg0))
	end)

	return var0
end

function var0.setSurveyState(arg0, arg1)
	local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0 and not var0:isEnd() then
		arg0.surveyState = arg1
	end
end

function var0.isSurveyDone(arg0)
	local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0 and not var0:isEnd() then
		return arg0.surveyState and arg0.surveyState > 0
	end
end

function var0.isSurveyOpen(arg0)
	local var0 = arg0:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0 and not var0:isEnd() then
		local var1 = var0:getConfig("config_data")
		local var2 = var1[1]
		local var3 = var1[2]

		if var2 == 1 then
			local var4 = var3 <= getProxy(PlayerProxy):getData().level
			local var5 = var0:getConfig("config_id")

			return var4, var5
		end
	end
end

function var0.GetActBossLinkPTActID(arg0, arg1)
	local var0 = table.Find(arg0.data, function(arg0, arg1)
		if arg1:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1:getDataConfig("link_id") == arg1
	end)

	return var0 and var0.id
end

function var0.CheckDailyEventRequest(arg0, arg1)
	if arg1:CheckDailyEventRequest() then
		arg0:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1.id
		})
	end
end

return var0
