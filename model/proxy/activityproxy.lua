local var0_0 = class("ActivityProxy", import(".NetProxy"))

var0_0.ACTIVITY_ADDED = "ActivityProxy ACTIVITY_ADDED"
var0_0.ACTIVITY_UPDATED = "ActivityProxy ACTIVITY_UPDATED"
var0_0.ACTIVITY_DELETED = "ActivityProxy ACTIVITY_DELETED"
var0_0.ACTIVITY_OPERATION_DONE = "ActivityProxy ACTIVITY_OPERATION_DONE"
var0_0.ACTIVITY_SHOW_AWARDS = "ActivityProxy ACTIVITY_SHOW_AWARDS"
var0_0.ACTIVITY_SHOP_SHOW_AWARDS = "ActivityProxy ACTIVITY_SHOP_SHOW_AWARDS"
var0_0.ACTIVITY_SHOW_BB_RESULT = "ActivityProxy ACTIVITY_SHOW_BB_RESULT"
var0_0.ACTIVITY_LOTTERY_SHOW_AWARDS = "ActivityProxy ACTIVITY_LOTTERY_SHOW_AWARDS"
var0_0.ACTIVITY_HITMONSTER_SHOW_AWARDS = "ActivityProxy ACTIVITY_HITMONSTER_SHOW_AWARDS"
var0_0.ACTIVITY_SHOW_REFLUX_AWARDS = "ActivityProxy ACTIVITY_SHOW_REFLUX_AWARDS"
var0_0.ACTIVITY_OPERATION_ERRO = "ActivityProxy ACTIVITY_OPERATION_ERRO"
var0_0.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT = "ActivityProxy ACTIVITY_SHOW_LOTTERY_AWARD_RESULT"
var0_0.ACTIVITY_SHOW_RED_PACKET_AWARDS = "ActivityProxy ACTIVITY_SHOW_RED_PACKET_AWARDS"
var0_0.ACTIVITY_SHOW_SHAKE_BEADS_RESULT = "ActivityProxy ACTIVITY_SHOW_SHAKE_BEADS_RESULT"
var0_0.ACTIVITY_PT_ID = 110

function var0_0.register(arg0_1)
	arg0_1:on(11200, function(arg0_2)
		arg0_1.data = {}
		arg0_1.params = {}
		arg0_1.hxList = {}
		arg0_1.buffActs = {}

		if arg0_2.hx_list then
			for iter0_2, iter1_2 in ipairs(arg0_2.hx_list) do
				table.insert(arg0_1.hxList, iter1_2)
			end
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.activity_list) do
			if not pg.activity_template[iter3_2.id] then
				Debugger.LogError("活动acvitity_template不存在: " .. iter3_2.id)
			else
				local var0_2 = Activity.Create(iter3_2)
				local var1_2 = var0_2:getConfig("type")

				if var1_2 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
					if var0_2:checkBattleTimeInBossAct() then
						arg0_1:InitActtivityFleet(var0_2, iter3_2)
					end
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_CHALLENGE then
					arg0_1:InitActtivityFleet(var0_2, iter3_2)
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_PARAMETER then
					arg0_1:addActivityParameter(var0_2)
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_BUFF then
					table.insert(arg0_1.buffActs, var0_2.id)
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
					arg0_1:InitActtivityFleet(var0_2, iter3_2)
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE then
					arg0_1:InitActtivityFleet(var0_2, iter3_2)
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE then
					arg0_1:CheckDailyEventRequest(var0_2)
				end

				arg0_1.data[iter3_2.id] = var0_2
			end
		end

		arg0_1:refreshActivityBuffs()

		for iter4_2, iter5_2 in pairs(arg0_1.data) do
			arg0_1:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
				isInit = true,
				activity = iter5_2
			})
		end

		if arg0_1.data[ActivityConst.MILITARY_EXERCISE_ACTIVITY_ID] then
			getProxy(MilitaryExerciseProxy):addSeasonOverTimer()
		end

		local var2_2 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

		if var2_2 and not var2_2:isEnd() then
			arg0_1:sendNotification(GAME.CHALLENGE2_INFO, {})
		end

		local var3_2 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

		if var3_2 and not var3_2:isEnd() and var3_2.data1 == 0 then
			arg0_1:monitorTaskList(var3_2)
		end

		local var4_2 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

		if var4_2 and not var4_2:isEnd() then
			local var5_2 = arg0_1.data[var4_2.id]

			arg0_1:InitActivityBossData(var5_2)
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
		;(function()
			local var0_3 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not var0_3 then
				return
			end

			arg0_1:sendNotification(GAME.REQUEST_ATELIER, var0_3.id)
		end)()
	end)
	arg0_1:on(11201, function(arg0_4)
		local var0_4 = Activity.Create(arg0_4.activity_info)

		assert(var0_4.id, "should exist activity")

		local var1_4 = var0_4:getConfig("type")

		if var1_4 == ActivityConst.ACTIVITY_TYPE_PARAMETER then
			arg0_1:addActivityParameter(var0_4)
		end

		if not arg0_1.data[var0_4.id] then
			arg0_1:addActivity(var0_4)
		else
			arg0_1:updateActivity(var0_4)
		end

		if var1_4 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			arg0_1:InitActtivityFleet(var0_4, arg0_4.activity_info)
			arg0_1:InitActivityBossData(var0_4)
		end

		arg0_1:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
			activity = var0_4
		})
	end)
	arg0_1:on(40009, function(arg0_5)
		local var0_5 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)
		local var1_5

		if var0_5 then
			var1_5 = var0_5:GetSeriesData()
		end

		local var2_5 = BossRushSettlementCommand.ConcludeEXP(arg0_5, var0_5, var1_5 and var1_5:GetBattleStatistics())

		;(function()
			getProxy(ActivityProxy):GetBossRushRuntime(var0_5.id).settlementData = var2_5
		end)()
	end)
	arg0_1:on(24100, function(arg0_7)
		(function()
			local var0_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK)

			if not var0_8 then
				return
			end

			var0_8:Record(arg0_7.score)
			arg0_1:updateActivity(var0_8)
		end)()

		local var0_7 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

		if not var0_7 then
			return
		end

		local var1_7 = var0_7:GetSeriesData()

		if not var1_7 then
			return
		end

		var1_7:AddEXScore(arg0_7)
		arg0_1:updateActivity(var0_7)
	end)
	arg0_1:on(11028, function(arg0_9)
		print("接受到问卷状态", arg0_9.result)

		if arg0_9.result == 0 then
			arg0_1:setSurveyState(arg0_9.result)
		elseif arg0_9.result > 0 then
			arg0_1:setSurveyState(arg0_9.result)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_9.result))
		end
	end)
	arg0_1:on(26033, function(arg0_10)
		local var0_10 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

		if not var0_10 then
			return
		end

		local var1_10 = arg0_10.point
		local var2_10 = var0_10:UpdateHighestScore(var1_10)

		arg0_1:GetActivityBossRuntime(var0_10.id).spScore = {
			score = var1_10,
			new = var2_10
		}

		arg0_1:updateActivity(var0_10)
	end)

	arg0_1.requestTime = {}
	arg0_1.extraDatas = {}
end

function var0_0.getAliveActivityByType(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg0_11.data) do
		if iter1_11:getConfig("type") == arg1_11 and not iter1_11:isEnd() then
			return iter1_11
		end
	end
end

function var0_0.getActivityByType(arg0_12, arg1_12)
	for iter0_12, iter1_12 in pairs(arg0_12.data) do
		if iter1_12:getConfig("type") == arg1_12 then
			return iter1_12
		end
	end
end

function var0_0.getActivitiesByType(arg0_13, arg1_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13.data) do
		if iter1_13:getConfig("type") == arg1_13 then
			table.insert(var0_13, iter1_13)
		end
	end

	return var0_13
end

function var0_0.getActivitiesByTypes(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14.data) do
		if table.contains(arg1_14, iter1_14:getConfig("type")) then
			table.insert(var0_14, iter1_14)
		end
	end

	return var0_14
end

function var0_0.GetEarliestActByType(arg0_15, arg1_15)
	local var0_15 = arg0_15:getActivitiesByType(arg1_15)
	local var1_15 = _.select(var0_15, function(arg0_16)
		return not arg0_16:isEnd()
	end)

	table.sort(var1_15, function(arg0_17, arg1_17)
		return arg0_17.id < arg1_17.id
	end)

	return var1_15[1]
end

function var0_0.getMilitaryExerciseActivity(arg0_18)
	local var0_18

	for iter0_18, iter1_18 in pairs(arg0_18.data) do
		if iter1_18:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			var0_18 = iter1_18

			break
		end
	end

	return Clone(var0_18)
end

function var0_0.getPanelActivities(arg0_19)
	local function var0_19(arg0_20)
		local var0_20 = arg0_20:getConfig("type")
		local var1_20 = arg0_20:isShow() and not arg0_20:isAfterShow()

		if var1_20 then
			if var0_20 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				var1_20 = arg0_20.data2 == 0
			elseif var0_20 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				var1_20 = arg0_20.data1 < 7 or not arg0_20.achieved
			end
		end

		return var1_20 and not arg0_20:isEnd()
	end

	local var1_19 = {}

	for iter0_19, iter1_19 in pairs(arg0_19.data) do
		if var0_19(iter1_19) then
			table.insert(var1_19, iter1_19)
		end
	end

	table.sort(var1_19, function(arg0_21, arg1_21)
		local var0_21 = arg0_21:getConfig("login_pop")
		local var1_21 = arg1_21:getConfig("login_pop")

		if var0_21 == var1_21 then
			return arg0_21.id < arg1_21.id
		else
			return var1_21 < var0_21
		end
	end)

	return var1_19
end

function var0_0.checkHxActivity(arg0_22, arg1_22)
	if arg0_22.hxList and #arg0_22.hxList > 0 then
		for iter0_22 = 1, #arg0_22.hxList do
			if arg0_22.hxList[iter0_22] == arg1_22 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_23)
	return _(pg.activity_banner.all):chain():map(function(arg0_24)
		return pg.activity_banner[arg0_24]
	end):filter(function(arg0_25)
		return pg.TimeMgr.GetInstance():inTime(arg0_25.time) and arg0_25.type ~= GAMEUI_BANNER_9 and arg0_25.type ~= GAMEUI_BANNER_11 and arg0_25.type ~= GAMEUI_BANNER_10 and arg0_25.type ~= GAMEUI_BANNER_12 and arg0_25.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_26, arg1_26)
	local var0_26 = pg.activity_banner.get_id_list_by_type[arg1_26]

	if not var0_26 then
		return nil
	end

	for iter0_26, iter1_26 in ipairs(var0_26) do
		local var1_26 = pg.activity_banner[iter1_26]

		if pg.TimeMgr.GetInstance():inTime(var1_26.time) then
			return var1_26
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_27)
	return _.map(pg.activity_banner_notice.all, function(arg0_28)
		return pg.activity_banner_notice[arg0_28]
	end)
end

function var0_0.findNextAutoActivity(arg0_29)
	local var0_29
	local var1_29 = pg.TimeMgr.GetInstance()
	local var2_29 = var1_29:GetServerTime()

	for iter0_29, iter1_29 in ipairs(arg0_29:getPanelActivities()) do
		if iter1_29:isShow() and not iter1_29.autoActionForbidden then
			local var3_29 = iter1_29:getConfig("type")

			if var3_29 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var4_29 = iter1_29:getConfig("config_id")
				local var5_29 = pg.activity_7_day_sign[var4_29].front_drops

				if iter1_29.data1 < #var5_29 and not var1_29:IsSameDay(var2_29, iter1_29.data2) and var2_29 > iter1_29.data2 then
					var0_29 = iter1_29

					break
				end
			elseif var3_29 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var6_29 = getProxy(ChapterProxy)

				if iter1_29.data1 < 7 and not var1_29:IsSameDay(var2_29, iter1_29.data2) or iter1_29.data1 == 7 and not iter1_29.achieved and var6_29:isClear(204) then
					var0_29 = iter1_29

					break
				end
			elseif var3_29 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var7_29 = pg.TimeMgr.GetInstance():STimeDescS(var2_29, "*t")

				iter1_29:setSpecialData("reMonthSignDay", nil)

				if var7_29.year ~= iter1_29.data1 or var7_29.month ~= iter1_29.data2 then
					iter1_29.data1 = var7_29.year
					iter1_29.data2 = var7_29.month
					iter1_29.data1_list = {}
					var0_29 = iter1_29

					break
				elseif not table.contains(iter1_29.data1_list, var7_29.day) then
					var0_29 = iter1_29

					break
				elseif var7_29.day > #iter1_29.data1_list and pg.activity_month_sign[iter1_29.data2].resign_count > iter1_29.data3 then
					for iter2_29 = var7_29.day, 1, -1 do
						if not table.contains(iter1_29.data1_list, iter2_29) then
							iter1_29:setSpecialData("reMonthSignDay", iter2_29)

							break
						end
					end

					var0_29 = iter1_29
				end
			elseif iter1_29.id == ActivityConst.SHADOW_PLAY_ID and iter1_29.clientData1 == 0 then
				local var8_29 = iter1_29:getConfig("config_data")[1]
				local var9_29 = getProxy(TaskProxy)
				local var10_29 = var9_29:getTaskById(var8_29) or var9_29:getFinishTaskById(var8_29)

				if var10_29 and not var10_29:isReceive() then
					var0_29 = iter1_29

					break
				end
			end
		end
	end

	if not var0_29 then
		for iter3_29, iter4_29 in pairs(arg0_29.data) do
			if not iter4_29:isShow() and iter4_29:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var11_29 = iter4_29:getConfig("config_id")
				local var12_29 = pg.activity_7_day_sign[var11_29].front_drops

				if iter4_29.data1 < #var12_29 and not var1_29:IsSameDay(var2_29, iter4_29.data2) and var2_29 > iter4_29.data2 then
					var0_29 = iter4_29

					break
				end
			end
		end
	end

	return var0_29
end

function var0_0.findRefluxAutoActivity(arg0_30)
	local var0_30 = arg0_30:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_30 and not var0_30:isEnd() and not var0_30.autoActionForbidden then
		local var1_30 = pg.TimeMgr.GetInstance()

		if var0_30.data1_list[2] < #pg.return_sign_template.all and not var1_30:IsSameDay(var1_30:GetServerTime(), var0_30.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_31)
	local var0_31 = arg0_31:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_31 and not var0_31:isEnd() then
		local var1_31 = pg.return_pt_template

		for iter0_31 = #var1_31.all, 1, -1 do
			local var2_31 = var1_31.all[iter0_31]
			local var3_31 = var1_31[var2_31]

			if var0_31.data3 >= var3_31.pt_require and var2_31 > var0_31.data4 then
				return true
			end
		end

		local var4_31 = getProxy(TaskProxy)
		local var5_31 = _(var0_31:getConfig("config_data")[7]):chain():map(function(arg0_32)
			return arg0_32[2]
		end):flatten():map(function(arg0_33)
			return var4_31:getTaskById(arg0_33) or var4_31:getFinishTaskById(arg0_33) or false
		end):filter(function(arg0_34)
			return not not arg0_34
		end):value()

		if _.any(var5_31, function(arg0_35)
			return arg0_35:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_36, arg1_36)
	return Clone(arg0_36.data[arg1_36])
end

function var0_0.RawGetActivityById(arg0_37, arg1_37)
	return arg0_37.data[arg1_37]
end

function var0_0.updateActivity(arg0_38, arg1_38)
	assert(arg0_38.data[arg1_38.id], "activity should exist" .. arg1_38.id)
	assert(isa(arg1_38, Activity), "activity should instance of Activity")

	if arg1_38:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_38 = pg.battlepass_event_pt[arg1_38.id].target

		if arg0_38.data[arg1_38.id].data1 < var0_38[#var0_38] and arg1_38.data1 - arg0_38.data[arg1_38.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_38.id].pt,
				ptCount = arg1_38.data1 - arg0_38.data[arg1_38.id].data1
			})
		end
	end

	arg0_38.data[arg1_38.id] = arg1_38

	arg0_38.facade:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_38:clone())
	arg0_38.facade:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_38.id
	})
end

function var0_0.addActivity(arg0_39, arg1_39)
	assert(arg0_39.data[arg1_39.id] == nil, "activity already exist" .. arg1_39.id)
	assert(isa(arg1_39, Activity), "activity should instance of Activity")

	arg0_39.data[arg1_39.id] = arg1_39

	arg0_39.facade:sendNotification(var0_0.ACTIVITY_ADDED, arg1_39:clone())

	if arg1_39:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		table.insert(arg0_39.buffActs, arg1_39.id)
		arg0_39:refreshActivityBuffs()
	end
end

function var0_0.deleteActivityById(arg0_40, arg1_40)
	assert(arg0_40.data[arg1_40], "activity should exist" .. arg1_40)

	arg0_40.data[arg1_40] = nil

	arg0_40.facade:sendNotification(var0_0.ACTIVITY_DELETED, arg1_40)
end

function var0_0.IsActivityNotEnd(arg0_41, arg1_41)
	return arg0_41.data[arg1_41] and not arg0_41.data[arg1_41]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_42, arg1_42)
	local var0_42 = false
	local var1_42 = arg0_42:getActivitiesByType(arg1_42)

	for iter0_42, iter1_42 in ipairs(var1_42) do
		if iter1_42:readyToAchieve() then
			var0_42 = true

			break
		end
	end

	return var0_42
end

function var0_0.getBuildActivityCfgByID(arg0_43, arg1_43)
	local var0_43 = arg0_43:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})

	for iter0_43, iter1_43 in ipairs(var0_43) do
		if not iter1_43:isEnd() then
			local var1_43 = iter1_43:getConfig("config_client")

			if var1_43 and var1_43.id == arg1_43 then
				return var1_43
			end
		end
	end

	return nil
end

function var0_0.getNoneActBuildActivityCfgByID(arg0_44, arg1_44)
	local var0_44 = arg0_44:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0_44, iter1_44 in ipairs(var0_44) do
		if not iter1_44:isEnd() then
			local var1_44 = iter1_44:getConfig("config_client")

			if var1_44 and var1_44.id == arg1_44 then
				return var1_44
			end
		end
	end

	return nil
end

function var0_0.getBuffShipList(arg0_45)
	local var0_45 = {}
	local var1_45 = arg0_45:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_45, function(arg0_46)
		if arg0_46 and not arg0_46:isEnd() then
			local var0_46 = arg0_46:getConfig("config_id")
			local var1_46 = pg.activity_expup_ship[var0_46]

			if not var1_46 then
				return
			end

			local var2_46 = var1_46.expup

			for iter0_46, iter1_46 in pairs(var2_46) do
				var0_45[iter1_46[1]] = iter1_46[2]
			end
		end
	end)

	return var0_45
end

function var0_0.getVirtualItemNumber(arg0_47, arg1_47)
	local var0_47 = arg0_47:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_47 and not var0_47:isEnd() then
		return var0_47.data1KeyValueList[1][arg1_47] and var0_47.data1KeyValueList[1][arg1_47] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg0_48:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_48, "vbagType invalid")

	if var0_48 and not var0_48:isEnd() then
		var0_48.data1KeyValueList[1][arg1_48] = var0_48.data1KeyValueList[1][arg1_48] - arg2_48
	end

	arg0_48:updateActivity(var0_48)
end

function var0_0.addVitemById(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg0_49:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_49, "vbagType invalid")

	if var0_49 and not var0_49:isEnd() then
		if not var0_49.data1KeyValueList[1][arg1_49] then
			var0_49.data1KeyValueList[1][arg1_49] = 0
		end

		var0_49.data1KeyValueList[1][arg1_49] = var0_49.data1KeyValueList[1][arg1_49] + arg2_49
	end

	arg0_49:updateActivity(var0_49)

	local var1_49 = Item.getConfigData(arg1_49).link_id

	if var1_49 ~= 0 then
		local var2_49 = arg0_49:getActivityById(var1_49)

		if var2_49 and not var2_49:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_49, arg2_49)
		end
	end
end

function var0_0.monitorTaskList(arg0_50, arg1_50)
	if arg1_50 and not arg1_50:isEnd() and arg1_50:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_50 = arg1_50:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_50) then
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_50.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_51, arg1_51, arg2_51)
	getProxy(FleetProxy):addActivityFleet(arg1_51, arg2_51.group_list)
end

function var0_0.InitActivityBossData(arg0_52, arg1_52)
	local var0_52 = pg.activity_event_worldboss[arg1_52:getConfig("config_id")]

	if not var0_52 then
		return
	end

	local var1_52 = arg1_52.data1KeyValueList

	for iter0_52, iter1_52 in pairs(var0_52.normal_expedition_drop_num or {}) do
		for iter2_52, iter3_52 in pairs(iter1_52[1]) do
			local var2_52 = iter1_52[2]
			local var3_52 = var1_52[1][iter3_52] or 0

			var1_52[1][iter3_52] = math.max(var2_52 - var3_52, 0)
			var1_52[2][iter3_52] = var1_52[2][iter3_52] or 0
		end
	end
end

function var0_0.AddInstagramTimer(arg0_53, arg1_53)
	arg0_53:RemoveInstagramTimer()

	local var0_53, var1_53 = arg0_53.data[arg1_53]:GetNextPushTime()

	if var0_53 then
		local var2_53 = var0_53 - pg.TimeMgr.GetInstance():GetServerTime()

		local function var3_53()
			arg0_53:sendNotification(GAME.ACT_INSTAGRAM_OP, {
				arg2 = 0,
				activity_id = arg1_53,
				cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
				arg1 = var1_53
			})
		end

		if var2_53 <= 0 then
			var3_53()
		else
			arg0_53.instagramTimer = Timer.New(function()
				var3_53()
				arg0_53:RemoveInstagramTimer()
			end, var2_53, 1)

			arg0_53.instagramTimer:Start()
		end
	end
end

function var0_0.RemoveInstagramTimer(arg0_56)
	if arg0_56.instagramTimer then
		arg0_56.instagramTimer:Stop()

		arg0_56.instagramTimer = nil
	end
end

function var0_0.RegisterRequestTime(arg0_57, arg1_57, arg2_57)
	if not arg1_57 or arg1_57 <= 0 then
		return
	end

	arg0_57.requestTime[arg1_57] = arg2_57
end

function var0_0.remove(arg0_58)
	arg0_58:RemoveInstagramTimer()
end

function var0_0.addActivityParameter(arg0_59, arg1_59)
	local var0_59 = arg1_59:getConfig("config_data")
	local var1_59 = arg1_59.stopTime

	for iter0_59, iter1_59 in ipairs(var0_59) do
		arg0_59.params[iter1_59[1]] = {
			iter1_59[2],
			var1_59
		}
	end
end

function var0_0.getActivityParameter(arg0_60, arg1_60)
	if arg0_60.params[arg1_60] then
		local var0_60, var1_60 = unpack(arg0_60.params[arg1_60])

		if not (var1_60 > 0) or not (var1_60 <= pg.TimeMgr.GetInstance():GetServerTime()) then
			return var0_60
		end
	end
end

function var0_0.IsShowFreeBuildMark(arg0_61, arg1_61)
	for iter0_61, iter1_61 in ipairs(arg0_61:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter1_61 and not iter1_61:isEnd() and iter1_61.data1 > 0 and iter1_61.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 and tobool(arg1_61) == (PlayerPrefs.GetString("Free_Build_Ticket_" .. iter1_61.id, "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")) then
			return iter1_61
		end
	end

	return false
end

function var0_0.getBuildFreeActivityByBuildId(arg0_62, arg1_62)
	for iter0_62, iter1_62 in ipairs(arg0_62:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if underscore.any(iter1_62:getConfig("config_data"), function(arg0_63)
			return arg0_63 == arg1_62
		end) then
			return iter1_62
		end
	end
end

function var0_0.getBuildPoolActivity(arg0_64, arg1_64)
	if arg1_64:IsActivity() then
		return arg0_64:getActivityById(arg1_64.activityId)
	end
end

function var0_0.getEnterReadyActivity(arg0_65)
	local var0_65 = {
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_66)
			return not arg0_66:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = false
	}
	local var1_65 = _.keys(var0_65)
	local var2_65 = {}

	for iter0_65, iter1_65 in ipairs(var1_65) do
		var2_65[iter1_65] = 0
	end

	for iter2_65, iter3_65 in pairs(arg0_65.data) do
		local var3_65 = iter3_65:getConfig("type")

		if var2_65[var3_65] and not iter3_65:isEnd() and not existCall(var0_65[var3_65], iter3_65) then
			var2_65[var3_65] = math.max(var2_65[var3_65], iter2_65)
		end
	end

	table.sort(var1_65)

	for iter4_65, iter5_65 in ipairs(var1_65) do
		if var2_65[iter5_65] > 0 then
			return arg0_65.data[var2_65[iter5_65]]
		end
	end
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_67)
	local var0_67 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_67 or var0_67:isEnd() then
		return false
	end

	local var1_67 = var0_67:GetSlots()

	for iter0_67, iter1_67 in pairs(var1_67) do
		if iter1_67[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_68, arg1_68, arg2_68)
	local var0_68 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_68 or var0_68:isEnd() then
		return false
	end

	local var1_68 = var0_68:GetItems()[arg1_68]

	return var1_68 and arg2_68 <= var1_68.count
end

function var0_0.refreshActivityBuffs(arg0_69)
	arg0_69.actBuffs = {}

	local var0_69 = 1

	while var0_69 <= #arg0_69.buffActs do
		local var1_69 = arg0_69.data[arg0_69.buffActs[var0_69]]

		if not var1_69 or var1_69:isEnd() then
			table.remove(arg0_69.buffActs, var0_69)
		else
			var0_69 = var0_69 + 1

			local var2_69 = {
				var1_69:getConfig("config_id")
			}

			if var2_69[1] == 0 then
				var2_69 = var1_69:getConfig("config_data")
			end

			for iter0_69, iter1_69 in ipairs(var2_69) do
				local var3_69 = ActivityBuff.New(var1_69.id, iter1_69)

				if var3_69:isActivate() then
					table.insert(arg0_69.actBuffs, var3_69)
				end
			end
		end
	end
end

function var0_0.getActivityBuffs(arg0_70)
	if underscore.any(arg0_70.buffActs, function(arg0_71)
		return not arg0_70.data[arg0_71] or arg0_70.data[arg0_71]:isEnd()
	end) or underscore.any(arg0_70.actBuffs, function(arg0_72)
		return not arg0_72:isActivate()
	end) then
		arg0_70:refreshActivityBuffs()
	end

	return arg0_70.actBuffs
end

function var0_0.getShipModExpActivity(arg0_73)
	return underscore.select(arg0_73:getActivityBuffs(), function(arg0_74)
		return arg0_74:ShipModExpUsage()
	end)
end

function var0_0.getBackyardEnergyActivityBuffs(arg0_75)
	return underscore.select(arg0_75:getActivityBuffs(), function(arg0_76)
		return arg0_76:BackyardEnergyUsage()
	end)
end

function var0_0.InitContinuousTime(arg0_77, arg1_77)
	arg0_77.continuousOpeartionTime = arg1_77
	arg0_77.continuousOpeartionTotalTime = arg1_77
end

function var0_0.UseContinuousTime(arg0_78)
	if not arg0_78.continuousOpeartionTime then
		return
	end

	arg0_78.continuousOpeartionTime = arg0_78.continuousOpeartionTime - 1
end

function var0_0.GetContinuousTime(arg0_79)
	return arg0_79.continuousOpeartionTime, arg0_79.continuousOpeartionTotalTime
end

function var0_0.AddBossRushAwards(arg0_80, arg1_80)
	arg0_80.bossrushAwards = arg0_80.bossrushAwards or {}

	table.insertto(arg0_80.bossrushAwards, arg1_80)
end

function var0_0.PopBossRushAwards(arg0_81)
	local var0_81 = arg0_81.bossrushAwards or {}

	arg0_81.bossrushAwards = nil

	return var0_81
end

function var0_0.GetBossRushRuntime(arg0_82, arg1_82)
	if not arg0_82.extraDatas[arg1_82] then
		arg0_82.extraDatas[arg1_82] = {
			record = 0
		}
	end

	return arg0_82.extraDatas[arg1_82]
end

function var0_0.GetActivityBossRuntime(arg0_83, arg1_83)
	if not arg0_83.extraDatas[arg1_83] then
		arg0_83.extraDatas[arg1_83] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0_83.extraDatas[arg1_83]
end

function var0_0.GetTaskActivities(arg0_84)
	local var0_84 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0_85, arg1_85)
		if not isa(arg1_85, ITaskActivity) then
			return
		end

		table.insertto(var0_84, arg0_84:getActivitiesByType(arg0_85))
	end)

	return var0_84
end

function var0_0.setSurveyState(arg0_86, arg1_86)
	local var0_86 = arg0_86:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_86 and not var0_86:isEnd() then
		arg0_86.surveyState = arg1_86
	end
end

function var0_0.isSurveyDone(arg0_87)
	local var0_87 = arg0_87:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_87 and not var0_87:isEnd() then
		return arg0_87.surveyState and arg0_87.surveyState > 0
	end
end

function var0_0.isSurveyOpen(arg0_88)
	local var0_88 = arg0_88:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_88 and not var0_88:isEnd() then
		local var1_88 = var0_88:getConfig("config_data")
		local var2_88 = var1_88[1]
		local var3_88 = var1_88[2]

		if var2_88 == 1 then
			local var4_88 = var3_88 <= getProxy(PlayerProxy):getData().level
			local var5_88 = var0_88:getConfig("config_id")

			return var4_88, var5_88
		end
	end
end

function var0_0.GetActBossLinkPTActID(arg0_89, arg1_89)
	local var0_89 = table.Find(arg0_89.data, function(arg0_90, arg1_90)
		if arg1_90:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1_90:getDataConfig("link_id") == arg1_89
	end)

	return var0_89 and var0_89.id
end

function var0_0.CheckDailyEventRequest(arg0_91, arg1_91)
	if arg1_91:CheckDailyEventRequest() then
		arg0_91:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1_91.id
		})
	end
end

return var0_0
