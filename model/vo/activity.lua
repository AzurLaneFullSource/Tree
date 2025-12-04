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
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = AirFightActivity,
		[ActivityConst.ACTIVITY_TYPE_NOT_TRACEABLE] = NotTraceableTaskActivity,
		[ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA] = VirtualBagActivity,
		[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = VirtualBagActivity,
		[ActivityConst.ACTIVITY_TYPE_ISLAND_DRAW_AWARD] = DrawAwardActivity
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
		[ActivityConst.ACTIVITY_TYPE_STORY_AWARD] = function(arg0_28)
			local var0_28 = getProxy(PlayerProxy):getRawData()
			local var1_28 = pg.activity_event_chapter_award[arg0_28:getConfig("config_id")]

			for iter0_28 = 1, #var1_28.chapter do
				local var2_28 = var1_28.chapter[iter0_28]

				if getProxy(ChapterProxy):isClear(var2_28) and not _.include(arg0_28.data1_list, var2_28) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASKS] = function(arg0_29)
			local var0_29 = getProxy(TaskProxy)
			local var1_29 = _.flatten(arg0_29:getConfig("config_data"))

			if _.any(var1_29, function(arg0_30)
				local var0_30 = var0_29:getTaskById(arg0_30)

				return var0_30 and var0_30:isFinish() and not var0_30:isReceive()
			end) then
				return true
			end

			local var2_29 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

			if var2_29 and not var2_29:isEnd() and var2_29:getConfig("config_client").linkActID == arg0_29.id and var2_29:readyToAchieve() then
				return true
			end

			if arg0_29:getConfig("config_client") and arg0_29:getConfig("config_client").decodeGameId then
				local var3_29 = arg0_29:getConfig("config_client").decodeGameId
				local var4_29 = getProxy(MiniGameProxy):GetHubByGameId(var3_29)

				if var4_29 then
					local var5_29 = arg0_29:getConfig("config_data")
					local var6_29 = var5_29[#var5_29]
					local var7_29 = _.all(var6_29, function(arg0_31)
						return getProxy(TaskProxy):getFinishTaskById(arg0_31) ~= nil
					end)

					if var4_29.ultimate <= 0 and var7_29 then
						return true
					end
				end
			end

			if arg0_29:getConfig("config_client") and arg0_29:getConfig("config_client").linkTaskPoolAct then
				local var8_29 = arg0_29:getConfig("config_client").linkTaskPoolAct
				local var9_29 = getProxy(ActivityProxy):getActivityById(var8_29)

				if var9_29 and var9_29:readyToAchieve() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_LIST] = function(...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_TASKS](...)
		end,
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
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = function(...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_PIZZA_PT](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_RETURN_AWARD] = function(arg0_38)
			local var0_38 = arg0_38.data1

			if var0_38 == 1 then
				local var1_38 = pg.activity_template_headhunting[arg0_38.id]
				local var2_38 = var1_38.target
				local var3_38 = 0

				for iter0_38, iter1_38 in ipairs(arg0_38:getClientList()) do
					var3_38 = var3_38 + iter1_38:getPt()
				end

				local var4_38 = 0

				for iter2_38 = #var2_38, 1, -1 do
					if table.contains(arg0_38.data1_list, var2_38[iter2_38]) then
						var4_38 = iter2_38

						break
					end
				end

				local var5_38 = var1_38.drop_client
				local var6_38 = math.min(var4_38 + 1, #var5_38)
				local var7_38 = _.any(var1_38.tasklist, function(arg0_39)
					local var0_39 = getProxy(TaskProxy):getTaskById(arg0_39)

					return var0_39 and var0_39:isFinish() and not var0_39:isReceive()
				end)

				return var3_38 >= var2_38[var6_38] and var4_38 ~= #var5_38 or var7_38
			elseif var0_38 == 2 then
				local var8_38 = getProxy(TaskProxy)
				local var9_38 = pg.activity_template_returnner[arg0_38.id]

				return _.any(_.flatten(var9_38.task_list), function(arg0_40)
					local var0_40 = var8_38:getTaskById(arg0_40)

					return var0_40 and var0_40:isFinish()
				end)
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_41)
			local var0_41 = getProxy(MiniGameProxy):GetHubByHubId(arg0_41:getConfig("config_id"))

			if var0_41.count > 0 then
				return true
			end

			if var0_41:getConfig("reward") ~= 0 and var0_41.usedtime >= var0_41:getConfig("reward_need") and var0_41.ultimate == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function(arg0_42)
			local var0_42 = pg.activity_event_turning[arg0_42:getConfig("config_id")]
			local var1_42 = arg0_42.data4

			if var1_42 ~= 0 then
				local var2_42 = var0_42.task_table[var1_42]
				local var3_42 = getProxy(TaskProxy)

				for iter0_42, iter1_42 in ipairs(var2_42) do
					if (var3_42:getTaskById(iter1_42) or var3_42:getFinishTaskById(iter1_42)):getTaskStatus() == 1 then
						return true
					end
				end

				local var4_42 = pg.TimeMgr.GetInstance():DiffDay(arg0_42.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var4_42, 1, pg.activity_event_turning[arg0_42:getConfig("config_id")].total_num) > arg0_42.data3 then
					for iter2_42, iter3_42 in ipairs(var2_42) do
						if (var3_42:getTaskById(iter3_42) or var3_42:getFinishTaskById(iter3_42)):getTaskStatus() ~= 2 then
							return false
						end
					end

					return true
				end
			elseif var1_42 == 0 then
				local var5_42 = pg.TimeMgr.GetInstance():DiffDay(arg0_42.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var5_42, 1, pg.activity_event_turning[arg0_42:getConfig("config_id")].total_num) > arg0_42.data3 then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function(arg0_43)
			return not (arg0_43.data2 > 0)
		end,
		[ActivityConst.ACTIVITY_TYPE_SHRINE] = function(arg0_44)
			local var0_44 = arg0_44:getConfig("config_client").story
			local var1_44 = var0_44 and #var0_44 or 7
			local var2_44 = pg.TimeMgr.GetInstance():DiffDay(arg0_44.data3, pg.TimeMgr.GetInstance():GetServerTime()) + 1
			local var3_44 = math.clamp(var2_44, 1, var1_44)
			local var4_44 = pg.NewStoryMgr.GetInstance()
			local var5_44 = math.clamp(arg0_44.data2, 0, var1_44)

			for iter0_44 = 1, var3_44 do
				local var6_44 = var0_44[iter0_44][1]

				if var6_44 and iter0_44 <= var5_44 and not var4_44:IsPlayed(var6_44) then
					return true
				end
			end

			if var1_44 <= var3_44 and var1_44 <= arg0_44.data2 and not (arg0_44.data1 > 0) then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = function(arg0_45)
			local var0_45 = arg0_45:getConfig("config_client")[3]
			local var1_45 = pg.TimeMgr.GetInstance()
			local var2_45 = var1_45:DiffDay(arg0_45.data3, var1_45:GetServerTime()) + 1 - arg0_45.data2

			return math.clamp(var2_45, 0, #var0_45 - arg0_45.data2) > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function(arg0_46)
			local var0_46 = arg0_46:GetBuildingIds()

			for iter0_46, iter1_46 in ipairs(var0_46) do
				local var1_46 = arg0_46:GetBuildingLevel(iter1_46)
				local var2_46 = pg.activity_event_building[iter1_46]

				if var2_46 and var1_46 < #var2_46.buff then
					local var3_46 = var2_46.material[var1_46]

					if underscore.all(var3_46, function(arg0_47)
						local var0_47 = arg0_47[1]
						local var1_47 = arg0_47[2]
						local var2_47 = arg0_47[3]
						local var3_47 = 0

						if var0_47 == DROP_TYPE_VITEM then
							local var4_47 = AcessWithinNull(Item.getConfigData(var1_47), "link_id")

							assert(var4_47 == arg0_46.id)

							var3_47 = arg0_46:GetMaterialCount(var1_47)
						elseif var0_47 > DROP_TYPE_USE_ACTIVITY_DROP then
							local var5_47 = AcessWithinNull(pg.activity_drop_type[var0_47], "activity_id")

							assert(var5_47)

							bagAct = getProxy(ActivityProxy):getActivityById(var5_47)
							var3_47 = bagAct:getVitemNumber(var1_47)
						end

						return var2_47 <= var3_47
					end) then
						return true
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function(arg0_48, ...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF](arg0_48, ...) or arg0_48:CanRequest()
		end,
		[ActivityConst.ACTIVITY_TYPE_EXPEDITION] = function(arg0_49)
			if arg0_49.data3 > 0 and arg0_49.data1 ~= 0 then
				return true
			else
				for iter0_49 = 1, #arg0_49.data1_list do
					if not bit.band(arg0_49.data1_list[iter0_49], ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
						if bit.band(arg0_49.data1_list[iter0_49], ActivityConst.EXPEDITION_TYPE_OPEN) ~= 0 then
							return true
						elseif bit.band(arg0_49.data1_list[iter0_49], ActivityConst.EXPEDITION_TYPE_BAOXIANG) ~= 0 then
							return true
						elseif bit.band(arg0_49.data1_list[iter0_49], ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 then
							return true
						end
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY] = function(arg0_50)
			local var0_50 = arg0_50:getConfig("config_client")

			if var0_50 and var0_50.linkGameHubID then
				local var1_50 = getProxy(MiniGameProxy):GetHubByHubId(var0_50.linkGameHubID)

				if var1_50 then
					if var0_50.trimRed then
						if var1_50.ultimate == 1 then
							return false
						end

						if var1_50.usedtime == var1_50:getConfig("reward_need") then
							return true
						end
					end

					return var1_50.count > 0
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BB] = function(arg0_51)
			return arg0_51.data2 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = function(arg0_52)
			local var0_52 = arg0_52.data1_list
			local var1_52 = arg0_52.data2_list
			local var2_52 = arg0_52:GetPicturePuzzleIds()
			local var3_52 = arg0_52:getConfig("config_client").linkActID

			if var3_52 then
				local var4_52 = getProxy(ActivityProxy):getActivityById(var3_52)

				if var4_52 and var4_52:readyToAchieve() then
					return true
				end
			end

			if _.any(var2_52, function(arg0_53)
				local var0_53 = table.contains(var1_52, arg0_53)
				local var1_53 = table.contains(var0_52, arg0_53)

				return not var0_53 and var1_53
			end) then
				return true
			end

			local var5_52 = pg.activity_event_picturepuzzle[arg0_52.id]

			if var5_52 and var5_52.chapter > 0 and arg0_52.data1 < 1 then
				return true
			end

			if var5_52 and #var5_52.auto_finish_args > 0 and arg0_52.data1 == 1 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = function(arg0_54)
			return AirFightActivity.readyToAchieve(arg0_54)
		end,
		[ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE] = function(arg0_55)
			local var0_55 = WorldInPictureActiviyData.New(arg0_55)

			return not var0_55:IsTravelAll() and var0_55:GetTravelPoint() > 0 or var0_55:GetDrawPoint() > 0 and var0_55:AnyAreaCanDraw()
		end,
		[ActivityConst.ACTIVITY_TYPE_APRIL_REWARD] = function(arg0_56)
			if arg0_56.data1 == 0 then
				local var0_56 = arg0_56:getStartTime()
				local var1_56 = pg.TimeMgr.GetInstance():GetServerTime()

				if arg0_56:getConfig("config_client").autounlock <= var1_56 - var0_56 then
					return true
				end
			elseif arg0_56.data1 ~= 0 and arg0_56.data2 == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_POOL] = function(arg0_57)
			local var0_57 = arg0_57:getConfig("config_data")
			local var1_57 = getProxy(TaskProxy)

			if arg0_57.data1 >= #var0_57 then
				return false
			end

			local var2_57 = pg.TimeMgr.GetInstance()
			local var3_57 = (var2_57:DiffDay(arg0_57:getStartTime(), var2_57:GetServerTime()) + 1) * arg0_57:getConfig("config_id")

			var3_57 = var3_57 > #var0_57 and #var0_57 or var3_57

			local var4_57 = _.any(var0_57, function(arg0_58)
				local var0_58 = var1_57:getTaskById(arg0_58)

				return var0_58 and var0_58:isFinish()
			end)

			return var3_57 - arg0_57.data1 > 0 and var4_57
		end,
		[ActivityConst.ACTIVITY_TYPE_EVENT] = function(arg0_59)
			local var0_59 = getProxy(PlayerProxy):getData().id

			return PlayerPrefs.GetInt("ACTIVITY_TYPE_EVENT_" .. arg0_59.id .. "_" .. var0_59) == 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_OTHER] = function(arg0_60)
			if arg0_60.data2 and arg0_60.data2 <= 0 and arg0_60.data1 >= pg.activity_event_avatarframe[arg0_60:getConfig("config_id")].target then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = function(arg0_61)
			local var0_61, var1_61 = arg0_61:GetUpgradeCost()

			if arg0_61:GetSlotCount() < arg0_61:GetTotalSlotCount() and var1_61 <= arg0_61:GetCoins() then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function(arg0_62)
			local var0_62 = arg0_62:getConfig("config_data")[2][1]
			local var1_62 = arg0_62:getConfig("config_data")[2][2]
			local var2_62 = getProxy(PlayerProxy):getRawData():getResource(var0_62)

			if arg0_62.data1 > 0 and var1_62 <= var2_62 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD] = function(arg0_63)
			local var0_63 = pg.TimeMgr.GetInstance()

			return var0_63:GetServerTime() >= var0_63:GetTimeToNextTime(math.max(arg0_63.data1, arg0_63.data2))
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND] = function(arg0_64)
			for iter0_64, iter1_64 in pairs(getProxy(SixthAnniversaryIslandProxy):GetNodeDic()) do
				if iter1_64:IsVisual() and iter1_64:RedDotHint() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = function(arg0_65)
			return Spring2Activity.readyToAchieve(arg0_65)
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE] = function(arg0_66)
			local var0_66 = #arg0_66.data2_list
			local var1_66 = arg0_66:getData1List()
			local var2_66 = arg0_66:getConfig("config_data")[2]

			if #var1_66 == #var2_66 then
				return false
			end

			local function var3_66()
				for iter0_67, iter1_67 in ipairs(var2_66) do
					if not table.contains(var1_66, iter1_67[1]) and var0_66 >= iter1_67[1] then
						return true
					end
				end

				return false
			end

			local function var4_66()
				local var0_68 = getProxy(PlayerProxy):getData().id

				return PlayerPrefs.GetInt("DAY_TIP_" .. arg0_66.id .. "_" .. var0_68 .. "_" .. arg0_66:getDayIndex()) == 0
			end

			return var3_66() or var4_66()
		end,
		[ActivityConst.ACTIVITY_TYPE_SURVEY] = function(arg0_69)
			local var0_69, var1_69 = getProxy(ActivityProxy):isSurveyOpen()
			local var2_69 = getProxy(ActivityProxy):isSurveyDone()

			return var0_69 and not var2_69 and not SurveyPage.IsEverEnter(var1_69)
		end,
		[ActivityConst.ACTIVITY_TYPE_ZUMA] = function(arg0_70)
			return LaunchBallActivityMgr.GetInvitationAble(arg0_70.id)
		end,
		[ActivityConst.ACTIVITY_TYPE_GIFT_UP] = function(arg0_71)
			local var0_71 = arg0_71:getConfig("config_client").gifts[2]
			local var1_71 = math.min(#var0_71, arg0_71:getNDay())

			return underscore(var0_71):chain():first(var1_71):any(function(arg0_72)
				local var0_72 = getProxy(ShopsProxy):GetGiftCommodity(arg0_72, Goods.TYPE_GIFT_PACKAGE)

				return var0_72:canPurchase() and var0_72:inTime() and not var0_72:IsGroupLimit()
			end):value()
		end,
		[ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE] = function(arg0_73)
			if getProxy(ShopsProxy):getActivityShops() == nil then
				return false
			end

			local var0_73 = arg0_73:getConfig("config_client")
			local var1_73 = getProxy(PlayerProxy):getData():getResource(var0_73.uPtId)
			local var2_73 = #var0_73.goodsId + 1
			local var3_73 = var2_73 - _.reduce(var0_73.goodsId, 0, function(arg0_74, arg1_74)
				return arg0_74 + getProxy(ShopsProxy):getActivityShopById(var0_73.shopId):GetCommodityById(arg1_74):GetPurchasableCnt()
			end)
			local var4_73 = var3_73 < var2_73 and pg.activity_shop_template[var0_73.goodsId[var3_73]] or nil

			return var3_73 < var2_73 and var1_73 >= var4_73.resource_num
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING] = function(arg0_75)
			return arg0_75:getData1() > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DAILY_STAGE_BONUS] = function(arg0_76)
			return arg0_76:NeedLoginRedPoint()
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_RYZA] = function(arg0_77)
			local var0_77 = getProxy(ActivityTaskProxy):getTaskById(arg0_77.id)

			for iter0_77, iter1_77 in ipairs(var0_77) do
				if iter1_77:getTaskStatus() == 1 then
					return true
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_78)
			local var0_78 = arg0_78:getConfig("config_id")

			if getProxy(MiniGameProxy):GetHubByHubId(var0_78).count > 0 then
				return true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function(arg0_79)
			local var0_79 = arg0_79:getConfig("config_id")
			local var1_79 = pg.activity_7_day_sign[var0_79].front_drops
			local var2_79 = pg.TimeMgr.GetInstance()
			local var3_79 = var2_79:GetServerTime()

			return arg0_79.data1 < #var1_79 and not var2_79:IsSameDay(var3_79, arg0_79.data2) and var3_79 > arg0_79.data2
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_HEI5] = function(arg0_80)
			return #getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5):GetHei5UnreceiveAward() > 0
		end
	}

	if switch(arg0_25:getConfig("type"), var0_0.readyToAchieveDic, nil, arg0_25) then
		return true
	elseif arg0_25:getConfig("config_client").sub_act_id then
		local var2_25 = getProxy(ActivityProxy):getActivityById(arg0_25:getConfig("config_client").sub_act_id)

		return var2_25 and not var2_25:isEnd() and var2_25:readyToAchieve()
	else
		return false
	end
end

function var0_0.IsShowTipById(arg0_81)
	var0_0.ShowTipTableById = var0_0.ShowTipTableById or {
		[ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE] = function()
			local var0_82 = getProxy(SkirmishProxy)

			var0_82:UpdateSkirmishProgress()

			local var1_82 = var0_82:getRawData()
			local var2_82 = 0
			local var3_82 = 0

			for iter0_82, iter1_82 in ipairs(var1_82) do
				local var4_82 = iter1_82:GetState()

				var2_82 = var4_82 > SkirmishVO.StateInactive and var2_82 + 1 or var2_82
				var3_82 = var4_82 == SkirmishVO.StateClear and var3_82 + 1 or var3_82
			end

			return var3_82 < var2_82
		end,
		[ActivityConst.POCKY_SKIN_LOGIN] = function()
			local var0_83 = arg0_81:getConfig("config_client").linkids
			local var1_83 = getProxy(TaskProxy)
			local var2_83 = getProxy(ActivityProxy)
			local var3_83 = var2_83:getActivityById(var0_83[1])
			local var4_83 = var2_83:getActivityById(var0_83[2])
			local var5_83 = var2_83:getActivityById(var0_83[3])

			assert(var3_83 and var4_83 and var5_83)

			local function var6_83()
				return var3_83 and var3_83:readyToAchieve()
			end

			local function var7_83()
				return var4_83 and var4_83:readyToAchieve()
			end

			local function var8_83()
				local var0_86 = _.flatten(arg0_81:getConfig("config_data"))

				for iter0_86 = 1, math.min(#var0_86, var4_83.data3) do
					local var1_86 = var0_86[iter0_86]
					local var2_86 = var1_83:getTaskById(var1_86)

					if var2_86 and var2_86:isFinish() and not var2_86:isReceive() then
						return true
					end
				end
			end

			local function var9_83()
				if not (var5_83 and var5_83:readyToAchieve()) or not var3_83 then
					return false
				end

				local var0_87 = ActivityPtData.New(var3_83)

				return var0_87.level >= #var0_87.targets
			end

			return var8_83() or var6_83() or var7_83() or var9_83()
		end,
		[ActivityConst.TOWERCLIMBING_SIGN] = function()
			local var0_88 = getProxy(MiniGameProxy):GetHubByHubId(9)
			local var1_88 = var0_88.ultimate
			local var2_88 = var0_88:getConfig("reward_need")
			local var3_88 = var0_88.usedtime

			return var1_88 == 0 and var2_88 <= var3_88
		end,
		[pg.activity_const.NEWYEAR_SNACK_PAGE_ID.act_id] = NewYearSnackPage.IsTip,
		[ActivityConst.WWF_TASK_ID] = WWFPtPage.IsShowRed,
		[ActivityConst.NEWMEIXIV4_SKIRMISH_ID] = NewMeixiV4SkirmishPage.IsShowRed,
		[ActivityConst.JIUJIU_YOYO_ID] = JiujiuYoyoPage.IsShowRed,
		[ActivityConst.SENRANKAGURA_TRAIN_ACT_ID] = SenrankaguraTrainScene.IsShowRed,
		[ActivityConst.DORM_SIGN_ID] = DormSignPage.IsShowRed,
		[ActivityConst.DORM_SIGN_ID_2] = DormSignTwoPage.IsShowRed,
		[ActivityConst.ISLAND_SIGN_ID] = IslandSignPage.IsShowRed,
		[ActivityConst.GOASTSTORYACTIVITY_ID] = GhostSkinPageLayer.IsShowRed,
		[ActivityConst.YUMIA_BASE_ACT_ID] = YoumiyaStrongholdLayer.ShouldShowTip,
		[ActivityConst.NINJA_CITY_MAIN_ACTIVITY_ID] = function()
			if CityRebuildBookLayer.ShouldShowTip() or CityRebuildTasksLayer.ShouldShowTip() then
				return true
			end

			return false
		end,
		[ActivityConst.SAILING_SHIP_3_SKIN_ACT_ID] = SailingShip3SkinLayer.ShouldShowTip,
		[ActivityConst.HelenaPT_ACT_ID] = function()
			local var0_90 = getProxy(ActivityProxy):getActivityById(ActivityConst.HelenaPT_ACT_ID)

			return HelenaScenarioPage:IsShowRed(var0_90)
		end
	}

	local var0_81 = var0_0.ShowTipTableById[arg0_81.id]

	return tobool(var0_81), var0_81 and var0_81()
end

function var0_0.isShow(arg0_91)
	if LOCK_SKIN_US then
		local var0_91 = pg.gameset.levellimit_skinstory.key_value
		local var1_91 = pg.gameset.levellimit_skinstory.description

		if var0_91 >= getProxy(PlayerProxy):getRawData().level and table.contains(var1_91, arg0_91.id) then
			return false
		end
	end

	local var2_91 = arg0_91:getConfig("page_info")

	if arg0_91:getConfig("is_show") <= 0 then
		return false
	elseif underscore.any({
		var2_91.ui_name,
		var2_91.ui_name2
	}, function(arg0_92)
		return not checkABExist(string.format("ui/%s", arg0_92))
	end) then
		warning(string.format("activity:%d without ui:%s", arg0_91.id, table.concat({
			var2_91.ui_name,
			var2_91.ui_name2
		}, " or ")))

		return false
	end

	if arg0_91:getConfig("type") == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		return arg0_91.data1 ~= 0
	elseif arg0_91:getConfig("type") == ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY then
		local var3_91 = arg0_91:getConfig("config_client").display_link

		if var3_91 then
			return underscore.any(var3_91, function(arg0_93)
				return arg0_93[2] == 0 or pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_93[2]].time)
			end)
		end
	elseif arg0_91:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SURVEY then
		local var4_91 = getProxy(ActivityProxy)
		local var5_91 = var4_91:isSurveyOpen()
		local var6_91 = var4_91:isSurveyDone()

		return var5_91 and not var6_91
	elseif arg0_91:getConfig("type") == ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE then
		if getProxy(ShopsProxy):getActivityShops() == nil then
			return false
		end

		local var7_91 = arg0_91:getConfig("config_client")
		local var8_91 = getProxy(PlayerProxy):getData():getResource(var7_91.uPtId)
		local var9_91 = #var7_91.goodsId + 1

		return var9_91 > var9_91 - _.reduce(var7_91.goodsId, 0, function(arg0_94, arg1_94)
			return arg0_94 + getProxy(ShopsProxy):getActivityShopById(var7_91.shopId):GetCommodityById(arg1_94):GetPurchasableCnt()
		end)
	elseif arg0_91:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_RYZA and table.contains({
		ActivityConst.DORM_SIGN_ID,
		ActivityConst.DORM_SIGN_ID_2
	}, arg0_91:getConfig("id")) then
		return #getProxy(ActivityProxy):getActivityById(arg0_91:getConfig("id")):getConfig("config_data") ~= #getProxy(ActivityTaskProxy):getFinishTaskById(arg0_91:getConfig("id"))
	end

	return true
end

function var0_0.isAfterShow(arg0_95)
	if arg0_95.configId == ActivityConst.UR_TASK_ACT_ID or arg0_95.configId == ActivityConst.SPECIAL_WEAPON_ACT_ID then
		local var0_95 = getProxy(TaskProxy)

		return underscore.all(arg0_95:getConfig("config_data")[1], function(arg0_96)
			local var0_96 = var0_95:getTaskVO(arg0_96)

			return var0_96 and var0_96:isReceive()
		end)
	end

	return false
end

function var0_0.getShowPriority(arg0_97)
	return arg0_97:getConfig("is_show")
end

function var0_0.isCorePage(arg0_98, arg1_98)
	return arg0_98:getConfig("page_core") == arg1_98
end

function var0_0.left4Day(arg0_99)
	if arg0_99.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 345600 then
		return true
	end

	return false
end

function var0_0.getAwardInfos(arg0_100)
	return arg0_100.data1KeyValueList or {}
end

function var0_0.updateData(arg0_101, arg1_101, arg2_101)
	if arg0_101:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if not arg0_101:getAwardInfos()[arg1_101] then
			arg0_101.data1KeyValueList[arg1_101] = {}
		end

		for iter0_101, iter1_101 in ipairs(arg2_101) do
			if arg0_101.data1KeyValueList[arg1_101][iter1_101] then
				arg0_101.data1KeyValueList[arg1_101][iter1_101] = arg0_101.data1KeyValueList[arg1_101][iter1_101] + 1
			else
				arg0_101.data1KeyValueList[arg1_101][iter1_101] = 1
			end
		end
	end
end

function var0_0.getTaskShip(arg0_102)
	return arg0_102:getConfig("config_client")[1]
end

function var0_0.getNotificationMsg(arg0_103)
	local var0_103 = arg0_103:getConfig("type")
	local var1_103 = ActivityProxy.ACTIVITY_SHOW_AWARDS

	if var0_103 == ActivityConst.ACTIVITY_TYPE_SHOP or var0_103 == ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE then
		var1_103 = ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS
	elseif var0_103 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		var1_103 = ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS
	elseif var0_103 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		var1_103 = ActivityProxy.ACTIVITY_SHOW_REFLUX_AWARDS
	elseif var0_103 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS or var0_103 == ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER then
		var1_103 = ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS
	end

	return var1_103
end

function var0_0.getDayIndex(arg0_104)
	local var0_104 = arg0_104:getStartTime()
	local var1_104 = pg.TimeMgr.GetInstance()
	local var2_104 = var1_104:GetServerTime()

	return var1_104:DiffDay(var0_104, var2_104) + 1
end

function var0_0.getStartTime(arg0_105)
	local var0_105, var1_105 = parseTimeConfig(arg0_105:getConfig("time"))

	if var1_105 and var1_105[1] == "newuser" then
		return arg0_105.stopTime - var1_105[3] * 86400
	else
		return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_105[2])
	end
end

function var0_0.getNDay(arg0_106, arg1_106)
	arg1_106 = arg1_106 or arg0_106:getStartTime()

	local var0_106 = pg.TimeMgr.GetInstance()

	return var0_106:DiffDay(arg1_106, var0_106:GetServerTime()) + 1
end

function var0_0.isVariableTime(arg0_107)
	local var0_107, var1_107 = parseTimeConfig(arg0_107:getConfig("time"))

	return var1_107 and var1_107[1] == "newuser"
end

function var0_0.setSpecialData(arg0_108, arg1_108, arg2_108)
	arg0_108.speciaData = arg0_108.speciaData and arg0_108.speciaData or {}
	arg0_108.speciaData[arg1_108] = arg2_108
end

function var0_0.getSpecialData(arg0_109, arg1_109)
	return arg0_109.speciaData and arg0_109.speciaData[arg1_109] and arg0_109.speciaData[arg1_109] or nil
end

function var0_0.canPermanentFinish(arg0_110)
	local var0_110 = arg0_110:getConfig("type")

	if var0_110 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		local var1_110 = arg0_110:getConfig("config_data")
		local var2_110 = getProxy(TaskProxy)

		return underscore.all(underscore.flatten({
			var1_110[#var1_110]
		}), function(arg0_111)
			return var2_110:getFinishTaskById(arg0_111) ~= nil
		end)
	elseif var0_110 == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		local var3_110 = ActivityPtData.New(arg0_110)

		return var3_110.level >= #var3_110.targets
	end

	return false
end

function var0_0.GetShopTime(arg0_112)
	local var0_112 = pg.TimeMgr.GetInstance()
	local var1_112 = arg0_112:getStartTime()
	local var2_112 = arg0_112.stopTime

	return var0_112:STimeDescS(var1_112, "%y.%m.%d") .. " - " .. var0_112:STimeDescS(var2_112, "%y.%m.%d")
end

function var0_0.GetCrusingUnreceiveAward(arg0_113)
	assert(arg0_113:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_113 = pg.battlepass_event_pt[arg0_113.id]
	local var1_113 = {}
	local var2_113 = {}

	for iter0_113, iter1_113 in ipairs(arg0_113.data1_list) do
		var2_113[iter1_113] = true
	end

	for iter2_113, iter3_113 in ipairs(var0_113.target) do
		if iter3_113 > arg0_113.data1 then
			break
		elseif not var2_113[iter3_113] then
			table.insert(var1_113, Drop.Create(pg.battlepass_event_award[var0_113.award[iter2_113]].drop_client))
		end
	end

	if arg0_113.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1_113)
	end

	local var3_113 = {}

	for iter4_113, iter5_113 in ipairs(arg0_113.data2_list) do
		var3_113[iter5_113] = true
	end

	for iter6_113, iter7_113 in ipairs(var0_113.target) do
		if iter7_113 > arg0_113.data1 then
			break
		elseif not var3_113[iter7_113] then
			table.insert(var1_113, Drop.Create(pg.battlepass_event_award[var0_113.award_pay[iter6_113]].drop_client))
		end
	end

	return PlayerConst.MergePassItemDrop(var1_113)
end

function var0_0.GetCrusingInfo(arg0_114)
	assert(arg0_114:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_114 = pg.battlepass_event_pt[arg0_114.id]
	local var1_114 = var0_114.pt
	local var2_114 = {}
	local var3_114 = {}

	for iter0_114, iter1_114 in ipairs(var0_114.key_point_display) do
		var3_114[iter1_114] = true
	end

	for iter2_114, iter3_114 in ipairs(var0_114.target) do
		table.insert(var2_114, {
			id = iter2_114,
			pt = iter3_114,
			award = pg.battlepass_event_award[var0_114.award[iter2_114]].drop_client,
			award_pay = pg.battlepass_event_award[var0_114.award_pay[iter2_114]].drop_client,
			isImportent = var3_114[iter2_114]
		})
	end

	local var4_114 = arg0_114.data1
	local var5_114 = arg0_114.data2 == 1
	local var6_114 = {}

	for iter4_114, iter5_114 in ipairs(arg0_114.data1_list) do
		var6_114[iter5_114] = true
	end

	local var7_114 = {}

	for iter6_114, iter7_114 in ipairs(arg0_114.data2_list) do
		var7_114[iter7_114] = true
	end

	local var8_114 = 0

	for iter8_114, iter9_114 in ipairs(var2_114) do
		if var4_114 < iter9_114.pt then
			break
		else
			var8_114 = iter8_114
		end
	end

	return {
		ptId = var1_114,
		awardList = var2_114,
		pt = var4_114,
		isPay = var5_114,
		awardDic = var6_114,
		awardPayDic = var7_114,
		phase = var8_114
	}
end

function var0_0.GetHei5Info(arg0_115)
	local var0_115 = pg.black_friday_battlepass_event_pt[arg0_115.id]
	local var1_115 = var0_115.pt
	local var2_115 = {}
	local var3_115 = {}

	for iter0_115, iter1_115 in ipairs(var0_115.key_point_display) do
		var3_115[iter1_115] = true
	end

	for iter2_115, iter3_115 in ipairs(var0_115.target) do
		table.insert(var2_115, {
			id = iter2_115,
			pt = iter3_115,
			award = pg.black_friday_battlepass_event_award[var0_115.award[iter2_115]].drop_client,
			award_pay = pg.black_friday_battlepass_event_award[var0_115.award_pay[iter2_115]].drop_client,
			isImportent = var3_115[iter2_115]
		})
	end

	local var4_115 = arg0_115.data1
	local var5_115 = arg0_115.data2 == 1
	local var6_115 = {}

	for iter4_115, iter5_115 in ipairs(arg0_115.data1_list) do
		var6_115[iter5_115] = true
	end

	local var7_115 = {}

	for iter6_115, iter7_115 in ipairs(arg0_115.data2_list) do
		var7_115[iter7_115] = true
	end

	local var8_115 = 0

	for iter8_115, iter9_115 in ipairs(var2_115) do
		if var4_115 < iter9_115.pt then
			break
		else
			var8_115 = iter8_115
		end
	end

	return {
		ptId = var1_115,
		awardList = var2_115,
		pt = var4_115,
		isPay = var5_115,
		awardDic = var6_115,
		awardPayDic = var7_115,
		phase = var8_115
	}
end

function var0_0.GetHei5UnreceiveAward(arg0_116)
	local var0_116 = pg.black_friday_battlepass_event_pt[arg0_116.id]
	local var1_116 = {}
	local var2_116 = {}

	for iter0_116, iter1_116 in ipairs(arg0_116.data1_list) do
		var2_116[iter1_116] = true
	end

	for iter2_116, iter3_116 in ipairs(var0_116.target) do
		if iter3_116 > arg0_116.data1 then
			break
		elseif not var2_116[iter3_116] then
			table.insert(var1_116, Drop.Create(pg.black_friday_battlepass_event_award[var0_116.award[iter2_116]].drop_client))
		end
	end

	if arg0_116.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1_116)
	end

	local var3_116 = {}

	for iter4_116, iter5_116 in ipairs(arg0_116.data2_list) do
		var3_116[iter5_116] = true
	end

	for iter6_116, iter7_116 in ipairs(var0_116.target) do
		if iter7_116 > arg0_116.data1 then
			break
		elseif not var3_116[iter7_116] then
			table.insert(var1_116, Drop.Create(pg.black_friday_battlepass_event_award[var0_116.award_pay[iter6_116]].drop_client))
		end
	end

	return PlayerConst.MergePassItemDrop(var1_116)
end

function var0_0.IsActivityReady(arg0_117)
	return arg0_117 and not arg0_117:isEnd() and arg0_117:readyToAchieve()
end

function var0_0.GetEndTimeStrByConfig(arg0_118)
	local var0_118 = arg0_118:getConfig("time")

	if type(var0_118) == "table" then
		local var1_118 = var0_118[3]
		local var2_118 = var1_118[1][2]
		local var3_118 = var1_118[1][3]

		return var2_118 .. "." .. var3_118
	else
		return ""
	end
end

function var0_0.NeedLoginRedPoint(arg0_119)
	return PlayerPrefs.GetString(arg0_119:GetLoginRedPointKey(), "") ~= arg0_119:GetLoginRedPointValue()
end

function var0_0.SetLoginRedPoint(arg0_120)
	PlayerPrefs.SetString(arg0_120:GetLoginRedPointKey(), arg0_120:GetLoginRedPointValue())
end

function var0_0.GetLoginRedPointValue(arg0_121)
	return pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
end

function var0_0.GetLoginRedPointKey(arg0_122)
	local var0_122 = arg0_122:GetPlayerID()

	return string.format("%s_%s", var0_122, arg0_122.id)
end

function var0_0.GetPlayerID(arg0_123)
	return getProxy(PlayerProxy):getPlayerId()
end

function var0_0.GetConfigClientSetting(arg0_124, arg1_124)
	return arg0_124:getConfig("config_client")[arg1_124]
end

return var0_0
