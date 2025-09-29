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

function var0_0.forceGC(arg0_3)
	return true
end

function var0_0.PlayBGM(arg0_4)
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.preload(arg0_5, arg1_5)
	local var0_5 = {}

	table.insert(var0_5, function(arg0_6)
		arg0_5:LoadUIContainer(arg0_6)
	end)
	table.insert(var0_5, function(arg0_7)
		arg0_5.poolMgr = IslandPoolMgr.New(arg0_5.poolContainer)

		arg0_5.poolMgr:Init(arg0_7)
	end)

	for iter0_5, iter1_5 in ipairs(arg0_5.cacheAbList) do
		table.insert(var0_5, function(arg0_8)
			AssetBundleHelper.StoreAssetBundle(iter1_5, true, false, function(arg0_9)
				arg0_8()
			end)
		end)
	end

	seriesAsync(var0_5, arg1_5)
end

function var0_0.LoadUIContainer(arg0_10, arg1_10)
	ResourceMgr.Inst:getAssetAsync("UI/UIIsland", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_11)
		IslandHelper.InstantiateAsyncGameObject(arg0_11, function(arg0_12)
			arg0_10._container = arg0_12.transform
			arg0_10.canvasGroup = GetOrAddComponent(arg0_10._container, typeof(CanvasGroup))
			arg0_10.uiLayer1 = arg0_10._container:Find("layer1")
			arg0_10.uiLayer2 = arg0_10._container:Find("layer2")
			arg0_10.uiContainer = arg0_10._container:Find("layer1/ui")
			arg0_10.opContainer = arg0_10._container:Find("layer1/op")
			arg0_10.pageContainer = arg0_10._container:Find("layer1/page")
			arg0_10.poolContainer = arg0_10._container:Find("_pool_")
			arg0_10._container.name = "UIIsland"

			setParent(arg0_10._container, pg.UIMgr.GetInstance().UICanvas)
			arg1_10()
		end)
	end), true, true)
end

function var0_0.SetUIParent(arg0_13, arg1_13)
	arg1_13.transform:SetParent(arg0_13.uiContainer, false)
end

function var0_0.emit(arg0_14, arg1_14, ...)
	if arg1_14 == BaseUI.ON_HOME or arg1_14 == IslandMediator.CHANGE_SCENE then
		if ISLAND_PLAYER_TESTING then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_home_btn_cant_use"))

			return
		end

		arg0_14:ExitProcess(arg1_14, nil, ...)
	else
		var0_0.super.emit(arg0_14, arg1_14, ...)
	end
end

function var0_0.emitCoreEvt(arg0_15, arg1_15, ...)
	arg0_15:emit(var0_0.LINK_CORE_EVENT, arg1_15, ...)
end

function var0_0.emitCore(arg0_16, arg1_16, ...)
	arg0_16:emit(var0_0.LINK_CORE_EVENT, IslandProxy.LINK_CORE, arg1_16, ...)
end

function var0_0.ExitProcess(arg0_17, arg1_17, arg2_17, ...)
	local var0_17 = packEx(...)
	local var1_17 = arg0_17:GetIsland()

	seriesAsync({
		function(arg0_18)
			arg0_17:emit(IslandBaseMediator.RECORD_PLAYER_POS)
			pg.m02:sendNotification(GAME.ISLAND_EXIT, {
				id = var1_17.id,
				callback = arg0_18
			})
		end
	}, function()
		var0_0.super.emit(arg0_17, arg1_17, unpackEx(var0_17))

		if arg2_17 then
			arg2_17()
		end
	end)
end

function var0_0.GetIsland(arg0_20)
	assert(false, "overwrite me !!!!")
end

function var0_0.onUILoaded(arg0_21, arg1_21)
	var0_0.super.onUILoaded(arg0_21, arg1_21)

	arg0_21.subViews = {
		IslandMsgBox.New(pg.UIMgr.GetInstance().OverlayMain, arg0_21.event),
		IslandToast.New(pg.UIMgr.GetInstance().OverlayToast, arg0_21.event),
		IslandStoryMgr.New(pg.UIMgr.GetInstance().OverlayToast, arg0_21.event),
		IslandAwardDisplayPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_21.event),
		IslandQueueUpMsgBox.New(pg.UIMgr.GetInstance().OverlayToast, arg0_21.event),
		IslandTimelineMgr.New(arg0_21:GetPoolMgr(), pg.UIMgr.GetInstance().OverlayToast, arg0_21.event),
		Island3dTaskAcceptPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_21.event)
	}
	arg0_21.monitors = {
		IslandPlayerDataMonitor.New(arg0_21:GetIsland()),
		IslandSyncDataMonitor.New(arg0_21:GetIsland())
	}
	arg0_21.poppingQueue = IslandPoppingQueue.New(arg0_21)

	arg0_21:AddCommonListeners()
	arg0_21:AddListeners()
end

function var0_0.AddCommonListeners(arg0_22)
	arg0_22:AddListener(ISLAND_EX_EVT.EMIT, arg0_22.OnEmit)
	arg0_22:AddListener(ISLAND_EX_EVT.INIT_FINISH, arg0_22.OnSceneLoaded)
	arg0_22:AddListener(ISLAND_EX_EVT.SHOW_MSG, arg0_22.OnShowMsgBox)
	arg0_22:AddListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_22.OnOpenPage)
	arg0_22:AddListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_22.OnPlayTimeline)
	arg0_22:AddListener(var0_0.LINK_CORE_EVENT, arg0_22.OnLinkCoreEvent)
	arg0_22:AddListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_22.OnOpenAnimatonOpPage)
	arg0_22:AddListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_22.OnCloseAnimatonOpPage)
end

function var0_0.GetSubView(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.subViews) do
		if isa(iter1_23, arg1_23) then
			return iter1_23
		end
	end

	return nil
end

function var0_0.GetPoolMgr(arg0_24)
	return arg0_24.poolMgr
end

function var0_0.OnOpenAnimatonOpPage(arg0_25)
	return
end

function var0_0.OnCloseAnimatonOpPage(arg0_26)
	return
end

function var0_0.OnLinkCoreEvent(arg0_27, arg1_27, ...)
	arg0_27:GetIsland():DispatchEvent(arg1_27, ...)
end

function var0_0.OnSetUpCore(arg0_28, arg1_28, arg2_28)
	return
end

function var0_0.OnOpenPage(arg0_29, arg1_29, ...)
	arg0_29:OpenPage(arg1_29, ...)
end

function var0_0.OnShowMsgBox(arg0_30, arg1_30)
	arg0_30:ShowMsgbox(arg1_30)
end

function var0_0.OnPlayTimeline(arg0_31, arg1_31, arg2_31, arg3_31)
	arg0_31:PlayTimeline(arg1_31, arg2_31, arg3_31)
end

function var0_0.OnSceneLoaded(arg0_32)
	arg0_32:emit(var0_0.ON_SCENE_LOADED)
end

function var0_0.OnEmit(arg0_33, arg1_33, ...)
	arg0_33:emit(arg1_33, ...)
end

function var0_0.StartCore(arg0_34)
	arg0_34:emit(IslandBaseMediator.SET_UP)
end

function var0_0.setVisible(arg0_35, arg1_35)
	local var0_35 = GetOrAddComponent(arg0_35._tf, typeof(CanvasGroup))

	var0_35.alpha = arg1_35 and 1 or 0
	var0_35.blocksRaycasts = arg1_35

	if arg1_35 then
		arg0_35:OnVisible()
	else
		arg0_35:OnDisVisible()
	end
end

function var0_0.TryVisible(arg0_36)
	arg0_36.showBalance = arg0_36.showBalance + 1

	if arg0_36.showBalance == 1 then
		arg0_36:setVisible(true)
	end
end

function var0_0.TryDisVisible(arg0_37)
	arg0_37.showBalance = arg0_37.showBalance - 1

	if arg0_37.showBalance == 0 then
		arg0_37:setVisible(false)
	end
end

function var0_0.OpenPage(arg0_38, arg1_38, ...)
	IslandGuideChecker.CheckOnOpenPage(arg1_38.__cname)

	return arg0_38.sceneMgr:OpenPage(arg0_38, arg1_38, ...)
end

function var0_0.ClosePage(arg0_39, arg1_39)
	arg0_39.sceneMgr:ClosePage(arg1_39)
end

function var0_0.ShowToast(arg0_40, arg1_40)
	arg0_40:GetSubView(IslandToast):ExecuteAction("Show", arg1_40)
end

function var0_0.DisplayAward(arg0_41, arg1_41)
	arg0_41:GetSubView(IslandAwardDisplayPage):ExecuteAction("Show", arg1_41)
end

function var0_0.PlayTimeline(arg0_42, arg1_42, arg2_42, arg3_42)
	arg0_42:GetSubView(IslandTimelineMgr):ExecuteAction("Show", arg1_42, arg2_42, arg3_42)
end

function var0_0.PlayGetShipTimeline(arg0_43, arg1_43, arg2_43)
	arg0_43:PlayTimeline(2, {
		arg1_43
	}, arg2_43)
end

function var0_0.PlayStory(arg0_44, arg1_44)
	arg0_44.poppingQueue:Enqueue(IslandPoppingQueue.STORY, arg1_44)
end

function var0_0.ShowMsgbox(arg0_45, arg1_45)
	arg0_45.poppingQueue:Enqueue(IslandPoppingQueue.MSGBOX, arg1_45)
end

function var0_0.PlayPerformance(arg0_46, arg1_46)
	arg0_46.poppingQueue:Enqueue(IslandPoppingQueue.PERFORMANCE, arg1_46)
end

function var0_0.HandleAwardDisplay(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47 = {
		dropData = arg1_47,
		callback = arg2_47,
		displayType = arg3_47
	}

	arg0_47.poppingQueue:Enqueue(IslandPoppingQueue.DISPLAY_AWARD, var0_47)
end

function var0_0.ShowTaskAcceptPage(arg0_48, arg1_48)
	arg0_48.poppingQueue:Enqueue(IslandPoppingQueue.TASK_ACCEPT_PAGE, arg1_48)
end

function var0_0.ShowQueueUpMsgBox(arg0_49, arg1_49, arg2_49)
	arg0_49:GetSubView(IslandQueueUpMsgBox):ExecuteAction("Show", arg1_49, arg2_49)
end

function var0_0.AddListener(arg0_50, arg1_50, arg2_50)
	local function var0_50(arg0_51, ...)
		arg2_50(arg0_50, ...)
	end

	local var1_50 = arg0_50:bind(arg1_50, var0_50)

	arg0_50.__callbacks__[arg1_50] = var1_50

	arg0_50:GetIsland():AddListener(arg1_50, var0_50)
end

function var0_0.RemoveListener(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg0_52.__callbacks__[arg1_52]

	if var0_52 then
		local var1_52 = arg0_52.eventStore[var0_52]

		arg0_52:GetIsland():RemoveListener(arg1_52, var1_52.callback)
		arg0_52:disconnect(var0_52)

		arg0_52.__callbacks__[arg1_52] = nil
	end
end

function var0_0.onBackPressed(arg0_53)
	local var0_53 = arg0_53:GetSubView(IslandTimelineMgr)

	if var0_53:GetLoaded() and var0_53:isShowing() then
		return
	end

	if arg0_53:GetSubView(IslandStoryMgr):onBackPressed() then
		return
	end

	for iter0_53, iter1_53 in ipairs(arg0_53.subViews) do
		if iter1_53:GetLoaded() and iter1_53:isShowing() then
			if isa(iter1_53, IslandMsgBox) then
				iter1_53:HideWindow()
			else
				iter1_53:Hide()
			end

			return
		end
	end

	if arg0_53.sceneMgr:OnBackPressed() then
		return
	end

	var0_0.super.onBackPressed(arg0_53)
end

function var0_0.RemoveCommonListeners(arg0_54)
	arg0_54:RemoveListener(ISLAND_EX_EVT.EMIT, arg0_54.OnEmit)
	arg0_54:RemoveListener(ISLAND_EX_EVT.INIT_FINISH, arg0_54.OnSceneLoaded)
	arg0_54:RemoveListener(ISLAND_EX_EVT.SHOW_MSG, arg0_54.OnShowMsgBox)
	arg0_54:RemoveListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_54.OnOpenPage)
	arg0_54:RemoveListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_54.OnPlayTimeline)
	arg0_54:RemoveListener(var0_0.LINK_CORE_EVENT, arg0_54.OnLinkCoreEvent)
	arg0_54:RemoveListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_54.OnOpenAnimatonOpPage)
	arg0_54:RemoveListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_54.OnCloseAnimatonOpPage)
end

function var0_0.exit(arg0_55)
	arg0_55:RemoveListeners()
	arg0_55:RemoveCommonListeners()

	for iter0_55, iter1_55 in ipairs(arg0_55.cacheAbList) do
		AssetBundleHelper.UnstoreAssetBundle(iter1_55, true)
	end

	for iter2_55, iter3_55 in ipairs(arg0_55.subViews) do
		if iter3_55:GetLoaded() then
			iter3_55:Destroy()
		end
	end

	for iter4_55, iter5_55 in ipairs(arg0_55.monitors) do
		iter5_55:Dispose()
	end

	arg0_55:GetIsland():ClearListeners()
	arg0_55.poolMgr:Dispose()
	arg0_55.poppingQueue:Dispose()
	arg0_55:disposeEvent()
	arg0_55.sceneMgr:Dispose()
	getProxy(IslandProxy):ClearAllPlayerDataCache()
	getProxy(IslandProxy):ClearAllGiftTagInfo()

	arg0_55.subViews = nil
	arg0_55.cacheAbList = nil
	arg0_55.poppingQueue = nil
	arg0_55.sceneMgr = nil
	arg0_55.poolMgr = nil
	arg0_55.monitors = nil
	arg0_55.uiContainer = nil
	arg0_55.opContainer = nil
	arg0_55.pageContainer = nil
	IslandSceneLoader.lastMapId = nil
	arg0_55.contextData = {}

	GraphicsInterface.Instance:ReleaseAsyncLoadedResources()
	var0_0.super.exit(arg0_55)
end

function var0_0.detach(arg0_56, arg1_56)
	var0_0.super.detach(arg0_56, arg1_56)

	if not IsNil(arg0_56._container) then
		Object.Destroy(arg0_56._container.gameObject)

		arg0_56._container = nil
	end
end

function var0_0.AddListeners(arg0_57)
	return
end

function var0_0.RemoveListeners(arg0_58)
	return
end

function var0_0.OnUnloadScene(arg0_59)
	return
end

return var0_0
