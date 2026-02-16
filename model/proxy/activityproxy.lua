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
						end,
						[ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_UP] = function()
							iter1_14:DayReset()
							arg0_13:updateActivity(iter1_14)
						end
					})
				end
			end
		end,
		[ProxyRegister.SecondCall] = function(arg0_35)
			for iter0_35, iter1_35 in pairs(arg0_13.data) do
				if not iter1_35:isEnd() then
					switch(iter1_35:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_TOWN] = function()
							iter1_35:UpdateTime()
						end
					})
				end
			end

			if not arg0_13.stopList then
				return
			end

			local var0_35 = pg.TimeMgr.GetInstance():GetServerTime()

			while #arg0_13.stopList > 0 and var0_35 >= arg0_13.stopList[1][1] do
				local var1_35, var2_35 = unpack(table.remove(arg0_13.stopList, 1))

				if arg0_13.data[var2_35]:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
					getProxy(MilitaryExerciseProxy):setSeasonOver()
				end

				pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
				arg0_13:sendNotification(var0_0.ACTIVITY_END, var2_35)
			end
		end
	}
end

function var0_0.getAliveActivityByType(arg0_37, arg1_37)
	for iter0_37, iter1_37 in pairs(arg0_37.data) do
		if iter1_37:getConfig("type") == arg1_37 and not iter1_37:isEnd() then
			return iter1_37
		end
	end
end

function var0_0.getActivityByType(arg0_38, arg1_38)
	for iter0_38, iter1_38 in pairs(arg0_38.data) do
		if iter1_38:getConfig("type") == arg1_38 then
			return iter1_38
		end
	end
end

function var0_0.getActivitiesByType(arg0_39, arg1_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in pairs(arg0_39.data) do
		if iter1_39:getConfig("type") == arg1_39 then
			table.insert(var0_39, iter1_39)
		end
	end

	return var0_39
end

function var0_0.getActivitiesByTypes(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in pairs(arg0_40.data) do
		if table.contains(arg1_40, iter1_40:getConfig("type")) then
			table.insert(var0_40, iter1_40)
		end
	end

	return var0_40
end

function var0_0.getMilitaryExerciseActivity(arg0_41)
	local var0_41

	for iter0_41, iter1_41 in pairs(arg0_41.data) do
		if iter1_41:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			var0_41 = iter1_41

			break
		end
	end

	return Clone(var0_41)
end

function var0_0.getPanelActivities(arg0_42)
	local function var0_42(arg0_43)
		local var0_43 = arg0_43:getConfig("type")
		local var1_43 = arg0_43:isShow() and not arg0_43:isAfterShow() and arg0_43:isCorePage("")

		if var1_43 then
			if var0_43 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				var1_43 = arg0_43.data2 == 0
			elseif var0_43 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				var1_43 = arg0_43.data1 < 7 or not arg0_43.achieved
			elseif var0_43 == ActivityConst.ACTIVITY_TYPE_SURVEY then
				var1_43 = PLATFORM ~= PLATFORM_OPENHARMONY
			end
		end

		return var1_43 and not arg0_43:isEnd()
	end

	local var1_42 = {}

	for iter0_42, iter1_42 in pairs(arg0_42.data) do
		if var0_42(iter1_42) then
			table.insert(var1_42, iter1_42)
		end
	end

	table.sort(var1_42, CompareFuncs({
		function(arg0_44)
			return -arg0_44:getConfig("login_pop")
		end,
		function(arg0_45)
			return arg0_45.id
		end
	}))

	return var1_42
end

function var0_0.getCorePanelActivities(arg0_46, arg1_46)
	local var0_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.data) do
		if iter1_46:isShow() and iter1_46:isCorePage(arg1_46) then
			table.insert(var0_46, iter1_46)
		end
	end

	table.sort(var0_46, CompareFuncs({
		function(arg0_47)
			return -arg0_47:getConfig("login_pop")
		end,
		function(arg0_48)
			return arg0_48.id
		end
	}))

	return var0_46
end

function var0_0.getIslandPanelActivities(arg0_49)
	local function var0_49(arg0_50)
		local var0_50 = arg0_50:getConfig("type")
		local var1_50 = arg0_50:isIslandShow()

		if var1_50 and var0_50 == ActivityConst.ACTIVITY_TYPE_SURVEY then
			local var2_50 = arg0_49:isSurveyOpen()
			local var3_50 = arg0_49:isSurveyDone()

			var1_50 = var2_50 and not var3_50

			if PLATFORM == PLATFORM_OPENHARMONY then
				var1_50 = false
			end
		end

		return var1_50 and not arg0_50:isEnd()
	end

	local var1_49 = {}

	for iter0_49, iter1_49 in pairs(arg0_49.data) do
		if var0_49(iter1_49) then
			table.insert(var1_49, iter1_49)
		end
	end

	return var1_49
end

function var0_0.checkHxActivity(arg0_51, arg1_51)
	if arg0_51.hxList and #arg0_51.hxList > 0 then
		for iter0_51 = 1, #arg0_51.hxList do
			if arg0_51.hxList[iter0_51] == arg1_51 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_52)
	return _(pg.activity_banner.all):chain():map(function(arg0_53)
		return pg.activity_banner[arg0_53]
	end):filter(function(arg0_54)
		return pg.TimeMgr.GetInstance():inTime(arg0_54.time) and arg0_54.type ~= GAMEUI_BANNER_9 and arg0_54.type ~= GAMEUI_BANNER_11 and arg0_54.type ~= GAMEUI_BANNER_10 and arg0_54.type ~= GAMEUI_BANNER_12 and arg0_54.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_55, arg1_55)
	local var0_55 = pg.activity_banner.get_id_list_by_type[arg1_55]

	if not var0_55 then
		return nil
	end

	for iter0_55, iter1_55 in ipairs(var0_55) do
		local var1_55 = pg.activity_banner[iter1_55]

		if pg.TimeMgr.GetInstance():inTime(var1_55.time) then
			return var1_55
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_56)
	return _.map(pg.activity_banner_notice.all, function(arg0_57)
		return pg.activity_banner_notice[arg0_57]
	end)
end

function var0_0.findNextAutoActivity(arg0_58, arg1_58)
	local var0_58
	local var1_58 = pg.TimeMgr.GetInstance()
	local var2_58 = var1_58:GetServerTime()
	local var3_58 = arg1_58 and arg1_58 ~= "" and arg0_58:getCorePanelActivities(arg1_58) or arg0_58:getPanelActivities()

	for iter0_58, iter1_58 in ipairs(var3_58) do
		if not iter1_58.autoActionForbidden then
			local var4_58 = iter1_58:getConfig("type")

			if var4_58 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var5_58 = iter1_58:getConfig("config_client")

				if var5_58 and var5_58.manulSign == true then
					-- block empty
				else
					local var6_58 = iter1_58:getConfig("config_id")
					local var7_58 = pg.activity_7_day_sign[var6_58].front_drops

					if iter1_58.data1 < #var7_58 and not var1_58:IsSameDay(var2_58, iter1_58.data2) and var2_58 > iter1_58.data2 then
						var0_58 = iter1_58

						break
					end
				end
			elseif var4_58 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var8_58 = getProxy(ChapterProxy)

				if iter1_58.data1 < 7 and not var1_58:IsSameDay(var2_58, iter1_58.data2) or iter1_58.data1 == 7 and not iter1_58.achieved and var8_58:isClear(204) then
					var0_58 = iter1_58

					break
				end
			elseif var4_58 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var9_58 = pg.TimeMgr.GetInstance():STimeDescS(var2_58, "*t")

				iter1_58:setSpecialData("reMonthSignDay", nil)

				if var9_58.year ~= iter1_58.data1 or var9_58.month ~= iter1_58.data2 then
					iter1_58.data1 = var9_58.year
					iter1_58.data2 = var9_58.month
					iter1_58.data1_list = {}
					var0_58 = iter1_58

					break
				elseif not table.contains(iter1_58.data1_list, var9_58.day) then
					var0_58 = iter1_58

					break
				elseif var9_58.day > #iter1_58.data1_list and pg.activity_month_sign[iter1_58.data2].resign_count > iter1_58.data3 then
					for iter2_58 = var9_58.day, 1, -1 do
						if not table.contains(iter1_58.data1_list, iter2_58) then
							iter1_58:setSpecialData("reMonthSignDay", iter2_58)

							break
						end
					end

					var0_58 = iter1_58
				end
			elseif iter1_58.id == ActivityConst.SHADOW_PLAY_ID and iter1_58.clientData1 == 0 then
				local var10_58 = iter1_58:getConfig("config_data")[1]
				local var11_58 = getProxy(TaskProxy)
				local var12_58 = var11_58:getTaskById(var10_58) or var11_58:getFinishTaskById(var10_58)

				if var12_58 and not var12_58:isReceive() then
					var0_58 = iter1_58

					break
				end
			end
		end
	end

	if not var0_58 then
		for iter3_58, iter4_58 in pairs(arg0_58.data) do
			if not iter4_58:isShow() and iter4_58:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var13_58 = iter4_58:getConfig("config_id")
				local var14_58 = pg.activity_7_day_sign[var13_58].front_drops

				if iter4_58.data1 < #var14_58 and not var1_58:IsSameDay(var2_58, iter4_58.data2) and var2_58 > iter4_58.data2 then
					var0_58 = iter4_58

					break
				end
			end
		end
	end

	return var0_58
end

function var0_0.findRefluxAutoActivity(arg0_59)
	local var0_59 = arg0_59:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_59 and not var0_59:isEnd() and not var0_59.autoActionForbidden then
		local var1_59 = pg.TimeMgr.GetInstance()

		if var0_59.data1_list[2] < #pg.return_sign_template.all and not var1_59:IsSameDay(var1_59:GetServerTime(), var0_59.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_60)
	local var0_60 = arg0_60:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_60 and not var0_60:isEnd() then
		local var1_60 = pg.return_pt_template

		for iter0_60 = #var1_60.all, 1, -1 do
			local var2_60 = var1_60.all[iter0_60]
			local var3_60 = var1_60[var2_60]

			if var0_60.data3 >= var3_60.pt_require and var2_60 > var0_60.data4 then
				return true
			end
		end

		local var4_60 = getProxy(TaskProxy)
		local var5_60 = _(var0_60:getConfig("config_data")[7]):chain():map(function(arg0_61)
			return arg0_61[2]
		end):flatten():map(function(arg0_62)
			return var4_60:getTaskById(arg0_62) or var4_60:getFinishTaskById(arg0_62) or false
		end):filter(function(arg0_63)
			return not not arg0_63
		end):value()

		if _.any(var5_60, function(arg0_64)
			return arg0_64:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_65, arg1_65)
	return Clone(arg0_65.data[arg1_65])
end

function var0_0.RawGetActivityById(arg0_66, arg1_66)
	return arg0_66.data[arg1_66]
end

function var0_0.updateActivity(arg0_67, arg1_67)
	assert(arg0_67.data[arg1_67.id], "activity should exist" .. arg1_67.id)
	assert(isa(arg1_67, Activity), "activity should instance of Activity")

	if arg1_67:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_67 = pg.battlepass_event_pt[arg1_67.id].target

		if arg0_67.data[arg1_67.id].data1 < var0_67[#var0_67] and arg1_67.data1 - arg0_67.data[arg1_67.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_67.id].pt,
				ptCount = arg1_67.data1 - arg0_67.data[arg1_67.id].data1
			})
		end
	elseif arg1_67:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_HEI5 then
		local var1_67 = pg.black_friday_battlepass_event_pt[arg1_67.id].target

		if arg0_67.data[arg1_67.id].data1 < var1_67[#var1_67] and arg1_67.data1 - arg0_67.data[arg1_67.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.black_friday_battlepass_event_pt[arg1_67.id].pt,
				ptCount = arg1_67.data1 - arg0_67.data[arg1_67.id].data1
			})
		end
	end

	arg0_67.data[arg1_67.id] = arg1_67

	arg0_67:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_67:clone())
	arg0_67:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_67.id
	})
	BuffHelper.GenBuffsForActivity(arg1_67)
end

function var0_0.addActivity(arg0_68, arg1_68)
	assert(arg0_68.data[arg1_68.id] == nil, "activity already exist" .. arg1_68.id)
	assert(isa(arg1_68, Activity), "activity should instance of Activity")

	arg0_68.data[arg1_68.id] = arg1_68

	arg0_68:sendNotification(var0_0.ACTIVITY_ADDED, arg1_68:clone())

	if arg1_68.stopTime > 0 then
		table.insert(arg0_68.stopList, {
			arg1_68.stopTime,
			arg1_68.id
		})
		table.sort(arg0_68.stopList, CompareFuncs({
			function(arg0_69)
				return arg0_69[1]
			end
		}))
	end
end

function var0_0.deleteActivityById(arg0_70, arg1_70)
	assert(arg0_70.data[arg1_70], "activity should exist" .. arg1_70)

	arg0_70.data[arg1_70] = nil

	arg0_70:sendNotification(var0_0.ACTIVITY_DELETED, arg1_70)

	local var0_70 = table.getIndex(arg0_70.stopList, function(arg0_71)
		return arg0_71[2] == arg1_70
	end)

	if var0_70 then
		table.remove(arg0_70.stopList, var0_70)
	end
end

function var0_0.IsActivityNotEnd(arg0_72, arg1_72)
	return arg0_72.data[arg1_72] and not arg0_72.data[arg1_72]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_73, arg1_73)
	local var0_73 = false
	local var1_73 = arg0_73:getActivitiesByType(arg1_73)

	for iter0_73, iter1_73 in ipairs(var1_73) do
		if iter1_73:readyToAchieve() then
			var0_73 = true

			break
		end
	end

	return var0_73
end

function var0_0.getBuildActivityCfgByID(arg0_74, arg1_74)
	local var0_74 = arg0_74:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
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

function var0_0.getNoneActBuildActivityCfgByID(arg0_75, arg1_75)
	local var0_75 = arg0_75:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0_75, iter1_75 in ipairs(var0_75) do
		if not iter1_75:isEnd() then
			local var1_75 = iter1_75:getConfig("config_client")

			if var1_75 and var1_75.id == arg1_75 then
				return var1_75
			end
		end
	end

	return nil
end

function var0_0.getBuffShipList(arg0_76)
	local var0_76 = {}
	local var1_76 = arg0_76:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_76, function(arg0_77)
		if arg0_77 and not arg0_77:isEnd() then
			local var0_77 = arg0_77:getConfig("config_id")
			local var1_77 = pg.activity_expup_ship[var0_77]

			if not var1_77 then
				return
			end

			local var2_77 = var1_77.expup

			for iter0_77, iter1_77 in pairs(var2_77) do
				var0_76[iter1_77[1]] = iter1_77[2]
			end
		end
	end)

	return var0_76
end

function var0_0.getVirtualItemNumber(arg0_78, arg1_78)
	local var0_78 = arg0_78:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_78 and not var0_78:isEnd() then
		return var0_78.data1KeyValueList[1][arg1_78] and var0_78.data1KeyValueList[1][arg1_78] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_79, arg1_79, arg2_79)
	local var0_79 = arg0_79:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_79, "vbagType invalid")

	if var0_79 and not var0_79:isEnd() then
		var0_79.data1KeyValueList[1][arg1_79] = var0_79.data1KeyValueList[1][arg1_79] - arg2_79
	end

	arg0_79:updateActivity(var0_79)
end

function var0_0.addVitemById(arg0_80, arg1_80, arg2_80)
	local var0_80 = arg0_80:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) or arg0_80:getActivityByType(ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA)

	var0_80 = var0_80 or arg0_80:getActivityByType(ActivityConst.ACTIVITY_TYPE_CITY_REBUILD)

	assert(var0_80, "vbagType invalid")

	if var0_80 and not var0_80:isEnd() then
		if not var0_80.data1KeyValueList[1][arg1_80] then
			var0_80.data1KeyValueList[1][arg1_80] = 0
		end

		var0_80.data1KeyValueList[1][arg1_80] = var0_80.data1KeyValueList[1][arg1_80] + arg2_80
	end

	arg0_80:updateActivity(var0_80)

	local var1_80 = Item.getConfigData(arg1_80).link_id

	if var1_80 ~= 0 then
		local var2_80 = arg0_80:getActivityById(var1_80)

		if var2_80 and not var2_80:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_80, arg2_80)
		end
	end
end

function var0_0.monitorTaskList(arg0_81, arg1_81)
	if arg1_81 and not arg1_81:isEnd() and arg1_81:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_81 = arg1_81:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_81) then
			arg0_81:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_81.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_82, arg1_82, arg2_82)
	getProxy(FleetProxy):addActivityFleet(arg1_82, arg2_82.group_list)
end

function var0_0.InitActivityBossData(arg0_83, arg1_83)
	local var0_83 = pg.activity_event_worldboss[arg1_83:getConfig("config_id")]

	if not var0_83 then
		return
	end

	local var1_83 = arg1_83.data1KeyValueList

	for iter0_83, iter1_83 in pairs(var0_83.normal_expedition_drop_num or {}) do
		for iter2_83, iter3_83 in pairs(iter1_83[1]) do
			local var2_83 = iter1_83[2]
			local var3_83 = var1_83[1][iter3_83] or 0

			var1_83[1][iter3_83] = math.max(var2_83 - var3_83, 0)
			var1_83[2][iter3_83] = var1_83[2][iter3_83] or 0
		end
	end
end

function var0_0.RegisterRequestTime(arg0_84, arg1_84, arg2_84)
	if not arg1_84 or arg1_84 <= 0 then
		return
	end

	arg0_84.requestTime[arg1_84] = arg2_84
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
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function(arg0_92)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_93)
			return arg0_93:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function(arg0_94)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function(arg0_95)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function(arg0_96)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function(arg0_97)
			return true
		end
	}
	local var1_91 = {}

	for iter0_91, iter1_91 in pairs(arg0_91.data) do
		if switch(iter1_91:getConfig("type"), var0_91, function(arg0_98)
			return false
		end, iter1_91) and not iter1_91:isEnd() and tobool(iter1_91:getConfig("config_client").entrance_bg) then
			table.insert(var1_91, iter1_91)
		end
	end

	table.sort(var1_91, CompareFuncs({
		function(arg0_99)
			return arg0_99:getConfig("config_client").order or 1
		end,
		function(arg0_100)
			return -arg0_100.id
		end
	}))

	return var1_91
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_101)
	local var0_101 = arg0_101:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_101 or var0_101:isEnd() then
		return false
	end

	local var1_101 = var0_101:GetSlots()

	for iter0_101, iter1_101 in pairs(var1_101) do
		if iter1_101[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_102, arg1_102, arg2_102)
	local var0_102 = arg0_102:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_102 or var0_102:isEnd() then
		return false
	end

	local var1_102 = var0_102:GetItems()[arg1_102]

	return var1_102 and arg2_102 <= var1_102.count
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
			record = 0,
			diff = 1
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

function var0_0.IsTipLoveLetterMail(arg0_118)
	local var0_118 = arg0_118:getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_MAIL)

	return var0_118 and not var0_118:isEnd() and var0_118:readyToAchieve()
end

return var0_0
