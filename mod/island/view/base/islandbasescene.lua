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

function var0_0.GCWhenAwake(arg0_4)
	return false
end

function var0_0.PlayBGM(arg0_5)
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.preload(arg0_6, arg1_6)
	local var0_6 = {}

	table.insert(var0_6, function(arg0_7)
		arg0_6:LoadUIContainer(arg0_7)
	end)
	table.insert(var0_6, function(arg0_8)
		arg0_6.poolMgr = IslandPoolMgr.New(arg0_6.poolContainer)

		arg0_6.poolMgr:Init(arg0_8)
	end)

	for iter0_6, iter1_6 in ipairs(arg0_6.cacheAbList) do
		table.insert(var0_6, function(arg0_9)
			AssetBundleHelper.StoreAssetBundle(iter1_6, true, false, function(arg0_10)
				arg0_9()
			end)
		end)
	end

	seriesAsync(var0_6, arg1_6)
end

function var0_0.LoadUIContainer(arg0_11, arg1_11)
	ResourceMgr.Inst:getAssetAsync("UI/UIIsland", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_12)
		IslandHelper.InstantiateAsyncGameObject(arg0_12, function(arg0_13)
			arg0_11._container = arg0_13.transform
			arg0_11.canvasGroup = GetOrAddComponent(arg0_11._container, typeof(CanvasGroup))
			arg0_11.uiLayer1 = arg0_11._container:Find("layer1")
			arg0_11.uiLayer2 = arg0_11._container:Find("layer2")
			arg0_11.uiContainer = arg0_11._container:Find("layer1/ui")
			arg0_11.opContainer = arg0_11._container:Find("layer1/op")
			arg0_11.pageContainer = arg0_11._container:Find("layer1/page")
			arg0_11.poolContainer = arg0_11._container:Find("_pool_")
			arg0_11._container.name = "UIIsland"

			setParent(arg0_11._container, pg.UIMgr.GetInstance().UICanvas)
			arg1_11()
		end)
	end), true, true)
end

function var0_0.SetUIParent(arg0_14, arg1_14)
	arg1_14.transform:SetParent(arg0_14.uiContainer, false)
end

function var0_0.emit(arg0_15, arg1_15, ...)
	if arg1_15 == BaseUI.ON_HOME or arg1_15 == IslandMediator.CHANGE_SCENE then
		if ISLAND_PLAYER_TESTING then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_home_btn_cant_use"))

			return
		end

		arg0_15:ExitProcess(arg1_15, nil, ...)
	else
		var0_0.super.emit(arg0_15, arg1_15, ...)
	end
end

function var0_0.emitCoreEvt(arg0_16, arg1_16, ...)
	arg0_16:emit(var0_0.LINK_CORE_EVENT, arg1_16, ...)
end

function var0_0.emitCore(arg0_17, arg1_17, ...)
	arg0_17:emit(var0_0.LINK_CORE_EVENT, IslandProxy.LINK_CORE, arg1_17, ...)
end

function var0_0.ExitProcess(arg0_18, arg1_18, arg2_18, ...)
	local var0_18 = packEx(...)
	local var1_18 = arg0_18:GetIsland()

	seriesAsync({
		function(arg0_19)
			arg0_18:emit(IslandBaseMediator.RECORD_PLAYER_POS)
			pg.m02:sendNotification(GAME.ISLAND_EXIT, {
				id = var1_18.id,
				callback = arg0_19
			})
		end
	}, function()
		var0_0.super.emit(arg0_18, arg1_18, unpackEx(var0_18))

		if arg2_18 then
			arg2_18()
		end
	end)
end

function var0_0.GetIsland(arg0_21)
	assert(false, "overwrite me !!!!")
end

function var0_0.onUILoaded(arg0_22, arg1_22)
	var0_0.super.onUILoaded(arg0_22, arg1_22)

	arg0_22.subViews = {
		IslandMsgBox.New(pg.UIMgr.GetInstance().OverlayMain, arg0_22.event),
		IslandToast.New(pg.UIMgr.GetInstance().OverlayToast, arg0_22.event),
		IslandStoryMgr.New(pg.UIMgr.GetInstance().OverlayToast, arg0_22.event),
		IslandAwardDisplayPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_22.event),
		IslandQueueUpMsgBox.New(pg.UIMgr.GetInstance().OverlayToast, arg0_22.event),
		IslandTimelineMgr.New(arg0_22:GetPoolMgr(), pg.UIMgr.GetInstance().OverlayToast, arg0_22.event),
		Island3dTaskAcceptPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_22.event),
		IslandSystemUnlockPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_22.event)
	}
	arg0_22.monitors = {
		IslandPlayerDataMonitor.New(arg0_22:GetIsland()),
		IslandSyncDataMonitor.New(arg0_22:GetIsland())
	}
	arg0_22.poppingQueue = IslandPoppingQueue.New(arg0_22)

	arg0_22:AddCommonListeners()
	arg0_22:AddListeners()
end

function var0_0.AddCommonListeners(arg0_23)
	arg0_23:AddListener(ISLAND_EX_EVT.EMIT, arg0_23.OnEmit)
	arg0_23:AddListener(ISLAND_EX_EVT.INIT_FINISH, arg0_23.OnSceneLoaded)
	arg0_23:AddListener(ISLAND_EX_EVT.SHOW_MSG, arg0_23.OnShowMsgBox)
	arg0_23:AddListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_23.OnOpenPage)
	arg0_23:AddListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_23.OnPlayTimeline)
	arg0_23:AddListener(var0_0.LINK_CORE_EVENT, arg0_23.OnLinkCoreEvent)
	arg0_23:AddListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_23.OnOpenAnimatonOpPage)
	arg0_23:AddListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_23.OnCloseAnimatonOpPage)
end

function var0_0.GetSubView(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.subViews) do
		if isa(iter1_24, arg1_24) then
			return iter1_24
		end
	end

	return nil
end

function var0_0.GetPoolMgr(arg0_25)
	return arg0_25.poolMgr
end

function var0_0.OnOpenAnimatonOpPage(arg0_26)
	return
end

function var0_0.OnCloseAnimatonOpPage(arg0_27)
	return
end

function var0_0.OnLinkCoreEvent(arg0_28, arg1_28, ...)
	arg0_28:GetIsland():DispatchEvent(arg1_28, ...)
end

function var0_0.OnSetUpCore(arg0_29, arg1_29, arg2_29)
	return
end

function var0_0.OnOpenPage(arg0_30, arg1_30, ...)
	arg0_30:OpenPage(arg1_30, ...)
end

function var0_0.OnShowMsgBox(arg0_31, arg1_31)
	arg0_31:ShowMsgbox(arg1_31)
end

function var0_0.OnPlayTimeline(arg0_32, arg1_32, arg2_32, arg3_32)
	arg0_32:PlayTimeline(arg1_32, arg2_32, arg3_32)
end

function var0_0.OnSceneLoaded(arg0_33)
	arg0_33:emit(var0_0.ON_SCENE_LOADED)
end

function var0_0.OnEmit(arg0_34, arg1_34, ...)
	arg0_34:emit(arg1_34, ...)
end

function var0_0.StartCore(arg0_35)
	arg0_35:emit(IslandBaseMediator.SET_UP)
end

function var0_0.setVisible(arg0_36, arg1_36)
	local var0_36 = GetOrAddComponent(arg0_36._tf, typeof(CanvasGroup))

	var0_36.alpha = arg1_36 and 1 or 0
	var0_36.blocksRaycasts = arg1_36

	if arg1_36 then
		arg0_36:OnVisible()
	else
		arg0_36:OnDisVisible()
	end
end

function var0_0.TryVisible(arg0_37)
	arg0_37.showBalance = arg0_37.showBalance + 1

	if arg0_37.showBalance == 1 then
		arg0_37:setVisible(true)
	end
end

function var0_0.TryDisVisible(arg0_38)
	arg0_38.showBalance = arg0_38.showBalance - 1

	if arg0_38.showBalance == 0 then
		arg0_38:setVisible(false)
	end
end

function var0_0.OpenPage(arg0_39, arg1_39, ...)
	IslandGuideChecker.CheckOnOpenPage(arg1_39.__cname)

	return arg0_39.sceneMgr:OpenPage(arg0_39, arg1_39, ...)
end

function var0_0.ClosePage(arg0_40, arg1_40)
	arg0_40.sceneMgr:ClosePage(arg1_40)
end

function var0_0.ShowToast(arg0_41, arg1_41)
	arg0_41:GetSubView(IslandToast):ExecuteAction("Show", arg1_41)
end

function var0_0.DisplayAward(arg0_42, arg1_42)
	arg0_42:GetSubView(IslandAwardDisplayPage):ExecuteAction("Show", arg1_42)
end

function var0_0.PlayTimeline(arg0_43, arg1_43, arg2_43, arg3_43)
	arg0_43:GetSubView(IslandTimelineMgr):ExecuteAction("Show", arg1_43, arg2_43, arg3_43)
end

function var0_0.PlayGetShipTimeline(arg0_44, arg1_44, arg2_44)
	arg0_44:PlayTimeline(2, {
		arg1_44
	}, arg2_44)
end

function var0_0.PlayStory(arg0_45, arg1_45)
	arg0_45.poppingQueue:Enqueue(IslandPoppingQueue.STORY, arg1_45)
end

function var0_0.ShowMsgbox(arg0_46, arg1_46)
	arg0_46.poppingQueue:Enqueue(IslandPoppingQueue.MSGBOX, arg1_46)
end

function var0_0.PlayPerformance(arg0_47, arg1_47)
	arg0_47.poppingQueue:Enqueue(IslandPoppingQueue.PERFORMANCE, arg1_47)
end

function var0_0.DisplaySystemUnlock(arg0_48, arg1_48, arg2_48)
	if not arg1_48 or #arg1_48 <= 0 then
		arg2_48()

		return
	end

	local var0_48 = _.select(arg1_48, function(arg0_49)
		return pg.island_ability_template[arg0_49.id].show_pop == 1
	end)

	if #var0_48 <= 0 then
		arg2_48()

		return
	end

	local var1_48 = {}

	for iter0_48, iter1_48 in ipairs(var0_48) do
		table.insert(var1_48, function(arg0_50)
			arg0_48:GetSubView(IslandSystemUnlockPage):ExecuteAction("Show", iter1_48.id, function()
				onNextTick(arg0_50)
			end)
		end)
	end

	seriesAsync(var1_48, arg2_48)
end

function var0_0.HandleAwardDisplay(arg0_52, arg1_52, arg2_52, arg3_52)
	local var0_52 = {
		dropData = arg1_52,
		callback = arg2_52,
		displayType = arg3_52
	}

	arg0_52.poppingQueue:Enqueue(IslandPoppingQueue.DISPLAY_AWARD, var0_52)
end

function var0_0.ShowTaskAcceptPage(arg0_53, arg1_53)
	arg0_53.poppingQueue:Enqueue(IslandPoppingQueue.TASK_ACCEPT_PAGE, arg1_53)
end

function var0_0.ShowQueueUpMsgBox(arg0_54, arg1_54, arg2_54)
	arg0_54:GetSubView(IslandQueueUpMsgBox):ExecuteAction("Show", arg1_54, arg2_54)
end

function var0_0.AddListener(arg0_55, arg1_55, arg2_55)
	local function var0_55(arg0_56, ...)
		arg2_55(arg0_55, ...)
	end

	local var1_55 = arg0_55:bind(arg1_55, var0_55)

	arg0_55.__callbacks__[arg1_55] = var1_55

	arg0_55:GetIsland():AddListener(arg1_55, var0_55)
end

function var0_0.RemoveListener(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg0_57.__callbacks__[arg1_57]

	if var0_57 then
		local var1_57 = arg0_57.eventStore[var0_57]

		arg0_57:GetIsland():RemoveListener(arg1_57, var1_57.callback)
		arg0_57:disconnect(var0_57)

		arg0_57.__callbacks__[arg1_57] = nil
	end
end

function var0_0.onBackPressed(arg0_58)
	local var0_58 = arg0_58:GetSubView(IslandTimelineMgr)

	if var0_58:GetLoaded() and var0_58:isShowing() then
		return
	end

	if arg0_58:GetSubView(IslandStoryMgr):onBackPressed() then
		return
	end

	for iter0_58, iter1_58 in ipairs(arg0_58.subViews) do
		if iter1_58:GetLoaded() and iter1_58:isShowing() then
			if isa(iter1_58, IslandMsgBox) then
				iter1_58:HideWindow()
			else
				iter1_58:Hide()
			end

			return
		end
	end

	if arg0_58.sceneMgr:OnBackPressed() then
		return
	end

	var0_0.super.onBackPressed(arg0_58)
end

function var0_0.RemoveCommonListeners(arg0_59)
	arg0_59:RemoveListener(ISLAND_EX_EVT.EMIT, arg0_59.OnEmit)
	arg0_59:RemoveListener(ISLAND_EX_EVT.INIT_FINISH, arg0_59.OnSceneLoaded)
	arg0_59:RemoveListener(ISLAND_EX_EVT.SHOW_MSG, arg0_59.OnShowMsgBox)
	arg0_59:RemoveListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_59.OnOpenPage)
	arg0_59:RemoveListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_59.OnPlayTimeline)
	arg0_59:RemoveListener(var0_0.LINK_CORE_EVENT, arg0_59.OnLinkCoreEvent)
	arg0_59:RemoveListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_59.OnOpenAnimatonOpPage)
	arg0_59:RemoveListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_59.OnCloseAnimatonOpPage)
end

function var0_0.exit(arg0_60)
	arg0_60:RemoveListeners()
	arg0_60:RemoveCommonListeners()

	for iter0_60, iter1_60 in ipairs(arg0_60.cacheAbList) do
		AssetBundleHelper.UnstoreAssetBundle(iter1_60, true)
	end

	for iter2_60, iter3_60 in ipairs(arg0_60.subViews) do
		if iter3_60:GetLoaded() then
			iter3_60:Destroy()
		end
	end

	for iter4_60, iter5_60 in ipairs(arg0_60.monitors) do
		iter5_60:Dispose()
	end

	arg0_60:GetIsland():ClearListeners()
	arg0_60.poolMgr:Dispose()
	arg0_60.poppingQueue:Dispose()
	arg0_60:disposeEvent()
	arg0_60.sceneMgr:Dispose()
	getProxy(IslandProxy):ClearAllPlayerDataCache()
	getProxy(IslandProxy):ClearAllGiftTagInfo()

	arg0_60.subViews = nil
	arg0_60.cacheAbList = nil
	arg0_60.poppingQueue = nil
	arg0_60.sceneMgr = nil
	arg0_60.poolMgr = nil
	arg0_60.monitors = nil
	arg0_60.uiContainer = nil
	arg0_60.opContainer = nil
	arg0_60.pageContainer = nil
	IslandSceneLoader.lastMapId = nil
	arg0_60.contextData = {}

	GraphicsInterface.Instance:ReleaseAsyncLoadedResources()
	var0_0.super.exit(arg0_60)
end

function var0_0.detach(arg0_61, arg1_61)
	var0_0.super.detach(arg0_61, arg1_61)

	if not IsNil(arg0_61._container) then
		Object.Destroy(arg0_61._container.gameObject)

		arg0_61._container = nil
	end
end

function var0_0.AddListeners(arg0_62)
	return
end

function var0_0.RemoveListeners(arg0_63)
	return
end

function var0_0.OnUnloadScene(arg0_64)
	return
end

return var0_0
