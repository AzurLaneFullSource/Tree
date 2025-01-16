local var0_0 = class("NewSkinShopMainView", import("view.base.BaseEventLogic"))

var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW = "NewSkinShopMainView:EVT_SHOW_OR_HIDE_PURCHASE_VIEW"
var0_0.EVT_ON_PURCHASE = "NewSkinShopMainView:EVT_ON_PURCHASE"

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 1
local var5_0 = 2
local var6_0 = 3
local var7_0 = 4
local var8_0 = 5
local var9_0 = 6
local var10_0 = 7
local var11_0 = 8

local function var12_0(arg0_1)
	if not var0_0.obtainBtnSpriteNames then
		var0_0.obtainBtnSpriteNames = {
			[var4_0] = "yigoumai_butten",
			[var5_0] = "goumai_butten",
			[var6_0] = "qianwanghuoqu_butten",
			[var7_0] = "item_buy",
			[var8_0] = "furniture_shop",
			[var9_0] = "tiyan_btn",
			[var10_0] = "item_buy",
			[var11_0] = "buy_with_gift"
		}
	end

	return var0_0.obtainBtnSpriteNames[arg0_1]
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	pg.DelegateInfo.New(arg0_2)
	var0_0.super.Ctor(arg0_2, arg2_2)

	arg0_2.contextData = arg3_2
	arg0_2._go = arg1_2.gameObject
	arg0_2._tf = arg1_2
	arg0_2.overlay = arg0_2._tf:Find("overlay")
	arg0_2.titleTr = arg0_2._tf:Find("overlay/title")
	arg0_2.skinNameTxt = arg0_2._tf:Find("overlay/title/skin_name"):GetComponent(typeof(Text))
	arg0_2.shipNameTxt = arg0_2._tf:Find("overlay/title/name"):GetComponent(typeof(Text))
	arg0_2.timeLimitTr = arg0_2._tf:Find("overlay/title/limit_time")
	arg0_2.timeLimitTxt = arg0_2.timeLimitTr:Find("Text"):GetComponent(typeof(Text))
	arg0_2.changeSkinUI = arg0_2._tf:Find("overlay/left/change_skin")
	arg0_2.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_2.changeSkinUI, "toggle_ui"))
	arg0_2.rightTr = arg0_2._tf:Find("overlay/right")
	arg0_2.uiTagList = UIItemList.New(arg0_2._tf:Find("overlay/right/tags"), arg0_2._tf:Find("overlay/right/tags/tpl"))
	arg0_2.charContainer = arg0_2._tf:Find("overlay/right/char")
	arg0_2.furnitureContainer = arg0_2._tf:Find("overlay/right/fur")
	arg0_2.charBg = arg0_2._tf:Find("overlay/right/bg/char")
	arg0_2.furnitureBg = arg0_2._tf:Find("overlay/right/bg/furn")
	arg0_2.switchPreviewBtn = arg0_2._tf:Find("overlay/right/switch")
	arg0_2.obtainBtn = arg0_2._tf:Find("overlay/right/price/btn")
	arg0_2.obtainBtnImg = arg0_2.obtainBtn:GetComponent(typeof(Image))
	arg0_2.giftTag = arg0_2.obtainBtn:Find("tag")
	arg0_2.giftItem = arg0_2.obtainBtn:Find("item")
	arg0_2.giftText = arg0_2._tf:Find("overlay/right/price/btn/Text"):GetComponent(typeof(Text))
	arg0_2.consumeTr = arg0_2._tf:Find("overlay/right/price/consume")
	arg0_2.consumeRealPriceTxt = arg0_2.consumeTr:Find("Text"):GetComponent(typeof(Text))
	arg0_2.consumePriceTxt = arg0_2.consumeTr:Find("originalprice/Text"):GetComponent(typeof(Text))
	arg0_2.experienceTr = arg0_2._tf:Find("overlay/right/price/timelimt")
	arg0_2.experienceTxt = arg0_2.experienceTr:Find("consume/Text"):GetComponent(typeof(Text))
	arg0_2.dynamicToggle = arg0_2._tf:Find("overlay/right/toggles/l2d_preview")
	arg0_2.showBgToggle = arg0_2._tf:Find("overlay/right/toggles/hideObjToggle")
	arg0_2.dynamicResToggle = arg0_2._tf:Find("overlay/right/toggles/l2d_res_state")
	arg0_2.dynamicResDownaload = arg0_2._tf:Find("overlay/right/toggles/l2d_res_state/downloaded")
	arg0_2.dynamicResUnDownaload = arg0_2._tf:Find("overlay/right/toggles/l2d_res_state/undownload")
	arg0_2.paintingTF = arg0_2._tf:Find("painting/paint")
	arg0_2.live2dContainer = arg0_2._tf:Find("painting/paint/live2d")
	arg0_2.spTF = arg0_2._tf:Find("painting/paint/spinePainting")
	arg0_2.spBg = arg0_2._tf:Find("painting/paintBg/spinePainting")
	arg0_2.bgsGo = arg0_2._tf:Find("bgs").gameObject
	arg0_2.diffBg = arg0_2._tf:Find("bgs/diffBg/bg")
	arg0_2.defaultBg = arg0_2._tf:Find("bgs/default")
	arg0_2.downloads = {}
	arg0_2.obtainBtnSprites = {}
	arg0_2.isToggleDynamic = false
	arg0_2.isToggleShowBg = true
	arg0_2.isPreviewFurniture = false
	arg0_2.interactionPreview = BackYardInteractionPreview.New(arg0_2.furnitureContainer, Vector3(0, 0, 0))
	arg0_2.voucherMsgBox = SkinVoucherMsgBox.New(pg.UIMgr.GetInstance().OverlayMain)
	arg0_2.purchaseView = NewSkinShopPurchaseView.New(arg0_2._tf, arg2_2)

	arg0_2:RegisterEvent()
end

function var0_0.RegisterEvent(arg0_3)
	arg0_3:bind(var0_0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, function(arg0_4, arg1_4)
		setAnchoredPosition(arg0_3.paintingTF, {
			x = arg1_4 and -440 or -120
		})
		setActive(arg0_3.overlay, not arg1_4)
	end)
	arg0_3:bind(var0_0.EVT_ON_PURCHASE, function(arg0_5, arg1_5)
		local var0_5 = arg0_3:GetObtainBtnState(arg1_5)

		arg0_3:OnClickBtn(var0_5, arg1_5)
	end)
	onButton(arg0_3, arg0_3.changeSkinUI, function()
		if ShipGroup.IsChangeSkin(arg0_3.skinId) then
			arg0_3.changeSkinId = ShipGroup.GetChangeSkinNextId(arg0_3.skinId)

			arg0_3:Flush(arg0_3.commodity)
		end
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_7, arg1_7)
	if not arg1_7 then
		arg0_7:FlushStyle(true)

		return
	end

	arg0_7:FlushStyle(false)

	local var0_7 = arg0_7.commodity and arg0_7.commodity.id == arg1_7.id
	local var1_7 = ShipGroup.IsChangeSkin(arg0_7.skinId)

	arg0_7.skinId = arg1_7:getSkinId()

	arg0_7:FlushChangeSkin(arg1_7)

	if not var0_7 then
		arg0_7:FlushName(arg1_7)
		arg0_7:FlushPreviewBtn(arg1_7)
		arg0_7:FlushTimeline(arg1_7)
		arg0_7:FlushTag(arg1_7)
		arg0_7:SwitchPreview(arg1_7, arg0_7.isPreviewFurniture, false)
		arg0_7:FlushPaintingToggle(arg1_7)
		arg0_7:FlushBG(arg1_7)
		arg0_7:FlushPainting(arg1_7)
	elseif var1_7 then
		arg0_7:FlushBG(arg1_7)
		arg0_7:FlushPainting(arg1_7)
		arg0_7:FlushTag(arg1_7)
		arg0_7:SwitchPreview(arg1_7, arg0_7.isPreviewFurniture, false)
	else
		arg0_7:FlushBG(arg1_7)
		arg0_7:FlushPainting(arg1_7)
	end

	arg0_7:FlushPrice(arg1_7)
	arg0_7:FlushObtainBtn(arg1_7)

	arg0_7.commodity = arg1_7
end

function var0_0.FlushChangeSkin(arg0_8, arg1_8)
	local var0_8 = arg0_8.skinId
	local var1_8 = ShipGroup.IsChangeSkin(var0_8)

	setActive(arg0_8.changeSkinUI, var1_8 and true or false)

	if var1_8 then
		local var2_8 = ShipGroup.GetChangeSkinGroupId(var0_8)

		if not arg0_8.changeSkinId then
			arg0_8.changeSkinId = var0_8
		elseif ShipGroup.GetChangeSkinGroupId(arg0_8.changeSkinId) == var2_8 then
			arg0_8.skinId = arg0_8.changeSkinId
		else
			arg0_8.changeSkinId = arg0_8.skinId
		end

		arg0_8.changeSkinToggle:setSkinData(arg0_8.skinId)
	end
end

function var0_0.FlushStyle(arg0_9, arg1_9)
	setActive(arg0_9.paintingTF.parent, not arg1_9)
	setActive(arg0_9.defaultBg, arg1_9)
	setActive(arg0_9.diffBg.parent, not arg1_9)
	setActive(arg0_9.titleTr, not arg1_9)
	setActive(arg0_9.rightTr, not arg1_9)
end

function var0_0.getUIName(arg0_10)
	return "NewSkinShopMainView"
end

function var0_0.FlushBgWithAnim(arg0_11, arg1_11)
	local var0_11 = arg0_11._tf:GetComponent(typeof(CanvasGroup))

	var0_11.blocksRaycasts = false

	parallelAsync({
		function(arg0_12)
			arg0_11:DoSwitchBgAnim(1, 0.3, 0.8, LeanTweenType.linear, arg0_12)
		end,
		function(arg0_13)
			arg0_11:FlushBG(arg1_11, arg0_13)
		end
	}, function()
		arg0_11:DoSwitchBgAnim(1, 1, 0.01, LeanTweenType.linear, function()
			var0_11.blocksRaycasts = true
		end)
	end)
end

function var0_0.DoSwitchBgAnim(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16, arg5_16)
	arg0_16:ClearSwitchBgAnim()

	local var0_16 = GetOrAddComponent(arg0_16.bgsGo, typeof(CanvasGroup))

	var0_16.alpha = arg1_16

	LeanTween.value(arg0_16.bgsGo, arg1_16, arg2_16, arg3_16):setOnUpdate(System.Action_float(function(arg0_17)
		var0_16.alpha = arg0_17
	end)):setEase(arg4_16):setOnComplete(System.Action(arg5_16))
end

function var0_0.ClearSwitchBgAnim(arg0_18)
	if LeanTween.isTweening(arg0_18.bgsGo) then
		LeanTween.cancel(arg0_18.bgsGo)
	end

	GetOrAddComponent(arg0_18.bgsGo, typeof(CanvasGroup)).alpha = 1
end

function var0_0.FlushBG(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.skinId
	local var1_19 = pg.ship_skin_template[var0_19]
	local var2_19 = ShipGroup.getDefaultShipConfig(var1_19.ship_group)
	local var3_19 = Ship.New({
		id = 999,
		configId = var2_19.id,
		skin_id = var0_19
	})
	local var4_19 = var3_19:getShipBgPrint(true)
	local var5_19 = pg.ship_skin_template[var0_19].painting

	if (arg0_19.isToggleShowBg or not checkABExist("painting/" .. var5_19 .. "_n")) and var1_19.bg_sp ~= "" then
		var4_19 = var1_19.bg_sp
	end

	local var6_19 = var4_19 ~= var3_19:rarity2bgPrintForGet()

	if var6_19 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_19, var4_19, arg0_19.diffBg.parent, arg0_19.diffBg, function(arg0_20)
			if arg2_19 then
				arg2_19()
			end
		end, function(arg0_21)
			if arg2_19 then
				arg2_19()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_19:getUIName())

		if arg2_19 then
			arg2_19()
		end
	end

	setActive(arg0_19.diffBg, var6_19)
	setActive(arg0_19.defaultBg, not var6_19)
end

function var0_0.FlushName(arg0_22, arg1_22)
	local var0_22 = arg0_22.skinId
	local var1_22 = pg.ship_skin_template[var0_22]

	arg0_22.skinNameTxt.text = SwitchSpecialChar(var1_22.name, true)

	local var2_22 = ShipGroup.getDefaultShipConfig(var1_22.ship_group)

	arg0_22.shipNameTxt.text = var2_22.name
end

function var0_0.FlushPaintingToggle(arg0_23, arg1_23)
	removeOnToggle(arg0_23.dynamicToggle)
	removeOnToggle(arg0_23.showBgToggle)

	local var0_23 = ShipSkin.New({
		id = arg0_23.skinId
	})
	local var1_23 = checkABExist("painting/" .. var0_23:getConfig("painting") .. "_n")

	if arg0_23.isToggleShowBg and not var1_23 then
		triggerToggle(arg0_23.showBgToggle, false)

		arg0_23.isToggleShowBg = false
	elseif var1_23 then
		triggerToggle(arg0_23.showBgToggle, true)

		arg0_23.isToggleShowBg = true
	end

	local var2_23 = var0_23:IsSpine() or var0_23:IsLive2d()

	if LOCK_SKIN_SHOP_ANIM_PREVIEW then
		var2_23 = false
	end

	if var2_23 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_23.isToggleDynamic = true
	end

	if arg0_23.isToggleDynamic and not var2_23 then
		triggerToggle(arg0_23.dynamicToggle, false)

		arg0_23.isToggleDynamic = false
	elseif arg0_23.isToggleDynamic and not arg0_23.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		triggerToggle(arg0_23.dynamicToggle, true)

		arg0_23.isToggleDynamic = true
	end

	if var1_23 then
		onToggle(arg0_23, arg0_23.showBgToggle, function(arg0_24)
			arg0_23.isToggleShowBg = arg0_24

			arg0_23:FlushPainting(arg1_23)
			arg0_23:FlushBG(arg1_23)
		end, SFX_PANEL)
	end

	if var0_23:IsSpine() or var0_23:IsLive2d() then
		onToggle(arg0_23, arg0_23.dynamicToggle, function(arg0_25)
			arg0_23.isToggleDynamic = arg0_25

			setActive(arg0_23.dynamicResToggle, arg0_25)
			setActive(arg0_23.showBgToggle, not arg0_25 and var1_23)
			arg0_23:FlushPainting(arg1_23)
			arg0_23:FlushDynamicPaintingResState(arg1_23)
			arg0_23:RecordFlag(arg0_25)
		end, SFX_PANEL)
	end

	if arg0_23.isToggleDynamic then
		arg0_23:FlushDynamicPaintingResState(arg1_23)
	end

	setActive(arg0_23.dynamicToggle, var2_23)
	setActive(arg0_23.dynamicResToggle, arg0_23.isToggleDynamic)
	setActive(arg0_23.showBgToggle, not arg0_23.isToggleDynamic and var1_23)
end

function var0_0.RecordFlag(arg0_26, arg1_26)
	local var0_26 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_26, arg1_26 and 1 or 0)
	PlayerPrefs.Save()
	arg0_26:emit(NewSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_26)
end

function var0_0.ExistL2dRes(arg0_27, arg1_27)
	local var0_27 = "live2d/" .. string.lower(arg1_27)
	local var1_27 = HXSet.autoHxShiftPath(var0_27, nil, true)

	return checkABExist(var1_27), var1_27
end

function var0_0.ExistSpineRes(arg0_28, arg1_28)
	local var0_28 = "SpinePainting/" .. string.lower(arg1_28)
	local var1_28 = HXSet.autoHxShiftPath(var0_28, nil, true)

	return checkABExist(var1_28), var1_28
end

function var0_0.FlushDynamicPaintingResState(arg0_29, arg1_29)
	if not arg0_29.isToggleDynamic then
		return
	end

	local var0_29 = arg0_29:GetPaintingState(arg1_29)
	local var1_29 = false
	local var2_29 = ""
	local var3_29 = pg.ship_skin_template[arg0_29.skinId].painting

	if var2_0 == var0_29 then
		var1_29, var2_29 = arg0_29:ExistL2dRes(var3_29)
	elseif var3_0 == var0_29 then
		var1_29, var2_29 = arg0_29:ExistSpineRes(var3_29)
	end

	setActive(arg0_29.dynamicResDownaload, var1_29)
	setActive(arg0_29.dynamicResUnDownaload, not var1_29)
	removeOnButton(arg0_29.dynamicResUnDownaload)

	if not var1_29 and var2_29 ~= "" then
		onButton(arg0_29, arg0_29.dynamicResUnDownaload, function()
			arg0_29:DownloadDynamicPainting(var2_29, arg1_29)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.skinId

	if arg0_31.downloads[var0_31] then
		return
	end

	local var1_31 = SkinShopDownloadRequest.New()

	arg0_31.downloads[var0_31] = var1_31

	var1_31:Start(arg1_31, function(arg0_32)
		if arg0_32 and arg0_31.paintingState and arg0_31.paintingState.id == arg2_31.id then
			arg0_31:FlushPainting(arg2_31)
			arg0_31:FlushDynamicPaintingResState(arg2_31)
		end

		var1_31:Dispose()

		arg0_31.downloads[var0_31] = nil
	end)
end

function var0_0.GetPaintingState(arg0_33, arg1_33)
	local var0_33 = ShipSkin.New({
		id = arg0_33.skinId
	})

	if arg0_33.isToggleDynamic and var0_33:IsLive2d() then
		return var2_0
	elseif arg0_33.isToggleDynamic and var0_33:IsSpine() then
		if var0_33:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.FlushPainting(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetPaintingState(arg1_34)
	local var1_34 = pg.ship_skin_template[arg0_34.skinId].painting
	local var2_34 = ShipGroup.GetChangeSkinData(arg0_34.skinId) and true or false

	if var0_34 == var2_0 and not arg0_34:ExistL2dRes(var1_34) or var0_34 == var3_0 and not arg0_34:ExistSpineRes(var1_34) then
		var0_34 = var1_0
	end

	if arg0_34.paintingState and arg0_34.paintingState.state == var0_34 and arg0_34.paintingState.id == arg1_34.id and arg0_34.paintingState.showBg == arg0_34.isToggleShowBg and arg0_34.paintingState.purchaseFlag == arg1_34.buyCount and not var2_34 then
		return
	end

	arg0_34:ClearPainting()

	if var0_34 == var1_0 then
		arg0_34:LoadMeshPainting(arg1_34, arg0_34.isToggleShowBg)
	elseif var0_34 == var2_0 then
		arg0_34:LoadL2dPainting(arg1_34)
	elseif var0_34 == var3_0 then
		arg0_34:LoadSpinePainting(arg1_34)
	end

	arg0_34.paintingState = {
		state = var0_34,
		id = arg1_34.id,
		showBg = arg0_34.isToggleShowBg,
		purchaseFlag = arg1_34.buyCount
	}
end

function var0_0.ClearPainting(arg0_35)
	local var0_35 = arg0_35.paintingState

	if not var0_35 then
		return
	end

	if var0_35.state == var1_0 then
		arg0_35:ClearMeshPainting()
	elseif var0_35.state == var2_0 then
		arg0_35:ClearL2dPainting()
	elseif var0_35.state == var3_0 then
		arg0_35:ClearSpinePainting()
	end

	arg0_35.paintingState = nil
end

function var0_0.LoadMeshPainting(arg0_36, arg1_36, arg2_36)
	local var0_36 = findTF(arg0_36.paintingTF, "fitter")
	local var1_36 = GetOrAddComponent(var0_36, "PaintingScaler")

	var1_36.FrameName = "chuanwu"
	var1_36.Tween = 1

	local var2_36 = pg.ship_skin_template[arg0_36.skinId].painting
	local var3_36 = var2_36

	if not arg2_36 and checkABExist("painting/" .. var2_36 .. "_n") then
		var2_36 = var2_36 .. "_n"
	end

	if not checkABExist("painting/" .. var2_36) then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_36, true, function(arg0_37)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_37, var0_36, false)
		ShipExpressionHelper.SetExpression(var0_36:GetChild(0), var3_36)

		arg0_36.paintingName = var2_36

		if arg0_36.paintingState and arg0_36.paintingState.id ~= arg1_36.id then
			arg0_36:ClearMeshPainting()
		end

		local var0_37 = arg0_37.transform:Find("shop_hx")

		arg0_36:CheckShowShopHx(var0_37, arg1_36)
	end)
end

function var0_0.ClearMeshPainting(arg0_38)
	local var0_38 = arg0_38.paintingTF:Find("fitter")

	if arg0_38.paintingName and var0_38.childCount > 0 then
		local var1_38 = var0_38:GetChild(0).gameObject
		local var2_38 = var1_38.transform:Find("shop_hx")

		arg0_38:RevertShopHx(var2_38)
		PoolMgr.GetInstance():ReturnPainting(arg0_38.paintingName, var1_38)
	end

	arg0_38.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_39, arg1_39)
	local var0_39 = arg0_39.skinId
	local var1_39 = pg.ship_skin_template[var0_39].ship_group
	local var2_39 = ShipGroup.getDefaultShipConfig(var1_39)
	local var3_39 = Live2D.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var2_39.id,
			skin_id = var0_39
		}),
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -1),
		parent = arg0_39.live2dContainer
	})

	var3_39.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_39.live2dChar = Live2D.New(var3_39, function(arg0_40)
		arg0_40:IgonreReactPos(true)
		arg0_39:CheckShowShopHxForL2d(arg0_40, arg1_39)

		if arg0_39.paintingState and arg0_39.paintingState.id ~= arg1_39.id then
			arg0_39:ClearL2dPainting()
		end

		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_41)
	if arg0_41.live2dChar then
		arg0_41:RevertShopHxForL2d(arg0_41.live2dChar)
		arg0_41.live2dChar:Dispose()

		arg0_41.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_42, arg1_42)
	local var0_42 = arg0_42.skinId
	local var1_42 = pg.ship_skin_template[var0_42].ship_group
	local var2_42 = ShipGroup.getDefaultShipConfig(var1_42)
	local var3_42 = SpinePainting.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var2_42.id,
			skin_id = var0_42
		}),
		position = Vector3(0, 0, 0),
		parent = arg0_42.spTF,
		effectParent = arg0_42.spBg
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_42.spinePainting = SpinePainting.New(var3_42, function(arg0_43)
		if arg0_42.paintingState and arg0_42.paintingState.id ~= arg1_42.id then
			arg0_42:ClearSpinePainting()
		end

		local var0_43 = arg0_43._tf:Find("shop_hx")

		arg0_42:CheckShowShopHx(var0_43, arg1_42)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_44)
	if arg0_44.spinePainting and arg0_44.spinePainting._tf then
		local var0_44 = arg0_44.spinePainting._tf:Find("shop_hx")

		arg0_44:RevertShopHx(arg0_44.shopHx)
		arg0_44.spinePainting:Dispose()

		arg0_44.spinePainting = nil
	end
end

function var0_0.CheckShowShopHxForL2d(arg0_45, arg1_45, arg2_45)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0_45 = arg2_45.buyCount <= 0 and 1 or 0

	arg1_45:changeParamaterValue("shophx", var0_45)
end

function var0_0.RevertShopHxForL2d(arg0_46, arg1_46)
	arg1_46:changeParamaterValue("shophx", 0)
end

function var0_0.CheckShowShopHx(arg0_47, arg1_47, arg2_47)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	if not IsNil(arg1_47) and arg2_47.buyCount <= 0 then
		setActive(arg1_47, true)
	end
end

function var0_0.RevertShopHx(arg0_48, arg1_48)
	if not IsNil(arg1_48) then
		setActive(arg1_48, false)
	end
end

function var0_0.FlushPreviewBtn(arg0_49, arg1_49)
	local var0_49 = Goods.ExistFurniture(arg1_49.id)

	removeOnButton(arg0_49.switchPreviewBtn)

	if not var0_49 and arg0_49.isPreviewFurniture then
		arg0_49.isPreviewFurniture = false
	end

	setActive(arg0_49.switchPreviewBtn, var0_49)

	if var0_49 then
		onButton(arg0_49, arg0_49.switchPreviewBtn, function()
			if arg0_49:IsSwitchTweening() then
				return
			end

			arg0_49.isPreviewFurniture = not arg0_49.isPreviewFurniture

			arg0_49:SwitchPreview(arg1_49, arg0_49.isPreviewFurniture, true)
			arg0_49:FlushPrice(arg1_49)
			arg0_49:FlushObtainBtn(arg1_49)
		end, SFX_PANEL)
	end
end

function var0_0.IsSwitchTweening(arg0_51)
	return LeanTween.isTweening(go(arg0_51.furnitureBg)) or LeanTween.isTweening(go(arg0_51.charBg))
end

function var0_0.ClearSwitchTween(arg0_52)
	if arg0_52:IsSwitchTweening() then
		LeanTween.cancel(go(arg0_52.furnitureBg))
		LeanTween.cancel(go(arg0_52.charBg))
	end
end

function var0_0.StartSwitchAnim(arg0_53, arg1_53, arg2_53, arg3_53, arg4_53)
	arg0_53:ClearSwitchTween()

	local var0_53 = arg1_53:GetComponent(typeof(CanvasGroup))
	local var1_53 = arg2_53:GetComponent(typeof(CanvasGroup))
	local var2_53 = var0_53.alpha
	local var3_53 = var1_53.alpha
	local var4_53 = arg1_53.anchoredPosition3D
	local var5_53 = arg2_53.anchoredPosition3D

	LeanTween.moveLocal(go(arg1_53), var5_53, arg3_53):setOnComplete(System.Action(function()
		var0_53.alpha = var3_53
	end))
	LeanTween.moveLocal(go(arg2_53), var4_53, arg3_53):setOnComplete(System.Action(function()
		var1_53.alpha = var2_53

		arg4_53()
	end))
end

function var0_0.SwitchPreview(arg0_56, arg1_56, arg2_56, arg3_56)
	local var0_56 = arg0_56.skinId
	local var1_56 = arg0_56.furnitureBg
	local var2_56 = arg0_56.charBg

	arg0_56:StartSwitchAnim(var1_56, var2_56, arg3_56 and 0.3 or 0, function()
		setActive(arg0_56.charContainer, not arg2_56)
		setActive(arg0_56.furnitureContainer, arg2_56)
	end)

	if not arg2_56 then
		var1_56:SetAsFirstSibling()
		var2_56:SetSiblingIndex(2)

		local var3_56 = pg.ship_skin_template[var0_56]

		arg0_56:FlushChar(var3_56.prefab, var3_56.id)
	else
		var2_56:SetAsFirstSibling()
		var1_56:SetSiblingIndex(2)

		local var4_56 = Goods.Id2FurnitureId(arg1_56.id)
		local var5_56 = Goods.GetFurnitureConfig(arg1_56.id)

		arg0_56.interactionPreview:Flush(var0_56, var4_56, var5_56.scale[2] or 1, var5_56.position[2])
	end
end

function var0_0.GetObtainBtnState(arg0_58, arg1_58)
	if arg1_58:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9_0
	elseif arg0_58.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_58.id)) then
			return var4_0
		else
			return var8_0
		end
	elseif arg1_58.type == Goods.TYPE_ACTIVITY or arg1_58.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6_0
	elseif arg1_58.buyCount > 0 then
		return var4_0
	elseif arg1_58:isDisCount() and arg1_58:IsItemDiscountType() then
		return var7_0
	elseif arg1_58:CanUseVoucherType() or arg1_58:ExistExclusiveDiscountItem() then
		return var10_0
	elseif #arg1_58:GetGiftList() > 0 then
		return var11_0
	else
		return var5_0
	end
end

function var0_0.GetMode(arg0_59)
	return arg0_59.contextData.mode or NewSkinShopScene.MODE_OVERVIEW
end

function var0_0.FlushPrice(arg0_60, arg1_60)
	local var0_60 = arg1_60:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_60 = arg1_60.type == Goods.TYPE_ACTIVITY or arg1_60.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0_60 then
		if arg0_60:GetMode() == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_60:UpdateExperiencePrice4Item(arg1_60)
		else
			arg0_60:UpdateExperiencePrice(arg1_60)
		end
	elseif arg0_60.isPreviewFurniture then
		arg0_60:UpdateFurniturePrice(arg1_60)
	elseif var1_60 then
		-- block empty
	else
		arg0_60:UpdateCommodityPrice(arg1_60)
	end

	local var2_60 = arg1_60.type == Goods.TYPE_SKIN

	setActive(arg0_60.experienceTr, var0_60 and not var1_60)
	setActive(arg0_60.consumeTr, var2_60 and not var0_60 and not var1_60)
end

function var0_0.UpdateExperiencePrice4Item(arg0_61, arg1_61)
	local var0_61 = arg1_61:getConfig("resource_num")
	local var1_61 = getProxy(BagProxy):GetSkinExperienceItems()
	local var2_61 = _.detect(var1_61, function(arg0_62)
		return arg0_62:CanUseForShop(arg1_61.id)
	end)
	local var3_61 = var2_61 and var2_61.count or 0
	local var4_61 = (var3_61 < var0_61 and "<color=" .. COLOR_RED .. ">" or "") .. var3_61 .. (var3_61 < var0_61 and "</color>" or "")

	arg0_61.experienceTxt.text = var4_61 .. "/" .. var0_61
end

function var0_0.UpdateExperiencePrice(arg0_63, arg1_63)
	local var0_63 = arg1_63:getConfig("resource_num")
	local var1_63 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2_63 = (var1_63 < var0_63 and "<color=" .. COLOR_RED .. ">" or "") .. var1_63 .. (var1_63 < var0_63 and "</color>" or "")

	arg0_63.experienceTxt.text = var2_63 .. "/" .. var0_63
end

function var0_0.UpdateCommodityPrice(arg0_64, arg1_64)
	local var0_64 = arg1_64:GetPrice()
	local var1_64 = arg1_64:getConfig("resource_num")

	arg0_64.consumeRealPriceTxt.text = var0_64
	arg0_64.consumePriceTxt.text = var1_64

	setActive(tf(go(arg0_64.consumePriceTxt)).parent, var0_64 ~= var1_64)
end

function var0_0.UpdateFurniturePrice(arg0_65, arg1_65)
	local var0_65 = Goods.Id2FurnitureId(arg1_65.id)
	local var1_65 = Furniture.New({
		id = var0_65
	})
	local var2_65 = var1_65:getConfig("gem_price")

	arg0_65.consumePriceTxt.text = var2_65

	local var3_65 = var1_65:getPrice(PlayerConst.ResDiamond)

	arg0_65.consumeRealPriceTxt.text = var3_65

	setActive(tf(go(arg0_65.consumePriceTxt)).parent, var2_65 ~= var3_65)
end

function var0_0.FlushObtainBtn(arg0_66, arg1_66)
	local var0_66 = arg0_66:GetObtainBtnState(arg1_66)
	local var1_66 = arg0_66.obtainBtnSprites[var0_66]

	if not var1_66 then
		var1_66 = GetSpriteFromAtlas("ui/skinshopui_atlas", var12_0(var0_66))
		arg0_66.obtainBtnSprites[var0_66] = var1_66
	end

	arg0_66.obtainBtnImg.sprite = var1_66

	arg0_66.obtainBtnImg:SetNativeSize()
	setActive(arg0_66.giftTag, var0_66 == var11_0)
	setActive(arg0_66.giftItem, var0_66 == var11_0)

	if var0_66 == var11_0 then
		arg0_66:FlushGift(arg1_66)
	else
		arg0_66.giftText.text = ""
	end

	onButton(arg0_66, arg0_66.obtainBtn, function()
		if var0_66 == var5_0 or var0_66 == var7_0 or var0_66 == var11_0 then
			arg0_66.purchaseView:ExecuteAction("Show", arg1_66)
		else
			arg0_66:OnClickBtn(var0_66, arg1_66)
		end
	end, SFX_PANEL)
end

function var0_0.OnClickBtn(arg0_68, arg1_68, arg2_68)
	if arg1_68 == var5_0 or arg1_68 == var7_0 or arg1_68 == var11_0 then
		arg0_68:OnPurchase(arg2_68)
	elseif arg1_68 == var10_0 then
		arg0_68:OnItemPurchase(arg2_68)
	elseif arg1_68 == var6_0 then
		arg0_68:OnActivity(arg2_68)
	elseif arg1_68 == var8_0 then
		arg0_68:OnBackyard(arg2_68)
	elseif arg1_68 == var9_0 then
		if arg0_68:GetMode() == NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM then
			arg0_68:OnExperience4Item(arg2_68)
		else
			arg0_68:OnExperience(arg2_68)
		end
	end
end

function var0_0.FlushGift(arg0_69, arg1_69)
	local var0_69 = arg1_69:GetGiftList()
	local var1_69 = var0_69[1]

	updateDrop(arg0_69.giftItem, {
		type = var1_69.type,
		id = var1_69.id,
		count = var1_69.count
	})

	local var2_69 = #var0_69 > 1 and "+" .. #var0_69 - 1 .. "..." or ""

	arg0_69.giftText.text = var2_69
end

function var0_0.OnItemPurchase(arg0_70, arg1_70)
	if arg1_70.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0_70 = arg1_70:GetVoucherIdList()
	local var1_70 = getProxy(BagProxy):GetExclusiveDiscountItem4Shop(arg1_70.id)

	if #var0_70 <= 0 and #var1_70 <= 0 then
		return
	end

	local var2_70 = {}

	for iter0_70, iter1_70 in ipairs(var0_70) do
		table.insert(var2_70, iter1_70)
	end

	for iter2_70, iter3_70 in ipairs(var1_70) do
		table.insert(var2_70, iter3_70.id)
	end

	local var3_70 = arg0_70.skinId
	local var4_70 = pg.ship_skin_template[var3_70]
	local var5_70 = SwitchSpecialChar(var4_70.name, true)

	arg0_70.voucherMsgBox:ExecuteAction("Show", {
		itemList = var2_70,
		skinId = var3_70,
		skinName = var5_70,
		price = arg1_70:GetPrice(),
		onYes = function(arg0_71)
			if arg0_71 then
				arg0_70:emit(NewSkinShopMediator.ON_ITEM_PURCHASE, arg0_71, arg1_70.id)
			else
				arg0_70:emit(NewSkinShopMediator.ON_SHOPPING, arg1_70.id, 1)
			end
		end
	})
end

function var0_0.OnPurchase(arg0_72, arg1_72)
	if arg1_72.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1_72:isDisCount() and arg1_72:IsItemDiscountType() then
		arg0_72:emit(NewSkinShopMediator.ON_SHOPPING_BY_ACT, arg1_72.id, 1)
	else
		arg0_72:emit(NewSkinShopMediator.ON_SHOPPING, arg1_72.id, 1)
	end
end

function var0_0.OnActivity(arg0_73, arg1_73)
	local var0_73 = arg1_73:getConfig("time")
	local var1_73 = arg1_73:getConfig("activity")
	local var2_73 = getProxy(ActivityProxy):getActivityById(var1_73)

	if var1_73 == 0 and pg.TimeMgr.GetInstance():inTime(var0_73) or var2_73 and not var2_73:isEnd() then
		if arg1_73.type == Goods.TYPE_ACTIVITY then
			arg0_73:emit(NewSkinShopMediator.GO_SHOPS_LAYER, arg1_73:getConfig("activity"))
		elseif arg1_73.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3_73 = arg1_73:getConfig("scene")

			if var3_73 and #var3_73 > 0 then
				arg0_73:emit(NewSkinShopMediator.OPEN_SCENE, var3_73)
			else
				arg0_73:emit(NewSkinShopMediator.OPEN_ACTIVITY, var1_73)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0_0.OnBackyard(arg0_74, arg1_74)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0_74 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_74.name, var0_74.level))

		return
	end

	arg0_74:emit(NewSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0_0.OnExperience(arg0_75, arg1_75)
	local var0_75 = arg0_75.skinId
	local var1_75 = getProxy(ShipSkinProxy):getSkinById(var0_75)

	if var1_75 and not var1_75:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_75 = arg1_75:getConfig("resource_num")
	local var3_75 = arg1_75:getConfig("time_second") * var2_75
	local var4_75, var5_75, var6_75, var7_75 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_75)
	local var8_75 = pg.ship_skin_template[arg0_75.skinId].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_75, var8_75, var4_75, var5_75),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2_75 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_75:emit(NewSkinShopMediator.ON_SHOPPING, arg1_75.id, 1)
		end
	})
end

function var0_0.OnExperience4Item(arg0_77, arg1_77)
	local var0_77 = arg0_77.skinId
	local var1_77 = getProxy(ShipSkinProxy):getSkinById(var0_77)

	if var1_77 and not var1_77:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_77 = arg1_77:getConfig("resource_num")
	local var3_77 = arg1_77:getConfig("time_second") * var2_77
	local var4_77, var5_77, var6_77, var7_77 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_77)
	local var8_77 = pg.ship_skin_template[arg0_77.skinId].name
	local var9_77 = getProxy(BagProxy):GetSkinExperienceItems()
	local var10_77 = _.detect(var9_77, function(arg0_78)
		return arg0_78:CanUseForShop(arg1_77.id)
	end)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_77, var8_77, var4_77, var5_77),
		onYes = function()
			if not var10_77 or var10_77.count < var2_77 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_77:emit(NewSkinShopMediator.ON_ITEM_EXPERIENCE, var10_77.id, arg1_77.id, 1)
		end
	})
end

function var0_0.FlushTag(arg0_80, arg1_80)
	local var0_80 = arg0_80.skinId
	local var1_80 = pg.ship_skin_template[var0_80].tag

	arg0_80.uiTagList:make(function(arg0_81, arg1_81, arg2_81)
		if arg0_81 == UIItemList.EventUpdate then
			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var1_80[arg1_81 + 1]), function(arg0_82)
				if arg0_80.exited then
					return
				end

				local var0_82 = arg2_81:Find("icon"):GetComponent(typeof(Image))

				var0_82.sprite = arg0_82

				var0_82:SetNativeSize()
			end)
		end
	end)
	arg0_80.uiTagList:align(#var1_80)
end

function var0_0.FlushChar(arg0_83, arg1_83, arg2_83)
	if arg0_83.prefabName and arg0_83.prefabName == arg1_83 then
		return
	end

	arg0_83:ReturnChar()
	PoolMgr.GetInstance():GetSpineChar(arg1_83, true, function(arg0_84)
		arg0_83.spineChar = tf(arg0_84)
		arg0_83.prefabName = arg1_83

		local var0_84 = pg.skinshop_spine_scale[arg2_83]

		if var0_84 then
			arg0_83.spineChar.localScale = Vector3(var0_84.skinshop_scale, var0_84.skinshop_scale, 1)
		else
			arg0_83.spineChar.localScale = Vector3(0.9, 0.9, 1)
		end

		arg0_83.spineChar.localPosition = Vector3(0, 0, 0)

		pg.ViewUtils.SetLayer(arg0_83.spineChar, Layer.UI)
		setParent(arg0_83.spineChar, arg0_83.charContainer)
		arg0_84:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end)
end

function var0_0.FlushTimeline(arg0_85, arg1_85)
	local var0_85 = arg0_85.skinId
	local var1_85 = false
	local var2_85

	if arg1_85:IsActivityExtra() and arg1_85:ShowMaintenanceTime() then
		local var3_85, var4_85 = arg1_85:GetMaintenanceMonthAndDay()

		function var2_85()
			return i18n("limit_skin_time_before_maintenance", var3_85, var4_85)
		end

		var1_85 = true
	elseif arg1_85:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5_85 = getProxy(ShipSkinProxy):getSkinById(var0_85)

		var1_85 = var5_85 and var5_85:isExpireType() and not var5_85:isExpired()

		if var1_85 then
			function var2_85()
				return skinTimeStamp(var5_85:getRemainTime())
			end
		end
	else
		local var6_85, var7_85 = pg.TimeMgr.GetInstance():inTime(arg1_85:getConfig("time"))

		var1_85 = var7_85

		if var1_85 then
			local var8_85 = pg.TimeMgr.GetInstance():Table2ServerTime(var7_85)

			function var2_85()
				return skinCommdityTimeStamp(var8_85)
			end
		end
	end

	setActive(arg0_85.timeLimitTr, var1_85)
	arg0_85:ClearTimer()

	if var1_85 then
		arg0_85:AddTimer(var2_85)
	end
end

function var0_0.AddTimer(arg0_89, arg1_89)
	arg0_89.timer = Timer.New(function()
		arg0_89.timeLimitTxt.text = arg1_89()
	end, 1, -1)

	arg0_89.timer.func()
	arg0_89.timer:Start()
end

function var0_0.ClearTimer(arg0_91)
	if arg0_91.timer then
		arg0_91.timer:Stop()

		arg0_91.timer = nil
	end
end

function var0_0.ReturnChar(arg0_92)
	if not IsNil(arg0_92.spineChar) then
		arg0_92.spineChar.gameObject:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0_92.prefabName, arg0_92.spineChar.gameObject)

		arg0_92.spineChar = nil
		arg0_92.prefabName = nil
	end
end

function var0_0.ClosePurchaseView(arg0_93)
	if arg0_93.purchaseView and arg0_93.purchaseView:GetLoaded() then
		arg0_93.purchaseView:Hide()
	end
end

function var0_0.Dispose(arg0_94)
	arg0_94.exited = true

	pg.DelegateInfo.Dispose(arg0_94)
	arg0_94:ClearSwitchBgAnim()
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_94:getUIName())

	if arg0_94.voucherMsgBox then
		arg0_94.voucherMsgBox:Destroy()

		arg0_94.voucherMsgBox = nil
	end

	if arg0_94.purchaseView then
		arg0_94.purchaseView:Destroy()

		arg0_94.purchaseView = nil
	end

	for iter0_94, iter1_94 in pairs(arg0_94.downloads) do
		iter1_94:Dispose()
	end

	arg0_94.downloads = {}

	arg0_94:ClearPainting()

	for iter2_94, iter3_94 in pairs(arg0_94.obtainBtnSprites) do
		arg0_94.obtainBtnSprites[iter3_94] = nil
	end

	arg0_94.obtainBtnSprites = nil

	if arg0_94.interactionPreview then
		arg0_94.interactionPreview:Dispose()

		arg0_94.interactionPreview = nil
	end

	arg0_94:ClearSwitchTween()
	arg0_94:disposeEvent()
	arg0_94:ClearTimer()
	arg0_94:ReturnChar()
end

return var0_0
