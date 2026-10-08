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
var0_0.MEDAL_TYPE_TROPHY = 1
var0_0.MEDAL_TYPE_ACT = 2

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
			local var0_17 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = tonumber(arg0_15:getConfig("target_id"))
			})
			local var1_17 = getProxy(ActivityProxy):GetPTActivityByRes(var0_17)

			return var1_17 and var1_17:GetTotalPtCount() or 0
		end,
		[TASK_SUB_TYPE_PT_PLUS] = function()
			local var0_18 = getProxy(ActivityProxy):getActivityById(tonumber(arg0_15:getConfig("target_id")))

			return var0_18 and var0_18:GetTotalPtCount() or 0
		end,
		[TASK_SUB_TYPE_PLAYER_RES] = function()
			local var0_19 = tonumber(arg0_15:getConfig("target_id"))

			return getProxy(PlayerProxy):getData():getResById(var0_19)
		end,
		[TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM] = function()
			local var0_20 = tonumber(arg0_15:getConfig("target_id"))

			return getProxy(ActivityProxy):getVirtualItemNumber(var0_20)
		end,
		[TASK_SUB_TYPE_BOSS_PT] = function()
			local var0_21 = tonumber(arg0_15:getConfig("target_id"))

			return getProxy(PlayerProxy):getData():getResById(var0_21)
		end,
		[TASK_SUB_STROY] = function()
			local var0_22 = arg0_15:getConfig("target_id")
			local var1_22 = 0

			_.each(var0_22, function(arg0_23)
				if pg.NewStoryMgr.GetInstance():GetPlayedFlag(arg0_23) then
					var1_22 = var1_22 + 1
				end
			end)

			return var1_22
		end,
		[TASK_SUB_TYPE_TECHNOLOGY_POINT] = function()
			return math.min(getProxy(TechnologyNationProxy):getNationPoint(tonumber(arg0_15:getConfig("target_id"))), arg0_15:getConfig("target_num"))
		end,
		[TASK_SUB_TYPE_VITEM] = function()
			local var0_25 = tonumber(arg0_15:getConfig("target_id"))
			local var1_25 = tonumber(arg0_15:getConfig("target_id_2"))
			local var2_25 = pg.activity_drop_type[var0_25].activity_id
			local var3_25 = getProxy(ActivityProxy):getActivityById(var2_25)

			if var3_25 then
				return var3_25:getVitemNumber(var1_25)
			end
		end,
		[TASK_SUB_TYPE_VITEMS] = function()
			local var0_26 = tonumber(arg0_15:getConfig("target_id"))

			if underscore.all(arg0_15:getConfig("target_id_2"), function(arg0_27)
				local var0_27 = Drop.New({
					type = var0_26,
					id = arg0_27[1],
					count = arg0_27[2]
				})

				return var0_27:getOwnedCount() >= var0_27.count
			end) then
				return 1
			end
		end,
		[TASK_SUB_TYPE_JOIN_GUILD] = function()
			return getProxy(GuildProxy):getData() and 1 or 0
		end,
		[TASK_SUB_TYPE_COLLAB_BOSS_RUSH_DEFEAT] = function()
			local var0_29 = tonumber(arg0_15:getConfig("target_id"))
			local var1_29 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB)

			if not var1_29 then
				return 0
			end

			local var2_29 = var1_29:GetCollabSeriesDataList()

			for iter0_29, iter1_29 in pairs(var2_29) do
				if iter1_29:GetCollabBossID() == var0_29 then
					return iter1_29:GetBossTimeStamp() ~= 0 and 1 or 0
				end
			end

			return 0
		end,
		[TASK_SUB_TYPE_REPEATABLE] = function()
			return arg0_15.progress >= 1 and 1 or 0
		end,
		[TASK_SUB_TYPE_COMPLETE_ALL_DAILY_TASKS] = function()
			return underscore.any(getProxy(TaskProxy):getTasks(), function(arg0_32)
				return arg0_32:IsRoutineType() and arg0_32:getConfig("sub_type") ~= TASK_SUB_TYPE_COMPLETE_ALL_DAILY_TASKS
			end) and 0 or 1
		end
	}, function()
		return arg0_15.progress
	end) or 0
end

function var0_0.getTargetNumber(arg0_34)
	return arg0_34:getConfig("target_num")
end

function var0_0.isReceive(arg0_35)
	return arg0_35.submitTime > 0
end

function var0_0.isCircle(arg0_36)
	if arg0_36:isActivityTask() then
		if arg0_36:getConfig("type") == 16 and arg0_36:getConfig("sub_type") == 1006 then
			return true
		elseif arg0_36:getConfig("type") == 16 and arg0_36:getConfig("sub_type") == 20 then
			return true
		elseif arg0_36:getConfig("type") == 16 and arg0_36:getConfig("sub_type") == 1007 then
			return true
		elseif arg0_36:getConfig("type") == 16 and arg0_36:getConfig("sub_type") == 122 then
			return true
		end
	end

	return false
end

function var0_0.isDaily(arg0_37)
	return arg0_37:getConfig("sub_type") == 415 or arg0_37:getConfig("sub_type") == 412
end

function var0_0.getTaskStatus(arg0_38)
	if arg0_38:isLock() then
		return -1
	end

	if arg0_38:isReceive() then
		return 2
	end

	if arg0_38:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_39)
	local function var0_39()
		if arg0_39:getConfig("sub_type") == 29 then
			local var0_40 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_40, function(arg0_41)
				return arg0_41:getConfig("task_id") == arg0_39.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_39
			})
		elseif arg0_39:getConfig("added_tip") > 0 then
			local var1_40

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_40()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_39:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_forward",
				noText = "text_iknow",
				content = i18n("tip_add_task", arg0_39:getConfig("name")),
				onYes = var1_40
			})
		end

		if arg0_39:IsCommanderManualType() then
			getProxy(CommanderManualProxy):AddPageTaskDone(arg0_39)
		end
	end

	local function var1_39()
		local var0_43 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_43.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_39 = arg0_39:getConfig("story_id")

	if var2_39 and var2_39 ~= "" and var1_39() then
		pg.NewStoryMgr.GetInstance():Play(var2_39, var0_39, true, true)
	else
		var0_39()
	end
end

function var0_0.updateProgress(arg0_44, arg1_44)
	arg0_44.progress = arg1_44
end

function var0_0.isSelectable(arg0_45)
	local var0_45 = arg0_45:getConfig("award_choice")

	return var0_45 ~= nil and type(var0_45) == "table" and #var0_45 > 0
end

function var0_0.judgeOverflow(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = arg0_46:getTaskStatus() == 1
	local var1_46 = arg0_46:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_46, arg2_46, arg3_46, var0_46, var1_46, arg0_46:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47, arg5_47)
	if arg3_47 and arg4_47 then
		local var0_47 = getProxy(PlayerProxy):getData()
		local var1_47 = pg.gameset.urpt_chapter_max.description[1]
		local var2_47 = arg0_47 or var0_47.gold
		local var3_47 = arg1_47 or var0_47.oil
		local var4_47 = arg2_47 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_47) or 0
		local var5_47 = pg.gameset.max_gold.key_value
		local var6_47 = pg.gameset.max_oil.key_value
		local var7_47 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_47 = false
		local var9_47 = false
		local var10_47 = false
		local var11_47 = false
		local var12_47 = false
		local var13_47 = {}
		local var14_47 = arg5_47

		for iter0_47, iter1_47 in ipairs(var14_47) do
			local var15_47, var16_47, var17_47 = unpack(iter1_47)

			if var15_47 == DROP_TYPE_RESOURCE then
				if var16_47 == PlayerConst.ResGold then
					local var18_47 = var2_47 + var17_47 - var5_47

					if var18_47 > 0 then
						var8_47 = true

						local var19_47 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_47, COLOR_RED)
						}

						table.insert(var13_47, var19_47)
					end
				elseif var16_47 == PlayerConst.ResOil then
					local var20_47 = var3_47 + var17_47 - var6_47

					if var20_47 > 0 then
						var9_47 = true

						local var21_47 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_47, COLOR_RED)
						}

						table.insert(var13_47, var21_47)
					end
				end
			elseif not LOCK_UR_SHIP and var15_47 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_47).virtual_type == 20 then
					local var22_47 = var4_47 + var17_47 - var7_47

					if var22_47 > 0 then
						var10_47 = true

						local var23_47 = {
							type = DROP_TYPE_VITEM,
							id = var1_47,
							count = setColorStr(var22_47, COLOR_RED)
						}

						table.insert(var13_47, var23_47)
					end
				end
			elseif var15_47 == DROP_TYPE_ITEM and Item.getConfigData(var16_47).type == Item.EXP_BOOK_TYPE then
				local var24_47 = getProxy(BagProxy):getItemCountById(var16_47) + var17_47
				local var25_47 = Item.getConfigData(var16_47).max_num

				if var25_47 < var24_47 then
					var11_47 = true

					local var26_47 = {
						type = DROP_TYPE_ITEM,
						id = var16_47,
						count = setColorStr(math.min(var17_47, var24_47 - var25_47), COLOR_RED)
					}

					table.insert(var13_47, var26_47)
				end
			end
		end

		return var8_47 or var9_47 or var10_47 or var11_47, var13_47
	end
end

function var0_0.IsUrTask(arg0_48)
	if not LOCK_UR_SHIP then
		local var0_48 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_48:getConfig("award_display"), function(arg0_49)
			return arg0_49[1] == DROP_TYPE_ITEM and arg0_49[2] == var0_48
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_50)
	local var0_50 = arg0_50:getConfig("priority_type")

	if var0_50 == 0 then
		var0_50 = arg0_50:getConfig("type")
	end

	return var0_50
end

function var0_0.IsOverflowShipExpItem(arg0_51)
	local function var0_51(arg0_52, arg1_52)
		return getProxy(BagProxy):getItemCountById(arg0_52) + arg1_52 > Item.getConfigData(arg0_52).max_num
	end

	local var1_51 = arg0_51:getConfig("award_display")

	for iter0_51, iter1_51 in ipairs(var1_51) do
		local var2_51 = iter1_51[1]
		local var3_51 = iter1_51[2]
		local var4_51 = iter1_51[3]

		if var2_51 == DROP_TYPE_ITEM and Item.getConfigData(var3_51).type == Item.EXP_BOOK_TYPE and var0_51(var3_51, var4_51) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_53)
	local var0_53 = arg0_53:getConfig("visibility") == 1

	if arg0_53.id == 17268 then
		var0_53 = false

		local var1_53 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_53 and not var1_53:isEnd() then
			local var2_53 = var1_53.data1KeyValueList[2][17] or 1
			local var3_53 = var1_53.data1KeyValueList[2][18] or 1

			var0_53 = var2_53 >= 4 and var3_53 >= 4
		end
	end

	return var0_53
end

function var0_0.setTaskFinish(arg0_54)
	arg0_54.submitTime = 1

	arg0_54:updateProgress(arg0_54:getConfig("target_num"))
end

function var0_0.isAvatarTask(arg0_55)
	return false
end

function var0_0.getActId(arg0_56)
	return arg0_56._actId
end

function var0_0.setActId(arg0_57, arg1_57)
	arg0_57._actId = arg1_57
end

function var0_0.isActivityTask(arg0_58)
	return arg0_58._actId and arg0_58._actId > 0
end

function var0_0.setAutoSubmit(arg0_59, arg1_59)
	arg0_59._autoSubmit = arg1_59
end

function var0_0.getAutoSubmit(arg0_60)
	return arg0_60._autoSubmit
end

function var0_0.getGiveDrops(arg0_61)
	local var0_61 = {}

	if arg0_61:getConfig("sub_type") == TASK_SUB_TYPE_VITEMS then
		local var1_61 = tonumber(arg0_61:getConfig("target_id"))

		for iter0_61, iter1_61 in ipairs(arg0_61:getConfig("target_id_2")) do
			table.insert(var0_61, Drop.New({
				type = var1_61,
				id = iter1_61[1],
				count = iter1_61[2]
			}))
		end
	end

	return var0_61
end

function var0_0.OwnSpAward(arg0_62)
	local function var0_62(arg0_63)
		return getProxy(DormProxy):getData():GetOwnFurnitureCount(arg0_63) > 0
	end

	local function var1_62(arg0_64)
		local var0_64 = getProxy(CollectionProxy):GetTrophyById(arg0_64)

		return var0_64 and (var0_64:canClaimed() or var0_64:isClaimed())
	end

	local function var2_62(arg0_65)
		return getProxy(PlayerProxy):getRawData():getActivityMedalExist(arg0_65)
	end

	local var3_62 = {
		type = arg0_62[1],
		id = arg0_62[2],
		count = arg0_62[3]
	}

	if var3_62.type == DROP_TYPE_FURNITURE then
		return var0_62(var3_62.id)
	elseif var3_62.type == DROP_TYPE_VITEM then
		local var4_62 = pg.item_virtual_data_statistics[var3_62.id].album_config

		if type(var4_62) == "table" then
			local var5_62 = var4_62[1]
			local var6_62 = var4_62[2]

			if var5_62 == var0_0.MEDAL_TYPE_TROPHY then
				return var1_62(var6_62)
			elseif var5_62 == var0_0.MEDAL_TYPE_ACT then
				return var2_62(var6_62)
			end
		end
	end

	return false
end

function var0_0.HasActMedalAward(arg0_66)
	local function var0_66(arg0_67)
		if arg0_67[1] == DROP_TYPE_VITEM then
			local var0_67 = pg.item_virtual_data_statistics[arg0_67[2]].album_config

			return type(var0_67) == "table" and var0_67[1] == var0_0.MEDAL_TYPE_ACT
		end

		return false
	end

	local var1_66 = arg0_66:getConfig("award_display")

	return _.any(var1_66, function(arg0_68)
		return var0_66(arg0_68)
	end)
end

return var0_0
