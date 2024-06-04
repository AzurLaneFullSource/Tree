local var0 = class("SkinShopScene", import("...base.BaseUI"))

var0.EVENT_ON_CARD_CLICK = "SkinShopScene:EVENT_ON_CARD_CLICK"

local var1 = pg.skin_page_template
local var2 = pg.ship_skin_template

var0.SHOP_TYPE_COMMON = 1
var0.SHOP_TYPE_TIMELIMIT = 2
var0.PAGE_ALL = -1
var0.PAGE_TIME_LIMIT = -2
var0.PAGE_ENCORE = -3
var0.PAGE_PROPOSE = 9998
var0.PAGE_TRANS = 9997
var0.MSGBOXNAME = "SkinShopMsgbox"

local var3 = {
	{
		"huanzhuangshagndian",
		"huanzhuangshagndian_en"
	},
	{
		"title_01",
		"title_en_01"
	}
}

function var0.forceGC(arg0)
	return true
end

function var0.getUIName(arg0)
	return "SkinShopUI"
end

function var0.ResUISettings(arg0)
	return {
		anim = true,
		showType = PlayerResUI.TYPE_GEM
	}
end

function var0.setSkins(arg0, arg1)
	arg0.skinList = arg1

	arg0:filterSkins()
end

function var0.SetEncoreSkins(arg0, arg1)
	arg0.existAnyEncoreSkin = #arg1 > 0
	arg0.encoreSkinMap = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.encoreSkinMap[iter1] = true
	end
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1
	arg0.skinTicket = arg0.playerVO:getSkinTicket()
end

function var0.filterSkins(arg0)
	arg0.skinGoodsVOs = getProxy(ShipSkinProxy):GetAllSkins()

	arg0:updateShipRect()
end

function var0.init(arg0)
	arg0.downloads = {}
	arg0.bottomTF = arg0:findTF("Main/bottom")
	arg0.topTF = arg0:findTF("Main/blur_panel/adapt/top")
	arg0.leftPanel = arg0:findTF("Main/left_panel")
	arg0.title = arg0:findTF("title", arg0.topTF)
	arg0.titleEn = arg0:findTF("title_en", arg0.topTF)
	arg0.mainPanel = arg0:findTF("Main")
	arg0.namePanel = arg0:findTF("name_bg", arg0.mainPanel)
	arg0.nameTxt = arg0:findTF("name_bg/name", arg0.mainPanel):GetComponent(typeof(Text))
	arg0.skinNameTxt = arg0:findTF("name_bg/skin_name", arg0.mainPanel):GetComponent(typeof(Text))
	arg0.rightPanel = arg0:findTF("Main/right")
	arg0.charParent = arg0:findTF("char", arg0.rightPanel)
	arg0.furParent = arg0:findTF("fur", arg0.rightPanel)
	arg0.interactionPreview = BackYardInteractionPreview.New(arg0.furParent, Vector3(0, 0, 0))
	arg0.paintingTF = arg0:findTF("painting/paint")
	arg0.tags = arg0:findTF("tags", arg0.rightPanel)
	arg0.limitTxt = arg0:findTF("name_bg/limit_time/Text", arg0.mainPanel):GetComponent(typeof(Text))
	arg0.commonPanel = arg0:findTF("common", arg0.rightPanel)
	arg0.commonBGTF = arg0:findTF("bg", arg0.commonPanel)
	arg0.commonLabelTF = arg0:findTF("label", arg0.commonPanel)
	arg0.commonConsumeTF = arg0:findTF("consume", arg0.commonPanel)
	arg0.buyBtn = arg0:findTF("buy_btn", arg0.commonPanel)
	arg0.activityBtn = arg0:findTF("activty_btn", arg0.commonPanel)
	arg0.itemBtn = arg0:findTF("item_btn", arg0.commonPanel)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.commonPanel)
	arg0.backyardBtn = arg0:findTF("backyard", arg0.commonPanel)
	arg0.priceTxt = arg0:findTF("consume/Text", arg0.commonPanel):GetComponent(typeof(Text))
	arg0.originalPriceTxt = arg0:findTF("consume/originalprice/Text", arg0.commonPanel):GetComponent(typeof(Text))
	arg0.timelimtPanel = arg0:findTF("timelimt", arg0.rightPanel)
	arg0.timelimitBtn = arg0:findTF("timelimit_btn", arg0.timelimtPanel)
	arg0.timelimitPriceTxt = arg0:findTF("consume/Text", arg0.timelimtPanel):GetComponent(typeof(Text))
	arg0.live2dFilter = arg0.topTF:Find("live2d")
	arg0.live2dFilterSel = arg0.live2dFilter:Find("selected")
	arg0.indexBtn = arg0.topTF:Find("index_btn")
	arg0.indexBtnSel = arg0.indexBtn:Find("sel")
	arg0.inptuTr = arg0.topTF:Find("search")
	arg0.changeBtn = arg0.topTF:Find("change_btn")

	setText(arg0.inptuTr:Find("holder"), i18n("skinatlas_search_holder"))

	arg0.furnBg = arg0:findTF("Main/right/bg/furn")
	arg0.bgMask = arg0:findTF("Main/right/bg/mask")
	arg0.charBg = arg0:findTF("Main/right/bg/char")
	arg0.switchBtn = arg0:findTF("Main/right/bg/switch")
	arg0.bgRoot = arg0:findTF("bgs/bg")
	arg0.bg1 = arg0:findTF("bgs/bg/bg_1")
	arg0.bg2 = arg0:findTF("bgs/bg/bg_2")
	arg0.bgType = false
	arg0.defaultBg = arg0.bg1:GetComponent(typeof(Image)).sprite
	arg0.blurPanel = arg0:findTF("Main/blur_panel")
	arg0.emptyTr = arg0:findTF("bgs/empty")
	Input.multiTouchEnabled = false
	arg0.viewMode = arg0.contextData.type or var0.SHOP_TYPE_COMMON
	arg0.hideObjToggleTF = arg0:findTF("toggles/hideObjToggle", arg0.rightPanel)

	setActive(arg0.hideObjToggleTF, false)

	arg0.switchCnt = 0
	arg0.l2dPreViewToggle = arg0:findTF("toggles/l2d_preview", arg0.rightPanel)
	arg0.l2dDownloadStateTf = arg0:findTF("toggles/l2d_res_state", arg0.rightPanel)
	arg0.l2dUnDownload = arg0.l2dDownloadStateTf:Find("undownload")
	arg0.l2dDownloaded = arg0.l2dDownloadStateTf:Find("downloaded")
	arg0.live2dContainer = arg0:findTF("painting/paint/live2d")
	arg0.paintingContainer = arg0:findTF("painting")
	arg0.spTF = arg0:findTF("painting/paint/spinePainting")
	arg0.spBg = arg0:findTF("painting/paintBg/spinePainting")
	arg0.defaultIndex = {
		typeIndex = ShipIndexConst.TypeAll,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = SkinIndexLayer.ExtraALL
	}
end

function var0.didEnter(arg0)
	arg0:bind(var0.EVENT_ON_CARD_CLICK, function(arg0, arg1)
		arg0:OnCardClick(arg1)
	end)
	arg0:initShips()
	arg0:initSkinPage()

	if arg0.contextData.skinId then
		arg0:JumpToSkinById(arg0.contextData.skinId)
	end

	onButton(arg0, arg0.topTF:Find("back_btn"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.bottomTF:Find("bg/atlas"), function()
		arg0:emit(SkinShopMediator.ON_ATLAS)
	end, SFX_PANEL)
	onButton(arg0, arg0.bottomTF:Find("bg/right_arr"), function()
		arg0:onNext()
	end, SFX_PANEL)
	onButton(arg0, arg0.bottomTF:Find("bg/left_arr"), function()
		arg0:onPrev()
	end, SFX_PANEL)

	arg0.inSkinMode = true

	onButton(arg0, arg0.switchBtn, function()
		arg0:SwitchCharBg()
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
		arg0:emit(SkinShopMediator.ON_INDEX, {
			OnFilter = function(arg0)
				arg0:OnFilter(arg0)
			end,
			defaultIndex = arg0.defaultIndex
		})
	end, SFX_PANEL)
	onInputChanged(arg0, arg0.inptuTr, function()
		arg0:OnSearch()
	end)

	local var0 = true

	onButton(arg0, arg0.changeBtn, function()
		var0 = not var0

		setActive(arg0.inptuTr, var0)
		setActive(arg0.indexBtn, var0)
		setActive(arg0.live2dFilter, not var0)

		if getInputText(arg0.inptuTr) ~= "" then
			setInputText(arg0.inptuTr, "")
		end
	end, SFX_PANEL)
	triggerButton(arg0.changeBtn)
	onButton(arg0, arg0.live2dFilter, function()
		if arg0.defaultIndex.extraIndex == SkinIndexLayer.ExtraL2D then
			arg0.defaultIndex.extraIndex = SkinIndexLayer.ExtraALL
		else
			arg0.defaultIndex.extraIndex = SkinIndexLayer.ExtraL2D
		end

		arg0:OnFilter(arg0.defaultIndex)
	end, SFX_PANEL)
end

function var0.OnSkinListUpdate(arg0, arg1)
	local var0 = arg1 == 0

	setActive(arg0.emptyTr, var0)
	setActive(arg0.rightPanel, not var0)
	setActive(arg0.paintingContainer, not var0)
	setActive(arg0.namePanel, not var0)
end

function var0.OnSearch(arg0)
	arg0:updateShipRect()
end

function var0.OnFilter(arg0, arg1)
	arg0.defaultIndex = {
		typeIndex = arg1.typeIndex,
		campIndex = arg1.campIndex,
		rarityIndex = arg1.rarityIndex,
		extraIndex = arg1.extraIndex
	}

	setActive(arg0.live2dFilterSel, arg1.extraIndex == SkinIndexLayer.ExtraL2D)
	arg0:updateShipRect()
	setActive(arg0.indexBtnSel, arg1.typeIndex ~= ShipIndexConst.TypeAll or arg1.campIndex ~= ShipIndexConst.CampAll or arg1.rarityIndex ~= ShipIndexConst.RarityAll or arg1.extraIndex ~= SkinIndexLayer.ExtraALL)
end

function var0.JumpToSkinById(arg0, arg1)
	local var0 = -1
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.displays) do
		if arg1 == iter1:getSkinId() then
			var0 = iter0
			var1 = iter1
		end
	end

	if var0 == -1 then
		return
	end

	local var2 = arg0.shipRect:HeadIndexToValue(var0 - 1)

	arg0.shipRect:ScrollTo(var2)
	onNextTick(function()
		for iter0, iter1 in pairs(arg0.cards) do
			if iter1.goodsVO.id == var1.id then
				triggerButton(iter1._tf)

				break
			end
		end
	end)
end

function var0.SwitchCharBg(arg0, arg1)
	local var0 = arg0.furnBg
	local var1 = arg0.charBg

	if not arg1 then
		if LeanTween.isTweening(go(var0)) or LeanTween.isTweening(go(var1)) then
			return
		end
	else
		LeanTween.cancel(go(var0))
		LeanTween.cancel(go(var1))
	end

	local var2 = arg0.goodsId and _.detect(arg0.skinGoodsVOs, function(arg0)
		return arg0.id == arg0.goodsId
	end)

	if not var2 then
		return
	end

	local function var3()
		setActive(arg0.charParent, arg0.inSkinMode)
		setActive(arg0.furParent, not arg0.inSkinMode)
	end

	local var4 = var0:GetComponent(typeof(CanvasGroup))
	local var5 = var1:GetComponent(typeof(CanvasGroup))
	local var6 = var4.alpha
	local var7 = var5.alpha
	local var8 = var0.anchoredPosition3D
	local var9 = var1.anchoredPosition3D

	LeanTween.moveLocal(go(var0), var9, 0.3):setOnComplete(System.Action(function()
		var4.alpha = var7
	end))
	LeanTween.moveLocal(go(var1), var8, 0.3):setOnComplete(System.Action(function()
		var5.alpha = var6

		var3()
	end))

	arg0.inSkinMode = not arg0.inSkinMode

	if arg0.inSkinMode then
		var0:SetAsFirstSibling()
		var1:SetSiblingIndex(2)
	else
		var1:SetAsFirstSibling()
		var0:SetSiblingIndex(2)

		local var10 = Goods.Id2FurnitureId(var2.id)
		local var11 = Goods.GetFurnitureConfig(var2.id)

		arg0.interactionPreview:Flush(var2:getSkinId(), var10, var11.scale[2] or 1, var11.position[2])
	end

	arg0:updateBuyBtn(var2)
	arg0:updatePrice(var2)
end

function var0.initSkinPage(arg0)
	local var0 = {}

	arg0.countByIds = {}

	for iter0, iter1 in ipairs(var1.all) do
		if iter1 == var0.PAGE_PROPOSE or iter1 == var0.PAGE_TRANS then
			-- block empty
		else
			arg0.countByIds[iter1] = 0

			table.insert(var0, iter1)
		end
	end

	for iter2, iter3 in ipairs(arg0.skinGoodsVOs) do
		local var1 = iter3:getSkinId()

		print(var1)

		local var2 = var2[var1]

		if not var2 then
			print("not found = " .. var1)
		end

		local var3 = var2.shop_type_id

		print(var3)

		local var4 = var3 == 0 and 9999 or var3

		arg0.countByIds[var4] = arg0.countByIds[var4] + 1
	end

	local var5 = arg0:findTF("toggles/mask/content", arg0.leftPanel)
	local var6 = {}

	for iter4, iter5 in ipairs(var0) do
		if arg0.countByIds[iter5] > 0 then
			table.insert(var6, iter5)
		end
	end

	if arg0.existAnyEncoreSkin then
		table.insert(var6, var0.PAGE_ENCORE)
	end

	assert(not table.contains(var6, var0.PAGE_ALL) and not table.contains(var6, var0.PAGE_TIME_LIMIT))

	if arg0.viewMode == var0.SHOP_TYPE_TIMELIMIT then
		table.insert(var6, 1, var0.PAGE_TIME_LIMIT)
	end

	table.insert(var6, 1, var0.PAGE_ALL)

	arg0.pageTFs, arg0.mid = {}, 4

	local var7 = var5.parent:Find("0")

	arg0.skinPageToggles = {}

	for iter6, iter7 in ipairs(var6) do
		local var8 = cloneTplTo(var7, var5, iter7)

		setActive(var8, true)

		arg0.skinPageToggles[iter7] = var8:Find("toggle")

		onButton(arg0, var8, function()
			local var0

			for iter0, iter1 in ipairs(arg0.pageTFs) do
				if tonumber(go(iter1).name) == iter7 then
					var0 = iter0

					break
				end
			end

			local var1 = var0 - arg0.mid

			for iter2 = 1, math.abs(var1) do
				arg0:onSwitch(var1)
			end

			arg0:onRelease()
		end, SFX_PANEL)
		arg0:UpdateTagStyle(var8, var1, iter7)
	end

	eachChild(var5, function(arg0)
		if arg0.gameObject.activeSelf then
			table.insert(arg0.pageTFs, 1, arg0)
		end
	end)
	arg0:addVerticalDrag(arg0.leftPanel, function(arg0)
		arg0:onSwitch(arg0)
	end, function()
		arg0:onRelease()
	end)
	arg0:UpdateViewMode(var5)
end

function var0.onSwitch(arg0, arg1)
	if arg1 > 0 then
		local var0 = table.remove(arg0.pageTFs, 1)

		var0:SetAsLastSibling()
		table.insert(arg0.pageTFs, var0)
	else
		local var1 = table.remove(arg0.pageTFs, #arg0.pageTFs)

		var1:SetAsFirstSibling()
		table.insert(arg0.pageTFs, 1, var1)
	end

	triggerToggle(arg0.pageTFs[arg0.mid]:Find("toggle"), true)
end

function var0.onRelease(arg0)
	local var0 = tonumber(go(arg0.pageTFs[arg0.mid]).name)

	arg0:index2PageId(var0)
end

function var0.index2PageId(arg0, arg1)
	arg0.contextData.pageId = arg1
	arg0.isSwitch = true

	arg0:updateShipRect(0)
	triggerToggle(arg0.skinPageToggles[arg1], true)
	arg0:SwitchCntPlusPlus()
end

function var0.UpdateViewMode(arg0, arg1)
	local var0
	local var1
	local var2

	if arg0.viewMode == var0.SHOP_TYPE_TIMELIMIT then
		var0 = var0.PAGE_TIME_LIMIT
	elseif arg0.viewMode == var0.SHOP_TYPE_COMMON then
		var0 = arg0.contextData.warp or var0.PAGE_ALL
	end

	setActive(arg0.leftPanel, arg0.viewMode == var0.SHOP_TYPE_COMMON)
	triggerButton(arg1:Find(var0))
	setImageSprite(arg0.title, GetSpriteFromAtlas("ui/SkinShopUI_atlas", var3[arg0.viewMode][1]), true)
	setImageSprite(arg0.titleEn, GetSpriteFromAtlas("ui/SkinShopUI_atlas", var3[arg0.viewMode][2]), true)
end

function var0.UpdateTagStyle(arg0, arg1, arg2, arg3)
	if arg2[arg3] then
		setImageSprite(arg1:Find("name"), GetSpriteFromAtlas("SkinClassified", "text_" .. arg2[arg3].res .. "01"), true)
		setImageSprite(arg1:Find("selected/Image"), GetSpriteFromAtlas("SkinClassified", "text_" .. arg2[arg3].res), true)
		setText(arg1:Find("eng"), string.upper(arg2[arg3].english_name or ""))
	elseif arg3 == var0.PAGE_ALL then
		setImageSprite(arg1:Find("name"), GetSpriteFromAtlas("SkinClassified", "text_all01"), true)
		setImageSprite(arg1:Find("selected/Image"), GetSpriteFromAtlas("SkinClassified", "text_all"), true)
		setText(arg1:Find("eng"), "ALL")
	elseif arg3 == var0.PAGE_ENCORE then
		setImageSprite(arg1:Find("name"), GetSpriteFromAtlas("SkinClassified", "text_fanchang"), true)
		setImageSprite(arg1:Find("selected/Image"), GetSpriteFromAtlas("SkinClassified", "text_fanchang01"), true)
		setText(arg1:Find("eng"), "RETURN")
	end
end

function var0.updateMainView(arg0, arg1)
	local var0 = arg1.shipSkinConfig

	arg0.showCardId = arg1.goodsVO.id

	local var1 = ShipGroup.getDefaultShipConfig(var0.ship_group)

	arg0.nameTxt.text = var1.name
	arg0.skinNameTxt.text = SwitchSpecialChar(var0.name, true)

	local var2 = var0.prefab

	if arg0.prefabName ~= var2 then
		arg0:loadChar(var2, var0)

		arg0.prefabName = var2
	end

	local var3 = var0.painting
	local var4 = checkABExist("painting/" .. var3 .. "_n")

	setActive(arg0.hideObjToggleTF, var4)

	local var5 = false

	eachChild(arg0.tags, function(arg0)
		local var0 = go(arg0).name
		local var1 = table.contains(var0.tag, tonumber(var0))

		if var1 then
			var5 = true
		end

		setActive(arg0, var1)
	end)

	if not var4 and var0.bg_sp ~= "" then
		arg0:setBg(var1, var0, true)
	else
		arg0:setBg(var1, var0, var4)
	end

	arg0:updatePrice(arg1.goodsVO)
	arg0:removeShopTimer()
	arg0:addShopTimer(arg1)
	arg0:updateBuyBtn(arg1.goodsVO)

	local var6 = {
		false
	}

	arg0:UpdateLiveToggle(var0.id, var6)

	if var6[1] == false and arg0.painting ~= var3 then
		arg0:loadPainting(var3, true)

		arg0.painting = var3
	end

	arg0.goodsId = arg1.goodsVO.id
end

function var0.UpdateLiveToggle(arg0, arg1, arg2)
	local var0 = ShipSkin.New({
		id = arg1
	})
	local var1 = var0:IsSpine()
	local var2 = var0:IsLive2d()
	local var3 = var2 or var1
	local var4 = getProxy(PlayerProxy):getRawData().id
	local var5 = PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. var4, 0) == 1
	local var6 = pg.ship_skin_template[var0.id].painting
	local var7 = checkABExist("painting/" .. var6 .. "_n")
	local var8 = true

	if var3 then
		onToggle(arg0, arg0.l2dPreViewToggle, function(arg0)
			setActive(arg0.hideObjToggleTF, not arg0 and var7)
			setActive(arg0.l2dDownloadStateTf, arg0)

			if arg0 then
				PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var4, 1)

				if var2 then
					arg0:UpdateLive2dDownloadState(var0, arg2)
				elseif var1 then
					arg0:UpdateSpineState(var0, arg2)
				end
			else
				PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var4, 0)
				arg0:loadPainting(var6, arg0.isHideObj)

				arg0.painting = var6
			end

			PlayerPrefs.Save()

			if not var8 then
				arg0:emit(SkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg0)
			else
				var8 = false
			end
		end, SFX_PANEL)
	else
		removeOnToggle(arg0.l2dPreViewToggle)
		setActive(arg0.l2dDownloadStateTf, false)
		setActive(arg0.hideObjToggleTF, var7)
	end

	triggerToggle(arg0.l2dPreViewToggle, var5)
	setActive(arg0.l2dPreViewToggle, var3)

	arg0.skinId = arg1
end

function var0.UpdateSpineState(arg0, arg1, arg2)
	local var0 = pg.ship_skin_template[arg1.id].painting
	local var1 = "SpinePainting/" .. string.lower(var0)
	local var2 = HXSet.autoHxShiftPath(var1, nil, true)
	local var3 = checkABExist(var2)

	setActive(arg0.l2dUnDownload, not var3)
	setActive(arg0.l2dDownloaded, var3)

	if not var3 then
		onButton(arg0, arg0.l2dDownloadStateTf, function()
			pg.TipsMgr.GetInstance():ShowTips("word_cmdClose")
		end, SFX_PANEL)

		if arg2 then
			arg2[1] = false
		end
	else
		if arg2 then
			arg2[1] = true
		end

		removeOnButton(arg0.l2dDownloadStateTf)
		arg0:LoadSpine(arg1)
	end
end

function var0.LoadSpine(arg0, arg1)
	arg0:recyclePainting()
	arg0:UnLoadLive2d()
	arg0:UnloadSpine()

	local var0 = pg.ship_skin_template[arg1.id].ship_group
	local var1 = ShipGroup.getDefaultShipConfig(var0)
	local var2 = SpinePainting.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var1.id,
			skin_id = arg1.id
		}),
		position = Vector3(0, 0, 0),
		parent = arg0.spTF,
		effectParent = arg0.spBg
	})

	arg0.spinePainting = SpinePainting.New(var2, function(arg0)
		return
	end)
end

function var0.UnloadSpine(arg0, arg1)
	if arg0.spinePainting then
		arg0.spinePainting:Dispose()

		arg0.spinePainting = nil
	end
end

function var0.UpdateLive2dDownloadState(arg0, arg1, arg2)
	local var0 = pg.ship_skin_template[arg1.id].painting
	local var1 = "live2d/" .. string.lower(var0)
	local var2 = HXSet.autoHxShiftPath(var1, nil, true)
	local var3 = checkABExist(var2)

	setActive(arg0.l2dUnDownload, not var3)
	setActive(arg0.l2dDownloaded, var3)

	if not var3 then
		onButton(arg0, arg0.l2dDownloadStateTf, function()
			if arg0.downloads[arg1.id] then
				return
			end

			local var0 = SkinShopDownloadRequest.New()

			arg0.downloads[arg1.id] = var0

			var0:Start(var2, function(arg0)
				if arg0 and arg0.skinId == arg1.id then
					arg0:UpdateLive2dDownloadState(arg1)
				end

				var0:Dispose()

				arg0.downloads[arg1.id] = nil
			end)
		end, SFX_PANEL)

		if arg2 then
			arg2[1] = false
		end
	else
		if arg2 then
			arg2[1] = true
		end

		removeOnButton(arg0.l2dDownloadStateTf)
		arg0:LoadL2d(arg1)
	end
end

function var0.LoadL2d(arg0, arg1)
	arg0:recyclePainting()
	arg0:UnLoadLive2d()
	arg0:UnloadSpine()

	local var0 = pg.ship_skin_template[arg1.id].ship_group
	local var1 = ShipGroup.getDefaultShipConfig(var0)
	local var2 = Live2D.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var1.id,
			skin_id = arg1.id
		}),
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -1),
		parent = arg0.live2dContainer
	})

	var2.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0.live2dChar = Live2D.New(var2, function(arg0)
		arg0:recyclePainting()
		arg0:IgonreReactPos(true)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0.UnLoadLive2d(arg0, arg1)
	if arg0.live2dChar then
		arg0.live2dChar:Dispose()

		arg0.live2dChar = nil
	end
end

function var0.setBg(arg0, arg1, arg2, arg3)
	local var0 = Ship.New({
		configId = arg1.id,
		skin_id = arg2.id
	})
	local var1 = var0:getShipBgPrint(true)

	if arg3 and arg2.bg_sp ~= "" then
		var1 = arg2.bg_sp
	end

	if var1 ~= var0:rarity2bgPrintForGet() then
		local var2 = arg0:GetCurBgTransform()

		pg.DynamicBgMgr.GetInstance():LoadBg(arg0, var1, arg0.bgRoot, var2, function(arg0)
			return
		end, function(arg0)
			arg0:AnimBg()
		end)
	else
		setImageSprite(arg0:GetCurBgTransform(), arg0.defaultBg)
		arg0:AnimBg()
	end
end

function var0.GetCurBgTransform(arg0)
	local var0

	if not arg0.bgType then
		var0 = arg0.bg2
	else
		var0 = arg0.bg1
	end

	arg0.bgType = not arg0.bgType

	return var0
end

function var0.AnimBg(arg0)
	local var0
	local var1

	if arg0.bgType then
		var0 = arg0.bg2
		var1 = arg0.bg1
	else
		var0 = arg0.bg1
		var1 = arg0.bg2
	end

	LeanTween.cancel(go(arg0.bg2))
	LeanTween.cancel(go(arg0.bg1))
	setActive(var0, true)
	var0:SetAsLastSibling()
	LeanTween.alpha(var0, 1, 0.8):setFrom(0):setOnComplete(System.Action(function()
		setImageAlpha(var0, 1)
		setImageAlpha(var1, 0)
	end))
end

function var0.onBuyDone(arg0, arg1)
	local var0 = _.detect(arg0.skinGoodsVOs, function(arg0)
		return arg0.id == arg1
	end)

	if var0 then
		arg0:updateBuyBtn(var0)
		arg0:updatePrice(var0)
		arg0:removeShopTimer()
		arg0:addShopTimer({
			goodsVO = var0
		})
	end
end

function var0.OnFurnitureUpdate(arg0, arg1)
	if arg0.goodsId and arg1 and Goods.ExistFurniture(arg0.goodsId) and Goods.Id2FurnitureId(arg0.goodsId) == arg1 then
		local var0 = _.detect(arg0.skinGoodsVOs, function(arg0)
			return arg0.id == arg0.goodsId
		end)

		arg0:updateBuyBtn(var0)
	end
end

function var0.updateBuyBtn(arg0, arg1)
	local var0 = arg1:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1

	if var0 then
		onButton(arg0, arg0.timelimitBtn, function()
			local var0 = arg1:getSkinId()
			local var1 = getProxy(ShipSkinProxy):getSkinById(var0)

			if var1 and not var1:isExpireType() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

				return
			end

			arg0:showTimeLimitSkinWindow(arg1)
		end, SFX_PANEL)

		var1 = var2[arg1:getSkinId()]
	else
		local var2 = arg1:getSkinId()

		var1 = var2[var2]

		local var3 = arg1.type
		local var4 = var3 == Goods.TYPE_ACTIVITY or var3 == Goods.TYPE_ACTIVITY_EXTRA
		local var5 = arg1.buyCount == 0
		local var6 = arg1:isDisCount() and arg1:IsItemDiscountType()
		local var7 = not arg0.inSkinMode
		local var8 = false

		if var7 then
			var8 = getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1.id))
		end

		setActive(arg0.itemBtn, var6 and var5 and not var7)
		setActive(arg0.buyBtn, not var4 and var5 and not var6 and not var7)
		setActive(arg0.gotBtn, not var4 and not var5 and not var7 or var7 and var8)
		setActive(arg0.activityBtn, var4 and not var6 and not var7)
		setActive(arg0.backyardBtn, var7 and not var8)
		onButton(arg0, arg0.itemBtn, function()
			triggerButton(arg0.buyBtn)
		end, SFX_PANEL)
		onButton(arg0, arg0.buyBtn, function()
			local var0 = arg1

			if var0.type == Goods.TYPE_SKIN then
				if arg0.showCardId == var0.id then
					if arg1:isDisCount() and var0:IsItemDiscountType() then
						arg0:emit(SkinShopMediator.ON_SHOPPING_BY_ACT, var0.id, 1)
					else
						local var1 = var0:GetPrice()
						local var2 = i18n("charge_scene_buy_confirm", var1, var1.name)

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = var2,
							onYes = function()
								arg0:emit(SkinShopMediator.ON_SHOPPING, var0.id, 1)
							end
						})
					end
				else
					pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[9999])

					return
				end
			end
		end, SFX_PANEL)
		onButton(arg0, arg0.activityBtn, function()
			local var0 = arg1
			local var1 = var0:getConfig("time")
			local var2 = var0:getConfig("activity")
			local var3 = getProxy(ActivityProxy):getActivityById(var2)

			if var2 == 0 and pg.TimeMgr.GetInstance():inTime(var1) or var3 and not var3:isEnd() then
				if var0.type == Goods.TYPE_ACTIVITY then
					arg0:emit(SkinShopMediator.GO_SHOPS_LAYER, var0:getConfig("activity"))
				elseif var0.type == Goods.TYPE_ACTIVITY_EXTRA then
					local var4 = var0:getConfig("scene")

					if var4 and #var4 > 0 then
						arg0:emit(SkinShopMediator.OPEN_SCENE, var4)
					else
						arg0:emit(SkinShopMediator.OPEN_ACTIVITY, var2)
					end
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
			end
		end, SFX_PANEL)
		onButton(arg0, arg0.backyardBtn, function()
			arg0:emit(SkinShopMediator.ON_BACKYARD_SHOP)
		end, SFX_PANEL)
	end

	local var9 = ShipGroup.getDefaultShipConfig(var1.ship_group)

	removeOnToggle(arg0.hideObjToggleTF)
	triggerToggle(arg0.hideObjToggleTF, true)

	arg0.isHideObj = true

	onToggle(arg0, arg0.hideObjToggleTF, function(arg0)
		arg0.isHideObj = arg0

		local var0 = arg0.painting

		arg0:loadPainting(var0, arg0)

		arg0.painting = var0

		arg0:setBg(var9, var1, arg0)
	end, SFX_PANEL)
end

function var0.showTimeLimitSkinWindow(arg0, arg1)
	local var0 = arg1:getConfig("resource_num")
	local var1 = arg1:getConfig("time_second") * var0
	local var2 = arg1:getSkinId()
	local var3 = pg.ship_skin_template[var2]

	assert(var3)

	local var4, var5, var6, var7 = pg.TimeMgr.GetInstance():parseTimeFrom(var1)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var0, var3.name, var4, var5),
		onYes = function()
			if arg0.skinTicket < var0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0:emit(SkinShopMediator.ON_SHOPPING, arg1.id, 1)
		end
	})
end

function var0.addShopTimer(arg0, arg1)
	local var0 = arg1.goodsVO
	local var1 = var0:getSkinId()

	if arg0.skinTimer then
		arg0.skinTimer:Stop()
	end

	setActive(tf(go(arg0.limitTxt)).parent, true)

	if var0:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var2 = getProxy(ShipSkinProxy):getSkinById(var1)
		local var3 = var2 and var2:isExpireType() and not var2:isExpired()

		setActive(tf(go(arg0.limitTxt)).parent, var3)

		if var3 then
			arg0.skinTimer = Timer.New(function()
				local var0 = skinTimeStamp(var2:getRemainTime())

				arg0.limitTxt.text = var0
			end, 1, -1)

			arg0.skinTimer:Start()
			arg0.skinTimer.func()
		else
			setActive(tf(go(arg0.limitTxt)).parent, false)
		end
	else
		local var4, var5 = pg.TimeMgr.GetInstance():inTime(var0:getConfig("time"))

		if not var5 then
			setActive(tf(go(arg0.limitTxt)).parent, false)

			return
		end

		local var6 = pg.TimeMgr.GetInstance()
		local var7 = var6:Table2ServerTime(var5)

		arg0.shopTimer = Timer.New(function()
			local var0 = var6:GetServerTime()

			if var0 > var7 then
				arg0:removeShopTimer()
			end

			local var1 = var7 - var0

			var1 = var1 < 0 and 0 or var1

			local var2 = math.floor(var1 / 86400)

			if var2 > 0 then
				arg0.limitTxt.text = i18n("time_remaining_tip") .. var2 .. i18n("word_date")
			else
				local var3 = math.floor(var1 / 3600)

				if var3 > 0 then
					arg0.limitTxt.text = i18n("time_remaining_tip") .. var3 .. i18n("word_hour")
				else
					local var4 = math.floor(var1 / 60)

					if var4 > 0 then
						arg0.limitTxt.text = i18n("time_remaining_tip") .. var4 .. i18n("word_minute")
					else
						arg0.limitTxt.text = i18n("time_remaining_tip") .. var1 .. i18n("word_second")
					end
				end
			end
		end, 1, -1)

		arg0.shopTimer:Start()
		arg0.shopTimer.func()
	end
end

function var0.removeShopTimer(arg0)
	if arg0.shopTimer then
		arg0.shopTimer:Stop()

		arg0.shopTimer = nil
	end
end

function var0.updatePrice(arg0, arg1)
	local var0 = arg1:getSkinId()
	local var1 = var2[var0]
	local var2 = arg1
	local var3 = var2:getConfig("genre") == ShopArgs.SkinShopTimeLimit

	setActive(arg0.commonPanel, not var3)
	setActive(arg0.timelimtPanel, var3)

	if var3 then
		local var4 = var2:getConfig("resource_num")
		local var5 = (var4 > arg0.skinTicket and "<color=" .. COLOR_RED .. ">" or "") .. arg0.skinTicket .. (var4 > arg0.skinTicket and "</color>" or "")

		arg0.timelimitPriceTxt.text = var5 .. "/" .. var4
	elseif arg0.inSkinMode then
		local var6 = var2.type == Goods.TYPE_SKIN

		setActive(arg0.commonBGTF, var6)
		setActive(arg0.commonLabelTF, var6)
		setActive(arg0.commonConsumeTF, var6)

		if var6 then
			local var7 = (100 - var2:getConfig("discount")) / 100
			local var8 = var2:getConfig("resource_num")
			local var9 = var2:isDisCount()

			arg0.priceTxt.text = var2:GetPrice()
			arg0.originalPriceTxt.text = var8

			setActive(tf(go(arg0.originalPriceTxt)).parent, var9)
		end
	else
		local var10 = Goods.Id2FurnitureId(var2.id)
		local var11 = Furniture.New({
			id = var10
		})
		local var12 = var11:getConfig("gem_price")

		arg0.originalPriceTxt.text = var12

		local var13 = var11:getPrice(PlayerConst.ResDiamond)

		arg0.priceTxt.text = var13

		setActive(tf(go(arg0.originalPriceTxt)).parent, var12 ~= var13)
	end
end

function var0.loadPainting(arg0, arg1, arg2)
	arg0:recyclePainting()
	arg0:UnLoadLive2d()
	arg0:UnloadSpine()
	arg0:setPaintingPrefab(arg0.paintingTF, arg1, "chuanwu", arg2)
end

function var0.setPaintingPrefab(arg0, arg1, arg2, arg3, arg4)
	local var0 = findTF(arg1, "fitter")

	assert(var0, "请添加子物体fitter")
	removeAllChildren(var0)

	local var1 = GetOrAddComponent(var0, "PaintingScaler")

	var1.FrameName = arg3 or ""
	var1.Tween = 1

	local var2 = arg2

	if not arg4 and checkABExist("painting/" .. arg2 .. "_n") then
		arg2 = arg2 .. "_n"
	end

	if checkABExist("painting/" .. arg2) then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetPainting(arg2, true, function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()
			setParent(arg0, var0, false)

			local var0 = findTF(arg0, "Touch")

			if not IsNil(var0) then
				setActive(var0, false)
			end

			ShipExpressionHelper.SetExpression(var0:GetChild(0), var2)
		end)
	end
end

function var0.recyclePainting(arg0)
	if arg0.painting then
		retPaintingPrefab(arg0.paintingTF, arg0.painting)
	end

	arg0.painting = nil
end

function var0.loadChar(arg0, arg1, arg2)
	arg0:recycleChar()
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(arg1, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.modelTf = tf(arg0)

		local var0 = pg.skinshop_spine_scale[arg2.id]

		if var0 then
			arg0.modelTf.localScale = Vector3(var0.skinshop_scale, var0.skinshop_scale, 1)
		else
			arg0.modelTf.localScale = Vector3(0.9, 0.9, 1)
		end

		arg0.modelTf.localPosition = Vector3(0, 0, 0)

		pg.ViewUtils.SetLayer(arg0.modelTf, Layer.UI)
		setParent(arg0.modelTf, arg0.charParent)
		arg0:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end)
end

function var0.recycleChar(arg0)
	if not IsNil(arg0.modelTf) then
		arg0.modelTf.gameObject:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefabName, arg0.modelTf.gameObject)
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnCardClick(arg0, arg1)
	if arg0.card and arg0.contextData.key == arg1.goodsVO:getKey() then
		return
	end

	if arg0.contextData.key then
		for iter0, iter1 in pairs(arg0.cards) do
			if iter1.goodsVO:getKey() == arg0.contextData.key then
				iter1:updateSelected(false)
			end
		end
	end

	arg1:updateSelected(true)

	arg0.contextData.key = arg1.goodsVO:getKey()
	arg0.card = arg1

	if not arg0.inSkinMode then
		arg0:SwitchCharBg(true)
	end

	arg0:updateMainView(arg1)
	arg0:UpdateSkinOrFurnitureMode(Goods.ExistFurniture(arg1.goodsVO.id))

	for iter2, iter3 in ipairs(arg0.displays) do
		if iter3 == arg0.card.goodsVO then
			arg0.index = iter2
		end
	end

	arg0:SwitchCntPlusPlus()
end

function var0.UpdateSkinOrFurnitureMode(arg0, arg1)
	setActive(arg0.switchBtn, arg1)
	setActive(arg0.furnBg, arg1)
	setActive(arg0.bgMask, arg1)
end

function var0.initShips(arg0)
	arg0.cards = {}
	arg0.shipRect = arg0.bottomTF:Find("scroll"):GetComponent("LScrollRect")

	function arg0.shipRect.onInitItem(arg0)
		local var0 = ShopSkinCard.New(arg0, arg0)

		arg0.cards[arg0] = var0
	end

	function arg0.shipRect.onUpdateItem(arg0, arg1)
		local var0 = arg0.cards[arg1]

		if not var0 then
			var0 = ShopSkinCard.New(arg1, arg0)
			arg0.cards[arg1] = var0
		end

		local var1 = arg0.displays[arg0 + 1]

		var0:update(var1)
		var0:updateSelected(arg0.contextData.key == var0.goodsVO:getKey())

		if arg0.isSwitch and arg0 == 0 then
			arg0.isSwitch = nil

			triggerButton(var0._tf)
		end
	end
end

function var0.SwitchCntPlusPlus(arg0)
	arg0.switchCnt = arg0.switchCnt + 1

	if arg0.switchCnt >= 2 then
		gcAll()

		arg0.switchCnt = 0
	end
end

function var0.onNext(arg0)
	if arg0.index == #arg0.displays then
		return
	end

	local var0

	for iter0, iter1 in ipairs(arg0.displays) do
		if iter1:getKey() == arg0.contextData.key then
			var0 = iter0

			break
		end
	end

	if var0 then
		local var1 = false
		local var2 = math.min(var0 + 1, #arg0.displays)

		arg0.index = var2

		local var3
		local var4 = arg0.displays[var2]

		for iter2, iter3 in pairs(arg0.cards) do
			if iter3.goodsVO:getKey() == var4:getKey() and iter3._tf.gameObject.name ~= "-1" then
				triggerButton(iter3._tf)

				var1 = true
				var3 = iter3

				break
			end
		end

		local function var5()
			local var0 = getBounds(arg0.bottomTF:Find("scroll"))
			local var1 = getBounds(var3._tf)
			local var2 = getBounds(arg0.card._tf)

			return math.ceil(var1:GetMax().x - var0:GetMax().x) > var2.size.x
		end

		if var1 and var5() then
			local var6 = arg0.shipRect:HeadIndexToValue(var2 - 1) - arg0.shipRect:HeadIndexToValue(var2)
			local var7 = arg0.shipRect.value - var6

			arg0.shipRect:SetNormalizedPosition(var7, 0)
		end
	end
end

function var0.onPrev(arg0)
	if arg0.index == 1 then
		return
	end

	local var0

	for iter0, iter1 in ipairs(arg0.displays) do
		if iter1:getKey() == arg0.contextData.key then
			var0 = iter0

			break
		end
	end

	if var0 then
		local var1 = false
		local var2 = math.max(var0 - 1, 1)

		arg0.index = var2

		local var3 = arg0.displays[var2]

		for iter2, iter3 in pairs(arg0.cards) do
			if iter3.goodsVO:getKey() == var3:getKey() and iter3._tf.gameObject.name ~= "-1" then
				triggerButton(iter3._tf)

				var1 = true

				break
			end
		end

		local function var4()
			local var0 = getBounds(arg0.bottomTF:Find("scroll"))
			local var1 = getBounds(arg0.bottomTF:Find("scroll/content"))
			local var2 = getBounds(arg0.card._tf)

			return var1:GetMin().x < var0:GetMin().x and var2:GetMin().x < var0:GetMin().x
		end

		if var1 and var4() then
			local var5 = arg0.shipRect:HeadIndexToValue(var2 - 1)

			arg0.shipRect:SetNormalizedPosition(var5, 0)
		end
	end
end

function var0.updateShipRect(arg0, arg1)
	arg0.card = nil

	if arg0.contextData.pageId and arg0.shipRect then
		arg0.displays = {}

		local function var0(arg0)
			return arg0.encoreSkinMap[arg0] == true
		end

		local var1 = {}

		local function var2(arg0)
			if #var1 == 0 then
				for iter0, iter1 in ipairs(arg0.skinGoodsVOs) do
					if iter1:getConfig("genre") == ShopArgs.SkinShop then
						local var0 = iter1:getSkinId()

						var1[var0] = true
					end
				end
			end

			return var1[arg0] == true
		end

		for iter0, iter1 in ipairs(arg0.skinGoodsVOs) do
			local var3 = iter1:getSkinId()
			local var4 = var2[var3].shop_type_id
			local var5 = var4 == 0 and 9999 or var4
			local var6 = iter1:getConfig("genre") == ShopArgs.SkinShopTimeLimit
			local var7 = arg0.contextData.pageId

			if var6 and var7 == var0.PAGE_TIME_LIMIT and var2(var3) or not var6 and (var7 == var0.PAGE_ALL or var5 == arg0.contextData.pageId) or not var6 and var7 == var0.PAGE_ENCORE and var0(iter1.id) then
				local var8 = ShipSkin.New({
					id = var3
				})

				if arg0:MatchIndex(var8) and var8:IsMatchKey(getInputText(arg0.inptuTr)) then
					table.insert(arg0.displays, iter1)
				end
			end
		end

		local function var9(arg0, arg1)
			local var0 = (arg0.type == Goods.TYPE_ACTIVITY or arg0.type == Goods.TYPE_ACTIVITY_EXTRA) and 0 or arg0:GetPrice()
			local var1 = (arg1.type == Goods.TYPE_ACTIVITY or arg1.type == Goods.TYPE_ACTIVITY_EXTRA) and 0 or arg1:GetPrice()

			if var0 == var1 then
				return arg0.id < arg1.id
			else
				return var1 < var0
			end
		end

		table.sort(arg0.displays, function(arg0, arg1)
			local var0 = arg0.buyCount == 0 and 1 or 0
			local var1 = arg1.buyCount == 0 and 1 or 0

			if var0 == var1 then
				local var2 = arg0:getConfig("order")
				local var3 = arg1:getConfig("order")

				if var2 == var3 then
					return var9(arg0, arg1)
				else
					return var2 < var3
				end
			else
				return var1 < var0
			end
		end)

		if arg1 then
			arg0.shipRect:SetTotalCount(#arg0.displays, arg1)
		else
			arg0.shipRect:SetTotalCount(#arg0.displays)
		end

		arg0:OnSkinListUpdate(#arg0.displays)
	end
end

function var0.ToVShip(arg0, arg1)
	if not arg0.vship then
		arg0.vship = {}

		function arg0.vship.getNation()
			return arg0.vship.config.nationality
		end

		function arg0.vship.getShipType()
			return arg0.vship.config.type
		end

		function arg0.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0.vship.config.type)
		end

		function arg0.vship.getRarity()
			return arg0.vship.config.rarity
		end
	end

	arg0.vship.config = arg1

	return arg0.vship
end

function var0.MatchIndex(arg0, arg1)
	local var0 = arg1:GetDefaultShipConfig()

	if not var0 then
		return false
	end

	local var1 = arg0:ToVShip(var0)
	local var2 = ShipIndexConst.filterByType(var1, arg0.defaultIndex.typeIndex)
	local var3 = ShipIndexConst.filterByCamp(var1, arg0.defaultIndex.campIndex)
	local var4 = ShipIndexConst.filterByRarity(var1, arg0.defaultIndex.rarityIndex)
	local var5 = SkinIndexLayer.filterByExtra(arg1, arg0.defaultIndex.extraIndex)

	return var2 and var3 and var4 and var5
end

function var0.addVerticalDrag(arg0, arg1, arg2, arg3)
	local var0 = GetOrAddComponent(arg1, "EventTriggerListener")
	local var1 = 90
	local var2
	local var3 = 0
	local var4 = 0
	local var5 = 0

	var0:AddBeginDragFunc(function(arg0, arg1)
		var3 = 0
		var4 = 0
		var2 = arg1.position
		var5 = var2.y
	end)
	var0:AddDragFunc(function(arg0, arg1)
		if var5 > arg1.position.y and var4 ~= 0 then
			var2 = arg1.position
			var4 = 0
		elseif var5 < arg1.position.y and var3 ~= 0 then
			var2 = arg1.position
			var3 = 0
		end

		local var0 = arg1.position.y - var2.y
		local var1 = math.abs(math.floor(var0 / var1))

		if arg2 and var1 > var3 then
			var3 = var1

			arg2(var0)
		end

		if arg2 and var1 < var4 then
			var4 = var1

			arg2(var0)
		end

		var5 = var2.y
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if arg3 then
			arg3()
		end
	end)
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil

	ClearEventTrigger(GetOrAddComponent(arg0._tf, "EventTriggerListener"))
	ClearLScrollrect(arg0.shipRect)

	arg0.shipRect = nil

	arg0:UnloadSpine()
	arg0:UnLoadLive2d()
	arg0:recycleChar()
	arg0:recyclePainting()
	arg0:removeShopTimer()

	for iter2, iter3 in pairs(arg0.downloads) do
		iter3:Dispose()
	end

	arg0.downloads = {}

	LeanTween.cancel(go(arg0.furnBg))
	LeanTween.cancel(go(arg0.charBg))
	LeanTween.cancel(go(arg0.bg1))
	LeanTween.cancel(go(arg0.bg2))

	Input.multiTouchEnabled = true

	arg0.interactionPreview:Dispose()

	arg0.interactionPreview = nil

	if arg0.skinTimer then
		arg0.skinTimer:Stop()
	end

	arg0.skinTimer = nil
	arg0.contextData.key = nil
	arg0.switchCnt = nil
	arg0.contextData.skinId = nil
end

return var0
