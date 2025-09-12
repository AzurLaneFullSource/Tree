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
	arg0_3.groupSkinList = ShipGroup.GetDisplayableSkinList(arg1_3.id)
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
	arg0_6.bottomTF = arg0_6:findTF("adapt/bottom")
	arg0_6.labelHeart = arg0_6:findTF("adapt/detail_left_panel/heart/label", arg0_6.blurPanel)
	arg0_6.btnLike = arg0_6:findTF("adapt/detail_left_panel/heart/btnLike", arg0_6.blurPanel)
	arg0_6.btnChangeSkin = arg0_6:findTF("adapt/detail_left_panel/change_skin", arg0_6.blurPanel)
	arg0_6.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_6.btnChangeSkin, "toggle_ui"))
	arg0_6.btnLikeAct = arg0_6.btnLike:Find("like")
	arg0_6.btnLikeDisact = arg0_6.btnLike:Find("unlike")
	arg0_6.obtainBtn = arg0_6:findTF("adapt/bottom/others/obtain_btn")
	arg0_6.evaBtn = arg0_6:findTF("adapt/bottom/others/eva_btn")
	arg0_6.viewBtn = arg0_6:findTF("adapt/bottom/others/view_btn")
	arg0_6.shareBtn = arg0_6:findTF("adapt/bottom/others/share_btn")
	arg0_6.rotateBtn = arg0_6:findTF("adapt/bottom/others/rotate_btn")
	arg0_6.cryptolaliaBtn = arg0_6:findTF("adapt/bottom/others/cryptolalia_btn")
	arg0_6.equipCodeBtn = arg0_6:findTF("adapt/bottom/others/equip_code_btn")
	arg0_6.leftProfile = arg0_6:findTF("adapt/profile_left_panel", arg0_6.blurPanel)
	arg0_6.modelContainer = arg0_6:findTF("model", arg0_6.leftProfile)
	arg0_6.live2DBtn = ShipProfileLive2dBtn.New(arg0_6:findTF("L2D_btn", arg0_6.blurPanel))
	arg0_6.l2dBtnOn = false

	GetComponent(arg0_6:findTF("L2D_btn", arg0_6.blurPanel), typeof(Image)):SetNativeSize()
	GetComponent(arg0_6:findTF("L2D_btn/img", arg0_6.blurPanel), typeof(Image)):SetNativeSize()

	arg0_6.spinePaintingBtn = arg0_6:findTF("SP_btn", arg0_6.blurPanel)

	GetComponent(arg0_6.spinePaintingBtn, typeof(Image)):SetNativeSize()
	GetComponent(arg0_6:findTF("SP_btn/img", arg0_6.blurPanel), typeof(Image)):SetNativeSize()
	GetComponent(arg0_6:findTF("adapt/top/title", arg0_6.blurPanel), typeof(Image)):SetNativeSize()

	arg0_6.spinePaintingToggle = arg0_6.spinePaintingBtn:Find("toggle")
	arg0_6.cvLoader = ShipProfileCVLoader.New()
	arg0_6.pageTFs = arg0_6:findTF("adapt/pages")
	arg0_6.paintingView = ShipProfilePaintingView.New(arg0_6._tf, arg0_6.painting)
	arg0_6.toggles = {
		arg0_6:findTF("adapt/bottom/detail"),
		arg0_6:findTF("adapt/bottom/profile")
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
		else
			arg0_8:clearLive2dPainting()
		end

		arg0_8.l2dBtnOn = arg0_17

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
	onButton(arg0_8, arg0_8.btnChangeSkin, function()
		local var0_19 = arg0_8.skin

		if ShipSkin.IsChangeSkin(var0_19.id) then
			local var1_19 = ShipSkin.GetChangeSkinNextId(var0_19.id)
			local var2_19 = pg.ship_skin_template[var1_19]

			arg0_8:showSkinProfile(arg0_8.contextData.skinIndex, var2_19, arg0_8.prevSkinBtn)
		end
	end, SFX_CONFIRM)
	setActive(arg0_8.bottomTF, false)
	triggerToggle(arg0_8.toggles[var0_0.INDEX_DETAIL], true)
end

function var0_0.InitSkinList(arg0_20)
	arg0_20.skinBtns = {}

	arg0_20.UISkinList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = arg0_20.groupSkinList[arg1_21 + 1]
			local var1_21 = ShipProfileSkinBtn.New(arg2_21)

			table.insert(arg0_20.skinBtns, var1_21)
			var1_21:Update(var0_21, arg0_20.shipGroup, table.contains(arg0_20.ownedSkinList, var0_21.id))
			onButton(arg0_20, var1_21._tf, function()
				if not var1_21.unlock then
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_profile_skin_locked"))

					return
				end

				arg0_20:showSkinProfile(arg1_21, var0_21, var1_21)
			end, SFX_PANEL)
			setActive(arg2_21, var0_21.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or not HXSet.isHxSkin())
		end
	end)
	arg0_20.UISkinList:align(#arg0_20.groupSkinList)
end

function var0_0.showSkinProfile(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = ShipSkin.IsChangeSkin(arg2_23.id)

	setActive(arg0_23.btnChangeSkin, var0_23)

	if var0_23 then
		arg0_23.changeSkinToggle:setSkinData(arg2_23.id)
	end

	arg0_23.contextData.skinIndex = arg1_23 + 1

	arg0_23:ShiftSkin(arg2_23)

	if arg0_23.prevSkinBtn then
		arg0_23.prevSkinBtn:UnShift()
	end

	arg3_23:Shift()

	arg0_23.prevSkinBtn = arg3_23
end

function var0_0.InitCommon(arg0_24)
	arg0_24:LoadSkinBg(arg0_24.shipGroup:rarity2bgPrintForGet(arg0_24.showTrans))
	setImageSprite(arg0_24.shipType, GetSpriteFromAtlas("shiptype", arg0_24.shipGroup:getShipType(arg0_24.showTrans)))

	arg0_24.labelName.text = arg0_24.shipGroup:getName(arg0_24.showTrans)

	local var0_24 = arg0_24.shipGroup.shipConfig

	arg0_24.labelEnName.text = var0_24.english_name

	for iter0_24 = 1, var0_24.star do
		cloneTplTo(arg0_24.star, arg0_24.stars)
	end

	arg0_24:FlushHearts()

	local var1_24 = arg0_24.shipGroup:GetSkin(arg0_24.showTrans).id

	arg0_24:SetPainting(var1_24, arg0_24.showTrans)
end

function var0_0.SetPainting(arg0_25, arg1_25, arg2_25)
	arg0_25:RecyclePainting()

	if arg2_25 and arg0_25.shipGroup.trans then
		arg1_25 = arg0_25.shipGroup.groupConfig.trans_skin
	end

	local var0_25 = pg.ship_skin_template[arg1_25].painting

	setPaintingPrefabAsync(arg0_25.painting, var0_25, "chuanwu", function()
		setActive(arg0_25.commonPainting, true)
	end)

	arg0_25.paintingName = var0_25

	arg0_25:UpdateCryptolaliaBtn(arg1_25)
end

function var0_0.RecyclePainting(arg0_27)
	if arg0_27.paintingName then
		retPaintingPrefab(arg0_27.painting, arg0_27.paintingName)
	end
end

function var0_0.FlushHearts(arg0_28)
	local var0_28 = arg0_28.shipGroup.hearts

	setText(arg0_28.labelHeart, var0_28 > 999 and "999+" or var0_28)

	arg0_28.labelHeart:GetComponent("Text").color = arg0_28.shipGroup.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

	setActive(arg0_28.btnLikeDisact, not arg0_28.shipGroup.iheart)
	setActive(arg0_28.btnLikeAct, arg0_28.shipGroup.iheart)
end

function var0_0.LoadSkinBg(arg0_29, arg1_29)
	arg0_29.bluePintBg = arg0_29.isBluePrintGroup and arg0_29.shipGroup:rarity2bgPrintForGet(arg0_29.showTrans)
	arg0_29.metaMainBg = arg0_29.isMetaGroup and arg0_29.shipGroup:rarity2bgPrintForGet(arg0_29.showTrans)

	if arg0_29.shipSkinBg ~= arg1_29 then
		arg0_29.shipSkinBg = arg1_29

		local function var0_29(arg0_30)
			rtf(arg0_30).localPosition = Vector3(0, 0, 200)
		end

		local function var1_29()
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg0_29.shipGroup:getRarity(arg0_29.showTrans), true, function(arg0_32)
				arg0_29.designBg = arg0_32
				arg0_29.designName = "raritydesign" .. arg0_29.shipGroup:getRarity(arg0_29.showTrans)

				arg0_32.transform:SetParent(arg0_29.staticBg, false)

				arg0_32.transform.localPosition = Vector3(1, 1, 1)
				arg0_32.transform.localScale = Vector3(1, 1, 1)

				arg0_32.transform:SetSiblingIndex(1)

				local var0_32 = arg0_32:GetComponent("Canvas")

				if var0_32 then
					var0_32.sortingOrder = LayerWeightConst.PAINTING_RARITY_DESIGN_LAYER
				end

				setActive(arg0_32, true)
			end)
		end

		local function var2_29()
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg0_29.shipGroup:getRarity(arg0_29.showTrans), true, function(arg0_34)
				arg0_29.metaBg = arg0_34
				arg0_29.metaName = "raritymeta" .. arg0_29.shipGroup:getRarity(arg0_29.showTrans)

				arg0_34.transform:SetParent(arg0_29.staticBg, false)

				arg0_34.transform.localPosition = Vector3(1, 1, 1)
				arg0_34.transform.localScale = Vector3(1, 1, 1)

				arg0_34.transform:SetSiblingIndex(1)
				setActive(arg0_34, true)
			end)
		end

		local function var3_29(arg0_35)
			if arg0_29.bluePintBg and arg1_29 == arg0_29.bluePintBg then
				if arg0_29.metaBg then
					setActive(arg0_29.metaBg, false)
				end

				if arg0_29.designBg and arg0_29.designName ~= "raritydesign" .. arg0_29.shipGroup:getRarity(arg0_29.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0_29.designName, arg0_29.designBg)

					arg0_29.designBg = nil
				end

				if not arg0_29.designBg then
					var1_29()
				else
					setActive(arg0_29.designBg, true)
				end
			elseif arg0_29.metaMainBg and arg1_29 == arg0_29.metaMainBg then
				if arg0_29.designBg then
					setActive(arg0_29.designBg, false)
				end

				if arg0_29.metaBg and arg0_29.metaName ~= "raritymeta" .. arg0_29.shipGroup:getRarity(arg0_29.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0_29.metaName, arg0_29.metaBg)

					arg0_29.metaBg = nil
				end

				if not arg0_29.metaBg then
					var2_29()
				else
					setActive(arg0_29.metaBg, true)
				end
			else
				if arg0_29.designBg then
					setActive(arg0_29.designBg, false)
				end

				if arg0_29.metaBg then
					setActive(arg0_29.metaBg, false)
				end
			end
		end

		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_29, arg1_29, arg0_29.bg, arg0_29.staticBg, var0_29, var3_29)
	end
end

function var0_0.SwitchPage(arg0_36, arg1_36)
	if arg0_36.index ~= arg1_36 then
		seriesAsync({
			function(arg0_37)
				pg.UIMgr.GetInstance():OverlayPanel(arg0_36.blurPanel, {
					groupName = LayerWeightConst.GROUP_SHIP_PROFILE
				})
				arg0_37()
			end,
			function(arg0_38)
				local var0_38 = arg0_36.pages[arg1_36]
				local var1_38 = arg1_36 == var0_0.INDEX_PROFILE and not var0_38:GetLoaded()

				var0_38:ExecuteAction("Update", arg0_36.shipGroup, arg0_36.showTrans, function()
					if var1_38 then
						arg0_36:InitSkinList()
					end

					arg0_38()
				end)
			end,
			function(arg0_40)
				if not arg0_36.index then
					arg0_40()

					return
				end

				arg0_36.pages[arg0_36.index]:ExecuteAction("ExistAnim", var1_0)
				arg0_40()
			end,
			function(arg0_41)
				local var0_41 = arg0_36.pages[arg1_36]

				SetParent(arg0_36.bottomTF, var0_41._tf)
				setActive(arg0_36.bottomTF, true)
				setAnchoredPosition(arg0_36.bottomTF, {
					z = 0,
					x = -7,
					y = 24
				})
				var0_41:ExecuteAction("EnterAnim", var1_0)
				arg0_36:TweenPage(arg1_36)
				arg0_41()
			end,
			function(arg0_42)
				arg0_36.index = arg1_36

				local var0_42 = arg0_36.contextData.skinIndex or 1

				if arg1_36 == var0_0.INDEX_PROFILE and var0_42 <= #arg0_36.skinBtns then
					triggerButton(arg0_36.skinBtns[var0_42]._tf)
				end
			end
		})
	end
end

function var0_0.TweenPage(arg0_43, arg1_43)
	if arg1_43 == var0_0.INDEX_DETAIL then
		LeanTween.moveX(rtf(arg0_43.leftProfile), -700, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_43.live2DBtn._tf), -70, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_43.spinePaintingBtn), -70, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_43.painting), arg0_43.paintingInitPos.x, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_43.name), arg0_43.nameInitPos.x, var1_0):setEase(LeanTweenType.easeInOutSine)
	elseif arg1_43 == var0_0.INDEX_PROFILE then
		LeanTween.moveX(rtf(arg0_43.leftProfile), 0, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_43.live2DBtn._tf), 60, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_43.spinePaintingBtn), 60, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_43.painting), arg0_43.paintingInitPos.x + 50, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_43.name), arg0_43.nameInitPos.x + 50, var1_0):setEase(LeanTweenType.easeInOutSine)
	end
end

function var0_0.ShiftSkin(arg0_44, arg1_44)
	if arg0_44.index ~= var0_0.INDEX_PROFILE or arg0_44.skin and arg1_44.id == arg0_44.skin.id then
		return
	end

	arg0_44.skin = arg1_44

	arg0_44:SetPainting(arg1_44.id, false)
	arg0_44:LoadModel(arg1_44)
	arg0_44.live2DBtn:Disable()
	arg0_44.live2DBtn:Update(arg0_44.paintingName, false)

	local var0_44
	local var1_44 = arg1_44 and arg1_44.spine_use_live2d == 1 and "spine_painting_bg" or "live2d_bg"

	LoadSpriteAtlasAsync("ui/share/btn_l2d_atlas", var1_44, function(arg0_45)
		GetComponent(arg0_44:findTF("L2D_btn", arg0_44.blurPanel), typeof(Image)).sprite = arg0_45
		GetComponent(arg0_44:findTF("L2D_btn/img", arg0_44.blurPanel), typeof(Image)).sprite = arg0_45

		GetComponent(arg0_44:findTF("L2D_btn", arg0_44.blurPanel), typeof(Image)):SetNativeSize()
		GetComponent(arg0_44:findTF("L2D_btn/img", arg0_44.blurPanel), typeof(Image)):SetNativeSize()
	end)

	arg0_44.spinePaintingisOn = false

	arg0_44:updateSpinePaintingState()
	arg0_44:DestroySpinePainting()
	arg0_44.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg1_44, false)

	local var2_44
	local var3_44 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_44.skin.painting, 0) == 0

	if arg0_44.skin.bg_sp and arg0_44.skin.bg_sp ~= "" and var3_44 then
		var2_44 = arg0_44.skin.bg_sp
	elseif arg0_44.skin.bg and arg0_44.skin.bg ~= "" then
		var2_44 = arg0_44.skin.bg
	else
		var2_44 = arg0_44.shipGroup:rarity2bgPrintForGet(arg0_44.showTrans, arg0_44.skin.id)
	end

	arg0_44:LoadSkinBg(var2_44)

	arg0_44.haveOp = checkABExist("ui/skinunlockanim/star_level_unlock_anim_" .. arg0_44.skin.id)
end

function var0_0.UpdateCryptolaliaBtn(arg0_46, arg1_46)
	local var0_46 = ShipSkin.New({
		id = arg1_46
	}):getConfig("ship_group")

	setActive(arg0_46.cryptolaliaBtn, getProxy(PlayerProxy):getRawData():ExistCryptolalia(var0_46))
end

function var0_0.LoadModel(arg0_47, arg1_47)
	if arg0_47.inLoading then
		return
	end

	arg0_47:ReturnModel()

	local var0_47 = arg1_47.prefab

	arg0_47.inLoading = true

	PoolMgr.GetInstance():GetSpineChar(var0_47, true, function(arg0_48)
		arg0_47.inLoading = false
		arg0_48.name = var0_47
		arg0_48.transform.localPosition = Vector3.zero
		arg0_48.transform.localScale = Vector3(0.8, 0.8, 1)

		arg0_48.transform:SetParent(arg0_47.modelContainer, false)
		arg0_48:GetComponent(typeof(SpineAnimUI)):SetAction(arg1_47.show_skin or "stand", 0)

		arg0_47.characterModel = arg0_48
		arg0_47.modelName = var0_47
	end)
end

function var0_0.ReturnModel(arg0_49)
	if not IsNil(arg0_49.characterModel) then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_49.modelName, arg0_49.characterModel)
	end
end

function var0_0.CreateLive2D(arg0_50)
	arg0_50.live2DBtn:SetEnable(false)

	if arg0_50.l2dChar then
		arg0_50.l2dChar:Dispose()

		arg0_50.l2dChar = nil
	end

	local var0_50 = arg0_50.shipGroup:getShipConfigId()
	local var1_50 = pg.ship_skin_template[arg0_50.skin.id].live2d_offset_profile
	local var2_50

	if var1_50 and #var1_50 >= 3 then
		local var3_50 = var1_50
	else
		local var4_50 = {
			0,
			0,
			0,
			52
		}
	end

	local var5_50 = Live2D.GenerateData({
		ship = Ship.New({
			noChangeSkin = true,
			configId = var0_50,
			skin_id = arg0_50.skin.id,
			propose = arg0_50.shipGroup.married
		}),
		position = Vector3(0, 0, 0),
		offset = var1_50,
		parent = arg0_50.l2dRoot
	})

	arg0_50.l2dChar = Live2D.New(var5_50, function(arg0_51)
		arg0_51:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
		arg0_50.live2DBtn:SetEnable(true)
	end)

	if isHalfBodyLive2D(arg0_50.skin.prefab) then
		setAnchoredPosition(arg0_50.l2dRoot, {
			y = -77 - (arg0_50.painting.rect.height - arg0_50.l2dRoot.rect.height * 1.5) / 2
		})
	else
		setAnchoredPosition(arg0_50.l2dRoot, {
			y = -40
		})
	end

	if Live2dConst.UnLoadL2dPating then
		Live2dConst.UnLoadL2dPating()
	end
end

function var0_0.GetModelAction(arg0_52, arg1_52)
	local var0_52

	if not arg1_52.spine_action or arg1_52.spine_action == "" then
		return "stand"
	else
		return arg1_52.spine_action
	end
end

function var0_0.OnCVBtnClick(arg0_53, arg1_53)
	if arg0_53.l2dActioning then
		return
	end

	local var0_53 = arg1_53.voice

	local function var1_53()
		local var0_54

		if arg1_53:isEx() then
			local var1_54 = var0_53.l2d_action .. "_ex"

			if arg0_53.l2dChar and arg0_53.l2dChar:checkActionExist(var1_54) then
				var0_54 = var1_54
			else
				var0_54 = var0_53.l2d_action
			end
		else
			var0_54 = var0_53.l2d_action
		end

		if arg0_53.l2dBtnOn and arg0_53.l2dChar and not arg0_53.l2dChar:enablePlayAction(var0_54) then
			return
		end

		arg0_53:UpdatePaintingFace(arg1_53)

		if arg0_53.characterModel then
			local var2_54 = arg0_53:GetModelAction(var0_53)

			arg0_53.characterModel:GetComponent(typeof(SpineAnimUI)):SetAction(var2_54, 0)
		end

		local var3_54 = {
			var0_0.CHAT_SHOW_TIME
		}

		if arg0_53.live2DBtn.isOn and arg0_53.l2dChar then
			if arg0_53.l2dChar:IsLoaded() then
				arg0_53.l2dActioning = true

				if not arg1_53:L2dHasEvent() then
					parallelAsync({
						function(arg0_55)
							arg0_53:RemoveLive2DTimer()

							arg0_53.l2dActioning = arg0_53.l2dChar:TriggerAction(var0_54, arg0_55)
						end,
						function(arg0_56)
							arg0_53:PlayVoice(arg1_53, var3_54)
							arg0_53:ShowDailogue(arg1_53, var3_54, arg0_56)
						end
					}, function()
						arg0_53.l2dActioning = false
					end)
				else
					seriesAsync({
						function(arg0_58)
							arg0_53:RemoveLive2DTimer()

							if arg0_53.l2dChar:checkActionExist(var0_54) then
								arg0_53.l2dActioning = arg0_53.l2dChar:TriggerAction(var0_54, arg0_58, nil, function(arg0_59)
									arg0_53:PlayVoice(arg1_53, var3_54)
									arg0_53:ShowDailogue(arg1_53, var3_54, arg0_58)
								end)
							else
								arg0_53:PlayVoice(arg1_53, var3_54)
								arg0_53:ShowDailogue(arg1_53, var3_54, arg0_58)
							end
						end
					}, function()
						arg0_53.l2dActioning = false
					end)
				end
			end
		else
			arg0_53:PlayVoice(arg1_53, var3_54)
			arg0_53:ShowDailogue(arg1_53, var3_54)
		end
	end

	if var0_53.key == "unlock" and arg0_53.haveOp then
		arg0_53:playOpening(var1_53)
	elseif arg1_53.voice.resource_key == "get" then
		local var2_53 = arg1_53.skin.id

		if PaintingShowScene.GetSkinShowAble(var2_53) then
			arg0_53:emit(ShipProfileMediator.OPEN_PAINTING_SHOW, var2_53, function()
				onNextTick(function()
					var1_53()
				end)
			end)
		else
			var1_53()
		end
	else
		var1_53()
	end
end

function var0_0.UpdatePaintingFace(arg0_63, arg1_63)
	local var0_63 = arg1_63.wordData
	local var1_63 = var0_63.mainIndex ~= nil
	local var2_63 = arg1_63.voice.key

	if var1_63 then
		var2_63 = "main_" .. var0_63.mainIndex
	end

	if arg0_63.paintingFitter.childCount > 0 then
		ShipExpressionHelper.SetExpression(arg0_63.paintingFitter:GetChild(0), arg0_63.paintingName, var2_63, var0_63.maxfavor, arg1_63.skin.id)
	end

	if arg0_63.spinePainting then
		local var3_63 = ShipExpressionHelper.GetExpression(arg0_63.paintingName, var2_63, var0_63.maxfavor, arg1_63.skin.id)

		if var3_63 ~= "" then
			arg0_63.spinePainting:SetAction(var3_63, 1)
		else
			arg0_63.spinePainting:SetEmptyAction(1)
		end
	end
end

function var0_0.PlayVoice(arg0_64, arg1_64, arg2_64)
	local var0_64 = arg1_64.wordData
	local var1_64 = arg1_64.skin
	local var2_64 = arg1_64.words

	arg0_64:RemoveCvTimer()

	if not var0_64.cvPath or var0_64.cvPath == "" then
		return
	end

	if var2_64.voice_key >= ShipWordHelper.CV_KEY_REPALCE or var2_64.voice_key_2 >= ShipWordHelper.CV_KEY_REPALCE or var2_64.voice_key == ShipWordHelper.CV_KEY_BAN_NEW then
		local var3_64 = 0

		if arg1_64.isLive2d and arg0_64.l2dChar and var0_64.voiceCalibrate then
			var3_64 = var0_64.voiceCalibrate
		end

		arg0_64.cvLoader:DelayPlaySound(var0_64.cvPath, var3_64, function(arg0_65)
			if arg0_65 then
				arg2_64[1] = long2int(arg0_65.length) * 0.001
			end
		end)
	end

	local var4_64 = var0_64.se

	if arg1_64.isLive2d and arg0_64.l2dChar and var4_64 then
		arg0_64.cvLoader:RawPlaySound("event:/ui/" .. var4_64[1], var4_64[2])
	end
end

function var0_0.RemoveCvSeTimer(arg0_66)
	if arg0_66.cvSeTimer then
		arg0_66.cvSeTimer:Stop()

		arg0_66.cvSeTimer = nil
	end
end

function var0_0.RemoveCvTimer(arg0_67)
	if arg0_67.cvTimer then
		arg0_67.cvTimer:Stop()

		arg0_67.cvTimer = nil
	end
end

function var0_0.RemoveLive2DTimer(arg0_68)
	if arg0_68.Live2DTimer then
		LeanTween.cancel(arg0_68.Live2DTimer)

		arg0_68.Live2DTimer = nil
	end
end

function var0_0.ShowDailogue(arg0_69, arg1_69, arg2_69, arg3_69)
	arg0_69.dailogueCallback = arg3_69 or function()
		return
	end

	local var0_69 = arg1_69.wordData.textContent

	if not var0_69 or var0_69 == "" or var0_69 == "nil" then
		if arg0_69.dailogueCallback then
			arg0_69.dailogueCallback()

			arg0_69.dailogueCallback = nil
		end

		return
	end

	local var1_69 = arg1_69.wordData.voiceCalibrate
	local var2_69 = arg0_69.chatText:GetComponent(typeof(Text))

	setText(arg0_69.chatText, SwitchSpecialChar(var0_69))

	var2_69.alignment = #var2_69.text > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	local var3_69 = var2_69.preferredHeight + 120

	arg0_69.chatBg.sizeDelta = var3_69 > arg0_69.initChatBgH and Vector2.New(arg0_69.chatBg.sizeDelta.x, var3_69) or Vector2.New(arg0_69.chatBg.sizeDelta.x, arg0_69.initChatBgH)

	arg0_69:StopDailogue()
	setActive(arg0_69.chatTF, true)
	LeanTween.scale(rtf(arg0_69.chatTF.gameObject), Vector3.New(1, 1, 1), var0_0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeOutBack):setDelay(var1_69 and var1_69 or 0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_69.chatTF.gameObject), Vector3.New(0, 0, 1), var0_0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeInBack):setDelay(var0_0.CHAT_ANIMATION_TIME + arg2_69[1]):setOnComplete(System.Action(function()
			if arg0_69.dailogueCallback then
				arg0_69.dailogueCallback()

				arg0_69.dailogueCallback = nil
			end

			if arg0_69.spinePainting then
				arg0_69.spinePainting:SetEmptyAction(1)
			end
		end))
	end))
end

function var0_0.StopDailogue(arg0_73)
	LeanTween.cancel(arg0_73.chatTF.gameObject)

	arg0_73.chatTF.localScale = Vector3(0, 0)
end

function var0_0.onBackPressed(arg0_74)
	if arg0_74.paintingView.isPreview then
		arg0_74.paintingView:Finish(true)

		return
	end

	triggerButton(arg0_74.btnBack)
end

function var0_0.playOpening(arg0_75, arg1_75)
	local var0_75 = "star_level_unlock_anim_" .. arg0_75.skin.id

	if checkABExist("ui/skinunlockanim/" .. var0_75) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1_75 then
				arg1_75()
			end
		end, "ui/skinunlockanim", var0_75, true, false, nil)
	elseif arg1_75 then
		arg1_75()
	end
end

function var0_0.updateSpinePaintingState(arg0_78)
	local var0_78 = HXSet.autoHxShiftPath("spinepainting/" .. arg0_78.paintingName)

	if checkABExist(var0_78) then
		setActive(arg0_78.spinePaintingBtn, true)
		setActive(arg0_78.spinePaintingToggle:Find("on"), arg0_78.spinePaintingisOn)
		setActive(arg0_78.spinePaintingToggle:Find("off"), not arg0_78.spinePaintingisOn)
		removeOnButton(arg0_78.spinePaintingBtn)
		onButton(arg0_78, arg0_78.spinePaintingBtn, function()
			arg0_78.spinePaintingisOn = not arg0_78.spinePaintingisOn

			setActive(arg0_78.spinePaintingToggle:Find("on"), arg0_78.spinePaintingisOn)
			setActive(arg0_78.spinePaintingToggle:Find("off"), not arg0_78.spinePaintingisOn)

			if arg0_78.spinePaintingisOn then
				arg0_78:CreateSpinePainting()
			end

			setActive(arg0_78.viewBtn, not arg0_78.spinePaintingisOn)
			setActive(arg0_78.rotateBtn, not arg0_78.spinePaintingisOn)
			setActive(arg0_78.commonPainting, not arg0_78.spinePaintingisOn)
			setActive(arg0_78.spinePaintingRoot, arg0_78.spinePaintingisOn)
			setActive(arg0_78.spinePaintingBgRoot, arg0_78.spinePaintingisOn)
			arg0_78:StopDailogue()

			if arg0_78.skin then
				arg0_78.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg0_78.skin, false)
			end
		end, SFX_PANEL)
	else
		setActive(arg0_78.spinePaintingBtn, false)
	end
end

function var0_0.CreateSpinePainting(arg0_80)
	if arg0_80.skin.id ~= arg0_80.preSkinId then
		arg0_80:DestroySpinePainting()

		local var0_80 = arg0_80.shipGroup:getShipConfigId()
		local var1_80 = SpinePainting.GenerateData({
			ship = Ship.New({
				noChangeSkin = true,
				configId = var0_80,
				skin_id = arg0_80.skin.id
			}),
			position = Vector3(0, 0, 0),
			parent = arg0_80.spinePaintingRoot,
			offset = pg.ship_skin_template[arg0_80.skin.id].spine_offset_profile,
			effectParent = arg0_80.spinePaintingBgRoot
		})

		arg0_80.spinePainting = SpinePainting.New(var1_80, function()
			return
		end)
		arg0_80.preSkinId = arg0_80.skin.id
	end

	arg0_80:DisplaySpinePainting(true)
end

function var0_0.clearLive2dPainting(arg0_82)
	if arg0_82.l2dChar then
		arg0_82.l2dChar:Dispose()

		arg0_82.l2dChar = nil
		arg0_82.l2dActioning = false
		arg0_82.cvLoader.prevCvPath = nil

		arg0_82:StopDailogue()
		arg0_82.cvLoader:StopSound()
	end
end

function var0_0.DestroySpinePainting(arg0_83)
	if arg0_83.spinePainting then
		arg0_83.spinePainting:Dispose()

		arg0_83.spinePainting = nil
	end

	arg0_83.preSkinId = nil
end

function var0_0.onWeddingReview(arg0_84, arg1_84)
	if not arg1_84 and arg0_84.exitLoadL2d then
		arg0_84.exitLoadL2d = false

		arg0_84.live2DBtn:Update(arg0_84.paintingName, true)
	else
		arg0_84.live2DBtn:Update(arg0_84.paintingName, false)
	end

	arg0_84.live2DBtn:SetEnable(not arg1_84)

	if arg0_84.l2dChar and arg1_84 then
		arg0_84.l2dChar:Dispose()

		arg0_84.l2dChar = nil
		arg0_84.l2dActioning = false
		arg0_84.cvLoader.prevCvPath = nil

		arg0_84:StopDailogue()
		arg0_84.cvLoader:StopSound()

		arg0_84.exitLoadL2d = true
	end

	if arg0_84.spinePaintingRoot.childCount > 0 then
		setActive(arg0_84.commonPainting, not arg0_84.spinePaintingisOn)
	end
end

function var0_0.DisplaySpinePainting(arg0_85, arg1_85)
	setActive(arg0_85.spinePaintingRoot, arg1_85)
	setActive(arg0_85.spinePaintingBgRoot, arg1_85)
end

function var0_0.willExit(arg0_86)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	SetParent(arg0_86.bottomTF, arg0_86._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_86.blurPanel, arg0_86._tf)

	for iter0_86, iter1_86 in ipairs(arg0_86.pages) do
		iter1_86:Destroy()
	end

	if arg0_86.l2dChar then
		arg0_86.l2dChar:Dispose()

		arg0_86.l2dChar = nil
	end

	arg0_86:DestroySpinePainting()
	arg0_86.paintingView:Dispose()
	arg0_86.live2DBtn:Dispose()
	arg0_86.cvLoader:Dispose()
	arg0_86:ReturnModel()
	arg0_86:RecyclePainting()
	_.each(arg0_86.skinBtns or {}, function(arg0_87)
		arg0_87:Dispose()
	end)
	arg0_86:RemoveCvTimer()
	arg0_86:RemoveCvSeTimer()
	arg0_86:RemoveLive2DTimer()
end

return var0_0
