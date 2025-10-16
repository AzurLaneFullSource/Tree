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

function var0_0.init(arg0_7)
	arg0_7.top = arg0_7._tf:Find("Top")
	arg0_7.layerFormulaPanel = arg0_7._tf:Find("FormulaList")
	arg0_7.layerFormulaOverlayPanel = arg0_7._tf:Find("FormulaDetail/Overlay")
	arg0_7.layerFormulaDetailPanel = arg0_7._tf:Find("FormulaDetail")
	arg0_7.scrollView = arg0_7._tf:Find("FormulaDetail/ScrollView")
	arg0_7.materialSelectPanel = arg0_7._tf:Find("FormulaDetail/Overlay/AvaliableMaterials")
	arg0_7.materialsPreviewPanel = arg0_7._tf:Find("FormulaMaterialsPreview")
	arg0_7.compositeConfirmPanel = arg0_7._tf:Find("CompositeConfirmWindow")
	arg0_7.compositeResultPanel = arg0_7._tf:Find("CompositeResultWindow")

	arg0_7:InitCustom()
	setActive(arg0_7.layerEmpty, false)
end

function var0_0.InitCustom(arg0_8)
	arg0_8.layerEmpty = arg0_8._tf:Find("Empty")

	setText(arg0_8._tf:Find("Empty/Bar/Text"), i18n(arg0_8.unlockText))

	arg0_8.painting = arg0_8._tf:Find("Painting")
	arg0_8.chat = arg0_8.painting:Find("Chat")

	setActive(arg0_8.chat, false)
	pg.ViewUtils.SetSortingOrder(arg0_8._tf:Find("Mask/BG"):GetChild(0), -1)
end

function var0_0.SetContextData(arg0_9, arg1_9)
	arg0_9.contextData = arg1_9

	arg0_9.atelierFormulaListView:SetContextData(arg1_9)
	arg0_9.atelierFormulaDetailView:SetContextData(arg1_9)
	arg0_9.atelierMaterialSelectView:SetContextData(arg1_9)
	arg0_9.atelierMaterialsPreview:SetContentData(arg1_9)
	arg0_9.atelierCompositeConfirmView:SetContentData(arg1_9)
	arg0_9.atelierCompositeResultView:SetContentData(arg1_9)
end

function var0_0.SetActivity(arg0_10, arg1_10)
	arg0_10.activity = arg1_10

	arg0_10.atelierFormulaListView:SetActivity(arg1_10)
	arg0_10.atelierFormulaDetailView:SetActivity(arg1_10)
	arg0_10.atelierMaterialSelectView:SetActivity(arg1_10)
	arg0_10.atelierMaterialsPreview:SetActivity(arg1_10)
	arg0_10.atelierCompositeConfirmView:SetActivity(arg1_10)
	arg0_10.atelierCompositeResultView:SetActivity(arg1_10)
end

function var0_0.SetEnabled(arg0_11, arg1_11)
	arg0_11.unlockSystem = arg1_11
end

function var0_0.didEnter(arg0_12)
	arg0_12:RefreshEmptyPanel()
	arg0_12.atelierFormulaListView:didEnter()
	arg0_12.atelierFormulaDetailView:didEnter()
	arg0_12.atelierMaterialSelectView:didEnter()
	arg0_12.atelierMaterialsPreview:didEnter()
	arg0_12.atelierCompositeConfirmView:didEnter()
	arg0_12.atelierCompositeResultView:didEnter()
	onButton(arg0_12, arg0_12._tf:Find("Top/TopBar/Back"), function()
		arg0_12:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12._tf:Find("Top/TopBar/Home"), function()
		arg0_12:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12._tf:Find("Top/TopBar/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n(arg0_12.helpStr)
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12._tf:Find("Top/TopBar/StoreHouse"), function()
		arg0_12:OnClickStore()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_12.top)

	if arg0_12.unlockSystem then
		if arg0_12.contextData.formulaId then
			local var0_12 = arg0_12.activity:GetFormulas()[arg0_12.contextData.formulaId]

			arg0_12:ShowFormulaDetail(var0_12)
		else
			arg0_12:DispalyChat(arg0_12.chatText.idle)
			arg0_12:ShowFormulaList()
		end
	end

	arg0_12:PlayGuide()
end

function var0_0.PlayGuide(arg0_17)
	if arg0_17.unlockSystem and PlayerPrefs.GetInt(string.format("first_enter_ryza_atelier_%s_%s", getProxy(PlayerProxy):getRawData().id, arg0_17.activity.id), 0) == 0 then
		triggerButton(arg0_17._tf:Find("Top/TopBar/Help"))
		PlayerPrefs.SetInt(string.format("first_enter_ryza_atelier_%s_%s", getProxy(PlayerProxy):getRawData().id, arg0_17.activity.id), 1)
	end
end

function var0_0.willExit(arg0_18)
	arg0_18.loader:Clear()
	arg0_18:LoadingOff()
	arg0_18:HideChat()
	arg0_18:ClearSound()
	arg0_18.atelierMaterialsPreview:HideMaterialsPreview()
	arg0_18.atelierCompositeResultView:HideCompositeResult()
	arg0_18.atelierCompositeConfirmView:HideCompositeConfirmWindow()
	arg0_18.atelierMaterialSelectView:HideCandicatePanel()
	arg0_18:HideFormulaDetail()
	arg0_18:HideFormulaList()
	arg0_18.atelierFormulaListView:willExit()

	arg0_18.atelierFormulaListView = nil

	arg0_18.atelierFormulaDetailView:willExit()

	arg0_18.atelierFormulaDetailView = nil

	arg0_18.atelierMaterialSelectView:willExit()

	arg0_18.atelierMaterialSelectView = nil

	arg0_18.atelierMaterialsPreview:willExit()

	arg0_18.atelierMaterialsPreview = nil

	arg0_18.atelierCompositeConfirmView:willExit()

	arg0_18.atelierCompositeConfirmView = nil

	arg0_18.atelierCompositeResultView:willExit()

	arg0_18.atelierCompositeResultView = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_18.top, arg0_18._tf)

	if arg0_18.nodePools then
		for iter0_18, iter1_18 in pairs(arg0_18.nodePools) do
			iter1_18:ClearItems()
		end
	end
end

function var0_0.UpdateRyzaDrop(arg0_19, arg1_19, arg2_19, arg3_19)
	updateDrop(arg1_19, arg2_19)
	SetCompomentEnabled(arg1_19:Find("icon_bg"), typeof(Image), false)
	setActive(arg1_19:Find("bg"), false)
	setActive(arg1_19:Find("icon_bg/frame"), false)
	setActive(arg1_19:Find("icon_bg/stars"), false)

	local var0_19 = arg2_19:getConfig("rarity")

	if arg2_19.type == DROP_TYPE_EQUIP or arg2_19.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0_19 = var0_19 - 1
	end

	local var1_19 = "icon_frame_" .. var0_19

	if arg3_19 then
		var1_19 = var1_19 .. "_small"
	end

	arg0_19.loader:GetSpriteQuiet(arg0_19.commonBundleName, var1_19, arg1_19)

	if arg2_19.type ~= DROP_TYPE_RYZA_DROP then
		onButton(arg0_19, arg1_19, function()
			arg0_19:emit(var0_0.ON_DROP, arg2_19)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_19)
	end
end

function var0_0.UpdateRyzaItem(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = "icon_frame_" .. arg2_21:GetRarity()

	if arg3_21 then
		var0_21 = var0_21 .. "_small"
	end

	arg0_21.loader:GetSpriteQuiet(arg0_21.commonBundleName, var0_21, arg1_21)
	arg0_21.loader:GetSpriteQuiet(arg2_21:GetIconPath(), "", arg1_21:Find("Icon"))

	if not IsNil(arg1_21:Find("Lv")) then
		setText(arg1_21:Find("Lv/Text"), arg2_21:GetLevel())
	end

	local var1_21 = arg2_21:GetProps()
	local var2_21 = CustomIndexLayer.Clone2Full(arg1_21:Find("List"), #var1_21)

	for iter0_21, iter1_21 in ipairs(var2_21) do
		arg0_21.loader:GetSpriteQuiet(arg0_21.commonBundleName, "element_" .. AtelierFormulaCircle.ELEMENT_NAME[var1_21[iter0_21]], iter1_21)
	end

	if not IsNil(arg1_21:Find("Text")) then
		setText(arg1_21:Find("Text"), arg2_21.count)
	end
end

function var0_0.OnClickFormula(arg0_22, arg1_22)
	arg0_22:HideFormulaList()
	arg0_22:ShowFormulaDetail(arg1_22)
	arg0_22:DispalyChat(arg0_22.chatText.clickFormula)
	arg0_22:PlaySoundEffect(arg0_22.soundStr.clickFormula)
end

function var0_0.OnClickFormulaBack(arg0_23)
	arg0_23:HideFormulaDetail()

	arg0_23.contextData.formulaId = nil

	arg0_23:ShowFormulaList()
end

function var0_0.ShowMaterialSelectWindow(arg0_24, arg1_24, arg2_24, arg3_24)
	arg0_24:DispalyChat(arg0_24.chatText.showMaterialSelectWindow)
	arg0_24:PlaySoundEffect(arg0_24.soundStr.showMaterialSelectWindow)
	arg0_24.atelierMaterialSelectView:ShowCandicatePanel(arg1_24, arg2_24, arg3_24)
end

function var0_0.ShowCompositeConfirmWindow(arg0_25, arg1_25)
	arg0_25.atelierCompositeConfirmView:ShowCompositeConfirmWindow(arg1_25)
end

function var0_0.OnSelectMaterial(arg0_26, arg1_26, arg2_26)
	arg0_26:DispalyChat(arg0_26.chatText.selectMaterial)
	arg0_26:PlaySoundEffect(arg0_26.soundStr.selectMaterial)
	arg0_26.atelierFormulaDetailView:FillNode(arg1_26, arg2_26)
end

function var0_0.RefreshEmptyPanel(arg0_27)
	setActive(arg0_27.layerEmpty, not arg0_27.unlockSystem)
	setActive(arg0_27.painting, arg0_27.unlockSystem)
end

function var0_0.ShowFormulaList(arg0_28)
	arg0_28:AddIdleTimer()
	arg0_28.atelierFormulaListView:ShowFormulaList()
end

function var0_0.HideFormulaList(arg0_29)
	if not arg0_29.layerFormulaPanel then
		return
	end

	arg0_29:RemoveIdleTimer()
	setParent(arg0_29.layerFormulaPanel, arg0_29._tf)
	setActive(arg0_29.layerFormulaPanel, false)

	return true
end

function var0_0.ShowFormulaDetail(arg0_30, arg1_30)
	arg0_30.contextData.formulaId = arg1_30:GetConfigID()

	arg0_30.atelierFormulaDetailView:Show(arg1_30)
	setParent(arg0_30.layerFormulaOverlayPanel, arg0_30.top)
	arg0_30.layerFormulaOverlayPanel:SetSiblingIndex(0)
	setParent(arg0_30.painting, arg0_30.layerFormulaOverlayPanel)
	setActive(arg0_30.materialSelectPanel, false)
end

function var0_0.HideFormulaDetail(arg0_31)
	if not isActive(arg0_31.layerFormulaDetailPanel) then
		return
	end

	arg0_31.atelierMaterialSelectView:HideCandicatePanel()
	setParent(arg0_31.painting, arg0_31._tf)
	arg0_31.painting:SetSiblingIndex(1)
	setParent(arg0_31.layerFormulaOverlayPanel, arg0_31.layerFormulaDetailPanel)
	setActive(arg0_31.layerFormulaDetailPanel, false)

	return true
end

function var0_0.ShowMaterialsPreview(arg0_32)
	arg0_32.atelierMaterialsPreview:ShowMaterialsPreview(arg0_32.atelierFormulaDetailView.nodeList)
end

function var0_0.DispalyChat(arg0_33, arg1_33)
	arg0_33:HideChat()
	setActive(arg0_33.chat, true)

	arg0_33.chatTween = LeanTween.delayedCall(go(arg0_33.chat), 4, System.Action(function()
		arg0_33:HideChat()
	end)).uniqueId

	local var0_33 = arg1_33[math.random(#arg1_33)]
	local var1_33 = pg.gametip[arg0_33.tipStr].tip
	local var2_33 = _.detect(var1_33, function(arg0_35)
		return arg0_35[1] == var0_33
	end)
	local var3_33 = var2_33 and var2_33[2]

	setText(arg0_33.chat:Find("Text"), var3_33)

	local var4_33 = arg0_33:GetSoundPath() .. var0_33

	arg0_33:PlaySound(var4_33)
end

function var0_0.GetSoundPath(arg0_36)
	local var0_36 = 1090001

	return "event:/cv/" .. var0_36 .. "/"
end

function var0_0.PlaySoundEffect(arg0_37, arg1_37)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_37)
end

function var0_0.ShowItemDetail(arg0_38, arg1_38)
	arg0_38:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, arg1_38)
end

function var0_0.LoadingOn(arg0_39)
	if arg0_39.animating then
		return
	end

	arg0_39.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0_0.LoadingOff(arg0_40)
	if not arg0_40.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0_40.animating = false
end

function var0_0.PlaySound(arg0_41, arg1_41, arg2_41)
	if not arg0_41.playbackInfo or arg1_41 ~= arg0_41.prevCvPath or arg0_41.playbackInfo.channelPlayer == nil then
		arg0_41:StopSound()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_41, function(arg0_42)
			if arg0_42 then
				arg0_41.playbackInfo = arg0_42

				arg0_41.playbackInfo:SetIgnoreAutoUnload(true)

				if arg2_41 then
					arg2_41(arg0_41.playbackInfo.cueInfo)
				end
			elseif arg2_41 then
				arg2_41()
			end
		end)

		arg0_41.prevCvPath = arg1_41

		if arg0_41.playbackInfo == nil then
			return nil
		end

		return arg0_41.playbackInfo.cueInfo
	elseif arg0_41.playbackInfo then
		arg0_41.playbackInfo:PlaybackStop()
		arg0_41.playbackInfo:SetStartTimeAndPlay()

		if arg2_41 then
			arg2_41(arg0_41.playbackInfo.cueInfo)
		end

		return arg0_41.playbackInfo.cueInfo
	elseif arg2_41 then
		arg2_41()
	end

	return nil
end

function var0_0.StopSound(arg0_43)
	if arg0_43.playbackInfo then
		pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0_43.playbackInfo)
		arg0_43.playbackInfo:SetIgnoreAutoUnload(false)
	end
end

function var0_0.ClearSound(arg0_44)
	arg0_44:StopSound()

	if arg0_44.playbackInfo then
		arg0_44.playbackInfo:Dispose()

		arg0_44.playbackInfo = nil
	end
end

function var0_0.HideChat(arg0_45)
	if arg0_45.chatTween then
		LeanTween.cancel(arg0_45.chatTween)

		arg0_45.chatTween = nil
	end

	setActive(arg0_45.chat, false)
end

function var0_0.AddIdleTimer(arg0_46)
	arg0_46:RemoveIdleTimer()

	arg0_46.idleTimer = Timer.New(function()
		arg0_46:DispalyChat(arg0_46.chatText.idle)
		arg0_46:AddIdleTimer()
	end, 8 + math.random() * 4)

	arg0_46.idleTimer:Start()
end

function var0_0.RemoveIdleTimer(arg0_48)
	if not arg0_48.idleTimer then
		return
	end

	arg0_48.idleTimer:Stop()

	arg0_48.idleTimer = nil
end

function var0_0.GetAtelierCompositEffect(arg0_49)
	return "laisha_lianjin"
end

function var0_0.GetAtelierCompositEffectPos(arg0_50)
	return Vector2.zero
end

function var0_0.OnCompositeResult(arg0_51, arg1_51)
	arg0_51:LoadingOn()
	arg0_51:DispalyChat(arg0_51.chatText.compositeResult)

	local var0_51 = 1.5
	local var1_51 = 0.5

	arg0_51.loader:GetPrefab("ui/" .. arg0_51:GetAtelierCompositEffect(), "", function(arg0_52)
		pg.UIMgr.GetInstance():OverlayPanel(tf(arg0_52))
		setAnchoredPosition(arg0_52, arg0_51:GetAtelierCompositEffectPos())
		arg0_51:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_51._tf, typeof(CanvasGroup)), 0, var0_51):setFrom(1)
		arg0_51:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_51.top, typeof(CanvasGroup)), 0, var0_51):setFrom(1)
		arg0_51:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_51.compositeConfirmPanel, typeof(CanvasGroup)), 0, var0_51):setFrom(1)
		arg0_51:managedTween(LeanTween.delayedCall, function()
			arg0_51.atelierCompositeConfirmView:HideCompositeConfirmWindow()
			setCanvasGroupAlpha(arg0_51.compositeConfirmPanel, 1)
			arg0_51:CleanNodeInstance()
			arg0_51.atelierCompositeResultView:ShowCompositeResult(arg1_51)
			arg0_51:DispalyChat(arg0_51.chatText.compositeResult2)
			arg0_51:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_51._tf, typeof(CanvasGroup)), 1, var1_51):setFrom(0)
			arg0_51:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_51.top, typeof(CanvasGroup)), 1, var1_51):setFrom(0)
			arg0_51:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0_51.compositeResultPanel, typeof(CanvasGroup)), 1, var1_51):setFrom(0)
			arg0_51:managedTween(LeanTween.delayedCall, function()
				arg0_51:LoadingOff()
				pg.UIMgr.GetInstance():UnOverlayPanel(tf(arg0_52), arg0_51._tf)
				arg0_51.loader:ClearRequest("CompositeResult")
			end, go(arg0_51.compositeResultPanel), var1_51, nil)
		end, go(arg0_51.compositeResultPanel), var0_51, nil)
	end, "CompositeResult")
end

function var0_0.OnReceiveFormualRequest(arg0_55, arg1_55)
	arg0_55.atelierMaterialSelectView:HideCandicatePanel()
	arg0_55.atelierCompositeConfirmView:HideCompositeConfirmWindow()
	arg0_55.atelierCompositeResultView:HideCompositeResult()
	arg0_55.atelierMaterialsPreview:HideMaterialsPreview()
	arg0_55:HideFormulaList()

	local var0_55 = arg0_55.activity:GetFormulas()[arg1_55]

	arg0_55:ShowFormulaDetail(var0_55)
end

function var0_0.CleanNodeInstance(arg0_56)
	local var0_56 = arg0_56.activity:GetFormulas()[arg0_56.contextData.formulaId]

	if not var0_56:IsAvaliable() then
		arg0_56:HideFormulaDetail()

		arg0_56.contextData.formulaId = nil

		arg0_56:ShowFormulaList()

		return
	end

	_.each(arg0_56.atelierFormulaDetailView.nodeList, function(arg0_57)
		arg0_57.Instance = nil
		arg0_57.Change = true
	end)
	arg0_56:ShowFormulaDetail(var0_56)
end

function var0_0.onBackPressed(arg0_58)
	if arg0_58.animating then
		return true
	end

	if arg0_58.atelierMaterialsPreview:HideMaterialsPreview() then
		return true
	end

	if arg0_58.atelierCompositeResultView:HideCompositeResult() then
		return true
	end

	if arg0_58.atelierCompositeConfirmView:HideCompositeConfirmWindow() then
		return true
	end

	if arg0_58.atelierMaterialSelectView:HideCandicatePanel() then
		return true
	end

	if arg0_58:HideFormulaDetail() then
		arg0_58.contextData.formulaId = nil

		arg0_58:ShowFormulaList()

		return true
	end

	arg0_58:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
