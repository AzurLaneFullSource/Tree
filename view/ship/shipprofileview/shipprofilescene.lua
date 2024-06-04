local var0 = class("ShipProfileScene", import("...base.BaseUI"))

var0.SHOW_SKILL_INFO = "event show skill info"
var0.SHOW_EVALUATION = "event show evalution"
var0.WEDDING_REVIEW = "event wedding review"
var0.INDEX_DETAIL = 1
var0.INDEX_PROFILE = 2
var0.CHAT_ANIMATION_TIME = 0.3
var0.CHAT_SHOW_TIME = 3

local var1 = 0.35

function var0.getUIName(arg0)
	return "ShipProfileUI"
end

function var0.preload(arg0, arg1)
	local var0 = getProxy(CollectionProxy):getShipGroup(arg0.contextData.groupId)

	LoadSpriteAtlasAsync("bg/star_level_bg_" .. var0:rarity2bgPrintForGet(arg0.showTrans), "", arg1)
end

function var0.setShipGroup(arg0, arg1)
	arg0.shipGroup = arg1
	arg0.groupSkinList = arg1:getDisplayableSkinList()
	arg0.isBluePrintGroup = arg0.shipGroup:isBluePrintGroup()
	arg0.isMetaGroup = arg0.shipGroup:isMetaGroup()
end

function var0.setShowTrans(arg0, arg1)
	arg0.showTrans = arg1
end

function var0.setOwnedSkinList(arg0, arg1)
	arg0.ownedSkinList = arg1
end

function var0.init(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.staticBg = arg0.bg:Find("static_bg")
	arg0.painting = arg0:findTF("paint")
	arg0.paintingFitter = findTF(arg0.painting, "fitter")
	arg0.paintingInitPos = arg0.painting.transform.localPosition
	arg0.chatTF = arg0:findTF("paint/chat")

	setActive(arg0.chatTF, false)

	arg0.commonPainting = arg0.painting:Find("fitter")
	arg0.l2dRoot = arg0:findTF("live2d", arg0.painting)
	arg0.spinePaintingRoot = arg0:findTF("spinePainting", arg0.painting)
	arg0.spinePaintingBgRoot = arg0:findTF("paintBg/spinePainting")
	arg0.chatBg = arg0:findTF("chatbgtop", arg0.chatTF)
	arg0.initChatBgH = arg0.chatBg.sizeDelta.y
	arg0.chatText = arg0:findTF("Text", arg0.chatBg)
	arg0.name = arg0:findTF("name")
	arg0.nameInitPos = arg0.name.transform.localPosition
	arg0.shipType = arg0:findTF("type", arg0.name)
	arg0.labelName = arg0:findTF("name_mask/Text", arg0.name):GetComponent(typeof(Text))
	arg0.labelEnName = arg0:findTF("english_name", arg0.name):GetComponent(typeof(Text))
	arg0.stars = arg0:findTF("stars", arg0.name)
	arg0.star = arg0:getTpl("star_tpl", arg0.stars)
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.top = arg0:findTF("blur_panel/adapt/top")
	arg0.btnBack = arg0:findTF("back", arg0.top)
	arg0.bottomTF = arg0:findTF("bottom")
	arg0.labelHeart = arg0:findTF("adapt/detail_left_panel/heart/label", arg0.blurPanel)
	arg0.btnLike = arg0:findTF("adapt/detail_left_panel/heart/btnLike", arg0.blurPanel)
	arg0.btnLikeAct = arg0.btnLike:Find("like")
	arg0.btnLikeDisact = arg0.btnLike:Find("unlike")
	arg0.obtainBtn = arg0:findTF("bottom/others/obtain_btn")
	arg0.evaBtn = arg0:findTF("bottom/others/eva_btn")
	arg0.viewBtn = arg0:findTF("bottom/others/view_btn")
	arg0.shareBtn = arg0:findTF("bottom/others/share_btn")
	arg0.rotateBtn = arg0:findTF("bottom/others/rotate_btn")
	arg0.cryptolaliaBtn = arg0:findTF("bottom/others/cryptolalia_btn")
	arg0.equipCodeBtn = arg0:findTF("bottom/others/equip_code_btn")
	arg0.leftProfile = arg0:findTF("adapt/profile_left_panel", arg0.blurPanel)
	arg0.modelContainer = arg0:findTF("model", arg0.leftProfile)
	arg0.live2DBtn = ShipProfileLive2dBtn.New(arg0:findTF("L2D_btn", arg0.blurPanel))

	GetComponent(arg0:findTF("L2D_btn", arg0.blurPanel), typeof(Image)):SetNativeSize()
	GetComponent(arg0:findTF("L2D_btn/img", arg0.blurPanel), typeof(Image)):SetNativeSize()

	arg0.spinePaintingBtn = arg0:findTF("SP_btn", arg0.blurPanel)

	GetComponent(arg0.spinePaintingBtn, typeof(Image)):SetNativeSize()
	GetComponent(arg0:findTF("SP_btn/img", arg0.blurPanel), typeof(Image)):SetNativeSize()
	GetComponent(arg0:findTF("adapt/top/title", arg0.blurPanel), typeof(Image)):SetNativeSize()

	arg0.spinePaintingToggle = arg0.spinePaintingBtn:Find("toggle")
	arg0.cvLoader = ShipProfileCVLoader.New()
	arg0.pageTFs = arg0:findTF("pages")
	arg0.paintingView = ShipProfilePaintingView.New(arg0._tf, arg0.painting)
	arg0.toggles = {
		arg0:findTF("bottom/detail"),
		arg0:findTF("bottom/profile")
	}

	local var0 = ShipProfileInformationPage.New(arg0.pageTFs, arg0.event)
	local var1 = ShipProfileDetailPage.New(arg0.pageTFs, arg0.event)

	var0:SetCvLoader(arg0.cvLoader)
	var0:SetCallback(function(arg0)
		arg0:OnCVBtnClick(arg0)
	end)

	arg0.pages = {
		var1,
		var0
	}
	arg0.UISkinList = UIItemList.New(arg0.leftProfile:Find("scroll/Viewport/skin_container"), arg0.leftProfile:Find("scroll/Viewport/skin_container/skin_tpl"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnBack, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.equipCodeBtn, function()
		arg0:emit(ShipProfileMediator.OPEN_EQUIP_CODE_SHARE, arg0.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.cryptolaliaBtn, function()
		arg0:emit(ShipProfileMediator.OPEN_CRYPTOLALIA, arg0.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.obtainBtn, function()
		local var0 = {
			type = MSGBOX_TYPE_OBTAIN,
			shipId = arg0.shipGroup:getShipConfigId(),
			list = arg0.shipGroup.groupConfig.description,
			mediatorName = ShipProfileMediator.__cname
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox(var0)
	end)
	onButton(arg0, arg0.evaBtn, function()
		arg0:emit(var0.SHOW_EVALUATION, arg0.shipGroup.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.viewBtn, function()
		if LeanTween.isTweening(arg0.chatTF.gameObject) then
			LeanTween.cancel(arg0.chatTF.gameObject)

			arg0.chatTF.localScale = Vector3(0, 0, 0)

			if arg0.dailogueCallback then
				arg0.dailogueCallback()

				arg0.dailogueCallback = nil
			end
		end

		arg0.paintingView:Start()
	end, SFX_PANEL)
	onButton(arg0, arg0.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeShipProfile)
	end, SFX_PANEL)
	onButton(arg0, arg0.rotateBtn, function()
		setActive(arg0._tf, false)
		arg0:emit(ShipProfileMediator.CLICK_ROTATE_BTN, arg0.shipGroup, arg0.showTrans, arg0.skin)
	end, SFX_PANEL)
	arg0.live2DBtn:AddListener(function(arg0)
		if arg0 then
			arg0:CreateLive2D()
		end

		setActive(arg0.viewBtn, not arg0)
		setActive(arg0.rotateBtn, not arg0)
		setActive(arg0.commonPainting, not arg0)
		setActive(arg0.l2dRoot, arg0)
		arg0:StopDailogue()

		arg0.l2dActioning = nil

		if arg0.skin then
			arg0.pages[var0.INDEX_PROFILE]:ExecuteAction("Flush", arg0.skin, arg0)
		end
	end)

	for iter0, iter1 in ipairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			if iter0 == var0.INDEX_DETAIL then
				arg0.live2DBtn:Update(arg0.paintingName, false)

				arg0.spinePaintingisOn = false

				arg0:updateSpinePaintingState()
				arg0:DisplaySpinePainting(false)
			end

			if arg0 then
				arg0:SwitchPage(iter0)
			end
		end, SFX_PANEL)
	end

	arg0:InitCommon()
	arg0.live2DBtn:Update(arg0.paintingName, false)
	arg0:updateSpinePaintingState()
	setActive(arg0.bottomTF, false)
	triggerToggle(arg0.toggles[var0.INDEX_DETAIL], true)
end

function var0.InitSkinList(arg0)
	arg0.skinBtns = {}

	arg0.UISkinList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.groupSkinList[arg1 + 1]
			local var1 = ShipProfileSkinBtn.New(arg2)

			table.insert(arg0.skinBtns, var1)
			var1:Update(var0, arg0.shipGroup, table.contains(arg0.ownedSkinList, var0.id))
			onButton(arg0, var1._tf, function()
				if not var1.unlock then
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_profile_skin_locked"))

					return
				end

				arg0.contextData.skinIndex = arg1 + 1

				arg0:ShiftSkin(var0)

				if arg0.prevSkinBtn then
					arg0.prevSkinBtn:UnShift()
				end

				var1:Shift()

				arg0.prevSkinBtn = var1
			end, SFX_PANEL)
			setActive(arg2, var0.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or not HXSet.isHxSkin())
		end
	end)
	arg0.UISkinList:align(#arg0.groupSkinList)
end

function var0.InitCommon(arg0)
	arg0:LoadSkinBg(arg0.shipGroup:rarity2bgPrintForGet(arg0.showTrans))
	setImageSprite(arg0.shipType, GetSpriteFromAtlas("shiptype", arg0.shipGroup:getShipType(arg0.showTrans)))

	arg0.labelName.text = arg0.shipGroup:getName(arg0.showTrans)

	local var0 = arg0.shipGroup.shipConfig

	arg0.labelEnName.text = var0.english_name

	for iter0 = 1, var0.star do
		cloneTplTo(arg0.star, arg0.stars)
	end

	arg0:FlushHearts()

	local var1 = arg0.shipGroup:GetSkin(arg0.showTrans).id

	arg0:SetPainting(var1, arg0.showTrans)
end

function var0.SetPainting(arg0, arg1, arg2)
	arg0:RecyclePainting()

	if arg2 and arg0.shipGroup.trans then
		arg1 = arg0.shipGroup.groupConfig.trans_skin
	end

	local var0 = pg.ship_skin_template[arg1].painting

	setPaintingPrefabAsync(arg0.painting, var0, "chuanwu")

	arg0.paintingName = var0

	arg0:UpdateCryptolaliaBtn(arg1)
end

function var0.RecyclePainting(arg0)
	if arg0.paintingName then
		retPaintingPrefab(arg0.painting, arg0.paintingName)
	end
end

function var0.FlushHearts(arg0)
	local var0 = arg0.shipGroup.hearts

	setText(arg0.labelHeart, var0 > 999 and "999+" or var0)

	arg0.labelHeart:GetComponent("Text").color = arg0.shipGroup.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

	setActive(arg0.btnLikeDisact, not arg0.shipGroup.iheart)
	setActive(arg0.btnLikeAct, arg0.shipGroup.iheart)
end

function var0.LoadSkinBg(arg0, arg1)
	arg0.bluePintBg = arg0.isBluePrintGroup and arg0.shipGroup:rarity2bgPrintForGet(arg0.showTrans)
	arg0.metaMainBg = arg0.isMetaGroup and arg0.shipGroup:rarity2bgPrintForGet(arg0.showTrans)

	if arg0.shipSkinBg ~= arg1 then
		arg0.shipSkinBg = arg1

		local function var0(arg0)
			rtf(arg0).localPosition = Vector3(0, 0, 200)
		end

		local function var1()
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg0.shipGroup:getRarity(arg0.showTrans), true, function(arg0)
				arg0.designBg = arg0
				arg0.designName = "raritydesign" .. arg0.shipGroup:getRarity(arg0.showTrans)

				arg0.transform:SetParent(arg0.staticBg, false)

				arg0.transform.localPosition = Vector3(1, 1, 1)
				arg0.transform.localScale = Vector3(1, 1, 1)

				arg0.transform:SetSiblingIndex(1)

				local var0 = arg0:GetComponent("Canvas")

				if var0 then
					var0.sortingOrder = -90
				end

				setActive(arg0, true)
			end)
		end

		local function var2()
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg0.shipGroup:getRarity(arg0.showTrans), true, function(arg0)
				arg0.metaBg = arg0
				arg0.metaName = "raritymeta" .. arg0.shipGroup:getRarity(arg0.showTrans)

				arg0.transform:SetParent(arg0.staticBg, false)

				arg0.transform.localPosition = Vector3(1, 1, 1)
				arg0.transform.localScale = Vector3(1, 1, 1)

				arg0.transform:SetSiblingIndex(1)
				setActive(arg0, true)
			end)
		end

		local function var3(arg0)
			if arg0.bluePintBg and arg1 == arg0.bluePintBg then
				if arg0.metaBg then
					setActive(arg0.metaBg, false)
				end

				if arg0.designBg and arg0.designName ~= "raritydesign" .. arg0.shipGroup:getRarity(arg0.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0.designName, arg0.designBg)

					arg0.designBg = nil
				end

				if not arg0.designBg then
					var1()
				else
					setActive(arg0.designBg, true)
				end
			elseif arg0.metaMainBg and arg1 == arg0.metaMainBg then
				if arg0.designBg then
					setActive(arg0.designBg, false)
				end

				if arg0.metaBg and arg0.metaName ~= "raritymeta" .. arg0.shipGroup:getRarity(arg0.showTrans) then
					PoolMgr.GetInstance():ReturnUI(arg0.metaName, arg0.metaBg)

					arg0.metaBg = nil
				end

				if not arg0.metaBg then
					var2()
				else
					setActive(arg0.metaBg, true)
				end
			else
				if arg0.designBg then
					setActive(arg0.designBg, false)
				end

				if arg0.metaBg then
					setActive(arg0.metaBg, false)
				end
			end
		end

		pg.DynamicBgMgr.GetInstance():LoadBg(arg0, arg1, arg0.bg, arg0.staticBg, var0, var3)
	end
end

function var0.SwitchPage(arg0, arg1)
	if arg0.index ~= arg1 then
		seriesAsync({
			function(arg0)
				pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel, {
					groupName = LayerWeightConst.GROUP_SHIP_PROFILE
				})
				arg0()
			end,
			function(arg0)
				local var0 = arg0.pages[arg1]
				local var1 = arg1 == var0.INDEX_PROFILE and not var0:GetLoaded()

				var0:ExecuteAction("Update", arg0.shipGroup, arg0.showTrans, function()
					if var1 then
						arg0:InitSkinList()
					end

					arg0()
				end)
			end,
			function(arg0)
				if not arg0.index then
					arg0()

					return
				end

				arg0.pages[arg0.index]:ExecuteAction("ExistAnim", var1)
				arg0()
			end,
			function(arg0)
				local var0 = arg0.pages[arg1]

				SetParent(arg0.bottomTF, var0._tf)
				setActive(arg0.bottomTF, true)
				setAnchoredPosition(arg0.bottomTF, {
					z = 0,
					x = -7,
					y = 24
				})
				var0:ExecuteAction("EnterAnim", var1)
				arg0:TweenPage(arg1)
				arg0()
			end,
			function(arg0)
				arg0.index = arg1

				local var0 = arg0.contextData.skinIndex or 1

				if arg1 == var0.INDEX_PROFILE and var0 <= #arg0.skinBtns then
					triggerButton(arg0.skinBtns[var0]._tf)
				end
			end
		})
	end
end

function var0.TweenPage(arg0, arg1)
	if arg1 == var0.INDEX_DETAIL then
		LeanTween.moveX(rtf(arg0.leftProfile), -700, var1):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0.live2DBtn._tf), -70, var1):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0.spinePaintingBtn), -70, var1):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0.painting), arg0.paintingInitPos.x, var1):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0.name), arg0.nameInitPos.x, var1):setEase(LeanTweenType.easeInOutSine)
	elseif arg1 == var0.INDEX_PROFILE then
		LeanTween.moveX(rtf(arg0.leftProfile), 0, var1):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0.live2DBtn._tf), 60, var1):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveY(rtf(arg0.spinePaintingBtn), 60, var1):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0.painting), arg0.paintingInitPos.x + 50, var1):setEase(LeanTweenType.easeInOutSine)
		LeanTween.moveX(rtf(arg0.name), arg0.nameInitPos.x + 50, var1):setEase(LeanTweenType.easeInOutSine)
	end
end

function var0.ShiftSkin(arg0, arg1)
	if arg0.index ~= var0.INDEX_PROFILE or arg0.skin and arg1.id == arg0.skin.id then
		return
	end

	arg0.skin = arg1

	arg0:LoadModel(arg1)
	arg0:SetPainting(arg1.id, false)
	arg0.live2DBtn:Disable()
	arg0.live2DBtn:Update(arg0.paintingName, false)

	local var0
	local var1 = arg1 and arg1.spine_use_live2d == 1 and "spine_painting_bg" or "live2d_bg"

	LoadSpriteAtlasAsync("ui/share/btn_l2d_atlas", var1, function(arg0)
		GetComponent(arg0:findTF("L2D_btn", arg0.blurPanel), typeof(Image)).sprite = arg0
		GetComponent(arg0:findTF("L2D_btn/img", arg0.blurPanel), typeof(Image)).sprite = arg0

		GetComponent(arg0:findTF("L2D_btn", arg0.blurPanel), typeof(Image)):SetNativeSize()
		GetComponent(arg0:findTF("L2D_btn/img", arg0.blurPanel), typeof(Image)):SetNativeSize()
	end)

	arg0.spinePaintingisOn = false

	arg0:updateSpinePaintingState()
	arg0:DestroySpinePainting()
	arg0.pages[var0.INDEX_PROFILE]:ExecuteAction("Flush", arg1, false)

	local var2
	local var3 = PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg0.skin.painting, 0) == 0

	if arg0.skin.bg_sp and arg0.skin.bg_sp ~= "" and var3 then
		var2 = arg0.skin.bg_sp
	elseif arg0.skin.bg and arg0.skin.bg ~= "" then
		var2 = arg0.skin.bg
	else
		var2 = arg0.shipGroup:rarity2bgPrintForGet(arg0.showTrans, arg0.skin.id)
	end

	arg0:LoadSkinBg(var2)

	arg0.haveOp = checkABExist("ui/skinunlockanim/star_level_unlock_anim_" .. arg0.skin.id)
end

function var0.UpdateCryptolaliaBtn(arg0, arg1)
	local var0 = ShipSkin.New({
		id = arg1
	}):getConfig("ship_group")

	setActive(arg0.cryptolaliaBtn, getProxy(PlayerProxy):getRawData():ExistCryptolalia(var0))
end

function var0.LoadModel(arg0, arg1)
	if arg0.inLoading then
		return
	end

	arg0:ReturnModel()

	local var0 = arg1.prefab

	arg0.inLoading = true

	PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
		arg0.inLoading = false
		arg0.name = var0
		arg0.transform.localPosition = Vector3.zero
		arg0.transform.localScale = Vector3(0.8, 0.8, 1)

		arg0.transform:SetParent(arg0.modelContainer, false)
		arg0:GetComponent(typeof(SpineAnimUI)):SetAction(arg1.show_skin or "stand", 0)

		arg0.characterModel = arg0
		arg0.modelName = var0
	end)
end

function var0.ReturnModel(arg0)
	if not IsNil(arg0.characterModel) then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.modelName, arg0.characterModel)
	end
end

function var0.CreateLive2D(arg0)
	arg0.live2DBtn:SetEnable(false)

	if arg0.l2dChar then
		arg0.l2dChar:Dispose()
	end

	local var0 = arg0.shipGroup:getShipConfigId()
	local var1 = pg.ship_skin_template[arg0.skin.id].live2d_offset_profile
	local var2

	if var1 and type(var1) ~= "string" then
		var2 = Vector3(0 + var1[1], -40 + var1[2], 100 + var1[3])
	else
		var2 = Vector3(0, -40, 100)
	end

	local var3 = Live2D.GenerateData({
		ship = Ship.New({
			configId = var0,
			skin_id = arg0.skin.id,
			propose = arg0.shipGroup.married
		}),
		scale = Vector3(52, 52, 52),
		position = var2,
		parent = arg0.l2dRoot
	})

	arg0.l2dChar = Live2D.New(var3, function()
		arg0.live2DBtn:SetEnable(true)
	end)

	if isHalfBodyLive2D(arg0.skin.prefab) then
		setAnchoredPosition(arg0.l2dRoot, {
			y = -37 - (arg0.painting.rect.height - arg0.l2dRoot.rect.height * 1.5) / 2
		})
	else
		setAnchoredPosition(arg0.l2dRoot, {
			y = 0
		})
	end

	if Live2dConst.UnLoadL2dPating then
		Live2dConst.UnLoadL2dPating()
	end
end

function var0.GetModelAction(arg0, arg1)
	local var0

	if not arg1.spine_action or arg1.spine_action == "" then
		return "stand"
	else
		return arg1.spine_action
	end
end

function var0.OnCVBtnClick(arg0, arg1)
	if arg0.l2dActioning then
		return
	end

	local var0 = arg1.voice

	local function var1()
		local var0

		if arg1:isEx() then
			local var1 = var0.l2d_action .. "_ex"

			if arg0.l2dChar and arg0.l2dChar:checkActionExist(var1) then
				var0 = var1
			else
				var0 = var0.l2d_action
			end
		else
			var0 = var0.l2d_action
		end

		if arg0.l2dChar and not arg0.l2dChar:enablePlayAction(var0) then
			return
		end

		arg0:UpdatePaintingFace(arg1)

		if arg0.characterModel then
			local var2 = arg0:GetModelAction(var0)

			arg0.characterModel:GetComponent(typeof(SpineAnimUI)):SetAction(var2, 0)
		end

		local var3 = {
			var0.CHAT_SHOW_TIME
		}

		if arg0.live2DBtn.isOn and arg0.l2dChar then
			if arg0.l2dChar:IsLoaded() then
				arg0.l2dActioning = true

				if not arg1:L2dHasEvent() then
					parallelAsync({
						function(arg0)
							arg0:RemoveLive2DTimer()
							arg0.l2dChar:TriggerAction(var0, arg0)
						end,
						function(arg0)
							arg0:PlayVoice(arg1, var3)
							arg0:ShowDailogue(arg1, var3, arg0)
						end
					}, function()
						arg0.l2dActioning = false
					end)
				else
					seriesAsync({
						function(arg0)
							arg0:RemoveLive2DTimer()
							arg0.l2dChar:TriggerAction(var0, arg0, nil, function(arg0)
								arg0:PlayVoice(arg1, var3)
								arg0:ShowDailogue(arg1, var3, arg0)
							end)
						end
					}, function()
						arg0.l2dActioning = false
					end)
				end
			end
		else
			arg0:PlayVoice(arg1, var3)
			arg0:ShowDailogue(arg1, var3)
		end
	end

	if var0.key == "unlock" and arg0.haveOp then
		arg0:playOpening(var1)
	else
		var1()
	end
end

function var0.UpdatePaintingFace(arg0, arg1)
	local var0 = arg1.wordData
	local var1 = var0.mainIndex ~= nil
	local var2 = arg1.voice.key

	if var1 then
		var2 = "main_" .. var0.mainIndex
	end

	if arg0.paintingFitter.childCount > 0 then
		ShipExpressionHelper.SetExpression(arg0.paintingFitter:GetChild(0), arg0.paintingName, var2, var0.maxfavor, arg1.skin.id)
	end

	if arg0.spinePainting then
		local var3 = ShipExpressionHelper.GetExpression(arg0.paintingName, var2, var0.maxfavor, arg1.skin.id)

		if var3 ~= "" then
			arg0.spinePainting:SetAction(var3, 1)
		else
			arg0.spinePainting:SetEmptyAction(1)
		end
	end
end

function var0.PlayVoice(arg0, arg1, arg2)
	local var0 = arg1.wordData
	local var1 = arg1.skin
	local var2 = arg1.words

	arg0:RemoveCvTimer()

	if not var0.cvPath or var0.cvPath == "" then
		return
	end

	if var2.voice_key >= ShipWordHelper.CV_KEY_REPALCE or var2.voice_key_2 >= ShipWordHelper.CV_KEY_REPALCE or var2.voice_key == ShipWordHelper.CV_KEY_BAN_NEW then
		local var3 = 0

		if arg1.isLive2d and arg0.l2dChar and var0.voiceCalibrate then
			var3 = var0.voiceCalibrate
		end

		arg0.cvLoader:DelayPlaySound(var0.cvPath, var3, function(arg0)
			if arg0 then
				arg2[1] = long2int(arg0.length) * 0.001
			end
		end)
	end

	local var4 = var0.se

	if arg1.isLive2d and arg0.l2dChar and var4 then
		arg0.cvLoader:RawPlaySound("event:/ui/" .. var4[1], var4[2])
	end
end

function var0.RemoveCvSeTimer(arg0)
	if arg0.cvSeTimer then
		arg0.cvSeTimer:Stop()

		arg0.cvSeTimer = nil
	end
end

function var0.RemoveCvTimer(arg0)
	if arg0.cvTimer then
		arg0.cvTimer:Stop()

		arg0.cvTimer = nil
	end
end

function var0.RemoveLive2DTimer(arg0)
	if arg0.Live2DTimer then
		LeanTween.cancel(arg0.Live2DTimer)

		arg0.Live2DTimer = nil
	end
end

function var0.ShowDailogue(arg0, arg1, arg2, arg3)
	arg0.dailogueCallback = arg3 or function()
		return
	end

	local var0 = arg1.wordData.textContent

	if not var0 or var0 == "" or var0 == "nil" then
		if arg0.dailogueCallback then
			arg0.dailogueCallback()

			arg0.dailogueCallback = nil
		end

		return
	end

	local var1 = arg1.wordData.voiceCalibrate
	local var2 = arg0.chatText:GetComponent(typeof(Text))

	setText(arg0.chatText, SwitchSpecialChar(var0))

	var2.alignment = #var2.text > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	local var3 = var2.preferredHeight + 120

	arg0.chatBg.sizeDelta = var3 > arg0.initChatBgH and Vector2.New(arg0.chatBg.sizeDelta.x, var3) or Vector2.New(arg0.chatBg.sizeDelta.x, arg0.initChatBgH)

	arg0:StopDailogue()
	setActive(arg0.chatTF, true)
	LeanTween.scale(rtf(arg0.chatTF.gameObject), Vector3.New(1, 1, 1), var0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeOutBack):setDelay(var1 and var1 or 0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0.chatTF.gameObject), Vector3.New(0, 0, 1), var0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeInBack):setDelay(var0.CHAT_ANIMATION_TIME + arg2[1]):setOnComplete(System.Action(function()
			if arg0.dailogueCallback then
				arg0.dailogueCallback()

				arg0.dailogueCallback = nil
			end

			if arg0.spinePainting then
				arg0.spinePainting:SetEmptyAction(1)
			end
		end))
	end))
end

function var0.StopDailogue(arg0)
	LeanTween.cancel(arg0.chatTF.gameObject)

	arg0.chatTF.localScale = Vector3(0, 0)
end

function var0.onBackPressed(arg0)
	if arg0.paintingView.isPreview then
		arg0.paintingView:Finish(true)

		return
	end

	triggerButton(arg0.btnBack)
end

function var0.playOpening(arg0, arg1)
	local var0 = "star_level_unlock_anim_" .. arg0.skin.id

	if checkABExist("ui/skinunlockanim/" .. var0) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1 then
				arg1()
			end
		end, "ui/skinunlockanim", var0, true, false, nil)
	elseif arg1 then
		arg1()
	end
end

function var0.updateSpinePaintingState(arg0)
	local var0 = HXSet.autoHxShiftPath("spinepainting/" .. arg0.paintingName)

	if checkABExist(var0) then
		setActive(arg0.spinePaintingBtn, true)
		setActive(arg0.spinePaintingToggle:Find("on"), arg0.spinePaintingisOn)
		setActive(arg0.spinePaintingToggle:Find("off"), not arg0.spinePaintingisOn)
		removeOnButton(arg0.spinePaintingBtn)
		onButton(arg0, arg0.spinePaintingBtn, function()
			arg0.spinePaintingisOn = not arg0.spinePaintingisOn

			setActive(arg0.spinePaintingToggle:Find("on"), arg0.spinePaintingisOn)
			setActive(arg0.spinePaintingToggle:Find("off"), not arg0.spinePaintingisOn)

			if arg0.spinePaintingisOn then
				arg0:CreateSpinePainting()
			end

			setActive(arg0.viewBtn, not arg0.spinePaintingisOn)
			setActive(arg0.rotateBtn, not arg0.spinePaintingisOn)
			setActive(arg0.commonPainting, not arg0.spinePaintingisOn)
			setActive(arg0.spinePaintingRoot, arg0.spinePaintingisOn)
			setActive(arg0.spinePaintingBgRoot, arg0.spinePaintingisOn)
			arg0:StopDailogue()

			if arg0.skin then
				arg0.pages[var0.INDEX_PROFILE]:ExecuteAction("Flush", arg0.skin, false)
			end
		end, SFX_PANEL)
	else
		setActive(arg0.spinePaintingBtn, false)
	end
end

function var0.CreateSpinePainting(arg0)
	if arg0.skin.id ~= arg0.preSkinId then
		arg0:DestroySpinePainting()

		local var0 = arg0.shipGroup:getShipConfigId()
		local var1 = SpinePainting.GenerateData({
			ship = Ship.New({
				configId = var0,
				skin_id = arg0.skin.id
			}),
			position = Vector3(0, 0, 0),
			parent = arg0.spinePaintingRoot,
			effectParent = arg0.spinePaintingBgRoot
		})

		arg0.spinePainting = SpinePainting.New(var1, function()
			return
		end)
		arg0.preSkinId = arg0.skin.id
	end

	arg0:DisplaySpinePainting(true)
end

function var0.DestroySpinePainting(arg0)
	if arg0.spinePainting then
		arg0.spinePainting:Dispose()

		arg0.spinePainting = nil
	end

	arg0.preSkinId = nil
end

function var0.onWeddingReview(arg0, arg1)
	if not arg1 and arg0.exitLoadL2d then
		arg0.exitLoadL2d = false

		arg0.live2DBtn:Update(arg0.paintingName, true)
	else
		arg0.live2DBtn:Update(arg0.paintingName, false)
	end

	arg0.live2DBtn:SetEnable(not arg1)

	if arg0.l2dChar and arg1 then
		arg0.l2dChar:Dispose()

		arg0.l2dChar = nil
		arg0.l2dActioning = false
		arg0.cvLoader.prevCvPath = nil

		arg0:StopDailogue()
		arg0.cvLoader:StopSound()

		arg0.exitLoadL2d = true
	end
end

function var0.DisplaySpinePainting(arg0, arg1)
	setActive(arg0.spinePaintingRoot, arg1)
	setActive(arg0.spinePaintingBgRoot, arg1)
end

function var0.willExit(arg0)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	SetParent(arg0.bottomTF, arg0._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)

	for iter0, iter1 in ipairs(arg0.pages) do
		iter1:Destroy()
	end

	if arg0.l2dChar then
		arg0.l2dChar:Dispose()
	end

	arg0:DestroySpinePainting()
	arg0.paintingView:Dispose()
	arg0.live2DBtn:Dispose()
	arg0.cvLoader:Dispose()
	arg0:ReturnModel()
	arg0:RecyclePainting()
	_.each(arg0.skinBtns or {}, function(arg0)
		arg0:Dispose()
	end)
	arg0:RemoveCvTimer()
	arg0:RemoveCvSeTimer()
	arg0:RemoveLive2DTimer()
end

return var0
