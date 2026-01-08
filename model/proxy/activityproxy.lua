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
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
					arg0_1:InitActtivityFleet(var0_2, iter3_2)
				end

				arg0_1.data[iter3_2.id] = var0_2

				if var0_2.stopTime > 0 then
					table.insert(arg0_1.stopList, {
						var0_2.stopTime,
						var0_2.id
					})
					table.sort(arg0_1.stopList, CompareFuncs({
						function(arg0_3)
							return arg0_3[1]
						end
					}))
				end
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
			local var0_4 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not var0_4 then
				return
			end

			arg0_1:sendNotification(GAME.REQUEST_ATELIER, var0_4.id)
		end)()

		local var6_2 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

		if var6_2 and not var6_2:isEnd() then
			getProxy(EventProxy):CheckAddActivityEvent()
		end

		BuffHelper.GetAllBuff()
	end)
	arg0_1:on(11201, function(arg0_5)
		local var0_5 = Activity.Create(arg0_5.activity_info)

		assert(var0_5.id, "should exist activity")

		local var1_5 = var0_5:getConfig("type")

		if var1_5 == ActivityConst.ACTIVITY_TYPE_PARAMETER then
			arg0_1:addActivityParameter(var0_5)
		end

		if not arg0_1.data[var0_5.id] then
			arg0_1:addActivity(var0_5)
		else
			arg0_1:updateActivity(var0_5)
		end

		if var1_5 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			arg0_1:InitActtivityFleet(var0_5, arg0_5.activity_info)
			arg0_1:InitActivityBossData(var0_5)
		end

		arg0_1:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
			activity = var0_5
		})
	end)
	arg0_1:on(40009, function(arg0_6)
		local var0_6 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH) or arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB)
		local var1_6

		if var0_6 then
			var1_6 = var0_6:GetSeriesData()
		end

		local var2_6 = BossRushSettlementCommand.ConcludeEXP(arg0_6, var0_6, var1_6 and var1_6:GetBattleStatistics())

		;(function()
			arg0_1:GetBossRushRuntime(var0_6.id).settlementData = var2_6
		end)()
	end)
	arg0_1:on(24100, function(arg0_8)
		(function()
			local var0_9 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK)

			if not var0_9 then
				return
			end

			var0_9:Record(arg0_8.score)
			arg0_1:updateActivity(var0_9)
		end)()

		local var0_8 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

		if not var0_8 then
			return
		end

		local var1_8 = var0_8:GetSeriesData()

		if not var1_8 then
			return
		end

		var1_8:AddEXScore(arg0_8)
		arg0_1:updateActivity(var0_8)
	end)
	arg0_1:on(11028, function(arg0_10)
		print("接受到问卷状态", arg0_10.result)

		if arg0_10.result == 0 then
			arg0_1:setSurveyState(arg0_10.result)
		elseif arg0_10.result > 0 then
			arg0_1:setSurveyState(arg0_10.result)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_10.result))
		end
	end)
	arg0_1:on(26033, function(arg0_11)
		local var0_11 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

		if not var0_11 then
			return
		end

		local var1_11 = arg0_11.point
		local var2_11 = var0_11:UpdateHighestScore(var1_11)

		arg0_1:GetActivityBossRuntime(var0_11.id).spScore = {
			score = var1_11,
			new = var2_11
		}

		arg0_1:updateActivity(var0_11)
	end)

	arg0_1.requestTime = {}
	arg0_1.extraDatas = {}
end

function var0_0.remove(arg0_12)
	BuffHelper.ClearAllCache()
end

function var0_0.timeCall(arg0_13)
	return {
		[ProxyRegister.DayCall] = function(arg0_14)
			for iter0_14, iter1_14 in pairs(arg0_13.data) do
				if not iter1_14:isEnd() then
					switch(iter1_14:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function()
							iter1_14.autoActionForbidden = false

							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN] = function()
							iter1_14.autoActionForbidden = false

							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_MONTHSIGN] = function()
							iter1_14.autoActionForbidden = false

							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_REFLUX] = function()
							iter1_14.data1KeyValueList = {
								{}
							}
							iter1_14.autoActionForbidden = false

							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = function()
							iter1_14.autoActionForbidden = false

							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_BB] = function()
							iter1_14.data2 = 0
							iter1_14.autoActionForbidden = false

							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function()
							iter1_14.data2 = 0
							iter1_14.autoActionForbidden = false

							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
							local var0_22 = iter1_14:GetUsedBonus()

							table.Foreach(var0_22, function(arg0_23, arg1_23)
								var0_22[arg0_23] = 0
							end)
							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
							local var0_24 = iter1_14:GetDailyCounts()

							table.Foreach(var0_24, function(arg0_25, arg1_25)
								var0_24[arg0_25] = 0
							end)
							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN] = function()
							arg0_13:sendNotification(GAME.ACT_MANUAL_SIGN, {
								activity_id = iter1_14.id,
								cmd = ManualSignActivity.OP_SIGN
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function()
							local var0_28 = iter1_14:getConfig("config_id")
							local var1_28 = pg.activity_event_turning[var0_28]

							if var1_28.total_num <= iter1_14.data3 then
								return
							end

							local var2_28 = var1_28.task_table[iter1_14.data4]

							if not var2_28 then
								return
							end

							local var3_28 = getProxy(TaskProxy)

							for iter0_28, iter1_28 in ipairs(var2_28) do
								if (var3_28:getTaskById(iter1_28) or var3_28:getFinishTaskById(iter1_28)):getTaskStatus() ~= 2 then
									return
								end
							end

							arg0_13:sendNotification(GAME.ACTIVITY_OPERATION, {
								cmd = 2,
								activity_id = iter1_14.id
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_MONOPOLY] = function()
							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_CHALLENGE] = function()
							arg0_13:sendNotification(GAME.CHALLENGE2_INFO, {})
						end,
						[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
							local var0_31 = iter1_14.data1KeyValueList[1]
							local var1_31 = pg.activity_event_worldboss[iter1_14:getConfig("config_id")]

							if var1_31 then
								for iter0_31, iter1_31 in ipairs(var1_31.normal_expedition_drop_num or {}) do
									for iter2_31, iter3_31 in ipairs(iter1_31[1]) do
										var0_31[iter3_31] = iter1_31[2] or 0
									end
								end
							end

							arg0_13:updateActivity(iter1_14)
						end,
						[ActivityConst.ACTIVITY_TYPE_RANDOM_DAILY_TASK] = function()
							local var0_32 = pg.TimeMgr.GetInstance():GetServerTime()

							if pg.TimeMgr.GetInstance():IsSameDay(iter1_14.data1, var0_32) then
								return
							end

							pg.m02:sendNotification(GAME.ACT_RANDOM_DAILY_TASK, {
								activity_id = iter1_14.id,
								cmd = ActivityConst.RANDOM_DAILY_TASK_OP_RANDOM
							})
						end,
						[ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE] = function()
							arg0_13:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
								actId = iter1_14.id
							})
						end
					})
				end
			end
		end,
		[ProxyRegister.SecondCall] = function(arg0_34)
			for iter0_34, iter1_34 in pairs(arg0_13.data) do
				if not iter1_34:isEnd() then
					switch(iter1_34:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_TOWN] = function()
							iter1_34:UpdateTime()
						end
					})
				end
			end

			if not arg0_13.stopList then
				return
			end

			local var0_34 = pg.TimeMgr.GetInstance():GetServerTime()

			while #arg0_13.stopList > 0 and var0_34 >= arg0_13.stopList[1][1] do
				local var1_34, var2_34 = unpack(table.remove(arg0_13.stopList, 1))

				if arg0_13.data[var2_34]:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
					getProxy(MilitaryExerciseProxy):setSeasonOver()
				end

				pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
				arg0_13:sendNotification(var0_0.ACTIVITY_END, var2_34)
			end
		end
	}
end

function var0_0.getAliveActivityByType(arg0_36, arg1_36)
	for iter0_36, iter1_36 in pairs(arg0_36.data) do
		if iter1_36:getConfig("type") == arg1_36 and not iter1_36:isEnd() then
			return iter1_36
		end
	end
end

function var0_0.getActivityByType(arg0_37, arg1_37)
	for iter0_37, iter1_37 in pairs(arg0_37.data) do
		if iter1_37:getConfig("type") == arg1_37 then
			return iter1_37
		end
	end
end

function var0_0.getActivitiesByType(arg0_38, arg1_38)
	local var0_38 = {}

	for iter0_38, iter1_38 in pairs(arg0_38.data) do
		if iter1_38:getConfig("type") == arg1_38 then
			table.insert(var0_38, iter1_38)
		end
	end

	return var0_38
end

function var0_0.getActivitiesByTypes(arg0_39, arg1_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in pairs(arg0_39.data) do
		if table.contains(arg1_39, iter1_39:getConfig("type")) then
			table.insert(var0_39, iter1_39)
		end
	end

	return var0_39
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
		local var1_42 = arg0_42:isShow() and not arg0_42:isAfterShow() and arg0_42:isCorePage("")

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

function var0_0.getCorePanelActivities(arg0_45, arg1_45)
	local var0_45 = {}

	for iter0_45, iter1_45 in pairs(arg0_45.data) do
		if iter1_45:isShow() and iter1_45:isCorePage(arg1_45) then
			table.insert(var0_45, iter1_45)
		end
	end

	table.sort(var0_45, CompareFuncs({
		function(arg0_46)
			return -arg0_46:getConfig("login_pop")
		end,
		function(arg0_47)
			return arg0_47.id
		end
	}))

	return var0_45
end

function var0_0.getIslandPanelActivities(arg0_48)
	local function var0_48(arg0_49)
		local var0_49 = arg0_49:getConfig("type")
		local var1_49 = arg0_49:isIslandShow()

		if var1_49 and var0_49 == ActivityConst.ACTIVITY_TYPE_SURVEY then
			local var2_49 = arg0_48:isSurveyOpen()
			local var3_49 = arg0_48:isSurveyDone()

			var1_49 = var2_49 and not var3_49
		end

		return var1_49 and not arg0_49:isEnd()
	end

	local var1_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.data) do
		if var0_48(iter1_48) then
			table.insert(var1_48, iter1_48)
		end
	end

	return var1_48
end

function var0_0.checkHxActivity(arg0_50, arg1_50)
	if arg0_50.hxList and #arg0_50.hxList > 0 then
		for iter0_50 = 1, #arg0_50.hxList do
			if arg0_50.hxList[iter0_50] == arg1_50 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_51)
	return _(pg.activity_banner.all):chain():map(function(arg0_52)
		return pg.activity_banner[arg0_52]
	end):filter(function(arg0_53)
		return pg.TimeMgr.GetInstance():inTime(arg0_53.time) and arg0_53.type ~= GAMEUI_BANNER_9 and arg0_53.type ~= GAMEUI_BANNER_11 and arg0_53.type ~= GAMEUI_BANNER_10 and arg0_53.type ~= GAMEUI_BANNER_12 and arg0_53.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_54, arg1_54)
	local var0_54 = pg.activity_banner.get_id_list_by_type[arg1_54]

	if not var0_54 then
		return nil
	end

	for iter0_54, iter1_54 in ipairs(var0_54) do
		local var1_54 = pg.activity_banner[iter1_54]

		if pg.TimeMgr.GetInstance():inTime(var1_54.time) then
			return var1_54
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_55)
	return _.map(pg.activity_banner_notice.all, function(arg0_56)
		return pg.activity_banner_notice[arg0_56]
	end)
end

function var0_0.findNextAutoActivity(arg0_57, arg1_57)
	local var0_57
	local var1_57 = pg.TimeMgr.GetInstance()
	local var2_57 = var1_57:GetServerTime()
	local var3_57 = arg1_57 and arg1_57 ~= "" and arg0_57:getCorePanelActivities(arg1_57) or arg0_57:getPanelActivities()

	for iter0_57, iter1_57 in ipairs(var3_57) do
		if not iter1_57.autoActionForbidden then
			local var4_57 = iter1_57:getConfig("type")

			if var4_57 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var5_57 = iter1_57:getConfig("config_client")

				if var5_57 and var5_57.manulSign == true then
					-- block empty
				else
					local var6_57 = iter1_57:getConfig("config_id")
					local var7_57 = pg.activity_7_day_sign[var6_57].front_drops

					if iter1_57.data1 < #var7_57 and not var1_57:IsSameDay(var2_57, iter1_57.data2) and var2_57 > iter1_57.data2 then
						var0_57 = iter1_57

						break
					end
				end
			elseif var4_57 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var8_57 = getProxy(ChapterProxy)

				if iter1_57.data1 < 7 and not var1_57:IsSameDay(var2_57, iter1_57.data2) or iter1_57.data1 == 7 and not iter1_57.achieved and var8_57:isClear(204) then
					var0_57 = iter1_57

					break
				end
			elseif var4_57 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var9_57 = pg.TimeMgr.GetInstance():STimeDescS(var2_57, "*t")

				iter1_57:setSpecialData("reMonthSignDay", nil)

				if var9_57.year ~= iter1_57.data1 or var9_57.month ~= iter1_57.data2 then
					iter1_57.data1 = var9_57.year
					iter1_57.data2 = var9_57.month
					iter1_57.data1_list = {}
					var0_57 = iter1_57

					break
				elseif not table.contains(iter1_57.data1_list, var9_57.day) then
					var0_57 = iter1_57

					break
				elseif var9_57.day > #iter1_57.data1_list and pg.activity_month_sign[iter1_57.data2].resign_count > iter1_57.data3 then
					for iter2_57 = var9_57.day, 1, -1 do
						if not table.contains(iter1_57.data1_list, iter2_57) then
							iter1_57:setSpecialData("reMonthSignDay", iter2_57)

							break
						end
					end

					var0_57 = iter1_57
				end
			elseif iter1_57.id == ActivityConst.SHADOW_PLAY_ID and iter1_57.clientData1 == 0 then
				local var10_57 = iter1_57:getConfig("config_data")[1]
				local var11_57 = getProxy(TaskProxy)
				local var12_57 = var11_57:getTaskById(var10_57) or var11_57:getFinishTaskById(var10_57)

				if var12_57 and not var12_57:isReceive() then
					var0_57 = iter1_57

					break
				end
			end
		end
	end

	if not var0_57 then
		for iter3_57, iter4_57 in pairs(arg0_57.data) do
			if not iter4_57:isShow() and iter4_57:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var13_57 = iter4_57:getConfig("config_id")
				local var14_57 = pg.activity_7_day_sign[var13_57].front_drops

				if iter4_57.data1 < #var14_57 and not var1_57:IsSameDay(var2_57, iter4_57.data2) and var2_57 > iter4_57.data2 then
					var0_57 = iter4_57

					break
				end
			end
		end
	end

	return var0_57
end

function var0_0.findRefluxAutoActivity(arg0_58)
	local var0_58 = arg0_58:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_58 and not var0_58:isEnd() and not var0_58.autoActionForbidden then
		local var1_58 = pg.TimeMgr.GetInstance()

		if var0_58.data1_list[2] < #pg.return_sign_template.all and not var1_58:IsSameDay(var1_58:GetServerTime(), var0_58.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_59)
	local var0_59 = arg0_59:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_59 and not var0_59:isEnd() then
		local var1_59 = pg.return_pt_template

		for iter0_59 = #var1_59.all, 1, -1 do
			local var2_59 = var1_59.all[iter0_59]
			local var3_59 = var1_59[var2_59]

			if var0_59.data3 >= var3_59.pt_require and var2_59 > var0_59.data4 then
				return true
			end
		end

		local var4_59 = getProxy(TaskProxy)
		local var5_59 = _(var0_59:getConfig("config_data")[7]):chain():map(function(arg0_60)
			return arg0_60[2]
		end):flatten():map(function(arg0_61)
			return var4_59:getTaskById(arg0_61) or var4_59:getFinishTaskById(arg0_61) or false
		end):filter(function(arg0_62)
			return not not arg0_62
		end):value()

		if _.any(var5_59, function(arg0_63)
			return arg0_63:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_64, arg1_64)
	return Clone(arg0_64.data[arg1_64])
end

function var0_0.RawGetActivityById(arg0_65, arg1_65)
	return arg0_65.data[arg1_65]
end

function var0_0.updateActivity(arg0_66, arg1_66)
	assert(arg0_66.data[arg1_66.id], "activity should exist" .. arg1_66.id)
	assert(isa(arg1_66, Activity), "activity should instance of Activity")

	if arg1_66:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_66 = pg.battlepass_event_pt[arg1_66.id].target

		if arg0_66.data[arg1_66.id].data1 < var0_66[#var0_66] and arg1_66.data1 - arg0_66.data[arg1_66.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_66.id].pt,
				ptCount = arg1_66.data1 - arg0_66.data[arg1_66.id].data1
			})
		end
	elseif arg1_66:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_HEI5 then
		local var1_66 = pg.black_friday_battlepass_event_pt[arg1_66.id].target

		if arg0_66.data[arg1_66.id].data1 < var1_66[#var1_66] and arg1_66.data1 - arg0_66.data[arg1_66.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.black_friday_battlepass_event_pt[arg1_66.id].pt,
				ptCount = arg1_66.data1 - arg0_66.data[arg1_66.id].data1
			})
		end
	end

	arg0_66.data[arg1_66.id] = arg1_66

	arg0_66:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_66:clone())
	arg0_66:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_66.id
	})
	BuffHelper.GenBuffsForActivity(arg1_66)
end

function var0_0.addActivity(arg0_67, arg1_67)
	assert(arg0_67.data[arg1_67.id] == nil, "activity already exist" .. arg1_67.id)
	assert(isa(arg1_67, Activity), "activity should instance of Activity")

	arg0_67.data[arg1_67.id] = arg1_67

	arg0_67:sendNotification(var0_0.ACTIVITY_ADDED, arg1_67:clone())

	if arg1_67.stopTime > 0 then
		table.insert(arg0_67.stopList, {
			arg1_67.stopTime,
			arg1_67.id
		})
		table.sort(arg0_67.stopList, CompareFuncs({
			function(arg0_68)
				return arg0_68[1]
			end
		}))
	end
end

function var0_0.deleteActivityById(arg0_69, arg1_69)
	assert(arg0_69.data[arg1_69], "activity should exist" .. arg1_69)

	arg0_69.data[arg1_69] = nil

	arg0_69:sendNotification(var0_0.ACTIVITY_DELETED, arg1_69)

	local var0_69 = table.getIndex(arg0_69.stopList, function(arg0_70)
		return arg0_70[2] == arg1_69
	end)

	if var0_69 then
		table.remove(arg0_69.stopList, var0_69)
	end
end

function var0_0.IsActivityNotEnd(arg0_71, arg1_71)
	return arg0_71.data[arg1_71] and not arg0_71.data[arg1_71]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_72, arg1_72)
	local var0_72 = false
	local var1_72 = arg0_72:getActivitiesByType(arg1_72)

	for iter0_72, iter1_72 in ipairs(var1_72) do
		if iter1_72:readyToAchieve() then
			var0_72 = true

			break
		end
	end

	return var0_72
end

function var0_0.getBuildActivityCfgByID(arg0_73, arg1_73)
	local var0_73 = arg0_73:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})

	for iter0_73, iter1_73 in ipairs(var0_73) do
		if not iter1_73:isEnd() then
			local var1_73 = iter1_73:getConfig("config_client")

			if var1_73 and var1_73.id == arg1_73 then
				return var1_73
			end
		end
	end

	return nil
end

function var0_0.getNoneActBuildActivityCfgByID(arg0_74, arg1_74)
	local var0_74 = arg0_74:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0_74, iter1_74 in ipairs(var0_74) do
		if not iter1_74:isEnd() then
			local var1_74 = iter1_74:getConfig("config_client")

			if var1_74 and var1_74.id == arg1_74 then
				return var1_74
			end
		end
	end

	return nil
end

function var0_0.getBuffShipList(arg0_75)
	local var0_75 = {}
	local var1_75 = arg0_75:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_75, function(arg0_76)
		if arg0_76 and not arg0_76:isEnd() then
			local var0_76 = arg0_76:getConfig("config_id")
			local var1_76 = pg.activity_expup_ship[var0_76]

			if not var1_76 then
				return
			end

			local var2_76 = var1_76.expup

			for iter0_76, iter1_76 in pairs(var2_76) do
				var0_75[iter1_76[1]] = iter1_76[2]
			end
		end
	end)

	return var0_75
end

function var0_0.getVirtualItemNumber(arg0_77, arg1_77)
	local var0_77 = arg0_77:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_77 and not var0_77:isEnd() then
		return var0_77.data1KeyValueList[1][arg1_77] and var0_77.data1KeyValueList[1][arg1_77] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_78, arg1_78, arg2_78)
	local var0_78 = arg0_78:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_78, "vbagType invalid")

	if var0_78 and not var0_78:isEnd() then
		var0_78.data1KeyValueList[1][arg1_78] = var0_78.data1KeyValueList[1][arg1_78] - arg2_78
	end

	arg0_78:updateActivity(var0_78)
end

function var0_0.addVitemById(arg0_79, arg1_79, arg2_79)
	local var0_79 = arg0_79:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) or arg0_79:getActivityByType(ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA)

	var0_79 = var0_79 or arg0_79:getActivityByType(ActivityConst.ACTIVITY_TYPE_CITY_REBUILD)

	assert(var0_79, "vbagType invalid")

	if var0_79 and not var0_79:isEnd() then
		if not var0_79.data1KeyValueList[1][arg1_79] then
			var0_79.data1KeyValueList[1][arg1_79] = 0
		end

		var0_79.data1KeyValueList[1][arg1_79] = var0_79.data1KeyValueList[1][arg1_79] + arg2_79
	end

	arg0_79:updateActivity(var0_79)

	local var1_79 = Item.getConfigData(arg1_79).link_id

	if var1_79 ~= 0 then
		local var2_79 = arg0_79:getActivityById(var1_79)

		if var2_79 and not var2_79:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_79, arg2_79)
		end
	end
end

function var0_0.monitorTaskList(arg0_80, arg1_80)
	if arg1_80 and not arg1_80:isEnd() and arg1_80:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_80 = arg1_80:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_80) then
			arg0_80:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_80.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_81, arg1_81, arg2_81)
	getProxy(FleetProxy):addActivityFleet(arg1_81, arg2_81.group_list)
end

function var0_0.InitActivityBossData(arg0_82, arg1_82)
	local var0_82 = pg.activity_event_worldboss[arg1_82:getConfig("config_id")]

	if not var0_82 then
		return
	end

	local var1_82 = arg1_82.data1KeyValueList

	for iter0_82, iter1_82 in pairs(var0_82.normal_expedition_drop_num or {}) do
		for iter2_82, iter3_82 in pairs(iter1_82[1]) do
			local var2_82 = iter1_82[2]
			local var3_82 = var1_82[1][iter3_82] or 0

			var1_82[1][iter3_82] = math.max(var2_82 - var3_82, 0)
			var1_82[2][iter3_82] = var1_82[2][iter3_82] or 0
		end
	end
end

function var0_0.RegisterRequestTime(arg0_83, arg1_83, arg2_83)
	if not arg1_83 or arg1_83 <= 0 then
		return
	end

	arg0_83.requestTime[arg1_83] = arg2_83
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
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function(arg0_91)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_92)
			return arg0_92:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function(arg0_93)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function(arg0_94)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function(arg0_95)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function(arg0_96)
			return true
		end
	}
	local var1_90 = {}

	for iter0_90, iter1_90 in pairs(arg0_90.data) do
		if switch(iter1_90:getConfig("type"), var0_90, function(arg0_97)
			return false
		end) and not iter1_90:isEnd() and tobool(iter1_90:getConfig("config_client").entrance_bg) then
			table.insert(var1_90, iter1_90)
		end
	end

	table.sort(var1_90, CompareFuncs({
		function(arg0_98)
			return arg0_98:getConfig("config_client").order or 1
		end,
		function(arg0_99)
			return -arg0_99.id
		end
	}))

	return var1_90
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_100)
	local var0_100 = arg0_100:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_100 or var0_100:isEnd() then
		return false
	end

	local var1_100 = var0_100:GetSlots()

	for iter0_100, iter1_100 in pairs(var1_100) do
		if iter1_100[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_101, arg1_101, arg2_101)
	local var0_101 = arg0_101:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_101 or var0_101:isEnd() then
		return false
	end

	local var1_101 = var0_101:GetItems()[arg1_101]

	return var1_101 and arg2_101 <= var1_101.count
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
			record = 0,
			diff = 1
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
