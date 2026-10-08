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
		[ActivityConst.ACTIVITY_TYPE_PT_CRUSING] = CrusingActivity,
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
		[ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN] = ReversePacmanActivity,
		[ActivityConst.ACTIVITY_TYPE_PT_RANK] = PTRankActivity,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = PTBuffActivity,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF_MARK2] = PTBuffActivity,
		[ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE] = URExchangeActivity
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
	elseif var0_18 == ActivityConst.ACTIVITY_TYPE_PIZZA_PT or var0_18 == ActivityConst.ACTIVITY_TYPE_PT_BUFF or var0_18 == ActivityConst.ACTIVITY_TYPE_PT_BUFF_MARK2 then
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
		[ActivityConst.ACTIVITY_TYPE_TASK_LIST] = ActivityConst.ACTIVITY_TYPE_TASKS,
		[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = function(arg0_33)
			local var0_33 = arg0_33:GetCountForHitMonster()

			return not (arg0_33:GetDataConfig("hp") <= arg0_33.data3) and var0_33 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DODGEM] = function(arg0_34)
			local var0_34 = pg.TimeMgr.GetInstance()
			local var1_34 = var0_34:DiffDay(arg0_34.data1, var0_34:GetServerTime()) + 1
			local var2_34 = arg0_34:getConfig("config_id")

			if var2_34 == 1 then
				return arg0_34.data4 == 0 and arg0_34.data2 >= 7 or defaultValue(arg0_34.data2_list[1], 0) > 0 or defaultValue(arg0_34.data2_list[2], 0) > 0 or arg0_34.data2 < math.min(var1_34, 7) or var1_34 > arg0_34.data3
			elseif var2_34 == 2 then
				return arg0_34.data4 == 0 and arg0_34.data2 >= 7 or defaultValue(arg0_34.data2_list[1], 0) > 0 or defaultValue(arg0_34.data2_list[2], 0) > 0 or arg0_34.data2 < math.min(var1_34, 7)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MONOPOLY] = function(arg0_35)
			local var0_35 = arg0_35.data1
			local var1_35 = arg0_35.data1_list[1]
			local var2_35 = arg0_35.data1_list[2]
			local var3_35 = arg0_35.data2_list[1]
			local var4_35 = arg0_35.data2_list[2]
			local var5_35 = pg.TimeMgr.GetInstance():GetServerTime()
			local var6_35 = math.ceil((var5_35 - var0_35) / 86400) * arg0_35:getDataConfig("daily_time") + var1_35 - var2_35
			local var7_35 = var3_35 - var4_35

			return var6_35 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PIZZA_PT] = function(arg0_36)
			local var0_36 = ActivityPtData.New(arg0_36):CanGetAward()
			local var1_36 = true

			if arg0_36:getConfig("config_client") then
				local var2_36 = arg0_36:getConfig("config_client").task_act_id

				if var2_36 and var2_36 ~= 0 and pg.activity_template[var2_36] then
					local var3_36 = pg.activity_template[var2_36]
					local var4_36 = _.flatten(var3_36.config_data)

					if var4_36 and #var4_36 > 0 then
						local var5_36 = getProxy(TaskProxy)

						for iter0_36 = 1, #var4_36 do
							local var6_36 = var5_36:getTaskById(var4_36[iter0_36])

							if var6_36 and var6_36:isFinish() then
								return true
							end
						end
					end
				end
			end

			local var7_36 = false
			local var8_36 = arg0_36:getConfig("config_client").fireworkActID

			if var8_36 and var8_36 ~= 0 then
				local var9_36 = getProxy(ActivityProxy):getActivityById(var8_36)

				var7_36 = var9_36 and var9_36:readyToAchieve() or false
			end

			local var10_36 = arg0_36:getConfig("config_client")[2]
			local var11_36 = type(var10_36) == "number" and ManualSignActivity.IsManualSignActAndAnyAwardCanGet(var10_36)

			return var0_36 and var1_36 or var7_36 or var11_36
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = ActivityConst.ACTIVITY_TYPE_PIZZA_PT,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF_MARK2] = ActivityConst.ACTIVITY_TYPE_PIZZA_PT,
		[ActivityConst.ACTIVITY_TYPE_RETURN_AWARD] = function(arg0_37)
			local var0_37 = arg0_37.data1

			if var0_37 == 1 then
				local var1_37 = pg.activity_template_headhunting[arg0_37.id]
				local var2_37 = var1_37.target
				local var3_37 = 0

				for iter0_37, iter1_37 in ipairs(arg0_37:getClientList()) do
					var3_37 = var3_37 + iter1_37:getPt()
				end

				local var4_37 = 0

				for iter2_37 = #var2_37, 1, -1 do
					if table.contains(arg0_37.data1_list, var2_37[iter2_37]) then
						var4_37 = iter2_37

						break
					end
				end

				local var5_37 = var1_37.drop_client
				local var6_37 = math.min(var4_37 + 1, #var5_37)
				local var7_37 = _.any(var1_37.tasklist, function(arg0_38)
					local var0_38 = getProxy(TaskProxy):getTaskById(arg0_38)

					return var0_38 and var0_38:isFinish() and not var0_38:isReceive()
				end)

				return var3_37 >= var2_37[var6_37] and var4_37 ~= #var5_37 or var7_37
			elseif var0_37 == 2 then
				local var8_37 = getProxy(TaskProxy)
				local var9_37 = pg.activity_template_returnner[arg0_37.id]

				return _.any(_.flatten(var9_37.task_list), function(arg0_39)
					local var0_39 = var8_37:getTaskById(arg0_39)

					return var0_39 and var0_39:isFinish()
				end)
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_40)
			local var0_40 = getProxy(MiniGameProxy):GetHubByHubId(arg0_40:getConfig("config_id"))

			if var0_40.count > 0 then
				return true
			end

			if var0_40:getConfig("reward") ~= 0 and var0_40.usedtime >= var0_40:getConfig("reward_need") and var0_40.ultimate == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function(arg0_41)
			local var0_41 = pg.activity_event_turning[arg0_41:getConfig("config_id")]
			local var1_41 = arg0_41.data4

			if var1_41 ~= 0 then
				local var2_41 = var0_41.task_table[var1_41]
				local var3_41 = getProxy(TaskProxy)

				for iter0_41, iter1_41 in ipairs(var2_41) do
					if (var3_41:getTaskById(iter1_41) or var3_41:getFinishTaskById(iter1_41)):getTaskStatus() == 1 then
						return true
					end
				end

				local var4_41 = pg.TimeMgr.GetInstance():DiffDay(arg0_41.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var4_41, 1, pg.activity_event_turning[arg0_41:getConfig("config_id")].total_num) > arg0_41.data3 then
					for iter2_41, iter3_41 in ipairs(var2_41) do
						if (var3_41:getTaskById(iter3_41) or var3_41:getFinishTaskById(iter3_41)):getTaskStatus() ~= 2 then
							return false
						end
					end

					return true
				end
			elseif var1_41 == 0 then
				local var5_41 = pg.TimeMgr.GetInstance():DiffDay(arg0_41.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var5_41, 1, pg.activity_event_turning[arg0_41:getConfig("config_id")].total_num) > arg0_41.data3 then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function(arg0_42)
			return not (arg0_42.data2 > 0)
		end,
		[ActivityConst.ACTIVITY_TYPE_SHRINE] = function(arg0_43)
			local var0_43 = arg0_43:getConfig("config_client").story
			local var1_43 = var0_43 and #var0_43 or 7
			local var2_43 = pg.TimeMgr.GetInstance():DiffDay(arg0_43.data3, pg.TimeMgr.GetInstance():GetServerTime()) + 1
			local var3_43 = math.clamp(var2_43, 1, var1_43)

			if var0_43 then
				local var4_43 = pg.NewStoryMgr.GetInstance()
				local var5_43 = math.clamp(arg0_43.data2, 0, var1_43)

				for iter0_43 = 1, var3_43 do
					local var6_43 = var0_43[iter0_43][1]

					if var6_43 and iter0_43 <= var5_43 and not var4_43:IsPlayed(var6_43) then
						return true
					end
				end
			end

			if var1_43 <= var3_43 and var1_43 <= arg0_43.data2 and not (arg0_43.data1 > 0) then
				return true
			end

			if Shrine2022View.IsNeedShowTipForShipCount() then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = function(arg0_44)
			local var0_44 = arg0_44:getConfig("config_client")[3]
			local var1_44 = pg.TimeMgr.GetInstance()
			local var2_44 = var1_44:DiffDay(arg0_44.data3, var1_44:GetServerTime()) + 1 - arg0_44.data2

			return math.clamp(var2_44, 0, #var0_44 - arg0_44.data2) > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function(arg0_45)
			local var0_45 = arg0_45:GetBuildingIds()

			for iter0_45, iter1_45 in ipairs(var0_45) do
				local var1_45 = arg0_45:GetBuildingLevel(iter1_45)
				local var2_45 = pg.activity_event_building[iter1_45]

				if var2_45 and var1_45 < #var2_45.buff then
					local var3_45 = var2_45.material[var1_45]

					if underscore.all(var3_45, function(arg0_46)
						local var0_46 = arg0_46[1]
						local var1_46 = arg0_46[2]
						local var2_46 = arg0_46[3]
						local var3_46 = 0

						if var0_46 == DROP_TYPE_VITEM then
							local var4_46 = AcessWithinNull(Item.getConfigData(var1_46), "link_id")

							assert(var4_46 == arg0_45.id)

							var3_46 = arg0_45:GetMaterialCount(var1_46)
						elseif var0_46 > DROP_TYPE_USE_ACTIVITY_DROP then
							local var5_46 = AcessWithinNull(pg.activity_drop_type[var0_46], "activity_id")

							assert(var5_46)

							bagAct = getProxy(ActivityProxy):getActivityById(var5_46)
							var3_46 = bagAct:getVitemNumber(var1_46)
						end

						return var2_46 <= var3_46
					end) then
						return true
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function(arg0_47, ...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF](arg0_47, ...) or arg0_47:CanRequest()
		end,
		[ActivityConst.ACTIVITY_TYPE_EXPEDITION] = function(arg0_48)
			if arg0_48.data3 > 0 and arg0_48.data1 ~= 0 then
				return true
			else
				for iter0_48 = 1, #arg0_48.data1_list do
					if not bit.band(arg0_48.data1_list[iter0_48], ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
						if bit.band(arg0_48.data1_list[iter0_48], ActivityConst.EXPEDITION_TYPE_OPEN) ~= 0 then
							return true
						elseif bit.band(arg0_48.data1_list[iter0_48], ActivityConst.EXPEDITION_TYPE_BAOXIANG) ~= 0 then
							return true
						elseif bit.band(arg0_48.data1_list[iter0_48], ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 then
							return true
						end
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY] = function(arg0_49)
			local var0_49 = arg0_49:getConfig("config_client")

			if var0_49 and var0_49.linkGameHubID then
				local var1_49 = getProxy(MiniGameProxy):GetHubByHubId(var0_49.linkGameHubID)

				if var1_49 then
					if var0_49.trimRed then
						if var1_49.ultimate == 1 then
							return false
						end

						if var1_49.usedtime == var1_49:getConfig("reward_need") then
							return true
						end
					end

					return var1_49.count > 0
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BB] = function(arg0_50)
			return arg0_50.data2 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = function(arg0_51)
			local var0_51 = arg0_51.data1_list
			local var1_51 = arg0_51.data2_list
			local var2_51 = arg0_51:GetPicturePuzzleIds()
			local var3_51 = arg0_51:getConfig("config_client").linkActID

			if var3_51 then
				local var4_51 = getProxy(ActivityProxy):getActivityById(var3_51)

				if var4_51 and var4_51:readyToAchieve() then
					return true
				end
			end

			if _.any(var2_51, function(arg0_52)
				local var0_52 = table.contains(var1_51, arg0_52)
				local var1_52 = table.contains(var0_51, arg0_52)

				return not var0_52 and var1_52
			end) then
				return true
			end

			local var5_51 = pg.activity_event_picturepuzzle[arg0_51.id]

			if var5_51 and var5_51.chapter > 0 and arg0_51.data1 < 1 then
				return true
			end

			if var5_51 and #var5_51.auto_finish_args > 0 and arg0_51.data1 == 1 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = function(arg0_53)
			return AirFightActivity.readyToAchieve(arg0_53)
		end,
		[ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE] = function(arg0_54)
			local var0_54 = WorldInPictureActiviyData.New(arg0_54)

			return not var0_54:IsTravelAll() and var0_54:GetTravelPoint() > 0 or var0_54:GetDrawPoint() > 0 and var0_54:AnyAreaCanDraw()
		end,
		[ActivityConst.ACTIVITY_TYPE_APRIL_REWARD] = function(arg0_55)
			if arg0_55.data1 == 0 then
				local var0_55 = arg0_55:getStartTime()
				local var1_55 = pg.TimeMgr.GetInstance():GetServerTime()

				if arg0_55:getConfig("config_client").autounlock <= var1_55 - var0_55 then
					return true
				end
			elseif arg0_55.data1 ~= 0 and arg0_55.data2 == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_POOL] = function(arg0_56)
			local var0_56 = arg0_56:getConfig("config_data")
			local var1_56 = getProxy(TaskProxy)

			if arg0_56.data1 >= #var0_56 then
				return false
			end

			local var2_56 = pg.TimeMgr.GetInstance()
			local var3_56 = (var2_56:DiffDay(arg0_56:getStartTime(), var2_56:GetServerTime()) + 1) * arg0_56:getConfig("config_id")

			var3_56 = var3_56 > #var0_56 and #var0_56 or var3_56

			local var4_56 = _.any(var0_56, function(arg0_57)
				local var0_57 = var1_56:getTaskById(arg0_57)

				return var0_57 and var0_57:isFinish()
			end)

			return var3_56 - arg0_56.data1 > 0 and var4_56
		end,
		[ActivityConst.ACTIVITY_TYPE_EVENT] = function(arg0_58)
			local var0_58 = getProxy(PlayerProxy):getData().id

			return PlayerPrefs.GetInt("ACTIVITY_TYPE_EVENT_" .. arg0_58.id .. "_" .. var0_58) == 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_OTHER] = function(arg0_59)
			if arg0_59.data2 and arg0_59.data2 <= 0 and arg0_59.data1 >= pg.activity_event_avatarframe[arg0_59:getConfig("config_id")].target then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = function(arg0_60)
			local var0_60, var1_60 = arg0_60:GetUpgradeCost()

			if arg0_60:GetSlotCount() < arg0_60:GetTotalSlotCount() and var1_60 <= arg0_60:GetCoins() then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function(arg0_61)
			local var0_61 = arg0_61:getConfig("config_data")[2][1]
			local var1_61 = arg0_61:getConfig("config_data")[2][2]
			local var2_61 = getProxy(PlayerProxy):getRawData():getResource(var0_61)

			if arg0_61.data1 > 0 and var1_61 <= var2_61 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD] = function(arg0_62)
			local var0_62 = pg.TimeMgr.GetInstance()

			return var0_62:GetServerTime() >= var0_62:GetTimeToNextTime(math.max(arg0_62.data1, arg0_62.data2))
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND] = function(arg0_63)
			for iter0_63, iter1_63 in pairs(getProxy(SixthAnniversaryIslandProxy):GetNodeDic()) do
				if iter1_63:IsVisual() and iter1_63:RedDotHint() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = function(arg0_64)
			return Spring2Activity.readyToAchieve(arg0_64)
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE] = function(arg0_65)
			local var0_65 = #arg0_65.data2_list
			local var1_65 = arg0_65:getData1List()
			local var2_65 = arg0_65:getConfig("config_data")[2]

			if #var1_65 == #var2_65 then
				return false
			end

			local function var3_65()
				for iter0_66, iter1_66 in ipairs(var2_65) do
					if not table.contains(var1_65, iter1_66[1]) and var0_65 >= iter1_66[1] then
						return true
					end
				end

				return false
			end

			local function var4_65()
				local var0_67 = getProxy(PlayerProxy):getData().id

				return PlayerPrefs.GetInt("DAY_TIP_" .. arg0_65.id .. "_" .. var0_67 .. "_" .. arg0_65:getDayIndex()) == 0
			end

			return var3_65() or var4_65()
		end,
		[ActivityConst.ACTIVITY_TYPE_SURVEY] = function(arg0_68)
			local var0_68, var1_68 = getProxy(ActivityProxy):isSurveyOpen()
			local var2_68 = getProxy(ActivityProxy):isSurveyDone()

			return var0_68 and not var2_68 and not SurveyPage.IsEverEnter(var1_68)
		end,
		[ActivityConst.ACTIVITY_TYPE_ZUMA] = function(arg0_69)
			return LaunchBallActivityMgr.GetInvitationAble(arg0_69.id)
		end,
		[ActivityConst.ACTIVITY_TYPE_GIFT_UP] = function(arg0_70)
			local var0_70 = arg0_70:getConfig("config_client").gifts[2]
			local var1_70 = math.min(#var0_70, arg0_70:getNDay())

			return underscore(var0_70):chain():first(var1_70):any(function(arg0_71)
				local var0_71 = getProxy(ShopsProxy):GetGiftCommodity(arg0_71, Goods.TYPE_GIFT_PACKAGE)

				return var0_71:canPurchase() and var0_71:inTime() and not var0_71:IsGroupLimit()
			end):value()
		end,
		[ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE] = function(arg0_72)
			local var0_72 = getProxy(ShopsProxy):getActivityShopById(arg0_72:GetConfigClientSetting("shopId"))

			for iter0_72, iter1_72 in ipairs(arg0_72:GetConfigClientSetting("goodsId")) do
				local var1_72 = var0_72:GetCommodityById(iter1_72)

				if var1_72:canPurchase() then
					local var2_72 = var1_72:GetConsume()

					if var2_72.count <= var2_72:getOwnedCount() then
						return true
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING] = function(arg0_73)
			return arg0_73:getData1() > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DAILY_STAGE_BONUS] = function(arg0_74)
			return arg0_74:NeedLoginRedPoint()
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_RYZA] = function(arg0_75)
			local var0_75 = getProxy(ActivityTaskProxy):getTaskById(arg0_75.id)

			for iter0_75, iter1_75 in ipairs(var0_75) do
				if iter1_75:getTaskStatus() == 1 then
					return true
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_76)
			local var0_76 = arg0_76:getConfig("config_id")

			if getProxy(MiniGameProxy):GetHubByHubId(var0_76).count > 0 then
				return true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function(arg0_77)
			local var0_77 = arg0_77:getConfig("config_id")
			local var1_77 = pg.activity_7_day_sign[var0_77].front_drops
			local var2_77 = pg.TimeMgr.GetInstance()
			local var3_77 = var2_77:GetServerTime()

			return arg0_77.data1 < #var1_77 and not var2_77:IsSameDay(var3_77, arg0_77.data2) and var3_77 > arg0_77.data2
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_HEI5] = function(arg0_78)
			return #arg0_78:GetHei5UnreceiveAward() > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_TownSkinStory] = function(arg0_79)
			local var0_79 = pg.NewStoryMgr.GetInstance()

			if arg0_79.data1 > 0 and underscore.any(arg0_79:GetConfigClientSetting("story"), function(arg0_80)
				return not var0_79:IsPlayed(arg0_80[1])
			end) then
				return true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MANUAL_SIGN] = function(arg0_81)
			return arg0_81:CanGetAward() or not arg0_81:TodayIsSigned()
		end,
		[ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_MAIL] = function(arg0_82)
			return getProxy(PlayerProxy):getRawData().level >= arg0_82:getConfig("config_id") and arg0_82.data1 == 0
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND_GAME_PT] = function(arg0_83)
			local var0_83 = pg.island_activity_pt_page[arg0_83:getIslandConfig("config_id")].task_id
			local var1_83 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

			return IslandGamePtTemplatePage.ShouldFirstTip(arg0_83.id) or _.any(var0_83, function(arg0_84)
				local var0_84 = var1_83:GetTask(arg0_84)

				return var0_84 and var0_84:IsFinish() and not var1_83:IsFinishTask(arg0_84)
			end)
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND_CHEATE_TAVERN] = function(arg0_85)
			local var0_85 = getProxy(ActivityTaskProxy):getTaskById(ActivityConst.ISLAND_BAR_ACT_ID)

			for iter0_85, iter1_85 in ipairs(var0_85) do
				if iter1_85:getTaskStatus() == 1 then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN] = function(arg0_86)
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

function var0_0.IsShowTipById(arg0_87)
	var0_0.ShowTipTableById = var0_0.ShowTipTableById or {
		[ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE] = function(arg0_88)
			local var0_88 = getProxy(SkirmishProxy)

			var0_88:UpdateSkirmishProgress()

			local var1_88 = var0_88:getRawData()
			local var2_88 = 0
			local var3_88 = 0

			for iter0_88, iter1_88 in ipairs(var1_88) do
				local var4_88 = iter1_88:GetState()

				var2_88 = var4_88 > SkirmishVO.StateInactive and var2_88 + 1 or var2_88
				var3_88 = var4_88 == SkirmishVO.StateClear and var3_88 + 1 or var3_88
			end

			return var3_88 < var2_88
		end,
		[ActivityConst.POCKY_SKIN_LOGIN] = function(arg0_89)
			local var0_89 = arg0_89:getConfig("config_client").linkids
			local var1_89 = getProxy(TaskProxy)
			local var2_89 = getProxy(ActivityProxy)
			local var3_89 = var2_89:getActivityById(var0_89[1])
			local var4_89 = var2_89:getActivityById(var0_89[2])
			local var5_89 = var2_89:getActivityById(var0_89[3])

			assert(var3_89 and var4_89 and var5_89)

			local function var6_89()
				return var3_89 and var3_89:readyToAchieve()
			end

			local function var7_89()
				return var4_89 and var4_89:readyToAchieve()
			end

			local function var8_89()
				local var0_92 = _.flatten(arg0_89:getConfig("config_data"))

				for iter0_92 = 1, math.min(#var0_92, var4_89.data3) do
					local var1_92 = var0_92[iter0_92]
					local var2_92 = var1_89:getTaskById(var1_92)

					if var2_92 and var2_92:isFinish() and not var2_92:isReceive() then
						return true
					end
				end
			end

			local function var9_89()
				if not (var5_89 and var5_89:readyToAchieve()) or not var3_89 then
					return false
				end

				local var0_93 = ActivityPtData.New(var3_89)

				return var0_93.level >= #var0_93.targets
			end

			return var8_89() or var6_89() or var7_89() or var9_89()
		end,
		[ActivityConst.TOWERCLIMBING_SIGN] = function(arg0_94)
			local var0_94 = getProxy(MiniGameProxy):GetHubByHubId(9)
			local var1_94 = var0_94.ultimate
			local var2_94 = var0_94:getConfig("reward_need")
			local var3_94 = var0_94.usedtime

			return var1_94 == 0 and var2_94 <= var3_94
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
		[ActivityConst.NINJA_CITY_MAIN_ACTIVITY_ID] = function(arg0_95)
			if CityRebuildBookLayer.ShouldShowTip() or CityRebuildTasksLayer.ShouldShowTip() then
				return true
			end

			return false
		end,
		[ActivityConst.MALL_MAIN_ACTIVITY_ID] = function(arg0_96)
			return AnniversaryNineMainPage.IsTip()
		end,
		[ActivityConst.SAILING_SHIP_3_SKIN_ACT_ID] = SailingShip3SkinLayer.ShouldShowTip,
		[ActivityConst.HelenaPT_ACT_ID] = function(arg0_97)
			return HelenaScenarioPage:IsShowRed(arg0_97)
		end,
		[ActivityConst.LOVE_LETTER_LOGIN_ID] = function(arg0_98)
			local var0_98 = arg0_98:getNDay()

			for iter0_98 = 1, var0_98 do
				local var1_98 = arg0_98:getConfig("config_data")[iter0_98]
				local var2_98 = var1_98 and getProxy(TaskProxy):getTaskVO(var1_98) or nil

				if var2_98 and var2_98:getTaskStatus() == 1 then
					return true
				end
			end

			return false
		end
	}

	local var0_87 = var0_0.ShowTipTableById[arg0_87.id]

	return tobool(var0_87), var0_87 and var0_87(arg0_87)
end

function var0_0.activityTasksSubTypeFunc(arg0_99, arg1_99)
	if arg1_99 == 1 then
		local var0_99 = 1
		local var1_99 = getProxy(TaskProxy)
		local var2_99 = arg0_99:getConfig("config_client").unlock_task
		local var3_99 = arg0_99:getNDay()
		local var4_99 = #var2_99
		local var5_99 = math.min(var3_99, var4_99)
		local var6_99 = true

		for iter0_99 = 1, var5_99 do
			if not var6_99 then
				break
			end

			var0_99 = iter0_99

			if iter0_99 < var5_99 then
				for iter1_99, iter2_99 in ipairs(var2_99[iter0_99]) do
					local var7_99 = var1_99:getTaskById(iter2_99) or var1_99:getFinishTaskById(iter2_99)

					if not var7_99 or var7_99:getTaskStatus() ~= 2 then
						var6_99 = false

						break
					end
				end
			end
		end

		local var8_99 = math.min(var0_99, var4_99)

		for iter3_99, iter4_99 in ipairs(var2_99[var8_99]) do
			local var9_99 = var1_99:getTaskById(iter4_99) or var1_99:getFinishTaskById(iter4_99)

			if not var9_99 then
				return false
			end

			if var9_99:getTaskStatus() == 1 then
				return true
			end
		end
	end

	if arg1_99 == TASK_SUB_TYPE_CLIENT_TRIGGER then
		local var10_99, var11_99 = getActivityTask(arg0_99, true)

		return var10_99 and (not var11_99 or var11_99:getTaskStatus() ~= 2)
	end

	return false
end

function var0_0.isShow(arg0_100)
	if LOCK_SKIN_US then
		local var0_100 = pg.gameset.levellimit_skinstory.key_value
		local var1_100 = pg.gameset.levellimit_skinstory.description

		if var0_100 >= getProxy(PlayerProxy):getRawData().level and table.contains(var1_100, arg0_100.id) then
			return false
		end
	end

	if arg0_100:getConfig("is_show") <= 0 then
		return false
	end

	if arg0_100:getConfig("type") == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		return arg0_100.data1 ~= 0
	elseif arg0_100:getConfig("type") == ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY then
		local var2_100 = arg0_100:getConfig("config_client").display_link

		if var2_100 then
			return underscore.any(var2_100, function(arg0_101)
				return arg0_101[2] == 0 or pg.TimeMgr.GetInstance():inTime(ShopConst.GetShopConfig(arg0_101[2]).time)
			end)
		end
	elseif arg0_100:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SURVEY then
		local var3_100 = getProxy(ActivityProxy)
		local var4_100 = var3_100:isSurveyOpen()
		local var5_100 = var3_100:isSurveyDone()

		return var4_100 and not var5_100
	elseif arg0_100:getConfig("type") == ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE then
		local var6_100 = getProxy(ShopsProxy):getActivityShopById(arg0_100:GetConfigClientSetting("shopId"))

		for iter0_100, iter1_100 in ipairs(arg0_100:GetConfigClientSetting("goodsId")) do
			if var6_100:GetCommodityById(iter1_100):canPurchase() then
				return true
			end
		end

		return false
	elseif arg0_100:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_RYZA and table.contains({
		ActivityConst.DORM_SIGN_ID,
		ActivityConst.DORM_SIGN_ID_2,
		ActivityConst.DORM_SIGN_ID_3
	}, arg0_100:getConfig("id")) then
		return #getProxy(ActivityProxy):getActivityById(arg0_100:getConfig("id")):getConfig("config_data") ~= #getProxy(ActivityTaskProxy):getFinishTaskById(arg0_100:getConfig("id"))
	end

	return true
end

function var0_0.isAfterShow(arg0_102)
	if arg0_102.configId == ActivityConst.ISLAND_SIGN_ID then
		local var0_102 = _.flatten(arg0_102:getConfig("config_data"))
		local var1_102 = getProxy(ActivityTaskProxy):GetActivityTasks(arg0_102.id)

		return _.all(var0_102, function(arg0_103)
			local var0_103 = var1_102[arg0_103]

			return var0_103 and var0_103:isOver()
		end)
	end

	if arg0_102.configId == ActivityConst.UR_TASK_ACT_ID or arg0_102.configId == ActivityConst.SPECIAL_WEAPON_ACT_ID then
		local var2_102 = getProxy(TaskProxy)

		return underscore.all(arg0_102:getConfig("config_data")[1], function(arg0_104)
			local var0_104 = var2_102:getTaskVO(arg0_104)

			return var0_104 and var0_104:isReceive()
		end)
	end

	return false
end

function var0_0.getPageABNames(arg0_105)
	local var0_105 = arg0_105:getConfig("page_info")

	return {
		var0_105.ui_name,
		var0_105.ui_name2
	}
end

function var0_0.checkPageABExist(arg0_106)
	if not IsUnityEditor then
		return true
	end

	return underscore.all(arg0_106:getPageABNames(), function(arg0_107)
		return checkABExist(string.format("ui/%s", arg0_107))
	end)
end

function var0_0.getShowPriority(arg0_108)
	return arg0_108:getConfig("is_show")
end

function var0_0.isCorePage(arg0_109, arg1_109)
	return arg0_109:getConfig("page_core") == arg1_109
end

function var0_0.left4Day(arg0_110)
	if arg0_110.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 345600 then
		return true
	end

	return false
end

function var0_0.getAwardInfos(arg0_111)
	return arg0_111.data1KeyValueList or {}
end

function var0_0.updateData(arg0_112, arg1_112, arg2_112)
	if arg0_112:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if not arg0_112:getAwardInfos()[arg1_112] then
			arg0_112.data1KeyValueList[arg1_112] = {}
		end

		for iter0_112, iter1_112 in ipairs(arg2_112) do
			if arg0_112.data1KeyValueList[arg1_112][iter1_112] then
				arg0_112.data1KeyValueList[arg1_112][iter1_112] = arg0_112.data1KeyValueList[arg1_112][iter1_112] + 1
			else
				arg0_112.data1KeyValueList[arg1_112][iter1_112] = 1
			end
		end
	end
end

function var0_0.getTaskShip(arg0_113)
	return arg0_113:getConfig("config_client")[1]
end

function var0_0.getNotificationMsg(arg0_114)
	local var0_114 = arg0_114:getConfig("type")
	local var1_114 = ActivityProxy.ACTIVITY_SHOW_AWARDS

	if var0_114 == ActivityConst.ACTIVITY_TYPE_SHOP or var0_114 == ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE or var0_114 == ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE then
		var1_114 = ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS
	elseif var0_114 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		var1_114 = ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS
	elseif var0_114 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		var1_114 = ActivityProxy.ACTIVITY_SHOW_REFLUX_AWARDS
	elseif var0_114 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS or var0_114 == ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER then
		var1_114 = ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS
	end

	return var1_114
end

function var0_0.getDayIndex(arg0_115)
	local var0_115 = arg0_115:getStartTime()
	local var1_115 = pg.TimeMgr.GetInstance()
	local var2_115 = var1_115:GetServerTime()

	return var1_115:DiffDay(var0_115, var2_115) + 1
end

function var0_0.getStartTime(arg0_116)
	if arg0_116:getConfig("time") == "stop" then
		return pg.TimeMgr.GetInstance():GetServerTime()
	else
		local var0_116, var1_116 = parseTimeConfig(arg0_116:getConfig("time"))

		if var1_116 and var1_116[1] == "newuser" then
			return arg0_116.stopTime - var1_116[3] * 86400
		else
			return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_116[2])
		end
	end
end

function var0_0.getNDay(arg0_117, arg1_117)
	arg1_117 = arg1_117 or arg0_117:getStartTime()

	local var0_117 = pg.TimeMgr.GetInstance()

	return var0_117:DiffDay(arg1_117, var0_117:GetServerTime()) + 1
end

function var0_0.isVariableTime(arg0_118)
	local var0_118, var1_118 = parseTimeConfig(arg0_118:getConfig("time"))

	return var1_118 and var1_118[1] == "newuser"
end

function var0_0.setSpecialData(arg0_119, arg1_119, arg2_119)
	arg0_119.speciaData = arg0_119.speciaData and arg0_119.speciaData or {}
	arg0_119.speciaData[arg1_119] = arg2_119
end

function var0_0.getSpecialData(arg0_120, arg1_120)
	return arg0_120.speciaData and arg0_120.speciaData[arg1_120] and arg0_120.speciaData[arg1_120] or nil
end

function var0_0.canPermanentFinish(arg0_121)
	local var0_121 = arg0_121:getConfig("type")

	if var0_121 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		local var1_121 = arg0_121:getConfig("config_data")
		local var2_121 = getProxy(TaskProxy)

		return underscore.all(underscore.flatten({
			var1_121[#var1_121]
		}), function(arg0_122)
			return var2_121:getFinishTaskById(arg0_122) ~= nil
		end)
	elseif var0_121 == ActivityConst.ACTIVITY_TYPE_PT_BUFF or var0_121 == ActivityConst.ACTIVITY_TYPE_PT_BUFF_MARK2 then
		local var3_121 = ActivityPtData.New(arg0_121)

		return var3_121.level >= #var3_121.targets
	end

	return false
end

function var0_0.GetShopTime(arg0_123)
	local var0_123 = pg.TimeMgr.GetInstance()
	local var1_123 = arg0_123:getStartTime()
	local var2_123 = arg0_123.stopTime
	local var3_123 = var0_123:STimeDescS(var2_123, "*t")

	if var3_123.hour == 0 and var3_123.min == 0 and var3_123.sec == 0 then
		return var0_123:STimeDescS(var1_123, "%y.%m.%d") .. " - " .. string.format("%s.%s.%s", var3_123.year, var3_123.month, var3_123.day - 1)
	else
		return var0_123:STimeDescS(var1_123, "%y.%m.%d") .. " - " .. var0_123:STimeDescS(var2_123, "%y.%m.%d")
	end
end

function var0_0.GetHei5Info(arg0_124)
	local var0_124 = pg.black_friday_battlepass_event_pt[arg0_124.id]
	local var1_124 = var0_124.pt
	local var2_124 = {}
	local var3_124 = {}

	for iter0_124, iter1_124 in ipairs(var0_124.key_point_display) do
		var3_124[iter1_124] = true
	end

	for iter2_124, iter3_124 in ipairs(var0_124.target) do
		table.insert(var2_124, {
			id = iter2_124,
			pt = iter3_124,
			award = pg.black_friday_battlepass_event_award[var0_124.award[iter2_124]].drop_client,
			award_pay = pg.black_friday_battlepass_event_award[var0_124.award_pay[iter2_124]].drop_client,
			isImportent = var3_124[iter2_124]
		})
	end

	local var4_124 = arg0_124.data1
	local var5_124 = arg0_124.data2 == 1
	local var6_124 = {}

	for iter4_124, iter5_124 in ipairs(arg0_124.data1_list) do
		var6_124[iter5_124] = true
	end

	local var7_124 = {}

	for iter6_124, iter7_124 in ipairs(arg0_124.data2_list) do
		var7_124[iter7_124] = true
	end

	local var8_124 = 0

	for iter8_124, iter9_124 in ipairs(var2_124) do
		if var4_124 < iter9_124.pt then
			break
		else
			var8_124 = iter8_124
		end
	end

	return {
		ptId = var1_124,
		awardList = var2_124,
		pt = var4_124,
		isPay = var5_124,
		awardDic = var6_124,
		awardPayDic = var7_124,
		phase = var8_124
	}
end

function var0_0.GetHei5UnreceiveAward(arg0_125)
	local var0_125 = pg.black_friday_battlepass_event_pt[arg0_125.id]
	local var1_125 = {}
	local var2_125 = {}

	for iter0_125, iter1_125 in ipairs(arg0_125.data1_list) do
		var2_125[iter1_125] = true
	end

	for iter2_125, iter3_125 in ipairs(var0_125.target) do
		if iter3_125 > arg0_125.data1 then
			break
		elseif not var2_125[iter3_125] then
			table.insert(var1_125, Drop.Create(pg.black_friday_battlepass_event_award[var0_125.award[iter2_125]].drop_client))
		end
	end

	if arg0_125.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1_125)
	end

	local var3_125 = {}

	for iter4_125, iter5_125 in ipairs(arg0_125.data2_list) do
		var3_125[iter5_125] = true
	end

	for iter6_125, iter7_125 in ipairs(var0_125.target) do
		if iter7_125 > arg0_125.data1 then
			break
		elseif not var3_125[iter7_125] then
			table.insert(var1_125, Drop.Create(pg.black_friday_battlepass_event_award[var0_125.award_pay[iter6_125]].drop_client))
		end
	end

	return PlayerConst.MergePassItemDrop(var1_125)
end

function var0_0.IsActivityReady(arg0_126)
	return arg0_126 and not arg0_126:isEnd() and arg0_126:readyToAchieve()
end

function var0_0.NeedLoginRedPoint(arg0_127)
	return PlayerPrefs.GetString(arg0_127:GetLoginRedPointKey(), "") ~= arg0_127:GetLoginRedPointValue()
end

function var0_0.SetLoginRedPoint(arg0_128)
	PlayerPrefs.SetString(arg0_128:GetLoginRedPointKey(), arg0_128:GetLoginRedPointValue())
end

function var0_0.GetLoginRedPointValue(arg0_129)
	return pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
end

function var0_0.GetLoginRedPointKey(arg0_130)
	local var0_130 = arg0_130:GetPlayerID()

	return string.format("%s_%s", var0_130, arg0_130.id)
end

function var0_0.GetPlayerID(arg0_131)
	return getProxy(PlayerProxy):getPlayerId()
end

function var0_0.GetConfigClientSetting(arg0_132, arg1_132)
	return arg0_132:getConfig("config_client")[arg1_132]
end

function var0_0.IsMaintenanceFinish(arg0_133)
	return not arg0_133:GetConfigClientSetting("no_maintenance")
end

function var0_0.GetPlayerActivyIDKey(arg0_134)
	local var0_134 = getProxy(PlayerProxy):getPlayerId()

	return "Activity_PlayerPrefs_PlayerId_" .. var0_134 .. "ActivityID_" .. arg0_134
end

function var0_0.GetConfigClientPTDrop(arg0_135)
	if arg0_135:isEnd() then
		return nil
	end

	if arg0_135:GetConfigClientSetting("PT_ACT") then
		local var0_135 = getProxy(ActivityProxy):getActivityById(arg0_135:GetConfigClientSetting("PT_ACT"))

		return var0_135 and var0_135:GetPTDrop() or nil
	elseif arg0_135:GetConfigClientSetting("PTID") then
		return Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = arg0_135:GetConfigClientSetting("PTID")
		})
	elseif arg0_135:GetConfigClientSetting("ptId") then
		return Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = arg0_135:GetConfigClientSetting("ptId")
		})
	end

	return nil
end

function var0_0.GetConfigClientPTActivity(arg0_136)
	if arg0_136:isEnd() then
		return nil
	end

	if arg0_136:GetConfigClientSetting("PT_ACT") then
		return getProxy(ActivityProxy):getActivityById(arg0_136:GetConfigClientSetting("PT_ACT"))
	else
		local var0_136 = arg0_136:GetConfigClientPTDrop()

		return var0_136 and getProxy(ActivityProxy):GetPTActivityByRes(var0_136) or nil
	end
end

local function var2_0(arg0_137)
	local var0_137 = pg.TimeMgr.GetInstance():STimeDescC(arg0_137.stopTime, "%Y/%m/%d/%H/%M/%S")
	local var1_137 = string.split(var0_137, "/")
	local var2_137 = pg.TimeMgr.GetInstance():STimeDescC(arg0_137:getStartTime(), "%Y/%m/%d/%H/%M/%S")
	local var3_137 = string.split(var2_137, "/")
	local var4_137 = (arg0_137:getConfig("config_client").is_maintain or 0) == ActivityRemasterData.MAINTAIN

	return GetActTimeDesc(false, var4_137, var3_137[2], var3_137[3], var1_137[2], var1_137[3], var1_137[4], var1_137[5], var1_137[6])
end

function var0_0.GetActivityTimeStr(arg0_138, arg1_138)
	local var0_138 = arg0_138

	if var0_138:getConfig("time") == "stop" then
		local var1_138 = getProxy(ActivityRemasterProxy):GetActivaingReamsterData()

		if not var1_138 then
			return ""
		end

		return var1_138:GetActivityTimeDesc(var0_138.id)
	elseif arg1_138 then
		return ""
	else
		return var2_0(var0_138)
	end
end

return var0_0
