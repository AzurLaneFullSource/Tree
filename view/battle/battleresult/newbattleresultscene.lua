local var0_0 = class("NewBattleResultScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewBattleResultEmptyUI"
end

function var0_0.getGroupName(arg0_2)
	return "BattleScene"
end

function var0_0.didEnter(arg0_3)
	arg0_3._parentTf = arg0_3._tf.parent

	arg0_3:InitData()
	arg0_3:Adjustion()
	arg0_3:SetUp(arg0_3.pages)

	if arg0_3.contextData.needVibrate then
		arg0_3:Vibrate()
	end

	arg0_3:BlurPanel(arg0_3._tf, {
		staticBlur = true,
		lockGlobalBlur = true
	})
	onDelayTick(function()
		if arg0_3.contextData.needCloseCamera then
			arg0_3:CloseCamera()
		end
	end, 0.2)
end

function var0_0.Adjustion(arg0_5)
	local var0_5 = GetComponent(arg0_5._tf, typeof(AspectRatioFitter))

	var0_5.enabled = true
	var0_5.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0_5.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_6, arg1_6)
		var0_5.aspectRatio = arg1_6
	end)
end

local function var1_0(arg0_7)
	if getProxy(SettingsProxy):IsDisplayResultPainting() then
		return
	end

	for iter0_7 = #arg0_7, 1, -1 do
		if arg0_7[iter0_7] == NewBattleResultDisplayPaintingsPage then
			table.remove(arg0_7, iter0_7)
		end
	end
end

function var0_0.InitData(arg0_8)
	local var0_8 = NewBattleResultYumiaMaterialPage.NeedShowYumiaMaterailDrop(arg0_8.contextData.drops) and {
		NewBattleResultGradePage,
		NewBattleResultDisplayAwardPage,
		NewBattleResultYumiaMaterialPage,
		NewBattleResultDisplayPaintingsPage,
		NewBattleResultStatisticsPage
	} or {
		NewBattleResultGradePage,
		NewBattleResultDisplayAwardPage,
		NewBattleResultDisplayPaintingsPage,
		NewBattleResultStatisticsPage
	}

	arg0_8.pages = NewBattleResultSystem2Pages[arg0_8.contextData.system] or var0_8

	var1_0(arg0_8.pages)

	arg0_8.contextData.oldMainShips = NewBattleResultUtil.RemoveNonStatisticShips(arg0_8.contextData.oldMainShips, arg0_8.contextData.statistics)
	arg0_8.contextData.newMainShips = NewBattleResultDataExtender.GetNewMainShips(arg0_8.contextData)
	arg0_8.contextData.autoSkipFlag = NewBattleResultDataExtender.GetAutoSkipFlag(arg0_8.contextData, arg0_8.contextData.system)
	arg0_8.contextData.needVibrate = NewBattleResultDataExtender.NeedVibrate(arg0_8.contextData.autoSkipFlag)
	arg0_8.contextData.needCloseCamera = NewBattleResultDataExtender.NeedCloseCamera(arg0_8.contextData.system)
	arg0_8.contextData.needHelpMessage = NewBattleResultDataExtender.NeedHelpMessage(arg0_8.contextData.system, arg0_8.contextData.score)
	arg0_8.contextData.expBuff = NewBattleResultDataExtender.GetExpBuffs(arg0_8.contextData.system)
	arg0_8.contextData.buffShips = NewBattleResultDataExtender.GetShipBuffs(arg0_8.contextData.system)
end

function var0_0.CloseCamera(arg0_9)
	ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCamera(false)
end

function var0_0.Vibrate(arg0_10)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
	LuaHelper.Vibrate()
end

function var0_0.SetUp(arg0_11, arg1_11)
	local var0_11 = {}

	arg0_11.history = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		table.insert(var0_11, function(arg0_12)
			if arg0_11.exited then
				return
			end

			local var0_12 = iter1_11.New(arg0_11._tf, arg0_11.event, arg0_11.contextData)

			var0_12:ExecuteAction("SetUp", arg0_12, function()
				arg0_11:DestroyHistory()
			end)
			table.insert(arg0_11.history, var0_12)
		end)
	end

	seriesAsync(var0_11, function()
		arg0_11:GoBack()
	end)
end

function var0_0.DestroyHistory(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.history) do
		if not isa(iter1_15, NewBattleResultStatisticsPage) then
			iter1_15:Destroy()
		end
	end
end

function var0_0.GoBack(arg0_16)
	local function var0_16()
		arg0_16.backSceneHandler = NewBattleResultBackSceneHandler.New(arg0_16.contextData)

		arg0_16.backSceneHandler:Execute()
	end

	if arg0_16.contextData.needHelpMessage then
		arg0_16:emit(NewBattleResultMediator.OPEN_FIALED_HELP, var0_16)
	else
		var0_16()
	end
end

function var0_0.onBackPressed(arg0_18)
	return
end

function var0_0.willExit(arg0_19)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19._tf, arg0_19._parentTf)

	if arg0_19.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_19.camEventId)

		arg0_19.camEventId = nil
	end

	if arg0_19.backSceneHandler then
		arg0_19.backSceneHandler:Dispose()

		arg0_19.backSceneHandler = nil
	end

	if arg0_19.history then
		for iter0_19, iter1_19 in ipairs(arg0_19.history) do
			iter1_19:Destroy()
		end

		arg0_19.history = nil
	end
end

return var0_0
