local var0_0 = class("IslandPerformancePerformer", import("view.base.BaseEventLogic"))

var0_0.START_PERFORMANCE = "IslandPerformancePerformer:START_PERFORMANCE"
var0_0.END_PERFORMANCE = "IslandPerformancePerformer:END_PERFORMANCE"
var0_0.TYPE_FINDPATH = 1
var0_0.TYPE_TRANSFER = 2
var0_0.TYPE_STORY = 3
var0_0.TYPE_HIDE_UNIT = 4
var0_0.TYPE_UPDATE_STORY = 5
var0_0.TYPE_LOCK_NPC_REFRESH = 6

function var0_0.GetStoryNameList(arg0_1)
	local var0_1 = pg.NewStoryMgr.GetInstance():GetScript(arg0_1)

	if not var0_1 then
		return {}
	end

	local function var1_1(arg0_2, arg1_2)
		local var0_2 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_2)

		if var0_2 then
			table.insert(arg0_2, var0_2)
		end
	end

	local var2_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		if iter1_1.type == var0_0.TYPE_STORY then
			if iter1_1.name then
				var1_1(var2_1, iter1_1.name)
			end
		elseif iter1_1.type == var0_0.TYPE_UPDATE_STORY then
			if iter1_1.index then
				var1_1(var2_1, iter1_1.index)
			end
		elseif iter1_1.type == var0_0.TYPE_FINDPATH and iter1_1.index then
			var1_1(var2_1, iter1_1.index)
		end
	end

	var1_1(var2_1, arg0_1)

	return var2_1
end

function var0_0.Ctor(arg0_3, arg1_3)
	var0_0.super.Ctor(arg0_3, arg1_3)

	if not arg0_3.handle then
		arg0_3.handle = UpdateBeat:CreateListener(arg0_3.Update, arg0_3)
	end

	UpdateBeat:AddListener(arg0_3.handle)
	arg0_3:bind(IslandBaseScene.ON_SCENE_LOADED, function()
		arg0_3:OnSceneLoaded()
	end)
end

function var0_0.GetPlayer(arg0_5, arg1_5)
	if arg1_5 == var0_0.TYPE_FINDPATH then
		return IslandFindingPathPlayer.New(arg0_5)
	elseif arg1_5 == var0_0.TYPE_TRANSFER then
		return IslandTransferPlayer.New(arg0_5)
	elseif arg1_5 == var0_0.TYPE_STORY then
		return IslandPerformanceStoryPlayer.New(arg0_5)
	elseif arg1_5 == var0_0.TYPE_HIDE_UNIT then
		return IslandPerformanceActiveUnitPlayer.New(arg0_5)
	elseif arg1_5 == var0_0.TYPE_UPDATE_STORY then
		return IslandUpdateStoryPlayer.New(arg0_5)
	elseif arg1_5 == var0_0.TYPE_LOCK_NPC_REFRESH then
		return IslandLockNpcRefreshPlayer.New(arg0_5)
	end
end

function var0_0.Play(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6:OnStart(arg1_6)

	local var0_6 = {}
	local var1_6 = _.detect(arg2_6, function(arg0_7)
		return arg0_7.type == var0_0.TYPE_LOCK_NPC_REFRESH
	end)
	local var2_6 = false

	for iter0_6, iter1_6 in ipairs(arg2_6) do
		table.insert(var0_6, function(arg0_8)
			local var0_8 = arg0_6:GetPlayer(iter1_6.type)

			if isa(var0_8, IslandFindingPathPlayer) and var1_6 then
				var0_8:SetEndCallback(function()
					arg0_6:ClearLockNpc(var1_6.unitIdList, false)
				end)

				var2_6 = true
			end

			var0_8:Play(iter1_6, arg0_8)

			arg0_6.player = var0_8
		end)
	end

	seriesAsync(var0_6, function()
		local var0_10 = not var2_6 and var1_6

		if var0_10 then
			arg0_6:ClearLockNpc(var1_6.unitIdList, true)
		end

		arg0_6:OnEnd(var0_10)

		arg0_6.player = nil

		if arg3_6 then
			arg3_6()
		end
	end)
end

function var0_0.ClearLockNpc(arg0_11, arg1_11, arg2_11)
	if not arg1_11 then
		return
	end

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		arg0_11:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.RELEASE_NPC_REFRESH, iter1_11, IslandConst.UNIT_LIST_OBJ)
	end
end

function var0_0.OnStart(arg0_12, arg1_12)
	arg0_12.runing = true

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg1_12
	})
	arg0_12:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.PERFORMANCE_START)
end

function var0_0.OnEnd(arg0_13, arg1_13)
	arg0_13.runing = false

	arg0_13:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.PERFORMANCE_END, arg1_13)
end

function var0_0.OnSceneLoaded(arg0_14)
	if not arg0_14.player then
		return
	end

	if isa(arg0_14.player, IslandTransferPlayer) then
		arg0_14.player:EndAction()
	end
end

function var0_0.Update(arg0_15)
	if arg0_15.player then
		arg0_15.player:Update()
	end
end

function var0_0.IsRunning(arg0_16)
	return arg0_16.runing
end

function var0_0.Dispose(arg0_17)
	arg0_17:disposeEvent()
	arg0_17:cleanManagedTween()

	arg0_17.player = nil

	if arg0_17.handle then
		UpdateBeat:RemoveListener(arg0_17.handle)
	end

	arg0_17.handle = nil
end

return var0_0
