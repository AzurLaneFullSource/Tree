local var0_0 = class("AtelierCompositeYumiaScene", import("view.activity.Atelier.base.AtelierCompositeBaseScene"))

function var0_0.getUIName(arg0_1)
	return "AtelierCompositeYumiaUI"
end

function var0_0.InitCustom(arg0_2)
	arg0_2.layerEmpty = arg0_2:findTF("bg/Empty")

	setText(arg0_2:findTF("bg/Empty/bg/Text"), i18n(arg0_2.unlockText))

	arg0_2.painting = arg0_2:findTF("bg/painting")
	arg0_2.topBar = arg0_2:findTF("Top/TopBar")
	arg0_2.chat = arg0_2:findTF("bg/Chat")

	setActive(arg0_2.chat, false)
end

function var0_0.InitStr(arg0_3)
	arg0_3.bundleName = "ui/AtelierCompositeYumiaUI_atlas"
	arg0_3.commonBundleName = "ui/AtelierCommonYumiaUI_atlas"
	arg0_3.chatText = {
		idle = {
			"atelier_yumia_1"
		},
		clickFormula = {
			"atelier_yumia_2",
			"atelier_yumia_3",
			"atelier_yumia_4"
		},
		showMaterialSelectWindow = {
			"atelier_yumia_2",
			"atelier_yumia_3",
			"atelier_yumia_4"
		},
		selectMaterial = {
			"atelier_yumia_5",
			"atelier_atellier6",
			"atelier_atellier7"
		},
		compositeResult = {
			"atelier_atellier8",
			"atelier_atellier9"
		},
		compositeResult2 = {
			"atelier_atellier10",
			"atelier_atellier11"
		}
	}
	arg0_3.soundStr = {
		formulaDetailUnlock = "event:/ui/ryza_atellier_ui_3",
		showMaterialSelectWindow = "event:/ui/ryza_atellier_ui_1",
		compositeConfirm = "event:/ui/ryza_atellier_ui_6",
		selectMaterial = "event:/ui/ryza_atellier_ui_2",
		formulaDetail = "event:/ui/ryza_atellier_ui_5",
		clickFormula = "event:/ui/ryza_atellier_ui_1",
		formulaDetailFill = "event:/ui/ryza_atellier_ui_4"
	}
	arg0_3.helpStr = "ryza_composite_help_tip"
	arg0_3.tipStr = "yumia_atelier_tip22"
	arg0_3.unlockText = "yumia_atelier_tip1"
end

function var0_0.InitView(arg0_4)
	arg0_4.atelierFormulaListView = AtelierFormulaListYumiaView.New(arg0_4.layerFormulaPanel, arg0_4)
	arg0_4.atelierFormulaDetailView = AtelierFormulaDetailYumiaView.New(arg0_4.layerFormulaDetailPanel, arg0_4)
	arg0_4.atelierMaterialSelectView = AtelierMaterialSelectYumiaView.New(arg0_4.materialSelectPanel, arg0_4)
	arg0_4.atelierMaterialsPreview = AtelierFormulaMaterialsPreviewYumia.New(arg0_4.materialsPreviewPanel, arg0_4)
	arg0_4.atelierCompositeConfirmView = AtelierCompositeConfirmYumiaView.New(arg0_4.compositeConfirmPanel, arg0_4)
	arg0_4.atelierCompositeResultView = AtelierCompositeResultYumiaView.New(arg0_4.compositeResultPanel, arg0_4)
end

function var0_0.RefreshEmptyPanel(arg0_5)
	setActive(arg0_5.layerEmpty, not arg0_5.unlockSystem)
end

function var0_0.didEnter(arg0_6)
	arg0_6:UpdateAdapt()
	var0_0.super.didEnter(arg0_6)
end

function var0_0.UpdateAdapt(arg0_7)
	local var0_7 = 1.33333333333333
	local var1_7 = 2.16666666666667
	local var2_7 = pg.CameraFixMgr.GetInstance()
	local var3_7 = var2_7.currentWidth / var2_7.currentHeight
	local var4_7 = math.clamp(var3_7, var0_7, var1_7)

	arg0_7._tf:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_7
	arg0_7.top:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_7
end

function var0_0.OnClickStore(arg0_8)
	local var0_8 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(AtelierCompositeMediator)

	addSubLayer(Context.New({
		mediator = AtelierStoreBaseMediator,
		viewComponent = AtelierStoreYumiaScene,
		data = {
			activity = arg0_8.activity
		}
	}), var0_8)
end

function var0_0.ShowFormulaList(arg0_9)
	arg0_9:AddIdleTimer()
	arg0_9.atelierFormulaListView:ShowFormulaList()
end

function var0_0.ShowFormulaDetail(arg0_10, arg1_10)
	arg0_10.contextData.formulaId = arg1_10:GetConfigID()

	arg0_10.atelierFormulaDetailView:Show(arg1_10)
	setActive(arg0_10.materialSelectPanel, false)
end

function var0_0.HideFormulaDetail(arg0_11)
	arg0_11:ShowTopBar(true)

	if not isActive(arg0_11.layerFormulaDetailPanel) then
		return
	end

	arg0_11.atelierMaterialSelectView:HideCandicatePanel()
	arg0_11.atelierFormulaDetailView:HideDescriptionView()
	setActive(arg0_11.layerFormulaDetailPanel, false)

	return true
end

function var0_0.ShowMaterialSelectWindow(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12.atelierFormulaDetailView:HideDescriptionView()
	arg0_12.atelierFormulaDetailView:HideCompositePanel()
	var0_0.super.ShowMaterialSelectWindow(arg0_12, arg1_12, arg2_12, arg3_12)
end

function var0_0.RefreshScrollViewPosition(arg0_13)
	arg0_13.atelierFormulaDetailView:RefreshScrollViewPosition()
end

function var0_0.ShowTopBar(arg0_14, arg1_14)
	setActive(arg0_14.topBar, arg1_14)
end

function var0_0.UpdateRyzaDrop(arg0_15, arg1_15, arg2_15, arg3_15)
	updateDrop(arg1_15, arg2_15)
	SetCompomentEnabled(arg0_15:findTF("icon_bg", arg1_15), typeof(Image), false)
	setActive(arg0_15:findTF("bg", arg1_15), false)
	setActive(arg0_15:findTF("icon_bg/frame", arg1_15), false)
	setActive(arg0_15:findTF("icon_bg/stars", arg1_15), false)

	local var0_15 = arg2_15:getConfig("rarity")

	if arg2_15.type == DROP_TYPE_EQUIP or arg2_15.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0_15 = var0_15 - 1
	end

	local var1_15 = ItemRarity.Rarity2Print(var0_15)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_15, arg0_15:findTF("icon_bg", arg1_15))

	if arg2_15.type ~= DROP_TYPE_RYZA_DROP then
		onButton(arg0_15, arg1_15, function()
			arg0_15:emit(var0_0.ON_DROP, arg2_15)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_15)
	end
end

function var0_0.UpdateRyzaItem(arg0_17, arg1_17, arg2_17, arg3_17)
	AtelierTools.UpdateYumiaItem(arg1_17, arg2_17)
end

function var0_0.GetAtelierCompositEffect(arg0_18)
	return "youmiya_lianjinhecheng"
end

function var0_0.GetAtelierCompositEffectPos(arg0_19)
	return Vector2(0, 100)
end

function var0_0.AddIdleTimer(arg0_20)
	local var0_20 = GetComponent(arg0_20._tf, typeof(Animation))

	if var0_20:IsPlaying("anim_composite_in") then
		arg0_20:RemoveIdleTimer()

		arg0_20.idleTimer = FrameTimer.New(function()
			if not var0_20:IsPlaying("anim_composite_in") then
				arg0_20:DispalyChat(arg0_20.chatText.idle)
				arg0_20:AddChatTimer()

				return
			end
		end, 1, -1)

		arg0_20.idleTimer:Start()
	else
		arg0_20:AddChatTimer()
	end
end

function var0_0.AddChatTimer(arg0_22)
	arg0_22:RemoveIdleTimer()

	arg0_22.idleTimer = Timer.New(function()
		arg0_22:DispalyChat(arg0_22.chatText.idle)
		arg0_22:AddIdleTimer()
	end, 8 + math.random() * 4)

	arg0_22.idleTimer:Start()
end

function var0_0.DispalyChat(arg0_24, arg1_24)
	if GetComponent(arg0_24._tf, typeof(Animation)):IsPlaying("anim_composite_in") then
		return
	end

	var0_0.super.DispalyChat(arg0_24, arg1_24)
	arg0_24.painting:Find("root"):GetComponent("Animation"):Play("anim_composite_formulalist_talk")
end

function var0_0.GetSoundPath(arg0_25)
	local var0_25 = 1130001

	return "event:/cv/" .. var0_25 .. "/"
end

function var0_0.PlaySoundEffect(arg0_26, arg1_26)
	return
end

function var0_0.ClearSound(arg0_27)
	return
end

function var0_0.PlayGuide(arg0_28)
	return
end

return var0_0
