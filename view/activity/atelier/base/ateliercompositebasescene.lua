local var0_0 = class("AtelierCompositeBaseScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AtelierCompositeUI"
end

function var0_0.InitStr(arg0_2)
	arg0_2.bundleName = "ui/AtelierCompositeUI_atlas"
	arg0_2.commonBundleName = "ui/AtelierCommonUI_atlas"
	arg0_2.chatText = {
		idle = {
			"ryza_atellier1"
		},
		clickFormula = {
			"ryza_atellier2",
			"ryza_atellier3",
			"ryza_atellier4"
		},
		showMaterialSelectWindow = {
			"ryza_atellier2",
			"ryza_atellier3",
			"ryza_atellier4"
		},
		selectMaterial = {
			"ryza_atellier5",
			"ryza_atellier6",
			"ryza_atellier7"
		},
		compositeResult = {
			"ryza_atellier8",
			"ryza_atellier9"
		},
		compositeResult2 = {
			"ryza_atellier10",
			"ryza_atellier11"
		}
	}
	arg0_2.soundStr = {
		formulaDetailUnlock = "event:/ui/ryza_atellier_ui_3",
		showMaterialSelectWindow = "event:/ui/ryza_atellier_ui_1",
		compositeConfirm = "event:/ui/ryza_atellier_ui_6",
		selectMaterial = "event:/ui/ryza_atellier_ui_2",
		formulaDetail = "event:/ui/ryza_atellier_ui_5",
		clickFormula = "event:/ui/ryza_atellier_ui_1",
		formulaDetailFill = "event:/ui/ryza_atellier_ui_4"
	}
	arg0_2.helpStr = "ryza_composite_help_tip"
	arg0_2.tipStr = "ryza_composite_words"
	arg0_2.unlockText = "ryza_tip_composite_unlock"
end

function var0_0.InitView(arg0_3)
	arg0_3.atelierFormulaListView = AtelierFormulaListView.New(arg0_3.layerFormulaPanel, arg0_3)
	arg0_3.atelierFormulaDetailView = AtelierFormulaDetailView.New(arg0_3.layerFormulaDetailPanel, arg0_3)
	arg0_3.atelierMaterialSelectView = AtelierMaterialSelectView.New(arg0_3.materialSelectPanel, arg0_3)
	arg0_3.atelierMaterialsPreview = AtelierFormulaMaterialsPreview.New(arg0_3.materialsPreviewPanel, arg0_3)
	arg0_3.atelierCompositeConfirmView = AtelierCompositeConfirmView.New(arg0_3.compositeConfirmPanel, arg0_3)
	arg0_3.atelierCompositeResultView = AtelierCompositeResultView.New(arg0_3.compositeResultPanel, arg0_3)
end

function var0_0.OnClickStore(arg0_4)
	local var0_4 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(AtelierCompositeMediator)

	addSubLayer(Context.New({
		mediator = AtelierStoreBaseMediator,
		viewComponent = AtelierStoreBaseScene,
		data = {
			activity = arg0_4.activity
		}
	}), var0_4)
end

function var0_0.preload(arg0_5, arg1_5)
	arg0_5:InitStr()

	arg0_5.loader = AutoLoader.New()

	table.ParallelIpairsAsync({
		arg0_5.bundleName,
		arg0_5.commonBundleName
	}, function(arg0_6, arg1_6, arg2_6)
		arg0_5.loader:LoadBundle(arg1_6, arg2_6)
	end, arg1_5)
end

function var0_0.getResource(arg0_7)
	arg0_7:InitStr()

	local var0_7 = var0_0.super.getResource(arg0_7)
	local var1_7 = {
		arg0_7.bundleName,
		arg0_7.commonBundleName,
		"ui/laisha_ui_huo_o",
		"ui/laisha_ui_huo_6",
		"ui/laisha_ui_bing_o",
		"ui/laisha_ui_bing_6",
		"ui/laisha_ui_lei_o",
		"ui/laisha_ui_lei_6",
		"ui/laisha_ui_feng_o",
		"ui/laisha_ui_feng_6",
		"ui/laisha_ui_sairen_o",
		"ui/laisha_ui_sairen_6",
		"ui/laisha_ui_wupinshanguang",
		"ui/laisha_ui_jiesuo",
		"ui/laisha_ui_lianjie01",
		"ui/laisha_ui_lianjie02",
		"ui/laisha_ui_lianjie_qiehuan",
		"ui/laisha_ui_wupinzhiru",
		"ui/laisha_ui_baoshi",
		"ui/" .. arg0_7:GetAtelierCompositEffect()
	}

	for iter0_7, iter1_7 in ipairs(var1_7) do
		if noEmptyStr(iter1_7) and not table.contains(var0_7, iter1_7) then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.init(arg0_8)
	arg0_8.top = arg0_8._tf:Find("Top")
	arg0_8.layerFormulaPanel = arg0_8._tf:Find("FormulaList")
	arg0_8.layerFormulaOverlayPanel = arg0_8._tf:Find("FormulaDetail/Overlay")
	arg0_8.layerFormulaDetailPanel = arg0_8._tf:Find("FormulaDetail")
	arg0_8.scrollView = arg0_8._tf:Find("FormulaDetail/ScrollView")
	arg0_8.materialSelectPanel = arg0_8._tf:Find("FormulaDetail/Overlay/AvaliableMaterials")
	arg0_8.materialsPreviewPanel = arg0_8._tf:Find("FormulaMaterialsPreview")
	arg0_8.compositeConfirmPanel = arg0_8._tf:Find("CompositeConfirmWindow")
	arg0_8.compositeResultPanel = arg0_8._tf:Find("CompositeResultWindow")

	arg0_8:InitCustom()
	setActive(arg0_8.layerEmpty, false)
end

function var0_0.InitCustom(arg0_9)
	arg0_9.layerEmpty = arg0_9._tf:Find("Empty")

	setText(arg0_9._tf:Find("Empty/Bar/Text"), i18n(arg0_9.unlockText))

	arg0_9.painting = arg0_9._tf:Find("Painting")
	arg0_9.chat = arg0_9.painting:Find("Chat")

	setActive(arg0_9.chat, false)
	pg.ViewUtils.SetSortingOrder(arg0_9._tf:Find("Mask/BG"):GetChild(0), -1)
end

function var0_0.SetContextData(arg0_10, arg1_10)
	arg0_10.contextData = arg1_10

	arg0_10.atelierFormulaListView:SetContextData(arg1_10)
	arg0_10.atelierFormulaDetailView:SetContextData(arg1_10)
	arg0_10.atelierMaterialSelectView:SetContextData(arg1_10)
	arg0_10.atelierMaterialsPreview:SetContentData(arg1_10)
	arg0_10.atelierCompositeConfirmView:SetContentData(arg1_10)
	arg0_10.atelierCompositeResultView:SetContentData(arg1_10)
end

function var0_0.SetActivity(arg0_11, arg1_11)
	arg0_11.activity = arg1_11

	arg0_11.atelierFormulaListView:SetActivity(arg1_11)
	arg0_11.atelierFormulaDetailView:SetActivity(arg1_11)
	arg0_11.atelierMaterialSelectView:SetActivity(arg1_11)
	arg0_11.atelierMaterialsPreview:SetActivity(arg1_11)
	arg0_11.atelierCompositeConfirmView:SetActivity(arg1_11)
	arg0_11.atelierCompositeResultView:SetActivity(arg1_11)
end

function var0_0.SetEnabled(arg0_12, arg1_12)
	arg0_12.unlockSystem = arg1_12
end

function var0_0.didEnter(arg0_13)
	arg0_13:RefreshEmptyPanel()
	arg0_13.atelierFormulaListView:didEnter()
	arg0_13.atelierFormulaDetailView:didEnter()
	arg0_13.atelierMaterialSelectView:didEnter()
	arg0_13.atelierMaterialsPreview:didEnter()
	arg0_13.atelierCompositeConfirmView:didEnter()
	arg0_13.atelierCompositeResultView:didEnter()
	onButton(arg0_13, arg0_13._tf:Find("Top/TopBar/Back"), function()
		arg0_13:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13._tf:Find("Top/TopBar/Home"), function()
		arg0_13:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13._tf:Find("Top/TopBar/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n(arg0_13.helpStr)
		})
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13._tf:Find("Top/TopBar/StoreHouse"), function()
		arg0_13:OnClickStore()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_13.top)

	if arg0_13.unlockSystem then
		if arg0_13.contextData.formulaId then
			local var0_13 = arg0_13.activity:GetFormulas()[arg0_13.contextData.formulaId]

			arg0_13:ShowFormulaDetail(var0_13)
		else
			arg0_13:DispalyChat(arg0_13.chatText.idle)
			arg0_13:ShowFormulaList()
		end
	end

	arg0_13:PlayGuide()
end

function var0_0.PlayGuide(arg0_18)
	if arg0_18.unlockSystem and PlayerPrefs.GetInt(string.format("first_enter_ryza_atelier_%s_%s", getProxy(PlayerProxy):getRawData().id, arg0_18.activity.id), 0) == 0 then
		triggerButton(arg0_18._tf:Find("Top/TopBar/Help"))
		PlayerPrefs.SetInt(string.format("first_enter_ryza_atelier_%s_%s", getProxy(PlayerProxy):getRawData().id, arg0_18.activity.id), 1)
	end
end

function var0_0.willExit(arg0_19)
	arg0_19.loader:Clear()
	arg0_19:LoadingOff()
	arg0_19:HideChat()
	arg0_19:ClearSound()
	arg0_19.atelierMaterialsPreview:HideMaterialsPreview()
	arg0_19.atelierCompositeResultView:HideCompositeResult()
	arg0_19.atelierCompositeConfirmView:HideCompositeConfirmWindow()
	arg0_19.atelierMaterialSelectView:HideCandicatePanel()
	arg0_19:HideFormulaDetail()
	arg0_19:HideFormulaList()
	arg0_19.atelierFormulaListView:willExit()

	arg0_19.atelierFormulaListView = nil

	arg0_19.atelierFormulaDetailView:willExit()

	arg0_19.atelierFormulaDetailView = nil

	arg0_19.atelierMaterialSelectView:willExit()

	arg0_19.atelierMaterialSelectView = nil

	arg0_19.atelierMaterialsPreview:willExit()

	arg0_19.atelierMaterialsPreview = nil

	arg0_19.atelierCompositeConfirmView:willExit()

	arg0_19.atelierCompositeConfirmView = nil

	arg0_19.atelierCompositeResultView:willExit()

	arg0_19.atelierCompositeResultView = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19.top, arg0_19._tf)

	if arg0_19.nodePools then
		for iter0_19, iter1_19 in pairs(arg0_19.nodePools) do
			iter1_19:ClearItems()
		end
	end
end

function var0_0.UpdateRyzaDrop(arg0_20, arg1_20, arg2_20, arg3_20)
	updateDrop(arg1_20, arg2_20)
	SetCompomentEnabled(arg1_20:Find("icon_bg"), typeof(Image), false)
	setActive(arg1_20:Find("bg"), false)
	setActive(arg1_20:Find("icon_bg/frame"), false)
	setActive(arg1_20:Find("icon_bg/stars"), false)

	local var0_20 = arg2_20:getConfig("rarity")

	if arg2_20.type == DROP_TYPE_EQUIP or arg2_20.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0_20 = var0_20 - 1
	end

	local var1_20 = "icon_frame_" .. var0_20

	if arg3_20 then
		var1_20 = var1_20 .. "_small"
	end

	arg0_20.loader:GetSpriteQuiet(arg0_20.commonBundleName, var1_20, arg1_20)

	if arg2_20.type ~= DROP_TYPE_RYZA_DROP then
		onButton(arg0_20, arg1_20, function()
			arg0_20:emit(var0_0.ON_DROP, arg2_20)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_20)
	end
end

function var0_0.UpdateRyzaItem(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = "icon_frame_" .. arg2_22:GetRarity()

	if arg3_22 then
		var0_22 = var0_22 .. "_small"
	end

	arg0_22.loader:GetSpriteQuiet(arg0_22.commonBundleName, var0_22, arg1_22)
	arg0_22.loader:GetSpriteQuiet(arg2_22:GetIconPath(), "", arg1_22:Find("Icon"))

	if not IsNil(arg1_22:Find("Lv")) then
		setText(arg1_22:Find("Lv/Text"), arg2_22:GetLevel())
	end

	local var1_22 = arg2_22:GetProps()
	local var2_22 = CustomIndexLayer.Clone2Full(arg1_22:Find("List"), #var1_22)

	for iter0_22, iter1_22 in ipairs(var2_22) do
		arg0_22.loader:GetSpriteQuiet(arg0_22.commonBundleName, "element_" .. AtelierFormulaCircle.ELEMENT_NAME[var1_22[iter0_22]], iter1_22)
	end

	if not IsNil(arg1_22:Find("Text")) then
		setText(arg1_22:Find("Text"), arg2_22.count)
	end
end

function var0_0.OnClickFormula(arg0_23, arg1_23)
	arg0_23:HideFormulaList()
	arg0_23:ShowFormulaDetail(arg1_23)
	arg0_23:DispalyChat(arg0_23.chatText.clickFormula)
	arg0_23:PlaySoundEffect(arg0_23.soundStr.clickFormula)
end

function var0_0.OnClickFormulaBack(arg0_24)
	arg0_24:HideFormulaDetail()

	arg0_24.contextData.formulaId = nil

	arg0_24:ShowFormulaList()
end

function var0_0.ShowMaterialSelectWindow(arg0_25, arg1_25, arg2_25, arg3_25)
	arg0_25:DispalyChat(arg0_25.chatText.showMaterialSelectWindow)
	arg0_25:PlaySoundEffect(arg0_25.soundStr.showMaterialSelectWindow)
	arg0_25.atelierMaterialSelectView:ShowCandicatePanel(arg1_25, arg2_25, arg3_25)
end

function var0_0.ShowCompositeConfirmWindow(arg0_26, arg1_26)
	arg0_26.atelierCompositeConfirmView:ShowCompositeConfirmWindow(arg1_26)
end

function var0_0.OnSelectMaterial(arg0_27, arg1_27, arg2_27)
	arg0_27:DispalyChat(arg0_27.chatText.selectMaterial)
	arg0_27:PlaySoundEffect(arg0_27.soundStr.selectMaterial)
	arg0_27.atelierFormulaDetailView:FillNode(arg1_27, arg2_27)
end

function var0_0.RefreshEmptyPanel(arg0_28)
	setActive(arg0_28.layerEmpty, not arg0_28.unlockSystem)
	setActive(arg0_28.painting, arg0_28.unlockSystem)
end

function var0_0.ShowFormulaList(arg0_29)
	arg0_29:AddIdleTimer()
	arg0_29.atelierFormulaListView:ShowFormulaList()
end

function var0_0.HideFormulaList(arg0_30)
	if not arg0_30.layerFormulaPanel then
		return
	end

	arg0_30:RemoveIdleTimer()
	setParent(arg0_30.layerFormulaPanel, arg0_30._tf)
	setActive(arg0_30.layerFormulaPanel, false)

	return true
end

function var0_0.ShowFormulaDetail(arg0_31, arg1_31)
	arg0_31.contextData.formulaId = arg1_31:GetConfigID()

	arg0_31.atelierFormulaDetailView:Show(arg1_31)
	setParent(arg0_31.layerFormulaOverlayPanel, arg0_31.top)
	arg0_31.layerFormulaOverlayPanel:SetSiblingIndex(0)
	setParent(arg0_31.painting, arg0_31.layerFormulaOverlayPanel)
	setActive(arg0_31.materialSelectPanel, false)
end

function var0_0.HideFormulaDetail(arg0_32)
	if not isActive(arg0_32.layerFormulaDetailPanel) then
		return
	end

	arg0_32.atelierMaterialSelectView:HideCandicatePanel()
	setParent(arg0_32.painting, arg0_32._tf)
	arg0_32.painting:SetSiblingIndex(1)
	setParent(arg0_32.layerFormulaOverlayPanel, arg0_32.layerFormulaDetailPanel)
	setActive(arg0_32.layerFormulaDetailPanel, false)

	return true
end

function var0_0.ShowMaterialsPreview(arg0_33)
	arg0_33.atelierMaterialsPreview:ShowMaterialsPreview(arg0_33.atelierFormulaDetailView.nodeList)
end

function var0_0.DispalyChat(arg0_34, arg1_34)
	arg0_34:HideChat()
	setActive(arg0_34.chat, true)

	arg0_34.chatTween = LeanTween.delayedCall(go(arg0_34.chat), 4, System.Action(function()
		arg0_34:HideChat()
	end)).uniqueId

	local var0_34 = arg1_34[math.random(#arg1_34)]
	local var1_34 = pg.gametip[arg0_34.tipStr].tip
	local var2_34 = _.detect(var1_34, function(arg0_36)
		return arg0_36[1] == var0_34
	end)
	local var3_34 = var2_34 and var2_34[2]

	setText(arg0_34.chat:Find("Text"), var3_34)

	local var4_34 = arg0_34:GetSoundPath() .. var0_34

	arg0_34:PlaySound(var4_34)
end

function var0_0.GetSoundPath(arg0_37)
	local var0_37 = 1090001

	return "event:/cv/" .. var0_37 .. "/"
end

function var0_0.PlaySoundEffect(arg0_38, arg1_38)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_38)
end

function var0_0.ShowItemDetail(arg0_39, arg1_39)
	arg0_39:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, arg1_39)
end

function var0_0.LoadingOn(arg0_40)
	if arg0_40.animating then
		return
	end

	arg0_40.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0_0.LoadingOff(arg0_41)
	if not arg0_41.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0_41.animating = false
end

function var0_0.PlaySound(arg0_42, arg1_42, arg2_42)
	if not arg0_42.playbackInfo or arg1_42 ~= arg0_42.prevCvPath or arg0_42.playbackInfo.channelPlayer == nil then
		arg0_42:StopSound()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_42, function(arg0_43)
			if arg0_43 then
				arg0_42.playbackInfo = arg0_43

				arg0_42.playbackInfo:SetIgnoreAutoUnload(true)

				if arg2_42 then
					arg2_42(arg0_42.playbackInfo.cueInfo)
				end
			elseif arg2_42 then
				arg2_42()
			end
		end)

		arg0_42.prevCvPath = arg1_42

		if arg0_42.playbackInfo == nil then
			return nil
		end

		return arg0_42.playbackInfo.cueInfo
	elseif arg0_42.playbackInfo then
		arg0_42.playbackInfo:PlaybackStop()
		arg0_42.playbackInfo:SetStartTimeAndPlay()

		if arg2_42 then
			arg2_42(arg0_42.playbackInfo.cueInfo)
		end

		return arg0_42.playbackInfo.cueInfo
	elseif arg2_42 then
		arg2_42()
	end

	return nil
end

function var0_0.StopSound(arg0_44)
	if arg0_44.playbackInfo then
		pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0_44.playbackInfo)
		arg0_44.playbackInfo:SetIgnoreAutoUnload(false)
	end
end

function var0_0.ClearSound(arg0_45)
	arg0_45:StopSound()

	if arg0_45.playbackInfo then
		arg0_45.playbackInfo:Dispose()

		arg0_45.playbackInfo = nil
	end
end

function var0_0.HideChat(arg0_46)
	if arg0_46.chatTween then
		LeanTween.cancel(arg0_46.chatTween)

		arg0_46.chatTween = nil
	end

	setActive(arg0_46.chat, false)
end

function var0_0.AddIdleTimer(arg0_47)
	arg0_47:RemoveIdleTimer()

	arg0_47.idleTimer = Timer.New(function()
		arg0_47:DispalyChat(arg0_47.chatText.idle)
		arg0_47:AddIdleTimer()
	end, 8 + math.random() * 4)

	arg0_47.idleTimer:Start()
end

function var0_0.RemoveIdleTimer(arg0_49)
	if not arg0_49.idleTimer then
		return
	end

	arg0_49.idleTimer:Stop()

	arg0_49.idleTimer = nil
end

function var0_0.GetAtelierCompositEffect(arg0_50)
	return "laisha_lianjin"
end

function var0_0.GetAtelierCompositEffectPos(arg0_51)
	return Vector2.zero
end

function var0_0.OnCompositeResult(arg0_52, arg1_52)
	arg0_52:LoadingOn()
	arg0_52:DispalyChat(arg0_52.chatText.compositeResult)

	local var0_52 = 1.5
	local var1_52 = 0.5

	arg0_52.loader:GetPrefab("ui/" .. arg0_52:GetAtelierCompositEffect(), "", function(arg0_53)
		pg.UIMgr.GetInstance():OverlayPanel(tf(arg0_53))
		setAnchoredPosition(arg0_53, arg0_52:GetAtelierCompositEffectPos())
		arg0_52:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_52._tf, typeof(CanvasGroup)), 0, var0_52):setFrom(1)
		arg0_52:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_52.top, typeof(CanvasGroup)), 0, var0_52):setFrom(1)
		arg0_52:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_52.compositeConfirmPanel, typeof(CanvasGroup)), 0, var0_52):setFrom(1)
		arg0_52:managedTween(LeanTween.delayedCall, function()
			arg0_52.atelierCompositeConfirmView:HideCompositeConfirmWindow()
			setCanvasGroupAlpha(arg0_52.compositeConfirmPanel, 1)
			arg0_52:CleanNodeInstance()
			arg0_52.atelierCompositeResultView:ShowCompositeResult(arg1_52)
			arg0_52:DispalyChat(arg0_52.chatText.compositeResult2)
			arg0_52:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_52._tf, typeof(CanvasGroup)), 1, var1_52):setFrom(0)
			arg0_52:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_52.top, typeof(CanvasGroup)), 1, var1_52):setFrom(0)
			arg0_52:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0_52.compositeResultPanel, typeof(CanvasGroup)), 1, var1_52):setFrom(0)
			arg0_52:managedTween(LeanTween.delayedCall, function()
				arg0_52:LoadingOff()
				pg.UIMgr.GetInstance():UnOverlayPanel(tf(arg0_53), arg0_52._tf)
				arg0_52.loader:ClearRequest("CompositeResult")
			end, go(arg0_52.compositeResultPanel), var1_52, nil)
		end, go(arg0_52.compositeResultPanel), var0_52, nil)
	end, "CompositeResult")
end

function var0_0.OnReceiveFormualRequest(arg0_56, arg1_56)
	arg0_56.atelierMaterialSelectView:HideCandicatePanel()
	arg0_56.atelierCompositeConfirmView:HideCompositeConfirmWindow()
	arg0_56.atelierCompositeResultView:HideCompositeResult()
	arg0_56.atelierMaterialsPreview:HideMaterialsPreview()
	arg0_56:HideFormulaList()

	local var0_56 = arg0_56.activity:GetFormulas()[arg1_56]

	arg0_56:ShowFormulaDetail(var0_56)
end

function var0_0.CleanNodeInstance(arg0_57)
	local var0_57 = arg0_57.activity:GetFormulas()[arg0_57.contextData.formulaId]

	if not var0_57:IsAvaliable() then
		arg0_57:HideFormulaDetail()

		arg0_57.contextData.formulaId = nil

		arg0_57:ShowFormulaList()

		return
	end

	_.each(arg0_57.atelierFormulaDetailView.nodeList, function(arg0_58)
		arg0_58.Instance = nil
		arg0_58.Change = true
	end)
	arg0_57:ShowFormulaDetail(var0_57)
end

function var0_0.onBackPressed(arg0_59)
	if arg0_59.animating then
		return true
	end

	if arg0_59.atelierMaterialsPreview:HideMaterialsPreview() then
		return true
	end

	if arg0_59.atelierCompositeResultView:HideCompositeResult() then
		return true
	end

	if arg0_59.atelierCompositeConfirmView:HideCompositeConfirmWindow() then
		return true
	end

	if arg0_59.atelierMaterialSelectView:HideCandicatePanel() then
		return true
	end

	if arg0_59:HideFormulaDetail() then
		arg0_59.contextData.formulaId = nil

		arg0_59:ShowFormulaList()

		return true
	end

	arg0_59:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
