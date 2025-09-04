local var0_0 = class("IslandSeekGameView", import("Mod.Island.Core.View.IslandView"))
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	arg0_1.state = var1_0

	arg0_1:Op("NotifiyIsland", ISLAND_EX_EVT.SEEK_GAME_START)
end

function var0_0.OnSceneInited(arg0_2)
	arg0_2:InitFocusCamera()
	arg0_2:DisableOp()

	local var0_2 = arg0_2:GetSystemModule(IslandConst.SEEK_GAME_SYSTEM_ID)
	local var1_2 = IslandSeekGameResultView.New(arg0_2, var0_2.data:GetResultUIName())

	var1_2:Init()
	table.insert(arg0_2.views, var1_2)
	var0_2:OnSceneInitEnd()

	arg0_2.isInit = true

	arg0_2:OnGameStart()
end

function var0_0.AddListeners(arg0_3)
	var0_0.super.AddListeners(arg0_3)
	arg0_3:AddListener(ISLAND_EVT.SEEK_GAME_FAILED, arg0_3.OnGameFailed)
	arg0_3:AddListener(ISLAND_EVT.SEEK_GAME_SUCCESS, arg0_3.OnGameSuccess)
end

function var0_0.RemoveListeners(arg0_4)
	var0_0.super.RemoveListeners(arg0_4)
	arg0_4:RemoveListener(ISLAND_EVT.SEEK_GAME_FAILED, arg0_4.OnGameFailed)
	arg0_4:RemoveListener(ISLAND_EVT.SEEK_GAME_SUCCESS, arg0_4.OnGameSuccess)
end

function var0_0.OnGameStart(arg0_5)
	if arg0_5.state ~= var1_0 then
		return
	end

	arg0_5.state = var2_0

	IslandCameraMgr.instance:LookAt(arg0_5.player._tf)
	arg0_5:GetSystemModule(IslandConst.SEEK_GAME_SYSTEM_ID):StartGame()
	arg0_5:EnableOp()
end

function var0_0.OnGameFailed(arg0_6)
	if arg0_6.state ~= var2_0 then
		return
	end

	arg0_6.state = var3_0

	arg0_6:GetSystemModule(IslandConst.SEEK_GAME_SYSTEM_ID):StopGame()
	arg0_6:DisableOp()
	arg0_6:GetSubView(IslandSeekGameResultView):Show()
end

function var0_0.OnGameSuccess(arg0_7)
	if arg0_7.state ~= var2_0 then
		return
	end

	arg0_7.state = var4_0

	arg0_7:GetSystemModule(IslandConst.SEEK_GAME_SYSTEM_ID):StopGame()
end

function var0_0.RestartGame(arg0_8)
	if arg0_8.state ~= var3_0 then
		return
	end

	arg0_8.state = var2_0

	arg0_8:GetSystemModule(IslandConst.SEEK_GAME_SYSTEM_ID):RestartGame()
	arg0_8.player:ResetPosition()
	arg0_8:EnableOp()
end

function var0_0.OnEndPerformance(arg0_9)
	var0_0.super.OnEndPerformance(arg0_9)
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_24")
end

function var0_0.DisableOp(arg0_10)
	arg0_10.player:StopMoveHandle()
	arg0_10:GetSubView(IslandOpView):TryDisablePlayerOp()
	arg0_10:GetSubView(IslandOpView):DisableInteraction()
	arg0_10:GetSubView(IslandOpView):Hide()
end

function var0_0.EnableOp(arg0_11)
	arg0_11:GetSubView(IslandOpView):TryEnablePlayerOp()
	arg0_11:GetSubView(IslandOpView):EnableInteraction()
	arg0_11:GetSubView(IslandOpView):Show()
end

function var0_0.OnDispose(arg0_12)
	arg0_12:Op("NotifiyIsland", ISLAND_EX_EVT.SEEK_GAME_END)
	var0_0.super.OnDispose(arg0_12)
end

return var0_0
