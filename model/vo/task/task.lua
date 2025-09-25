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
		end
	}, function()
		return arg0_15.progress
	end) or 0
end

function var0_0.getTargetNumber(arg0_29)
	return arg0_29:getConfig("target_num")
end

function var0_0.isReceive(arg0_30)
	return arg0_30.submitTime > 0
end

function var0_0.isCircle(arg0_31)
	if arg0_31:isActivityTask() then
		if arg0_31:getConfig("type") == 16 and arg0_31:getConfig("sub_type") == 1006 then
			return true
		elseif arg0_31:getConfig("type") == 16 and arg0_31:getConfig("sub_type") == 20 then
			return true
		elseif arg0_31:getConfig("type") == 16 and arg0_31:getConfig("sub_type") == 1007 then
			return true
		elseif arg0_31:getConfig("type") == 16 and arg0_31:getConfig("sub_type") == 122 then
			return true
		end
	end

	return false
end

function var0_0.isDaily(arg0_32)
	return arg0_32:getConfig("sub_type") == 415 or arg0_32:getConfig("sub_type") == 412
end

function var0_0.getTaskStatus(arg0_33)
	if arg0_33:isLock() then
		return -1
	end

	if arg0_33:isReceive() then
		return 2
	end

	if arg0_33:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_34)
	local function var0_34()
		if arg0_34:getConfig("sub_type") == 29 then
			local var0_35 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_35, function(arg0_36)
				return arg0_36:getConfig("task_id") == arg0_34.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_34
			})
		elseif arg0_34:getConfig("added_tip") > 0 then
			local var1_35

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_35()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_34:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_forward",
				noText = "text_iknow",
				content = i18n("tip_add_task", arg0_34:getConfig("name")),
				onYes = var1_35
			})
		end

		if arg0_34:IsCommanderManualType() then
			getProxy(CommanderManualProxy):AddPageTaskDone(arg0_34)
		end
	end

	local function var1_34()
		local var0_38 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_38.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_34 = arg0_34:getConfig("story_id")

	if var2_34 and var2_34 ~= "" and var1_34() then
		pg.NewStoryMgr.GetInstance():Play(var2_34, var0_34, true, true)
	else
		var0_34()
	end
end

function var0_0.updateProgress(arg0_39, arg1_39)
	arg0_39.progress = arg1_39
end

function var0_0.isSelectable(arg0_40)
	local var0_40 = arg0_40:getConfig("award_choice")

	return var0_40 ~= nil and type(var0_40) == "table" and #var0_40 > 0
end

function var0_0.judgeOverflow(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41 = arg0_41:getTaskStatus() == 1
	local var1_41 = arg0_41:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_41, arg2_41, arg3_41, var0_41, var1_41, arg0_41:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42, arg5_42)
	if arg3_42 and arg4_42 then
		local var0_42 = getProxy(PlayerProxy):getData()
		local var1_42 = pg.gameset.urpt_chapter_max.description[1]
		local var2_42 = arg0_42 or var0_42.gold
		local var3_42 = arg1_42 or var0_42.oil
		local var4_42 = arg2_42 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_42) or 0
		local var5_42 = pg.gameset.max_gold.key_value
		local var6_42 = pg.gameset.max_oil.key_value
		local var7_42 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_42 = false
		local var9_42 = false
		local var10_42 = false
		local var11_42 = false
		local var12_42 = false
		local var13_42 = {}
		local var14_42 = arg5_42

		for iter0_42, iter1_42 in ipairs(var14_42) do
			local var15_42, var16_42, var17_42 = unpack(iter1_42)

			if var15_42 == DROP_TYPE_RESOURCE then
				if var16_42 == PlayerConst.ResGold then
					local var18_42 = var2_42 + var17_42 - var5_42

					if var18_42 > 0 then
						var8_42 = true

						local var19_42 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_42, COLOR_RED)
						}

						table.insert(var13_42, var19_42)
					end
				elseif var16_42 == PlayerConst.ResOil then
					local var20_42 = var3_42 + var17_42 - var6_42

					if var20_42 > 0 then
						var9_42 = true

						local var21_42 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_42, COLOR_RED)
						}

						table.insert(var13_42, var21_42)
					end
				end
			elseif not LOCK_UR_SHIP and var15_42 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_42).virtual_type == 20 then
					local var22_42 = var4_42 + var17_42 - var7_42

					if var22_42 > 0 then
						var10_42 = true

						local var23_42 = {
							type = DROP_TYPE_VITEM,
							id = var1_42,
							count = setColorStr(var22_42, COLOR_RED)
						}

						table.insert(var13_42, var23_42)
					end
				end
			elseif var15_42 == DROP_TYPE_ITEM and Item.getConfigData(var16_42).type == Item.EXP_BOOK_TYPE then
				local var24_42 = getProxy(BagProxy):getItemCountById(var16_42) + var17_42
				local var25_42 = Item.getConfigData(var16_42).max_num

				if var25_42 < var24_42 then
					var11_42 = true

					local var26_42 = {
						type = DROP_TYPE_ITEM,
						id = var16_42,
						count = setColorStr(math.min(var17_42, var24_42 - var25_42), COLOR_RED)
					}

					table.insert(var13_42, var26_42)
				end
			end
		end

		return var8_42 or var9_42 or var10_42 or var11_42, var13_42
	end
end

function var0_0.IsUrTask(arg0_43)
	if not LOCK_UR_SHIP then
		local var0_43 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_43:getConfig("award_display"), function(arg0_44)
			return arg0_44[1] == DROP_TYPE_ITEM and arg0_44[2] == var0_43
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_45)
	local var0_45 = arg0_45:getConfig("priority_type")

	if var0_45 == 0 then
		var0_45 = arg0_45:getConfig("type")
	end

	return var0_45
end

function var0_0.IsOverflowShipExpItem(arg0_46)
	local function var0_46(arg0_47, arg1_47)
		return getProxy(BagProxy):getItemCountById(arg0_47) + arg1_47 > Item.getConfigData(arg0_47).max_num
	end

	local var1_46 = arg0_46:getConfig("award_display")

	for iter0_46, iter1_46 in ipairs(var1_46) do
		local var2_46 = iter1_46[1]
		local var3_46 = iter1_46[2]
		local var4_46 = iter1_46[3]

		if var2_46 == DROP_TYPE_ITEM and Item.getConfigData(var3_46).type == Item.EXP_BOOK_TYPE and var0_46(var3_46, var4_46) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_48)
	local var0_48 = arg0_48:getConfig("visibility") == 1

	if arg0_48.id == 17268 then
		var0_48 = false

		local var1_48 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_48 and not var1_48:isEnd() then
			local var2_48 = var1_48.data1KeyValueList[2][17] or 1
			local var3_48 = var1_48.data1KeyValueList[2][18] or 1

			var0_48 = var2_48 >= 4 and var3_48 >= 4
		end
	end

	return var0_48
end

function var0_0.setTaskFinish(arg0_49)
	arg0_49.submitTime = 1

	arg0_49:updateProgress(arg0_49:getConfig("target_num"))
end

function var0_0.isAvatarTask(arg0_50)
	return false
end

function var0_0.getActId(arg0_51)
	return arg0_51._actId
end

function var0_0.setActId(arg0_52, arg1_52)
	arg0_52._actId = arg1_52
end

function var0_0.isActivityTask(arg0_53)
	return arg0_53._actId and arg0_53._actId > 0
end

function var0_0.setAutoSubmit(arg0_54, arg1_54)
	arg0_54._autoSubmit = arg1_54
end

function var0_0.getAutoSubmit(arg0_55)
	return arg0_55._autoSubmit
end

function var0_0.getGiveDrops(arg0_56)
	local var0_56 = {}

	if arg0_56:getConfig("sub_type") == TASK_SUB_TYPE_VITEMS then
		local var1_56 = tonumber(arg0_56:getConfig("target_id"))

		for iter0_56, iter1_56 in ipairs(arg0_56:getConfig("target_id_2")) do
			table.insert(var0_56, Drop.New({
				type = var1_56,
				id = iter1_56[1],
				count = iter1_56[2]
			}))
		end
	end

	return var0_56
end

return var0_0
