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
		end
	}, function()
		return arg0_15.progress
	end) or 0
end

function var0_0.getTargetNumber(arg0_28)
	return arg0_28:getConfig("target_num")
end

function var0_0.isReceive(arg0_29)
	return arg0_29.submitTime > 0
end

function var0_0.isCircle(arg0_30)
	if arg0_30:isActivityTask() then
		if arg0_30:getConfig("type") == 16 and arg0_30:getConfig("sub_type") == 1006 then
			return true
		elseif arg0_30:getConfig("type") == 16 and arg0_30:getConfig("sub_type") == 20 then
			return true
		elseif arg0_30:getConfig("type") == 16 and arg0_30:getConfig("sub_type") == 1007 then
			return true
		elseif arg0_30:getConfig("type") == 16 and arg0_30:getConfig("sub_type") == 122 then
			return true
		end
	end

	return false
end

function var0_0.isDaily(arg0_31)
	return arg0_31:getConfig("sub_type") == 415 or arg0_31:getConfig("sub_type") == 412
end

function var0_0.getTaskStatus(arg0_32)
	if arg0_32:isLock() then
		return -1
	end

	if arg0_32:isReceive() then
		return 2
	end

	if arg0_32:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_33)
	local function var0_33()
		if arg0_33:getConfig("sub_type") == 29 then
			local var0_34 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_34, function(arg0_35)
				return arg0_35:getConfig("task_id") == arg0_33.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_33
			})
		elseif arg0_33:getConfig("added_tip") > 0 then
			local var1_34

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_34()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_33:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				noText = "text_iknow",
				yesText = "text_forward",
				content = i18n("tip_add_task", arg0_33:getConfig("name")),
				onYes = var1_34,
				weight = LayerWeightConst.TOP_LAYER
			})
		end

		if arg0_33:IsCommanderManualType() then
			getProxy(CommanderManualProxy):AddPageTaskDone(arg0_33)
		end
	end

	local function var1_33()
		local var0_37 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_37.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_33 = arg0_33:getConfig("story_id")

	if var2_33 and var2_33 ~= "" and var1_33() then
		pg.NewStoryMgr.GetInstance():Play(var2_33, var0_33, true, true)
	else
		var0_33()
	end
end

function var0_0.updateProgress(arg0_38, arg1_38)
	arg0_38.progress = arg1_38
end

function var0_0.isSelectable(arg0_39)
	local var0_39 = arg0_39:getConfig("award_choice")

	return var0_39 ~= nil and type(var0_39) == "table" and #var0_39 > 0
end

function var0_0.judgeOverflow(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = arg0_40:getTaskStatus() == 1
	local var1_40 = arg0_40:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_40, arg2_40, arg3_40, var0_40, var1_40, arg0_40:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41, arg5_41)
	if arg3_41 and arg4_41 then
		local var0_41 = getProxy(PlayerProxy):getData()
		local var1_41 = pg.gameset.urpt_chapter_max.description[1]
		local var2_41 = arg0_41 or var0_41.gold
		local var3_41 = arg1_41 or var0_41.oil
		local var4_41 = arg2_41 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_41) or 0
		local var5_41 = pg.gameset.max_gold.key_value
		local var6_41 = pg.gameset.max_oil.key_value
		local var7_41 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_41 = false
		local var9_41 = false
		local var10_41 = false
		local var11_41 = false
		local var12_41 = false
		local var13_41 = {}
		local var14_41 = arg5_41

		for iter0_41, iter1_41 in ipairs(var14_41) do
			local var15_41, var16_41, var17_41 = unpack(iter1_41)

			if var15_41 == DROP_TYPE_RESOURCE then
				if var16_41 == PlayerConst.ResGold then
					local var18_41 = var2_41 + var17_41 - var5_41

					if var18_41 > 0 then
						var8_41 = true

						local var19_41 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_41, COLOR_RED)
						}

						table.insert(var13_41, var19_41)
					end
				elseif var16_41 == PlayerConst.ResOil then
					local var20_41 = var3_41 + var17_41 - var6_41

					if var20_41 > 0 then
						var9_41 = true

						local var21_41 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_41, COLOR_RED)
						}

						table.insert(var13_41, var21_41)
					end
				end
			elseif not LOCK_UR_SHIP and var15_41 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_41).virtual_type == 20 then
					local var22_41 = var4_41 + var17_41 - var7_41

					if var22_41 > 0 then
						var10_41 = true

						local var23_41 = {
							type = DROP_TYPE_VITEM,
							id = var1_41,
							count = setColorStr(var22_41, COLOR_RED)
						}

						table.insert(var13_41, var23_41)
					end
				end
			elseif var15_41 == DROP_TYPE_ITEM and Item.getConfigData(var16_41).type == Item.EXP_BOOK_TYPE then
				local var24_41 = getProxy(BagProxy):getItemCountById(var16_41) + var17_41
				local var25_41 = Item.getConfigData(var16_41).max_num

				if var25_41 < var24_41 then
					var11_41 = true

					local var26_41 = {
						type = DROP_TYPE_ITEM,
						id = var16_41,
						count = setColorStr(math.min(var17_41, var24_41 - var25_41), COLOR_RED)
					}

					table.insert(var13_41, var26_41)
				end
			end
		end

		return var8_41 or var9_41 or var10_41 or var11_41, var13_41
	end
end

function var0_0.IsUrTask(arg0_42)
	if not LOCK_UR_SHIP then
		local var0_42 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_42:getConfig("award_display"), function(arg0_43)
			return arg0_43[1] == DROP_TYPE_ITEM and arg0_43[2] == var0_42
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_44)
	local var0_44 = arg0_44:getConfig("priority_type")

	if var0_44 == 0 then
		var0_44 = arg0_44:getConfig("type")
	end

	return var0_44
end

function var0_0.IsOverflowShipExpItem(arg0_45)
	local function var0_45(arg0_46, arg1_46)
		return getProxy(BagProxy):getItemCountById(arg0_46) + arg1_46 > Item.getConfigData(arg0_46).max_num
	end

	local var1_45 = arg0_45:getConfig("award_display")

	for iter0_45, iter1_45 in ipairs(var1_45) do
		local var2_45 = iter1_45[1]
		local var3_45 = iter1_45[2]
		local var4_45 = iter1_45[3]

		if var2_45 == DROP_TYPE_ITEM and Item.getConfigData(var3_45).type == Item.EXP_BOOK_TYPE and var0_45(var3_45, var4_45) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_47)
	local var0_47 = arg0_47:getConfig("visibility") == 1

	if arg0_47.id == 17268 then
		var0_47 = false

		local var1_47 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_47 and not var1_47:isEnd() then
			local var2_47 = var1_47.data1KeyValueList[2][17] or 1
			local var3_47 = var1_47.data1KeyValueList[2][18] or 1

			var0_47 = var2_47 >= 4 and var3_47 >= 4
		end
	end

	return var0_47
end

function var0_0.setTaskFinish(arg0_48)
	arg0_48.submitTime = 1

	arg0_48:updateProgress(arg0_48:getConfig("target_num"))
end

function var0_0.isAvatarTask(arg0_49)
	return false
end

function var0_0.getActId(arg0_50)
	return arg0_50._actId
end

function var0_0.setActId(arg0_51, arg1_51)
	arg0_51._actId = arg1_51
end

function var0_0.isActivityTask(arg0_52)
	return arg0_52._actId and arg0_52._actId > 0
end

function var0_0.setAutoSubmit(arg0_53, arg1_53)
	arg0_53._autoSubmit = arg1_53
end

function var0_0.getAutoSubmit(arg0_54)
	return arg0_54._autoSubmit
end

function var0_0.getGiveDrops(arg0_55)
	local var0_55 = {}

	if arg0_55:getConfig("sub_type") == TASK_SUB_TYPE_VITEMS then
		local var1_55 = tonumber(arg0_55:getConfig("target_id"))

		for iter0_55, iter1_55 in ipairs(arg0_55:getConfig("target_id_2")) do
			table.insert(var0_55, Drop.New({
				type = var1_55,
				id = iter1_55[1],
				count = iter1_55[2]
			}))
		end
	end

	return var0_55
end

return var0_0
