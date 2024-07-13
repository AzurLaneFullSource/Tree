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

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(CollectionProxy):getShipGroup(arg0_2.contextData.groupId)

	LoadSpriteAtlasAsync("bg/star_level_bg_" .. var0_2:rarity2bgPrintForGet(arg0_2.showTrans), "", arg1_2)
end

function var0_0.setShipGroup(arg0_3, arg1_3)
	arg0_3.shipGroup = arg1_3
	arg0_3.groupSkinList = arg1_3:getDisplayableSkinList()
	arg0_3.isBluePrintGroup = arg0_3.shipGroup:isBluePrintGroup()
	arg0_3.isMetaGroup = arg0_3.shipGroup:isMetaGroup()
end

function var0_0.setShowTrans(arg0_4, arg1_4)
	arg0_4.showTrans = arg1_4
end

function var0_0.setOwnedSkinList(arg0_5, arg1_5)
	arg0_5.ownedSkinList = arg1_5
end

function var0_0.init(arg0_6)
	arg0_6.bg = arg0_6:findTF("bg")
	arg0_6.staticBg = arg0_6.bg:Find("static_bg")
	arg0_6.painting = arg0_6:findTF("paint")
	arg0_6.paintingFitter = findTF(arg0_6.painting, "fitter")
	arg0_6.paintingInitPos = arg0_6.painting.transform.localPosition
	arg0_6.chatTF = arg0_6:findTF("paint/chat")

	setActive(arg0_6.chatTF, false)

	arg0_6.commonPainting = arg0_6.painting:Find("fitter")
	arg0_6.l2dRoot = arg0_6:findTF("live2d", arg0_6.painting)
	arg0_6.spinePaintingRoot = arg0_6:findTF("spinePainting", arg0_6.painting)
	arg0_6.spinePaintingBgRoot = arg0_6:findTF("paintBg/spinePainting")
	arg0_6.chatBg = arg0_6:findTF("chatbgtop", arg0_6.chatTF)
	arg0_6.initChatBgH = arg0_6.chatBg.sizeDelta.y
	arg0_6.chatText = arg0_6:findTF("Text", arg0_6.chatBg)
	arg0_6.name = arg0_6:findTF("name")
	arg0_6.nameInitPos = arg0_6.name.transform.localPosition
	arg0_6.shipType = arg0_6:findTF("type", arg0_6.name)
	arg0_6.labelName = arg0_6:findTF("name_mask/Text", arg0_6.name):GetComponent(typeof(Text))
	arg0_6.labelEnName = arg0_6:findTF("english_name", arg0_6.name):GetComponent(typeof(Text))
	arg0_6.stars = arg0_6:findTF("stars", arg0_6.name)
	arg0_6.star = arg0_6:getTpl("star_tpl", arg0_6.stars)
	arg0_6.blurPanel = arg0_6:findTF("blur_panel")
	arg0_6.top = arg0_6:findTF("blur_panel/adapt/top")
	arg0_6.btnBack = arg0_6:findTF("back", arg0_6.top)
	arg0_6.bottomTF = arg0_6:findTF("bottom")
	arg0_6.labelHeart = arg0_6:findTF("adapt/detail_left_panel/heart/label", arg0_6.blurPanel)
	arg0_6.btnLike = arg0_6:findTF("adapt/detail_left_panel/heart/btnLike", arg0_6.blurPanel)
	arg0_6.btnLikeAct = arg0_6.btnLike:Find("like")
	arg0_6.btnLikeDisact = arg0_6.btnLike:Find("unlike")
	arg0_6.obtainBtn = arg0_6:findTF("bottom/others/obtain_btn")
	arg0_6.evaBtn = arg0_6:findTF("bottom/others/eva_btn")
	arg0_6.viewBtn = arg0_6:findTF("bottom/others/view_btn")
	arg0_6.shareBtn = arg0_6:findTF("bottom/others/share_btn")
	arg0_6.rotateBtn = arg0_6:findTF("bottom/others/rotate_btn")
	arg0_6.cryptolaliaBtn = arg0_6:findTF("bottom/others/cryptolalia_btn")
	arg0_6.equipCodeBtn = arg0_6:findTF("bottom/others/equip_code_btn")
	arg0_6.leftProfile = arg0_6:findTF("adapt/profile_left_panel", arg0_6.blurPanel)
	arg0_6.modelContainer = arg0_6:findTF("model", arg0_6.leftProfile)
	arg0_6.live2DBtn = ShipProfileLive2dBtn.New(arg0_6:findTF("L2D_btn", arg0_6.blurPanel))

	GetComponent(arg0_6:findTF("L2D_btn", arg0_6.blurPanel), typeof(Image)):SetNativeSize()
	GetComponent(arg0_6:findTF("L2D_btn/img", arg0_6.blurPanel), typeof(Image)):SetNativeSize()

	arg0_6.spinePaintingBtn = arg0_6:findTF("SP_btn", arg0_6.blurPanel)

	GetComponent(arg0_6.spinePaintingBtn, typeof(Image)):SetNativeSize()
	GetComponent(arg0_6:findTF("SP_btn/img", arg0_6.blurPanel), typeof(Image)):SetNativeSize()
	GetComponent(arg0_6:findTF("adapt/top/title", arg0_6.blurPanel), typeof(Image)):SetNativeSize()

	arg0_6.spinePaintingToggle = arg0_6.spinePaintingBtn:Find("toggle")
	arg0_6.cvLoader = ShipProfileCVLoader.New()
	arg0_6.pageTFs = arg0_6:findTF("pages")
	arg0_6.paintingView = ShipProfilePaintingView.New(arg0_6._tf, arg0_6.painting)
	arg0_6.toggles = {
		arg0_6:findTF("bottom/detail"),
		arg0_6:findTF("bottom/profile")
	}

	local var0_6 = ShipProfileInformationPage.New(arg0_6.pageTFs, arg0_6.event)
	local var1_6 = ShipProfileDetailPage.New(arg0_6.pageTFs, arg0_6.event)

	var0_6:SetCvLoader(arg0_6.cvLoader)
	var0_6:SetCallback(function(arg0_7)
		arg0_6:OnCVBtnClick(arg0_7)
	end)

	arg0_6.pages = {
		var1_6,
		var0_6
	}
	arg0_6.UISkinList = UIItemList.New(arg0_6.leftProfile:Find("scroll/Viewport/skin_container"), arg0_6.leftProfile:Find("scroll/Viewport/skin_container/skin_tpl"))
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.btnBack, function()
		arg0_8:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.equipCodeBtn, function()
		arg0_8:emit(ShipProfileMediator.OPEN_EQUIP_CODE_SHARE, arg0_8.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.cryptolaliaBtn, function()
		arg0_8:emit(ShipProfileMediator.OPEN_CRYPTOLALIA, arg0_8.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.obtainBtn, function()
		local var0_12 = {
			type = MSGBOX_TYPE_OBTAIN,
			shipId = arg0_8.shipGroup:getShipConfigId(),
			list = arg0_8.shipGroup.groupConfig.description,
			mediatorName = ShipProfileMediator.__cname
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_12)
	end)
	onButton(arg0_8, arg0_8.evaBtn, function()
		arg0_8:emit(var0_0.SHOW_EVALUATION, arg0_8.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.viewBtn, function()
		if LeanTween.isTweening(arg0_8.chatTF.gameObject) then
			LeanTween.cancel(arg0_8.chatTF.gameObject)

			arg0_8.chatTF.localScale = Vector3(0, 0, 0)

			if arg0_8.dailogueCallback then
				arg0_8.dailogueCallback()

				arg0_8.dailogueCallback = nil
			end
		end

		arg0_8.paintingView:Start()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeShipProfile)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.rotateBtn, function()
		setActive(arg0_8._tf, false)
		arg0_8:emit(ShipProfileMediator.CLICK_ROTATE_BTN, arg0_8.shipGroup, arg0_8.showTrans, arg0_8.skin)
	end, SFX_PANEL)
	arg0_8.live2DBtn:AddListener(function(arg0_17)
		if arg0_17 then
			arg0_8:CreateLive2D()
		end

		setActive(arg0_8.viewBtn, not arg0_17)
		setActive(arg0_8.rotateBtn, not arg0_17)
		setActive(arg0_8.commonPainting, not arg0_17)
		setActive(arg0_8.l2dRoot, arg0_17)
		arg0_8:StopDailogue()

		arg0_8.l2dActioning = nil

		if arg0_8.skin then
			arg0_8.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg0_8.skin, arg0_17)
		end
	end)

	for iter0_8, iter1_8 in ipairs(arg0_8.toggles) do
		onToggle(arg0_8, iter1_8, function(arg0_18)
			if iter0_8 == var0_0.INDEX_DETAIL then
				arg0_8.live2DBtn:Update(arg0_8.paintingName, false)

				arg0_8.spinePaintingisOn = false

				arg0_8:updateSpinePaintingState()
				arg0_8:DisplaySpinePainting(false)
			end

			if arg0_18 then
				arg0_8:SwitchPage(iter0_8)
			end
		end, SFX_PANEL)
	end

	arg0_8:InitCommon()
	arg0_8.live2DBtn:Update(arg0_8.paintingName, false)
	arg0_8:updateSpinePaintingState()
	setActive(arg0_8.bottomTF, false)
	triggerToggle(arg0_8.toggles[var0_0.INDEX_DETAIL], true)
end

function var0_0.InitSkinList(arg0_19)
	arg0_19.skinBtns = {}

	arg0_19.UISkinList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = arg0_19.groupSkinList[arg1_20 + 1]
			local var1_20 = ShipProfileSkinBtn.New(arg2_20)

			table.insert(arg0_19.skinBtns, var1_20)
			var1_20:Update(var0_20, arg0_19.shipGroup, table.contains(arg0_19.ownedSkinList, var0_20.id))
			onButton(arg0_19, var1_20._tf, function()
				if not var1_20.unlock then
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_profile_skin_locked"))

					return
				end

				arg0_19.contextData.skinIndex = arg1_20 + 1

				arg0_19:ShiftSkin(var0_20)

				if arg0_19.prevSkinBtn then
					arg0_19.prevSkinBtn:UnShift()
				end

				var1_20:Shift()

				arg0_19.prevSkinBtn = var1_20
			end, SFX_PANEL)
			setActive(arg2_20, var0_20.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or not HXSet.isHxSkin())
		end
	end)
	arg0_19.UISkinList:align(#arg0_19.groupSkinList)
end

function var0_0.InitCommon(arg0_22)
	arg0_22:LoadSkinBg(arg0_22.shipGroup:rarity2bgPrintForGet(arg0_22.showTrans))
	setImageSprite(arg0_22.shipType, GetSpriteFromAtlas("shiptype", arg0_22.shipGroup:getShipType(arg0_22.showTrans)))

	arg0_22.labelName.text = arg0_22.shipGroup:getName(arg0_22.showTrans)

	local var0_22 = arg0_22.shipGroup.shipConfig

	arg0_22.labelEnName.text = var0_22.english_name

	for iter0_22 = 1, var0_22.star do
		cloneTplTo(arg0_22.star, arg0_22.stars)
	end

	arg0_22:FlushHearts()

	local var1_22 = arg0_22.shipGroup:GetSkin(arg0_22.showTrans).id

	arg0_22:SetPainting(var1_22, arg0_22.showTrans)
end

function var0_0.SetPainting(arg0_23, arg1_23, arg2_23)
	arg0_23:RecyclePainting()

	if arg2_23 and arg0_23.shipGroup.trans then
		arg1_23 = arg0_23.shipGroup.groupConfig.trans_skin
	end

	local var0_23 = pg.ship_skin_template[arg1_23].painting

	setPaintingPrefabAsync(arg0_23.painting, var0_23, "chuanwu")

	arg0_23.paintingName = var0_23

	arg0_23:UpdateCryptolaliaBtn(arg1_23)
end

function var0_0.RecyclePainting(arg0_24)
	if arg0_24.paintingName then
		retPaintingPrefab(arg0_24.painting, arg0_24.paintingName)
	end
end

function var0_0.FlushHearts(arg0_25)
	local var0_25 = arg0_25.shipGroup.hearts

	setText(arg0_25.labelHeart, var0_25 > 999 and "999+" or var0_25)

	arg0_25.labelHeart:GetComponent("Text").color = arg0_25.shipGroup.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

	setActive(arg0_25.btnLikeDisact, not arg0_25.shipGroup.iheart)
	setActive(arg0_25.btnLikeAct, arg0_25.shipGroup.iheart)
end

function var0_0.LoadSkinBg(arg0_26, arg1_26)
	arg0_26.bluePintBg = arg0_26.isBluePrintGroup and arg0_26.shipGroup:rarity2bgPrintForGet(arg0_26.showTrans)
	arg0_26.metaMainBg = arg0_26.isMetaGroup and arg0_26.shipGroup:rarity2bgPrintForGet(arg0_26.showTrans)

	if arg0_26.shipSkinBg ~= arg1_26 then
		arg0_26.shipSkinBg = arg1_26

		local function var0_26(arg0_27)
			rtf(arg0_27).localPosition = Vector3(0, 0, 200)
		end

		local function var1_26()
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg0_26.shipGroup:getRarity(arg0_26.showTrans), true, function(arg0_29)
				arg0_26.designBg = arg0_29
				arg0_26.designName = "raritydesign" .. arg0_26.shipGroup:getRarity(arg0_26.showTrans)

				arg0_29.transform:SetParent(arg0_26.staticBg, false)

				arg0_29.transform.localPosition = Vector3(1, 1, 1)
				arg0_29.transform.localScale = Vector3(1, 1, 1)

				arg0_29.transform:SetSiblingIndex(1)

				local var0_29 = arg0_29:GetComponent("Canvas")

				if var0_29 then
					var0_29.sortingOrder = -90
				end

				setActive(arg0_29, true)
			end)
		end

		local function var2_26()
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg0_26.shipGroup:getRarity(arg0_26.showTrans), true, function(arg0_31)
				arg0_26.metaBg = arg0_31
				arg0_26.metaName = "raritymeta" .. arg0_26.shipGroup:getRarity(arg0_26.showTrans)

				arg0_31.transform:SetParent(arg0_26.staticBg, false)

				arg0_31.transform.localPosition = Vector3(1, 1, 1)
				arg0_31.transform.localScale = Vector3(1, 1, 1)

				arg0_31.transform:SetSiblingIndex(1)
				setActive(arg0_31, true)
			end)
		end

		local function var3_26(arg0_32)
			if arg0_26.bluePintBg and arg1_26 == arg0_26.bluePintBg then
				if arg0_26.metaBg then
					setActive(arg0_26.metaBg, false)
				end

				if arg0_26.designBg and arg0_26.designName ~= "raritydesign" .. arg0_26.shipGroup:getRarity(arg0_26.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0_26.designName, arg0_26.designBg)

					arg0_26.designBg = nil
				end

				if not arg0_26.designBg then
					var1_26()
				else
					setActive(arg0_26.designBg, true)
				end
			elseif arg0_26.metaMainBg and arg1_26 == arg0_26.metaMainBg then
				if arg0_26.designBg then
					setActive(arg0_26.designBg, false)
				end

				if arg0_26.metaBg and arg0_26.metaName ~= "raritymeta" .. arg0_26.shipGroup:getRarity(arg0_26.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0_26.metaName, arg0_26.metaBg)

					arg0_26.metaBg = nil
				end

				if not arg0_26.metaBg then
					var2_26()
				else
					setActive(arg0_26.metaBg, true)
				end
			else
				if arg0_26.designBg then
					setActive(arg0_26.designBg, false)
				end

				if arg0_26.metaBg then
					setActive(arg0_26.metaBg, false)
				end
			end
		end

		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_26, arg1_26, arg0_26.bg, arg0_26.staticBg, var0_26, var3_26)
	end
end

function var0_0.SwitchPage(arg0_33, arg1_33)
	if arg0_33.index ~= arg1_33 then
		seriesAsync({
			function(arg0_34)
				pg.UIMgr.GetInstance():OverlayPanel(arg0_33.blurPanel, {
					groupName = LayerWeightConst.GROUP_SHIP_PROFILE
				})
				arg0_34()
			end,
			function(arg0_35)
				local var0_35 = arg0_33.pages[arg1_33]
				local var1_35 = arg1_33 == var0_0.INDEX_PROFILE and not var0_35:GetLoaded()

				var0_35:ExecuteAction("Update", arg0_33.shipGroup, arg0_33.showTrans, function()
					if var1_35 then
						arg0_33:InitSkinList()
					end

					arg0_35()
				end)
			end,
			function(arg0_37)
				if not arg0_33.index then
					arg0_37()

					return
				end

				arg0_33.pages[arg0_33.index]:ExecuteAction("ExistAnim", var1_0)
				arg0_37()
			end,
			function(arg0_38)
				local var0_38 = arg0_33.pages[arg1_33]

				SetParent(arg0_33.bottomTF, var0_38._tf)
				setActive(arg0_33.bottomTF, true)
				setAnchoredPosition(arg0_33.bottomTF, {
					z = 0,
					x = -7,
					y = 24
				})
				var0_38:ExecuteAction("EnterAnim", var1_0)
				arg0_33:TweenPage(arg1_33)
				arg0_38()
			end,
			function(arg0_39)
				arg0_33.index = arg1_33

				local var0_39 = arg0_33.contextData.skinIndex or 1

				if arg1_33 == var0_0.INDEX_PROFILE and var0_39 <= #arg0_33.skinBtns then
					triggerButton(arg0_33.skinBtns[var0_39]._tf)
				end
			end
		})
	end
end

function var0_0.TweenPage(arg0_40, arg1_40)
	if arg1_40 == var0_0.INDEX_DETAIL then
		LeanTween.moveX(rtf(arg0_40.leftProfile), -700, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_40.live2DBtn._tf), -70, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_40.spinePaintingBtn), -70, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_40.painting), arg0_40.paintingInitPos.x, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_40.name), arg0_40.nameInitPos.x, var1_0):setEase(LeanTweenType.easeInOutSine)
	elseif arg1_40 == var0_0.INDEX_PROFILE then
		LeanTween.moveX(rtf(arg0_40.leftProfile), 0, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_40.live2DBtn._tf), 60, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_40.spinePaintingBtn), 60, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_40.painting), arg0_40.paintingInitPos.x + 50, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_40.name), arg0_40.nameInitPos.x + 50, var1_0):setEase(LeanTweenType.easeInOutSine)
	end
end

function var0_0.ShiftSkin(arg0_41, arg1_41)
	if arg0_41.index ~= var0_0.INDEX_PROFILE or arg0_41.skin and arg1_41.id == arg0_41.skin.id then
		return
	end

	arg0_41.skin = arg1_41

	arg0_41:LoadModel(arg1_41)
	arg0_41:SetPainting(arg1_41.id, false)
	arg0_41.live2DBtn:Disable()
	arg0_41.live2DBtn:Update(arg0_41.paintingName, false)

	local var0_41
	local var1_41 = arg1_41 and arg1_41.spine_use_live2d == 1 and "spine_painting_bg" or "live2d_bg"

	LoadSpriteAtlasAsync("ui/share/btn_l2d_atlas", var1_41, function(arg0_42)
		GetComponent(arg0_41:findTF("L2D_btn", arg0_41.blurPanel), typeof(Image)).sprite = arg0_42
		GetComponent(arg0_41:findTF("L2D_btn/img", arg0_41.blurPanel), typeof(Image)).sprite = arg0_42

		GetComponent(arg0_41:findTF("L2D_btn", arg0_41.blurPanel), typeof(Image)):SetNativeSize()
		GetComponent(arg0_41:findTF("L2D_btn/img", arg0_41.blurPanel), typeof(Image)):SetNativeSize()
	end)

	arg0_41.spinePaintingisOn = false

	arg0_41:updateSpinePaintingState()
	arg0_41:DestroySpinePainting()
	arg0_41.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg1_41, false)

	local var2_41
	local var3_41 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_41.skin.painting, 0) == 0

	if arg0_41.skin.bg_sp and arg0_41.skin.bg_sp ~= "" and var3_41 then
		var2_41 = arg0_41.skin.bg_sp
	elseif arg0_41.skin.bg and arg0_41.skin.bg ~= "" then
		var2_41 = arg0_41.skin.bg
	else
		var2_41 = arg0_41.shipGroup:rarity2bgPrintForGet(arg0_41.showTrans, arg0_41.skin.id)
	end

	arg0_41:LoadSkinBg(var2_41)

	arg0_41.haveOp = checkABExist("ui/skinunlockanim/star_level_unlock_anim_" .. arg0_41.skin.id)
end

function var0_0.UpdateCryptolaliaBtn(arg0_43, arg1_43)
	local var0_43 = ShipSkin.New({
		id = arg1_43
	}):getConfig("ship_group")

	setActive(arg0_43.cryptolaliaBtn, getProxy(PlayerProxy):getRawData():ExistCryptolalia(var0_43))
end

function var0_0.LoadModel(arg0_44, arg1_44)
	if arg0_44.inLoading then
		return
	end

	arg0_44:ReturnModel()

	local var0_44 = arg1_44.prefab

	arg0_44.inLoading = true

	PoolMgr.GetInstance():GetSpineChar(var0_44, true, function(arg0_45)
		arg0_44.inLoading = false
		arg0_45.name = var0_44
		arg0_45.transform.localPosition = Vector3.zero
		arg0_45.transform.localScale = Vector3(0.8, 0.8, 1)

		arg0_45.transform:SetParent(arg0_44.modelContainer, false)
		arg0_45:GetComponent(typeof(SpineAnimUI)):SetAction(arg1_44.show_skin or "stand", 0)

		arg0_44.characterModel = arg0_45
		arg0_44.modelName = var0_44
	end)
end

function var0_0.ReturnModel(arg0_46)
	if not IsNil(arg0_46.characterModel) then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_46.modelName, arg0_46.characterModel)
	end
end

function var0_0.CreateLive2D(arg0_47)
	arg0_47.live2DBtn:SetEnable(false)

	if arg0_47.l2dChar then
		arg0_47.l2dChar:Dispose()
	end

	local var0_47 = arg0_47.shipGroup:getShipConfigId()
	local var1_47 = pg.ship_skin_template[arg0_47.skin.id].live2d_offset_profile
	local var2_47

	if var1_47 and type(var1_47) ~= "string" then
		var2_47 = Vector3(0 + var1_47[1], -40 + var1_47[2], 100 + var1_47[3])
	else
		var2_47 = Vector3(0, -40, 100)
	end

	local var3_47 = Live2D.GenerateData({
		ship = Ship.New({
			configId = var0_47,
			skin_id = arg0_47.skin.id,
			propose = arg0_47.shipGroup.married
		}),
		scale = Vector3(52, 52, 52),
		position = var2_47,
		parent = arg0_47.l2dRoot
	})

	arg0_47.l2dChar = Live2D.New(var3_47, function()
		arg0_47.live2DBtn:SetEnable(true)
	end)

	if isHalfBodyLive2D(arg0_47.skin.prefab) then
		setAnchoredPosition(arg0_47.l2dRoot, {
			y = -37 - (arg0_47.painting.rect.height - arg0_47.l2dRoot.rect.height * 1.5) / 2
		})
	else
		setAnchoredPosition(arg0_47.l2dRoot, {
			y = 0
		})
	end

	if Live2dConst.UnLoadL2dPating then
		Live2dConst.UnLoadL2dPating()
	end
end

function var0_0.GetModelAction(arg0_49, arg1_49)
	local var0_49

	if not arg1_49.spine_action or arg1_49.spine_action == "" then
		return "stand"
	else
		return arg1_49.spine_action
	end
end

function var0_0.OnCVBtnClick(arg0_50, arg1_50)
	if arg0_50.l2dActioning then
		return
	end

	local var0_50 = arg1_50.voice

	local function var1_50()
		local var0_51

		if arg1_50:isEx() then
			local var1_51 = var0_50.l2d_action .. "_ex"

			if arg0_50.l2dChar and arg0_50.l2dChar:checkActionExist(var1_51) then
				var0_51 = var1_51
			else
				var0_51 = var0_50.l2d_action
			end
		else
			var0_51 = var0_50.l2d_action
		end

		if arg0_50.l2dChar and not arg0_50.l2dChar:enablePlayAction(var0_51) then
			return
		end

		arg0_50:UpdatePaintingFace(arg1_50)

		if arg0_50.characterModel then
			local var2_51 = arg0_50:GetModelAction(var0_50)

			arg0_50.characterModel:GetComponent(typeof(SpineAnimUI)):SetAction(var2_51, 0)
		end

		local var3_51 = {
			var0_0.CHAT_SHOW_TIME
		}

		if arg0_50.live2DBtn.isOn and arg0_50.l2dChar then
			if arg0_50.l2dChar:IsLoaded() then
				arg0_50.l2dActioning = true

				if not arg1_50:L2dHasEvent() then
					parallelAsync({
						function(arg0_52)
							arg0_50:RemoveLive2DTimer()
							arg0_50.l2dChar:TriggerAction(var0_51, arg0_52)
						end,
						function(arg0_53)
							arg0_50:PlayVoice(arg1_50, var3_51)
							arg0_50:ShowDailogue(arg1_50, var3_51, arg0_53)
						end
					}, function()
						arg0_50.l2dActioning = false
					end)
				else
					seriesAsync({
						function(arg0_55)
							arg0_50:RemoveLive2DTimer()
							arg0_50.l2dChar:TriggerAction(var0_51, arg0_55, nil, function(arg0_56)
								arg0_50:PlayVoice(arg1_50, var3_51)
								arg0_50:ShowDailogue(arg1_50, var3_51, arg0_55)
							end)
						end
					}, function()
						arg0_50.l2dActioning = false
					end)
				end
			end
		else
			arg0_50:PlayVoice(arg1_50, var3_51)
			arg0_50:ShowDailogue(arg1_50, var3_51)
		end
	end

	if var0_50.key == "unlock" and arg0_50.haveOp then
		arg0_50:playOpening(var1_50)
	else
		var1_50()
	end
end

function var0_0.UpdatePaintingFace(arg0_58, arg1_58)
	local var0_58 = arg1_58.wordData
	local var1_58 = var0_58.mainIndex ~= nil
	local var2_58 = arg1_58.voice.key

	if var1_58 then
		var2_58 = "main_" .. var0_58.mainIndex
	end

	if arg0_58.paintingFitter.childCount > 0 then
		ShipExpressionHelper.SetExpression(arg0_58.paintingFitter:GetChild(0), arg0_58.paintingName, var2_58, var0_58.maxfavor, arg1_58.skin.id)
	end

	if arg0_58.spinePainting then
		local var3_58 = ShipExpressionHelper.GetExpression(arg0_58.paintingName, var2_58, var0_58.maxfavor, arg1_58.skin.id)

		if var3_58 ~= "" then
			arg0_58.spinePainting:SetAction(var3_58, 1)
		else
			arg0_58.spinePainting:SetEmptyAction(1)
		end
	end
end

function var0_0.PlayVoice(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg1_59.wordData
	local var1_59 = arg1_59.skin
	local var2_59 = arg1_59.words

	arg0_59:RemoveCvTimer()

	if not var0_59.cvPath or var0_59.cvPath == "" then
		return
	end

	if var2_59.voice_key >= ShipWordHelper.CV_KEY_REPALCE or var2_59.voice_key_2 >= ShipWordHelper.CV_KEY_REPALCE or var2_59.voice_key == ShipWordHelper.CV_KEY_BAN_NEW then
		local var3_59 = 0

		if arg1_59.isLive2d and arg0_59.l2dChar and var0_59.voiceCalibrate then
			var3_59 = var0_59.voiceCalibrate
		end

		arg0_59.cvLoader:DelayPlaySound(var0_59.cvPath, var3_59, function(arg0_60)
			if arg0_60 then
				arg2_59[1] = long2int(arg0_60.length) * 0.001
			end
		end)
	end

	local var4_59 = var0_59.se

	if arg1_59.isLive2d and arg0_59.l2dChar and var4_59 then
		arg0_59.cvLoader:RawPlaySound("event:/ui/" .. var4_59[1], var4_59[2])
	end
end

function var0_0.RemoveCvSeTimer(arg0_61)
	if arg0_61.cvSeTimer then
		arg0_61.cvSeTimer:Stop()

		arg0_61.cvSeTimer = nil
	end
end

function var0_0.RemoveCvTimer(arg0_62)
	if arg0_62.cvTimer then
		arg0_62.cvTimer:Stop()

		arg0_62.cvTimer = nil
	end
end

function var0_0.RemoveLive2DTimer(arg0_63)
	if arg0_63.Live2DTimer then
		LeanTween.cancel(arg0_63.Live2DTimer)

		arg0_63.Live2DTimer = nil
	end
end

function var0_0.ShowDailogue(arg0_64, arg1_64, arg2_64, arg3_64)
	arg0_64.dailogueCallback = arg3_64 or function()
		return
	end

	local var0_64 = arg1_64.wordData.textContent

	if not var0_64 or var0_64 == "" or var0_64 == "nil" then
		if arg0_64.dailogueCallback then
			arg0_64.dailogueCallback()

			arg0_64.dailogueCallback = nil
		end

		return
	end

	local var1_64 = arg1_64.wordData.voiceCalibrate
	local var2_64 = arg0_64.chatText:GetComponent(typeof(Text))

	setText(arg0_64.chatText, SwitchSpecialChar(var0_64))

	var2_64.alignment = #var2_64.text > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	local var3_64 = var2_64.preferredHeight + 120

	arg0_64.chatBg.sizeDelta = var3_64 > arg0_64.initChatBgH and Vector2.New(arg0_64.chatBg.sizeDelta.x, var3_64) or Vector2.New(arg0_64.chatBg.sizeDelta.x, arg0_64.initChatBgH)

	arg0_64:StopDailogue()
	setActive(arg0_64.chatTF, true)
	LeanTween.scale(rtf(arg0_64.chatTF.gameObject), Vector3.New(1, 1, 1), var0_0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeOutBack):setDelay(var1_64 and var1_64 or 0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_64.chatTF.gameObject), Vector3.New(0, 0, 1), var0_0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeInBack):setDelay(var0_0.CHAT_ANIMATION_TIME + arg2_64[1]):setOnComplete(System.Action(function()
			if arg0_64.dailogueCallback then
				arg0_64.dailogueCallback()

				arg0_64.dailogueCallback = nil
			end

			if arg0_64.spinePainting then
				arg0_64.spinePainting:SetEmptyAction(1)
			end
		end))
	end))
end

function var0_0.StopDailogue(arg0_68)
	LeanTween.cancel(arg0_68.chatTF.gameObject)

	arg0_68.chatTF.localScale = Vector3(0, 0)
end

function var0_0.onBackPressed(arg0_69)
	if arg0_69.paintingView.isPreview then
		arg0_69.paintingView:Finish(true)

		return
	end

	triggerButton(arg0_69.btnBack)
end

function var0_0.playOpening(arg0_70, arg1_70)
	local var0_70 = "star_level_unlock_anim_" .. arg0_70.skin.id

	if checkABExist("ui/skinunlockanim/" .. var0_70) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1_70 then
				arg1_70()
			end
		end, "ui/skinunlockanim", var0_70, true, false, nil)
	elseif arg1_70 then
		arg1_70()
	end
end

function var0_0.updateSpinePaintingState(arg0_73)
	local var0_73 = HXSet.autoHxShiftPath("spinepainting/" .. arg0_73.paintingName)

	if checkABExist(var0_73) then
		setActive(arg0_73.spinePaintingBtn, true)
		setActive(arg0_73.spinePaintingToggle:Find("on"), arg0_73.spinePaintingisOn)
		setActive(arg0_73.spinePaintingToggle:Find("off"), not arg0_73.spinePaintingisOn)
		removeOnButton(arg0_73.spinePaintingBtn)
		onButton(arg0_73, arg0_73.spinePaintingBtn, function()
			arg0_73.spinePaintingisOn = not arg0_73.spinePaintingisOn

			setActive(arg0_73.spinePaintingToggle:Find("on"), arg0_73.spinePaintingisOn)
			setActive(arg0_73.spinePaintingToggle:Find("off"), not arg0_73.spinePaintingisOn)

			if arg0_73.spinePaintingisOn then
				arg0_73:CreateSpinePainting()
			end

			setActive(arg0_73.viewBtn, not arg0_73.spinePaintingisOn)
			setActive(arg0_73.rotateBtn, not arg0_73.spinePaintingisOn)
			setActive(arg0_73.commonPainting, not arg0_73.spinePaintingisOn)
			setActive(arg0_73.spinePaintingRoot, arg0_73.spinePaintingisOn)
			setActive(arg0_73.spinePaintingBgRoot, arg0_73.spinePaintingisOn)
			arg0_73:StopDailogue()

			if arg0_73.skin then
				arg0_73.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg0_73.skin, false)
			end
		end, SFX_PANEL)
	else
		setActive(arg0_73.spinePaintingBtn, false)
	end
end

function var0_0.CreateSpinePainting(arg0_75)
	if arg0_75.skin.id ~= arg0_75.preSkinId then
		arg0_75:DestroySpinePainting()

		local var0_75 = arg0_75.shipGroup:getShipConfigId()
		local var1_75 = SpinePainting.GenerateData({
			ship = Ship.New({
				configId = var0_75,
				skin_id = arg0_75.skin.id
			}),
			position = Vector3(0, 0, 0),
			parent = arg0_75.spinePaintingRoot,
			effectParent = arg0_75.spinePaintingBgRoot
		})

		arg0_75.spinePainting = SpinePainting.New(var1_75, function()
			return
		end)
		arg0_75.preSkinId = arg0_75.skin.id
	end

	arg0_75:DisplaySpinePainting(true)
end

function var0_0.DestroySpinePainting(arg0_77)
	if arg0_77.spinePainting then
		arg0_77.spinePainting:Dispose()

		arg0_77.spinePainting = nil
	end

	arg0_77.preSkinId = nil
end

function var0_0.onWeddingReview(arg0_78, arg1_78)
	if not arg1_78 and arg0_78.exitLoadL2d then
		arg0_78.exitLoadL2d = false

		arg0_78.live2DBtn:Update(arg0_78.paintingName, true)
	else
		arg0_78.live2DBtn:Update(arg0_78.paintingName, false)
	end

	arg0_78.live2DBtn:SetEnable(not arg1_78)

	if arg0_78.l2dChar and arg1_78 then
		arg0_78.l2dChar:Dispose()

		arg0_78.l2dChar = nil
		arg0_78.l2dActioning = false
		arg0_78.cvLoader.prevCvPath = nil

		arg0_78:StopDailogue()
		arg0_78.cvLoader:StopSound()

		arg0_78.exitLoadL2d = true
	end

	if arg0_78.spinePaintingRoot.childCount > 0 then
		setActive(arg0_78.commonPainting, not arg0_78.spinePaintingisOn)
	end
end

function var0_0.DisplaySpinePainting(arg0_79, arg1_79)
	setActive(arg0_79.spinePaintingRoot, arg1_79)
	setActive(arg0_79.spinePaintingBgRoot, arg1_79)
end

function var0_0.willExit(arg0_80)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	SetParent(arg0_80.bottomTF, arg0_80._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_80.blurPanel, arg0_80._tf)

	for iter0_80, iter1_80 in ipairs(arg0_80.pages) do
		iter1_80:Destroy()
	end

	if arg0_80.l2dChar then
		arg0_80.l2dChar:Dispose()
	end

	arg0_80:DestroySpinePainting()
	arg0_80.paintingView:Dispose()
	arg0_80.live2DBtn:Dispose()
	arg0_80.cvLoader:Dispose()
	arg0_80:ReturnModel()
	arg0_80:RecyclePainting()
	_.each(arg0_80.skinBtns or {}, function(arg0_81)
		arg0_81:Dispose()
	end)
	arg0_80:RemoveCvTimer()
	arg0_80:RemoveCvSeTimer()
	arg0_80:RemoveLive2DTimer()
end

return var0_0
