local var0_0 = class("Activity", import(".BaseVO"))
local var1_0

function var0_0.GetType2Class()
	if var1_0 then
		return var1_0
	end

	var1_0 = {
		[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = BeatMonterNianActivity,
		[ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT] = CollectionEventActivity,
		[ActivityConst.ACTIVITY_TYPE_RETURN_AWARD] = ReturnerActivity,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = BuildingBuffActivity,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = BuildingBuff2Activity,
		[ActivityConst.ACTIVITY_TYPE_ATELIER_LINK] = AtelierActivity,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = ActivityBossActivity,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = BossRushActivity,
		[ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK] = BossRushRankActivity,
		[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = CollabrateBossRushActivity,
		[ActivityConst.ACTIVITY_TYPE_WORKBENCH] = WorkBenchActivity,
		[ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG] = VirtualBagActivity,
		[ActivityConst.ACTIVITY_TYPE_SCULPTURE] = SculptureActivity,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = SpringActivity,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = Spring2Activity,
		[ActivityConst.ACTIVITY_TYPE_TASK_RYZA] = ActivityTaskActivity,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = PuzzleActivity,
		[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON] = SkinCouponActivity,
		[ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN] = ManualSignActivity,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = BossSingleActivity,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = BossSingleVariableActivity,
		[ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE] = SingleEventActivity,
		[ActivityConst.ACTIVITY_TYPE_LINER] = LinerActivity,
		[ActivityConst.ACTIVITY_TYPE_TOWN] = TownActivity,
		[ActivityConst.ACTIVITY_TYPE_TOWN2] = TownActivity2,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = AirFightActivity,
		[ActivityConst.ACTIVITY_TYPE_NOT_TRACEABLE] = NotTraceableTaskActivity,
		[ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA] = VirtualBagActivity,
		[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = VirtualBagActivity,
		[ActivityConst.ACTIVITY_TYPE_ISLAND_DRAW_AWARD] = DrawAwardActivity,
		[ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_UP] = LoveLetterActivity,
		[ActivityConst.ACTIVITY_TYPE_MALL] = MallActivity,
		[ActivityConst.ACTIVITY_TYPE_AUCTION_GAME] = AuctionGameActivity,
		[ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN] = ReversePacmanActivity
	}

	return var1_0
end

function var0_0.Create(arg0_2)
	local var0_2 = pg.activity_template[arg0_2.id]

	return (var0_0.GetType2Class()[var0_2.type] or Activity).New(arg0_2)
end

function var0_0.Ctor(arg0_3, arg1_3)
	arg0_3.id = arg1_3.id
	arg0_3.configId = arg0_3.id
	arg0_3.stopTime = arg1_3.stop_time
	arg0_3.data1 = defaultValue(arg1_3.data1, 0)
	arg0_3.data2 = defaultValue(arg1_3.data2, 0)
	arg0_3.data3 = defaultValue(arg1_3.data3, 0)
	arg0_3.data4 = defaultValue(arg1_3.data4, 0)
	arg0_3.str_data1 = defaultValue(arg1_3.str_data1, "")
	arg0_3.data1_list = {}

	for iter0_3, iter1_3 in ipairs(arg1_3.data1_list or {}) do
		table.insert(arg0_3.data1_list, iter1_3)
	end

	arg0_3.data2_list = {}

	for iter2_3, iter3_3 in ipairs(arg1_3.data2_list or {}) do
		table.insert(arg0_3.data2_list, iter3_3)
	end

	arg0_3.data3_list = {}

	for iter4_3, iter5_3 in ipairs(arg1_3.data3_list or {}) do
		table.insert(arg0_3.data3_list, iter5_3)
	end

	arg0_3.data4_list = {}

	for iter6_3, iter7_3 in ipairs(arg1_3.data4_list or {}) do
		table.insert(arg0_3.data4_list, iter7_3)
	end

	arg0_3.data1KeyValueList = {}

	for iter8_3, iter9_3 in ipairs(arg1_3.date1_key_value_list or {}) do
		arg0_3.data1KeyValueList[iter9_3.key] = {}

		for iter10_3, iter11_3 in ipairs(iter9_3.value_list or {}) do
			arg0_3.data1KeyValueList[iter9_3.key][iter11_3.key] = iter11_3.value
		end
	end

	arg0_3.buffList = {}

	for iter12_3, iter13_3 in ipairs(arg1_3.buff_list or {}) do
		table.insert(arg0_3.buffList, ActivityBuff.New(arg0_3.id, iter13_3.id, iter13_3.timestamp))
	end

	if arg0_3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP then
		arg0_3.data2KeyValueList = {}

		for iter14_3, iter15_3 in ipairs(arg1_3.date1_key_value_list or {}) do
			local var0_3 = iter15_3.key
			local var1_3 = iter15_3.value

			arg0_3.data2KeyValueList[var0_3] = {}
			arg0_3.data2KeyValueList[var0_3].value = var1_3
			arg0_3.data2KeyValueList[var0_3].dataMap = {}

			for iter16_3, iter17_3 in ipairs(iter15_3.value_list or {}) do
				local var2_3 = iter17_3.key
				local var3_3 = iter17_3.value

				arg0_3.data2KeyValueList[var0_3].dataMap[var2_3] = var3_3
			end
		end
	end

	arg0_3.clientData1 = 0
	arg0_3.clientList = {}
end

function var0_0.GetBuffList(arg0_4)
	return arg0_4.buffList
end

function var0_0.AddBuff(arg0_5, arg1_5)
	assert(isa(arg1_5, ActivityBuff), "activityBuff should instance of ActivityBuff")
	table.insert(arg0_5.buffList, arg1_5)
end

function var0_0.setClientList(arg0_6, arg1_6)
	arg0_6.clientList = arg1_6
end

function var0_0.getClientList(arg0_7)
	return arg0_7.clientList
end

function var0_0.updateDataList(arg0_8, arg1_8)
	table.insert(arg0_8.data1_list, arg1_8)
end

function var0_0.setDataList(arg0_9, arg1_9)
	arg0_9.data1_list = arg1_9
end

function var0_0.updateKVPList(arg0_10, arg1_10, arg2_10, arg3_10)
	if not arg0_10.data1KeyValueList[arg1_10] then
		arg0_10.data1KeyValueList[arg1_10] = {}
	end

	arg0_10.data1KeyValueList[arg1_10][arg2_10] = arg3_10
end

function var0_0.getKVPList(arg0_11, arg1_11, arg2_11)
	if not arg0_11.data1KeyValueList[arg1_11] then
		arg0_11.data1KeyValueList[arg1_11] = {}
	end

	return arg0_11.data1KeyValueList[arg1_11][arg2_11] or 0
end

function var0_0.getData1(arg0_12)
	return arg0_12.data1
end

function var0_0.getData2(arg0_13)
	return arg0_13.data2
end

function var0_0.getData3(arg0_14)
	return arg0_14.data3
end

function var0_0.getStrData1(arg0_15)
	return arg0_15.str_data1
end

function var0_0.getData1List(arg0_16)
	return arg0_16.data1_list
end

function var0_0.bindConfigTable(arg0_17)
	return pg.activity_template
end

function var0_0.getDataConfigTable(arg0_18)
	local var0_18 = arg0_18:getConfig("type")
	local var1_18 = arg0_18:getConfig("config_id")

	if var0_18 == ActivityConst.ACTIVITY_TYPE_MONOPOLY then
		return pg.activity_event_monopoly[tonumber(var1_18)]
	elseif var0_18 == ActivityConst.ACTIVITY_TYPE_PIZZA_PT or var0_18 == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		return pg.activity_event_pt[tonumber(var1_18)]
	elseif var0_18 == ActivityConst.ACTIVITY_TYPE_VOTE then
		return pg.activity_vote[tonumber(var1_18)]
	end
end

function var0_0.getDataConfig(arg0_19, arg1_19)
	local var0_19 = arg0_19:getDataConfigTable()

	assert(var0_19, "miss config : " .. arg0_19.id)

	return var0_19 and var0_19[arg1_19]
end

function var0_0.getIslandConfigTable(arg0_20)
	return pg.island_activity_template[arg0_20.configId]
end

function var0_0.getIslandConfig(arg0_21, arg1_21)
	local var0_21 = arg0_21:getIslandConfigTable()

	assert(var0_21, "miss config : " .. arg0_21.id)

	return var0_21 and var0_21[arg1_21] or arg0_21:getConfig(arg1_21)
end

function var0_0.isIslandShow(arg0_22)
	return arg0_22:getIslandConfigTable() and arg0_22:getIslandConfig("is_show") > 0
end

function var0_0.isEnd(arg0_23)
	return arg0_23.stopTime > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_23.stopTime
end

function var0_0.increaseUsedCount(arg0_24, arg1_24)
	if arg1_24 == 1 then
		arg0_24.data1 = arg0_24.data1 + 1
	elseif arg1_24 == 2 then
		arg0_24.data2 = arg0_24.data2 + 1
	end
end

function var0_0.readyToAchieve(arg0_25)
	local var0_25, var1_25 = arg0_25:IsShowTipById()

	if var0_25 then
		return var1_25
	end

	var0_0.readyToAchieveDic = var0_0.readyToAchieveDic or {
		[ActivityConst.ACTIVITY_TYPE_CARD_PAIRS] = function(arg0_26)
			local var0_26 = os.difftime(pg.TimeMgr.GetInstance():GetServerTime(), arg0_26.data3)

			return math.ceil(var0_26 / 86400) > arg0_26.data2 and arg0_26.data2 < arg0_26:getConfig("config_data")[4]
		end,
		[ActivityConst.ACTIVITY_TYPE_LEVELAWARD] = function(arg0_27)
			local var0_27 = getProxy(PlayerProxy):getRawData()
			local var1_27 = pg.activity_level_award[arg0_27:getConfig("config_id")]

			for iter0_27 = 1, #var1_27.front_drops do
				local var2_27 = var1_27.front_drops[iter0_27][1]

				if var2_27 <= var0_27.level and not _.include(arg0_27.data1_list, var2_27) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_CHARGEAWARD] = function(arg0_28)
			return ChargeAwardPage.IsShowTip(arg0_28)
		end,
		[ActivityConst.ACTIVITY_TYPE_STORY_AWARD] = function(arg0_29)
			local var0_29 = getProxy(PlayerProxy):getRawData()
			local var1_29 = pg.activity_event_chapter_award[arg0_29:getConfig("config_id")]

			for iter0_29 = 1, #var1_29.chapter do
				local var2_29 = var1_29.chapter[iter0_29]

				if getProxy(ChapterProxy):isClear(var2_29) and not _.include(arg0_29.data1_list, var2_29) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASKS] = function(arg0_30)
			local var0_30 = arg0_30:getConfig("config_client").subType

			if var0_30 then
				return arg0_30:activityTasksSubTypeFunc(var0_30)
			end

			local var1_30 = getProxy(TaskProxy)
			local var2_30 = _.flatten(arg0_30:getConfig("config_data"))

			if IslandTaskActhelper.IsIslandTaskAct(arg0_30) then
				return IslandTaskActhelper.ShouldTipIslandTask(arg0_30)
			end

			if _.any(var2_30, function(arg0_31)
				local var0_31 = var1_30:getTaskById(arg0_31)

				return var0_31 and var0_31:isFinish() and not var0_31:isReceive()
			end) then
				return true
			end

			local var3_30 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

			if var3_30 and not var3_30:isEnd() and var3_30:getConfig("config_client").linkActID == arg0_30.id and var3_30:readyToAchieve() then
				return true
			end

			if arg0_30:getConfig("config_client") and arg0_30:getConfig("config_client").decodeGameId then
				local var4_30 = arg0_30:getConfig("config_client").decodeGameId
				local var5_30 = getProxy(MiniGameProxy):GetHubByGameId(var4_30)

				if var5_30 then
					local var6_30 = arg0_30:getConfig("config_data")
					local var7_30 = var6_30[#var6_30]
					local var8_30 = _.all(var7_30, function(arg0_32)
						return getProxy(TaskProxy):getFinishTaskById(arg0_32) ~= nil
					end)

					if var5_30.ultimate <= 0 and var8_30 then
						return true
					end
				end
			end

			if arg0_30:getConfig("config_client") and arg0_30:getConfig("config_client").linkTaskPoolAct then
				local var9_30 = arg0_30:getConfig("config_client").linkTaskPoolAct
				local var10_30 = getProxy(ActivityProxy):getActivityById(var9_30)

				if var10_30 and var10_30:readyToAchieve() then
					return true
				end
			end

			if arg0_30:getConfig("config_client") and arg0_30:getConfig("config_client").link_act then
				local var11_30 = arg0_30:getConfig("config_client").link_act
				local var12_30 = getProxy(ActivityProxy):getActivityById(var11_30)

				if var12_30 and var12_30:readyToAchieve() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_LIST] = function(...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_TASKS](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = function(arg0_34)
			local var0_34 = arg0_34:GetCountForHitMonster()

			return not (arg0_34:GetDataConfig("hp") <= arg0_34.data3) and var0_34 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DODGEM] = function(arg0_35)
			local var0_35 = pg.TimeMgr.GetInstance()
			local var1_35 = var0_35:DiffDay(arg0_35.data1, var0_35:GetServerTime()) + 1
			local var2_35 = arg0_35:getConfig("config_id")

			if var2_35 == 1 then
				return arg0_35.data4 == 0 and arg0_35.data2 >= 7 or defaultValue(arg0_35.data2_list[1], 0) > 0 or defaultValue(arg0_35.data2_list[2], 0) > 0 or arg0_35.data2 < math.min(var1_35, 7) or var1_35 > arg0_35.data3
			elseif var2_35 == 2 then
				return arg0_35.data4 == 0 and arg0_35.data2 >= 7 or defaultValue(arg0_35.data2_list[1], 0) > 0 or defaultValue(arg0_35.data2_list[2], 0) > 0 or arg0_35.data2 < math.min(var1_35, 7)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MONOPOLY] = function(arg0_36)
			local var0_36 = arg0_36.data1
			local var1_36 = arg0_36.data1_list[1]
			local var2_36 = arg0_36.data1_list[2]
			local var3_36 = arg0_36.data2_list[1]
			local var4_36 = arg0_36.data2_list[2]
			local var5_36 = pg.TimeMgr.GetInstance():GetServerTime()
			local var6_36 = math.ceil((var5_36 - var0_36) / 86400) * arg0_36:getDataConfig("daily_time") + var1_36 - var2_36
			local var7_36 = var3_36 - var4_36

			return var6_36 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PIZZA_PT] = function(arg0_37)
			local var0_37 = ActivityPtData.New(arg0_37):CanGetAward()
			local var1_37 = true

			if arg0_37:getConfig("config_client") then
				local var2_37 = arg0_37:getConfig("config_client").task_act_id

				if var2_37 and var2_37 ~= 0 and pg.activity_template[var2_37] then
					local var3_37 = pg.activity_template[var2_37]
					local var4_37 = _.flatten(var3_37.config_data)

					if var4_37 and #var4_37 > 0 then
						local var5_37 = getProxy(TaskProxy)

						for iter0_37 = 1, #var4_37 do
							local var6_37 = var5_37:getTaskById(var4_37[iter0_37])

							if var6_37 and var6_37:isFinish() then
								return true
							end
						end
					end
				end
			end

			local var7_37 = false
			local var8_37 = arg0_37:getConfig("config_client").fireworkActID

			if var8_37 and var8_37 ~= 0 then
				local var9_37 = getProxy(ActivityProxy):getActivityById(var8_37)

				var7_37 = var9_37 and var9_37:readyToAchieve() or false
			end

			local var10_37 = arg0_37:getConfig("config_client")[2]
			local var11_37 = type(var10_37) == "number" and ManualSignActivity.IsManualSignActAndAnyAwardCanGet(var10_37)

			return var0_37 and var1_37 or var7_37 or var11_37
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = function(...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_PIZZA_PT](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_RETURN_AWARD] = function(arg0_39)
			local var0_39 = arg0_39.data1

			if var0_39 == 1 then
				local var1_39 = pg.activity_template_headhunting[arg0_39.id]
				local var2_39 = var1_39.target
				local var3_39 = 0

				for iter0_39, iter1_39 in ipairs(arg0_39:getClientList()) do
					var3_39 = var3_39 + iter1_39:getPt()
				end

				local var4_39 = 0

				for iter2_39 = #var2_39, 1, -1 do
					if table.contains(arg0_39.data1_list, var2_39[iter2_39]) then
						var4_39 = iter2_39

						break
					end
				end

				local var5_39 = var1_39.drop_client
				local var6_39 = math.min(var4_39 + 1, #var5_39)
				local var7_39 = _.any(var1_39.tasklist, function(arg0_40)
					local var0_40 = getProxy(TaskProxy):getTaskById(arg0_40)

					return var0_40 and var0_40:isFinish() and not var0_40:isReceive()
				end)

				return var3_39 >= var2_39[var6_39] and var4_39 ~= #var5_39 or var7_39
			elseif var0_39 == 2 then
				local var8_39 = getProxy(TaskProxy)
				local var9_39 = pg.activity_template_returnner[arg0_39.id]

				return _.any(_.flatten(var9_39.task_list), function(arg0_41)
					local var0_41 = var8_39:getTaskById(arg0_41)

					return var0_41 and var0_41:isFinish()
				end)
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_42)
			local var0_42 = getProxy(MiniGameProxy):GetHubByHubId(arg0_42:getConfig("config_id"))

			if var0_42.count > 0 then
				return true
			end

			if var0_42:getConfig("reward") ~= 0 and var0_42.usedtime >= var0_42:getConfig("reward_need") and var0_42.ultimate == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function(arg0_43)
			local var0_43 = pg.activity_event_turning[arg0_43:getConfig("config_id")]
			local var1_43 = arg0_43.data4

			if var1_43 ~= 0 then
				local var2_43 = var0_43.task_table[var1_43]
				local var3_43 = getProxy(TaskProxy)

				for iter0_43, iter1_43 in ipairs(var2_43) do
					if (var3_43:getTaskById(iter1_43) or var3_43:getFinishTaskById(iter1_43)):getTaskStatus() == 1 then
						return true
					end
				end

				local var4_43 = pg.TimeMgr.GetInstance():DiffDay(arg0_43.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var4_43, 1, pg.activity_event_turning[arg0_43:getConfig("config_id")].total_num) > arg0_43.data3 then
					for iter2_43, iter3_43 in ipairs(var2_43) do
						if (var3_43:getTaskById(iter3_43) or var3_43:getFinishTaskById(iter3_43)):getTaskStatus() ~= 2 then
							return false
						end
					end

					return true
				end
			elseif var1_43 == 0 then
				local var5_43 = pg.TimeMgr.GetInstance():DiffDay(arg0_43.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var5_43, 1, pg.activity_event_turning[arg0_43:getConfig("config_id")].total_num) > arg0_43.data3 then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function(arg0_44)
			return not (arg0_44.data2 > 0)
		end,
		[ActivityConst.ACTIVITY_TYPE_SHRINE] = function(arg0_45)
			local var0_45 = arg0_45:getConfig("config_client").story
			local var1_45 = var0_45 and #var0_45 or 7
			local var2_45 = pg.TimeMgr.GetInstance():DiffDay(arg0_45.data3, pg.TimeMgr.GetInstance():GetServerTime()) + 1
			local var3_45 = math.clamp(var2_45, 1, var1_45)

			if var0_45 then
				local var4_45 = pg.NewStoryMgr.GetInstance()
				local var5_45 = math.clamp(arg0_45.data2, 0, var1_45)

				for iter0_45 = 1, var3_45 do
					local var6_45 = var0_45[iter0_45][1]

					if var6_45 and iter0_45 <= var5_45 and not var4_45:IsPlayed(var6_45) then
						return true
					end
				end
			end

			if var1_45 <= var3_45 and var1_45 <= arg0_45.data2 and not (arg0_45.data1 > 0) then
				return true
			end

			if Shrine2022View.IsNeedShowTipForShipCount() then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = function(arg0_46)
			local var0_46 = arg0_46:getConfig("config_client")[3]
			local var1_46 = pg.TimeMgr.GetInstance()
			local var2_46 = var1_46:DiffDay(arg0_46.data3, var1_46:GetServerTime()) + 1 - arg0_46.data2

			return math.clamp(var2_46, 0, #var0_46 - arg0_46.data2) > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function(arg0_47)
			local var0_47 = arg0_47:GetBuildingIds()

			for iter0_47, iter1_47 in ipairs(var0_47) do
				local var1_47 = arg0_47:GetBuildingLevel(iter1_47)
				local var2_47 = pg.activity_event_building[iter1_47]

				if var2_47 and var1_47 < #var2_47.buff then
					local var3_47 = var2_47.material[var1_47]

					if underscore.all(var3_47, function(arg0_48)
						local var0_48 = arg0_48[1]
						local var1_48 = arg0_48[2]
						local var2_48 = arg0_48[3]
						local var3_48 = 0

						if var0_48 == DROP_TYPE_VITEM then
							local var4_48 = AcessWithinNull(Item.getConfigData(var1_48), "link_id")

							assert(var4_48 == arg0_47.id)

							var3_48 = arg0_47:GetMaterialCount(var1_48)
						elseif var0_48 > DROP_TYPE_USE_ACTIVITY_DROP then
							local var5_48 = AcessWithinNull(pg.activity_drop_type[var0_48], "activity_id")

							assert(var5_48)

							bagAct = getProxy(ActivityProxy):getActivityById(var5_48)
							var3_48 = bagAct:getVitemNumber(var1_48)
						end

						return var2_48 <= var3_48
					end) then
						return true
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function(arg0_49, ...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF](arg0_49, ...) or arg0_49:CanRequest()
		end,
		[ActivityConst.ACTIVITY_TYPE_EXPEDITION] = function(arg0_50)
			if arg0_50.data3 > 0 and arg0_50.data1 ~= 0 then
				return true
			else
				for iter0_50 = 1, #arg0_50.data1_list do
					if not bit.band(arg0_50.data1_list[iter0_50], ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
						if bit.band(arg0_50.data1_list[iter0_50], ActivityConst.EXPEDITION_TYPE_OPEN) ~= 0 then
							return true
						elseif bit.band(arg0_50.data1_list[iter0_50], ActivityConst.EXPEDITION_TYPE_BAOXIANG) ~= 0 then
							return true
						elseif bit.band(arg0_50.data1_list[iter0_50], ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 then
							return true
						end
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY] = function(arg0_51)
			local var0_51 = arg0_51:getConfig("config_client")

			if var0_51 and var0_51.linkGameHubID then
				local var1_51 = getProxy(MiniGameProxy):GetHubByHubId(var0_51.linkGameHubID)

				if var1_51 then
					if var0_51.trimRed then
						if var1_51.ultimate == 1 then
							return false
						end

						if var1_51.usedtime == var1_51:getConfig("reward_need") then
							return true
						end
					end

					return var1_51.count > 0
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BB] = function(arg0_52)
			return arg0_52.data2 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = function(arg0_53)
			local var0_53 = arg0_53.data1_list
			local var1_53 = arg0_53.data2_list
			local var2_53 = arg0_53:GetPicturePuzzleIds()
			local var3_53 = arg0_53:getConfig("config_client").linkActID

			if var3_53 then
				local var4_53 = getProxy(ActivityProxy):getActivityById(var3_53)

				if var4_53 and var4_53:readyToAchieve() then
					return true
				end
			end

			if _.any(var2_53, function(arg0_54)
				local var0_54 = table.contains(var1_53, arg0_54)
				local var1_54 = table.contains(var0_53, arg0_54)

				return not var0_54 and var1_54
			end) then
				return true
			end

			local var5_53 = pg.activity_event_picturepuzzle[arg0_53.id]

			if var5_53 and var5_53.chapter > 0 and arg0_53.data1 < 1 then
				return true
			end

			if var5_53 and #var5_53.auto_finish_args > 0 and arg0_53.data1 == 1 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = function(arg0_55)
			return AirFightActivity.readyToAchieve(arg0_55)
		end,
		[ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE] = function(arg0_56)
			local var0_56 = WorldInPictureActiviyData.New(arg0_56)

			return not var0_56:IsTravelAll() and var0_56:GetTravelPoint() > 0 or var0_56:GetDrawPoint() > 0 and var0_56:AnyAreaCanDraw()
		end,
		[ActivityConst.ACTIVITY_TYPE_APRIL_REWARD] = function(arg0_57)
			if arg0_57.data1 == 0 then
				local var0_57 = arg0_57:getStartTime()
				local var1_57 = pg.TimeMgr.GetInstance():GetServerTime()

				if arg0_57:getConfig("config_client").autounlock <= var1_57 - var0_57 then
					return true
				end
			elseif arg0_57.data1 ~= 0 and arg0_57.data2 == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_POOL] = function(arg0_58)
			local var0_58 = arg0_58:getConfig("config_data")
			local var1_58 = getProxy(TaskProxy)

			if arg0_58.data1 >= #var0_58 then
				return false
			end

			local var2_58 = pg.TimeMgr.GetInstance()
			local var3_58 = (var2_58:DiffDay(arg0_58:getStartTime(), var2_58:GetServerTime()) + 1) * arg0_58:getConfig("config_id")

			var3_58 = var3_58 > #var0_58 and #var0_58 or var3_58

			local var4_58 = _.any(var0_58, function(arg0_59)
				local var0_59 = var1_58:getTaskById(arg0_59)

				return var0_59 and var0_59:isFinish()
			end)

			return var3_58 - arg0_58.data1 > 0 and var4_58
		end,
		[ActivityConst.ACTIVITY_TYPE_EVENT] = function(arg0_60)
			local var0_60 = getProxy(PlayerProxy):getData().id

			return PlayerPrefs.GetInt("ACTIVITY_TYPE_EVENT_" .. arg0_60.id .. "_" .. var0_60) == 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_OTHER] = function(arg0_61)
			if arg0_61.data2 and arg0_61.data2 <= 0 and arg0_61.data1 >= pg.activity_event_avatarframe[arg0_61:getConfig("config_id")].target then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = function(arg0_62)
			local var0_62, var1_62 = arg0_62:GetUpgradeCost()

			if arg0_62:GetSlotCount() < arg0_62:GetTotalSlotCount() and var1_62 <= arg0_62:GetCoins() then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function(arg0_63)
			local var0_63 = arg0_63:getConfig("config_data")[2][1]
			local var1_63 = arg0_63:getConfig("config_data")[2][2]
			local var2_63 = getProxy(PlayerProxy):getRawData():getResource(var0_63)

			if arg0_63.data1 > 0 and var1_63 <= var2_63 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD] = function(arg0_64)
			local var0_64 = pg.TimeMgr.GetInstance()

			return var0_64:GetServerTime() >= var0_64:GetTimeToNextTime(math.max(arg0_64.data1, arg0_64.data2))
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND] = function(arg0_65)
			for iter0_65, iter1_65 in pairs(getProxy(SixthAnniversaryIslandProxy):GetNodeDic()) do
				if iter1_65:IsVisual() and iter1_65:RedDotHint() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = function(arg0_66)
			return Spring2Activity.readyToAchieve(arg0_66)
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE] = function(arg0_67)
			local var0_67 = #arg0_67.data2_list
			local var1_67 = arg0_67:getData1List()
			local var2_67 = arg0_67:getConfig("config_data")[2]

			if #var1_67 == #var2_67 then
				return false
			end

			local function var3_67()
				for iter0_68, iter1_68 in ipairs(var2_67) do
					if not table.contains(var1_67, iter1_68[1]) and var0_67 >= iter1_68[1] then
						return true
					end
				end

				return false
			end

			local function var4_67()
				local var0_69 = getProxy(PlayerProxy):getData().id

				return PlayerPrefs.GetInt("DAY_TIP_" .. arg0_67.id .. "_" .. var0_69 .. "_" .. arg0_67:getDayIndex()) == 0
			end

			return var3_67() or var4_67()
		end,
		[ActivityConst.ACTIVITY_TYPE_SURVEY] = function(arg0_70)
			local var0_70, var1_70 = getProxy(ActivityProxy):isSurveyOpen()
			local var2_70 = getProxy(ActivityProxy):isSurveyDone()

			return var0_70 and not var2_70 and not SurveyPage.IsEverEnter(var1_70)
		end,
		[ActivityConst.ACTIVITY_TYPE_ZUMA] = function(arg0_71)
			return LaunchBallActivityMgr.GetInvitationAble(arg0_71.id)
		end,
		[ActivityConst.ACTIVITY_TYPE_GIFT_UP] = function(arg0_72)
			local var0_72 = arg0_72:getConfig("config_client").gifts[2]
			local var1_72 = math.min(#var0_72, arg0_72:getNDay())

			return underscore(var0_72):chain():first(var1_72):any(function(arg0_73)
				local var0_73 = getProxy(ShopsProxy):GetGiftCommodity(arg0_73, Goods.TYPE_GIFT_PACKAGE)

				return var0_73:canPurchase() and var0_73:inTime() and not var0_73:IsGroupLimit()
			end):value()
		end,
		[ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE] = function(arg0_74)
			if getProxy(ShopsProxy):getActivityShops() == nil then
				return false
			end

			local var0_74 = arg0_74:getConfig("config_client")
			local var1_74 = getProxy(PlayerProxy):getData():getResource(var0_74.uPtId)
			local var2_74 = #var0_74.goodsId + 1
			local var3_74 = var2_74 - _.reduce(var0_74.goodsId, 0, function(arg0_75, arg1_75)
				return arg0_75 + getProxy(ShopsProxy):getActivityShopById(var0_74.shopId):GetCommodityById(arg1_75):GetPurchasableCnt()
			end)
			local var4_74 = var3_74 < var2_74 and pg.activity_shop_template[var0_74.goodsId[var3_74]] or nil

			return var3_74 < var2_74 and var1_74 >= var4_74.resource_num
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING] = function(arg0_76)
			return arg0_76:getData1() > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DAILY_STAGE_BONUS] = function(arg0_77)
			return arg0_77:NeedLoginRedPoint()
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_RYZA] = function(arg0_78)
			local var0_78 = getProxy(ActivityTaskProxy):getTaskById(arg0_78.id)

			for iter0_78, iter1_78 in ipairs(var0_78) do
				if iter1_78:getTaskStatus() == 1 then
					return true
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_79)
			local var0_79 = arg0_79:getConfig("config_id")

			if getProxy(MiniGameProxy):GetHubByHubId(var0_79).count > 0 then
				return true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function(arg0_80)
			local var0_80 = arg0_80:getConfig("config_id")
			local var1_80 = pg.activity_7_day_sign[var0_80].front_drops
			local var2_80 = pg.TimeMgr.GetInstance()
			local var3_80 = var2_80:GetServerTime()

			return arg0_80.data1 < #var1_80 and not var2_80:IsSameDay(var3_80, arg0_80.data2) and var3_80 > arg0_80.data2
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_HEI5] = function(arg0_81)
			return #arg0_81:GetHei5UnreceiveAward() > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_TownSkinStory] = function(arg0_82)
			local var0_82 = pg.NewStoryMgr.GetInstance()

			if arg0_82.data1 > 0 and underscore.any(arg0_82:GetConfigClientSetting("story"), function(arg0_83)
				return not var0_82:IsPlayed(arg0_83[1])
			end) then
				return true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN] = function(arg0_84)
			return arg0_84:CanGetAward() or not arg0_84:TodayIsSigned()
		end,
		[ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_MAIL] = function(arg0_85)
			return getProxy(PlayerProxy):getRawData().level >= arg0_85:getConfig("config_id") and arg0_85.data1 == 0
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND_GAME_PT] = function(arg0_86)
			local var0_86 = pg.island_activity_pt_page[arg0_86:getIslandConfig("config_id")].task_id
			local var1_86 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

			return IslandGamePtTemplatePage.ShouldFirstTip(arg0_86.id) or _.any(var0_86, function(arg0_87)
				local var0_87 = var1_86:GetTask(arg0_87)

				return var0_87 and var0_87:IsFinish() and not var1_86:IsFinishTask(arg0_87)
			end)
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND_CHEATE_TAVERN] = function(arg0_88)
			local var0_88 = getProxy(ActivityTaskProxy):getTaskById(ActivityConst.ISLAND_BAR_ACT_ID)

			for iter0_88, iter1_88 in ipairs(var0_88) do
				if iter1_88:getTaskStatus() == 1 then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN] = function(arg0_89)
			print("TODO: 红点功能")

			return false
		end
	}

	if switch(arg0_25:getConfig("type"), var0_0.readyToAchieveDic, nil, arg0_25) then
		return true
	elseif arg0_25:getConfig("config_client").sub_act_id then
		local var2_25 = getProxy(ActivityProxy):getActivityById(arg0_25:getConfig("config_client").sub_act_id)

		return var2_25 and not var2_25:isEnd() and var2_25:readyToAchieve()
	elseif arg0_25:getConfig("config_client").is_showMedal then
		local var3_25 = arg0_25:getConfig("config_client").medal_group_id

		return ActivityMedalGroup.showTip(var3_25)
	elseif arg0_25:getConfig("config_client").is_clickOnce then
		local var4_25 = arg0_25:getConfig("id")
		local var5_25 = Activity.GetPlayerActivyIDKey(arg0_25:getConfig("id"))

		return PlayerPrefs.GetInt(var5_25, 0) == 0
	else
		return false
	end
end

function var0_0.IsShowTipById(arg0_90)
	var0_0.ShowTipTableById = var0_0.ShowTipTableById or {
		[ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE] = function(arg0_91)
			local var0_91 = getProxy(SkirmishProxy)

			var0_91:UpdateSkirmishProgress()

			local var1_91 = var0_91:getRawData()
			local var2_91 = 0
			local var3_91 = 0

			for iter0_91, iter1_91 in ipairs(var1_91) do
				local var4_91 = iter1_91:GetState()

				var2_91 = var4_91 > SkirmishVO.StateInactive and var2_91 + 1 or var2_91
				var3_91 = var4_91 == SkirmishVO.StateClear and var3_91 + 1 or var3_91
			end

			return var3_91 < var2_91
		end,
		[ActivityConst.POCKY_SKIN_LOGIN] = function(arg0_92)
			local var0_92 = arg0_92:getConfig("config_client").linkids
			local var1_92 = getProxy(TaskProxy)
			local var2_92 = getProxy(ActivityProxy)
			local var3_92 = var2_92:getActivityById(var0_92[1])
			local var4_92 = var2_92:getActivityById(var0_92[2])
			local var5_92 = var2_92:getActivityById(var0_92[3])

			assert(var3_92 and var4_92 and var5_92)

			local function var6_92()
				return var3_92 and var3_92:readyToAchieve()
			end

			local function var7_92()
				return var4_92 and var4_92:readyToAchieve()
			end

			local function var8_92()
				local var0_95 = _.flatten(arg0_92:getConfig("config_data"))

				for iter0_95 = 1, math.min(#var0_95, var4_92.data3) do
					local var1_95 = var0_95[iter0_95]
					local var2_95 = var1_92:getTaskById(var1_95)

					if var2_95 and var2_95:isFinish() and not var2_95:isReceive() then
						return true
					end
				end
			end

			local function var9_92()
				if not (var5_92 and var5_92:readyToAchieve()) or not var3_92 then
					return false
				end

				local var0_96 = ActivityPtData.New(var3_92)

				return var0_96.level >= #var0_96.targets
			end

			return var8_92() or var6_92() or var7_92() or var9_92()
		end,
		[ActivityConst.TOWERCLIMBING_SIGN] = function(arg0_97)
			local var0_97 = getProxy(MiniGameProxy):GetHubByHubId(9)
			local var1_97 = var0_97.ultimate
			local var2_97 = var0_97:getConfig("reward_need")
			local var3_97 = var0_97.usedtime

			return var1_97 == 0 and var2_97 <= var3_97
		end,
		[pg.activity_const.NEWYEAR_SNACK_PAGE_ID.act_id] = NewYearSnackPage.IsTip,
		[ActivityConst.WWF_TASK_ID] = WWFPtPage.IsShowRed,
		[ActivityConst.NEWMEIXIV4_SKIRMISH_ID] = NewMeixiV4SkirmishPage.IsShowRed,
		[ActivityConst.JIUJIU_YOYO_ID] = JiujiuYoyoPage.IsShowRed,
		[ActivityConst.SENRANKAGURA_TRAIN_ACT_ID] = SenrankaguraTrainScene.IsShowRed,
		[ActivityConst.DORM_SIGN_ID] = DormSignPage.IsShowRed,
		[ActivityConst.DORM_SIGN_ID_2] = DormSignTwoPage.IsShowRed,
		[ActivityConst.DORM_SIGN_ID_3] = DormSignThirdPage.IsShowRed,
		[ActivityConst.ISLAND_SIGN_ID] = IslandSignPage.IsShowRed,
		[ActivityConst.GOASTSTORYACTIVITY_ID] = GhostSkinPageLayer.IsShowRed,
		[ActivityConst.YUMIA_BASE_ACT_ID] = YoumiyaStrongholdLayer.ShouldShowTip,
		[ActivityConst.NINJA_CITY_MAIN_ACTIVITY_ID] = function(arg0_98)
			if CityRebuildBookLayer.ShouldShowTip() or CityRebuildTasksLayer.ShouldShowTip() then
				return true
			end

			return false
		end,
		[ActivityConst.MALL_MAIN_ACTIVITY_ID] = function(arg0_99)
			return AnniversaryNineMainPage.IsTip()
		end,
		[ActivityConst.SAILING_SHIP_3_SKIN_ACT_ID] = SailingShip3SkinLayer.ShouldShowTip,
		[ActivityConst.HelenaPT_ACT_ID] = function(arg0_100)
			return HelenaScenarioPage:IsShowRed(arg0_100)
		end,
		[ActivityConst.LOVE_LETTER_LOGIN_ID] = function(arg0_101)
			local var0_101 = arg0_101:getNDay()

			for iter0_101 = 1, var0_101 do
				local var1_101 = arg0_101:getConfig("config_data")[iter0_101]
				local var2_101 = var1_101 and getProxy(TaskProxy):getTaskVO(var1_101) or nil

				if var2_101 and var2_101:getTaskStatus() == 1 then
					return true
				end
			end

			return false
		end
	}

	local var0_90 = var0_0.ShowTipTableById[arg0_90.id]

	return tobool(var0_90), var0_90 and var0_90(arg0_90)
end

function var0_0.activityTasksSubTypeFunc(arg0_102, arg1_102)
	if arg1_102 == 1 then
		local var0_102 = 1
		local var1_102 = getProxy(TaskProxy)
		local var2_102 = arg0_102:getConfig("config_client").unlock_task
		local var3_102 = arg0_102:getNDay()
		local var4_102 = #var2_102
		local var5_102 = math.min(var3_102, var4_102)
		local var6_102 = true

		for iter0_102 = 1, var5_102 do
			if not var6_102 then
				break
			end

			var0_102 = iter0_102

			if iter0_102 < var5_102 then
				for iter1_102, iter2_102 in ipairs(var2_102[iter0_102]) do
					local var7_102 = var1_102:getTaskById(iter2_102) or var1_102:getFinishTaskById(iter2_102)

					if not var7_102 or var7_102:getTaskStatus() ~= 2 then
						var6_102 = false

						break
					end
				end
			end
		end

		local var8_102 = math.min(var0_102, var4_102)

		for iter3_102, iter4_102 in ipairs(var2_102[var8_102]) do
			local var9_102 = var1_102:getTaskById(iter4_102) or var1_102:getFinishTaskById(iter4_102)

			if not var9_102 then
				return false
			end

			if var9_102:getTaskStatus() == 1 then
				return true
			end
		end
	end

	if arg1_102 == TASK_SUB_TYPE_CLIENT_TRIGGER then
		local var10_102, var11_102 = getActivityTask(arg0_102, true)

		return var10_102 and (not var11_102 or var11_102:getTaskStatus() ~= 2)
	end

	return false
end

function var0_0.isShow(arg0_103)
	if LOCK_SKIN_US then
		local var0_103 = pg.gameset.levellimit_skinstory.key_value
		local var1_103 = pg.gameset.levellimit_skinstory.description

		if var0_103 >= getProxy(PlayerProxy):getRawData().level and table.contains(var1_103, arg0_103.id) then
			return false
		end
	end

	local var2_103 = arg0_103:getConfig("page_info")

	if arg0_103:getConfig("is_show") <= 0 then
		return false
	elseif underscore.any({
		var2_103.ui_name,
		var2_103.ui_name2
	}, function(arg0_104)
		return not checkABExist(string.format("ui/%s", arg0_104))
	end) then
		warning(string.format("activity:%d without ui:%s", arg0_103.id, table.concat({
			var2_103.ui_name,
			var2_103.ui_name2
		}, " or ")))

		return false
	end

	if arg0_103:getConfig("type") == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		return arg0_103.data1 ~= 0
	elseif arg0_103:getConfig("type") == ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY then
		local var3_103 = arg0_103:getConfig("config_client").display_link

		if var3_103 then
			return underscore.any(var3_103, function(arg0_105)
				return arg0_105[2] == 0 or pg.TimeMgr.GetInstance():inTime(ShopConst.GetShopConfig(arg0_105[2]).time)
			end)
		end
	elseif arg0_103:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SURVEY then
		local var4_103 = getProxy(ActivityProxy)
		local var5_103 = var4_103:isSurveyOpen()
		local var6_103 = var4_103:isSurveyDone()

		return var5_103 and not var6_103
	elseif arg0_103:getConfig("type") == ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE then
		if getProxy(ShopsProxy):getActivityShops() == nil then
			return false
		end

		local var7_103 = arg0_103:getConfig("config_client")
		local var8_103 = getProxy(PlayerProxy):getData():getResource(var7_103.uPtId)
		local var9_103 = #var7_103.goodsId + 1

		return var9_103 > var9_103 - _.reduce(var7_103.goodsId, 0, function(arg0_106, arg1_106)
			return arg0_106 + getProxy(ShopsProxy):getActivityShopById(var7_103.shopId):GetCommodityById(arg1_106):GetPurchasableCnt()
		end)
	elseif arg0_103:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_RYZA and table.contains({
		ActivityConst.DORM_SIGN_ID,
		ActivityConst.DORM_SIGN_ID_2,
		ActivityConst.DORM_SIGN_ID_3
	}, arg0_103:getConfig("id")) then
		return #getProxy(ActivityProxy):getActivityById(arg0_103:getConfig("id")):getConfig("config_data") ~= #getProxy(ActivityTaskProxy):getFinishTaskById(arg0_103:getConfig("id"))
	end

	return true
end

function var0_0.isAfterShow(arg0_107)
	if arg0_107.configId == ActivityConst.ISLAND_SIGN_ID then
		local var0_107 = _.flatten(arg0_107:getConfig("config_data"))
		local var1_107 = getProxy(ActivityTaskProxy):GetActivityTasks(arg0_107.id)

		return _.all(var0_107, function(arg0_108)
			local var0_108 = var1_107[arg0_108]

			return var0_108 and var0_108:isOver()
		end)
	end

	if arg0_107.configId == ActivityConst.UR_TASK_ACT_ID or arg0_107.configId == ActivityConst.SPECIAL_WEAPON_ACT_ID then
		local var2_107 = getProxy(TaskProxy)

		return underscore.all(arg0_107:getConfig("config_data")[1], function(arg0_109)
			local var0_109 = var2_107:getTaskVO(arg0_109)

			return var0_109 and var0_109:isReceive()
		end)
	end

	return false
end

function var0_0.getShowPriority(arg0_110)
	return arg0_110:getConfig("is_show")
end

function var0_0.isCorePage(arg0_111, arg1_111)
	return arg0_111:getConfig("page_core") == arg1_111
end

function var0_0.left4Day(arg0_112)
	if arg0_112.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 345600 then
		return true
	end

	return false
end

function var0_0.getAwardInfos(arg0_113)
	return arg0_113.data1KeyValueList or {}
end

function var0_0.updateData(arg0_114, arg1_114, arg2_114)
	if arg0_114:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if not arg0_114:getAwardInfos()[arg1_114] then
			arg0_114.data1KeyValueList[arg1_114] = {}
		end

		for iter0_114, iter1_114 in ipairs(arg2_114) do
			if arg0_114.data1KeyValueList[arg1_114][iter1_114] then
				arg0_114.data1KeyValueList[arg1_114][iter1_114] = arg0_114.data1KeyValueList[arg1_114][iter1_114] + 1
			else
				arg0_114.data1KeyValueList[arg1_114][iter1_114] = 1
			end
		end
	end
end

function var0_0.getTaskShip(arg0_115)
	return arg0_115:getConfig("config_client")[1]
end

function var0_0.getNotificationMsg(arg0_116)
	local var0_116 = arg0_116:getConfig("type")
	local var1_116 = ActivityProxy.ACTIVITY_SHOW_AWARDS

	if var0_116 == ActivityConst.ACTIVITY_TYPE_SHOP or var0_116 == ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE or var0_116 == ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE then
		var1_116 = ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS
	elseif var0_116 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		var1_116 = ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS
	elseif var0_116 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		var1_116 = ActivityProxy.ACTIVITY_SHOW_REFLUX_AWARDS
	elseif var0_116 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS or var0_116 == ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER then
		var1_116 = ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS
	end

	return var1_116
end

function var0_0.getDayIndex(arg0_117)
	local var0_117 = arg0_117:getStartTime()
	local var1_117 = pg.TimeMgr.GetInstance()
	local var2_117 = var1_117:GetServerTime()

	return var1_117:DiffDay(var0_117, var2_117) + 1
end

function var0_0.getStartTime(arg0_118)
	local var0_118, var1_118 = parseTimeConfig(arg0_118:getConfig("time"))

	if var1_118 and var1_118[1] == "newuser" then
		return arg0_118.stopTime - var1_118[3] * 86400
	else
		return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_118[2])
	end
end

function var0_0.getNDay(arg0_119, arg1_119)
	arg1_119 = arg1_119 or arg0_119:getStartTime()

	local var0_119 = pg.TimeMgr.GetInstance()

	return var0_119:DiffDay(arg1_119, var0_119:GetServerTime()) + 1
end

function var0_0.isVariableTime(arg0_120)
	local var0_120, var1_120 = parseTimeConfig(arg0_120:getConfig("time"))

	return var1_120 and var1_120[1] == "newuser"
end

function var0_0.setSpecialData(arg0_121, arg1_121, arg2_121)
	arg0_121.speciaData = arg0_121.speciaData and arg0_121.speciaData or {}
	arg0_121.speciaData[arg1_121] = arg2_121
end

function var0_0.getSpecialData(arg0_122, arg1_122)
	return arg0_122.speciaData and arg0_122.speciaData[arg1_122] and arg0_122.speciaData[arg1_122] or nil
end

function var0_0.canPermanentFinish(arg0_123)
	local var0_123 = arg0_123:getConfig("type")

	if var0_123 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		local var1_123 = arg0_123:getConfig("config_data")
		local var2_123 = getProxy(TaskProxy)

		return underscore.all(underscore.flatten({
			var1_123[#var1_123]
		}), function(arg0_124)
			return var2_123:getFinishTaskById(arg0_124) ~= nil
		end)
	elseif var0_123 == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		local var3_123 = ActivityPtData.New(arg0_123)

		return var3_123.level >= #var3_123.targets
	end

	return false
end

function var0_0.GetShopTime(arg0_125)
	local var0_125 = pg.TimeMgr.GetInstance()
	local var1_125 = arg0_125:getStartTime()
	local var2_125 = arg0_125.stopTime

	return var0_125:STimeDescS(var1_125, "%y.%m.%d") .. " - " .. var0_125:STimeDescS(var2_125, "%y.%m.%d")
end

function var0_0.GetCrusingUnreceiveAward(arg0_126)
	assert(arg0_126:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_126 = pg.battlepass_event_pt[arg0_126.id]
	local var1_126 = {}
	local var2_126 = {}

	for iter0_126, iter1_126 in ipairs(arg0_126.data1_list) do
		var2_126[iter1_126] = true
	end

	for iter2_126, iter3_126 in ipairs(var0_126.target) do
		if iter3_126 > arg0_126.data1 then
			break
		elseif not var2_126[iter3_126] then
			table.insert(var1_126, Drop.Create(pg.battlepass_event_award[var0_126.award[iter2_126]].drop_client))
		end
	end

	if arg0_126.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1_126)
	end

	local var3_126 = {}

	for iter4_126, iter5_126 in ipairs(arg0_126.data2_list) do
		var3_126[iter5_126] = true
	end

	for iter6_126, iter7_126 in ipairs(var0_126.target) do
		if iter7_126 > arg0_126.data1 then
			break
		elseif not var3_126[iter7_126] then
			table.insert(var1_126, Drop.Create(pg.battlepass_event_award[var0_126.award_pay[iter6_126]].drop_client))
		end
	end

	return PlayerConst.MergePassItemDrop(var1_126)
end

function var0_0.GetCrusingInfo(arg0_127)
	assert(arg0_127:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_127 = pg.battlepass_event_pt[arg0_127.id]
	local var1_127 = var0_127.pt
	local var2_127 = {}
	local var3_127 = {}

	for iter0_127, iter1_127 in ipairs(var0_127.key_point_display) do
		var3_127[iter1_127] = true
	end

	for iter2_127, iter3_127 in ipairs(var0_127.target) do
		table.insert(var2_127, {
			id = iter2_127,
			pt = iter3_127,
			award = pg.battlepass_event_award[var0_127.award[iter2_127]].drop_client,
			award_pay = pg.battlepass_event_award[var0_127.award_pay[iter2_127]].drop_client,
			isImportent = var3_127[iter2_127]
		})
	end

	local var4_127 = arg0_127.data1
	local var5_127 = arg0_127.data2 == 1
	local var6_127 = {}

	for iter4_127, iter5_127 in ipairs(arg0_127.data1_list) do
		var6_127[iter5_127] = true
	end

	local var7_127 = {}

	for iter6_127, iter7_127 in ipairs(arg0_127.data2_list) do
		var7_127[iter7_127] = true
	end

	local var8_127 = 0

	for iter8_127, iter9_127 in ipairs(var2_127) do
		if var4_127 < iter9_127.pt then
			break
		else
			var8_127 = iter8_127
		end
	end

	return {
		ptId = var1_127,
		awardList = var2_127,
		pt = var4_127,
		isPay = var5_127,
		awardDic = var6_127,
		awardPayDic = var7_127,
		phase = var8_127
	}
end

function var0_0.GetHei5Info(arg0_128)
	local var0_128 = pg.black_friday_battlepass_event_pt[arg0_128.id]
	local var1_128 = var0_128.pt
	local var2_128 = {}
	local var3_128 = {}

	for iter0_128, iter1_128 in ipairs(var0_128.key_point_display) do
		var3_128[iter1_128] = true
	end

	for iter2_128, iter3_128 in ipairs(var0_128.target) do
		table.insert(var2_128, {
			id = iter2_128,
			pt = iter3_128,
			award = pg.black_friday_battlepass_event_award[var0_128.award[iter2_128]].drop_client,
			award_pay = pg.black_friday_battlepass_event_award[var0_128.award_pay[iter2_128]].drop_client,
			isImportent = var3_128[iter2_128]
		})
	end

	local var4_128 = arg0_128.data1
	local var5_128 = arg0_128.data2 == 1
	local var6_128 = {}

	for iter4_128, iter5_128 in ipairs(arg0_128.data1_list) do
		var6_128[iter5_128] = true
	end

	local var7_128 = {}

	for iter6_128, iter7_128 in ipairs(arg0_128.data2_list) do
		var7_128[iter7_128] = true
	end

	local var8_128 = 0

	for iter8_128, iter9_128 in ipairs(var2_128) do
		if var4_128 < iter9_128.pt then
			break
		else
			var8_128 = iter8_128
		end
	end

	return {
		ptId = var1_128,
		awardList = var2_128,
		pt = var4_128,
		isPay = var5_128,
		awardDic = var6_128,
		awardPayDic = var7_128,
		phase = var8_128
	}
end

function var0_0.GetHei5UnreceiveAward(arg0_129)
	local var0_129 = pg.black_friday_battlepass_event_pt[arg0_129.id]
	local var1_129 = {}
	local var2_129 = {}

	for iter0_129, iter1_129 in ipairs(arg0_129.data1_list) do
		var2_129[iter1_129] = true
	end

	for iter2_129, iter3_129 in ipairs(var0_129.target) do
		if iter3_129 > arg0_129.data1 then
			break
		elseif not var2_129[iter3_129] then
			table.insert(var1_129, Drop.Create(pg.black_friday_battlepass_event_award[var0_129.award[iter2_129]].drop_client))
		end
	end

	if arg0_129.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1_129)
	end

	local var3_129 = {}

	for iter4_129, iter5_129 in ipairs(arg0_129.data2_list) do
		var3_129[iter5_129] = true
	end

	for iter6_129, iter7_129 in ipairs(var0_129.target) do
		if iter7_129 > arg0_129.data1 then
			break
		elseif not var3_129[iter7_129] then
			table.insert(var1_129, Drop.Create(pg.black_friday_battlepass_event_award[var0_129.award_pay[iter6_129]].drop_client))
		end
	end

	return PlayerConst.MergePassItemDrop(var1_129)
end

function var0_0.IsActivityReady(arg0_130)
	return arg0_130 and not arg0_130:isEnd() and arg0_130:readyToAchieve()
end

function var0_0.NeedLoginRedPoint(arg0_131)
	return PlayerPrefs.GetString(arg0_131:GetLoginRedPointKey(), "") ~= arg0_131:GetLoginRedPointValue()
end

function var0_0.SetLoginRedPoint(arg0_132)
	PlayerPrefs.SetString(arg0_132:GetLoginRedPointKey(), arg0_132:GetLoginRedPointValue())
end

function var0_0.GetLoginRedPointValue(arg0_133)
	return pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
end

function var0_0.GetLoginRedPointKey(arg0_134)
	local var0_134 = arg0_134:GetPlayerID()

	return string.format("%s_%s", var0_134, arg0_134.id)
end

function var0_0.GetPlayerID(arg0_135)
	return getProxy(PlayerProxy):getPlayerId()
end

function var0_0.GetConfigClientSetting(arg0_136, arg1_136)
	return arg0_136:getConfig("config_client")[arg1_136]
end

function var0_0.IsMaintenanceFinish(arg0_137)
	return not arg0_137:GetConfigClientSetting("no_maintenance")
end

function var0_0.GetPlayerActivyIDKey(arg0_138)
	local var0_138 = getProxy(PlayerProxy):getPlayerId()

	return "Activity_PlayerPrefs_PlayerId_" .. var0_138 .. "ActivityID_" .. arg0_138
end

return var0_0
