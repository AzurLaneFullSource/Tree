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
		end
	}, function()
		return arg0_15.progress
	end) or 0
end

function var0_0.getTargetNumber(arg0_31)
	return arg0_31:getConfig("target_num")
end

function var0_0.isReceive(arg0_32)
	return arg0_32.submitTime > 0
end

function var0_0.isCircle(arg0_33)
	if arg0_33:isActivityTask() then
		if arg0_33:getConfig("type") == 16 and arg0_33:getConfig("sub_type") == 1006 then
			return true
		elseif arg0_33:getConfig("type") == 16 and arg0_33:getConfig("sub_type") == 20 then
			return true
		elseif arg0_33:getConfig("type") == 16 and arg0_33:getConfig("sub_type") == 1007 then
			return true
		elseif arg0_33:getConfig("type") == 16 and arg0_33:getConfig("sub_type") == 122 then
			return true
		end
	end

	return false
end

function var0_0.isDaily(arg0_34)
	return arg0_34:getConfig("sub_type") == 415 or arg0_34:getConfig("sub_type") == 412
end

function var0_0.getTaskStatus(arg0_35)
	if arg0_35:isLock() then
		return -1
	end

	if arg0_35:isReceive() then
		return 2
	end

	if arg0_35:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_36)
	local function var0_36()
		if arg0_36:getConfig("sub_type") == 29 then
			local var0_37 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_37, function(arg0_38)
				return arg0_38:getConfig("task_id") == arg0_36.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_36
			})
		elseif arg0_36:getConfig("added_tip") > 0 then
			local var1_37

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_37()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_36:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_forward",
				noText = "text_iknow",
				content = i18n("tip_add_task", arg0_36:getConfig("name")),
				onYes = var1_37
			})
		end

		if arg0_36:IsCommanderManualType() then
			getProxy(CommanderManualProxy):AddPageTaskDone(arg0_36)
		end
	end

	local function var1_36()
		local var0_40 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_40.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_36 = arg0_36:getConfig("story_id")

	if var2_36 and var2_36 ~= "" and var1_36() then
		pg.NewStoryMgr.GetInstance():Play(var2_36, var0_36, true, true)
	else
		var0_36()
	end
end

function var0_0.updateProgress(arg0_41, arg1_41)
	arg0_41.progress = arg1_41
end

function var0_0.isSelectable(arg0_42)
	local var0_42 = arg0_42:getConfig("award_choice")

	return var0_42 ~= nil and type(var0_42) == "table" and #var0_42 > 0
end

function var0_0.judgeOverflow(arg0_43, arg1_43, arg2_43, arg3_43)
	local var0_43 = arg0_43:getTaskStatus() == 1
	local var1_43 = arg0_43:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_43, arg2_43, arg3_43, var0_43, var1_43, arg0_43:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44, arg5_44)
	if arg3_44 and arg4_44 then
		local var0_44 = getProxy(PlayerProxy):getData()
		local var1_44 = pg.gameset.urpt_chapter_max.description[1]
		local var2_44 = arg0_44 or var0_44.gold
		local var3_44 = arg1_44 or var0_44.oil
		local var4_44 = arg2_44 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_44) or 0
		local var5_44 = pg.gameset.max_gold.key_value
		local var6_44 = pg.gameset.max_oil.key_value
		local var7_44 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_44 = false
		local var9_44 = false
		local var10_44 = false
		local var11_44 = false
		local var12_44 = false
		local var13_44 = {}
		local var14_44 = arg5_44

		for iter0_44, iter1_44 in ipairs(var14_44) do
			local var15_44, var16_44, var17_44 = unpack(iter1_44)

			if var15_44 == DROP_TYPE_RESOURCE then
				if var16_44 == PlayerConst.ResGold then
					local var18_44 = var2_44 + var17_44 - var5_44

					if var18_44 > 0 then
						var8_44 = true

						local var19_44 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_44, COLOR_RED)
						}

						table.insert(var13_44, var19_44)
					end
				elseif var16_44 == PlayerConst.ResOil then
					local var20_44 = var3_44 + var17_44 - var6_44

					if var20_44 > 0 then
						var9_44 = true

						local var21_44 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_44, COLOR_RED)
						}

						table.insert(var13_44, var21_44)
					end
				end
			elseif not LOCK_UR_SHIP and var15_44 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_44).virtual_type == 20 then
					local var22_44 = var4_44 + var17_44 - var7_44

					if var22_44 > 0 then
						var10_44 = true

						local var23_44 = {
							type = DROP_TYPE_VITEM,
							id = var1_44,
							count = setColorStr(var22_44, COLOR_RED)
						}

						table.insert(var13_44, var23_44)
					end
				end
			elseif var15_44 == DROP_TYPE_ITEM and Item.getConfigData(var16_44).type == Item.EXP_BOOK_TYPE then
				local var24_44 = getProxy(BagProxy):getItemCountById(var16_44) + var17_44
				local var25_44 = Item.getConfigData(var16_44).max_num

				if var25_44 < var24_44 then
					var11_44 = true

					local var26_44 = {
						type = DROP_TYPE_ITEM,
						id = var16_44,
						count = setColorStr(math.min(var17_44, var24_44 - var25_44), COLOR_RED)
					}

					table.insert(var13_44, var26_44)
				end
			end
		end

		return var8_44 or var9_44 or var10_44 or var11_44, var13_44
	end
end

function var0_0.IsUrTask(arg0_45)
	if not LOCK_UR_SHIP then
		local var0_45 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_45:getConfig("award_display"), function(arg0_46)
			return arg0_46[1] == DROP_TYPE_ITEM and arg0_46[2] == var0_45
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_47)
	local var0_47 = arg0_47:getConfig("priority_type")

	if var0_47 == 0 then
		var0_47 = arg0_47:getConfig("type")
	end

	return var0_47
end

function var0_0.IsOverflowShipExpItem(arg0_48)
	local function var0_48(arg0_49, arg1_49)
		return getProxy(BagProxy):getItemCountById(arg0_49) + arg1_49 > Item.getConfigData(arg0_49).max_num
	end

	local var1_48 = arg0_48:getConfig("award_display")

	for iter0_48, iter1_48 in ipairs(var1_48) do
		local var2_48 = iter1_48[1]
		local var3_48 = iter1_48[2]
		local var4_48 = iter1_48[3]

		if var2_48 == DROP_TYPE_ITEM and Item.getConfigData(var3_48).type == Item.EXP_BOOK_TYPE and var0_48(var3_48, var4_48) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_50)
	local var0_50 = arg0_50:getConfig("visibility") == 1

	if arg0_50.id == 17268 then
		var0_50 = false

		local var1_50 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_50 and not var1_50:isEnd() then
			local var2_50 = var1_50.data1KeyValueList[2][17] or 1
			local var3_50 = var1_50.data1KeyValueList[2][18] or 1

			var0_50 = var2_50 >= 4 and var3_50 >= 4
		end
	end

	return var0_50
end

function var0_0.setTaskFinish(arg0_51)
	arg0_51.submitTime = 1

	arg0_51:updateProgress(arg0_51:getConfig("target_num"))
end

function var0_0.isAvatarTask(arg0_52)
	return false
end

function var0_0.getActId(arg0_53)
	return arg0_53._actId
end

function var0_0.setActId(arg0_54, arg1_54)
	arg0_54._actId = arg1_54
end

function var0_0.isActivityTask(arg0_55)
	return arg0_55._actId and arg0_55._actId > 0
end

function var0_0.setAutoSubmit(arg0_56, arg1_56)
	arg0_56._autoSubmit = arg1_56
end

function var0_0.getAutoSubmit(arg0_57)
	return arg0_57._autoSubmit
end

function var0_0.getGiveDrops(arg0_58)
	local var0_58 = {}

	if arg0_58:getConfig("sub_type") == TASK_SUB_TYPE_VITEMS then
		local var1_58 = tonumber(arg0_58:getConfig("target_id"))

		for iter0_58, iter1_58 in ipairs(arg0_58:getConfig("target_id_2")) do
			table.insert(var0_58, Drop.New({
				type = var1_58,
				id = iter1_58[1],
				count = iter1_58[2]
			}))
		end
	end

	return var0_58
end

function var0_0.OwnSpAward(arg0_59)
	local function var0_59(arg0_60)
		return getProxy(DormProxy):getData():GetOwnFurnitureCount(arg0_60) > 0
	end

	local function var1_59(arg0_61)
		local var0_61 = getProxy(CollectionProxy):GetTrophyById(arg0_61)

		return var0_61 and (var0_61:canClaimed() or var0_61:isClaimed())
	end

	local function var2_59(arg0_62)
		local var0_62 = getProxy(PlayerProxy):getRawData():getActivityMedalGroup()

		for iter0_62, iter1_62 in pairs(var0_62) do
			if iter1_62:OwnMedel(arg0_62) then
				return true
			end
		end

		return false
	end

	local var3_59 = {
		type = arg0_59[1],
		id = arg0_59[2],
		count = arg0_59[3]
	}

	if var3_59.type == DROP_TYPE_FURNITURE then
		return var0_59(var3_59.id)
	elseif var3_59.type == DROP_TYPE_VITEM then
		local var4_59 = pg.item_virtual_data_statistics[var3_59.id].album_config

		if type(var4_59) == "table" then
			local var5_59 = var4_59[1]
			local var6_59 = var4_59[2]

			if var5_59 == 1 then
				return var1_59(var6_59)
			elseif var5_59 == 2 then
				return var2_59(var6_59)
			end
		end
	end

	return false
end

return var0_0
