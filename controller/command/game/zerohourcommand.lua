local var0_0 = class("ZeroHourCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1, var1_1 = pcall(arg0_1.mainHandler, arg0_1)

	if not var0_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("zero_hour_command_error"))
		error(var1_1)
	end
end

function var0_0.mainHandler(arg0_2, arg1_2)
	local var0_2 = getProxy(PlayerProxy)
	local var1_2 = var0_2:getData()

	var1_2:resetBuyOilCount()

	for iter0_2, iter1_2 in pairs(var1_2.vipCards) do
		if iter1_2:isExpire() then
			var1_2.vipCards[iter1_2.id] = nil
		end
	end

	var0_2:updatePlayer(var1_2)

	local var2_2 = getProxy(ShopsProxy)
	local var3_2 = var2_2:getShopStreet()

	if var3_2 then
		var3_2:resetflashCount()
		var2_2:setShopStreet(var3_2)
	end

	var2_2.refreshChargeList = true

	getProxy(CollectionProxy):resetEvaCount()

	local var4_2 = getProxy(MilitaryExerciseProxy)
	local var5_2 = var4_2:getSeasonInfo()

	if var5_2 then
		var5_2:resetFlashCount()
		var4_2:updateSeasonInfo(var5_2)
	end

	getProxy(DailyLevelProxy):resetDailyCount()

	local var6_2 = getProxy(ChapterProxy)

	var6_2:resetRepairTimes()
	var6_2:resetEscortChallengeTimes()

	local var7_2 = var6_2:getData()

	for iter2_2, iter3_2 in pairs(var7_2) do
		if iter3_2.todayDefeatCount > 0 then
			iter3_2.todayDefeatCount = 0

			var6_2:updateChapter(iter3_2)
		end
	end

	var6_2:resetDailyCount()
	;(function()
		local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

		if not var0_3 then
			return
		end

		local var1_3 = var0_3:GetUsedBonus()

		table.Foreach(var1_3, function(arg0_4, arg1_4)
			var1_3[arg0_4] = 0
		end)
		getProxy(ActivityProxy):updateActivity(var0_3)
	end)()
	getProxy(DailyLevelProxy):clearChaptersDefeatCount()

	local var8_2 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")

	if var8_2.day == 1 then
		var2_2.shamShop:update(var8_2.month, {})
		var2_2:AddShamShop(var2_2.shamShop)
		var2_2.fragmentShop:Reset(var8_2.month)
		var2_2:AddFragmentShop(var2_2.fragmentShop)

		if not LOCK_UR_SHIP then
			local var9_2 = pg.gameset.urpt_chapter_max.description[1]

			getProxy(BagProxy):ClearLimitCnt(var9_2)
		end
	end

	local var10_2 = getProxy(ShopsProxy):getMiniShop()

	if var10_2 and var10_2:checkShopFlash() then
		pg.m02:sendNotification(GAME.MINI_GAME_SHOP_FLUSH)
	end

	local var11_2 = getProxy(ActivityProxy)

	for iter4_2, iter5_2 in ipairs(var11_2:getPanelActivities()) do
		if (function()
			local var0_5 = {
				ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN,
				ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN,
				ActivityConst.ACTIVITY_TYPE_MONTHSIGN,
				ActivityConst.ACTIVITY_TYPE_REFLUX,
				ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN,
				ActivityConst.ACTIVITY_TYPE_BB,
				ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD
			}

			iter5_2.autoActionForbidden = false

			if iter5_2:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BB then
				iter5_2.data2 = 0
			elseif iter5_2:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD then
				iter5_2.data2 = 0
			end

			return table.contains(var0_5, iter5_2:getConfig("type"))
		end)() then
			var11_2:updateActivity(iter5_2)
		end
	end

	getProxy(RefluxProxy):setAutoActionForbidden(false)

	local var12_2 = var11_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN)

	if var12_2 and not var12_2:isEnd() then
		pg.m02:sendNotification(GAME.ACT_MANUAL_SIGN, {
			activity_id = var12_2.id,
			cmd = ManualSignActivity.OP_SIGN
		})
	end

	local var13_2 = var11_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var13_2 and not var13_2:isEnd() then
		var13_2.data1KeyValueList = {
			{}
		}

		var11_2:updateActivity(var13_2)
	end

	local var14_2 = var11_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_TURNTABLE)

	if var14_2 and not var14_2:isEnd() then
		local var15_2 = var14_2:getConfig("config_id")
		local var16_2 = pg.activity_event_turning[var15_2]

		if var16_2.total_num <= var14_2.data3 then
			return
		end

		local var17_2 = var16_2.task_table[var14_2.data4]
		local var18_2 = getProxy(TaskProxy)

		for iter6_2, iter7_2 in ipairs(var17_2) do
			if (var18_2:getTaskById(iter7_2) or var18_2:getFinishTaskById(iter7_2)):getTaskStatus() ~= 2 then
				return
			end
		end

		arg0_2:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = var14_2.id
		})
	end

	local var19_2 = getProxy(NavalAcademyProxy)

	var19_2:setCourse(var19_2.course)
	arg0_2:sendNotification(GAME.CLASS_FORCE_UPDATE)
	getProxy(TechnologyProxy):updateRefreshFlag(0)
	arg0_2:sendNotification(GAME.ACCEPT_ACTIVITY_TASK)
	getProxy(CommanderProxy):resetBoxUseCnt()

	local var20_2 = getProxy(CommanderProxy):GetCommanderHome()

	if var20_2 then
		var20_2:ResetCatteryOP()
		var20_2:ReduceClean()
	end

	local var21_2 = var11_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

	if var21_2 and not var21_2:isEnd() then
		var11_2:updateActivity(var21_2)
	end

	local var22_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	if var22_2 and not var22_2:isEnd() then
		arg0_2:sendNotification(GAME.CHALLENGE2_INFO, {})
	end

	LimitChallengeConst.RequestInfo()
	arg0_2:sendNotification(GAME.REQUEST_MINI_GAME, {
		type = MiniGameRequestCommand.REQUEST_HUB_DATA
	})

	local var23_2 = getProxy(MiniGameProxy)
	local var24_2 = var23_2:GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var24_2 then
		local var25_2 = var24_2.id
		local var26_2 = var23_2:GetHubByGameId(var25_2).id

		arg0_2:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var26_2,
			cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
			args1 = {
				var25_2,
				1
			}
		})
	end

	arg0_2:sendNotification(GAME.REFLUX_REQUEST_DATA)

	local var27_2 = nowWorld()

	if pg.TimeMgr.GetInstance():GetServerWeek() == 1 then
		var27_2.staminaMgr.staminaExchangeTimes = 0
	end

	if var27_2 then
		local var28_2 = var27_2:GetBossProxy()

		var28_2:increasePt()
		var28_2:ClearSummonPtDailyAcc()
		var28_2:ClearSummonPtOldAcc()
	end

	local var29_2 = var11_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if var29_2 and not var29_2:isEnd() then
		local var30_2 = var29_2.data1KeyValueList[1]
		local var31_2 = pg.activity_event_worldboss[var29_2:getConfig("config_id")]

		if var31_2 then
			for iter8_2, iter9_2 in ipairs(var31_2.normal_expedition_drop_num or {}) do
				for iter10_2, iter11_2 in ipairs(iter9_2[1]) do
					var30_2[iter11_2] = iter9_2[2] or 0
				end
			end
		end

		var11_2:updateActivity(var29_2)
	end

	local var32_2 = getProxy(ActivityProxy)
	local var33_2 = var32_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if var33_2 and not var33_2:isEnd() then
		local var34_2, var35_2 = getProxy(EventProxy):GetEventByActivityId(var33_2.id)

		if not var34_2 or var34_2 and not var34_2:IsStarting() then
			if var34_2 and var35_2 then
				table.remove(getProxy(EventProxy).eventList, var35_2)
			end

			local var36_2 = var33_2:getConfig("config_data")
			local var37_2 = var33_2:getDayIndex()

			if var37_2 > 0 and var37_2 <= #var36_2 then
				getProxy(EventProxy):AddActivityEvent(EventInfo.New({
					finish_time = 0,
					over_time = 0,
					id = var36_2[var37_2],
					ship_id_list = {},
					activity_id = var33_2.id
				}))
			end

			pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
			arg0_2:sendNotification(GAME.EVENT_LIST_UPDATE)
		end
	end

	local var38_2 = getProxy(GuildProxy)
	local var39_2 = var38_2:getRawData()

	if var39_2 then
		var39_2:ResetTechCancelCnt()

		local var40_2 = var39_2:getWeeklyTask()

		if var40_2 and var40_2:isExpire() then
			local var41_2 = var40_2:GetPresonTaskId()

			getProxy(TaskProxy):removeTaskById(var41_2)

			var39_2.weeklyTaskFlag = 0
		end

		local var42_2 = var39_2:GetActiveEvent()

		if var42_2 then
			var42_2:GetBossMission():ResetDailyCnt()
		end

		if var8_2.day == 1 then
			var39_2:ResetActiveEventCnt()
		end

		var38_2:updateGuild(var39_2)
	end

	if var38_2:GetPublicGuild() then
		local var43_2 = math.random(2, 5)
		local var44_2

		var44_2 = Timer.New(function()
			var44_2:Stop()
			arg0_2:sendNotification(GAME.GET_PUBLIC_GUILD_USER_DATA, {
				flag = true
			})
		end, var43_2, 1)

		var44_2:Start()
	end

	getProxy(NavalAcademyProxy):resetUsedDailyFinishCnt()
	getProxy(AvatarFrameProxy):clearTimeOut()
	arg0_2:sendNotification(GAME.ZERO_HOUR_OP_DONE)
	MainRequestActDataSequence.New():RequestRandomDailyTask()
	;(function()
		local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)

		if not var0_7 or var0_7:isEnd() then
			return
		end

		local var1_7 = var0_7:GetDailyCounts()

		table.Foreach(var1_7, function(arg0_8, arg1_8)
			var1_7[arg0_8] = 0
		end)
		getProxy(ActivityProxy):updateActivity(var0_7)
	end)()
	;(function()
		local var0_9 = var32_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE)

		if not var0_9 or var0_9:isEnd() then
			return
		end

		arg0_2:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = var0_9.id
		})
	end)()
end

return var0_0
