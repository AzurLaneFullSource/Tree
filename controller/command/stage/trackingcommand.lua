local var0_0 = class("TrackingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.chapterId
	local var2_1 = var0_1.fleetIds
	local var3_1 = var0_1.operationItem or 0
	local var4_1 = var0_1.loopFlag or 0
	local var5_1 = var0_1.duties

	if not var5_1 or var4_1 == 0 then
		var5_1 = {}
	end

	local var6_1 = {}

	for iter0_1, iter1_1 in ipairs(var5_1) do
		table.insert(var6_1, {
			key = iter0_1,
			value = iter1_1
		})
	end

	local var7_1 = getProxy(ChapterProxy)
	local var8_1 = var7_1:getChapterById(var1_1)

	var8_1.loopFlag = var4_1

	local var9_1 = var7_1:getMapById(var8_1:getConfig("map"))
	local var10_1 = var7_1:GetContinuousData(SYSTEM_SCENARIO)
	local var11_1 = var7_1:getRemasterTicketCost()
	local var12_1

	seriesAsync({
		function(arg0_2)
			if var9_1:isRemaster() and var7_1.remasterTickets < var11_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_tickets_not_enough"))
				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end

			if var9_1:isActivity() and not var9_1:isRemaster() and not var8_1:inActTime() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_close"))
				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end

			if var8_1:isTriesLimit() and not var8_1:enoughTimes2Start() then
				if var8_1:IsSpChapter() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("sp_no_quota"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))
				end

				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end

			local var0_2 = getProxy(DailyLevelProxy)

			if var9_1:getMapType() == Map.ELITE and not var0_2:IsEliteEnabled() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))
				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end

			if var8_1.active then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_strategying"))
				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end

			if var9_1:isEscort() and var7_1.escortChallengeTimes >= var7_1:getMaxEscortChallengeTimes() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("escort_less_count_to_combat"))
				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end

			arg0_2()
		end,
		function(arg0_3)
			if var8_1:getConfig("type") ~= Chapter.CustomFleet then
				arg0_3()

				return
			end

			local var0_3, var1_3 = var8_1:IsEliteFleetLegal()

			if var0_3 then
				arg0_3()
			else
				pg.TipsMgr.GetInstance():ShowTips(var1_3)
				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end
		end,
		function(arg0_4)
			local var0_4 = var8_1:getConfig("oil")

			if var8_1:IsSupportSubmarineStage() and #var8_1:getSupportFleet() > 0 then
				var0_4 = var0_4 + getGameset("submarine_support_oil_consume")[1]
			end

			local var1_4 = var0_4 * var0_0.CalculateSpItemMoreCostRate(var3_1)

			if not getProxy(PlayerProxy):getRawData():isEnough({
				oil = var1_4
			}) then
				if not ItemTipPanel.ShowOilBuyTip(var1_4) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
				end

				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_STRIKE_FAILD)

				return
			end

			arg0_4()
		end,
		function(arg0_5)
			if var8_1:getConfig("type") == Chapter.SelectFleet then
				var12_1 = {
					[FleetType.Normal] = {},
					[FleetType.Submarine] = {},
					[FleetType.Support] = Clone(var8_1.eliteFleetList[FleetType.Support])
				}

				local var0_5 = false
				local var1_5 = ""

				for iter0_5, iter1_5 in ipairs(var2_1) do
					local var2_5 = getProxy(FleetProxy):getFleetById(iter1_5)
					local var3_5, var4_5 = var2_5:ChangeToElite()

					table.insert(var12_1[var4_5], var3_5)

					if not var0_5 then
						local var5_5

						var0_5, var5_5 = var2_5:GetEnergyStatus()
					end
				end
			else
				var12_1 = var8_1.eliteFleetList
			end

			var12_1 = Chapter.PackEliteFleetInfo(var12_1)

			local var6_5 = {}

			if hasTiredState then
				table.insert(var6_5, function(arg0_6)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = tooltip,
						onYes = arg0_6
					})
				end)
			end

			seriesAsync(var6_5, arg0_5)
		end,
		function(arg0_7)
			if var9_1:isRemaster() and PlayerPrefs.GetString("remaster_tip") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") and (not var10_1 or var10_1:IsFirstBattle()) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					showStopRemind = true,
					content = i18n("levelScene_activate_remaster_1", getProxy(ChapterProxy):getRemasterTicketCost()),
					onYes = function()
						if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
							PlayerPrefs.SetString("remaster_tip", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
						end

						arg0_7()
					end
				})

				return
			end

			arg0_7()
		end,
		function(arg0_9)
			if var8_1:IsSupportSubmarineStage() and #var8_1:getSupportFleet() > 0 then
				if var10_1 then
					arg0_9()
				else
					local var0_9 = getGameset("submarine_support_oil_consume")[1]

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("submarine_support_oil_consume_tip", var0_9),
						onYes = arg0_9
					})
				end
			else
				arg0_9()
			end
		end,
		function(arg0_10)
			local var0_10 = var8_1:getConfig("enter_story")
			local var1_10 = var8_1:getConfig("enter_story_limit")

			if var0_10 and var0_10 ~= "" and arg0_1:isCrossStoryLimit(var1_10) and not var9_1:isRemaster() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_10) then
				local var2_10 = tonumber(var0_10)

				if var2_10 and var2_10 > 0 then
					local var3_10 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

					if var3_10 then
						var3_10.data.pendingEnterChapterId = var1_1
					end

					arg0_1:sendNotification(GAME.BEGIN_STAGE, {
						system = SYSTEM_PERFORM,
						stageId = var2_10,
						exitCallback = arg0_10
					})

					return
				else
					ChapterOpCommand.PlayChapterStory(var0_10, arg0_10, var8_1:isLoop() and PlayerPrefs.GetInt("chapter_autofight_flag_" .. var8_1.id, 1) == 1)

					return
				end
			end

			arg0_10()
		end,
		function(arg0_11)
			if var10_1 then
				local var0_11 = var10_1:GetRestBattleTime()
				local var1_11 = {
					1,
					1,
					2
				}

				if var9_1:isRemaster() then
					table.insert(var1_11, 1)
				end

				if var0_11 > _.reduce(var1_11, -1, function(arg0_12, arg1_12)
					return arg0_12 + arg1_12
				end) then
					arg0_1:sendNotification(15300, {
						type = 2,
						ver_str = string.format("tracking Chapter %d by CO times %d", var8_1.id, var0_11)
					})
				end
			end

			arg0_11()
		end,
		function(arg0_13)
			arg0_1.chapterId = var1_1
			arg0_1.fleetDatas = var12_1
			arg0_1.loopFlag = var4_1
			arg0_1.operationItem = var3_1
			arg0_1.dutiesKeyValue = var6_1
			arg0_1.autoFightFlag = var0_1.autoFightFlag

			arg0_1:sendProto()
		end
	})
end

function var0_0.sendProto(arg0_14)
	local var0_14 = arg0_14.chapterId
	local var1_14 = arg0_14.fleetIds
	local var2_14 = arg0_14.fleetDatas
	local var3_14 = arg0_14.operationItem
	local var4_14 = arg0_14.loopFlag
	local var5_14 = arg0_14.dutiesKeyValue
	local var6_14 = arg0_14.autoFightFlag

	pg.ConnectionMgr.GetInstance():Send(13101, {
		id = var0_14,
		fleet = var2_14,
		operation_item = var3_14,
		loop_flag = var4_14,
		fleet_duties = var5_14
	}, 13102, function(arg0_15)
		if arg0_15.result == 0 then
			local var0_15 = getProxy(ChapterProxy)
			local var1_15 = var0_15:getChapterById(var0_14)
			local var2_15 = var0_15:getMapById(var1_15:getConfig("map"))
			local var3_15 = getProxy(PlayerProxy)
			local var4_15 = var3_15:getData()

			var1_15:update(arg0_15.current_chapter)

			local var5_15 = var1_15:getConfig("oil")

			if var1_15:IsSupportSubmarineStage() and var1_15:getChapterSupportFleet() then
				var5_15 = var5_15 + getGameset("submarine_support_oil_consume")[1]
			end

			var4_15:consume({
				oil = var5_15 * var1_15:GetExtraCostRate()
			})
			var3_15:updatePlayer(var4_15)

			if var3_14 ~= 0 then
				getProxy(BagProxy):removeItemById(var3_14, 1)
			end

			for iter0_15, iter1_15 in pairs(var1_15.cells) do
				if ChapterConst.NeedMarkAsLurk(iter1_15) then
					iter1_15.trait = ChapterConst.TraitLurk
				end
			end

			for iter2_15, iter3_15 in ipairs(var1_15.champions) do
				iter3_15.trait = ChapterConst.TraitLurk
			end

			var0_15:updateChapter(var1_15)

			if var2_15:isEscort() then
				var0_15.escortChallengeTimes = var0_15.escortChallengeTimes + 1
			end

			if var2_15:isRemaster() then
				var0_15:updateRemasterTicketsNum(var0_15.remasterTickets - var0_15:getRemasterTicketCost())
			end

			local var6_15 = var0_15:GetContinuousData(SYSTEM_SCENARIO)

			if var6_15 then
				var6_15:TryActivate()
			end

			arg0_14:sendNotification(GAME.TRACKING_DONE, var1_15)
			getProxy(ChapterProxy):updateExtraFlag(var1_15, var1_15:getExtraFlags(), {}, true)

			if var4_14 ~= 0 and var6_14 then
				getProxy(ChapterProxy):SetChapterAutoFlag(var0_14, true)
			end

			return
		end

		if arg0_15.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_retry"))
			arg0_14:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
		elseif arg0_15.result == 3010 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_3001"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("levelScene_tracking_erro", arg0_15.result))
		end

		local var7_15 = getProxy(ChapterProxy):getChapterById(var0_14)

		arg0_14:sendNotification(GAME.TRACKING_ERROR, {
			chapter = var7_15
		})
	end)
end

function var0_0.isCrossStoryLimit(arg0_16, arg1_16)
	local var0_16 = true

	if arg1_16 ~= "" and #arg1_16 > 0 then
		var0_16 = _.all(arg1_16, function(arg0_17)
			if arg0_17[1] == 1 then
				local var0_17 = getProxy(TaskProxy):getTaskById(arg0_17[2])

				return var0_17 and not var0_17:isFinish()
			end

			return false
		end)
	end

	return var0_16
end

function var0_0.CalculateSpItemMoreCostRate(arg0_18)
	local var0_18 = 1

	if not arg0_18 or arg0_18 == 0 then
		return var0_18
	end

	local var1_18 = Item.getConfigData(arg0_18).usage_arg
	local var2_18 = _.map(string.split(string.sub(var1_18, 2, -2), ","), function(arg0_19)
		return tonumber(arg0_19)
	end)

	for iter0_18, iter1_18 in ipairs(var2_18) do
		local var3_18 = pg.benefit_buff_template[iter0_18]

		if var3_18 and var3_18.benefit_type == Chapter.OPERATION_BUFF_TYPE_COST then
			var0_18 = var0_18 + tonumber(var3_18.benefit_effect) * 0.01
		end
	end

	return (math.max(1, var0_18))
end

return var0_0
