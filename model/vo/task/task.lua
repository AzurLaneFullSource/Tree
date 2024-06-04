local var0 = class("Task", import("..BaseVO"))

var0.TYPE_SCENARIO = 1
var0.TYPE_BRANCH = 2
var0.TYPE_ROUTINE = 3
var0.TYPE_WEEKLY = 4
var0.TYPE_HIDDEN = 5
var0.TYPE_ACTIVITY = 6
var0.TYPE_ACTIVITY_ROUTINE = 36
var0.TYPE_ACTIVITY_BRANCH = 26
var0.TYPE_GUILD_WEEKLY = 12
var0.TYPE_NEW_WEEKLY = 13
var0.TYPE_REFLUX = 15
var0.TYPE_ACTIVITY_WEEKLY = 46

local var1 = {
	"scenario",
	"branch",
	"routine",
	"weekly"
}

var0.TASK_PROGRESS_UPDATE = 0
var0.TASK_PROGRESS_APPEND = 1

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.progress = arg1.progress or 0
	arg0.acceptTime = arg1.accept_time
	arg0.submitTime = arg1.submit_time or 0
end

function var0.isClientTrigger(arg0)
	return arg0:getConfig("sub_type") > 2000 and arg0:getConfig("sub_type") < 3000
end

function var0.bindConfigTable(arg0)
	return pg.task_data_template
end

function var0.isGuildTask(arg0)
	return arg0:getConfig("type") == var0.TYPE_GUILD_WEEKLY
end

function var0.IsRoutineType(arg0)
	return arg0:getConfig("type") == var0.TYPE_ROUTINE
end

function var0.IsActRoutineType(arg0)
	return arg0:getConfig("type") == var0.TYPE_ACTIVITY_ROUTINE
end

function var0.IsActType(arg0)
	return arg0:getConfig("type") == var0.TYPE_ACTIVITY
end

function var0.IsWeeklyType(arg0)
	return arg0:getConfig("type") == var0.TYPE_WEEKLY or arg0:getConfig("type") == var0.TYPE_NEW_WEEKLY
end

function var0.IsBackYardInterActionType(arg0)
	return arg0:getConfig("sub_type") == 2010
end

function var0.IsFlagShipInterActionType(arg0)
	return arg0:getConfig("sub_type") == 2011
end

function var0.IsGuildAddLivnessType(arg0)
	local var0 = arg0:getConfig("type")

	return var0 == var0.TYPE_ROUTINE or var0 == var0.TYPE_WEEKLY or var0 == var0.TYPE_GUILD_WEEKLY or var0 == var0.TYPE_NEW_WEEKLY
end

function var0.isLock(arg0)
	return getProxy(PlayerProxy):getRawData().level < arg0:getConfig("level")
end

function var0.isFinish(arg0)
	return arg0:getProgress() >= arg0:getConfig("target_num")
end

function var0.getProgress(arg0)
	local var0 = arg0.progress

	if arg0:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
		local var1 = tonumber(arg0:getConfig("target_id"))

		var0 = getProxy(BagProxy):getItemCountById(tonumber(var1))
	elseif arg0:getConfig("sub_type") == TASK_SUB_TYPE_PT then
		local var2 = getProxy(ActivityProxy):getActivityById(tonumber(arg0:getConfig("target_id_2")))

		var0 = var2 and var2.data1 or 0
	elseif arg0:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
		local var3 = tonumber(arg0:getConfig("target_id"))

		var0 = getProxy(PlayerProxy):getData():getResById(var3)
	elseif arg0:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
		local var4 = tonumber(arg0:getConfig("target_id"))

		var0 = getProxy(ActivityProxy):getVirtualItemNumber(var4)
	elseif arg0:getConfig("sub_type") == TASK_SUB_TYPE_BOSS_PT then
		local var5 = tonumber(arg0:getConfig("target_id"))

		var0 = getProxy(PlayerProxy):getData():getResById(var5)
	elseif arg0:getConfig("sub_type") == TASK_SUB_STROY then
		local var6 = arg0:getConfig("target_id")
		local var7 = 0

		_.each(var6, function(arg0)
			if pg.NewStoryMgr.GetInstance():GetPlayedFlag(arg0) then
				var7 = var7 + 1
			end
		end)

		var0 = var7
	elseif arg0:getConfig("sub_type") == TASK_SUB_TYPE_TECHNOLOGY_POINT then
		var0 = getProxy(TechnologyNationProxy):getNationPoint(tonumber(arg0:getConfig("target_id")))
		var0 = math.min(var0, arg0:getConfig("target_num"))
	end

	return var0 or 0
end

function var0.getTargetNumber(arg0)
	return arg0:getConfig("target_num")
end

function var0.isReceive(arg0)
	return arg0.submitTime > 0
end

function var0.getTaskStatus(arg0)
	if arg0:isLock() then
		return -1
	end

	if arg0:isReceive() then
		return 2
	end

	if arg0:isFinish() then
		return 1
	end

	return 0
end

function var0.onAdded(arg0)
	local function var0()
		if arg0:getConfig("sub_type") == 29 then
			local var0 = getProxy(SkirmishProxy):getRawData()

			if _.any(var0, function(arg0)
				return arg0:getConfig("task_id") == arg0.id
			end) then
				return
			end

			pg.m02:sendNotification(GAME.TASK_GO, {
				taskVO = arg0
			})
		elseif arg0:getConfig("added_tip") > 0 then
			local var1

			if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= TaskMediator.__cname then
				function var1()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = var1[arg0:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				noText = "text_iknow",
				yesText = "text_forward",
				content = i18n("tip_add_task", arg0:getConfig("name")),
				onYes = var1,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end

	local function var1()
		local var0 = getProxy(ContextProxy):getCurrentContext()

		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, var0.viewComponent.__cname) then
			return true
		end

		return false
	end

	local var2 = arg0:getConfig("story_id")

	if var2 and var2 ~= "" and var1() then
		pg.NewStoryMgr.GetInstance():Play(var2, var0, true, true)
	else
		var0()
	end
end

function var0.updateProgress(arg0, arg1)
	arg0.progress = arg1
end

function var0.isSelectable(arg0)
	local var0 = arg0:getConfig("award_choice")

	return var0 ~= nil and type(var0) == "table" and #var0 > 0
end

function var0.judgeOverflow(arg0, arg1, arg2, arg3)
	local var0 = arg0:getTaskStatus() == 1
	local var1 = arg0:ShowOnTaskScene()

	return var0.StaticJudgeOverflow(arg1, arg2, arg3, var0, var1, arg0:getConfig("award_display"))
end

function var0.StaticJudgeOverflow(arg0, arg1, arg2, arg3, arg4, arg5)
	if arg3 and arg4 then
		local var0 = getProxy(PlayerProxy):getData()
		local var1 = pg.gameset.urpt_chapter_max.description[1]
		local var2 = arg0 or var0.gold
		local var3 = arg1 or var0.oil
		local var4 = arg2 or not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var1) or 0
		local var5 = pg.gameset.max_gold.key_value
		local var6 = pg.gameset.max_oil.key_value
		local var7 = not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2] or 0
		local var8 = false
		local var9 = false
		local var10 = false
		local var11 = false
		local var12 = false
		local var13 = {}
		local var14 = arg5

		for iter0, iter1 in ipairs(var14) do
			local var15, var16, var17 = unpack(iter1)

			if var15 == DROP_TYPE_RESOURCE then
				if var16 == PlayerConst.ResGold then
					local var18 = var2 + var17 - var5

					if var18 > 0 then
						var8 = true

						local var19 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(var18, COLOR_RED)
						}

						table.insert(var13, var19)
					end
				elseif var16 == PlayerConst.ResOil then
					local var20 = var3 + var17 - var6

					if var20 > 0 then
						var9 = true

						local var21 = {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = setColorStr(var20, COLOR_RED)
						}

						table.insert(var13, var21)
					end
				end
			elseif not LOCK_UR_SHIP and var15 == DROP_TYPE_VITEM then
				if Item.getConfigData(var16).virtual_type == 20 then
					local var22 = var4 + var17 - var7

					if var22 > 0 then
						var10 = true

						local var23 = {
							type = DROP_TYPE_VITEM,
							id = var1,
							count = setColorStr(var22, COLOR_RED)
						}

						table.insert(var13, var23)
					end
				end
			elseif var15 == DROP_TYPE_ITEM and Item.getConfigData(var16).type == Item.EXP_BOOK_TYPE then
				local var24 = getProxy(BagProxy):getItemCountById(var16) + var17
				local var25 = Item.getConfigData(var16).max_num

				if var25 < var24 then
					var11 = true

					local var26 = {
						type = DROP_TYPE_ITEM,
						id = var16,
						count = setColorStr(math.min(var17, var24 - var25), COLOR_RED)
					}

					table.insert(var13, var26)
				end
			end
		end

		return var8 or var9 or var10 or var11, var13
	end
end

function var0.IsUrTask(arg0)
	if not LOCK_UR_SHIP then
		local var0 = pg.gameset.urpt_chapter_max.description[1]

		do return _.any(arg0:getConfig("award_display"), function(arg0)
			return arg0[1] == DROP_TYPE_ITEM and arg0[2] == var0
		end) end
		return
	end

	return false
end

function var0.GetRealType(arg0)
	local var0 = arg0:getConfig("priority_type")

	if var0 == 0 then
		var0 = arg0:getConfig("type")
	end

	return var0
end

function var0.IsOverflowShipExpItem(arg0)
	local function var0(arg0, arg1)
		return getProxy(BagProxy):getItemCountById(arg0) + arg1 > Item.getConfigData(arg0).max_num
	end

	local var1 = arg0:getConfig("award_display")

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1[1]
		local var3 = iter1[2]
		local var4 = iter1[3]

		if var2 == DROP_TYPE_ITEM and Item.getConfigData(var3).type == Item.EXP_BOOK_TYPE and var0(var3, var4) then
			return true
		end
	end

	return false
end

function var0.ShowOnTaskScene(arg0)
	local var0 = arg0:getConfig("visibility") == 1

	if arg0.id == 17268 then
		var0 = false

		local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILDING_NEWYEAR_2022)

		if var1 and not var1:isEnd() then
			local var2 = var1.data1KeyValueList[2][17] or 1
			local var3 = var1.data1KeyValueList[2][18] or 1

			var0 = var2 >= 4 and var3 >= 4
		end
	end

	return var0
end

function var0.isAvatarTask(arg0)
	return false
end

return var0
