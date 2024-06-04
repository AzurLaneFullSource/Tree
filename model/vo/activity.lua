local var0 = class("Activity", import(".BaseVO"))
local var1

function var0.GetType2Class()
	if var1 then
		return var1
	end

	var1 = {
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
		[ActivityConst.ACTIVITY_TYPE_LINER] = LinerActivity
	}

	return var1
end

function var0.Create(arg0)
	local var0 = pg.activity_template[arg0.id]

	return (var0.GetType2Class()[var0.type] or Activity).New(arg0)
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.stopTime = arg1.stop_time
	arg0.data1 = defaultValue(arg1.data1, 0)
	arg0.data2 = defaultValue(arg1.data2, 0)
	arg0.data3 = defaultValue(arg1.data3, 0)
	arg0.data4 = defaultValue(arg1.data4, 0)
	arg0.str_data1 = defaultValue(arg1.str_data1, "")
	arg0.data1_list = {}

	for iter0, iter1 in ipairs(arg1.data1_list or {}) do
		table.insert(arg0.data1_list, iter1)
	end

	arg0.data2_list = {}

	for iter2, iter3 in ipairs(arg1.data2_list or {}) do
		table.insert(arg0.data2_list, iter3)
	end

	arg0.data3_list = {}

	for iter4, iter5 in ipairs(arg1.data3_list or {}) do
		table.insert(arg0.data3_list, iter5)
	end

	arg0.data4_list = {}

	for iter6, iter7 in ipairs(arg1.data4_list or {}) do
		table.insert(arg0.data4_list, iter7)
	end

	arg0.data1KeyValueList = {}

	for iter8, iter9 in ipairs(arg1.date1_key_value_list or {}) do
		arg0.data1KeyValueList[iter9.key] = {}

		for iter10, iter11 in ipairs(iter9.value_list or {}) do
			arg0.data1KeyValueList[iter9.key][iter11.key] = iter11.value
		end
	end

	arg0.buffList = {}

	for iter12, iter13 in ipairs(arg1.buff_list or {}) do
		table.insert(arg0.buffList, ActivityBuff.New(arg0.id, iter13.id, iter13.timestamp))
	end

	if arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP then
		arg0.data2KeyValueList = {}

		for iter14, iter15 in ipairs(arg1.date1_key_value_list or {}) do
			local var0 = iter15.key
			local var1 = iter15.value

			arg0.data2KeyValueList[var0] = {}
			arg0.data2KeyValueList[var0].value = var1
			arg0.data2KeyValueList[var0].dataMap = {}

			for iter16, iter17 in ipairs(iter15.value_list or {}) do
				local var2 = iter17.key
				local var3 = iter17.value

				arg0.data2KeyValueList[var0].dataMap[var2] = var3
			end
		end
	end

	arg0.clientData1 = 0
	arg0.clientList = {}
end

function var0.GetBuffList(arg0)
	return arg0.buffList
end

function var0.AddBuff(arg0, arg1)
	assert(isa(arg1, ActivityBuff), "activityBuff should instance of ActivityBuff")
	table.insert(arg0.buffList, arg1)
end

function var0.setClientList(arg0, arg1)
	arg0.clientList = arg1
end

function var0.getClientList(arg0)
	return arg0.clientList
end

function var0.updateDataList(arg0, arg1)
	table.insert(arg0.data1_list, arg1)
end

function var0.setDataList(arg0, arg1)
	arg0.data1_list = arg1
end

function var0.updateKVPList(arg0, arg1, arg2, arg3)
	if not arg0.data1KeyValueList[arg1] then
		arg0.data1KeyValueList[arg1] = {}
	end

	arg0.data1KeyValueList[arg1][arg2] = arg3
end

function var0.getKVPList(arg0, arg1, arg2)
	if not arg0.data1KeyValueList[arg1] then
		arg0.data1KeyValueList[arg1] = {}
	end

	return arg0.data1KeyValueList[arg1][arg2] or 0
end

function var0.getData1(arg0)
	return arg0.data1
end

function var0.getStrData1(arg0)
	return arg0.str_data1
end

function var0.getData3(arg0)
	return arg0.data3
end

function var0.getData1List(arg0)
	return arg0.data1_list
end

function var0.bindConfigTable(arg0)
	return pg.activity_template
end

function var0.getDataConfigTable(arg0)
	local var0 = arg0:getConfig("type")
	local var1 = arg0:getConfig("config_id")

	if var0 == ActivityConst.ACTIVITY_TYPE_MONOPOLY then
		return pg.activity_event_monopoly[tonumber(var1)]
	elseif var0 == ActivityConst.ACTIVITY_TYPE_PIZZA_PT or var0 == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		return pg.activity_event_pt[tonumber(var1)]
	elseif var0 == ActivityConst.ACTIVITY_TYPE_VOTE then
		return pg.activity_vote[tonumber(var1)]
	end
end

function var0.getDataConfig(arg0, arg1)
	local var0 = arg0:getDataConfigTable()

	assert(var0, "miss config : " .. arg0.id)

	return var0 and var0[arg1]
end

function var0.isEnd(arg0)
	return arg0.stopTime > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0.stopTime
end

function var0.increaseUsedCount(arg0, arg1)
	if arg1 == 1 then
		arg0.data1 = arg0.data1 + 1
	elseif arg1 == 2 then
		arg0.data2 = arg0.data2 + 1
	end
end

function var0.readyToAchieve(arg0)
	local var0, var1 = arg0:IsShowTipById()

	if var0 then
		return var1
	end

	var0.readyToAchieveDic = var0.readyToAchieveDic or {
		[ActivityConst.ACTIVITY_TYPE_CARD_PAIRS] = function(arg0)
			local var0 = os.difftime(pg.TimeMgr.GetInstance():GetServerTime(), arg0.data3)

			return math.ceil(var0 / 86400) > arg0.data2 and arg0.data2 < arg0:getConfig("config_data")[4]
		end,
		[ActivityConst.ACTIVITY_TYPE_LEVELAWARD] = function(arg0)
			local var0 = getProxy(PlayerProxy):getRawData()
			local var1 = pg.activity_level_award[arg0:getConfig("config_id")]

			for iter0 = 1, #var1.front_drops do
				local var2 = var1.front_drops[iter0][1]

				if var2 <= var0.level and not _.include(arg0.data1_list, var2) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_STORY_AWARD] = function(arg0)
			local var0 = getProxy(PlayerProxy):getRawData()
			local var1 = pg.activity_event_chapter_award[arg0:getConfig("config_id")]

			for iter0 = 1, #var1.chapter do
				local var2 = var1.chapter[iter0]

				if getProxy(ChapterProxy):isClear(var2) and not _.include(arg0.data1_list, var2) then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASKS] = function(arg0)
			local var0 = getProxy(TaskProxy)
			local var1 = _.flatten(arg0:getConfig("config_data"))

			if _.any(var1, function(arg0)
				local var0 = var0:getTaskById(arg0)

				return var0 and var0:isFinish() and not var0:isReceive()
			end) then
				return true
			end

			local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

			if var2 and not var2:isEnd() and var2:getConfig("config_client").linkActID == arg0.id and var2:readyToAchieve() then
				return true
			end

			if arg0:getConfig("config_client") and arg0:getConfig("config_client").decodeGameId then
				local var3 = arg0:getConfig("config_client").decodeGameId
				local var4 = getProxy(MiniGameProxy):GetHubByGameId(var3)

				if var4 then
					local var5 = arg0:getConfig("config_data")
					local var6 = var5[#var5]
					local var7 = _.all(var6, function(arg0)
						return getProxy(TaskProxy):getFinishTaskById(arg0) ~= nil
					end)

					if var4.ultimate <= 0 and var7 then
						return true
					end
				end
			end

			if arg0:getConfig("config_client") and arg0:getConfig("config_client").linkTaskPoolAct then
				local var8 = arg0:getConfig("config_client").linkTaskPoolAct
				local var9 = getProxy(ActivityProxy):getActivityById(var8)

				if var9 and var9:readyToAchieve() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_LIST] = function(...)
			return var0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_TASKS](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_HITMONSTERNIAN] = function(arg0)
			local var0 = arg0:GetCountForHitMonster()

			return not (arg0:GetDataConfig("hp") <= arg0.data3) and var0 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_DODGEM] = function(arg0)
			local var0 = pg.TimeMgr.GetInstance()
			local var1 = var0:DiffDay(arg0.data1, var0:GetServerTime()) + 1
			local var2 = arg0:getConfig("config_id")

			if var2 == 1 then
				return arg0.data4 == 0 and arg0.data2 >= 7 or defaultValue(arg0.data2_list[1], 0) > 0 or defaultValue(arg0.data2_list[2], 0) > 0 or arg0.data2 < math.min(var1, 7) or var1 > arg0.data3
			elseif var2 == 2 then
				return arg0.data4 == 0 and arg0.data2 >= 7 or defaultValue(arg0.data2_list[1], 0) > 0 or defaultValue(arg0.data2_list[2], 0) > 0 or arg0.data2 < math.min(var1, 7)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MONOPOLY] = function(arg0)
			local var0 = arg0.data1
			local var1 = arg0.data1_list[1]
			local var2 = arg0.data1_list[2]
			local var3 = arg0.data2_list[1]
			local var4 = arg0.data2_list[2]
			local var5 = pg.TimeMgr.GetInstance():GetServerTime()
			local var6 = math.ceil((var5 - var0) / 86400) * arg0:getDataConfig("daily_time") + var1 - var2
			local var7 = var3 - var4

			return var6 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PIZZA_PT] = function(arg0)
			local var0 = ActivityPtData.New(arg0):CanGetAward()
			local var1 = true

			if arg0:getConfig("config_client") then
				local var2 = arg0:getConfig("config_client").task_act_id

				if var2 and var2 ~= 0 and pg.activity_template[var2] then
					local var3 = pg.activity_template[var2]
					local var4 = _.flatten(var3.config_data)

					if var4 and #var4 > 0 then
						local var5 = getProxy(TaskProxy)

						for iter0 = 1, #var4 do
							local var6 = var5:getTaskById(var4[iter0])

							if var6 and var6:isFinish() then
								return true
							end
						end
					end
				end
			end

			local var7 = false
			local var8 = arg0:getConfig("config_client").fireworkActID

			if var8 and var8 ~= 0 then
				local var9 = getProxy(ActivityProxy):getActivityById(var8)

				var7 = var9 and var9:readyToAchieve() or false
			end

			local var10 = arg0:getConfig("config_client")[2]
			local var11 = type(var10) == "number" and ManualSignActivity.IsManualSignActAndAnyAwardCanGet(var10)

			return var0 and var1 or var7 or var11
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = function(...)
			return var0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_PIZZA_PT](...)
		end,
		[ActivityConst.ACTIVITY_TYPE_RETURN_AWARD] = function(arg0)
			local var0 = arg0.data1

			if var0 == 1 then
				local var1 = pg.activity_template_headhunting[arg0.id]
				local var2 = var1.target
				local var3 = 0

				for iter0, iter1 in ipairs(arg0:getClientList()) do
					var3 = var3 + iter1:getPt()
				end

				local var4 = 0

				for iter2 = #var2, 1, -1 do
					if table.contains(arg0.data1_list, var2[iter2]) then
						var4 = iter2

						break
					end
				end

				local var5 = var1.drop_client
				local var6 = math.min(var4 + 1, #var5)
				local var7 = _.any(var1.tasklist, function(arg0)
					local var0 = getProxy(TaskProxy):getTaskById(arg0)

					return var0 and var0:isFinish() and not var0:isReceive()
				end)

				return var3 >= var2[var6] and var4 ~= #var5 or var7
			elseif var0 == 2 then
				local var8 = getProxy(TaskProxy)
				local var9 = pg.activity_template_returnner[arg0.id]

				return _.any(_.flatten(var9.task_list), function(arg0)
					local var0 = var8:getTaskById(arg0)

					return var0 and var0:isFinish()
				end)
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_MINIGAME] = function(arg0)
			local var0 = getProxy(MiniGameProxy):GetHubByHubId(arg0:getConfig("config_id"))

			if var0.count > 0 then
				return true
			end

			if var0:getConfig("reward") ~= 0 and var0.usedtime >= var0:getConfig("reward_need") and var0.ultimate == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function(arg0)
			local var0 = pg.activity_event_turning[arg0:getConfig("config_id")]
			local var1 = arg0.data4

			if var1 ~= 0 then
				local var2 = var0.task_table[var1]
				local var3 = getProxy(TaskProxy)

				for iter0, iter1 in ipairs(var2) do
					if (var3:getTaskById(iter1) or var3:getFinishTaskById(iter1)):getTaskStatus() == 1 then
						return true
					end
				end

				local var4 = pg.TimeMgr.GetInstance():DiffDay(arg0.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var4, 1, pg.activity_event_turning[arg0:getConfig("config_id")].total_num) > arg0.data3 then
					for iter2, iter3 in ipairs(var2) do
						if (var3:getTaskById(iter3) or var3:getFinishTaskById(iter3)):getTaskStatus() ~= 2 then
							return false
						end
					end

					return true
				end
			elseif var1 == 0 then
				local var5 = pg.TimeMgr.GetInstance():DiffDay(arg0.data1, pg.TimeMgr.GetInstance():GetServerTime()) + 1

				if math.clamp(var5, 1, pg.activity_event_turning[arg0:getConfig("config_id")].total_num) > arg0.data3 then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function(arg0)
			return not (arg0.data2 > 0)
		end,
		[ActivityConst.ACTIVITY_TYPE_SHRINE] = function(arg0)
			local var0 = arg0:getConfig("config_client").story
			local var1 = var0 and #var0 or 7
			local var2 = pg.TimeMgr.GetInstance():DiffDay(arg0.data3, pg.TimeMgr.GetInstance():GetServerTime()) + 1
			local var3 = math.clamp(var2, 1, var1)
			local var4 = pg.NewStoryMgr.GetInstance()
			local var5 = math.clamp(arg0.data2, 0, var1)

			for iter0 = 1, var3 do
				local var6 = var0[iter0][1]

				if var6 and iter0 <= var5 and not var4:IsPlayed(var6) then
					return true
				end
			end

			if var1 <= var3 and var1 <= arg0.data2 and not (arg0.data1 > 0) then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = function(arg0)
			local var0 = arg0:getConfig("config_client")[3]
			local var1 = pg.TimeMgr.GetInstance()
			local var2 = var1:DiffDay(arg0.data3, var1:GetServerTime()) + 1 - arg0.data2

			return math.clamp(var2, 0, #var0 - arg0.data2) > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function(arg0)
			local var0 = arg0:GetBuildingIds()

			for iter0, iter1 in ipairs(var0) do
				local var1 = arg0:GetBuildingLevel(iter1)
				local var2 = pg.activity_event_building[iter1]

				if var2 and var1 < #var2.buff then
					local var3 = var2.material[var1]

					if underscore.all(var3, function(arg0)
						local var0 = arg0[1]
						local var1 = arg0[2]
						local var2 = arg0[3]
						local var3 = 0

						if var0 == DROP_TYPE_VITEM then
							local var4 = AcessWithinNull(Item.getConfigData(var1), "link_id")

							assert(var4 == arg0.id)

							var3 = arg0:GetMaterialCount(var1)
						elseif var0 > DROP_TYPE_USE_ACTIVITY_DROP then
							local var5 = AcessWithinNull(pg.activity_drop_type[var0], "activity_id")

							assert(var5)

							bagAct = getProxy(ActivityProxy):getActivityById(var5)
							var3 = bagAct:getVitemNumber(var1)
						end

						return var2 <= var3
					end) then
						return true
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function(arg0, ...)
			return var0.readyToAchieveDic[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF](arg0, ...) or arg0:CanRequest()
		end,
		[ActivityConst.ACTIVITY_TYPE_EXPEDITION] = function(arg0)
			if arg0.data3 > 0 and arg0.data1 ~= 0 then
				return true
			else
				for iter0 = 1, #arg0.data1_list do
					if not bit.band(arg0.data1_list[iter0], ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
						if bit.band(arg0.data1_list[iter0], ActivityConst.EXPEDITION_TYPE_OPEN) ~= 0 then
							return true
						elseif bit.band(arg0.data1_list[iter0], ActivityConst.EXPEDITION_TYPE_BAOXIANG) ~= 0 then
							return true
						elseif bit.band(arg0.data1_list[iter0], ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 then
							return true
						end
					end
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY] = function(arg0)
			local var0 = arg0:getConfig("config_client")

			if var0 and var0.linkGameHubID then
				local var1 = getProxy(MiniGameProxy):GetHubByHubId(var0.linkGameHubID)

				if var1 then
					if var0.trimRed then
						if var1.ultimate == 1 then
							return false
						end

						if var1.usedtime == var1:getConfig("reward_need") then
							return true
						end
					end

					return var1.count > 0
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_BB] = function(arg0)
			return arg0.data2 > 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = function(arg0)
			local var0 = arg0.data1_list
			local var1 = arg0.data2_list
			local var2 = arg0:GetPicturePuzzleIds()
			local var3 = arg0:getConfig("config_client").linkActID

			if var3 then
				local var4 = getProxy(ActivityProxy):getActivityById(var3)

				if var4 and var4:readyToAchieve() then
					return true
				end
			end

			if _.any(var2, function(arg0)
				local var0 = table.contains(var1, arg0)
				local var1 = table.contains(var0, arg0)

				return not var0 and var1
			end) then
				return true
			end

			local var5 = pg.activity_event_picturepuzzle[arg0.id]

			if var5 and var5.chapter > 0 and arg0.data1 < 1 then
				return true
			end

			if var5 and #var5.auto_finish_args > 0 and arg0.data1 == 1 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE] = function(arg0)
			local var0 = WorldInPictureActiviyData.New(arg0)

			return not var0:IsTravelAll() and var0:GetTravelPoint() > 0 or var0:GetDrawPoint() > 0 and var0:AnyAreaCanDraw()
		end,
		[ActivityConst.ACTIVITY_TYPE_APRIL_REWARD] = function(arg0)
			if arg0.data1 == 0 then
				local var0 = arg0:getStartTime()
				local var1 = pg.TimeMgr.GetInstance():GetServerTime()

				if arg0:getConfig("config_client").autounlock <= var1 - var0 then
					return true
				end
			elseif arg0.data1 ~= 0 and arg0.data2 == 0 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_POOL] = function(arg0)
			local var0 = arg0:getConfig("config_data")
			local var1 = getProxy(TaskProxy)

			if arg0.data1 >= #var0 then
				return false
			end

			local var2 = pg.TimeMgr.GetInstance()
			local var3 = (var2:DiffDay(arg0:getStartTime(), var2:GetServerTime()) + 1) * arg0:getConfig("config_id")

			var3 = var3 > #var0 and #var0 or var3

			local var4 = _.any(var0, function(arg0)
				local var0 = var1:getTaskById(arg0)

				return var0 and var0:isFinish()
			end)

			return var3 - arg0.data1 > 0 and var4
		end,
		[ActivityConst.ACTIVITY_TYPE_EVENT] = function(arg0)
			local var0 = getProxy(PlayerProxy):getData().id

			return PlayerPrefs.GetInt("ACTIVITY_TYPE_EVENT_" .. arg0.id .. "_" .. var0) == 0
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_OTHER] = function(arg0)
			if arg0.data2 and arg0.data2 <= 0 and arg0.data1 >= pg.activity_event_avatarframe[arg0:getConfig("config_id")].target then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = function(arg0)
			local var0, var1 = arg0:GetUpgradeCost()

			if arg0:GetSlotCount() < arg0:GetTotalSlotCount() and var1 <= arg0:GetCoins() then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function(arg0)
			local var0 = arg0:getConfig("config_data")[2][1]
			local var1 = arg0:getConfig("config_data")[2][2]
			local var2 = getProxy(PlayerProxy):getRawData():getResource(var0)

			if arg0.data1 > 0 and var1 <= var2 then
				return true
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD] = function(arg0)
			local var0 = pg.TimeMgr.GetInstance()

			return var0:GetServerTime() >= var0:GetTimeToNextTime(math.max(arg0.data1, arg0.data2))
		end,
		[ActivityConst.ACTIVITY_TYPE_ISLAND] = function(arg0)
			for iter0, iter1 in pairs(getProxy(IslandProxy):GetNodeDic()) do
				if iter1:IsVisual() and iter1:RedDotHint() then
					return true
				end
			end

			return false
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = function(arg0)
			return Spring2Activity.readyToAchieve(arg0)
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE] = function(arg0)
			local var0 = #arg0.data2_list
			local var1 = arg0:getData1List()
			local var2 = arg0:getConfig("config_data")[2]

			if #var1 == #var2 then
				return false
			end

			local function var3()
				for iter0, iter1 in ipairs(var2) do
					if not table.contains(var1, iter1[1]) and var0 >= iter1[1] then
						return true
					end
				end

				return false
			end

			local function var4()
				local var0 = getProxy(PlayerProxy):getData().id

				return PlayerPrefs.GetInt("DAY_TIP_" .. arg0.id .. "_" .. var0 .. "_" .. arg0:getDayIndex()) == 0
			end

			return var3() or var4()
		end,
		[ActivityConst.ACTIVITY_TYPE_SURVEY] = function(arg0)
			local var0, var1 = getProxy(ActivityProxy):isSurveyOpen()

			return var0 and not SurveyPage.IsEverEnter(var1)
		end,
		[ActivityConst.ACTIVITY_TYPE_ZUMA] = function(arg0)
			return LaunchBallActivityMgr.GetInvitationAble(arg0.id)
		end,
		[ActivityConst.ACTIVITY_TYPE_GIFT_UP] = function(arg0)
			local var0 = arg0:getConfig("config_client").gifts[2]
			local var1 = math.min(#var0, arg0:getNDay())

			return underscore(var0):chain():first(var1):any(function(arg0)
				local var0 = getProxy(ShopsProxy):GetGiftCommodity(arg0, Goods.TYPE_GIFT_PACKAGE)

				return var0:canPurchase() and var0:inTime() and not var0:IsGroupLimit()
			end):value()
		end,
		[ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE] = function(arg0)
			if getProxy(ShopsProxy):getActivityShops() == nil then
				return false
			end

			local var0 = arg0:getConfig("config_client")
			local var1 = getProxy(PlayerProxy):getData():getResource(var0.uPtId)
			local var2 = #var0.goodsId + 1
			local var3 = var2 - _.reduce(var0.goodsId, 0, function(arg0, arg1)
				return arg0 + getProxy(ShopsProxy):getActivityShopById(var0.shopId):GetCommodityById(arg1):GetPurchasableCnt()
			end)
			local var4 = var3 < var2 and pg.activity_shop_template[var0.goodsId[var3]] or nil

			return var3 < var2 and var1 >= var4.resource_num
		end
	}

	return switch(arg0:getConfig("type"), var0.readyToAchieveDic, nil, arg0)
end

function var0.IsShowTipById(arg0)
	var0.ShowTipTableById = var0.ShowTipTableById or {
		[ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE] = function()
			local var0 = getProxy(SkirmishProxy)

			var0:UpdateSkirmishProgress()

			local var1 = var0:getRawData()
			local var2 = 0
			local var3 = 0

			for iter0, iter1 in ipairs(var1) do
				local var4 = iter1:GetState()

				var2 = var4 > SkirmishVO.StateInactive and var2 + 1 or var2
				var3 = var4 == SkirmishVO.StateClear and var3 + 1 or var3
			end

			return var3 < var2
		end,
		[ActivityConst.POCKY_SKIN_LOGIN] = function()
			local var0 = arg0:getConfig("config_client").linkids
			local var1 = getProxy(TaskProxy)
			local var2 = getProxy(ActivityProxy)
			local var3 = var2:getActivityById(var0[1])
			local var4 = var2:getActivityById(var0[2])
			local var5 = var2:getActivityById(var0[3])

			assert(var3 and var4 and var5)

			local function var6()
				return var3 and var3:readyToAchieve()
			end

			local function var7()
				return var4 and var4:readyToAchieve()
			end

			local function var8()
				local var0 = _.flatten(arg0:getConfig("config_data"))

				for iter0 = 1, math.min(#var0, var4.data3) do
					local var1 = var0[iter0]
					local var2 = var1:getTaskById(var1)

					if var2 and var2:isFinish() and not var2:isReceive() then
						return true
					end
				end
			end

			local function var9()
				if not (var5 and var5:readyToAchieve()) or not var3 then
					return false
				end

				local var0 = ActivityPtData.New(var3)

				return var0.level >= #var0.targets
			end

			return var8() or var6() or var7() or var9()
		end,
		[ActivityConst.TOWERCLIMBING_SIGN] = function()
			local var0 = getProxy(MiniGameProxy):GetHubByHubId(9)
			local var1 = var0.ultimate
			local var2 = var0:getConfig("reward_need")
			local var3 = var0.usedtime

			return var1 == 0 and var2 <= var3
		end,
		[pg.activity_const.NEWYEAR_SNACK_PAGE_ID.act_id] = NewYearSnackPage.IsTip,
		[ActivityConst.WWF_TASK_ID] = WWFPtPage.IsShowRed,
		[ActivityConst.NEWMEIXIV4_SKIRMISH_ID] = NewMeixiV4SkirmishPage.IsShowRed,
		[ActivityConst.JIUJIU_YOYO_ID] = JiujiuYoyoPage.IsShowRed,
		[ActivityConst.SENRANKAGURA_TRAIN_ACT_ID] = SenrankaguraTrainScene.IsShowRed
	}

	local var0 = var0.ShowTipTableById[arg0.id]

	return tobool(var0), var0 and var0()
end

function var0.isShow(arg0)
	if arg0:getConfig("is_show") <= 0 then
		return false
	end

	if arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		return arg0.data1 ~= 0
	elseif arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY then
		local var0 = arg0:getConfig("config_client").display_link

		if var0 then
			return underscore.any(var0, function(arg0)
				return arg0[2] == 0 or pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0[2]].time)
			end)
		end
	elseif arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SURVEY then
		local var1 = getProxy(ActivityProxy)
		local var2 = var1:isSurveyOpen()
		local var3 = var1:isSurveyDone()

		return var2 and not var3
	elseif arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE then
		if getProxy(ShopsProxy):getActivityShops() == nil then
			return false
		end

		local var4 = arg0:getConfig("config_client")
		local var5 = getProxy(PlayerProxy):getData():getResource(var4.uPtId)
		local var6 = #var4.goodsId + 1

		return var6 > var6 - _.reduce(var4.goodsId, 0, function(arg0, arg1)
			return arg0 + getProxy(ShopsProxy):getActivityShopById(var4.shopId):GetCommodityById(arg1):GetPurchasableCnt()
		end)
	end

	return true
end

function var0.isAfterShow(arg0)
	if arg0.configId == ActivityConst.UR_TASK_ACT_ID or arg0.configId == ActivityConst.SPECIAL_WEAPON_ACT_ID then
		local var0 = getProxy(TaskProxy)

		return underscore.all(arg0:getConfig("config_data")[1], function(arg0)
			local var0 = var0:getTaskVO(arg0)

			return var0 and var0:isReceive()
		end)
	end

	return false
end

function var0.getShowPriority(arg0)
	return arg0:getConfig("is_show")
end

function var0.left4Day(arg0)
	if arg0.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 345600 then
		return true
	end

	return false
end

function var0.getAwardInfos(arg0)
	return arg0.data1KeyValueList or {}
end

function var0.updateData(arg0, arg1, arg2)
	if arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if not arg0:getAwardInfos()[arg1] then
			arg0.data1KeyValueList[arg1] = {}
		end

		for iter0, iter1 in ipairs(arg2) do
			if arg0.data1KeyValueList[arg1][iter1] then
				arg0.data1KeyValueList[arg1][iter1] = arg0.data1KeyValueList[arg1][iter1] + 1
			else
				arg0.data1KeyValueList[arg1][iter1] = 1
			end
		end
	end
end

function var0.getTaskShip(arg0)
	return arg0:getConfig("config_client")[1]
end

function var0.getNotificationMsg(arg0)
	local var0 = arg0:getConfig("type")
	local var1 = ActivityProxy.ACTIVITY_SHOW_AWARDS

	if var0 == ActivityConst.ACTIVITY_TYPE_SHOP then
		var1 = ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS
	elseif var0 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		var1 = ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS
	elseif var0 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		var1 = ActivityProxy.ACTIVITY_SHOW_REFLUX_AWARDS
	elseif var0 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS or var0 == ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER then
		var1 = ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS
	end

	return var1
end

function var0.getDayIndex(arg0)
	local var0 = arg0:getStartTime()
	local var1 = pg.TimeMgr.GetInstance()
	local var2 = var1:GetServerTime()

	return var1:DiffDay(var0, var2) + 1
end

function var0.getStartTime(arg0)
	local var0, var1 = parseTimeConfig(arg0:getConfig("time"))

	if var1 and var1[1] == "newuser" then
		return arg0.stopTime - var1[3] * 86400
	else
		return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0[2])
	end
end

function var0.getNDay(arg0, arg1)
	arg1 = arg1 or arg0:getStartTime()

	local var0 = pg.TimeMgr.GetInstance()

	return var0:DiffDay(arg1, var0:GetServerTime()) + 1
end

function var0.isVariableTime(arg0)
	local var0, var1 = parseTimeConfig(arg0:getConfig("time"))

	return var1 and var1[1] == "newuser"
end

function var0.setSpecialData(arg0, arg1, arg2)
	arg0.speciaData = arg0.speciaData and arg0.speciaData or {}
	arg0.speciaData[arg1] = arg2
end

function var0.getSpecialData(arg0, arg1)
	return arg0.speciaData and arg0.speciaData[arg1] and arg0.speciaData[arg1] or nil
end

function var0.canPermanentFinish(arg0)
	local var0 = arg0:getConfig("type")

	if var0 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		local var1 = arg0:getConfig("config_data")
		local var2 = getProxy(TaskProxy)

		return underscore.all(underscore.flatten({
			var1[#var1]
		}), function(arg0)
			return var2:getFinishTaskById(arg0) ~= nil
		end)
	elseif var0 == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		local var3 = ActivityPtData.New(arg0)

		return var3.level >= #var3.targets
	end

	return false
end

function var0.GetShopTime(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = arg0:getStartTime()
	local var2 = arg0.stopTime

	return var0:STimeDescS(var1, "%y.%m.%d") .. " - " .. var0:STimeDescS(var2, "%y.%m.%d")
end

function var0.GetCrusingUnreceiveAward(arg0)
	assert(arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0 = pg.battlepass_event_pt[arg0.id]
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(arg0.data1_list) do
		var2[iter1] = true
	end

	for iter2, iter3 in ipairs(var0.target) do
		if iter3 > arg0.data1 then
			break
		elseif not var2[iter3] then
			table.insert(var1, Drop.Create(var0.drop_client[iter2]))
		end
	end

	if arg0.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1)
	end

	local var3 = {}

	for iter4, iter5 in ipairs(arg0.data2_list) do
		var3[iter5] = true
	end

	for iter6, iter7 in ipairs(var0.target) do
		if iter7 > arg0.data1 then
			break
		elseif not var3[iter7] then
			table.insert(var1, Drop.Create(var0.drop_client_pay[iter6]))
		end
	end

	return PlayerConst.MergePassItemDrop(var1)
end

function var0.GetCrusingInfo(arg0)
	assert(arg0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0 = pg.battlepass_event_pt[arg0.id]
	local var1 = var0.pt
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(var0.key_point_display) do
		var3[iter1] = true
	end

	for iter2, iter3 in ipairs(var0.target) do
		table.insert(var2, {
			id = iter2,
			pt = iter3,
			award = var0.drop_client[iter2],
			award_pay = var0.drop_client_pay[iter2],
			isImportent = var3[iter2]
		})
	end

	local var4 = arg0.data1
	local var5 = arg0.data2 == 1
	local var6 = {}

	for iter4, iter5 in ipairs(arg0.data1_list) do
		var6[iter5] = true
	end

	local var7 = {}

	for iter6, iter7 in ipairs(arg0.data2_list) do
		var7[iter7] = true
	end

	local var8 = 0

	for iter8, iter9 in ipairs(var2) do
		if var4 < iter9.pt then
			break
		else
			var8 = iter8
		end
	end

	return {
		ptId = var1,
		awardList = var2,
		pt = var4,
		isPay = var5,
		awardDic = var6,
		awardPayDic = var7,
		phase = var8
	}
end

function var0.IsActivityReady(arg0)
	return arg0 and not arg0:isEnd() and arg0:readyToAchieve()
end

function var0.GetEndTimeStrByConfig(arg0)
	local var0 = arg0:getConfig("time")

	if type(var0) == "table" then
		local var1 = var0[3]
		local var2 = var1[1][2]
		local var3 = var1[1][3]

		return var2 .. "." .. var3
	else
		return ""
	end
end

return var0
