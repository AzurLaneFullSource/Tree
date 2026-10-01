local var0_0 = class("IslandBaseScene", import("view.base.BaseUI"))

var0_0.ON_SCENE_LOADED = "IslandBaseScene:ON_SCENE_LOADED"
var0_0.LINK_CORE_EVENT = "IslandBaseScene:LINK_CORE_EVENT"

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.sceneMgr = IslandSceneMgr.New(arg0_1)
	arg0_1.__callbacks__ = {}
	arg0_1.showBalance = 1
	arg0_1.cacheAbList = {
		"ui/islandui_atlas",
		"ui/islandcommonui_atlas",
		"island/IslandInteractionBtns"
	}
end

function var0_0.getDefaultUI(arg0_2)
	return arg0_2._container
end

function var0_0.DontGC(arg0_3)
	return true
end

function var0_0.forceGC(arg0_4)
	return false
end

function var0_0.GCWhenAwake(arg0_5)
	return false
end

function var0_0.PlayBGM(arg0_6)
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.preload(arg0_7, arg1_7)
	local var0_7 = {}

	table.insert(var0_7, function(arg0_8)
		arg0_7:LoadUIContainer(arg0_8)
	end)
	table.insert(var0_7, function(arg0_9)
		arg0_7.poolMgr = IslandPoolMgr.New(arg0_7.poolContainer)

		arg0_7.poolMgr:Init(arg0_9)
	end)

	for iter0_7, iter1_7 in ipairs(arg0_7.cacheAbList) do
		table.insert(var0_7, function(arg0_10)
			AssetBundleHelper.StoreAssetBundle(iter1_7, true, false, function(arg0_11)
				arg0_10()
			end)
		end)
	end

	seriesAsync(var0_7, arg1_7)
end

function var0_0.getResource(arg0_12)
	local var0_12 = var0_0.super.getResource(arg0_12)
	local var1_12 = {
		"UI/UIIsland"
	}

	for iter0_12, iter1_12 in ipairs(arg0_12.cacheAbList or {}) do
		if not table.contains(var0_12, iter1_12) then
			table.insert(var0_12, iter1_12)
		end
	end

	for iter2_12, iter3_12 in ipairs(var1_12) do
		if noEmptyStr(iter3_12) and not table.contains(var0_12, iter3_12) then
			table.insert(var0_12, iter3_12)
		end
	end

	return var0_12
end

function var0_0.LoadUIContainer(arg0_13, arg1_13)
	ResourceMgr.Inst:getAssetAsync("UI/UIIsland", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_14)
		IslandHelper.InstantiateAsyncGameObject(arg0_14, function(arg0_15)
			arg0_13._container = arg0_15.transform
			arg0_13.canvasGroup = GetOrAddComponent(arg0_13._container, typeof(CanvasGroup))
			arg0_13.uiLayer1 = arg0_13._container:Find("layer1")
			arg0_13.uiLayer2 = arg0_13._container:Find("layer2")
			arg0_13.uiContainer = arg0_13._container:Find("layer1/ui")
			arg0_13.opContainer = arg0_13._container:Find("layer1/op")
			arg0_13.pageContainer = arg0_13._container:Find("layer1/page")
			arg0_13.poolContainer = arg0_13._container:Find("_pool_")
			arg0_13._container.name = "UIIsland"

			setParent(arg0_13._container, pg.UIMgr.GetInstance().UICanvas)
			arg1_13()
		end)
	end), true, true)
end

function var0_0.SetUIParent(arg0_16, arg1_16)
	arg1_16.transform:SetParent(arg0_16.uiContainer, false)
end

function var0_0.emit(arg0_17, arg1_17, ...)
	if arg1_17 == BaseUI.ON_HOME or arg1_17 == IslandMediator.CHANGE_SCENE then
		if ISLAND_PLAYER_TESTING then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_home_btn_cant_use"))

			return
		end

		arg0_17:ExitProcess(arg1_17, nil, ...)
	else
		var0_0.super.emit(arg0_17, arg1_17, ...)
	end
end

function var0_0.emitCoreController(arg0_18, arg1_18, ...)
	arg0_18:emit(var0_0.LINK_CORE_EVENT, arg1_18, ...)
end

function var0_0.emitCore(arg0_19, arg1_19, ...)
	arg0_19:emit(var0_0.LINK_CORE_EVENT, IslandProxy.LINK_CORE, arg1_19, ...)
end

function var0_0.ExitProcess(arg0_20, arg1_20, arg2_20, ...)
	local var0_20 = packEx(...)
	local var1_20 = arg0_20:GetIsland()

	seriesAsync({
		function(arg0_21)
			arg0_20:emit(IslandBaseMediator.RECORD_PLAYER_POS)
			pg.m02:sendNotification(GAME.ISLAND_EXIT, {
				id = var1_20.id,
				callback = arg0_21
			})
		end
	}, function()
		var0_0.super.emit(arg0_20, arg1_20, unpackEx(var0_20))

		if arg2_20 then
			arg2_20()
		end
	end)
end

function var0_0.GetIsland(arg0_23)
	assert(false, "overwrite me !!!!")
end

function var0_0.onUILoaded(arg0_24, arg1_24)
	var0_0.super.onUILoaded(arg0_24, arg1_24)

	arg0_24.subViews = {
		IslandMsgBox.New(pg.UIMgr.GetInstance().OverlayMain, arg0_24.event),
		IslandToast.New(pg.UIMgr.GetInstance().OverlayToast, arg0_24.event),
		IslandStoryMgr.New(pg.UIMgr.GetInstance().OverlayToast, arg0_24.event),
		IslandAwardDisplayPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_24.event),
		IslandQueueUpMsgBox.New(pg.UIMgr.GetInstance().OverlayToast, arg0_24.event),
		IslandTimelineMgr.New(arg0_24:GetPoolMgr(), pg.UIMgr.GetInstance().OverlayToast, arg0_24.event),
		Island3dTaskAcceptPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_24.event),
		IslandSystemUnlockPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_24.event)
	}
	arg0_24.monitors = {
		IslandPlayerDataMonitor.New(arg0_24:GetIsland()),
		IslandSyncDataMonitor.New(arg0_24:GetIsland()),
		IslandCheaterTavernMonitor.New(arg0_24:GetIsland())
	}
	arg0_24.poppingQueue = IslandPoppingQueue.New(arg0_24)

	arg0_24:AddCommonListeners()
	arg0_24:AddListeners()

	for iter0_24, iter1_24 in pairs(arg0_24.subViews) do
		iter1_24:RegisterView(arg0_24)
	end
end

function var0_0.AddCommonListeners(arg0_25)
	arg0_25:AddListener(ISLAND_EX_EVT.EMIT, arg0_25.OnEmit)
	arg0_25:AddListener(ISLAND_EX_EVT.INIT_FINISH, arg0_25.OnSceneLoaded)
	arg0_25:AddListener(ISLAND_EX_EVT.SHOW_MSG, arg0_25.OnShowMsgBox)
	arg0_25:AddListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_25.OnOpenPage)
	arg0_25:AddListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_25.OnPlayTimeline)
	arg0_25:AddListener(var0_0.LINK_CORE_EVENT, arg0_25.OnLinkCoreEvent)
	arg0_25:AddListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_25.OnOpenAnimatonOpPage)
	arg0_25:AddListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_25.OnCloseAnimatonOpPage)
end

function var0_0.GetSubView(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.subViews) do
		if isa(iter1_26, arg1_26) then
			return iter1_26
		end
	end

	return nil
end

function var0_0.GetPoolMgr(arg0_27)
	return arg0_27.poolMgr
end

function var0_0.OnOpenAnimatonOpPage(arg0_28)
	return
end

function var0_0.OnCloseAnimatonOpPage(arg0_29)
	return
end

function var0_0.OnLinkCoreEvent(arg0_30, arg1_30, ...)
	arg0_30:GetIsland():DispatchEvent(arg1_30, ...)
end

function var0_0.OnSetUpCore(arg0_31, arg1_31, arg2_31)
	return
end

function var0_0.OnOpenPage(arg0_32, arg1_32, ...)
	arg0_32:OpenPage(arg1_32, ...)
end

function var0_0.OnShowMsgBox(arg0_33, arg1_33)
	arg0_33:ShowMsgbox(arg1_33)
end

function var0_0.OnPlayTimeline(arg0_34, arg1_34, arg2_34, arg3_34)
	arg0_34:PlayTimeline(arg1_34, arg2_34, arg3_34)
end

function var0_0.OnSceneLoaded(arg0_35)
	arg0_35:emit(var0_0.ON_SCENE_LOADED)
end

function var0_0.OnEmit(arg0_36, arg1_36, ...)
	arg0_36:emit(arg1_36, ...)
end

function var0_0.StartCore(arg0_37)
	arg0_37:emit(IslandBaseMediator.SET_UP)
end

function var0_0.setVisible(arg0_38, arg1_38)
	local var0_38 = GetOrAddComponent(arg0_38._tf, typeof(CanvasGroup))

	var0_38.alpha = arg1_38 and 1 or 0
	var0_38.blocksRaycasts = arg1_38

	if arg1_38 then
		arg0_38:OnVisible()
	else
		arg0_38:OnDisVisible()
	end
end

function var0_0.TryVisible(arg0_39)
	arg0_39.showBalance = arg0_39.showBalance + 1

	if arg0_39.showBalance == 1 then
		arg0_39:setVisible(true)
	end
end

function var0_0.TryDisVisible(arg0_40)
	arg0_40.showBalance = arg0_40.showBalance - 1

	if arg0_40.showBalance == 0 then
		arg0_40:setVisible(false)
	end
end

function var0_0.OpenPage(arg0_41, arg1_41, ...)
	IslandGuideChecker.CheckOnOpenPage(arg1_41.__cname)

	return arg0_41.sceneMgr:OpenPage(arg0_41, arg1_41, ...)
end

function var0_0.ClosePage(arg0_42, arg1_42)
	arg0_42.sceneMgr:ClosePage(arg1_42)
end

function var0_0.GetPage(arg0_43, arg1_43)
	return arg0_43.sceneMgr:GetPage(arg1_43)
end

function var0_0.GetSubPage(arg0_44, arg1_44)
	return arg0_44.sceneMgr:GetSubPage(arg1_44)
end

function var0_0.ShowToast(arg0_45, arg1_45)
	arg0_45:GetSubView(IslandToast):ExecuteAction("Show", arg1_45)
end

function var0_0.DisplayAward(arg0_46, arg1_46)
	arg0_46:GetSubView(IslandAwardDisplayPage):ExecuteAction("Show", arg1_46)
end

function var0_0.PlayTimeline(arg0_47, arg1_47, arg2_47, arg3_47)
	arg0_47:GetSubView(IslandTimelineMgr):ExecuteAction("Show", arg1_47, arg2_47, arg3_47)
end

function var0_0.PlayGetShipTimeline(arg0_48, arg1_48, arg2_48)
	arg0_48:PlayTimeline(2, {
		arg1_48
	}, arg2_48)
end

function var0_0.PlayStory(arg0_49, arg1_49)
	arg0_49.poppingQueue:Enqueue(IslandPoppingQueue.STORY, arg1_49)
end

function var0_0.ShowMsgbox(arg0_50, arg1_50)
	arg0_50.poppingQueue:Enqueue(IslandPoppingQueue.MSGBOX, arg1_50)
end

function var0_0.PlayPerformance(arg0_51, arg1_51)
	arg0_51.poppingQueue:Enqueue(IslandPoppingQueue.PERFORMANCE, arg1_51)
end

function var0_0.DisplaySystemUnlock(arg0_52, arg1_52, arg2_52)
	if not arg1_52 or #arg1_52 <= 0 then
		arg2_52()

		return
	end

	local var0_52 = _.select(arg1_52, function(arg0_53)
		return pg.island_ability_template[arg0_53.id].show_pop == 1
	end)

	if #var0_52 <= 0 then
		arg2_52()

		return
	end

	local var1_52 = {}

	for iter0_52, iter1_52 in ipairs(var0_52) do
		table.insert(var1_52, function(arg0_54)
			arg0_52:GetSubView(IslandSystemUnlockPage):ExecuteAction("Show", iter1_52.id, function()
				onNextTick(arg0_54)
			end)
		end)
	end

	seriesAsync(var1_52, arg2_52)
end

function var0_0.HandleAwardDisplay(arg0_56, arg1_56, arg2_56, arg3_56)
	local var0_56 = {
		dropData = arg1_56,
		callback = arg2_56,
		displayType = arg3_56
	}

	arg0_56.poppingQueue:Enqueue(IslandPoppingQueue.DISPLAY_AWARD, var0_56)
end

function var0_0.ShowTaskAcceptPage(arg0_57, arg1_57)
	arg0_57.poppingQueue:Enqueue(IslandPoppingQueue.TASK_ACCEPT_PAGE, arg1_57)
end

function var0_0.ShowQueueUpMsgBox(arg0_58, arg1_58, arg2_58)
	arg0_58:GetSubView(IslandQueueUpMsgBox):ExecuteAction("Show", arg1_58, arg2_58)
end

function var0_0.AddListener(arg0_59, arg1_59, arg2_59)
	local function var0_59(arg0_60, ...)
		arg2_59(arg0_59, ...)
	end

	local var1_59 = arg0_59:bind(arg1_59, var0_59)

	arg0_59.__callbacks__[arg1_59] = var1_59

	arg0_59:GetIsland():AddListener(arg1_59, var0_59)
end

function var0_0.RemoveListener(arg0_61, arg1_61, arg2_61)
	local var0_61 = arg0_61.__callbacks__[arg1_61]

	if var0_61 then
		local var1_61 = arg0_61.eventStore[var0_61]

		arg0_61:GetIsland():RemoveListener(arg1_61, var1_61.callback)
		arg0_61:disconnect(var0_61)

		arg0_61.__callbacks__[arg1_61] = nil
	end
end

function var0_0.onBackPressed(arg0_62)
	local var0_62 = arg0_62:GetSubView(IslandTimelineMgr)

	if var0_62:GetLoaded() and var0_62:isShowing() then
		return
	end

	if arg0_62:GetSubView(IslandStoryMgr):onBackPressed() then
		return
	end

	for iter0_62, iter1_62 in ipairs(arg0_62.subViews) do
		if iter1_62:GetLoaded() and iter1_62:isShowing() then
			if isa(iter1_62, IslandMsgBox) then
				iter1_62:HideWindow()
			else
				iter1_62:Hide()
			end

			return
		end
	end

	if arg0_62.sceneMgr:OnBackPressed() then
		return
	end

	var0_0.super.onBackPressed(arg0_62)
end

function var0_0.RemoveCommonListeners(arg0_63)
	arg0_63:RemoveListener(ISLAND_EX_EVT.EMIT, arg0_63.OnEmit)
	arg0_63:RemoveListener(ISLAND_EX_EVT.INIT_FINISH, arg0_63.OnSceneLoaded)
	arg0_63:RemoveListener(ISLAND_EX_EVT.SHOW_MSG, arg0_63.OnShowMsgBox)
	arg0_63:RemoveListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_63.OnOpenPage)
	arg0_63:RemoveListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_63.OnPlayTimeline)
	arg0_63:RemoveListener(var0_0.LINK_CORE_EVENT, arg0_63.OnLinkCoreEvent)
	arg0_63:RemoveListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_63.OnOpenAnimatonOpPage)
	arg0_63:RemoveListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_63.OnCloseAnimatonOpPage)
end

function var0_0.exit(arg0_64)
	arg0_64:RemoveListeners()
	arg0_64:RemoveCommonListeners()

	for iter0_64, iter1_64 in ipairs(arg0_64.cacheAbList) do
		AssetBundleHelper.UnstoreAssetBundle(iter1_64, true)
	end

	for iter2_64, iter3_64 in ipairs(arg0_64.subViews) do
		if iter3_64:GetLoaded() then
			iter3_64:Destroy()
		end
	end

	for iter4_64, iter5_64 in ipairs(arg0_64.monitors) do
		iter5_64:Dispose()
	end

	arg0_64:GetIsland():ClearListeners()
	arg0_64.poolMgr:Dispose()
	arg0_64.poppingQueue:Dispose()
	arg0_64:disposeEvent()
	arg0_64.sceneMgr:Dispose()
	getProxy(IslandProxy):ClearAllPlayerDataCache()
	getProxy(IslandProxy):ClearAllGiftTagInfo()

	arg0_64.subViews = nil
	arg0_64.cacheAbList = nil
	arg0_64.poppingQueue = nil
	arg0_64.sceneMgr = nil
	arg0_64.poolMgr = nil
	arg0_64.monitors = nil
	arg0_64.uiContainer = nil
	arg0_64.opContainer = nil
	arg0_64.pageContainer = nil
	IslandSceneLoader.lastMapId = nil
	arg0_64.contextData = {}

	GraphicsInterface.Instance:ReleaseAsyncLoadedResources()
	var0_0.super.exit(arg0_64)
end

function var0_0.detach(arg0_65, arg1_65)
	var0_0.super.detach(arg0_65, arg1_65)

	if not IsNil(arg0_65._container) then
		Object.Destroy(arg0_65._container.gameObject)

		arg0_65._container = nil
	end
end

function var0_0.AddListeners(arg0_66)
	return
end

function var0_0.RemoveListeners(arg0_67)
	return
end

function var0_0.OnUnloadScene(arg0_68)
	return
end

return var0_0
