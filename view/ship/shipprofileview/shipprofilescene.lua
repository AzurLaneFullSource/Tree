local var0_0 = class("ShipProfileScene", import("...base.BaseUI"))

var0_0.SHOW_SKILL_INFO = "event show skill info"
var0_0.SHOW_EVALUATION = "event show evalution"
var0_0.WEDDING_REVIEW = "event wedding review"
var0_0.INDEX_DETAIL = 1
var0_0.INDEX_PROFILE = 2
var0_0.CHAT_ANIMATION_TIME = 0.3
var0_0.CHAT_SHOW_TIME = 3

local var1_0 = 0.35

function var0_0.getUIName(arg0_1)
	return "ShipProfileUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = getProxy(CollectionProxy):getShipGroup(arg1_2.groupId)
	local var1_2 = {
		"bg/star_level_bg_" .. var0_2:rarity2bgPrintForGet(arg1_2.showTrans),
		"ui/share/btn_l2d_atlas"
	}

	for iter0_2, iter1_2 in ipairs(ShipGroup.GetDisplayableSkinList(var0_2.id)) do
		table.insertto(var1_2, ResPathSupport.GetPaintingListByPaintingName(iter1_2.painting))
	end

	local var2_2 = var0_2:getShipConfigId()

	table.insertto(var1_2, ResPathSupport.GetSkillIconList(var2_2))

	local var3_2 = Ship.New({
		configId = var2_2
	}):getPrefab()
	local var4_2 = ResPathSupport.GetSpineCharListByPrefabName(var3_2)

	table.insertto(var1_2, var4_2)

	return table.insertto(var1_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = getProxy(CollectionProxy):getShipGroup(arg0_3.contextData.groupId)

	LoadSpriteAtlasAsync("bg/star_level_bg_" .. var0_3:rarity2bgPrintForGet(arg0_3.contextData.showTrans), "", arg1_3)
end

function var0_0.setShipGroup(arg0_4, arg1_4)
	arg0_4.shipGroup = arg1_4
	arg0_4.groupSkinList = ShipGroup.GetDisplayableSkinList(arg1_4.id)
	arg0_4.isBluePrintGroup = arg0_4.shipGroup:isBluePrintGroup()
	arg0_4.isMetaGroup = arg0_4.shipGroup:isMetaGroup()
end

function var0_0.setShowTrans(arg0_5, arg1_5)
	arg0_5.showTrans = arg1_5
end

function var0_0.setOwnedSkinList(arg0_6, arg1_6)
	arg0_6.ownedSkinList = arg1_6
end

function var0_0.init(arg0_7)
	arg0_7.bg = arg0_7._tf:Find("bg")
	arg0_7.staticBg = arg0_7.bg:Find("static_bg")
	arg0_7.painting = arg0_7._tf:Find("paint")
	arg0_7.paintingFitter = findTF(arg0_7.painting, "fitter")
	arg0_7.paintingInitPos = arg0_7.painting.transform.localPosition
	arg0_7.chatTF = arg0_7._tf:Find("paint/chat")

	setActive(arg0_7.chatTF, false)

	arg0_7.commonPainting = arg0_7.painting:Find("fitter")
	arg0_7.l2dRoot = arg0_7.painting:Find("live2d")
	arg0_7.spinePaintingRoot = arg0_7.painting:Find("spinePainting")
	arg0_7.spinePaintingBgRoot = arg0_7._tf:Find("paintBg/spinePainting")
	arg0_7.chatBg = arg0_7.chatTF:Find("chatbgtop")
	arg0_7.initChatBgH = arg0_7.chatBg.sizeDelta.y
	arg0_7.chatText = arg0_7.chatBg:Find("Text")
	arg0_7.name = arg0_7._tf:Find("name")
	arg0_7.nameInitPos = arg0_7.name.transform.localPosition
	arg0_7.shipType = arg0_7.name:Find("type")
	arg0_7.labelName = arg0_7.name:Find("name_mask/Text"):GetComponent(typeof(Text))
	arg0_7.labelEnName = arg0_7.name:Find("english_name"):GetComponent(typeof(Text))
	arg0_7.stars = arg0_7.name:Find("stars")
	arg0_7.star = arg0_7:getTpl("star_tpl", arg0_7.stars)
	arg0_7.blurPanel = arg0_7._tf:Find("blur_panel")
	arg0_7.top = arg0_7._tf:Find("blur_panel/adapt/top")
	arg0_7.btnBack = arg0_7.top:Find("back")
	arg0_7.bottomTF = arg0_7._tf:Find("adapt/bottom")
	arg0_7.labelHeart = arg0_7.blurPanel:Find("adapt/detail_left_panel/heart/label")
	arg0_7.btnLike = arg0_7.blurPanel:Find("adapt/detail_left_panel/heart/btnLike")
	arg0_7.btnChangeSkin = arg0_7.blurPanel:Find("adapt/detail_left_panel/change_skin")
	arg0_7.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_7.btnChangeSkin, "toggle_ui"))
	arg0_7.btnLikeAct = arg0_7.btnLike:Find("like")
	arg0_7.btnLikeDisact = arg0_7.btnLike:Find("unlike")
	arg0_7.obtainBtn = arg0_7._tf:Find("adapt/bottom/others/obtain_btn")
	arg0_7.evaBtn = arg0_7._tf:Find("adapt/bottom/others/eva_btn")
	arg0_7.viewBtn = arg0_7._tf:Find("adapt/bottom/others/view_btn")
	arg0_7.shareBtn = arg0_7._tf:Find("adapt/bottom/others/share_btn")
	arg0_7.rotateBtn = arg0_7._tf:Find("adapt/bottom/others/rotate_btn")
	arg0_7.cryptolaliaBtn = arg0_7._tf:Find("adapt/bottom/others/cryptolalia_btn")
	arg0_7.equipCodeBtn = arg0_7._tf:Find("adapt/bottom/others/equip_code_btn")
	arg0_7.leftProfile = arg0_7.blurPanel:Find("adapt/profile_left_panel")
	arg0_7.modelContainer = arg0_7.leftProfile:Find("model")
	arg0_7.live2DBtn = ShipProfileLive2dBtn.New(arg0_7.blurPanel:Find("L2D_btn"))
	arg0_7.l2dBtnOn = false

	GetComponent(arg0_7.blurPanel:Find("L2D_btn"), typeof(Image)):SetNativeSize()
	GetComponent(arg0_7.blurPanel:Find("L2D_btn/img"), typeof(Image)):SetNativeSize()

	arg0_7.spinePaintingBtn = arg0_7.blurPanel:Find("SP_btn")

	GetComponent(arg0_7.spinePaintingBtn, typeof(Image)):SetNativeSize()
	GetComponent(arg0_7.blurPanel:Find("SP_btn/img"), typeof(Image)):SetNativeSize()
	GetComponent(arg0_7.blurPanel:Find("adapt/top/title"), typeof(Image)):SetNativeSize()

	arg0_7.spinePaintingToggle = arg0_7.spinePaintingBtn:Find("toggle")
	arg0_7.cvLoader = ShipProfileCVLoader.New()
	arg0_7.pageTFs = arg0_7._tf:Find("adapt/pages")
	arg0_7.paintingView = ShipProfilePaintingView.New(arg0_7._tf, arg0_7.painting)
	arg0_7.toggles = {
		arg0_7._tf:Find("adapt/bottom/detail"),
		arg0_7._tf:Find("adapt/bottom/profile")
	}

	local var0_7 = ShipProfileInformationPage.New(arg0_7.pageTFs, arg0_7.event)
	local var1_7 = ShipProfileDetailPage.New(arg0_7.pageTFs, arg0_7.event)

	var0_7:SetCvLoader(arg0_7.cvLoader)
	var0_7:SetCallback(function(arg0_8)
		arg0_7:OnCVBtnClick(arg0_8)
	end)

	arg0_7.pages = {
		var1_7,
		var0_7
	}
	arg0_7.UISkinList = UIItemList.New(arg0_7.leftProfile:Find("scroll/Viewport/skin_container"), arg0_7.leftProfile:Find("scroll/Viewport/skin_container/skin_tpl"))
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9.btnBack, function()
		arg0_9:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.equipCodeBtn, function()
		arg0_9:emit(ShipProfileMediator.OPEN_EQUIP_CODE_SHARE, arg0_9.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.cryptolaliaBtn, function()
		arg0_9:emit(ShipProfileMediator.OPEN_CRYPTOLALIA, arg0_9.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.obtainBtn, function()
		local var0_13 = {
			type = MSGBOX_TYPE_OBTAIN,
			shipId = arg0_9.shipGroup:getShipConfigId(),
			list = arg0_9.shipGroup.groupConfig.description,
			mediatorName = ShipProfileMediator.__cname
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_13)
	end)
	onButton(arg0_9, arg0_9.evaBtn, function()
		arg0_9:emit(var0_0.SHOW_EVALUATION, arg0_9.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.viewBtn, function()
		if LeanTween.isTweening(arg0_9.chatTF.gameObject) then
			LeanTween.cancel(arg0_9.chatTF.gameObject)

			arg0_9.chatTF.localScale = Vector3(0, 0, 0)

			if arg0_9.dailogueCallback then
				arg0_9.dailogueCallback()

				arg0_9.dailogueCallback = nil
			end
		end

		arg0_9.paintingView:Start()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeShipProfile)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.rotateBtn, function()
		setActive(arg0_9._tf, false)
		setActive(arg0_9.blurPanel, false)
		arg0_9:emit(ShipProfileMediator.CLICK_ROTATE_BTN, arg0_9.shipGroup, arg0_9.showTrans, arg0_9.skin)
	end, SFX_PANEL)
	arg0_9.live2DBtn:AddListener(function(arg0_18)
		if arg0_18 then
			arg0_9:CreateLive2D()
		else
			arg0_9:clearLive2dPainting()
		end

		arg0_9.l2dBtnOn = arg0_18

		setActive(arg0_9.viewBtn, not arg0_18)
		setActive(arg0_9.rotateBtn, not arg0_18)
		setActive(arg0_9.commonPainting, not arg0_18)
		setActive(arg0_9.l2dRoot, arg0_18)
		arg0_9:StopDailogue()

		arg0_9.l2dActioning = nil

		if arg0_9.skin then
			arg0_9.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg0_9.skin, arg0_18)
		end
	end)

	for iter0_9, iter1_9 in ipairs(arg0_9.toggles) do
		onToggle(arg0_9, iter1_9, function(arg0_19)
			if iter0_9 == var0_0.INDEX_DETAIL then
				arg0_9.live2DBtn:Update(arg0_9.paintingName, false)

				arg0_9.spinePaintingisOn = false

				arg0_9:updateSpinePaintingState()
				arg0_9:DisplaySpinePainting(false)
			end

			if arg0_19 then
				arg0_9:SwitchPage(iter0_9)
			end
		end, SFX_PANEL)
	end

	arg0_9:InitCommon()
	arg0_9.live2DBtn:Update(arg0_9.paintingName, false)
	arg0_9:updateSpinePaintingState()
	onButton(arg0_9, arg0_9.btnChangeSkin, function()
		local var0_20 = arg0_9.skin

		if ShipSkin.IsChangeSkin(var0_20.id) then
			local var1_20 = ShipSkin.GetChangeSkinNextId(var0_20.id)
			local var2_20 = pg.ship_skin_template[var1_20]

			arg0_9:showSkinProfile(arg0_9.contextData.skinIndex, var2_20, arg0_9.prevSkinBtn)
		end
	end, SFX_CONFIRM)
	setActive(arg0_9.bottomTF, false)
	triggerToggle(arg0_9.toggles[var0_0.INDEX_DETAIL], true)
end

function var0_0.InitSkinList(arg0_21)
	arg0_21.skinBtns = {}

	arg0_21.UISkinList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = arg0_21.groupSkinList[arg1_22 + 1]
			local var1_22 = ShipProfileSkinBtn.New(arg2_22)

			table.insert(arg0_21.skinBtns, var1_22)
			var1_22:Update(var0_22, arg0_21.shipGroup, table.contains(arg0_21.ownedSkinList, var0_22.id))
			onButton(arg0_21, var1_22._tf, function()
				if not var1_22.unlock then
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_profile_skin_locked"))

					return
				end

				arg0_21:showSkinProfile(arg1_22, var0_22, var1_22)
			end, SFX_PANEL)
			setActive(arg2_22, var0_22.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or not HXSet.isHxSkin())
		end
	end)
	arg0_21.UISkinList:align(#arg0_21.groupSkinList)
end

function var0_0.showSkinProfile(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = ShipSkin.IsChangeSkin(arg2_24.id)

	setActive(arg0_24.btnChangeSkin, var0_24)

	if var0_24 then
		arg0_24.changeSkinToggle:setSkinData(arg2_24.id)
		setActive(arg0_24.btnChangeSkin, not arg0_24.changeSkinToggle:IsAsmrSkin())
	end

	arg0_24.contextData.skinIndex = arg1_24 + 1

	arg0_24:ShiftSkin(arg2_24)

	if arg0_24.prevSkinBtn then
		arg0_24.prevSkinBtn:UnShift()
	end

	arg3_24:Shift()

	arg0_24.prevSkinBtn = arg3_24
end

function var0_0.InitCommon(arg0_25)
	arg0_25:LoadSkinBg(arg0_25.shipGroup:rarity2bgPrintForGet(arg0_25.showTrans))
	setImageSprite(arg0_25.shipType, GetSpriteFromAtlas("shiptype", arg0_25.shipGroup:getShipType(arg0_25.showTrans)))

	arg0_25.labelName.text = arg0_25.shipGroup:getName(arg0_25.showTrans)

	local var0_25 = arg0_25.shipGroup.shipConfig
	local var1_25 = pg.ship_data_template[var0_25.id].star_max

	arg0_25.labelEnName.text = var0_25.english_name

	for iter0_25 = 1, var1_25 do
		cloneTplTo(arg0_25.star, arg0_25.stars)
	end

	arg0_25:FlushHearts()

	local var2_25 = arg0_25.shipGroup:GetSkin(arg0_25.showTrans).id

	arg0_25:SetPainting(var2_25, arg0_25.showTrans)
end

function var0_0.SetPainting(arg0_26, arg1_26, arg2_26)
	arg0_26:RecyclePainting()

	if arg2_26 and arg0_26.shipGroup.trans then
		arg1_26 = arg0_26.shipGroup.groupConfig.trans_skin
	end

	local var0_26 = pg.ship_skin_template[arg1_26].painting

	setPaintingPrefabAsync(arg0_26.painting, var0_26, "chuanwu", function()
		setActive(arg0_26.commonPainting, true)
	end)

	arg0_26.paintingName = var0_26

	arg0_26:UpdateCryptolaliaBtn(arg1_26)
end

function var0_0.RecyclePainting(arg0_28)
	if arg0_28.paintingName then
		retPaintingPrefab(arg0_28.painting, arg0_28.paintingName)
	end
end

function var0_0.FlushHearts(arg0_29)
	local var0_29 = arg0_29.shipGroup.hearts

	setText(arg0_29.labelHeart, var0_29 > 999 and "999+" or var0_29)

	arg0_29.labelHeart:GetComponent("Text").color = arg0_29.shipGroup.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

	setActive(arg0_29.btnLikeDisact, not arg0_29.shipGroup.iheart)
	setActive(arg0_29.btnLikeAct, arg0_29.shipGroup.iheart)
end

function var0_0.LoadSkinBg(arg0_30, arg1_30)
	arg0_30.bluePintBg = arg0_30.isBluePrintGroup and arg0_30.shipGroup:rarity2bgPrintForGet(arg0_30.showTrans)
	arg0_30.metaMainBg = arg0_30.isMetaGroup and arg0_30.shipGroup:rarity2bgPrintForGet(arg0_30.showTrans)

	if arg0_30.shipSkinBg ~= arg1_30 then
		arg0_30.shipSkinBg = arg1_30

		local function var0_30(arg0_31)
			rtf(arg0_31).localPosition = Vector3(0, 0, 200)
			rtf(arg0_31).anchorMin = Vector2.zero
			rtf(arg0_31).anchorMax = Vector2.one
			rtf(arg0_31).offsetMin = Vector2(0, 0)
			rtf(arg0_31).offsetMax = Vector2(0, 0)
		end

		local function var1_30()
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg0_30.shipGroup:getRarity(arg0_30.showTrans), true, function(arg0_33)
				arg0_30.designBg = arg0_33
				arg0_30.designName = "raritydesign" .. arg0_30.shipGroup:getRarity(arg0_30.showTrans)

				arg0_33.transform:SetParent(arg0_30.staticBg, false)

				arg0_33.transform.localPosition = Vector3(1, 1, 1)
				arg0_33.transform.localScale = Vector3(1, 1, 1)

				arg0_33.transform:SetSiblingIndex(1)
				SetTFLayerOrder(arg0_33.transform, LayerWeightConst.PAINTING_RARITY_DESIGN_LAYER)
				setActive(arg0_33, true)
			end)
		end

		local function var2_30()
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg0_30.shipGroup:getRarity(arg0_30.showTrans), true, function(arg0_35)
				arg0_30.metaBg = arg0_35
				arg0_30.metaName = "raritymeta" .. arg0_30.shipGroup:getRarity(arg0_30.showTrans)

				arg0_35.transform:SetParent(arg0_30.staticBg, false)

				arg0_35.transform.localPosition = Vector3(1, 1, 1)
				arg0_35.transform.localScale = Vector3(1, 1, 1)

				arg0_35.transform:SetSiblingIndex(1)
				setActive(arg0_35, true)
			end)
		end

		local function var3_30(arg0_36)
			if arg0_30.bluePintBg and arg1_30 == arg0_30.bluePintBg then
				if arg0_30.metaBg then
					setActive(arg0_30.metaBg, false)
				end

				if arg0_30.designBg and arg0_30.designName ~= "raritydesign" .. arg0_30.shipGroup:getRarity(arg0_30.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0_30.designName, arg0_30.designBg)

					arg0_30.designBg = nil
				end

				if not arg0_30.designBg then
					var1_30()
				else
					setActive(arg0_30.designBg, true)
				end
			elseif arg0_30.metaMainBg and arg1_30 == arg0_30.metaMainBg then
				if arg0_30.designBg then
					setActive(arg0_30.designBg, false)
				end

				if arg0_30.metaBg and arg0_30.metaName ~= "raritymeta" .. arg0_30.shipGroup:getRarity(arg0_30.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0_30.metaName, arg0_30.metaBg)

					arg0_30.metaBg = nil
				end

				if not arg0_30.metaBg then
					var2_30()
				else
					setActive(arg0_30.metaBg, true)
				end
			else
				if arg0_30.designBg then
					setActive(arg0_30.designBg, false)
				end

				if arg0_30.metaBg then
					setActive(arg0_30.metaBg, false)
				end
			end
		end

		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_30, arg1_30, arg0_30.bg, arg0_30.staticBg, var0_30, var3_30)
	end
end

function var0_0.SwitchPage(arg0_37, arg1_37)
	if arg0_37.index ~= arg1_37 then
		seriesAsync({
			function(arg0_38)
				arg0_37:OverlayPanel(arg0_37.blurPanel)
				arg0_38()
			end,
			function(arg0_39)
				local var0_39 = arg0_37.pages[arg1_37]
				local var1_39 = arg1_37 == var0_0.INDEX_PROFILE and not var0_39:GetLoaded()

				var0_39:ExecuteAction("Update", arg0_37.shipGroup, arg0_37.showTrans, function()
					if var1_39 then
						arg0_37:InitSkinList()
					end

					arg0_39()
				end)
			end,
			function(arg0_41)
				if not arg0_37.index then
					arg0_41()

					return
				end

				arg0_37.pages[arg0_37.index]:ExecuteAction("ExistAnim", var1_0)
				arg0_41()
			end,
			function(arg0_42)
				local var0_42 = arg0_37.pages[arg1_37]

				SetParent(arg0_37.bottomTF, var0_42._tf)
				setActive(arg0_37.bottomTF, true)
				setAnchoredPosition(arg0_37.bottomTF, {
					z = 0,
					x = -7,
					y = 24
				})
				var0_42:ExecuteAction("EnterAnim", var1_0)
				arg0_37:TweenPage(arg1_37)
				arg0_42()
			end,
			function(arg0_43)
				arg0_37.index = arg1_37

				local var0_43 = arg0_37.contextData.skinIndex or 1

				if arg1_37 == var0_0.INDEX_PROFILE and var0_43 <= #arg0_37.skinBtns then
					triggerButton(arg0_37.skinBtns[var0_43]._tf)
				end
			end
		})
	end
end

function var0_0.TweenPage(arg0_44, arg1_44)
	if arg1_44 == var0_0.INDEX_DETAIL then
		LeanTween.moveX(rtf(arg0_44.leftProfile), -700, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_44.live2DBtn._tf), -70, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_44.spinePaintingBtn), -70, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_44.painting), arg0_44.paintingInitPos.x, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_44.name), arg0_44.nameInitPos.x, var1_0):setEase(LeanTweenType.easeInOutSine)
	elseif arg1_44 == var0_0.INDEX_PROFILE then
		LeanTween.moveX(rtf(arg0_44.leftProfile), 0, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_44.live2DBtn._tf), 60, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_44.spinePaintingBtn), 60, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_44.painting), arg0_44.paintingInitPos.x + 50, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_44.name), arg0_44.nameInitPos.x + 50, var1_0):setEase(LeanTweenType.easeInOutSine)
	end
end

function var0_0.ShiftSkin(arg0_45, arg1_45)
	if arg0_45.index ~= var0_0.INDEX_PROFILE or arg0_45.skin and arg1_45.id == arg0_45.skin.id then
		return
	end

	arg0_45.skin = arg1_45

	arg0_45:SetPainting(arg1_45.id, false)
	arg0_45:LoadModel(arg1_45)
	arg0_45.live2DBtn:Disable()
	arg0_45.live2DBtn:Update(arg0_45.paintingName, false)

	local var0_45
	local var1_45 = arg1_45 and arg1_45.spine_use_live2d == 1 and "spine_painting_bg" or "live2d_bg"

	LoadSpriteAtlasAsync("ui/share/btn_l2d_atlas", var1_45, function(arg0_46)
		GetComponent(arg0_45.blurPanel:Find("L2D_btn"), typeof(Image)).sprite = arg0_46
		GetComponent(arg0_45.blurPanel:Find("L2D_btn/img"), typeof(Image)).sprite = arg0_46

		GetComponent(arg0_45.blurPanel:Find("L2D_btn"), typeof(Image)):SetNativeSize()
		GetComponent(arg0_45.blurPanel:Find("L2D_btn/img"), typeof(Image)):SetNativeSize()
	end)

	arg0_45.spinePaintingisOn = false

	arg0_45:updateSpinePaintingState()
	arg0_45:DestroySpinePainting()
	arg0_45.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg1_45, false)

	local var2_45
	local var3_45 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_45.skin.painting, 0) == 0

	if arg0_45.skin.bg_sp and arg0_45.skin.bg_sp ~= "" and var3_45 then
		var2_45 = arg0_45.skin.bg_sp
	elseif arg0_45.skin.bg and arg0_45.skin.bg ~= "" then
		var2_45 = arg0_45.skin.bg
	else
		var2_45 = arg0_45.shipGroup:rarity2bgPrintForGet(arg0_45.showTrans, arg0_45.skin.id)
	end

	arg0_45:LoadSkinBg(var2_45)

	arg0_45.haveOp = checkABExist("ui/skinunlockanim/star_level_unlock_anim_" .. arg0_45.skin.id)
end

function var0_0.UpdateCryptolaliaBtn(arg0_47, arg1_47)
	local var0_47 = ShipSkin.New({
		id = arg1_47
	}):getConfig("ship_group")

	setActive(arg0_47.cryptolaliaBtn, getProxy(PlayerProxy):getRawData():ExistCryptolalia(var0_47))
end

function var0_0.LoadModel(arg0_48, arg1_48)
	if arg0_48.inLoading then
		return
	end

	arg0_48:ReturnModel()

	local var0_48 = arg1_48.prefab

	arg0_48.inLoading = true

	local var1_48 = SpineAnimChar.New()

	var1_48:SetPaint(var0_48)
	var1_48:Load(true, function(arg0_49)
		arg0_48.inLoading = false

		arg0_49:SetName(var0_48)
		arg0_49:SetLocalPosition(Vector3.zero)
		arg0_49:SetLocalScale(Vector3(0.8, 0.8, 1))
		arg0_49:SetParent(arg0_48.modelContainer)
		arg0_49:SetAction(arg1_48.show_skin or "stand", 0)

		arg0_48.characterModel = arg0_49
		arg0_48.modelName = var0_48
	end)
end

function var0_0.ReturnModel(arg0_50)
	if arg0_50.characterModel then
		arg0_50.characterModel:Dispose()

		arg0_50.characterModel = nil
	end
end

function var0_0.CreateLive2D(arg0_51)
	arg0_51.live2DBtn:SetEnable(false)

	if arg0_51.l2dChar then
		arg0_51.l2dChar:Dispose()

		arg0_51.l2dChar = nil
	end

	local var0_51 = arg0_51.shipGroup:getShipConfigId()
	local var1_51 = pg.ship_skin_template[arg0_51.skin.id].live2d_offset_profile
	local var2_51

	if var1_51 and #var1_51 >= 3 then
		local var3_51 = var1_51
	else
		local var4_51 = {
			0,
			0,
			0,
			52
		}
	end

	local var5_51 = Live2DPainting.GenerateData({
		ship = Ship.New({
			noChangeSkin = true,
			configId = var0_51,
			skin_id = arg0_51.skin.id,
			propose = arg0_51.shipGroup.married
		}),
		position = Vector3(0, 0, 0),
		offset = var1_51,
		parent = arg0_51.l2dRoot
	})

	arg0_51.l2dChar = Live2DPainting.New(var5_51, function(arg0_52)
		arg0_52:setSortingModeFrontZ()
		arg0_51.live2DBtn:SetEnable(true)
	end)

	if isHalfBodyLive2D(arg0_51.skin.prefab) then
		setAnchoredPosition(arg0_51.l2dRoot, {
			y = -77 - (arg0_51.painting.rect.height - arg0_51.l2dRoot.rect.height * 1.5) / 2
		})
	else
		setAnchoredPosition(arg0_51.l2dRoot, {
			y = -40
		})
	end

	if Live2dConst.UnLoadL2dPating then
		Live2dConst.UnLoadL2dPating()
	end
end

function var0_0.GetModelAction(arg0_53, arg1_53)
	local var0_53

	if not arg1_53.spine_action or arg1_53.spine_action == "" then
		return "stand"
	else
		return arg1_53.spine_action
	end
end

function var0_0.OnCVBtnClick(arg0_54, arg1_54)
	if arg0_54.l2dActioning then
		return
	end

	local var0_54 = arg1_54.voice

	local function var1_54()
		local var0_55

		if arg1_54:isEx() then
			local var1_55 = var0_54.l2d_action .. "_ex"

			if arg0_54.l2dChar and arg0_54.l2dChar:checkActionExist(var1_55) then
				var0_55 = var1_55
			else
				var0_55 = var0_54.l2d_action
			end
		else
			var0_55 = var0_54.l2d_action
		end

		if arg0_54.l2dBtnOn and arg0_54.l2dChar and not arg0_54.l2dChar:enablePlayAction(var0_55) then
			return
		end

		arg0_54:UpdatePaintingFace(arg1_54)

		if arg0_54.characterModel then
			local var2_55 = arg0_54:GetModelAction(var0_54)

			arg0_54.characterModel:SetAction(var2_55, 0)
		end

		local var3_55 = {
			var0_0.CHAT_SHOW_TIME
		}

		if arg0_54.live2DBtn.isOn and arg0_54.l2dChar then
			if arg0_54.l2dChar:IsLoaded() then
				arg0_54.l2dActioning = true

				if not arg1_54:L2dHasEvent() then
					parallelAsync({
						function(arg0_56)
							arg0_54:RemoveLive2DTimer()

							arg0_54.l2dActioning = arg0_54.l2dChar:TriggerAction(var0_55, arg0_56)
						end,
						function(arg0_57)
							arg0_54:PlayVoice(arg1_54, var3_55)
							arg0_54:ShowDailogue(arg1_54, var3_55, arg0_57)
						end
					}, function()
						arg0_54.l2dActioning = false
					end)
				else
					seriesAsync({
						function(arg0_59)
							arg0_54:RemoveLive2DTimer()

							if arg0_54.l2dChar:checkActionProfile(var0_55) then
								arg0_54.l2dActioning = arg0_54.l2dChar:TriggerAction(var0_55, arg0_59, nil, function(arg0_60)
									arg0_54:PlayVoice(arg1_54, var3_55)
									arg0_54:ShowDailogue(arg1_54, var3_55, arg0_59)
								end)
							else
								arg0_54:PlayVoice(arg1_54, var3_55)
								arg0_54:ShowDailogue(arg1_54, var3_55, arg0_59)
							end
						end
					}, function()
						arg0_54.l2dActioning = false
					end)
				end
			end
		else
			arg0_54:PlayVoice(arg1_54, var3_55)
			arg0_54:ShowDailogue(arg1_54, var3_55)
		end
	end

	if var0_54.key == "unlock" and arg0_54.haveOp then
		arg0_54:playOpening(var1_54)
	elseif arg1_54.voice.resource_key == "get" then
		local var2_54 = arg1_54.skin.id

		if PaintingShowScene.GetSkinShowAble(var2_54) then
			arg0_54:emit(ShipProfileMediator.OPEN_PAINTING_SHOW, var2_54, function()
				onNextTick(function()
					var1_54()
				end)
			end)
		else
			var1_54()
		end
	else
		var1_54()
	end
end

function var0_0.UpdatePaintingFace(arg0_64, arg1_64)
	local var0_64 = arg1_64.wordData
	local var1_64 = var0_64.mainIndex ~= nil
	local var2_64 = arg1_64.voice.key

	if var1_64 then
		var2_64 = "main_" .. var0_64.mainIndex
	end

	if arg0_64.paintingFitter.childCount > 0 then
		ShipExpressionHelper.SetExpression(arg0_64.paintingFitter:GetChild(0), arg0_64.paintingName, var2_64, var0_64.maxfavor, arg1_64.skin.id)
	end

	if arg0_64.spinePainting then
		local var3_64

		if pg.AssistantInfo.GetAssistantEventsByDialog(var2_64) then
			var3_64 = pg.AssistantInfo.GetAssistantEventsByDialog(var2_64).action
		end

		local var4_64 = ShipExpressionHelper.GetExpression(arg0_64.paintingName, var2_64, var0_64.maxfavor, arg1_64.skin.id)

		if var4_64 ~= "" then
			arg0_64.spinePainting:SetAction(var4_64, 1)

			if var3_64 and arg0_64.spinePainting:getAnimationExist(var3_64) then
				arg0_64.spinePainting:SetEmptyAction(1)
				arg0_64.spinePainting:SetOnceAction(var3_64, nil, function()
					return
				end, true)
			elseif arg0_64.spinePainting:isInAction() then
				arg0_64.spinePainting:SetAction(arg0_64.spinePainting:getIdleName(), 0, true)
				arg0_64.spinePainting:ClearAction()
			end
		else
			arg0_64.spinePainting:SetEmptyAction(1)

			if var3_64 and arg0_64.spinePainting:getAnimationExist(var3_64) then
				arg0_64.spinePainting:SetOnceAction(var3_64, nil, function()
					return
				end, true)
			elseif arg0_64.spinePainting:isInAction() then
				arg0_64.spinePainting:SetAction(arg0_64.spinePainting:getIdleName(), 0, true)
				arg0_64.spinePainting:ClearAction()
			end
		end
	end
end

function var0_0.PlayVoice(arg0_67, arg1_67, arg2_67)
	local var0_67 = arg1_67.wordData
	local var1_67 = arg1_67.skin
	local var2_67 = arg1_67.words

	arg0_67:RemoveCvTimer()

	if not var0_67.cvPath or var0_67.cvPath == "" then
		return
	end

	if var2_67.voice_key >= ShipWordHelper.CV_KEY_REPALCE or var2_67.voice_key_2 >= ShipWordHelper.CV_KEY_REPALCE or var2_67.voice_key == ShipWordHelper.CV_KEY_BAN_NEW then
		local var3_67 = 0

		if arg1_67.isLive2d and arg0_67.l2dChar and var0_67.voiceCalibrate then
			var3_67 = var0_67.voiceCalibrate
		end

		arg0_67.cvLoader:DelayPlaySound(var0_67.cvPath, var3_67, function(arg0_68)
			if arg0_68 then
				arg2_67[1] = long2int(arg0_68.length) * 0.001
			end
		end)
	end

	local var4_67 = var0_67.se

	if arg1_67.isLive2d and arg0_67.l2dChar and var4_67 then
		arg0_67.cvLoader:RawPlaySound("event:/ui/" .. var4_67[1], var4_67[2])
	end
end

function var0_0.RemoveCvSeTimer(arg0_69)
	if arg0_69.cvSeTimer then
		arg0_69.cvSeTimer:Stop()

		arg0_69.cvSeTimer = nil
	end
end

function var0_0.RemoveCvTimer(arg0_70)
	if arg0_70.cvTimer then
		arg0_70.cvTimer:Stop()

		arg0_70.cvTimer = nil
	end
end

function var0_0.RemoveLive2DTimer(arg0_71)
	if arg0_71.Live2DTimer then
		LeanTween.cancel(arg0_71.Live2DTimer)

		arg0_71.Live2DTimer = nil
	end
end

function var0_0.ShowDailogue(arg0_72, arg1_72, arg2_72, arg3_72)
	arg0_72.dailogueCallback = arg3_72 or function()
		return
	end

	local var0_72 = arg1_72.wordData.textContent

	if not var0_72 or var0_72 == "" or var0_72 == "nil" then
		if arg0_72.dailogueCallback then
			arg0_72.dailogueCallback()

			arg0_72.dailogueCallback = nil
		end

		return
	end

	local var1_72 = arg1_72.wordData.voiceCalibrate
	local var2_72 = arg0_72.chatText:GetComponent(typeof(Text))

	setText(arg0_72.chatText, SwitchSpecialChar(var0_72))

	var2_72.alignment = #var2_72.text > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	local var3_72 = var2_72.preferredHeight + 120

	arg0_72.chatBg.sizeDelta = var3_72 > arg0_72.initChatBgH and Vector2.New(arg0_72.chatBg.sizeDelta.x, var3_72) or Vector2.New(arg0_72.chatBg.sizeDelta.x, arg0_72.initChatBgH)

	arg0_72:StopDailogue()
	setActive(arg0_72.chatTF, true)
	LeanTween.scale(rtf(arg0_72.chatTF.gameObject), Vector3.New(1, 1, 1), var0_0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeOutBack):setDelay(var1_72 and var1_72 or 0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_72.chatTF.gameObject), Vector3.New(0, 0, 1), var0_0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeInBack):setDelay(var0_0.CHAT_ANIMATION_TIME + arg2_72[1]):setOnComplete(System.Action(function()
			if arg0_72.dailogueCallback then
				arg0_72.dailogueCallback()

				arg0_72.dailogueCallback = nil
			end

			if arg0_72.spinePainting then
				arg0_72.spinePainting:SetEmptyAction(1)
			end
		end))
	end))
end

function var0_0.StopDailogue(arg0_76)
	LeanTween.cancel(arg0_76.chatTF.gameObject)

	arg0_76.chatTF.localScale = Vector3(0, 0)
end

function var0_0.onBackPressed(arg0_77)
	if arg0_77.paintingView.isPreview then
		arg0_77.paintingView:Finish(true)

		return
	end

	triggerButton(arg0_77.btnBack)
end

function var0_0.playOpening(arg0_78, arg1_78)
	local var0_78 = "star_level_unlock_anim_" .. arg0_78.skin.id

	if checkABExist("ui/skinunlockanim/" .. var0_78) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1_78 then
				arg1_78()
			end
		end, "ui/skinunlockanim", var0_78, true, false)
	elseif arg1_78 then
		arg1_78()
	end
end

function var0_0.updateSpinePaintingState(arg0_81)
	local var0_81 = HXSet.autoHxShiftPath("spinepainting/" .. arg0_81.paintingName)

	if checkABExist(var0_81) then
		setActive(arg0_81.spinePaintingBtn, true)
		setActive(arg0_81.spinePaintingToggle:Find("on"), arg0_81.spinePaintingisOn)
		setActive(arg0_81.spinePaintingToggle:Find("off"), not arg0_81.spinePaintingisOn)
		removeOnButton(arg0_81.spinePaintingBtn)
		onButton(arg0_81, arg0_81.spinePaintingBtn, function()
			arg0_81.spinePaintingisOn = not arg0_81.spinePaintingisOn

			setActive(arg0_81.spinePaintingToggle:Find("on"), arg0_81.spinePaintingisOn)
			setActive(arg0_81.spinePaintingToggle:Find("off"), not arg0_81.spinePaintingisOn)

			if arg0_81.spinePaintingisOn then
				arg0_81:CreateSpinePainting()
			end

			setActive(arg0_81.viewBtn, not arg0_81.spinePaintingisOn)
			setActive(arg0_81.rotateBtn, not arg0_81.spinePaintingisOn)
			setActive(arg0_81.commonPainting, not arg0_81.spinePaintingisOn)
			setActive(arg0_81.spinePaintingRoot, arg0_81.spinePaintingisOn)
			setActive(arg0_81.spinePaintingBgRoot, arg0_81.spinePaintingisOn)
			arg0_81:StopDailogue()

			if arg0_81.skin then
				arg0_81.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg0_81.skin, false)
			end
		end, SFX_PANEL)
	else
		setActive(arg0_81.spinePaintingBtn, false)
	end
end

function var0_0.CreateSpinePainting(arg0_83)
	if arg0_83.skin.id ~= arg0_83.preSkinId then
		arg0_83:DestroySpinePainting()

		local var0_83 = arg0_83.shipGroup:getShipConfigId()
		local var1_83 = SpinePainting.GenerateData({
			ship = Ship.New({
				noChangeSkin = true,
				configId = var0_83,
				skin_id = arg0_83.skin.id
			}),
			position = Vector3(0, 0, 0),
			parent = arg0_83.spinePaintingRoot,
			offset = pg.ship_skin_template[arg0_83.skin.id].spine_offset_profile,
			effectParent = arg0_83.spinePaintingBgRoot
		})

		arg0_83.spinePainting = SpinePainting.New(var1_83, function()
			return
		end)
		arg0_83.preSkinId = arg0_83.skin.id
	end

	arg0_83:DisplaySpinePainting(true)
end

function var0_0.clearLive2dPainting(arg0_85)
	if arg0_85.l2dChar then
		arg0_85.l2dChar:Dispose()

		arg0_85.l2dChar = nil
		arg0_85.l2dActioning = false
		arg0_85.cvLoader.prevCvPath = nil

		arg0_85:StopDailogue()
		arg0_85.cvLoader:StopSound()
	end
end

function var0_0.DestroySpinePainting(arg0_86)
	if arg0_86.spinePainting then
		arg0_86.spinePainting:Dispose()

		arg0_86.spinePainting = nil
	end

	arg0_86.preSkinId = nil
end

function var0_0.onWeddingReview(arg0_87, arg1_87)
	if not arg1_87 and arg0_87.exitLoadL2d then
		arg0_87.exitLoadL2d = false

		arg0_87.live2DBtn:Update(arg0_87.paintingName, true)
	else
		arg0_87.live2DBtn:Update(arg0_87.paintingName, false)
	end

	arg0_87.live2DBtn:SetEnable(not arg1_87)

	if arg0_87.l2dChar and arg1_87 then
		arg0_87.l2dChar:Dispose()

		arg0_87.l2dChar = nil
		arg0_87.l2dActioning = false
		arg0_87.cvLoader.prevCvPath = nil

		arg0_87:StopDailogue()
		arg0_87.cvLoader:StopSound()

		arg0_87.exitLoadL2d = true
	end

	if arg0_87.spinePaintingRoot.childCount > 0 then
		setActive(arg0_87.commonPainting, not arg0_87.spinePaintingisOn)
	end
end

function var0_0.DisplaySpinePainting(arg0_88, arg1_88)
	setActive(arg0_88.spinePaintingRoot, arg1_88)
	setActive(arg0_88.spinePaintingBgRoot, arg1_88)
end

function var0_0.willExit(arg0_89)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	SetParent(arg0_89.bottomTF, arg0_89._tf)
	arg0_89:UnOverlayPanel(arg0_89.blurPanel, arg0_89._tf)

	for iter0_89, iter1_89 in ipairs(arg0_89.pages) do
		iter1_89:Destroy()
	end

	if arg0_89.l2dChar then
		arg0_89.l2dChar:Dispose()

		arg0_89.l2dChar = nil
	end

	arg0_89:DestroySpinePainting()
	arg0_89.paintingView:Dispose()
	arg0_89.live2DBtn:Dispose()
	arg0_89.cvLoader:Dispose()
	arg0_89:ReturnModel()
	arg0_89:RecyclePainting()
	_.each(arg0_89.skinBtns or {}, function(arg0_90)
		arg0_90:Dispose()
	end)
	arg0_89:RemoveCvTimer()
	arg0_89:RemoveCvSeTimer()
	arg0_89:RemoveLive2DTimer()
end

return var0_0
