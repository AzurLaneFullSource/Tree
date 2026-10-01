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

function var0_0.getResource(arg0_4, arg1_4)
	local var0_4 = {
		"scenes/worldmap3d",
		"model/worldmapmodel",
		"world/object/world_plane",
		"ui/darkfog",
		"ui/sairenfog",
		"world/cell/base",
		"world/object/yangliu_shang",
		"world/object/yangliu_you",
		"world/object/yangliu_xia",
		"world/object/yangliu_zuo",
		"world/object/longjuanfeng_shang",
		"world/object/longjuanfeng_you",
		"world/object/longjuanfeng_xia",
		"world/object/longjuanfeng_zuo",
		"world/object/ice",
		"world/object/poison01",
		"world/object/poison02",
		"world/object/longjuanfeng",
		"ui/san_low",
		"weaponframes",
		"shiptype"
	}

	return table.insertto(var0_4, var0_0.super.getResource(arg0_4, arg1_4))
end

function var0_0.insertResToList(arg0_5, arg1_5, arg2_5)
	if noEmptyStr(arg2_5) and not table.contains(arg1_5, arg2_5) then
		table.insert(arg1_5, arg2_5)
	end
end

function var0_0.insertResListToList(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in ipairs(arg2_6 or {}) do
		arg0_6:insertResToList(arg1_6, iter1_6)
	end
end

function var0_0.insertPrefixResToList(arg0_7, arg1_7, arg2_7, arg3_7)
	if noEmptyStr(arg3_7) then
		arg0_7:insertResToList(arg1_7, arg2_7 .. arg3_7)
	end
end

function var0_0.insertWorldBuffIconRes(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg2_8 and arg2_8.config and noEmptyStr(arg2_8.config.icon) then
		arg0_8:insertPrefixResToList(arg1_8, arg3_8, arg2_8.config.icon)
	end
end

function var0_0.downloadWorldResList(arg0_9, arg1_9, arg2_9)
	SplitPackConst.DownloadByLuaArr(arg1_9, function()
		if arg0_9.exited then
			return
		end

		return existCall(arg2_9)
	end)
end

function var0_0.getAtlasResList(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(WSEntranceTpl.prefabName) do
		arg0_11:insertPrefixResToList(var0_11, "world/mark/", iter1_11)
	end

	arg0_11:insertResToList(var0_11, "world/mark/dsj_srgr")

	return var0_11
end

function var0_0.getMapCellResList(arg0_12, arg1_12)
	local var0_12 = {}

	if not arg1_12 then
		return var0_12
	end

	local var1_12 = arg1_12:GetTerrain()

	if var1_12 == WorldMapCell.TerrainStream or var1_12 == WorldMapCell.TerrainWind or var1_12 == WorldMapCell.TerrainIce or var1_12 == WorldMapCell.TerrainPoison then
		arg0_12:insertResToList(var0_12, (WorldConst.GetTerrainEffectRes(var1_12, arg1_12.terrainDir, arg1_12.terrainStrong)))
	end

	local var2_12 = arg1_12:GetEmotion()

	if noEmptyStr(var2_12) then
		arg0_12:insertResToList(var0_12, "ui/" .. var2_12)
	end

	return var0_12
end

function var0_0.getMapAttachmentResList(arg0_13, arg1_13, arg2_13)
	local var0_13 = {}

	if not arg2_13 then
		return var0_13
	end

	if arg2_13.type == WorldMapAttachment.TypeArtifact then
		local var1_13 = arg2_13:GetArtifaceInfo()

		if var1_13 and noEmptyStr(var1_13[3]) then
			arg0_13:insertPrefixResToList(var0_13, WorldConst.ResChapterPrefab, var1_13[3])
		end

		return var0_13
	end

	local var2_13 = arg2_13.config

	if not var2_13 then
		return var0_13
	end

	if arg2_13.type == WorldMapAttachment.TypeEvent then
		local var3_13 = arg2_13:GetReplaceDisplayEnemyConfig()

		if var3_13 then
			if arg2_13:IsAvatar() then
				arg0_13:insertPrefixResToList(var0_13, "char/", var3_13.icon)
			else
				arg0_13:insertPrefixResToList(var0_13, "enemies/", var3_13.icon)

				if noEmptyStr(var3_13.icon) then
					arg0_13:insertResToList(var0_13, "enemies/" .. var3_13.icon .. "_d_blue")
				end
			end
		elseif arg2_13:IsAvatar() then
			arg0_13:insertPrefixResToList(var0_13, "char/", var2_13.icon)
		elseif math.floor(var2_13.enemyicon / 2) == 2 then
			arg0_13:insertPrefixResToList(var0_13, WorldConst.ResChapterPrefab, var2_13.icon)
		elseif math.floor(var2_13.enemyicon / 2) == 0 then
			arg0_13:insertPrefixResToList(var0_13, WorldConst.ResBoxPrefab, var2_13.icon)
		end
	elseif arg2_13.type == WorldMapAttachment.TypeBox then
		if arg2_13:IsAvatar() then
			arg0_13:insertPrefixResToList(var0_13, "char/", var2_13.icon)
		else
			arg0_13:insertPrefixResToList(var0_13, WorldConst.ResBoxPrefab, var2_13.icon)
		end
	elseif WorldMapAttachment.IsEnemyType(arg2_13.type) then
		if arg2_13:IsAvatar() then
			arg0_13:insertPrefixResToList(var0_13, "char/", var2_13.icon)
		else
			arg0_13:insertPrefixResToList(var0_13, "enemies/", var2_13.icon)

			if noEmptyStr(var2_13.icon) then
				arg0_13:insertResToList(var0_13, "enemies/" .. var2_13.icon .. "_d_blue")
			end
		end
	elseif arg2_13.type == WorldMapAttachment.TypeTransportFleet then
		arg0_13:insertPrefixResToList(var0_13, "enemies/", var2_13.icon)
	elseif arg2_13.type == WorldMapAttachment.TypeTrap then
		if arg2_13:IsAvatar() then
			arg0_13:insertPrefixResToList(var0_13, "char/", var2_13.trap_fx)
		else
			arg0_13:insertPrefixResToList(var0_13, WorldConst.ResBoxPrefab, var2_13.trap_fx)
		end
	end

	for iter0_13, iter1_13 in ipairs(arg2_13:GetBuffList()) do
		arg0_13:insertWorldBuffIconRes(var0_13, iter1_13, "world/buff/")
	end

	if arg1_13 then
		local var4_13 = arg2_13:GetRadiationBuffs()

		if #var4_13 > 0 then
			local var5_13, var6_13, var7_13 = unpack(var4_13[1])
			local var8_13 = pg.world_SLGbuff_data[var6_13]

			if var8_13 then
				arg0_13:insertPrefixResToList(var0_13, "world/mapbuff/", var8_13.icon)
			end
		else
			for iter2_13, iter3_13 in ipairs(arg1_13:GetBuffList(WorldMap.FactionEnemy, arg2_13)) do
				arg0_13:insertWorldBuffIconRes(var0_13, iter3_13, "world/mapbuff/")
			end
		end
	end

	return var0_13
end

function var0_0.getCarryItemResList(arg0_14, arg1_14)
	local var0_14 = {}

	if arg1_14 and arg1_14.config then
		if arg1_14:IsAvatar() then
			arg0_14:insertPrefixResToList(var0_14, "char/", arg1_14.config.icon)
		else
			arg0_14:insertPrefixResToList(var0_14, WorldConst.ResBoxPrefab, arg1_14.config.icon)
		end
	end

	return var0_14
end

function var0_0.getWorldFleetResList(arg0_15, arg1_15)
	local var0_15 = {}

	if not arg1_15 then
		return var0_15
	end

	arg0_15:insertPrefixResToList(var0_15, "char/", arg1_15:GetPrefab())

	for iter0_15, iter1_15 in ipairs(arg1_15:GetBuffFxList()) do
		if type(iter1_15) == "table" then
			for iter2_15, iter3_15 in ipairs(iter1_15) do
				arg0_15:insertPrefixResToList(var0_15, "ui/", iter3_15)
			end
		else
			arg0_15:insertPrefixResToList(var0_15, "ui/", iter1_15)
		end
	end

	for iter4_15, iter5_15 in ipairs(arg1_15:GetCarries()) do
		arg0_15:insertResListToList(var0_15, arg0_15:getCarryItemResList(iter5_15))
	end

	for iter6_15, iter7_15 in ipairs(arg1_15:GetBuffList()) do
		arg0_15:insertWorldBuffIconRes(var0_15, iter7_15, "world/buff/")
	end

	arg0_15:insertWorldBuffIconRes(var0_15, arg1_15:GetDamageBuff(), "world/buff/")
	arg0_15:insertWorldBuffIconRes(var0_15, arg1_15:GetWatchingBuff(), "world/watchingbuff/")

	if arg1_15:IsCatSalvage() then
		local var1_15 = arg1_15:GetDisplayCommander()

		if var1_15 then
			arg0_15:insertPrefixResToList(var0_15, "commandericon/", var1_15:getPainting())
		end
	end

	for iter8_15, iter9_15 in pairs(arg1_15:getCommanders()) do
		if iter9_15 then
			local var2_15 = iter9_15:getSkills()[1]

			if var2_15 then
				arg0_15:insertPrefixResToList(var0_15, "commanderskillicon/", var2_15:getConfig("icon"))
			end
		end
	end

	for iter10_15, iter11_15 in ipairs({
		TeamType.Main,
		TeamType.Vanguard
	}) do
		for iter12_15, iter13_15 in ipairs(arg1_15:GetTeamShips(iter11_15, true)) do
			local var3_15 = WorldConst.FetchShipVO(iter13_15.id)

			if var3_15 then
				arg0_15:insertPrefixResToList(var0_15, "SquareIcon/", var3_15:getPainting())
			end
		end
	end

	return var0_15
end

function var0_0.getMapResList(arg0_16, arg1_16)
	local var0_16 = {
		"world/object/world_plane",
		"ui/darkfog",
		"ui/sairenfog",
		"world/cell/base",
		"world/object/yangliu_shang",
		"world/object/yangliu_you",
		"world/object/yangliu_xia",
		"world/object/yangliu_zuo",
		"world/object/longjuanfeng_shang",
		"world/object/longjuanfeng_you",
		"world/object/longjuanfeng_xia",
		"world/object/longjuanfeng_zuo",
		"world/object/ice",
		"world/object/poison01",
		"world/object/poison02",
		"world/object/longjuanfeng",
		"ui/san_low",
		"weaponframes",
		"shiptype"
	}

	if not arg1_16 then
		return var0_16
	end

	if arg1_16.theme and noEmptyStr(arg1_16.theme.assetSea) then
		arg0_16:insertPrefixResToList(var0_16, "chapter/pic/", arg1_16.theme.assetSea)
	end

	for iter0_16, iter1_16 in ipairs(checkExist(arg1_16, {
		"config"
	}, {
		"float_items"
	}) or {}) do
		arg0_16:insertPrefixResToList(var0_16, WorldConst.ResChapterPrefab, iter1_16[3])
	end

	for iter2_16, iter3_16 in pairs(arg1_16.cells or {}) do
		arg0_16:insertResListToList(var0_16, arg0_16:getMapCellResList(iter3_16))

		for iter4_16, iter5_16 in ipairs(iter3_16.attachments or {}) do
			arg0_16:insertResListToList(var0_16, arg0_16:getMapAttachmentResList(arg1_16, iter5_16))
		end
	end

	for iter6_16, iter7_16 in ipairs(arg1_16:GetNormalFleets()) do
		arg0_16:insertResListToList(var0_16, arg0_16:getWorldFleetResList(iter7_16))
	end

	for iter8_16, iter9_16 in ipairs(nowWorld():GetWorldMapBuffs()) do
		arg0_16:insertWorldBuffIconRes(var0_16, iter9_16, "world/buff/")
	end

	local var1_16 = WorldBuff.New()

	var1_16:Setup({
		floor = 0,
		id = WorldConst.MoveLimitBuffId
	})
	arg0_16:insertWorldBuffIconRes(var0_16, var1_16, "world/buff/")

	return var0_16
end

function var0_0.getUIAnimResList(arg0_17, arg1_17)
	local var0_17 = {}

	arg0_17:insertPrefixResToList(var0_17, "ui/", arg1_17)

	return var0_17
end

function var0_0.getStrikeAnimResList(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18:getUIAnimResList(arg1_18)

	if arg2_18 then
		arg0_18:insertPrefixResToList(var0_18, "painting/", arg2_18:getPainting())
		arg0_18:insertPrefixResToList(var0_18, "char/", arg2_18:getPrefab())
	end

	return var0_18
end

function var0_0.init(arg0_19)
	for iter0_19, iter1_19 in pairs(var0_0.Listeners) do
		arg0_19[iter0_19] = function(...)
			var0_0[iter1_19](arg0_19, ...)
		end
	end

	arg0_19:bind(var0_0.SceneOp, function(arg0_21, ...)
		arg0_19:Op(...)
	end)

	arg0_19.camera = pg.UIMgr.GetInstance().levelCamera:GetComponent(typeof(Camera))
	arg0_19.rtUIMain = pg.UIMgr.GetInstance().LevelMain

	setActive(arg0_19.rtUIMain, false)

	arg0_19.rtGrid = arg0_19.rtUIMain:Find("LevelGrid")

	setActive(arg0_19.rtGrid, true)

	arg0_19.rtDragLayer = arg0_19.rtGrid:Find("DragLayer")
	arg0_19.rtEnvBG = arg0_19._tf:Find("main/bg")
	arg0_19.rtTop = arg0_19._tf:Find("top")
	arg0_19.rtTopAtlas = arg0_19.rtTop:Find("adapt/top_chapter")

	setActive(arg0_19.rtTopAtlas, false)

	arg0_19.rtRightAtlas = arg0_19.rtTop:Find("adapt/right_chapter")

	setActive(arg0_19.rtRightAtlas, false)

	arg0_19.rtBottomAtlas = arg0_19.rtTop:Find("adapt/bottom_chapter")

	setActive(arg0_19.rtBottomAtlas, false)

	arg0_19.rtTransportAtlas = arg0_19.rtTop:Find("transport_chapter")

	setActive(arg0_19.rtTransportAtlas, false)

	arg0_19.rtTopMap = arg0_19.rtTop:Find("adapt/top_stage")

	setActive(arg0_19.rtTopMap, false)

	arg0_19.rtLeftMap = arg0_19.rtTop:Find("adapt/left_stage")

	setActive(arg0_19.rtLeftMap, false)

	arg0_19.rtRightMap = arg0_19.rtTop:Find("adapt/right_stage")

	setActive(arg0_19.rtRightMap, false)

	arg0_19.rtOutMap = arg0_19.rtTop:Find("effect_stage")

	setActive(arg0_19.rtOutMap, false)

	arg0_19.rtClickStop = arg0_19.rtTop:Find("stop_click")

	onButton(arg0_19, arg0_19.rtClickStop:Find("long_move"), function()
		if #arg0_19.moveQueue > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_fleet_stop"))
			arg0_19:ClearMoveQueue()
		end
	end)
	onButton(arg0_19, arg0_19.rtClickStop:Find("auto_fight"), function()
		local var0_23 = nowWorld()

		if var0_23.isAutoFight then
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_stop"))
			var0_23:TriggerAutoFight(false)
		else
			assert(false, "stop clicker shouldn't active")
		end
	end)
	setActive(arg0_19.rtClickStop, false)

	arg0_19.resAtlas = WorldResource.New()

	arg0_19.resAtlas:setParent(arg0_19.rtTopAtlas:Find("resources"), false)

	arg0_19.resMap = WorldResource.New()

	arg0_19.resMap:setParent(arg0_19.rtTopMap:Find("resources"), false)

	arg0_19.wsPool = WSPool.New()

	arg0_19.wsPool:Setup(arg0_19._tf:Find("resources"))

	arg0_19.wsAnim = WSAnim.New()

	arg0_19.wsAnim:Setup()

	arg0_19.wsTimer = WSTimer.New()

	arg0_19.wsTimer:Setup()

	arg0_19.wsDragProxy = WSDragProxy.New()
	arg0_19.wsDragProxy.transform = arg0_19.rtDragLayer
	arg0_19.wsDragProxy.wsTimer = arg0_19.wsTimer

	arg0_19.wsDragProxy:Setup({
		clickCall = function(arg0_24, arg1_24)
			if arg0_19.svScannerPanel:isShowing() then
				local var0_24, var1_24 = arg0_19:CheckScannerEnable(arg0_19:ScreenPos2MapPos(arg1_24.position))

				if var0_24 then
					arg0_19.svScannerPanel:ActionInvoke("DisplayWindow", var0_24, var1_24)
				else
					arg0_19.svScannerPanel:ActionInvoke("HideWindow")
				end
			else
				arg0_19:OnClickMap(arg0_19:ScreenPos2MapPos(arg1_24.position))
			end
		end,
		longPressCall = function()
			arg0_19:OnLongPressMap(arg0_19:ScreenPos2MapPos(Vector3(Input.mousePosition.x, Input.mousePosition.y)))
		end
	})

	arg0_19.wsMapCamera = WSMapCamera.New()
	arg0_19.wsMapCamera.camera = arg0_19.camera

	arg0_19.wsMapCamera:Setup()
	arg0_19:InitSubView()
	arg0_19:AddWorldListener()

	arg0_19.moveQueue = {}
	arg0_19.achievedList = {}
	arg0_19.mapOps = {}
	arg0_19.wsCommands = {}

	WSCommand.Bind(arg0_19)
	arg0_19:OpOpen()
end

function var0_0.InitSubView(arg0_26)
	arg0_26.rtPanelList = arg0_26._tf:Find("panel_list")
	arg0_26.svOrderPanel = SVOrderPanel.New(arg0_26.rtPanelList, arg0_26.event, {
		wsPool = arg0_26.wsPool
	})
	arg0_26.svScannerPanel = SVScannerPanel.New(arg0_26.rtPanelList, arg0_26.event)

	arg0_26:bind(SVScannerPanel.ShowView, function(arg0_27)
		arg0_26.wsMap:ShowScannerMap(true)
		setActive(arg0_26.wsMap.rtTop, false)
		arg0_26:HideMapUI()
	end)
	arg0_26:bind(SVScannerPanel.HideView, function(arg0_28)
		arg0_26.wsMap:ShowScannerMap(false)
		setActive(arg0_26.wsMap.rtTop, true)
		arg0_26:DisplayMapUI()
	end)
	arg0_26:bind(SVScannerPanel.HideGoing, function(arg0_29, arg1_29, arg2_29)
		arg0_26.wsMap:ShowScannerMap(false)
		setActive(arg0_26.wsMap.rtTop, true)
		arg0_26:DisplayMapUI()
		arg0_26:OnClickCell(arg1_29, arg2_29)
	end)

	arg0_26.svRealmPanel = SVRealmPanel.New(arg0_26.rtPanelList, arg0_26.event)
	arg0_26.svAchievement = SVAchievement.New(arg0_26.rtPanelList, arg0_26.event)

	arg0_26:bind(SVAchievement.HideView, function(arg0_30)
		table.remove(arg0_26.achievedList, 1)

		return (#arg0_26.achievedList > 0 and function()
			arg0_26:ShowSubView("Achievement", arg0_26.achievedList[1])
		end or function()
			arg0_26:Op("OpInteractive")
		end)()
	end)

	arg0_26.svDebugPanel = SVDebugPanel.New(arg0_26.rtPanelList, arg0_26.event)
	arg0_26.svFloatPanel = SVFloatPanel.New(arg0_26.rtTop, arg0_26.event)

	arg0_26:bind(SVFloatPanel.ReturnCall, function(arg0_33, arg1_33)
		arg0_26:Op("OpCall", function(arg0_34)
			arg0_34()

			local var0_34 = nowWorld():GetActiveEntrance()

			if arg1_33.id == var0_34.id then
				arg0_26.wsAtlas:UpdateSelect()
				arg0_26.wsAtlas:UpdateSelect(arg1_33)
			else
				arg0_26:ClickAtlas(var0_34)
			end
		end)
	end)
	arg0_26:bind(SVFloatPanel.DelegateCall, function(arg0_35, arg1_35)
		local var0_35, var1_35 = nowWorld():CanDelegate()

		if not var0_35 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var1_35))

			return
		end

		arg0_26.svSingleDelegatePanel:ExecuteAction("Show", arg1_35)
	end)

	arg0_26.svPoisonPanel = SVPoisonPanel.New(arg0_26.rtPanelList, arg0_26.event)
	arg0_26.svGlobalBuff = SVGlobalBuff.New(arg0_26.rtPanelList, arg0_26.event)

	arg0_26:bind(SVGlobalBuff.HideView, function(arg0_36, arg1_36)
		return existCall(arg1_36)
	end)

	arg0_26.svBossProgress = SVBossProgress.New(arg0_26.rtPanelList, arg0_26.event)

	arg0_26:bind(SVBossProgress.HideView, function(arg0_37, arg1_37)
		return existCall(arg1_37)
	end)

	arg0_26.svSalvageResult = SVSalvageResult.New(arg0_26.rtPanelList, arg0_26.event)
	arg0_26.svDelegatePanel = ChapterAutoPanelTypeWorld.New(arg0_26.rtPanelList, arg0_26.event)

	arg0_26.svDelegatePanel:RegisterView(arg0_26)

	arg0_26.svSingleDelegatePanel = ChapterAutoPanelTypeWorldSingle.New(arg0_26.rtPanelList, arg0_26.event)

	arg0_26.svSingleDelegatePanel:RegisterView(arg0_26)
end

function var0_0.didEnter(arg0_38)
	arg0_38:OverlayPanel(arg0_38.rtTop)

	arg0_38.warningSairen = not arg0_38.contextData.inSave

	if getProxy(ChapterAutoProxy):HasTypeCommission(ChapterAutoProxy.TYPE.WORLD) or arg0_38.contextData.inWorld then
		arg0_38:Op("OpSetInMap", false, function()
			arg0_38.wsAtlas:UpdateSelect(nowWorld():GetActiveEntrance())
		end)
	else
		arg0_38:Op("OpSetInMap", true)
	end
end

function var0_0.onBackPressed(arg0_40)
	if arg0_40.inCutIn then
		return
	elseif arg0_40.svDebugPanel:isShowing() then
		arg0_40:HideSubView("DebugPanel")
	elseif arg0_40.svAchievement:isShowing() then
		arg0_40:HideSubView("Achievement")
	elseif arg0_40.svGlobalBuff:isShowing() then
		arg0_40:HideSubView("GlobalBuff")
	elseif arg0_40.svBossProgress:isShowing() then
		arg0_40:HideSubView("BossProgress")
	elseif arg0_40.svOrderPanel:isShowing() then
		arg0_40:HideSubView("OrderPanel")
	elseif arg0_40.svScannerPanel:isShowing() then
		arg0_40:HideSubView("ScannerPanel")
	elseif arg0_40.svPoisonPanel:isShowing() then
		arg0_40:HideSubView("PoisonPanel")
	elseif arg0_40.svSalvageResult:isShowing() then
		arg0_40:HideSubView("SalvageResult")
	elseif arg0_40.svDelegatePanel:isShowing() then
		arg0_40:HideSubView("DelegatePanel")
	elseif arg0_40.svSingleDelegatePanel:isShowing() then
		arg0_40:HideSubView("SingleDelegatePanel")
	elseif arg0_40.wsMapLeft and isActive(arg0_40.wsMapLeft.toggleMask) then
		arg0_40.wsMapLeft:HideToggleMask()
	elseif not arg0_40:GetInMap() then
		triggerButton(arg0_40.rtTopAtlas:Find("back_button"))
	else
		triggerButton(arg0_40.wsMapTop.btnBack)
	end
end

function var0_0.quickExitFunc(arg0_41)
	arg0_41:Op("OpCall", function(arg0_42)
		arg0_42()

		local var0_42 = {}

		if nowWorld():CheckReset() then
			table.insert(var0_42, function(arg0_43)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_recycle_notice"),
					onYes = arg0_43
				})
			end)
		end

		seriesAsync(var0_42, function()
			var0_0.super.quickExitFunc(arg0_41)
		end)
	end)
end

function var0_0.ExitWorld(arg0_45, arg1_45, arg2_45)
	local var0_45 = {}

	if not arg2_45 then
		table.insert(var0_45, function(arg0_46)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_exit_tip"),
				onYes = arg0_46,
				onNo = function()
					return existCall(arg1_45)
				end
			})
		end)
	end

	if not arg2_45 and nowWorld():CheckReset() then
		table.insert(var0_45, function(arg0_48)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_recycle_notice"),
				onYes = arg0_48,
				onNo = function()
					return existCall(arg1_45)
				end
			})
		end)
	end

	table.insert(var0_45, function(arg0_50)
		if arg0_45:GetInMap() then
			arg0_45:EaseOutMapUI(arg0_50)
		else
			arg0_45:EaseOutAtlasUI(arg0_50)
		end
	end)
	seriesAsync(var0_45, function()
		existCall(arg1_45)
		arg0_45:closeView()
	end)
end

function var0_0.SaveState(arg0_52)
	arg0_52.contextData.inSave = true
	arg0_52.contextData.inWorld = arg0_52:GetInMap() == false
	arg0_52.contextData.inShop = false
	arg0_52.contextData.inPort = false
end

function var0_0.willExit(arg0_53)
	arg0_53:SaveState()
	arg0_53:RemoveWorldListener()
	arg0_53:UnOverlayPanel(arg0_53.rtTop, arg0_53._tf)
	arg0_53.svOrderPanel:Destroy()
	arg0_53.svScannerPanel:Destroy()
	arg0_53.svAchievement:Destroy()
	arg0_53.svRealmPanel:Destroy()
	arg0_53.svDebugPanel:Destroy()
	arg0_53.svFloatPanel:Destroy()
	arg0_53.svPoisonPanel:Destroy()
	arg0_53.svGlobalBuff:Destroy()
	arg0_53.svBossProgress:Destroy()
	arg0_53.svDelegatePanel:Destroy()
	arg0_53.svSingleDelegatePanel:Destroy()
	arg0_53:DisposeAtlas()
	arg0_53:DisposeAtlasUI()
	arg0_53:DisposeMap()
	arg0_53:DisposeMapUI()
	arg0_53.wsPool:Dispose()

	arg0_53.wsPool = nil

	arg0_53.wsAnim:Dispose()

	arg0_53.wsAnim = nil

	arg0_53.wsTimer:Dispose()

	arg0_53.wsTimer = nil

	arg0_53.wsDragProxy:Dispose()

	arg0_53.wsDragProxy = nil

	arg0_53.wsMapCamera:Dispose()

	arg0_53.wsMapCamera = nil

	arg0_53.resAtlas:exit()

	arg0_53.resAtlas = nil

	arg0_53.resMap:exit()

	arg0_53.resMap = nil

	arg0_53:VerifyMapOp()
	arg0_53:OpDispose()
	WSCommand.Unbind(arg0_53)
	WBank:Recycle(WorldMapOp)
end

function var0_0.SetPlayer(arg0_54, arg1_54)
	arg0_54.player = arg1_54

	arg0_54.resAtlas:setPlayer(arg0_54.player)
	arg0_54.resMap:setPlayer(arg0_54.player)
end

function var0_0.AddWorldListener(arg0_55)
	local var0_55 = nowWorld()

	var0_55:AddListener(World.EventUpdateProgress, arg0_55.onUpdateProgress)
	var0_55:GetTaskProxy():AddListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0_55.onUpdateDaily)
end

function var0_0.RemoveWorldListener(arg0_56)
	local var0_56 = nowWorld()

	var0_56:RemoveListener(World.EventUpdateProgress, arg0_56.onUpdateProgress)
	var0_56:GetTaskProxy():RemoveListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0_56.onUpdateDaily)
end

function var0_0.SetInMap(arg0_57, arg1_57, arg2_57)
	if arg1_57 then
		arg2_57 = defaultValue(arg2_57, function()
			arg0_57:Op("OpInteractive")
		end)
	end

	if arg0_57.inMap == arg1_57 then
		return existCall(arg2_57)
	end

	local var0_57 = {}
	local var1_57 = {}

	arg0_57:StopAnim()

	if arg0_57.inMap then
		table.insert(var0_57, function(arg0_59)
			arg0_57:Op("OpSwitchOutMap", arg0_59)
		end)
	elseif arg0_57.inMap ~= nil then
		table.insert(var0_57, function(arg0_60)
			arg0_57:Op("OpSwitchOutWorld", arg0_60)
		end)
	end

	table.insert(var0_57, function(arg0_61)
		arg0_57:Op("OpCall", function(arg0_62)
			parallelAsync(var1_57, function()
				arg0_62()

				return arg0_61()
			end)
		end)
	end)
	table.insert(var1_57, function(arg0_64)
		arg0_57:DisplayEnv(arg0_64)
	end)
	table.insert(var1_57, function(arg0_65)
		arg0_57:LoadMap(nowWorld():GetActiveMap(), arg0_65)
	end)

	if arg1_57 then
		table.insert(var0_57, function(arg0_66)
			arg0_57:Op("OpSwitchInMap", arg0_66)
		end)
	else
		table.insert(var1_57, function(arg0_67)
			arg0_57:LoadAtlas(arg0_67)
		end)
		table.insert(var0_57, function(arg0_68)
			arg0_57:Op("OpSwitchInWorld", arg0_68)
		end)
		table.insert(var0_57, function(arg0_69)
			arg0_57:CheckGuideWorld(arg0_69)
		end)
	end

	table.insert(var0_57, function(arg0_70)
		arg0_57:PlayBGM()
		arg0_70()
	end)

	arg0_57.inMap = arg1_57

	seriesAsync(var0_57, arg2_57)
end

function var0_0.CheckGuideWorld(arg0_71, arg1_71)
	local var0_71 = nowWorld()
	local var1_71 = {}

	table.insert(var1_71, {
		"CHAPTER_AUTO_WORLD_GUIDE",
		function()
			return var0_71:CanDelegate()
		end
	})

	local var2_71 = pg.NewStoryMgr.GetInstance()

	for iter0_71, iter1_71 in ipairs(var1_71) do
		if not var2_71:IsPlayed(iter1_71[1]) and iter1_71[2]() then
			return WorldGuider.GetInstance():PlayGuide(iter1_71[1], nil, arg1_71)
		end
	end

	existCall(arg1_71)
end

function var0_0.GetInMap(arg0_73)
	return arg0_73.inMap
end

function var0_0.ShowSubView(arg0_74, arg1_74, arg2_74, arg3_74)
	local var0_74 = arg0_74["sv" .. arg1_74]

	var0_74:Load()
	var0_74:ActionInvoke("Setup", unpack(arg2_74 or {}))
	var0_74:ActionInvoke("Show", unpack(arg3_74 or {}))
end

function var0_0.HideSubView(arg0_75, arg1_75, ...)
	arg0_75["sv" .. arg1_75]:ActionInvoke("Hide", ...)
end

function var0_0.DisplayAtlasUI(arg0_76)
	arg0_76:DisplayAtlasTop()
	arg0_76:DisplayAtlasRight()
	arg0_76:DisplayAtlasBottom()
	arg0_76:UpdateSystemOpen()
end

function var0_0.HideAtlasUI(arg0_77)
	arg0_77:HideAtlasTop()
	arg0_77:HideAtlasRight()
	arg0_77:HideAtlasBottom()
end

function var0_0.EaseInAtlasUI(arg0_78, arg1_78)
	arg0_78:CancelAtlasUITween()
	parallelAsync({
		function(arg0_79)
			setAnchoredPosition(arg0_78.rtTopAtlas, {
				y = arg0_78.rtTopAtlas.rect.height
			})
			arg0_78.wsTimer:AddTween(LeanTween.moveY(arg0_78.rtTopAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_79)).uniqueId)
		end,
		function(arg0_80)
			setAnchoredPosition(arg0_78.rtBottomAtlas, {
				y = -arg0_78.rtBottomAtlas.rect.height
			})
			arg0_78.wsTimer:AddTween(LeanTween.moveY(arg0_78.rtBottomAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_80)).uniqueId)
		end,
		function(arg0_81)
			setAnchoredPosition(arg0_78.rtRightAtlas, {
				x = arg0_78.rtRightAtlas.rect.width
			})
			arg0_78.wsTimer:AddTween(LeanTween.moveX(arg0_78.rtRightAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_81)).uniqueId)
		end
	}, function()
		return existCall(arg1_78)
	end)
end

function var0_0.EaseOutAtlasUI(arg0_83, arg1_83)
	arg0_83:CancelAtlasUITween()
	parallelAsync({
		function(arg0_84)
			setAnchoredPosition(arg0_83.rtTopAtlas, {
				y = 0
			})
			arg0_83.wsTimer:AddTween(LeanTween.moveY(arg0_83.rtTopAtlas, arg0_83.rtTopAtlas.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_84)).uniqueId)
		end,
		function(arg0_85)
			setAnchoredPosition(arg0_83.rtBottomAtlas, {
				y = 0
			})
			arg0_83.wsTimer:AddTween(LeanTween.moveY(arg0_83.rtBottomAtlas, -arg0_83.rtBottomAtlas.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_85)).uniqueId)
		end,
		function(arg0_86)
			setAnchoredPosition(arg0_83.rtRightAtlas, {
				x = 0
			})
			arg0_83.wsTimer:AddTween(LeanTween.moveX(arg0_83.rtRightAtlas, arg0_83.rtRightAtlas.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_86)).uniqueId)
		end
	}, function()
		return existCall(arg1_83)
	end)
end

function var0_0.CancelAtlasUITween(arg0_88)
	LeanTween.cancel(go(arg0_88.rtTransportAtlas))
	LeanTween.cancel(go(arg0_88.rtTopAtlas))
	LeanTween.cancel(go(arg0_88.rtBottomAtlas))
	LeanTween.cancel(go(arg0_88.rtRightAtlas))
end

function var0_0.DisposeAtlasUI(arg0_89)
	arg0_89:HideAtlasUI()
	arg0_89:DisposeAtlasTransport()
	arg0_89:DisposeAtlasTop()
	arg0_89:DisposeAtlasRight()
	arg0_89:DisposeAtlasBottom()
end

function var0_0.DisplayAtlas(arg0_90)
	local var0_90 = nowWorld():GetActiveEntrance()

	arg0_90.wsAtlas:SwitchArea(var0_90:GetAreaId())
	arg0_90.wsAtlas:UpdateActiveMark()
	arg0_90.wsAtlas:ShowOrHide(true)
end

function var0_0.HideAtlas(arg0_91)
	arg0_91.wsAtlas:UpdateSelect()
	arg0_91.wsAtlas:ShowOrHide(false)
end

function var0_0.ClickAtlas(arg0_92, arg1_92)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

	local var0_92 = arg1_92:GetAreaId()

	if not nowWorld():CheckAreaUnlock(var0_92) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("area_lock"))

		return
	end

	if arg0_92.wsAtlas.nowArea then
		arg0_92.wsAtlas:UpdateSelect()

		if arg0_92.wsAtlas.selectEntrance ~= arg1_92 then
			arg0_92.wsAtlas:UpdateSelect(arg1_92)
		end
	else
		arg0_92:EnterToModelMap(var0_92)
	end
end

function var0_0.LoadAtlas(arg0_93, arg1_93)
	local var0_93 = {}

	if not arg0_93.wsAtlas then
		table.insert(var0_93, function(arg0_94)
			arg0_93:downloadWorldResList(arg0_93:getAtlasResList(), arg0_94)
		end)
		table.insert(var0_93, function(arg0_95)
			arg0_93.wsAtlas = arg0_93:NewAtlas()

			arg0_93.wsAtlas:LoadScene(function()
				arg0_93.wsAtlas:AddListener(WSAtlasWorld.EventUpdateselectEntrance, arg0_93.onModelSelectMap)
				arg0_93.wsAtlas:UpdateAtlas(nowWorld():GetAtlas())

				return arg0_95()
			end)
		end)
	end

	seriesAsync(var0_93, arg1_93)
end

function var0_0.NewAtlas(arg0_97)
	local var0_97 = WSAtlasWorld.New()

	var0_97.wsTimer = arg0_97.wsTimer

	function var0_97.onClickColor(arg0_98, arg1_98)
		if arg0_97.wsAtlas:CheckIsTweening() then
			return
		end

		arg0_97:Op("OpCall", function(arg0_99)
			arg0_99()
			arg0_97:ClickAtlas(arg0_98)
		end)
	end

	var0_97:Setup()

	return var0_97
end

function var0_0.DisposeAtlas(arg0_100)
	if arg0_100.wsAtlas then
		arg0_100:HideAtlas()
		arg0_100.wsAtlas:RemoveListener(WSAtlasWorld.EventUpdateselectEntrance, arg0_100.onModelSelectMap)
		arg0_100.wsAtlas:Dispose()

		arg0_100.wsAtlas = nil
	end
end

function var0_0.DisplayAtlasTop(arg0_101)
	arg0_101.wsAtlasTop = arg0_101.wsAtlasTop or arg0_101:NewAtlasTop(arg0_101.rtTopAtlas)

	setActive(arg0_101.rtTopAtlas, true)
	setActive(arg0_101.rtTopAtlas:Find("print/title_world"), true)
	setActive(arg0_101.rtTopAtlas:Find("print/title_view"), false)
	setActive(arg0_101.rtTopAtlas:Find("sairen_warning"), arg0_101.warningSairen and #nowWorld():GetAtlas().sairenEntranceList > 0)

	arg0_101.warningSairen = false
end

function var0_0.UpdateDelegateDisplay(arg0_102)
	if arg0_102.svDelegatePanel:isShowing() then
		arg0_102:HideSubView("DelegatePanel")
	end

	if arg0_102.svSingleDelegatePanel:isShowing() then
		arg0_102:HideSubView("SingleDelegatePanel")
	end

	if arg0_102.wsAtlasRight then
		arg0_102.wsAtlasRight:UpdateDelegate()
	end

	if arg0_102.svFloatPanel:isShowing() then
		arg0_102.svFloatPanel:UpdatePanel()
	end
end

function var0_0.HideAtlasTop(arg0_103)
	setActive(arg0_103.rtTopAtlas, false)
end

function var0_0.NewAtlasTop(arg0_104, arg1_104)
	local var0_104 = {
		transform = arg1_104
	}

	onButton(arg0_104, arg1_104:Find("back_button"), function()
		if getProxy(ChapterAutoProxy):HasTypeCommission(ChapterAutoProxy.TYPE.WORLD) then
			arg0_104:Op("OpCall", function(arg0_106)
				arg0_104:ExitWorld(arg0_106)
			end)
		else
			arg0_104:Op("OpCall", function(arg0_107)
				arg0_107()
				arg0_104:BackToMap()
			end)
		end
	end, SFX_CANCEL)

	return var0_104
end

function var0_0.DisposeAtlasTop(arg0_108)
	arg0_108.wsAtlasTop = nil
end

function var0_0.DisplayAtlasRight(arg0_109)
	arg0_109.wsAtlasRight = arg0_109.wsAtlasRight or arg0_109:NewAtlasRight(arg0_109.rtRightAtlas)

	arg0_109.wsAtlasRight:SetOverSize(arg0_109.rtTop:Find("adapt").offsetMax.x)
	setActive(arg0_109.rtRightAtlas, true)
end

function var0_0.HideAtlasRight(arg0_110)
	setActive(arg0_110.rtRightAtlas, false)
end

function var0_0.NewAtlasRight(arg0_111, arg1_111, arg2_111)
	local var0_111 = WSAtlasRight.New()

	var0_111.transform = arg1_111

	var0_111:Setup()
	onButton(arg0_111, var0_111.btnSettings, function()
		arg0_111:Op("OpOpenScene", SCENE.SETTINGS, {
			scroll = "world_settings",
			page = NewSettingsScene.PAGE_OPTION
		})
	end, SFX_PANEL)
	onButton(arg0_111, var0_111.btnSwitch, function()
		if getProxy(ChapterAutoProxy):IsCommissionDoing() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_auto_plan_error_tip1"))

			return
		end

		arg0_111:Op("OpOpenLayer", Context.New({
			mediator = WorldSwitchPlanningMediator,
			viewComponent = WorldSwitchPlanningLayer
		}))
	end, SFX_CONFIRM)
	onButton(arg0_111, var0_111.btnDelegate, function()
		local var0_114, var1_114 = nowWorld():CanDelegate()

		if not var0_114 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var1_114))

			return
		end

		arg0_111.svDelegatePanel:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_111, var0_111.btnDeleCancel, function()
		arg0_111:emit(WorldMediator.OnFinishDelegate)
	end, SFX_CANCEL)
	onButton(arg0_111, var0_111.btnDeleConfirm, function()
		arg0_111:emit(WorldMediator.OnFinishDelegate)
	end, SFX_CONFIRM)

	return var0_111
end

function var0_0.DisposeAtlasRight(arg0_117)
	if arg0_117.wsAtlasRight then
		arg0_117.wsAtlasRight:Dispose()

		arg0_117.wsAtlasRight = nil
	end
end

function var0_0.DisplayAtlasBottom(arg0_118)
	arg0_118.wsAtlasBottom = arg0_118.wsAtlasBottom or arg0_118:NewAtlasBottom(arg0_118.rtBottomAtlas)

	arg0_118.wsAtlasBottom:SetOverSize(arg0_118.rtTop:Find("adapt").offsetMax.x)
	arg0_118.wsAtlasBottom:UpdateScale(1)
	setActive(arg0_118.rtBottomAtlas, true)
	setActive(arg0_118.wsAtlasBottom.btnDailyTask:Find("tip"), nowWorld():GetTaskProxy():canAcceptDailyTask())
end

function var0_0.HideAtlasBottom(arg0_119)
	setActive(arg0_119.rtBottomAtlas, false)
end

function var0_0.NewAtlasBottom(arg0_120, arg1_120)
	local var0_120 = WSAtlasBottom.New()

	var0_120.transform = arg1_120
	var0_120.wsTimer = arg0_120.wsTimer

	var0_120:Setup()

	if CAMERA_MOVE_OPEN then
		var0_120:AddListener(WSAtlasBottom.EventUpdateScale, arg0_120.onUpdateScale)
	end

	onButton(arg0_120, var0_120.btnOverview, function()
		if arg0_120.wsAtlas:CheckIsTweening() then
			return
		end

		arg0_120:Op("OpCall", function(arg0_122)
			arg0_120.wsAtlas:LoadModel(function()
				arg0_122()
				arg0_120:ReturnToModelArea()
			end)
		end)
	end, SFX_PANEL)
	onButton(arg0_120, var0_120.btnBoss, function()
		if nowWorld():GetBossProxy():IsOpen() then
			arg0_120:Op("OpOpenScene", SCENE.WORLDBOSS)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0_120, var0_120.btnShop, function()
		arg0_120:Op("OpOpenLayer", Context.New({
			mediator = WorldShopMediator,
			viewComponent = WorldShopLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_120, var0_120.btnCollection, function()
		arg0_120:Op("OpOpenScene", SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_RECORD
		})
	end, SFX_PANEL)
	onButton(arg0_120, var0_120.btnDailyTask, function()
		local var0_127 = nowWorld()

		if var0_127:IsSystemOpen(WorldConst.SystemDailyTask) then
			var0_127:GetTaskProxy():checkDailyTask(function()
				arg0_120:Op("OpOpenLayer", Context.New({
					mediator = WorldDailyTaskMediator,
					viewComponent = WorldDailyTaskLayer
				}))
			end)
		else
			pg.TipsMgr.GetInstance(i18n("world_daily_task_lock"))
		end
	end, SFX_PANEL)

	return var0_120
end

function var0_0.DisposeAtlasBottom(arg0_129)
	if arg0_129.wsAtlasBottom then
		arg0_129.wsAtlasBottom:Dispose()

		arg0_129.wsAtlasBottom = nil
	end
end

function var0_0.DisplayAtlasTransport(arg0_130)
	arg0_130.wsAtlasTransport = arg0_130.wsAtlasTransport or arg0_130:NewAtlasTransport(arg0_130.rtTransportAtlas)

	setActive(arg0_130.rtTransportAtlas, true)
end

function var0_0.HideAtlasTransport(arg0_131)
	setActive(arg0_131.rtTransportAtlas, false)
end

function var0_0.NewAtlasTransport(arg0_132, arg1_132)
	local var0_132 = {
		transform = arg1_132,
		btnBack = arg1_132:Find("adapt/btn_back")
	}

	onButton(arg0_132, var0_132.btnBack, function()
		assert(arg0_132.inTransportMode, "this isn't transport mode atlas")
		arg0_132:BackToMap()
	end, SFX_CANCEL)

	return var0_132
end

function var0_0.DisposeAtlasTransport(arg0_134)
	arg0_134.wsAtlasTransport = nil
end

function var0_0.DisplayMapUI(arg0_135)
	arg0_135:DisplayMapTop()
	arg0_135:DisplayMapLeft()
	arg0_135:DisplayMapRight()
	arg0_135:DisplayMapOut()
	arg0_135:UpdateSystemOpen()
end

function var0_0.HideMapUI(arg0_136)
	arg0_136:HideMapTop()
	arg0_136:HideMapLeft()
	arg0_136:HideMapRight()
	arg0_136:HideMapOut()
end

function var0_0.UpdateMapUI(arg0_137)
	local var0_137 = nowWorld()
	local var1_137 = var0_137:GetActiveEntrance()
	local var2_137 = var0_137:GetActiveMap()

	arg0_137.wsMapTop:Update(var1_137, var2_137)
	arg0_137.wsMapLeft:UpdateMap(var2_137)
	arg0_137.wsMapRight:Update(var1_137, var2_137)
	arg0_137.wsMapOut:UpdateMap(var2_137)
end

function var0_0.EaseInMapUI(arg0_138, arg1_138)
	arg0_138:CancelMapUITween()
	parallelAsync({
		function(arg0_139)
			setAnchoredPosition(arg0_138.rtTopMap, {
				y = arg0_138.rtTopMap.rect.height
			})
			arg0_138.wsTimer:AddTween(LeanTween.moveY(arg0_138.rtTopMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_139)).uniqueId)
		end,
		function(arg0_140)
			setAnchoredPosition(arg0_138.rtLeftMap, {
				x = -arg0_138.rtLeftMap.rect.width
			})
			arg0_138.wsTimer:AddTween(LeanTween.moveX(arg0_138.rtLeftMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_140)).uniqueId)
		end,
		function(arg0_141)
			setAnchoredPosition(arg0_138.rtRightMap, {
				x = arg0_138.rtRightMap.rect.width
			})
			arg0_138.wsTimer:AddTween(LeanTween.moveX(arg0_138.rtRightMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(arg0_141)).uniqueId)
		end
	}, function()
		return existCall(arg1_138)
	end)
end

function var0_0.EaseOutMapUI(arg0_143, arg1_143)
	arg0_143:CancelMapUITween()
	parallelAsync({
		function(arg0_144)
			setAnchoredPosition(arg0_143.rtTopMap, {
				y = 0
			})
			arg0_143.wsTimer:AddTween(LeanTween.moveY(arg0_143.rtTopMap, arg0_143.rtTopMap.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_144)).uniqueId)
		end,
		function(arg0_145)
			setAnchoredPosition(arg0_143.rtLeftMap, {
				x = 0
			})
			arg0_143.wsTimer:AddTween(LeanTween.moveX(arg0_143.rtLeftMap, -arg0_143.rtLeftMap.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_145)).uniqueId)
		end,
		function(arg0_146)
			setAnchoredPosition(arg0_143.rtRightMap, {
				x = 0
			})
			arg0_143.wsTimer:AddTween(LeanTween.moveX(arg0_143.rtRightMap, arg0_143.rtRightMap.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(arg0_146)).uniqueId)
		end
	}, function()
		return existCall(arg1_143)
	end)
end

function var0_0.CancelMapUITween(arg0_148)
	LeanTween.cancel(go(arg0_148.rtTopMap))
	LeanTween.cancel(go(arg0_148.rtLeftMap))
	LeanTween.cancel(go(arg0_148.rtRightMap))
end

function var0_0.DisposeMapUI(arg0_149)
	arg0_149:DisposeMapTop()
	arg0_149:DisposeMapLeft()
	arg0_149:DisposeMapRight()
	arg0_149:DisposeMapOut()
end

function var0_0.DisplayMap(arg0_150)
	setActive(arg0_150.rtUIMain, true)
end

function var0_0.HideMap(arg0_151)
	setActive(arg0_151.rtUIMain, false)
end

function var0_0.ShowMargin(arg0_152, arg1_152)
	if arg0_152.wsMap then
		arg0_152.wsMap:UpdateTransportDisplay(arg1_152)
	end
end

function var0_0.LoadMap(arg0_153, arg1_153, arg2_153)
	assert(arg1_153, "target map not exist.")

	local var0_153 = {}

	if not arg1_153:IsValid() then
		table.insert(var0_153, function(arg0_154)
			arg0_153:emit(WorldMediator.OnMapReq, arg1_153.id, arg0_154)
		end)
	end

	seriesAsync(var0_153, function()
		if arg0_153.wsMap then
			return existCall(arg2_153)
		else
			arg0_153:downloadWorldResList(arg0_153:getMapResList(arg1_153), function()
				arg1_153:AddListener(WorldMap.EventUpdateActive, arg0_153.onDisposeMap)
				arg1_153:AddListener(WorldMap.EventUpdateMoveSpeed, arg0_153.onClearMoveQueue)

				arg0_153.wsMap = arg0_153:NewMap(arg1_153)

				arg0_153.wsMap:Load(function()
					arg0_153.wsMap.transform:SetParent(arg0_153.rtDragLayer, false)
					setActive(arg0_153.wsMap.transform, true)
					arg0_153:InitMap()

					return existCall(arg2_153)
				end)
			end)
		end
	end)
end

function var0_0.InitMap(arg0_158)
	for iter0_158, iter1_158 in ipairs(arg0_158.wsMap.wsMapFleets) do
		onButton(arg0_158, iter1_158.rtRetreat, function()
			arg0_158:Op("OpReqRetreat", iter1_158.fleet)
		end, SFX_PANEL)
		iter1_158:AddListener(WSMapFleet.EventUpdateSelected, arg0_158.onFleetSelected)
	end

	arg0_158.wsMap:AddListener(WSMap.EventUpdateEventTips, arg0_158.onUpdateEventTips)

	local var0_158 = nowWorld()

	var0_158:AddListener(World.EventUpdateSubmarineSupport, arg0_158.onUpdateSubmarineSupport)
	var0_158:AddListener(World.EventAchieved, arg0_158.onAchievementAchieved)

	local var1_158 = arg0_158.wsMap.map

	arg0_158.wsDragProxy:UpdateMap(var1_158)
	arg0_158.wsDragProxy:Focus(arg0_158.wsMap:GetFleet().transform.position)
	arg0_158.wsMapCamera:UpdateMap(var1_158)
	arg0_158:OnUpdateSubmarineSupport()
end

function var0_0.NewMap(arg0_160, arg1_160)
	local var0_160 = WSMap.New()

	var0_160.wsPool = arg0_160.wsPool
	var0_160.wsTimer = arg0_160.wsTimer

	var0_160:Setup(arg1_160)

	arg0_160.rtGrid.localEulerAngles = Vector3(arg1_160.theme.angle, 0, 0)

	return var0_160
end

function var0_0.DisposeMap(arg0_161)
	if arg0_161.wsMap then
		arg0_161.wsTimer:ClearInMapTimers()
		arg0_161.wsTimer:ClearInMapTweens()
		arg0_161:HideMap()

		local var0_161 = nowWorld()

		var0_161:RemoveListener(World.EventUpdateSubmarineSupport, arg0_161.onUpdateSubmarineSupport)
		var0_161:RemoveListener(World.EventAchieved, arg0_161.onAchievementAchieved)

		local var1_161 = arg0_161.wsMap.map

		var1_161:RemoveListener(WorldMap.EventUpdateActive, arg0_161.onDisposeMap)
		var1_161:RemoveListener(WorldMap.EventUpdateMoveSpeed, arg0_161.onClearMoveQueue)
		arg0_161.wsMap:Dispose()

		arg0_161.wsMap = nil
	end
end

function var0_0.OnDisposeMap(arg0_162, arg1_162, arg2_162)
	local var0_162 = false

	if arg1_162 == WorldMap.EventUpdateActive then
		var0_162 = not arg2_162.active
	end

	if var0_162 then
		arg0_162:DisposeMap()
	end
end

function var0_0.DisplayMapTop(arg0_163)
	arg0_163.wsMapTop = arg0_163.wsMapTop or arg0_163:NewMapTop(arg0_163.rtTopMap)

	setActive(arg0_163.rtTopMap, true)
end

function var0_0.HideMapTop(arg0_164)
	setActive(arg0_164.rtTopMap, false)
end

function var0_0.NewMapTop(arg0_165, arg1_165)
	local var0_165 = WSMapTop.New()

	var0_165.transform = arg1_165

	var0_165:Setup()

	function var0_165.cmdSkillFunc(arg0_166)
		arg0_165:emit(WorldMediator.OnOpenLayer, Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = arg0_166
			}
		}))
	end

	function var0_165.poisonFunc(arg0_167)
		arg0_165:ShowSubView("PoisonPanel", {
			arg0_167
		})
	end

	onButton(arg0_165, var0_165.btnBack, function()
		arg0_165:Op("OpCall", function(arg0_169)
			arg0_165:ExitWorld(arg0_169)
		end)
	end, SFX_CANCEL)

	return var0_165
end

function var0_0.DisposeMapTop(arg0_170)
	if arg0_170.wsMapTop then
		arg0_170:HideMapTop()
		arg0_170.wsMapTop:Dispose()

		arg0_170.wsMapTop = nil
	end
end

function var0_0.DisplayMapLeft(arg0_171)
	arg0_171.wsMapLeft = arg0_171.wsMapLeft or arg0_171:NewMapLeft(arg0_171.rtLeftMap)

	setActive(arg0_171.rtLeftMap, true)
end

function var0_0.HideMapLeft(arg0_172)
	setActive(arg0_172.rtLeftMap, false)
end

function var0_0.NewMapLeft(arg0_173, arg1_173)
	local var0_173 = WSMapLeft.New()

	var0_173.transform = arg1_173

	var0_173:Setup()

	function var0_173.onAgonyClick()
		arg0_173:Op("OpOpenLayer", Context.New({
			mediator = WorldInventoryMediator,
			viewComponent = WorldInventoryLayer,
			data = {
				currentFleetIndex = nowWorld():GetActiveMap().findex
			}
		}))
	end

	function var0_173.onLongPress(arg0_175)
		local var0_175 = nowWorld():GetFleet(arg0_175.fleetId):GetShipVOs(true)

		arg0_173:Op("OpOpenScene", SCENE.SHIPINFO, {
			shipId = arg0_175.id,
			shipVOs = var0_175
		})
	end

	function var0_173.onClickSalvage(arg0_176)
		arg0_173:Op("OpCall", function(arg0_177)
			arg0_177()
			arg0_173:ShowSubView("SalvageResult", {
				arg0_176
			})
		end)
	end

	var0_173:AddListener(WSMapLeft.EventSelectFleet, arg0_173.onSelectFleet)

	return var0_173
end

function var0_0.DisposeMapLeft(arg0_178)
	if arg0_178.wsMapLeft then
		arg0_178:HideMapLeft()
		arg0_178.wsMapLeft:RemoveListener(WSMapLeft.EventSelectFleet, arg0_178.onSelectFleet)
		arg0_178.wsMapLeft:Dispose()

		arg0_178.wsMapLeft = nil
	end
end

function var0_0.DisplayMapRight(arg0_179)
	arg0_179.wsMapRight = arg0_179.wsMapRight or arg0_179:NewMapRight(arg0_179.rtRightMap)

	setActive(arg0_179.rtRightMap, true)
	arg0_179:UpdateAutoFightDisplay()
	arg0_179:UpdateAutoSwitchDisplay()
end

function var0_0.HideMapRight(arg0_180)
	setActive(arg0_180.rtRightMap, false)
end

function var0_0.HideMapRightCompass(arg0_181)
	return
end

function var0_0.HideMapRightMemo(arg0_182)
	return
end

function var0_0.NewMapRight(arg0_183, arg1_183)
	local var0_183 = WSMapRight.New()

	var0_183.transform = arg1_183
	var0_183.wsPool = arg0_183.wsPool
	var0_183.wsTimer = arg0_183.wsTimer

	var0_183:Setup()
	var0_183:OnUpdateInfoBtnTip()
	var0_183:OnUpdateHelpBtnTip()
	onButton(arg0_183, var0_183.btnOrder, function()
		arg0_183:Op("OpShowOrderPanel")
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnScan, function()
		arg0_183:Op("OpShowScannerPanel")
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnDefeat, function()
		var0_183:OnUpdateHelpBtnTip(true)
		arg0_183:Op("OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = 4,
				pageId = 5
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnDetail, function()
		arg0_183:Op("OpOpenLayer", Context.New({
			mediator = WorldDetailMediator,
			viewComponent = WorldDetailLayer,
			data = {
				fleetId = nowWorld():GetActiveMap():GetFleet().id
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnInformation, function()
		arg0_183:Op("OpOpenLayer", Context.New({
			mediator = WorldInformationMediator,
			viewComponent = WorldInformationLayer,
			data = {
				fleetId = nowWorld():GetActiveMap():GetFleet().id
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnInventory, function()
		arg0_183:Op("OpOpenLayer", Context.New({
			mediator = WorldInventoryMediator,
			viewComponent = WorldInventoryLayer,
			data = {
				currentFleetIndex = nowWorld():GetActiveMap().findex
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnTransport, function()
		arg0_183:OnClickTransport()
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnPort, function()
		local var0_191 = nowWorld():GetActiveMap()
		local var1_191 = var0_191:GetFleet()

		if var0_191:GetCell(var1_191.row, var1_191.column):ExistEnemy() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_port_inbattle"))

			return
		end

		arg0_183:Op("OpReqEnterPort")
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnExit, function()
		local var0_192 = nowWorld():GetActiveMap()
		local var1_192 = {}

		if var0_192:CheckFleetSalvage(true) then
			table.insert(var1_192, function(arg0_193)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_catsearch_leavemap"),
					onYes = arg0_193
				})
			end)
		end

		seriesAsync(var1_192, function()
			arg0_183:Op("OpReqJumpOut", var0_192.gid)
		end)
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.btnHelp, function()
		var0_183:OnUpdateHelpBtnTip(true)
		arg0_183:Op("OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.toggleAutoFight:Find("off"), function()
		arg0_183:Op("OpCall", function(arg0_197)
			arg0_197()

			local var0_197 = {}

			if PlayerPrefs.GetInt("first_auto_fight_mark", 0) == 0 then
				table.insert(var0_197, function(arg0_198)
					PlayerPrefs.SetInt("first_auto_fight_mark", 1)
					arg0_183:Op("OpOpenLayer", Context.New({
						mediator = WorldHelpMediator,
						viewComponent = WorldHelpLayer,
						data = {
							titleId = 2,
							pageId = 8
						},
						onRemoved = arg0_198
					}))
				end)
			end

			local var1_197 = nowWorld()

			if var1_197:IsSystemOpen(WorldConst.SystemOrderSubmarine) and PlayerPrefs.GetInt("world_sub_auto_call", 0) == 1 and var1_197:GetActiveMap():GetConfig("instruction_available")[1] == 1 and var1_197:CanCallSubmarineSupport() and not var1_197:IsSubmarineSupporting() then
				local var2_197 = var1_197:CalcOrderCost(WorldConst.OpReqSub)

				if var2_197 <= PlayerPrefs.GetInt("world_sub_call_line", 0) and var2_197 <= var1_197.staminaMgr:GetTotalStamina() then
					if var2_197 > 0 then
						table.insert(var0_197, function(arg0_199)
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("world_instruction_submarine_2", setColorStr(var2_197, COLOR_GREEN)),
								onYes = function()
									PlayerPrefs.SetInt("autoSubIsAcitve" .. AutoSubCommand.GetAutoSubMark(SYSTEM_WORLD), 1)
									arg0_183:Op("OpReqSub", arg0_199)
								end,
								onNo = arg0_199
							})
						end)
					else
						PlayerPrefs.SetInt("autoSubIsAcitve" .. AutoSubCommand.GetAutoSubMark(SYSTEM_WORLD), 1)
						table.insert(var0_197, function(arg0_201)
							arg0_183:Op("OpReqSub", arg0_201)
						end)
					end
				end
			end

			seriesAsync(var0_197, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_begin"))
				getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
				PlayerPrefs.SetInt("world_skip_precombat", 1)
				PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(SYSTEM_WORLD), 1)
				var1_197:TriggerAutoFight(true)
				arg0_183:Op("OpInteractive")
			end)
		end)
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.toggleAutoFight:Find("on"), function()
		arg0_183:Op("OpCall", function(arg0_204)
			arg0_204()
			nowWorld():TriggerAutoFight(false)
			arg0_183:Op("OpInteractive")
		end)
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.toggleAutoSwitch:Find("off"), function()
		arg0_183:Op("OpOpenLayer", Context.New({
			mediator = WorldSwitchPlanningMediator,
			viewComponent = WorldSwitchPlanningLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_183, var0_183.toggleAutoSwitch:Find("on"), function()
		arg0_183:Op("OpCall", function(arg0_207)
			arg0_207()
			nowWorld():TriggerAutoFight(false)
			arg0_183:Op("OpInteractive")
		end)
	end, SFX_PANEL)

	return var0_183
end

function var0_0.DisposeMapRight(arg0_208)
	if arg0_208.wsMapRight then
		arg0_208:HideMapRight()
		arg0_208.wsMapRight:Dispose()

		arg0_208.wsMapRight = nil
	end
end

function var0_0.DisplayMapOut(arg0_209)
	arg0_209.wsMapOut = arg0_209.wsMapOut or arg0_209:NewMapOut(arg0_209.rtOutMap)

	setActive(arg0_209.rtOutMap, true)
end

function var0_0.HideMapOut(arg0_210)
	setActive(arg0_210.rtOutMap, false)
end

function var0_0.NewMapOut(arg0_211, arg1_211)
	local var0_211 = WSMapOut.New()

	var0_211.transform = arg1_211

	var0_211:Setup()

	return var0_211
end

function var0_0.DisposeMapOut(arg0_212)
	if arg0_212.wsMapOut then
		arg0_212:HideMapOut()
		arg0_212.wsMapOut:Dispose()

		arg0_212.wsMapOut = nil
	end
end

function var0_0.OnUpdateProgress(arg0_213, arg1_213, arg2_213, arg3_213, arg4_213)
	arg0_213:UpdateSystemOpen()

	if arg0_213.wsMapRight then
		arg0_213.wsMapRight:OnUpdateHelpBtnTip()
	end
end

function var0_0.OnUpdateScale(arg0_214, arg1_214, arg2_214, arg3_214)
	if arg0_214.wsAtlas and not arg0_214.wsAtlasBottom:CheckIsTweening() then
		arg0_214.wsAtlas:UpdateScale(arg3_214)
	end
end

function var0_0.OnModelSelectMap(arg0_215, arg1_215, arg2_215, arg3_215, arg4_215, arg5_215)
	if arg3_215 then
		arg0_215:ShowSubView("FloatPanel", {
			arg3_215,
			arg4_215,
			arg5_215,
			arg2_215
		})
	else
		arg0_215:HideSubView("FloatPanel")
	end
end

function var0_0.OnUpdateSubmarineSupport(arg0_216, arg1_216)
	arg0_216.wsMap:UpdateSubmarineSupport()

	if arg0_216.wsMapLeft then
		arg0_216.wsMapLeft:OnUpdateSubmarineSupport()
	end
end

function var0_0.OnUpdateDaily(arg0_217)
	if arg0_217.wsAtlasBottom then
		setActive(arg0_217.wsAtlasBottom.btnDailyTask:Find("tip"), nowWorld():GetTaskProxy():canAcceptDailyTask())
	end
end

function var0_0.OnFleetSelected(arg0_218, arg1_218, arg2_218)
	if arg2_218.selected then
		arg0_218.wsDragProxy:Focus(arg2_218.transform.position, nil, LeanTweenType.easeInOutSine)
	end
end

function var0_0.OnSelectFleet(arg0_219, arg1_219, arg2_219, arg3_219)
	if arg3_219 == nowWorld():GetActiveMap():GetFleet() then
		arg0_219:Op("OpMoveCamera", 0, 0.1)
	else
		arg0_219:Op("OpReqSwitchFleet", arg3_219)
	end
end

function var0_0.OnClickCell(arg0_220, arg1_220, arg2_220)
	local var0_220 = nowWorld():GetActiveMap()
	local var1_220 = var0_220:GetFleet()
	local var2_220 = var0_220:GetCell(arg1_220, arg2_220)
	local var3_220 = var0_220:FindFleet(var2_220.row, var2_220.column)

	if var3_220 and var3_220 ~= var1_220 then
		arg0_220:Op("OpReqSwitchFleet", var3_220)
	elseif var0_220:CheckInteractive() then
		arg0_220:Op("OpInteractive", true)
	elseif var0_220:IsSign(arg1_220, arg2_220) and ManhattonDist({
		row = var1_220.row,
		column = var1_220.column
	}, {
		row = var2_220.row,
		column = var2_220.column
	}) <= 1 then
		arg0_220:Op("OpTriggerSign", var1_220, var2_220:GetEventAttachment(), function()
			arg0_220:Op("OpInteractive")
		end)
	elseif var0_220:CanLongMove(var1_220) then
		arg0_220:Op("OpLongMoveFleet", var1_220, var2_220.row, var2_220.column)
	else
		arg0_220:Op("OpReqMoveFleet", var1_220, var2_220.row, var2_220.column)
	end
end

function var0_0.OnClickTransport(arg0_222)
	if arg0_222.svScannerPanel:isShowing() then
		return
	end

	arg0_222:Op("OpCall", function(arg0_223)
		arg0_223()
		arg0_222:QueryTransport(function()
			arg0_222:EnterTransportWorld()
		end)
	end)
end

function var0_0.QueryTransport(arg0_225, arg1_225)
	local var0_225 = nowWorld()
	local var1_225 = var0_225:GetActiveMap()
	local var2_225 = {}

	if not var0_225:IsSystemOpen(WorldConst.SystemOutMap) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))

		return
	end

	if var1_225:CheckAttachmentTransport() == "story" then
		local var3_225 = pg.gameset.world_transfer_eventstory.description[1]

		table.insert(var2_225, function(arg0_226)
			arg0_225:OpRaw("OpStory", var3_225, true, true, false, function(arg0_227)
				if arg0_227 == 1 then
					arg0_226()
				end
			end)
		end)
	end

	if var0_225:IsSubmarineSupporting() and var1_225:GetSubmarineFleet():GetAmmo() > 0 then
		table.insert(var2_225, function(arg0_228)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_instruction_submarine_6"),
				onYes = arg0_228
			})
		end)
	end

	if var1_225:CheckFleetSalvage(true) then
		table.insert(var2_225, function(arg0_229)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_catsearch_leavemap"),
				onYes = arg0_229
			})
		end)
	end

	local var4_225

	for iter0_225, iter1_225 in ipairs(var1_225:GetNormalFleets()) do
		for iter2_225, iter3_225 in ipairs(iter1_225:GetCarries()) do
			if iter3_225.config.out_story ~= "" then
				var4_225 = iter3_225.config.out_story
			end
		end
	end

	if var4_225 then
		table.insert(var2_225, function(arg0_230)
			arg0_225:OpRaw("OpStory", var4_225, true, true, false, function(arg0_231)
				if arg0_231 == 1 then
					arg0_230()
				end
			end)
		end)
	end

	local var5_225, var6_225 = var1_225:CkeckTransport()

	if not var5_225 then
		table.insert(var2_225, function(arg0_232)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var6_225,
				onYes = arg0_232
			})
		end)
	end

	seriesAsync(var2_225, function()
		return arg1_225(var5_225)
	end)
end

function var0_0.OnUpdateEventTips(arg0_234, arg1_234, arg2_234)
	if arg0_234.wsMapRight then
		arg0_234.wsMapRight:OnUpdateEventTips()
	end

	if arg0_234.wsMapTop then
		arg0_234.wsMapTop:OnUpdatePoison()
	end
end

function var0_0.OnClickMap(arg0_235, arg1_235, arg2_235)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

	local var0_235 = arg0_235.wsMap.map
	local var1_235 = var0_235.top
	local var2_235 = var0_235.bottom
	local var3_235 = var0_235.left
	local var4_235 = var0_235.right

	if arg1_235 < var1_235 or var2_235 < arg1_235 or arg2_235 < var3_235 or var4_235 < arg2_235 then
		arg0_235:OnClickTransport()
	else
		arg0_235:OnClickCell(arg1_235, arg2_235)
	end
end

function var0_0.CheckScannerEnable(arg0_236, arg1_236, arg2_236)
	if nowWorld():IsSystemOpen(WorldConst.SystemScanner) then
		local var0_236 = arg0_236.wsMap.map:GetCell(arg1_236, arg2_236)

		if var0_236 and var0_236:GetInFOV() and not var0_236:InFog() then
			local var1_236 = var0_236:GetScannerAttachment()

			if var1_236 then
				local var2_236 = arg0_236.wsMap:GetCell(arg1_236, arg2_236).rtAttachments.position

				return var1_236, arg0_236.camera:WorldToScreenPoint(var2_236)
			end
		end
	end
end

function var0_0.OnLongPressMap(arg0_237, arg1_237, arg2_237)
	if not arg0_237.svScannerPanel:isShowing() then
		local var0_237, var1_237 = arg0_237:CheckScannerEnable(arg1_237, arg2_237)

		if var0_237 then
			arg0_237:Op("OpShowScannerPanel", var0_237, var1_237)
		end
	end
end

function var0_0.OnAchievementAchieved(arg0_238, arg1_238, arg2_238, arg3_238, arg4_238)
	if arg3_238 then
		for iter0_238, iter1_238 in ipairs(arg3_238) do
			pg.TipsMgr.GetInstance():ShowTips(iter1_238)
		end
	end

	if arg4_238 then
		local var0_238 = nowWorld()

		if var0_238.isAutoFight then
			var0_238:AddAutoInfo("message", i18n("autofight_discovery", arg4_238.config.target_desc))
		else
			table.insert(arg0_238.achievedList, {
				arg4_238,
				arg0_238.wsMapRight.btnInformation.position
			})
		end
	end
end

function var0_0.DoAnim(arg0_239, arg1_239, arg2_239)
	arg0_239:downloadWorldResList(arg0_239:getUIAnimResList(arg1_239), function()
		local var0_240 = arg0_239.wsAnim

		if not var0_240:GetAnim(arg1_239) then
			var0_240:SetAnim(arg1_239, arg0_239:NewUIAnim(arg1_239))
		end

		var0_240:GetAnim(arg1_239):Play(arg2_239)
	end)
end

function var0_0.NewUIAnim(arg0_241, arg1_241)
	local var0_241 = UIAnim.New()

	var0_241:Setup(arg1_241)
	var0_241:AddListener(UIAnim.EventLoaded, function()
		var0_241.transform:SetParent(arg0_241.rtTop, false)
	end)
	var0_241:Load()

	return var0_241
end

function var0_0.DoStrikeAnim(arg0_243, arg1_243, arg2_243, arg3_243)
	arg0_243:downloadWorldResList(arg0_243:getStrikeAnimResList(arg1_243, arg2_243), function()
		local var0_244 = arg0_243.wsAnim

		if not var0_244:GetAnim(arg1_243) then
			var0_244:SetAnim(arg1_243, arg0_243:NewStrikeAnim(arg1_243, arg2_243))
		else
			var0_244:GetAnim(arg1_243):ReloadShip(arg2_243)
		end

		var0_244:GetAnim(arg1_243):Play(arg3_243)
	end)
end

function var0_0.NewStrikeAnim(arg0_245, arg1_245, arg2_245)
	local var0_245 = UIStrikeAnim.New()

	var0_245:Setup(arg1_245, arg2_245)
	var0_245:AddListener(UIStrikeAnim.EventLoaded, function()
		var0_245.transform:SetParent(arg0_245.rtTop, false)
	end)
	var0_245:Load()

	return var0_245
end

function var0_0.StopAnim(arg0_247)
	arg0_247.wsAnim:Stop()
end

function var0_0.UpdateSystemOpen(arg0_248)
	local var0_248 = nowWorld()

	if arg0_248:GetInMap() then
		local var1_248 = var0_248:GetActiveMap()

		arg0_248.wsMapLeft.onAgonyClickEnabled = var0_248:IsSystemOpen(WorldConst.SystemInventory)

		setActive(arg0_248.wsMapRight.btnInventory, var0_248:IsSystemOpen(WorldConst.SystemInventory))
		setActive(arg0_248.wsMapRight.btnTransport, var0_248:IsSystemOpen(WorldConst.SystemOutMap))
		setActive(arg0_248.wsMapRight.btnDetail, var0_248:IsSystemOpen(WorldConst.SystemFleetDetail))
		setActive(arg0_248.wsMapRight.rtCompassPanel, var0_248:IsSystemOpen(WorldConst.SystemCompass))
		setActive(arg0_248.wsMapRight.toggleAutoFight, var1_248:CanAutoFight())
		setActive(arg0_248.wsMapRight.toggleAutoSwitch, var0_248:IsSystemOpen(WorldConst.SystemAutoSwitch))
	else
		setActive(arg0_248.wsAtlasBottom.btnBoss, var0_248:IsSystemOpen(WorldConst.SystemWorldBoss))

		local var2_248 = var0_248:GetBossProxy():NeedTip()
		local var3_248 = var0_248:GetBossProxy():ExistSelfBoss()
		local var4_248 = WorldBossConst.CanUnlockCurrBoss()
		local var5_248 = not var3_248 and not var4_248

		setActive(arg0_248.wsAtlasBottom.btnBoss:Find("tip"), var2_248 or var4_248 or WorldBossConst.AnyArchivesBossCanGetAward())
		setActive(arg0_248.wsAtlasBottom.btnBoss:Find("sel"), not var5_248)

		local var6_248 = arg0_248.rtTopAtlas:Find("reset_coutdown")

		onButton(arg0_248, var6_248, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("world_reset_tip")
			})
		end, SFX_PANEL)

		local var7_248 = var0_248:IsSystemOpen(WorldConst.SystemResetCountDown) and var0_248:CheckResetProgress()

		setActive(var6_248, var7_248)

		if var7_248 then
			local var8_248 = var0_248:GetResetWaitingTime()
			local var9_248 = math.floor(var8_248 / 86400)

			if var9_248 > 0 then
				setText(var6_248:Find("Text"), i18n("world_reset_1", string.format("  %d  ", var9_248)))
			elseif var9_248 == 0 then
				setText(var6_248:Find("Text"), i18n("world_reset_2", string.format("  %d  ", 0)))
			elseif var9_248 < 0 then
				setText(var6_248:Find("Text"), i18n("world_reset_3"))
			end
		end

		setActive(arg0_248.wsAtlasBottom.btnShop, var0_248:IsSystemOpen(WorldConst.SystemResetShop))
		setActive(arg0_248.wsAtlasBottom.btnDailyTask:Find("mask"), not var0_248:IsSystemOpen(WorldConst.SystemDailyTask))
		setActive(arg0_248.wsAtlasRight.btnSwitch, var0_248:IsSystemOpen(WorldConst.SystemAutoSwitch))
		setActive(arg0_248.wsAtlasRight.btnDelegate, var0_248:IsSystemOpen(WorldConst.SystemAutoSwitch))
	end

	setActive(arg0_248.resAtlas._tf, var0_248:IsSystemOpen(WorldConst.SystemResource))
	setActive(arg0_248.resMap._tf, var0_248:IsSystemOpen(WorldConst.SystemResource))
end

function var0_0.EnterToModelMap(arg0_250, arg1_250)
	local var0_250 = {}

	table.insert(var0_250, function(arg0_251)
		setActive(arg0_250.rtTopAtlas:Find("print/title_world"), true)
		setActive(arg0_250.rtTopAtlas:Find("print/title_view"), false)
		arg0_250.wsAtlasBottom:UpdateScale(1, true, arg0_251)
	end)
	table.insert(var0_250, function(arg0_252)
		arg0_250.wsAtlas:SwitchArea(arg1_250, true, arg0_252)
	end)
	parallelAsync(var0_250, function()
		local var0_253 = nowWorld():GetAtlas():GetActiveEntrance()

		if arg1_250 == var0_253:GetAreaId() then
			arg0_250.wsAtlas:UpdateSelect(var0_253)
		end
	end)
end

function var0_0.ReturnToModelArea(arg0_254)
	arg0_254.wsAtlas:UpdateSelect()

	local var0_254 = {}

	table.insert(var0_254, function(arg0_255)
		setActive(arg0_254.rtTopAtlas:Find("print/title_world"), false)
		setActive(arg0_254.rtTopAtlas:Find("print/title_view"), true)
		arg0_254.wsAtlasBottom:UpdateScale(0, true, arg0_255)
	end)
	table.insert(var0_254, function(arg0_256)
		arg0_254.wsAtlas:SwitchArea(nil, true, arg0_256)
	end)
	parallelAsync(var0_254, function()
		return
	end)
end

function var0_0.EnterTransportWorld(arg0_258, arg1_258)
	local var0_258 = nowWorld()

	arg1_258 = arg1_258 or {
		entrance = var0_258:GetActiveEntrance()
	}

	local var1_258 = {}

	if arg0_258:GetInMap() then
		table.insert(var1_258, function(arg0_259)
			arg0_258:Op("OpSetInMap", false, arg0_259)
		end)
	elseif not arg0_258.wsAtlas.nowArea then
		table.insert(var1_258, function(arg0_260)
			arg0_258.wsAtlas:SwitchArea(arg1_258.entrance:GetAreaId(), false, arg0_260)
		end)
	end

	seriesAsync(var1_258, function()
		arg0_258.wsAtlas:UpdateSelect()
		arg0_258.wsAtlas:UpdateSelect(arg1_258.entrance, arg1_258.mapId, arg1_258.mapTypes)
		arg0_258.wsAtlas:DisplayTransport(arg0_258.contextData.displayTransDic or {}, function()
			arg0_258.contextData.displayTransDic = Clone(var0_258:GetAtlas().transportDic)
		end)
	end)
end

function var0_0.BackToMap(arg0_263)
	if arg0_263.wsAtlas:CheckIsTweening() then
		return
	end

	arg0_263:Op("OpSetInMap", true)
end

function var0_0.DisplayEnv(arg0_264, arg1_264)
	local var0_264 = checkExist(nowWorld():GetActiveMap(), {
		"config"
	}, {
		"map_bg"
	}, {
		1
	}) or "model_bg"
	local var1_264 = {}

	if arg0_264.rtEnvBG:GetComponent(typeof(Image)).sprite.name ~= var0_264 then
		table.insert(var1_264, function(arg0_265)
			arg0_264:downloadWorldResList({
				"world/map/" .. var0_264
			}, arg0_265)
		end)
		table.insert(var1_264, function(arg0_266)
			GetSpriteFromAtlasAsync("world/map/" .. var0_264, var0_264, function(arg0_267)
				setImageSprite(arg0_264.rtEnvBG, arg0_267)

				return arg0_266()
			end)
		end)
	end

	seriesAsync(var1_264, arg1_264)
end

function var0_0.ScreenPos2MapPos(arg0_268, arg1_268)
	local var0_268 = arg0_268.wsMap
	local var1_268 = var0_268.map
	local var2_268 = arg0_268.camera:ScreenPointToRay(arg1_268)
	local var3_268, var4_268 = Plane.New(var0_268.rtQuads.forward, -Vector3.Dot(var0_268.rtQuads.position, var0_268.rtQuads.forward)):Raycast(var2_268)

	if var3_268 then
		local var5_268 = var2_268:GetPoint(var4_268)
		local var6_268 = var0_268.rtQuads:InverseTransformPoint(var5_268)
		local var7_268 = var1_268.theme:X2Column(var6_268.x)

		return var1_268.theme:Y2Row(var6_268.y), var7_268
	end
end

function var0_0.BuildCutInAnim(arg0_269, arg1_269, arg2_269)
	arg0_269.tfAnim = arg0_269.rtPanelList:Find(arg1_269 .. "(Clone)")

	local var0_269 = {}

	if not arg0_269.tfAnim then
		table.insert(var0_269, function(arg0_270)
			arg0_269:downloadWorldResList({
				"ui/" .. arg1_269
			}, arg0_270)
		end)
		table.insert(var0_269, function(arg0_271)
			PoolMgr.GetInstance():GetUI(arg1_269, true, function(arg0_272)
				arg0_272:SetActive(false)

				arg0_269.tfAnim = tf(arg0_272)

				arg0_269.tfAnim:SetParent(arg0_269.rtPanelList, false)

				return arg0_271()
			end)
		end)
	end

	table.insert(var0_269, function(arg0_273)
		arg0_269.inCutIn = true

		arg0_269.tfAnim:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_274)
			if not IsNil(arg0_269.tfAnim) then
				arg0_269.inCutIn = false

				arg0_269:UnOverlayPanel(arg0_269.tfAnim, arg0_269.rtPanelList)
				setActive(arg0_269.tfAnim, false)

				return arg0_273()
			end
		end)
		arg0_269:OverlayPanel(arg0_269.tfAnim)
		setActive(arg0_269.tfAnim, true)
	end)
	seriesAsync(var0_269, function()
		return existCall(arg2_269)
	end)
end

function var0_0.PlaySound(arg0_276, arg1_276, arg2_276)
	if arg0_276.cueName then
		pg.CriMgr.GetInstance():StopSE_V3()

		arg0_276.cueName = nil
	end

	pg.CriMgr.GetInstance():PlaySE_V3(arg1_276, function()
		arg0_276.cueName = nil
	end)

	return existCall(arg2_276)
end

function var0_0.ChangeTopRaycasts(arg0_278, arg1_278)
	GetOrAddComponent(arg0_278.rtTop, typeof(CanvasGroup)).blocksRaycasts = tobool(arg1_278)
end

function var0_0.DoTopBlock(arg0_279, arg1_279)
	arg0_279:ChangeTopRaycasts(false)

	return function(...)
		arg0_279:ChangeTopRaycasts(true)

		return existCall(arg1_279, ...)
	end
end

function var0_0.SetMoveQueue(arg0_281, arg1_281)
	arg0_281:ReContinueMoveQueue()

	arg0_281.moveQueue = arg1_281
end

function var0_0.ClearMoveQueue(arg0_282)
	arg0_282:DisplayMoveStopClick(false)

	arg0_282.moveQueueInteractive = true

	if #arg0_282.moveQueue > 0 then
		arg0_282.moveQueue = {}
	end

	arg0_282:ShowFleetMoveTurn(false)
end

function var0_0.DoQueueMove(arg0_283, arg1_283)
	assert(#arg0_283.moveQueue > 0, "without move queue")
	arg0_283:DisplayMoveStopClick(true)

	local var0_283 = nowWorld():GetActiveMap()
	local var1_283 = _.detect(arg0_283.moveQueue, function(arg0_284)
		return arg0_284.stay
	end)

	if #arg0_283.moveQueue == 1 and var0_283:IsSign(var1_283.row, var1_283.column) then
		arg0_283:ClearMoveQueue()

		local var2_283 = var0_283:GetCell(var1_283.row, var1_283.column)

		arg0_283:Op("OpTriggerSign", arg1_283, var2_283:GetEventAttachment(), function()
			arg0_283:Op("OpInteractive")
		end)
	else
		arg0_283:ReContinueMoveQueue()
		arg0_283:ShowFleetMoveTurn(true)
		arg0_283:Op("OpReqMoveFleet", arg1_283, var1_283.row, var1_283.column)
	end
end

function var0_0.CheckMoveQueue(arg0_286, arg1_286)
	if #arg0_286.moveQueue < #arg1_286 or #arg1_286 == 0 then
		arg0_286:ClearMoveQueue()
	else
		local var0_286 = arg1_286[#arg1_286]

		if arg0_286.moveQueue[#arg1_286].row ~= var0_286.row or arg0_286.moveQueue[#arg1_286].column ~= var0_286.column then
			arg0_286:ClearMoveQueue()
		else
			for iter0_286 = 1, #arg1_286 do
				table.remove(arg0_286.moveQueue, 1)
			end

			if #arg0_286.moveQueue == 0 then
				arg0_286:ResetLostMoveQueueCount()

				arg0_286.moveQueueInteractive = true
			end
		end
	end
end

function var0_0.InteractiveMoveQueue(arg0_287)
	if arg0_287.moveQueueInteractive then
		arg0_287:ClearMoveQueue()
	else
		arg0_287:DisplayMoveStopClick(false)

		arg0_287.moveQueueInteractive = true
	end
end

function var0_0.ReContinueMoveQueue(arg0_288)
	arg0_288.moveQueueInteractive = false
end

function var0_0.CheckLostMoveQueueCount(arg0_289)
	arg0_289.lostMoveQueueCount = defaultValue(arg0_289.lostMoveQueueCount, 0) + 1

	return arg0_289.lostMoveQueueCount > WorldConst.AutoFightLoopCountLimit
end

function var0_0.ResetLostMoveQueueCount(arg0_290, arg1_290)
	if arg1_290 then
		arg0_290.inLoopAutoFight = true
	end

	arg0_290.lostMoveQueueCount = 0
end

function var0_0.DisplayMoveStopClick(arg0_291, arg1_291)
	setActive(arg0_291.rtClickStop, arg1_291)

	if arg1_291 then
		local var0_291 = nowWorld().isAutoFight

		setActive(arg0_291.rtClickStop:Find("long_move"), not var0_291)
		setActive(arg0_291.rtClickStop:Find("auto_fight"), var0_291)
	end
end

function var0_0.ShowFleetMoveTurn(arg0_292, arg1_292)
	if arg0_292.wsMap then
		if arg1_292 then
			arg0_292.wsMap:GetFleet():PlusMoveTurn()
		else
			arg0_292.wsMap:GetFleet():ClearMoveTurn()
		end
	end
end

function var0_0.GetAllPessingAward(arg0_293, arg1_293)
	local var0_293 = nowWorld()
	local var1_293 = var0_293:GetAtlas()
	local var2_293 = {}

	for iter0_293, iter1_293 in pairs(var0_293.pressingAwardDic) do
		if iter1_293.flag then
			var0_293:FlagMapPressingAward(iter0_293)
			var1_293:MarkMapTransport(iter0_293)

			local var3_293 = pg.world_event_complete[iter1_293.id].event_reward_slgbuff

			if #var3_293 > 0 then
				var2_293[var3_293[1]] = defaultValue(var2_293[var3_293[1]], 0) + var3_293[2]
			end
		end
	end

	local var4_293 = var0_293:GetActiveMap()

	if not var4_293.visionFlag and var0_293:IsMapVisioned(var4_293.id) then
		var4_293:UpdateVisionFlag(true)
	end

	if arg0_293.wsAtlas then
		arg0_293.wsAtlas:OnUpdatePressingAward()
	end

	local var5_293 = {}

	for iter2_293, iter3_293 in pairs(var2_293) do
		table.insert(var5_293, function(arg0_294)
			local var0_294 = {
				id = iter2_293,
				floor = iter3_293,
				before = var0_293:GetGlobalBuff(iter2_293):GetFloor()
			}

			arg0_293:ShowSubView("GlobalBuff", {
				var0_294,
				arg0_294
			})
		end)
		table.insert(var5_293, function(arg0_295)
			var0_293:AddGlobalBuff(iter2_293, iter3_293)
			arg0_295()
		end)
	end

	seriesAsync(var5_293, function()
		return existCall(arg1_293)
	end)
end

function var0_0.GetDelegatedAwards(arg0_297, arg1_297, arg2_297, arg3_297, arg4_297)
	local var0_297 = nowWorld()
	local var1_297 = var0_297:GetAtlas()
	local var2_297 = {}

	for iter0_297, iter1_297 in ipairs(arg1_297) do
		local var3_297 = var0_297.pressingAwardDic[iter1_297]

		if var3_297.flag then
			var0_297:FlagMapPressingAward(iter1_297)
			var1_297:MarkMapTransport(iter1_297)

			local var4_297 = pg.world_event_complete[var3_297.id].event_reward_slgbuff

			if #var4_297 > 0 then
				var2_297[var4_297[1]] = defaultValue(var2_297[var4_297[1]], 0) + var4_297[2]
			end
		end
	end

	if arg0_297.wsAtlas then
		arg0_297.wsAtlas:OnUpdatePressingAward()
	end

	local var5_297 = {}
	local var6_297 = {}

	for iter2_297, iter3_297 in pairs(var2_297) do
		table.insert(var5_297, function(arg0_298)
			local var0_298 = {
				id = iter2_297,
				floor = iter3_297,
				before = var0_297:GetGlobalBuff(iter2_297):GetFloor()
			}

			table.insert(var6_297, var0_298)
			arg0_297:ShowSubView("GlobalBuff", {
				var0_298,
				arg0_298
			})
		end)
		table.insert(var5_297, function(arg0_299)
			var0_297:AddGlobalBuff(iter2_297, iter3_297)
			arg0_299()
		end)
	end

	if #arg2_297 > 0 then
		table.insert(var5_297, function(arg0_300)
			arg0_297:Op("OpOpenLayer", Context.New({
				viewComponent = WorldChapterAutoRewardLayer,
				mediator = WorldChapterAutoRewardMediator,
				data = {
					awards = arg2_297,
					buffInfos = var6_297,
					proficiency = arg3_297,
					onClose = arg0_300
				}
			}))
		end)
	end

	seriesAsync(var5_297, arg4_297)
end

function var0_0.CheckGuideSLG(arg0_301, arg1_301, arg2_301)
	local var0_301 = nowWorld()
	local var1_301 = {}

	table.insert(var1_301, {
		"WorldG007",
		function()
			local var0_302 = arg1_301:GetPort()

			if var0_302 and not var0_302:IsTempPort() then
				local var1_302 = arg1_301:GetFleet()

				return not arg1_301:GetCell(var1_302.row, var1_302.column):ExistEnemy()
			end
		end
	})
	table.insert(var1_301, {
		"WorldG111",
		function()
			return arg1_301:canExit()
		end
	})
	table.insert(var1_301, {
		"WorldG112",
		function()
			local var0_304 = var0_301:GetActiveEntrance()

			return var0_304.becomeSairen and var0_304:GetSairenMapId() == arg1_301.id
		end
	})
	table.insert(var1_301, {
		"WorldG124",
		function()
			return var0_301:IsSystemOpen(WorldConst.SystemOrderSubmarine) and arg1_301:GetConfig("instruction_available")[1] ~= 0 and var0_301:CanCallSubmarineSupport()
		end
	})
	table.insert(var1_301, {
		"WorldG162",
		function()
			return _.any(arg1_301:GetNormalFleets(), function(arg0_307)
				return _.any(arg0_307:GetShips(true), function(arg0_308)
					return arg0_308:IsBroken()
				end)
			end)
		end
	})
	table.insert(var1_301, {
		"WorldG163",
		function()
			local var0_309 = var0_301:GetTaskProxy():getDoingTaskVOs()

			return underscore.any(var0_309, function(arg0_310)
				return not arg0_310:IsAutoSubmit() and arg0_310:isFinished()
			end)
		end
	})
	table.insert(var1_301, {
		"WorldG164",
		function()
			return arg1_301:CheckFleetSalvage(true)
		end
	})
	table.insert(var1_301, {
		"WorldG181",
		function()
			return var0_301:GetInventoryProxy():GetItemCount(102) > 0
		end
	})
	table.insert(var1_301, {
		"WorldG191",
		function()
			return WorldBossConst.CanUnlockCurrBoss() and nowWorld():IsSystemOpen(WorldConst.SystemWorldBoss)
		end
	})

	local var2_301 = _.filter(arg1_301:FindAttachments(WorldMapAttachment.TypeEvent), function(arg0_314)
		return arg0_314:IsAlive()
	end)

	for iter0_301, iter1_301 in ipairs(pg.gameset.world_guide_event.description) do
		table.insert(var1_301, {
			iter1_301[2],
			function()
				return _.any(var2_301, function(arg0_316)
					return arg0_316.id == iter1_301[1]
				end)
			end
		})
	end

	local var3_301 = pg.NewStoryMgr.GetInstance()

	for iter2_301, iter3_301 in ipairs(var1_301) do
		if not var3_301:IsPlayed(iter3_301[1]) and iter3_301[2]() then
			WorldGuider.GetInstance():PlayGuide(iter3_301[1])

			return true
		end
	end

	return false
end

function var0_0.CheckEventForMsg(arg0_317, arg1_317)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_317.player.level, "EventMediator") and getProxy(EventProxy).eventForMsg
end

function var0_0.OpenPortLayer(arg0_318, arg1_318)
	arg0_318:Op("OpOpenLayer", Context.New({
		mediator = WorldPortMediator,
		viewComponent = WorldPortLayer,
		data = arg1_318
	}))
end

function var0_0.ShowTransportMarkOverview(arg0_319, arg1_319, arg2_319)
	if nowWorld():GetActiveMap():CheckFleetSalvage(true) then
		arg0_319:Op("OpShowMarkOverview", arg1_319, function()
			pg.NewStoryMgr.GetInstance():Play(pg.gameset.world_catsearch_special.description[1], arg2_319, true)
		end)
	else
		arg0_319:Op("OpShowMarkOverview", arg1_319, arg2_319)
	end
end

function var0_0.UpdateAutoFightDisplay(arg0_321)
	arg0_321:ClearMoveQueue()

	local var0_321 = nowWorld().isAutoFight

	if arg0_321.wsMapRight then
		setActive(arg0_321.wsMapRight.toggleAutoFight:Find("off"), not var0_321)
		setActive(arg0_321.wsMapRight.toggleAutoFight:Find("on"), var0_321)
		setActive(arg0_321.wsMapRight.toggleSkipPrecombat, not var0_321)
		triggerToggle(arg0_321.wsMapRight.toggleSkipPrecombat, PlayerPrefs.GetInt("world_skip_precombat", 0) == 1)
	end
end

function var0_0.UpdateAutoSwitchDisplay(arg0_322)
	local var0_322 = nowWorld().isAutoSwitch

	if arg0_322.wsMapRight then
		setActive(arg0_322.wsMapRight.toggleAutoSwitch:Find("off"), not var0_322)
		setActive(arg0_322.wsMapRight.toggleAutoSwitch:Find("on"), var0_322)
	end
end

function var0_0.GuideShowScannerEvent(arg0_323, arg1_323)
	assert(arg0_323.svScannerPanel:isShowing(), "scanner mode is closed")

	local var0_323 = arg0_323.wsMap.map:FindAttachments(WorldMapAttachment.TypeEvent, arg1_323)

	assert(#var0_323 == 1, "event number error: " .. #var0_323)

	local var1_323, var2_323 = arg0_323:CheckScannerEnable(var0_323[1].row, var0_323[1].column)

	assert(var1_323, "without scanner attachment")
	arg0_323.svScannerPanel:ActionInvoke("DisplayWindow", var1_323, var2_323)
end

function var0_0.DisplayAwards(arg0_324, arg1_324, arg2_324, arg3_324)
	local var0_324 = {}
	local var1_324 = {}

	for iter0_324, iter1_324 in ipairs(arg1_324) do
		if iter1_324.type == DROP_TYPE_WORLD_COLLECTION then
			table.insert(var1_324, iter1_324)
		else
			table.insert(var0_324, iter1_324)
		end
	end

	seriesAsync({
		function(arg0_325)
			if #var0_324 == 0 then
				return arg0_325()
			end

			arg2_324.items = var0_324
			arg2_324.removeFunc = arg0_325

			arg0_324:emit(BaseUI.ON_WORLD_ACHIEVE, arg2_324)
		end,
		function(arg0_326)
			local var0_326 = var1_324[1]

			if not var0_326 then
				arg0_326()

				return
			end

			assert(WorldCollectionProxy.GetCollectionType(var0_326.id) == WorldCollectionProxy.WorldCollectionType.FILE, string.format("collection drop type error#%d", var0_326.id))
			arg0_324:emit(WorldMediator.OnOpenLayer, Context.New({
				mediator = WorldMediaCollectionFilePreviewMediator,
				viewComponent = WorldMediaCollectionFilePreviewLayer,
				data = {
					collectionId = var0_326.id
				},
				onRemoved = arg0_326
			}))
		end
	}, arg3_324)
end

function var0_0.DisplayPhaseAction(arg0_327, arg1_327)
	local var0_327 = {}

	while #arg1_327 > 0 do
		local var1_327 = nowWorld()
		local var2_327 = table.remove(arg1_327, 1)

		table.insert(var0_327, function(arg0_328)
			if var2_327.anim then
				arg0_327:BuildCutInAnim(var2_327.anim, arg0_328)
			elseif var2_327.story then
				if var1_327.isAutoFight then
					arg0_328()
				else
					pg.NewStoryMgr.GetInstance():Play(var2_327.story, arg0_328, true)
				end
			elseif var2_327.drops then
				if var1_327.isAutoFight then
					var1_327:AddAutoInfo("drops", var2_327.drops)
					arg0_328()
				else
					arg0_327:DisplayAwards(var2_327.drops, {}, arg0_328)
				end
			end
		end)
	end

	seriesAsync(var0_327, function()
		arg0_327:Op("OpInteractive")
	end)
end

function var0_0.StartAutoSwitch(arg0_330)
	local var0_330 = nowWorld()
	local var1_330 = var0_330:GetActiveEntrance()
	local var2_330 = var0_330:GetActiveMap()

	if PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_SAFE and PlayerPrefs.GetString("auto_switch_difficult_safe", "only") == "only" and World.ReplacementMapType(var1_330, var2_330) ~= "complete_chapter" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip3"))

		return
	elseif PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_TREASURE and not var0_330:GetGobalFlag("treasure_flag") then
		pg.TipsMgr.GetInstance():ShowTips("without auto switch flag")

		return
	end

	arg0_330:QueryTransport(function(arg0_331)
		if not arg0_331 then
			if PlayerPrefs.GetInt("auto_switch_mode", 0) == WorldSwitchPlanningLayer.MODE_TREASURE and World.ReplacementMapType(var1_330, var2_330) == "teasure_chapter" then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip5"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip4"))
			end
		else
			getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
			PlayerPrefs.SetInt("world_skip_precombat", 1)
			PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(SYSTEM_WORLD), 1)
			arg0_330:Op("OpAutoSwitchMap")
		end
	end)
end

function var0_0.MoveAndOpenLayer(arg0_332, arg1_332)
	local var0_332 = {}

	table.insert(var0_332, function(arg0_333)
		arg0_332:Op("OpSetInMap", arg1_332.inMap, arg0_333)
	end)
	seriesAsync(var0_332, function()
		arg0_332:Op("OpOpenLayer", arg1_332.context)
	end)
end

function var0_0.GetDepth(arg0_335)
	return #arg0_335.wsCommands
end

function var0_0.GetCommand(arg0_336, arg1_336)
	return arg0_336.wsCommands[arg1_336 or arg0_336:GetDepth()]
end

function var0_0.Op(arg0_337, arg1_337, ...)
	arg0_337:GetCommand():Op(arg1_337, ...)
end

function var0_0.OpRaw(arg0_338, arg1_338, ...)
	arg0_338:GetCommand():OpRaw(arg1_338, ...)
end

function var0_0.OpOpen(arg0_339)
	local var0_339 = arg0_339:GetDepth()

	WorldConst.Print("open operation stack: " .. var0_339 + 1)
	table.insert(arg0_339.wsCommands, WSCommand.New(var0_339 + 1))
end

function var0_0.OpClose(arg0_340)
	local var0_340 = arg0_340:GetDepth()

	assert(var0_340 > 0)
	WorldConst.Print("close operation stack: " .. var0_340)
	arg0_340.wsCommands[var0_340]:Dispose()
	table.remove(arg0_340.wsCommands, var0_340)
end

function var0_0.OpClear(arg0_341)
	for iter0_341, iter1_341 in ipairs(arg0_341.wsCommands) do
		iter1_341:OpClear()
	end
end

function var0_0.OpDispose(arg0_342)
	for iter0_342, iter1_342 in ipairs(arg0_342.wsCommands) do
		iter1_342:Dispose()
	end

	arg0_342.wsCommands = nil
end

function var0_0.NewMapOp(arg0_343, arg1_343)
	local var0_343 = WBank:Fetch(WorldMapOp)

	var0_343.depth = arg0_343:GetDepth()

	for iter0_343, iter1_343 in pairs(arg1_343) do
		var0_343[iter0_343] = iter1_343
	end

	return var0_343
end

function var0_0.RegistMapOp(arg0_344, arg1_344)
	assert(arg1_344, "mapOp can not be nil.")
	assert(not table.contains(arg0_344.mapOps, arg1_344), "repeated registered mapOp.")
	table.insert(arg0_344.mapOps, arg1_344)
	arg1_344:AddCallbackWhenApplied(function()
		for iter0_345 = #arg0_344.mapOps, 1, -1 do
			if arg0_344.mapOps[iter0_345] == arg1_344 then
				table.remove(arg0_344.mapOps, iter0_345)
			end
		end
	end)
end

function var0_0.VerifyMapOp(arg0_346)
	for iter0_346 = #arg0_346.mapOps, 1, -1 do
		local var0_346 = table.remove(arg0_346.mapOps, iter0_346)

		if not var0_346.applied then
			var0_346:Apply()
		end
	end

	arg0_346:OpClear()
end

function var0_0.GetCompassGridPos(arg0_347, arg1_347, arg2_347, arg3_347)
	WorldGuider.GetInstance():SetTempGridPos(arg0_347.wsMapRight.wsCompass:GetMarkPosition(arg1_347, arg2_347), arg3_347)
end

function var0_0.GetEntranceTrackMark(arg0_348, arg1_348, arg2_348)
	WorldGuider.GetInstance():SetTempGridPos(arg0_348.wsMapRight.wsCompass:GetEntranceTrackMark(arg1_348), arg2_348)
end

function var0_0.GetSlgTilePos(arg0_349, arg1_349, arg2_349, arg3_349)
	WorldGuider.GetInstance():SetTempGridPos2(arg0_349.wsMap:GetCell(arg1_349, arg2_349):GetWorldPos(), arg3_349)
end

function var0_0.GetScannerPos(arg0_350, arg1_350)
	local var0_350 = arg0_350.svScannerPanel.rtPanel.transform
	local var1_350 = arg0_350.svScannerPanel.rtWindow.transform
	local var2_350 = Vector3.New(var1_350.localPosition.x + var1_350.rect.width * (0.5 - var1_350.pivot.x), var1_350.localPosition.y + var1_350.rect.height * (0.5 - var1_350.pivot.y), 0)
	local var3_350 = var0_350:TransformPoint(var2_350)

	WorldGuider.GetInstance():SetTempGridPos(var3_350, arg1_350)
end

function var0_0.GuideSelectModelMap(arg0_351, arg1_351)
	local var0_351 = nowWorld():GetEntrance(arg1_351)

	assert(arg0_351.wsAtlas, "didn't enter the world map mode")
	arg0_351:ClickAtlas(var0_351)
end

return var0_0
