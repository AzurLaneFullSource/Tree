local var0_0 = class("IslandPoppingQueue")

var0_0.PERFORMANCE = 1
var0_0.DISPLAY_AWARD = 2
var0_0.MSGBOX = 3
var0_0.STORY = 4
var0_0.TASK_ACCEPT_PAGE = 5

function var0_0.CreateTask(arg0_1, arg1_1)
	local var0_1 = {
		type = arg0_1,
		args = arg1_1 or {}
	}

	var0_1.callback = var0_1.args.callback

	return var0_1
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.islandScene = arg1_2
	arg0_2.schedule = {}
	arg0_2.ignoringStoryList = {}
	arg0_2.playerList = {}
end

function var0_0.GetSceneView(arg0_3)
	return arg0_3.islandScene
end

function var0_0.Enqueue(arg0_4, arg1_4, arg2_4)
	local var0_4 = var0_0.CreateTask(arg1_4, arg2_4)

	if not arg0_4:IsValid(var0_4) then
		return
	end

	table.insert(arg0_4.schedule, var0_4)

	if #arg0_4.schedule == 1 then
		arg0_4:ProcessNextOne()
	end
end

function var0_0.IsValid(arg0_5, arg1_5)
	if arg1_5.type == var0_0.STORY and table.contains(arg0_5.ignoringStoryList, arg1_5.args.name) then
		arg0_5:ExecuteStory(arg1_5.callback, arg1_5.args.name, arg1_5.args.refreshNpc)

		return false
	end

	return true
end

function var0_0.ProcessNextOne(arg0_6)
	local var0_6 = arg0_6.schedule[1]

	local function var1_6()
		if var0_6.callback then
			var0_6.callback()
		end

		if not arg0_6.schedule then
			return
		end

		arg0_6.ignoringStoryList = {}

		table.remove(arg0_6.schedule, 1)

		if #arg0_6.schedule > 0 then
			onNextTick(function()
				arg0_6:ProcessNextOne()
			end)
		end
	end

	if var0_6.type == var0_0.PERFORMANCE then
		arg0_6:ExecutePerformer(var1_6, var0_6.args.name)
	elseif var0_6.type == var0_0.DISPLAY_AWARD then
		arg0_6:ExecuteAwardDisplay(var1_6, var0_6.args.dropData, var0_6.args.displayType)
	elseif var0_6.type == var0_0.MSGBOX then
		arg0_6:ExecuteMsgbox(var1_6, var0_6.args)
	elseif var0_6.type == var0_0.STORY then
		arg0_6:ExecuteStory(var1_6, var0_6.args.name, var0_6.args.refreshNpc)
	elseif var0_6.type == var0_0.TASK_ACCEPT_PAGE then
		arg0_6:ExecuteTaskAcceptWin(var1_6, var0_6.args.taskId)
	else
		error("Unknown popping type: " .. tostring(var0_6.type))
	end
end

function var0_0.ExecuteStory(arg0_9, arg1_9, arg2_9, arg3_9)
	arg0_9:GetSceneView():TryDisVisible()
	arg0_9:GetSceneView():GetSubView(IslandStoryMgr):ExecuteAction("Play", arg2_9, arg3_9, function()
		arg0_9:GetSceneView():TryVisible()
		arg1_9()
	end)
end

function var0_0.ExecuteMsgbox(arg0_11, arg1_11, arg2_11)
	arg0_11:GetSceneView():GetSubView(IslandMsgBox):ExecuteAction("Show", arg2_11, arg1_11)
end

function var0_0.ExecutePerformer(arg0_12, arg1_12, arg2_12)
	local var0_12 = pg.NewStoryMgr.GetInstance():GetScript(arg2_12)

	if not var0_12 or #var0_12 <= 0 then
		arg1_12()

		return
	end

	for iter0_12, iter1_12 in ipairs(var0_12) do
		if iter1_12.type == IslandPerformancePerformer.TYPE_STORY then
			table.insert(arg0_12.ignoringStoryList, iter1_12.name)
		end
	end

	local var1_12 = IslandPerformancePerformer.New(arg0_12:GetSceneView().event)

	var1_12:Play(arg2_12, var0_12, function()
		var1_12:Dispose()
		table.removebyvalue(arg0_12.playerList, var1_12)
		arg1_12()
	end)
	table.insert(arg0_12.playerList, var1_12)
end

function var0_0.ExecuteAwardDisplay(arg0_14, arg1_14, arg2_14, arg3_14)
	seriesAsync({
		function(arg0_15)
			if not arg2_14.drops or #arg2_14.drops <= 0 then
				arg0_15()

				return
			end

			arg0_14:GetSceneView():emit(BaseUI.ON_ACHIEVE, arg2_14.drops, arg0_15)
		end,
		function(arg0_16)
			onNextTick(arg0_16)
		end,
		function(arg0_17)
			if not arg2_14.awards or #arg2_14.awards <= 0 then
				arg0_17()

				return
			end

			arg0_14:GetSceneView():DisplayAward({
				type = arg3_14,
				title = i18n("island_get_item_tip"),
				awards = arg2_14.awards,
				callback = arg0_17
			})
		end,
		function(arg0_18)
			onNextTick(arg0_18)
		end,
		function(arg0_19)
			if not arg2_14.exp or arg2_14.exp <= 0 then
				arg0_19()

				return
			end

			arg0_14:GetSceneView():ShowExpAdd(arg2_14.exp, arg0_19)
		end,
		function(arg0_20)
			onNextTick(arg0_20)
		end,
		function(arg0_21)
			arg0_14:GetSceneView():DisplaySystemUnlock(arg2_14.abilitys, arg0_21)
		end,
		function(arg0_22)
			onNextTick(arg0_22)
		end,
		function(arg0_23)
			pg.m02:sendNotification(GAME.ISLAND_UPGRADE, {
				callback = arg0_23
			})
		end,
		function(arg0_24)
			onNextTick(arg0_24)
		end,
		function(arg0_25)
			if not arg2_14.overflowAwards or #arg2_14.overflowAwards == 0 then
				arg0_25()

				return
			end

			arg0_14:GetSceneView():DisplayAward({
				titleColor = "#ab4734",
				title = i18n("island_add_temp_bag"),
				awards = arg2_14.overflowAwards,
				callback = arg0_25
			})
		end,
		function(arg0_26)
			if not arg2_14.overflowAwards or #arg2_14.overflowAwards == 0 then
				arg0_26()

				return
			end

			arg0_14:GetSceneView():OpenPage(IslandInventoryPage)
			arg0_26()
		end
	}, arg1_14)
end

function var0_0.ExecuteTaskAcceptWin(arg0_27, arg1_27, arg2_27)
	arg0_27:GetSceneView():emitCore(ISLAND_EVT.DISABLE_INPUT)

	local function var0_27()
		arg0_27:GetSceneView():emitCore(ISLAND_EVT.ENABLE_INPUT)
		arg1_27()
	end

	arg0_27:GetSceneView():GetSubView(Island3dTaskAcceptPage):ExecuteAction("Show", arg2_27, var0_27)
end

function var0_0.AnyPlayerIsRunning(arg0_29)
	return #arg0_29.playerList > 0
end

function var0_0.Dispose(arg0_30)
	arg0_30.schedule = nil

	for iter0_30, iter1_30 in ipairs(arg0_30.playerList or {}) do
		iter1_30:Dispose()
	end

	arg0_30.playerList = nil
end

return var0_0
