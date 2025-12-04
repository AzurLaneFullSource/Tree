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
			arg0_6:ProcessNextOne()
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

function var0_0.ExecuteStory(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8:GetSceneView():TryDisVisible()
	arg0_8:GetSceneView():GetSubView(IslandStoryMgr):ExecuteAction("Play", arg2_8, arg3_8, function()
		arg0_8:GetSceneView():TryVisible()
		arg1_8()
	end)
end

function var0_0.ExecuteMsgbox(arg0_10, arg1_10, arg2_10)
	arg0_10:GetSceneView():GetSubView(IslandMsgBox):ExecuteAction("Show", arg2_10, arg1_10)
end

function var0_0.ExecutePerformer(arg0_11, arg1_11, arg2_11)
	local var0_11 = pg.NewStoryMgr.GetInstance():GetScript(arg2_11)

	if not var0_11 or #var0_11 <= 0 then
		arg1_11()

		return
	end

	for iter0_11, iter1_11 in ipairs(var0_11) do
		if iter1_11.type == IslandPerformancePerformer.TYPE_STORY then
			table.insert(arg0_11.ignoringStoryList, iter1_11.name)
		end
	end

	local var1_11 = IslandPerformancePerformer.New(arg0_11:GetSceneView().event)

	var1_11:Play(arg2_11, var0_11, function()
		var1_11:Dispose()
		table.removebyvalue(arg0_11.playerList, var1_11)
		arg1_11()
	end)
	table.insert(arg0_11.playerList, var1_11)
end

function var0_0.ExecuteAwardDisplay(arg0_13, arg1_13, arg2_13, arg3_13)
	seriesAsync({
		function(arg0_14)
			if not arg2_13.drops or #arg2_13.drops <= 0 then
				arg0_14()

				return
			end

			arg0_13:GetSceneView():emit(BaseUI.ON_ACHIEVE, arg2_13.drops, arg0_14)
		end,
		function(arg0_15)
			onNextTick(arg0_15)
		end,
		function(arg0_16)
			if not arg2_13.awards or #arg2_13.awards <= 0 then
				arg0_16()

				return
			end

			arg0_13:GetSceneView():DisplayAward({
				type = arg3_13,
				title = i18n("island_get_item_tip"),
				awards = arg2_13.awards,
				callback = arg0_16
			})
		end,
		function(arg0_17)
			onNextTick(arg0_17)
		end,
		function(arg0_18)
			if not arg2_13.exp or arg2_13.exp <= 0 then
				arg0_18()

				return
			end

			arg0_13:GetSceneView():ShowExpAdd(arg2_13.exp, arg0_18)
		end,
		function(arg0_19)
			onNextTick(arg0_19)
		end,
		function(arg0_20)
			arg0_13:GetSceneView():DisplaySystemUnlock(arg2_13.abilitys, arg0_20)
		end,
		function(arg0_21)
			onNextTick(arg0_21)
		end,
		function(arg0_22)
			pg.m02:sendNotification(GAME.ISLAND_UPGRADE, {
				callback = arg0_22
			})
		end,
		function(arg0_23)
			onNextTick(arg0_23)
		end,
		function(arg0_24)
			if not arg2_13.overflowAwards or #arg2_13.overflowAwards == 0 then
				arg0_24()

				return
			end

			arg0_13:GetSceneView():DisplayAward({
				titleColor = "#ab4734",
				title = i18n("island_add_temp_bag"),
				awards = arg2_13.overflowAwards,
				callback = arg0_24
			})
		end,
		function(arg0_25)
			if not arg2_13.overflowAwards or #arg2_13.overflowAwards == 0 then
				arg0_25()

				return
			end

			arg0_13:GetSceneView():OpenPage(IslandInventoryPage)
			arg0_25()
		end
	}, arg1_13)
end

function var0_0.ExecuteTaskAcceptWin(arg0_26, arg1_26, arg2_26)
	arg0_26:GetSceneView():emitCore(ISLAND_EVT.DISABLE_INPUT)

	local function var0_26()
		arg0_26:GetSceneView():emitCore(ISLAND_EVT.ENABLE_INPUT)
		arg1_26()
	end

	arg0_26:GetSceneView():GetSubView(Island3dTaskAcceptPage):ExecuteAction("Show", arg2_26, var0_26)
end

function var0_0.AnyPlayerIsRunning(arg0_28)
	return #arg0_28.playerList > 0
end

function var0_0.Dispose(arg0_29)
	arg0_29.schedule = nil

	for iter0_29, iter1_29 in ipairs(arg0_29.playerList or {}) do
		iter1_29:Dispose()
	end

	arg0_29.playerList = nil
end

return var0_0
