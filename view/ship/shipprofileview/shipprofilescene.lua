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
	arg0_6.bottomTF = arg0_6:findTF("bottom")
	arg0_6.labelHeart = arg0_6:findTF("adapt/detail_left_panel/heart/label", arg0_6.blurPanel)
	arg0_6.btnLike = arg0_6:findTF("adapt/detail_left_panel/heart/btnLike", arg0_6.blurPanel)
	arg0_6.btnChangeSkin = arg0_6:findTF("adapt/detail_left_panel/change_skin", arg0_6.blurPanel)
	arg0_6.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_6.btnChangeSkin, "toggle_ui"))
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
	onButton(arg0_8, arg0_8.btnChangeSkin, function()
		local var0_19 = arg0_8.skin

		if ShipGroup.IsChangeSkin(var0_19.id) then
			local var1_19 = ShipGroup.GetChangeSkinNextId(var0_19.id)
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
	local var0_23 = ShipGroup.IsChangeSkin(arg2_23.id) and true or false

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

	setPaintingPrefabAsync(arg0_25.painting, var0_25, "chuanwu")

	arg0_25.paintingName = var0_25

	arg0_25:UpdateCryptolaliaBtn(arg1_25)
end

function var0_0.RecyclePainting(arg0_26)
	if arg0_26.paintingName then
		retPaintingPrefab(arg0_26.painting, arg0_26.paintingName)
	end
end

function var0_0.FlushHearts(arg0_27)
	local var0_27 = arg0_27.shipGroup.hearts

	setText(arg0_27.labelHeart, var0_27 > 999 and "999+" or var0_27)

	arg0_27.labelHeart:GetComponent("Text").color = arg0_27.shipGroup.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

	setActive(arg0_27.btnLikeDisact, not arg0_27.shipGroup.iheart)
	setActive(arg0_27.btnLikeAct, arg0_27.shipGroup.iheart)
end

function var0_0.LoadSkinBg(arg0_28, arg1_28)
	arg0_28.bluePintBg = arg0_28.isBluePrintGroup and arg0_28.shipGroup:rarity2bgPrintForGet(arg0_28.showTrans)
	arg0_28.metaMainBg = arg0_28.isMetaGroup and arg0_28.shipGroup:rarity2bgPrintForGet(arg0_28.showTrans)

	if arg0_28.shipSkinBg ~= arg1_28 then
		arg0_28.shipSkinBg = arg1_28

		local function var0_28(arg0_29)
			rtf(arg0_29).localPosition = Vector3(0, 0, 200)
		end

		local function var1_28()
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg0_28.shipGroup:getRarity(arg0_28.showTrans), true, function(arg0_31)
				arg0_28.designBg = arg0_31
				arg0_28.designName = "raritydesign" .. arg0_28.shipGroup:getRarity(arg0_28.showTrans)

				arg0_31.transform:SetParent(arg0_28.staticBg, false)

				arg0_31.transform.localPosition = Vector3(1, 1, 1)
				arg0_31.transform.localScale = Vector3(1, 1, 1)

				arg0_31.transform:SetSiblingIndex(1)

				local var0_31 = arg0_31:GetComponent("Canvas")

				if var0_31 then
					var0_31.sortingOrder = -90
				end

				setActive(arg0_31, true)
			end)
		end

		local function var2_28()
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg0_28.shipGroup:getRarity(arg0_28.showTrans), true, function(arg0_33)
				arg0_28.metaBg = arg0_33
				arg0_28.metaName = "raritymeta" .. arg0_28.shipGroup:getRarity(arg0_28.showTrans)

				arg0_33.transform:SetParent(arg0_28.staticBg, false)

				arg0_33.transform.localPosition = Vector3(1, 1, 1)
				arg0_33.transform.localScale = Vector3(1, 1, 1)

				arg0_33.transform:SetSiblingIndex(1)
				setActive(arg0_33, true)
			end)
		end

		local function var3_28(arg0_34)
			if arg0_28.bluePintBg and arg1_28 == arg0_28.bluePintBg then
				if arg0_28.metaBg then
					setActive(arg0_28.metaBg, false)
				end

				if arg0_28.designBg and arg0_28.designName ~= "raritydesign" .. arg0_28.shipGroup:getRarity(arg0_28.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0_28.designName, arg0_28.designBg)

					arg0_28.designBg = nil
				end

				if not arg0_28.designBg then
					var1_28()
				else
					setActive(arg0_28.designBg, true)
				end
			elseif arg0_28.metaMainBg and arg1_28 == arg0_28.metaMainBg then
				if arg0_28.designBg then
					setActive(arg0_28.designBg, false)
				end

				if arg0_28.metaBg and arg0_28.metaName ~= "raritymeta" .. arg0_28.shipGroup:getRarity(arg0_28.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0_28.metaName, arg0_28.metaBg)

					arg0_28.metaBg = nil
				end

				if not arg0_28.metaBg then
					var2_28()
				else
					setActive(arg0_28.metaBg, true)
				end
			else
				if arg0_28.designBg then
					setActive(arg0_28.designBg, false)
				end

				if arg0_28.metaBg then
					setActive(arg0_28.metaBg, false)
				end
			end
		end

		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_28, arg1_28, arg0_28.bg, arg0_28.staticBg, var0_28, var3_28)
	end
end

function var0_0.SwitchPage(arg0_35, arg1_35)
	if arg0_35.index ~= arg1_35 then
		seriesAsync({
			function(arg0_36)
				pg.UIMgr.GetInstance():OverlayPanel(arg0_35.blurPanel, {
					groupName = LayerWeightConst.GROUP_SHIP_PROFILE
				})
				arg0_36()
			end,
			function(arg0_37)
				local var0_37 = arg0_35.pages[arg1_35]
				local var1_37 = arg1_35 == var0_0.INDEX_PROFILE and not var0_37:GetLoaded()

				var0_37:ExecuteAction("Update", arg0_35.shipGroup, arg0_35.showTrans, function()
					if var1_37 then
						arg0_35:InitSkinList()
					end

					arg0_37()
				end)
			end,
			function(arg0_39)
				if not arg0_35.index then
					arg0_39()

					return
				end

				arg0_35.pages[arg0_35.index]:ExecuteAction("ExistAnim", var1_0)
				arg0_39()
			end,
			function(arg0_40)
				local var0_40 = arg0_35.pages[arg1_35]

				SetParent(arg0_35.bottomTF, var0_40._tf)
				setActive(arg0_35.bottomTF, true)
				setAnchoredPosition(arg0_35.bottomTF, {
					z = 0,
					x = -7,
					y = 24
				})
				var0_40:ExecuteAction("EnterAnim", var1_0)
				arg0_35:TweenPage(arg1_35)
				arg0_40()
			end,
			function(arg0_41)
				arg0_35.index = arg1_35

				local var0_41 = arg0_35.contextData.skinIndex or 1

				if arg1_35 == var0_0.INDEX_PROFILE and var0_41 <= #arg0_35.skinBtns then
					triggerButton(arg0_35.skinBtns[var0_41]._tf)
				end
			end
		})
	end
end

function var0_0.TweenPage(arg0_42, arg1_42)
	if arg1_42 == var0_0.INDEX_DETAIL then
		LeanTween.moveX(rtf(arg0_42.leftProfile), -700, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_42.live2DBtn._tf), -70, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_42.spinePaintingBtn), -70, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_42.painting), arg0_42.paintingInitPos.x, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_42.name), arg0_42.nameInitPos.x, var1_0):setEase(LeanTweenType.easeInOutSine)
	elseif arg1_42 == var0_0.INDEX_PROFILE then
		LeanTween.moveX(rtf(arg0_42.leftProfile), 0, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_42.live2DBtn._tf), 60, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0_42.spinePaintingBtn), 60, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_42.painting), arg0_42.paintingInitPos.x + 50, var1_0):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0_42.name), arg0_42.nameInitPos.x + 50, var1_0):setEase(LeanTweenType.easeInOutSine)
	end
end

function var0_0.ShiftSkin(arg0_43, arg1_43)
	if arg0_43.index ~= var0_0.INDEX_PROFILE or arg0_43.skin and arg1_43.id == arg0_43.skin.id then
		return
	end

	arg0_43.skin = arg1_43

	arg0_43:LoadModel(arg1_43)
	arg0_43:SetPainting(arg1_43.id, false)
	arg0_43.live2DBtn:Disable()
	arg0_43.live2DBtn:Update(arg0_43.paintingName, false)

	local var0_43
	local var1_43 = arg1_43 and arg1_43.spine_use_live2d == 1 and "spine_painting_bg" or "live2d_bg"

	LoadSpriteAtlasAsync("ui/share/btn_l2d_atlas", var1_43, function(arg0_44)
		GetComponent(arg0_43:findTF("L2D_btn", arg0_43.blurPanel), typeof(Image)).sprite = arg0_44
		GetComponent(arg0_43:findTF("L2D_btn/img", arg0_43.blurPanel), typeof(Image)).sprite = arg0_44

		GetComponent(arg0_43:findTF("L2D_btn", arg0_43.blurPanel), typeof(Image)):SetNativeSize()
		GetComponent(arg0_43:findTF("L2D_btn/img", arg0_43.blurPanel), typeof(Image)):SetNativeSize()
	end)

	arg0_43.spinePaintingisOn = false

	arg0_43:updateSpinePaintingState()
	arg0_43:DestroySpinePainting()
	arg0_43.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg1_43, false)

	local var2_43
	local var3_43 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0_43.skin.painting, 0) == 0

	if arg0_43.skin.bg_sp and arg0_43.skin.bg_sp ~= "" and var3_43 then
		var2_43 = arg0_43.skin.bg_sp
	elseif arg0_43.skin.bg and arg0_43.skin.bg ~= "" then
		var2_43 = arg0_43.skin.bg
	else
		var2_43 = arg0_43.shipGroup:rarity2bgPrintForGet(arg0_43.showTrans, arg0_43.skin.id)
	end

	arg0_43:LoadSkinBg(var2_43)

	arg0_43.haveOp = checkABExist("ui/skinunlockanim/star_level_unlock_anim_" .. arg0_43.skin.id)
end

function var0_0.UpdateCryptolaliaBtn(arg0_45, arg1_45)
	local var0_45 = ShipSkin.New({
		id = arg1_45
	}):getConfig("ship_group")

	setActive(arg0_45.cryptolaliaBtn, getProxy(PlayerProxy):getRawData():ExistCryptolalia(var0_45))
end

function var0_0.LoadModel(arg0_46, arg1_46)
	if arg0_46.inLoading then
		return
	end

	arg0_46:ReturnModel()

	local var0_46 = arg1_46.prefab

	arg0_46.inLoading = true

	PoolMgr.GetInstance():GetSpineChar(var0_46, true, function(arg0_47)
		arg0_46.inLoading = false
		arg0_47.name = var0_46
		arg0_47.transform.localPosition = Vector3.zero
		arg0_47.transform.localScale = Vector3(0.8, 0.8, 1)

		arg0_47.transform:SetParent(arg0_46.modelContainer, false)
		arg0_47:GetComponent(typeof(SpineAnimUI)):SetAction(arg1_46.show_skin or "stand", 0)

		arg0_46.characterModel = arg0_47
		arg0_46.modelName = var0_46
	end)
end

function var0_0.ReturnModel(arg0_48)
	if not IsNil(arg0_48.characterModel) then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_48.modelName, arg0_48.characterModel)
	end
end

function var0_0.CreateLive2D(arg0_49)
	arg0_49.live2DBtn:SetEnable(false)

	if arg0_49.l2dChar then
		arg0_49.l2dChar:Dispose()
	end

	local var0_49 = arg0_49.shipGroup:getShipConfigId()
	local var1_49 = pg.ship_skin_template[arg0_49.skin.id].live2d_offset_profile
	local var2_49

	if var1_49 and type(var1_49) ~= "string" then
		var2_49 = Vector3(0 + var1_49[1], -40 + var1_49[2], 100 + var1_49[3])
	else
		var2_49 = Vector3(0, -40, 100)
	end

	local var3_49 = Live2D.GenerateData({
		ship = Ship.New({
			configId = var0_49,
			skin_id = arg0_49.skin.id,
			propose = arg0_49.shipGroup.married
		}),
		scale = Vector3(52, 52, 52),
		position = var2_49,
		parent = arg0_49.l2dRoot
	})

	arg0_49.l2dChar = Live2D.New(var3_49, function()
		arg0_49.live2DBtn:SetEnable(true)
	end)

	if isHalfBodyLive2D(arg0_49.skin.prefab) then
		setAnchoredPosition(arg0_49.l2dRoot, {
			y = -37 - (arg0_49.painting.rect.height - arg0_49.l2dRoot.rect.height * 1.5) / 2
		})
	else
		setAnchoredPosition(arg0_49.l2dRoot, {
			y = 0
		})
	end

	if Live2dConst.UnLoadL2dPating then
		Live2dConst.UnLoadL2dPating()
	end
end

function var0_0.GetModelAction(arg0_51, arg1_51)
	local var0_51

	if not arg1_51.spine_action or arg1_51.spine_action == "" then
		return "stand"
	else
		return arg1_51.spine_action
	end
end

function var0_0.OnCVBtnClick(arg0_52, arg1_52)
	if arg0_52.l2dActioning then
		return
	end

	local var0_52 = arg1_52.voice

	local function var1_52()
		local var0_53

		if arg1_52:isEx() then
			local var1_53 = var0_52.l2d_action .. "_ex"

			if arg0_52.l2dChar and arg0_52.l2dChar:checkActionExist(var1_53) then
				var0_53 = var1_53
			else
				var0_53 = var0_52.l2d_action
			end
		else
			var0_53 = var0_52.l2d_action
		end

		if arg0_52.l2dChar and not arg0_52.l2dChar:enablePlayAction(var0_53) then
			return
		end

		arg0_52:UpdatePaintingFace(arg1_52)

		if arg0_52.characterModel then
			local var2_53 = arg0_52:GetModelAction(var0_52)

			arg0_52.characterModel:GetComponent(typeof(SpineAnimUI)):SetAction(var2_53, 0)
		end

		local var3_53 = {
			var0_0.CHAT_SHOW_TIME
		}

		if arg0_52.live2DBtn.isOn and arg0_52.l2dChar then
			if arg0_52.l2dChar:IsLoaded() then
				arg0_52.l2dActioning = true

				if not arg1_52:L2dHasEvent() then
					parallelAsync({
						function(arg0_54)
							arg0_52:RemoveLive2DTimer()

							arg0_52.l2dActioning = arg0_52.l2dChar:TriggerAction(var0_53, arg0_54)
						end,
						function(arg0_55)
							arg0_52:PlayVoice(arg1_52, var3_53)
							arg0_52:ShowDailogue(arg1_52, var3_53, arg0_55)
						end
					}, function()
						arg0_52.l2dActioning = false
					end)
				else
					seriesAsync({
						function(arg0_57)
							arg0_52:RemoveLive2DTimer()

							arg0_52.l2dActioning = arg0_52.l2dChar:TriggerAction(var0_53, arg0_57, nil, function(arg0_58)
								arg0_52:PlayVoice(arg1_52, var3_53)
								arg0_52:ShowDailogue(arg1_52, var3_53, arg0_57)
							end)
						end
					}, function()
						arg0_52.l2dActioning = false
					end)
				end
			end
		else
			arg0_52:PlayVoice(arg1_52, var3_53)
			arg0_52:ShowDailogue(arg1_52, var3_53)
		end
	end

	if var0_52.key == "unlock" and arg0_52.haveOp then
		arg0_52:playOpening(var1_52)
	else
		var1_52()
	end
end

function var0_0.UpdatePaintingFace(arg0_60, arg1_60)
	local var0_60 = arg1_60.wordData
	local var1_60 = var0_60.mainIndex ~= nil
	local var2_60 = arg1_60.voice.key

	if var1_60 then
		var2_60 = "main_" .. var0_60.mainIndex
	end

	if arg0_60.paintingFitter.childCount > 0 then
		ShipExpressionHelper.SetExpression(arg0_60.paintingFitter:GetChild(0), arg0_60.paintingName, var2_60, var0_60.maxfavor, arg1_60.skin.id)
	end

	if arg0_60.spinePainting then
		local var3_60 = ShipExpressionHelper.GetExpression(arg0_60.paintingName, var2_60, var0_60.maxfavor, arg1_60.skin.id)

		if var3_60 ~= "" then
			arg0_60.spinePainting:SetAction(var3_60, 1)
		else
			arg0_60.spinePainting:SetEmptyAction(1)
		end
	end
end

function var0_0.PlayVoice(arg0_61, arg1_61, arg2_61)
	local var0_61 = arg1_61.wordData
	local var1_61 = arg1_61.skin
	local var2_61 = arg1_61.words

	arg0_61:RemoveCvTimer()

	if not var0_61.cvPath or var0_61.cvPath == "" then
		return
	end

	if var2_61.voice_key >= ShipWordHelper.CV_KEY_REPALCE or var2_61.voice_key_2 >= ShipWordHelper.CV_KEY_REPALCE or var2_61.voice_key == ShipWordHelper.CV_KEY_BAN_NEW then
		local var3_61 = 0

		if arg1_61.isLive2d and arg0_61.l2dChar and var0_61.voiceCalibrate then
			var3_61 = var0_61.voiceCalibrate
		end

		arg0_61.cvLoader:DelayPlaySound(var0_61.cvPath, var3_61, function(arg0_62)
			if arg0_62 then
				arg2_61[1] = long2int(arg0_62.length) * 0.001
			end
		end)
	end

	local var4_61 = var0_61.se

	if arg1_61.isLive2d and arg0_61.l2dChar and var4_61 then
		arg0_61.cvLoader:RawPlaySound("event:/ui/" .. var4_61[1], var4_61[2])
	end
end

function var0_0.RemoveCvSeTimer(arg0_63)
	if arg0_63.cvSeTimer then
		arg0_63.cvSeTimer:Stop()

		arg0_63.cvSeTimer = nil
	end
end

function var0_0.RemoveCvTimer(arg0_64)
	if arg0_64.cvTimer then
		arg0_64.cvTimer:Stop()

		arg0_64.cvTimer = nil
	end
end

function var0_0.RemoveLive2DTimer(arg0_65)
	if arg0_65.Live2DTimer then
		LeanTween.cancel(arg0_65.Live2DTimer)

		arg0_65.Live2DTimer = nil
	end
end

function var0_0.ShowDailogue(arg0_66, arg1_66, arg2_66, arg3_66)
	arg0_66.dailogueCallback = arg3_66 or function()
		return
	end

	local var0_66 = arg1_66.wordData.textContent

	if not var0_66 or var0_66 == "" or var0_66 == "nil" then
		if arg0_66.dailogueCallback then
			arg0_66.dailogueCallback()

			arg0_66.dailogueCallback = nil
		end

		return
	end

	local var1_66 = arg1_66.wordData.voiceCalibrate
	local var2_66 = arg0_66.chatText:GetComponent(typeof(Text))

	setText(arg0_66.chatText, SwitchSpecialChar(var0_66))

	var2_66.alignment = #var2_66.text > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	local var3_66 = var2_66.preferredHeight + 120

	arg0_66.chatBg.sizeDelta = var3_66 > arg0_66.initChatBgH and Vector2.New(arg0_66.chatBg.sizeDelta.x, var3_66) or Vector2.New(arg0_66.chatBg.sizeDelta.x, arg0_66.initChatBgH)

	arg0_66:StopDailogue()
	setActive(arg0_66.chatTF, true)
	LeanTween.scale(rtf(arg0_66.chatTF.gameObject), Vector3.New(1, 1, 1), var0_0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeOutBack):setDelay(var1_66 and var1_66 or 0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_66.chatTF.gameObject), Vector3.New(0, 0, 1), var0_0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeInBack):setDelay(var0_0.CHAT_ANIMATION_TIME + arg2_66[1]):setOnComplete(System.Action(function()
			if arg0_66.dailogueCallback then
				arg0_66.dailogueCallback()

				arg0_66.dailogueCallback = nil
			end

			if arg0_66.spinePainting then
				arg0_66.spinePainting:SetEmptyAction(1)
			end
		end))
	end))
end

function var0_0.StopDailogue(arg0_70)
	LeanTween.cancel(arg0_70.chatTF.gameObject)

	arg0_70.chatTF.localScale = Vector3(0, 0)
end

function var0_0.onBackPressed(arg0_71)
	if arg0_71.paintingView.isPreview then
		arg0_71.paintingView:Finish(true)

		return
	end

	triggerButton(arg0_71.btnBack)
end

function var0_0.playOpening(arg0_72, arg1_72)
	local var0_72 = "star_level_unlock_anim_" .. arg0_72.skin.id

	if checkABExist("ui/skinunlockanim/" .. var0_72) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1_72 then
				arg1_72()
			end
		end, "ui/skinunlockanim", var0_72, true, false, nil)
	elseif arg1_72 then
		arg1_72()
	end
end

function var0_0.updateSpinePaintingState(arg0_75)
	local var0_75 = HXSet.autoHxShiftPath("spinepainting/" .. arg0_75.paintingName)

	if checkABExist(var0_75) then
		setActive(arg0_75.spinePaintingBtn, true)
		setActive(arg0_75.spinePaintingToggle:Find("on"), arg0_75.spinePaintingisOn)
		setActive(arg0_75.spinePaintingToggle:Find("off"), not arg0_75.spinePaintingisOn)
		removeOnButton(arg0_75.spinePaintingBtn)
		onButton(arg0_75, arg0_75.spinePaintingBtn, function()
			arg0_75.spinePaintingisOn = not arg0_75.spinePaintingisOn

			setActive(arg0_75.spinePaintingToggle:Find("on"), arg0_75.spinePaintingisOn)
			setActive(arg0_75.spinePaintingToggle:Find("off"), not arg0_75.spinePaintingisOn)

			if arg0_75.spinePaintingisOn then
				arg0_75:CreateSpinePainting()
			end

			setActive(arg0_75.viewBtn, not arg0_75.spinePaintingisOn)
			setActive(arg0_75.rotateBtn, not arg0_75.spinePaintingisOn)
			setActive(arg0_75.commonPainting, not arg0_75.spinePaintingisOn)
			setActive(arg0_75.spinePaintingRoot, arg0_75.spinePaintingisOn)
			setActive(arg0_75.spinePaintingBgRoot, arg0_75.spinePaintingisOn)
			arg0_75:StopDailogue()

			if arg0_75.skin then
				arg0_75.pages[var0_0.INDEX_PROFILE]:ExecuteAction("Flush", arg0_75.skin, false)
			end
		end, SFX_PANEL)
	else
		setActive(arg0_75.spinePaintingBtn, false)
	end
end

function var0_0.CreateSpinePainting(arg0_77)
	if arg0_77.skin.id ~= arg0_77.preSkinId then
		arg0_77:DestroySpinePainting()

		local var0_77 = arg0_77.shipGroup:getShipConfigId()
		local var1_77 = SpinePainting.GenerateData({
			ship = Ship.New({
				configId = var0_77,
				skin_id = arg0_77.skin.id
			}),
			position = Vector3(0, 0, 0),
			parent = arg0_77.spinePaintingRoot,
			effectParent = arg0_77.spinePaintingBgRoot
		})

		arg0_77.spinePainting = SpinePainting.New(var1_77, function()
			return
		end)
		arg0_77.preSkinId = arg0_77.skin.id
	end

	arg0_77:DisplaySpinePainting(true)
end

function var0_0.DestroySpinePainting(arg0_79)
	if arg0_79.spinePainting then
		arg0_79.spinePainting:Dispose()

		arg0_79.spinePainting = nil
	end

	arg0_79.preSkinId = nil
end

function var0_0.onWeddingReview(arg0_80, arg1_80)
	if not arg1_80 and arg0_80.exitLoadL2d then
		arg0_80.exitLoadL2d = false

		arg0_80.live2DBtn:Update(arg0_80.paintingName, true)
	else
		arg0_80.live2DBtn:Update(arg0_80.paintingName, false)
	end

	arg0_80.live2DBtn:SetEnable(not arg1_80)

	if arg0_80.l2dChar and arg1_80 then
		arg0_80.l2dChar:Dispose()

		arg0_80.l2dChar = nil
		arg0_80.l2dActioning = false
		arg0_80.cvLoader.prevCvPath = nil

		arg0_80:StopDailogue()
		arg0_80.cvLoader:StopSound()

		arg0_80.exitLoadL2d = true
	end

	if arg0_80.spinePaintingRoot.childCount > 0 then
		setActive(arg0_80.commonPainting, not arg0_80.spinePaintingisOn)
	end
end

function var0_0.DisplaySpinePainting(arg0_81, arg1_81)
	setActive(arg0_81.spinePaintingRoot, arg1_81)
	setActive(arg0_81.spinePaintingBgRoot, arg1_81)
end

function var0_0.willExit(arg0_82)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	SetParent(arg0_82.bottomTF, arg0_82._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_82.blurPanel, arg0_82._tf)

	for iter0_82, iter1_82 in ipairs(arg0_82.pages) do
		iter1_82:Destroy()
	end

	if arg0_82.l2dChar then
		arg0_82.l2dChar:Dispose()
	end

	arg0_82:DestroySpinePainting()
	arg0_82.paintingView:Dispose()
	arg0_82.live2DBtn:Dispose()
	arg0_82.cvLoader:Dispose()
	arg0_82:ReturnModel()
	arg0_82:RecyclePainting()
	_.each(arg0_82.skinBtns or {}, function(arg0_83)
		arg0_83:Dispose()
	end)
	arg0_82:RemoveCvTimer()
	arg0_82:RemoveCvSeTimer()
	arg0_82:RemoveLive2DTimer()
end

return var0_0
