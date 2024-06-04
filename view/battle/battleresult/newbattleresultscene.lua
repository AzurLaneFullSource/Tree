local var0 = class("NewBattleResultScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "NewBattleResultEmptyUI"
end

function var0.didEnter(arg0)
	arg0._parentTf = arg0._tf.parent

	arg0:InitData()
	arg0:Adjustion()
	arg0:SetUp(arg0.pages)

	if arg0.contextData.needVibrate then
		arg0:Vibrate()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, true, {
		lockGlobalBlur = true,
		groupName = LayerWeightConst.GROUP_COMBAT
	})
	onDelayTick(function()
		if arg0.contextData.needCloseCamera then
			arg0:CloseCamera()
		end
	end, 0.2)
end

function var0.Adjustion(arg0)
	local var0 = GetComponent(arg0._tf, typeof(AspectRatioFitter))

	var0.enabled = true
	var0.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0, arg1)
		var0.aspectRatio = arg1
	end)
end

local function var1(arg0)
	if getProxy(SettingsProxy):IsDisplayResultPainting() then
		return
	end

	for iter0 = #arg0, 1, -1 do
		if arg0[iter0] == NewBattleResultDisplayPaintingsPage then
			table.remove(arg0, iter0)
		end
	end
end

function var0.InitData(arg0)
	arg0.pages = NewBattleResultSystem2Pages[arg0.contextData.system] or {
		NewBattleResultGradePage,
		NewBattleResultDisplayAwardPage,
		NewBattleResultDisplayPaintingsPage,
		NewBattleResultStatisticsPage
	}

	var1(arg0.pages)

	arg0.contextData.oldMainShips = NewBattleResultUtil.RemoveNonStatisticShips(arg0.contextData.oldMainShips, arg0.contextData.statistics)
	arg0.contextData.newMainShips = NewBattleResultDataExtender.GetNewMainShips(arg0.contextData)
	arg0.contextData.autoSkipFlag = NewBattleResultDataExtender.GetAutoSkipFlag(arg0.contextData, arg0.contextData.system)
	arg0.contextData.needVibrate = NewBattleResultDataExtender.NeedVibrate(arg0.contextData.autoSkipFlag)
	arg0.contextData.needCloseCamera = NewBattleResultDataExtender.NeedCloseCamera(arg0.contextData.system)
	arg0.contextData.needHelpMessage = NewBattleResultDataExtender.NeedHelpMessage(arg0.contextData.system, arg0.contextData.score)
	arg0.contextData.expBuff = NewBattleResultDataExtender.GetExpBuffs(arg0.contextData.system)
	arg0.contextData.buffShips = NewBattleResultDataExtender.GetShipBuffs(arg0.contextData.system)
end

function var0.CloseCamera(arg0)
	ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCemera(false)
end

function var0.Vibrate(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
	LuaHelper.Vibrate()
end

function var0.SetUp(arg0, arg1)
	local var0 = {}

	arg0.history = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var0, function(arg0)
			if arg0.exited then
				return
			end

			local var0 = iter1.New(arg0._tf, arg0.event, arg0.contextData)

			var0:ExecuteAction("SetUp", arg0, function()
				arg0:DestroyHistory()
			end)
			table.insert(arg0.history, var0)
		end)
	end

	seriesAsync(var0, function()
		arg0:GoBack()
	end)
end

function var0.DestroyHistory(arg0)
	for iter0, iter1 in ipairs(arg0.history) do
		if not isa(iter1, NewBattleResultStatisticsPage) then
			iter1:Destroy()
		end
	end
end

function var0.GoBack(arg0)
	local function var0()
		arg0.backSceneHandler = NewBattleResultBackSceneHandler.New(arg0.contextData)

		arg0.backSceneHandler:Execute()
	end

	if arg0.contextData.needHelpMessage then
		arg0:emit(NewBattleResultMediator.OPEN_FIALED_HELP, var0)
	else
		var0()
	end
end

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	pg.UIMgr:GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

	if arg0.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0.camEventId)

		arg0.camEventId = nil
	end

	if arg0.backSceneHandler then
		arg0.backSceneHandler:Dispose()

		arg0.backSceneHandler = nil
	end

	if arg0.history then
		for iter0, iter1 in ipairs(arg0.history) do
			iter1:Destroy()
		end

		arg0.history = nil
	end
end

return var0
