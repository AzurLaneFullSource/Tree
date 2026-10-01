local var0_0 = class("NewBattleResultScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewBattleResultEmptyUI"
end

function var0_0.getGroupName(arg0_2)
	return "BattleScene"
end

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = {
		"ui/battleresult_atlas",
		"battleresultitems/resulteffect",
		"ui/newbattleresultstatisticspage",
		"ui/zhandoujiesuan_xingxing",
		"battleresultitems/ship",
		"battleresultitems/mvpbg",
		"battleresultitems/ship",
		"battleresultitems/mvp",
		"battleresultitems/metabtn",
		"battleresultitems/levelup",
		"battleresultitems/bommander",
		"battleresultitems/failedpainting"
	}

	if NewBattleResultYumiaMaterialPage.NeedShowYumiaMaterailDrop(arg0_3.contextData.drops) then
		table.insertto(var0_3, arg0_3:GetYumiaMaterialRes(arg1_3))
	else
		table.insertto(var0_3, arg0_3:GetNormalRes(arg1_3))
	end

	table.insertto(var0_3, var0_0.super.getResource(arg0_3))

	return var0_3
end

function var0_0.GetYumiaMaterialRes(arg0_4, arg1_4)
	local var0_4 = {}

	table.insertto(var0_4, arg0_4:GetGradePageRes())
	table.insertto(var0_4, arg0_4:GetDisplayAwardPageRes())
	table.insertto(var0_4, arg0_4:GetDisplayPaintingsPageRes(arg1_4))
	table.insertto(var0_4, arg0_4:GetStatisticsPageRes(arg1_4))
	table.insertto(var0_4, arg0_4:GetYumiaMaterialPageRes())

	return var0_4
end

function var0_0.GetNormalRes(arg0_5, arg1_5)
	local var0_5 = {}

	table.insertto(var0_5, arg0_5:GetGradePageRes())
	table.insertto(var0_5, arg0_5:GetDisplayAwardPageRes())
	table.insertto(var0_5, arg0_5:GetDisplayPaintingsPageRes(arg1_5))
	table.insertto(var0_5, arg0_5:GetStatisticsPageRes(arg1_5))

	return var0_5
end

function var0_0.GetGradePageRes(arg0_6)
	local var0_6 = {
		"ui/newbattleresultgradepage",
		"battleresultitems/victory",
		"battleresultitems/failed"
	}
	local var1_6 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}

	for iter0_6, iter1_6 in ipairs(var1_6) do
		table.insert(var0_6, "battlescore/battle_score_" .. iter1_6 .. "/letter_" .. iter1_6)
		table.insert(var0_6, "battlescore/battle_score_" .. iter1_6 .. "/label_" .. iter1_6)
	end

	local var2_6 = var1_6[2]
	local var3_6 = "flag_destroy"

	table.insert(var0_6, "battlescore/battle_score_" .. var2_6 .. "/label_" .. var3_6)

	return var0_6
end

function var0_0.GetDisplayAwardPageRes(arg0_7)
	return {}
end

function var0_0.GetDisplayPaintingsPageRes(arg0_8, arg1_8)
	local var0_8 = {
		"ui/newbattleresultdisplaypaintingspages"
	}
	local var1_8 = arg1_8.oldMainShips

	for iter0_8, iter1_8 in ipairs(var1_8) do
		local var2_8 = iter1_8:getPainting()

		table.insert(var0_8, "painting/" .. var2_8 .. "_n")
		table.insert(var0_8, "paintingface/" .. var2_8)
		table.insert(var0_8, "squareicon/" .. var2_8)
	end

	return var0_8
end

function var0_0.GetStatisticsPageRes(arg0_9, arg1_9)
	local var0_9 = {
		"ui/newbattleresultstatisticspage",
		"battleresultitems/commander",
		"ui/BattleResultMetaExpUI"
	}
	local var1_9 = arg1_9.oldMainShips

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var2_9 = iter1_9:getPainting()

		table.insert(var0_9, "herohrzicon/" .. var2_9)
	end

	local var3_9 = arg1_9.commanderExps or {}
	local var4_9 = var3_9.surfaceCMD or var3_9.submarineCMD or {}

	for iter2_9 = 1, #var4_9 do
		local var5_9 = getProxy(CommanderProxy):getCommanderById(var4_9[iter2_9].commander_id)

		table.insert(var0_9, "commandericon/" .. var5_9:getPainting())
	end

	return var0_9
end

function var0_0.GetYumiaMaterialPageRes(arg0_10)
	return {
		"ui/newbattleresultyumiarewardpages"
	}
end

function var0_0.didEnter(arg0_11)
	arg0_11._parentTf = arg0_11._tf.parent

	arg0_11:InitData()
	arg0_11:Adjustion()
	arg0_11:SetUp(arg0_11.pages)

	if arg0_11.contextData.needVibrate then
		arg0_11:Vibrate()
	end

	arg0_11:BlurPanel(arg0_11._tf, {
		staticBlur = true,
		lockGlobalBlur = true
	})
	onDelayTick(function()
		if arg0_11.contextData.needCloseCamera then
			arg0_11:CloseCamera()
		end
	end, 0.2)
end

function var0_0.Adjustion(arg0_13)
	local var0_13 = GetComponent(arg0_13._tf, typeof(AspectRatioFitter))

	var0_13.enabled = true
	var0_13.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0_13.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_14, arg1_14)
		var0_13.aspectRatio = arg1_14
	end)
end

local function var1_0(arg0_15)
	if getProxy(SettingsProxy):IsDisplayResultPainting() then
		return
	end

	for iter0_15 = #arg0_15, 1, -1 do
		if arg0_15[iter0_15] == NewBattleResultDisplayPaintingsPage then
			table.remove(arg0_15, iter0_15)
		end
	end
end

function var0_0.InitData(arg0_16)
	local var0_16 = NewBattleResultYumiaMaterialPage.NeedShowYumiaMaterailDrop(arg0_16.contextData.drops) and {
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

	arg0_16.pages = NewBattleResultSystem2Pages[arg0_16.contextData.system] or var0_16

	var1_0(arg0_16.pages)

	arg0_16.contextData.oldMainShips = NewBattleResultUtil.RemoveNonStatisticShips(arg0_16.contextData.oldMainShips, arg0_16.contextData.statistics)
	arg0_16.contextData.newMainShips = NewBattleResultDataExtender.GetNewMainShips(arg0_16.contextData)
	arg0_16.contextData.autoSkipFlag = NewBattleResultDataExtender.GetAutoSkipFlag(arg0_16.contextData, arg0_16.contextData.system)
	arg0_16.contextData.needVibrate = NewBattleResultDataExtender.NeedVibrate(arg0_16.contextData.autoSkipFlag)
	arg0_16.contextData.needCloseCamera = NewBattleResultDataExtender.NeedCloseCamera(arg0_16.contextData.system)
	arg0_16.contextData.needHelpMessage = NewBattleResultDataExtender.NeedHelpMessage(arg0_16.contextData.system, arg0_16.contextData.score)
	arg0_16.contextData.expBuff = NewBattleResultDataExtender.GetExpBuffs(arg0_16.contextData.system)
	arg0_16.contextData.buffShips = NewBattleResultDataExtender.GetShipBuffs(arg0_16.contextData.system)
end

function var0_0.CloseCamera(arg0_17)
	ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCamera(false)
end

function var0_0.Vibrate(arg0_18)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
	LuaHelper.Vibrate()
end

function var0_0.SetUp(arg0_19, arg1_19)
	local var0_19 = {}

	arg0_19.history = {}

	for iter0_19, iter1_19 in ipairs(arg1_19) do
		table.insert(var0_19, function(arg0_20)
			if arg0_19.exited then
				return
			end

			local var0_20 = iter1_19.New(arg0_19._tf, arg0_19.event, arg0_19.contextData)

			var0_20:ExecuteAction("SetUp", arg0_20, function()
				arg0_19:DestroyHistory()
			end)
			table.insert(arg0_19.history, var0_20)
		end)
	end

	seriesAsync(var0_19, function()
		arg0_19:GoBack()
	end)
end

function var0_0.DestroyHistory(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.history) do
		if not isa(iter1_23, NewBattleResultStatisticsPage) then
			iter1_23:Destroy()
		end
	end
end

function var0_0.GoBack(arg0_24)
	local function var0_24()
		arg0_24.backSceneHandler = NewBattleResultBackSceneHandler.New(arg0_24.contextData)

		arg0_24.backSceneHandler:Execute()
	end

	if arg0_24.contextData.needHelpMessage then
		arg0_24:emit(NewBattleResultMediator.OPEN_FIALED_HELP, var0_24)
	else
		var0_24()
	end
end

function var0_0.onBackPressed(arg0_26)
	return
end

function var0_0.willExit(arg0_27)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_27._tf, arg0_27._parentTf)

	if arg0_27.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_27.camEventId)

		arg0_27.camEventId = nil
	end

	if arg0_27.backSceneHandler then
		arg0_27.backSceneHandler:Dispose()

		arg0_27.backSceneHandler = nil
	end

	if arg0_27.history then
		for iter0_27, iter1_27 in ipairs(arg0_27.history) do
			iter1_27:Destroy()
		end

		arg0_27.history = nil
	end
end

return var0_0
