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

function var0_0.isLock(arg0_12)
	return getProxy(PlayerProxy):getRawData().level < arg0_12:getConfig("level")
end

function var0_0.isFinish(arg0_13)
	return arg0_13:getProgress() >= arg0_13:getConfig("target_num")
end

function var0_0.getProgress(arg0_14)
	local var0_14 = arg0_14.progress

	if arg0_14:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
		local var1_14 = tonumber(arg0_14:getConfig("target_id"))

		var0_14 = getProxy(BagProxy):getItemCountById(tonumber(var1_14))
	elseif arg0_14:getConfig("sub_type") == TASK_SUB_TYPE_PT then
		local var2_14 = getProxy(ActivityProxy):getActivityById(tonumber(arg0_14:getConfig("target_id_2")))

		var0_14 = var2_14 and var2_14.data1 or 0
	elseif arg0_14:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
		local var3_14 = tonumber(arg0_14:getConfig("target_id"))

		var0_14 = getProxy(PlayerProxy):getData():getResById(var3_14)
	elseif arg0_14:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
		local var4_14 = tonumber(arg0_14:getConfig("target_id"))

		var0_14 = getProxy(ActivityProxy):getVirtualItemNumber(var4_14)
	elseif arg0_14:getConfig("sub_type") == TASK_SUB_TYPE_BOSS_PT then
		local var5_14 = tonumber(arg0_14:getConfig("target_id"))

		var0_14 = getProxy(PlayerProxy):getData():getResById(var5_14)
	elseif arg0_14:getConfig("sub_type") == TASK_SUB_STROY then
		local var6_14 = arg0_14:getConfig("target_id")
		local var7_14 = 0

		_.each(var6_14, function(arg0_15)
			if pg.NewStoryMgr.GetInstance():GetPlayedFlag(arg0_15) then
				var7_14 = var7_14 + 1
			end
		end)

		var0_14 = var7_14
	elseif arg0_14:getConfig("sub_type") == TASK_SUB_TYPE_TECHNOLOGY_POINT then
		var0_14 = getProxy(TechnologyNationProxy):getNationPoint(tonumber(arg0_14:getConfig("target_id")))
		var0_14 = math.min(var0_14, arg0_14:getConfig("target_num"))
	elseif arg0_14:getConfig("sub_type") == TASK_SUB_TYPE_VITEM then
		local var8_14 = tonumber(arg0_14:getConfig("target_id"))
		local var9_14 = tonumber(arg0_14:getConfig("target_id_2"))
		local var10_14 = pg.activity_drop_type[var8_14].activity_id
		local var11_14 = getProxy(ActivityProxy):getActivityById(var10_14)

		if var11_14 then
			var0_14 = var11_14:getVitemNumber(var9_14)
		end
	end

	return var0_14 or 0
end

function var0_0.getTargetNumber(arg0_16)
	return arg0_16:getConfig("target_num")
end

function var0_0.isReceive(arg0_17)
	return arg0_17.submitTime > 0
end

function var0_0.isCircle(arg0_18)
	if arg0_18:isActivityTask() then
		if arg0_18:getConfig("type") == 16 and arg0_18:getConfig("sub_type") == 1006 then
			return true
		elseif arg0_18:getConfig("type") == 16 and arg0_18:getConfig("sub_type") == 20 then
			return true
		end
	end

	return false
end

function var0_0.isDaily(arg0_19)
	return arg0_19:getConfig("sub_type") == 415 or arg0_19:getConfig("sub_type") == 412
end

function var0_0.getTaskStatus(arg0_20)
	if arg0_20:isLock() then
		return -1
	end

	if arg0_20:isReceive() then
		return 2
	end

	if arg0_20:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_21)
	local function var0_21()
		if arg0_21:getConfig("sub_type") == 29 then
			local var0_22 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_22, function(arg0_23)
				return arg0_23:getConfig("task_id") == arg0_21.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_21
			})
		elseif arg0_21:getConfig("added_tip") > 0 then
			local var1_22

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_22()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_21:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				noText = "text_iknow",
				yesText = "text_forward",
				content = i18n("tip_add_task", arg0_21:getConfig("name")),
				onYes = var1_22,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end

	local function var1_21()
		local var0_25 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_25.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_21 = arg0_21:getConfig("story_id")

	if var2_21 and var2_21 ~= "" and var1_21() then
		pg.NewStoryMgr.GetInstance():Play(var2_21, var0_21, true, true)
	else
		var0_21()
	end
end

function var0_0.updateProgress(arg0_26, arg1_26)
	arg0_26.progress = arg1_26
end

function var0_0.isSelectable(arg0_27)
	local var0_27 = arg0_27:getConfig("award_choice")

	return var0_27 ~= nil and type(var0_27) == "table" and #var0_27 > 0
end

function var0_0.judgeOverflow(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = arg0_28:getTaskStatus() == 1
	local var1_28 = arg0_28:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_28, arg2_28, arg3_28, var0_28, var1_28, arg0_28:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29, arg5_29)
	if arg3_29 and arg4_29 then
		local var0_29 = getProxy(PlayerProxy):getData()
		local var1_29 = pg.gameset.urpt_chapter_max.description[1]
		local var2_29 = arg0_29 or var0_29.gold
		local var3_29 = arg1_29 or var0_29.oil
		local var4_29 = arg2_29 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_29) or 0
		local var5_29 = pg.gameset.max_gold.key_value
		local var6_29 = pg.gameset.max_oil.key_value
		local var7_29 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_29 = false
		local var9_29 = false
		local var10_29 = false
		local var11_29 = false
		local var12_29 = false
		local var13_29 = {}
		local var14_29 = arg5_29

		for iter0_29, iter1_29 in ipairs(var14_29) do
			local var15_29, var16_29, var17_29 = unpack(iter1_29)

			if var15_29 == DROP_TYPE_RESOURCE then
				if var16_29 == PlayerConst.ResGold then
					local var18_29 = var2_29 + var17_29 - var5_29

					if var18_29 > 0 then
						var8_29 = true

						local var19_29 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_29, COLOR_RED)
						}

						table.insert(var13_29, var19_29)
					end
				elseif var16_29 == PlayerConst.ResOil then
					local var20_29 = var3_29 + var17_29 - var6_29

					if var20_29 > 0 then
						var9_29 = true

						local var21_29 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_29, COLOR_RED)
						}

						table.insert(var13_29, var21_29)
					end
				end
			elseif not LOCK_UR_SHIP and var15_29 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_29).virtual_type == 20 then
					local var22_29 = var4_29 + var17_29 - var7_29

					if var22_29 > 0 then
						var10_29 = true

						local var23_29 = {
							type = DROP_TYPE_VITEM,
							id = var1_29,
							count = setColorStr(var22_29, COLOR_RED)
						}

						table.insert(var13_29, var23_29)
					end
				end
			elseif var15_29 == DROP_TYPE_ITEM and Item.getConfigData(var16_29).type == Item.EXP_BOOK_TYPE then
				local var24_29 = getProxy(BagProxy):getItemCountById(var16_29) + var17_29
				local var25_29 = Item.getConfigData(var16_29).max_num

				if var25_29 < var24_29 then
					var11_29 = true

					local var26_29 = {
						type = DROP_TYPE_ITEM,
						id = var16_29,
						count = setColorStr(math.min(var17_29, var24_29 - var25_29), COLOR_RED)
					}

					table.insert(var13_29, var26_29)
				end
			end
		end

		return var8_29 or var9_29 or var10_29 or var11_29, var13_29
	end
end

function var0_0.IsUrTask(arg0_30)
	if not LOCK_UR_SHIP then
		local var0_30 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_30:getConfig("award_display"), function(arg0_31)
			return arg0_31[1] == DROP_TYPE_ITEM and arg0_31[2] == var0_30
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_32)
	local var0_32 = arg0_32:getConfig("priority_type")

	if var0_32 == 0 then
		var0_32 = arg0_32:getConfig("type")
	end

	return var0_32
end

function var0_0.IsOverflowShipExpItem(arg0_33)
	local function var0_33(arg0_34, arg1_34)
		return getProxy(BagProxy):getItemCountById(arg0_34) + arg1_34 > Item.getConfigData(arg0_34).max_num
	end

	local var1_33 = arg0_33:getConfig("award_display")

	for iter0_33, iter1_33 in ipairs(var1_33) do
		local var2_33 = iter1_33[1]
		local var3_33 = iter1_33[2]
		local var4_33 = iter1_33[3]

		if var2_33 == DROP_TYPE_ITEM and Item.getConfigData(var3_33).type == Item.EXP_BOOK_TYPE and var0_33(var3_33, var4_33) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_35)
	local var0_35 = arg0_35:getConfig("visibility") == 1

	if arg0_35.id == 17268 then
		var0_35 = false

		local var1_35 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_35 and not var1_35:isEnd() then
			local var2_35 = var1_35.data1KeyValueList[2][17] or 1
			local var3_35 = var1_35.data1KeyValueList[2][18] or 1

			var0_35 = var2_35 >= 4 and var3_35 >= 4
		end
	end

	return var0_35
end

function var0_0.setTaskFinish(arg0_36)
	arg0_36.submitTime = 1

	arg0_36:updateProgress(arg0_36:getConfig("target_num"))
end

function var0_0.isAvatarTask(arg0_37)
	return false
end

function var0_0.getActId(arg0_38)
	return arg0_38._actId
end

function var0_0.setActId(arg0_39, arg1_39)
	arg0_39._actId = arg1_39
end

function var0_0.isActivityTask(arg0_40)
	return arg0_40._actId and arg0_40._actId > 0
end

function var0_0.setAutoSubmit(arg0_41, arg1_41)
	arg0_41._autoSubmit = arg1_41
end

function var0_0.getAutoSubmit(arg0_42)
	return arg0_42._autoSubmit
end

return var0_0
