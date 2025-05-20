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
	local var0_15 = arg0_15.progress

	if arg0_15:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
		local var1_15 = tonumber(arg0_15:getConfig("target_id"))

		var0_15 = getProxy(BagProxy):getItemCountById(tonumber(var1_15))
	elseif arg0_15:getConfig("sub_type") == TASK_SUB_TYPE_PT then
		local var2_15 = getProxy(ActivityProxy):getActivityById(tonumber(arg0_15:getConfig("target_id_2")))

		var0_15 = var2_15 and var2_15.data1 or 0
	elseif arg0_15:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
		local var3_15 = tonumber(arg0_15:getConfig("target_id"))

		var0_15 = getProxy(PlayerProxy):getData():getResById(var3_15)
	elseif arg0_15:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
		local var4_15 = tonumber(arg0_15:getConfig("target_id"))

		var0_15 = getProxy(ActivityProxy):getVirtualItemNumber(var4_15)
	elseif arg0_15:getConfig("sub_type") == TASK_SUB_TYPE_BOSS_PT then
		local var5_15 = tonumber(arg0_15:getConfig("target_id"))

		var0_15 = getProxy(PlayerProxy):getData():getResById(var5_15)
	elseif arg0_15:getConfig("sub_type") == TASK_SUB_STROY then
		local var6_15 = arg0_15:getConfig("target_id")
		local var7_15 = 0

		_.each(var6_15, function(arg0_16)
			if pg.NewStoryMgr.GetInstance():GetPlayedFlag(arg0_16) then
				var7_15 = var7_15 + 1
			end
		end)

		var0_15 = var7_15
	elseif arg0_15:getConfig("sub_type") == TASK_SUB_TYPE_TECHNOLOGY_POINT then
		var0_15 = getProxy(TechnologyNationProxy):getNationPoint(tonumber(arg0_15:getConfig("target_id")))
		var0_15 = math.min(var0_15, arg0_15:getConfig("target_num"))
	elseif arg0_15:getConfig("sub_type") == TASK_SUB_TYPE_VITEM then
		local var8_15 = tonumber(arg0_15:getConfig("target_id"))
		local var9_15 = tonumber(arg0_15:getConfig("target_id_2"))
		local var10_15 = pg.activity_drop_type[var8_15].activity_id
		local var11_15 = getProxy(ActivityProxy):getActivityById(var10_15)

		if var11_15 then
			var0_15 = var11_15:getVitemNumber(var9_15)
		end
	end

	return var0_15 or 0
end

function var0_0.getTargetNumber(arg0_17)
	return arg0_17:getConfig("target_num")
end

function var0_0.isReceive(arg0_18)
	return arg0_18.submitTime > 0
end

function var0_0.isCircle(arg0_19)
	if arg0_19:isActivityTask() then
		if arg0_19:getConfig("type") == 16 and arg0_19:getConfig("sub_type") == 1006 then
			return true
		elseif arg0_19:getConfig("type") == 16 and arg0_19:getConfig("sub_type") == 20 then
			return true
		elseif arg0_19:getConfig("type") == 16 and arg0_19:getConfig("sub_type") == 1007 then
			return true
		elseif arg0_19:getConfig("type") == 16 and arg0_19:getConfig("sub_type") == 122 then
			return true
		end
	end

	return false
end

function var0_0.isDaily(arg0_20)
	return arg0_20:getConfig("sub_type") == 415 or arg0_20:getConfig("sub_type") == 412
end

function var0_0.getTaskStatus(arg0_21)
	if arg0_21:isLock() then
		return -1
	end

	if arg0_21:isReceive() then
		return 2
	end

	if arg0_21:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_22)
	local function var0_22()
		if arg0_22:getConfig("sub_type") == 29 then
			local var0_23 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_23, function(arg0_24)
				return arg0_24:getConfig("task_id") == arg0_22.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_22
			})
		elseif arg0_22:getConfig("added_tip") > 0 then
			local var1_23

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_23()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_22:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				noText = "text_iknow",
				yesText = "text_forward",
				content = i18n("tip_add_task", arg0_22:getConfig("name")),
				onYes = var1_23,
				weight = LayerWeightConst.TOP_LAYER
			})
		end

		if arg0_22:IsCommanderManualType() then
			getProxy(CommanderManualProxy):AddPageTaskDone(arg0_22)
		end
	end

	local function var1_22()
		local var0_26 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_26.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_22 = arg0_22:getConfig("story_id")

	if var2_22 and var2_22 ~= "" and var1_22() then
		pg.NewStoryMgr.GetInstance():Play(var2_22, var0_22, true, true)
	else
		var0_22()
	end
end

function var0_0.updateProgress(arg0_27, arg1_27)
	arg0_27.progress = arg1_27
end

function var0_0.isSelectable(arg0_28)
	local var0_28 = arg0_28:getConfig("award_choice")

	return var0_28 ~= nil and type(var0_28) == "table" and #var0_28 > 0
end

function var0_0.judgeOverflow(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg0_29:getTaskStatus() == 1
	local var1_29 = arg0_29:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_29, arg2_29, arg3_29, var0_29, var1_29, arg0_29:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30, arg5_30)
	if arg3_30 and arg4_30 then
		local var0_30 = getProxy(PlayerProxy):getData()
		local var1_30 = pg.gameset.urpt_chapter_max.description[1]
		local var2_30 = arg0_30 or var0_30.gold
		local var3_30 = arg1_30 or var0_30.oil
		local var4_30 = arg2_30 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_30) or 0
		local var5_30 = pg.gameset.max_gold.key_value
		local var6_30 = pg.gameset.max_oil.key_value
		local var7_30 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_30 = false
		local var9_30 = false
		local var10_30 = false
		local var11_30 = false
		local var12_30 = false
		local var13_30 = {}
		local var14_30 = arg5_30

		for iter0_30, iter1_30 in ipairs(var14_30) do
			local var15_30, var16_30, var17_30 = unpack(iter1_30)

			if var15_30 == DROP_TYPE_RESOURCE then
				if var16_30 == PlayerConst.ResGold then
					local var18_30 = var2_30 + var17_30 - var5_30

					if var18_30 > 0 then
						var8_30 = true

						local var19_30 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_30, COLOR_RED)
						}

						table.insert(var13_30, var19_30)
					end
				elseif var16_30 == PlayerConst.ResOil then
					local var20_30 = var3_30 + var17_30 - var6_30

					if var20_30 > 0 then
						var9_30 = true

						local var21_30 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_30, COLOR_RED)
						}

						table.insert(var13_30, var21_30)
					end
				end
			elseif not LOCK_UR_SHIP and var15_30 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_30).virtual_type == 20 then
					local var22_30 = var4_30 + var17_30 - var7_30

					if var22_30 > 0 then
						var10_30 = true

						local var23_30 = {
							type = DROP_TYPE_VITEM,
							id = var1_30,
							count = setColorStr(var22_30, COLOR_RED)
						}

						table.insert(var13_30, var23_30)
					end
				end
			elseif var15_30 == DROP_TYPE_ITEM and Item.getConfigData(var16_30).type == Item.EXP_BOOK_TYPE then
				local var24_30 = getProxy(BagProxy):getItemCountById(var16_30) + var17_30
				local var25_30 = Item.getConfigData(var16_30).max_num

				if var25_30 < var24_30 then
					var11_30 = true

					local var26_30 = {
						type = DROP_TYPE_ITEM,
						id = var16_30,
						count = setColorStr(math.min(var17_30, var24_30 - var25_30), COLOR_RED)
					}

					table.insert(var13_30, var26_30)
				end
			end
		end

		return var8_30 or var9_30 or var10_30 or var11_30, var13_30
	end
end

function var0_0.IsUrTask(arg0_31)
	if not LOCK_UR_SHIP then
		local var0_31 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_31:getConfig("award_display"), function(arg0_32)
			return arg0_32[1] == DROP_TYPE_ITEM and arg0_32[2] == var0_31
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_33)
	local var0_33 = arg0_33:getConfig("priority_type")

	if var0_33 == 0 then
		var0_33 = arg0_33:getConfig("type")
	end

	return var0_33
end

function var0_0.IsOverflowShipExpItem(arg0_34)
	local function var0_34(arg0_35, arg1_35)
		return getProxy(BagProxy):getItemCountById(arg0_35) + arg1_35 > Item.getConfigData(arg0_35).max_num
	end

	local var1_34 = arg0_34:getConfig("award_display")

	for iter0_34, iter1_34 in ipairs(var1_34) do
		local var2_34 = iter1_34[1]
		local var3_34 = iter1_34[2]
		local var4_34 = iter1_34[3]

		if var2_34 == DROP_TYPE_ITEM and Item.getConfigData(var3_34).type == Item.EXP_BOOK_TYPE and var0_34(var3_34, var4_34) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_36)
	local var0_36 = arg0_36:getConfig("visibility") == 1

	if arg0_36.id == 17268 then
		var0_36 = false

		local var1_36 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_36 and not var1_36:isEnd() then
			local var2_36 = var1_36.data1KeyValueList[2][17] or 1
			local var3_36 = var1_36.data1KeyValueList[2][18] or 1

			var0_36 = var2_36 >= 4 and var3_36 >= 4
		end
	end

	return var0_36
end

function var0_0.setTaskFinish(arg0_37)
	arg0_37.submitTime = 1

	arg0_37:updateProgress(arg0_37:getConfig("target_num"))
end

function var0_0.isAvatarTask(arg0_38)
	return false
end

function var0_0.getActId(arg0_39)
	return arg0_39._actId
end

function var0_0.setActId(arg0_40, arg1_40)
	arg0_40._actId = arg1_40
end

function var0_0.isActivityTask(arg0_41)
	return arg0_41._actId and arg0_41._actId > 0
end

function var0_0.setAutoSubmit(arg0_42, arg1_42)
	arg0_42._autoSubmit = arg1_42
end

function var0_0.getAutoSubmit(arg0_43)
	return arg0_43._autoSubmit
end

return var0_0
