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

function var0_0.getAliveActivityByType(arg0_32, arg1_32)
	for iter0_32, iter1_32 in pairs(arg0_32.data) do
		if iter1_32:getConfig("type") == arg1_32 and not iter1_32:isEnd() then
			return iter1_32
		end
	end
end

function var0_0.getActivityByType(arg0_33, arg1_33)
	for iter0_33, iter1_33 in pairs(arg0_33.data) do
		if iter1_33:getConfig("type") == arg1_33 then
			return iter1_33
		end
	end
end

function var0_0.getActivitiesByType(arg0_34, arg1_34)
	local var0_34 = {}

	for iter0_34, iter1_34 in pairs(arg0_34.data) do
		if iter1_34:getConfig("type") == arg1_34 then
			table.insert(var0_34, iter1_34)
		end
	end

	return var0_34
end

function var0_0.getActivitiesByTypes(arg0_35, arg1_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		if table.contains(arg1_35, iter1_35:getConfig("type")) then
			table.insert(var0_35, iter1_35)
		end
	end

	return var0_35
end

function var0_0.GetEarliestActByType(arg0_36, arg1_36)
	local var0_36 = arg0_36:getActivitiesByType(arg1_36)
	local var1_36 = _.select(var0_36, function(arg0_37)
		return not arg0_37:isEnd()
	end)

	table.sort(var1_36, function(arg0_38, arg1_38)
		return arg0_38.id < arg1_38.id
	end)

	return var1_36[1]
end

function var0_0.getMilitaryExerciseActivity(arg0_39)
	local var0_39

	for iter0_39, iter1_39 in pairs(arg0_39.data) do
		if iter1_39:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			var0_39 = iter1_39

			break
		end
	end

	return Clone(var0_39)
end

function var0_0.getPanelActivities(arg0_40)
	local function var0_40(arg0_41)
		local var0_41 = arg0_41:getConfig("type")
		local var1_41 = arg0_41:isShow() and not arg0_41:isAfterShow()

		if var1_41 then
			if var0_41 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				var1_41 = arg0_41.data2 == 0
			elseif var0_41 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				var1_41 = arg0_41.data1 < 7 or not arg0_41.achieved
			end
		end

		return var1_41 and not arg0_41:isEnd()
	end

	local var1_40 = {}

	for iter0_40, iter1_40 in pairs(arg0_40.data) do
		if var0_40(iter1_40) then
			table.insert(var1_40, iter1_40)
		end
	end

	table.sort(var1_40, CompareFuncs({
		function(arg0_42)
			return -arg0_42:getConfig("login_pop")
		end,
		function(arg0_43)
			return arg0_43.id
		end
	}))

	return var1_40
end

function var0_0.checkHxActivity(arg0_44, arg1_44)
	if arg0_44.hxList and #arg0_44.hxList > 0 then
		for iter0_44 = 1, #arg0_44.hxList do
			if arg0_44.hxList[iter0_44] == arg1_44 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_45)
	return _(pg.activity_banner.all):chain():map(function(arg0_46)
		return pg.activity_banner[arg0_46]
	end):filter(function(arg0_47)
		return pg.TimeMgr.GetInstance():inTime(arg0_47.time) and arg0_47.type ~= GAMEUI_BANNER_9 and arg0_47.type ~= GAMEUI_BANNER_11 and arg0_47.type ~= GAMEUI_BANNER_10 and arg0_47.type ~= GAMEUI_BANNER_12 and arg0_47.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_48, arg1_48)
	local var0_48 = pg.activity_banner.get_id_list_by_type[arg1_48]

	if not var0_48 then
		return nil
	end

	for iter0_48, iter1_48 in ipairs(var0_48) do
		local var1_48 = pg.activity_banner[iter1_48]

		if pg.TimeMgr.GetInstance():inTime(var1_48.time) then
			return var1_48
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_49)
	return _.map(pg.activity_banner_notice.all, function(arg0_50)
		return pg.activity_banner_notice[arg0_50]
	end)
end

function var0_0.findNextAutoActivity(arg0_51)
	local var0_51
	local var1_51 = pg.TimeMgr.GetInstance()
	local var2_51 = var1_51:GetServerTime()

	for iter0_51, iter1_51 in ipairs(arg0_51:getPanelActivities()) do
		if iter1_51:isShow() and not iter1_51.autoActionForbidden then
			local var3_51 = iter1_51:getConfig("type")

			if var3_51 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var4_51 = iter1_51:getConfig("config_id")
				local var5_51 = pg.activity_7_day_sign[var4_51].front_drops

				if iter1_51.data1 < #var5_51 and not var1_51:IsSameDay(var2_51, iter1_51.data2) and var2_51 > iter1_51.data2 then
					var0_51 = iter1_51

					break
				end
			elseif var3_51 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var6_51 = getProxy(ChapterProxy)

				if iter1_51.data1 < 7 and not var1_51:IsSameDay(var2_51, iter1_51.data2) or iter1_51.data1 == 7 and not iter1_51.achieved and var6_51:isClear(204) then
					var0_51 = iter1_51

					break
				end
			elseif var3_51 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var7_51 = pg.TimeMgr.GetInstance():STimeDescS(var2_51, "*t")

				iter1_51:setSpecialData("reMonthSignDay", nil)

				if var7_51.year ~= iter1_51.data1 or var7_51.month ~= iter1_51.data2 then
					iter1_51.data1 = var7_51.year
					iter1_51.data2 = var7_51.month
					iter1_51.data1_list = {}
					var0_51 = iter1_51

					break
				elseif not table.contains(iter1_51.data1_list, var7_51.day) then
					var0_51 = iter1_51

					break
				elseif var7_51.day > #iter1_51.data1_list and pg.activity_month_sign[iter1_51.data2].resign_count > iter1_51.data3 then
					for iter2_51 = var7_51.day, 1, -1 do
						if not table.contains(iter1_51.data1_list, iter2_51) then
							iter1_51:setSpecialData("reMonthSignDay", iter2_51)

							break
						end
					end

					var0_51 = iter1_51
				end
			elseif iter1_51.id == ActivityConst.SHADOW_PLAY_ID and iter1_51.clientData1 == 0 then
				local var8_51 = iter1_51:getConfig("config_data")[1]
				local var9_51 = getProxy(TaskProxy)
				local var10_51 = var9_51:getTaskById(var8_51) or var9_51:getFinishTaskById(var8_51)

				if var10_51 and not var10_51:isReceive() then
					var0_51 = iter1_51

					break
				end
			end
		end
	end

	if not var0_51 then
		for iter3_51, iter4_51 in pairs(arg0_51.data) do
			if not iter4_51:isShow() and iter4_51:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var11_51 = iter4_51:getConfig("config_id")
				local var12_51 = pg.activity_7_day_sign[var11_51].front_drops

				if iter4_51.data1 < #var12_51 and not var1_51:IsSameDay(var2_51, iter4_51.data2) and var2_51 > iter4_51.data2 then
					var0_51 = iter4_51

					break
				end
			end
		end
	end

	return var0_51
end

function var0_0.findRefluxAutoActivity(arg0_52)
	local var0_52 = arg0_52:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_52 and not var0_52:isEnd() and not var0_52.autoActionForbidden then
		local var1_52 = pg.TimeMgr.GetInstance()

		if var0_52.data1_list[2] < #pg.return_sign_template.all and not var1_52:IsSameDay(var1_52:GetServerTime(), var0_52.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_53)
	local var0_53 = arg0_53:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_53 and not var0_53:isEnd() then
		local var1_53 = pg.return_pt_template

		for iter0_53 = #var1_53.all, 1, -1 do
			local var2_53 = var1_53.all[iter0_53]
			local var3_53 = var1_53[var2_53]

			if var0_53.data3 >= var3_53.pt_require and var2_53 > var0_53.data4 then
				return true
			end
		end

		local var4_53 = getProxy(TaskProxy)
		local var5_53 = _(var0_53:getConfig("config_data")[7]):chain():map(function(arg0_54)
			return arg0_54[2]
		end):flatten():map(function(arg0_55)
			return var4_53:getTaskById(arg0_55) or var4_53:getFinishTaskById(arg0_55) or false
		end):filter(function(arg0_56)
			return not not arg0_56
		end):value()

		if _.any(var5_53, function(arg0_57)
			return arg0_57:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_58, arg1_58)
	return Clone(arg0_58.data[arg1_58])
end

function var0_0.RawGetActivityById(arg0_59, arg1_59)
	return arg0_59.data[arg1_59]
end

function var0_0.updateActivity(arg0_60, arg1_60)
	assert(arg0_60.data[arg1_60.id], "activity should exist" .. arg1_60.id)
	assert(isa(arg1_60, Activity), "activity should instance of Activity")

	if arg1_60:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_60 = pg.battlepass_event_pt[arg1_60.id].target

		if arg0_60.data[arg1_60.id].data1 < var0_60[#var0_60] and arg1_60.data1 - arg0_60.data[arg1_60.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_60.id].pt,
				ptCount = arg1_60.data1 - arg0_60.data[arg1_60.id].data1
			})
		end
	end

	arg0_60.data[arg1_60.id] = arg1_60

	arg0_60:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_60:clone())
	arg0_60:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_60.id
	})
end

function var0_0.addActivity(arg0_61, arg1_61)
	assert(arg0_61.data[arg1_61.id] == nil, "activity already exist" .. arg1_61.id)
	assert(isa(arg1_61, Activity), "activity should instance of Activity")

	arg0_61.data[arg1_61.id] = arg1_61

	arg0_61:sendNotification(var0_0.ACTIVITY_ADDED, arg1_61:clone())

	if arg1_61.stopTime > 0 then
		table.insert(arg0_61.stopList, {
			arg1_61.stopTime,
			arg1_61.id
		})
		table.sort(arg0_61.stopList, CompareFuncs({
			function(arg0_62)
				return arg0_62[1]
			end
		}))
	end

	if arg1_61:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		table.insert(arg0_61.buffActs, arg1_61.id)
		arg0_61:refreshActivityBuffs()
	end
end

function var0_0.deleteActivityById(arg0_63, arg1_63)
	assert(arg0_63.data[arg1_63], "activity should exist" .. arg1_63)

	arg0_63.data[arg1_63] = nil

	arg0_63:sendNotification(var0_0.ACTIVITY_DELETED, arg1_63)

	local var0_63 = table.getIndex(arg0_63.stopList, function(arg0_64)
		return arg0_64[2] == arg1_63
	end)

	if var0_63 then
		table.remove(arg0_63.stopList, var0_63)
	end
end

function var0_0.IsActivityNotEnd(arg0_65, arg1_65)
	return arg0_65.data[arg1_65] and not arg0_65.data[arg1_65]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_66, arg1_66)
	local var0_66 = false
	local var1_66 = arg0_66:getActivitiesByType(arg1_66)

	for iter0_66, iter1_66 in ipairs(var1_66) do
		if iter1_66:readyToAchieve() then
			var0_66 = true

			break
		end
	end

	return var0_66
end

function var0_0.getBuildActivityCfgByID(arg0_67, arg1_67)
	local var0_67 = arg0_67:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})

	for iter0_67, iter1_67 in ipairs(var0_67) do
		if not iter1_67:isEnd() then
			local var1_67 = iter1_67:getConfig("config_client")

			if var1_67 and var1_67.id == arg1_67 then
				return var1_67
			end
		end
	end

	return nil
end

function var0_0.getNoneActBuildActivityCfgByID(arg0_68, arg1_68)
	local var0_68 = arg0_68:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
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

function var0_0.getBuffShipList(arg0_69)
	local var0_69 = {}
	local var1_69 = arg0_69:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_69, function(arg0_70)
		if arg0_70 and not arg0_70:isEnd() then
			local var0_70 = arg0_70:getConfig("config_id")
			local var1_70 = pg.activity_expup_ship[var0_70]

			if not var1_70 then
				return
			end

			local var2_70 = var1_70.expup

			for iter0_70, iter1_70 in pairs(var2_70) do
				var0_69[iter1_70[1]] = iter1_70[2]
			end
		end
	end)

	return var0_69
end

function var0_0.getVirtualItemNumber(arg0_71, arg1_71)
	local var0_71 = arg0_71:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_71 and not var0_71:isEnd() then
		return var0_71.data1KeyValueList[1][arg1_71] and var0_71.data1KeyValueList[1][arg1_71] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_72, arg1_72, arg2_72)
	local var0_72 = arg0_72:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_72, "vbagType invalid")

	if var0_72 and not var0_72:isEnd() then
		var0_72.data1KeyValueList[1][arg1_72] = var0_72.data1KeyValueList[1][arg1_72] - arg2_72
	end

	arg0_72:updateActivity(var0_72)
end

function var0_0.addVitemById(arg0_73, arg1_73, arg2_73)
	local var0_73 = arg0_73:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_73, "vbagType invalid")

	if var0_73 and not var0_73:isEnd() then
		if not var0_73.data1KeyValueList[1][arg1_73] then
			var0_73.data1KeyValueList[1][arg1_73] = 0
		end

		var0_73.data1KeyValueList[1][arg1_73] = var0_73.data1KeyValueList[1][arg1_73] + arg2_73
	end

	arg0_73:updateActivity(var0_73)

	local var1_73 = Item.getConfigData(arg1_73).link_id

	if var1_73 ~= 0 then
		local var2_73 = arg0_73:getActivityById(var1_73)

		if var2_73 and not var2_73:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_73, arg2_73)
		end
	end
end

function var0_0.monitorTaskList(arg0_74, arg1_74)
	if arg1_74 and not arg1_74:isEnd() and arg1_74:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_74 = arg1_74:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_74) then
			arg0_74:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_74.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_75, arg1_75, arg2_75)
	getProxy(FleetProxy):addActivityFleet(arg1_75, arg2_75.group_list)
end

function var0_0.InitActivityBossData(arg0_76, arg1_76)
	local var0_76 = pg.activity_event_worldboss[arg1_76:getConfig("config_id")]

	if not var0_76 then
		return
	end

	local var1_76 = arg1_76.data1KeyValueList

	for iter0_76, iter1_76 in pairs(var0_76.normal_expedition_drop_num or {}) do
		for iter2_76, iter3_76 in pairs(iter1_76[1]) do
			local var2_76 = iter1_76[2]
			local var3_76 = var1_76[1][iter3_76] or 0

			var1_76[1][iter3_76] = math.max(var2_76 - var3_76, 0)
			var1_76[2][iter3_76] = var1_76[2][iter3_76] or 0
		end
	end
end

function var0_0.AddInstagramTimer(arg0_77, arg1_77)
	arg0_77:RemoveInstagramTimer()

	local var0_77, var1_77 = arg0_77.data[arg1_77]:GetNextPushTime()

	if var0_77 then
		local var2_77 = var0_77 - pg.TimeMgr.GetInstance():GetServerTime()

		local function var3_77()
			arg0_77:sendNotification(GAME.ACT_INSTAGRAM_OP, {
				arg2 = 0,
				activity_id = arg1_77,
				cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
				arg1 = var1_77
			})
		end

		if var2_77 <= 0 then
			var3_77()
		else
			arg0_77.instagramTimer = Timer.New(function()
				var3_77()
				arg0_77:RemoveInstagramTimer()
			end, var2_77, 1)

			arg0_77.instagramTimer:Start()
		end
	end
end

function var0_0.RemoveInstagramTimer(arg0_80)
	if arg0_80.instagramTimer then
		arg0_80.instagramTimer:Stop()

		arg0_80.instagramTimer = nil
	end
end

function var0_0.RegisterRequestTime(arg0_81, arg1_81, arg2_81)
	if not arg1_81 or arg1_81 <= 0 then
		return
	end

	arg0_81.requestTime[arg1_81] = arg2_81
end

function var0_0.remove(arg0_82)
	arg0_82:RemoveInstagramTimer()
end

function var0_0.addActivityParameter(arg0_83, arg1_83)
	local var0_83 = arg1_83:getConfig("config_data")
	local var1_83 = arg1_83.stopTime

	for iter0_83, iter1_83 in ipairs(var0_83) do
		arg0_83.params[iter1_83[1]] = {
			iter1_83[2],
			var1_83
		}
	end
end

function var0_0.getActivityParameter(arg0_84, arg1_84)
	if arg0_84.params[arg1_84] then
		local var0_84, var1_84 = unpack(arg0_84.params[arg1_84])

		if not (var1_84 > 0) or not (var1_84 <= pg.TimeMgr.GetInstance():GetServerTime()) then
			return var0_84
		end
	end
end

function var0_0.IsShowFreeBuildMark(arg0_85, arg1_85)
	for iter0_85, iter1_85 in ipairs(arg0_85:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter1_85 and not iter1_85:isEnd() and iter1_85.data1 > 0 and iter1_85.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 and tobool(arg1_85) == (PlayerPrefs.GetString("Free_Build_Ticket_" .. iter1_85.id, "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")) then
			return iter1_85
		end
	end

	return false
end

function var0_0.getBuildFreeActivityByBuildId(arg0_86, arg1_86)
	for iter0_86, iter1_86 in ipairs(arg0_86:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if underscore.any(iter1_86:getConfig("config_data"), function(arg0_87)
			return arg0_87 == arg1_86
		end) then
			return iter1_86
		end
	end
end

function var0_0.getBuildPoolActivity(arg0_88, arg1_88)
	if arg1_88:IsActivity() then
		return arg0_88:getActivityById(arg1_88.activityId)
	end
end

function var0_0.getEnterReadyActivity(arg0_89)
	local var0_89 = {
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_90)
			return not arg0_90:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = false
	}
	local var1_89 = _.keys(var0_89)
	local var2_89 = {}

	for iter0_89, iter1_89 in ipairs(var1_89) do
		var2_89[iter1_89] = 0
	end

	for iter2_89, iter3_89 in pairs(arg0_89.data) do
		local var3_89 = iter3_89:getConfig("type")

		if var2_89[var3_89] and not iter3_89:isEnd() and not existCall(var0_89[var3_89], iter3_89) then
			var2_89[var3_89] = math.max(var2_89[var3_89], iter2_89)
		end
	end

	table.sort(var1_89)

	for iter4_89, iter5_89 in ipairs(var1_89) do
		if var2_89[iter5_89] > 0 then
			return arg0_89.data[var2_89[iter5_89]]
		end
	end
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_91)
	local var0_91 = arg0_91:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_91 or var0_91:isEnd() then
		return false
	end

	local var1_91 = var0_91:GetSlots()

	for iter0_91, iter1_91 in pairs(var1_91) do
		if iter1_91[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_92, arg1_92, arg2_92)
	local var0_92 = arg0_92:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_92 or var0_92:isEnd() then
		return false
	end

	local var1_92 = var0_92:GetItems()[arg1_92]

	return var1_92 and arg2_92 <= var1_92.count
end

function var0_0.refreshActivityBuffs(arg0_93)
	arg0_93.actBuffs = {}

	local var0_93 = 1

	while var0_93 <= #arg0_93.buffActs do
		local var1_93 = arg0_93.data[arg0_93.buffActs[var0_93]]

		if not var1_93 or var1_93:isEnd() then
			table.remove(arg0_93.buffActs, var0_93)
		else
			var0_93 = var0_93 + 1

			local var2_93 = {
				var1_93:getConfig("config_id")
			}

			if var2_93[1] == 0 then
				var2_93 = var1_93:getConfig("config_data")
			end

			for iter0_93, iter1_93 in ipairs(var2_93) do
				local var3_93 = ActivityBuff.New(var1_93.id, iter1_93)

				if var3_93:isActivate() then
					table.insert(arg0_93.actBuffs, var3_93)
				end
			end
		end
	end
end

function var0_0.getActivityBuffs(arg0_94)
	if underscore.any(arg0_94.buffActs, function(arg0_95)
		return not arg0_94.data[arg0_95] or arg0_94.data[arg0_95]:isEnd()
	end) or underscore.any(arg0_94.actBuffs, function(arg0_96)
		return not arg0_96:isActivate()
	end) then
		arg0_94:refreshActivityBuffs()
	end

	return arg0_94.actBuffs
end

function var0_0.getShipModExpActivity(arg0_97)
	return underscore.select(arg0_97:getActivityBuffs(), function(arg0_98)
		return arg0_98:ShipModExpUsage()
	end)
end

function var0_0.getBackyardEnergyActivityBuffs(arg0_99)
	return underscore.select(arg0_99:getActivityBuffs(), function(arg0_100)
		return arg0_100:BackyardEnergyUsage()
	end)
end

function var0_0.InitContinuousTime(arg0_101, arg1_101)
	arg0_101.continuousOpeartionTime = arg1_101
	arg0_101.continuousOpeartionTotalTime = arg1_101
end

function var0_0.UseContinuousTime(arg0_102)
	if not arg0_102.continuousOpeartionTime then
		return
	end

	arg0_102.continuousOpeartionTime = arg0_102.continuousOpeartionTime - 1
end

function var0_0.GetContinuousTime(arg0_103)
	return arg0_103.continuousOpeartionTime, arg0_103.continuousOpeartionTotalTime
end

function var0_0.AddBossRushAwards(arg0_104, arg1_104)
	arg0_104.bossrushAwards = arg0_104.bossrushAwards or {}

	table.insertto(arg0_104.bossrushAwards, arg1_104)
end

function var0_0.PopBossRushAwards(arg0_105)
	local var0_105 = arg0_105.bossrushAwards or {}

	arg0_105.bossrushAwards = nil

	return var0_105
end

function var0_0.GetBossRushRuntime(arg0_106, arg1_106)
	if not arg0_106.extraDatas[arg1_106] then
		arg0_106.extraDatas[arg1_106] = {
			record = 0
		}
	end

	return arg0_106.extraDatas[arg1_106]
end

function var0_0.GetActivityBossRuntime(arg0_107, arg1_107)
	if not arg0_107.extraDatas[arg1_107] then
		arg0_107.extraDatas[arg1_107] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0_107.extraDatas[arg1_107]
end

function var0_0.GetTaskActivities(arg0_108)
	local var0_108 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0_109, arg1_109)
		if not isa(arg1_109, ITaskActivity) then
			return
		end

		table.insertto(var0_108, arg0_108:getActivitiesByType(arg0_109))
	end)

	return var0_108
end

function var0_0.setSurveyState(arg0_110, arg1_110)
	local var0_110 = arg0_110:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_110 and not var0_110:isEnd() then
		arg0_110.surveyState = arg1_110
	end
end

function var0_0.isSurveyDone(arg0_111)
	local var0_111 = arg0_111:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_111 and not var0_111:isEnd() then
		return arg0_111.surveyState and arg0_111.surveyState > 0
	end
end

function var0_0.isSurveyOpen(arg0_112)
	local var0_112 = arg0_112:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_112 and not var0_112:isEnd() then
		local var1_112 = var0_112:getConfig("config_data")
		local var2_112 = var1_112[1]
		local var3_112 = var1_112[2]

		if var2_112 == 1 then
			local var4_112 = var3_112 <= getProxy(PlayerProxy):getData().level
			local var5_112 = var0_112:getConfig("config_id")

			return var4_112, var5_112
		end
	end
end

function var0_0.GetActBossLinkPTActID(arg0_113, arg1_113)
	local var0_113 = table.Find(arg0_113.data, function(arg0_114, arg1_114)
		if arg1_114:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1_114:getDataConfig("link_id") == arg1_113
	end)

	return var0_113 and var0_113.id
end

function var0_0.CheckDailyEventRequest(arg0_115, arg1_115)
	if arg1_115:CheckDailyEventRequest() then
		arg0_115:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1_115.id
		})
	end
end

return var0_0
