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
		local var0_6 = arg0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)
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

function var0_0.getCorePanelActivity(arg0_45, arg1_45)
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

function var0_0.checkHxActivity(arg0_48, arg1_48)
	if arg0_48.hxList and #arg0_48.hxList > 0 then
		for iter0_48 = 1, #arg0_48.hxList do
			if arg0_48.hxList[iter0_48] == arg1_48 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_49)
	return _(pg.activity_banner.all):chain():map(function(arg0_50)
		return pg.activity_banner[arg0_50]
	end):filter(function(arg0_51)
		return pg.TimeMgr.GetInstance():inTime(arg0_51.time) and arg0_51.type ~= GAMEUI_BANNER_9 and arg0_51.type ~= GAMEUI_BANNER_11 and arg0_51.type ~= GAMEUI_BANNER_10 and arg0_51.type ~= GAMEUI_BANNER_12 and arg0_51.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_52, arg1_52)
	local var0_52 = pg.activity_banner.get_id_list_by_type[arg1_52]

	if not var0_52 then
		return nil
	end

	for iter0_52, iter1_52 in ipairs(var0_52) do
		local var1_52 = pg.activity_banner[iter1_52]

		if pg.TimeMgr.GetInstance():inTime(var1_52.time) then
			return var1_52
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_53)
	return _.map(pg.activity_banner_notice.all, function(arg0_54)
		return pg.activity_banner_notice[arg0_54]
	end)
end

function var0_0.findNextAutoActivity(arg0_55, arg1_55)
	local var0_55
	local var1_55 = pg.TimeMgr.GetInstance()
	local var2_55 = var1_55:GetServerTime()
	local var3_55 = arg1_55 and arg1_55 ~= "" and arg0_55:getCorePanelActivity(arg1_55) or arg0_55:getPanelActivities()

	for iter0_55, iter1_55 in ipairs(var3_55) do
		if not iter1_55.autoActionForbidden then
			local var4_55 = iter1_55:getConfig("type")

			if var4_55 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var5_55 = iter1_55:getConfig("config_client")

				if var5_55 and var5_55.manulSign == true then
					-- block empty
				else
					local var6_55 = iter1_55:getConfig("config_id")
					local var7_55 = pg.activity_7_day_sign[var6_55].front_drops

					if iter1_55.data1 < #var7_55 and not var1_55:IsSameDay(var2_55, iter1_55.data2) and var2_55 > iter1_55.data2 then
						var0_55 = iter1_55

						break
					end
				end
			elseif var4_55 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var8_55 = getProxy(ChapterProxy)

				if iter1_55.data1 < 7 and not var1_55:IsSameDay(var2_55, iter1_55.data2) or iter1_55.data1 == 7 and not iter1_55.achieved and var8_55:isClear(204) then
					var0_55 = iter1_55

					break
				end
			elseif var4_55 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var9_55 = pg.TimeMgr.GetInstance():STimeDescS(var2_55, "*t")

				iter1_55:setSpecialData("reMonthSignDay", nil)

				if var9_55.year ~= iter1_55.data1 or var9_55.month ~= iter1_55.data2 then
					iter1_55.data1 = var9_55.year
					iter1_55.data2 = var9_55.month
					iter1_55.data1_list = {}
					var0_55 = iter1_55

					break
				elseif not table.contains(iter1_55.data1_list, var9_55.day) then
					var0_55 = iter1_55

					break
				elseif var9_55.day > #iter1_55.data1_list and pg.activity_month_sign[iter1_55.data2].resign_count > iter1_55.data3 then
					for iter2_55 = var9_55.day, 1, -1 do
						if not table.contains(iter1_55.data1_list, iter2_55) then
							iter1_55:setSpecialData("reMonthSignDay", iter2_55)

							break
						end
					end

					var0_55 = iter1_55
				end
			elseif iter1_55.id == ActivityConst.SHADOW_PLAY_ID and iter1_55.clientData1 == 0 then
				local var10_55 = iter1_55:getConfig("config_data")[1]
				local var11_55 = getProxy(TaskProxy)
				local var12_55 = var11_55:getTaskById(var10_55) or var11_55:getFinishTaskById(var10_55)

				if var12_55 and not var12_55:isReceive() then
					var0_55 = iter1_55

					break
				end
			end
		end
	end

	if not var0_55 then
		for iter3_55, iter4_55 in pairs(arg0_55.data) do
			if not iter4_55:isShow() and iter4_55:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var13_55 = iter4_55:getConfig("config_id")
				local var14_55 = pg.activity_7_day_sign[var13_55].front_drops

				if iter4_55.data1 < #var14_55 and not var1_55:IsSameDay(var2_55, iter4_55.data2) and var2_55 > iter4_55.data2 then
					var0_55 = iter4_55

					break
				end
			end
		end
	end

	return var0_55
end

function var0_0.findRefluxAutoActivity(arg0_56)
	local var0_56 = arg0_56:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_56 and not var0_56:isEnd() and not var0_56.autoActionForbidden then
		local var1_56 = pg.TimeMgr.GetInstance()

		if var0_56.data1_list[2] < #pg.return_sign_template.all and not var1_56:IsSameDay(var1_56:GetServerTime(), var0_56.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_57)
	local var0_57 = arg0_57:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_57 and not var0_57:isEnd() then
		local var1_57 = pg.return_pt_template

		for iter0_57 = #var1_57.all, 1, -1 do
			local var2_57 = var1_57.all[iter0_57]
			local var3_57 = var1_57[var2_57]

			if var0_57.data3 >= var3_57.pt_require and var2_57 > var0_57.data4 then
				return true
			end
		end

		local var4_57 = getProxy(TaskProxy)
		local var5_57 = _(var0_57:getConfig("config_data")[7]):chain():map(function(arg0_58)
			return arg0_58[2]
		end):flatten():map(function(arg0_59)
			return var4_57:getTaskById(arg0_59) or var4_57:getFinishTaskById(arg0_59) or false
		end):filter(function(arg0_60)
			return not not arg0_60
		end):value()

		if _.any(var5_57, function(arg0_61)
			return arg0_61:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_62, arg1_62)
	return Clone(arg0_62.data[arg1_62])
end

function var0_0.RawGetActivityById(arg0_63, arg1_63)
	return arg0_63.data[arg1_63]
end

function var0_0.updateActivity(arg0_64, arg1_64)
	assert(arg0_64.data[arg1_64.id], "activity should exist" .. arg1_64.id)
	assert(isa(arg1_64, Activity), "activity should instance of Activity")

	if arg1_64:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_64 = pg.battlepass_event_pt[arg1_64.id].target

		if arg0_64.data[arg1_64.id].data1 < var0_64[#var0_64] and arg1_64.data1 - arg0_64.data[arg1_64.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_64.id].pt,
				ptCount = arg1_64.data1 - arg0_64.data[arg1_64.id].data1
			})
		end
	end

	arg0_64.data[arg1_64.id] = arg1_64

	arg0_64:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_64:clone())
	arg0_64:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_64.id
	})
	BuffHelper.GenBuffsForActivity(arg1_64)
end

function var0_0.addActivity(arg0_65, arg1_65)
	assert(arg0_65.data[arg1_65.id] == nil, "activity already exist" .. arg1_65.id)
	assert(isa(arg1_65, Activity), "activity should instance of Activity")

	arg0_65.data[arg1_65.id] = arg1_65

	arg0_65:sendNotification(var0_0.ACTIVITY_ADDED, arg1_65:clone())

	if arg1_65.stopTime > 0 then
		table.insert(arg0_65.stopList, {
			arg1_65.stopTime,
			arg1_65.id
		})
		table.sort(arg0_65.stopList, CompareFuncs({
			function(arg0_66)
				return arg0_66[1]
			end
		}))
	end
end

function var0_0.deleteActivityById(arg0_67, arg1_67)
	assert(arg0_67.data[arg1_67], "activity should exist" .. arg1_67)

	arg0_67.data[arg1_67] = nil

	arg0_67:sendNotification(var0_0.ACTIVITY_DELETED, arg1_67)

	local var0_67 = table.getIndex(arg0_67.stopList, function(arg0_68)
		return arg0_68[2] == arg1_67
	end)

	if var0_67 then
		table.remove(arg0_67.stopList, var0_67)
	end
end

function var0_0.IsActivityNotEnd(arg0_69, arg1_69)
	return arg0_69.data[arg1_69] and not arg0_69.data[arg1_69]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_70, arg1_70)
	local var0_70 = false
	local var1_70 = arg0_70:getActivitiesByType(arg1_70)

	for iter0_70, iter1_70 in ipairs(var1_70) do
		if iter1_70:readyToAchieve() then
			var0_70 = true

			break
		end
	end

	return var0_70
end

function var0_0.getBuildActivityCfgByID(arg0_71, arg1_71)
	local var0_71 = arg0_71:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
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

function var0_0.getNoneActBuildActivityCfgByID(arg0_72, arg1_72)
	local var0_72 = arg0_72:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
	})

	for iter0_72, iter1_72 in ipairs(var0_72) do
		if not iter1_72:isEnd() then
			local var1_72 = iter1_72:getConfig("config_client")

			if var1_72 and var1_72.id == arg1_72 then
				return var1_72
			end
		end
	end

	return nil
end

function var0_0.getBuffShipList(arg0_73)
	local var0_73 = {}
	local var1_73 = arg0_73:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_73, function(arg0_74)
		if arg0_74 and not arg0_74:isEnd() then
			local var0_74 = arg0_74:getConfig("config_id")
			local var1_74 = pg.activity_expup_ship[var0_74]

			if not var1_74 then
				return
			end

			local var2_74 = var1_74.expup

			for iter0_74, iter1_74 in pairs(var2_74) do
				var0_73[iter1_74[1]] = iter1_74[2]
			end
		end
	end)

	return var0_73
end

function var0_0.getVirtualItemNumber(arg0_75, arg1_75)
	local var0_75 = arg0_75:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_75 and not var0_75:isEnd() then
		return var0_75.data1KeyValueList[1][arg1_75] and var0_75.data1KeyValueList[1][arg1_75] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_76, arg1_76, arg2_76)
	local var0_76 = arg0_76:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_76, "vbagType invalid")

	if var0_76 and not var0_76:isEnd() then
		var0_76.data1KeyValueList[1][arg1_76] = var0_76.data1KeyValueList[1][arg1_76] - arg2_76
	end

	arg0_76:updateActivity(var0_76)
end

function var0_0.addVitemById(arg0_77, arg1_77, arg2_77)
	local var0_77 = arg0_77:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) or arg0_77:getActivityByType(ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA)

	var0_77 = var0_77 or arg0_77:getActivityByType(ActivityConst.ACTIVITY_TYPE_CITY_REBUILD)

	assert(var0_77, "vbagType invalid")

	if var0_77 and not var0_77:isEnd() then
		if not var0_77.data1KeyValueList[1][arg1_77] then
			var0_77.data1KeyValueList[1][arg1_77] = 0
		end

		var0_77.data1KeyValueList[1][arg1_77] = var0_77.data1KeyValueList[1][arg1_77] + arg2_77
	end

	arg0_77:updateActivity(var0_77)

	local var1_77 = Item.getConfigData(arg1_77).link_id

	if var1_77 ~= 0 then
		local var2_77 = arg0_77:getActivityById(var1_77)

		if var2_77 and not var2_77:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_77, arg2_77)
		end
	end
end

function var0_0.monitorTaskList(arg0_78, arg1_78)
	if arg1_78 and not arg1_78:isEnd() and arg1_78:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_78 = arg1_78:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_78) then
			arg0_78:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_78.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_79, arg1_79, arg2_79)
	getProxy(FleetProxy):addActivityFleet(arg1_79, arg2_79.group_list)
end

function var0_0.InitActivityBossData(arg0_80, arg1_80)
	local var0_80 = pg.activity_event_worldboss[arg1_80:getConfig("config_id")]

	if not var0_80 then
		return
	end

	local var1_80 = arg1_80.data1KeyValueList

	for iter0_80, iter1_80 in pairs(var0_80.normal_expedition_drop_num or {}) do
		for iter2_80, iter3_80 in pairs(iter1_80[1]) do
			local var2_80 = iter1_80[2]
			local var3_80 = var1_80[1][iter3_80] or 0

			var1_80[1][iter3_80] = math.max(var2_80 - var3_80, 0)
			var1_80[2][iter3_80] = var1_80[2][iter3_80] or 0
		end
	end
end

function var0_0.RegisterRequestTime(arg0_81, arg1_81, arg2_81)
	if not arg1_81 or arg1_81 <= 0 then
		return
	end

	arg0_81.requestTime[arg1_81] = arg2_81
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
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function(arg0_89)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_90)
			return arg0_90:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function(arg0_91)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function(arg0_92)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function(arg0_93)
			return true
		end
	}
	local var1_88 = {}

	for iter0_88, iter1_88 in pairs(arg0_88.data) do
		if switch(iter1_88:getConfig("type"), var0_88, function(arg0_94)
			return false
		end) and not iter1_88:isEnd() and tobool(iter1_88:getConfig("config_client").entrance_bg) then
			table.insert(var1_88, iter1_88)
		end
	end

	table.sort(var1_88, CompareFuncs({
		function(arg0_95)
			return arg0_95:getConfig("config_client").order or 1
		end,
		function(arg0_96)
			return -arg0_96.id
		end
	}))

	return var1_88
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_97)
	local var0_97 = arg0_97:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_97 or var0_97:isEnd() then
		return false
	end

	local var1_97 = var0_97:GetSlots()

	for iter0_97, iter1_97 in pairs(var1_97) do
		if iter1_97[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_98, arg1_98, arg2_98)
	local var0_98 = arg0_98:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_98 or var0_98:isEnd() then
		return false
	end

	local var1_98 = var0_98:GetItems()[arg1_98]

	return var1_98 and arg2_98 <= var1_98.count
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
