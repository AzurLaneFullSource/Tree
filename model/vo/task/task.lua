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
	end

	return var0_14 or 0
end

function var0_0.getTargetNumber(arg0_16)
	return arg0_16:getConfig("target_num")
end

function var0_0.isReceive(arg0_17)
	return arg0_17.submitTime > 0
end

function var0_0.getTaskStatus(arg0_18)
	if arg0_18:isLock() then
		return -1
	end

	if arg0_18:isReceive() then
		return 2
	end

	if arg0_18:isFinish() then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_19)
	local function var0_19()
		if arg0_19:getConfig("sub_type") == 29 then
			local var0_20 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0_20, function(arg0_21)
				return arg0_21:getConfig("task_id") == arg0_19.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0_19
			})
		elseif arg0_19:getConfig("added_tip") > 0 then
			local var1_20

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1_20()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1_0[arg0_19:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				noText = "text_iknow",
				yesText = "text_forward",
				content = i18n("tip_add_task", arg0_19:getConfig("name")),
				onYes = var1_20,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end

	local function var1_19()
		local var0_23 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0_23.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2_19 = arg0_19:getConfig("story_id")

	if var2_19 and var2_19 ~= "" and var1_19() then
		pg.NewStoryMgr.GetInstance():Play(var2_19, var0_19, true, true)
	else
		var0_19()
	end
end

function var0_0.updateProgress(arg0_24, arg1_24)
	arg0_24.progress = arg1_24
end

function var0_0.isSelectable(arg0_25)
	local var0_25 = arg0_25:getConfig("award_choice")

	return var0_25 ~= nil and type(var0_25) == "table" and #var0_25 > 0
end

function var0_0.judgeOverflow(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg0_26:getTaskStatus() == 1
	local var1_26 = arg0_26:ShowOnTaskScene()

	return var0_0.StaticJudgeOverflow(arg1_26, arg2_26, arg3_26, var0_26, var1_26, arg0_26:getConfig("award_display"))
end

function var0_0.StaticJudgeOverflow(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27)
	if arg3_27 and arg4_27 then
		local var0_27 = getProxy(PlayerProxy):getData()
		local var1_27 = pg.gameset.urpt_chapter_max.description[1]
		local var2_27 = arg0_27 or var0_27.gold
		local var3_27 = arg1_27 or var0_27.oil
		local var4_27 = arg2_27 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1_27) or 0
		local var5_27 = pg.gameset.max_gold.key_value
		local var6_27 = pg.gameset.max_oil.key_value
		local var7_27 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8_27 = false
		local var9_27 = false
		local var10_27 = false
		local var11_27 = false
		local var12_27 = false
		local var13_27 = {}
		local var14_27 = arg5_27

		for iter0_27, iter1_27 in ipairs(var14_27) do
			local var15_27, var16_27, var17_27 = unpack(iter1_27)

			if var15_27 == DROP_TYPE_RESOURCE then
				if var16_27 == PlayerConst.ResGold then
					local var18_27 = var2_27 + var17_27 - var5_27

					if var18_27 > 0 then
						var8_27 = true

						local var19_27 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18_27, COLOR_RED)
						}

						table.insert(var13_27, var19_27)
					end
				elseif var16_27 == PlayerConst.ResOil then
					local var20_27 = var3_27 + var17_27 - var6_27

					if var20_27 > 0 then
						var9_27 = true

						local var21_27 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20_27, COLOR_RED)
						}

						table.insert(var13_27, var21_27)
					end
				end
			elseif not LOCK_UR_SHIP and var15_27 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16_27).virtual_type == 20 then
					local var22_27 = var4_27 + var17_27 - var7_27

					if var22_27 > 0 then
						var10_27 = true

						local var23_27 = {
							type = DROP_TYPE_VITEM,
							id = var1_27,
							count = setColorStr(var22_27, COLOR_RED)
						}

						table.insert(var13_27, var23_27)
					end
				end
			elseif var15_27 == DROP_TYPE_ITEM and Item.getConfigData(var16_27).type == Item.EXP_BOOK_TYPE then
				local var24_27 = getProxy(BagProxy):getItemCountById(var16_27) + var17_27
				local var25_27 = Item.getConfigData(var16_27).max_num

				if var25_27 < var24_27 then
					var11_27 = true

					local var26_27 = {
						type = DROP_TYPE_ITEM,
						id = var16_27,
						count = setColorStr(math.min(var17_27, var24_27 - var25_27), COLOR_RED)
					}

					table.insert(var13_27, var26_27)
				end
			end
		end

		return var8_27 or var9_27 or var10_27 or var11_27, var13_27
	end
end

function var0_0.IsUrTask(arg0_28)
	if not LOCK_UR_SHIP then
		local var0_28 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0_28:getConfig("award_display"), function(arg0_29)
			return arg0_29[1] == DROP_TYPE_ITEM and arg0_29[2] == var0_28
		end) end
		return
	end

	return false
end

function var0_0.GetRealType(arg0_30)
	local var0_30 = arg0_30:getConfig("priority_type")

	if var0_30 == 0 then
		var0_30 = arg0_30:getConfig("type")
	end

	return var0_30
end

function var0_0.IsOverflowShipExpItem(arg0_31)
	local function var0_31(arg0_32, arg1_32)
		return getProxy(BagProxy):getItemCountById(arg0_32) + arg1_32 > Item.getConfigData(arg0_32).max_num
	end

	local var1_31 = arg0_31:getConfig("award_display")

	for iter0_31, iter1_31 in ipairs(var1_31) do
		local var2_31 = iter1_31[1]
		local var3_31 = iter1_31[2]
		local var4_31 = iter1_31[3]

		if var2_31 == DROP_TYPE_ITEM and Item.getConfigData(var3_31).type == Item.EXP_BOOK_TYPE and var0_31(var3_31, var4_31) then
			return true
		end
	end

	return false
end

function var0_0.ShowOnTaskScene(arg0_33)
	local var0_33 = arg0_33:getConfig("visibility") == 1

	if arg0_33.id == 17268 then
		var0_33 = false

		local var1_33 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1_33 and not var1_33:isEnd() then
			local var2_33 = var1_33.data1KeyValueList[2][17] or 1
			local var3_33 = var1_33.data1KeyValueList[2][18] or 1

			var0_33 = var2_33 >= 4 and var3_33 >= 4
		end
	end

	return var0_33
end

function var0_0.isAvatarTask(arg0_34)
	return false
end

function var0_0.getActId(arg0_35)
	return arg0_35._actId
end

function var0_0.setActId(arg0_36, arg1_36)
	arg0_36._actId = arg1_36
end

function var0_0.isActivityTask(arg0_37)
	return arg0_37._actId and arg0_37._actId > 0
end

return var0_0
