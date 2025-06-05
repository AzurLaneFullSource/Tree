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
var0_0.ACTIVITY_EXCHANGE_RESOURCES = "ActivityProxy ACTIVITY_EXCHANGE_RESOURCES"
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
		local var1_40 = arg0_40:isShow() and not arg0_40:isAfterShow() and arg0_40:isCorePage("")

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

function var0_0.getCorePanelActivity(arg0_43, arg1_43)
	local var0_43 = {}

	for iter0_43, iter1_43 in pairs(arg0_43.data) do
		if iter1_43:isShow() and iter1_43:isCorePage(arg1_43) then
			table.insert(var0_43, iter1_43)
		end
	end

	table.sort(var0_43, CompareFuncs({
		function(arg0_44)
			return -arg0_44:getConfig("login_pop")
		end,
		function(arg0_45)
			return arg0_45.id
		end
	}))

	return var0_43
end

function var0_0.checkHxActivity(arg0_46, arg1_46)
	if arg0_46.hxList and #arg0_46.hxList > 0 then
		for iter0_46 = 1, #arg0_46.hxList do
			if arg0_46.hxList[iter0_46] == arg1_46 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_47)
	return _(pg.activity_banner.all):chain():map(function(arg0_48)
		return pg.activity_banner[arg0_48]
	end):filter(function(arg0_49)
		return pg.TimeMgr.GetInstance():inTime(arg0_49.time) and arg0_49.type ~= GAMEUI_BANNER_9 and arg0_49.type ~= GAMEUI_BANNER_11 and arg0_49.type ~= GAMEUI_BANNER_10 and arg0_49.type ~= GAMEUI_BANNER_12 and arg0_49.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_50, arg1_50)
	local var0_50 = pg.activity_banner.get_id_list_by_type[arg1_50]

	if not var0_50 then
		return nil
	end

	for iter0_50, iter1_50 in ipairs(var0_50) do
		local var1_50 = pg.activity_banner[iter1_50]

		if pg.TimeMgr.GetInstance():inTime(var1_50.time) then
			return var1_50
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_51)
	return _.map(pg.activity_banner_notice.all, function(arg0_52)
		return pg.activity_banner_notice[arg0_52]
	end)
end

function var0_0.findNextAutoActivity(arg0_53)
	local var0_53
	local var1_53 = pg.TimeMgr.GetInstance()
	local var2_53 = var1_53:GetServerTime()

	for iter0_53, iter1_53 in ipairs(arg0_53:getPanelActivities()) do
		if not iter1_53.autoActionForbidden then
			local var3_53 = iter1_53:getConfig("type")

			if var3_53 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var4_53 = iter1_53:getConfig("config_id")
				local var5_53 = pg.activity_7_day_sign[var4_53].front_drops

				if iter1_53.data1 < #var5_53 and not var1_53:IsSameDay(var2_53, iter1_53.data2) and var2_53 > iter1_53.data2 then
					var0_53 = iter1_53

					break
				end
			elseif var3_53 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var6_53 = getProxy(ChapterProxy)

				if iter1_53.data1 < 7 and not var1_53:IsSameDay(var2_53, iter1_53.data2) or iter1_53.data1 == 7 and not iter1_53.achieved and var6_53:isClear(204) then
					var0_53 = iter1_53

					break
				end
			elseif var3_53 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var7_53 = pg.TimeMgr.GetInstance():STimeDescS(var2_53, "*t")

				iter1_53:setSpecialData("reMonthSignDay", nil)

				if var7_53.year ~= iter1_53.data1 or var7_53.month ~= iter1_53.data2 then
					iter1_53.data1 = var7_53.year
					iter1_53.data2 = var7_53.month
					iter1_53.data1_list = {}
					var0_53 = iter1_53

					break
				elseif not table.contains(iter1_53.data1_list, var7_53.day) then
					var0_53 = iter1_53

					break
				elseif var7_53.day > #iter1_53.data1_list and pg.activity_month_sign[iter1_53.data2].resign_count > iter1_53.data3 then
					for iter2_53 = var7_53.day, 1, -1 do
						if not table.contains(iter1_53.data1_list, iter2_53) then
							iter1_53:setSpecialData("reMonthSignDay", iter2_53)

							break
						end
					end

					var0_53 = iter1_53
				end
			elseif iter1_53.id == ActivityConst.SHADOW_PLAY_ID and iter1_53.clientData1 == 0 then
				local var8_53 = iter1_53:getConfig("config_data")[1]
				local var9_53 = getProxy(TaskProxy)
				local var10_53 = var9_53:getTaskById(var8_53) or var9_53:getFinishTaskById(var8_53)

				if var10_53 and not var10_53:isReceive() then
					var0_53 = iter1_53

					break
				end
			end
		end
	end

	if not var0_53 then
		for iter3_53, iter4_53 in pairs(arg0_53.data) do
			if not iter4_53:isShow() and iter4_53:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var11_53 = iter4_53:getConfig("config_id")
				local var12_53 = pg.activity_7_day_sign[var11_53].front_drops

				if iter4_53.data1 < #var12_53 and not var1_53:IsSameDay(var2_53, iter4_53.data2) and var2_53 > iter4_53.data2 then
					var0_53 = iter4_53

					break
				end
			end
		end
	end

	return var0_53
end

function var0_0.findRefluxAutoActivity(arg0_54)
	local var0_54 = arg0_54:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_54 and not var0_54:isEnd() and not var0_54.autoActionForbidden then
		local var1_54 = pg.TimeMgr.GetInstance()

		if var0_54.data1_list[2] < #pg.return_sign_template.all and not var1_54:IsSameDay(var1_54:GetServerTime(), var0_54.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_55)
	local var0_55 = arg0_55:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_55 and not var0_55:isEnd() then
		local var1_55 = pg.return_pt_template

		for iter0_55 = #var1_55.all, 1, -1 do
			local var2_55 = var1_55.all[iter0_55]
			local var3_55 = var1_55[var2_55]

			if var0_55.data3 >= var3_55.pt_require and var2_55 > var0_55.data4 then
				return true
			end
		end

		local var4_55 = getProxy(TaskProxy)
		local var5_55 = _(var0_55:getConfig("config_data")[7]):chain():map(function(arg0_56)
			return arg0_56[2]
		end):flatten():map(function(arg0_57)
			return var4_55:getTaskById(arg0_57) or var4_55:getFinishTaskById(arg0_57) or false
		end):filter(function(arg0_58)
			return not not arg0_58
		end):value()

		if _.any(var5_55, function(arg0_59)
			return arg0_59:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_60, arg1_60)
	return Clone(arg0_60.data[arg1_60])
end

function var0_0.RawGetActivityById(arg0_61, arg1_61)
	return arg0_61.data[arg1_61]
end

function var0_0.updateActivity(arg0_62, arg1_62)
	assert(arg0_62.data[arg1_62.id], "activity should exist" .. arg1_62.id)
	assert(isa(arg1_62, Activity), "activity should instance of Activity")

	if arg1_62:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_62 = pg.battlepass_event_pt[arg1_62.id].target

		if arg0_62.data[arg1_62.id].data1 < var0_62[#var0_62] and arg1_62.data1 - arg0_62.data[arg1_62.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_62.id].pt,
				ptCount = arg1_62.data1 - arg0_62.data[arg1_62.id].data1
			})
		end
	end

	arg0_62.data[arg1_62.id] = arg1_62

	arg0_62:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_62:clone())
	arg0_62:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_62.id
	})
end

function var0_0.addActivity(arg0_63, arg1_63)
	assert(arg0_63.data[arg1_63.id] == nil, "activity already exist" .. arg1_63.id)
	assert(isa(arg1_63, Activity), "activity should instance of Activity")

	arg0_63.data[arg1_63.id] = arg1_63

	arg0_63:sendNotification(var0_0.ACTIVITY_ADDED, arg1_63:clone())

	if arg1_63.stopTime > 0 then
		table.insert(arg0_63.stopList, {
			arg1_63.stopTime,
			arg1_63.id
		})
		table.sort(arg0_63.stopList, CompareFuncs({
			function(arg0_64)
				return arg0_64[1]
			end
		}))
	end

	if arg1_63:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		table.insert(arg0_63.buffActs, arg1_63.id)
		arg0_63:refreshActivityBuffs()
	end
end

function var0_0.deleteActivityById(arg0_65, arg1_65)
	assert(arg0_65.data[arg1_65], "activity should exist" .. arg1_65)

	arg0_65.data[arg1_65] = nil

	arg0_65:sendNotification(var0_0.ACTIVITY_DELETED, arg1_65)

	local var0_65 = table.getIndex(arg0_65.stopList, function(arg0_66)
		return arg0_66[2] == arg1_65
	end)

	if var0_65 then
		table.remove(arg0_65.stopList, var0_65)
	end
end

function var0_0.IsActivityNotEnd(arg0_67, arg1_67)
	return arg0_67.data[arg1_67] and not arg0_67.data[arg1_67]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_68, arg1_68)
	local var0_68 = false
	local var1_68 = arg0_68:getActivitiesByType(arg1_68)

	for iter0_68, iter1_68 in ipairs(var1_68) do
		if iter1_68:readyToAchieve() then
			var0_68 = true

			break
		end
	end

	return var0_68
end

function var0_0.getBuildActivityCfgByID(arg0_69, arg1_69)
	local var0_69 = arg0_69:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
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

function var0_0.getNoneActBuildActivityCfgByID(arg0_70, arg1_70)
	local var0_70 = arg0_70:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0_70, iter1_70 in ipairs(var0_70) do
		if not iter1_70:isEnd() then
			local var1_70 = iter1_70:getConfig("config_client")

			if var1_70 and var1_70.id == arg1_70 then
				return var1_70
			end
		end
	end

	return nil
end

function var0_0.getBuffShipList(arg0_71)
	local var0_71 = {}
	local var1_71 = arg0_71:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_71, function(arg0_72)
		if arg0_72 and not arg0_72:isEnd() then
			local var0_72 = arg0_72:getConfig("config_id")
			local var1_72 = pg.activity_expup_ship[var0_72]

			if not var1_72 then
				return
			end

			local var2_72 = var1_72.expup

			for iter0_72, iter1_72 in pairs(var2_72) do
				var0_71[iter1_72[1]] = iter1_72[2]
			end
		end
	end)

	return var0_71
end

function var0_0.getVirtualItemNumber(arg0_73, arg1_73)
	local var0_73 = arg0_73:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_73 and not var0_73:isEnd() then
		return var0_73.data1KeyValueList[1][arg1_73] and var0_73.data1KeyValueList[1][arg1_73] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg0_74:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_74, "vbagType invalid")

	if var0_74 and not var0_74:isEnd() then
		var0_74.data1KeyValueList[1][arg1_74] = var0_74.data1KeyValueList[1][arg1_74] - arg2_74
	end

	arg0_74:updateActivity(var0_74)
end

function var0_0.addVitemById(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) or arg0_75:getActivityByType(ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA)

	assert(var0_75, "vbagType invalid")

	if var0_75 and not var0_75:isEnd() then
		if not var0_75.data1KeyValueList[1][arg1_75] then
			var0_75.data1KeyValueList[1][arg1_75] = 0
		end

		var0_75.data1KeyValueList[1][arg1_75] = var0_75.data1KeyValueList[1][arg1_75] + arg2_75
	end

	arg0_75:updateActivity(var0_75)

	local var1_75 = Item.getConfigData(arg1_75).link_id

	if var1_75 ~= 0 then
		local var2_75 = arg0_75:getActivityById(var1_75)

		if var2_75 and not var2_75:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_75, arg2_75)
		end
	end
end

function var0_0.monitorTaskList(arg0_76, arg1_76)
	if arg1_76 and not arg1_76:isEnd() and arg1_76:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_76 = arg1_76:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_76) then
			arg0_76:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_76.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_77, arg1_77, arg2_77)
	getProxy(FleetProxy):addActivityFleet(arg1_77, arg2_77.group_list)
end

function var0_0.InitActivityBossData(arg0_78, arg1_78)
	local var0_78 = pg.activity_event_worldboss[arg1_78:getConfig("config_id")]

	if not var0_78 then
		return
	end

	local var1_78 = arg1_78.data1KeyValueList

	for iter0_78, iter1_78 in pairs(var0_78.normal_expedition_drop_num or {}) do
		for iter2_78, iter3_78 in pairs(iter1_78[1]) do
			local var2_78 = iter1_78[2]
			local var3_78 = var1_78[1][iter3_78] or 0

			var1_78[1][iter3_78] = math.max(var2_78 - var3_78, 0)
			var1_78[2][iter3_78] = var1_78[2][iter3_78] or 0
		end
	end
end

function var0_0.AddInstagramTimer(arg0_79, arg1_79)
	arg0_79:RemoveInstagramTimer()

	local var0_79, var1_79 = arg0_79.data[arg1_79]:GetNextPushTime()

	if var0_79 then
		local var2_79 = var0_79 - pg.TimeMgr.GetInstance():GetServerTime()

		local function var3_79()
			arg0_79:sendNotification(GAME.ACT_INSTAGRAM_OP, {
				arg2 = 0,
				activity_id = arg1_79,
				cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
				arg1 = var1_79
			})
		end

		if var2_79 <= 0 then
			var3_79()
		else
			arg0_79.instagramTimer = Timer.New(function()
				var3_79()
				arg0_79:RemoveInstagramTimer()
			end, var2_79, 1)

			arg0_79.instagramTimer:Start()
		end
	end
end

function var0_0.RemoveInstagramTimer(arg0_82)
	if arg0_82.instagramTimer then
		arg0_82.instagramTimer:Stop()

		arg0_82.instagramTimer = nil
	end
end

function var0_0.RegisterRequestTime(arg0_83, arg1_83, arg2_83)
	if not arg1_83 or arg1_83 <= 0 then
		return
	end

	arg0_83.requestTime[arg1_83] = arg2_83
end

function var0_0.remove(arg0_84)
	arg0_84:RemoveInstagramTimer()
end

function var0_0.addActivityParameter(arg0_85, arg1_85)
	local var0_85 = arg1_85:getConfig("config_data")
	local var1_85 = arg1_85.stopTime

	for iter0_85, iter1_85 in ipairs(var0_85) do
		arg0_85.params[iter1_85[1]] = {
			iter1_85[2],
			var1_85
		}
	end
end

function var0_0.getActivityParameter(arg0_86, arg1_86)
	if arg0_86.params[arg1_86] then
		local var0_86, var1_86 = unpack(arg0_86.params[arg1_86])

		if not (var1_86 > 0) or not (var1_86 <= pg.TimeMgr.GetInstance():GetServerTime()) then
			return var0_86
		end
	end
end

function var0_0.IsShowFreeBuildMark(arg0_87, arg1_87)
	for iter0_87, iter1_87 in ipairs(arg0_87:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter1_87 and not iter1_87:isEnd() and iter1_87.data1 > 0 and iter1_87.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 and tobool(arg1_87) == (PlayerPrefs.GetString("Free_Build_Ticket_" .. iter1_87.id, "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")) then
			return iter1_87
		end
	end

	return false
end

function var0_0.getBuildFreeActivityByBuildId(arg0_88, arg1_88)
	for iter0_88, iter1_88 in ipairs(arg0_88:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if underscore.any(iter1_88:getConfig("config_data"), function(arg0_89)
			return arg0_89 == arg1_88
		end) then
			return iter1_88
		end
	end
end

function var0_0.getBuildPoolActivity(arg0_90, arg1_90)
	if arg1_90:IsActivity() then
		return arg0_90:getActivityById(arg1_90.activityId)
	end
end

function var0_0.getEnterReadyActivity(arg0_91)
	local var0_91 = {
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_92)
			return not arg0_92:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = false,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = false
	}
	local var1_91 = _.keys(var0_91)
	local var2_91 = {}

	for iter0_91, iter1_91 in ipairs(var1_91) do
		var2_91[iter1_91] = 0
	end

	for iter2_91, iter3_91 in pairs(arg0_91.data) do
		local var3_91 = iter3_91:getConfig("type")

		if var2_91[var3_91] and not iter3_91:isEnd() and not existCall(var0_91[var3_91], iter3_91) then
			var2_91[var3_91] = math.max(var2_91[var3_91], iter2_91)
		end
	end

	table.sort(var1_91)

	for iter4_91, iter5_91 in ipairs(var1_91) do
		if var2_91[iter5_91] > 0 then
			return arg0_91.data[var2_91[iter5_91]]
		end
	end
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_93)
	local var0_93 = arg0_93:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_93 or var0_93:isEnd() then
		return false
	end

	local var1_93 = var0_93:GetSlots()

	for iter0_93, iter1_93 in pairs(var1_93) do
		if iter1_93[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_94, arg1_94, arg2_94)
	local var0_94 = arg0_94:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_94 or var0_94:isEnd() then
		return false
	end

	local var1_94 = var0_94:GetItems()[arg1_94]

	return var1_94 and arg2_94 <= var1_94.count
end

function var0_0.refreshActivityBuffs(arg0_95)
	arg0_95.actBuffs = {}

	local var0_95 = 1

	while var0_95 <= #arg0_95.buffActs do
		local var1_95 = arg0_95.data[arg0_95.buffActs[var0_95]]

		if not var1_95 or var1_95:isEnd() then
			table.remove(arg0_95.buffActs, var0_95)
		else
			var0_95 = var0_95 + 1

			local var2_95 = {
				var1_95:getConfig("config_id")
			}

			if var2_95[1] == 0 then
				var2_95 = var1_95:getConfig("config_data")
			end

			for iter0_95, iter1_95 in ipairs(var2_95) do
				local var3_95 = ActivityBuff.New(var1_95.id, iter1_95)

				if var3_95:isActivate() then
					table.insert(arg0_95.actBuffs, var3_95)
				end
			end
		end
	end
end

function var0_0.getActivityBuffs(arg0_96)
	if underscore.any(arg0_96.buffActs, function(arg0_97)
		return not arg0_96.data[arg0_97] or arg0_96.data[arg0_97]:isEnd()
	end) or underscore.any(arg0_96.actBuffs, function(arg0_98)
		return not arg0_98:isActivate()
	end) then
		arg0_96:refreshActivityBuffs()
	end

	return arg0_96.actBuffs
end

function var0_0.getShipModExpActivity(arg0_99)
	return underscore.select(arg0_99:getActivityBuffs(), function(arg0_100)
		return arg0_100:ShipModExpUsage()
	end)
end

function var0_0.getBackyardEnergyActivityBuffs(arg0_101)
	return underscore.select(arg0_101:getActivityBuffs(), function(arg0_102)
		return arg0_102:BackyardEnergyUsage()
	end)
end

function var0_0.InitContinuousTime(arg0_103, arg1_103)
	arg0_103.continuousOpeartionTime = arg1_103
	arg0_103.continuousOpeartionTotalTime = arg1_103
end

function var0_0.UseContinuousTime(arg0_104)
	if not arg0_104.continuousOpeartionTime then
		return
	end

	arg0_104.continuousOpeartionTime = arg0_104.continuousOpeartionTime - 1
end

function var0_0.GetContinuousTime(arg0_105)
	return arg0_105.continuousOpeartionTime, arg0_105.continuousOpeartionTotalTime
end

function var0_0.AddBossRushAwards(arg0_106, arg1_106)
	arg0_106.bossrushAwards = arg0_106.bossrushAwards or {}

	table.insertto(arg0_106.bossrushAwards, arg1_106)
end

function var0_0.PopBossRushAwards(arg0_107)
	local var0_107 = arg0_107.bossrushAwards or {}

	arg0_107.bossrushAwards = nil

	return var0_107
end

function var0_0.GetBossRushRuntime(arg0_108, arg1_108)
	if not arg0_108.extraDatas[arg1_108] then
		arg0_108.extraDatas[arg1_108] = {
			record = 0
		}
	end

	return arg0_108.extraDatas[arg1_108]
end

function var0_0.GetActivityBossRuntime(arg0_109, arg1_109)
	if not arg0_109.extraDatas[arg1_109] then
		arg0_109.extraDatas[arg1_109] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0_109.extraDatas[arg1_109]
end

function var0_0.GetTaskActivities(arg0_110)
	local var0_110 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0_111, arg1_111)
		if not isa(arg1_111, ITaskActivity) then
			return
		end

		table.insertto(var0_110, arg0_110:getActivitiesByType(arg0_111))
	end)

	return var0_110
end

function var0_0.setSurveyState(arg0_112, arg1_112)
	local var0_112 = arg0_112:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_112 and not var0_112:isEnd() then
		arg0_112.surveyState = arg1_112
	end
end

function var0_0.isSurveyDone(arg0_113)
	local var0_113 = arg0_113:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_113 and not var0_113:isEnd() then
		return arg0_113.surveyState and arg0_113.surveyState > 0
	end
end

function var0_0.isSurveyOpen(arg0_114)
	local var0_114 = arg0_114:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_114 and not var0_114:isEnd() then
		local var1_114 = var0_114:getConfig("config_data")
		local var2_114 = var1_114[1]
		local var3_114 = var1_114[2]

		if var2_114 == 1 then
			local var4_114 = var3_114 <= getProxy(PlayerProxy):getData().level
			local var5_114 = var0_114:getConfig("config_id")

			return var4_114, var5_114
		end
	end
end

function var0_0.GetActBossLinkPTActID(arg0_115, arg1_115)
	local var0_115 = table.Find(arg0_115.data, function(arg0_116, arg1_116)
		if arg1_116:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1_116:getDataConfig("link_id") == arg1_115
	end)

	return var0_115 and var0_115.id
end

function var0_0.CheckDailyEventRequest(arg0_117, arg1_117)
	if arg1_117:CheckDailyEventRequest() then
		arg0_117:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1_117.id
		})
	end
end

return var0_0
