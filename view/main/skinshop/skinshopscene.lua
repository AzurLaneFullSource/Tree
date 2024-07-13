local var0_0 = class("SkinShopScene", import("...base.BaseUI"))

var0_0.EVENT_ON_CARD_CLICK = "SkinShopScene:EVENT_ON_CARD_CLICK"

local var1_0 = pg.skin_page_template
local var2_0 = pg.ship_skin_template

var0_0.SHOP_TYPE_COMMON = 1
var0_0.SHOP_TYPE_TIMELIMIT = 2
var0_0.PAGE_ALL = -1
var0_0.PAGE_TIME_LIMIT = -2
var0_0.PAGE_ENCORE = -3
var0_0.PAGE_PROPOSE = 9998
var0_0.PAGE_TRANS = 9997
var0_0.MSGBOXNAME = "SkinShopMsgbox"

local var3_0 = {
	{
		"huanzhuangshagndian",
		"huanzhuangshagndian_en"
	},
	{
		"title_01",
		"title_en_01"
	}
}

function var0_0.forceGC(arg0_1)
	return true
end

function var0_0.getUIName(arg0_2)
	return "SkinShopUI"
end

function var0_0.ResUISettings(arg0_3)
	return {
		anim = true,
		showType = PlayerResUI.TYPE_GEM
	}
end

function var0_0.setSkins(arg0_4, arg1_4)
	arg0_4.skinList = arg1_4

	arg0_4:filterSkins()
end

function var0_0.SetEncoreSkins(arg0_5, arg1_5)
	arg0_5.existAnyEncoreSkin = #arg1_5 > 0
	arg0_5.encoreSkinMap = {}

	for iter0_5, iter1_5 in ipairs(arg1_5) do
		arg0_5.encoreSkinMap[iter1_5] = true
	end
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.playerVO = arg1_6
	arg0_6.skinTicket = arg0_6.playerVO:getSkinTicket()
end

function var0_0.filterSkins(arg0_7)
	arg0_7.skinGoodsVOs = getProxy(ShipSkinProxy):GetAllSkins()

	arg0_7:updateShipRect()
end

function var0_0.init(arg0_8)
	arg0_8.downloads = {}
	arg0_8.bottomTF = arg0_8:findTF("Main/bottom")
	arg0_8.topTF = arg0_8:findTF("Main/blur_panel/adapt/top")
	arg0_8.leftPanel = arg0_8:findTF("Main/left_panel")
	arg0_8.title = arg0_8:findTF("title", arg0_8.topTF)
	arg0_8.titleEn = arg0_8:findTF("title_en", arg0_8.topTF)
	arg0_8.mainPanel = arg0_8:findTF("Main")
	arg0_8.namePanel = arg0_8:findTF("name_bg", arg0_8.mainPanel)
	arg0_8.nameTxt = arg0_8:findTF("name_bg/name", arg0_8.mainPanel):GetComponent(typeof(Text))
	arg0_8.skinNameTxt = arg0_8:findTF("name_bg/skin_name", arg0_8.mainPanel):GetComponent(typeof(Text))
	arg0_8.rightPanel = arg0_8:findTF("Main/right")
	arg0_8.charParent = arg0_8:findTF("char", arg0_8.rightPanel)
	arg0_8.furParent = arg0_8:findTF("fur", arg0_8.rightPanel)
	arg0_8.interactionPreview = BackYardInteractionPreview.New(arg0_8.furParent, Vector3(0, 0, 0))
	arg0_8.paintingTF = arg0_8:findTF("painting/paint")
	arg0_8.tags = arg0_8:findTF("tags", arg0_8.rightPanel)
	arg0_8.limitTxt = arg0_8:findTF("name_bg/limit_time/Text", arg0_8.mainPanel):GetComponent(typeof(Text))
	arg0_8.commonPanel = arg0_8:findTF("common", arg0_8.rightPanel)
	arg0_8.commonBGTF = arg0_8:findTF("bg", arg0_8.commonPanel)
	arg0_8.commonLabelTF = arg0_8:findTF("label", arg0_8.commonPanel)
	arg0_8.commonConsumeTF = arg0_8:findTF("consume", arg0_8.commonPanel)
	arg0_8.buyBtn = arg0_8:findTF("buy_btn", arg0_8.commonPanel)
	arg0_8.activityBtn = arg0_8:findTF("activty_btn", arg0_8.commonPanel)
	arg0_8.itemBtn = arg0_8:findTF("item_btn", arg0_8.commonPanel)
	arg0_8.gotBtn = arg0_8:findTF("got_btn", arg0_8.commonPanel)
	arg0_8.backyardBtn = arg0_8:findTF("backyard", arg0_8.commonPanel)
	arg0_8.priceTxt = arg0_8:findTF("consume/Text", arg0_8.commonPanel):GetComponent(typeof(Text))
	arg0_8.originalPriceTxt = arg0_8:findTF("consume/originalprice/Text", arg0_8.commonPanel):GetComponent(typeof(Text))
	arg0_8.timelimtPanel = arg0_8:findTF("timelimt", arg0_8.rightPanel)
	arg0_8.timelimitBtn = arg0_8:findTF("timelimit_btn", arg0_8.timelimtPanel)
	arg0_8.timelimitPriceTxt = arg0_8:findTF("consume/Text", arg0_8.timelimtPanel):GetComponent(typeof(Text))
	arg0_8.live2dFilter = arg0_8.topTF:Find("live2d")
	arg0_8.live2dFilterSel = arg0_8.live2dFilter:Find("selected")
	arg0_8.indexBtn = arg0_8.topTF:Find("index_btn")
	arg0_8.indexBtnSel = arg0_8.indexBtn:Find("sel")
	arg0_8.inptuTr = arg0_8.topTF:Find("search")
	arg0_8.changeBtn = arg0_8.topTF:Find("change_btn")

	setText(arg0_8.inptuTr:Find("holder"), i18n("skinatlas_search_holder"))

	arg0_8.furnBg = arg0_8:findTF("Main/right/bg/furn")
	arg0_8.bgMask = arg0_8:findTF("Main/right/bg/mask")
	arg0_8.charBg = arg0_8:findTF("Main/right/bg/char")
	arg0_8.switchBtn = arg0_8:findTF("Main/right/bg/switch")
	arg0_8.bgRoot = arg0_8:findTF("bgs/bg")
	arg0_8.bg1 = arg0_8:findTF("bgs/bg/bg_1")
	arg0_8.bg2 = arg0_8:findTF("bgs/bg/bg_2")
	arg0_8.bgType = false
	arg0_8.defaultBg = arg0_8.bg1:GetComponent(typeof(Image)).sprite
	arg0_8.blurPanel = arg0_8:findTF("Main/blur_panel")
	arg0_8.emptyTr = arg0_8:findTF("bgs/empty")
	Input.multiTouchEnabled = false
	arg0_8.viewMode = arg0_8.contextData.type or var0_0.SHOP_TYPE_COMMON
	arg0_8.hideObjToggleTF = arg0_8:findTF("toggles/hideObjToggle", arg0_8.rightPanel)

	setActive(arg0_8.hideObjToggleTF, false)

	arg0_8.switchCnt = 0
	arg0_8.l2dPreViewToggle = arg0_8:findTF("toggles/l2d_preview", arg0_8.rightPanel)
	arg0_8.l2dDownloadStateTf = arg0_8:findTF("toggles/l2d_res_state", arg0_8.rightPanel)
	arg0_8.l2dUnDownload = arg0_8.l2dDownloadStateTf:Find("undownload")
	arg0_8.l2dDownloaded = arg0_8.l2dDownloadStateTf:Find("downloaded")
	arg0_8.live2dContainer = arg0_8:findTF("painting/paint/live2d")
	arg0_8.paintingContainer = arg0_8:findTF("painting")
	arg0_8.spTF = arg0_8:findTF("painting/paint/spinePainting")
	arg0_8.spBg = arg0_8:findTF("painting/paintBg/spinePainting")
	arg0_8.defaultIndex = {
		typeIndex = ShipIndexConst.TypeAll,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = SkinIndexLayer.ExtraALL
	}
end

function var0_0.didEnter(arg0_9)
	arg0_9:bind(var0_0.EVENT_ON_CARD_CLICK, function(arg0_10, arg1_10)
		arg0_9:OnCardClick(arg1_10)
	end)
	arg0_9:initShips()
	arg0_9:initSkinPage()

	if arg0_9.contextData.skinId then
		arg0_9:JumpToSkinById(arg0_9.contextData.skinId)
	end

	onButton(arg0_9, arg0_9.topTF:Find("back_btn"), function()
		arg0_9:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.bottomTF:Find("bg/atlas"), function()
		arg0_9:emit(SkinShopMediator.ON_ATLAS)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.bottomTF:Find("bg/right_arr"), function()
		arg0_9:onNext()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.bottomTF:Find("bg/left_arr"), function()
		arg0_9:onPrev()
	end, SFX_PANEL)

	arg0_9.inSkinMode = true

	onButton(arg0_9, arg0_9.switchBtn, function()
		arg0_9:SwitchCharBg()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.indexBtn, function()
		arg0_9:emit(SkinShopMediator.ON_INDEX, {
			OnFilter = function(arg0_17)
				arg0_9:OnFilter(arg0_17)
			end,
			defaultIndex = arg0_9.defaultIndex
		})
	end, SFX_PANEL)
	onInputChanged(arg0_9, arg0_9.inptuTr, function()
		arg0_9:OnSearch()
	end)

	local var0_9 = true

	onButton(arg0_9, arg0_9.changeBtn, function()
		var0_9 = not var0_9

		setActive(arg0_9.inptuTr, var0_9)
		setActive(arg0_9.indexBtn, var0_9)
		setActive(arg0_9.live2dFilter, not var0_9)

		if getInputText(arg0_9.inptuTr) ~= "" then
			setInputText(arg0_9.inptuTr, "")
		end
	end, SFX_PANEL)
	triggerButton(arg0_9.changeBtn)
	onButton(arg0_9, arg0_9.live2dFilter, function()
		if arg0_9.defaultIndex.extraIndex == SkinIndexLayer.ExtraL2D then
			arg0_9.defaultIndex.extraIndex = SkinIndexLayer.ExtraALL
		else
			arg0_9.defaultIndex.extraIndex = SkinIndexLayer.ExtraL2D
		end

		arg0_9:OnFilter(arg0_9.defaultIndex)
	end, SFX_PANEL)
end

function var0_0.OnSkinListUpdate(arg0_21, arg1_21)
	local var0_21 = arg1_21 == 0

	setActive(arg0_21.emptyTr, var0_21)
	setActive(arg0_21.rightPanel, not var0_21)
	setActive(arg0_21.paintingContainer, not var0_21)
	setActive(arg0_21.namePanel, not var0_21)
end

function var0_0.OnSearch(arg0_22)
	arg0_22:updateShipRect()
end

function var0_0.OnFilter(arg0_23, arg1_23)
	arg0_23.defaultIndex = {
		typeIndex = arg1_23.typeIndex,
		campIndex = arg1_23.campIndex,
		rarityIndex = arg1_23.rarityIndex,
		extraIndex = arg1_23.extraIndex
	}

	setActive(arg0_23.live2dFilterSel, arg1_23.extraIndex == SkinIndexLayer.ExtraL2D)
	arg0_23:updateShipRect()
	setActive(arg0_23.indexBtnSel, arg1_23.typeIndex ~= ShipIndexConst.TypeAll or arg1_23.campIndex ~= ShipIndexConst.CampAll or arg1_23.rarityIndex ~= ShipIndexConst.RarityAll or arg1_23.extraIndex ~= SkinIndexLayer.ExtraALL)
end

function var0_0.JumpToSkinById(arg0_24, arg1_24)
	local var0_24 = -1
	local var1_24 = {}

	for iter0_24, iter1_24 in ipairs(arg0_24.displays) do
		if arg1_24 == iter1_24:getSkinId() then
			var0_24 = iter0_24
			var1_24 = iter1_24
		end
	end

	if var0_24 == -1 then
		return
	end

	local var2_24 = arg0_24.shipRect:HeadIndexToValue(var0_24 - 1)

	arg0_24.shipRect:ScrollTo(var2_24)
	onNextTick(function()
		for iter0_25, iter1_25 in pairs(arg0_24.cards) do
			if iter1_25.goodsVO.id == var1_24.id then
				triggerButton(iter1_25._tf)

				break
			end
		end
	end)
end

function var0_0.SwitchCharBg(arg0_26, arg1_26)
	local var0_26 = arg0_26.furnBg
	local var1_26 = arg0_26.charBg

	if not arg1_26 then
		if LeanTween.isTweening(go(var0_26)) or LeanTween.isTweening(go(var1_26)) then
			return
		end
	else
		LeanTween.cancel(go(var0_26))
		LeanTween.cancel(go(var1_26))
	end

	local var2_26 = arg0_26.goodsId and _.detect(arg0_26.skinGoodsVOs, function(arg0_27)
		return arg0_27.id == arg0_26.goodsId
	end)

	if not var2_26 then
		return
	end

	local function var3_26()
		setActive(arg0_26.charParent, arg0_26.inSkinMode)
		setActive(arg0_26.furParent, not arg0_26.inSkinMode)
	end

	local var4_26 = var0_26:GetComponent(typeof(CanvasGroup))
	local var5_26 = var1_26:GetComponent(typeof(CanvasGroup))
	local var6_26 = var4_26.alpha
	local var7_26 = var5_26.alpha
	local var8_26 = var0_26.anchoredPosition3D
	local var9_26 = var1_26.anchoredPosition3D

	LeanTween.moveLocal(go(var0_26), var9_26, 0.3):setOnComplete(System.Action(function()
		var4_26.alpha = var7_26
	end))
	LeanTween.moveLocal(go(var1_26), var8_26, 0.3):setOnComplete(System.Action(function()
		var5_26.alpha = var6_26

		var3_26()
	end))

	arg0_26.inSkinMode = not arg0_26.inSkinMode

	if arg0_26.inSkinMode then
		var0_26:SetAsFirstSibling()
		var1_26:SetSiblingIndex(2)
	else
		var1_26:SetAsFirstSibling()
		var0_26:SetSiblingIndex(2)

		local var10_26 = Goods.Id2FurnitureId(var2_26.id)
		local var11_26 = Goods.GetFurnitureConfig(var2_26.id)

		arg0_26.interactionPreview:Flush(var2_26:getSkinId(), var10_26, var11_26.scale[2] or 1, var11_26.position[2])
	end

	arg0_26:updateBuyBtn(var2_26)
	arg0_26:updatePrice(var2_26)
end

function var0_0.initSkinPage(arg0_31)
	local var0_31 = {}

	arg0_31.countByIds = {}

	for iter0_31, iter1_31 in ipairs(var1_0.all) do
		if iter1_31 == var0_0.PAGE_PROPOSE or iter1_31 == var0_0.PAGE_TRANS then
			-- block empty
		else
			arg0_31.countByIds[iter1_31] = 0

			table.insert(var0_31, iter1_31)
		end
	end

	for iter2_31, iter3_31 in ipairs(arg0_31.skinGoodsVOs) do
		local var1_31 = iter3_31:getSkinId()

		print(var1_31)

		local var2_31 = var2_0[var1_31]

		if not var2_31 then
			print("not found = " .. var1_31)
		end

		local var3_31 = var2_31.shop_type_id

		print(var3_31)

		local var4_31 = var3_31 == 0 and 9999 or var3_31

		arg0_31.countByIds[var4_31] = arg0_31.countByIds[var4_31] + 1
	end

	local var5_31 = arg0_31:findTF("toggles/mask/content", arg0_31.leftPanel)
	local var6_31 = {}

	for iter4_31, iter5_31 in ipairs(var0_31) do
		if arg0_31.countByIds[iter5_31] > 0 then
			table.insert(var6_31, iter5_31)
		end
	end

	if arg0_31.existAnyEncoreSkin then
		table.insert(var6_31, var0_0.PAGE_ENCORE)
	end

	assert(not table.contains(var6_31, var0_0.PAGE_ALL) and not table.contains(var6_31, var0_0.PAGE_TIME_LIMIT))

	if arg0_31.viewMode == var0_0.SHOP_TYPE_TIMELIMIT then
		table.insert(var6_31, 1, var0_0.PAGE_TIME_LIMIT)
	end

	table.insert(var6_31, 1, var0_0.PAGE_ALL)

	arg0_31.pageTFs, arg0_31.mid = {}, 4

	local var7_31 = var5_31.parent:Find("0")

	arg0_31.skinPageToggles = {}

	for iter6_31, iter7_31 in ipairs(var6_31) do
		local var8_31 = cloneTplTo(var7_31, var5_31, iter7_31)

		setActive(var8_31, true)

		arg0_31.skinPageToggles[iter7_31] = var8_31:Find("toggle")

		onButton(arg0_31, var8_31, function()
			local var0_32

			for iter0_32, iter1_32 in ipairs(arg0_31.pageTFs) do
				if tonumber(go(iter1_32).name) == iter7_31 then
					var0_32 = iter0_32

					break
				end
			end

			local var1_32 = var0_32 - arg0_31.mid

			for iter2_32 = 1, math.abs(var1_32) do
				arg0_31:onSwitch(var1_32)
			end

			arg0_31:onRelease()
		end, SFX_PANEL)
		arg0_31:UpdateTagStyle(var8_31, var1_0, iter7_31)
	end

	eachChild(var5_31, function(arg0_33)
		if arg0_33.gameObject.activeSelf then
			table.insert(arg0_31.pageTFs, 1, arg0_33)
		end
	end)
	arg0_31:addVerticalDrag(arg0_31.leftPanel, function(arg0_34)
		arg0_31:onSwitch(arg0_34)
	end, function()
		arg0_31:onRelease()
	end)
	arg0_31:UpdateViewMode(var5_31)
end

function var0_0.onSwitch(arg0_36, arg1_36)
	if arg1_36 > 0 then
		local var0_36 = table.remove(arg0_36.pageTFs, 1)

		var0_36:SetAsLastSibling()
		table.insert(arg0_36.pageTFs, var0_36)
	else
		local var1_36 = table.remove(arg0_36.pageTFs, #arg0_36.pageTFs)

		var1_36:SetAsFirstSibling()
		table.insert(arg0_36.pageTFs, 1, var1_36)
	end

	triggerToggle(arg0_36.pageTFs[arg0_36.mid]:Find("toggle"), true)
end

function var0_0.onRelease(arg0_37)
	local var0_37 = tonumber(go(arg0_37.pageTFs[arg0_37.mid]).name)

	arg0_37:index2PageId(var0_37)
end

function var0_0.index2PageId(arg0_38, arg1_38)
	arg0_38.contextData.pageId = arg1_38
	arg0_38.isSwitch = true

	arg0_38:updateShipRect(0)
	triggerToggle(arg0_38.skinPageToggles[arg1_38], true)
	arg0_38:SwitchCntPlusPlus()
end

function var0_0.UpdateViewMode(arg0_39, arg1_39)
	local var0_39
	local var1_39
	local var2_39

	if arg0_39.viewMode == var0_0.SHOP_TYPE_TIMELIMIT then
		var0_39 = var0_0.PAGE_TIME_LIMIT
	elseif arg0_39.viewMode == var0_0.SHOP_TYPE_COMMON then
		var0_39 = arg0_39.contextData.warp or var0_0.PAGE_ALL
	end

	setActive(arg0_39.leftPanel, arg0_39.viewMode == var0_0.SHOP_TYPE_COMMON)
	triggerButton(arg1_39:Find(var0_39))
	setImageSprite(arg0_39.title, GetSpriteFromAtlas("ui/SkinShopUI_atlas", var3_0[arg0_39.viewMode][1]), true)
	setImageSprite(arg0_39.titleEn, GetSpriteFromAtlas("ui/SkinShopUI_atlas", var3_0[arg0_39.viewMode][2]), true)
end

function var0_0.UpdateTagStyle(arg0_40, arg1_40, arg2_40, arg3_40)
	if arg2_40[arg3_40] then
		setImageSprite(arg1_40:Find("name"), GetSpriteFromAtlas("SkinClassified", "text_" .. arg2_40[arg3_40].res .. "01"), true)
		setImageSprite(arg1_40:Find("selected/Image"), GetSpriteFromAtlas("SkinClassified", "text_" .. arg2_40[arg3_40].res), true)
		setText(arg1_40:Find("eng"), string.upper(arg2_40[arg3_40].english_name or ""))
	elseif arg3_40 == var0_0.PAGE_ALL then
		setImageSprite(arg1_40:Find("name"), GetSpriteFromAtlas("SkinClassified", "text_all01"), true)
		setImageSprite(arg1_40:Find("selected/Image"), GetSpriteFromAtlas("SkinClassified", "text_all"), true)
		setText(arg1_40:Find("eng"), "ALL")
	elseif arg3_40 == var0_0.PAGE_ENCORE then
		setImageSprite(arg1_40:Find("name"), GetSpriteFromAtlas("SkinClassified", "text_fanchang"), true)
		setImageSprite(arg1_40:Find("selected/Image"), GetSpriteFromAtlas("SkinClassified", "text_fanchang01"), true)
		setText(arg1_40:Find("eng"), "RETURN")
	end
end

function var0_0.updateMainView(arg0_41, arg1_41)
	local var0_41 = arg1_41.shipSkinConfig

	arg0_41.showCardId = arg1_41.goodsVO.id

	local var1_41 = ShipGroup.getDefaultShipConfig(var0_41.ship_group)

	arg0_41.nameTxt.text = var1_41.name
	arg0_41.skinNameTxt.text = SwitchSpecialChar(var0_41.name, true)

	local var2_41 = var0_41.prefab

	if arg0_41.prefabName ~= var2_41 then
		arg0_41:loadChar(var2_41, var0_41)

		arg0_41.prefabName = var2_41
	end

	local var3_41 = var0_41.painting
	local var4_41 = checkABExist("painting/" .. var3_41 .. "_n")

	setActive(arg0_41.hideObjToggleTF, var4_41)

	local var5_41 = false

	eachChild(arg0_41.tags, function(arg0_42)
		local var0_42 = go(arg0_42).name
		local var1_42 = table.contains(var0_41.tag, tonumber(var0_42))

		if var1_42 then
			var5_41 = true
		end

		setActive(arg0_42, var1_42)
	end)

	if not var4_41 and var0_41.bg_sp ~= "" then
		arg0_41:setBg(var1_41, var0_41, true)
	else
		arg0_41:setBg(var1_41, var0_41, var4_41)
	end

	arg0_41:updatePrice(arg1_41.goodsVO)
	arg0_41:removeShopTimer()
	arg0_41:addShopTimer(arg1_41)
	arg0_41:updateBuyBtn(arg1_41.goodsVO)

	local var6_41 = {
		false
	}

	arg0_41:UpdateLiveToggle(var0_41.id, var6_41)

	if var6_41[1] == false and arg0_41.painting ~= var3_41 then
		arg0_41:loadPainting(var3_41, true)

		arg0_41.painting = var3_41
	end

	arg0_41.goodsId = arg1_41.goodsVO.id
end

function var0_0.UpdateLiveToggle(arg0_43, arg1_43, arg2_43)
	local var0_43 = ShipSkin.New({
		id = arg1_43
	})
	local var1_43 = var0_43:IsSpine()
	local var2_43 = var0_43:IsLive2d()
	local var3_43 = var2_43 or var1_43
	local var4_43 = getProxy(PlayerProxy):getRawData().id
	local var5_43 = PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. var4_43, 0) == 1
	local var6_43 = pg.ship_skin_template[var0_43.id].painting
	local var7_43 = checkABExist("painting/" .. var6_43 .. "_n")
	local var8_43 = true

	if var3_43 then
		onToggle(arg0_43, arg0_43.l2dPreViewToggle, function(arg0_44)
			setActive(arg0_43.hideObjToggleTF, not arg0_44 and var7_43)
			setActive(arg0_43.l2dDownloadStateTf, arg0_44)

			if arg0_44 then
				PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var4_43, 1)

				if var2_43 then
					arg0_43:UpdateLive2dDownloadState(var0_43, arg2_43)
				elseif var1_43 then
					arg0_43:UpdateSpineState(var0_43, arg2_43)
				end
			else
				PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var4_43, 0)
				arg0_43:loadPainting(var6_43, arg0_43.isHideObj)

				arg0_43.painting = var6_43
			end

			PlayerPrefs.Save()

			if not var8_43 then
				arg0_43:emit(SkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg0_44)
			else
				var8_43 = false
			end
		end, SFX_PANEL)
	else
		removeOnToggle(arg0_43.l2dPreViewToggle)
		setActive(arg0_43.l2dDownloadStateTf, false)
		setActive(arg0_43.hideObjToggleTF, var7_43)
	end

	triggerToggle(arg0_43.l2dPreViewToggle, var5_43)
	setActive(arg0_43.l2dPreViewToggle, var3_43)

	arg0_43.skinId = arg1_43
end

function var0_0.UpdateSpineState(arg0_45, arg1_45, arg2_45)
	local var0_45 = pg.ship_skin_template[arg1_45.id].painting
	local var1_45 = "SpinePainting/" .. string.lower(var0_45)
	local var2_45 = HXSet.autoHxShiftPath(var1_45, nil, true)
	local var3_45 = checkABExist(var2_45)

	setActive(arg0_45.l2dUnDownload, not var3_45)
	setActive(arg0_45.l2dDownloaded, var3_45)

	if not var3_45 then
		onButton(arg0_45, arg0_45.l2dDownloadStateTf, function()
			pg.TipsMgr.GetInstance():ShowTips("word_cmdClose")
		end, SFX_PANEL)

		if arg2_45 then
			arg2_45[1] = false
		end
	else
		if arg2_45 then
			arg2_45[1] = true
		end

		removeOnButton(arg0_45.l2dDownloadStateTf)
		arg0_45:LoadSpine(arg1_45)
	end
end

function var0_0.LoadSpine(arg0_47, arg1_47)
	arg0_47:recyclePainting()
	arg0_47:UnLoadLive2d()
	arg0_47:UnloadSpine()

	local var0_47 = pg.ship_skin_template[arg1_47.id].ship_group
	local var1_47 = ShipGroup.getDefaultShipConfig(var0_47)
	local var2_47 = SpinePainting.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var1_47.id,
			skin_id = arg1_47.id
		}),
		position = Vector3(0, 0, 0),
		parent = arg0_47.spTF,
		effectParent = arg0_47.spBg
	})

	arg0_47.spinePainting = SpinePainting.New(var2_47, function(arg0_48)
		return
	end)
end

function var0_0.UnloadSpine(arg0_49, arg1_49)
	if arg0_49.spinePainting then
		arg0_49.spinePainting:Dispose()

		arg0_49.spinePainting = nil
	end
end

function var0_0.UpdateLive2dDownloadState(arg0_50, arg1_50, arg2_50)
	local var0_50 = pg.ship_skin_template[arg1_50.id].painting
	local var1_50 = "live2d/" .. string.lower(var0_50)
	local var2_50 = HXSet.autoHxShiftPath(var1_50, nil, true)
	local var3_50 = checkABExist(var2_50)

	setActive(arg0_50.l2dUnDownload, not var3_50)
	setActive(arg0_50.l2dDownloaded, var3_50)

	if not var3_50 then
		onButton(arg0_50, arg0_50.l2dDownloadStateTf, function()
			if arg0_50.downloads[arg1_50.id] then
				return
			end

			local var0_51 = SkinShopDownloadRequest.New()

			arg0_50.downloads[arg1_50.id] = var0_51

			var0_51:Start(var2_50, function(arg0_52)
				if arg0_52 and arg0_50.skinId == arg1_50.id then
					arg0_50:UpdateLive2dDownloadState(arg1_50)
				end

				var0_51:Dispose()

				arg0_50.downloads[arg1_50.id] = nil
			end)
		end, SFX_PANEL)

		if arg2_50 then
			arg2_50[1] = false
		end
	else
		if arg2_50 then
			arg2_50[1] = true
		end

		removeOnButton(arg0_50.l2dDownloadStateTf)
		arg0_50:LoadL2d(arg1_50)
	end
end

function var0_0.LoadL2d(arg0_53, arg1_53)
	arg0_53:recyclePainting()
	arg0_53:UnLoadLive2d()
	arg0_53:UnloadSpine()

	local var0_53 = pg.ship_skin_template[arg1_53.id].ship_group
	local var1_53 = ShipGroup.getDefaultShipConfig(var0_53)
	local var2_53 = Live2D.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var1_53.id,
			skin_id = arg1_53.id
		}),
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -1),
		parent = arg0_53.live2dContainer
	})

	var2_53.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_53.live2dChar = Live2D.New(var2_53, function(arg0_54)
		arg0_53:recyclePainting()
		arg0_54:IgonreReactPos(true)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.UnLoadLive2d(arg0_55, arg1_55)
	if arg0_55.live2dChar then
		arg0_55.live2dChar:Dispose()

		arg0_55.live2dChar = nil
	end
end

function var0_0.setBg(arg0_56, arg1_56, arg2_56, arg3_56)
	local var0_56 = Ship.New({
		configId = arg1_56.id,
		skin_id = arg2_56.id
	})
	local var1_56 = var0_56:getShipBgPrint(true)

	if arg3_56 and arg2_56.bg_sp ~= "" then
		var1_56 = arg2_56.bg_sp
	end

	if var1_56 ~= var0_56:rarity2bgPrintForGet() then
		local var2_56 = arg0_56:GetCurBgTransform()

		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_56, var1_56, arg0_56.bgRoot, var2_56, function(arg0_57)
			return
		end, function(arg0_58)
			arg0_56:AnimBg()
		end)
	else
		setImageSprite(arg0_56:GetCurBgTransform(), arg0_56.defaultBg)
		arg0_56:AnimBg()
	end
end

function var0_0.GetCurBgTransform(arg0_59)
	local var0_59

	if not arg0_59.bgType then
		var0_59 = arg0_59.bg2
	else
		var0_59 = arg0_59.bg1
	end

	arg0_59.bgType = not arg0_59.bgType

	return var0_59
end

function var0_0.AnimBg(arg0_60)
	local var0_60
	local var1_60

	if arg0_60.bgType then
		var0_60 = arg0_60.bg2
		var1_60 = arg0_60.bg1
	else
		var0_60 = arg0_60.bg1
		var1_60 = arg0_60.bg2
	end

	LeanTween.cancel(go(arg0_60.bg2))
	LeanTween.cancel(go(arg0_60.bg1))
	setActive(var0_60, true)
	var0_60:SetAsLastSibling()
	LeanTween.alpha(var0_60, 1, 0.8):setFrom(0):setOnComplete(System.Action(function()
		setImageAlpha(var0_60, 1)
		setImageAlpha(var1_60, 0)
	end))
end

function var0_0.onBuyDone(arg0_62, arg1_62)
	local var0_62 = _.detect(arg0_62.skinGoodsVOs, function(arg0_63)
		return arg0_63.id == arg1_62
	end)

	if var0_62 then
		arg0_62:updateBuyBtn(var0_62)
		arg0_62:updatePrice(var0_62)
		arg0_62:removeShopTimer()
		arg0_62:addShopTimer({
			goodsVO = var0_62
		})
	end
end

function var0_0.OnFurnitureUpdate(arg0_64, arg1_64)
	if arg0_64.goodsId and arg1_64 and Goods.ExistFurniture(arg0_64.goodsId) and Goods.Id2FurnitureId(arg0_64.goodsId) == arg1_64 then
		local var0_64 = _.detect(arg0_64.skinGoodsVOs, function(arg0_65)
			return arg0_65.id == arg0_64.goodsId
		end)

		arg0_64:updateBuyBtn(var0_64)
	end
end

function var0_0.updateBuyBtn(arg0_66, arg1_66)
	local var0_66 = arg1_66:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_66

	if var0_66 then
		onButton(arg0_66, arg0_66.timelimitBtn, function()
			local var0_67 = arg1_66:getSkinId()
			local var1_67 = getProxy(ShipSkinProxy):getSkinById(var0_67)

			if var1_67 and not var1_67:isExpireType() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

				return
			end

			arg0_66:showTimeLimitSkinWindow(arg1_66)
		end, SFX_PANEL)

		var1_66 = var2_0[arg1_66:getSkinId()]
	else
		local var2_66 = arg1_66:getSkinId()

		var1_66 = var2_0[var2_66]

		local var3_66 = arg1_66.type
		local var4_66 = var3_66 == Goods.TYPE_ACTIVITY or var3_66 == Goods.TYPE_ACTIVITY_EXTRA
		local var5_66 = arg1_66.buyCount == 0
		local var6_66 = arg1_66:isDisCount() and arg1_66:IsItemDiscountType()
		local var7_66 = not arg0_66.inSkinMode
		local var8_66 = false

		if var7_66 then
			var8_66 = getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_66.id))
		end

		setActive(arg0_66.itemBtn, var6_66 and var5_66 and not var7_66)
		setActive(arg0_66.buyBtn, not var4_66 and var5_66 and not var6_66 and not var7_66)
		setActive(arg0_66.gotBtn, not var4_66 and not var5_66 and not var7_66 or var7_66 and var8_66)
		setActive(arg0_66.activityBtn, var4_66 and not var6_66 and not var7_66)
		setActive(arg0_66.backyardBtn, var7_66 and not var8_66)
		onButton(arg0_66, arg0_66.itemBtn, function()
			triggerButton(arg0_66.buyBtn)
		end, SFX_PANEL)
		onButton(arg0_66, arg0_66.buyBtn, function()
			local var0_69 = arg1_66

			if var0_69.type == Goods.TYPE_SKIN then
				if arg0_66.showCardId == var0_69.id then
					if arg1_66:isDisCount() and var0_69:IsItemDiscountType() then
						arg0_66:emit(SkinShopMediator.ON_SHOPPING_BY_ACT, var0_69.id, 1)
					else
						local var1_69 = var0_69:GetPrice()
						local var2_69 = i18n("charge_scene_buy_confirm", var1_69, var1_66.name)

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = var2_69,
							onYes = function()
								arg0_66:emit(SkinShopMediator.ON_SHOPPING, var0_69.id, 1)
							end
						})
					end
				else
					pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[9999])

					return
				end
			end
		end, SFX_PANEL)
		onButton(arg0_66, arg0_66.activityBtn, function()
			local var0_71 = arg1_66
			local var1_71 = var0_71:getConfig("time")
			local var2_71 = var0_71:getConfig("activity")
			local var3_71 = getProxy(ActivityProxy):getActivityById(var2_71)

			if var2_71 == 0 and pg.TimeMgr.GetInstance():inTime(var1_71) or var3_71 and not var3_71:isEnd() then
				if var0_71.type == Goods.TYPE_ACTIVITY then
					arg0_66:emit(SkinShopMediator.GO_SHOPS_LAYER, var0_71:getConfig("activity"))
				elseif var0_71.type == Goods.TYPE_ACTIVITY_EXTRA then
					local var4_71 = var0_71:getConfig("scene")

					if var4_71 and #var4_71 > 0 then
						arg0_66:emit(SkinShopMediator.OPEN_SCENE, var4_71)
					else
						arg0_66:emit(SkinShopMediator.OPEN_ACTIVITY, var2_71)
					end
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
			end
		end, SFX_PANEL)
		onButton(arg0_66, arg0_66.backyardBtn, function()
			arg0_66:emit(SkinShopMediator.ON_BACKYARD_SHOP)
		end, SFX_PANEL)
	end

	local var9_66 = ShipGroup.getDefaultShipConfig(var1_66.ship_group)

	removeOnToggle(arg0_66.hideObjToggleTF)
	triggerToggle(arg0_66.hideObjToggleTF, true)

	arg0_66.isHideObj = true

	onToggle(arg0_66, arg0_66.hideObjToggleTF, function(arg0_73)
		arg0_66.isHideObj = arg0_73

		local var0_73 = arg0_66.painting

		arg0_66:loadPainting(var0_73, arg0_73)

		arg0_66.painting = var0_73

		arg0_66:setBg(var9_66, var1_66, arg0_73)
	end, SFX_PANEL)
end

function var0_0.showTimeLimitSkinWindow(arg0_74, arg1_74)
	local var0_74 = arg1_74:getConfig("resource_num")
	local var1_74 = arg1_74:getConfig("time_second") * var0_74
	local var2_74 = arg1_74:getSkinId()
	local var3_74 = pg.ship_skin_template[var2_74]

	assert(var3_74)

	local var4_74, var5_74, var6_74, var7_74 = pg.TimeMgr.GetInstance():parseTimeFrom(var1_74)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var0_74, var3_74.name, var4_74, var5_74),
		onYes = function()
			if arg0_74.skinTicket < var0_74 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_74:emit(SkinShopMediator.ON_SHOPPING, arg1_74.id, 1)
		end
	})
end

function var0_0.addShopTimer(arg0_76, arg1_76)
	local var0_76 = arg1_76.goodsVO
	local var1_76 = var0_76:getSkinId()

	if arg0_76.skinTimer then
		arg0_76.skinTimer:Stop()
	end

	setActive(tf(go(arg0_76.limitTxt)).parent, true)

	if var0_76:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var2_76 = getProxy(ShipSkinProxy):getSkinById(var1_76)
		local var3_76 = var2_76 and var2_76:isExpireType() and not var2_76:isExpired()

		setActive(tf(go(arg0_76.limitTxt)).parent, var3_76)

		if var3_76 then
			arg0_76.skinTimer = Timer.New(function()
				local var0_77 = skinTimeStamp(var2_76:getRemainTime())

				arg0_76.limitTxt.text = var0_77
			end, 1, -1)

			arg0_76.skinTimer:Start()
			arg0_76.skinTimer.func()
		else
			setActive(tf(go(arg0_76.limitTxt)).parent, false)
		end
	else
		local var4_76, var5_76 = pg.TimeMgr.GetInstance():inTime(var0_76:getConfig("time"))

		if not var5_76 then
			setActive(tf(go(arg0_76.limitTxt)).parent, false)

			return
		end

		local var6_76 = pg.TimeMgr.GetInstance()
		local var7_76 = var6_76:Table2ServerTime(var5_76)

		arg0_76.shopTimer = Timer.New(function()
			local var0_78 = var6_76:GetServerTime()

			if var0_78 > var7_76 then
				arg0_76:removeShopTimer()
			end

			local var1_78 = var7_76 - var0_78

			var1_78 = var1_78 < 0 and 0 or var1_78

			local var2_78 = math.floor(var1_78 / 86400)

			if var2_78 > 0 then
				arg0_76.limitTxt.text = i18n("time_remaining_tip") .. var2_78 .. i18n("word_date")
			else
				local var3_78 = math.floor(var1_78 / 3600)

				if var3_78 > 0 then
					arg0_76.limitTxt.text = i18n("time_remaining_tip") .. var3_78 .. i18n("word_hour")
				else
					local var4_78 = math.floor(var1_78 / 60)

					if var4_78 > 0 then
						arg0_76.limitTxt.text = i18n("time_remaining_tip") .. var4_78 .. i18n("word_minute")
					else
						arg0_76.limitTxt.text = i18n("time_remaining_tip") .. var1_78 .. i18n("word_second")
					end
				end
			end
		end, 1, -1)

		arg0_76.shopTimer:Start()
		arg0_76.shopTimer.func()
	end
end

function var0_0.removeShopTimer(arg0_79)
	if arg0_79.shopTimer then
		arg0_79.shopTimer:Stop()

		arg0_79.shopTimer = nil
	end
end

function var0_0.updatePrice(arg0_80, arg1_80)
	local var0_80 = arg1_80:getSkinId()
	local var1_80 = var2_0[var0_80]
	local var2_80 = arg1_80
	local var3_80 = var2_80:getConfig("genre") == ShopArgs.SkinShopTimeLimit

	setActive(arg0_80.commonPanel, not var3_80)
	setActive(arg0_80.timelimtPanel, var3_80)

	if var3_80 then
		local var4_80 = var2_80:getConfig("resource_num")
		local var5_80 = (var4_80 > arg0_80.skinTicket and "<color=" .. COLOR_RED .. ">" or "") .. arg0_80.skinTicket .. (var4_80 > arg0_80.skinTicket and "</color>" or "")

		arg0_80.timelimitPriceTxt.text = var5_80 .. "/" .. var4_80
	elseif arg0_80.inSkinMode then
		local var6_80 = var2_80.type == Goods.TYPE_SKIN

		setActive(arg0_80.commonBGTF, var6_80)
		setActive(arg0_80.commonLabelTF, var6_80)
		setActive(arg0_80.commonConsumeTF, var6_80)

		if var6_80 then
			local var7_80 = (100 - var2_80:getConfig("discount")) / 100
			local var8_80 = var2_80:getConfig("resource_num")
			local var9_80 = var2_80:isDisCount()

			arg0_80.priceTxt.text = var2_80:GetPrice()
			arg0_80.originalPriceTxt.text = var8_80

			setActive(tf(go(arg0_80.originalPriceTxt)).parent, var9_80)
		end
	else
		local var10_80 = Goods.Id2FurnitureId(var2_80.id)
		local var11_80 = Furniture.New({
			id = var10_80
		})
		local var12_80 = var11_80:getConfig("gem_price")

		arg0_80.originalPriceTxt.text = var12_80

		local var13_80 = var11_80:getPrice(PlayerConst.ResDiamond)

		arg0_80.priceTxt.text = var13_80

		setActive(tf(go(arg0_80.originalPriceTxt)).parent, var12_80 ~= var13_80)
	end
end

function var0_0.loadPainting(arg0_81, arg1_81, arg2_81)
	arg0_81:recyclePainting()
	arg0_81:UnLoadLive2d()
	arg0_81:UnloadSpine()
	arg0_81:setPaintingPrefab(arg0_81.paintingTF, arg1_81, "chuanwu", arg2_81)
end

function var0_0.setPaintingPrefab(arg0_82, arg1_82, arg2_82, arg3_82, arg4_82)
	local var0_82 = findTF(arg1_82, "fitter")

	assert(var0_82, "请添加子物体fitter")
	removeAllChildren(var0_82)

	local var1_82 = GetOrAddComponent(var0_82, "PaintingScaler")

	var1_82.FrameName = arg3_82 or ""
	var1_82.Tween = 1

	local var2_82 = arg2_82

	if not arg4_82 and checkABExist("painting/" .. arg2_82 .. "_n") then
		arg2_82 = arg2_82 .. "_n"
	end

	if checkABExist("painting/" .. arg2_82) then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetPainting(arg2_82, true, function(arg0_83)
			pg.UIMgr.GetInstance():LoadingOff()
			setParent(arg0_83, var0_82, false)

			local var0_83 = findTF(arg0_83, "Touch")

			if not IsNil(var0_83) then
				setActive(var0_83, false)
			end

			ShipExpressionHelper.SetExpression(var0_82:GetChild(0), var2_82)
		end)
	end
end

function var0_0.recyclePainting(arg0_84)
	if arg0_84.painting then
		retPaintingPrefab(arg0_84.paintingTF, arg0_84.painting)
	end

	arg0_84.painting = nil
end

function var0_0.loadChar(arg0_85, arg1_85, arg2_85)
	arg0_85:recycleChar()
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(arg1_85, true, function(arg0_86)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_85.modelTf = tf(arg0_86)

		local var0_86 = pg.skinshop_spine_scale[arg2_85.id]

		if var0_86 then
			arg0_85.modelTf.localScale = Vector3(var0_86.skinshop_scale, var0_86.skinshop_scale, 1)
		else
			arg0_85.modelTf.localScale = Vector3(0.9, 0.9, 1)
		end

		arg0_85.modelTf.localPosition = Vector3(0, 0, 0)

		pg.ViewUtils.SetLayer(arg0_85.modelTf, Layer.UI)
		setParent(arg0_85.modelTf, arg0_85.charParent)
		arg0_86:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end)
end

function var0_0.recycleChar(arg0_87)
	if not IsNil(arg0_87.modelTf) then
		arg0_87.modelTf.gameObject:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0_87.prefabName, arg0_87.modelTf.gameObject)
	end

	if arg0_87.timer then
		arg0_87.timer:Stop()

		arg0_87.timer = nil
	end
end

function var0_0.OnCardClick(arg0_88, arg1_88)
	if arg0_88.card and arg0_88.contextData.key == arg1_88.goodsVO:getKey() then
		return
	end

	if arg0_88.contextData.key then
		for iter0_88, iter1_88 in pairs(arg0_88.cards) do
			if iter1_88.goodsVO:getKey() == arg0_88.contextData.key then
				iter1_88:updateSelected(false)
			end
		end
	end

	arg1_88:updateSelected(true)

	arg0_88.contextData.key = arg1_88.goodsVO:getKey()
	arg0_88.card = arg1_88

	if not arg0_88.inSkinMode then
		arg0_88:SwitchCharBg(true)
	end

	arg0_88:updateMainView(arg1_88)
	arg0_88:UpdateSkinOrFurnitureMode(Goods.ExistFurniture(arg1_88.goodsVO.id))

	for iter2_88, iter3_88 in ipairs(arg0_88.displays) do
		if iter3_88 == arg0_88.card.goodsVO then
			arg0_88.index = iter2_88
		end
	end

	arg0_88:SwitchCntPlusPlus()
end

function var0_0.UpdateSkinOrFurnitureMode(arg0_89, arg1_89)
	setActive(arg0_89.switchBtn, arg1_89)
	setActive(arg0_89.furnBg, arg1_89)
	setActive(arg0_89.bgMask, arg1_89)
end

function var0_0.initShips(arg0_90)
	arg0_90.cards = {}
	arg0_90.shipRect = arg0_90.bottomTF:Find("scroll"):GetComponent("LScrollRect")

	function arg0_90.shipRect.onInitItem(arg0_91)
		local var0_91 = ShopSkinCard.New(arg0_91, arg0_90)

		arg0_90.cards[arg0_91] = var0_91
	end

	function arg0_90.shipRect.onUpdateItem(arg0_92, arg1_92)
		local var0_92 = arg0_90.cards[arg1_92]

		if not var0_92 then
			var0_92 = ShopSkinCard.New(arg1_92, arg0_90)
			arg0_90.cards[arg1_92] = var0_92
		end

		local var1_92 = arg0_90.displays[arg0_92 + 1]

		var0_92:update(var1_92)
		var0_92:updateSelected(arg0_90.contextData.key == var0_92.goodsVO:getKey())

		if arg0_90.isSwitch and arg0_92 == 0 then
			arg0_90.isSwitch = nil

			triggerButton(var0_92._tf)
		end
	end
end

function var0_0.SwitchCntPlusPlus(arg0_93)
	arg0_93.switchCnt = arg0_93.switchCnt + 1

	if arg0_93.switchCnt >= 2 then
		gcAll()

		arg0_93.switchCnt = 0
	end
end

function var0_0.onNext(arg0_94)
	if arg0_94.index == #arg0_94.displays then
		return
	end

	local var0_94

	for iter0_94, iter1_94 in ipairs(arg0_94.displays) do
		if iter1_94:getKey() == arg0_94.contextData.key then
			var0_94 = iter0_94

			break
		end
	end

	if var0_94 then
		local var1_94 = false
		local var2_94 = math.min(var0_94 + 1, #arg0_94.displays)

		arg0_94.index = var2_94

		local var3_94
		local var4_94 = arg0_94.displays[var2_94]

		for iter2_94, iter3_94 in pairs(arg0_94.cards) do
			if iter3_94.goodsVO:getKey() == var4_94:getKey() and iter3_94._tf.gameObject.name ~= "-1" then
				triggerButton(iter3_94._tf)

				var1_94 = true
				var3_94 = iter3_94

				break
			end
		end

		local function var5_94()
			local var0_95 = getBounds(arg0_94.bottomTF:Find("scroll"))
			local var1_95 = getBounds(var3_94._tf)
			local var2_95 = getBounds(arg0_94.card._tf)

			return math.ceil(var1_95:GetMax().x - var0_95:GetMax().x) > var2_95.size.x
		end

		if var1_94 and var5_94() then
			local var6_94 = arg0_94.shipRect:HeadIndexToValue(var2_94 - 1) - arg0_94.shipRect:HeadIndexToValue(var2_94)
			local var7_94 = arg0_94.shipRect.value - var6_94

			arg0_94.shipRect:SetNormalizedPosition(var7_94, 0)
		end
	end
end

function var0_0.onPrev(arg0_96)
	if arg0_96.index == 1 then
		return
	end

	local var0_96

	for iter0_96, iter1_96 in ipairs(arg0_96.displays) do
		if iter1_96:getKey() == arg0_96.contextData.key then
			var0_96 = iter0_96

			break
		end
	end

	if var0_96 then
		local var1_96 = false
		local var2_96 = math.max(var0_96 - 1, 1)

		arg0_96.index = var2_96

		local var3_96 = arg0_96.displays[var2_96]

		for iter2_96, iter3_96 in pairs(arg0_96.cards) do
			if iter3_96.goodsVO:getKey() == var3_96:getKey() and iter3_96._tf.gameObject.name ~= "-1" then
				triggerButton(iter3_96._tf)

				var1_96 = true

				break
			end
		end

		local function var4_96()
			local var0_97 = getBounds(arg0_96.bottomTF:Find("scroll"))
			local var1_97 = getBounds(arg0_96.bottomTF:Find("scroll/content"))
			local var2_97 = getBounds(arg0_96.card._tf)

			return var1_97:GetMin().x < var0_97:GetMin().x and var2_97:GetMin().x < var0_97:GetMin().x
		end

		if var1_96 and var4_96() then
			local var5_96 = arg0_96.shipRect:HeadIndexToValue(var2_96 - 1)

			arg0_96.shipRect:SetNormalizedPosition(var5_96, 0)
		end
	end
end

function var0_0.updateShipRect(arg0_98, arg1_98)
	arg0_98.card = nil

	if arg0_98.contextData.pageId and arg0_98.shipRect then
		arg0_98.displays = {}

		local function var0_98(arg0_99)
			return arg0_98.encoreSkinMap[arg0_99] == true
		end

		local var1_98 = {}

		local function var2_98(arg0_100)
			if #var1_98 == 0 then
				for iter0_100, iter1_100 in ipairs(arg0_98.skinGoodsVOs) do
					if iter1_100:getConfig("genre") == ShopArgs.SkinShop then
						local var0_100 = iter1_100:getSkinId()

						var1_98[var0_100] = true
					end
				end
			end

			return var1_98[arg0_100] == true
		end

		for iter0_98, iter1_98 in ipairs(arg0_98.skinGoodsVOs) do
			local var3_98 = iter1_98:getSkinId()
			local var4_98 = var2_0[var3_98].shop_type_id
			local var5_98 = var4_98 == 0 and 9999 or var4_98
			local var6_98 = iter1_98:getConfig("genre") == ShopArgs.SkinShopTimeLimit
			local var7_98 = arg0_98.contextData.pageId

			if var6_98 and var7_98 == var0_0.PAGE_TIME_LIMIT and var2_98(var3_98) or not var6_98 and (var7_98 == var0_0.PAGE_ALL or var5_98 == arg0_98.contextData.pageId) or not var6_98 and var7_98 == var0_0.PAGE_ENCORE and var0_98(iter1_98.id) then
				local var8_98 = ShipSkin.New({
					id = var3_98
				})

				if arg0_98:MatchIndex(var8_98) and var8_98:IsMatchKey(getInputText(arg0_98.inptuTr)) then
					table.insert(arg0_98.displays, iter1_98)
				end
			end
		end

		local function var9_98(arg0_101, arg1_101)
			local var0_101 = (arg0_101.type == Goods.TYPE_ACTIVITY or arg0_101.type == Goods.TYPE_ACTIVITY_EXTRA) and 0 or arg0_101:GetPrice()
			local var1_101 = (arg1_101.type == Goods.TYPE_ACTIVITY or arg1_101.type == Goods.TYPE_ACTIVITY_EXTRA) and 0 or arg1_101:GetPrice()

			if var0_101 == var1_101 then
				return arg0_101.id < arg1_101.id
			else
				return var1_101 < var0_101
			end
		end

		table.sort(arg0_98.displays, function(arg0_102, arg1_102)
			local var0_102 = arg0_102.buyCount == 0 and 1 or 0
			local var1_102 = arg1_102.buyCount == 0 and 1 or 0

			if var0_102 == var1_102 then
				local var2_102 = arg0_102:getConfig("order")
				local var3_102 = arg1_102:getConfig("order")

				if var2_102 == var3_102 then
					return var9_98(arg0_102, arg1_102)
				else
					return var2_102 < var3_102
				end
			else
				return var1_102 < var0_102
			end
		end)

		if arg1_98 then
			arg0_98.shipRect:SetTotalCount(#arg0_98.displays, arg1_98)
		else
			arg0_98.shipRect:SetTotalCount(#arg0_98.displays)
		end

		arg0_98:OnSkinListUpdate(#arg0_98.displays)
	end
end

function var0_0.ToVShip(arg0_103, arg1_103)
	if not arg0_103.vship then
		arg0_103.vship = {}

		function arg0_103.vship.getNation()
			return arg0_103.vship.config.nationality
		end

		function arg0_103.vship.getShipType()
			return arg0_103.vship.config.type
		end

		function arg0_103.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_103.vship.config.type)
		end

		function arg0_103.vship.getRarity()
			return arg0_103.vship.config.rarity
		end
	end

	arg0_103.vship.config = arg1_103

	return arg0_103.vship
end

function var0_0.MatchIndex(arg0_108, arg1_108)
	local var0_108 = arg1_108:GetDefaultShipConfig()

	if not var0_108 then
		return false
	end

	local var1_108 = arg0_108:ToVShip(var0_108)
	local var2_108 = ShipIndexConst.filterByType(var1_108, arg0_108.defaultIndex.typeIndex)
	local var3_108 = ShipIndexConst.filterByCamp(var1_108, arg0_108.defaultIndex.campIndex)
	local var4_108 = ShipIndexConst.filterByRarity(var1_108, arg0_108.defaultIndex.rarityIndex)
	local var5_108 = SkinIndexLayer.filterByExtra(arg1_108, arg0_108.defaultIndex.extraIndex)

	return var2_108 and var3_108 and var4_108 and var5_108
end

function var0_0.addVerticalDrag(arg0_109, arg1_109, arg2_109, arg3_109)
	local var0_109 = GetOrAddComponent(arg1_109, "EventTriggerListener")
	local var1_109 = 90
	local var2_109
	local var3_109 = 0
	local var4_109 = 0
	local var5_109 = 0

	var0_109:AddBeginDragFunc(function(arg0_110, arg1_110)
		var3_109 = 0
		var4_109 = 0
		var2_109 = arg1_110.position
		var5_109 = var2_109.y
	end)
	var0_109:AddDragFunc(function(arg0_111, arg1_111)
		if var5_109 > arg1_111.position.y and var4_109 ~= 0 then
			var2_109 = arg1_111.position
			var4_109 = 0
		elseif var5_109 < arg1_111.position.y and var3_109 ~= 0 then
			var2_109 = arg1_111.position
			var3_109 = 0
		end

		local var0_111 = arg1_111.position.y - var2_109.y
		local var1_111 = math.abs(math.floor(var0_111 / var1_109))

		if arg2_109 and var1_111 > var3_109 then
			var3_109 = var1_111

			arg2_109(var0_111)
		end

		if arg2_109 and var1_111 < var4_109 then
			var4_109 = var1_111

			arg2_109(var0_111)
		end

		var5_109 = var2_109.y
	end)
	var0_109:AddDragEndFunc(function(arg0_112, arg1_112)
		if arg3_109 then
			arg3_109()
		end
	end)
end

function var0_0.willExit(arg0_113)
	for iter0_113, iter1_113 in ipairs(arg0_113.cards) do
		iter1_113:Dispose()
	end

	arg0_113.cards = nil

	ClearEventTrigger(GetOrAddComponent(arg0_113._tf, "EventTriggerListener"))
	ClearLScrollrect(arg0_113.shipRect)

	arg0_113.shipRect = nil

	arg0_113:UnloadSpine()
	arg0_113:UnLoadLive2d()
	arg0_113:recycleChar()
	arg0_113:recyclePainting()
	arg0_113:removeShopTimer()

	for iter2_113, iter3_113 in pairs(arg0_113.downloads) do
		iter3_113:Dispose()
	end

	arg0_113.downloads = {}

	LeanTween.cancel(go(arg0_113.furnBg))
	LeanTween.cancel(go(arg0_113.charBg))
	LeanTween.cancel(go(arg0_113.bg1))
	LeanTween.cancel(go(arg0_113.bg2))

	Input.multiTouchEnabled = true

	arg0_113.interactionPreview:Dispose()

	arg0_113.interactionPreview = nil

	if arg0_113.skinTimer then
		arg0_113.skinTimer:Stop()
	end

	arg0_113.skinTimer = nil
	arg0_113.contextData.key = nil
	arg0_113.switchCnt = nil
	arg0_113.contextData.skinId = nil
end

return var0_0
