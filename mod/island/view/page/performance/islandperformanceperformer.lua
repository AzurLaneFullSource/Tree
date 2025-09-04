local var0_0 = class("IslandPerformancePerformer", import("view.base.BaseEventLogic"))

var0_0.START_PERFORMANCE = "IslandPerformancePerformer:START_PERFORMANCE"
var0_0.END_PERFORMANCE = "IslandPerformancePerformer:END_PERFORMANCE"
var0_0.TYPE_FINDPATH = 1
var0_0.TYPE_TRANSFER = 2
var0_0.TYPE_STORY = 3
var0_0.TYPE_HIDE_UNIT = 4

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	if not arg0_1.handle then
		arg0_1.handle = UpdateBeat:CreateListener(arg0_1.Update, arg0_1)
	end

	UpdateBeat:AddListener(arg0_1.handle)
	arg0_1:bind(IslandBaseScene.ON_SCENE_LOADED, function()
		arg0_1:OnSceneLoaded()
	end)
end

function var0_0.GetPlayer(arg0_3, arg1_3)
	if arg1_3 == var0_0.TYPE_FINDPATH then
		return IslandFindingPathPlayer.New(arg0_3)
	elseif arg1_3 == var0_0.TYPE_TRANSFER then
		return IslandTransferPlayer.New(arg0_3)
	elseif arg1_3 == var0_0.TYPE_STORY then
		return IslandPerformanceStoryPlayer.New(arg0_3)
	elseif arg1_3 == var0_0.TYPE_HIDE_UNIT then
		return IslandPerformanceActiveUnitPlayer.New(arg0_3)
	end
end

function var0_0.Play(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4:OnStart(arg1_4)

	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg2_4) do
		table.insert(var0_4, function(arg0_5)
			local var0_5 = arg0_4:GetPlayer(iter1_4.type)

			var0_5:Play(iter1_4, arg0_5)

			arg0_4.player = var0_5
		end)
	end

	seriesAsync(var0_4, function()
		arg0_4:OnEnd()

		arg0_4.player = nil

		if arg3_4 then
			arg3_4()
		end
	end)
end

function var0_0.OnStart(arg0_7, arg1_7)
	arg0_7.runing = true

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg1_7
	})
	arg0_7:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.PERFORMANCE_START)
end

function var0_0.OnEnd(arg0_8)
	arg0_8.runing = false

	arg0_8:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.PERFORMANCE_END)
end

function var0_0.OnSceneLoaded(arg0_9)
	if not arg0_9.player then
		return
	end

	if isa(arg0_9.player, IslandTransferPlayer) then
		arg0_9.player:EndAction()
	end
end

function var0_0.Update(arg0_10)
	if arg0_10.player then
		arg0_10.player:Update()
	end
end

function var0_0.IsRunning(arg0_11)
	return arg0_11.runing
end

function var0_0.Dispose(arg0_12)
	arg0_12:disposeEvent()
	arg0_12:cleanManagedTween()

	arg0_12.player = nil

	if arg0_12.handle then
		UpdateBeat:RemoveListener(arg0_12.handle)
	end

	arg0_12.handle = nil
end

return var0_0
