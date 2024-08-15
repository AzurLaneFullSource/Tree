local var0_0 = class("ActivityProxy", import(".NetProxy"))

var0_0.ACTIVITY_ADDED = "ActivityProxy ACTIVITY_ADDED"
var0_0.ACTIVITY_UPDATED = "ActivityProxy ACTIVITY_UPDATED"
var0_0.ACTIVITY_DELETED = "ActivityProxy ACTIVITY_DELETED"
var0_0.ACTIVITY_END = "ActivityProxy ACTIVITY_END"
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
		arg0_1.stopList = {}

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
			arg0_1:GetBossRushRuntime(var0_5.id).settlementData = var2_5
		end)()
	end)
	arg0_1:on(24100, function(arg0_7)
		(function()
			local var0_8 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK)

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

function var0_0.timeCall(arg0_11)
	return {
		[ProxyRegister.DayCall] = function(arg0_12)
			for iter0_12, iter1_12 in pairs(arg0_11.data) do
				if not iter1_12:isEnd() then
					switch(iter1_12:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function()
							iter1_12.autoActionForbidden = false

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN] = function()
							iter1_12.autoActionForbidden = false

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_MONTHSIGN] = function()
							iter1_12.autoActionForbidden = false

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_REFLUX] = function()
							iter1_12.data1KeyValueList = {
								{}
							}
							iter1_12.autoActionForbidden = false

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = function()
							iter1_12.autoActionForbidden = false

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_BB] = function()
							iter1_12.data2 = 0
							iter1_12.autoActionForbidden = false

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function()
							iter1_12.data2 = 0
							iter1_12.autoActionForbidden = false

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
							local var0_20 = iter1_12:GetUsedBonus()

							table.Foreach(var0_20, function(arg0_21, arg1_21)
								var0_20[arg0_21] = 0
							end)
							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
							local var0_22 = iter1_12:GetDailyCounts()

							table.Foreach(var0_22, function(arg0_23, arg1_23)
								var0_22[arg0_23] = 0
							end)
							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN] = function()
							arg0_11:sendNotification(GAME.ACT_MANUAL_SIGN, {
								activity_id = iter1_12.id,
								cmd = ManualSignActivity.OP_SIGN
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function()
							local var0_25 = iter1_12:getConfig("config_id")
							local var1_25 = pg.activity_event_turning[var0_25]

							if var1_25.total_num <= iter1_12.data3 then
								return
							end

							local var2_25 = var1_25.task_table[iter1_12.data4]

							if not var2_25 then
								return
							end

							local var3_25 = getProxy(TaskProxy)

							for iter0_25, iter1_25 in ipairs(var2_25) do
								if (var3_25:getTaskById(iter1_25) or var3_25:getFinishTaskById(iter1_25)):getTaskStatus() ~= 2 then
									return
								end
							end

							arg0_11:sendNotification(GAME.ACTIVITY_OPERATION, {
								cmd = 2,
								activity_id = iter1_12.id
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_MONOPOLY] = function()
							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_CHALLENGE] = function()
							arg0_11:sendNotification(GAME.CHALLENGE2_INFO, {})
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
							local var0_28 = iter1_12.data1KeyValueList[1]
							local var1_28 = pg.activity_event_worldboss[iter1_12:getConfig("config_id")]

							if var1_28 then
								for iter0_28, iter1_28 in ipairs(var1_28.normal_expedition_drop_num or {}) do
									for iter2_28, iter3_28 in ipairs(iter1_28[1]) do
										var0_28[iter3_28] = iter1_28[2] or 0
									end
								end
							end

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_RANDOM_DAILY_TASK] = function()
							local var0_29 = pg.TimeMgr.GetInstance():GetServerTime()

							if pg.TimeMgr.GetInstance():IsSameDay(iter1_12.data1, var0_29) then
								return
							end

							pg.m02:sendNotification(GAME.ACT_RANDOM_DAILY_TASK, {
								activity_id = iter1_12.id,
								cmd = ActivityConst.RANDOM_DAILY_TASK_OP_RANDOM
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE] = function()
							arg0_11:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
								actId = iter1_12.id
							})
						end
					})
				end
			end
		end,
		[ProxyRegister.SecondCall] = function(arg0_31)
			for iter0_31, iter1_31 in pairs(arg0_11.data) do
				if not iter1_31:isEnd() then
					switch(iter1_31:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_TOWN] = function()
							iter1_31:UpdateTime()
						end
					})
				end
			end

			if not arg0_11.stopList then
				return
			end

			local var0_31 = pg.TimeMgr.GetInstance():GetServerTime()

			while #arg0_11.stopList > 0 and var0_31 >= arg0_11.stopList[1][1] do
				local var1_31, var2_31 = unpack(table.remove(arg0_11.stopList, 1))

				if arg0_11.data[var2_31]:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
					getProxy(MilitaryExerciseProxy):setSeasonOver()
				end

				pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
				arg0_11:sendNotification(var0_0.ACTIVITY_END, var2_31)
			end
		end
	}
end

function var0_0.getAliveActivityByType(arg0_33, arg1_33)
	for iter0_33, iter1_33 in pairs(arg0_33.data) do
		if iter1_33:getConfig("type") == arg1_33 and not iter1_33:isEnd() then
			return iter1_33
		end
	end
end

function var0_0.getActivityByType(arg0_34, arg1_34)
	for iter0_34, iter1_34 in pairs(arg0_34.data) do
		if iter1_34:getConfig("type") == arg1_34 then
			return iter1_34
		end
	end
end

function var0_0.getActivitiesByType(arg0_35, arg1_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		if iter1_35:getConfig("type") == arg1_35 then
			table.insert(var0_35, iter1_35)
		end
	end

	return var0_35
end

function var0_0.getActivitiesByTypes(arg0_36, arg1_36)
	local var0_36 = {}

	for iter0_36, iter1_36 in pairs(arg0_36.data) do
		if table.contains(arg1_36, iter1_36:getConfig("type")) then
			table.insert(var0_36, iter1_36)
		end
	end

	return var0_36
end

function var0_0.GetEarliestActByType(arg0_37, arg1_37)
	local var0_37 = arg0_37:getActivitiesByType(arg1_37)
	local var1_37 = _.select(var0_37, function(arg0_38)
		return not arg0_38:isEnd()
	end)

	table.sort(var1_37, function(arg0_39, arg1_39)
		return arg0_39.id < arg1_39.id
	end)

	return var1_37[1]
end

function var0_0.getMilitaryExerciseActivity(arg0_40)
	local var0_40

	for iter0_40, iter1_40 in pairs(arg0_40.data) do
		if iter1_40:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			var0_40 = iter1_40

			break
		end
	end

	return Clone(var0_40)
end

function var0_0.getPanelActivities(arg0_41)
	local function var0_41(arg0_42)
		local var0_42 = arg0_42:getConfig("type")
		local var1_42 = arg0_42:isShow() and not arg0_42:isAfterShow()

		if var1_42 then
			if var0_42 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				var1_42 = arg0_42.data2 == 0
			elseif var0_42 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				var1_42 = arg0_42.data1 < 7 or not arg0_42.achieved
			end
		end

		return var1_42 and not arg0_42:isEnd()
	end

	local var1_41 = {}

	for iter0_41, iter1_41 in pairs(arg0_41.data) do
		if var0_41(iter1_41) then
			table.insert(var1_41, iter1_41)
		end
	end

	table.sort(var1_41, CompareFuncs({
		function(arg0_43)
			return -arg0_43:getConfig("login_pop")
		end,
		function(arg0_44)
			return arg0_44.id
		end
	}))

	return var1_41
end

function var0_0.checkHxActivity(arg0_45, arg1_45)
	if arg0_45.hxList and #arg0_45.hxList > 0 then
		for iter0_45 = 1, #arg0_45.hxList do
			if arg0_45.hxList[iter0_45] == arg1_45 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_46)
	return _(pg.activity_banner.all):chain():map(function(arg0_47)
		return pg.activity_banner[arg0_47]
	end):filter(function(arg0_48)
		return pg.TimeMgr.GetInstance():inTime(arg0_48.time) and arg0_48.type ~= GAMEUI_BANNER_9 and arg0_48.type ~= GAMEUI_BANNER_11 and arg0_48.type ~= GAMEUI_BANNER_10 and arg0_48.type ~= GAMEUI_BANNER_12 and arg0_48.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_49, arg1_49)
	local var0_49 = pg.activity_banner.get_id_list_by_type[arg1_49]

	if not var0_49 then
		return nil
	end

	for iter0_49, iter1_49 in ipairs(var0_49) do
		local var1_49 = pg.activity_banner[iter1_49]

		if pg.TimeMgr.GetInstance():inTime(var1_49.time) then
			return var1_49
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_50)
	return _.map(pg.activity_banner_notice.all, function(arg0_51)
		return pg.activity_banner_notice[arg0_51]
	end)
end

function var0_0.findNextAutoActivity(arg0_52)
	local var0_52
	local var1_52 = pg.TimeMgr.GetInstance()
	local var2_52 = var1_52:GetServerTime()

	for iter0_52, iter1_52 in ipairs(arg0_52:getPanelActivities()) do
		if iter1_52:isShow() and not iter1_52.autoActionForbidden then
			local var3_52 = iter1_52:getConfig("type")

			if var3_52 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var4_52 = iter1_52:getConfig("config_id")
				local var5_52 = pg.activity_7_day_sign[var4_52].front_drops

				if iter1_52.data1 < #var5_52 and not var1_52:IsSameDay(var2_52, iter1_52.data2) and var2_52 > iter1_52.data2 then
					var0_52 = iter1_52

					break
				end
			elseif var3_52 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var6_52 = getProxy(ChapterProxy)

				if iter1_52.data1 < 7 and not var1_52:IsSameDay(var2_52, iter1_52.data2) or iter1_52.data1 == 7 and not iter1_52.achieved and var6_52:isClear(204) then
					var0_52 = iter1_52

					break
				end
			elseif var3_52 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var7_52 = pg.TimeMgr.GetInstance():STimeDescS(var2_52, "*t")

				iter1_52:setSpecialData("reMonthSignDay", nil)

				if var7_52.year ~= iter1_52.data1 or var7_52.month ~= iter1_52.data2 then
					iter1_52.data1 = var7_52.year
					iter1_52.data2 = var7_52.month
					iter1_52.data1_list = {}
					var0_52 = iter1_52

					break
				elseif not table.contains(iter1_52.data1_list, var7_52.day) then
					var0_52 = iter1_52

					break
				elseif var7_52.day > #iter1_52.data1_list and pg.activity_month_sign[iter1_52.data2].resign_count > iter1_52.data3 then
					for iter2_52 = var7_52.day, 1, -1 do
						if not table.contains(iter1_52.data1_list, iter2_52) then
							iter1_52:setSpecialData("reMonthSignDay", iter2_52)

							break
						end
					end

					var0_52 = iter1_52
				end
			elseif iter1_52.id == ActivityConst.SHADOW_PLAY_ID and iter1_52.clientData1 == 0 then
				local var8_52 = iter1_52:getConfig("config_data")[1]
				local var9_52 = getProxy(TaskProxy)
				local var10_52 = var9_52:getTaskById(var8_52) or var9_52:getFinishTaskById(var8_52)

				if var10_52 and not var10_52:isReceive() then
					var0_52 = iter1_52

					break
				end
			end
		end
	end

	if not var0_52 then
		for iter3_52, iter4_52 in pairs(arg0_52.data) do
			if not iter4_52:isShow() and iter4_52:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var11_52 = iter4_52:getConfig("config_id")
				local var12_52 = pg.activity_7_day_sign[var11_52].front_drops

				if iter4_52.data1 < #var12_52 and not var1_52:IsSameDay(var2_52, iter4_52.data2) and var2_52 > iter4_52.data2 then
					var0_52 = iter4_52

					break
				end
			end
		end
	end

	return var0_52
end

function var0_0.findRefluxAutoActivity(arg0_53)
	local var0_53 = arg0_53:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_53 and not var0_53:isEnd() and not var0_53.autoActionForbidden then
		local var1_53 = pg.TimeMgr.GetInstance()

		if var0_53.data1_list[2] < #pg.return_sign_template.all and not var1_53:IsSameDay(var1_53:GetServerTime(), var0_53.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_54)
	local var0_54 = arg0_54:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_54 and not var0_54:isEnd() then
		local var1_54 = pg.return_pt_template

		for iter0_54 = #var1_54.all, 1, -1 do
			local var2_54 = var1_54.all[iter0_54]
			local var3_54 = var1_54[var2_54]

			if var0_54.data3 >= var3_54.pt_require and var2_54 > var0_54.data4 then
				return true
			end
		end

		local var4_54 = getProxy(TaskProxy)
		local var5_54 = _(var0_54:getConfig("config_data")[7]):chain():map(function(arg0_55)
			return arg0_55[2]
		end):flatten():map(function(arg0_56)
			return var4_54:getTaskById(arg0_56) or var4_54:getFinishTaskById(arg0_56) or false
		end):filter(function(arg0_57)
			return not not arg0_57
		end):value()

		if _.any(var5_54, function(arg0_58)
			return arg0_58:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_59, arg1_59)
	return Clone(arg0_59.data[arg1_59])
end

function var0_0.RawGetActivityById(arg0_60, arg1_60)
	return arg0_60.data[arg1_60]
end

function var0_0.updateActivity(arg0_61, arg1_61)
	assert(arg0_61.data[arg1_61.id], "activity should exist" .. arg1_61.id)
	assert(isa(arg1_61, Activity), "activity should instance of Activity")

	if arg1_61:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_61 = pg.battlepass_event_pt[arg1_61.id].target

		if arg0_61.data[arg1_61.id].data1 < var0_61[#var0_61] and arg1_61.data1 - arg0_61.data[arg1_61.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_61.id].pt,
				ptCount = arg1_61.data1 - arg0_61.data[arg1_61.id].data1
			})
		end
	end

	arg0_61.data[arg1_61.id] = arg1_61

	arg0_61:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_61:clone())
	arg0_61:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_61.id
	})
end

function var0_0.addActivity(arg0_62, arg1_62)
	assert(arg0_62.data[arg1_62.id] == nil, "activity already exist" .. arg1_62.id)
	assert(isa(arg1_62, Activity), "activity should instance of Activity")

	arg0_62.data[arg1_62.id] = arg1_62

	arg0_62:sendNotification(var0_0.ACTIVITY_ADDED, arg1_62:clone())

	if arg1_62.stopTime > 0 then
		table.insert(arg0_62.stopList, {
			arg1_62.stopTime,
			arg1_62.id
		})
		table.sort(arg0_62.stopList, CompareFuncs({
			function(arg0_63)
				return arg0_63[1]
			end
		}))
	end

	if arg1_62:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		table.insert(arg0_62.buffActs, arg1_62.id)
		arg0_62:refreshActivityBuffs()
	end
end

function var0_0.deleteActivityById(arg0_64, arg1_64)
	assert(arg0_64.data[arg1_64], "activity should exist" .. arg1_64)

	arg0_64.data[arg1_64] = nil

	arg0_64:sendNotification(var0_0.ACTIVITY_DELETED, arg1_64)

	local var0_64 = table.getIndex(arg0_64.stopList, function(arg0_65)
		return arg0_65[2] == arg1_64
	end)

	if var0_64 then
		table.remove(arg0_64.stopList, var0_64)
	end
end

function var0_0.IsActivityNotEnd(arg0_66, arg1_66)
	return arg0_66.data[arg1_66] and not arg0_66.data[arg1_66]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_67, arg1_67)
	local var0_67 = false
	local var1_67 = arg0_67:getActivitiesByType(arg1_67)

	for iter0_67, iter1_67 in ipairs(var1_67) do
		if iter1_67:readyToAchieve() then
			var0_67 = true

			break
		end
	end

	return var0_67
end

function var0_0.getBuildActivityCfgByID(arg0_68, arg1_68)
	local var0_68 = arg0_68:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})

	for iter0_68, iter1_68 in ipairs(var0_68) do
		if not iter1_68:isEnd() then
			local var1_68 = iter1_68:getConfig("config_client")

			if var1_68 and var1_68.id == arg1_68 then
				return var1_68
			end
		end
	end

	return nil
end

function var0_0.getNoneActBuildActivityCfgByID(arg0_69, arg1_69)
	local var0_69 = arg0_69:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0_69, iter1_69 in ipairs(var0_69) do
		if not iter1_69:isEnd() then
			local var1_69 = iter1_69:getConfig("config_client")

			if var1_69 and var1_69.id == arg1_69 then
				return var1_69
			end
		end
	end

	return nil
end

function var0_0.getBuffShipList(arg0_70)
	local var0_70 = {}
	local var1_70 = arg0_70:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_70, function(arg0_71)
		if arg0_71 and not arg0_71:isEnd() then
			local var0_71 = arg0_71:getConfig("config_id")
			local var1_71 = pg.activity_expup_ship[var0_71]

			if not var1_71 then
				return
			end

			local var2_71 = var1_71.expup

			for iter0_71, iter1_71 in pairs(var2_71) do
				var0_70[iter1_71[1]] = iter1_71[2]
			end
		end
	end)

	return var0_70
end

function var0_0.getVirtualItemNumber(arg0_72, arg1_72)
	local var0_72 = arg0_72:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_72 and not var0_72:isEnd() then
		return var0_72.data1KeyValueList[1][arg1_72] and var0_72.data1KeyValueList[1][arg1_72] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_73, arg1_73, arg2_73)
	local var0_73 = arg0_73:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_73, "vbagType invalid")

	if var0_73 and not var0_73:isEnd() then
		var0_73.data1KeyValueList[1][arg1_73] = var0_73.data1KeyValueList[1][arg1_73] - arg2_73
	end

	arg0_73:updateActivity(var0_73)
end

function var0_0.addVitemById(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg0_74:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_74, "vbagType invalid")

	if var0_74 and not var0_74:isEnd() then
		if not var0_74.data1KeyValueList[1][arg1_74] then
			var0_74.data1KeyValueList[1][arg1_74] = 0
		end

		var0_74.data1KeyValueList[1][arg1_74] = var0_74.data1KeyValueList[1][arg1_74] + arg2_74
	end

	arg0_74:updateActivity(var0_74)

	local var1_74 = Item.getConfigData(arg1_74).link_id

	if var1_74 ~= 0 then
		local var2_74 = arg0_74:getActivityById(var1_74)

		if var2_74 and not var2_74:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_74, arg2_74)
		end
	end
end

function var0_0.monitorTaskList(arg0_75, arg1_75)
	if arg1_75 and not arg1_75:isEnd() and arg1_75:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_75 = arg1_75:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_75) then
			arg0_75:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_75.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_76, arg1_76, arg2_76)
	getProxy(FleetProxy):addActivityFleet(arg1_76, arg2_76.group_list)
end

function var0_0.InitActivityBossData(arg0_77, arg1_77)
	local var0_77 = pg.activity_event_worldboss[arg1_77:getConfig("config_id")]

	if not var0_77 then
		return
	end

	local var1_77 = arg1_77.data1KeyValueList

	for iter0_77, iter1_77 in pairs(var0_77.normal_expedition_drop_num or {}) do
		for iter2_77, iter3_77 in pairs(iter1_77[1]) do
			local var2_77 = iter1_77[2]
			local var3_77 = var1_77[1][iter3_77] or 0

			var1_77[1][iter3_77] = math.max(var2_77 - var3_77, 0)
			var1_77[2][iter3_77] = var1_77[2][iter3_77] or 0
		end
	end
end

function var0_0.AddInstagramTimer(arg0_78, arg1_78)
	arg0_78:RemoveInstagramTimer()

	local var0_78, var1_78 = arg0_78.data[arg1_78]:GetNextPushTime()

	if var0_78 then
		local var2_78 = var0_78 - pg.TimeMgr.GetInstance():GetServerTime()

		local function var3_78()
			arg0_78:sendNotification(GAME.ACT_INSTAGRAM_OP, {
				arg2 = 0,
				activity_id = arg1_78,
				cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
				arg1 = var1_78
			})
		end

		if var2_78 <= 0 then
			var3_78()
		else
			arg0_78.instagramTimer = Timer.New(function()
				var3_78()
				arg0_78:RemoveInstagramTimer()
			end, var2_78, 1)

			arg0_78.instagramTimer:Start()
		end
	end
end

function var0_0.RemoveInstagramTimer(arg0_81)
	if arg0_81.instagramTimer then
		arg0_81.instagramTimer:Stop()

		arg0_81.instagramTimer = nil
	end
end

function var0_0.RegisterRequestTime(arg0_82, arg1_82, arg2_82)
	if not arg1_82 or arg1_82 <= 0 then
		return
	end

	arg0_82.requestTime[arg1_82] = arg2_82
end

function var0_0.remove(arg0_83)
	arg0_83:RemoveInstagramTimer()
end

function var0_0.addActivityParameter(arg0_84, arg1_84)
	local var0_84 = arg1_84:getConfig("config_data")
	local var1_84 = arg1_84.stopTime

	for iter0_84, iter1_84 in ipairs(var0_84) do
		arg0_84.params[iter1_84[1]] = {
			iter1_84[2],
			var1_84
		}
	end
end

function var0_0.getActivityParameter(arg0_85, arg1_85)
	if arg0_85.params[arg1_85] then
		local var0_85, var1_85 = unpack(arg0_85.params[arg1_85])

		if not (var1_85 > 0) or not (var1_85 <= pg.TimeMgr.GetInstance():GetServerTime()) then
			return var0_85
		end
	end
end

function var0_0.IsShowFreeBuildMark(arg0_86, arg1_86)
	for iter0_86, iter1_86 in ipairs(arg0_86:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter1_86 and not iter1_86:isEnd() and iter1_86.data1 > 0 and iter1_86.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 and tobool(arg1_86) == (PlayerPrefs.GetString("Free_Build_Ticket_" .. iter1_86.id, "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")) then
			return iter1_86
		end
	end

	return false
end

function var0_0.getBuildFreeActivityByBuildId(arg0_87, arg1_87)
	for iter0_87, iter1_87 in ipairs(arg0_87:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if underscore.any(iter1_87:getConfig("config_data"), function(arg0_88)
			return arg0_88 == arg1_87
		end) then
			return iter1_87
		end
	end
end

function var0_0.getBuildPoolActivity(arg0_89, arg1_89)
	if arg1_89:IsActivity() then
		return arg0_89:getActivityById(arg1_89.activityId)
	end
end

function var0_0.getEnterReadyActivity(arg0_90)
	local var0_90 = {
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_91)
			return not arg0_91:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = false
	}
	local var1_90 = _.keys(var0_90)
	local var2_90 = {}

	for iter0_90, iter1_90 in ipairs(var1_90) do
		var2_90[iter1_90] = 0
	end

	for iter2_90, iter3_90 in pairs(arg0_90.data) do
		local var3_90 = iter3_90:getConfig("type")

		if var2_90[var3_90] and not iter3_90:isEnd() and not existCall(var0_90[var3_90], iter3_90) then
			var2_90[var3_90] = math.max(var2_90[var3_90], iter2_90)
		end
	end

	table.sort(var1_90)

	for iter4_90, iter5_90 in ipairs(var1_90) do
		if var2_90[iter5_90] > 0 then
			return arg0_90.data[var2_90[iter5_90]]
		end
	end
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_92)
	local var0_92 = arg0_92:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_92 or var0_92:isEnd() then
		return false
	end

	local var1_92 = var0_92:GetSlots()

	for iter0_92, iter1_92 in pairs(var1_92) do
		if iter1_92[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_93, arg1_93, arg2_93)
	local var0_93 = arg0_93:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_93 or var0_93:isEnd() then
		return false
	end

	local var1_93 = var0_93:GetItems()[arg1_93]

	return var1_93 and arg2_93 <= var1_93.count
end

function var0_0.refreshActivityBuffs(arg0_94)
	arg0_94.actBuffs = {}

	local var0_94 = 1

	while var0_94 <= #arg0_94.buffActs do
		local var1_94 = arg0_94.data[arg0_94.buffActs[var0_94]]

		if not var1_94 or var1_94:isEnd() then
			table.remove(arg0_94.buffActs, var0_94)
		else
			var0_94 = var0_94 + 1

			local var2_94 = {
				var1_94:getConfig("config_id")
			}

			if var2_94[1] == 0 then
				var2_94 = var1_94:getConfig("config_data")
			end

			for iter0_94, iter1_94 in ipairs(var2_94) do
				local var3_94 = ActivityBuff.New(var1_94.id, iter1_94)

				if var3_94:isActivate() then
					table.insert(arg0_94.actBuffs, var3_94)
				end
			end
		end
	end
end

function var0_0.getActivityBuffs(arg0_95)
	if underscore.any(arg0_95.buffActs, function(arg0_96)
		return not arg0_95.data[arg0_96] or arg0_95.data[arg0_96]:isEnd()
	end) or underscore.any(arg0_95.actBuffs, function(arg0_97)
		return not arg0_97:isActivate()
	end) then
		arg0_95:refreshActivityBuffs()
	end

	return arg0_95.actBuffs
end

function var0_0.getShipModExpActivity(arg0_98)
	return underscore.select(arg0_98:getActivityBuffs(), function(arg0_99)
		return arg0_99:ShipModExpUsage()
	end)
end

function var0_0.getBackyardEnergyActivityBuffs(arg0_100)
	return underscore.select(arg0_100:getActivityBuffs(), function(arg0_101)
		return arg0_101:BackyardEnergyUsage()
	end)
end

function var0_0.InitContinuousTime(arg0_102, arg1_102)
	arg0_102.continuousOpeartionTime = arg1_102
	arg0_102.continuousOpeartionTotalTime = arg1_102
end

function var0_0.UseContinuousTime(arg0_103)
	if not arg0_103.continuousOpeartionTime then
		return
	end

	arg0_103.continuousOpeartionTime = arg0_103.continuousOpeartionTime - 1
end

function var0_0.GetContinuousTime(arg0_104)
	return arg0_104.continuousOpeartionTime, arg0_104.continuousOpeartionTotalTime
end

function var0_0.AddBossRushAwards(arg0_105, arg1_105)
	arg0_105.bossrushAwards = arg0_105.bossrushAwards or {}

	table.insertto(arg0_105.bossrushAwards, arg1_105)
end

function var0_0.PopBossRushAwards(arg0_106)
	local var0_106 = arg0_106.bossrushAwards or {}

	arg0_106.bossrushAwards = nil

	return var0_106
end

function var0_0.GetBossRushRuntime(arg0_107, arg1_107)
	if not arg0_107.extraDatas[arg1_107] then
		arg0_107.extraDatas[arg1_107] = {
			record = 0
		}
	end

	return arg0_107.extraDatas[arg1_107]
end

function var0_0.GetActivityBossRuntime(arg0_108, arg1_108)
	if not arg0_108.extraDatas[arg1_108] then
		arg0_108.extraDatas[arg1_108] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0_108.extraDatas[arg1_108]
end

function var0_0.GetTaskActivities(arg0_109)
	local var0_109 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0_110, arg1_110)
		if not isa(arg1_110, ITaskActivity) then
			return
		end

		table.insertto(var0_109, arg0_109:getActivitiesByType(arg0_110))
	end)

	return var0_109
end

function var0_0.setSurveyState(arg0_111, arg1_111)
	local var0_111 = arg0_111:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_111 and not var0_111:isEnd() then
		arg0_111.surveyState = arg1_111
	end
end

function var0_0.isSurveyDone(arg0_112)
	local var0_112 = arg0_112:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_112 and not var0_112:isEnd() then
		return arg0_112.surveyState and arg0_112.surveyState > 0
	end
end

function var0_0.isSurveyOpen(arg0_113)
	local var0_113 = arg0_113:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_113 and not var0_113:isEnd() then
		local var1_113 = var0_113:getConfig("config_data")
		local var2_113 = var1_113[1]
		local var3_113 = var1_113[2]

		if var2_113 == 1 then
			local var4_113 = var3_113 <= getProxy(PlayerProxy):getData().level
			local var5_113 = var0_113:getConfig("config_id")

			return var4_113, var5_113
		end
	end
end

function var0_0.GetActBossLinkPTActID(arg0_114, arg1_114)
	local var0_114 = table.Find(arg0_114.data, function(arg0_115, arg1_115)
		if arg1_115:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1_115:getDataConfig("link_id") == arg1_114
	end)

	return var0_114 and var0_114.id
end

function var0_0.CheckDailyEventRequest(arg0_116, arg1_116)
	if arg1_116:CheckDailyEventRequest() then
		arg0_116:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1_116.id
		})
	end
end

return var0_0
