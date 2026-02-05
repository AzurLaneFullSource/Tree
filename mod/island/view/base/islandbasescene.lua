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

function var0_0.LoadUIContainer(arg0_12, arg1_12)
	ResourceMgr.Inst:getAssetAsync("UI/UIIsland", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_13)
		IslandHelper.InstantiateAsyncGameObject(arg0_13, function(arg0_14)
			arg0_12._container = arg0_14.transform
			arg0_12.canvasGroup = GetOrAddComponent(arg0_12._container, typeof(CanvasGroup))
			arg0_12.uiLayer1 = arg0_12._container:Find("layer1")
			arg0_12.uiLayer2 = arg0_12._container:Find("layer2")
			arg0_12.uiContainer = arg0_12._container:Find("layer1/ui")
			arg0_12.opContainer = arg0_12._container:Find("layer1/op")
			arg0_12.pageContainer = arg0_12._container:Find("layer1/page")
			arg0_12.poolContainer = arg0_12._container:Find("_pool_")
			arg0_12._container.name = "UIIsland"

			setParent(arg0_12._container, pg.UIMgr.GetInstance().UICanvas)
			arg1_12()
		end)
	end), true, true)
end

function var0_0.SetUIParent(arg0_15, arg1_15)
	arg1_15.transform:SetParent(arg0_15.uiContainer, false)
end

function var0_0.emit(arg0_16, arg1_16, ...)
	if arg1_16 == BaseUI.ON_HOME or arg1_16 == IslandMediator.CHANGE_SCENE then
		if ISLAND_PLAYER_TESTING then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_home_btn_cant_use"))

			return
		end

		arg0_16:ExitProcess(arg1_16, nil, ...)
	else
		var0_0.super.emit(arg0_16, arg1_16, ...)
	end
end

function var0_0.emitCoreController(arg0_17, arg1_17, ...)
	arg0_17:emit(var0_0.LINK_CORE_EVENT, arg1_17, ...)
end

function var0_0.emitCore(arg0_18, arg1_18, ...)
	arg0_18:emit(var0_0.LINK_CORE_EVENT, IslandProxy.LINK_CORE, arg1_18, ...)
end

function var0_0.ExitProcess(arg0_19, arg1_19, arg2_19, ...)
	local var0_19 = packEx(...)
	local var1_19 = arg0_19:GetIsland()

	seriesAsync({
		function(arg0_20)
			arg0_19:emit(IslandBaseMediator.RECORD_PLAYER_POS)
			pg.m02:sendNotification(GAME.ISLAND_EXIT, {
				id = var1_19.id,
				callback = arg0_20
			})
		end
	}, function()
		var0_0.super.emit(arg0_19, arg1_19, unpackEx(var0_19))

		if arg2_19 then
			arg2_19()
		end
	end)
end

function var0_0.GetIsland(arg0_22)
	assert(false, "overwrite me !!!!")
end

function var0_0.onUILoaded(arg0_23, arg1_23)
	var0_0.super.onUILoaded(arg0_23, arg1_23)

	arg0_23.subViews = {
		IslandMsgBox.New(pg.UIMgr.GetInstance().OverlayMain, arg0_23.event),
		IslandToast.New(pg.UIMgr.GetInstance().OverlayToast, arg0_23.event),
		IslandStoryMgr.New(pg.UIMgr.GetInstance().OverlayToast, arg0_23.event),
		IslandAwardDisplayPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_23.event),
		IslandQueueUpMsgBox.New(pg.UIMgr.GetInstance().OverlayToast, arg0_23.event),
		IslandTimelineMgr.New(arg0_23:GetPoolMgr(), pg.UIMgr.GetInstance().OverlayToast, arg0_23.event),
		Island3dTaskAcceptPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_23.event),
		IslandSystemUnlockPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_23.event)
	}
	arg0_23.monitors = {
		IslandPlayerDataMonitor.New(arg0_23:GetIsland()),
		IslandSyncDataMonitor.New(arg0_23:GetIsland())
	}
	arg0_23.poppingQueue = IslandPoppingQueue.New(arg0_23)

	arg0_23:AddCommonListeners()
	arg0_23:AddListeners()

	for iter0_23, iter1_23 in pairs(arg0_23.subViews) do
		iter1_23:RegisterView(arg0_23)
	end
end

function var0_0.AddCommonListeners(arg0_24)
	arg0_24:AddListener(ISLAND_EX_EVT.EMIT, arg0_24.OnEmit)
	arg0_24:AddListener(ISLAND_EX_EVT.INIT_FINISH, arg0_24.OnSceneLoaded)
	arg0_24:AddListener(ISLAND_EX_EVT.SHOW_MSG, arg0_24.OnShowMsgBox)
	arg0_24:AddListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_24.OnOpenPage)
	arg0_24:AddListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_24.OnPlayTimeline)
	arg0_24:AddListener(var0_0.LINK_CORE_EVENT, arg0_24.OnLinkCoreEvent)
	arg0_24:AddListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_24.OnOpenAnimatonOpPage)
	arg0_24:AddListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_24.OnCloseAnimatonOpPage)
end

function var0_0.GetSubView(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.subViews) do
		if isa(iter1_25, arg1_25) then
			return iter1_25
		end
	end

	return nil
end

function var0_0.GetPoolMgr(arg0_26)
	return arg0_26.poolMgr
end

function var0_0.OnOpenAnimatonOpPage(arg0_27)
	return
end

function var0_0.OnCloseAnimatonOpPage(arg0_28)
	return
end

function var0_0.OnLinkCoreEvent(arg0_29, arg1_29, ...)
	arg0_29:GetIsland():DispatchEvent(arg1_29, ...)
end

function var0_0.OnSetUpCore(arg0_30, arg1_30, arg2_30)
	return
end

function var0_0.OnOpenPage(arg0_31, arg1_31, ...)
	arg0_31:OpenPage(arg1_31, ...)
end

function var0_0.OnShowMsgBox(arg0_32, arg1_32)
	arg0_32:ShowMsgbox(arg1_32)
end

function var0_0.OnPlayTimeline(arg0_33, arg1_33, arg2_33, arg3_33)
	arg0_33:PlayTimeline(arg1_33, arg2_33, arg3_33)
end

function var0_0.OnSceneLoaded(arg0_34)
	arg0_34:emit(var0_0.ON_SCENE_LOADED)
end

function var0_0.OnEmit(arg0_35, arg1_35, ...)
	arg0_35:emit(arg1_35, ...)
end

function var0_0.StartCore(arg0_36)
	arg0_36:emit(IslandBaseMediator.SET_UP)
end

function var0_0.setVisible(arg0_37, arg1_37)
	local var0_37 = GetOrAddComponent(arg0_37._tf, typeof(CanvasGroup))

	var0_37.alpha = arg1_37 and 1 or 0
	var0_37.blocksRaycasts = arg1_37

	if arg1_37 then
		arg0_37:OnVisible()
	else
		arg0_37:OnDisVisible()
	end
end

function var0_0.TryVisible(arg0_38)
	arg0_38.showBalance = arg0_38.showBalance + 1

	if arg0_38.showBalance == 1 then
		arg0_38:setVisible(true)
	end
end

function var0_0.TryDisVisible(arg0_39)
	arg0_39.showBalance = arg0_39.showBalance - 1

	if arg0_39.showBalance == 0 then
		arg0_39:setVisible(false)
	end
end

function var0_0.OpenPage(arg0_40, arg1_40, ...)
	IslandGuideChecker.CheckOnOpenPage(arg1_40.__cname)

	return arg0_40.sceneMgr:OpenPage(arg0_40, arg1_40, ...)
end

function var0_0.ClosePage(arg0_41, arg1_41)
	arg0_41.sceneMgr:ClosePage(arg1_41)
end

function var0_0.ShowToast(arg0_42, arg1_42)
	arg0_42:GetSubView(IslandToast):ExecuteAction("Show", arg1_42)
end

function var0_0.DisplayAward(arg0_43, arg1_43)
	arg0_43:GetSubView(IslandAwardDisplayPage):ExecuteAction("Show", arg1_43)
end

function var0_0.PlayTimeline(arg0_44, arg1_44, arg2_44, arg3_44)
	arg0_44:GetSubView(IslandTimelineMgr):ExecuteAction("Show", arg1_44, arg2_44, arg3_44)
end

function var0_0.PlayGetShipTimeline(arg0_45, arg1_45, arg2_45)
	arg0_45:PlayTimeline(2, {
		arg1_45
	}, arg2_45)
end

function var0_0.PlayStory(arg0_46, arg1_46)
	arg0_46.poppingQueue:Enqueue(IslandPoppingQueue.STORY, arg1_46)
end

function var0_0.ShowMsgbox(arg0_47, arg1_47)
	arg0_47.poppingQueue:Enqueue(IslandPoppingQueue.MSGBOX, arg1_47)
end

function var0_0.PlayPerformance(arg0_48, arg1_48)
	arg0_48.poppingQueue:Enqueue(IslandPoppingQueue.PERFORMANCE, arg1_48)
end

function var0_0.DisplaySystemUnlock(arg0_49, arg1_49, arg2_49)
	if not arg1_49 or #arg1_49 <= 0 then
		arg2_49()

		return
	end

	local var0_49 = _.select(arg1_49, function(arg0_50)
		return pg.island_ability_template[arg0_50.id].show_pop == 1
	end)

	if #var0_49 <= 0 then
		arg2_49()

		return
	end

	local var1_49 = {}

	for iter0_49, iter1_49 in ipairs(var0_49) do
		table.insert(var1_49, function(arg0_51)
			arg0_49:GetSubView(IslandSystemUnlockPage):ExecuteAction("Show", iter1_49.id, function()
				onNextTick(arg0_51)
			end)
		end)
	end

	seriesAsync(var1_49, arg2_49)
end

function var0_0.HandleAwardDisplay(arg0_53, arg1_53, arg2_53, arg3_53)
	local var0_53 = {
		dropData = arg1_53,
		callback = arg2_53,
		displayType = arg3_53
	}

	arg0_53.poppingQueue:Enqueue(IslandPoppingQueue.DISPLAY_AWARD, var0_53)
end

function var0_0.ShowTaskAcceptPage(arg0_54, arg1_54)
	arg0_54.poppingQueue:Enqueue(IslandPoppingQueue.TASK_ACCEPT_PAGE, arg1_54)
end

function var0_0.ShowQueueUpMsgBox(arg0_55, arg1_55, arg2_55)
	arg0_55:GetSubView(IslandQueueUpMsgBox):ExecuteAction("Show", arg1_55, arg2_55)
end

function var0_0.AddListener(arg0_56, arg1_56, arg2_56)
	local function var0_56(arg0_57, ...)
		arg2_56(arg0_56, ...)
	end

	local var1_56 = arg0_56:bind(arg1_56, var0_56)

	arg0_56.__callbacks__[arg1_56] = var1_56

	arg0_56:GetIsland():AddListener(arg1_56, var0_56)
end

function var0_0.RemoveListener(arg0_58, arg1_58, arg2_58)
	local var0_58 = arg0_58.__callbacks__[arg1_58]

	if var0_58 then
		local var1_58 = arg0_58.eventStore[var0_58]

		arg0_58:GetIsland():RemoveListener(arg1_58, var1_58.callback)
		arg0_58:disconnect(var0_58)

		arg0_58.__callbacks__[arg1_58] = nil
	end
end

function var0_0.onBackPressed(arg0_59)
	local var0_59 = arg0_59:GetSubView(IslandTimelineMgr)

	if var0_59:GetLoaded() and var0_59:isShowing() then
		return
	end

	if arg0_59:GetSubView(IslandStoryMgr):onBackPressed() then
		return
	end

	for iter0_59, iter1_59 in ipairs(arg0_59.subViews) do
		if iter1_59:GetLoaded() and iter1_59:isShowing() then
			if isa(iter1_59, IslandMsgBox) then
				iter1_59:HideWindow()
			else
				iter1_59:Hide()
			end

			return
		end
	end

	if arg0_59.sceneMgr:OnBackPressed() then
		return
	end

	var0_0.super.onBackPressed(arg0_59)
end

function var0_0.RemoveCommonListeners(arg0_60)
	arg0_60:RemoveListener(ISLAND_EX_EVT.EMIT, arg0_60.OnEmit)
	arg0_60:RemoveListener(ISLAND_EX_EVT.INIT_FINISH, arg0_60.OnSceneLoaded)
	arg0_60:RemoveListener(ISLAND_EX_EVT.SHOW_MSG, arg0_60.OnShowMsgBox)
	arg0_60:RemoveListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_60.OnOpenPage)
	arg0_60:RemoveListener(ISLAND_EX_EVT.PLAY_TIMELINE, arg0_60.OnPlayTimeline)
	arg0_60:RemoveListener(var0_0.LINK_CORE_EVENT, arg0_60.OnLinkCoreEvent)
	arg0_60:RemoveListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_60.OnOpenAnimatonOpPage)
	arg0_60:RemoveListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_60.OnCloseAnimatonOpPage)
end

function var0_0.exit(arg0_61)
	arg0_61:RemoveListeners()
	arg0_61:RemoveCommonListeners()

	for iter0_61, iter1_61 in ipairs(arg0_61.cacheAbList) do
		AssetBundleHelper.UnstoreAssetBundle(iter1_61, true)
	end

	for iter2_61, iter3_61 in ipairs(arg0_61.subViews) do
		if iter3_61:GetLoaded() then
			iter3_61:Destroy()
		end
	end

	for iter4_61, iter5_61 in ipairs(arg0_61.monitors) do
		iter5_61:Dispose()
	end

	arg0_61:GetIsland():ClearListeners()
	arg0_61.poolMgr:Dispose()
	arg0_61.poppingQueue:Dispose()
	arg0_61:disposeEvent()
	arg0_61.sceneMgr:Dispose()
	getProxy(IslandProxy):ClearAllPlayerDataCache()
	getProxy(IslandProxy):ClearAllGiftTagInfo()

	arg0_61.subViews = nil
	arg0_61.cacheAbList = nil
	arg0_61.poppingQueue = nil
	arg0_61.sceneMgr = nil
	arg0_61.poolMgr = nil
	arg0_61.monitors = nil
	arg0_61.uiContainer = nil
	arg0_61.opContainer = nil
	arg0_61.pageContainer = nil
	IslandSceneLoader.lastMapId = nil
	arg0_61.contextData = {}

	GraphicsInterface.Instance:ReleaseAsyncLoadedResources()
	var0_0.super.exit(arg0_61)
end

function var0_0.detach(arg0_62, arg1_62)
	var0_0.super.detach(arg0_62, arg1_62)

	if not IsNil(arg0_62._container) then
		Object.Destroy(arg0_62._container.gameObject)

		arg0_62._container = nil
	end
end

function var0_0.AddListeners(arg0_63)
	return
end

function var0_0.RemoveListeners(arg0_64)
	return
end

function var0_0.OnUnloadScene(arg0_65)
	return
end

return var0_0
