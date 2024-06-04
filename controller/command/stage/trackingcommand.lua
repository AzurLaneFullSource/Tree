local var0 = class("TrackingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.chapterId
	local var2 = var0.fleetIds
	local var3 = var0.operationItem or 0
	local var4 = var0.loopFlag or 0
	local var5 = var0.duties

	if not var5 or var4 == 0 then
		var5 = {}
	end

	local var6 = {}

	for iter0, iter1 in ipairs(var5) do
		table.insert(var6, {
			key = iter0,
			value = iter1
		})
	end

	local var7 = getProxy(ChapterProxy)
	local var8 = var7:getChapterById(var1)

	var8.loopFlag = var4

	local var9 = var7:getMapById(var8:getConfig("map"))
	local var10 = var7:GetContinuousData(SYSTEM_SCENARIO)

	seriesAsync({
		function(arg0)
			if var9:isRemaster() and var7.remasterTickets <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_tickets_not_enough"))
				arg0:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8
				})

				return
			end

			if var9:isActivity() and not var9:isRemaster() and not var8:inActTime() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_close"))
				arg0:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8
				})

				return
			end

			if var8:isTriesLimit() and not var8:enoughTimes2Start() then
				if var8:IsSpChapter() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("sp_no_quota"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))
				end

				arg0:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8
				})

				return
			end

			local var0 = getProxy(DailyLevelProxy)

			if var9:getMapType() == Map.ELITE and not var0:IsEliteEnabled() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))
				arg0:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8
				})

				return
			end

			if var8.active then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_strategying"))
				arg0:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8
				})

				return
			end

			if var9:isEscort() and var7.escortChallengeTimes >= var7:getMaxEscortChallengeTimes() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("escort_less_count_to_combat"))
				arg0:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8
				})

				return
			end

			arg0()
		end,
		function(arg0)
			if var8:getConfig("type") ~= Chapter.CustomFleet then
				arg0()

				return
			end

			local var0, var1 = var8:IsEliteFleetLegal()

			if not var0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)
				arg0:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8
				})

				return
			end

			if var1 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					content = i18n("elite_fleet_confirm", Fleet.DEFAULT_NAME[var1]),
					onYes = arg0
				})

				return
			end

			arg0()
		end,
		function(arg0)
			local var0 = var8:getConfig("oil") * var0.CalculateSpItemMoreCostRate(var3)

			if not getProxy(PlayerProxy):getRawData():isEnough({
				oil = var0
			}) then
				if not ItemTipPanel.ShowOilBuyTip(var0) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
				end

				arg0:sendNotification(GAME.TRACKING_ERROR, {
					chapter = var8
				})

				return
			end

			arg0()
		end,
		function(arg0)
			if var8:getConfig("type") ~= Chapter.SelectFleet then
				arg0()

				return
			end

			local var0 = false
			local var1 = ""

			for iter0, iter1 in ipairs(var2) do
				var0, var1 = getProxy(FleetProxy):getFleetById(iter1):GetEnergyStatus()

				if var0 then
					break
				end
			end

			if var0 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = var1,
					onYes = arg0
				})

				return
			end

			arg0()
		end,
		function(arg0)
			if var9:isRemaster() and PlayerPrefs.GetString("remaster_tip") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") and (not var10 or var10:IsFirstBattle()) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					showStopRemind = true,
					content = i18n("levelScene_activate_remaster"),
					onYes = function()
						if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
							PlayerPrefs.SetString("remaster_tip", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
						end

						arg0()
					end
				})

				return
			end

			arg0()
		end,
		function(arg0)
			local var0 = var8:getConfig("enter_story")
			local var1 = var8:getConfig("enter_story_limit")

			if var0 and var0 ~= "" and arg0:isCrossStoryLimit(var1) and not var9:isRemaster() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0) then
				local var2 = tonumber(var0)

				if var2 and var2 > 0 then
					arg0:sendNotification(GAME.BEGIN_STAGE, {
						system = SYSTEM_PERFORM,
						stageId = var2,
						exitCallback = arg0
					})

					return
				else
					ChapterOpCommand.PlayChapterStory(var0, arg0, var8:isLoop() and PlayerPrefs.GetInt("chapter_autofight_flag_" .. var8.id, 1) == 1)

					return
				end
			end

			arg0()
		end,
		function(arg0)
			if var10 then
				local var0 = var10:GetRestBattleTime()
				local var1 = {
					1,
					1,
					2
				}

				if var9:isRemaster() then
					table.insert(var1, 1)
				end

				if var0 > _.reduce(var1, -1, function(arg0, arg1)
					return arg0 + arg1
				end) then
					arg0:sendNotification(15300, {
						type = 2,
						ver_str = string.format("tracking Chapter %d by CO times %d", var8.id, var0)
					})
				end
			end

			arg0()
		end,
		function(arg0)
			local var0 = var8:getConfig("map")
			local var1 = var8:getEliteFleetList()
			local var2 = var8:getEliteFleetCommanders()
			local var3 = {}

			for iter0, iter1 in ipairs(var1) do
				if var8:singleEliteFleetVertify(iter0) then
					local var4 = {}
					local var5 = {}
					local var6 = {}

					for iter2, iter3 in ipairs(iter1) do
						var5[#var5 + 1] = iter3
					end

					local var7 = var2[iter0]

					for iter4, iter5 in pairs(var7) do
						table.insert(var6, {
							pos = iter4,
							id = iter5
						})
					end

					var4.map_id = var0
					var4.main_id = var5
					var4.commanders = var6
					var3[#var3 + 1] = var4
				else
					var3[#var3 + 1] = {
						main_id = {},
						commanders = {}
					}
				end
			end

			local var8 = var8:getSupportFleet()
			local var9 = {}
			local var10 = {}

			for iter6, iter7 in ipairs(var8) do
				var10[#var10 + 1] = iter7
			end

			var9.map_id = var0
			var9.main_id = var10
			var9.commanders = {}
			var3[#var3 + 1] = var9
			arg0.chapterId = var1
			arg0.fleetIds = var2
			arg0.fleetDatas = var3
			arg0.loopFlag = var4
			arg0.operationItem = var3
			arg0.dutiesKeyValue = var6
			arg0.autoFightFlag = var0.autoFightFlag

			arg0:sendProto()
		end
	})
end

function var0.sendProto(arg0)
	local var0 = arg0.chapterId
	local var1 = arg0.fleetIds
	local var2 = arg0.fleetDatas
	local var3 = arg0.operationItem
	local var4 = arg0.loopFlag
	local var5 = arg0.dutiesKeyValue
	local var6 = arg0.autoFightFlag

	pg.ConnectionMgr.GetInstance():Send(13101, {
		id = var0,
		group_id_list = var1,
		elite_fleet_list = var2,
		operation_item = var3,
		loop_flag = var4,
		fleet_duties = var5
	}, 13102, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ChapterProxy)
			local var1 = var0:getChapterById(var0)
			local var2 = var0:getMapById(var1:getConfig("map"))
			local var3 = getProxy(PlayerProxy)
			local var4 = var3:getData()

			var1:update(arg0.current_chapter)

			local var5 = var1:getConfig("oil")

			var4:consume({
				oil = var5 * var1:GetExtraCostRate()
			})
			var3:updatePlayer(var4)

			if var3 ~= 0 then
				getProxy(BagProxy):removeItemById(var3, 1)
			end

			for iter0, iter1 in pairs(var1.cells) do
				if ChapterConst.NeedMarkAsLurk(iter1) then
					iter1.trait = ChapterConst.TraitLurk
				end
			end

			for iter2, iter3 in ipairs(var1.champions) do
				iter3.trait = ChapterConst.TraitLurk
			end

			var0:updateChapter(var1)

			if var2:isEscort() then
				var0.escortChallengeTimes = var0.escortChallengeTimes + 1
			end

			if var2:isRemaster() then
				var0.remasterTickets = var0.remasterTickets - 1
			end

			local var6 = var0:GetContinuousData(SYSTEM_SCENARIO)

			if var6 then
				var6:TryActivate()
			end

			arg0:sendNotification(GAME.TRACKING_DONE, var1)
			getProxy(ChapterProxy):updateExtraFlag(var1, var1.extraFlagList, {}, true)

			if var4 ~= 0 and var6 then
				getProxy(ChapterProxy):SetChapterAutoFlag(var0, true)
			end

			return
		end

		if arg0.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_retry"))
			arg0:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
		elseif arg0.result == 3010 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_3001"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("levelScene_tracking_erro", arg0.result))
		end

		local var7 = getProxy(ChapterProxy):getChapterById(var0)

		arg0:sendNotification(GAME.TRACKING_ERROR, {
			chapter = var7
		})
	end)
end

function var0.isCrossStoryLimit(arg0, arg1)
	local var0 = true

	if arg1 ~= "" and #arg1 > 0 then
		var0 = _.all(arg1, function(arg0)
			if arg0[1] == 1 then
				local var0 = getProxy(TaskProxy):getTaskById(arg0[2])

				return var0 and not var0:isFinish()
			end

			return false
		end)
	end

	return var0
end

function var0.CalculateSpItemMoreCostRate(arg0)
	local var0 = 1

	if not arg0 or arg0 == 0 then
		return var0
	end

	local var1 = Item.getConfigData(arg0).usage_arg
	local var2 = _.map(string.split(string.sub(var1, 2, -2), ","), function(arg0)
		return tonumber(arg0)
	end)

	for iter0, iter1 in ipairs(var2) do
		local var3 = pg.benefit_buff_template[iter0]

		if var3 and var3.benefit_type == Chapter.OPERATION_BUFF_TYPE_COST then
			var0 = var0 + tonumber(var3.benefit_effect) * 0.01
		end
	end

	return (math.max(1, var0))
end

return var0
