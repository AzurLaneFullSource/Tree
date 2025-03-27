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
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE then
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
						[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN] = function()
							arg0_11:sendNotification(GAME.ACT_MANUAL_SIGN, {
								activity_id = iter1_12.id,
								cmd = ManualSignActivity.OP_SIGN
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function()
							local var0_26 = iter1_12:getConfig("config_id")
							local var1_26 = pg.activity_event_turning[var0_26]

							if var1_26.total_num <= iter1_12.data3 then
								return
							end

							local var2_26 = var1_26.task_table[iter1_12.data4]

							if not var2_26 then
								return
							end

							local var3_26 = getProxy(TaskProxy)

							for iter0_26, iter1_26 in ipairs(var2_26) do
								if (var3_26:getTaskById(iter1_26) or var3_26:getFinishTaskById(iter1_26)):getTaskStatus() ~= 2 then
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
							local var0_29 = iter1_12.data1KeyValueList[1]
							local var1_29 = pg.activity_event_worldboss[iter1_12:getConfig("config_id")]

							if var1_29 then
								for iter0_29, iter1_29 in ipairs(var1_29.normal_expedition_drop_num or {}) do
									for iter2_29, iter3_29 in ipairs(iter1_29[1]) do
										var0_29[iter3_29] = iter1_29[2] or 0
									end
								end
							end

							arg0_11:updateActivity(iter1_12)
						end,
						[ActivityConst.ACTIVITY_TYPE_RANDOM_DAILY_TASK] = function()
							local var0_30 = pg.TimeMgr.GetInstance():GetServerTime()

							if pg.TimeMgr.GetInstance():IsSameDay(iter1_12.data1, var0_30) then
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
		[ProxyRegister.SecondCall] = function(arg0_32)
			for iter0_32, iter1_32 in pairs(arg0_11.data) do
				if not iter1_32:isEnd() then
					switch(iter1_32:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_TOWN] = function()
							iter1_32:UpdateTime()
						end
					})
				end
			end

			if not arg0_11.stopList then
				return
			end

			local var0_32 = pg.TimeMgr.GetInstance():GetServerTime()

			while #arg0_11.stopList > 0 and var0_32 >= arg0_11.stopList[1][1] do
				local var1_32, var2_32 = unpack(table.remove(arg0_11.stopList, 1))

				if arg0_11.data[var2_32]:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
					getProxy(MilitaryExerciseProxy):setSeasonOver()
				end

				pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
				arg0_11:sendNotification(var0_0.ACTIVITY_END, var2_32)
			end
		end
	}
end

function var0_0.getAliveActivityByType(arg0_34, arg1_34)
	for iter0_34, iter1_34 in pairs(arg0_34.data) do
		if iter1_34:getConfig("type") == arg1_34 and not iter1_34:isEnd() then
			return iter1_34
		end
	end
end

function var0_0.getActivityByType(arg0_35, arg1_35)
	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		if iter1_35:getConfig("type") == arg1_35 then
			return iter1_35
		end
	end
end

function var0_0.getActivitiesByType(arg0_36, arg1_36)
	local var0_36 = {}

	for iter0_36, iter1_36 in pairs(arg0_36.data) do
		if iter1_36:getConfig("type") == arg1_36 then
			table.insert(var0_36, iter1_36)
		end
	end

	return var0_36
end

function var0_0.getActivitiesByTypes(arg0_37, arg1_37)
	local var0_37 = {}

	for iter0_37, iter1_37 in pairs(arg0_37.data) do
		if table.contains(arg1_37, iter1_37:getConfig("type")) then
			table.insert(var0_37, iter1_37)
		end
	end

	return var0_37
end

function var0_0.getMilitaryExerciseActivity(arg0_38)
	local var0_38

	for iter0_38, iter1_38 in pairs(arg0_38.data) do
		if iter1_38:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			var0_38 = iter1_38

			break
		end
	end

	return Clone(var0_38)
end

function var0_0.getPanelActivities(arg0_39)
	local function var0_39(arg0_40)
		local var0_40 = arg0_40:getConfig("type")
		local var1_40 = arg0_40:isShow() and not arg0_40:isAfterShow()

		if var1_40 then
			if var0_40 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				var1_40 = arg0_40.data2 == 0
			elseif var0_40 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				var1_40 = arg0_40.data1 < 7 or not arg0_40.achieved
			end
		end

		return var1_40 and not arg0_40:isEnd()
	end

	local var1_39 = {}

	for iter0_39, iter1_39 in pairs(arg0_39.data) do
		if var0_39(iter1_39) then
			table.insert(var1_39, iter1_39)
		end
	end

	table.sort(var1_39, CompareFuncs({
		function(arg0_41)
			return -arg0_41:getConfig("login_pop")
		end,
		function(arg0_42)
			return arg0_42.id
		end
	}))

	return var1_39
end

function var0_0.checkHxActivity(arg0_43, arg1_43)
	if arg0_43.hxList and #arg0_43.hxList > 0 then
		for iter0_43 = 1, #arg0_43.hxList do
			if arg0_43.hxList[iter0_43] == arg1_43 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_44)
	return _(pg.activity_banner.all):chain():map(function(arg0_45)
		return pg.activity_banner[arg0_45]
	end):filter(function(arg0_46)
		return pg.TimeMgr.GetInstance():inTime(arg0_46.time) and arg0_46.type ~= GAMEUI_BANNER_9 and arg0_46.type ~= GAMEUI_BANNER_11 and arg0_46.type ~= GAMEUI_BANNER_10 and arg0_46.type ~= GAMEUI_BANNER_12 and arg0_46.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_47, arg1_47)
	local var0_47 = pg.activity_banner.get_id_list_by_type[arg1_47]

	if not var0_47 then
		return nil
	end

	for iter0_47, iter1_47 in ipairs(var0_47) do
		local var1_47 = pg.activity_banner[iter1_47]

		if pg.TimeMgr.GetInstance():inTime(var1_47.time) then
			return var1_47
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_48)
	return _.map(pg.activity_banner_notice.all, function(arg0_49)
		return pg.activity_banner_notice[arg0_49]
	end)
end

function var0_0.findNextAutoActivity(arg0_50)
	local var0_50
	local var1_50 = pg.TimeMgr.GetInstance()
	local var2_50 = var1_50:GetServerTime()

	for iter0_50, iter1_50 in ipairs(arg0_50:getPanelActivities()) do
		if iter1_50:isShow() and not iter1_50.autoActionForbidden then
			local var3_50 = iter1_50:getConfig("type")

			if var3_50 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var4_50 = iter1_50:getConfig("config_id")
				local var5_50 = pg.activity_7_day_sign[var4_50].front_drops

				if iter1_50.data1 < #var5_50 and not var1_50:IsSameDay(var2_50, iter1_50.data2) and var2_50 > iter1_50.data2 then
					var0_50 = iter1_50

					break
				end
			elseif var3_50 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var6_50 = getProxy(ChapterProxy)

				if iter1_50.data1 < 7 and not var1_50:IsSameDay(var2_50, iter1_50.data2) or iter1_50.data1 == 7 and not iter1_50.achieved and var6_50:isClear(204) then
					var0_50 = iter1_50

					break
				end
			elseif var3_50 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var7_50 = pg.TimeMgr.GetInstance():STimeDescS(var2_50, "*t")

				iter1_50:setSpecialData("reMonthSignDay", nil)

				if var7_50.year ~= iter1_50.data1 or var7_50.month ~= iter1_50.data2 then
					iter1_50.data1 = var7_50.year
					iter1_50.data2 = var7_50.month
					iter1_50.data1_list = {}
					var0_50 = iter1_50

					break
				elseif not table.contains(iter1_50.data1_list, var7_50.day) then
					var0_50 = iter1_50

					break
				elseif var7_50.day > #iter1_50.data1_list and pg.activity_month_sign[iter1_50.data2].resign_count > iter1_50.data3 then
					for iter2_50 = var7_50.day, 1, -1 do
						if not table.contains(iter1_50.data1_list, iter2_50) then
							iter1_50:setSpecialData("reMonthSignDay", iter2_50)

							break
						end
					end

					var0_50 = iter1_50
				end
			elseif iter1_50.id == ActivityConst.SHADOW_PLAY_ID and iter1_50.clientData1 == 0 then
				local var8_50 = iter1_50:getConfig("config_data")[1]
				local var9_50 = getProxy(TaskProxy)
				local var10_50 = var9_50:getTaskById(var8_50) or var9_50:getFinishTaskById(var8_50)

				if var10_50 and not var10_50:isReceive() then
					var0_50 = iter1_50

					break
				end
			end
		end
	end

	if not var0_50 then
		for iter3_50, iter4_50 in pairs(arg0_50.data) do
			if not iter4_50:isShow() and iter4_50:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var11_50 = iter4_50:getConfig("config_id")
				local var12_50 = pg.activity_7_day_sign[var11_50].front_drops

				if iter4_50.data1 < #var12_50 and not var1_50:IsSameDay(var2_50, iter4_50.data2) and var2_50 > iter4_50.data2 then
					var0_50 = iter4_50

					break
				end
			end
		end
	end

	return var0_50
end

function var0_0.findRefluxAutoActivity(arg0_51)
	local var0_51 = arg0_51:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_51 and not var0_51:isEnd() and not var0_51.autoActionForbidden then
		local var1_51 = pg.TimeMgr.GetInstance()

		if var0_51.data1_list[2] < #pg.return_sign_template.all and not var1_51:IsSameDay(var1_51:GetServerTime(), var0_51.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_52)
	local var0_52 = arg0_52:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_52 and not var0_52:isEnd() then
		local var1_52 = pg.return_pt_template

		for iter0_52 = #var1_52.all, 1, -1 do
			local var2_52 = var1_52.all[iter0_52]
			local var3_52 = var1_52[var2_52]

			if var0_52.data3 >= var3_52.pt_require and var2_52 > var0_52.data4 then
				return true
			end
		end

		local var4_52 = getProxy(TaskProxy)
		local var5_52 = _(var0_52:getConfig("config_data")[7]):chain():map(function(arg0_53)
			return arg0_53[2]
		end):flatten():map(function(arg0_54)
			return var4_52:getTaskById(arg0_54) or var4_52:getFinishTaskById(arg0_54) or false
		end):filter(function(arg0_55)
			return not not arg0_55
		end):value()

		if _.any(var5_52, function(arg0_56)
			return arg0_56:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_57, arg1_57)
	return Clone(arg0_57.data[arg1_57])
end

function var0_0.RawGetActivityById(arg0_58, arg1_58)
	return arg0_58.data[arg1_58]
end

function var0_0.updateActivity(arg0_59, arg1_59)
	assert(arg0_59.data[arg1_59.id], "activity should exist" .. arg1_59.id)
	assert(isa(arg1_59, Activity), "activity should instance of Activity")

	if arg1_59:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_59 = pg.battlepass_event_pt[arg1_59.id].target

		if arg0_59.data[arg1_59.id].data1 < var0_59[#var0_59] and arg1_59.data1 - arg0_59.data[arg1_59.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_59.id].pt,
				ptCount = arg1_59.data1 - arg0_59.data[arg1_59.id].data1
			})
		end
	end

	arg0_59.data[arg1_59.id] = arg1_59

	arg0_59:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_59:clone())
	arg0_59:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_59.id
	})
end

function var0_0.addActivity(arg0_60, arg1_60)
	assert(arg0_60.data[arg1_60.id] == nil, "activity already exist" .. arg1_60.id)
	assert(isa(arg1_60, Activity), "activity should instance of Activity")

	arg0_60.data[arg1_60.id] = arg1_60

	arg0_60:sendNotification(var0_0.ACTIVITY_ADDED, arg1_60:clone())

	if arg1_60.stopTime > 0 then
		table.insert(arg0_60.stopList, {
			arg1_60.stopTime,
			arg1_60.id
		})
		table.sort(arg0_60.stopList, CompareFuncs({
			function(arg0_61)
				return arg0_61[1]
			end
		}))
	end

	if arg1_60:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		table.insert(arg0_60.buffActs, arg1_60.id)
		arg0_60:refreshActivityBuffs()
	end
end

function var0_0.deleteActivityById(arg0_62, arg1_62)
	assert(arg0_62.data[arg1_62], "activity should exist" .. arg1_62)

	arg0_62.data[arg1_62] = nil

	arg0_62:sendNotification(var0_0.ACTIVITY_DELETED, arg1_62)

	local var0_62 = table.getIndex(arg0_62.stopList, function(arg0_63)
		return arg0_63[2] == arg1_62
	end)

	if var0_62 then
		table.remove(arg0_62.stopList, var0_62)
	end
end

function var0_0.IsActivityNotEnd(arg0_64, arg1_64)
	return arg0_64.data[arg1_64] and not arg0_64.data[arg1_64]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_65, arg1_65)
	local var0_65 = false
	local var1_65 = arg0_65:getActivitiesByType(arg1_65)

	for iter0_65, iter1_65 in ipairs(var1_65) do
		if iter1_65:readyToAchieve() then
			var0_65 = true

			break
		end
	end

	return var0_65
end

function var0_0.getBuildActivityCfgByID(arg0_66, arg1_66)
	local var0_66 = arg0_66:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})

	for iter0_66, iter1_66 in ipairs(var0_66) do
		if not iter1_66:isEnd() then
			local var1_66 = iter1_66:getConfig("config_client")

			if var1_66 and var1_66.id == arg1_66 then
				return var1_66
			end
		end
	end

	return nil
end

function var0_0.getNoneActBuildActivityCfgByID(arg0_67, arg1_67)
	local var0_67 = arg0_67:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
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

function var0_0.getBuffShipList(arg0_68)
	local var0_68 = {}
	local var1_68 = arg0_68:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_68, function(arg0_69)
		if arg0_69 and not arg0_69:isEnd() then
			local var0_69 = arg0_69:getConfig("config_id")
			local var1_69 = pg.activity_expup_ship[var0_69]

			if not var1_69 then
				return
			end

			local var2_69 = var1_69.expup

			for iter0_69, iter1_69 in pairs(var2_69) do
				var0_68[iter1_69[1]] = iter1_69[2]
			end
		end
	end)

	return var0_68
end

function var0_0.getVirtualItemNumber(arg0_70, arg1_70)
	local var0_70 = arg0_70:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_70 and not var0_70:isEnd() then
		return var0_70.data1KeyValueList[1][arg1_70] and var0_70.data1KeyValueList[1][arg1_70] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_71, "vbagType invalid")

	if var0_71 and not var0_71:isEnd() then
		var0_71.data1KeyValueList[1][arg1_71] = var0_71.data1KeyValueList[1][arg1_71] - arg2_71
	end

	arg0_71:updateActivity(var0_71)
end

function var0_0.addVitemById(arg0_72, arg1_72, arg2_72)
	local var0_72 = arg0_72:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_72, "vbagType invalid")

	if var0_72 and not var0_72:isEnd() then
		if not var0_72.data1KeyValueList[1][arg1_72] then
			var0_72.data1KeyValueList[1][arg1_72] = 0
		end

		var0_72.data1KeyValueList[1][arg1_72] = var0_72.data1KeyValueList[1][arg1_72] + arg2_72
	end

	arg0_72:updateActivity(var0_72)

	local var1_72 = Item.getConfigData(arg1_72).link_id

	if var1_72 ~= 0 then
		local var2_72 = arg0_72:getActivityById(var1_72)

		if var2_72 and not var2_72:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_72, arg2_72)
		end
	end
end

function var0_0.monitorTaskList(arg0_73, arg1_73)
	if arg1_73 and not arg1_73:isEnd() and arg1_73:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_73 = arg1_73:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_73) then
			arg0_73:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_73.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_74, arg1_74, arg2_74)
	getProxy(FleetProxy):addActivityFleet(arg1_74, arg2_74.group_list)
end

function var0_0.InitActivityBossData(arg0_75, arg1_75)
	local var0_75 = pg.activity_event_worldboss[arg1_75:getConfig("config_id")]

	if not var0_75 then
		return
	end

	local var1_75 = arg1_75.data1KeyValueList

	for iter0_75, iter1_75 in pairs(var0_75.normal_expedition_drop_num or {}) do
		for iter2_75, iter3_75 in pairs(iter1_75[1]) do
			local var2_75 = iter1_75[2]
			local var3_75 = var1_75[1][iter3_75] or 0

			var1_75[1][iter3_75] = math.max(var2_75 - var3_75, 0)
			var1_75[2][iter3_75] = var1_75[2][iter3_75] or 0
		end
	end
end

function var0_0.AddInstagramTimer(arg0_76, arg1_76)
	arg0_76:RemoveInstagramTimer()

	local var0_76, var1_76 = arg0_76.data[arg1_76]:GetNextPushTime()

	if var0_76 then
		local var2_76 = var0_76 - pg.TimeMgr.GetInstance():GetServerTime()

		local function var3_76()
			arg0_76:sendNotification(GAME.ACT_INSTAGRAM_OP, {
				arg2 = 0,
				activity_id = arg1_76,
				cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
				arg1 = var1_76
			})
		end

		if var2_76 <= 0 then
			var3_76()
		else
			arg0_76.instagramTimer = Timer.New(function()
				var3_76()
				arg0_76:RemoveInstagramTimer()
			end, var2_76, 1)

			arg0_76.instagramTimer:Start()
		end
	end
end

function var0_0.RemoveInstagramTimer(arg0_79)
	if arg0_79.instagramTimer then
		arg0_79.instagramTimer:Stop()

		arg0_79.instagramTimer = nil
	end
end

function var0_0.RegisterRequestTime(arg0_80, arg1_80, arg2_80)
	if not arg1_80 or arg1_80 <= 0 then
		return
	end

	arg0_80.requestTime[arg1_80] = arg2_80
end

function var0_0.remove(arg0_81)
	arg0_81:RemoveInstagramTimer()
end

function var0_0.addActivityParameter(arg0_82, arg1_82)
	local var0_82 = arg1_82:getConfig("config_data")
	local var1_82 = arg1_82.stopTime

	for iter0_82, iter1_82 in ipairs(var0_82) do
		arg0_82.params[iter1_82[1]] = {
			iter1_82[2],
			var1_82
		}
	end
end

function var0_0.getActivityParameter(arg0_83, arg1_83)
	if arg0_83.params[arg1_83] then
		local var0_83, var1_83 = unpack(arg0_83.params[arg1_83])

		if not (var1_83 > 0) or not (var1_83 <= pg.TimeMgr.GetInstance():GetServerTime()) then
			return var0_83
		end
	end
end

function var0_0.IsShowFreeBuildMark(arg0_84, arg1_84)
	for iter0_84, iter1_84 in ipairs(arg0_84:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter1_84 and not iter1_84:isEnd() and iter1_84.data1 > 0 and iter1_84.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 and tobool(arg1_84) == (PlayerPrefs.GetString("Free_Build_Ticket_" .. iter1_84.id, "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")) then
			return iter1_84
		end
	end

	return false
end

function var0_0.getBuildFreeActivityByBuildId(arg0_85, arg1_85)
	for iter0_85, iter1_85 in ipairs(arg0_85:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if underscore.any(iter1_85:getConfig("config_data"), function(arg0_86)
			return arg0_86 == arg1_85
		end) then
			return iter1_85
		end
	end
end

function var0_0.getBuildPoolActivity(arg0_87, arg1_87)
	if arg1_87:IsActivity() then
		return arg0_87:getActivityById(arg1_87.activityId)
	end
end

function var0_0.getEnterReadyActivity(arg0_88)
	local var0_88 = {
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_89)
			return not arg0_89:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = false
	}
	local var1_88 = _.keys(var0_88)
	local var2_88 = {}

	for iter0_88, iter1_88 in ipairs(var1_88) do
		var2_88[iter1_88] = 0
	end

	for iter2_88, iter3_88 in pairs(arg0_88.data) do
		local var3_88 = iter3_88:getConfig("type")

		if var2_88[var3_88] and not iter3_88:isEnd() and not existCall(var0_88[var3_88], iter3_88) then
			var2_88[var3_88] = math.max(var2_88[var3_88], iter2_88)
		end
	end

	table.sort(var1_88)

	for iter4_88, iter5_88 in ipairs(var1_88) do
		if var2_88[iter5_88] > 0 then
			return arg0_88.data[var2_88[iter5_88]]
		end
	end
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_90)
	local var0_90 = arg0_90:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_90 or var0_90:isEnd() then
		return false
	end

	local var1_90 = var0_90:GetSlots()

	for iter0_90, iter1_90 in pairs(var1_90) do
		if iter1_90[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_91, arg1_91, arg2_91)
	local var0_91 = arg0_91:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_91 or var0_91:isEnd() then
		return false
	end

	local var1_91 = var0_91:GetItems()[arg1_91]

	return var1_91 and arg2_91 <= var1_91.count
end

function var0_0.refreshActivityBuffs(arg0_92)
	arg0_92.actBuffs = {}

	local var0_92 = 1

	while var0_92 <= #arg0_92.buffActs do
		local var1_92 = arg0_92.data[arg0_92.buffActs[var0_92]]

		if not var1_92 or var1_92:isEnd() then
			table.remove(arg0_92.buffActs, var0_92)
		else
			var0_92 = var0_92 + 1

			local var2_92 = {
				var1_92:getConfig("config_id")
			}

			if var2_92[1] == 0 then
				var2_92 = var1_92:getConfig("config_data")
			end

			for iter0_92, iter1_92 in ipairs(var2_92) do
				local var3_92 = ActivityBuff.New(var1_92.id, iter1_92)

				if var3_92:isActivate() then
					table.insert(arg0_92.actBuffs, var3_92)
				end
			end
		end
	end
end

function var0_0.getActivityBuffs(arg0_93)
	if underscore.any(arg0_93.buffActs, function(arg0_94)
		return not arg0_93.data[arg0_94] or arg0_93.data[arg0_94]:isEnd()
	end) or underscore.any(arg0_93.actBuffs, function(arg0_95)
		return not arg0_95:isActivate()
	end) then
		arg0_93:refreshActivityBuffs()
	end

	return arg0_93.actBuffs
end

function var0_0.getShipModExpActivity(arg0_96)
	return underscore.select(arg0_96:getActivityBuffs(), function(arg0_97)
		return arg0_97:ShipModExpUsage()
	end)
end

function var0_0.getBackyardEnergyActivityBuffs(arg0_98)
	return underscore.select(arg0_98:getActivityBuffs(), function(arg0_99)
		return arg0_99:BackyardEnergyUsage()
	end)
end

function var0_0.InitContinuousTime(arg0_100, arg1_100)
	arg0_100.continuousOpeartionTime = arg1_100
	arg0_100.continuousOpeartionTotalTime = arg1_100
end

function var0_0.UseContinuousTime(arg0_101)
	if not arg0_101.continuousOpeartionTime then
		return
	end

	arg0_101.continuousOpeartionTime = arg0_101.continuousOpeartionTime - 1
end

function var0_0.GetContinuousTime(arg0_102)
	return arg0_102.continuousOpeartionTime, arg0_102.continuousOpeartionTotalTime
end

function var0_0.AddBossRushAwards(arg0_103, arg1_103)
	arg0_103.bossrushAwards = arg0_103.bossrushAwards or {}

	table.insertto(arg0_103.bossrushAwards, arg1_103)
end

function var0_0.PopBossRushAwards(arg0_104)
	local var0_104 = arg0_104.bossrushAwards or {}

	arg0_104.bossrushAwards = nil

	return var0_104
end

function var0_0.GetBossRushRuntime(arg0_105, arg1_105)
	if not arg0_105.extraDatas[arg1_105] then
		arg0_105.extraDatas[arg1_105] = {
			record = 0
		}
	end

	return arg0_105.extraDatas[arg1_105]
end

function var0_0.GetActivityBossRuntime(arg0_106, arg1_106)
	if not arg0_106.extraDatas[arg1_106] then
		arg0_106.extraDatas[arg1_106] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0_106.extraDatas[arg1_106]
end

function var0_0.GetTaskActivities(arg0_107)
	local var0_107 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0_108, arg1_108)
		if not isa(arg1_108, ITaskActivity) then
			return
		end

		table.insertto(var0_107, arg0_107:getActivitiesByType(arg0_108))
	end)

	return var0_107
end

function var0_0.setSurveyState(arg0_109, arg1_109)
	local var0_109 = arg0_109:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_109 and not var0_109:isEnd() then
		arg0_109.surveyState = arg1_109
	end
end

function var0_0.isSurveyDone(arg0_110)
	local var0_110 = arg0_110:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_110 and not var0_110:isEnd() then
		return arg0_110.surveyState and arg0_110.surveyState > 0
	end
end

function var0_0.isSurveyOpen(arg0_111)
	local var0_111 = arg0_111:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_111 and not var0_111:isEnd() then
		local var1_111 = var0_111:getConfig("config_data")
		local var2_111 = var1_111[1]
		local var3_111 = var1_111[2]

		if var2_111 == 1 then
			local var4_111 = var3_111 <= getProxy(PlayerProxy):getData().level
			local var5_111 = var0_111:getConfig("config_id")

			return var4_111, var5_111
		end
	end
end

function var0_0.GetActBossLinkPTActID(arg0_112, arg1_112)
	local var0_112 = table.Find(arg0_112.data, function(arg0_113, arg1_113)
		if arg1_113:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1_113:getDataConfig("link_id") == arg1_112
	end)

	return var0_112 and var0_112.id
end

function var0_0.CheckDailyEventRequest(arg0_114, arg1_114)
	if arg1_114:CheckDailyEventRequest() then
		arg0_114:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1_114.id
		})
	end
end

return var0_0
