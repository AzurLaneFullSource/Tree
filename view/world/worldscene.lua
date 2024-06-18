local var0_0 = class("WorldScene", import("..base.BaseUI"))

var0_0.SceneOp = "WorldScene.SceneOp"
var0_0.Listeners = {
	onAchievementAchieved = "OnAchievementAchieved",
	onUpdateEventTips = "OnUpdateEventTips",
	onSelectFleet = "OnSelectFleet",
	onUpdateSubmarineSupport = "OnUpdateSubmarineSupport",
	onClearMoveQueue = "ClearMoveQueue",
	onModelSelectMap = "OnModelSelectMap",
	onUpdateDaily = "OnUpdateDaily",
	onUpdateProgress = "OnUpdateProgress",
	onUpdateScale = "OnUpdateScale",
	onUpdateRound = "OnUpdateRound",
	onDisposeMap = "OnDisposeMap",
	onFleetSelected = "OnFleetSelected"
}
var0_0.optionsPath = {
	"top/adapt/top_chapter/option",
	"top/adapt/top_stage/option"
}

function var0_0.forceGC(arg0_1)
	return true
end

function var0_0.getUIName(arg0_2)
	return "WorldUI"
end

function var0_0.getBGM(arg0_3)
	local var0_3 = {}

	if arg0_3:GetInMap() == false then
		-- block empty
	else
		table.insert(var0_3, nowWorld():GetActiveMap():GetBGM() or "")
	end

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if iter1_3 ~= "" then
			return iter1_3
		end
	end

	return var0_0.super.getBGM(arg0_3)
end

function var0_0.init(arg0_4)
	for iter0_4, iter1_4 in pairs(var0_0.Listeners) do
		arg0_4[iter0_4] = function(...)
			var0_0[iter1_4](arg0_4, ...)
		end
	end

	arg0_4:bind(var0_0.SceneOp, function(arg0_6, ...)
		arg0_4:Op(...)
	end)

	local var0_4 = pg.UIMgr.GetInstance()

	arg0_4.camera = var0_4.levelCamera:GetComponent(typeof(Camera))
	arg0_4.rtUIMain = var0_4.LevelMain

	setActive(arg0_4.rtUIMain, false)

	arg0_4.rtGrid = arg0_4.rtUIMain:Find("LevelGrid")

	setActive(arg0_4.rtGrid, true)

	arg0_4.rtDragLayer = arg0_4.rtGrid:Find("DragLayer")
	arg0_4.rtEnvBG = arg0_4._tf:Find("main/bg")
	arg0_4.rtTop = arg0_4._tf:Find("top")
	arg0_4.rtTopAtlas = arg0_4.rtTop:Find("adapt/top_chapter")

	setActive(arg0_4.rtTopAtlas, false)

	arg0_4.rtRightAtlas = arg0_4.rtTop:Find("adapt/right_chapter")

	setActive(arg0_4.rtRightAtlas, false)

	arg0_4.rtBottomAtlas = arg0_4.rtTop:Find("adapt/bottom_chapter")

	setActive(arg0_4.rtBottomAtlas, false)

	arg0_4.rtTransportAtlas = arg0_4.rtTop:Find("transport_chapter")

	setActive(arg0_4.rtTransportAtlas, false)

	arg0_4.rtTopMap = arg0_4.rtTop:Find("adapt/top_stage")

	setActive(arg0_4.rtTopMap, false)

	arg0_4.rtLeftMap = arg0_4.rtTop:Find("adapt/left_stage")

	setActive(arg0_4.rtLeftMap, false)

	arg0_4.rtRightMap = arg0_4.rtTop:Find("adapt/right_stage")

	setActive(arg0_4.rtRightMap, false)

	arg0_4.rtOutMap = arg0_4.rtTop:Find("effect_stage")

	setActive(arg0_4.rtOutMap, false)

	arg0_4.rtClickStop = arg0_4.rtTop:Find("stop_click")

	onButton(arg0_4, arg0_4.rtClickStop:Find("long_move"), function()
		if #arg0_4.moveQueue > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_fleet_stop"))
			arg0_4:ClearMoveQueue()
		end
	end)
	onButton(arg0_4, arg0_4.rtClickStop:Find("auto_fight"), function()
		local var0_8 = nowWorld()

		if var0_8.isAutoFight then
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_stop"))
			var0_8:TriggerAutoFight(false)
		else
			assert(false, "stop clicker shouldn't active")
		end
	end)
	setActive(arg0_4.rtClickStop, false)

	arg0_4.resAtlas = WorldResource.New()

	arg0_4.resAtlas:setParent(arg0_4.rtTopAtlas:Find("resources"), false)

	arg0_4.resMap = WorldResource.New()

	arg0_4.resMap:setParent(arg0_4.rtTopMap:Find("resources"), false)

	arg0_4.wsPool = WSPool.New()

	arg0_4.wsPool:Setup(arg0_4:findTF("resources"))

	arg0_4.wsAnim = WSAnim.New()

	arg0_4.wsAnim:Setup()

	arg0_4.wsTimer = WSTimer.New()

	arg0_4.wsTimer:Setup()

	arg0_4.wsDragProxy = WSDragProxy.New()
	arg0_4.wsDragProxy.transform = arg0_4.rtDragLayer
	arg0_4.wsDragProxy.wsTimer = arg0_4.wsTimer

	arg0_4.wsDragProxy:Setup({
		clickCall = function(arg0_9, arg1_9)
			if arg0_4.svScannerPanel:isShowing() then
				local var0_9, var1_9 = arg0_4:CheckScannerEnable(arg0_4:ScreenPos2MapPos(arg1_9.position))

				if var0_9 then
					arg0_4.svScannerPanel:ActionInvoke("DisplayWindow", var0_9, var1_9)
				else
					arg0_4.svScannerPanel:ActionInvoke("HideWindow")
				end
			else
				arg0_4:OnClickMap(arg0_4:ScreenPos2MapPos(arg1_9.position))
			end
		end,
		longPressCall = function()
			arg0_4:OnLongPressMap(arg0_4:ScreenPos2MapPos(Vector3(Input.mousePosition.x, Input.mousePosition.y)))
		end
	})

	arg0_4.wsMapCamera = WSMapCamera.New()
	arg0_4.wsMapCamera.camera = arg0_4.camera

	arg0_4.wsMapCamera:Setup()
	arg0_4:InitSubView()
	arg0_4:AddWorldListener()

	arg0_4.moveQueue = {}
	arg0_4.achievedList = {}
	arg0_4.mapOps = {}
	arg0_4.wsCommands = {}

	WSCommand.Bind(arg0_4)
	arg0_4:OpOpen()
end

function var0_0.InitSubView(arg0_11)
	arg0_11.rtPanelList = arg0_11:findTF("panel_list")
	arg0_11.svOrderPanel = SVOrderPanel.New(arg0_11.rtPanelList, arg0_11.event, {
		wsPool = arg0_11.wsPool
	})
	arg0_11.svScannerPanel = SVScannerPanel.New(arg0_11.rtPanelList, arg0_11.event)

	arg0_11:bind(SVScannerPanel.ShowView, function(arg0_12)
		arg0_11.wsMap:ShowScannerMap(true)
		setActive(arg0_11.wsMap.rtTop, false)
		arg0_11:HideMapUI()
	end)
	arg0_11:bind(SVScannerPanel.HideView, function(arg0_13)
		arg0_11.wsMap:ShowScannerMap(false)
		setActive(arg0_11.wsMap.rtTop, true)
		arg0_11:DisplayMapUI()
	end)
	arg0_11:bind(SVScannerPanel.HideGoing, function(arg0_14, arg1_14, arg2_14)
		arg0_11.wsMap:ShowScannerMap(false)
		setActive(arg0_11.wsMap.rtTop, true)
		arg0_11:DisplayMapUI()
		arg0_11:OnClickCell(arg1_14, arg2_14)
	end)

	arg0_11.svRealmPanel = SVRealmPanel.New(arg0_11.rtPanelList, arg0_11.event)
	arg0_11.svAchievement = SVAchievement.New(arg0_11.rtPanelList, arg0_11.event)

	arg0_11:bind(SVAchievement.HideView, function(arg0_15)
		table.remove(arg0_11.achievedList, 1)

		return (#arg0_11.achievedList > 0 and function()
			arg0_11:ShowSubView("Achievement", arg0_11.achievedList[1])
		end or function()
			arg0_11:Op("OpInteractive")
		end)()
	end)

	arg0_11.svDebugPanel = SVDebugPanel.New(arg0_11.rtPanelList, arg0_11.event)
	arg0_11.svFloatPanel = SVFloatPanel.New(arg0_11.rtTop, arg0_11.event)

	arg0_11:bind(SVFloatPanel.ReturnCall, function(arg0_18, arg1_18)
		arg0_11:Op("OpCall", function(arg0_19)
			arg0_19()

			local var0_19 = nowWorld():GetActiveEntrance()

			if arg1_18.id == var0_19.id then
				arg0_11.wsAtlas:UpdateSelect()
				arg0_11.wsAtlas:UpdateSelect(arg1_18)
			else
				arg0_11:ClickAtlas(var0_19)
			end
		end)
	end)

	arg0_11.svPoisonPanel = SVPoisonPanel.New(arg0_11.rtPanelList, arg0_11.event)
	arg0_11.svGlobalBuff = SVGlobalBuff.New(arg0_11.rtPanelList, arg0_11.event)

	arg0_11:bind(SVGlobalBuff.HideView, function(arg0_20, arg1_20)
		return existCall(arg1_20)
	end)

	arg0_11.svBossProgress = SVBossProgress.New(arg0_11.rtPanelList, arg0_11.event)

	arg0_11:bind(SVBossProgress.HideView, function(arg0_21, arg1_21)
		return existCall(arg1_21)
	end)

	arg0_11.svSalvageResult = SVSalvageResult.New(arg0_11.rtPanelList, arg0_11.event)
end

function var0_0.didEnter(arg0_22)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_22.rtTop)

	arg0_22.warningSairen = not arg0_22.contextData.inSave

	if arg0_22.contextData.inWorld then
		arg0_22:Op("OpSetInMap", false, function()
			arg0_22.wsAtlas:UpdateSelect(nowWorld():GetActiveEntrance())
		end)
	else
		arg0_22:Op("OpSetInMap", true)
	end
end

function var0_0.onBackPressed(arg0_24)
	if arg0_24.inCutIn then
		return
	elseif arg0_24.svDebugPanel:isShowing() then
		arg0_24:HideSubView("DebugPanel")
	elseif arg0_24.svAchievement:isShowing() then
		arg0_24:HideSubView("Achievement")
	elseif arg0_24.svGlobalBuff:isShowing() then
		arg0_24:HideSubView("GlobalBuff")
	elseif arg0_24.svBossProgress:isShowing() then
		arg0_24:HideSubView("BossProgress")
	elseif arg0_24.svOrderPanel:isShowing() then
		arg0_24:HideSubView("OrderPanel")
	elseif arg0_24.svScannerPanel:isShowing() then
		arg0_24:HideSubView("ScannerPanel")
	elseif arg0_24.svPoisonPanel:isShowing() then
		arg0_24:HideSubView("PoisonPanel")
	elseif arg0_24.svSalvageResult:isShowing() then
		arg0_24:HideSubView("SalvageResult")
	elseif arg0_24.wsMapLeft and isActive(arg0_24.wsMapLeft.toggleMask) then
		arg0_24.wsMapLeft:HideToggleMask()
	elseif arg0_24:GetInMap() then
		triggerButton(arg0_24.wsMapTop.btnBack)
	else
		triggerButton(arg0_24.rtTopAtlas:Find("back_button"))
	end
end

function var0_0.quickExitFunc(arg0_25)
	arg0_25:Op("OpCall", function(arg0_26)
		arg0_26()

		local var0_26 = {}

		if nowWorld():CheckReset() then
			table.insert(var0_26, function(arg0_27)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_recycle_notice"),
					onYes = arg0_27
				})
			end)
		end

		seriesAsync(var0_26, function()
			var0_0.super.quickExitFunc(arg0_25)
		end)
	end)
end

function var0_0.ExitWorld(arg0_29, arg1_29, arg2_29)
	local var0_29 = {}

	if not arg2_29 then
		table.insert(var0_29, function(arg0_30)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_exit_tip"),
				onYes = arg0_30,
				onNo = function()
					return existCall(arg1_29)
				end
			})
		end)
	end

	if not arg2_29 and nowWorld():CheckReset() then
		table.insert(var0_29, function(arg0_32)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_recycle_notice"),
				onYes = arg0_32,
				onNo = function()
					return existCall(arg1_29)
				end
			})
		end)
	end

	table.insert(var0_29, function(arg0_34)
		if arg0_29:GetInMap() then
			arg0_29:EaseOutMapUI(arg0_34)
		else
			arg0_29:EaseOutAtlasUI(arg0_34)
		end
	end)
	seriesAsync(var0_29, function()
		existCall(arg1_29)
		arg0_29:closeView()
	end)
end

function var0_0.SaveState(arg0_36)
	arg0_36.contextData.inSave = true
	arg0_36.contextData.inWorld = arg0_36:GetInMap() == false
	arg0_36.contextData.inShop = false
	arg0_36.contextData.inPort = false
end

function var0_0.willExit(arg0_37)
	arg0_37:SaveState()
	arg0_37:RemoveWorldListener()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_37.rtTop, arg0_37._tf)
	arg0_37.svOrderPanel:Destroy()
	arg0_37.svScannerPanel:Destroy()
	arg0_37.svAchievement:Destroy()
	arg0_37.svRealmPanel:Destroy()
	arg0_37.svDebugPanel:Destroy()
	arg0_37.svFloatPanel:Destroy()
	arg0_37.svPoisonPanel:Destroy()
	arg0_37.svGlobalBuff:Destroy()
	arg0_37.svBossProgress:Destroy()
	arg0_37:DisposeAtlas()
	arg0_37:DisposeAtlasUI()
	arg0_37:DisposeMap()
	arg0_37:DisposeMapUI()
	arg0_37.wsPool:Dispose()

	arg0_37.wsPool = nil

	arg0_37.wsAnim:Dispose()

	arg0_37.wsAnim = nil

	arg0_37.wsTimer:Dispose()

	arg0_37.wsTimer = nil

	arg0_37.wsDragProxy:Dispose()

	arg0_37.wsDragProxy = nil

	arg0_37.wsMapCamera:Dispose()

	arg0_37.wsMapCamera = nil

	arg0_37.resAtlas:exit()

	arg0_37.resAtlas = nil

	arg0_37.resMap:exit()

	arg0_37.resMap = nil

	arg0_37:VerifyMapOp()
	arg0_37:OpDispose()
	WSCommand.Unbind(arg0_37)
	WBank:Recycle(WorldMapOp)
end

function var0_0.SetPlayer(arg0_38, arg1_38)
	arg0_38.player = arg1_38

	arg0_38.resAtlas:setPlayer(arg0_38.player)
	arg0_38.resMap:setPlayer(arg0_38.player)
end

function var0_0.AddWorldListener(arg0_39)
	local var0_39 = nowWorld()

	var0_39:AddListener(World.EventUpdateProgress, arg0_39.onUpdateProgress)
	var0_39:GetTaskProxy():AddListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0_39.onUpdateDaily)
end

function var0_0.RemoveWorldListener(arg0_40)
	local var0_40 = nowWorld()

	var0_40:RemoveListener(World.EventUpdateProgress, arg0_40.onUpdateProgress)
	var0_40:GetTaskProxy():RemoveListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0_40.onUpdateDaily)
end

function var0_0.SetInMap(arg0_41, arg1_41, arg2_41)
	if arg1_41 then
		arg2_41 = defaultValue(arg2_41, function()
			arg0_41:Op("OpInteractive")
		end)
	end

	if arg0_41.inMap == arg1_41 then
		return existCall(arg2_41)
	end

	local var0_41 = {}
	local var1_41 = {}

	arg0_41:StopAnim()

	if arg0_41.inMap then
		table.insert(var0_41, function(arg0_43)
			arg0_41:Op("OpSwitchOutMap", arg0_43)
		end)
	elseif arg0_41.inMap ~= nil then
		table.insert(var0_41, function(arg0_44)
			arg0_41:Op("OpSwitchOutWorld", arg0_44)
		end)
	end

	table.insert(var0_41, function(arg0_45)
		arg0_41:Op("OpCall", function(arg0_46)
			parallelAsync(var1_41, function()
				arg0_46()

				return arg0_45()
			end)
		end)
	end)
	table.insert(var1_41, function(arg0_48)
		arg0_41:DisplayEnv(arg0_48)
	end)

	if arg1_41 then
		table.insert(var1_41, function(arg0_49)
			arg0_41:LoadMap(nowWorld():GetActiveMap(), arg0_49)
		end)
		table.insert(var0_41, function(arg0_50)
			arg0_41:Op("OpSwitchInMap", arg0_50)
		end)
	else
		table.insert(var1_41, function(arg0_51)
			arg0_41:LoadAtlas(arg0_51)
		end)
		table.insert(var0_41, function(arg0_52)
			arg0_41:Op("OpSwitchInWorld", arg0_52)
		end)
	end

	table.insert(var0_41, function(arg0_53)
		arg0_41:PlayBGM()
		arg0_53()
	end)

	arg0_41.inMap = arg1_41

	seriesAsync(var0_41, arg2_41)
end

function var0_0.GetInMap(arg0_54)
	return arg0_54.inMap
end

function var0_0.ShowSubView(arg0_55, arg1_55, arg2_55, arg3_55)
	local var0_55 = arg0_55["sv" .. arg1_55]

	var0_55:Load()
	var0_55:ActionInvoke("Setup", unpack(arg2_55 or {}))
	var0_55:ActionInvoke("Show", unpack(arg3_55 or {}))
end

function var0_0.HideSubView(arg0_56, arg1_56, ...)
	arg0_56["sv" .. arg1_56]:ActionInvoke("Hide", ...)
end

function var0_0.DisplayAtlasUI(arg0_57)
	arg0_57:DisplayAtlasTop()
	arg0_57:DisplayAtlasRight()
	arg0_57:DisplayAtlasBottom()
	arg0_57:UpdateSystemOpen()
end

function var0_0.HideAtlasUI(arg0_58)
	arg0_58:HideAtlasTop()
	arg0_58:HideAtlasRight()
	arg0_58:HideAtlasBottom()
end

function var0_0.EaseInAtlasUI(arg0_59, arg1_59)
	arg0_59:CancelAtlasUITween()
	parallelAsync({
		function(arg0_60)
			setAnchoredPosition(arg0_59.rtTopAtlas, {
				y = arg0_59.rtTopAtlas.rect.height
			})
			arg0_59.wsTimer:AddTween(LeanTween.moveY(arg0_59.rtTopAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_60)).uniqueId)
		end,
		function(arg0_61)
			setAnchoredPosition(arg0_59.rtBottomAtlas, {
				y = -arg0_59.rtBottomAtlas.rect.height
			})
			arg0_59.wsTimer:AddTween(LeanTween.moveY(arg0_59.rtBottomAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_61)).uniqueId)
		end,
		function(arg0_62)
			setAnchoredPosition(arg0_59.rtRightAtlas, {
				x = arg0_59.rtRightAtlas.rect.width
			})
			arg0_59.wsTimer:AddTween(LeanTween.moveX(arg0_59.rtRightAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_62)).uniqueId)
		end
	}, function()
		return existCall(arg1_59)
	end)
end

function var0_0.EaseOutAtlasUI(arg0_64, arg1_64)
	arg0_64:CancelAtlasUITween()
	parallelAsync({
		function(arg0_65)
			setAnchoredPosition(arg0_64.rtTopAtlas, {
				y = 0
			})
			arg0_64.wsTimer:AddTween(LeanTween.moveY(arg0_64.rtTopAtlas, arg0_64.rtTopAtlas.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_65)).uniqueId)
		end,
		function(arg0_66)
			setAnchoredPosition(arg0_64.rtBottomAtlas, {
				y = 0
			})
			arg0_64.wsTimer:AddTween(LeanTween.moveY(arg0_64.rtBottomAtlas, -arg0_64.rtBottomAtlas.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_66)).uniqueId)
		end,
		function(arg0_67)
			setAnchoredPosition(arg0_64.rtRightAtlas, {
				x = 0
			})
			arg0_64.wsTimer:AddTween(LeanTween.moveX(arg0_64.rtRightAtlas, arg0_64.rtRightAtlas.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_67)).uniqueId)
		end
	}, function()
		return existCall(arg1_64)
	end)
end

function var0_0.CancelAtlasUITween(arg0_69)
	LeanTween.cancel(go(arg0_69.rtTransportAtlas))
	LeanTween.cancel(go(arg0_69.rtTopAtlas))
	LeanTween.cancel(go(arg0_69.rtBottomAtlas))
	LeanTween.cancel(go(arg0_69.rtRightAtlas))
end

function var0_0.DisposeAtlasUI(arg0_70)
	arg0_70:HideAtlasUI()
	arg0_70:DisposeAtlasTransport()
	arg0_70:DisposeAtlasTop()
	arg0_70:DisposeAtlasRight()
	arg0_70:DisposeAtlasBottom()
end

function var0_0.DisplayAtlas(arg0_71)
	local var0_71 = nowWorld():GetActiveEntrance()

	arg0_71.wsAtlas:SwitchArea(var0_71:GetAreaId())
	arg0_71.wsAtlas:UpdateActiveMark()
	arg0_71.wsAtlas:ShowOrHide(true)
end

function var0_0.HideAtlas(arg0_72)
	arg0_72.wsAtlas:UpdateSelect()
	arg0_72.wsAtlas:ShowOrHide(false)
end

function var0_0.ClickAtlas(arg0_73, arg1_73)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

	local var0_73 = arg1_73:GetAreaId()

	if not nowWorld():CheckAreaUnlock(var0_73) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("area_lock"))

		return
	end

	if arg0_73.wsAtlas.nowArea then
		arg0_73.wsAtlas:UpdateSelect()

		if arg0_73.wsAtlas.selectEntrance ~= arg1_73 then
			arg0_73.wsAtlas:UpdateSelect(arg1_73)
		end
	else
		arg0_73:EnterToModelMap(var0_73)
	end
end

function var0_0.LoadAtlas(arg0_74, arg1_74)
	local var0_74 = {}

	if not arg0_74.wsAtlas then
		table.insert(var0_74, function(arg0_75)
			arg0_74.wsAtlas = arg0_74:NewAtlas()

			arg0_74.wsAtlas:LoadScene(function()
				arg0_74.wsAtlas:AddListener(WSAtlasWorld.EventUpdateselectEntrance, arg0_74.onModelSelectMap)
				arg0_74.wsAtlas:UpdateAtlas(nowWorld():GetAtlas())

				return arg0_75()
			end)
		end)
	end

	seriesAsync(var0_74, arg1_74)
end

function var0_0.NewAtlas(arg0_77)
	local var0_77 = WSAtlasWorld.New()

	var0_77.wsTimer = arg0_77.wsTimer

	function var0_77.onClickColor(arg0_78, arg1_78)
		if arg0_77.wsAtlas:CheckIsTweening() then
			return
		end

		arg0_77:Op("OpCall", function(arg0_79)
			arg0_79()
			arg0_77:ClickAtlas(arg0_78)
		end)
	end

	var0_77:Setup()

	return var0_77
end

function var0_0.DisposeAtlas(arg0_80)
	if arg0_80.wsAtlas then
		arg0_80:HideAtlas()
		arg0_80.wsAtlas:RemoveListener(WSAtlasWorld.EventUpdateselectEntrance, arg0_80.onModelSelectMap)
		arg0_80.wsAtlas:Dispose()

		arg0_80.wsAtlas = nil
	end
end

function var0_0.DisplayAtlasTop(arg0_81)
	arg0_81.wsAtlasTop = arg0_81.wsAtlasTop or arg0_81:NewAtlasTop(arg0_81.rtTopAtlas)

	setActive(arg0_81.rtTopAtlas, true)
	setActive(arg0_81.rtTopAtlas:Find("print/title_world"), true)
	setActive(arg0_81.rtTopAtlas:Find("print/title_view"), false)
	setActive(arg0_81.rtTopAtlas:Find("sairen_warning"), arg0_81.warningSairen and #nowWorld():GetAtlas().sairenEntranceList > 0)

	arg0_81.warningSairen = false
end

function var0_0.HideAtlasTop(arg0_82)
	setActive(arg0_82.rtTopAtlas, false)
end

function var0_0.NewAtlasTop(arg0_83, arg1_83)
	local var0_83 = {
		transform = arg1_83
	}

	onButton(arg0_83, arg1_83:Find("back_button"), function()
		arg0_83:Op("OpCall", function(arg0_85)
			arg0_85()
			arg0_83:BackToMap()
		end)
	end, SFX_CANCEL)

	return var0_83
end

function var0_0.DisposeAtlasTop(arg0_86)
	arg0_86.wsAtlasTop = nil
end

function var0_0.DisplayAtlasRight(arg0_87)
	arg0_87.wsAtlasRight = arg0_87.wsAtlasRight or arg0_87:NewAtlasRight(arg0_87.rtRightAtlas)

	arg0_87.wsAtlasRight:SetOverSize(arg0_87.rtTop:Find("adapt").offsetMax.x)
	setActive(arg0_87.rtRightAtlas, true)
end

function var0_0.HideAtlasRight(arg0_88)
	setActive(arg0_88.rtRightAtlas, false)
end

function var0_0.NewAtlasRight(arg0_89, arg1_89, arg2_89)
	local var0_89 = WSAtlasRight.New()

	var0_89.transform = arg1_89

	var0_89:Setup()
	onButton(arg0_89, var0_89.btnSettings, function()
		arg0_89:Op("OpOpenScene", SCENE.SETTINGS, {
			scroll = "world_settings",
			page = NewSettingsScene.PAGE_OPTION
		})
	end, SFX_PANEL)
	onButton(arg0_89, var0_89.btnSwitch, function()
		arg0_89:Op("OpOpenLayer", Context.New({
			mediator = WorldSwitchPlanningMediator,
			viewComponent = WorldSwitchPlanningLayer
		}))
	end, SFX_CONFIRM)

	return var0_89
end

function var0_0.DisposeAtlasRight(arg0_92)
	if arg0_92.wsAtlasRight then
		arg0_92.wsAtlasRight:Dispose()

		arg0_92.wsAtlasRight = nil
	end
end

function var0_0.DisplayAtlasBottom(arg0_93)
	arg0_93.wsAtlasBottom = arg0_93.wsAtlasBottom or arg0_93:NewAtlasBottom(arg0_93.rtBottomAtlas)

	arg0_93.wsAtlasBottom:SetOverSize(arg0_93.rtTop:Find("adapt").offsetMax.x)
	arg0_93.wsAtlasBottom:UpdateScale(1)
	setActive(arg0_93.rtBottomAtlas, true)
	setActive(arg0_93.wsAtlasBottom.btnDailyTask:Find("tip"), nowWorld():GetTaskProxy():canAcceptDailyTask())
end

function var0_0.HideAtlasBottom(arg0_94)
	setActive(arg0_94.rtBottomAtlas, false)
end

function var0_0.NewAtlasBottom(arg0_95, arg1_95)
	local var0_95 = WSAtlasBottom.New()

	var0_95.transform = arg1_95
	var0_95.wsTimer = arg0_95.wsTimer

	var0_95:Setup()

	if CAMERA_MOVE_OPEN then
		var0_95:AddListener(WSAtlasBottom.EventUpdateScale, arg0_95.onUpdateScale)
	end

	onButton(arg0_95, var0_95.btnOverview, function()
		if arg0_95.wsAtlas:CheckIsTweening() then
			return
		end

		arg0_95:Op("OpCall", function(arg0_97)
			arg0_95.wsAtlas:LoadModel(function()
				arg0_97()
				arg0_95:ReturnToModelArea()
			end)
		end)
	end, SFX_PANEL)
	onButton(arg0_95, var0_95.btnBoss, function()
		if nowWorld():GetBossProxy():IsOpen() then
			arg0_95:Op("OpOpenScene", SCENE.WORLDBOSS)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0_95, var0_95.btnShop, function()
		arg0_95:Op("OpOpenLayer", Context.New({
			mediator = WorldShopMediator,
			viewComponent = WorldShopLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_95, var0_95.btnCollection, function()
		arg0_95:Op("OpOpenScene", SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_RECORD
		})
	end, SFX_PANEL)
	onButton(arg0_95, var0_95.btnDailyTask, function()
		local var0_102 = nowWorld()

		if var0_102:IsSystemOpen(WorldConst.SystemDailyTask) then
			var0_102:GetTaskProxy():checkDailyTask(function()
				arg0_95:Op("OpOpenLayer", Context.New({
					mediator = WorldDailyTaskMediator,
					viewComponent = WorldDailyTaskLayer
				}))
			end)
		else
			pg.TipsMgr.GetInstance(i18n("world_daily_task_lock"))
		end
	end, SFX_PANEL)

	return var0_95
end

function var0_0.DisposeAtlasBottom(arg0_104)
	if arg0_104.wsAtlasBottom then
		arg0_104.wsAtlasBottom:Dispose()

		arg0_104.wsAtlasBottom = nil
	end
end

function var0_0.DisplayAtlasTransport(arg0_105)
	arg0_105.wsAtlasTransport = arg0_105.wsAtlasTransport or arg0_105:NewAtlasTransport(arg0_105.rtTransportAtlas)

	setActive(arg0_105.rtTransportAtlas, true)
end

function var0_0.HideAtlasTransport(arg0_106)
	setActive(arg0_106.rtTransportAtlas, false)
end

function var0_0.NewAtlasTransport(arg0_107, arg1_107)
	local var0_107 = {
		transform = arg1_107,
		btnBack = arg1_107:Find("adapt/btn_back")
	}

	onButton(arg0_107, var0_107.btnBack, function()
		assert(arg0_107.inTransportMode, "this isn't transport mode atlas")
		arg0_107:BackToMap()
	end, SFX_CANCEL)

	return var0_107
end

function var0_0.DisposeAtlasTransport(arg0_109)
	arg0_109.wsAtlasTransport = nil
end

function var0_0.DisplayMapUI(arg0_110)
	arg0_110:DisplayMapTop()
	arg0_110:DisplayMapLeft()
	arg0_110:DisplayMapRight()
	arg0_110:DisplayMapOut()
	arg0_110:UpdateSystemOpen()
end

function var0_0.HideMapUI(arg0_111)
	arg0_111:HideMapTop()
	arg0_111:HideMapLeft()
	arg0_111:HideMapRight()
	arg0_111:HideMapOut()
end

function var0_0.UpdateMapUI(arg0_112)
	local var0_112 = nowWorld()
	local var1_112 = var0_112:GetActiveEntrance()
	local var2_112 = var0_112:GetActiveMap()

	arg0_112.wsMapTop:Update(var1_112, var2_112)
	arg0_112.wsMapLeft:UpdateMap(var2_112)
	arg0_112.wsMapRight:Update(var1_112, var2_112)
	arg0_112.wsMapOut:UpdateMap(var2_112)
end

function var0_0.EaseInMapUI(arg0_113, arg1_113)
	arg0_113:CancelMapUITween()
	parallelAsync({
		function(arg0_114)
			setAnchoredPosition(arg0_113.rtTopMap, {
				y = arg0_113.rtTopMap.rect.height
			})
			arg0_113.wsTimer:AddTween(LeanTween.moveY(arg0_113.rtTopMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_114)).uniqueId)
		end,
		function(arg0_115)
			setAnchoredPosition(arg0_113.rtLeftMap, {
				x = -arg0_113.rtLeftMap.rect.width
			})
			arg0_113.wsTimer:AddTween(LeanTween.moveX(arg0_113.rtLeftMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_115)).uniqueId)
		end,
		function(arg0_116)
			setAnchoredPosition(arg0_113.rtRightMap, {
				x = arg0_113.rtRightMap.rect.width
			})
			arg0_113.wsTimer:AddTween(LeanTween.moveX(arg0_113.rtRightMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_116)).uniqueId)
		end
	}, function()
		return existCall(arg1_113)
	end)
end

function var0_0.EaseOutMapUI(arg0_118, arg1_118)
	arg0_118:CancelMapUITween()
	parallelAsync({
		function(arg0_119)
			setAnchoredPosition(arg0_118.rtTopMap, {
				y = 0
			})
			arg0_118.wsTimer:AddTween(LeanTween.moveY(arg0_118.rtTopMap, arg0_118.rtTopMap.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_119)).uniqueId)
		end,
		function(arg0_120)
			setAnchoredPosition(arg0_118.rtLeftMap, {
				x = 0
			})
			arg0_118.wsTimer:AddTween(LeanTween.moveX(arg0_118.rtLeftMap, -arg0_118.rtLeftMap.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_120)).uniqueId)
		end,
		function(arg0_121)
			setAnchoredPosition(arg0_118.rtRightMap, {
				x = 0
			})
			arg0_118.wsTimer:AddTween(LeanTween.moveX(arg0_118.rtRightMap, arg0_118.rtRightMap.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_121)).uniqueId)
		end
	}, function()
		return existCall(arg1_118)
	end)
end

function var0_0.CancelMapUITween(arg0_123)
	LeanTween.cancel(go(arg0_123.rtTopMap))
	LeanTween.cancel(go(arg0_123.rtLeftMap))
	LeanTween.cancel(go(arg0_123.rtRightMap))
end

function var0_0.DisposeMapUI(arg0_124)
	arg0_124:DisposeMapTop()
	arg0_124:DisposeMapLeft()
	arg0_124:DisposeMapRight()
	arg0_124:DisposeMapOut()
end

function var0_0.DisplayMap(arg0_125)
	setActive(arg0_125.rtUIMain, true)
end

function var0_0.HideMap(arg0_126)
	setActive(arg0_126.rtUIMain, false)
end

function var0_0.ShowMargin(arg0_127, arg1_127)
	if arg0_127.wsMap then
		arg0_127.wsMap:UpdateTransportDisplay(arg1_127)
	end
end

function var0_0.LoadMap(arg0_128, arg1_128, arg2_128)
	assert(arg1_128, "target map not exist.")

	local var0_128 = {}

	if not arg1_128:IsValid() then
		table.insert(var0_128, function(arg0_129)
			arg0_128:emit(WorldMediator.OnMapReq, arg1_128.id, arg0_129)
		end)
	end

	seriesAsync(var0_128, function()
		if arg0_128.wsMap then
			return existCall(arg2_128)
		else
			arg1_128:AddListener(WorldMap.EventUpdateActive, arg0_128.onDisposeMap)
			arg1_128:AddListener(WorldMap.EventUpdateMoveSpeed, arg0_128.onClearMoveQueue)

			arg0_128.wsMap = arg0_128:NewMap(arg1_128)

			arg0_128.wsMap:Load(function()
				arg0_128.wsMap.transform:SetParent(arg0_128.rtDragLayer, false)
				setActive(arg0_128.wsMap.transform, true)
				arg0_128:InitMap()

				return existCall(arg2_128)
			end)
		end
	end)
end

function var0_0.InitMap(arg0_132)
	for iter0_132, iter1_132 in ipairs(arg0_132.wsMap.wsMapFleets) do
		onButton(arg0_132, iter1_132.rtRetreat, function()
			arg0_132:Op("OpReqRetreat", iter1_132.fleet)
		end, SFX_PANEL)
		iter1_132:AddListener(WSMapFleet.EventUpdateSelected, arg0_132.onFleetSelected)
	end

	arg0_132.wsMap:AddListener(WSMap.EventUpdateEventTips, arg0_132.onUpdateEventTips)

	local var0_132 = nowWorld()

	var0_132:AddListener(World.EventUpdateSubmarineSupport, arg0_132.onUpdateSubmarineSupport)
	var0_132:AddListener(World.EventAchieved, arg0_132.onAchievementAchieved)

	local var1_132 = arg0_132.wsMap.map

	arg0_132.wsDragProxy:UpdateMap(var1_132)
	arg0_132.wsDragProxy:Focus(arg0_132.wsMap:GetFleet().transform.position)
	arg0_132.wsMapCamera:UpdateMap(var1_132)
	arg0_132:OnUpdateSubmarineSupport()
end

function var0_0.NewMap(arg0_134, arg1_134)
	local var0_134 = WSMap.New()

	var0_134.wsPool = arg0_134.wsPool
	var0_134.wsTimer = arg0_134.wsTimer

	var0_134:Setup(arg1_134)

	arg0_134.rtGrid.localEulerAngles = Vector3(arg1_134.theme.angle, 0, 0)

	return var0_134
end

function var0_0.DisposeMap(arg0_135)
	if arg0_135.wsMap then
		arg0_135.wsTimer:ClearInMapTimers()
		arg0_135.wsTimer:ClearInMapTweens()
		arg0_135:HideMap()

		local var0_135 = nowWorld()

		var0_135:RemoveListener(World.EventUpdateSubmarineSupport, arg0_135.onUpdateSubmarineSupport)
		var0_135:RemoveListener(World.EventAchieved, arg0_135.onAchievementAchieved)

		local var1_135 = arg0_135.wsMap.map

		var1_135:RemoveListener(WorldMap.EventUpdateActive, arg0_135.onDisposeMap)
		var1_135:RemoveListener(WorldMap.EventUpdateMoveSpeed, arg0_135.onClearMoveQueue)
		arg0_135.wsMap:Dispose()

		arg0_135.wsMap = nil
	end
end

function var0_0.OnDisposeMap(arg0_136, arg1_136, arg2_136)
	local var0_136 = false

	if arg1_136 == WorldMap.EventUpdateActive then
		var0_136 = not arg2_136.active
	end

	if var0_136 then
		arg0_136:DisposeMap()
	end
end

function var0_0.DisplayMapTop(arg0_137)
	arg0_137.wsMapTop = arg0_137.wsMapTop or arg0_137:NewMapTop(arg0_137.rtTopMap)

	setActive(arg0_137.rtTopMap, true)
end

function var0_0.HideMapTop(arg0_138)
	setActive(arg0_138.rtTopMap, false)
end

function var0_0.NewMapTop(arg0_139, arg1_139)
	local var0_139 = WSMapTop.New()

	var0_139.transform = arg1_139

	var0_139:Setup()

	function var0_139.cmdSkillFunc(arg0_140)
		arg0_139:emit(WorldMediator.OnOpenLayer, Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = arg0_140
			}
		}))
	end

	function var0_139.poisonFunc(arg0_141)
		arg0_139:ShowSubView("PoisonPanel", {
			arg0_141
		})
	end

	onButton(arg0_139, var0_139.btnBack, function()
		arg0_139:Op("OpCall", function(arg0_143)
			arg0_139:ExitWorld(arg0_143)
		end)
	end, SFX_CANCEL)

	return var0_139
end

function var0_0.DisposeMapTop(arg0_144)
	if arg0_144.wsMapTop then
		arg0_144:HideMapTop()
		arg0_144.wsMapTop:Dispose()

		arg0_144.wsMapTop = nil
	end
end

function var0_0.DisplayMapLeft(arg0_145)
	arg0_145.wsMapLeft = arg0_145.wsMapLeft or arg0_145:NewMapLeft(arg0_145.rtLeftMap)

	setActive(arg0_145.rtLeftMap, true)
end

function var0_0.HideMapLeft(arg0_146)
	setActive(arg0_146.rtLeftMap, false)
end

function var0_0.NewMapLeft(arg0_147, arg1_147)
	local var0_147 = WSMapLeft.New()

	var0_147.transform = arg1_147

	var0_147:Setup()

	function var0_147.onAgonyClick()
		arg0_147:Op("OpOpenLayer", Context.New({
			mediator = WorldInventoryMediator,
			viewComponent = WorldInventoryLayer,
			data = {
				currentFleetIndex = nowWorld():GetActiveMap().findex
			}
		}))
	end

	function var0_147.onLongPress(arg0_149)
		local var0_149 = nowWorld():GetFleet(arg0_149.fleetId):GetShipVOs(true)

		arg0_147:Op("OpOpenScene", SCENE.SHIPINFO, {
			shipId = arg0_149.id,
			shipVOs = var0_149
		})
	end

	function var0_147.onClickSalvage(arg0_150)
		arg0_147:Op("OpCall", function(arg0_151)
			arg0_151()
			arg0_147:ShowSubView("SalvageResult", {
				arg0_150
			})
		end)
	end

	var0_147:AddListener(WSMapLeft.EventSelectFleet, arg0_147.onSelectFleet)

	return var0_147
end

function var0_0.DisposeMapLeft(arg0_152)
	if arg0_152.wsMapLeft then
		arg0_152:HideMapLeft()
		arg0_152.wsMapLeft:RemoveListener(WSMapLeft.EventSelectFleet, arg0_152.onSelectFleet)
		arg0_152.wsMapLeft:Dispose()

		arg0_152.wsMapLeft = nil
	end
end

function var0_0.DisplayMapRight(arg0_153)
	arg0_153.wsMapRight = arg0_153.wsMapRight or arg0_153:NewMapRight(arg0_153.rtRightMap)

	setActive(arg0_153.rtRightMap, true)
	arg0_153:UpdateAutoFightDisplay()
	arg0_153:UpdateAutoSwitchDisplay()
end

function var0_0.HideMapRight(arg0_154)
	setActive(arg0_154.rtRightMap, false)
end

function var0_0.HideMapRightCompass(arg0_155)
	return
end

function var0_0.HideMapRightMemo(arg0_156)
	return
end

function var0_0.NewMapRight(arg0_157, arg1_157)
	local var0_157 = WSMapRight.New()

	var0_157.transform = arg1_157
	var0_157.wsPool = arg0_157.wsPool
	var0_157.wsTimer = arg0_157.wsTimer

	var0_157:Setup()
	var0_157:OnUpdateInfoBtnTip()
	var0_157:OnUpdateHelpBtnTip()
	onButton(arg0_157, var0_157.btnOrder, function()
		arg0_157:Op("OpShowOrderPanel")
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnScan, function()
		arg0_157:Op("OpShowScannerPanel")
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnDefeat, function()
		var0_157:OnUpdateHelpBtnTip(true)
		arg0_157:Op("OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = 4,
				pageId = 5
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnDetail, function()
		arg0_157:Op("OpOpenLayer", Context.New({
			mediator = WorldDetailMediator,
			viewComponent = WorldDetailLayer,
			data = {
				fleetId = nowWorld():GetActiveMap():GetFleet().id
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnInformation, function()
		arg0_157:Op("OpOpenLayer", Context.New({
			mediator = WorldInformationMediator,
			viewComponent = WorldInformationLayer,
			data = {
				fleetId = nowWorld():GetActiveMap():GetFleet().id
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnInventory, function()
		arg0_157:Op("OpOpenLayer", Context.New({
			mediator = WorldInventoryMediator,
			viewComponent = WorldInventoryLayer,
			data = {
				currentFleetIndex = nowWorld():GetActiveMap().findex
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnTransport, function()
		arg0_157:OnClickTransport()
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnPort, function()
		local var0_165 = nowWorld():GetActiveMap()
		local var1_165 = var0_165:GetFleet()

		if var0_165:GetCell(var1_165.row, var1_165.column):ExistEnemy() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_port_inbattle"))

			return
		end

		arg0_157:Op("OpReqEnterPort")
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnExit, function()
		local var0_166 = nowWorld():GetActiveMap()
		local var1_166 = {}

		if var0_166:CheckFleetSalvage(true) then
			table.insert(var1_166, function(arg0_167)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_catsearch_leavemap"),
					onYes = arg0_167
				})
			end)
		end

		seriesAsync(var1_166, function()
			arg0_157:Op("OpReqJumpOut", var0_166.gid)
		end)
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.btnHelp, function()
		var0_157:OnUpdateHelpBtnTip(true)
		arg0_157:Op("OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.toggleAutoFight:Find("off"), function()
		arg0_157:Op("OpCall", function(arg0_171)
			arg0_171()

			local var0_171 = {}

			if PlayerPrefs.GetInt("first_auto_fight_mark", 0) == 0 then
				table.insert(var0_171, function(arg0_172)
					PlayerPrefs.SetInt("first_auto_fight_mark", 1)
					arg0_157:Op("OpOpenLayer", Context.New({
						mediator = WorldHelpMediator,
						viewComponent = WorldHelpLayer,
						data = {
							titleId = 2,
							pageId = 8
						},
						onRemoved = arg0_172
					}))
				end)
			end

			local var1_171 = nowWorld()

			if var1_171:IsSystemOpen(WorldConst.SystemOrderSubmarine) and PlayerPrefs.GetInt("world_sub_auto_call", 0) == 1 and var1_171:GetActiveMap():GetConfig("instruction_available")[1] == 1 and var1_171:CanCallSubmarineSupport() and not var1_171:IsSubmarineSupporting() then
				local var2_171 = var1_171:CalcOrderCost(WorldConst.OpReqSub)

				if var2_171 <= PlayerPrefs.GetInt("world_sub_call_line", 0) and var2_171 <= var1_171.staminaMgr:GetTotalStamina() then
					if var2_171 > 0 then
						table.insert(var0_171, function(arg0_173)
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("world_instruction_submarine_2", setColorStr(var2_171, COLOR_GREEN)),
								onYes = function()
									PlayerPrefs.SetInt("autoSubIsAcitve" .. AutoSubCommand.GetAutoSubMark(SYSTEM_WORLD), 1)
									arg0_157:Op("OpReqSub", arg0_173)
								end,
								onNo = arg0_173
							})
						end)
					else
						PlayerPrefs.SetInt("autoSubIsAcitve" .. AutoSubCommand.GetAutoSubMark(SYSTEM_WORLD), 1)
						table.insert(var0_171, function(arg0_175)
							arg0_157:Op("OpReqSub", arg0_175)
						end)
					end
				end
			end

			seriesAsync(var0_171, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_begin"))
				getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
				PlayerPrefs.SetInt("world_skip_precombat", 1)
				PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(SYSTEM_WORLD), 1)
				var1_171:TriggerAutoFight(true)
				arg0_157:Op("OpInteractive")
			end)
		end)
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.toggleAutoFight:Find("on"), function()
		arg0_157:Op("OpCall", function(arg0_178)
			arg0_178()
			nowWorld():TriggerAutoFight(false)
			arg0_157:Op("OpInteractive")
		end)
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.toggleAutoSwitch:Find("off"), function()
		arg0_157:Op("OpOpenLayer", Context.New({
			mediator = WorldSwitchPlanningMediator,
			viewComponent = WorldSwitchPlanningLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_157, var0_157.toggleAutoSwitch:Find("on"), function()
		arg0_157:Op("OpCall", function(arg0_181)
			arg0_181()
			nowWorld():TriggerAutoFight(false)
			arg0_157:Op("OpInteractive")
		end)
	end, SFX_PANEL)

	return var0_157
end

function var0_0.DisposeMapRight(arg0_182)
	if arg0_182.wsMapRight then
		arg0_182:HideMapRight()
		arg0_182.wsMapRight:Dispose()

		arg0_182.wsMapRight = nil
	end
end

function var0_0.DisplayMapOut(arg0_183)
	arg0_183.wsMapOut = arg0_183.wsMapOut or arg0_183:NewMapOut(arg0_183.rtOutMap)

	setActive(arg0_183.rtOutMap, true)
end

function var0_0.HideMapOut(arg0_184)
	setActive(arg0_184.rtOutMap, false)
end

function var0_0.NewMapOut(arg0_185, arg1_185)
	local var0_185 = WSMapOut.New()

	var0_185.transform = arg1_185

	var0_185:Setup()

	return var0_185
end

function var0_0.DisposeMapOut(arg0_186)
	if arg0_186.wsMapOut then
		arg0_186:HideMapOut()
		arg0_186.wsMapOut:Dispose()

		arg0_186.wsMapOut = nil
	end
end

function var0_0.OnUpdateProgress(arg0_187, arg1_187, arg2_187, arg3_187, arg4_187)
	arg0_187:UpdateSystemOpen()

	if arg0_187.wsMapRight then
		arg0_187.wsMapRight:OnUpdateHelpBtnTip()
	end
end

function var0_0.OnUpdateScale(arg0_188, arg1_188, arg2_188, arg3_188)
	if arg0_188.wsAtlas and not arg0_188.wsAtlasBottom:CheckIsTweening() then
		arg0_188.wsAtlas:UpdateScale(arg3_188)
	end
end

function var0_0.OnModelSelectMap(arg0_189, arg1_189, arg2_189, arg3_189, arg4_189, arg5_189)
	if arg3_189 then
		arg0_189:ShowSubView("FloatPanel", {
			arg3_189,
			arg4_189,
			arg5_189,
			arg2_189
		})
	else
		arg0_189:HideSubView("FloatPanel")
	end
end

function var0_0.OnUpdateSubmarineSupport(arg0_190, arg1_190)
	arg0_190.wsMap:UpdateSubmarineSupport()

	if arg0_190.wsMapLeft then
		arg0_190.wsMapLeft:OnUpdateSubmarineSupport()
	end
end

function var0_0.OnUpdateDaily(arg0_191)
	if arg0_191.wsAtlasBottom then
		setActive(arg0_191.wsAtlasBottom.btnDailyTask:Find("tip"), nowWorld():GetTaskProxy():canAcceptDailyTask())
	end
end

function var0_0.OnFleetSelected(arg0_192, arg1_192, arg2_192)
	if arg2_192.selected then
		arg0_192.wsDragProxy:Focus(arg2_192.transform.position, nil, LeanTweenType.easeInOutSine)
	end
end

function var0_0.OnSelectFleet(arg0_193, arg1_193, arg2_193, arg3_193)
	if arg3_193 == nowWorld():GetActiveMap():GetFleet() then
		arg0_193:Op("OpMoveCamera", 0, 0.1)
	else
		arg0_193:Op("OpReqSwitchFleet", arg3_193)
	end
end

function var0_0.OnClickCell(arg0_194, arg1_194, arg2_194)
	local var0_194 = nowWorld():GetActiveMap()
	local var1_194 = var0_194:GetFleet()
	local var2_194 = var0_194:GetCell(arg1_194, arg2_194)
	local var3_194 = var0_194:FindFleet(var2_194.row, var2_194.column)

	if var3_194 and var3_194 ~= var1_194 then
		arg0_194:Op("OpReqSwitchFleet", var3_194)
	elseif var0_194:CheckInteractive() then
		arg0_194:Op("OpInteractive", true)
	elseif var0_194:IsSign(arg1_194, arg2_194) and ManhattonDist({
		row = var1_194.row,
		column = var1_194.column
	}, {
		row = var2_194.row,
		column = var2_194.column
	}) <= 1 then
		arg0_194:Op("OpTriggerSign", var1_194, var2_194:GetEventAttachment(), function()
			arg0_194:Op("OpInteractive")
		end)
	elseif var0_194:CanLongMove(var1_194) then
		arg0_194:Op("OpLongMoveFleet", var1_194, var2_194.row, var2_194.column)
	else
		arg0_194:Op("OpReqMoveFleet", var1_194, var2_194.row, var2_194.column)
	end
end

function var0_0.OnClickTransport(arg0_196)
	if arg0_196.svScannerPanel:isShowing() then
		return
	end

	arg0_196:Op("OpCall", function(arg0_197)
		arg0_197()
		arg0_196:QueryTransport(function()
			arg0_196:EnterTransportWorld()
		end)
	end)
end

function var0_0.QueryTransport(arg0_199, arg1_199)
	local var0_199 = nowWorld()
	local var1_199 = var0_199:GetActiveMap()
	local var2_199 = {}

	if not var0_199:IsSystemOpen(WorldConst.SystemOutMap) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))

		return
	end

	if var1_199:CheckAttachmentTransport() == "story" then
		local var3_199 = pg.gameset.world_transfer_eventstory.description[1]

		table.insert(var2_199, function(arg0_200)
			arg0_199:OpRaw("OpStory", var3_199, true, true, false, function(arg0_201)
				if arg0_201 == 1 then
					arg0_200()
				end
			end)
		end)
	end

	if var0_199:IsSubmarineSupporting() and var1_199:GetSubmarineFleet():GetAmmo() > 0 then
		table.insert(var2_199, function(arg0_202)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_instruction_submarine_6"),
				onYes = arg0_202
			})
		end)
	end

	if var1_199:CheckFleetSalvage(true) then
		table.insert(var2_199, function(arg0_203)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_catsearch_leavemap"),
				onYes = arg0_203
			})
		end)
	end

	local var4_199

	for iter0_199, iter1_199 in ipairs(var1_199:GetNormalFleets()) do
		for iter2_199, iter3_199 in ipairs(iter1_199:GetCarries()) do
			if iter3_199.config.out_story ~= "" then
				var4_199 = iter3_199.config.out_story
			end
		end
	end

	if var4_199 then
		table.insert(var2_199, function(arg0_204)
			arg0_199:OpRaw("OpStory", var4_199, true, true, false, function(arg0_205)
				if arg0_205 == 1 then
					arg0_204()
				end
			end)
		end)
	end

	local var5_199, var6_199 = var1_199:CkeckTransport()

	if not var5_199 then
		table.insert(var2_199, function(arg0_206)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var6_199,
				onYes = arg0_206
			})
		end)
	end

	seriesAsync(var2_199, function()
		return arg1_199(var5_199)
	end)
end

function var0_0.OnUpdateEventTips(arg0_208, arg1_208, arg2_208)
	if arg0_208.wsMapRight then
		arg0_208.wsMapRight:OnUpdateEventTips()
	end

	if arg0_208.wsMapTop then
		arg0_208.wsMapTop:OnUpdatePoison()
	end
end

function var0_0.OnClickMap(arg0_209, arg1_209, arg2_209)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

	local var0_209 = arg0_209.wsMap.map
	local var1_209 = var0_209.top
	local var2_209 = var0_209.bottom
	local var3_209 = var0_209.left
	local var4_209 = var0_209.right

	if arg1_209 < var1_209 or var2_209 < arg1_209 or arg2_209 < var3_209 or var4_209 < arg2_209 then
		arg0_209:OnClickTransport()
	else
		arg0_209:OnClickCell(arg1_209, arg2_209)
	end
end

function var0_0.CheckScannerEnable(arg0_210, arg1_210, arg2_210)
	if nowWorld():IsSystemOpen(WorldConst.SystemScanner) then
		local var0_210 = arg0_210.wsMap.map:GetCell(arg1_210, arg2_210)

		if var0_210 and var0_210:GetInFOV() and not var0_210:InFog() then
			local var1_210 = var0_210:GetScannerAttachment()

			if var1_210 then
				local var2_210 = arg0_210.wsMap:GetCell(arg1_210, arg2_210).rtAttachments.position

				return var1_210, arg0_210.camera:WorldToScreenPoint(var2_210)
			end
		end
	end
end

function var0_0.OnLongPressMap(arg0_211, arg1_211, arg2_211)
	if not arg0_211.svScannerPanel:isShowing() then
		local var0_211, var1_211 = arg0_211:CheckScannerEnable(arg1_211, arg2_211)

		if var0_211 then
			arg0_211:Op("OpShowScannerPanel", var0_211, var1_211)
		end
	end
end

function var0_0.OnAchievementAchieved(arg0_212, arg1_212, arg2_212, arg3_212, arg4_212)
	if arg3_212 then
		for iter0_212, iter1_212 in ipairs(arg3_212) do
			pg.TipsMgr.GetInstance():ShowTips(iter1_212)
		end
	end

	if arg4_212 then
		local var0_212 = nowWorld()

		if var0_212.isAutoFight then
			var0_212:AddAutoInfo("message", i18n("autofight_discovery", arg4_212.config.target_desc))
		else
			table.insert(arg0_212.achievedList, {
				arg4_212,
				arg0_212.wsMapRight.btnInformation.position
			})
		end
	end
end

function var0_0.DoAnim(arg0_213, arg1_213, arg2_213)
	local var0_213 = arg0_213.wsAnim

	if not var0_213:GetAnim(arg1_213) then
		var0_213:SetAnim(arg1_213, arg0_213:NewUIAnim(arg1_213))
	end

	var0_213:GetAnim(arg1_213):Play(arg2_213)
end

function var0_0.NewUIAnim(arg0_214, arg1_214)
	local var0_214 = UIAnim.New()

	var0_214:Setup(arg1_214)
	var0_214:AddListener(UIAnim.EventLoaded, function()
		var0_214.transform:SetParent(arg0_214.rtTop, false)
	end)
	var0_214:Load()

	return var0_214
end

function var0_0.DoStrikeAnim(arg0_216, arg1_216, arg2_216, arg3_216)
	local var0_216 = arg0_216.wsAnim

	if not var0_216:GetAnim(arg1_216) then
		var0_216:SetAnim(arg1_216, arg0_216:NewStrikeAnim(arg1_216, arg2_216))
	else
		var0_216:GetAnim(arg1_216):ReloadShip(arg2_216)
	end

	var0_216:GetAnim(arg1_216):Play(arg3_216)
end

function var0_0.NewStrikeAnim(arg0_217, arg1_217, arg2_217)
	local var0_217 = UIStrikeAnim.New()

	var0_217:Setup(arg1_217, arg2_217)
	var0_217:AddListener(UIStrikeAnim.EventLoaded, function()
		var0_217.transform:SetParent(arg0_217.rtTop, false)
	end)
	var0_217:Load()

	return var0_217
end

function var0_0.StopAnim(arg0_219)
	arg0_219.wsAnim:Stop()
end

function var0_0.UpdateSystemOpen(arg0_220)
	local var0_220 = nowWorld()

	if arg0_220:GetInMap() then
		local var1_220 = var0_220:GetActiveMap()

		arg0_220.wsMapLeft.onAgonyClickEnabled = var0_220:IsSystemOpen(WorldConst.SystemInventory)

		setActive(arg0_220.wsMapRight.btnInventory, var0_220:IsSystemOpen(WorldConst.SystemInventory))
		setActive(arg0_220.wsMapRight.btnTransport, var0_220:IsSystemOpen(WorldConst.SystemOutMap))
		setActive(arg0_220.wsMapRight.btnDetail, var0_220:IsSystemOpen(WorldConst.SystemFleetDetail))
		setActive(arg0_220.wsMapRight.rtCompassPanel, var0_220:IsSystemOpen(WorldConst.SystemCompass))
		setActive(arg0_220.wsMapRight.toggleAutoFight, var1_220:CanAutoFight())
		setActive(arg0_220.wsMapRight.toggleAutoSwitch, var0_220:IsSystemOpen(WorldConst.SystemAutoSwitch))
	else
		setActive(arg0_220.wsAtlasBottom.btnBoss, var0_220:IsSystemOpen(WorldConst.SystemWorldBoss))

		local var2_220 = var0_220:GetBossProxy():NeedTip()
		local var3_220 = var0_220:GetBossProxy():ExistSelfBoss()
		local var4_220 = WorldBossConst.CanUnlockCurrBoss()
		local var5_220 = not var3_220 and not var4_220

		setActive(arg0_220.wsAtlasBottom.btnBoss:Find("tip"), var2_220 or var4_220 or WorldBossConst.AnyArchivesBossCanGetAward())
		setActive(arg0_220.wsAtlasBottom.btnBoss:Find("sel"), not var5_220)

		local var6_220 = arg0_220.rtTopAtlas:Find("reset_coutdown")

		onButton(arg0_220, var6_220, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("world_reset_tip")
			})
		end, SFX_PANEL)

		local var7_220 = var0_220:IsSystemOpen(WorldConst.SystemResetCountDown) and var0_220:CheckResetProgress()

		setActive(var6_220, var7_220)

		if var7_220 then
			local var8_220 = var0_220:GetResetWaitingTime()
			local var9_220 = math.floor(var8_220 / 86400)

			if var9_220 > 0 then
				setText(var6_220:Find("Text"), i18n("world_reset_1", string.format("  %d  ", var9_220)))
			elseif var9_220 == 0 then
				setText(var6_220:Find("Text"), i18n("world_reset_2", string.format("  %d  ", 0)))
			elseif var9_220 < 0 then
				setText(var6_220:Find("Text"), i18n("world_reset_3"))
			end
		end

		setActive(arg0_220.wsAtlasBottom.btnShop, var0_220:IsSystemOpen(WorldConst.SystemResetShop))
		setActive(arg0_220.wsAtlasBottom.btnDailyTask:Find("mask"), not var0_220:IsSystemOpen(WorldConst.SystemDailyTask))
		setActive(arg0_220.wsAtlasRight.btnSwitch, var0_220:IsSystemOpen(WorldConst.SystemAutoSwitch))
	end

	setActive(arg0_220.resAtlas._tf, var0_220:IsSystemOpen(WorldConst.SystemResource))
	setActive(arg0_220.resMap._tf, var0_220:IsSystemOpen(WorldConst.SystemResource))
end

function var0_0.EnterToModelMap(arg0_222, arg1_222)
	local var0_222 = {}

	table.insert(var0_222, function(arg0_223)
		setActive(arg0_222.rtTopAtlas:Find("print/title_world"), true)
		setActive(arg0_222.rtTopAtlas:Find("print/title_view"), false)
		arg0_222.wsAtlasBottom:UpdateScale(1, true, arg0_223)
	end)
	table.insert(var0_222, function(arg0_224)
		arg0_222.wsAtlas:SwitchArea(arg1_222, true, arg0_224)
	end)
	parallelAsync(var0_222, function()
		local var0_225 = nowWorld():GetAtlas():GetActiveEntrance()

		if arg1_222 == var0_225:GetAreaId() then
			arg0_222.wsAtlas:UpdateSelect(var0_225)
		end
	end)
end

function var0_0.ReturnToModelArea(arg0_226)
	arg0_226.wsAtlas:UpdateSelect()

	local var0_226 = {}

	table.insert(var0_226, function(arg0_227)
		setActive(arg0_226.rtTopAtlas:Find("print/title_world"), false)
		setActive(arg0_226.rtTopAtlas:Find("print/title_view"), true)
		arg0_226.wsAtlasBottom:UpdateScale(0, true, arg0_227)
	end)
	table.insert(var0_226, function(arg0_228)
		arg0_226.wsAtlas:SwitchArea(nil, true, arg0_228)
	end)
	parallelAsync(var0_226, function()
		return
	end)
end

function var0_0.EnterTransportWorld(arg0_230, arg1_230)
	local var0_230 = nowWorld()

	arg1_230 = arg1_230 or {
		entrance = var0_230:GetActiveEntrance()
	}

	local var1_230 = {}

	if arg0_230:GetInMap() then
		table.insert(var1_230, function(arg0_231)
			arg0_230:Op("OpSetInMap", false, arg0_231)
		end)
	elseif not arg0_230.wsAtlas.nowArea then
		table.insert(var1_230, function(arg0_232)
			arg0_230.wsAtlas:SwitchArea(arg1_230.entrance:GetAreaId(), false, arg0_232)
		end)
	end

	seriesAsync(var1_230, function()
		arg0_230.wsAtlas:UpdateSelect()
		arg0_230.wsAtlas:UpdateSelect(arg1_230.entrance, arg1_230.mapId, arg1_230.mapTypes)
		arg0_230.wsAtlas:DisplayTransport(arg0_230.contextData.displayTransDic or {}, function()
			arg0_230.contextData.displayTransDic = Clone(var0_230:GetAtlas().transportDic)
		end)
	end)
end

function var0_0.BackToMap(arg0_235)
	if arg0_235.wsAtlas:CheckIsTweening() then
		return
	end

	arg0_235:Op("OpSetInMap", true)
end

function var0_0.DisplayEnv(arg0_236, arg1_236)
	local var0_236 = checkExist(nowWorld():GetActiveMap(), {
		"config"
	}, {
		"map_bg"
	}, {
		1
	}) or "model_bg"
	local var1_236 = {}

	if arg0_236.rtEnvBG:GetComponent(typeof(Image)).sprite.name ~= var0_236 then
		table.insert(var1_236, function(arg0_237)
			GetSpriteFromAtlasAsync("world/map/" .. var0_236, var0_236, function(arg0_238)
				setImageSprite(arg0_236.rtEnvBG, arg0_238)

				return arg0_237()
			end)
		end)
	end

	seriesAsync(var1_236, arg1_236)
end

function var0_0.ScreenPos2MapPos(arg0_239, arg1_239)
	local var0_239 = arg0_239.wsMap
	local var1_239 = var0_239.map
	local var2_239 = arg0_239.camera:ScreenPointToRay(arg1_239)
	local var3_239, var4_239 = Plane.New(var0_239.rtQuads.forward, -Vector3.Dot(var0_239.rtQuads.position, var0_239.rtQuads.forward)):Raycast(var2_239)

	if var3_239 then
		local var5_239 = var2_239:GetPoint(var4_239)
		local var6_239 = var0_239.rtQuads:InverseTransformPoint(var5_239)
		local var7_239 = var1_239.theme:X2Column(var6_239.x)

		return var1_239.theme:Y2Row(var6_239.y), var7_239
	end
end

function var0_0.BuildCutInAnim(arg0_240, arg1_240, arg2_240)
	arg0_240.tfAnim = arg0_240.rtPanelList:Find(arg1_240 .. "(Clone)")

	local var0_240 = {}

	if not arg0_240.tfAnim then
		table.insert(var0_240, function(arg0_241)
			PoolMgr.GetInstance():GetUI(arg1_240, true, function(arg0_242)
				arg0_242:SetActive(false)

				arg0_240.tfAnim = tf(arg0_242)

				arg0_240.tfAnim:SetParent(arg0_240.rtPanelList, false)

				return arg0_241()
			end)
		end)
	end

	table.insert(var0_240, function(arg0_243)
		arg0_240.inCutIn = true

		arg0_240.tfAnim:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_244)
			if not IsNil(arg0_240.tfAnim) then
				arg0_240.inCutIn = false

				pg.UIMgr.GetInstance():UnOverlayPanel(arg0_240.tfAnim, arg0_240.rtPanelList)
				setActive(arg0_240.tfAnim, false)

				return arg0_243()
			end
		end)
		pg.UIMgr.GetInstance():OverlayPanel(arg0_240.tfAnim)
		setActive(arg0_240.tfAnim, true)
	end)
	seriesAsync(var0_240, function()
		return existCall(arg2_240)
	end)
end

function var0_0.PlaySound(arg0_246, arg1_246, arg2_246)
	if arg0_246.cueName then
		pg.CriMgr.GetInstance():StopSE_V3()

		arg0_246.cueName = nil
	end

	pg.CriMgr.GetInstance():PlaySE_V3(arg1_246, function()
		arg0_246.cueName = nil
	end)

	return existCall(arg2_246)
end

function var0_0.ChangeTopRaycasts(arg0_248, arg1_248)
	GetComponent(arg0_248.rtTop, typeof(CanvasGroup)).blocksRaycasts = tobool(arg1_248)
end

function var0_0.DoTopBlock(arg0_249, arg1_249)
	arg0_249:ChangeTopRaycasts(false)

	return function(...)
		arg0_249:ChangeTopRaycasts(true)

		return existCall(arg1_249, ...)
	end
end

function var0_0.SetMoveQueue(arg0_251, arg1_251)
	arg0_251:ReContinueMoveQueue()

	arg0_251.moveQueue = arg1_251
end

function var0_0.ClearMoveQueue(arg0_252)
	arg0_252:DisplayMoveStopClick(false)

	arg0_252.moveQueueInteractive = true

	if #arg0_252.moveQueue > 0 then
		arg0_252.moveQueue = {}
	end

	arg0_252:ShowFleetMoveTurn(false)
end

function var0_0.DoQueueMove(arg0_253, arg1_253)
	assert(#arg0_253.moveQueue > 0, "without move queue")
	arg0_253:DisplayMoveStopClick(true)

	local var0_253 = nowWorld():GetActiveMap()
	local var1_253 = _.detect(arg0_253.moveQueue, function(arg0_254)
		return arg0_254.stay
	end)

	if #arg0_253.moveQueue == 1 and var0_253:IsSign(var1_253.row, var1_253.column) then
		arg0_253:ClearMoveQueue()

		local var2_253 = var0_253:GetCell(var1_253.row, var1_253.column)

		arg0_253:Op("OpTriggerSign", arg1_253, var2_253:GetEventAttachment(), function()
			arg0_253:Op("OpInteractive")
		end)
	else
		arg0_253:ReContinueMoveQueue()
		arg0_253:ShowFleetMoveTurn(true)
		arg0_253:Op("OpReqMoveFleet", arg1_253, var1_253.row, var1_253.column)
	end
end

function var0_0.CheckMoveQueue(arg0_256, arg1_256)
	if #arg0_256.moveQueue < #arg1_256 or #arg1_256 == 0 then
		arg0_256:ClearMoveQueue()
	else
		local var0_256 = arg1_256[#arg1_256]

		if arg0_256.moveQueue[#arg1_256].row ~= var0_256.row or arg0_256.moveQueue[#arg1_256].column ~= var0_256.column then
			arg0_256:ClearMoveQueue()
		else
			for iter0_256 = 1, #arg1_256 do
				table.remove(arg0_256.moveQueue, 1)
			end

			if #arg0_256.moveQueue == 0 then
				arg0_256:ResetLostMoveQueueCount()

				arg0_256.moveQueueInteractive = true
			end
		end
	end
end

function var0_0.InteractiveMoveQueue(arg0_257)
	if arg0_257.moveQueueInteractive then
		arg0_257:ClearMoveQueue()
	else
		arg0_257:DisplayMoveStopClick(false)

		arg0_257.moveQueueInteractive = true
	end
end

function var0_0.ReContinueMoveQueue(arg0_258)
	arg0_258.moveQueueInteractive = false
end

function var0_0.CheckLostMoveQueueCount(arg0_259)
	arg0_259.lostMoveQueueCount = defaultValue(arg0_259.lostMoveQueueCount, 0) + 1

	return arg0_259.lostMoveQueueCount > WorldConst.AutoFightLoopCountLimit
end

function var0_0.ResetLostMoveQueueCount(arg0_260, arg1_260)
	if arg1_260 then
		arg0_260.inLoopAutoFight = true
	end

	arg0_260.lostMoveQueueCount = 0
end

function var0_0.DisplayMoveStopClick(arg0_261, arg1_261)
	setActive(arg0_261.rtClickStop, arg1_261)

	if arg1_261 then
		local var0_261 = nowWorld().isAutoFight

		setActive(arg0_261.rtClickStop:Find("long_move"), not var0_261)
		setActive(arg0_261.rtClickStop:Find("auto_fight"), var0_261)
	end
end

function var0_0.ShowFleetMoveTurn(arg0_262, arg1_262)
	if arg0_262.wsMap then
		if arg1_262 then
			arg0_262.wsMap:GetFleet():PlusMoveTurn()
		else
			arg0_262.wsMap:GetFleet():ClearMoveTurn()
		end
	end
end

function var0_0.GetAllPessingAward(arg0_263, arg1_263)
	local var0_263 = nowWorld()
	local var1_263 = var0_263:GetAtlas()
	local var2_263 = {}

	for iter0_263, iter1_263 in pairs(var0_263.pressingAwardDic) do
		if iter1_263.flag then
			var0_263:FlagMapPressingAward(iter0_263)
			var1_263:MarkMapTransport(iter0_263)

			local var3_263 = pg.world_event_complete[iter1_263.id].event_reward_slgbuff

			if #var3_263 > 0 then
				var2_263[var3_263[1]] = defaultValue(var2_263[var3_263[1]], 0) + var3_263[2]
			end
		end
	end

	local var4_263 = var0_263:GetActiveMap()

	if not var4_263.visionFlag and var0_263:IsMapVisioned(var4_263.id) then
		var4_263:UpdateVisionFlag(true)
	end

	if arg0_263.wsAtlas then
		arg0_263.wsAtlas:OnUpdatePressingAward()
	end

	local var5_263 = {}

	for iter2_263, iter3_263 in pairs(var2_263) do
		table.insert(var5_263, function(arg0_264)
			local var0_264 = {
				id = iter2_263,
				floor = iter3_263,
				before = var0_263:GetGlobalBuff(iter2_263):GetFloor()
			}

			arg0_263:ShowSubView("GlobalBuff", {
				var0_264,
				arg0_264
			})
		end)
		table.insert(var5_263, function(arg0_265)
			var0_263:AddGlobalBuff(iter2_263, iter3_263)
			arg0_265()
		end)
	end

	seriesAsync(var5_263, function()
		return existCall(arg1_263)
	end)
end

function var0_0.CheckGuideSLG(arg0_267, arg1_267, arg2_267)
	local var0_267 = nowWorld()
	local var1_267 = {}

	table.insert(var1_267, {
		"WorldG007",
		function()
			local var0_268 = arg1_267:GetPort()

			if var0_268 and not var0_268:IsTempPort() then
				local var1_268 = arg1_267:GetFleet()

				return not arg1_267:GetCell(var1_268.row, var1_268.column):ExistEnemy()
			end
		end
	})
	table.insert(var1_267, {
		"WorldG111",
		function()
			return arg1_267:canExit()
		end
	})
	table.insert(var1_267, {
		"WorldG112",
		function()
			local var0_270 = var0_267:GetActiveEntrance()

			return var0_270.becomeSairen and var0_270:GetSairenMapId() == arg1_267.id
		end
	})
	table.insert(var1_267, {
		"WorldG124",
		function()
			return var0_267:IsSystemOpen(WorldConst.SystemOrderSubmarine) and arg1_267:GetConfig("instruction_available")[1] ~= 0 and var0_267:CanCallSubmarineSupport()
		end
	})
	table.insert(var1_267, {
		"WorldG162",
		function()
			return _.any(arg1_267:GetNormalFleets(), function(arg0_273)
				return _.any(arg0_273:GetShips(true), function(arg0_274)
					return arg0_274:IsBroken()
				end)
			end)
		end
	})
	table.insert(var1_267, {
		"WorldG163",
		function()
			local var0_275 = var0_267:GetTaskProxy():getDoingTaskVOs()

			return underscore.any(var0_275, function(arg0_276)
				return not arg0_276:IsAutoSubmit() and arg0_276:isFinished()
			end)
		end
	})
	table.insert(var1_267, {
		"WorldG164",
		function()
			return arg1_267:CheckFleetSalvage(true)
		end
	})
	table.insert(var1_267, {
		"WorldG181",
		function()
			return var0_267:GetInventoryProxy():GetItemCount(102) > 0
		end
	})
	table.insert(var1_267, {
		"WorldG191",
		function()
			return WorldBossConst.CanUnlockCurrBoss() and nowWorld():IsSystemOpen(WorldConst.SystemWorldBoss)
		end
	})

	local var2_267 = _.filter(arg1_267:FindAttachments(WorldMapAttachment.TypeEvent), function(arg0_280)
		return arg0_280:IsAlive()
	end)

	for iter0_267, iter1_267 in ipairs(pg.gameset.world_guide_event.description) do
		table.insert(var1_267, {
			iter1_267[2],
			function()
				return _.any(var2_267, function(arg0_282)
					return arg0_282.id == iter1_267[1]
				end)
			end
		})
	end

	local var3_267 = pg.NewStoryMgr.GetInstance()

	for iter2_267, iter3_267 in ipairs(var1_267) do
		if not var3_267:IsPlayed(iter3_267[1]) and iter3_267[2]() then
			WorldGuider.GetInstance():PlayGuide(iter3_267[1])

			return true
		end
	end

	return false
end

function var0_0.CheckEventForMsg(arg0_283, arg1_283)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_283.player.level, "EventMediator") and getProxy(EventProxy).eventForMsg
end

function var0_0.OpenPortLayer(arg0_284, arg1_284)
	arg0_284:Op("OpOpenLayer", Context.New({
		mediator = WorldPortMediator,
		viewComponent = WorldPortLayer,
		data = arg1_284
	}))
end

function var0_0.ShowTransportMarkOverview(arg0_285, arg1_285, arg2_285)
	if nowWorld():GetActiveMap():CheckFleetSalvage(true) then
		arg0_285:Op("OpShowMarkOverview", arg1_285, function()
			pg.NewStoryMgr.GetInstance():Play(pg.gameset.world_catsearch_special.description[1], arg2_285, true)
		end)
	else
		arg0_285:Op("OpShowMarkOverview", arg1_285, arg2_285)
	end
end

function var0_0.UpdateAutoFightDisplay(arg0_287)
	arg0_287:ClearMoveQueue()

	local var0_287 = nowWorld().isAutoFight

	if arg0_287.wsMapRight then
		setActive(arg0_287.wsMapRight.toggleAutoFight:Find("off"), not var0_287)
		setActive(arg0_287.wsMapRight.toggleAutoFight:Find("on"), var0_287)
		setActive(arg0_287.wsMapRight.toggleSkipPrecombat, not var0_287)
		triggerToggle(arg0_287.wsMapRight.toggleSkipPrecombat, PlayerPrefs.GetInt("world_skip_precombat", 0) == 1)
	end
end

function var0_0.UpdateAutoSwitchDisplay(arg0_288)
	local var0_288 = nowWorld().isAutoSwitch

	if arg0_288.wsMapRight then
		setActive(arg0_288.wsMapRight.toggleAutoSwitch:Find("off"), not var0_288)
		setActive(arg0_288.wsMapRight.toggleAutoSwitch:Find("on"), var0_288)
	end
end

function var0_0.GuideShowScannerEvent(arg0_289, arg1_289)
	assert(arg0_289.svScannerPanel:isShowing(), "scanner mode is closed")

	local var0_289 = arg0_289.wsMap.map:FindAttachments(WorldMapAttachment.TypeEvent, arg1_289)

	assert(#var0_289 == 1, "event number error: " .. #var0_289)

	local var1_289, var2_289 = arg0_289:CheckScannerEnable(var0_289[1].row, var0_289[1].column)

	assert(var1_289, "without scanner attachment")
	arg0_289.svScannerPanel:ActionInvoke("DisplayWindow", var1_289, var2_289)
end

function var0_0.DisplayAwards(arg0_290, arg1_290, arg2_290, arg3_290)
	local var0_290 = {}
	local var1_290 = {}

	for iter0_290, iter1_290 in ipairs(arg1_290) do
		if iter1_290.type == DROP_TYPE_WORLD_COLLECTION then
			table.insert(var1_290, iter1_290)
		else
			table.insert(var0_290, iter1_290)
		end
	end

	seriesAsync({
		function(arg0_291)
			if #var0_290 == 0 then
				return arg0_291()
			end

			arg2_290.items = var0_290
			arg2_290.removeFunc = arg0_291

			arg0_290:emit(BaseUI.ON_WORLD_ACHIEVE, arg2_290)
		end,
		function(arg0_292)
			local var0_292 = var1_290[1]

			if not var0_292 then
				arg0_292()

				return
			end

			assert(WorldCollectionProxy.GetCollectionType(var0_292.id) == WorldCollectionProxy.WorldCollectionType.FILE, string.format("collection drop type error#%d", var0_292.id))
			arg0_290:emit(WorldMediator.OnOpenLayer, Context.New({
				mediator = WorldMediaCollectionFilePreviewMediator,
				viewComponent = WorldMediaCollectionFilePreviewLayer,
				data = {
					collectionId = var0_292.id
				},
				onRemoved = arg0_292
			}))
		end
	}, arg3_290)
end

function var0_0.DisplayPhaseAction(arg0_293, arg1_293)
	local var0_293 = {}

	while #arg1_293 > 0 do
		local var1_293 = nowWorld()
		local var2_293 = table.remove(arg1_293, 1)

		table.insert(var0_293, function(arg0_294)
			if var2_293.anim then
				arg0_293:BuildCutInAnim(var2_293.anim, arg0_294)
			elseif var2_293.story then
				if var1_293.isAutoFight then
					arg0_294()
				else
					pg.NewStoryMgr.GetInstance():Play(var2_293.story, arg0_294, true)
				end
			elseif var2_293.drops then
				if var1_293.isAutoFight then
					var1_293:AddAutoInfo("drops", var2_293.drops)
					arg0_294()
				else
					arg0_293:DisplayAwards(var2_293.drops, {}, arg0_294)
				end
			end
		end)
	end

	seriesAsync(var0_293, function()
		arg0_293:Op("OpInteractive")
	end)
end

function var0_0.StartAutoSwitch(arg0_296)
	local var0_296 = nowWorld()
	local var1_296 = var0_296:GetActiveEntrance()
	local var2_296 = var0_296:GetActiveMap()

	if PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_SAFE and PlayerPrefs.GetString("auto_switch_difficult_safe", "only") == "only" and World.ReplacementMapType(var1_296, var2_296) ~= "complete_chapter" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip3"))

		return
	elseif PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_TREASURE and not var0_296:GetGobalFlag("treasure_flag") then
		pg.TipsMgr.GetInstance():ShowTips("without auto switch flag")

		return
	end

	arg0_296:QueryTransport(function(arg0_297)
		if not arg0_297 then
			if PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_TREASURE and World.ReplacementMapType(var1_296, var2_296) == "teasure_chapter" then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip5"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip4"))
			end
		else
			getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
			PlayerPrefs.SetInt("world_skip_precombat", 1)
			PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(SYSTEM_WORLD), 1)
			arg0_296:Op("OpAutoSwitchMap")
		end
	end)
end

function var0_0.MoveAndOpenLayer(arg0_298, arg1_298)
	local var0_298 = {}

	table.insert(var0_298, function(arg0_299)
		arg0_298:Op("OpSetInMap", arg1_298.inMap, arg0_299)
	end)
	seriesAsync(var0_298, function()
		arg0_298:Op("OpOpenLayer", arg1_298.context)
	end)
end

function var0_0.GetDepth(arg0_301)
	return #arg0_301.wsCommands
end

function var0_0.GetCommand(arg0_302, arg1_302)
	return arg0_302.wsCommands[arg1_302 or arg0_302:GetDepth()]
end

function var0_0.Op(arg0_303, arg1_303, ...)
	arg0_303:GetCommand():Op(arg1_303, ...)
end

function var0_0.OpRaw(arg0_304, arg1_304, ...)
	arg0_304:GetCommand():OpRaw(arg1_304, ...)
end

function var0_0.OpOpen(arg0_305)
	local var0_305 = arg0_305:GetDepth()

	WorldConst.Print("open operation stack: " .. var0_305 + 1)
	table.insert(arg0_305.wsCommands, WSCommand.New(var0_305 + 1))
end

function var0_0.OpClose(arg0_306)
	local var0_306 = arg0_306:GetDepth()

	assert(var0_306 > 0)
	WorldConst.Print("close operation stack: " .. var0_306)
	arg0_306.wsCommands[var0_306]:Dispose()
	table.remove(arg0_306.wsCommands, var0_306)
end

function var0_0.OpClear(arg0_307)
	for iter0_307, iter1_307 in ipairs(arg0_307.wsCommands) do
		iter1_307:OpClear()
	end
end

function var0_0.OpDispose(arg0_308)
	for iter0_308, iter1_308 in ipairs(arg0_308.wsCommands) do
		iter1_308:Dispose()
	end

	arg0_308.wsCommands = nil
end

function var0_0.NewMapOp(arg0_309, arg1_309)
	local var0_309 = WBank:Fetch(WorldMapOp)

	var0_309.depth = arg0_309:GetDepth()

	for iter0_309, iter1_309 in pairs(arg1_309) do
		var0_309[iter0_309] = iter1_309
	end

	return var0_309
end

function var0_0.RegistMapOp(arg0_310, arg1_310)
	assert(arg1_310, "mapOp can not be nil.")
	assert(not table.contains(arg0_310.mapOps, arg1_310), "repeated registered mapOp.")
	table.insert(arg0_310.mapOps, arg1_310)
	arg1_310:AddCallbackWhenApplied(function()
		for iter0_311 = #arg0_310.mapOps, 1, -1 do
			if arg0_310.mapOps[iter0_311] == arg1_310 then
				table.remove(arg0_310.mapOps, iter0_311)
			end
		end
	end)
end

function var0_0.VerifyMapOp(arg0_312)
	for iter0_312 = #arg0_312.mapOps, 1, -1 do
		local var0_312 = table.remove(arg0_312.mapOps, iter0_312)

		if not var0_312.applied then
			var0_312:Apply()
		end
	end

	arg0_312:OpClear()
end

function var0_0.GetCompassGridPos(arg0_313, arg1_313, arg2_313, arg3_313)
	WorldGuider.GetInstance():SetTempGridPos(arg0_313.wsMapRight.wsCompass:GetMarkPosition(arg1_313, arg2_313), arg3_313)
end

function var0_0.GetEntranceTrackMark(arg0_314, arg1_314, arg2_314)
	WorldGuider.GetInstance():SetTempGridPos(arg0_314.wsMapRight.wsCompass:GetEntranceTrackMark(arg1_314), arg2_314)
end

function var0_0.GetSlgTilePos(arg0_315, arg1_315, arg2_315, arg3_315)
	WorldGuider.GetInstance():SetTempGridPos2(arg0_315.wsMap:GetCell(arg1_315, arg2_315):GetWorldPos(), arg3_315)
end

function var0_0.GetScannerPos(arg0_316, arg1_316)
	local var0_316 = arg0_316.svScannerPanel.rtPanel.transform
	local var1_316 = arg0_316.svScannerPanel.rtWindow.transform
	local var2_316 = Vector3.New(var1_316.localPosition.x + var1_316.rect.width * (0.5 - var1_316.pivot.x), var1_316.localPosition.y + var1_316.rect.height * (0.5 - var1_316.pivot.y), 0)
	local var3_316 = var0_316:TransformPoint(var2_316)

	WorldGuider.GetInstance():SetTempGridPos(var3_316, arg1_316)
end

function var0_0.GuideSelectModelMap(arg0_317, arg1_317)
	local var0_317 = nowWorld():GetEntrance(arg1_317)

	assert(arg0_317.wsAtlas, "didn't enter the world map mode")
	arg0_317:ClickAtlas(var0_317)
end

return var0_0
