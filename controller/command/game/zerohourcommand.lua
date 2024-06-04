local var0 = class("ZeroHourCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0, var1 = pcall(arg0.mainHandler, arg0)

	if not var0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("zero_hour_command_error"))
		error(var1)
	end
end

function var0.mainHandler(arg0, arg1)
	local var0 = getProxy(PlayerProxy)
	local var1 = var0:getData()

	var1:resetBuyOilCount()

	for iter0, iter1 in pairs(var1.vipCards) do
		if iter1:isExpire() then
			var1.vipCards[iter1.id] = nil
		end
	end

	var0:updatePlayer(var1)

	local var2 = getProxy(ShopsProxy)
	local var3 = var2:getShopStreet()

	if var3 then
		var3:resetflashCount()
		var2:setShopStreet(var3)
	end

	var2.refreshChargeList = true

	getProxy(CollectionProxy):resetEvaCount()

	local var4 = getProxy(MilitaryExerciseProxy)
	local var5 = var4:getSeasonInfo()

	if var5 then
		var5:resetFlashCount()
		var4:updateSeasonInfo(var5)
	end

	getProxy(DailyLevelProxy):resetDailyCount()

	local var6 = getProxy(ChapterProxy)

	var6:resetRepairTimes()
	var6:resetEscortChallengeTimes()

	local var7 = var6:getData()

	for iter2, iter3 in pairs(var7) do
		if iter3.todayDefeatCount > 0 then
			iter3.todayDefeatCount = 0

			var6:updateChapter(iter3)
		end
	end

	var6:resetDailyCount()
	;(function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

		if not var0 then
			return
		end

		local var1 = var0:GetUsedBonus()

		table.Foreach(var1, function(arg0, arg1)
			var1[arg0] = 0
		end)
		getProxy(ActivityProxy):updateActivity(var0)
	end)()
	getProxy(DailyLevelProxy):clearChaptersDefeatCount()

	local var8 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")

	if var8.day == 1 then
		var2.shamShop:update(var8.month, {})
		var2:AddShamShop(var2.shamShop)
		var2.fragmentShop:Reset(var8.month)
		var2:AddFragmentShop(var2.fragmentShop)

		if not LOCK_UR_SHIP then
			local var9 = pg.gameset.urpt_chapter_max.description[1]

			getProxy(BagProxy):ClearLimitCnt(var9)
		end
	end

	local var10 = getProxy(ShopsProxy):getMiniShop()

	if var10 and var10:checkShopFlash() then
		pg.m02:sendNotification(GAME.MINI_GAME_SHOP_FLUSH)
	end

	local var11 = getProxy(ActivityProxy)

	for iter4, iter5 in ipairs(var11:getPanelActivities()) do
		if (function()
			local var0 = {
				ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN,
				ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN,
				ActivityConst.ACTIVITY_TYPE_MONTHSIGN,
				ActivityConst.ACTIVITY_TYPE_REFLUX,
				ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN,
				ActivityConst.ACTIVITY_TYPE_BB,
				ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD
			}

			iter5.autoActionForbidden = false

			if iter5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BB then
				iter5.data2 = 0
			elseif iter5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD then
				iter5.data2 = 0
			end

			return table.contains(var0, iter5:getConfig("type"))
		end)() then
			var11:updateActivity(iter5)
		end
	end

	getProxy(RefluxProxy):setAutoActionForbidden(false)

	local var12 = var11:getActivityByType(ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN)

	if var12 and not var12:isEnd() then
		pg.m02:sendNotification(GAME.ACT_MANUAL_SIGN, {
			activity_id = var12.id,
			cmd = ManualSignActivity.OP_SIGN
		})
	end

	local var13 = var11:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

	if var13 and not var13:isEnd() then
		var13.data1KeyValueList = {
			{}
		}

		var11:updateActivity(var13)
	end

	local var14 = var11:getActivityByType(ActivityConst.ACTIVITY_TYPE_TURNTABLE)

	if var14 and not var14:isEnd() then
		local var15 = var14:getConfig("config_id")
		local var16 = pg.activity_event_turning[var15]

		if var16.total_num <= var14.data3 then
			return
		end

		local var17 = var16.task_table[var14.data4]
		local var18 = getProxy(TaskProxy)

		for iter6, iter7 in ipairs(var17) do
			if (var18:getTaskById(iter7) or var18:getFinishTaskById(iter7)):getTaskStatus() ~= 2 then
				return
			end
		end

		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = var14.id
		})
	end

	local var19 = getProxy(NavalAcademyProxy)

	var19:setCourse(var19.course)
	arg0:sendNotification(GAME.CLASS_FORCE_UPDATE)
	getProxy(TechnologyProxy):updateRefreshFlag(0)
	arg0:sendNotification(GAME.ACCEPT_ACTIVITY_TASK)
	getProxy(CommanderProxy):resetBoxUseCnt()

	local var20 = getProxy(CommanderProxy):GetCommanderHome()

	if var20 then
		var20:ResetCatteryOP()
		var20:ReduceClean()
	end

	local var21 = var11:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

	if var21 and not var21:isEnd() then
		var11:updateActivity(var21)
	end

	local var22 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	if var22 and not var22:isEnd() then
		arg0:sendNotification(GAME.CHALLENGE2_INFO, {})
	end

	LimitChallengeConst.RequestInfo()
	arg0:sendNotification(GAME.REQUEST_MINI_GAME, {
		type = MiniGameRequestCommand.REQUEST_HUB_DATA
	})

	local var23 = getProxy(MiniGameProxy)
	local var24 = var23:GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var24 then
		local var25 = var24.id
		local var26 = var23:GetHubByGameId(var25).id

		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var26,
			cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
			args1 = {
				var25,
				1
			}
		})
	end

	arg0:sendNotification(GAME.REFLUX_REQUEST_DATA)

	local var27 = nowWorld()

	if pg.TimeMgr.GetInstance():GetServerWeek() == 1 then
		var27.staminaMgr.staminaExchangeTimes = 0
	end

	if var27 then
		local var28 = var27:GetBossProxy()

		var28:increasePt()
		var28:ClearSummonPtDailyAcc()
		var28:ClearSummonPtOldAcc()
	end

	local var29 = var11:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if var29 and not var29:isEnd() then
		local var30 = var29.data1KeyValueList[1]
		local var31 = pg.activity_event_worldboss[var29:getConfig("config_id")]

		if var31 then
			for iter8, iter9 in ipairs(var31.normal_expedition_drop_num or {}) do
				for iter10, iter11 in ipairs(iter9[1]) do
					var30[iter11] = iter9[2] or 0
				end
			end
		end

		var11:updateActivity(var29)
	end

	local var32 = getProxy(ActivityProxy)
	local var33 = var32:getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if var33 and not var33:isEnd() then
		local var34, var35 = getProxy(EventProxy):GetEventByActivityId(var33.id)

		if not var34 or var34 and not var34:IsStarting() then
			if var34 and var35 then
				table.remove(getProxy(EventProxy).eventList, var35)
			end

			local var36 = var33:getConfig("config_data")
			local var37 = var33:getDayIndex()

			if var37 > 0 and var37 <= #var36 then
				getProxy(EventProxy):AddActivityEvent(EventInfo.New({
					finish_time = 0,
					over_time = 0,
					id = var36[var37],
					ship_id_list = {},
					activity_id = var33.id
				}))
			end

			pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
			arg0:sendNotification(GAME.EVENT_LIST_UPDATE)
		end
	end

	local var38 = getProxy(GuildProxy)
	local var39 = var38:getRawData()

	if var39 then
		var39:ResetTechCancelCnt()

		local var40 = var39:getWeeklyTask()

		if var40 and var40:isExpire() then
			local var41 = var40:GetPresonTaskId()

			getProxy(TaskProxy):removeTaskById(var41)

			var39.weeklyTaskFlag = 0
		end

		local var42 = var39:GetActiveEvent()

		if var42 then
			var42:GetBossMission():ResetDailyCnt()
		end

		if var8.day == 1 then
			var39:ResetActiveEventCnt()
		end

		var38:updateGuild(var39)
	end

	if var38:GetPublicGuild() then
		local var43 = math.random(2, 5)
		local var44

		var44 = Timer.New(function()
			var44:Stop()
			arg0:sendNotification(GAME.GET_PUBLIC_GUILD_USER_DATA, {
				flag = true
			})
		end, var43, 1)

		var44:Start()
	end

	getProxy(NavalAcademyProxy):resetUsedDailyFinishCnt()
	getProxy(AvatarFrameProxy):clearTimeOut()
	arg0:sendNotification(GAME.ZERO_HOUR_OP_DONE)
	MainRequestActDataSequence.New():RequestRandomDailyTask()
	;(function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)

		if not var0 or var0:isEnd() then
			return
		end

		local var1 = var0:GetDailyCounts()

		table.Foreach(var1, function(arg0, arg1)
			var1[arg0] = 0
		end)
		getProxy(ActivityProxy):updateActivity(var0)
	end)()
	;(function()
		local var0 = var32:getActivityByType(ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE)

		if not var0 or var0:isEnd() then
			return
		end

		arg0:sendNotification(GAME.SINGLE_EVENT_REFRESH, {
			actId = var0.id
		})
	end)()
end

return var0
