local var0_0 = class("NewBattleResultScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewBattleResultEmptyUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2._parentTf = arg0_2._tf.parent

	arg0_2:InitData()
	arg0_2:Adjustion()
	arg0_2:SetUp(arg0_2.pages)

	if arg0_2.contextData.needVibrate then
		arg0_2:Vibrate()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, true, {
		lockGlobalBlur = true,
		groupName = LayerWeightConst.GROUP_COMBAT
	})
	onDelayTick(function()
		if arg0_2.contextData.needCloseCamera then
			arg0_2:CloseCamera()
		end
	end, 0.2)
end

function var0_0.Adjustion(arg0_4)
	local var0_4 = GetComponent(arg0_4._tf, typeof(AspectRatioFitter))

	var0_4.enabled = true
	var0_4.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0_4.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_5, arg1_5)
		var0_4.aspectRatio = arg1_5
	end)
end

local function var1_0(arg0_6)
	if getProxy(SettingsProxy):IsDisplayResultPainting() then
		return
	end

	for iter0_6 = #arg0_6, 1, -1 do
		if arg0_6[iter0_6] == NewBattleResultDisplayPaintingsPage then
			table.remove(arg0_6, iter0_6)
		end
	end
end

function var0_0.InitData(arg0_7)
	arg0_7.pages = NewBattleResultSystem2Pages[arg0_7.contextData.system] or {
		NewBattleResultGradePage,
		NewBattleResultDisplayAwardPage,
		NewBattleResultDisplayPaintingsPage,
		NewBattleResultStatisticsPage
	}

	var1_0(arg0_7.pages)

	arg0_7.contextData.oldMainShips = NewBattleResultUtil.RemoveNonStatisticShips(arg0_7.contextData.oldMainShips, arg0_7.contextData.statistics)
	arg0_7.contextData.newMainShips = NewBattleResultDataExtender.GetNewMainShips(arg0_7.contextData)
	arg0_7.contextData.autoSkipFlag = NewBattleResultDataExtender.GetAutoSkipFlag(arg0_7.contextData, arg0_7.contextData.system)
	arg0_7.contextData.needVibrate = NewBattleResultDataExtender.NeedVibrate(arg0_7.contextData.autoSkipFlag)
	arg0_7.contextData.needCloseCamera = NewBattleResultDataExtender.NeedCloseCamera(arg0_7.contextData.system)
	arg0_7.contextData.needHelpMessage = NewBattleResultDataExtender.NeedHelpMessage(arg0_7.contextData.system, arg0_7.contextData.score)
	arg0_7.contextData.expBuff = NewBattleResultDataExtender.GetExpBuffs(arg0_7.contextData.system)
	arg0_7.contextData.buffShips = NewBattleResultDataExtender.GetShipBuffs(arg0_7.contextData.system)
end

function var0_0.CloseCamera(arg0_8)
	ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCemera(false)
end

function var0_0.Vibrate(arg0_9)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
	LuaHelper.Vibrate()
end

function var0_0.SetUp(arg0_10, arg1_10)
	local var0_10 = {}

	arg0_10.history = {}

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		table.insert(var0_10, function(arg0_11)
			if arg0_10.exited then
				return
			end

			local var0_11 = iter1_10.New(arg0_10._tf, arg0_10.event, arg0_10.contextData)

			var0_11:ExecuteAction("SetUp", arg0_11, function()
				arg0_10:DestroyHistory()
			end)
			table.insert(arg0_10.history, var0_11)
		end)
	end

	seriesAsync(var0_10, function()
		arg0_10:GoBack()
	end)
end

function var0_0.DestroyHistory(arg0_14)
	for iter0_14, iter1_14 in ipairs(arg0_14.history) do
		if not isa(iter1_14, NewBattleResultStatisticsPage) then
			iter1_14:Destroy()
		end
	end
end

function var0_0.GoBack(arg0_15)
	local function var0_15()
		arg0_15.backSceneHandler = NewBattleResultBackSceneHandler.New(arg0_15.contextData)

		arg0_15.backSceneHandler:Execute()
	end

	if arg0_15.contextData.needHelpMessage then
		arg0_15:emit(NewBattleResultMediator.OPEN_FIALED_HELP, var0_15)
	else
		var0_15()
	end
end

function var0_0.onBackPressed(arg0_17)
	return
end

function var0_0.willExit(arg0_18)
	pg.UIMgr:GetInstance():UnblurPanel(arg0_18._tf, arg0_18._parentTf)

	if arg0_18.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_18.camEventId)

		arg0_18.camEventId = nil
	end

	if arg0_18.backSceneHandler then
		arg0_18.backSceneHandler:Dispose()

		arg0_18.backSceneHandler = nil
	end

	if arg0_18.history then
		for iter0_18, iter1_18 in ipairs(arg0_18.history) do
			iter1_18:Destroy()
		end

		arg0_18.history = nil
	end
end

return var0_0
