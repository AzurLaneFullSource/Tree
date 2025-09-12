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
		[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = VirtualBagActivity
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

function var0_0.isEnd(arg0_20)
	return arg0_20.stopTime > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_20.stopTime
end

function var0_0.increaseUsedCount(arg0_21, arg1_21)
	if arg1_21 == 1 then
		arg0_21.data1 = arg0_21.data1 + 1
	elseif arg1_21 == 2 then
		arg0_21.data2 = arg0_21.data2 + 1
	end
end

function var0_0.readyToAchieve(arg0_22)
	local var0_22, var1_22 = arg0_22:IsShowTipById()

	if var0_22 then
		return var1_22
	end

	var0_0.readyToAchieveDic = var0_0.readyToAchieveDic or {
		[ActivityConst.ACTIVITY_TYPE_CARD_PAIRS] = function(arg0_23)
			local var0_23 = os.difftime(pg.TimeMgr.GetInstance():GetServerTime(), arg0_23.data3)

			return math.ceil(var0_23 / 86400) > arg0_23.data2 and arg0_23.data2 < arg0_23:getConfig("config_data")[4]
		end,
		[ActivityConst.ACTIVITY_TYPE_LEVELAWARD] = function(arg0_24)
			local var0_24 = getProxy(PlayerProxy):getRawData()
			local var1_24 = pg.activity_level_award[arg0_24:getConfig("config_id")]

			for iter0_24 = 1, #var1_24.front_drops do
				local var2_24 = var1_24.front_drops[iter0_24][1]

				if var2_24 <= var0_24.level and not _.include(arg0_24.data1_list, var2_24) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_STORY_AWARD] = function(arg0_25)
			local var0_25 = getProxy(PlayerProxy):getRawData()
			local var1_25 = pg.activity_event_chapter_award[arg0_25:getConfig("config_id")]

			for iter0_25 = 1, #var1_25.chapter do
				local var2_25 = var1_25.chapter[iter0_25]

				if getProxy(ChapterProxy):isClear(var2_25) and not _.include(arg0_25.data1_list, var2_25) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASKS] = function(arg0_26)
			local var0_26 = getProxy(TaskProxy)
			local var1_26 = _.flatten(arg0_26:getConfig("config_data"))

			if _.any(var1_26, function(arg0_27)
				local var0_27 = var0_26:getTaskById(arg0_27)

				return var0_27 and var0_27:isFinish() and not var0_27:isReceive()
			end) then
				return true
			end

			local var2_26 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

			if var2_26 and not var2_26:isEnd() and var2_26:getConfig("config_client").linkActID == arg0_26.id and var2_26:readyToAchieve() then
				return true
			end

			if arg0_26:getConfig("config_client") and arg0_26:getConfig("config_client").decodeGameId then
				local var3_26 = arg0_26:getConfig("config_client").decodeGameId
				local var4_26 = getProxy(MiniGameProxy):GetHubByGameId(var3_26)

				if var4_26 then
					local var5_26 = arg0_26:getConfig("config_data")
					local var6_26 = var5_26[#var5_26]
					local var7_26 = _.all(var6_26, function(arg0_28)
						return getProxy(TaskProxy):getFinishTaskById(arg0_28) ~= nil
					end)

					if var4_26.ultimate <= 0 and var7_26 then
						return true
					end
				end
			end

			if arg0_26:getConfig("config_client") and arg0_26:getConfig("config_client").linkTaskPoolAct then
				local var8_26 = arg0_26:getConfig("config_client").linkTaskPoolAct
				local var9_26 = getProxy(ActivityProxy):getActivityById(var8_26)

				if var9_26 and var9_26:readyToAchieve() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_LIST] = function(...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_TASKS](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = function(arg0_30)
			local var0_30 = arg0_30:GetCountForHitMonster()

			return not (arg0_30:GetDataConfig("hp") <= arg0_30.data3) and var0_30 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DODGEM] = function(arg0_31)
			local var0_31 = pg.TimeMgr.GetInstance()
			local var1_31 = var0_31:DiffDay(arg0_31.data1, var0_31:GetServerTime()) + 1
			local var2_31 = arg0_31:getConfig("config_id")

			if var2_31 == 1 then
				return arg0_31.data4 == 0 and arg0_31.data2 >= 7 or defaultValue(arg0_31.data2_list[1], 0) > 0 or defaultValue(arg0_31.data2_list[2], 0) > 0 or arg0_31.data2 < math.min(var1_31, 7) or var1_31 > arg0_31.data3
			elseif var2_31 == 2 then
				return arg0_31.data4 == 0 and arg0_31.data2 >= 7 or defaultValue(arg0_31.data2_list[1], 0) > 0 or defaultValue(arg0_31.data2_list[2], 0) > 0 or arg0_31.data2 < math.min(var1_31, 7)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MONOPOLY] = function(arg0_32)
			local var0_32 = arg0_32.data1
			local var1_32 = arg0_32.data1_list[1]
			local var2_32 = arg0_32.data1_list[2]
			local var3_32 = arg0_32.data2_list[1]
			local var4_32 = arg0_32.data2_list[2]
			local var5_32 = pg.TimeMgr.GetInstance():GetServerTime()
			local var6_32 = math.ceil((var5_32 - var0_32) / 86400) * arg0_32:getDataConfig("daily_time") + var1_32 - var2_32
			local var7_32 = var3_32 - var4_32

			return var6_32 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PIZZA_PT] = function(arg0_33)
			local var0_33 = ActivityPtData.New(arg0_33):CanGetAward()
			local var1_33 = true

			if arg0_33:getConfig("config_client") then
				local var2_33 = arg0_33:getConfig("config_client").task_act_id

				if var2_33 and var2_33 ~= 0 and pg.activity_template[var2_33] then
					local var3_33 = pg.activity_template[var2_33]
					local var4_33 = _.flatten(var3_33.config_data)

					if var4_33 and #var4_33 > 0 then
						local var5_33 = getProxy(TaskProxy)

						for iter0_33 = 1, #var4_33 do
							local var6_33 = var5_33:getTaskById(var4_33[iter0_33])

							if var6_33 and var6_33:isFinish() then
								return true
							end
						end
					end
				end
			end

			local var7_33 = false
			local var8_33 = arg0_33:getConfig("config_client").fireworkActID

			if var8_33 and var8_33 ~= 0 then
				local var9_33 = getProxy(ActivityProxy):getActivityById(var8_33)

				var7_33 = var9_33 and var9_33:readyToAchieve() or false
			end

			local var10_33 = arg0_33:getConfig("config_client")[2]
			local var11_33 = type(var10_33) == "number" and ManualSignActivity.IsManualSignActAndAnyAwardCanGet(var10_33)

			return var0_33 and var1_33 or var7_33 or var11_33
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = function(...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_PIZZA_PT](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_RETURN_AWARD] = function(arg0_35)
			local var0_35 = arg0_35.data1

			if var0_35 == 1 then
				local var1_35 = pg.activity_template_headhunting[arg0_35.id]
				local var2_35 = var1_35.target
				local var3_35 = 0

				for iter0_35, iter1_35 in ipairs(arg0_35:getClientList()) do
					var3_35 = var3_35 + iter1_35:getPt()
				end

				local var4_35 = 0

				for iter2_35 = #var2_35, 1, -1 do
					if table.contains(arg0_35.data1_list, var2_35[iter2_35]) then
						var4_35 = iter2_35

						break
					end
				end

				local var5_35 = var1_35.drop_client
				local var6_35 = math.min(var4_35 + 1, #var5_35)
				local var7_35 = _.any(var1_35.tasklist, function(arg0_36)
					local var0_36 = getProxy(TaskProxy):getTaskById(arg0_36)

					return var0_36 and var0_36:isFinish() and not var0_36:isReceive()
				end)

				return var3_35 >= var2_35[var6_35] and var4_35 ~= #var5_35 or var7_35
			elseif var0_35 == 2 then
				local var8_35 = getProxy(TaskProxy)
				local var9_35 = pg.activity_template_returnner[arg0_35.id]

				return _.any(_.flatten(var9_35.task_list), function(arg0_37)
					local var0_37 = var8_35:getTaskById(arg0_37)

					return var0_37 and var0_37:isFinish()
				end)
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_38)
			local var0_38 = getProxy(MiniGameProxy):GetHubByHubId(arg0_38:getConfig("config_id"))

			if var0_38.count > 0 then
				return true
			end

			if var0_38:getConfig("reward") ~= 0 and var0_38.usedtime >= var0_38:getConfig("reward_need") and var0_38.ultimate == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function(arg0_39)
			local var0_39 = pg.activity_event_turning[arg0_39:getConfig("config_id")]
			local var1_39 = arg0_39.data4

			if var1_39 ~= 0 then
				local var2_39 = var0_39.task_table[var1_39]
				local var3_39 = getProxy(TaskProxy)

				for iter0_39, iter1_39 in ipairs(var2_39) do
					if (var3_39:getTaskById(iter1_39) or var3_39:getFinishTaskById(iter1_39)):getTaskStatus() == 1 then
						return true
					end
				end

				local var4_39 = pg.TimeMgr.GetInstance():DiffDay(arg0_39.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var4_39, 1, pg.activity_event_turning[arg0_39:getConfig("config_id")].total_num) > arg0_39.data3 then
					for iter2_39, iter3_39 in ipairs(var2_39) do
						if (var3_39:getTaskById(iter3_39) or var3_39:getFinishTaskById(iter3_39)):getTaskStatus() ~= 2 then
							return false
						end
					end

					return true
				end
			elseif var1_39 == 0 then
				local var5_39 = pg.TimeMgr.GetInstance():DiffDay(arg0_39.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var5_39, 1, pg.activity_event_turning[arg0_39:getConfig("config_id")].total_num) > arg0_39.data3 then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function(arg0_40)
			return not (arg0_40.data2 > 0)
		end,
		[ActivityConst.ACTIVITY_TYPE_SHRINE] = function(arg0_41)
			local var0_41 = arg0_41:getConfig("config_client").story
			local var1_41 = var0_41 and #var0_41 or 7
			local var2_41 = pg.TimeMgr.GetInstance():DiffDay(arg0_41.data3, pg.TimeMgr.GetInstance():GetServerTime()) + 1
			local var3_41 = math.clamp(var2_41, 1, var1_41)
			local var4_41 = pg.NewStoryMgr.GetInstance()
			local var5_41 = math.clamp(arg0_41.data2, 0, var1_41)

			for iter0_41 = 1, var3_41 do
				local var6_41 = var0_41[iter0_41][1]

				if var6_41 and iter0_41 <= var5_41 and not var4_41:IsPlayed(var6_41) then
					return true
				end
			end

			if var1_41 <= var3_41 and var1_41 <= arg0_41.data2 and not (arg0_41.data1 > 0) then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = function(arg0_42)
			local var0_42 = arg0_42:getConfig("config_client")[3]
			local var1_42 = pg.TimeMgr.GetInstance()
			local var2_42 = var1_42:DiffDay(arg0_42.data3, var1_42:GetServerTime()) + 1 - arg0_42.data2

			return math.clamp(var2_42, 0, #var0_42 - arg0_42.data2) > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function(arg0_43)
			local var0_43 = arg0_43:GetBuildingIds()

			for iter0_43, iter1_43 in ipairs(var0_43) do
				local var1_43 = arg0_43:GetBuildingLevel(iter1_43)
				local var2_43 = pg.activity_event_building[iter1_43]

				if var2_43 and var1_43 < #var2_43.buff then
					local var3_43 = var2_43.material[var1_43]

					if underscore.all(var3_43, function(arg0_44)
						local var0_44 = arg0_44[1]
						local var1_44 = arg0_44[2]
						local var2_44 = arg0_44[3]
						local var3_44 = 0

						if var0_44 == DROP_TYPE_VITEM then
							local var4_44 = AcessWithinNull(Item.getConfigData(var1_44), "link_id")

							assert(var4_44 == arg0_43.id)

							var3_44 = arg0_43:GetMaterialCount(var1_44)
						elseif var0_44 > DROP_TYPE_USE_ACTIVITY_DROP then
							local var5_44 = AcessWithinNull(pg.activity_drop_type[var0_44], "activity_id")

							assert(var5_44)

							bagAct = getProxy(ActivityProxy):getActivityById(var5_44)
							var3_44 = bagAct:getVitemNumber(var1_44)
						end

						return var2_44 <= var3_44
					end) then
						return true
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function(arg0_45, ...)
			return var0_0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF](arg0_45, ...) or arg0_45:CanRequest()
		end,
		[ActivityConst.ACTIVITY_TYPE_EXPEDITION] = function(arg0_46)
			if arg0_46.data3 > 0 and arg0_46.data1 ~= 0 then
				return true
			else
				for iter0_46 = 1, #arg0_46.data1_list do
					if not bit.band(arg0_46.data1_list[iter0_46], ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
						if bit.band(arg0_46.data1_list[iter0_46], ActivityConst.EXPEDITION_TYPE_OPEN) ~= 0 then
							return true
						elseif bit.band(arg0_46.data1_list[iter0_46], ActivityConst.EXPEDITION_TYPE_BAOXIANG) ~= 0 then
							return true
						elseif bit.band(arg0_46.data1_list[iter0_46], ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 then
							return true
						end
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY] = function(arg0_47)
			local var0_47 = arg0_47:getConfig("config_client")

			if var0_47 and var0_47.linkGameHubID then
				local var1_47 = getProxy(MiniGameProxy):GetHubByHubId(var0_47.linkGameHubID)

				if var1_47 then
					if var0_47.trimRed then
						if var1_47.ultimate == 1 then
							return false
						end

						if var1_47.usedtime == var1_47:getConfig("reward_need") then
							return true
						end
					end

					return var1_47.count > 0
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BB] = function(arg0_48)
			return arg0_48.data2 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = function(arg0_49)
			local var0_49 = arg0_49.data1_list
			local var1_49 = arg0_49.data2_list
			local var2_49 = arg0_49:GetPicturePuzzleIds()
			local var3_49 = arg0_49:getConfig("config_client").linkActID

			if var3_49 then
				local var4_49 = getProxy(ActivityProxy):getActivityById(var3_49)

				if var4_49 and var4_49:readyToAchieve() then
					return true
				end
			end

			if _.any(var2_49, function(arg0_50)
				local var0_50 = table.contains(var1_49, arg0_50)
				local var1_50 = table.contains(var0_49, arg0_50)

				return not var0_50 and var1_50
			end) then
				return true
			end

			local var5_49 = pg.activity_event_picturepuzzle[arg0_49.id]

			if var5_49 and var5_49.chapter > 0 and arg0_49.data1 < 1 then
				return true
			end

			if var5_49 and #var5_49.auto_finish_args > 0 and arg0_49.data1 == 1 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = function(arg0_51)
			return AirFightActivity.readyToAchieve(arg0_51)
		end,
		[ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE] = function(arg0_52)
			local var0_52 = WorldInPictureActiviyData.New(arg0_52)

			return not var0_52:IsTravelAll() and var0_52:GetTravelPoint() > 0 or var0_52:GetDrawPoint() > 0 and var0_52:AnyAreaCanDraw()
		end,
		[ActivityConst.ACTIVITY_TYPE_APRIL_REWARD] = function(arg0_53)
			if arg0_53.data1 == 0 then
				local var0_53 = arg0_53:getStartTime()
				local var1_53 = pg.TimeMgr.GetInstance():GetServerTime()

				if arg0_53:getConfig("config_client").autounlock <= var1_53 - var0_53 then
					return true
				end
			elseif arg0_53.data1 ~= 0 and arg0_53.data2 == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_POOL] = function(arg0_54)
			local var0_54 = arg0_54:getConfig("config_data")
			local var1_54 = getProxy(TaskProxy)

			if arg0_54.data1 >= #var0_54 then
				return false
			end

			local var2_54 = pg.TimeMgr.GetInstance()
			local var3_54 = (var2_54:DiffDay(arg0_54:getStartTime(), var2_54:GetServerTime()) + 1) * arg0_54:getConfig("config_id")

			var3_54 = var3_54 > #var0_54 and #var0_54 or var3_54

			local var4_54 = _.any(var0_54, function(arg0_55)
				local var0_55 = var1_54:getTaskById(arg0_55)

				return var0_55 and var0_55:isFinish()
			end)

			return var3_54 - arg0_54.data1 > 0 and var4_54
		end,
		[ActivityConst.ACTIVITY_TYPE_EVENT] = function(arg0_56)
			local var0_56 = getProxy(PlayerProxy):getData().id

			return PlayerPrefs.GetInt("ACTIVITY_TYPE_EVENT_" .. arg0_56.id .. "_" .. var0_56) == 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_OTHER] = function(arg0_57)
			if arg0_57.data2 and arg0_57.data2 <= 0 and arg0_57.data1 >= pg.activity_event_avatarframe[arg0_57:getConfig("config_id")].target then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = function(arg0_58)
			local var0_58, var1_58 = arg0_58:GetUpgradeCost()

			if arg0_58:GetSlotCount() < arg0_58:GetTotalSlotCount() and var1_58 <= arg0_58:GetCoins() then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function(arg0_59)
			local var0_59 = arg0_59:getConfig("config_data")[2][1]
			local var1_59 = arg0_59:getConfig("config_data")[2][2]
			local var2_59 = getProxy(PlayerProxy):getRawData():getResource(var0_59)

			if arg0_59.data1 > 0 and var1_59 <= var2_59 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD] = function(arg0_60)
			local var0_60 = pg.TimeMgr.GetInstance()

			return var0_60:GetServerTime() >= var0_60:GetTimeToNextTime(math.max(arg0_60.data1, arg0_60.data2))
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND] = function(arg0_61)
			for iter0_61, iter1_61 in pairs(getProxy(SixthAnniversaryIslandProxy):GetNodeDic()) do
				if iter1_61:IsVisual() and iter1_61:RedDotHint() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = function(arg0_62)
			return Spring2Activity.readyToAchieve(arg0_62)
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE] = function(arg0_63)
			local var0_63 = #arg0_63.data2_list
			local var1_63 = arg0_63:getData1List()
			local var2_63 = arg0_63:getConfig("config_data")[2]

			if #var1_63 == #var2_63 then
				return false
			end

			local function var3_63()
				for iter0_64, iter1_64 in ipairs(var2_63) do
					if not table.contains(var1_63, iter1_64[1]) and var0_63 >= iter1_64[1] then
						return true
					end
				end

				return false
			end

			local function var4_63()
				local var0_65 = getProxy(PlayerProxy):getData().id

				return PlayerPrefs.GetInt("DAY_TIP_" .. arg0_63.id .. "_" .. var0_65 .. "_" .. arg0_63:getDayIndex()) == 0
			end

			return var3_63() or var4_63()
		end,
		[ActivityConst.ACTIVITY_TYPE_SURVEY] = function(arg0_66)
			local var0_66, var1_66 = getProxy(ActivityProxy):isSurveyOpen()
			local var2_66 = getProxy(ActivityProxy):isSurveyDone()

			return var0_66 and not var2_66 and not SurveyPage.IsEverEnter(var1_66)
		end,
		[ActivityConst.ACTIVITY_TYPE_ZUMA] = function(arg0_67)
			return LaunchBallActivityMgr.GetInvitationAble(arg0_67.id)
		end,
		[ActivityConst.ACTIVITY_TYPE_GIFT_UP] = function(arg0_68)
			local var0_68 = arg0_68:getConfig("config_client").gifts[2]
			local var1_68 = math.min(#var0_68, arg0_68:getNDay())

			return underscore(var0_68):chain():first(var1_68):any(function(arg0_69)
				local var0_69 = getProxy(ShopsProxy):GetGiftCommodity(arg0_69, Goods.TYPE_GIFT_PACKAGE)

				return var0_69:canPurchase() and var0_69:inTime() and not var0_69:IsGroupLimit()
			end):value()
		end,
		[ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE] = function(arg0_70)
			if getProxy(ShopsProxy):getActivityShops() == nil then
				return false
			end

			local var0_70 = arg0_70:getConfig("config_client")
			local var1_70 = getProxy(PlayerProxy):getData():getResource(var0_70.uPtId)
			local var2_70 = #var0_70.goodsId + 1
			local var3_70 = var2_70 - _.reduce(var0_70.goodsId, 0, function(arg0_71, arg1_71)
				return arg0_71 + getProxy(ShopsProxy):getActivityShopById(var0_70.shopId):GetCommodityById(arg1_71):GetPurchasableCnt()
			end)
			local var4_70 = var3_70 < var2_70 and pg.activity_shop_template[var0_70.goodsId[var3_70]] or nil

			return var3_70 < var2_70 and var1_70 >= var4_70.resource_num
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING] = function(arg0_72)
			return arg0_72:getData1() > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DAILY_STAGE_BONUS] = function(arg0_73)
			return arg0_73:NeedLoginRedPoint()
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_RYZA] = function(arg0_74)
			local var0_74 = getProxy(ActivityTaskProxy):getTaskById(arg0_74.id)

			for iter0_74, iter1_74 in ipairs(var0_74) do
				if iter1_74:getTaskStatus() == 1 then
					return true
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0_75)
			local var0_75 = arg0_75:getConfig("config_id")

			if getProxy(MiniGameProxy):GetHubByHubId(var0_75).count > 0 then
				return true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function(arg0_76)
			local var0_76 = arg0_76:getConfig("config_id")
			local var1_76 = pg.activity_7_day_sign[var0_76].front_drops
			local var2_76 = pg.TimeMgr.GetInstance()
			local var3_76 = var2_76:GetServerTime()

			return arg0_76.data1 < #var1_76 and not var2_76:IsSameDay(var3_76, arg0_76.data2) and var3_76 > arg0_76.data2
		end
	}

	if switch(arg0_22:getConfig("type"), var0_0.readyToAchieveDic, nil, arg0_22) then
		return true
	elseif arg0_22:getConfig("config_client").sub_act_id then
		local var2_22 = getProxy(ActivityProxy):getActivityById(arg0_22:getConfig("config_client").sub_act_id)

		return var2_22 and not var2_22:isEnd() and var2_22:readyToAchieve()
	else
		return false
	end
end

function var0_0.IsShowTipById(arg0_77)
	var0_0.ShowTipTableById = var0_0.ShowTipTableById or {
		[ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE] = function()
			local var0_78 = getProxy(SkirmishProxy)

			var0_78:UpdateSkirmishProgress()

			local var1_78 = var0_78:getRawData()
			local var2_78 = 0
			local var3_78 = 0

			for iter0_78, iter1_78 in ipairs(var1_78) do
				local var4_78 = iter1_78:GetState()

				var2_78 = var4_78 > SkirmishVO.StateInactive and var2_78 + 1 or var2_78
				var3_78 = var4_78 == SkirmishVO.StateClear and var3_78 + 1 or var3_78
			end

			return var3_78 < var2_78
		end,
		[ActivityConst.POCKY_SKIN_LOGIN] = function()
			local var0_79 = arg0_77:getConfig("config_client").linkids
			local var1_79 = getProxy(TaskProxy)
			local var2_79 = getProxy(ActivityProxy)
			local var3_79 = var2_79:getActivityById(var0_79[1])
			local var4_79 = var2_79:getActivityById(var0_79[2])
			local var5_79 = var2_79:getActivityById(var0_79[3])

			assert(var3_79 and var4_79 and var5_79)

			local function var6_79()
				return var3_79 and var3_79:readyToAchieve()
			end

			local function var7_79()
				return var4_79 and var4_79:readyToAchieve()
			end

			local function var8_79()
				local var0_82 = _.flatten(arg0_77:getConfig("config_data"))

				for iter0_82 = 1, math.min(#var0_82, var4_79.data3) do
					local var1_82 = var0_82[iter0_82]
					local var2_82 = var1_79:getTaskById(var1_82)

					if var2_82 and var2_82:isFinish() and not var2_82:isReceive() then
						return true
					end
				end
			end

			local function var9_79()
				if not (var5_79 and var5_79:readyToAchieve()) or not var3_79 then
					return false
				end

				local var0_83 = ActivityPtData.New(var3_79)

				return var0_83.level >= #var0_83.targets
			end

			return var8_79() or var6_79() or var7_79() or var9_79()
		end,
		[ActivityConst.TOWERCLIMBING_SIGN] = function()
			local var0_84 = getProxy(MiniGameProxy):GetHubByHubId(9)
			local var1_84 = var0_84.ultimate
			local var2_84 = var0_84:getConfig("reward_need")
			local var3_84 = var0_84.usedtime

			return var1_84 == 0 and var2_84 <= var3_84
		end,
		[pg.activity_const.NEWYEAR_SNACK_PAGE_ID.act_id] = NewYearSnackPage.IsTip,
		[ActivityConst.WWF_TASK_ID] = WWFPtPage.IsShowRed,
		[ActivityConst.NEWMEIXIV4_SKIRMISH_ID] = NewMeixiV4SkirmishPage.IsShowRed,
		[ActivityConst.JIUJIU_YOYO_ID] = JiujiuYoyoPage.IsShowRed,
		[ActivityConst.SENRANKAGURA_TRAIN_ACT_ID] = SenrankaguraTrainScene.IsShowRed,
		[ActivityConst.DORM_SIGN_ID] = DormSignPage.IsShowRed,
		[ActivityConst.DORM_SIGN_ID_2] = DormSignTwoPage.IsShowRed,
		[ActivityConst.GOASTSTORYACTIVITY_ID] = GhostSkinPageLayer.IsShowRed,
		[ActivityConst.YUMIA_BASE_ACT_ID] = YoumiyaStrongholdLayer.ShouldShowTip,
		[ActivityConst.NINJA_CITY_MAIN_ACTIVITY_ID] = function()
			if CityRebuildBookLayer.ShouldShowTip() and CityRebuildTasksLayer.ShouldShowTip() then
				return true
			end

			return false
		end
	}

	local var0_77 = var0_0.ShowTipTableById[arg0_77.id]

	return tobool(var0_77), var0_77 and var0_77()
end

function var0_0.isShow(arg0_86)
	if LOCK_SKIN_US then
		local var0_86 = pg.gameset.levellimit_skinstory.key_value
		local var1_86 = pg.gameset.levellimit_skinstory.description

		if var0_86 >= getProxy(PlayerProxy):getRawData().level and table.contains(var1_86, arg0_86.id) then
			return false
		end
	end

	local var2_86 = arg0_86:getConfig("page_info")

	if arg0_86:getConfig("is_show") <= 0 then
		return false
	elseif underscore.any({
		var2_86.ui_name,
		var2_86.ui_name2
	}, function(arg0_87)
		return not checkABExist(string.format("ui/%s", arg0_87))
	end) then
		warning(string.format("activity:%d without ui:%s", arg0_86.id, table.concat({
			var2_86.ui_name,
			var2_86.ui_name2
		}, " or ")))

		return false
	end

	if arg0_86:getConfig("type") == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		return arg0_86.data1 ~= 0
	elseif arg0_86:getConfig("type") == ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY then
		local var3_86 = arg0_86:getConfig("config_client").display_link

		if var3_86 then
			return underscore.any(var3_86, function(arg0_88)
				return arg0_88[2] == 0 or pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_88[2]].time)
			end)
		end
	elseif arg0_86:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SURVEY then
		local var4_86 = getProxy(ActivityProxy)
		local var5_86 = var4_86:isSurveyOpen()
		local var6_86 = var4_86:isSurveyDone()

		return var5_86 and not var6_86
	elseif arg0_86:getConfig("type") == ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE then
		if getProxy(ShopsProxy):getActivityShops() == nil then
			return false
		end

		local var7_86 = arg0_86:getConfig("config_client")
		local var8_86 = getProxy(PlayerProxy):getData():getResource(var7_86.uPtId)
		local var9_86 = #var7_86.goodsId + 1

		return var9_86 > var9_86 - _.reduce(var7_86.goodsId, 0, function(arg0_89, arg1_89)
			return arg0_89 + getProxy(ShopsProxy):getActivityShopById(var7_86.shopId):GetCommodityById(arg1_89):GetPurchasableCnt()
		end)
	elseif arg0_86:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_RYZA and table.contains({
		ActivityConst.DORM_SIGN_ID,
		ActivityConst.DORM_SIGN_ID_2
	}, arg0_86:getConfig("id")) then
		return #getProxy(ActivityProxy):getActivityById(arg0_86:getConfig("id")):getConfig("config_data") ~= #getProxy(ActivityTaskProxy):getFinishTaskById(arg0_86:getConfig("id"))
	end

	return true
end

function var0_0.isAfterShow(arg0_90)
	if arg0_90.configId == ActivityConst.UR_TASK_ACT_ID or arg0_90.configId == ActivityConst.SPECIAL_WEAPON_ACT_ID then
		local var0_90 = getProxy(TaskProxy)

		return underscore.all(arg0_90:getConfig("config_data")[1], function(arg0_91)
			local var0_91 = var0_90:getTaskVO(arg0_91)

			return var0_91 and var0_91:isReceive()
		end)
	end

	return false
end

function var0_0.getShowPriority(arg0_92)
	return arg0_92:getConfig("is_show")
end

function var0_0.isCorePage(arg0_93, arg1_93)
	return arg0_93:getConfig("page_core") == arg1_93
end

function var0_0.left4Day(arg0_94)
	if arg0_94.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 345600 then
		return true
	end

	return false
end

function var0_0.getAwardInfos(arg0_95)
	return arg0_95.data1KeyValueList or {}
end

function var0_0.updateData(arg0_96, arg1_96, arg2_96)
	if arg0_96:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if not arg0_96:getAwardInfos()[arg1_96] then
			arg0_96.data1KeyValueList[arg1_96] = {}
		end

		for iter0_96, iter1_96 in ipairs(arg2_96) do
			if arg0_96.data1KeyValueList[arg1_96][iter1_96] then
				arg0_96.data1KeyValueList[arg1_96][iter1_96] = arg0_96.data1KeyValueList[arg1_96][iter1_96] + 1
			else
				arg0_96.data1KeyValueList[arg1_96][iter1_96] = 1
			end
		end
	end
end

function var0_0.getTaskShip(arg0_97)
	return arg0_97:getConfig("config_client")[1]
end

function var0_0.getNotificationMsg(arg0_98)
	local var0_98 = arg0_98:getConfig("type")
	local var1_98 = ActivityProxy.ACTIVITY_SHOW_AWARDS

	if var0_98 == ActivityConst.ACTIVITY_TYPE_SHOP then
		var1_98 = ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS
	elseif var0_98 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		var1_98 = ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS
	elseif var0_98 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		var1_98 = ActivityProxy.ACTIVITY_SHOW_REFLUX_AWARDS
	elseif var0_98 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS or var0_98 == ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER then
		var1_98 = ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS
	end

	return var1_98
end

function var0_0.getDayIndex(arg0_99)
	local var0_99 = arg0_99:getStartTime()
	local var1_99 = pg.TimeMgr.GetInstance()
	local var2_99 = var1_99:GetServerTime()

	return var1_99:DiffDay(var0_99, var2_99) + 1
end

function var0_0.getStartTime(arg0_100)
	local var0_100, var1_100 = parseTimeConfig(arg0_100:getConfig("time"))

	if var1_100 and var1_100[1] == "newuser" then
		return arg0_100.stopTime - var1_100[3] * 86400
	else
		return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_100[2])
	end
end

function var0_0.getNDay(arg0_101, arg1_101)
	arg1_101 = arg1_101 or arg0_101:getStartTime()

	local var0_101 = pg.TimeMgr.GetInstance()

	return var0_101:DiffDay(arg1_101, var0_101:GetServerTime()) + 1
end

function var0_0.isVariableTime(arg0_102)
	local var0_102, var1_102 = parseTimeConfig(arg0_102:getConfig("time"))

	return var1_102 and var1_102[1] == "newuser"
end

function var0_0.setSpecialData(arg0_103, arg1_103, arg2_103)
	arg0_103.speciaData = arg0_103.speciaData and arg0_103.speciaData or {}
	arg0_103.speciaData[arg1_103] = arg2_103
end

function var0_0.getSpecialData(arg0_104, arg1_104)
	return arg0_104.speciaData and arg0_104.speciaData[arg1_104] and arg0_104.speciaData[arg1_104] or nil
end

function var0_0.canPermanentFinish(arg0_105)
	local var0_105 = arg0_105:getConfig("type")

	if var0_105 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		local var1_105 = arg0_105:getConfig("config_data")
		local var2_105 = getProxy(TaskProxy)

		return underscore.all(underscore.flatten({
			var1_105[#var1_105]
		}), function(arg0_106)
			return var2_105:getFinishTaskById(arg0_106) ~= nil
		end)
	elseif var0_105 == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		local var3_105 = ActivityPtData.New(arg0_105)

		return var3_105.level >= #var3_105.targets
	end

	return false
end

function var0_0.GetShopTime(arg0_107)
	local var0_107 = pg.TimeMgr.GetInstance()
	local var1_107 = arg0_107:getStartTime()
	local var2_107 = arg0_107.stopTime

	return var0_107:STimeDescS(var1_107, "%y.%m.%d") .. " - " .. var0_107:STimeDescS(var2_107, "%y.%m.%d")
end

function var0_0.GetCrusingUnreceiveAward(arg0_108)
	assert(arg0_108:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_108 = pg.battlepass_event_pt[arg0_108.id]
	local var1_108 = {}
	local var2_108 = {}

	for iter0_108, iter1_108 in ipairs(arg0_108.data1_list) do
		var2_108[iter1_108] = true
	end

	for iter2_108, iter3_108 in ipairs(var0_108.target) do
		if iter3_108 > arg0_108.data1 then
			break
		elseif not var2_108[iter3_108] then
			table.insert(var1_108, Drop.Create(pg.battlepass_event_award[var0_108.award[iter2_108]].drop_client))
		end
	end

	if arg0_108.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1_108)
	end

	local var3_108 = {}

	for iter4_108, iter5_108 in ipairs(arg0_108.data2_list) do
		var3_108[iter5_108] = true
	end

	for iter6_108, iter7_108 in ipairs(var0_108.target) do
		if iter7_108 > arg0_108.data1 then
			break
		elseif not var3_108[iter7_108] then
			table.insert(var1_108, Drop.Create(pg.battlepass_event_award[var0_108.award_pay[iter6_108]].drop_client))
		end
	end

	return PlayerConst.MergePassItemDrop(var1_108)
end

function var0_0.GetCrusingInfo(arg0_109)
	assert(arg0_109:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_109 = pg.battlepass_event_pt[arg0_109.id]
	local var1_109 = var0_109.pt
	local var2_109 = {}
	local var3_109 = {}

	for iter0_109, iter1_109 in ipairs(var0_109.key_point_display) do
		var3_109[iter1_109] = true
	end

	for iter2_109, iter3_109 in ipairs(var0_109.target) do
		table.insert(var2_109, {
			id = iter2_109,
			pt = iter3_109,
			award = pg.battlepass_event_award[var0_109.award[iter2_109]].drop_client,
			award_pay = pg.battlepass_event_award[var0_109.award_pay[iter2_109]].drop_client,
			isImportent = var3_109[iter2_109]
		})
	end

	local var4_109 = arg0_109.data1
	local var5_109 = arg0_109.data2 == 1
	local var6_109 = {}

	for iter4_109, iter5_109 in ipairs(arg0_109.data1_list) do
		var6_109[iter5_109] = true
	end

	local var7_109 = {}

	for iter6_109, iter7_109 in ipairs(arg0_109.data2_list) do
		var7_109[iter7_109] = true
	end

	local var8_109 = 0

	for iter8_109, iter9_109 in ipairs(var2_109) do
		if var4_109 < iter9_109.pt then
			break
		else
			var8_109 = iter8_109
		end
	end

	return {
		ptId = var1_109,
		awardList = var2_109,
		pt = var4_109,
		isPay = var5_109,
		awardDic = var6_109,
		awardPayDic = var7_109,
		phase = var8_109
	}
end

function var0_0.IsActivityReady(arg0_110)
	return arg0_110 and not arg0_110:isEnd() and arg0_110:readyToAchieve()
end

function var0_0.GetEndTimeStrByConfig(arg0_111)
	local var0_111 = arg0_111:getConfig("time")

	if type(var0_111) == "table" then
		local var1_111 = var0_111[3]
		local var2_111 = var1_111[1][2]
		local var3_111 = var1_111[1][3]

		return var2_111 .. "." .. var3_111
	else
		return ""
	end
end

function var0_0.NeedLoginRedPoint(arg0_112)
	return PlayerPrefs.GetString(arg0_112:GetLoginRedPointKey(), "") ~= arg0_112:GetLoginRedPointValue()
end

function var0_0.SetLoginRedPoint(arg0_113)
	PlayerPrefs.SetString(arg0_113:GetLoginRedPointKey(), arg0_113:GetLoginRedPointValue())
end

function var0_0.GetLoginRedPointValue(arg0_114)
	return pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
end

function var0_0.GetLoginRedPointKey(arg0_115)
	local var0_115 = arg0_115:GetPlayerID()

	return string.format("%s_%s", var0_115, arg0_115.id)
end

function var0_0.GetPlayerID(arg0_116)
	return getProxy(PlayerProxy):getPlayerId()
end

function var0_0.GetConfigClientSetting(arg0_117, arg1_117)
	return arg0_117:getConfig("config_client")[arg1_117]
end

return var0_0
