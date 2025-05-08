local var0_0 = class("IslandSeekGameView", import("Mod.Island.Core.View.IslandView"))
local var1_0 = 0

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	local var0_1 = arg0_1:CreateResultView()

	var0_1:Init()
	table.insert(arg0_1.views, var0_1)

	local var1_1 = IslandSeekGameSystem.New(arg0_1, var1_0)

	table.insert(arg0_1.systems, var1_1)
	arg0_1:Op("NotifiyIsland", ISLAND_EX_EVT.SEEK_GAME_START)
end

function var0_0.CreateResultView(arg0_2)
	return IslandSeekGameResultView.New(arg0_2)
end

function var0_0.OnSceneInited(arg0_3)
	arg0_3:DisableOp()
	arg0_3:GetSystem(var1_0):OnSceneInitEnd()

	arg0_3.isInit = true
end

function var0_0.AddListeners(arg0_4)
	var0_0.super.AddListeners(arg0_4)
	arg0_4:AddListener(ISLAND_EVT.SEEK_GAME_START, arg0_4.OnGameStart)
	arg0_4:AddListener(ISLAND_EVT.SEEK_GAME_FAILED, arg0_4.OnGameFailed)
	arg0_4:AddListener(ISLAND_EVT.SEEK_GAME_SUCCESS, arg0_4.OnGameSuccess)
end

function var0_0.RemoveListeners(arg0_5)
	var0_0.super.RemoveListeners(arg0_5)
	arg0_5:RemoveListener(ISLAND_EVT.SEEK_GAME_START, arg0_5.OnGameStart)
	arg0_5:RemoveListener(ISLAND_EVT.SEEK_GAME_FAILED, arg0_5.OnGameFailed)
	arg0_5:RemoveListener(ISLAND_EVT.SEEK_GAME_SUCCESS, arg0_5.OnGameSuccess)
end

function var0_0.OnGameStart(arg0_6)
	IslandCameraMgr.instance:LookAt(arg0_6.player._tf)
	arg0_6:GetSystem(var1_0):StartGame()
	arg0_6:EnableOp()
end

function var0_0.OnGameFailed(arg0_7)
	arg0_7:GetSystem(var1_0):StopGame()
	arg0_7.player:StopMoveHandle()
	arg0_7:DisableOp()
	arg0_7:GetSubView(IslandSeekGameResultView):Show()
end

function var0_0.OnGameSuccess(arg0_8)
	arg0_8:GetSystem(var1_0):StopGame()
end

function var0_0.RestartGame(arg0_9)
	arg0_9:GetSystem(var1_0):RestartGame()
	arg0_9.player:ResetPosition()
	arg0_9:EnableOp()
end

function var0_0.OnDispose(arg0_10)
	var0_0.super.OnDispose(arg0_10)
	arg0_10:Op("NotifiyIsland", ISLAND_EX_EVT.SEEK_GAME_END)
end

return var0_0
