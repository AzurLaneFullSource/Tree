local var0_0 = class("IslandPerformancePerformer", import("view.base.BaseEventLogic"))

var0_0.START_PERFORMANCE = "IslandPerformancePerformer:START_PERFORMANCE"
var0_0.END_PERFORMANCE = "IslandPerformancePerformer:END_PERFORMANCE"
var0_0.TYPE_FINDPATH = 1
var0_0.TYPE_TRANSFER = 2
var0_0.TYPE_STORY = 3
var0_0.TYPE_HIDE_UNIT = 4
var0_0.TYPE_UPDATE_STORY = 5
var0_0.TYPE_LOCK_NPC_REFRESH = 6

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
	elseif arg1_3 == var0_0.TYPE_UPDATE_STORY then
		return IslandUpdateStoryPlayer.New(arg0_3)
	elseif arg1_3 == var0_0.TYPE_LOCK_NPC_REFRESH then
		return IslandLockNpcRefreshPlayer.New(arg0_3)
	end
end

function var0_0.Play(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4:OnStart(arg1_4)

	local var0_4 = {}
	local var1_4 = _.detect(arg2_4, function(arg0_5)
		return arg0_5.type == var0_0.TYPE_LOCK_NPC_REFRESH
	end)
	local var2_4 = false

	for iter0_4, iter1_4 in ipairs(arg2_4) do
		table.insert(var0_4, function(arg0_6)
			local var0_6 = arg0_4:GetPlayer(iter1_4.type)

			if isa(var0_6, IslandFindingPathPlayer) and var1_4 then
				var0_6:SetEndCallback(function()
					arg0_4:ClearLockNpc(var1_4.unitIdList, false)
				end)

				var2_4 = true
			end

			var0_6:Play(iter1_4, arg0_6)

			arg0_4.player = var0_6
		end)
	end

	seriesAsync(var0_4, function()
		local var0_8 = not var2_4 and var1_4

		if var0_8 then
			arg0_4:ClearLockNpc(var1_4.unitIdList, true)
		end

		arg0_4:OnEnd(var0_8)

		arg0_4.player = nil

		if arg3_4 then
			arg3_4()
		end
	end)
end

function var0_0.ClearLockNpc(arg0_9, arg1_9, arg2_9)
	if not arg1_9 then
		return
	end

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		arg0_9:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.RELEASE_NPC_REFRESH, iter1_9, IslandConst.UNIT_LIST_OBJ)
	end
end

function var0_0.OnStart(arg0_10, arg1_10)
	arg0_10.runing = true

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg1_10
	})
	arg0_10:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.PERFORMANCE_START)
end

function var0_0.OnEnd(arg0_11, arg1_11)
	arg0_11.runing = false

	arg0_11:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.PERFORMANCE_END, arg1_11)
end

function var0_0.OnSceneLoaded(arg0_12)
	if not arg0_12.player then
		return
	end

	if isa(arg0_12.player, IslandTransferPlayer) then
		arg0_12.player:EndAction()
	end
end

function var0_0.Update(arg0_13)
	if arg0_13.player then
		arg0_13.player:Update()
	end
end

function var0_0.IsRunning(arg0_14)
	return arg0_14.runing
end

function var0_0.Dispose(arg0_15)
	arg0_15:disposeEvent()
	arg0_15:cleanManagedTween()

	arg0_15.player = nil

	if arg0_15.handle then
		UpdateBeat:RemoveListener(arg0_15.handle)
	end

	arg0_15.handle = nil
end

return var0_0
