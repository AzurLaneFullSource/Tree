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
	local var0_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.data) do
		if iter1_48:isIslandShow() then
			table.insert(var0_48, iter1_48)
		end
	end

	return var0_48
end

function var0_0.checkHxActivity(arg0_49, arg1_49)
	if arg0_49.hxList and #arg0_49.hxList > 0 then
		for iter0_49 = 1, #arg0_49.hxList do
			if arg0_49.hxList[iter0_49] == arg1_49 then
				return true
			end
		end
	end

	return false
end

function var0_0.getBannerDisplays(arg0_50)
	return _(pg.activity_banner.all):chain():map(function(arg0_51)
		return pg.activity_banner[arg0_51]
	end):filter(function(arg0_52)
		return pg.TimeMgr.GetInstance():inTime(arg0_52.time) and arg0_52.type ~= GAMEUI_BANNER_9 and arg0_52.type ~= GAMEUI_BANNER_11 and arg0_52.type ~= GAMEUI_BANNER_10 and arg0_52.type ~= GAMEUI_BANNER_12 and arg0_52.type ~= GAMEUI_BANNER_13
	end):value()
end

function var0_0.getActiveBannerByType(arg0_53, arg1_53)
	local var0_53 = pg.activity_banner.get_id_list_by_type[arg1_53]

	if not var0_53 then
		return nil
	end

	for iter0_53, iter1_53 in ipairs(var0_53) do
		local var1_53 = pg.activity_banner[iter1_53]

		if pg.TimeMgr.GetInstance():inTime(var1_53.time) then
			return var1_53
		end
	end

	return nil
end

function var0_0.getNoticeBannerDisplays(arg0_54)
	return _.map(pg.activity_banner_notice.all, function(arg0_55)
		return pg.activity_banner_notice[arg0_55]
	end)
end

function var0_0.findNextAutoActivity(arg0_56, arg1_56)
	local var0_56
	local var1_56 = pg.TimeMgr.GetInstance()
	local var2_56 = var1_56:GetServerTime()
	local var3_56 = arg1_56 and arg1_56 ~= "" and arg0_56:getCorePanelActivities(arg1_56) or arg0_56:getPanelActivities()

	for iter0_56, iter1_56 in ipairs(var3_56) do
		if not iter1_56.autoActionForbidden then
			local var4_56 = iter1_56:getConfig("type")

			if var4_56 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var5_56 = iter1_56:getConfig("config_client")

				if var5_56 and var5_56.manulSign == true then
					-- block empty
				else
					local var6_56 = iter1_56:getConfig("config_id")
					local var7_56 = pg.activity_7_day_sign[var6_56].front_drops

					if iter1_56.data1 < #var7_56 and not var1_56:IsSameDay(var2_56, iter1_56.data2) and var2_56 > iter1_56.data2 then
						var0_56 = iter1_56

						break
					end
				end
			elseif var4_56 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				local var8_56 = getProxy(ChapterProxy)

				if iter1_56.data1 < 7 and not var1_56:IsSameDay(var2_56, iter1_56.data2) or iter1_56.data1 == 7 and not iter1_56.achieved and var8_56:isClear(204) then
					var0_56 = iter1_56

					break
				end
			elseif var4_56 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				local var9_56 = pg.TimeMgr.GetInstance():STimeDescS(var2_56, "*t")

				iter1_56:setSpecialData("reMonthSignDay", nil)

				if var9_56.year ~= iter1_56.data1 or var9_56.month ~= iter1_56.data2 then
					iter1_56.data1 = var9_56.year
					iter1_56.data2 = var9_56.month
					iter1_56.data1_list = {}
					var0_56 = iter1_56

					break
				elseif not table.contains(iter1_56.data1_list, var9_56.day) then
					var0_56 = iter1_56

					break
				elseif var9_56.day > #iter1_56.data1_list and pg.activity_month_sign[iter1_56.data2].resign_count > iter1_56.data3 then
					for iter2_56 = var9_56.day, 1, -1 do
						if not table.contains(iter1_56.data1_list, iter2_56) then
							iter1_56:setSpecialData("reMonthSignDay", iter2_56)

							break
						end
					end

					var0_56 = iter1_56
				end
			elseif iter1_56.id == ActivityConst.SHADOW_PLAY_ID and iter1_56.clientData1 == 0 then
				local var10_56 = iter1_56:getConfig("config_data")[1]
				local var11_56 = getProxy(TaskProxy)
				local var12_56 = var11_56:getTaskById(var10_56) or var11_56:getFinishTaskById(var10_56)

				if var12_56 and not var12_56:isReceive() then
					var0_56 = iter1_56

					break
				end
			end
		end
	end

	if not var0_56 then
		for iter3_56, iter4_56 in pairs(arg0_56.data) do
			if not iter4_56:isShow() and iter4_56:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				local var13_56 = iter4_56:getConfig("config_id")
				local var14_56 = pg.activity_7_day_sign[var13_56].front_drops

				if iter4_56.data1 < #var14_56 and not var1_56:IsSameDay(var2_56, iter4_56.data2) and var2_56 > iter4_56.data2 then
					var0_56 = iter4_56

					break
				end
			end
		end
	end

	return var0_56
end

function var0_0.findRefluxAutoActivity(arg0_57)
	local var0_57 = arg0_57:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_57 and not var0_57:isEnd() and not var0_57.autoActionForbidden then
		local var1_57 = pg.TimeMgr.GetInstance()

		if var0_57.data1_list[2] < #pg.return_sign_template.all and not var1_57:IsSameDay(var1_57:GetServerTime(), var0_57.data1_list[1]) then
			return 1
		end
	end
end

function var0_0.existRefluxAwards(arg0_58)
	local var0_58 = arg0_58:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var0_58 and not var0_58:isEnd() then
		local var1_58 = pg.return_pt_template

		for iter0_58 = #var1_58.all, 1, -1 do
			local var2_58 = var1_58.all[iter0_58]
			local var3_58 = var1_58[var2_58]

			if var0_58.data3 >= var3_58.pt_require and var2_58 > var0_58.data4 then
				return true
			end
		end

		local var4_58 = getProxy(TaskProxy)
		local var5_58 = _(var0_58:getConfig("config_data")[7]):chain():map(function(arg0_59)
			return arg0_59[2]
		end):flatten():map(function(arg0_60)
			return var4_58:getTaskById(arg0_60) or var4_58:getFinishTaskById(arg0_60) or false
		end):filter(function(arg0_61)
			return not not arg0_61
		end):value()

		if _.any(var5_58, function(arg0_62)
			return arg0_62:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

function var0_0.getActivityById(arg0_63, arg1_63)
	return Clone(arg0_63.data[arg1_63])
end

function var0_0.RawGetActivityById(arg0_64, arg1_64)
	return arg0_64.data[arg1_64]
end

function var0_0.updateActivity(arg0_65, arg1_65)
	assert(arg0_65.data[arg1_65.id], "activity should exist" .. arg1_65.id)
	assert(isa(arg1_65, Activity), "activity should instance of Activity")

	if arg1_65:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		local var0_65 = pg.battlepass_event_pt[arg1_65.id].target

		if arg0_65.data[arg1_65.id].data1 < var0_65[#var0_65] and arg1_65.data1 - arg0_65.data[arg1_65.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.battlepass_event_pt[arg1_65.id].pt,
				ptCount = arg1_65.data1 - arg0_65.data[arg1_65.id].data1
			})
		end
	elseif arg1_65:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_HEI5 then
		local var1_65 = pg.black_friday_battlepass_event_pt[arg1_65.id].target

		if arg0_65.data[arg1_65.id].data1 < var1_65[#var1_65] and arg1_65.data1 - arg0_65.data[arg1_65.id].data1 > 0 then
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_CRUSING, {
				ptId = pg.black_friday_battlepass_event_pt[arg1_65.id].pt,
				ptCount = arg1_65.data1 - arg0_65.data[arg1_65.id].data1
			})
		end
	end

	arg0_65.data[arg1_65.id] = arg1_65

	arg0_65:sendNotification(var0_0.ACTIVITY_UPDATED, arg1_65:clone())
	arg0_65:sendNotification(GAME.SYN_GRAFTING_ACTIVITY, {
		id = arg1_65.id
	})
	BuffHelper.GenBuffsForActivity(arg1_65)
end

function var0_0.addActivity(arg0_66, arg1_66)
	assert(arg0_66.data[arg1_66.id] == nil, "activity already exist" .. arg1_66.id)
	assert(isa(arg1_66, Activity), "activity should instance of Activity")

	arg0_66.data[arg1_66.id] = arg1_66

	arg0_66:sendNotification(var0_0.ACTIVITY_ADDED, arg1_66:clone())

	if arg1_66.stopTime > 0 then
		table.insert(arg0_66.stopList, {
			arg1_66.stopTime,
			arg1_66.id
		})
		table.sort(arg0_66.stopList, CompareFuncs({
			function(arg0_67)
				return arg0_67[1]
			end
		}))
	end
end

function var0_0.deleteActivityById(arg0_68, arg1_68)
	assert(arg0_68.data[arg1_68], "activity should exist" .. arg1_68)

	arg0_68.data[arg1_68] = nil

	arg0_68:sendNotification(var0_0.ACTIVITY_DELETED, arg1_68)

	local var0_68 = table.getIndex(arg0_68.stopList, function(arg0_69)
		return arg0_69[2] == arg1_68
	end)

	if var0_68 then
		table.remove(arg0_68.stopList, var0_68)
	end
end

function var0_0.IsActivityNotEnd(arg0_70, arg1_70)
	return arg0_70.data[arg1_70] and not arg0_70.data[arg1_70]:isEnd()
end

function var0_0.readyToAchieveByType(arg0_71, arg1_71)
	local var0_71 = false
	local var1_71 = arg0_71:getActivitiesByType(arg1_71)

	for iter0_71, iter1_71 in ipairs(var1_71) do
		if iter1_71:readyToAchieve() then
			var0_71 = true

			break
		end
	end

	return var0_71
end

function var0_0.getBuildActivityCfgByID(arg0_72, arg1_72)
	local var0_72 = arg0_72:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
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

function var0_0.getNoneActBuildActivityCfgByID(arg0_73, arg1_73)
	local var0_73 = arg0_73:getActivitiesByTypes({
		ActivityConst.ACTIVITY_TYPE_BUILD
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

function var0_0.getBuffShipList(arg0_74)
	local var0_74 = {}
	local var1_74 = arg0_74:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF)

	_.each(var1_74, function(arg0_75)
		if arg0_75 and not arg0_75:isEnd() then
			local var0_75 = arg0_75:getConfig("config_id")
			local var1_75 = pg.activity_expup_ship[var0_75]

			if not var1_75 then
				return
			end

			local var2_75 = var1_75.expup

			for iter0_75, iter1_75 in pairs(var2_75) do
				var0_74[iter1_75[1]] = iter1_75[2]
			end
		end
	end)

	return var0_74
end

function var0_0.getVirtualItemNumber(arg0_76, arg1_76)
	local var0_76 = arg0_76:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if var0_76 and not var0_76:isEnd() then
		return var0_76.data1KeyValueList[1][arg1_76] and var0_76.data1KeyValueList[1][arg1_76] or 0
	end

	return 0
end

function var0_0.removeVitemById(arg0_77, arg1_77, arg2_77)
	local var0_77 = arg0_77:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	assert(var0_77, "vbagType invalid")

	if var0_77 and not var0_77:isEnd() then
		var0_77.data1KeyValueList[1][arg1_77] = var0_77.data1KeyValueList[1][arg1_77] - arg2_77
	end

	arg0_77:updateActivity(var0_77)
end

function var0_0.addVitemById(arg0_78, arg1_78, arg2_78)
	local var0_78 = arg0_78:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) or arg0_78:getActivityByType(ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA)

	var0_78 = var0_78 or arg0_78:getActivityByType(ActivityConst.ACTIVITY_TYPE_CITY_REBUILD)

	assert(var0_78, "vbagType invalid")

	if var0_78 and not var0_78:isEnd() then
		if not var0_78.data1KeyValueList[1][arg1_78] then
			var0_78.data1KeyValueList[1][arg1_78] = 0
		end

		var0_78.data1KeyValueList[1][arg1_78] = var0_78.data1KeyValueList[1][arg1_78] + arg2_78
	end

	arg0_78:updateActivity(var0_78)

	local var1_78 = Item.getConfigData(arg1_78).link_id

	if var1_78 ~= 0 then
		local var2_78 = arg0_78:getActivityById(var1_78)

		if var2_78 and not var2_78:isEnd() then
			PlayerResChangeCommand.UpdateActivity(var2_78, arg2_78)
		end
	end
end

function var0_0.monitorTaskList(arg0_79, arg1_79)
	if arg1_79 and not arg1_79:isEnd() and arg1_79:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR then
		local var0_79 = arg1_79:getConfig("config_data")[1] or {}

		if getProxy(TaskProxy):isReceiveTasks(var0_79) then
			arg0_79:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg1_79.id
			})
		end
	end
end

function var0_0.InitActtivityFleet(arg0_80, arg1_80, arg2_80)
	getProxy(FleetProxy):addActivityFleet(arg1_80, arg2_80.group_list)
end

function var0_0.InitActivityBossData(arg0_81, arg1_81)
	local var0_81 = pg.activity_event_worldboss[arg1_81:getConfig("config_id")]

	if not var0_81 then
		return
	end

	local var1_81 = arg1_81.data1KeyValueList

	for iter0_81, iter1_81 in pairs(var0_81.normal_expedition_drop_num or {}) do
		for iter2_81, iter3_81 in pairs(iter1_81[1]) do
			local var2_81 = iter1_81[2]
			local var3_81 = var1_81[1][iter3_81] or 0

			var1_81[1][iter3_81] = math.max(var2_81 - var3_81, 0)
			var1_81[2][iter3_81] = var1_81[2][iter3_81] or 0
		end
	end
end

function var0_0.RegisterRequestTime(arg0_82, arg1_82, arg2_82)
	if not arg1_82 or arg1_82 <= 0 then
		return
	end

	arg0_82.requestTime[arg1_82] = arg2_82
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
		[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function(arg0_90)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function(arg0_91)
			return arg0_91:checkBattleTimeInBossAct()
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function(arg0_92)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function(arg0_93)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function(arg0_94)
			return true
		end,
		[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function(arg0_95)
			return true
		end
	}
	local var1_89 = {}

	for iter0_89, iter1_89 in pairs(arg0_89.data) do
		if switch(iter1_89:getConfig("type"), var0_89, function(arg0_96)
			return false
		end) and not iter1_89:isEnd() and tobool(iter1_89:getConfig("config_client").entrance_bg) then
			table.insert(var1_89, iter1_89)
		end
	end

	table.sort(var1_89, CompareFuncs({
		function(arg0_97)
			return arg0_97:getConfig("config_client").order or 1
		end,
		function(arg0_98)
			return -arg0_98.id
		end
	}))

	return var1_89
end

function var0_0.AtelierActivityAllSlotIsEmpty(arg0_99)
	local var0_99 = arg0_99:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_99 or var0_99:isEnd() then
		return false
	end

	local var1_99 = var0_99:GetSlots()

	for iter0_99, iter1_99 in pairs(var1_99) do
		if iter1_99[1] ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.OwnAtelierActivityItemCnt(arg0_100, arg1_100, arg2_100)
	local var0_100 = arg0_100:getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	if not var0_100 or var0_100:isEnd() then
		return false
	end

	local var1_100 = var0_100:GetItems()[arg1_100]

	return var1_100 and arg2_100 <= var1_100.count
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
			record = 0,
			diff = 1
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
