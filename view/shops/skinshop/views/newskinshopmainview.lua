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

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	pg.DelegateInfo.New(arg0_2)
	var0_0.super.Ctor(arg0_2, arg2_2)

	arg0_2._go = arg1_2.gameObject
	arg0_2._tf = arg1_2
	arg0_2.overlay = arg0_2._tf:Find("overlay")
	arg0_2.titleTr = arg0_2._tf:Find("overlay/title")
	arg0_2.skinNameTxt = arg0_2._tf:Find("overlay/title/skin_name"):GetComponent(typeof(Text))
	arg0_2.shipNameTxt = arg0_2._tf:Find("overlay/title/name"):GetComponent(typeof(Text))
	arg0_2.timeLimitTr = arg0_2._tf:Find("overlay/title/limit_time")
	arg0_2.timeLimitTxt = arg0_2.timeLimitTr:Find("Text"):GetComponent(typeof(Text))
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
end

function var0_0.Flush(arg0_6, arg1_6)
	if not arg1_6 then
		arg0_6:FlushStyle(true)

		return
	end

	arg0_6:FlushStyle(false)

	if not (arg0_6.commodity and arg0_6.commodity.id == arg1_6.id) then
		arg0_6:FlushName(arg1_6)
		arg0_6:FlushPreviewBtn(arg1_6)
		arg0_6:FlushTimeline(arg1_6)
		arg0_6:FlushTag(arg1_6)
		arg0_6:SwitchPreview(arg1_6, arg0_6.isPreviewFurniture, false)
		arg0_6:FlushPaintingToggle(arg1_6)
		arg0_6:FlushBG(arg1_6)
		arg0_6:FlushPainting(arg1_6)
	else
		arg0_6:FlushBG(arg1_6)
		arg0_6:FlushPainting(arg1_6)
	end

	arg0_6:FlushPrice(arg1_6)
	arg0_6:FlushObtainBtn(arg1_6)

	arg0_6.commodity = arg1_6
end

function var0_0.FlushStyle(arg0_7, arg1_7)
	setActive(arg0_7.paintingTF.parent, not arg1_7)
	setActive(arg0_7.defaultBg, arg1_7)
	setActive(arg0_7.diffBg.parent, not arg1_7)
	setActive(arg0_7.titleTr, not arg1_7)
	setActive(arg0_7.rightTr, not arg1_7)
end

function var0_0.getUIName(arg0_8)
	return "NewSkinShopMainView"
end

function var0_0.FlushBgWithAnim(arg0_9, arg1_9)
	local var0_9 = arg0_9._tf:GetComponent(typeof(CanvasGroup))

	var0_9.blocksRaycasts = false

	parallelAsync({
		function(arg0_10)
			arg0_9:DoSwitchBgAnim(1, 0.3, 0.8, LeanTweenType.linear, arg0_10)
		end,
		function(arg0_11)
			arg0_9:FlushBG(arg1_9, arg0_11)
		end
	}, function()
		arg0_9:DoSwitchBgAnim(1, 1, 0.01, LeanTweenType.linear, function()
			var0_9.blocksRaycasts = true
		end)
	end)
end

function var0_0.DoSwitchBgAnim(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14, arg5_14)
	arg0_14:ClearSwitchBgAnim()

	local var0_14 = GetOrAddComponent(arg0_14.bgsGo, typeof(CanvasGroup))

	var0_14.alpha = arg1_14

	LeanTween.value(arg0_14.bgsGo, arg1_14, arg2_14, arg3_14):setOnUpdate(System.Action_float(function(arg0_15)
		var0_14.alpha = arg0_15
	end)):setEase(arg4_14):setOnComplete(System.Action(arg5_14))
end

function var0_0.ClearSwitchBgAnim(arg0_16)
	if LeanTween.isTweening(arg0_16.bgsGo) then
		LeanTween.cancel(arg0_16.bgsGo)
	end

	GetOrAddComponent(arg0_16.bgsGo, typeof(CanvasGroup)).alpha = 1
end

function var0_0.FlushBG(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17:getSkinId()
	local var1_17 = pg.ship_skin_template[var0_17]
	local var2_17 = ShipGroup.getDefaultShipConfig(var1_17.ship_group)
	local var3_17 = Ship.New({
		id = 999,
		configId = var2_17.id,
		skin_id = var0_17
	})
	local var4_17 = var3_17:getShipBgPrint(true)
	local var5_17 = pg.ship_skin_template[var0_17].painting

	if (arg0_17.isToggleShowBg or not checkABExist("painting/" .. var5_17 .. "_n")) and var1_17.bg_sp ~= "" then
		var4_17 = var1_17.bg_sp
	end

	local var6_17 = var4_17 ~= var3_17:rarity2bgPrintForGet()

	if var6_17 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_17, var4_17, arg0_17.diffBg.parent, arg0_17.diffBg, function(arg0_18)
			if arg2_17 then
				arg2_17()
			end
		end, function(arg0_19)
			if arg2_17 then
				arg2_17()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_17:getUIName())

		if arg2_17 then
			arg2_17()
		end
	end

	setActive(arg0_17.diffBg, var6_17)
	setActive(arg0_17.defaultBg, not var6_17)
end

function var0_0.FlushName(arg0_20, arg1_20)
	local var0_20 = arg1_20:getSkinId()
	local var1_20 = pg.ship_skin_template[var0_20]

	arg0_20.skinNameTxt.text = SwitchSpecialChar(var1_20.name, true)

	local var2_20 = ShipGroup.getDefaultShipConfig(var1_20.ship_group)

	arg0_20.shipNameTxt.text = var2_20.name
end

function var0_0.FlushPaintingToggle(arg0_21, arg1_21)
	removeOnToggle(arg0_21.dynamicToggle)
	removeOnToggle(arg0_21.showBgToggle)

	local var0_21 = ShipSkin.New({
		id = arg1_21:getSkinId()
	})
	local var1_21 = checkABExist("painting/" .. var0_21:getConfig("painting") .. "_n")

	if arg0_21.isToggleShowBg and not var1_21 then
		triggerToggle(arg0_21.showBgToggle, false)

		arg0_21.isToggleShowBg = false
	elseif var1_21 then
		triggerToggle(arg0_21.showBgToggle, true)

		arg0_21.isToggleShowBg = true
	end

	local var2_21 = var0_21:IsSpine() or var0_21:IsLive2d()

	if LOCK_SKIN_SHOP_ANIM_PREVIEW then
		var2_21 = false
	end

	if var2_21 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_21.isToggleDynamic = true
	end

	if arg0_21.isToggleDynamic and not var2_21 then
		triggerToggle(arg0_21.dynamicToggle, false)

		arg0_21.isToggleDynamic = false
	elseif arg0_21.isToggleDynamic and not arg0_21.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		triggerToggle(arg0_21.dynamicToggle, true)

		arg0_21.isToggleDynamic = true
	end

	if var1_21 then
		onToggle(arg0_21, arg0_21.showBgToggle, function(arg0_22)
			arg0_21.isToggleShowBg = arg0_22

			arg0_21:FlushPainting(arg1_21)
			arg0_21:FlushBG(arg1_21)
		end, SFX_PANEL)
	end

	if var0_21:IsSpine() or var0_21:IsLive2d() then
		onToggle(arg0_21, arg0_21.dynamicToggle, function(arg0_23)
			arg0_21.isToggleDynamic = arg0_23

			setActive(arg0_21.dynamicResToggle, arg0_23)
			setActive(arg0_21.showBgToggle, not arg0_23 and var1_21)
			arg0_21:FlushPainting(arg1_21)
			arg0_21:FlushDynamicPaintingResState(arg1_21)
			arg0_21:RecordFlag(arg0_23)
		end, SFX_PANEL)
	end

	if arg0_21.isToggleDynamic then
		arg0_21:FlushDynamicPaintingResState(arg1_21)
	end

	setActive(arg0_21.dynamicToggle, var2_21)
	setActive(arg0_21.dynamicResToggle, arg0_21.isToggleDynamic)
	setActive(arg0_21.showBgToggle, not arg0_21.isToggleDynamic and var1_21)
end

function var0_0.RecordFlag(arg0_24, arg1_24)
	local var0_24 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_24, arg1_24 and 1 or 0)
	PlayerPrefs.Save()
	arg0_24:emit(NewSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_24)
end

function var0_0.ExistL2dRes(arg0_25, arg1_25)
	local var0_25 = "live2d/" .. string.lower(arg1_25)
	local var1_25 = HXSet.autoHxShiftPath(var0_25, nil, true)

	return checkABExist(var1_25), var1_25
end

function var0_0.ExistSpineRes(arg0_26, arg1_26)
	local var0_26 = "SpinePainting/" .. string.lower(arg1_26)
	local var1_26 = HXSet.autoHxShiftPath(var0_26, nil, true)

	return checkABExist(var1_26), var1_26
end

function var0_0.FlushDynamicPaintingResState(arg0_27, arg1_27)
	if not arg0_27.isToggleDynamic then
		return
	end

	local var0_27 = arg0_27:GetPaintingState(arg1_27)
	local var1_27 = false
	local var2_27 = ""
	local var3_27 = pg.ship_skin_template[arg1_27:getSkinId()].painting

	if var2_0 == var0_27 then
		var1_27, var2_27 = arg0_27:ExistL2dRes(var3_27)
	elseif var3_0 == var0_27 then
		var1_27, var2_27 = arg0_27:ExistSpineRes(var3_27)
	end

	setActive(arg0_27.dynamicResDownaload, var1_27)
	setActive(arg0_27.dynamicResUnDownaload, not var1_27)
	removeOnButton(arg0_27.dynamicResUnDownaload)

	if not var1_27 and var2_27 ~= "" then
		onButton(arg0_27, arg0_27.dynamicResUnDownaload, function()
			arg0_27:DownloadDynamicPainting(var2_27, arg1_27)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg2_29:getSkinId()

	if arg0_29.downloads[var0_29] then
		return
	end

	local var1_29 = SkinShopDownloadRequest.New()

	arg0_29.downloads[var0_29] = var1_29

	var1_29:Start(arg1_29, function(arg0_30)
		if arg0_30 and arg0_29.paintingState and arg0_29.paintingState.id == arg2_29.id then
			arg0_29:FlushPainting(arg2_29)
			arg0_29:FlushDynamicPaintingResState(arg2_29)
		end

		var1_29:Dispose()

		arg0_29.downloads[var0_29] = nil
	end)
end

function var0_0.GetPaintingState(arg0_31, arg1_31)
	local var0_31 = ShipSkin.New({
		id = arg1_31:getSkinId()
	})

	if arg0_31.isToggleDynamic and var0_31:IsLive2d() then
		return var2_0
	elseif arg0_31.isToggleDynamic and var0_31:IsSpine() then
		if var0_31:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.FlushPainting(arg0_32, arg1_32)
	local var0_32 = arg0_32:GetPaintingState(arg1_32)
	local var1_32 = pg.ship_skin_template[arg1_32:getSkinId()].painting

	if var0_32 == var2_0 and not arg0_32:ExistL2dRes(var1_32) or var0_32 == var3_0 and not arg0_32:ExistSpineRes(var1_32) then
		var0_32 = var1_0
	end

	if arg0_32.paintingState and arg0_32.paintingState.state == var0_32 and arg0_32.paintingState.id == arg1_32.id and arg0_32.paintingState.showBg == arg0_32.isToggleShowBg and arg0_32.paintingState.purchaseFlag == arg1_32.buyCount then
		return
	end

	arg0_32:ClearPainting()

	if var0_32 == var1_0 then
		arg0_32:LoadMeshPainting(arg1_32, arg0_32.isToggleShowBg)
	elseif var0_32 == var2_0 then
		arg0_32:LoadL2dPainting(arg1_32)
	elseif var0_32 == var3_0 then
		arg0_32:LoadSpinePainting(arg1_32)
	end

	arg0_32.paintingState = {
		state = var0_32,
		id = arg1_32.id,
		showBg = arg0_32.isToggleShowBg,
		purchaseFlag = arg1_32.buyCount
	}
end

function var0_0.ClearPainting(arg0_33)
	local var0_33 = arg0_33.paintingState

	if not var0_33 then
		return
	end

	if var0_33.state == var1_0 then
		arg0_33:ClearMeshPainting()
	elseif var0_33.state == var2_0 then
		arg0_33:ClearL2dPainting()
	elseif var0_33.state == var3_0 then
		arg0_33:ClearSpinePainting()
	end

	arg0_33.paintingState = nil
end

function var0_0.LoadMeshPainting(arg0_34, arg1_34, arg2_34)
	local var0_34 = findTF(arg0_34.paintingTF, "fitter")
	local var1_34 = GetOrAddComponent(var0_34, "PaintingScaler")

	var1_34.FrameName = "chuanwu"
	var1_34.Tween = 1

	local var2_34 = pg.ship_skin_template[arg1_34:getSkinId()].painting
	local var3_34 = var2_34

	if not arg2_34 and checkABExist("painting/" .. var2_34 .. "_n") then
		var2_34 = var2_34 .. "_n"
	end

	if not checkABExist("painting/" .. var2_34) then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_34, true, function(arg0_35)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_35, var0_34, false)
		ShipExpressionHelper.SetExpression(var0_34:GetChild(0), var3_34)

		arg0_34.paintingName = var2_34

		if arg0_34.paintingState and arg0_34.paintingState.id ~= arg1_34.id then
			arg0_34:ClearMeshPainting()
		end

		local var0_35 = arg0_35.transform:Find("shop_hx")

		arg0_34:CheckShowShopHx(var0_35, arg1_34)
	end)
end

function var0_0.ClearMeshPainting(arg0_36)
	local var0_36 = arg0_36.paintingTF:Find("fitter")

	if arg0_36.paintingName and var0_36.childCount > 0 then
		local var1_36 = var0_36:GetChild(0).gameObject
		local var2_36 = var1_36.transform:Find("shop_hx")

		arg0_36:RevertShopHx(var2_36)
		PoolMgr.GetInstance():ReturnPainting(arg0_36.paintingName, var1_36)
	end

	arg0_36.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_37, arg1_37)
	local var0_37 = arg1_37:getSkinId()
	local var1_37 = pg.ship_skin_template[var0_37].ship_group
	local var2_37 = ShipGroup.getDefaultShipConfig(var1_37)
	local var3_37 = Live2D.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var2_37.id,
			skin_id = var0_37
		}),
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -1),
		parent = arg0_37.live2dContainer
	})

	var3_37.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_37.live2dChar = Live2D.New(var3_37, function(arg0_38)
		arg0_38:IgonreReactPos(true)
		arg0_37:CheckShowShopHxForL2d(arg0_38, arg1_37)

		if arg0_37.paintingState and arg0_37.paintingState.id ~= arg1_37.id then
			arg0_37:ClearL2dPainting()
		end

		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_39)
	if arg0_39.live2dChar then
		arg0_39:RevertShopHxForL2d(arg0_39.live2dChar)
		arg0_39.live2dChar:Dispose()

		arg0_39.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_40, arg1_40)
	local var0_40 = arg1_40:getSkinId()
	local var1_40 = pg.ship_skin_template[var0_40].ship_group
	local var2_40 = ShipGroup.getDefaultShipConfig(var1_40)
	local var3_40 = SpinePainting.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var2_40.id,
			skin_id = var0_40
		}),
		position = Vector3(0, 0, 0),
		parent = arg0_40.spTF,
		effectParent = arg0_40.spBg
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_40.spinePainting = SpinePainting.New(var3_40, function(arg0_41)
		if arg0_40.paintingState and arg0_40.paintingState.id ~= arg1_40.id then
			arg0_40:ClearSpinePainting()
		end

		local var0_41 = arg0_41._tf:Find("shop_hx")

		arg0_40:CheckShowShopHx(var0_41, arg1_40)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_42)
	if arg0_42.spinePainting and arg0_42.spinePainting._tf then
		local var0_42 = arg0_42.spinePainting._tf:Find("shop_hx")

		arg0_42:RevertShopHx(arg0_42.shopHx)
		arg0_42.spinePainting:Dispose()

		arg0_42.spinePainting = nil
	end
end

function var0_0.CheckShowShopHxForL2d(arg0_43, arg1_43, arg2_43)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0_43 = arg2_43.buyCount <= 0 and 1 or 0

	arg1_43:changeParamaterValue("shophx", var0_43)
end

function var0_0.RevertShopHxForL2d(arg0_44, arg1_44)
	arg1_44:changeParamaterValue("shophx", 0)
end

function var0_0.CheckShowShopHx(arg0_45, arg1_45, arg2_45)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	if not IsNil(arg1_45) and arg2_45.buyCount <= 0 then
		setActive(arg1_45, true)
	end
end

function var0_0.RevertShopHx(arg0_46, arg1_46)
	if not IsNil(arg1_46) then
		setActive(arg1_46, false)
	end
end

function var0_0.FlushPreviewBtn(arg0_47, arg1_47)
	local var0_47 = Goods.ExistFurniture(arg1_47.id)

	removeOnButton(arg0_47.switchPreviewBtn)

	if not var0_47 and arg0_47.isPreviewFurniture then
		arg0_47.isPreviewFurniture = false
	end

	setActive(arg0_47.switchPreviewBtn, var0_47)

	if var0_47 then
		onButton(arg0_47, arg0_47.switchPreviewBtn, function()
			if arg0_47:IsSwitchTweening() then
				return
			end

			arg0_47.isPreviewFurniture = not arg0_47.isPreviewFurniture

			arg0_47:SwitchPreview(arg1_47, arg0_47.isPreviewFurniture, true)
			arg0_47:FlushPrice(arg1_47)
			arg0_47:FlushObtainBtn(arg1_47)
		end, SFX_PANEL)
	end
end

function var0_0.IsSwitchTweening(arg0_49)
	return LeanTween.isTweening(go(arg0_49.furnitureBg)) or LeanTween.isTweening(go(arg0_49.charBg))
end

function var0_0.ClearSwitchTween(arg0_50)
	if arg0_50:IsSwitchTweening() then
		LeanTween.cancel(go(arg0_50.furnitureBg))
		LeanTween.cancel(go(arg0_50.charBg))
	end
end

function var0_0.StartSwitchAnim(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51)
	arg0_51:ClearSwitchTween()

	local var0_51 = arg1_51:GetComponent(typeof(CanvasGroup))
	local var1_51 = arg2_51:GetComponent(typeof(CanvasGroup))
	local var2_51 = var0_51.alpha
	local var3_51 = var1_51.alpha
	local var4_51 = arg1_51.anchoredPosition3D
	local var5_51 = arg2_51.anchoredPosition3D

	LeanTween.moveLocal(go(arg1_51), var5_51, arg3_51):setOnComplete(System.Action(function()
		var0_51.alpha = var3_51
	end))
	LeanTween.moveLocal(go(arg2_51), var4_51, arg3_51):setOnComplete(System.Action(function()
		var1_51.alpha = var2_51

		arg4_51()
	end))
end

function var0_0.SwitchPreview(arg0_54, arg1_54, arg2_54, arg3_54)
	local var0_54 = arg1_54:getSkinId()
	local var1_54 = arg0_54.furnitureBg
	local var2_54 = arg0_54.charBg

	arg0_54:StartSwitchAnim(var1_54, var2_54, arg3_54 and 0.3 or 0, function()
		setActive(arg0_54.charContainer, not arg2_54)
		setActive(arg0_54.furnitureContainer, arg2_54)
	end)

	if not arg2_54 then
		var1_54:SetAsFirstSibling()
		var2_54:SetSiblingIndex(2)

		local var3_54 = pg.ship_skin_template[var0_54]

		arg0_54:FlushChar(var3_54.prefab, var3_54.id)
	else
		var2_54:SetAsFirstSibling()
		var1_54:SetSiblingIndex(2)

		local var4_54 = Goods.Id2FurnitureId(arg1_54.id)
		local var5_54 = Goods.GetFurnitureConfig(arg1_54.id)

		arg0_54.interactionPreview:Flush(var0_54, var4_54, var5_54.scale[2] or 1, var5_54.position[2])
	end
end

function var0_0.GetObtainBtnState(arg0_56, arg1_56)
	if arg1_56:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9_0
	elseif arg0_56.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1_56.id)) then
			return var4_0
		else
			return var8_0
		end
	elseif arg1_56.type == Goods.TYPE_ACTIVITY or arg1_56.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6_0
	elseif arg1_56.buyCount > 0 then
		return var4_0
	elseif arg1_56:isDisCount() and arg1_56:IsItemDiscountType() then
		return var7_0
	elseif arg1_56:CanUseVoucherType() then
		return var10_0
	elseif #arg1_56:GetGiftList() > 0 then
		return var11_0
	else
		return var5_0
	end
end

function var0_0.FlushPrice(arg0_57, arg1_57)
	local var0_57 = arg1_57:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1_57 = arg1_57.type == Goods.TYPE_ACTIVITY or arg1_57.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0_57 then
		arg0_57:UpdateExperiencePrice(arg1_57)
	elseif arg0_57.isPreviewFurniture then
		arg0_57:UpdateFurniturePrice(arg1_57)
	elseif var1_57 then
		-- block empty
	else
		arg0_57:UpdateCommodityPrice(arg1_57)
	end

	local var2_57 = arg1_57.type == Goods.TYPE_SKIN

	setActive(arg0_57.experienceTr, var0_57 and not var1_57)
	setActive(arg0_57.consumeTr, var2_57 and not var0_57 and not var1_57)
end

function var0_0.UpdateExperiencePrice(arg0_58, arg1_58)
	local var0_58 = arg1_58:getConfig("resource_num")
	local var1_58 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2_58 = (var1_58 < var0_58 and "<color=" .. COLOR_RED .. ">" or "") .. var1_58 .. (var1_58 < var0_58 and "</color>" or "")

	arg0_58.experienceTxt.text = var2_58 .. "/" .. var0_58
end

function var0_0.UpdateCommodityPrice(arg0_59, arg1_59)
	local var0_59 = arg1_59:GetPrice()
	local var1_59 = arg1_59:getConfig("resource_num")

	arg0_59.consumeRealPriceTxt.text = var0_59
	arg0_59.consumePriceTxt.text = var1_59

	setActive(tf(go(arg0_59.consumePriceTxt)).parent, var0_59 ~= var1_59)
end

function var0_0.UpdateFurniturePrice(arg0_60, arg1_60)
	local var0_60 = Goods.Id2FurnitureId(arg1_60.id)
	local var1_60 = Furniture.New({
		id = var0_60
	})
	local var2_60 = var1_60:getConfig("gem_price")

	arg0_60.consumePriceTxt.text = var2_60

	local var3_60 = var1_60:getPrice(PlayerConst.ResDiamond)

	arg0_60.consumeRealPriceTxt.text = var3_60

	setActive(tf(go(arg0_60.consumePriceTxt)).parent, var2_60 ~= var3_60)
end

function var0_0.FlushObtainBtn(arg0_61, arg1_61)
	local var0_61 = arg0_61:GetObtainBtnState(arg1_61)
	local var1_61 = arg0_61.obtainBtnSprites[var0_61]

	if not var1_61 then
		var1_61 = GetSpriteFromAtlas("ui/skinshopui_atlas", var12_0(var0_61))
		arg0_61.obtainBtnSprites[var0_61] = var1_61
	end

	arg0_61.obtainBtnImg.sprite = var1_61

	arg0_61.obtainBtnImg:SetNativeSize()
	setActive(arg0_61.giftTag, var0_61 == var11_0)
	setActive(arg0_61.giftItem, var0_61 == var11_0)

	if var0_61 == var11_0 then
		arg0_61:FlushGift(arg1_61)
	else
		arg0_61.giftText.text = ""
	end

	onButton(arg0_61, arg0_61.obtainBtn, function()
		if var0_61 == var5_0 or var0_61 == var7_0 or var0_61 == var11_0 then
			arg0_61.purchaseView:ExecuteAction("Show", arg1_61)
		else
			arg0_61:OnClickBtn(var0_61, arg1_61)
		end
	end, SFX_PANEL)
end

function var0_0.OnClickBtn(arg0_63, arg1_63, arg2_63)
	if arg1_63 == var5_0 or arg1_63 == var7_0 or arg1_63 == var11_0 then
		arg0_63:OnPurchase(arg2_63)
	elseif arg1_63 == var10_0 then
		arg0_63:OnItemPurchase(arg2_63)
	elseif arg1_63 == var6_0 then
		arg0_63:OnActivity(arg2_63)
	elseif arg1_63 == var8_0 then
		arg0_63:OnBackyard(arg2_63)
	elseif arg1_63 == var9_0 then
		arg0_63:OnExperience(arg2_63)
	end
end

function var0_0.FlushGift(arg0_64, arg1_64)
	local var0_64 = arg1_64:GetGiftList()
	local var1_64 = var0_64[1]

	updateDrop(arg0_64.giftItem, {
		type = var1_64.type,
		id = var1_64.id,
		count = var1_64.count
	})

	local var2_64 = #var0_64 > 1 and "+" .. #var0_64 - 1 .. "..." or ""

	arg0_64.giftText.text = var2_64
end

function var0_0.OnItemPurchase(arg0_65, arg1_65)
	if arg1_65.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0_65 = arg1_65:GetVoucherIdList()

	if #var0_65 <= 0 then
		return
	end

	local var1_65 = arg1_65:getSkinId()
	local var2_65 = pg.ship_skin_template[var1_65]
	local var3_65 = SwitchSpecialChar(var2_65.name, true)

	arg0_65.voucherMsgBox:ExecuteAction("Show", {
		itemList = var0_65,
		skinName = var3_65,
		price = arg1_65:GetPrice(),
		onYes = function(arg0_66)
			if arg0_66 then
				arg0_65:emit(NewSkinShopMediator.ON_ITEM_PURCHASE, arg0_66, arg1_65.id)
			else
				arg0_65:emit(NewSkinShopMediator.ON_SHOPPING, arg1_65.id, 1)
			end
		end
	})
end

function var0_0.OnPurchase(arg0_67, arg1_67)
	if arg1_67.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1_67:isDisCount() and arg1_67:IsItemDiscountType() then
		arg0_67:emit(NewSkinShopMediator.ON_SHOPPING_BY_ACT, arg1_67.id, 1)
	else
		arg0_67:emit(NewSkinShopMediator.ON_SHOPPING, arg1_67.id, 1)
	end
end

function var0_0.OnActivity(arg0_68, arg1_68)
	local var0_68 = arg1_68:getConfig("time")
	local var1_68 = arg1_68:getConfig("activity")
	local var2_68 = getProxy(ActivityProxy):getActivityById(var1_68)

	if var1_68 == 0 and pg.TimeMgr.GetInstance():inTime(var0_68) or var2_68 and not var2_68:isEnd() then
		if arg1_68.type == Goods.TYPE_ACTIVITY then
			arg0_68:emit(NewSkinShopMediator.GO_SHOPS_LAYER, arg1_68:getConfig("activity"))
		elseif arg1_68.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3_68 = arg1_68:getConfig("scene")

			if var3_68 and #var3_68 > 0 then
				arg0_68:emit(NewSkinShopMediator.OPEN_SCENE, var3_68)
			else
				arg0_68:emit(NewSkinShopMediator.OPEN_ACTIVITY, var1_68)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0_0.OnBackyard(arg0_69, arg1_69)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0_69 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_69.name, var0_69.level))

		return
	end

	arg0_69:emit(NewSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0_0.OnExperience(arg0_70, arg1_70)
	local var0_70 = arg1_70:getSkinId()
	local var1_70 = getProxy(ShipSkinProxy):getSkinById(var0_70)

	if var1_70 and not var1_70:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2_70 = arg1_70:getConfig("resource_num")
	local var3_70 = arg1_70:getConfig("time_second") * var2_70
	local var4_70, var5_70, var6_70, var7_70 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_70)
	local var8_70 = pg.ship_skin_template[arg1_70:getSkinId()].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2_70, var8_70, var4_70, var5_70),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2_70 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0_70:emit(NewSkinShopMediator.ON_SHOPPING, arg1_70.id, 1)
		end
	})
end

function var0_0.FlushTag(arg0_72, arg1_72)
	local var0_72 = arg1_72:getSkinId()
	local var1_72 = pg.ship_skin_template[var0_72].tag

	arg0_72.uiTagList:make(function(arg0_73, arg1_73, arg2_73)
		if arg0_73 == UIItemList.EventUpdate then
			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var1_72[arg1_73 + 1]), function(arg0_74)
				if arg0_72.exited then
					return
				end

				local var0_74 = arg2_73:Find("icon"):GetComponent(typeof(Image))

				var0_74.sprite = arg0_74

				var0_74:SetNativeSize()
			end)
		end
	end)
	arg0_72.uiTagList:align(#var1_72)
end

function var0_0.FlushChar(arg0_75, arg1_75, arg2_75)
	if arg0_75.prefabName and arg0_75.prefabName == arg1_75 then
		return
	end

	arg0_75:ReturnChar()
	PoolMgr.GetInstance():GetSpineChar(arg1_75, true, function(arg0_76)
		arg0_75.spineChar = tf(arg0_76)
		arg0_75.prefabName = arg1_75

		local var0_76 = pg.skinshop_spine_scale[arg2_75]

		if var0_76 then
			arg0_75.spineChar.localScale = Vector3(var0_76.skinshop_scale, var0_76.skinshop_scale, 1)
		else
			arg0_75.spineChar.localScale = Vector3(0.9, 0.9, 1)
		end

		arg0_75.spineChar.localPosition = Vector3(0, 0, 0)

		pg.ViewUtils.SetLayer(arg0_75.spineChar, Layer.UI)
		setParent(arg0_75.spineChar, arg0_75.charContainer)
		arg0_76:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end)
end

function var0_0.FlushTimeline(arg0_77, arg1_77)
	local var0_77 = arg1_77:getSkinId()
	local var1_77 = false
	local var2_77

	if arg1_77:IsActivityExtra() and arg1_77:ShowMaintenanceTime() then
		local var3_77, var4_77 = arg1_77:GetMaintenanceMonthAndDay()

		function var2_77()
			return i18n("limit_skin_time_before_maintenance", var3_77, var4_77)
		end

		var1_77 = true
	elseif arg1_77:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5_77 = getProxy(ShipSkinProxy):getSkinById(var0_77)

		var1_77 = var5_77 and var5_77:isExpireType() and not var5_77:isExpired()

		if var1_77 then
			function var2_77()
				return skinTimeStamp(var5_77:getRemainTime())
			end
		end
	else
		local var6_77, var7_77 = pg.TimeMgr.GetInstance():inTime(arg1_77:getConfig("time"))

		var1_77 = var7_77

		if var1_77 then
			local var8_77 = pg.TimeMgr.GetInstance():Table2ServerTime(var7_77)

			function var2_77()
				return skinCommdityTimeStamp(var8_77)
			end
		end
	end

	setActive(arg0_77.timeLimitTr, var1_77)
	arg0_77:ClearTimer()

	if var1_77 then
		arg0_77:AddTimer(var2_77)
	end
end

function var0_0.AddTimer(arg0_81, arg1_81)
	arg0_81.timer = Timer.New(function()
		arg0_81.timeLimitTxt.text = arg1_81()
	end, 1, -1)

	arg0_81.timer.func()
	arg0_81.timer:Start()
end

function var0_0.ClearTimer(arg0_83)
	if arg0_83.timer then
		arg0_83.timer:Stop()

		arg0_83.timer = nil
	end
end

function var0_0.ReturnChar(arg0_84)
	if not IsNil(arg0_84.spineChar) then
		arg0_84.spineChar.gameObject:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0_84.prefabName, arg0_84.spineChar.gameObject)

		arg0_84.spineChar = nil
		arg0_84.prefabName = nil
	end
end

function var0_0.ClosePurchaseView(arg0_85)
	if arg0_85.purchaseView and arg0_85.purchaseView:GetLoaded() then
		arg0_85.purchaseView:Hide()
	end
end

function var0_0.Dispose(arg0_86)
	arg0_86.exited = true

	pg.DelegateInfo.Dispose(arg0_86)
	arg0_86:ClearSwitchBgAnim()
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_86:getUIName())

	if arg0_86.voucherMsgBox then
		arg0_86.voucherMsgBox:Destroy()

		arg0_86.voucherMsgBox = nil
	end

	if arg0_86.purchaseView then
		arg0_86.purchaseView:Destroy()

		arg0_86.purchaseView = nil
	end

	for iter0_86, iter1_86 in pairs(arg0_86.downloads) do
		iter1_86:Dispose()
	end

	arg0_86.downloads = {}

	arg0_86:ClearPainting()

	for iter2_86, iter3_86 in pairs(arg0_86.obtainBtnSprites) do
		arg0_86.obtainBtnSprites[iter3_86] = nil
	end

	arg0_86.obtainBtnSprites = nil

	if arg0_86.interactionPreview then
		arg0_86.interactionPreview:Dispose()

		arg0_86.interactionPreview = nil
	end

	arg0_86:ClearSwitchTween()
	arg0_86:disposeEvent()
	arg0_86:ClearTimer()
	arg0_86:ReturnChar()
end

return var0_0
