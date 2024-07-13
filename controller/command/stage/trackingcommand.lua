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

	seriesAsync({
		function(arg0_2)
			if var9_1:isRemaster() and var7_1.remasterTickets <= 0 then
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

			if not var0_3 then
				pg.TipsMgr.GetInstance():ShowTips(var1_3)
				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end

			if var1_3 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					content = i18n("elite_fleet_confirm", Fleet.DEFAULT_NAME[var1_3]),
					onYes = arg0_3
				})

				return
			end

			arg0_3()
		end,
		function(arg0_4)
			local var0_4 = var8_1:getConfig("oil") * var0_0.CalculateSpItemMoreCostRate(var3_1)

			if not getProxy(PlayerProxy):getRawData():isEnough({
				oil = var0_4
			}) then
				if not ItemTipPanel.ShowOilBuyTip(var0_4) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
				end

				arg0_1:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8_1
				})

				return
			end

			arg0_4()
		end,
		function(arg0_5)
			if var8_1:getConfig("type") ~= Chapter.SelectFleet then
				arg0_5()

				return
			end

			local var0_5 = false
			local var1_5 = ""

			for iter0_5, iter1_5 in ipairs(var2_1) do
				var0_5, var1_5 = getProxy(FleetProxy):getFleetById(iter1_5):GetEnergyStatus()

				if var0_5 then
					break
				end
			end

			if var0_5 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = var1_5,
					onYes = arg0_5
				})

				return
			end

			arg0_5()
		end,
		function(arg0_6)
			if var9_1:isRemaster() and PlayerPrefs.GetString("remaster_tip") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") and (not var10_1 or var10_1:IsFirstBattle()) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					showStopRemind = true,
					content = i18n("levelScene_activate_remaster"),
					onYes = function()
						if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
							PlayerPrefs.SetString("remaster_tip", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
						end

						arg0_6()
					end
				})

				return
			end

			arg0_6()
		end,
		function(arg0_8)
			local var0_8 = var8_1:getConfig("enter_story")
			local var1_8 = var8_1:getConfig("enter_story_limit")

			if var0_8 and var0_8 ~= "" and arg0_1:isCrossStoryLimit(var1_8) and not var9_1:isRemaster() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_8) then
				local var2_8 = tonumber(var0_8)

				if var2_8 and var2_8 > 0 then
					arg0_1:sendNotification(GAME.BEGIN_STAGE, {
						system = SYSTEM_PERFORM,
						stageId = var2_8,
						exitCallback = arg0_8
					})

					return
				else
					ChapterOpCommand.PlayChapterStory(var0_8, arg0_8, var8_1:isLoop() and PlayerPrefs.GetInt("chapter_autofight_flag_" .. var8_1.id, 1) == 1)

					return
				end
			end

			arg0_8()
		end,
		function(arg0_9)
			if var10_1 then
				local var0_9 = var10_1:GetRestBattleTime()
				local var1_9 = {
					1,
					1,
					2
				}

				if var9_1:isRemaster() then
					table.insert(var1_9, 1)
				end

				if var0_9 > _.reduce(var1_9, -1, function(arg0_10, arg1_10)
					return arg0_10 + arg1_10
				end) then
					arg0_1:sendNotification(15300, {
						type = 2,
						ver_str = string.format("tracking Chapter %d by CO times %d", var8_1.id, var0_9)
					})
				end
			end

			arg0_9()
		end,
		function(arg0_11)
			local var0_11 = var8_1:getConfig("map")
			local var1_11 = var8_1:getEliteFleetList()
			local var2_11 = var8_1:getEliteFleetCommanders()
			local var3_11 = {}

			for iter0_11, iter1_11 in ipairs(var1_11) do
				if var8_1:singleEliteFleetVertify(iter0_11) then
					local var4_11 = {}
					local var5_11 = {}
					local var6_11 = {}

					for iter2_11, iter3_11 in ipairs(iter1_11) do
						var5_11[#var5_11 + 1] = iter3_11
					end

					local var7_11 = var2_11[iter0_11]

					for iter4_11, iter5_11 in pairs(var7_11) do
						table.insert(var6_11, {
							pos = iter4_11,
							id = iter5_11
						})
					end

					var4_11.map_id = var0_11
					var4_11.main_id = var5_11
					var4_11.commanders = var6_11
					var3_11[#var3_11 + 1] = var4_11
				else
					var3_11[#var3_11 + 1] = {
						main_id = {},
						commanders = {}
					}
				end
			end

			local var8_11 = var8_1:getSupportFleet()
			local var9_11 = {}
			local var10_11 = {}

			for iter6_11, iter7_11 in ipairs(var8_11) do
				var10_11[#var10_11 + 1] = iter7_11
			end

			var9_11.map_id = var0_11
			var9_11.main_id = var10_11
			var9_11.commanders = {}
			var3_11[#var3_11 + 1] = var9_11
			arg0_1.chapterId = var1_1
			arg0_1.fleetIds = var2_1
			arg0_1.fleetDatas = var3_11
			arg0_1.loopFlag = var4_1
			arg0_1.operationItem = var3_1
			arg0_1.dutiesKeyValue = var6_1
			arg0_1.autoFightFlag = var0_1.autoFightFlag

			arg0_1:sendProto()
		end
	})
end

function var0_0.sendProto(arg0_12)
	local var0_12 = arg0_12.chapterId
	local var1_12 = arg0_12.fleetIds
	local var2_12 = arg0_12.fleetDatas
	local var3_12 = arg0_12.operationItem
	local var4_12 = arg0_12.loopFlag
	local var5_12 = arg0_12.dutiesKeyValue
	local var6_12 = arg0_12.autoFightFlag

	pg.ConnectionMgr.GetInstance():Send(13101, {
		id = var0_12,
		group_id_list = var1_12,
		elite_fleet_list = var2_12,
		operation_item = var3_12,
		loop_flag = var4_12,
		fleet_duties = var5_12
	}, 13102, function(arg0_13)
		if arg0_13.result == 0 then
			local var0_13 = getProxy(ChapterProxy)
			local var1_13 = var0_13:getChapterById(var0_12)
			local var2_13 = var0_13:getMapById(var1_13:getConfig("map"))
			local var3_13 = getProxy(PlayerProxy)
			local var4_13 = var3_13:getData()

			var1_13:update(arg0_13.current_chapter)

			local var5_13 = var1_13:getConfig("oil")

			var4_13:consume({
				oil = var5_13 * var1_13:GetExtraCostRate()
			})
			var3_13:updatePlayer(var4_13)

			if var3_12 ~= 0 then
				getProxy(BagProxy):removeItemById(var3_12, 1)
			end

			for iter0_13, iter1_13 in pairs(var1_13.cells) do
				if ChapterConst.NeedMarkAsLurk(iter1_13) then
					iter1_13.trait = ChapterConst.TraitLurk
				end
			end

			for iter2_13, iter3_13 in ipairs(var1_13.champions) do
				iter3_13.trait = ChapterConst.TraitLurk
			end

			var0_13:updateChapter(var1_13)

			if var2_13:isEscort() then
				var0_13.escortChallengeTimes = var0_13.escortChallengeTimes + 1
			end

			if var2_13:isRemaster() then
				var0_13.remasterTickets = var0_13.remasterTickets - 1
			end

			local var6_13 = var0_13:GetContinuousData(SYSTEM_SCENARIO)

			if var6_13 then
				var6_13:TryActivate()
			end

			arg0_12:sendNotification(GAME.TRACKING_DONE, var1_13)
			getProxy(ChapterProxy):updateExtraFlag(var1_13, var1_13.extraFlagList, {}, true)

			if var4_12 ~= 0 and var6_12 then
				getProxy(ChapterProxy):SetChapterAutoFlag(var0_12, true)
			end

			return
		end

		if arg0_13.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_retry"))
			arg0_12:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
		elseif arg0_13.result == 3010 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_3001"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("levelScene_tracking_erro", arg0_13.result))
		end

		local var7_13 = getProxy(ChapterProxy):getChapterById(var0_12)

		arg0_12:sendNotification(GAME.TRACKING_ERROR, {
			chapter = var7_13
		})
	end)
end

function var0_0.isCrossStoryLimit(arg0_14, arg1_14)
	local var0_14 = true

	if arg1_14 ~= "" and #arg1_14 > 0 then
		var0_14 = _.all(arg1_14, function(arg0_15)
			if arg0_15[1] == 1 then
				local var0_15 = getProxy(TaskProxy):getTaskById(arg0_15[2])

				return var0_15 and not var0_15:isFinish()
			end

			return false
		end)
	end

	return var0_14
end

function var0_0.CalculateSpItemMoreCostRate(arg0_16)
	local var0_16 = 1

	if not arg0_16 or arg0_16 == 0 then
		return var0_16
	end

	local var1_16 = Item.getConfigData(arg0_16).usage_arg
	local var2_16 = _.map(string.split(string.sub(var1_16, 2, -2), ","), function(arg0_17)
		return tonumber(arg0_17)
	end)

	for iter0_16, iter1_16 in ipairs(var2_16) do
		local var3_16 = pg.benefit_buff_template[iter0_16]

		if var3_16 and var3_16.benefit_type == Chapter.OPERATION_BUFF_TYPE_COST then
			var0_16 = var0_16 + tonumber(var3_16.benefit_effect) * 0.01
		end
	end

	return (math.max(1, var0_16))
end

return var0_0
