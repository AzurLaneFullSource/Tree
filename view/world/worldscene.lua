local var0 = class("WorldScene", import("..base.BaseUI"))

var0.SceneOp = "WorldScene.SceneOp"
var0.Listeners = {
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
var0.optionsPath = {
	"top/adapt/top_chapter/option",
	"top/adapt/top_stage/option"
}

function var0.forceGC(arg0)
	return true
end

function var0.getUIName(arg0)
	return "WorldUI"
end

function var0.getBGM(arg0)
	local var0 = {}

	if arg0:GetInMap() == false then
		-- block empty
	else
		table.insert(var0, nowWorld():GetActiveMap():GetBGM() or "")
	end

	for iter0, iter1 in ipairs(var0) do
		if iter1 ~= "" then
			return iter1
		end
	end

	return var0.super.getBGM(arg0)
end

function var0.init(arg0)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0:bind(var0.SceneOp, function(arg0, ...)
		arg0:Op(...)
	end)

	local var0 = pg.UIMgr.GetInstance()

	arg0.camera = var0.levelCamera:GetComponent(typeof(Camera))
	arg0.rtUIMain = var0.LevelMain

	setActive(arg0.rtUIMain, false)

	arg0.rtGrid = arg0.rtUIMain:Find("LevelGrid")

	setActive(arg0.rtGrid, true)

	arg0.rtDragLayer = arg0.rtGrid:Find("DragLayer")
	arg0.rtEnvBG = arg0._tf:Find("main/bg")
	arg0.rtTop = arg0._tf:Find("top")
	arg0.rtTopAtlas = arg0.rtTop:Find("adapt/top_chapter")

	setActive(arg0.rtTopAtlas, false)

	arg0.rtRightAtlas = arg0.rtTop:Find("adapt/right_chapter")

	setActive(arg0.rtRightAtlas, false)

	arg0.rtBottomAtlas = arg0.rtTop:Find("adapt/bottom_chapter")

	setActive(arg0.rtBottomAtlas, false)

	arg0.rtTransportAtlas = arg0.rtTop:Find("transport_chapter")

	setActive(arg0.rtTransportAtlas, false)

	arg0.rtTopMap = arg0.rtTop:Find("adapt/top_stage")

	setActive(arg0.rtTopMap, false)

	arg0.rtLeftMap = arg0.rtTop:Find("adapt/left_stage")

	setActive(arg0.rtLeftMap, false)

	arg0.rtRightMap = arg0.rtTop:Find("adapt/right_stage")

	setActive(arg0.rtRightMap, false)

	arg0.rtOutMap = arg0.rtTop:Find("effect_stage")

	setActive(arg0.rtOutMap, false)

	arg0.rtClickStop = arg0.rtTop:Find("stop_click")

	onButton(arg0, arg0.rtClickStop:Find("long_move"), function()
		if #arg0.moveQueue > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_fleet_stop"))
			arg0:ClearMoveQueue()
		end
	end)
	onButton(arg0, arg0.rtClickStop:Find("auto_fight"), function()
		local var0 = nowWorld()

		if var0.isAutoFight then
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_stop"))
			var0:TriggerAutoFight(false)
		else
			assert(false, "stop clicker shouldn't active")
		end
	end)
	setActive(arg0.rtClickStop, false)

	arg0.resAtlas = WorldResource.New()

	arg0.resAtlas:setParent(arg0.rtTopAtlas:Find("resources"), false)

	arg0.resMap = WorldResource.New()

	arg0.resMap:setParent(arg0.rtTopMap:Find("resources"), false)

	arg0.wsPool = WSPool.New()

	arg0.wsPool:Setup(arg0:findTF("resources"))

	arg0.wsAnim = WSAnim.New()

	arg0.wsAnim:Setup()

	arg0.wsTimer = WSTimer.New()

	arg0.wsTimer:Setup()

	arg0.wsDragProxy = WSDragProxy.New()
	arg0.wsDragProxy.transform = arg0.rtDragLayer
	arg0.wsDragProxy.wsTimer = arg0.wsTimer

	arg0.wsDragProxy:Setup({
		clickCall = function(arg0, arg1)
			if arg0.svScannerPanel:isShowing() then
				local var0, var1 = arg0:CheckScannerEnable(arg0:ScreenPos2MapPos(arg1.position))

				if var0 then
					arg0.svScannerPanel:ActionInvoke("DisplayWindow", var0, var1)
				else
					arg0.svScannerPanel:ActionInvoke("HideWindow")
				end
			else
				arg0:OnClickMap(arg0:ScreenPos2MapPos(arg1.position))
			end
		end,
		longPressCall = function()
			arg0:OnLongPressMap(arg0:ScreenPos2MapPos(Vector3(Input.mousePosition.x, Input.mousePosition.y)))
		end
	})

	arg0.wsMapCamera = WSMapCamera.New()
	arg0.wsMapCamera.camera = arg0.camera

	arg0.wsMapCamera:Setup()
	arg0:InitSubView()
	arg0:AddWorldListener()

	arg0.moveQueue = {}
	arg0.achievedList = {}
	arg0.mapOps = {}
	arg0.wsCommands = {}

	WSCommand.Bind(arg0)
	arg0:OpOpen()
end

function var0.InitSubView(arg0)
	arg0.rtPanelList = arg0:findTF("panel_list")
	arg0.svOrderPanel = SVOrderPanel.New(arg0.rtPanelList, arg0.event, {
		wsPool = arg0.wsPool
	})
	arg0.svScannerPanel = SVScannerPanel.New(arg0.rtPanelList, arg0.event)

	arg0:bind(SVScannerPanel.ShowView, function(arg0)
		arg0.wsMap:ShowScannerMap(true)
		setActive(arg0.wsMap.rtTop, false)
		arg0:HideMapUI()
	end)
	arg0:bind(SVScannerPanel.HideView, function(arg0)
		arg0.wsMap:ShowScannerMap(false)
		setActive(arg0.wsMap.rtTop, true)
		arg0:DisplayMapUI()
	end)
	arg0:bind(SVScannerPanel.HideGoing, function(arg0, arg1, arg2)
		arg0.wsMap:ShowScannerMap(false)
		setActive(arg0.wsMap.rtTop, true)
		arg0:DisplayMapUI()
		arg0:OnClickCell(arg1, arg2)
	end)

	arg0.svRealmPanel = SVRealmPanel.New(arg0.rtPanelList, arg0.event)
	arg0.svAchievement = SVAchievement.New(arg0.rtPanelList, arg0.event)

	arg0:bind(SVAchievement.HideView, function(arg0)
		table.remove(arg0.achievedList, 1)

		return (#arg0.achievedList > 0 and function()
			arg0:ShowSubView("Achievement", arg0.achievedList[1])
		end or function()
			arg0:Op("OpInteractive")
		end)()
	end)

	arg0.svDebugPanel = SVDebugPanel.New(arg0.rtPanelList, arg0.event)
	arg0.svFloatPanel = SVFloatPanel.New(arg0.rtTop, arg0.event)

	arg0:bind(SVFloatPanel.ReturnCall, function(arg0, arg1)
		arg0:Op("OpCall", function(arg0)
			arg0()

			local var0 = nowWorld():GetActiveEntrance()

			if arg1.id == var0.id then
				arg0.wsAtlas:UpdateSelect()
				arg0.wsAtlas:UpdateSelect(arg1)
			else
				arg0:ClickAtlas(var0)
			end
		end)
	end)

	arg0.svPoisonPanel = SVPoisonPanel.New(arg0.rtPanelList, arg0.event)
	arg0.svGlobalBuff = SVGlobalBuff.New(arg0.rtPanelList, arg0.event)

	arg0:bind(SVGlobalBuff.HideView, function(arg0, arg1)
		return existCall(arg1)
	end)

	arg0.svBossProgress = SVBossProgress.New(arg0.rtPanelList, arg0.event)

	arg0:bind(SVBossProgress.HideView, function(arg0, arg1)
		return existCall(arg1)
	end)

	arg0.svSalvageResult = SVSalvageResult.New(arg0.rtPanelList, arg0.event)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.rtTop)

	arg0.warningSairen = not arg0.contextData.inSave

	if arg0.contextData.inWorld then
		arg0:Op("OpSetInMap", false, function()
			arg0.wsAtlas:UpdateSelect(nowWorld():GetActiveEntrance())
		end)
	else
		arg0:Op("OpSetInMap", true)
	end
end

function var0.onBackPressed(arg0)
	if arg0.inCutIn then
		return
	elseif arg0.svDebugPanel:isShowing() then
		arg0:HideSubView("DebugPanel")
	elseif arg0.svAchievement:isShowing() then
		arg0:HideSubView("Achievement")
	elseif arg0.svGlobalBuff:isShowing() then
		arg0:HideSubView("GlobalBuff")
	elseif arg0.svBossProgress:isShowing() then
		arg0:HideSubView("BossProgress")
	elseif arg0.svOrderPanel:isShowing() then
		arg0:HideSubView("OrderPanel")
	elseif arg0.svScannerPanel:isShowing() then
		arg0:HideSubView("ScannerPanel")
	elseif arg0.svPoisonPanel:isShowing() then
		arg0:HideSubView("PoisonPanel")
	elseif arg0.svSalvageResult:isShowing() then
		arg0:HideSubView("SalvageResult")
	elseif arg0.wsMapLeft and isActive(arg0.wsMapLeft.toggleMask) then
		arg0.wsMapLeft:HideToggleMask()
	elseif arg0:GetInMap() then
		triggerButton(arg0.wsMapTop.btnBack)
	else
		triggerButton(arg0.rtTopAtlas:Find("back_button"))
	end
end

function var0.quickExitFunc(arg0)
	arg0:Op("OpCall", function(arg0)
		arg0()

		local var0 = {}

		if nowWorld():CheckReset() then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_recycle_notice"),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			var0.super.quickExitFunc(arg0)
		end)
	end)
end

function var0.ExitWorld(arg0, arg1, arg2)
	local var0 = {}

	if not arg2 then
		table.insert(var0, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_exit_tip"),
				onYes = arg0,
				onNo = function()
					return existCall(arg1)
				end
			})
		end)
	end

	if not arg2 and nowWorld():CheckReset() then
		table.insert(var0, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_recycle_notice"),
				onYes = arg0,
				onNo = function()
					return existCall(arg1)
				end
			})
		end)
	end

	table.insert(var0, function(arg0)
		if arg0:GetInMap() then
			arg0:EaseOutMapUI(arg0)
		else
			arg0:EaseOutAtlasUI(arg0)
		end
	end)
	seriesAsync(var0, function()
		existCall(arg1)
		arg0:closeView()
	end)
end

function var0.SaveState(arg0)
	arg0.contextData.inSave = true
	arg0.contextData.inWorld = arg0:GetInMap() == false
	arg0.contextData.inShop = false
	arg0.contextData.inPort = false
end

function var0.willExit(arg0)
	arg0:SaveState()
	arg0:RemoveWorldListener()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.rtTop, arg0._tf)
	arg0.svOrderPanel:Destroy()
	arg0.svScannerPanel:Destroy()
	arg0.svAchievement:Destroy()
	arg0.svRealmPanel:Destroy()
	arg0.svDebugPanel:Destroy()
	arg0.svFloatPanel:Destroy()
	arg0.svPoisonPanel:Destroy()
	arg0.svGlobalBuff:Destroy()
	arg0.svBossProgress:Destroy()
	arg0:DisposeAtlas()
	arg0:DisposeAtlasUI()
	arg0:DisposeMap()
	arg0:DisposeMapUI()
	arg0.wsPool:Dispose()

	arg0.wsPool = nil

	arg0.wsAnim:Dispose()

	arg0.wsAnim = nil

	arg0.wsTimer:Dispose()

	arg0.wsTimer = nil

	arg0.wsDragProxy:Dispose()

	arg0.wsDragProxy = nil

	arg0.wsMapCamera:Dispose()

	arg0.wsMapCamera = nil

	arg0.resAtlas:exit()

	arg0.resAtlas = nil

	arg0.resMap:exit()

	arg0.resMap = nil

	arg0:VerifyMapOp()
	arg0:OpDispose()
	WSCommand.Unbind(arg0)
	WBank:Recycle(WorldMapOp)
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1

	arg0.resAtlas:setPlayer(arg0.player)
	arg0.resMap:setPlayer(arg0.player)
end

function var0.AddWorldListener(arg0)
	local var0 = nowWorld()

	var0:AddListener(World.EventUpdateProgress, arg0.onUpdateProgress)
	var0:GetTaskProxy():AddListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0.onUpdateDaily)
end

function var0.RemoveWorldListener(arg0)
	local var0 = nowWorld()

	var0:RemoveListener(World.EventUpdateProgress, arg0.onUpdateProgress)
	var0:GetTaskProxy():RemoveListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0.onUpdateDaily)
end

function var0.SetInMap(arg0, arg1, arg2)
	if arg1 then
		arg2 = defaultValue(arg2, function()
			arg0:Op("OpInteractive")
		end)
	end

	if arg0.inMap == arg1 then
		return existCall(arg2)
	end

	local var0 = {}
	local var1 = {}

	arg0:StopAnim()

	if arg0.inMap then
		table.insert(var0, function(arg0)
			arg0:Op("OpSwitchOutMap", arg0)
		end)
	elseif arg0.inMap ~= nil then
		table.insert(var0, function(arg0)
			arg0:Op("OpSwitchOutWorld", arg0)
		end)
	end

	table.insert(var0, function(arg0)
		arg0:Op("OpCall", function(arg0)
			parallelAsync(var1, function()
				arg0()

				return arg0()
			end)
		end)
	end)
	table.insert(var1, function(arg0)
		arg0:DisplayEnv(arg0)
	end)

	if arg1 then
		table.insert(var1, function(arg0)
			arg0:LoadMap(nowWorld():GetActiveMap(), arg0)
		end)
		table.insert(var0, function(arg0)
			arg0:Op("OpSwitchInMap", arg0)
		end)
	else
		table.insert(var1, function(arg0)
			arg0:LoadAtlas(arg0)
		end)
		table.insert(var0, function(arg0)
			arg0:Op("OpSwitchInWorld", arg0)
		end)
	end

	table.insert(var0, function(arg0)
		arg0:PlayBGM()
		arg0()
	end)

	arg0.inMap = arg1

	seriesAsync(var0, arg2)
end

function var0.GetInMap(arg0)
	return arg0.inMap
end

function var0.ShowSubView(arg0, arg1, arg2, arg3)
	local var0 = arg0["sv" .. arg1]

	var0:Load()
	var0:ActionInvoke("Setup", unpack(arg2 or {}))
	var0:ActionInvoke("Show", unpack(arg3 or {}))
end

function var0.HideSubView(arg0, arg1, ...)
	arg0["sv" .. arg1]:ActionInvoke("Hide", ...)
end

function var0.DisplayAtlasUI(arg0)
	arg0:DisplayAtlasTop()
	arg0:DisplayAtlasRight()
	arg0:DisplayAtlasBottom()
	arg0:UpdateSystemOpen()
end

function var0.HideAtlasUI(arg0)
	arg0:HideAtlasTop()
	arg0:HideAtlasRight()
	arg0:HideAtlasBottom()
end

function var0.EaseInAtlasUI(arg0, arg1)
	arg0:CancelAtlasUITween()
	parallelAsync({
		function(arg0)
			setAnchoredPosition(arg0.rtTopAtlas, {
				y = arg0.rtTopAtlas.rect.height
			})
			arg0.wsTimer:AddTween(LeanTween.moveY(arg0.rtTopAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0)).uniqueId)
		end,
		function(arg0)
			setAnchoredPosition(arg0.rtBottomAtlas, {
				y = -arg0.rtBottomAtlas.rect.height
			})
			arg0.wsTimer:AddTween(LeanTween.moveY(arg0.rtBottomAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0)).uniqueId)
		end,
		function(arg0)
			setAnchoredPosition(arg0.rtRightAtlas, {
				x = arg0.rtRightAtlas.rect.width
			})
			arg0.wsTimer:AddTween(LeanTween.moveX(arg0.rtRightAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0)).uniqueId)
		end
	}, function()
		return existCall(arg1)
	end)
end

function var0.EaseOutAtlasUI(arg0, arg1)
	arg0:CancelAtlasUITween()
	parallelAsync({
		function(arg0)
			setAnchoredPosition(arg0.rtTopAtlas, {
				y = 0
			})
			arg0.wsTimer:AddTween(LeanTween.moveY(arg0.rtTopAtlas, arg0.rtTopAtlas.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0)).uniqueId)
		end,
		function(arg0)
			setAnchoredPosition(arg0.rtBottomAtlas, {
				y = 0
			})
			arg0.wsTimer:AddTween(LeanTween.moveY(arg0.rtBottomAtlas, -arg0.rtBottomAtlas.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0)).uniqueId)
		end,
		function(arg0)
			setAnchoredPosition(arg0.rtRightAtlas, {
				x = 0
			})
			arg0.wsTimer:AddTween(LeanTween.moveX(arg0.rtRightAtlas, arg0.rtRightAtlas.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0)).uniqueId)
		end
	}, function()
		return existCall(arg1)
	end)
end

function var0.CancelAtlasUITween(arg0)
	LeanTween.cancel(go(arg0.rtTransportAtlas))
	LeanTween.cancel(go(arg0.rtTopAtlas))
	LeanTween.cancel(go(arg0.rtBottomAtlas))
	LeanTween.cancel(go(arg0.rtRightAtlas))
end

function var0.DisposeAtlasUI(arg0)
	arg0:HideAtlasUI()
	arg0:DisposeAtlasTransport()
	arg0:DisposeAtlasTop()
	arg0:DisposeAtlasRight()
	arg0:DisposeAtlasBottom()
end

function var0.DisplayAtlas(arg0)
	local var0 = nowWorld():GetActiveEntrance()

	arg0.wsAtlas:SwitchArea(var0:GetAreaId())
	arg0.wsAtlas:UpdateActiveMark()
	arg0.wsAtlas:ShowOrHide(true)
end

function var0.HideAtlas(arg0)
	arg0.wsAtlas:UpdateSelect()
	arg0.wsAtlas:ShowOrHide(false)
end

function var0.ClickAtlas(arg0, arg1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

	local var0 = arg1:GetAreaId()

	if not nowWorld():CheckAreaUnlock(var0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("area_lock"))

		return
	end

	if arg0.wsAtlas.nowArea then
		arg0.wsAtlas:UpdateSelect()

		if arg0.wsAtlas.selectEntrance ~= arg1 then
			arg0.wsAtlas:UpdateSelect(arg1)
		end
	else
		arg0:EnterToModelMap(var0)
	end
end

function var0.LoadAtlas(arg0, arg1)
	local var0 = {}

	if not arg0.wsAtlas then
		table.insert(var0, function(arg0)
			arg0.wsAtlas = arg0:NewAtlas()

			arg0.wsAtlas:LoadScene(function()
				arg0.wsAtlas:AddListener(WSAtlasWorld.EventUpdateselectEntrance, arg0.onModelSelectMap)
				arg0.wsAtlas:UpdateAtlas(nowWorld():GetAtlas())

				return arg0()
			end)
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.NewAtlas(arg0)
	local var0 = WSAtlasWorld.New()

	var0.wsTimer = arg0.wsTimer

	function var0.onClickColor(arg0, arg1)
		if arg0.wsAtlas:CheckIsTweening() then
			return
		end

		arg0:Op("OpCall", function(arg0)
			arg0()
			arg0:ClickAtlas(arg0)
		end)
	end

	var0:Setup()

	return var0
end

function var0.DisposeAtlas(arg0)
	if arg0.wsAtlas then
		arg0:HideAtlas()
		arg0.wsAtlas:RemoveListener(WSAtlasWorld.EventUpdateselectEntrance, arg0.onModelSelectMap)
		arg0.wsAtlas:Dispose()

		arg0.wsAtlas = nil
	end
end

function var0.DisplayAtlasTop(arg0)
	arg0.wsAtlasTop = arg0.wsAtlasTop or arg0:NewAtlasTop(arg0.rtTopAtlas)

	setActive(arg0.rtTopAtlas, true)
	setActive(arg0.rtTopAtlas:Find("print/title_world"), true)
	setActive(arg0.rtTopAtlas:Find("print/title_view"), false)
	setActive(arg0.rtTopAtlas:Find("sairen_warning"), arg0.warningSairen and #nowWorld():GetAtlas().sairenEntranceList > 0)

	arg0.warningSairen = false
end

function var0.HideAtlasTop(arg0)
	setActive(arg0.rtTopAtlas, false)
end

function var0.NewAtlasTop(arg0, arg1)
	local var0 = {
		transform = arg1
	}

	onButton(arg0, arg1:Find("back_button"), function()
		arg0:Op("OpCall", function(arg0)
			arg0()
			arg0:BackToMap()
		end)
	end, SFX_CANCEL)

	return var0
end

function var0.DisposeAtlasTop(arg0)
	arg0.wsAtlasTop = nil
end

function var0.DisplayAtlasRight(arg0)
	arg0.wsAtlasRight = arg0.wsAtlasRight or arg0:NewAtlasRight(arg0.rtRightAtlas)

	arg0.wsAtlasRight:SetOverSize(arg0.rtTop:Find("adapt").offsetMax.x)
	setActive(arg0.rtRightAtlas, true)
end

function var0.HideAtlasRight(arg0)
	setActive(arg0.rtRightAtlas, false)
end

function var0.NewAtlasRight(arg0, arg1, arg2)
	local var0 = WSAtlasRight.New()

	var0.transform = arg1

	var0:Setup()
	onButton(arg0, var0.btnSettings, function()
		arg0:Op("OpOpenScene", SCENE.SETTINGS, {
			scroll = "world_settings",
			page = NewSettingsScene.PAGE_OPTION
		})
	end, SFX_PANEL)
	onButton(arg0, var0.btnSwitch, function()
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldSwitchPlanningMediator,
			viewComponent = WorldSwitchPlanningLayer
		}))
	end, SFX_CONFIRM)

	return var0
end

function var0.DisposeAtlasRight(arg0)
	if arg0.wsAtlasRight then
		arg0.wsAtlasRight:Dispose()

		arg0.wsAtlasRight = nil
	end
end

function var0.DisplayAtlasBottom(arg0)
	arg0.wsAtlasBottom = arg0.wsAtlasBottom or arg0:NewAtlasBottom(arg0.rtBottomAtlas)

	arg0.wsAtlasBottom:SetOverSize(arg0.rtTop:Find("adapt").offsetMax.x)
	arg0.wsAtlasBottom:UpdateScale(1)
	setActive(arg0.rtBottomAtlas, true)
	setActive(arg0.wsAtlasBottom.btnDailyTask:Find("tip"), nowWorld():GetTaskProxy():canAcceptDailyTask())
end

function var0.HideAtlasBottom(arg0)
	setActive(arg0.rtBottomAtlas, false)
end

function var0.NewAtlasBottom(arg0, arg1)
	local var0 = WSAtlasBottom.New()

	var0.transform = arg1
	var0.wsTimer = arg0.wsTimer

	var0:Setup()

	if CAMERA_MOVE_OPEN then
		var0:AddListener(WSAtlasBottom.EventUpdateScale, arg0.onUpdateScale)
	end

	onButton(arg0, var0.btnOverview, function()
		if arg0.wsAtlas:CheckIsTweening() then
			return
		end

		arg0:Op("OpCall", function(arg0)
			arg0.wsAtlas:LoadModel(function()
				arg0()
				arg0:ReturnToModelArea()
			end)
		end)
	end, SFX_PANEL)
	onButton(arg0, var0.btnBoss, function()
		if nowWorld():GetBossProxy():IsOpen() then
			arg0:Op("OpOpenScene", SCENE.WORLDBOSS)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0, var0.btnShop, function()
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldShopMediator,
			viewComponent = WorldShopLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, var0.btnCollection, function()
		arg0:Op("OpOpenScene", SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_RECORD
		})
	end, SFX_PANEL)
	onButton(arg0, var0.btnDailyTask, function()
		local var0 = nowWorld()

		if var0:IsSystemOpen(WorldConst.SystemDailyTask) then
			var0:GetTaskProxy():checkDailyTask(function()
				arg0:Op("OpOpenLayer", Context.New({
					mediator = WorldDailyTaskMediator,
					viewComponent = WorldDailyTaskLayer
				}))
			end)
		else
			pg.TipsMgr.GetInstance(i18n("world_daily_task_lock"))
		end
	end, SFX_PANEL)

	return var0
end

function var0.DisposeAtlasBottom(arg0)
	if arg0.wsAtlasBottom then
		arg0.wsAtlasBottom:Dispose()

		arg0.wsAtlasBottom = nil
	end
end

function var0.DisplayAtlasTransport(arg0)
	arg0.wsAtlasTransport = arg0.wsAtlasTransport or arg0:NewAtlasTransport(arg0.rtTransportAtlas)

	setActive(arg0.rtTransportAtlas, true)
end

function var0.HideAtlasTransport(arg0)
	setActive(arg0.rtTransportAtlas, false)
end

function var0.NewAtlasTransport(arg0, arg1)
	local var0 = {
		transform = arg1,
		btnBack = arg1:Find("adapt/btn_back")
	}

	onButton(arg0, var0.btnBack, function()
		assert(arg0.inTransportMode, "this isn't transport mode atlas")
		arg0:BackToMap()
	end, SFX_CANCEL)

	return var0
end

function var0.DisposeAtlasTransport(arg0)
	arg0.wsAtlasTransport = nil
end

function var0.DisplayMapUI(arg0)
	arg0:DisplayMapTop()
	arg0:DisplayMapLeft()
	arg0:DisplayMapRight()
	arg0:DisplayMapOut()
	arg0:UpdateSystemOpen()
end

function var0.HideMapUI(arg0)
	arg0:HideMapTop()
	arg0:HideMapLeft()
	arg0:HideMapRight()
	arg0:HideMapOut()
end

function var0.UpdateMapUI(arg0)
	local var0 = nowWorld()
	local var1 = var0:GetActiveEntrance()
	local var2 = var0:GetActiveMap()

	arg0.wsMapTop:Update(var1, var2)
	arg0.wsMapLeft:UpdateMap(var2)
	arg0.wsMapRight:Update(var1, var2)
	arg0.wsMapOut:UpdateMap(var2)
end

function var0.EaseInMapUI(arg0, arg1)
	arg0:CancelMapUITween()
	parallelAsync({
		function(arg0)
			setAnchoredPosition(arg0.rtTopMap, {
				y = arg0.rtTopMap.rect.height
			})
			arg0.wsTimer:AddTween(LeanTween.moveY(arg0.rtTopMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0)).uniqueId)
		end,
		function(arg0)
			setAnchoredPosition(arg0.rtLeftMap, {
				x = -arg0.rtLeftMap.rect.width
			})
			arg0.wsTimer:AddTween(LeanTween.moveX(arg0.rtLeftMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0)).uniqueId)
		end,
		function(arg0)
			setAnchoredPosition(arg0.rtRightMap, {
				x = arg0.rtRightMap.rect.width
			})
			arg0.wsTimer:AddTween(LeanTween.moveX(arg0.rtRightMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0)).uniqueId)
		end
	}, function()
		return existCall(arg1)
	end)
end

function var0.EaseOutMapUI(arg0, arg1)
	arg0:CancelMapUITween()
	parallelAsync({
		function(arg0)
			setAnchoredPosition(arg0.rtTopMap, {
				y = 0
			})
			arg0.wsTimer:AddTween(LeanTween.moveY(arg0.rtTopMap, arg0.rtTopMap.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0)).uniqueId)
		end,
		function(arg0)
			setAnchoredPosition(arg0.rtLeftMap, {
				x = 0
			})
			arg0.wsTimer:AddTween(LeanTween.moveX(arg0.rtLeftMap, -arg0.rtLeftMap.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0)).uniqueId)
		end,
		function(arg0)
			setAnchoredPosition(arg0.rtRightMap, {
				x = 0
			})
			arg0.wsTimer:AddTween(LeanTween.moveX(arg0.rtRightMap, arg0.rtRightMap.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0)).uniqueId)
		end
	}, function()
		return existCall(arg1)
	end)
end

function var0.CancelMapUITween(arg0)
	LeanTween.cancel(go(arg0.rtTopMap))
	LeanTween.cancel(go(arg0.rtLeftMap))
	LeanTween.cancel(go(arg0.rtRightMap))
end

function var0.DisposeMapUI(arg0)
	arg0:DisposeMapTop()
	arg0:DisposeMapLeft()
	arg0:DisposeMapRight()
	arg0:DisposeMapOut()
end

function var0.DisplayMap(arg0)
	setActive(arg0.rtUIMain, true)
end

function var0.HideMap(arg0)
	setActive(arg0.rtUIMain, false)
end

function var0.ShowMargin(arg0, arg1)
	if arg0.wsMap then
		arg0.wsMap:UpdateTransportDisplay(arg1)
	end
end

function var0.LoadMap(arg0, arg1, arg2)
	assert(arg1, "target map not exist.")

	local var0 = {}

	if not arg1:IsValid() then
		table.insert(var0, function(arg0)
			arg0:emit(WorldMediator.OnMapReq, arg1.id, arg0)
		end)
	end

	seriesAsync(var0, function()
		if arg0.wsMap then
			return existCall(arg2)
		else
			arg1:AddListener(WorldMap.EventUpdateActive, arg0.onDisposeMap)
			arg1:AddListener(WorldMap.EventUpdateMoveSpeed, arg0.onClearMoveQueue)

			arg0.wsMap = arg0:NewMap(arg1)

			arg0.wsMap:Load(function()
				arg0.wsMap.transform:SetParent(arg0.rtDragLayer, false)
				setActive(arg0.wsMap.transform, true)
				arg0:InitMap()

				return existCall(arg2)
			end)
		end
	end)
end

function var0.InitMap(arg0)
	for iter0, iter1 in ipairs(arg0.wsMap.wsMapFleets) do
		onButton(arg0, iter1.rtRetreat, function()
			arg0:Op("OpReqRetreat", iter1.fleet)
		end, SFX_PANEL)
		iter1:AddListener(WSMapFleet.EventUpdateSelected, arg0.onFleetSelected)
	end

	arg0.wsMap:AddListener(WSMap.EventUpdateEventTips, arg0.onUpdateEventTips)

	local var0 = nowWorld()

	var0:AddListener(World.EventUpdateSubmarineSupport, arg0.onUpdateSubmarineSupport)
	var0:AddListener(World.EventAchieved, arg0.onAchievementAchieved)

	local var1 = arg0.wsMap.map

	arg0.wsDragProxy:UpdateMap(var1)
	arg0.wsDragProxy:Focus(arg0.wsMap:GetFleet().transform.position)
	arg0.wsMapCamera:UpdateMap(var1)
	arg0:OnUpdateSubmarineSupport()
end

function var0.NewMap(arg0, arg1)
	local var0 = WSMap.New()

	var0.wsPool = arg0.wsPool
	var0.wsTimer = arg0.wsTimer

	var0:Setup(arg1)

	arg0.rtGrid.localEulerAngles = Vector3(arg1.theme.angle, 0, 0)

	return var0
end

function var0.DisposeMap(arg0)
	if arg0.wsMap then
		arg0.wsTimer:ClearInMapTimers()
		arg0.wsTimer:ClearInMapTweens()
		arg0:HideMap()

		local var0 = nowWorld()

		var0:RemoveListener(World.EventUpdateSubmarineSupport, arg0.onUpdateSubmarineSupport)
		var0:RemoveListener(World.EventAchieved, arg0.onAchievementAchieved)

		local var1 = arg0.wsMap.map

		var1:RemoveListener(WorldMap.EventUpdateActive, arg0.onDisposeMap)
		var1:RemoveListener(WorldMap.EventUpdateMoveSpeed, arg0.onClearMoveQueue)
		arg0.wsMap:Dispose()

		arg0.wsMap = nil
	end
end

function var0.OnDisposeMap(arg0, arg1, arg2)
	local var0 = false

	if arg1 == WorldMap.EventUpdateActive then
		var0 = not arg2.active
	end

	if var0 then
		arg0:DisposeMap()
	end
end

function var0.DisplayMapTop(arg0)
	arg0.wsMapTop = arg0.wsMapTop or arg0:NewMapTop(arg0.rtTopMap)

	setActive(arg0.rtTopMap, true)
end

function var0.HideMapTop(arg0)
	setActive(arg0.rtTopMap, false)
end

function var0.NewMapTop(arg0, arg1)
	local var0 = WSMapTop.New()

	var0.transform = arg1

	var0:Setup()

	function var0.cmdSkillFunc(arg0)
		arg0:emit(WorldMediator.OnOpenLayer, Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = arg0
			}
		}))
	end

	function var0.poisonFunc(arg0)
		arg0:ShowSubView("PoisonPanel", {
			arg0
		})
	end

	onButton(arg0, var0.btnBack, function()
		arg0:Op("OpCall", function(arg0)
			arg0:ExitWorld(arg0)
		end)
	end, SFX_CANCEL)

	return var0
end

function var0.DisposeMapTop(arg0)
	if arg0.wsMapTop then
		arg0:HideMapTop()
		arg0.wsMapTop:Dispose()

		arg0.wsMapTop = nil
	end
end

function var0.DisplayMapLeft(arg0)
	arg0.wsMapLeft = arg0.wsMapLeft or arg0:NewMapLeft(arg0.rtLeftMap)

	setActive(arg0.rtLeftMap, true)
end

function var0.HideMapLeft(arg0)
	setActive(arg0.rtLeftMap, false)
end

function var0.NewMapLeft(arg0, arg1)
	local var0 = WSMapLeft.New()

	var0.transform = arg1

	var0:Setup()

	function var0.onAgonyClick()
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldInventoryMediator,
			viewComponent = WorldInventoryLayer,
			data = {
				currentFleetIndex = nowWorld():GetActiveMap().findex
			}
		}))
	end

	function var0.onLongPress(arg0)
		local var0 = nowWorld():GetFleet(arg0.fleetId):GetShipVOs(true)

		arg0:Op("OpOpenScene", SCENE.SHIPINFO, {
			shipId = arg0.id,
			shipVOs = var0
		})
	end

	function var0.onClickSalvage(arg0)
		arg0:Op("OpCall", function(arg0)
			arg0()
			arg0:ShowSubView("SalvageResult", {
				arg0
			})
		end)
	end

	var0:AddListener(WSMapLeft.EventSelectFleet, arg0.onSelectFleet)

	return var0
end

function var0.DisposeMapLeft(arg0)
	if arg0.wsMapLeft then
		arg0:HideMapLeft()
		arg0.wsMapLeft:RemoveListener(WSMapLeft.EventSelectFleet, arg0.onSelectFleet)
		arg0.wsMapLeft:Dispose()

		arg0.wsMapLeft = nil
	end
end

function var0.DisplayMapRight(arg0)
	arg0.wsMapRight = arg0.wsMapRight or arg0:NewMapRight(arg0.rtRightMap)

	setActive(arg0.rtRightMap, true)
	arg0:UpdateAutoFightDisplay()
	arg0:UpdateAutoSwitchDisplay()
end

function var0.HideMapRight(arg0)
	setActive(arg0.rtRightMap, false)
end

function var0.HideMapRightCompass(arg0)
	return
end

function var0.HideMapRightMemo(arg0)
	return
end

function var0.NewMapRight(arg0, arg1)
	local var0 = WSMapRight.New()

	var0.transform = arg1
	var0.wsPool = arg0.wsPool
	var0.wsTimer = arg0.wsTimer

	var0:Setup()
	var0:OnUpdateInfoBtnTip()
	var0:OnUpdateHelpBtnTip()
	onButton(arg0, var0.btnOrder, function()
		arg0:Op("OpShowOrderPanel")
	end, SFX_PANEL)
	onButton(arg0, var0.btnScan, function()
		arg0:Op("OpShowScannerPanel")
	end, SFX_PANEL)
	onButton(arg0, var0.btnDefeat, function()
		var0:OnUpdateHelpBtnTip(true)
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = 4,
				pageId = 5
			}
		}))
	end, SFX_PANEL)
	onButton(arg0, var0.btnDetail, function()
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldDetailMediator,
			viewComponent = WorldDetailLayer,
			data = {
				fleetId = nowWorld():GetActiveMap():GetFleet().id
			}
		}))
	end, SFX_PANEL)
	onButton(arg0, var0.btnInformation, function()
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldInformationMediator,
			viewComponent = WorldInformationLayer,
			data = {
				fleetId = nowWorld():GetActiveMap():GetFleet().id
			}
		}))
	end, SFX_PANEL)
	onButton(arg0, var0.btnInventory, function()
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldInventoryMediator,
			viewComponent = WorldInventoryLayer,
			data = {
				currentFleetIndex = nowWorld():GetActiveMap().findex
			}
		}))
	end, SFX_PANEL)
	onButton(arg0, var0.btnTransport, function()
		arg0:OnClickTransport()
	end, SFX_PANEL)
	onButton(arg0, var0.btnPort, function()
		local var0 = nowWorld():GetActiveMap()
		local var1 = var0:GetFleet()

		if var0:GetCell(var1.row, var1.column):ExistEnemy() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_port_inbattle"))

			return
		end

		arg0:Op("OpReqEnterPort")
	end, SFX_PANEL)
	onButton(arg0, var0.btnExit, function()
		local var0 = nowWorld():GetActiveMap()
		local var1 = {}

		if var0:CheckFleetSalvage(true) then
			table.insert(var1, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_catsearch_leavemap"),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var1, function()
			arg0:Op("OpReqJumpOut", var0.gid)
		end)
	end, SFX_PANEL)
	onButton(arg0, var0.btnHelp, function()
		var0:OnUpdateHelpBtnTip(true)
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, var0.toggleAutoFight:Find("off"), function()
		arg0:Op("OpCall", function(arg0)
			arg0()

			local var0 = {}

			if PlayerPrefs.GetInt("first_auto_fight_mark", 0) == 0 then
				table.insert(var0, function(arg0)
					PlayerPrefs.SetInt("first_auto_fight_mark", 1)
					arg0:Op("OpOpenLayer", Context.New({
						mediator = WorldHelpMediator,
						viewComponent = WorldHelpLayer,
						data = {
							titleId = 2,
							pageId = 8
						},
						onRemoved = arg0
					}))
				end)
			end

			local var1 = nowWorld()

			if var1:IsSystemOpen(WorldConst.SystemOrderSubmarine) and PlayerPrefs.GetInt("world_sub_auto_call", 0) == 1 and var1:GetActiveMap():GetConfig("instruction_available")[1] == 1 and var1:CanCallSubmarineSupport() and not var1:IsSubmarineSupporting() then
				local var2 = var1:CalcOrderCost(WorldConst.OpReqSub)

				if var2 <= PlayerPrefs.GetInt("world_sub_call_line", 0) and var2 <= var1.staminaMgr:GetTotalStamina() then
					if var2 > 0 then
						table.insert(var0, function(arg0)
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("world_instruction_submarine_2", setColorStr(var2, COLOR_GREEN)),
								onYes = function()
									PlayerPrefs.SetInt("autoSubIsAcitve" .. AutoSubCommand.GetAutoSubMark(SYSTEM_WORLD), 1)
									arg0:Op("OpReqSub", arg0)
								end,
								onNo = arg0
							})
						end)
					else
						PlayerPrefs.SetInt("autoSubIsAcitve" .. AutoSubCommand.GetAutoSubMark(SYSTEM_WORLD), 1)
						table.insert(var0, function(arg0)
							arg0:Op("OpReqSub", arg0)
						end)
					end
				end
			end

			seriesAsync(var0, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_begin"))
				getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
				PlayerPrefs.SetInt("world_skip_precombat", 1)
				PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(SYSTEM_WORLD), 1)
				var1:TriggerAutoFight(true)
				arg0:Op("OpInteractive")
			end)
		end)
	end, SFX_PANEL)
	onButton(arg0, var0.toggleAutoFight:Find("on"), function()
		arg0:Op("OpCall", function(arg0)
			arg0()
			nowWorld():TriggerAutoFight(false)
			arg0:Op("OpInteractive")
		end)
	end, SFX_PANEL)
	onButton(arg0, var0.toggleAutoSwitch:Find("off"), function()
		arg0:Op("OpOpenLayer", Context.New({
			mediator = WorldSwitchPlanningMediator,
			viewComponent = WorldSwitchPlanningLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, var0.toggleAutoSwitch:Find("on"), function()
		arg0:Op("OpCall", function(arg0)
			arg0()
			nowWorld():TriggerAutoFight(false)
			arg0:Op("OpInteractive")
		end)
	end, SFX_PANEL)

	return var0
end

function var0.DisposeMapRight(arg0)
	if arg0.wsMapRight then
		arg0:HideMapRight()
		arg0.wsMapRight:Dispose()

		arg0.wsMapRight = nil
	end
end

function var0.DisplayMapOut(arg0)
	arg0.wsMapOut = arg0.wsMapOut or arg0:NewMapOut(arg0.rtOutMap)

	setActive(arg0.rtOutMap, true)
end

function var0.HideMapOut(arg0)
	setActive(arg0.rtOutMap, false)
end

function var0.NewMapOut(arg0, arg1)
	local var0 = WSMapOut.New()

	var0.transform = arg1

	var0:Setup()

	return var0
end

function var0.DisposeMapOut(arg0)
	if arg0.wsMapOut then
		arg0:HideMapOut()
		arg0.wsMapOut:Dispose()

		arg0.wsMapOut = nil
	end
end

function var0.OnUpdateProgress(arg0, arg1, arg2, arg3, arg4)
	arg0:UpdateSystemOpen()

	if arg0.wsMapRight then
		arg0.wsMapRight:OnUpdateHelpBtnTip()
	end
end

function var0.OnUpdateScale(arg0, arg1, arg2, arg3)
	if arg0.wsAtlas and not arg0.wsAtlasBottom:CheckIsTweening() then
		arg0.wsAtlas:UpdateScale(arg3)
	end
end

function var0.OnModelSelectMap(arg0, arg1, arg2, arg3, arg4, arg5)
	if arg3 then
		arg0:ShowSubView("FloatPanel", {
			arg3,
			arg4,
			arg5,
			arg2
		})
	else
		arg0:HideSubView("FloatPanel")
	end
end

function var0.OnUpdateSubmarineSupport(arg0, arg1)
	arg0.wsMap:UpdateSubmarineSupport()

	if arg0.wsMapLeft then
		arg0.wsMapLeft:OnUpdateSubmarineSupport()
	end
end

function var0.OnUpdateDaily(arg0)
	if arg0.wsAtlasBottom then
		setActive(arg0.wsAtlasBottom.btnDailyTask:Find("tip"), nowWorld():GetTaskProxy():canAcceptDailyTask())
	end
end

function var0.OnFleetSelected(arg0, arg1, arg2)
	if arg2.selected then
		arg0.wsDragProxy:Focus(arg2.transform.position, nil, LeanTweenType.easeInOutSine)
	end
end

function var0.OnSelectFleet(arg0, arg1, arg2, arg3)
	if arg3 == nowWorld():GetActiveMap():GetFleet() then
		arg0:Op("OpMoveCamera", 0, 0.1)
	else
		arg0:Op("OpReqSwitchFleet", arg3)
	end
end

function var0.OnClickCell(arg0, arg1, arg2)
	local var0 = nowWorld():GetActiveMap()
	local var1 = var0:GetFleet()
	local var2 = var0:GetCell(arg1, arg2)
	local var3 = var0:FindFleet(var2.row, var2.column)

	if var3 and var3 ~= var1 then
		arg0:Op("OpReqSwitchFleet", var3)
	elseif var0:CheckInteractive() then
		arg0:Op("OpInteractive", true)
	elseif var0:IsSign(arg1, arg2) and ManhattonDist({
		row = var1.row,
		column = var1.column
	}, {
		row = var2.row,
		column = var2.column
	}) <= 1 then
		arg0:Op("OpTriggerSign", var1, var2:GetEventAttachment(), function()
			arg0:Op("OpInteractive")
		end)
	elseif var0:CanLongMove(var1) then
		arg0:Op("OpLongMoveFleet", var1, var2.row, var2.column)
	else
		arg0:Op("OpReqMoveFleet", var1, var2.row, var2.column)
	end
end

function var0.OnClickTransport(arg0)
	if arg0.svScannerPanel:isShowing() then
		return
	end

	arg0:Op("OpCall", function(arg0)
		arg0()
		arg0:QueryTransport(function()
			arg0:EnterTransportWorld()
		end)
	end)
end

function var0.QueryTransport(arg0, arg1)
	local var0 = nowWorld()
	local var1 = var0:GetActiveMap()
	local var2 = {}

	if not var0:IsSystemOpen(WorldConst.SystemOutMap) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))

		return
	end

	if var1:CheckAttachmentTransport() == "story" then
		local var3 = pg.gameset.world_transfer_eventstory.description[1]

		table.insert(var2, function(arg0)
			arg0:OpRaw("OpStory", var3, true, true, false, function(arg0)
				if arg0 == 1 then
					arg0()
				end
			end)
		end)
	end

	if var0:IsSubmarineSupporting() and var1:GetSubmarineFleet():GetAmmo() > 0 then
		table.insert(var2, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_instruction_submarine_6"),
				onYes = arg0
			})
		end)
	end

	if var1:CheckFleetSalvage(true) then
		table.insert(var2, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_catsearch_leavemap"),
				onYes = arg0
			})
		end)
	end

	local var4

	for iter0, iter1 in ipairs(var1:GetNormalFleets()) do
		for iter2, iter3 in ipairs(iter1:GetCarries()) do
			if iter3.config.out_story ~= "" then
				var4 = iter3.config.out_story
			end
		end
	end

	if var4 then
		table.insert(var2, function(arg0)
			arg0:OpRaw("OpStory", var4, true, true, false, function(arg0)
				if arg0 == 1 then
					arg0()
				end
			end)
		end)
	end

	local var5, var6 = var1:CkeckTransport()

	if not var5 then
		table.insert(var2, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var6,
				onYes = arg0
			})
		end)
	end

	seriesAsync(var2, function()
		return arg1(var5)
	end)
end

function var0.OnUpdateEventTips(arg0, arg1, arg2)
	if arg0.wsMapRight then
		arg0.wsMapRight:OnUpdateEventTips()
	end

	if arg0.wsMapTop then
		arg0.wsMapTop:OnUpdatePoison()
	end
end

function var0.OnClickMap(arg0, arg1, arg2)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

	local var0 = arg0.wsMap.map
	local var1 = var0.top
	local var2 = var0.bottom
	local var3 = var0.left
	local var4 = var0.right

	if arg1 < var1 or var2 < arg1 or arg2 < var3 or var4 < arg2 then
		arg0:OnClickTransport()
	else
		arg0:OnClickCell(arg1, arg2)
	end
end

function var0.CheckScannerEnable(arg0, arg1, arg2)
	if nowWorld():IsSystemOpen(WorldConst.SystemScanner) then
		local var0 = arg0.wsMap.map:GetCell(arg1, arg2)

		if var0 and var0:GetInFOV() and not var0:InFog() then
			local var1 = var0:GetScannerAttachment()

			if var1 then
				local var2 = arg0.wsMap:GetCell(arg1, arg2).rtAttachments.position

				return var1, arg0.camera:WorldToScreenPoint(var2)
			end
		end
	end
end

function var0.OnLongPressMap(arg0, arg1, arg2)
	if not arg0.svScannerPanel:isShowing() then
		local var0, var1 = arg0:CheckScannerEnable(arg1, arg2)

		if var0 then
			arg0:Op("OpShowScannerPanel", var0, var1)
		end
	end
end

function var0.OnAchievementAchieved(arg0, arg1, arg2, arg3, arg4)
	if arg3 then
		for iter0, iter1 in ipairs(arg3) do
			pg.TipsMgr.GetInstance():ShowTips(iter1)
		end
	end

	if arg4 then
		local var0 = nowWorld()

		if var0.isAutoFight then
			var0:AddAutoInfo("message", i18n("autofight_discovery", arg4.config.target_desc))
		else
			table.insert(arg0.achievedList, {
				arg4,
				arg0.wsMapRight.btnInformation.position
			})
		end
	end
end

function var0.DoAnim(arg0, arg1, arg2)
	local var0 = arg0.wsAnim

	if not var0:GetAnim(arg1) then
		var0:SetAnim(arg1, arg0:NewUIAnim(arg1))
	end

	var0:GetAnim(arg1):Play(arg2)
end

function var0.NewUIAnim(arg0, arg1)
	local var0 = UIAnim.New()

	var0:Setup(arg1)
	var0:AddListener(UIAnim.EventLoaded, function()
		var0.transform:SetParent(arg0.rtTop, false)
	end)
	var0:Load()

	return var0
end

function var0.DoStrikeAnim(arg0, arg1, arg2, arg3)
	local var0 = arg0.wsAnim

	if not var0:GetAnim(arg1) then
		var0:SetAnim(arg1, arg0:NewStrikeAnim(arg1, arg2))
	else
		var0:GetAnim(arg1):ReloadShip(arg2)
	end

	var0:GetAnim(arg1):Play(arg3)
end

function var0.NewStrikeAnim(arg0, arg1, arg2)
	local var0 = UIStrikeAnim.New()

	var0:Setup(arg1, arg2)
	var0:AddListener(UIStrikeAnim.EventLoaded, function()
		var0.transform:SetParent(arg0.rtTop, false)
	end)
	var0:Load()

	return var0
end

function var0.StopAnim(arg0)
	arg0.wsAnim:Stop()
end

function var0.UpdateSystemOpen(arg0)
	local var0 = nowWorld()

	if arg0:GetInMap() then
		local var1 = var0:GetActiveMap()

		arg0.wsMapLeft.onAgonyClickEnabled = var0:IsSystemOpen(WorldConst.SystemInventory)

		setActive(arg0.wsMapRight.btnInventory, var0:IsSystemOpen(WorldConst.SystemInventory))
		setActive(arg0.wsMapRight.btnTransport, var0:IsSystemOpen(WorldConst.SystemOutMap))
		setActive(arg0.wsMapRight.btnDetail, var0:IsSystemOpen(WorldConst.SystemFleetDetail))
		setActive(arg0.wsMapRight.rtCompassPanel, var0:IsSystemOpen(WorldConst.SystemCompass))
		setActive(arg0.wsMapRight.toggleAutoFight, var1:CanAutoFight())
		setActive(arg0.wsMapRight.toggleAutoSwitch, var0:IsSystemOpen(WorldConst.SystemAutoSwitch))
	else
		setActive(arg0.wsAtlasBottom.btnBoss, var0:IsSystemOpen(WorldConst.SystemWorldBoss))

		local var2 = var0:GetBossProxy():NeedTip()
		local var3 = var0:GetBossProxy():ExistSelfBoss()
		local var4 = WorldBossConst.CanUnlockCurrBoss()
		local var5 = not var3 and not var4

		setActive(arg0.wsAtlasBottom.btnBoss:Find("tip"), var2 or var4 or WorldBossConst.AnyArchivesBossCanGetAward())
		setActive(arg0.wsAtlasBottom.btnBoss:Find("sel"), not var5)

		local var6 = arg0.rtTopAtlas:Find("reset_coutdown")

		onButton(arg0, var6, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("world_reset_tip")
			})
		end, SFX_PANEL)

		local var7 = var0:IsSystemOpen(WorldConst.SystemResetCountDown) and var0:CheckResetProgress()

		setActive(var6, var7)

		if var7 then
			local var8 = var0:GetResetWaitingTime()
			local var9 = math.floor(var8 / 86400)

			if var9 > 0 then
				setText(var6:Find("Text"), i18n("world_reset_1", string.format("  %d  ", var9)))
			elseif var9 == 0 then
				setText(var6:Find("Text"), i18n("world_reset_2", string.format("  %d  ", 0)))
			elseif var9 < 0 then
				setText(var6:Find("Text"), i18n("world_reset_3"))
			end
		end

		setActive(arg0.wsAtlasBottom.btnShop, var0:IsSystemOpen(WorldConst.SystemResetShop))
		setActive(arg0.wsAtlasBottom.btnDailyTask:Find("mask"), not var0:IsSystemOpen(WorldConst.SystemDailyTask))
		setActive(arg0.wsAtlasRight.btnSwitch, var0:IsSystemOpen(WorldConst.SystemAutoSwitch))
	end

	setActive(arg0.resAtlas._tf, var0:IsSystemOpen(WorldConst.SystemResource))
	setActive(arg0.resMap._tf, var0:IsSystemOpen(WorldConst.SystemResource))
end

function var0.EnterToModelMap(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		setActive(arg0.rtTopAtlas:Find("print/title_world"), true)
		setActive(arg0.rtTopAtlas:Find("print/title_view"), false)
		arg0.wsAtlasBottom:UpdateScale(1, true, arg0)
	end)
	table.insert(var0, function(arg0)
		arg0.wsAtlas:SwitchArea(arg1, true, arg0)
	end)
	parallelAsync(var0, function()
		local var0 = nowWorld():GetAtlas():GetActiveEntrance()

		if arg1 == var0:GetAreaId() then
			arg0.wsAtlas:UpdateSelect(var0)
		end
	end)
end

function var0.ReturnToModelArea(arg0)
	arg0.wsAtlas:UpdateSelect()

	local var0 = {}

	table.insert(var0, function(arg0)
		setActive(arg0.rtTopAtlas:Find("print/title_world"), false)
		setActive(arg0.rtTopAtlas:Find("print/title_view"), true)
		arg0.wsAtlasBottom:UpdateScale(0, true, arg0)
	end)
	table.insert(var0, function(arg0)
		arg0.wsAtlas:SwitchArea(nil, true, arg0)
	end)
	parallelAsync(var0, function()
		return
	end)
end

function var0.EnterTransportWorld(arg0, arg1)
	local var0 = nowWorld()

	arg1 = arg1 or {
		entrance = var0:GetActiveEntrance()
	}

	local var1 = {}

	if arg0:GetInMap() then
		table.insert(var1, function(arg0)
			arg0:Op("OpSetInMap", false, arg0)
		end)
	elseif not arg0.wsAtlas.nowArea then
		table.insert(var1, function(arg0)
			arg0.wsAtlas:SwitchArea(arg1.entrance:GetAreaId(), false, arg0)
		end)
	end

	seriesAsync(var1, function()
		arg0.wsAtlas:UpdateSelect()
		arg0.wsAtlas:UpdateSelect(arg1.entrance, arg1.mapId, arg1.mapTypes)
		arg0.wsAtlas:DisplayTransport(arg0.contextData.displayTransDic or {}, function()
			arg0.contextData.displayTransDic = Clone(var0:GetAtlas().transportDic)
		end)
	end)
end

function var0.BackToMap(arg0)
	if arg0.wsAtlas:CheckIsTweening() then
		return
	end

	arg0:Op("OpSetInMap", true)
end

function var0.DisplayEnv(arg0, arg1)
	local var0 = checkExist(nowWorld():GetActiveMap(), {
		"config"
	}, {
		"map_bg"
	}, {
		1
	}) or "model_bg"
	local var1 = {}

	if arg0.rtEnvBG:GetComponent(typeof(Image)).sprite.name ~= var0 then
		table.insert(var1, function(arg0)
			GetSpriteFromAtlasAsync("world/map/" .. var0, var0, function(arg0)
				setImageSprite(arg0.rtEnvBG, arg0)

				return arg0()
			end)
		end)
	end

	seriesAsync(var1, arg1)
end

function var0.ScreenPos2MapPos(arg0, arg1)
	local var0 = arg0.wsMap
	local var1 = var0.map
	local var2 = arg0.camera:ScreenPointToRay(arg1)
	local var3, var4 = Plane.New(var0.rtQuads.forward, -Vector3.Dot(var0.rtQuads.position, var0.rtQuads.forward)):Raycast(var2)

	if var3 then
		local var5 = var2:GetPoint(var4)
		local var6 = var0.rtQuads:InverseTransformPoint(var5)
		local var7 = var1.theme:X2Column(var6.x)

		return var1.theme:Y2Row(var6.y), var7
	end
end

function var0.BuildCutInAnim(arg0, arg1, arg2)
	arg0.tfAnim = arg0.rtPanelList:Find(arg1 .. "(Clone)")

	local var0 = {}

	if not arg0.tfAnim then
		table.insert(var0, function(arg0)
			PoolMgr.GetInstance():GetUI(arg1, true, function(arg0)
				arg0:SetActive(false)

				arg0.tfAnim = tf(arg0)

				arg0.tfAnim:SetParent(arg0.rtPanelList, false)

				return arg0()
			end)
		end)
	end

	table.insert(var0, function(arg0)
		arg0.inCutIn = true

		arg0.tfAnim:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			if not IsNil(arg0.tfAnim) then
				arg0.inCutIn = false

				pg.UIMgr.GetInstance():UnOverlayPanel(arg0.tfAnim, arg0.rtPanelList)
				setActive(arg0.tfAnim, false)

				return arg0()
			end
		end)
		pg.UIMgr.GetInstance():OverlayPanel(arg0.tfAnim)
		setActive(arg0.tfAnim, true)
	end)
	seriesAsync(var0, function()
		return existCall(arg2)
	end)
end

function var0.PlaySound(arg0, arg1, arg2)
	if arg0.cueName then
		pg.CriMgr.GetInstance():StopSE_V3()

		arg0.cueName = nil
	end

	pg.CriMgr.GetInstance():PlaySE_V3(arg1, function()
		arg0.cueName = nil
	end)

	return existCall(arg2)
end

function var0.ChangeTopRaycasts(arg0, arg1)
	GetComponent(arg0.rtTop, typeof(CanvasGroup)).blocksRaycasts = tobool(arg1)
end

function var0.DoTopBlock(arg0, arg1)
	arg0:ChangeTopRaycasts(false)

	return function(...)
		arg0:ChangeTopRaycasts(true)

		return existCall(arg1, ...)
	end
end

function var0.SetMoveQueue(arg0, arg1)
	arg0:ReContinueMoveQueue()

	arg0.moveQueue = arg1
end

function var0.ClearMoveQueue(arg0)
	arg0:DisplayMoveStopClick(false)

	arg0.moveQueueInteractive = true

	if #arg0.moveQueue > 0 then
		arg0.moveQueue = {}
	end

	arg0:ShowFleetMoveTurn(false)
end

function var0.DoQueueMove(arg0, arg1)
	assert(#arg0.moveQueue > 0, "without move queue")
	arg0:DisplayMoveStopClick(true)

	local var0 = nowWorld():GetActiveMap()
	local var1 = _.detect(arg0.moveQueue, function(arg0)
		return arg0.stay
	end)

	if #arg0.moveQueue == 1 and var0:IsSign(var1.row, var1.column) then
		arg0:ClearMoveQueue()

		local var2 = var0:GetCell(var1.row, var1.column)

		arg0:Op("OpTriggerSign", arg1, var2:GetEventAttachment(), function()
			arg0:Op("OpInteractive")
		end)
	else
		arg0:ReContinueMoveQueue()
		arg0:ShowFleetMoveTurn(true)
		arg0:Op("OpReqMoveFleet", arg1, var1.row, var1.column)
	end
end

function var0.CheckMoveQueue(arg0, arg1)
	if #arg0.moveQueue < #arg1 or #arg1 == 0 then
		arg0:ClearMoveQueue()
	else
		local var0 = arg1[#arg1]

		if arg0.moveQueue[#arg1].row ~= var0.row or arg0.moveQueue[#arg1].column ~= var0.column then
			arg0:ClearMoveQueue()
		else
			for iter0 = 1, #arg1 do
				table.remove(arg0.moveQueue, 1)
			end

			if #arg0.moveQueue == 0 then
				arg0:ResetLostMoveQueueCount()

				arg0.moveQueueInteractive = true
			end
		end
	end
end

function var0.InteractiveMoveQueue(arg0)
	if arg0.moveQueueInteractive then
		arg0:ClearMoveQueue()
	else
		arg0:DisplayMoveStopClick(false)

		arg0.moveQueueInteractive = true
	end
end

function var0.ReContinueMoveQueue(arg0)
	arg0.moveQueueInteractive = false
end

function var0.CheckLostMoveQueueCount(arg0)
	arg0.lostMoveQueueCount = defaultValue(arg0.lostMoveQueueCount, 0) + 1

	return arg0.lostMoveQueueCount > WorldConst.AutoFightLoopCountLimit
end

function var0.ResetLostMoveQueueCount(arg0, arg1)
	if arg1 then
		arg0.inLoopAutoFight = true
	end

	arg0.lostMoveQueueCount = 0
end

function var0.DisplayMoveStopClick(arg0, arg1)
	setActive(arg0.rtClickStop, arg1)

	if arg1 then
		local var0 = nowWorld().isAutoFight

		setActive(arg0.rtClickStop:Find("long_move"), not var0)
		setActive(arg0.rtClickStop:Find("auto_fight"), var0)
	end
end

function var0.ShowFleetMoveTurn(arg0, arg1)
	if arg0.wsMap then
		if arg1 then
			arg0.wsMap:GetFleet():PlusMoveTurn()
		else
			arg0.wsMap:GetFleet():ClearMoveTurn()
		end
	end
end

function var0.GetAllPessingAward(arg0, arg1)
	local var0 = nowWorld()
	local var1 = var0:GetAtlas()
	local var2 = {}

	for iter0, iter1 in pairs(var0.pressingAwardDic) do
		if iter1.flag then
			var0:FlagMapPressingAward(iter0)
			var1:MarkMapTransport(iter0)

			local var3 = pg.world_event_complete[iter1.id].event_reward_slgbuff

			if #var3 > 0 then
				var2[var3[1]] = defaultValue(var2[var3[1]], 0) + var3[2]
			end
		end
	end

	local var4 = var0:GetActiveMap()

	if not var4.visionFlag and var0:IsMapVisioned(var4.id) then
		var4:UpdateVisionFlag(true)
	end

	if arg0.wsAtlas then
		arg0.wsAtlas:OnUpdatePressingAward()
	end

	local var5 = {}

	for iter2, iter3 in pairs(var2) do
		table.insert(var5, function(arg0)
			local var0 = {
				id = iter2,
				floor = iter3,
				before = var0:GetGlobalBuff(iter2):GetFloor()
			}

			arg0:ShowSubView("GlobalBuff", {
				var0,
				arg0
			})
		end)
		table.insert(var5, function(arg0)
			var0:AddGlobalBuff(iter2, iter3)
			arg0()
		end)
	end

	seriesAsync(var5, function()
		return existCall(arg1)
	end)
end

function var0.CheckGuideSLG(arg0, arg1, arg2)
	local var0 = nowWorld()
	local var1 = {}

	table.insert(var1, {
		"WorldG007",
		function()
			local var0 = arg1:GetPort()

			if var0 and not var0:IsTempPort() then
				local var1 = arg1:GetFleet()

				return not arg1:GetCell(var1.row, var1.column):ExistEnemy()
			end
		end
	})
	table.insert(var1, {
		"WorldG111",
		function()
			return arg1:canExit()
		end
	})
	table.insert(var1, {
		"WorldG112",
		function()
			local var0 = var0:GetActiveEntrance()

			return var0.becomeSairen and var0:GetSairenMapId() == arg1.id
		end
	})
	table.insert(var1, {
		"WorldG124",
		function()
			return var0:IsSystemOpen(WorldConst.SystemOrderSubmarine) and arg1:GetConfig("instruction_available")[1] ~= 0 and var0:CanCallSubmarineSupport()
		end
	})
	table.insert(var1, {
		"WorldG162",
		function()
			return _.any(arg1:GetNormalFleets(), function(arg0)
				return _.any(arg0:GetShips(true), function(arg0)
					return arg0:IsBroken()
				end)
			end)
		end
	})
	table.insert(var1, {
		"WorldG163",
		function()
			local var0 = var0:GetTaskProxy():getDoingTaskVOs()

			return underscore.any(var0, function(arg0)
				return not arg0:IsAutoSubmit() and arg0:isFinished()
			end)
		end
	})
	table.insert(var1, {
		"WorldG164",
		function()
			return arg1:CheckFleetSalvage(true)
		end
	})
	table.insert(var1, {
		"WorldG181",
		function()
			return var0:GetInventoryProxy():GetItemCount(102) > 0
		end
	})
	table.insert(var1, {
		"WorldG191",
		function()
			return WorldBossConst.CanUnlockCurrBoss() and nowWorld():IsSystemOpen(WorldConst.SystemWorldBoss)
		end
	})

	local var2 = _.filter(arg1:FindAttachments(WorldMapAttachment.TypeEvent), function(arg0)
		return arg0:IsAlive()
	end)

	for iter0, iter1 in ipairs(pg.gameset.world_guide_event.description) do
		table.insert(var1, {
			iter1[2],
			function()
				return _.any(var2, function(arg0)
					return arg0.id == iter1[1]
				end)
			end
		})
	end

	local var3 = pg.NewStoryMgr.GetInstance()

	for iter2, iter3 in ipairs(var1) do
		if not var3:IsPlayed(iter3[1]) and iter3[2]() then
			WorldGuider.GetInstance():PlayGuide(iter3[1])

			return true
		end
	end

	return false
end

function var0.CheckEventForMsg(arg0, arg1)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.player.level, "EventMediator") and getProxy(EventProxy).eventForMsg
end

function var0.OpenPortLayer(arg0, arg1)
	arg0:Op("OpOpenLayer", Context.New({
		mediator = WorldPortMediator,
		viewComponent = WorldPortLayer,
		data = arg1
	}))
end

function var0.ShowTransportMarkOverview(arg0, arg1, arg2)
	if nowWorld():GetActiveMap():CheckFleetSalvage(true) then
		arg0:Op("OpShowMarkOverview", arg1, function()
			pg.NewStoryMgr.GetInstance():Play(pg.gameset.world_catsearch_special.description[1], arg2, true)
		end)
	else
		arg0:Op("OpShowMarkOverview", arg1, arg2)
	end
end

function var0.UpdateAutoFightDisplay(arg0)
	arg0:ClearMoveQueue()

	local var0 = nowWorld().isAutoFight

	if arg0.wsMapRight then
		setActive(arg0.wsMapRight.toggleAutoFight:Find("off"), not var0)
		setActive(arg0.wsMapRight.toggleAutoFight:Find("on"), var0)
		setActive(arg0.wsMapRight.toggleSkipPrecombat, not var0)
		triggerToggle(arg0.wsMapRight.toggleSkipPrecombat, PlayerPrefs.GetInt("world_skip_precombat", 0) == 1)
	end
end

function var0.UpdateAutoSwitchDisplay(arg0)
	local var0 = nowWorld().isAutoSwitch

	if arg0.wsMapRight then
		setActive(arg0.wsMapRight.toggleAutoSwitch:Find("off"), not var0)
		setActive(arg0.wsMapRight.toggleAutoSwitch:Find("on"), var0)
	end
end

function var0.GuideShowScannerEvent(arg0, arg1)
	assert(arg0.svScannerPanel:isShowing(), "scanner mode is closed")

	local var0 = arg0.wsMap.map:FindAttachments(WorldMapAttachment.TypeEvent, arg1)

	assert(#var0 == 1, "event number error: " .. #var0)

	local var1, var2 = arg0:CheckScannerEnable(var0[1].row, var0[1].column)

	assert(var1, "without scanner attachment")
	arg0.svScannerPanel:ActionInvoke("DisplayWindow", var1, var2)
end

function var0.DisplayAwards(arg0, arg1, arg2, arg3)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		if iter1.type == DROP_TYPE_WORLD_COLLECTION then
			table.insert(var1, iter1)
		else
			table.insert(var0, iter1)
		end
	end

	seriesAsync({
		function(arg0)
			if #var0 == 0 then
				return arg0()
			end

			arg2.items = var0
			arg2.removeFunc = arg0

			arg0:emit(BaseUI.ON_WORLD_ACHIEVE, arg2)
		end,
		function(arg0)
			local var0 = var1[1]

			if not var0 then
				arg0()

				return
			end

			assert(WorldCollectionProxy.GetCollectionType(var0.id) == WorldCollectionProxy.WorldCollectionType.FILE, string.format("collection drop type error#%d", var0.id))
			arg0:emit(WorldMediator.OnOpenLayer, Context.New({
				mediator = WorldMediaCollectionFilePreviewMediator,
				viewComponent = WorldMediaCollectionFilePreviewLayer,
				data = {
					collectionId = var0.id
				},
				onRemoved = arg0
			}))
		end
	}, arg3)
end

function var0.DisplayPhaseAction(arg0, arg1)
	local var0 = {}

	while #arg1 > 0 do
		local var1 = nowWorld()
		local var2 = table.remove(arg1, 1)

		table.insert(var0, function(arg0)
			if var2.anim then
				arg0:BuildCutInAnim(var2.anim, arg0)
			elseif var2.story then
				if var1.isAutoFight then
					arg0()
				else
					pg.NewStoryMgr.GetInstance():Play(var2.story, arg0, true)
				end
			elseif var2.drops then
				if var1.isAutoFight then
					var1:AddAutoInfo("drops", var2.drops)
					arg0()
				else
					arg0:DisplayAwards(var2.drops, {}, arg0)
				end
			end
		end)
	end

	seriesAsync(var0, function()
		arg0:Op("OpInteractive")
	end)
end

function var0.StartAutoSwitch(arg0)
	local var0 = nowWorld()
	local var1 = var0:GetActiveEntrance()
	local var2 = var0:GetActiveMap()

	if PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_SAFE and PlayerPrefs.GetString("auto_switch_difficult_safe", "only") == "only" and World.ReplacementMapType(var1, var2) ~= "complete_chapter" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip3"))

		return
	elseif PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_TREASURE and not var0:GetGobalFlag("treasure_flag") then
		pg.TipsMgr.GetInstance():ShowTips("without auto switch flag")

		return
	end

	arg0:QueryTransport(function(arg0)
		if not arg0 then
			if PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_TREASURE and World.ReplacementMapType(var1, var2) == "teasure_chapter" then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip5"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip4"))
			end
		else
			getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
			PlayerPrefs.SetInt("world_skip_precombat", 1)
			PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(SYSTEM_WORLD), 1)
			arg0:Op("OpAutoSwitchMap")
		end
	end)
end

function var0.MoveAndOpenLayer(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:Op("OpSetInMap", arg1.inMap, arg0)
	end)
	seriesAsync(var0, function()
		arg0:Op("OpOpenLayer", arg1.context)
	end)
end

function var0.GetDepth(arg0)
	return #arg0.wsCommands
end

function var0.GetCommand(arg0, arg1)
	return arg0.wsCommands[arg1 or arg0:GetDepth()]
end

function var0.Op(arg0, arg1, ...)
	arg0:GetCommand():Op(arg1, ...)
end

function var0.OpRaw(arg0, arg1, ...)
	arg0:GetCommand():OpRaw(arg1, ...)
end

function var0.OpOpen(arg0)
	local var0 = arg0:GetDepth()

	WorldConst.Print("open operation stack: " .. var0 + 1)
	table.insert(arg0.wsCommands, WSCommand.New(var0 + 1))
end

function var0.OpClose(arg0)
	local var0 = arg0:GetDepth()

	assert(var0 > 0)
	WorldConst.Print("close operation stack: " .. var0)
	arg0.wsCommands[var0]:Dispose()
	table.remove(arg0.wsCommands, var0)
end

function var0.OpClear(arg0)
	for iter0, iter1 in ipairs(arg0.wsCommands) do
		iter1:OpClear()
	end
end

function var0.OpDispose(arg0)
	for iter0, iter1 in ipairs(arg0.wsCommands) do
		iter1:Dispose()
	end

	arg0.wsCommands = nil
end

function var0.NewMapOp(arg0, arg1)
	local var0 = WBank:Fetch(WorldMapOp)

	var0.depth = arg0:GetDepth()

	for iter0, iter1 in pairs(arg1) do
		var0[iter0] = iter1
	end

	return var0
end

function var0.RegistMapOp(arg0, arg1)
	assert(arg1, "mapOp can not be nil.")
	assert(not table.contains(arg0.mapOps, arg1), "repeated registered mapOp.")
	table.insert(arg0.mapOps, arg1)
	arg1:AddCallbackWhenApplied(function()
		for iter0 = #arg0.mapOps, 1, -1 do
			if arg0.mapOps[iter0] == arg1 then
				table.remove(arg0.mapOps, iter0)
			end
		end
	end)
end

function var0.VerifyMapOp(arg0)
	for iter0 = #arg0.mapOps, 1, -1 do
		local var0 = table.remove(arg0.mapOps, iter0)

		if not var0.applied then
			var0:Apply()
		end
	end

	arg0:OpClear()
end

function var0.GetCompassGridPos(arg0, arg1, arg2, arg3)
	WorldGuider.GetInstance():SetTempGridPos(arg0.wsMapRight.wsCompass:GetMarkPosition(arg1, arg2), arg3)
end

function var0.GetEntranceTrackMark(arg0, arg1, arg2)
	WorldGuider.GetInstance():SetTempGridPos(arg0.wsMapRight.wsCompass:GetEntranceTrackMark(arg1), arg2)
end

function var0.GetSlgTilePos(arg0, arg1, arg2, arg3)
	WorldGuider.GetInstance():SetTempGridPos2(arg0.wsMap:GetCell(arg1, arg2):GetWorldPos(), arg3)
end

function var0.GetScannerPos(arg0, arg1)
	local var0 = arg0.svScannerPanel.rtPanel.transform
	local var1 = arg0.svScannerPanel.rtWindow.transform
	local var2 = Vector3.New(var1.localPosition.x + var1.rect.width * (0.5 - var1.pivot.x), var1.localPosition.y + var1.rect.height * (0.5 - var1.pivot.y), 0)
	local var3 = var0:TransformPoint(var2)

	WorldGuider.GetInstance():SetTempGridPos(var3, arg1)
end

function var0.GuideSelectModelMap(arg0, arg1)
	local var0 = nowWorld():GetEntrance(arg1)

	assert(arg0.wsAtlas, "didn't enter the world map mode")
	arg0:ClickAtlas(var0)
end

return var0
