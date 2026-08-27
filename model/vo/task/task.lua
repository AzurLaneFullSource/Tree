local var0_0 = class("Task", import("..BaseVO"))

var0_0.TYPE_SCENARIO = 1
var0_0.TYPE_BRANCH = 2
var0_0.TYPE_ROUTINE = 3
var0_0.TYPE_WEEKLY = 4
var0_0.TYPE_HIDDEN = 5
var0_0.TYPE_ACTIVITY = 6
var0_0.TYPE_ACTIVITY_ROUTINE = 36
var0_0.TYPE_ACTIVITY_BRANCH = 26
var0_0.TYPE_GUILD_WEEKLY = 12
var0_0.TYPE_NEW_WEEKLY = 13
var0_0.TYPE_REFLUX = 15
var0_0.TYPE_ACTIVITY_REPEAT = 16
var0_0.TYPE_ACTIVITY_WEEKLY = 46
var0_0.TYPE_COMMANDER_MANUAL = 17
var0_0.TYPE_REPEATABLE = 20

local var1_0 = {
	"scenario",
	"branch",
	"routine",
	"weekly"
}

var0_0.TASK_PROGRESS_UPDATE = 0
var0_0.TASK_PROGRESS_APPEND = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.progress = arg1_1.progress or 0
	arg0_1.acceptTime = arg1_1.accept_time
	arg0_1.submitTime = arg1_1.submit_time or 0
	arg0_1._actId = nil
	arg0_1._autoSubmit = false
end

function var0_0.isClientTrigger(arg0_2)
	return arg0_2:getConfig("sub_type") > 2000 and arg0_2:getConfig("sub_type") < 3000
end

function var0_0.bindConfigTable(arg0_3)
	return pg.task_data_template
end

function var0_0.isGuildTask(arg0_4)
	return arg0_4:getConfig("type") == var0_0.TYPE_GUILD_WEEKLY
end

function var0_0.IsRoutineType(arg0_5)
	return arg0_5:getConfig("type") == var0_0.TYPE_ROUTINE
end

function var0_0.IsActRoutineType(arg0_6)
	return arg0_6:getConfig("type") == var0_0.TYPE_ACTIVITY_ROUTINE
end

function var0_0.IsActType(arg0_7)
	return arg0_7:getConfig("type") == var0_0.TYPE_ACTIVITY
end

function var0_0.IsWeeklyType(arg0_8)
	return arg0_8:getConfig("type") == var0_0.TYPE_WEEKLY or arg0_8:getConfig("type") == var0_0.TYPE_NEW_WEEKLY
end

function var0_0.IsBackYardInterActionType(arg0_9)
	return arg0_9:getConfig("sub_type") == 2010
end

function var0_0.IsFlagShipInterActionType(arg0_10)
	return arg0_10:getConfig("sub_type") == 2011
end

function var0_0.IsGuildAddLivnessType(arg0_11)
	local var0_11 = arg0_11:getConfig("type")

	return var0_11 == var0_0.TYPE_ROUTINE or var0_11 == var0_0.TYPE_WEEKLY or var0_11 == var0_0.TYPE_GUILD_WEEKLY or var0_11 == var0_0.TYPE_NEW_WEEKLY
end

function var0_0.IsCommanderManualType(arg0_12)
	return arg0_12:getConfig("type") == var0_0.TYPE_COMMANDER_MANUAL
end

function var0_0.isLock(arg0_13)
	return getProxy(PlayerProxy):getRawData().level < arg0_13:getConfig("level")
end

function var0_0.isFinish(arg0_14)
	local var0_14 = arg0_14:getProgress()

	if arg0_14:getConfig("sub_type") == TASK_SUB_TYPE_REPEATABLE then
		return var0_14 >= 1
	end

	return var0_14 >= arg0_14:getConfig("target_num")
end

function var0_0.getProgress(arg0_15)
	return switch(arg0_15:getConfig("sub_type"), {
		[TASK_SUB_TYPE_GIVE_ITEM] = function()
			local var0_16 = tonumber(arg0_15:getConfig("target_id"))

			return getProxy(BagProxy):getItemCountById(tonumber(var0_16))
		end,
		[TASK_SUB_TYPE_PT] = function()
			local var0_17 = getProxy(ActivityProxy):getActivityById(tonumber(arg0_15:getConfig("target_id_2")))

			return var0_17 and var0_17.data1 or 0
		end,
		[TASK_SUB_TYPE_PLAYER_RES] = function()
			local var0_18 = tonumber(arg0_15:getConfig("target_id"))

			return getProxy(PlayerProxy):getData():getResById(var0_18)
		end,
		[TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM] = function()
			local var0_19 = tonumber(arg0_15:getConfig("target_id"))

			return getProxy(ActivityProxy):getVirtualItemNumber(var0_19)
		end,
		[TASK_SUB_TYPE_BOSS_PT] = function()
			local var0_20 = tonumber(arg0_15:getConfig("target_id"))

			return getProxy(PlayerProxy):getData():getResById(var0_20)
		end,
		[TASK_SUB_STROY] = function()
			local var0_21 = arg0_15:getConfig("target_id")
			local var1_21 = 0

			_.each(var0_21, function(arg0_22)
				if pg.NewStoryMgr.GetInstance():GetPlayedFlag(arg0_22) then
					var1_21 = var1_21 + 1
				end
			end)

			return var1_21
		end,
		[TASK_SUB_TYPE_TECHNOLOGY_POINT] = function()
			return math.min(getProxy(TechnologyNationProxy):getNationPoint(tonumber(arg0_15:getConfig("target_id"))), arg0_15:getConfig("target_num"))
		end,
		[TASK_SUB_TYPE_VITEM] = function()
			local var0_24 = tonumber(arg0_15:getConfig("target_id"))
			local var1_24 = tonumber(arg0_15:getConfig("target_id_2"))
			local var2_24 = pg.activity_drop_type[var0_24].activity_id
			local var3_24 = getProxy(ActivityProxy):getActivityById(var2_24)

			if var3_24 then
				return var3_24:getVitemNumber(var1_24)
			end
		end,
		[TASK_SUB_TYPE_VITEMS] = function()
			local var0_25 = tonumber(arg0_15:getConfig("target_id"))

			if underscore.all(arg0_15:getConfig("target_id_2"), function(arg0_26)
				local var0_26 = Drop.New({
					type = var0_25,
					id = arg0_26[1],
					count = arg0_26[2]
				})

				return var0_26:getOwnedCount() >= var0_26.count
			end) then
				return 1
			end
		end,
		[TASK_SUB_TYPE_JOIN_GUILD] = function()
			return getProxy(GuildProxy):getData() and 1 or 0
		end,
		[TASK_SUB_TYPE_COLLAB_BOSS_RUSH_DEFEAT] = function()
			local var0_28 = tonumber(arg0_15:getConfig("target_id"))
			local var1_28 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB)

			if not var1_28 then
				return 0
			end

			local var2_28 = var1_28:GetCollabSeriesDataList()

			for iter0_28, iter1_28 in pairs(var2_28) do
				if iter1_28:GetCollabBossID() == var0_28 then
					return iter1_28:GetBossTimeStamp() ~= 0 and 1 or 0
				end
			end

			return 0
		end,
		[TASK_SUB_TYPE_REPEATABLE] = function()
			return arg0_15.progress >= 1 and 1 or 0
		end,
		[TASK_SUB_TYPE_COMPLETE_ALL_DAILY_TASKS] = function()
			return underscore.any(getProxy(TaskProxy):getTasks(), function(arg0_31)
				return arg0_31:IsRoutineType() and arg0_31:getConfig("sub_type") ~= TASK_SUB_TYPE_COMPLETE_ALL_DAILY_TASKS
			end) and 0 or 1
		end
	}, function()
		return arg0_15.progress
	end) or 0
end

function var0_0.getTargetNumber(arg0_33)
	return arg0_33:getConfig("target_num")
end

function var0_0.isReceive(arg0_34)
	return arg0_34.submitTime > 0
end

function var0_0.isCircle(arg0_35)
	if arg0_35:isActivityTask() then
		if arg0_35:getConfig("type") == 16 and arg0_35:getConfig("sub_type") == 1006 then
			return true
		elseif arg0_35:getConfig("type") == 16 and arg0_35:getConfig("sub_type") == 20 then
			return true
		elseif arg0_35:getConfig("type") == 16 and arg0_35:getConfig("sub_type") == 1007 then
			return true
		elseif arg0_35:getConfig("type") == 16 and arg0_35:getConfig("sub_type") == 122 then
			return true
		end
	end

	return false
end

function var0_0.isDaily(arg0_36)
	return arg0_36:getConfig("sub_type") == 415 or arg0_36:getConfig("sub_type") == 412
end

function var0_0.getTaskStatus(arg0_37)
	if arg0_37:isLock() then
		return -1
	end

	if arg0_37:isReceive() then
		return 2
	end

	if arg0_37:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_38)
	local function var0_38()
		if arg0_38:getConfig("sub_type") == 29 then
			local var0_39 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_39, function(arg0_40)
				return arg0_40:getConfig("task_id") == arg0_38.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_38
			})
		elseif arg0_38:getConfig("added_tip") > 0 then
			local var1_39

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_39()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_38:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_forward",
				noText = "text_iknow",
				content = i18n("tip_add_task", arg0_38:getConfig("name")),
				onYes = var1_39
			})
		end

		if arg0_38:IsCommanderManualType() then
			getProxy(CommanderManualProxy):AddPageTaskDone(arg0_38)
		end
	end

	local function var1_38()
		local var0_42 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_42.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_38 = arg0_38:getConfig("story_id")

	if var2_38 and var2_38 ~= "" and var1_38() then
		pg.NewStoryMgr.GetInstance():Play(var2_38, var0_38, true, true)
	else
		var0_38()
	end
end

function var0_0.updateProgress(arg0_43, arg1_43)
	arg0_43.progress = arg1_43
end

function var0_0.isSelectable(arg0_44)
	local var0_44 = arg0_44:getConfig("award_choice")

	return var0_44 ~= nil and type(var0_44) == "table" and #var0_44 > 0
end

function var0_0.judgeOverflow(arg0_45, arg1_45, arg2_45, arg3_45)
	local var0_45 = arg0_45:getTaskStatus() == 1
	local var1_45 = arg0_45:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_45, arg2_45, arg3_45, var0_45, var1_45, arg0_45:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46, arg5_46)
	if arg3_46 and arg4_46 then
		local var0_46 = getProxy(PlayerProxy):getData()
		local var1_46 = pg.gameset.urpt_chapter_max.description[1]
		local var2_46 = arg0_46 or var0_46.gold
		local var3_46 = arg1_46 or var0_46.oil
		local var4_46 = arg2_46 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_46) or 0
		local var5_46 = pg.gameset.max_gold.key_value
		local var6_46 = pg.gameset.max_oil.key_value
		local var7_46 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_46 = false
		local var9_46 = false
		local var10_46 = false
		local var11_46 = false
		local var12_46 = false
		local var13_46 = {}
		local var14_46 = arg5_46

		for iter0_46, iter1_46 in ipairs(var14_46) do
			local var15_46, var16_46, var17_46 = unpack(iter1_46)

			if var15_46 == DROP_TYPE_RESOURCE then
				if var16_46 == PlayerConst.ResGold then
					local var18_46 = var2_46 + var17_46 - var5_46

					if var18_46 > 0 then
						var8_46 = true

						local var19_46 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_46, COLOR_RED)
						}

						table.insert(var13_46, var19_46)
					end
				elseif var16_46 == PlayerConst.ResOil then
					local var20_46 = var3_46 + var17_46 - var6_46

					if var20_46 > 0 then
						var9_46 = true

						local var21_46 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_46, COLOR_RED)
						}

						table.insert(var13_46, var21_46)
					end
				end
			elseif not LOCK_UR_SHIP and var15_46 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_46).virtual_type == 20 then
					local var22_46 = var4_46 + var17_46 - var7_46

					if var22_46 > 0 then
						var10_46 = true

						local var23_46 = {
							type = DROP_TYPE_VITEM,
							id = var1_46,
							count = setColorStr(var22_46, COLOR_RED)
						}

						table.insert(var13_46, var23_46)
					end
				end
			elseif var15_46 == DROP_TYPE_ITEM and Item.getConfigData(var16_46).type == Item.EXP_BOOK_TYPE then
				local var24_46 = getProxy(BagProxy):getItemCountById(var16_46) + var17_46
				local var25_46 = Item.getConfigData(var16_46).max_num

				if var25_46 < var24_46 then
					var11_46 = true

					local var26_46 = {
						type = DROP_TYPE_ITEM,
						id = var16_46,
						count = setColorStr(math.min(var17_46, var24_46 - var25_46), COLOR_RED)
					}

					table.insert(var13_46, var26_46)
				end
			end
		end

		return var8_46 or var9_46 or var10_46 or var11_46, var13_46
	end
end

function var0_0.IsUrTask(arg0_47)
	if not LOCK_UR_SHIP then
		local var0_47 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_47:getConfig("award_display"), function(arg0_48)
			return arg0_48[1] == DROP_TYPE_ITEM and arg0_48[2] == var0_47
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_49)
	local var0_49 = arg0_49:getConfig("priority_type")

	if var0_49 == 0 then
		var0_49 = arg0_49:getConfig("type")
	end

	return var0_49
end

function var0_0.IsOverflowShipExpItem(arg0_50)
	local function var0_50(arg0_51, arg1_51)
		return getProxy(BagProxy):getItemCountById(arg0_51) + arg1_51 > Item.getConfigData(arg0_51).max_num
	end

	local var1_50 = arg0_50:getConfig("award_display")

	for iter0_50, iter1_50 in ipairs(var1_50) do
		local var2_50 = iter1_50[1]
		local var3_50 = iter1_50[2]
		local var4_50 = iter1_50[3]

		if var2_50 == DROP_TYPE_ITEM and Item.getConfigData(var3_50).type == Item.EXP_BOOK_TYPE and var0_50(var3_50, var4_50) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_52)
	local var0_52 = arg0_52:getConfig("visibility") == 1

	if arg0_52.id == 17268 then
		var0_52 = false

		local var1_52 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_52 and not var1_52:isEnd() then
			local var2_52 = var1_52.data1KeyValueList[2][17] or 1
			local var3_52 = var1_52.data1KeyValueList[2][18] or 1

			var0_52 = var2_52 >= 4 and var3_52 >= 4
		end
	end

	return var0_52
end

function var0_0.setTaskFinish(arg0_53)
	arg0_53.submitTime = 1

	arg0_53:updateProgress(arg0_53:getConfig("target_num"))
end

function var0_0.isAvatarTask(arg0_54)
	return false
end

function var0_0.getActId(arg0_55)
	return arg0_55._actId
end

function var0_0.setActId(arg0_56, arg1_56)
	arg0_56._actId = arg1_56
end

function var0_0.isActivityTask(arg0_57)
	return arg0_57._actId and arg0_57._actId > 0
end

function var0_0.setAutoSubmit(arg0_58, arg1_58)
	arg0_58._autoSubmit = arg1_58
end

function var0_0.getAutoSubmit(arg0_59)
	return arg0_59._autoSubmit
end

function var0_0.getGiveDrops(arg0_60)
	local var0_60 = {}

	if arg0_60:getConfig("sub_type") == TASK_SUB_TYPE_VITEMS then
		local var1_60 = tonumber(arg0_60:getConfig("target_id"))

		for iter0_60, iter1_60 in ipairs(arg0_60:getConfig("target_id_2")) do
			table.insert(var0_60, Drop.New({
				type = var1_60,
				id = iter1_60[1],
				count = iter1_60[2]
			}))
		end
	end

	return var0_60
end

function var0_0.OwnSpAward(arg0_61)
	local function var0_61(arg0_62)
		return getProxy(DormProxy):getData():GetOwnFurnitureCount(arg0_62) > 0
	end

	local function var1_61(arg0_63)
		local var0_63 = getProxy(CollectionProxy):GetTrophyById(arg0_63)

		return var0_63 and (var0_63:canClaimed() or var0_63:isClaimed())
	end

	local function var2_61(arg0_64)
		local var0_64 = getProxy(PlayerProxy):getRawData():getActivityMedalGroup()

		for iter0_64, iter1_64 in pairs(var0_64) do
			if iter1_64:OwnMedel(arg0_64) then
				return true
			end
		end

		return false
	end

	local var3_61 = {
		type = arg0_61[1],
		id = arg0_61[2],
		count = arg0_61[3]
	}

	if var3_61.type == DROP_TYPE_FURNITURE then
		return var0_61(var3_61.id)
	elseif var3_61.type == DROP_TYPE_VITEM then
		local var4_61 = pg.item_virtual_data_statistics[var3_61.id].album_config

		if type(var4_61) == "table" then
			local var5_61 = var4_61[1]
			local var6_61 = var4_61[2]

			if var5_61 == 1 then
				return var1_61(var6_61)
			elseif var5_61 == 2 then
				return var2_61(var6_61)
			end
		end
	end

	return false
end

return var0_0
