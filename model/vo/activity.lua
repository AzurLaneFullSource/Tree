local var0_0 = class("Activity", import(".BaseVO"))
local var1_0

function var0_0.GetType2Class()
	if var1_0 then
		return var1_0
	end

	var1_0 = {
		[ActivityConst.ACTIVITY_TYPE_INSTAGRAM] = InstagramActivity,
		[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = BeatMonterNianActivity,
		[ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT] = CollectionEventActivity,
		[ActivityConst.ACTIVITY_TYPE_RETURN_AWARD] = ReturnerActivity,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = BuildingBuffActivity,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = BuildingBuff2Activity,
		[ActivityConst.ACTIVITY_TYPE_ATELIER_LINK] = AtelierActivity,
		[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = ActivityBossActivity,
		[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = BossRushActivity,
		[ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK] = BossRushRankActivity,
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
		[ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE] = SingleEventActivity,
		[ActivityConst.ACTIVITY_TYPE_LINER] = LinerActivity,
		[ActivityConst.ACTIVITY_TYPE_TOWN] = TownActivity,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = AirFightActivity,
		[ActivityConst.ACTIVITY_TYPE_NOT_TRACEABLE] = NotTraceableTaskActivity
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

function var0_0.getStrData1(arg0_13)
	return arg0_13.str_data1
end

function var0_0.getData3(arg0_14)
	return arg0_14.data3
end

function var0_0.getData1List(arg0_15)
	return arg0_15.data1_list
end

function var0_0.bindConfigTable(arg0_16)
	return pg.activity_template
end

function var0_0.getDataConfigTable(arg0_17)
	local var0_17 = arg0_17:getConfig("type")
	local var1_17 = arg0_17:getConfig("config_id")

	if var0_17 == ActivityConst.ACTIVITY_TYPE_MONOPOLY then
		return pg.activity_event_monopoly[tonumber(var1_17)]
	elseif var0_17 == ActivityConst.ACTIVITY_TYPE_PIZZA_PT or var0_17 == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		return pg.activity_event_pt[tonumber(var1_17)]
	elseif var0_17 == ActivityConst.ACTIVITY_TYPE_VOTE then
		return pg.activity_vote[tonumber(var1_17)]
	end
end

function var0_0.getDataConfig(arg0_18, arg1_18)
	local var0_18 = arg0_18:getDataConfigTable()

	assert(var0_18, "miss config : " .. arg0_18.id)

	return var0_18 and var0_18[arg1_18]
end

function var0_0.isEnd(arg0_19)
	return arg0_19.stopTime > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_19.stopTime
end

function var0_0.increaseUsedCount(arg0_20, arg1_20)
	if arg1_20 == 1 then
		arg0_20.data1 = arg0_20.data1 + 1
	elseif arg1_20 == 2 then
		arg0_20.data2 = arg0_20.data2 + 1
	end
end

function var0_0.readyToAchieve(arg0_21)
	local var0_21, var1_21 = arg0_21:IsShowTipById()

	if var0_21 then
		return var1_21
	end

	var0_0.readyToAchieveDic = var0_0.readyToAchieveDic or {
		[ActivityConst.ACTIVITY_TYPE_CARD_PAIRS] = function(arg0_22)
			local var0_22 = os.difftime(pg.TimeMgr.GetInstance():GetServerTime(), arg0_22.data3)

			return math.ceil(var0_22 / 86400) > arg0_22.data2 and arg0_22.data2 < arg0_22:getConfig("config_data")[4]
		end,
		[ActivityConst.ACTIVITY_TYPE_LEVELAWARD] = function(arg0_23)
			local var0_23 = getProxy(PlayerProxy):getRawData()
			local var1_23 = pg.activity_level_award[arg0_23:getConfig("config_id")]

			for iter0_23 = 1, #var1_23.front_drops do
				local var2_23 = var1_23.front_drops[iter0_23][1]

				if var2_23 <= var0_23.level and not _.include(arg0_23.data1_list, var2_23) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_STORY_AWARD] = function(arg0_24)
			local var0_24 = getProxy(PlayerProxy):getRawData()
			local var1_24 = pg.activity_event_chapter_award[arg0_24:getConfig("config_id")]

			for iter0_24 = 1, #var1_24.chapter do
				local var2_24 = var1_24.chapter[iter0_24]

				if getProxy(ChapterProxy):isClear(var2_24) and not _.include(arg0_24.data1_list, var2_24) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASKS] = function(arg0_25)
			local var0_25 = getProxy(TaskProxy)
			local var1_25 = _.flatten(arg0_25:getConfig("config_data"))

			if _.any(var1_25, function(arg0_26)
				local var0_26 = var0_25:getTaskById(arg0_26)

				return var0_26 and var0_26:isFinish() and not var0_26:isReceive()
			end) then
				return true
			end

			local var2_25 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

			if var2_25 and not var2_25:isEnd() and var2_25:getConfig("config_client").linkActID == arg0_25.id and var2_25:readyToAchieve() then
				return true
			end

			if arg0_25:getConfig("config_client") and arg0_25:getConfig("config_client").decodeGameId then
				local var3_25 = arg0_25:getConfig("config_client").decodeGameId
				local var4_25 = getProxy(MiniGameProxy):GetHubByGameId(var3_25)

				if var4_25 then
					local var5_25 = arg0_25:getConfig("config_data")
					local var6_25 = var5_25[#var5_25]
					local var7_25 = _.all(var6_25, function(arg0_27)
						return getProxy(TaskProxy):getFinishTaskById(arg0_27) ~= nil
					end)

					if var4_25.ultimate <= 0 and var7_25 then
						return true
					end
				end
			end

			if arg0_25:getConfig("config_client") and arg0_25:getConfig("config_client").linkTaskPoolAct then
				local var8_25 = arg0_25:getConfig("config_client").linkTaskPoolAct
				local var9_25 = getProxy(ActivityProxy):getActivityById(var8_25)

				if var9_25 and var9_25:readyToAchieve() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_LIST] = function(...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_TASKS](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = function(arg0_29)
			local var0_29 = arg0_29:GetCountForHitMonster()

			return not (arg0_29:GetDataConfig("hp") <= arg0_29.data3) and var0_29 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DODGEM] = function(arg0_30)
			local var0_30 = pg.TimeMgr.GetInstance()
			local var1_30 = var0_30:DiffDay(arg0_30.data1, var0_30:GetServerTime()) + 1
			local var2_30 = arg0_30:getConfig("config_id")

			if var2_30 == 1 then
				return arg0_30.data4 == 0 and arg0_30.data2 >= 7 or defaultValue(arg0_30.data2_list[1], 0) > 0 or defaultValue(arg0_30.data2_list[2], 0) > 0 or arg0_30.data2 < math.min(var1_30, 7) or var1_30 > arg0_30.data3
			elseif var2_30 == 2 then
				return arg0_30.data4 == 0 and arg0_30.data2 >= 7 or defaultValue(arg0_30.data2_list[1], 0) > 0 or defaultValue(arg0_30.data2_list[2], 0) > 0 or arg0_30.data2 < math.min(var1_30, 7)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MONOPOLY] = function(arg0_31)
			local var0_31 = arg0_31.data1
			local var1_31 = arg0_31.data1_list[1]
			local var2_31 = arg0_31.data1_list[2]
			local var3_31 = arg0_31.data2_list[1]
			local var4_31 = arg0_31.data2_list[2]
			local var5_31 = pg.TimeMgr.GetInstance():GetServerTime()
			local var6_31 = math.ceil((var5_31 - var0_31) / 86400) * arg0_31:getDataConfig("daily_time") + var1_31 - var2_31
			local var7_31 = var3_31 - var4_31

			return var6_31 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PIZZA_PT] = function(arg0_32)
			local var0_32 = ActivityPtData.New(arg0_32):CanGetAward()
			local var1_32 = true

			if arg0_32:getConfig("config_client") then
				local var2_32 = arg0_32:getConfig("config_client").task_act_id

				if var2_32 and var2_32 ~= 0 and pg.activity_template[var2_32] then
					local var3_32 = pg.activity_template[var2_32]
					local var4_32 = _.flatten(var3_32.config_data)

					if var4_32 and #var4_32 > 0 then
						local var5_32 = getProxy(TaskProxy)

						for iter0_32 = 1, #var4_32 do
							local var6_32 = var5_32:getTaskById(var4_32[iter0_32])

							if var6_32 and var6_32:isFinish() then
								return true
							end
						end
					end
				end
			end

			local var7_32 = false
			local var8_32 = arg0_32:getConfig("config_client").fireworkActID

			if var8_32 and var8_32 ~= 0 then
				local var9_32 = getProxy(ActivityProxy):getActivityById(var8_32)

				var7_32 = var9_32 and var9_32:readyToAchieve() or false
			end

			local var10_32 = arg0_32:getConfig("config_client")[2]
			local var11_32 = type(var10_32) == "number" and ManualSignActivity.IsManualSignActAndAnyAwardCanGet(var10_32)

			return var0_32 and var1_32 or var7_32 or var11_32
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = function(...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_PIZZA_PT](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_RETURN_AWARD] = function(arg0_34)
			local var0_34 = arg0_34.data1

			if var0_34 == 1 then
				local var1_34 = pg.activity_template_headhunting[arg0_34.id]
				local var2_34 = var1_34.target
				local var3_34 = 0

				for iter0_34, iter1_34 in ipairs(arg0_34:getClientList()) do
					var3_34 = var3_34 + iter1_34:getPt()
				end

				local var4_34 = 0

				for iter2_34 = #var2_34, 1, -1 do
					if table.contains(arg0_34.data1_list, var2_34[iter2_34]) then
						var4_34 = iter2_34

						break
					end
				end

				local var5_34 = var1_34.drop_client
				local var6_34 = math.min(var4_34 + 1, #var5_34)
				local var7_34 = _.any(var1_34.tasklist, function(arg0_35)
					local var0_35 = getProxy(TaskProxy):getTaskById(arg0_35)

					return var0_35 and var0_35:isFinish() and not var0_35:isReceive()
				end)

				return var3_34 >= var2_34[var6_34] and var4_34 ~= #var5_34 or var7_34
			elseif var0_34 == 2 then
				local var8_34 = getProxy(TaskProxy)
				local var9_34 = pg.activity_template_returnner[arg0_34.id]

				return _.any(_.flatten(var9_34.task_list), function(arg0_36)
					local var0_36 = var8_34:getTaskById(arg0_36)

					return var0_36 and var0_36:isFinish()
				end)
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_37)
			local var0_37 = getProxy(MiniGameProxy):GetHubByHubId(arg0_37:getConfig("config_id"))

			if var0_37.count > 0 then
				return true
			end

			if var0_37:getConfig("reward") ~= 0 and var0_37.usedtime >= var0_37:getConfig("reward_need") and var0_37.ultimate == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function(arg0_38)
			local var0_38 = pg.activity_event_turning[arg0_38:getConfig("config_id")]
			local var1_38 = arg0_38.data4

			if var1_38 ~= 0 then
				local var2_38 = var0_38.task_table[var1_38]
				local var3_38 = getProxy(TaskProxy)

				for iter0_38, iter1_38 in ipairs(var2_38) do
					if (var3_38:getTaskById(iter1_38) or var3_38:getFinishTaskById(iter1_38)):getTaskStatus() == 1 then
						return true
					end
				end

				local var4_38 = pg.TimeMgr.GetInstance():DiffDay(arg0_38.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var4_38, 1, pg.activity_event_turning[arg0_38:getConfig("config_id")].total_num) > arg0_38.data3 then
					for iter2_38, iter3_38 in ipairs(var2_38) do
						if (var3_38:getTaskById(iter3_38) or var3_38:getFinishTaskById(iter3_38)):getTaskStatus() ~= 2 then
							return false
						end
					end

					return true
				end
			elseif var1_38 == 0 then
				local var5_38 = pg.TimeMgr.GetInstance():DiffDay(arg0_38.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var5_38, 1, pg.activity_event_turning[arg0_38:getConfig("config_id")].total_num) > arg0_38.data3 then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function(arg0_39)
			return not (arg0_39.data2 > 0)
		end,
		[ActivityConst.ACTIVITY_TYPE_SHRINE] = function(arg0_40)
			local var0_40 = arg0_40:getConfig("config_client").story
			local var1_40 = var0_40 and #var0_40 or 7
			local var2_40 = pg.TimeMgr.GetInstance():DiffDay(arg0_40.data3, pg.TimeMgr.GetInstance():GetServerTime()) + 1
			local var3_40 = math.clamp(var2_40, 1, var1_40)
			local var4_40 = pg.NewStoryMgr.GetInstance()
			local var5_40 = math.clamp(arg0_40.data2, 0, var1_40)

			for iter0_40 = 1, var3_40 do
				local var6_40 = var0_40[iter0_40][1]

				if var6_40 and iter0_40 <= var5_40 and not var4_40:IsPlayed(var6_40) then
					return true
				end
			end

			if var1_40 <= var3_40 and var1_40 <= arg0_40.data2 and not (arg0_40.data1 > 0) then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = function(arg0_41)
			local var0_41 = arg0_41:getConfig("config_client")[3]
			local var1_41 = pg.TimeMgr.GetInstance()
			local var2_41 = var1_41:DiffDay(arg0_41.data3, var1_41:GetServerTime()) + 1 - arg0_41.data2

			return math.clamp(var2_41, 0, #var0_41 - arg0_41.data2) > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function(arg0_42)
			local var0_42 = arg0_42:GetBuildingIds()

			for iter0_42, iter1_42 in ipairs(var0_42) do
				local var1_42 = arg0_42:GetBuildingLevel(iter1_42)
				local var2_42 = pg.activity_event_building[iter1_42]

				if var2_42 and var1_42 < #var2_42.buff then
					local var3_42 = var2_42.material[var1_42]

					if underscore.all(var3_42, function(arg0_43)
						local var0_43 = arg0_43[1]
						local var1_43 = arg0_43[2]
						local var2_43 = arg0_43[3]
						local var3_43 = 0

						if var0_43 == DROP_TYPE_VITEM then
							local var4_43 = AcessWithinNull(Item.getConfigData(var1_43), "link_id")

							assert(var4_43 == arg0_42.id)

							var3_43 = arg0_42:GetMaterialCount(var1_43)
						elseif var0_43 > DROP_TYPE_USE_ACTIVITY_DROP then
							local var5_43 = AcessWithinNull(pg.activity_drop_type[var0_43], "activity_id")

							assert(var5_43)

							bagAct = getProxy(ActivityProxy):getActivityById(var5_43)
							var3_43 = bagAct:getVitemNumber(var1_43)
						end

						return var2_43 <= var3_43
					end) then
						return true
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function(arg0_44, ...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF](arg0_44, ...) or arg0_44:CanRequest()
		end,
		[ActivityConst.ACTIVITY_TYPE_EXPEDITION] = function(arg0_45)
			if arg0_45.data3 > 0 and arg0_45.data1 ~= 0 then
				return true
			else
				for iter0_45 = 1, #arg0_45.data1_list do
					if not bit.band(arg0_45.data1_list[iter0_45], ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
						if bit.band(arg0_45.data1_list[iter0_45], ActivityConst.EXPEDITION_TYPE_OPEN) ~= 0 then
							return true
						elseif bit.band(arg0_45.data1_list[iter0_45], ActivityConst.EXPEDITION_TYPE_BAOXIANG) ~= 0 then
							return true
						elseif bit.band(arg0_45.data1_list[iter0_45], ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 then
							return true
						end
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY] = function(arg0_46)
			local var0_46 = arg0_46:getConfig("config_client")

			if var0_46 and var0_46.linkGameHubID then
				local var1_46 = getProxy(MiniGameProxy):GetHubByHubId(var0_46.linkGameHubID)

				if var1_46 then
					if var0_46.trimRed then
						if var1_46.ultimate == 1 then
							return false
						end

						if var1_46.usedtime == var1_46:getConfig("reward_need") then
							return true
						end
					end

					return var1_46.count > 0
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BB] = function(arg0_47)
			return arg0_47.data2 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = function(arg0_48)
			local var0_48 = arg0_48.data1_list
			local var1_48 = arg0_48.data2_list
			local var2_48 = arg0_48:GetPicturePuzzleIds()
			local var3_48 = arg0_48:getConfig("config_client").linkActID

			if var3_48 then
				local var4_48 = getProxy(ActivityProxy):getActivityById(var3_48)

				if var4_48 and var4_48:readyToAchieve() then
					return true
				end
			end

			if _.any(var2_48, function(arg0_49)
				local var0_49 = table.contains(var1_48, arg0_49)
				local var1_49 = table.contains(var0_48, arg0_49)

				return not var0_49 and var1_49
			end) then
				return true
			end

			local var5_48 = pg.activity_event_picturepuzzle[arg0_48.id]

			if var5_48 and var5_48.chapter > 0 and arg0_48.data1 < 1 then
				return true
			end

			if var5_48 and #var5_48.auto_finish_args > 0 and arg0_48.data1 == 1 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = function(arg0_50)
			return AirFightActivity.readyToAchieve(arg0_50)
		end,
		[ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE] = function(arg0_51)
			local var0_51 = WorldInPictureActiviyData.New(arg0_51)

			return not var0_51:IsTravelAll() and var0_51:GetTravelPoint() > 0 or var0_51:GetDrawPoint() > 0 and var0_51:AnyAreaCanDraw()
		end,
		[ActivityConst.ACTIVITY_TYPE_APRIL_REWARD] = function(arg0_52)
			if arg0_52.data1 == 0 then
				local var0_52 = arg0_52:getStartTime()
				local var1_52 = pg.TimeMgr.GetInstance():GetServerTime()

				if arg0_52:getConfig("config_client").autounlock <= var1_52 - var0_52 then
					return true
				end
			elseif arg0_52.data1 ~= 0 and arg0_52.data2 == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_POOL] = function(arg0_53)
			local var0_53 = arg0_53:getConfig("config_data")
			local var1_53 = getProxy(TaskProxy)

			if arg0_53.data1 >= #var0_53 then
				return false
			end

			local var2_53 = pg.TimeMgr.GetInstance()
			local var3_53 = (var2_53:DiffDay(arg0_53:getStartTime(), var2_53:GetServerTime()) + 1) * arg0_53:getConfig("config_id")

			var3_53 = var3_53 > #var0_53 and #var0_53 or var3_53

			local var4_53 = _.any(var0_53, function(arg0_54)
				local var0_54 = var1_53:getTaskById(arg0_54)

				return var0_54 and var0_54:isFinish()
			end)

			return var3_53 - arg0_53.data1 > 0 and var4_53
		end,
		[ActivityConst.ACTIVITY_TYPE_EVENT] = function(arg0_55)
			local var0_55 = getProxy(PlayerProxy):getData().id

			return PlayerPrefs.GetInt("ACTIVITY_TYPE_EVENT_" .. arg0_55.id .. "_" .. var0_55) == 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_OTHER] = function(arg0_56)
			if arg0_56.data2 and arg0_56.data2 <= 0 and arg0_56.data1 >= pg.activity_event_avatarframe[arg0_56:getConfig("config_id")].target then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = function(arg0_57)
			local var0_57, var1_57 = arg0_57:GetUpgradeCost()

			if arg0_57:GetSlotCount() < arg0_57:GetTotalSlotCount() and var1_57 <= arg0_57:GetCoins() then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function(arg0_58)
			local var0_58 = arg0_58:getConfig("config_data")[2][1]
			local var1_58 = arg0_58:getConfig("config_data")[2][2]
			local var2_58 = getProxy(PlayerProxy):getRawData():getResource(var0_58)

			if arg0_58.data1 > 0 and var1_58 <= var2_58 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD] = function(arg0_59)
			local var0_59 = pg.TimeMgr.GetInstance()

			return var0_59:GetServerTime() >= var0_59:GetTimeToNextTime(math.max(arg0_59.data1, arg0_59.data2))
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND] = function(arg0_60)
			for iter0_60, iter1_60 in pairs(getProxy(IslandProxy):GetNodeDic()) do
				if iter1_60:IsVisual() and iter1_60:RedDotHint() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = function(arg0_61)
			return Spring2Activity.readyToAchieve(arg0_61)
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE] = function(arg0_62)
			local var0_62 = #arg0_62.data2_list
			local var1_62 = arg0_62:getData1List()
			local var2_62 = arg0_62:getConfig("config_data")[2]

			if #var1_62 == #var2_62 then
				return false
			end

			local function var3_62()
				for iter0_63, iter1_63 in ipairs(var2_62) do
					if not table.contains(var1_62, iter1_63[1]) and var0_62 >= iter1_63[1] then
						return true
					end
				end

				return false
			end

			local function var4_62()
				local var0_64 = getProxy(PlayerProxy):getData().id

				return PlayerPrefs.GetInt("DAY_TIP_" .. arg0_62.id .. "_" .. var0_64 .. "_" .. arg0_62:getDayIndex()) == 0
			end

			return var3_62() or var4_62()
		end,
		[ActivityConst.ACTIVITY_TYPE_SURVEY] = function(arg0_65)
			local var0_65, var1_65 = getProxy(ActivityProxy):isSurveyOpen()
			local var2_65 = getProxy(ActivityProxy):isSurveyDone()

			return var0_65 and not var2_65 and not SurveyPage.IsEverEnter(var1_65)
		end,
		[ActivityConst.ACTIVITY_TYPE_ZUMA] = function(arg0_66)
			return LaunchBallActivityMgr.GetInvitationAble(arg0_66.id)
		end,
		[ActivityConst.ACTIVITY_TYPE_GIFT_UP] = function(arg0_67)
			local var0_67 = arg0_67:getConfig("config_client").gifts[2]
			local var1_67 = math.min(#var0_67, arg0_67:getNDay())

			return underscore(var0_67):chain():first(var1_67):any(function(arg0_68)
				local var0_68 = getProxy(ShopsProxy):GetGiftCommodity(arg0_68, Goods.TYPE_GIFT_PACKAGE)

				return var0_68:canPurchase() and var0_68:inTime() and not var0_68:IsGroupLimit()
			end):value()
		end,
		[ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE] = function(arg0_69)
			if getProxy(ShopsProxy):getActivityShops() == nil then
				return false
			end

			local var0_69 = arg0_69:getConfig("config_client")
			local var1_69 = getProxy(PlayerProxy):getData():getResource(var0_69.uPtId)
			local var2_69 = #var0_69.goodsId + 1
			local var3_69 = var2_69 - _.reduce(var0_69.goodsId, 0, function(arg0_70, arg1_70)
				return arg0_70 + getProxy(ShopsProxy):getActivityShopById(var0_69.shopId):GetCommodityById(arg1_70):GetPurchasableCnt()
			end)
			local var4_69 = var3_69 < var2_69 and pg.activity_shop_template[var0_69.goodsId[var3_69]] or nil

			return var3_69 < var2_69 and var1_69 >= var4_69.resource_num
		end
	}

	return switch(arg0_21:getConfig("type"), var0_0.readyToAchieveDic, nil, arg0_21)
end

function var0_0.IsShowTipById(arg0_71)
	var0_0.ShowTipTableById = var0_0.ShowTipTableById or {
		[ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE] = function()
			local var0_72 = getProxy(SkirmishProxy)

			var0_72:UpdateSkirmishProgress()

			local var1_72 = var0_72:getRawData()
			local var2_72 = 0
			local var3_72 = 0

			for iter0_72, iter1_72 in ipairs(var1_72) do
				local var4_72 = iter1_72:GetState()

				var2_72 = var4_72 > SkirmishVO.StateInactive and var2_72 + 1 or var2_72
				var3_72 = var4_72 == SkirmishVO.StateClear and var3_72 + 1 or var3_72
			end

			return var3_72 < var2_72
		end,
		[ActivityConst.POCKY_SKIN_LOGIN] = function()
			local var0_73 = arg0_71:getConfig("config_client").linkids
			local var1_73 = getProxy(TaskProxy)
			local var2_73 = getProxy(ActivityProxy)
			local var3_73 = var2_73:getActivityById(var0_73[1])
			local var4_73 = var2_73:getActivityById(var0_73[2])
			local var5_73 = var2_73:getActivityById(var0_73[3])

			assert(var3_73 and var4_73 and var5_73)

			local function var6_73()
				return var3_73 and var3_73:readyToAchieve()
			end

			local function var7_73()
				return var4_73 and var4_73:readyToAchieve()
			end

			local function var8_73()
				local var0_76 = _.flatten(arg0_71:getConfig("config_data"))

				for iter0_76 = 1, math.min(#var0_76, var4_73.data3) do
					local var1_76 = var0_76[iter0_76]
					local var2_76 = var1_73:getTaskById(var1_76)

					if var2_76 and var2_76:isFinish() and not var2_76:isReceive() then
						return true
					end
				end
			end

			local function var9_73()
				if not (var5_73 and var5_73:readyToAchieve()) or not var3_73 then
					return false
				end

				local var0_77 = ActivityPtData.New(var3_73)

				return var0_77.level >= #var0_77.targets
			end

			return var8_73() or var6_73() or var7_73() or var9_73()
		end,
		[ActivityConst.TOWERCLIMBING_SIGN] = function()
			local var0_78 = getProxy(MiniGameProxy):GetHubByHubId(9)
			local var1_78 = var0_78.ultimate
			local var2_78 = var0_78:getConfig("reward_need")
			local var3_78 = var0_78.usedtime

			return var1_78 == 0 and var2_78 <= var3_78
		end,
		[pg.activity_const.NEWYEAR_SNACK_PAGE_ID.act_id] = NewYearSnackPage.IsTip,
		[ActivityConst.WWF_TASK_ID] = WWFPtPage.IsShowRed,
		[ActivityConst.NEWMEIXIV4_SKIRMISH_ID] = NewMeixiV4SkirmishPage.IsShowRed,
		[ActivityConst.JIUJIU_YOYO_ID] = JiujiuYoyoPage.IsShowRed,
		[ActivityConst.SENRANKAGURA_TRAIN_ACT_ID] = SenrankaguraTrainScene.IsShowRed,
		[ActivityConst.DORM_SIGN_ID] = DormSignPage.IsShowRed,
		[ActivityConst.GOASTSTORYACTIVITY_ID] = GhostSkinPageLayer.IsShowRed
	}

	local var0_71 = var0_0.ShowTipTableById[arg0_71.id]

	return tobool(var0_71), var0_71 and var0_71()
end

function var0_0.isShow(arg0_79)
	local var0_79 = arg0_79:getConfig("page_info")

	if arg0_79:getConfig("is_show") <= 0 then
		return false
	elseif underscore.any({
		var0_79.ui_name,
		var0_79.ui_name2
	}, function(arg0_80)
		return not checkABExist(string.format("ui/%s", arg0_80))
	end) then
		warning(string.format("activity:%d without ui:%s", arg0_79.id, table.concat({
			var0_79.ui_name,
			var0_79.ui_name2
		}, " or ")))

		return false
	end

	if arg0_79:getConfig("type") == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		return arg0_79.data1 ~= 0
	elseif arg0_79:getConfig("type") == ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY then
		local var1_79 = arg0_79:getConfig("config_client").display_link

		if var1_79 then
			return underscore.any(var1_79, function(arg0_81)
				return arg0_81[2] == 0 or pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_81[2]].time)
			end)
		end
	elseif arg0_79:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SURVEY then
		local var2_79 = getProxy(ActivityProxy)
		local var3_79 = var2_79:isSurveyOpen()
		local var4_79 = var2_79:isSurveyDone()

		return var3_79 and not var4_79
	elseif arg0_79:getConfig("type") == ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE then
		if getProxy(ShopsProxy):getActivityShops() == nil then
			return false
		end

		local var5_79 = arg0_79:getConfig("config_client")
		local var6_79 = getProxy(PlayerProxy):getData():getResource(var5_79.uPtId)
		local var7_79 = #var5_79.goodsId + 1

		return var7_79 > var7_79 - _.reduce(var5_79.goodsId, 0, function(arg0_82, arg1_82)
			return arg0_82 + getProxy(ShopsProxy):getActivityShopById(var5_79.shopId):GetCommodityById(arg1_82):GetPurchasableCnt()
		end)
	elseif arg0_79:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_RYZA and table.contains({
		ActivityConst.DORM_SIGN_ID
	}, arg0_79:getConfig("id")) then
		return #getProxy(ActivityProxy):getActivityById(arg0_79:getConfig("id")):getConfig("config_data") ~= #getProxy(ActivityTaskProxy):getFinishTaskById(arg0_79:getConfig("id"))
	end

	return true
end

function var0_0.isAfterShow(arg0_83)
	if arg0_83.configId == ActivityConst.UR_TASK_ACT_ID or arg0_83.configId == ActivityConst.SPECIAL_WEAPON_ACT_ID then
		local var0_83 = getProxy(TaskProxy)

		return underscore.all(arg0_83:getConfig("config_data")[1], function(arg0_84)
			local var0_84 = var0_83:getTaskVO(arg0_84)

			return var0_84 and var0_84:isReceive()
		end)
	end

	return false
end

function var0_0.getShowPriority(arg0_85)
	return arg0_85:getConfig("is_show")
end

function var0_0.left4Day(arg0_86)
	if arg0_86.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 345600 then
		return true
	end

	return false
end

function var0_0.getAwardInfos(arg0_87)
	return arg0_87.data1KeyValueList or {}
end

function var0_0.updateData(arg0_88, arg1_88, arg2_88)
	if arg0_88:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if not arg0_88:getAwardInfos()[arg1_88] then
			arg0_88.data1KeyValueList[arg1_88] = {}
		end

		for iter0_88, iter1_88 in ipairs(arg2_88) do
			if arg0_88.data1KeyValueList[arg1_88][iter1_88] then
				arg0_88.data1KeyValueList[arg1_88][iter1_88] = arg0_88.data1KeyValueList[arg1_88][iter1_88] + 1
			else
				arg0_88.data1KeyValueList[arg1_88][iter1_88] = 1
			end
		end
	end
end

function var0_0.getTaskShip(arg0_89)
	return arg0_89:getConfig("config_client")[1]
end

function var0_0.getNotificationMsg(arg0_90)
	local var0_90 = arg0_90:getConfig("type")
	local var1_90 = ActivityProxy.ACTIVITY_SHOW_AWARDS

	if var0_90 == ActivityConst.ACTIVITY_TYPE_SHOP then
		var1_90 = ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS
	elseif var0_90 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		var1_90 = ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS
	elseif var0_90 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		var1_90 = ActivityProxy.ACTIVITY_SHOW_REFLUX_AWARDS
	elseif var0_90 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS or var0_90 == ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER then
		var1_90 = ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS
	end

	return var1_90
end

function var0_0.getDayIndex(arg0_91)
	local var0_91 = arg0_91:getStartTime()
	local var1_91 = pg.TimeMgr.GetInstance()
	local var2_91 = var1_91:GetServerTime()

	return var1_91:DiffDay(var0_91, var2_91) + 1
end

function var0_0.getStartTime(arg0_92)
	local var0_92, var1_92 = parseTimeConfig(arg0_92:getConfig("time"))

	if var1_92 and var1_92[1] == "newuser" then
		return arg0_92.stopTime - var1_92[3] * 86400
	else
		return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_92[2])
	end
end

function var0_0.getNDay(arg0_93, arg1_93)
	arg1_93 = arg1_93 or arg0_93:getStartTime()

	local var0_93 = pg.TimeMgr.GetInstance()

	return var0_93:DiffDay(arg1_93, var0_93:GetServerTime()) + 1
end

function var0_0.isVariableTime(arg0_94)
	local var0_94, var1_94 = parseTimeConfig(arg0_94:getConfig("time"))

	return var1_94 and var1_94[1] == "newuser"
end

function var0_0.setSpecialData(arg0_95, arg1_95, arg2_95)
	arg0_95.speciaData = arg0_95.speciaData and arg0_95.speciaData or {}
	arg0_95.speciaData[arg1_95] = arg2_95
end

function var0_0.getSpecialData(arg0_96, arg1_96)
	return arg0_96.speciaData and arg0_96.speciaData[arg1_96] and arg0_96.speciaData[arg1_96] or nil
end

function var0_0.canPermanentFinish(arg0_97)
	local var0_97 = arg0_97:getConfig("type")

	if var0_97 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		local var1_97 = arg0_97:getConfig("config_data")
		local var2_97 = getProxy(TaskProxy)

		return underscore.all(underscore.flatten({
			var1_97[#var1_97]
		}), function(arg0_98)
			return var2_97:getFinishTaskById(arg0_98) ~= nil
		end)
	elseif var0_97 == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		local var3_97 = ActivityPtData.New(arg0_97)

		return var3_97.level >= #var3_97.targets
	end

	return false
end

function var0_0.GetShopTime(arg0_99)
	local var0_99 = pg.TimeMgr.GetInstance()
	local var1_99 = arg0_99:getStartTime()
	local var2_99 = arg0_99.stopTime

	return var0_99:STimeDescS(var1_99, "%y.%m.%d") .. " - " .. var0_99:STimeDescS(var2_99, "%y.%m.%d")
end

function var0_0.GetCrusingUnreceiveAward(arg0_100)
	assert(arg0_100:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_100 = pg.battlepass_event_pt[arg0_100.id]
	local var1_100 = {}
	local var2_100 = {}

	for iter0_100, iter1_100 in ipairs(arg0_100.data1_list) do
		var2_100[iter1_100] = true
	end

	for iter2_100, iter3_100 in ipairs(var0_100.target) do
		if iter3_100 > arg0_100.data1 then
			break
		elseif not var2_100[iter3_100] then
			table.insert(var1_100, Drop.Create(pg.battlepass_event_award[var0_100.award[iter2_100]].drop_client))
		end
	end

	if arg0_100.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1_100)
	end

	local var3_100 = {}

	for iter4_100, iter5_100 in ipairs(arg0_100.data2_list) do
		var3_100[iter5_100] = true
	end

	for iter6_100, iter7_100 in ipairs(var0_100.target) do
		if iter7_100 > arg0_100.data1 then
			break
		elseif not var3_100[iter7_100] then
			table.insert(var1_100, Drop.Create(pg.battlepass_event_award[var0_100.award_pay[iter6_100]].drop_client))
		end
	end

	return PlayerConst.MergePassItemDrop(var1_100)
end

function var0_0.GetCrusingInfo(arg0_101)
	assert(arg0_101:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_101 = pg.battlepass_event_pt[arg0_101.id]
	local var1_101 = var0_101.pt
	local var2_101 = {}
	local var3_101 = {}

	for iter0_101, iter1_101 in ipairs(var0_101.key_point_display) do
		var3_101[iter1_101] = true
	end

	for iter2_101, iter3_101 in ipairs(var0_101.target) do
		table.insert(var2_101, {
			id = iter2_101,
			pt = iter3_101,
			award = pg.battlepass_event_award[var0_101.award[iter2_101]].drop_client,
			award_pay = pg.battlepass_event_award[var0_101.award_pay[iter2_101]].drop_client,
			isImportent = var3_101[iter2_101]
		})
	end

	local var4_101 = arg0_101.data1
	local var5_101 = arg0_101.data2 == 1
	local var6_101 = {}

	for iter4_101, iter5_101 in ipairs(arg0_101.data1_list) do
		var6_101[iter5_101] = true
	end

	local var7_101 = {}

	for iter6_101, iter7_101 in ipairs(arg0_101.data2_list) do
		var7_101[iter7_101] = true
	end

	local var8_101 = 0

	for iter8_101, iter9_101 in ipairs(var2_101) do
		if var4_101 < iter9_101.pt then
			break
		else
			var8_101 = iter8_101
		end
	end

	return {
		ptId = var1_101,
		awardList = var2_101,
		pt = var4_101,
		isPay = var5_101,
		awardDic = var6_101,
		awardPayDic = var7_101,
		phase = var8_101
	}
end

function var0_0.IsActivityReady(arg0_102)
	return arg0_102 and not arg0_102:isEnd() and arg0_102:readyToAchieve()
end

function var0_0.GetEndTimeStrByConfig(arg0_103)
	local var0_103 = arg0_103:getConfig("time")

	if type(var0_103) == "table" then
		local var1_103 = var0_103[3]
		local var2_103 = var1_103[1][2]
		local var3_103 = var1_103[1][3]

		return var2_103 .. "." .. var3_103
	else
		return ""
	end
end

return var0_0
