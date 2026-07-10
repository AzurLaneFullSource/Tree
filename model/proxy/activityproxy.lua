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

				if var1_2 == ActivityConst.ACTIVITY_TYPE_PARAMETER then
					arg0_1:addActivityParameter(var0_2)
				elseif var1_2 == ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE then
					arg0_1:CheckDailyEventRequest(var0_2)
				else
					arg0_1:CheckCreateActivityFleet(var0_2, iter3_2)
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

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
		;(function()
			local var0_4 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not var0_4 then
				return
			end

			arg0_1:sendNotification(GAME.REQUEST_ATELIER, var0_4.id)
		end)()

		local var4_2 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

		if var4_2 and not var4_2:isEnd() then
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

		if not arg0_1.data[var0_5.id] or var1_5 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			arg0_1:CheckCreateActivityFleet(var0_5, arg0_5.activity_info)
		end

		if not arg0_1.data[var0_5.id] then
			arg0_1:addActivity(var0_5)
		else
			arg0_1:updateActivity(var0_5)
		end

		arg0_1:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
			activity = var0_5
		})
	end)
	arg0_1:on(40009, function(arg0_6)
		local var0_6 = arg0_1:GetBossActivityByChapterId(arg0_6.arg1) or arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB)
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

		local var0_8 = arg0_1:getActivityById(arg0_8.act_id)

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
						end,
						[ActivityConst.ACTIVITY_TYPE_TOWN2] = function()
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
				local var3_35 = arg0_13.data[var2_35]

				switch(var3_35:getConfig("type"), {
					[ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE] = function()
						getProxy(MilitaryExerciseProxy):setSeasonOver()
					end,
					[ActivityConst.ACTIVITY_TYPE_NPC_COLLECTION] = function()
						local var0_39 = getProxy(BayProxy):getShipById(var3_35.data2)

						if var0_39 and var0_39:isActivityNpc() then
							arg0_13:sendNotification(GAME.SEND_CMD, {
								cmd = "kick"
							})
						end
					end,
					[ActivityConst.ACTIVITY_TYPE_TASKS] = function()
						local var0_40 = getProxy(TaskProxy)

						for iter0_40, iter1_40 in ipairs(var3_35:getConfig("config_data")) do
							var0_40:deleteTaskById(iter1_40)
						end
					end
				})
				pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
				arg0_13:sendNotification(var0_0.ACTIVITY_END, var2_35)
			end
		end
	}
end

function var0_0.getAliveActivityByType(arg0_41, arg1_41)
	for iter0_41, iter1_41 in pairs(arg0_41.data) do
		if iter1_41:getConfig("type") == arg1_41 and not iter1_41:isEnd() then
			return iter1_41
		end
	end
end

function var0_0.getActivityByType(arg0_42, arg1_42)
	for iter0_42, iter1_42 in pairs(arg0_42.data) do
		if iter1_42:getConfig("type") == arg1_42 then
			return iter1_42
		end
	end
end

function var0_0.getActivitiesByType(arg0_43, arg1_43)
	local var0_43 = {}

	for iter0_43, iter1_43 in pairs(arg0_43.data) do
		if iter1_43:getConfig("type") == arg1_43 then
			table.insert(var0_43, iter1_43)
		end
	end

	return var0_43
end

function var0_0.getActivitiesByTypes(arg0_44, arg1_44)
	local var0_44 = {}

	for iter0_44, iter1_44 in pairs(arg0_44.data) do
		if table.contains(arg1_44, iter1_44:getConfig("type")) then
			table.insert(var0_44, iter1_44)
		end
	end

	return var0_44
end

function var0_0.getMilitaryExerciseActivity(arg0_45)
	local var0_45

	for iter0_45, iter1_45 in pairs(arg0_45.data) do
		if iter1_45:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			var0_45 = iter1_45

			break
		end
	end

	return Clone(var0_45)
end

function var0_0.getPanelActivities(arg0_46)
	local function var0_46(arg0_47)
		local var0_47 = arg0_47:getConfig("type")
		local var1_47 = arg0_47:isShow() and not arg0_47:isAfterShow() and arg0_47:isCorePage("")

		if var1_47 then
			if var0_47 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				var1_47 = arg0_47.data2 == 0
			elseif var0_47 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				var1_47 = arg0_47.data1 < 7 or not arg0_47.achieved
			elseif var0_47 == ActivityConst.ACTIVITY_TYPE_SURVEY then
				var1_47 = PLATFORM ~= PLATFORM_OPENHARMONY
			end
		end

		return var1_47 and not arg0_47:isEnd()
	end

	local var1_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.data) do
		if var0_46(iter1_46) then
			table.insert(var1_46, iter1_46)
		end
	end

	table.sort(var1_46, CompareFuncs({
		function(arg0_48)
			return -arg0_48:getConfig("login_pop")
		end,
		function(arg0_49)
			return arg0_49.id
		end
	}))

	return var1_46
end

function var0_0.getCorePanelActivities(arg0_50, arg1_50)
	local var0_50 = {}

	for iter0_50, iter1_50 in pairs(arg0_50.data) do
		if iter1_50:isShow() and iter1_50:isCorePage(arg1_50) then
			table.insert(var0_50, iter1_50)
		end
	end

	table.sort(var0_50, CompareFuncs({
		function(arg0_51)
			return -arg0_51:getConfig("login_pop")
		end,
		function(arg0_52)
			return arg0_52.id
		end
	}))

	return var0_50
end

function var0_0.getIslandPanelActivities(arg0_53)
	local function var0_53(arg0_54)
		local var0_54 = arg0_54:getConfig("type")
		local var1_54 = arg0_54:isIslandShow()

		if var1_54 and var0_54 == ActivityConst.ACTIVITY_TYPE_SURVEY then
			local var2_54 = arg0_53:isSurveyOpen()
			local var3_54 = arg0_53:isSurveyDone()

			var1_54 = var2_54 and not var3_54

			if PLATFORM == PLATFORM_OPENHARMONY then
				var1_54 = false
			end
		end

		return var1_54 and not arg0_54:isEnd()
	end

	local var1_53 = {}

	for iter0_53, iter1_53 in pairs(arg0_53.data) do
		if var0_53(iter1_53) then
			table.insert(var1_53, iter1_53)
		end
	end

	return var1_53
end

function var0_0.checkHxActivity(arg0_55, arg1_55)
	if arg0_55.hxList and #arg0_55.hxList > 0 then
		for iter0_55 = 1, #arg0_55.hxList do
			if arg0_55.hxList[iter0_55] == arg1_55 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_56)
	return _(pg.activity_banner.all):chain():map(function(arg0_57)
		return pg.activity_banner[arg0_57]
	end):filter(function(arg0_58)
		return pg.TimeMgr.GetInstance():inTime(arg0_58.time) and arg0_58.type ~= GAMEUI_BANNER_9 and arg0_58.type ~= GAMEUI_BANNER_11 and arg0_58.type ~= GAMEUI_BANNER_10 and arg0_58.type ~= GAMEUI_BANNER_12 and arg0_58.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_59, arg1_59)
	local var0_59 = pg.activity_banner.get_id_list_by_type[arg1_59]

	if not var0_59 then
		return nil
	end

	for iter0_59, iter1_59 in ipairs(var0_59) do
		local var1_59 = pg.activity_banner[iter1_59]

		if pg.TimeMgr.GetInstance():inTime(var1_59.time) then
			return var1_59
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_60)
	return _.map(pg.activity_banner_notice.all, function(arg0_61)
		return pg.activity_banner_notice[arg0_61]
	end)
end

function var0_0.findNextAutoActivity(arg0_62, arg1_62)
	local var0_62
	local var1_62 = pg.TimeMgr.GetInstance()
	local var2_62 = var1_62:GetServerTime()
	local var3_62 = arg1_62 and arg1_62 ~= "" and arg0_62:getCorePanelActivities(arg1_62) or arg0_62:getPanelActivities()

	for iter0_62, iter1_62 in ipairs(var3_62) do
		if not iter1_62.autoActionForbidden then
			local var4_62 = iter1_62:getConfig("type")

			if var4_62 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var5_62 = iter1_62:getConfig("config_client")

				if var5_62 and var5_62.manulSign == true then
					-- block empty
				else
					local var6_62 = iter1_62:getConfig("config_id")
					local var7_62 = pg.activity_7_day_sign[var6_62].front_drops

					if iter1_62.data1 < #var7_62 and not var1_62:IsSameDay(var2_62, iter1_62.data2) and var2_62 > iter1_62.data2 then
						var0_62 = iter1_62

						break
					end
				end
			elseif var4_62 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var8_62 = getProxy(ChapterProxy)

				if iter1_62.data1 < 7 and not var1_62:IsSameDay(var2_62, iter1_62.data2) or iter1_62.data1 == 7 and not iter1_62.achieved and var8_62:isClear(204) then
					var0_62 = iter1_62

					break
				end
			elseif var4_62 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var9_62 = pg.TimeMgr.GetInstance():STimeDescS(var2_62, "*t")

				iter1_62:setSpecialData("reMonthSignDay", nil)

				if var9_62.year ~= iter1_62.data1 or var9_62.month ~= iter1_62.data2 then
					iter1_62.data1 = var9_62.year
					iter1_62.data2 = var9_62.month
					iter1_62.data1_list = {}
					var0_62 = iter1_62

					break
				elseif not table.contains(iter1_62.data1_list, var9_62.day) then
					var0_62 = iter1_62

					break
				elseif var9_62.day > #iter1_62.data1_list and pg.activity_month_sign[iter1_62.data2].resign_count > iter1_62.data3 then
					for iter2_62 = var9_62.day, 1, -1 do
						if not table.contains(iter1_62.data1_list, iter2_62) then
							iter1_62:setSpecialData("reMonthSignDay", iter2_62)

							break
						end
					end

					var0_62 = iter1_62
				end
			elseif iter1_62.id == ActivityConst.SHADOW_PLAY_ID and iter1_62.clientData1 == 0 then
				local var10_62 = iter1_62:getConfig("config_data")[1]
				local var11_62 = getProxy(TaskProxy)
				local var12_62 = var11_62:getTaskById(var10_62) or var11_62:getFinishTaskById(var10_62)

				if var12_62 and not var12_62:isReceive() then
					var0_62 = iter1_62

					break
				end
			end
		end
	end

	if not var0_62 then
		for iter3_62, iter4_62 in pairs(arg0_62.data) do
			if not iter4_62:isShow() and iter4_62:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var13_62 = iter4_62:getConfig("config_id")
				local var14_62 = pg.activity_7_day_sign[var13_62].front_drops

				if iter4_62.data1 < #var14_62 and not var1_62:IsSameDay(var2_62, iter4_62.data2) and var2_62 > iter4_62.data2 then
					var0_62 = iter4_62

					break
				end
			end
		end
	end

	return var0_62
end

function var0_0.findRefluxAutoActivity(arg0_63)
	local var0_63 = arg0_63:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_63 and not var0_63:isEnd() and not var0_63.autoActionForbidden then
		local var1_63 = pg.TimeMgr.GetInstance()

		if var0_63.data1_list[2] < #pg.return_sign_template.all and not var1_63:IsSameDay(var1_63:GetServerTime(), var0_63.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_64)
	local var0_64 = arg0_64:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_64 and not var0_64:isEnd() then
		local var1_64 = pg.return_pt_template

		for iter0_64 = #var1_64.all, 1, -1 do
			local var2_64 = var1_64.all[iter0_64]
			local var3_64 = var1_64[var2_64]

			if var0_64.data3 >= var3_64.pt_require and var2_64 > var0_64.data4 then
				return true
			end
		end

		local var4_64 = getProxy(TaskProxy)
		local var5_64 = _(var0_64:getConfig("config_data")[7]):chain():map(function(arg0_65)
			return arg0_65[2]
		end):flatten():map(function(arg0_66)
			return var4_64:getTaskById(arg0_66) or var4_64:getFinishTaskById(arg0_66) or false
		end):filter(function(arg0_67)
			return not not arg0_67
		end):value()

		if _.any(var5_64, function(arg0_68)
			return arg0_68:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_69, arg1_69)
	return Clone(arg0_69.data[arg1_69])
end

function var0_0.RawGetActivityById(arg0_70, arg1_70)
	return arg0_70.data[arg1_70]
end

function var0_0.updateActivity(arg0_71, arg1_71)
	assert(arg0_71.data[arg1_71.id], "activity should exist" .. arg1_71.id)
	assert(isa(arg1_71, Activity), "activity should instance of Activity")

	if arg1_71:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_71 = pg.battlepass_event_pt[arg1_71.id].target

		if arg0_71.data[arg1_71.id].data1 < var0_71[#var0_71] and arg1_71.data1 - arg0_71.data[arg1_71.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_71.id].pt,
				ptCount = arg1_71.data1 - arg0_71.data[arg1_71.id].data1
			})
		end
	elseif arg1_71:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_HEI5 then
		local var1_71 = pg.black_friday_battlepass_event_pt[arg1_71.id].target

		if arg0_71.data[arg1_71.id].data1 < var1_71[#var1_71] and arg1_71.data1 - arg0_71.data[arg1_71.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.black_friday_battlepass_event_pt[arg1_71.id].pt,
				ptCount = arg1_71.data1 - arg0_71.data[arg1_71.id].data1
			})
		end
	end

	arg0_71.data[arg1_71.id] = arg1_71

	arg0_71:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_71:clone())
	arg0_71:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_71.id
	})
	BuffHelper.GenBuffsForActivity(arg1_71)
end

function var0_0.addActivity(arg0_72, arg1_72)
	assert(arg0_72.data[arg1_72.id] == nil, "activity already exist" .. arg1_72.id)
	assert(isa(arg1_72, Activity), "activity should instance of Activity")

	arg0_72.data[arg1_72.id] = arg1_72

	arg0_72:sendNotification(var0_0.ACTIVITY_ADDED, arg1_72:clone())

	if arg1_72.stopTime > 0 then
		table.insert(arg0_72.stopList, {
			arg1_72.stopTime,
			arg1_72.id
		})
		table.sort(arg0_72.stopList, CompareFuncs({
			function(arg0_73)
				return arg0_73[1]
			end
		}))
	end
end

function var0_0.deleteActivityById(arg0_74, arg1_74)
	assert(arg0_74.data[arg1_74], "activity should exist" .. arg1_74)

	arg0_74.data[arg1_74] = nil

	arg0_74:sendNotification(var0_0.ACTIVITY_DELETED, arg1_74)

	local var0_74 = table.getIndex(arg0_74.stopList, function(arg0_75)
		return arg0_75[2] == arg1_74
	end)

	if var0_74 then
		table.remove(arg0_74.stopList, var0_74)
	end
end

function var0_0.IsActivityNotEnd(arg0_76, arg1_76)
	return arg0_76.data[arg1_76] and not arg0_76.data[arg1_76]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_77, arg1_77)
	local var0_77 = false
	local var1_77 = arg0_77:getActivitiesByType(arg1_77)

	for iter0_77, iter1_77 in ipairs(var1_77) do
		if iter1_77:readyToAchieve() then
			var0_77 = true

			break
		end
	end

	return var0_77
end

function var0_0.getBuildActivityCfgByID(arg0_78, arg1_78)
	local var0_78 = arg0_78:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	})

	for iter0_78, iter1_78 in ipairs(var0_78) do
		if not iter1_78:isEnd() then
			local var1_78 = iter1_78:getConfig("config_client")

			if var1_78 and var1_78.id == arg1_78 then
				return var1_78
			end
		end
	end

	return nil
end

function var0_0.getNoneActBuildActivityCfgByID(arg0_79, arg1_79)
	local var0_79 = arg0_79:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0_79, iter1_79 in ipairs(var0_79) do
		if not iter1_79:isEnd() then
			local var1_79 = iter1_79:getConfig("config_client")

			if var1_79 and var1_79.id == arg1_79 then
				return var1_79
			end
		end
	end

	return nil
end

function var0_0.getBuffShipList(arg0_80)
	local var0_80 = {}
	local var1_80 = arg0_80:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_80, function(arg0_81)
		if arg0_81 and not arg0_81:isEnd() then
			local var0_81 = arg0_81:getConfig("config_id")
			local var1_81 = pg.activity_expup_ship[var0_81]

			if not var1_81 then
				return
			end

			local var2_81 = var1_81.expup

			for iter0_81, iter1_81 in pairs(var2_81) do
				var0_80[iter1_81[1]] = iter1_81[2]
			end
		end
	end)

	return var0_80
end

function var0_0.getVirtualItemNumber(arg0_82, arg1_82)
	local var0_82 = arg0_82:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_82 and not var0_82:isEnd() then
		return var0_82.data1KeyValueList[1][arg1_82] and var0_82.data1KeyValueList[1][arg1_82] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_83, arg1_83, arg2_83)
	local var0_83 = arg0_83:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_83, "vbagType invalid")

	if var0_83 and not var0_83:isEnd() then
		var0_83.data1KeyValueList[1][arg1_83] = var0_83.data1KeyValueList[1][arg1_83] - arg2_83
	end

	arg0_83:updateActivity(var0_83)
end

function var0_0.addVitemById(arg0_84, arg1_84, arg2_84)
	local var0_84 = arg0_84:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) or arg0_84:getActivityByType(ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA)

	var0_84 = var0_84 or arg0_84:getActivityByType(ActivityConst.ACTIVITY_TYPE_CITY_REBUILD)

	assert(var0_84, "vbagType invalid")

	if var0_84 and not var0_84:isEnd() then
		if not var0_84.data1KeyValueList[1][arg1_84] then
			var0_84.data1KeyValueList[1][arg1_84] = 0
		end

		var0_84.data1KeyValueList[1][arg1_84] = var0_84.data1KeyValueList[1][arg1_84] + arg2_84
	end

	arg0_84:updateActivity(var0_84)

	local var1_84 = Item.getConfigData(arg1_84).link_id

	if var1_84 ~= 0 then
		local var2_84 = arg0_84:getActivityById(var1_84)

		if var2_84 and not var2_84:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_84, arg2_84)
		end
	end
end

function var0_0.monitorTaskList(arg0_85, arg1_85)
	if arg1_85 and not arg1_85:isEnd() and arg1_85:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_85 = arg1_85:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_85) then
			arg0_85:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_85.id
			})
		end
	end
end

function var0_0.CheckCreateActivityFleet(arg0_86, arg1_86, arg2_86)
	switch(arg1_86:getConfig("type"), {
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
			if arg1_86:checkBattleTimeInBossAct() then
				arg0_86:InitActtivityFleet(arg1_86, arg2_86)
			end

			arg0_86:InitActivityBossData(arg1_86)
		end,
		[ActivityConst.ACTIVITY_TYPE_CHALLENGE] = function()
			arg0_86:InitActtivityFleet(arg1_86, arg2_86)
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = ActivityConst.ACTIVITY_TYPE_CHALLENGE,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = ActivityConst.ACTIVITY_TYPE_CHALLENGE,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = ActivityConst.ACTIVITY_TYPE_CHALLENGE,
		[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = ActivityConst.ACTIVITY_TYPE_CHALLENGE
	})
end

function var0_0.InitActtivityFleet(arg0_89, arg1_89, arg2_89)
	getProxy(FleetProxy):addActivityFleet(arg1_89, arg2_89.group_list)
end

function var0_0.InitActivityBossData(arg0_90, arg1_90)
	local var0_90 = pg.activity_event_worldboss[arg1_90:getConfig("config_id")]

	if not var0_90 then
		return
	end

	local var1_90 = arg1_90.data1KeyValueList

	for iter0_90, iter1_90 in pairs(var0_90.normal_expedition_drop_num or {}) do
		for iter2_90, iter3_90 in pairs(iter1_90[1]) do
			local var2_90 = iter1_90[2]
			local var3_90 = var1_90[1][iter3_90] or 0

			var1_90[1][iter3_90] = math.max(var2_90 - var3_90, 0)
			var1_90[2][iter3_90] = var1_90[2][iter3_90] or 0
		end
	end
end

function var0_0.RegisterRequestTime(arg0_91, arg1_91, arg2_91)
	if not arg1_91 or arg1_91 <= 0 then
		return
	end

	arg0_91.requestTime[arg1_91] = arg2_91
end

function var0_0.addActivityParameter(arg0_92, arg1_92)
	local var0_92 = arg1_92:getConfig("config_data")
	local var1_92 = arg1_92.stopTime

	for iter0_92, iter1_92 in ipairs(var0_92) do
		arg0_92.params[iter1_92[1]] = {
			iter1_92[2],
			var1_92
		}
	end
end

function var0_0.getActivityParameter(arg0_93, arg1_93)
	if arg0_93.params[arg1_93] then
		local var0_93, var1_93 = unpack(arg0_93.params[arg1_93])

		if not (var1_93 > 0) or not (var1_93 <= pg.TimeMgr.GetInstance():GetServerTime()) then
			return var0_93
		end
	end
end

function var0_0.IsShowFreeBuildMark(arg0_94, arg1_94)
	for iter0_94, iter1_94 in ipairs(arg0_94:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter1_94 and not iter1_94:isEnd() and iter1_94.data1 > 0 and iter1_94.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200 and tobool(arg1_94) == (PlayerPrefs.GetString("Free_Build_Ticket_" .. iter1_94.id, "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")) then
			return iter1_94
		end
	end

	return false
end

function var0_0.getBuildFreeActivityByBuildId(arg0_95, arg1_95)
	for iter0_95, iter1_95 in ipairs(arg0_95:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if underscore.any(iter1_95:getConfig("config_data"), function(arg0_96)
			return arg0_96 == arg1_95
		end) then
			return iter1_95
		end
	end
end

function var0_0.getBuildPoolActivity(arg0_97, arg1_97)
	if arg1_97:IsActivity() then
		return arg0_97:getActivityById(arg1_97.activityId)
	end
end

function var0_0.getEnterReadyActivity(arg0_98)
	local var0_98 = {
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function(arg0_99)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_100)
			return arg0_100:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function(arg0_101)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function(arg0_102)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function(arg0_103)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function(arg0_104)
			return true
		end
	}
	local var1_98 = {}

	for iter0_98, iter1_98 in pairs(arg0_98.data) do
		if switch(iter1_98:getConfig("type"), var0_98, function(arg0_105)
			return false
		end, iter1_98) and not iter1_98:isEnd() and tobool(iter1_98:getConfig("config_client").entrance_bg) then
			table.insert(var1_98, iter1_98)
		end
	end

	table.sort(var1_98, CompareFuncs({
		function(arg0_106)
			return arg0_106:getConfig("config_client").order or 1
		end,
		function(arg0_107)
			return -arg0_107.id
		end
	}))

	return var1_98
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_108)
	local var0_108 = arg0_108:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_108 or var0_108:isEnd() then
		return false
	end

	local var1_108 = var0_108:GetSlots()

	for iter0_108, iter1_108 in pairs(var1_108) do
		if iter1_108[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_109, arg1_109, arg2_109)
	local var0_109 = arg0_109:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_109 or var0_109:isEnd() then
		return false
	end

	local var1_109 = var0_109:GetItems()[arg1_109]

	return var1_109 and arg2_109 <= var1_109.count
end

function var0_0.InitContinuousTime(arg0_110, arg1_110)
	arg0_110.continuousOpeartionTime = arg1_110
	arg0_110.continuousOpeartionTotalTime = arg1_110
end

function var0_0.UseContinuousTime(arg0_111)
	if not arg0_111.continuousOpeartionTime then
		return
	end

	arg0_111.continuousOpeartionTime = arg0_111.continuousOpeartionTime - 1
end

function var0_0.GetContinuousTime(arg0_112)
	return arg0_112.continuousOpeartionTime, arg0_112.continuousOpeartionTotalTime
end

function var0_0.AddBossRushAwards(arg0_113, arg1_113)
	arg0_113.bossrushAwards = arg0_113.bossrushAwards or {}

	table.insertto(arg0_113.bossrushAwards, arg1_113)
end

function var0_0.PopBossRushAwards(arg0_114)
	local var0_114 = arg0_114.bossrushAwards or {}

	arg0_114.bossrushAwards = nil

	return var0_114
end

function var0_0.GetBossRushRuntime(arg0_115, arg1_115)
	if not arg0_115.extraDatas[arg1_115] then
		arg0_115.extraDatas[arg1_115] = {
			record = 0,
			diff = 1
		}
	end

	return arg0_115.extraDatas[arg1_115]
end

function var0_0.GetActivityBossRuntime(arg0_116, arg1_116)
	if not arg0_116.extraDatas[arg1_116] then
		arg0_116.extraDatas[arg1_116] = {
			buffIds = {},
			spScore = {
				score = 0
			}
		}
	end

	return arg0_116.extraDatas[arg1_116]
end

function var0_0.GetTaskActivities(arg0_117)
	local var0_117 = {}

	table.Foreach(Activity.GetType2Class(), function(arg0_118, arg1_118)
		if not isa(arg1_118, ITaskActivity) then
			return
		end

		table.insertto(var0_117, arg0_117:getActivitiesByType(arg0_118))
	end)

	return var0_117
end

function var0_0.setSurveyState(arg0_119, arg1_119)
	local var0_119 = arg0_119:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_119 and not var0_119:isEnd() then
		arg0_119.surveyState = arg1_119

		if arg1_119 > 0 then
			arg0_119:sendNotification(GAME.SURVEY_DONE, var0_119)
		end
	end
end

function var0_0.isSurveyDone(arg0_120)
	local var0_120 = arg0_120:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_120 and not var0_120:isEnd() then
		return arg0_120.surveyState and arg0_120.surveyState > 0
	end
end

function var0_0.isSurveyOpen(arg0_121)
	local var0_121 = arg0_121:getActivityByType(ActivityConst.ACTIVITY_TYPE_SURVEY)

	if var0_121 and not var0_121:isEnd() then
		local var1_121 = var0_121:getConfig("config_data")
		local var2_121 = var1_121[1]
		local var3_121 = var1_121[2]

		if var2_121 == 1 then
			local var4_121 = var3_121 <= getProxy(PlayerProxy):getData().level
			local var5_121 = var0_121:getConfig("config_id")

			return var4_121, var5_121
		end
	end
end

function var0_0.GetActBossLinkPTActID(arg0_122, arg1_122)
	local var0_122 = table.Find(arg0_122.data, function(arg0_123, arg1_123)
		if arg1_123:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_PT_BUFF then
			return
		end

		return arg1_123:getDataConfig("link_id") == arg1_122
	end)

	return var0_122 and var0_122.id
end

function var0_0.CheckDailyEventRequest(arg0_124, arg1_124)
	if arg1_124:CheckDailyEventRequest() then
		arg0_124:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = arg1_124.id
		})
	end
end

function var0_0.IsTipLoveLetterMail(arg0_125)
	local var0_125 = arg0_125:getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_MAIL)

	return var0_125 and not var0_125:isEnd() and var0_125:readyToAchieve()
end

function var0_0.GetBossRushActivities(arg0_126, arg1_126)
	local var0_126 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

	return _.select(var0_126, function(arg0_127)
		local var0_127 = pg.activity_task_permanent[arg0_127.id] ~= nil

		if arg1_126 then
			return var0_127 and not arg0_127:isEnd()
		else
			return not var0_127 and not arg0_127:isEnd()
		end
	end)
end

function var0_0.GetBossRushActivitity(arg0_128, arg1_128)
	return arg0_128:GetBossRushActivities(arg1_128)[1]
end

function var0_0.GetBossRushActivityById(arg0_129, arg1_129)
	local var0_129 = arg0_129:getActivityById(arg1_129)

	if var0_129 and var0_129:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSSRUSH and not var0_129:isEnd() then
		return var0_129
	end

	return nil
end

function var0_0.GetBossActivityByChapterId(arg0_130, arg1_130)
	local var0_130 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

	for iter0_130, iter1_130 in ipairs(var0_130) do
		if not iter1_130:isEnd() then
			local var1_130 = iter1_130:getConfig("config_data")

			if table.contains(var1_130, arg1_130) then
				return iter1_130
			end
		end
	end

	return nil
end

function var0_0.GetFakeGiftPackActivity(arg0_131, arg1_131)
	arg0_131.skinCommodityActDic = arg0_131.skinCommodityActDic or {}

	if arg0_131.skinCommodityActDic[arg1_131.id] then
		local var0_131 = arg0_131.skinCommodityActDic[arg1_131.id]

		if not var0_131:isEnd() then
			return var0_131
		end

		arg0_131.skinCommodityActDic[arg1_131.id] = nil
	end

	for iter0_131, iter1_131 in ipairs(arg0_131:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE,
		ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE
	})) do
		if switch(iter1_131:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
				return not iter1_131:isEnd() and iter1_131.data1 < 1 and underscore.any(iter1_131:getConfig("config_data")[1], function(arg0_133)
					return pg.ship_skin_template[arg0_133].shop_id == arg1_131.id
				end)
			end,
			[ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE] = function()
				local var0_134 = pg.activity_giftpackage[iter1_131:getConfig("config_id")]

				return not iter1_131:isEnd() and iter1_131.data1 < var0_134.limit_count and underscore.any(var0_134.skin, function(arg0_135)
					return pg.ship_skin_template[arg0_135].shop_id == arg1_131.id
				end) and not underscore.all(var0_134.skin, function(arg0_136)
					return getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_136)
				end)
			end
		}, function()
			return
		end) then
			arg0_131.skinCommodityActDic[arg1_131.id] = iter1_131

			return iter1_131
		end
	end
end

return var0_0
