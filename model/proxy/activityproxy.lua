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

		local var6_2 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

		if var6_2 and not var6_2:isEnd() then
			getProxy(EventProxy):CheckAddActivityEvent()
		end

		BuffHelper.GetAllBuff()
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

function var0_0.remove(arg0_11)
	BuffHelper.ClearAllCache()
end

function var0_0.timeCall(arg0_12)
	return {
		[ProxyRegister.DayCall] = function(arg0_13)
			for iter0_13, iter1_13 in pairs(arg0_12.data) do
				if not iter1_13:isEnd() then
					switch(iter1_13:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function()
							iter1_13.autoActionForbidden = false

							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN] = function()
							iter1_13.autoActionForbidden = false

							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_MONTHSIGN] = function()
							iter1_13.autoActionForbidden = false

							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_REFLUX] = function()
							iter1_13.data1KeyValueList = {
								{}
							}
							iter1_13.autoActionForbidden = false

							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = function()
							iter1_13.autoActionForbidden = false

							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_BB] = function()
							iter1_13.data2 = 0
							iter1_13.autoActionForbidden = false

							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function()
							iter1_13.data2 = 0
							iter1_13.autoActionForbidden = false

							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
							local var0_21 = iter1_13:GetUsedBonus()

							table.Foreach(var0_21, function(arg0_22, arg1_22)
								var0_21[arg0_22] = 0
							end)
							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
							local var0_23 = iter1_13:GetDailyCounts()

							table.Foreach(var0_23, function(arg0_24, arg1_24)
								var0_23[arg0_24] = 0
							end)
							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN] = function()
							arg0_12:sendNotification(GAME.ACT_MANUAL_SIGN, {
								activity_id = iter1_13.id,
								cmd = ManualSignActivity.OP_SIGN
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function()
							local var0_27 = iter1_13:getConfig("config_id")
							local var1_27 = pg.activity_event_turning[var0_27]

							if var1_27.total_num <= iter1_13.data3 then
								return
							end

							local var2_27 = var1_27.task_table[iter1_13.data4]

							if not var2_27 then
								return
							end

							local var3_27 = getProxy(TaskProxy)

							for iter0_27, iter1_27 in ipairs(var2_27) do
								if (var3_27:getTaskById(iter1_27) or var3_27:getFinishTaskById(iter1_27)):getTaskStatus() ~= 2 then
									return
								end
							end

							arg0_12:sendNotification(GAME.ACTIVITY_OPERATION, {
								cmd = 2,
								activity_id = iter1_13.id
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_MONOPOLY] = function()
							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_CHALLENGE] = function()
							arg0_12:sendNotification(GAME.CHALLENGE2_INFO, {})
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
							local var0_30 = iter1_13.data1KeyValueList[1]
							local var1_30 = pg.activity_event_worldboss[iter1_13:getConfig("config_id")]

							if var1_30 then
								for iter0_30, iter1_30 in ipairs(var1_30.normal_expedition_drop_num or {}) do
									for iter2_30, iter3_30 in ipairs(iter1_30[1]) do
										var0_30[iter3_30] = iter1_30[2] or 0
									end
								end
							end

							arg0_12:updateActivity(iter1_13)
						end,
						[ActivityConst.ACTIVITY_TYPE_RANDOM_DAILY_TASK] = function()
							local var0_31 = pg.TimeMgr.GetInstance():GetServerTime()

							if pg.TimeMgr.GetInstance():IsSameDay(iter1_13.data1, var0_31) then
								return
							end

							pg.m02:sendNotification(GAME.ACT_RANDOM_DAILY_TASK, {
								activity_id = iter1_13.id,
								cmd = ActivityConst.RANDOM_DAILY_TASK_OP_RANDOM
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE] = function()
							arg0_12:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
								actId = iter1_13.id
							})
						end
					})
				end
			end
		end,
		[ProxyRegister.SecondCall] = function(arg0_33)
			for iter0_33, iter1_33 in pairs(arg0_12.data) do
				if not iter1_33:isEnd() then
					switch(iter1_33:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_TOWN] = function()
							iter1_33:UpdateTime()
						end
					})
				end
			end

			if not arg0_12.stopList then
				return
			end

			local var0_33 = pg.TimeMgr.GetInstance():GetServerTime()

			while #arg0_12.stopList > 0 and var0_33 >= arg0_12.stopList[1][1] do
				local var1_33, var2_33 = unpack(table.remove(arg0_12.stopList, 1))

				if arg0_12.data[var2_33]:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
					getProxy(MilitaryExerciseProxy):setSeasonOver()
				end

				pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
				arg0_12:sendNotification(var0_0.ACTIVITY_END, var2_33)
			end
		end
	}
end

function var0_0.getAliveActivityByType(arg0_35, arg1_35)
	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		if iter1_35:getConfig("type") == arg1_35 and not iter1_35:isEnd() then
			return iter1_35
		end
	end
end

function var0_0.getActivityByType(arg0_36, arg1_36)
	for iter0_36, iter1_36 in pairs(arg0_36.data) do
		if iter1_36:getConfig("type") == arg1_36 then
			return iter1_36
		end
	end
end

function var0_0.getActivitiesByType(arg0_37, arg1_37)
	local var0_37 = {}

	for iter0_37, iter1_37 in pairs(arg0_37.data) do
		if iter1_37:getConfig("type") == arg1_37 then
			table.insert(var0_37, iter1_37)
		end
	end

	return var0_37
end

function var0_0.getActivitiesByTypes(arg0_38, arg1_38)
	local var0_38 = {}

	for iter0_38, iter1_38 in pairs(arg0_38.data) do
		if table.contains(arg1_38, iter1_38:getConfig("type")) then
			table.insert(var0_38, iter1_38)
		end
	end

	return var0_38
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
		local var1_41 = arg0_41:isShow() and not arg0_41:isAfterShow() and arg0_41:isCorePage("")

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

function var0_0.getCorePanelActivity(arg0_44, arg1_44)
	local var0_44 = {}

	for iter0_44, iter1_44 in pairs(arg0_44.data) do
		if iter1_44:isShow() and iter1_44:isCorePage(arg1_44) then
			table.insert(var0_44, iter1_44)
		end
	end

	table.sort(var0_44, CompareFuncs({
		function(arg0_45)
			return -arg0_45:getConfig("login_pop")
		end,
		function(arg0_46)
			return arg0_46.id
		end
	}))

	return var0_44
end

function var0_0.checkHxActivity(arg0_47, arg1_47)
	if arg0_47.hxList and #arg0_47.hxList > 0 then
		for iter0_47 = 1, #arg0_47.hxList do
			if arg0_47.hxList[iter0_47] == arg1_47 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_48)
	return _(pg.activity_banner.all):chain():map(function(arg0_49)
		return pg.activity_banner[arg0_49]
	end):filter(function(arg0_50)
		return pg.TimeMgr.GetInstance():inTime(arg0_50.time) and arg0_50.type ~= GAMEUI_BANNER_9 and arg0_50.type ~= GAMEUI_BANNER_11 and arg0_50.type ~= GAMEUI_BANNER_10 and arg0_50.type ~= GAMEUI_BANNER_12 and arg0_50.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_51, arg1_51)
	local var0_51 = pg.activity_banner.get_id_list_by_type[arg1_51]

	if not var0_51 then
		return nil
	end

	for iter0_51, iter1_51 in ipairs(var0_51) do
		local var1_51 = pg.activity_banner[iter1_51]

		if pg.TimeMgr.GetInstance():inTime(var1_51.time) then
			return var1_51
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_52)
	return _.map(pg.activity_banner_notice.all, function(arg0_53)
		return pg.activity_banner_notice[arg0_53]
	end)
end

function var0_0.findNextAutoActivity(arg0_54)
	local var0_54
	local var1_54 = pg.TimeMgr.GetInstance()
	local var2_54 = var1_54:GetServerTime()

	for iter0_54, iter1_54 in ipairs(arg0_54:getPanelActivities()) do
		if not iter1_54.autoActionForbidden then
			local var3_54 = iter1_54:getConfig("type")

			if var3_54 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var4_54 = iter1_54:getConfig("config_id")
				local var5_54 = pg.activity_7_day_sign[var4_54].front_drops

				if iter1_54.data1 < #var5_54 and not var1_54:IsSameDay(var2_54, iter1_54.data2) and var2_54 > iter1_54.data2 then
					var0_54 = iter1_54

					break
				end
			elseif var3_54 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var6_54 = getProxy(ChapterProxy)

				if iter1_54.data1 < 7 and not var1_54:IsSameDay(var2_54, iter1_54.data2) or iter1_54.data1 == 7 and not iter1_54.achieved and var6_54:isClear(204) then
					var0_54 = iter1_54

					break
				end
			elseif var3_54 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var7_54 = pg.TimeMgr.GetInstance():STimeDescS(var2_54, "*t")

				iter1_54:setSpecialData("reMonthSignDay", nil)

				if var7_54.year ~= iter1_54.data1 or var7_54.month ~= iter1_54.data2 then
					iter1_54.data1 = var7_54.year
					iter1_54.data2 = var7_54.month
					iter1_54.data1_list = {}
					var0_54 = iter1_54

					break
				elseif not table.contains(iter1_54.data1_list, var7_54.day) then
					var0_54 = iter1_54

					break
				elseif var7_54.day > #iter1_54.data1_list and pg.activity_month_sign[iter1_54.data2].resign_count > iter1_54.data3 then
					for iter2_54 = var7_54.day, 1, -1 do
						if not table.contains(iter1_54.data1_list, iter2_54) then
							iter1_54:setSpecialData("reMonthSignDay", iter2_54)

							break
						end
					end

					var0_54 = iter1_54
				end
			elseif iter1_54.id == ActivityConst.SHADOW_PLAY_ID and iter1_54.clientData1 == 0 then
				local var8_54 = iter1_54:getConfig("config_data")[1]
				local var9_54 = getProxy(TaskProxy)
				local var10_54 = var9_54:getTaskById(var8_54) or var9_54:getFinishTaskById(var8_54)

				if var10_54 and not var10_54:isReceive() then
					var0_54 = iter1_54

					break
				end
			end
		end
	end

	if not var0_54 then
		for iter3_54, iter4_54 in pairs(arg0_54.data) do
			if not iter4_54:isShow() and iter4_54:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var11_54 = iter4_54:getConfig("config_id")
				local var12_54 = pg.activity_7_day_sign[var11_54].front_drops

				if iter4_54.data1 < #var12_54 and not var1_54:IsSameDay(var2_54, iter4_54.data2) and var2_54 > iter4_54.data2 then
					var0_54 = iter4_54

					break
				end
			end
		end
	end

	return var0_54
end

function var0_0.findRefluxAutoActivity(arg0_55)
	local var0_55 = arg0_55:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_55 and not var0_55:isEnd() and not var0_55.autoActionForbidden then
		local var1_55 = pg.TimeMgr.GetInstance()

		if var0_55.data1_list[2] < #pg.return_sign_template.all and not var1_55:IsSameDay(var1_55:GetServerTime(), var0_55.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_56)
	local var0_56 = arg0_56:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_56 and not var0_56:isEnd() then
		local var1_56 = pg.return_pt_template

		for iter0_56 = #var1_56.all, 1, -1 do
			local var2_56 = var1_56.all[iter0_56]
			local var3_56 = var1_56[var2_56]

			if var0_56.data3 >= var3_56.pt_require and var2_56 > var0_56.data4 then
				return true
			end
		end

		local var4_56 = getProxy(TaskProxy)
		local var5_56 = _(var0_56:getConfig("config_data")[7]):chain():map(function(arg0_57)
			return arg0_57[2]
		end):flatten():map(function(arg0_58)
			return var4_56:getTaskById(arg0_58) or var4_56:getFinishTaskById(arg0_58) or false
		end):filter(function(arg0_59)
			return not not arg0_59
		end):value()

		if _.any(var5_56, function(arg0_60)
			return arg0_60:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_61, arg1_61)
	return Clone(arg0_61.data[arg1_61])
end

function var0_0.RawGetActivityById(arg0_62, arg1_62)
	return arg0_62.data[arg1_62]
end

function var0_0.updateActivity(arg0_63, arg1_63)
	assert(arg0_63.data[arg1_63.id], "activity should exist" .. arg1_63.id)
	assert(isa(arg1_63, Activity), "activity should instance of Activity")

	if arg1_63:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_63 = pg.battlepass_event_pt[arg1_63.id].target

		if arg0_63.data[arg1_63.id].data1 < var0_63[#var0_63] and arg1_63.data1 - arg0_63.data[arg1_63.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_63.id].pt,
				ptCount = arg1_63.data1 - arg0_63.data[arg1_63.id].data1
			})
		end
	end

	arg0_63.data[arg1_63.id] = arg1_63

	arg0_63:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_63:clone())
	arg0_63:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_63.id
	})
	BuffHelper.GenBuffsForActivity(arg1_63)
end

function var0_0.addActivity(arg0_64, arg1_64)
	assert(arg0_64.data[arg1_64.id] == nil, "activity already exist" .. arg1_64.id)
	assert(isa(arg1_64, Activity), "activity should instance of Activity")

	arg0_64.data[arg1_64.id] = arg1_64

	arg0_64:sendNotification(var0_0.ACTIVITY_ADDED, arg1_64:clone())

	if arg1_64.stopTime > 0 then
		table.insert(arg0_64.stopList, {
			arg1_64.stopTime,
			arg1_64.id
		})
		table.sort(arg0_64.stopList, CompareFuncs({
			function(arg0_65)
				return arg0_65[1]
			end
		}))
	end
end

function var0_0.deleteActivityById(arg0_66, arg1_66)
	assert(arg0_66.data[arg1_66], "activity should exist" .. arg1_66)

	arg0_66.data[arg1_66] = nil

	arg0_66:sendNotification(var0_0.ACTIVITY_DELETED, arg1_66)

	local var0_66 = table.getIndex(arg0_66.stopList, function(arg0_67)
		return arg0_67[2] == arg1_66
	end)

	if var0_66 then
		table.remove(arg0_66.stopList, var0_66)
	end
end

function var0_0.IsActivityNotEnd(arg0_68, arg1_68)
	return arg0_68.data[arg1_68] and not arg0_68.data[arg1_68]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_69, arg1_69)
	local var0_69 = false
	local var1_69 = arg0_69:getActivitiesByType(arg1_69)

	for iter0_69, iter1_69 in ipairs(var1_69) do
		if iter1_69:readyToAchieve() then
			var0_69 = true

			break
		end
	end

	return var0_69
end

function var0_0.getBuildActivityCfgByID(arg0_70, arg1_70)
	local var0_70 = arg0_70:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
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

function var0_0.getNoneActBuildActivityCfgByID(arg0_71, arg1_71)
	local var0_71 = arg0_71:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0_71, iter1_71 in ipairs(var0_71) do
		if not iter1_71:isEnd() then
			local var1_71 = iter1_71:getConfig("config_client")

			if var1_71 and var1_71.id == arg1_71 then
				return var1_71
			end
		end
	end

	return nil
end

function var0_0.getBuffShipList(arg0_72)
	local var0_72 = {}
	local var1_72 = arg0_72:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_72, function(arg0_73)
		if arg0_73 and not arg0_73:isEnd() then
			local var0_73 = arg0_73:getConfig("config_id")
			local var1_73 = pg.activity_expup_ship[var0_73]

			if not var1_73 then
				return
			end

			local var2_73 = var1_73.expup

			for iter0_73, iter1_73 in pairs(var2_73) do
				var0_72[iter1_73[1]] = iter1_73[2]
			end
		end
	end)

	return var0_72
end

function var0_0.getVirtualItemNumber(arg0_74, arg1_74)
	local var0_74 = arg0_74:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_74 and not var0_74:isEnd() then
		return var0_74.data1KeyValueList[1][arg1_74] and var0_74.data1KeyValueList[1][arg1_74] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_75, "vbagType invalid")

	if var0_75 and not var0_75:isEnd() then
		var0_75.data1KeyValueList[1][arg1_75] = var0_75.data1KeyValueList[1][arg1_75] - arg2_75
	end

	arg0_75:updateActivity(var0_75)
end

function var0_0.addVitemById(arg0_76, arg1_76, arg2_76)
	local var0_76 = arg0_76:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) or arg0_76:getActivityByType(ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA)

	assert(var0_76, "vbagType invalid")

	if var0_76 and not var0_76:isEnd() then
		if not var0_76.data1KeyValueList[1][arg1_76] then
			var0_76.data1KeyValueList[1][arg1_76] = 0
		end

		var0_76.data1KeyValueList[1][arg1_76] = var0_76.data1KeyValueList[1][arg1_76] + arg2_76
	end

	arg0_76:updateActivity(var0_76)

	local var1_76 = Item.getConfigData(arg1_76).link_id

	if var1_76 ~= 0 then
		local var2_76 = arg0_76:getActivityById(var1_76)

		if var2_76 and not var2_76:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_76, arg2_76)
		end
	end
end

function var0_0.monitorTaskList(arg0_77, arg1_77)
	if arg1_77 and not arg1_77:isEnd() and arg1_77:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_77 = arg1_77:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_77) then
			arg0_77:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_77.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_78, arg1_78, arg2_78)
	getProxy(FleetProxy):addActivityFleet(arg1_78, arg2_78.group_list)
end

function var0_0.InitActivityBossData(arg0_79, arg1_79)
	local var0_79 = pg.activity_event_worldboss[arg1_79:getConfig("config_id")]

	if not var0_79 then
		return
	end

	local var1_79 = arg1_79.data1KeyValueList

	for iter0_79, iter1_79 in pairs(var0_79.normal_expedition_drop_num or {}) do
		for iter2_79, iter3_79 in pairs(iter1_79[1]) do
			local var2_79 = iter1_79[2]
			local var3_79 = var1_79[1][iter3_79] or 0

			var1_79[1][iter3_79] = math.max(var2_79 - var3_79, 0)
			var1_79[2][iter3_79] = var1_79[2][iter3_79] or 0
		end
	end
end

function var0_0.RegisterRequestTime(arg0_80, arg1_80, arg2_80)
	if not arg1_80 or arg1_80 <= 0 then
		return
	end

	arg0_80.requestTime[arg1_80] = arg2_80
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
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function(arg0_88)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_89)
			return arg0_89:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function(arg0_90)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function(arg0_91)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function(arg0_92)
			return true
		end
	}
	local var1_87 = {}

	for iter0_87, iter1_87 in pairs(arg0_87.data) do
		if switch(iter1_87:getConfig("type"), var0_87, function(arg0_93)
			return false
		end) and not iter1_87:isEnd() and tobool(iter1_87:getConfig("config_client").entrance_bg) then
			table.insert(var1_87, iter1_87)
		end
	end

	table.sort(var1_87, CompareFuncs({
		function(arg0_94)
			return arg0_94:getConfig("config_client").order or 1
		end,
		function(arg0_95)
			return -arg0_95.id
		end
	}))

	return var1_87
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_96)
	local var0_96 = arg0_96:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_96 or var0_96:isEnd() then
		return false
	end

	local var1_96 = var0_96:GetSlots()

	for iter0_96, iter1_96 in pairs(var1_96) do
		if iter1_96[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_97, arg1_97, arg2_97)
	local var0_97 = arg0_97:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_97 or var0_97:isEnd() then
		return false
	end

	local var1_97 = var0_97:GetItems()[arg1_97]

	return var1_97 and arg2_97 <= var1_97.count
end

function var0_0.InitContinuousTime(arg0_98, arg1_98)
	arg0_98.continuousOpeartionTime = arg1_98
	arg0_98.continuousOpeartionTotalTime = arg1_98
end

function var0_0.UseContinuousTime(arg0_99)
	if not arg0_99.continuousOpeartionTime then
		return
	end

	arg0_99.continuousOpeartionTime = arg0_99.continuousOpeartionTime - 1
end

function var0_0.GetContinuousTime(arg0_100)
	return arg0_100.continuousOpeartionTime, arg0_100.continuousOpeartionTotalTime
end

function var0_0.AddBossRushAwards(arg0_101, arg1_101)
	arg0_101.bossrushAwards = arg0_101.bossrushAwards or {}

	table.insertto(arg0_101.bossrushAwards, arg1_101)
end

function var0_0.PopBossRushAwards(arg0_102)
	local var0_102 = arg0_102.bossrushAwards or {}

	arg0_102.bossrushAwards = nil

	return var0_102
end

function var0_0.GetBossRushRuntime(arg0_103, arg1_103)
	if not arg0_103.extraDatas[arg1_103] then
		arg0_103.extraDatas[arg1_103] = {
			record = 0
		}
	end

	return arg0_103.extraDatas[arg1_103]
end

function var0_0.GetActivityBossRuntime(arg0_104, arg1_104)
	if not arg0_104.extraDatas[arg1_104] then
		arg0_104.extraDatas[arg1_104] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0_104.extraDatas[arg1_104]
end

function var0_0.GetTaskActivities(arg0_105)
	local var0_105 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0_106, arg1_106)
		if not isa(arg1_106, ITaskActivity) then
			return
		end

		table.insertto(var0_105, arg0_105:getActivitiesByType(arg0_106))
	end)

	return var0_105
end

function var0_0.setSurveyState(arg0_107, arg1_107)
	local var0_107 = arg0_107:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_107 and not var0_107:isEnd() then
		arg0_107.surveyState = arg1_107
	end
end

function var0_0.isSurveyDone(arg0_108)
	local var0_108 = arg0_108:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_108 and not var0_108:isEnd() then
		return arg0_108.surveyState and arg0_108.surveyState > 0
	end
end

function var0_0.isSurveyOpen(arg0_109)
	local var0_109 = arg0_109:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_109 and not var0_109:isEnd() then
		local var1_109 = var0_109:getConfig("config_data")
		local var2_109 = var1_109[1]
		local var3_109 = var1_109[2]

		if var2_109 == 1 then
			local var4_109 = var3_109 <= getProxy(PlayerProxy):getData().level
			local var5_109 = var0_109:getConfig("config_id")

			return var4_109, var5_109
		end
	end
end

function var0_0.GetActBossLinkPTActID(arg0_110, arg1_110)
	local var0_110 = table.Find(arg0_110.data, function(arg0_111, arg1_111)
		if arg1_111:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1_111:getDataConfig("link_id") == arg1_110
	end)

	return var0_110 and var0_110.id
end

function var0_0.CheckDailyEventRequest(arg0_112, arg1_112)
	if arg1_112:CheckDailyEventRequest() then
		arg0_112:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1_112.id
		})
	end
end

return var0_0
