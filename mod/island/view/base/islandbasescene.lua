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

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = {}

	table.insert(var0_2, function(arg0_3)
		arg0_2:LoadUIContainer(arg0_3)
	end)
	table.insert(var0_2, function(arg0_4)
		arg0_2.poolMgr = IslandPoolMgr.New(arg0_2.poolContainer)

		arg0_2.poolMgr:Init(arg0_4)
	end)

	for iter0_2, iter1_2 in ipairs(arg0_2.cacheAbList) do
		table.insert(var0_2, function(arg0_5)
			AssetBundleHelper.StoreAssetBundle(iter1_2, true, false, function(arg0_6)
				arg0_5()
			end)
		end)
	end

	seriesAsync(var0_2, arg1_2)
end

function var0_0.LoadUIContainer(arg0_7, arg1_7)
	ResourceMgr.Inst:getAssetAsync("UI/UIIsland", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_8)
		arg0_7._container = Object.Instantiate(arg0_8).transform
		arg0_7.uiContainer = arg0_7._container:Find("ui")
		arg0_7.opContainer = arg0_7._container:Find("op")
		arg0_7.pageContainer = arg0_7._container:Find("page")
		arg0_7.poolContainer = arg0_7._container:Find("_pool_")
		arg0_7._container.name = "UIIsland"

		setParent(arg0_7._container, pg.UIMgr.GetInstance().UICanvas)
		arg1_7()
	end), true, true)
end

function var0_0.SetUIParent(arg0_9, arg1_9)
	arg1_9.transform:SetParent(arg0_9.uiContainer, false)
end

function var0_0.emit(arg0_10, ...)
	if unpack({
		...
	}) == BaseUI.ON_HOME then
		if ISLAND_PLAYER_TESTING then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_home_btn_cant_use"))

			return
		end

		arg0_10:ExitIsland()
	else
		var0_0.super.emit(arg0_10, ...)
	end
end

function var0_0.emitCoreEvt(arg0_11, arg1_11, ...)
	arg0_11:emit(var0_0.LINK_CORE_EVENT, arg1_11, ...)
end

function var0_0.emitCore(arg0_12, arg1_12, ...)
	arg0_12:emit(var0_0.LINK_CORE_EVENT, IslandProxy.LINK_CORE, arg1_12, ...)
end

function var0_0.ExitIsland(arg0_13)
	local var0_13 = arg0_13:GetIsland()

	seriesAsync({
		function(arg0_14)
			arg0_13:emit(IslandBaseMediator.RECORD_PLAYER_POS)
			pg.m02:sendNotification(GAME.ISLAND_EXIT, {
				id = var0_13.id,
				callback = arg0_14
			})
		end
	}, function()
		var0_0.super.emit(arg0_13, BaseUI.ON_HOME)
	end)
end

function var0_0.GetIsland(arg0_16)
	assert(false, "overwrite me !!!!")
end

function var0_0.onUILoaded(arg0_17, arg1_17)
	var0_0.super.onUILoaded(arg0_17, arg1_17)

	arg0_17.canvasGroup = GetOrAddComponent(arg0_17._tf, typeof(CanvasGroup))
	arg0_17.canvasGroup.alpha = 0
	arg0_17.canvasGroup.blocksRaycasts = false
	arg0_17.subViews = {
		IslandMsgBox.New(pg.UIMgr.GetInstance().OverlayMain, arg0_17.event),
		IslandToast.New(pg.UIMgr.GetInstance().OverlayToast, arg0_17.event),
		IslandStoryMgr.New(pg.UIMgr.GetInstance().OverlayToast, arg0_17.event),
		IslandAwardDisplayPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_17.event),
		IslandQueueUpMsgBox.New(pg.UIMgr.GetInstance().OverlayToast, arg0_17.event),
		IslandTimelineMgr.New(arg0_17:GetPoolMgr(), pg.UIMgr.GetInstance().OverlayToast, arg0_17.event),
		Island3dTaskAcceptPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_17.event)
	}
	arg0_17.monitors = {
		IslandPlayerDataMonitor.New(arg0_17:GetIsland()),
		IslandSyncDataMonitor.New(arg0_17:GetIsland())
	}
	arg0_17.poppingQueue = IslandPoppingQueue.New(arg0_17)

	arg0_17:AddListeners()
	arg0_17:AddListener(ISLAND_EX_EVT.EMIT, arg0_17.OnEmit)
	arg0_17:AddListener(ISLAND_EX_EVT.INIT_FINISH, arg0_17.OnSceneLoaded)
	arg0_17:AddListener(ISLAND_EX_EVT.SHOW_MSG, arg0_17.OnShowMsgBox)
	arg0_17:AddListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_17.OnOpenPage)
	arg0_17:AddListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_17.OnPlayTimeline)
	arg0_17:AddListener(var0_0.LINK_CORE_EVENT, arg0_17.OnLinkCoreEvent)
end

function var0_0.GetSubView(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.subViews) do
		if isa(iter1_18, arg1_18) then
			return iter1_18
		end
	end

	return nil
end

function var0_0.GetPoolMgr(arg0_19)
	return arg0_19.poolMgr
end

function var0_0.OnLinkCoreEvent(arg0_20, arg1_20, ...)
	arg0_20:GetIsland():DispatchEvent(arg1_20, ...)
end

function var0_0.OnSetUpCore(arg0_21, arg1_21, arg2_21)
	return
end

function var0_0.OnOpenPage(arg0_22, arg1_22, ...)
	arg0_22:OpenPage(arg1_22, ...)
end

function var0_0.OnShowMsgBox(arg0_23, arg1_23)
	arg0_23:ShowMsgbox(arg1_23)
end

function var0_0.OnPlayTimeline(arg0_24, arg1_24, arg2_24, arg3_24)
	arg0_24:PlayTimeline(arg1_24, arg2_24, arg3_24)
end

function var0_0.OnSceneLoaded(arg0_25)
	arg0_25:emit(var0_0.ON_SCENE_LOADED)

	arg0_25.canvasGroup.alpha = 1
	arg0_25.canvasGroup.blocksRaycasts = true
end

function var0_0.OnEmit(arg0_26, arg1_26, ...)
	arg0_26:emit(arg1_26, ...)
end

function var0_0.StartCore(arg0_27)
	arg0_27:emit(IslandBaseMediator.SET_UP)
end

function var0_0.setVisible(arg0_28, arg1_28)
	arg0_28:ShowOrHideResUI(arg1_28)

	if arg1_28 then
		arg0_28:OnVisible()
	else
		arg0_28:OnDisVisible()
	end

	setActive(arg0_28._tf, arg1_28)
end

function var0_0.TryVisible(arg0_29)
	arg0_29.showBalance = arg0_29.showBalance + 1

	if arg0_29.showBalance == 1 then
		arg0_29:setVisible(true)
	end
end

function var0_0.TryDisVisible(arg0_30)
	arg0_30.showBalance = arg0_30.showBalance - 1

	if arg0_30.showBalance == 0 then
		arg0_30:setVisible(false)
	end
end

function var0_0.OpenPage(arg0_31, arg1_31, ...)
	IslandGuideChecker.CheckOnOpenPage(arg1_31.__cname)

	return arg0_31.sceneMgr:OpenPage(arg0_31, arg1_31, ...)
end

function var0_0.ClosePage(arg0_32, arg1_32)
	arg0_32.sceneMgr:ClosePage(arg1_32)
end

function var0_0.ShowToast(arg0_33, arg1_33)
	arg0_33:GetSubView(IslandToast):ExecuteAction("Show", arg1_33)
end

function var0_0.DisplayAward(arg0_34, arg1_34)
	arg0_34:GetSubView(IslandAwardDisplayPage):ExecuteAction("Show", arg1_34)
end

function var0_0.PlayTimeline(arg0_35, arg1_35, arg2_35, arg3_35)
	arg0_35:GetSubView(IslandTimelineMgr):ExecuteAction("Show", arg1_35, arg2_35, arg3_35)
end

function var0_0.PlayGetShipTimeline(arg0_36, arg1_36, arg2_36)
	arg0_36:PlayTimeline(2, {
		arg1_36
	}, arg2_36)
end

function var0_0.PlayStory(arg0_37, arg1_37)
	arg0_37.poppingQueue:Enqueue(IslandPoppingQueue.STORY, arg1_37)
end

function var0_0.ShowMsgbox(arg0_38, arg1_38)
	arg0_38.poppingQueue:Enqueue(IslandPoppingQueue.MSGBOX, arg1_38)
end

function var0_0.PlayPerformance(arg0_39, arg1_39)
	arg0_39.poppingQueue:Enqueue(IslandPoppingQueue.PERFORMANCE, arg1_39)
end

function var0_0.HandleAwardDisplay(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = {
		dropData = arg1_40,
		callback = arg2_40,
		displayType = arg3_40
	}

	arg0_40.poppingQueue:Enqueue(IslandPoppingQueue.DISPLAY_AWARD, var0_40)
end

function var0_0.ShowTaskAcceptPage(arg0_41, arg1_41)
	arg0_41.poppingQueue:Enqueue(IslandPoppingQueue.TASK_ACCEPT_PAGE, arg1_41)
end

function var0_0.ShowQueueUpMsgBox(arg0_42, arg1_42, arg2_42)
	arg0_42:GetSubView(IslandQueueUpMsgBox):ExecuteAction("Show", arg1_42, arg2_42)
end

function var0_0.AddListener(arg0_43, arg1_43, arg2_43)
	local function var0_43(arg0_44, ...)
		arg2_43(arg0_43, ...)
	end

	local var1_43 = arg0_43:bind(arg1_43, var0_43)

	arg0_43.__callbacks__[arg1_43] = var1_43

	arg0_43:GetIsland():AddListener(arg1_43, var0_43)
end

function var0_0.RemoveListener(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg0_45.__callbacks__[arg1_45]

	if var0_45 then
		local var1_45 = arg0_45.eventStore[var0_45]

		arg0_45:GetIsland():RemoveListener(arg1_45, var1_45.callback)
		arg0_45:disconnect(var0_45)

		arg0_45.__callbacks__[arg1_45] = nil
	end
end

function var0_0.onBackPressed(arg0_46)
	local var0_46 = arg0_46:GetSubView(IslandTimelineMgr)

	if var0_46:GetLoaded() and var0_46:isShowing() then
		return
	end

	if arg0_46:GetSubView(IslandStoryMgr):onBackPressed() then
		return
	end

	for iter0_46, iter1_46 in ipairs(arg0_46.subViews) do
		if iter1_46:GetLoaded() and iter1_46:isShowing() then
			iter1_46:Hide()

			return
		end
	end

	if arg0_46.sceneMgr:OnBackPressed() then
		return
	end

	var0_0.super.onBackPressed(arg0_46)
end

function var0_0.exit(arg0_47)
	arg0_47:RemoveListeners()
	arg0_47:RemoveListener(ISLAND_EX_EVT.EMIT, arg0_47.OnEmit)
	arg0_47:RemoveListener(ISLAND_EX_EVT.INIT_FINISH, arg0_47.OnSceneLoaded)
	arg0_47:RemoveListener(ISLAND_EX_EVT.SHOW_MSG, arg0_47.OnShowMsgBox)
	arg0_47:RemoveListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_47.OnOpenPage)
	arg0_47:RemoveListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_47.OnPlayTimeline)
	arg0_47:RemoveListener(var0_0.LINK_CORE_EVENT, arg0_47.OnLinkCoreEvent)

	for iter0_47, iter1_47 in ipairs(arg0_47.cacheAbList) do
		AssetBundleHelper.UnstoreAssetBundle(iter1_47, true)
	end

	arg0_47.cacheAbList = nil

	for iter2_47, iter3_47 in ipairs(arg0_47.subViews) do
		if iter3_47:GetLoaded() then
			iter3_47:Destroy()
		end
	end

	arg0_47.subViews = nil

	for iter4_47, iter5_47 in ipairs(arg0_47.monitors) do
		iter5_47:Dispose()
	end

	arg0_47.monitors = nil

	arg0_47:GetIsland():ClearListeners()

	if not IsNil(arg0_47._container) then
		Object.Destroy(arg0_47._container.gameObject)
	end

	arg0_47._container = nil
	arg0_47.uiContainer = nil
	arg0_47.opContainer = nil
	arg0_47.pageContainer = nil

	arg0_47.poolMgr:Dispose()

	arg0_47.poolMgr = nil

	arg0_47.poppingQueue:Dispose()

	arg0_47.poppingQueue = nil

	arg0_47:disposeEvent()
	arg0_47.sceneMgr:Dispose()

	arg0_47.sceneMgr = nil

	getProxy(IslandProxy):ClearAllPlayerDataCache()
	getProxy(IslandProxy):ClearAllGiftTagInfo()
	var0_0.super.exit(arg0_47)
	gcAll(false)
end

function var0_0.AddListeners(arg0_48)
	return
end

function var0_0.RemoveListeners(arg0_49)
	return
end

function var0_0.OnUnloadScene(arg0_50)
	return
end

return var0_0
