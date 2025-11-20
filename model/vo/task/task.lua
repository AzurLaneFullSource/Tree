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
	return arg0_14:getProgress() >= arg0_14:getConfig("target_num")
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
		end
	}, function()
		return arg0_15.progress
	end) or 0
end

function var0_0.getTargetNumber(arg0_30)
	return arg0_30:getConfig("target_num")
end

function var0_0.isReceive(arg0_31)
	return arg0_31.submitTime > 0
end

function var0_0.isCircle(arg0_32)
	if arg0_32:isActivityTask() then
		if arg0_32:getConfig("type") == 16 and arg0_32:getConfig("sub_type") == 1006 then
			return true
		elseif arg0_32:getConfig("type") == 16 and arg0_32:getConfig("sub_type") == 20 then
			return true
		elseif arg0_32:getConfig("type") == 16 and arg0_32:getConfig("sub_type") == 1007 then
			return true
		elseif arg0_32:getConfig("type") == 16 and arg0_32:getConfig("sub_type") == 122 then
			return true
		end
	end

	return false
end

function var0_0.isDaily(arg0_33)
	return arg0_33:getConfig("sub_type") == 415 or arg0_33:getConfig("sub_type") == 412
end

function var0_0.getTaskStatus(arg0_34)
	if arg0_34:isLock() then
		return -1
	end

	if arg0_34:isReceive() then
		return 2
	end

	if arg0_34:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_35)
	local function var0_35()
		if arg0_35:getConfig("sub_type") == 29 then
			local var0_36 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_36, function(arg0_37)
				return arg0_37:getConfig("task_id") == arg0_35.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_35
			})
		elseif arg0_35:getConfig("added_tip") > 0 then
			local var1_36

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_36()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_35:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_forward",
				noText = "text_iknow",
				content = i18n("tip_add_task", arg0_35:getConfig("name")),
				onYes = var1_36
			})
		end

		if arg0_35:IsCommanderManualType() then
			getProxy(CommanderManualProxy):AddPageTaskDone(arg0_35)
		end
	end

	local function var1_35()
		local var0_39 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_39.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_35 = arg0_35:getConfig("story_id")

	if var2_35 and var2_35 ~= "" and var1_35() then
		pg.NewStoryMgr.GetInstance():Play(var2_35, var0_35, true, true)
	else
		var0_35()
	end
end

function var0_0.updateProgress(arg0_40, arg1_40)
	arg0_40.progress = arg1_40
end

function var0_0.isSelectable(arg0_41)
	local var0_41 = arg0_41:getConfig("award_choice")

	return var0_41 ~= nil and type(var0_41) == "table" and #var0_41 > 0
end

function var0_0.judgeOverflow(arg0_42, arg1_42, arg2_42, arg3_42)
	local var0_42 = arg0_42:getTaskStatus() == 1
	local var1_42 = arg0_42:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_42, arg2_42, arg3_42, var0_42, var1_42, arg0_42:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43, arg5_43)
	if arg3_43 and arg4_43 then
		local var0_43 = getProxy(PlayerProxy):getData()
		local var1_43 = pg.gameset.urpt_chapter_max.description[1]
		local var2_43 = arg0_43 or var0_43.gold
		local var3_43 = arg1_43 or var0_43.oil
		local var4_43 = arg2_43 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_43) or 0
		local var5_43 = pg.gameset.max_gold.key_value
		local var6_43 = pg.gameset.max_oil.key_value
		local var7_43 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_43 = false
		local var9_43 = false
		local var10_43 = false
		local var11_43 = false
		local var12_43 = false
		local var13_43 = {}
		local var14_43 = arg5_43

		for iter0_43, iter1_43 in ipairs(var14_43) do
			local var15_43, var16_43, var17_43 = unpack(iter1_43)

			if var15_43 == DROP_TYPE_RESOURCE then
				if var16_43 == PlayerConst.ResGold then
					local var18_43 = var2_43 + var17_43 - var5_43

					if var18_43 > 0 then
						var8_43 = true

						local var19_43 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_43, COLOR_RED)
						}

						table.insert(var13_43, var19_43)
					end
				elseif var16_43 == PlayerConst.ResOil then
					local var20_43 = var3_43 + var17_43 - var6_43

					if var20_43 > 0 then
						var9_43 = true

						local var21_43 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_43, COLOR_RED)
						}

						table.insert(var13_43, var21_43)
					end
				end
			elseif not LOCK_UR_SHIP and var15_43 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_43).virtual_type == 20 then
					local var22_43 = var4_43 + var17_43 - var7_43

					if var22_43 > 0 then
						var10_43 = true

						local var23_43 = {
							type = DROP_TYPE_VITEM,
							id = var1_43,
							count = setColorStr(var22_43, COLOR_RED)
						}

						table.insert(var13_43, var23_43)
					end
				end
			elseif var15_43 == DROP_TYPE_ITEM and Item.getConfigData(var16_43).type == Item.EXP_BOOK_TYPE then
				local var24_43 = getProxy(BagProxy):getItemCountById(var16_43) + var17_43
				local var25_43 = Item.getConfigData(var16_43).max_num

				if var25_43 < var24_43 then
					var11_43 = true

					local var26_43 = {
						type = DROP_TYPE_ITEM,
						id = var16_43,
						count = setColorStr(math.min(var17_43, var24_43 - var25_43), COLOR_RED)
					}

					table.insert(var13_43, var26_43)
				end
			end
		end

		return var8_43 or var9_43 or var10_43 or var11_43, var13_43
	end
end

function var0_0.IsUrTask(arg0_44)
	if not LOCK_UR_SHIP then
		local var0_44 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_44:getConfig("award_display"), function(arg0_45)
			return arg0_45[1] == DROP_TYPE_ITEM and arg0_45[2] == var0_44
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_46)
	local var0_46 = arg0_46:getConfig("priority_type")

	if var0_46 == 0 then
		var0_46 = arg0_46:getConfig("type")
	end

	return var0_46
end

function var0_0.IsOverflowShipExpItem(arg0_47)
	local function var0_47(arg0_48, arg1_48)
		return getProxy(BagProxy):getItemCountById(arg0_48) + arg1_48 > Item.getConfigData(arg0_48).max_num
	end

	local var1_47 = arg0_47:getConfig("award_display")

	for iter0_47, iter1_47 in ipairs(var1_47) do
		local var2_47 = iter1_47[1]
		local var3_47 = iter1_47[2]
		local var4_47 = iter1_47[3]

		if var2_47 == DROP_TYPE_ITEM and Item.getConfigData(var3_47).type == Item.EXP_BOOK_TYPE and var0_47(var3_47, var4_47) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_49)
	local var0_49 = arg0_49:getConfig("visibility") == 1

	if arg0_49.id == 17268 then
		var0_49 = false

		local var1_49 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_49 and not var1_49:isEnd() then
			local var2_49 = var1_49.data1KeyValueList[2][17] or 1
			local var3_49 = var1_49.data1KeyValueList[2][18] or 1

			var0_49 = var2_49 >= 4 and var3_49 >= 4
		end
	end

	return var0_49
end

function var0_0.setTaskFinish(arg0_50)
	arg0_50.submitTime = 1

	arg0_50:updateProgress(arg0_50:getConfig("target_num"))
end

function var0_0.isAvatarTask(arg0_51)
	return false
end

function var0_0.getActId(arg0_52)
	return arg0_52._actId
end

function var0_0.setActId(arg0_53, arg1_53)
	arg0_53._actId = arg1_53
end

function var0_0.isActivityTask(arg0_54)
	return arg0_54._actId and arg0_54._actId > 0
end

function var0_0.setAutoSubmit(arg0_55, arg1_55)
	arg0_55._autoSubmit = arg1_55
end

function var0_0.getAutoSubmit(arg0_56)
	return arg0_56._autoSubmit
end

function var0_0.getGiveDrops(arg0_57)
	local var0_57 = {}

	if arg0_57:getConfig("sub_type") == TASK_SUB_TYPE_VITEMS then
		local var1_57 = tonumber(arg0_57:getConfig("target_id"))

		for iter0_57, iter1_57 in ipairs(arg0_57:getConfig("target_id_2")) do
			table.insert(var0_57, Drop.New({
				type = var1_57,
				id = iter1_57[1],
				count = iter1_57[2]
			}))
		end
	end

	return var0_57
end

return var0_0
