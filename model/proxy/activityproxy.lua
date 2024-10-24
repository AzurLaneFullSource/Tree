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

function var0_0.getMilitaryExerciseActivity(arg0_37)
	local var0_37

	for iter0_37, iter1_37 in pairs(arg0_37.data) do
		if iter1_37:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			var0_37 = iter1_37

			break
		end
	end

	return Clone(var0_37)
end

function var0_0.getPanelActivities(arg0_38)
	local function var0_38(arg0_39)
		local var0_39 = arg0_39:getConfig("type")
		local var1_39 = arg0_39:isShow() and not arg0_39:isAfterShow()

		if var1_39 then
			if var0_39 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				var1_39 = arg0_39.data2 == 0
			elseif var0_39 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				var1_39 = arg0_39.data1 < 7 or not arg0_39.achieved
			end
		end

		return var1_39 and not arg0_39:isEnd()
	end

	local var1_38 = {}

	for iter0_38, iter1_38 in pairs(arg0_38.data) do
		if var0_38(iter1_38) then
			table.insert(var1_38, iter1_38)
		end
	end

	table.sort(var1_38, CompareFuncs({
		function(arg0_40)
			return -arg0_40:getConfig("login_pop")
		end,
		function(arg0_41)
			return arg0_41.id
		end
	}))

	return var1_38
end

function var0_0.checkHxActivity(arg0_42, arg1_42)
	if arg0_42.hxList and #arg0_42.hxList > 0 then
		for iter0_42 = 1, #arg0_42.hxList do
			if arg0_42.hxList[iter0_42] == arg1_42 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_43)
	return _(pg.activity_banner.all):chain():map(function(arg0_44)
		return pg.activity_banner[arg0_44]
	end):filter(function(arg0_45)
		return pg.TimeMgr.GetInstance():inTime(arg0_45.time) and arg0_45.type ~= GAMEUI_BANNER_9 and arg0_45.type ~= GAMEUI_BANNER_11 and arg0_45.type ~= GAMEUI_BANNER_10 and arg0_45.type ~= GAMEUI_BANNER_12 and arg0_45.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_46, arg1_46)
	local var0_46 = pg.activity_banner.get_id_list_by_type[arg1_46]

	if not var0_46 then
		return nil
	end

	for iter0_46, iter1_46 in ipairs(var0_46) do
		local var1_46 = pg.activity_banner[iter1_46]

		if pg.TimeMgr.GetInstance():inTime(var1_46.time) then
			return var1_46
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_47)
	return _.map(pg.activity_banner_notice.all, function(arg0_48)
		return pg.activity_banner_notice[arg0_48]
	end)
end

function var0_0.findNextAutoActivity(arg0_49)
	local var0_49
	local var1_49 = pg.TimeMgr.GetInstance()
	local var2_49 = var1_49:GetServerTime()

	for iter0_49, iter1_49 in ipairs(arg0_49:getPanelActivities()) do
		if iter1_49:isShow() and not iter1_49.autoActionForbidden then
			local var3_49 = iter1_49:getConfig("type")

			if var3_49 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var4_49 = iter1_49:getConfig("config_id")
				local var5_49 = pg.activity_7_day_sign[var4_49].front_drops

				if iter1_49.data1 < #var5_49 and not var1_49:IsSameDay(var2_49, iter1_49.data2) and var2_49 > iter1_49.data2 then
					var0_49 = iter1_49

					break
				end
			elseif var3_49 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var6_49 = getProxy(ChapterProxy)

				if iter1_49.data1 < 7 and not var1_49:IsSameDay(var2_49, iter1_49.data2) or iter1_49.data1 == 7 and not iter1_49.achieved and var6_49:isClear(204) then
					var0_49 = iter1_49

					break
				end
			elseif var3_49 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var7_49 = pg.TimeMgr.GetInstance():STimeDescS(var2_49, "*t")

				iter1_49:setSpecialData("reMonthSignDay", nil)

				if var7_49.year ~= iter1_49.data1 or var7_49.month ~= iter1_49.data2 then
					iter1_49.data1 = var7_49.year
					iter1_49.data2 = var7_49.month
					iter1_49.data1_list = {}
					var0_49 = iter1_49

					break
				elseif not table.contains(iter1_49.data1_list, var7_49.day) then
					var0_49 = iter1_49

					break
				elseif var7_49.day > #iter1_49.data1_list and pg.activity_month_sign[iter1_49.data2].resign_count > iter1_49.data3 then
					for iter2_49 = var7_49.day, 1, -1 do
						if not table.contains(iter1_49.data1_list, iter2_49) then
							iter1_49:setSpecialData("reMonthSignDay", iter2_49)

							break
						end
					end

					var0_49 = iter1_49
				end
			elseif iter1_49.id == ActivityConst.SHADOW_PLAY_ID and iter1_49.clientData1 == 0 then
				local var8_49 = iter1_49:getConfig("config_data")[1]
				local var9_49 = getProxy(TaskProxy)
				local var10_49 = var9_49:getTaskById(var8_49) or var9_49:getFinishTaskById(var8_49)

				if var10_49 and not var10_49:isReceive() then
					var0_49 = iter1_49

					break
				end
			end
		end
	end

	if not var0_49 then
		for iter3_49, iter4_49 in pairs(arg0_49.data) do
			if not iter4_49:isShow() and iter4_49:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var11_49 = iter4_49:getConfig("config_id")
				local var12_49 = pg.activity_7_day_sign[var11_49].front_drops

				if iter4_49.data1 < #var12_49 and not var1_49:IsSameDay(var2_49, iter4_49.data2) and var2_49 > iter4_49.data2 then
					var0_49 = iter4_49

					break
				end
			end
		end
	end

	return var0_49
end

function var0_0.findRefluxAutoActivity(arg0_50)
	local var0_50 = arg0_50:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_50 and not var0_50:isEnd() and not var0_50.autoActionForbidden then
		local var1_50 = pg.TimeMgr.GetInstance()

		if var0_50.data1_list[2] < #pg.return_sign_template.all and not var1_50:IsSameDay(var1_50:GetServerTime(), var0_50.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_51)
	local var0_51 = arg0_51:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_51 and not var0_51:isEnd() then
		local var1_51 = pg.return_pt_template

		for iter0_51 = #var1_51.all, 1, -1 do
			local var2_51 = var1_51.all[iter0_51]
			local var3_51 = var1_51[var2_51]

			if var0_51.data3 >= var3_51.pt_require and var2_51 > var0_51.data4 then
				return true
			end
		end

		local var4_51 = getProxy(TaskProxy)
		local var5_51 = _(var0_51:getConfig("config_data")[7]):chain():map(function(arg0_52)
			return arg0_52[2]
		end):flatten():map(function(arg0_53)
			return var4_51:getTaskById(arg0_53) or var4_51:getFinishTaskById(arg0_53) or false
		end):filter(function(arg0_54)
			return not not arg0_54
		end):value()

		if _.any(var5_51, function(arg0_55)
			return arg0_55:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_56, arg1_56)
	return Clone(arg0_56.data[arg1_56])
end

function var0_0.RawGetActivityById(arg0_57, arg1_57)
	return arg0_57.data[arg1_57]
end

function var0_0.updateActivity(arg0_58, arg1_58)
	assert(arg0_58.data[arg1_58.id], "activity should exist" .. arg1_58.id)
	assert(isa(arg1_58, Activity), "activity should instance of Activity")

	if arg1_58:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_58 = pg.battlepass_event_pt[arg1_58.id].target

		if arg0_58.data[arg1_58.id].data1 < var0_58[#var0_58] and arg1_58.data1 - arg0_58.data[arg1_58.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_58.id].pt,
				ptCount = arg1_58.data1 - arg0_58.data[arg1_58.id].data1
			})
		end
	end

	arg0_58.data[arg1_58.id] = arg1_58

	arg0_58:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_58:clone())
	arg0_58:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_58.id
	})
end

function var0_0.addActivity(arg0_59, arg1_59)
	assert(arg0_59.data[arg1_59.id] == nil, "activity already exist" .. arg1_59.id)
	assert(isa(arg1_59, Activity), "activity should instance of Activity")

	arg0_59.data[arg1_59.id] = arg1_59

	arg0_59:sendNotification(var0_0.ACTIVITY_ADDED, arg1_59:clone())

	if arg1_59.stopTime > 0 then
		table.insert(arg0_59.stopList, {
			arg1_59.stopTime,
			arg1_59.id
		})
		table.sort(arg0_59.stopList, CompareFuncs({
			function(arg0_60)
				return arg0_60[1]
			end
		}))
	end

	if arg1_59:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		table.insert(arg0_59.buffActs, arg1_59.id)
		arg0_59:refreshActivityBuffs()
	end
end

function var0_0.deleteActivityById(arg0_61, arg1_61)
	assert(arg0_61.data[arg1_61], "activity should exist" .. arg1_61)

	arg0_61.data[arg1_61] = nil

	arg0_61:sendNotification(var0_0.ACTIVITY_DELETED, arg1_61)

	local var0_61 = table.getIndex(arg0_61.stopList, function(arg0_62)
		return arg0_62[2] == arg1_61
	end)

	if var0_61 then
		table.remove(arg0_61.stopList, var0_61)
	end
end

function var0_0.IsActivityNotEnd(arg0_63, arg1_63)
	return arg0_63.data[arg1_63] and not arg0_63.data[arg1_63]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_64, arg1_64)
	local var0_64 = false
	local var1_64 = arg0_64:getActivitiesByType(arg1_64)

	for iter0_64, iter1_64 in ipairs(var1_64) do
		if iter1_64:readyToAchieve() then
			var0_64 = true

			break
		end
	end

	return var0_64
end

function var0_0.getBuildActivityCfgByID(arg0_65, arg1_65)
	local var0_65 = arg0_65:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})

	for iter0_65, iter1_65 in ipairs(var0_65) do
		if not iter1_65:isEnd() then
			local var1_65 = iter1_65:getConfig("config_client")

			if var1_65 and var1_65.id == arg1_65 then
				return var1_65
			end
		end
	end

	return nil
end

function var0_0.getNoneActBuildActivityCfgByID(arg0_66, arg1_66)
	local var0_66 = arg0_66:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
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

function var0_0.getBuffShipList(arg0_67)
	local var0_67 = {}
	local var1_67 = arg0_67:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_67, function(arg0_68)
		if arg0_68 and not arg0_68:isEnd() then
			local var0_68 = arg0_68:getConfig("config_id")
			local var1_68 = pg.activity_expup_ship[var0_68]

			if not var1_68 then
				return
			end

			local var2_68 = var1_68.expup

			for iter0_68, iter1_68 in pairs(var2_68) do
				var0_67[iter1_68[1]] = iter1_68[2]
			end
		end
	end)

	return var0_67
end

function var0_0.getVirtualItemNumber(arg0_69, arg1_69)
	local var0_69 = arg0_69:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_69 and not var0_69:isEnd() then
		return var0_69.data1KeyValueList[1][arg1_69] and var0_69.data1KeyValueList[1][arg1_69] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_70, arg1_70, arg2_70)
	local var0_70 = arg0_70:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_70, "vbagType invalid")

	if var0_70 and not var0_70:isEnd() then
		var0_70.data1KeyValueList[1][arg1_70] = var0_70.data1KeyValueList[1][arg1_70] - arg2_70
	end

	arg0_70:updateActivity(var0_70)
end

function var0_0.addVitemById(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_71, "vbagType invalid")

	if var0_71 and not var0_71:isEnd() then
		if not var0_71.data1KeyValueList[1][arg1_71] then
			var0_71.data1KeyValueList[1][arg1_71] = 0
		end

		var0_71.data1KeyValueList[1][arg1_71] = var0_71.data1KeyValueList[1][arg1_71] + arg2_71
	end

	arg0_71:updateActivity(var0_71)

	local var1_71 = Item.getConfigData(arg1_71).link_id

	if var1_71 ~= 0 then
		local var2_71 = arg0_71:getActivityById(var1_71)

		if var2_71 and not var2_71:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_71, arg2_71)
		end
	end
end

function var0_0.monitorTaskList(arg0_72, arg1_72)
	if arg1_72 and not arg1_72:isEnd() and arg1_72:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_72 = arg1_72:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_72) then
			arg0_72:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_72.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_73, arg1_73, arg2_73)
	getProxy(FleetProxy):addActivityFleet(arg1_73, arg2_73.group_list)
end

function var0_0.InitActivityBossData(arg0_74, arg1_74)
	local var0_74 = pg.activity_event_worldboss[arg1_74:getConfig("config_id")]

	if not var0_74 then
		return
	end

	local var1_74 = arg1_74.data1KeyValueList

	for iter0_74, iter1_74 in pairs(var0_74.normal_expedition_drop_num or {}) do
		for iter2_74, iter3_74 in pairs(iter1_74[1]) do
			local var2_74 = iter1_74[2]
			local var3_74 = var1_74[1][iter3_74] or 0

			var1_74[1][iter3_74] = math.max(var2_74 - var3_74, 0)
			var1_74[2][iter3_74] = var1_74[2][iter3_74] or 0
		end
	end
end

function var0_0.AddInstagramTimer(arg0_75, arg1_75)
	arg0_75:RemoveInstagramTimer()

	local var0_75, var1_75 = arg0_75.data[arg1_75]:GetNextPushTime()

	if var0_75 then
		local var2_75 = var0_75 - pg.TimeMgr.GetInstance():GetServerTime()

		local function var3_75()
			arg0_75:sendNotification(GAME.ACT_INSTAGRAM_OP, {
				arg2 = 0,
				activity_id = arg1_75,
				cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
				arg1 = var1_75
			})
		end

		if var2_75 <= 0 then
			var3_75()
		else
			arg0_75.instagramTimer = Timer.New(function()
				var3_75()
				arg0_75:RemoveInstagramTimer()
			end, var2_75, 1)

			arg0_75.instagramTimer:Start()
		end
	end
end

function var0_0.RemoveInstagramTimer(arg0_78)
	if arg0_78.instagramTimer then
		arg0_78.instagramTimer:Stop()

		arg0_78.instagramTimer = nil
	end
end

function var0_0.RegisterRequestTime(arg0_79, arg1_79, arg2_79)
	if not arg1_79 or arg1_79 <= 0 then
		return
	end

	arg0_79.requestTime[arg1_79] = arg2_79
end

function var0_0.remove(arg0_80)
	arg0_80:RemoveInstagramTimer()
end

function var0_0.addActivityParameter(arg0_81, arg1_81)
	local var0_81 = arg1_81:getConfig("config_data")
	local var1_81 = arg1_81.stopTime

	for iter0_81, iter1_81 in ipairs(var0_81) do
		arg0_81.params[iter1_81[1]] = {
			iter1_81[2],
			var1_81
		}
	end
end

function var0_0.getActivityParameter(arg0_82, arg1_82)
	if arg0_82.params[arg1_82] then
		local var0_82, var1_82 = unpack(arg0_82.params[arg1_82])

		if not (var1_82 > 0) or not (var1_82 <= pg.TimeMgr.GetInstance():GetServerTime()) then
			return var0_82
		end
	end
end

function var0_0.IsShowFreeBuildMark(arg0_83, arg1_83)
	for iter0_83, iter1_83 in ipairs(arg0_83:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter1_83 and not iter1_83:isEnd() and iter1_83.data1 > 0 and iter1_83.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 and tobool(arg1_83) == (PlayerPrefs.GetString("Free_Build_Ticket_" .. iter1_83.id, "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")) then
			return iter1_83
		end
	end

	return false
end

function var0_0.getBuildFreeActivityByBuildId(arg0_84, arg1_84)
	for iter0_84, iter1_84 in ipairs(arg0_84:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if underscore.any(iter1_84:getConfig("config_data"), function(arg0_85)
			return arg0_85 == arg1_84
		end) then
			return iter1_84
		end
	end
end

function var0_0.getBuildPoolActivity(arg0_86, arg1_86)
	if arg1_86:IsActivity() then
		return arg0_86:getActivityById(arg1_86.activityId)
	end
end

function var0_0.getEnterReadyActivity(arg0_87)
	local var0_87 = {
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_88)
			return not arg0_88:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = false
	}
	local var1_87 = _.keys(var0_87)
	local var2_87 = {}

	for iter0_87, iter1_87 in ipairs(var1_87) do
		var2_87[iter1_87] = 0
	end

	for iter2_87, iter3_87 in pairs(arg0_87.data) do
		local var3_87 = iter3_87:getConfig("type")

		if var2_87[var3_87] and not iter3_87:isEnd() and not existCall(var0_87[var3_87], iter3_87) then
			var2_87[var3_87] = math.max(var2_87[var3_87], iter2_87)
		end
	end

	table.sort(var1_87)

	for iter4_87, iter5_87 in ipairs(var1_87) do
		if var2_87[iter5_87] > 0 then
			return arg0_87.data[var2_87[iter5_87]]
		end
	end
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_89)
	local var0_89 = arg0_89:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_89 or var0_89:isEnd() then
		return false
	end

	local var1_89 = var0_89:GetSlots()

	for iter0_89, iter1_89 in pairs(var1_89) do
		if iter1_89[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_90, arg1_90, arg2_90)
	local var0_90 = arg0_90:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_90 or var0_90:isEnd() then
		return false
	end

	local var1_90 = var0_90:GetItems()[arg1_90]

	return var1_90 and arg2_90 <= var1_90.count
end

function var0_0.refreshActivityBuffs(arg0_91)
	arg0_91.actBuffs = {}

	local var0_91 = 1

	while var0_91 <= #arg0_91.buffActs do
		local var1_91 = arg0_91.data[arg0_91.buffActs[var0_91]]

		if not var1_91 or var1_91:isEnd() then
			table.remove(arg0_91.buffActs, var0_91)
		else
			var0_91 = var0_91 + 1

			local var2_91 = {
				var1_91:getConfig("config_id")
			}

			if var2_91[1] == 0 then
				var2_91 = var1_91:getConfig("config_data")
			end

			for iter0_91, iter1_91 in ipairs(var2_91) do
				local var3_91 = ActivityBuff.New(var1_91.id, iter1_91)

				if var3_91:isActivate() then
					table.insert(arg0_91.actBuffs, var3_91)
				end
			end
		end
	end
end

function var0_0.getActivityBuffs(arg0_92)
	if underscore.any(arg0_92.buffActs, function(arg0_93)
		return not arg0_92.data[arg0_93] or arg0_92.data[arg0_93]:isEnd()
	end) or underscore.any(arg0_92.actBuffs, function(arg0_94)
		return not arg0_94:isActivate()
	end) then
		arg0_92:refreshActivityBuffs()
	end

	return arg0_92.actBuffs
end

function var0_0.getShipModExpActivity(arg0_95)
	return underscore.select(arg0_95:getActivityBuffs(), function(arg0_96)
		return arg0_96:ShipModExpUsage()
	end)
end

function var0_0.getBackyardEnergyActivityBuffs(arg0_97)
	return underscore.select(arg0_97:getActivityBuffs(), function(arg0_98)
		return arg0_98:BackyardEnergyUsage()
	end)
end

function var0_0.InitContinuousTime(arg0_99, arg1_99)
	arg0_99.continuousOpeartionTime = arg1_99
	arg0_99.continuousOpeartionTotalTime = arg1_99
end

function var0_0.UseContinuousTime(arg0_100)
	if not arg0_100.continuousOpeartionTime then
		return
	end

	arg0_100.continuousOpeartionTime = arg0_100.continuousOpeartionTime - 1
end

function var0_0.GetContinuousTime(arg0_101)
	return arg0_101.continuousOpeartionTime, arg0_101.continuousOpeartionTotalTime
end

function var0_0.AddBossRushAwards(arg0_102, arg1_102)
	arg0_102.bossrushAwards = arg0_102.bossrushAwards or {}

	table.insertto(arg0_102.bossrushAwards, arg1_102)
end

function var0_0.PopBossRushAwards(arg0_103)
	local var0_103 = arg0_103.bossrushAwards or {}

	arg0_103.bossrushAwards = nil

	return var0_103
end

function var0_0.GetBossRushRuntime(arg0_104, arg1_104)
	if not arg0_104.extraDatas[arg1_104] then
		arg0_104.extraDatas[arg1_104] = {
			record = 0
		}
	end

	return arg0_104.extraDatas[arg1_104]
end

function var0_0.GetActivityBossRuntime(arg0_105, arg1_105)
	if not arg0_105.extraDatas[arg1_105] then
		arg0_105.extraDatas[arg1_105] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0_105.extraDatas[arg1_105]
end

function var0_0.GetTaskActivities(arg0_106)
	local var0_106 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0_107, arg1_107)
		if not isa(arg1_107, ITaskActivity) then
			return
		end

		table.insertto(var0_106, arg0_106:getActivitiesByType(arg0_107))
	end)

	return var0_106
end

function var0_0.setSurveyState(arg0_108, arg1_108)
	local var0_108 = arg0_108:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_108 and not var0_108:isEnd() then
		arg0_108.surveyState = arg1_108
	end
end

function var0_0.isSurveyDone(arg0_109)
	local var0_109 = arg0_109:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_109 and not var0_109:isEnd() then
		return arg0_109.surveyState and arg0_109.surveyState > 0
	end
end

function var0_0.isSurveyOpen(arg0_110)
	local var0_110 = arg0_110:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_110 and not var0_110:isEnd() then
		local var1_110 = var0_110:getConfig("config_data")
		local var2_110 = var1_110[1]
		local var3_110 = var1_110[2]

		if var2_110 == 1 then
			local var4_110 = var3_110 <= getProxy(PlayerProxy):getData().level
			local var5_110 = var0_110:getConfig("config_id")

			return var4_110, var5_110
		end
	end
end

function var0_0.GetActBossLinkPTActID(arg0_111, arg1_111)
	local var0_111 = table.Find(arg0_111.data, function(arg0_112, arg1_112)
		if arg1_112:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1_112:getDataConfig("link_id") == arg1_111
	end)

	return var0_111 and var0_111.id
end

function var0_0.CheckDailyEventRequest(arg0_113, arg1_113)
	if arg1_113:CheckDailyEventRequest() then
		arg0_113:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1_113.id
		})
	end
end

return var0_0
