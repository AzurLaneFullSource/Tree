local var0_0 = class("IslandMinigameCore", import(".IslandCore"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.showBalance = arg3_1
end

function var0_0.SetIslandViewCoponent(arg0_2, arg1_2)
	arg0_2.viewCoponent = arg1_2
end

function var0_0.SetIsReconected(arg0_3, arg1_3)
	arg0_3.isReconected = arg1_3
end

function var0_0.OnInit(arg0_4)
	arg0_4:LoadMiniGameMainPage()
end

function var0_0.GetSceneLoader(arg0_5)
	return IslandMiniGameSceneLoader.New()
end

function var0_0.Update(arg0_6)
	if not arg0_6:IsInit() then
		return
	end

	arg0_6.controller:Update()
	arg0_6.view:Update()

	if arg0_6.callback and arg0_6.view:IsLoaded() and arg0_6.miniGameUILoaded then
		Timer.New(function()
			if arg0_6.isReconected then
				pg.m02:sendNotification(GAME.PLAY_ROOM_ALL_LOAD_OVER)
			else
				pg.m02:sendNotification(GAME.PLAY_ROOM_LOAD_SCENE_COMPLETE)
			end
		end, 2, 0):Start()
		arg0_6.callback()

		arg0_6.callback = nil
	end

	if arg0_6.initCallback and arg0_6.view:IsInit() then
		arg0_6.initCallback()

		arg0_6.initCallback = nil
	end
end

function var0_0.OnChangeMiniGameScene(arg0_8, arg1_8)
	if arg1_8 then
		setActive(arg0_8.miniGameUI, true)
		arg0_8.viewCoponent:OpenPage(IslandCheaterTavernMainPage, arg0_8.miniGameUI, isReConnected)
		onNextTick(function()
			arg0_8.view:AfterCoreInit()

			if arg0_8.isReconected then
				pg.m02:sendNotification(GAME.ISLAND_CHEATER_RECONECTING)
			end
		end)
	else
		CheatTavernCameraMgr.instance._mainCamera.enabled = false

		arg0_8.viewCoponent:OpenPage(IslandCheaterTavernMainPage, arg0_8.miniGameUI, isReConnected)

		CheatTavernCameraMgr.instance._mainCamera.enabled = true
	end
end

function var0_0.LoadMiniGameMainPage(arg0_10)
	arg0_10.miniGameUI = nil
	arg0_10.miniGameUILoaded = false

	PoolMgr.GetInstance():GetUI(arg0_10:GetMiniGameUI(), true, function(arg0_11)
		arg0_10.miniGameUILoaded = true
		arg0_10.miniGameUI = arg0_11

		arg0_10.viewCoponent:SetUIParent(arg0_10.miniGameUI)
		setActive(arg0_10.miniGameUI, false)
	end)
end

function var0_0.GetMiniGameUI(arg0_12)
	return "IslandCheaterTavernMainUI"
end

function var0_0.Dispose(arg0_13, arg1_13)
	var0_0.super.Dispose(arg0_13, arg1_13)
	GameObject.Destroy(arg0_13.miniGameUI)
end

return var0_0
