local var0 = class("NewSkinShopMainView", import("view.base.BaseEventLogic"))

var0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW = "NewSkinShopMainView:EVT_SHOW_OR_HIDE_PURCHASE_VIEW"
var0.EVT_ON_PURCHASE = "NewSkinShopMainView:EVT_ON_PURCHASE"

local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 1
local var5 = 2
local var6 = 3
local var7 = 4
local var8 = 5
local var9 = 6
local var10 = 7
local var11 = 8

local function var12(arg0)
	if not var0.obtainBtnSpriteNames then
		var0.obtainBtnSpriteNames = {
			[var4] = "yigoumai_butten",
			[var5] = "goumai_butten",
			[var6] = "qianwanghuoqu_butten",
			[var7] = "item_buy",
			[var8] = "furniture_shop",
			[var9] = "tiyan_btn",
			[var10] = "item_buy",
			[var11] = "buy_with_gift"
		}
	end

	return var0.obtainBtnSpriteNames[arg0]
end

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)
	var0.super.Ctor(arg0, arg2)

	arg0._go = arg1.gameObject
	arg0._tf = arg1
	arg0.overlay = arg0._tf:Find("overlay")
	arg0.titleTr = arg0._tf:Find("overlay/title")
	arg0.skinNameTxt = arg0._tf:Find("overlay/title/skin_name"):GetComponent(typeof(Text))
	arg0.shipNameTxt = arg0._tf:Find("overlay/title/name"):GetComponent(typeof(Text))
	arg0.timeLimitTr = arg0._tf:Find("overlay/title/limit_time")
	arg0.timeLimitTxt = arg0.timeLimitTr:Find("Text"):GetComponent(typeof(Text))
	arg0.rightTr = arg0._tf:Find("overlay/right")
	arg0.uiTagList = UIItemList.New(arg0._tf:Find("overlay/right/tags"), arg0._tf:Find("overlay/right/tags/tpl"))
	arg0.charContainer = arg0._tf:Find("overlay/right/char")
	arg0.furnitureContainer = arg0._tf:Find("overlay/right/fur")
	arg0.charBg = arg0._tf:Find("overlay/right/bg/char")
	arg0.furnitureBg = arg0._tf:Find("overlay/right/bg/furn")
	arg0.switchPreviewBtn = arg0._tf:Find("overlay/right/switch")
	arg0.obtainBtn = arg0._tf:Find("overlay/right/price/btn")
	arg0.obtainBtnImg = arg0.obtainBtn:GetComponent(typeof(Image))
	arg0.giftTag = arg0.obtainBtn:Find("tag")
	arg0.giftItem = arg0.obtainBtn:Find("item")
	arg0.giftText = arg0._tf:Find("overlay/right/price/btn/Text"):GetComponent(typeof(Text))
	arg0.consumeTr = arg0._tf:Find("overlay/right/price/consume")
	arg0.consumeRealPriceTxt = arg0.consumeTr:Find("Text"):GetComponent(typeof(Text))
	arg0.consumePriceTxt = arg0.consumeTr:Find("originalprice/Text"):GetComponent(typeof(Text))
	arg0.experienceTr = arg0._tf:Find("overlay/right/price/timelimt")
	arg0.experienceTxt = arg0.experienceTr:Find("consume/Text"):GetComponent(typeof(Text))
	arg0.dynamicToggle = arg0._tf:Find("overlay/right/toggles/l2d_preview")
	arg0.showBgToggle = arg0._tf:Find("overlay/right/toggles/hideObjToggle")
	arg0.dynamicResToggle = arg0._tf:Find("overlay/right/toggles/l2d_res_state")
	arg0.dynamicResDownaload = arg0._tf:Find("overlay/right/toggles/l2d_res_state/downloaded")
	arg0.dynamicResUnDownaload = arg0._tf:Find("overlay/right/toggles/l2d_res_state/undownload")
	arg0.paintingTF = arg0._tf:Find("painting/paint")
	arg0.live2dContainer = arg0._tf:Find("painting/paint/live2d")
	arg0.spTF = arg0._tf:Find("painting/paint/spinePainting")
	arg0.spBg = arg0._tf:Find("painting/paintBg/spinePainting")
	arg0.bgsGo = arg0._tf:Find("bgs").gameObject
	arg0.diffBg = arg0._tf:Find("bgs/diffBg/bg")
	arg0.defaultBg = arg0._tf:Find("bgs/default")
	arg0.downloads = {}
	arg0.obtainBtnSprites = {}
	arg0.isToggleDynamic = false
	arg0.isToggleShowBg = true
	arg0.isPreviewFurniture = false
	arg0.interactionPreview = BackYardInteractionPreview.New(arg0.furnitureContainer, Vector3(0, 0, 0))
	arg0.voucherMsgBox = SkinVoucherMsgBox.New(pg.UIMgr.GetInstance().OverlayMain)
	arg0.purchaseView = NewSkinShopPurchaseView.New(arg0._tf, arg2)

	arg0:RegisterEvent()
end

function var0.RegisterEvent(arg0)
	arg0:bind(var0.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, function(arg0, arg1)
		setAnchoredPosition(arg0.paintingTF, {
			x = arg1 and -440 or -120
		})
		setActive(arg0.overlay, not arg1)
	end)
	arg0:bind(var0.EVT_ON_PURCHASE, function(arg0, arg1)
		local var0 = arg0:GetObtainBtnState(arg1)

		arg0:OnClickBtn(var0, arg1)
	end)
end

function var0.Flush(arg0, arg1)
	if not arg1 then
		arg0:FlushStyle(true)

		return
	end

	arg0:FlushStyle(false)

	if not (arg0.commodity and arg0.commodity.id == arg1.id) then
		arg0:FlushName(arg1)
		arg0:FlushPreviewBtn(arg1)
		arg0:FlushTimeline(arg1)
		arg0:FlushTag(arg1)
		arg0:SwitchPreview(arg1, arg0.isPreviewFurniture, false)
		arg0:FlushPaintingToggle(arg1)
		arg0:FlushBG(arg1)
		arg0:FlushPainting(arg1)
	else
		arg0:FlushBG(arg1)
		arg0:FlushPainting(arg1)
	end

	arg0:FlushPrice(arg1)
	arg0:FlushObtainBtn(arg1)

	arg0.commodity = arg1
end

function var0.FlushStyle(arg0, arg1)
	setActive(arg0.paintingTF.parent, not arg1)
	setActive(arg0.defaultBg, arg1)
	setActive(arg0.diffBg.parent, not arg1)
	setActive(arg0.titleTr, not arg1)
	setActive(arg0.rightTr, not arg1)
end

function var0.getUIName(arg0)
	return "NewSkinShopMainView"
end

function var0.FlushBgWithAnim(arg0, arg1)
	local var0 = arg0._tf:GetComponent(typeof(CanvasGroup))

	var0.blocksRaycasts = false

	parallelAsync({
		function(arg0)
			arg0:DoSwitchBgAnim(1, 0.3, 0.8, LeanTweenType.linear, arg0)
		end,
		function(arg0)
			arg0:FlushBG(arg1, arg0)
		end
	}, function()
		arg0:DoSwitchBgAnim(1, 1, 0.01, LeanTweenType.linear, function()
			var0.blocksRaycasts = true
		end)
	end)
end

function var0.DoSwitchBgAnim(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0:ClearSwitchBgAnim()

	local var0 = GetOrAddComponent(arg0.bgsGo, typeof(CanvasGroup))

	var0.alpha = arg1

	LeanTween.value(arg0.bgsGo, arg1, arg2, arg3):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end)):setEase(arg4):setOnComplete(System.Action(arg5))
end

function var0.ClearSwitchBgAnim(arg0)
	if LeanTween.isTweening(arg0.bgsGo) then
		LeanTween.cancel(arg0.bgsGo)
	end

	GetOrAddComponent(arg0.bgsGo, typeof(CanvasGroup)).alpha = 1
end

function var0.FlushBG(arg0, arg1, arg2)
	local var0 = arg1:getSkinId()
	local var1 = pg.ship_skin_template[var0]
	local var2 = ShipGroup.getDefaultShipConfig(var1.ship_group)
	local var3 = Ship.New({
		id = 999,
		configId = var2.id,
		skin_id = var0
	})
	local var4 = var3:getShipBgPrint(true)
	local var5 = pg.ship_skin_template[var0].painting

	if (arg0.isToggleShowBg or not checkABExist("painting/" .. var5 .. "_n")) and var1.bg_sp ~= "" then
		var4 = var1.bg_sp
	end

	local var6 = var4 ~= var3:rarity2bgPrintForGet()

	if var6 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0, var4, arg0.diffBg.parent, arg0.diffBg, function(arg0)
			if arg2 then
				arg2()
			end
		end, function(arg0)
			if arg2 then
				arg2()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0:getUIName())

		if arg2 then
			arg2()
		end
	end

	setActive(arg0.diffBg, var6)
	setActive(arg0.defaultBg, not var6)
end

function var0.FlushName(arg0, arg1)
	local var0 = arg1:getSkinId()
	local var1 = pg.ship_skin_template[var0]

	arg0.skinNameTxt.text = SwitchSpecialChar(var1.name, true)

	local var2 = ShipGroup.getDefaultShipConfig(var1.ship_group)

	arg0.shipNameTxt.text = var2.name
end

function var0.FlushPaintingToggle(arg0, arg1)
	removeOnToggle(arg0.dynamicToggle)
	removeOnToggle(arg0.showBgToggle)

	local var0 = ShipSkin.New({
		id = arg1:getSkinId()
	})
	local var1 = checkABExist("painting/" .. var0:getConfig("painting") .. "_n")

	if arg0.isToggleShowBg and not var1 then
		triggerToggle(arg0.showBgToggle, false)

		arg0.isToggleShowBg = false
	elseif var1 then
		triggerToggle(arg0.showBgToggle, true)

		arg0.isToggleShowBg = true
	end

	local var2 = var0:IsSpine() or var0:IsLive2d()

	if LOCK_SKIN_SHOP_ANIM_PREVIEW then
		var2 = false
	end

	if var2 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0.isToggleDynamic = true
	end

	if arg0.isToggleDynamic and not var2 then
		triggerToggle(arg0.dynamicToggle, false)

		arg0.isToggleDynamic = false
	elseif arg0.isToggleDynamic and not arg0.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		triggerToggle(arg0.dynamicToggle, true)

		arg0.isToggleDynamic = true
	end

	if var1 then
		onToggle(arg0, arg0.showBgToggle, function(arg0)
			arg0.isToggleShowBg = arg0

			arg0:FlushPainting(arg1)
			arg0:FlushBG(arg1)
		end, SFX_PANEL)
	end

	if var0:IsSpine() or var0:IsLive2d() then
		onToggle(arg0, arg0.dynamicToggle, function(arg0)
			arg0.isToggleDynamic = arg0

			setActive(arg0.dynamicResToggle, arg0)
			setActive(arg0.showBgToggle, not arg0 and var1)
			arg0:FlushPainting(arg1)
			arg0:FlushDynamicPaintingResState(arg1)
			arg0:RecordFlag(arg0)
		end, SFX_PANEL)
	end

	if arg0.isToggleDynamic then
		arg0:FlushDynamicPaintingResState(arg1)
	end

	setActive(arg0.dynamicToggle, var2)
	setActive(arg0.dynamicResToggle, arg0.isToggleDynamic)
	setActive(arg0.showBgToggle, not arg0.isToggleDynamic and var1)
end

function var0.RecordFlag(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0, arg1 and 1 or 0)
	PlayerPrefs.Save()
	arg0:emit(NewSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1)
end

function var0.ExistL2dRes(arg0, arg1)
	local var0 = "live2d/" .. string.lower(arg1)
	local var1 = HXSet.autoHxShiftPath(var0, nil, true)

	return checkABExist(var1), var1
end

function var0.ExistSpineRes(arg0, arg1)
	local var0 = "SpinePainting/" .. string.lower(arg1)
	local var1 = HXSet.autoHxShiftPath(var0, nil, true)

	return checkABExist(var1), var1
end

function var0.FlushDynamicPaintingResState(arg0, arg1)
	if not arg0.isToggleDynamic then
		return
	end

	local var0 = arg0:GetPaintingState(arg1)
	local var1 = false
	local var2 = ""
	local var3 = pg.ship_skin_template[arg1:getSkinId()].painting

	if var2 == var0 then
		var1, var2 = arg0:ExistL2dRes(var3)
	elseif var3 == var0 then
		var1, var2 = arg0:ExistSpineRes(var3)
	end

	setActive(arg0.dynamicResDownaload, var1)
	setActive(arg0.dynamicResUnDownaload, not var1)
	removeOnButton(arg0.dynamicResUnDownaload)

	if not var1 and var2 ~= "" then
		onButton(arg0, arg0.dynamicResUnDownaload, function()
			arg0:DownloadDynamicPainting(var2, arg1)
		end, SFX_PANEL)
	end
end

function var0.DownloadDynamicPainting(arg0, arg1, arg2)
	local var0 = arg2:getSkinId()

	if arg0.downloads[var0] then
		return
	end

	local var1 = SkinShopDownloadRequest.New()

	arg0.downloads[var0] = var1

	var1:Start(arg1, function(arg0)
		if arg0 and arg0.paintingState and arg0.paintingState.id == arg2.id then
			arg0:FlushPainting(arg2)
			arg0:FlushDynamicPaintingResState(arg2)
		end

		var1:Dispose()

		arg0.downloads[var0] = nil
	end)
end

function var0.GetPaintingState(arg0, arg1)
	local var0 = ShipSkin.New({
		id = arg1:getSkinId()
	})

	if arg0.isToggleDynamic and var0:IsLive2d() then
		return var2
	elseif arg0.isToggleDynamic and var0:IsSpine() then
		if var0:getConfig("spine_use_live2d") == 1 then
			return var2
		end

		return var3
	else
		return var1
	end
end

function var0.FlushPainting(arg0, arg1)
	local var0 = arg0:GetPaintingState(arg1)
	local var1 = pg.ship_skin_template[arg1:getSkinId()].painting

	if var0 == var2 and not arg0:ExistL2dRes(var1) or var0 == var3 and not arg0:ExistSpineRes(var1) then
		var0 = var1
	end

	if arg0.paintingState and arg0.paintingState.state == var0 and arg0.paintingState.id == arg1.id and arg0.paintingState.showBg == arg0.isToggleShowBg and arg0.paintingState.purchaseFlag == arg1.buyCount then
		return
	end

	arg0:ClearPainting()

	if var0 == var1 then
		arg0:LoadMeshPainting(arg1, arg0.isToggleShowBg)
	elseif var0 == var2 then
		arg0:LoadL2dPainting(arg1)
	elseif var0 == var3 then
		arg0:LoadSpinePainting(arg1)
	end

	arg0.paintingState = {
		state = var0,
		id = arg1.id,
		showBg = arg0.isToggleShowBg,
		purchaseFlag = arg1.buyCount
	}
end

function var0.ClearPainting(arg0)
	local var0 = arg0.paintingState

	if not var0 then
		return
	end

	if var0.state == var1 then
		arg0:ClearMeshPainting()
	elseif var0.state == var2 then
		arg0:ClearL2dPainting()
	elseif var0.state == var3 then
		arg0:ClearSpinePainting()
	end

	arg0.paintingState = nil
end

function var0.LoadMeshPainting(arg0, arg1, arg2)
	local var0 = findTF(arg0.paintingTF, "fitter")
	local var1 = GetOrAddComponent(var0, "PaintingScaler")

	var1.FrameName = "chuanwu"
	var1.Tween = 1

	local var2 = pg.ship_skin_template[arg1:getSkinId()].painting
	local var3 = var2

	if not arg2 and checkABExist("painting/" .. var2 .. "_n") then
		var2 = var2 .. "_n"
	end

	if not checkABExist("painting/" .. var2) then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0, var0, false)
		ShipExpressionHelper.SetExpression(var0:GetChild(0), var3)

		arg0.paintingName = var2

		if arg0.paintingState and arg0.paintingState.id ~= arg1.id then
			arg0:ClearMeshPainting()
		end

		local var0 = arg0.transform:Find("shop_hx")

		arg0:CheckShowShopHx(var0, arg1)
	end)
end

function var0.ClearMeshPainting(arg0)
	local var0 = arg0.paintingTF:Find("fitter")

	if arg0.paintingName and var0.childCount > 0 then
		local var1 = var0:GetChild(0).gameObject
		local var2 = var1.transform:Find("shop_hx")

		arg0:RevertShopHx(var2)
		PoolMgr.GetInstance():ReturnPainting(arg0.paintingName, var1)
	end

	arg0.paintingName = nil
end

function var0.LoadL2dPainting(arg0, arg1)
	local var0 = arg1:getSkinId()
	local var1 = pg.ship_skin_template[var0].ship_group
	local var2 = ShipGroup.getDefaultShipConfig(var1)
	local var3 = Live2D.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var2.id,
			skin_id = var0
		}),
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -1),
		parent = arg0.live2dContainer
	})

	var3.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0.live2dChar = Live2D.New(var3, function(arg0)
		arg0:IgonreReactPos(true)
		arg0:CheckShowShopHxForL2d(arg0, arg1)

		if arg0.paintingState and arg0.paintingState.id ~= arg1.id then
			arg0:ClearL2dPainting()
		end

		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0.ClearL2dPainting(arg0)
	if arg0.live2dChar then
		arg0:RevertShopHxForL2d(arg0.live2dChar)
		arg0.live2dChar:Dispose()

		arg0.live2dChar = nil
	end
end

function var0.LoadSpinePainting(arg0, arg1)
	local var0 = arg1:getSkinId()
	local var1 = pg.ship_skin_template[var0].ship_group
	local var2 = ShipGroup.getDefaultShipConfig(var1)
	local var3 = SpinePainting.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var2.id,
			skin_id = var0
		}),
		position = Vector3(0, 0, 0),
		parent = arg0.spTF,
		effectParent = arg0.spBg
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0.spinePainting = SpinePainting.New(var3, function(arg0)
		if arg0.paintingState and arg0.paintingState.id ~= arg1.id then
			arg0:ClearSpinePainting()
		end

		local var0 = arg0._tf:Find("shop_hx")

		arg0:CheckShowShopHx(var0, arg1)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0.ClearSpinePainting(arg0)
	if arg0.spinePainting and arg0.spinePainting._tf then
		local var0 = arg0.spinePainting._tf:Find("shop_hx")

		arg0:RevertShopHx(arg0.shopHx)
		arg0.spinePainting:Dispose()

		arg0.spinePainting = nil
	end
end

function var0.CheckShowShopHxForL2d(arg0, arg1, arg2)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	local var0 = arg2.buyCount <= 0 and 1 or 0

	arg1:changeParamaterValue("shophx", var0)
end

function var0.RevertShopHxForL2d(arg0, arg1)
	arg1:changeParamaterValue("shophx", 0)
end

function var0.CheckShowShopHx(arg0, arg1, arg2)
	if PLATFORM_CODE ~= PLATFORM_CH then
		return
	end

	if not HXSet.isHx() then
		return
	end

	if not IsNil(arg1) and arg2.buyCount <= 0 then
		setActive(arg1, true)
	end
end

function var0.RevertShopHx(arg0, arg1)
	if not IsNil(arg1) then
		setActive(arg1, false)
	end
end

function var0.FlushPreviewBtn(arg0, arg1)
	local var0 = Goods.ExistFurniture(arg1.id)

	removeOnButton(arg0.switchPreviewBtn)

	if not var0 and arg0.isPreviewFurniture then
		arg0.isPreviewFurniture = false
	end

	setActive(arg0.switchPreviewBtn, var0)

	if var0 then
		onButton(arg0, arg0.switchPreviewBtn, function()
			if arg0:IsSwitchTweening() then
				return
			end

			arg0.isPreviewFurniture = not arg0.isPreviewFurniture

			arg0:SwitchPreview(arg1, arg0.isPreviewFurniture, true)
			arg0:FlushPrice(arg1)
			arg0:FlushObtainBtn(arg1)
		end, SFX_PANEL)
	end
end

function var0.IsSwitchTweening(arg0)
	return LeanTween.isTweening(go(arg0.furnitureBg)) or LeanTween.isTweening(go(arg0.charBg))
end

function var0.ClearSwitchTween(arg0)
	if arg0:IsSwitchTweening() then
		LeanTween.cancel(go(arg0.furnitureBg))
		LeanTween.cancel(go(arg0.charBg))
	end
end

function var0.StartSwitchAnim(arg0, arg1, arg2, arg3, arg4)
	arg0:ClearSwitchTween()

	local var0 = arg1:GetComponent(typeof(CanvasGroup))
	local var1 = arg2:GetComponent(typeof(CanvasGroup))
	local var2 = var0.alpha
	local var3 = var1.alpha
	local var4 = arg1.anchoredPosition3D
	local var5 = arg2.anchoredPosition3D

	LeanTween.moveLocal(go(arg1), var5, arg3):setOnComplete(System.Action(function()
		var0.alpha = var3
	end))
	LeanTween.moveLocal(go(arg2), var4, arg3):setOnComplete(System.Action(function()
		var1.alpha = var2

		arg4()
	end))
end

function var0.SwitchPreview(arg0, arg1, arg2, arg3)
	local var0 = arg1:getSkinId()
	local var1 = arg0.furnitureBg
	local var2 = arg0.charBg

	arg0:StartSwitchAnim(var1, var2, arg3 and 0.3 or 0, function()
		setActive(arg0.charContainer, not arg2)
		setActive(arg0.furnitureContainer, arg2)
	end)

	if not arg2 then
		var1:SetAsFirstSibling()
		var2:SetSiblingIndex(2)

		local var3 = pg.ship_skin_template[var0]

		arg0:FlushChar(var3.prefab, var3.id)
	else
		var2:SetAsFirstSibling()
		var1:SetSiblingIndex(2)

		local var4 = Goods.Id2FurnitureId(arg1.id)
		local var5 = Goods.GetFurnitureConfig(arg1.id)

		arg0.interactionPreview:Flush(var0, var4, var5.scale[2] or 1, var5.position[2])
	end
end

function var0.GetObtainBtnState(arg0, arg1)
	if arg1:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var9
	elseif arg0.isPreviewFurniture then
		if getProxy(DormProxy):getRawData():HasFurniture(Goods.Id2FurnitureId(arg1.id)) then
			return var4
		else
			return var8
		end
	elseif arg1.type == Goods.TYPE_ACTIVITY or arg1.type == Goods.TYPE_ACTIVITY_EXTRA then
		return var6
	elseif arg1.buyCount > 0 then
		return var4
	elseif arg1:isDisCount() and arg1:IsItemDiscountType() then
		return var7
	elseif arg1:CanUseVoucherType() then
		return var10
	elseif #arg1:GetGiftList() > 0 then
		return var11
	else
		return var5
	end
end

function var0.FlushPrice(arg0, arg1)
	local var0 = arg1:getConfig("genre") == ShopArgs.SkinShopTimeLimit
	local var1 = arg1.type == Goods.TYPE_ACTIVITY or arg1.type == Goods.TYPE_ACTIVITY_EXTRA

	if var0 then
		arg0:UpdateExperiencePrice(arg1)
	elseif arg0.isPreviewFurniture then
		arg0:UpdateFurniturePrice(arg1)
	elseif var1 then
		-- block empty
	else
		arg0:UpdateCommodityPrice(arg1)
	end

	local var2 = arg1.type == Goods.TYPE_SKIN

	setActive(arg0.experienceTr, var0 and not var1)
	setActive(arg0.consumeTr, var2 and not var0 and not var1)
end

function var0.UpdateExperiencePrice(arg0, arg1)
	local var0 = arg1:getConfig("resource_num")
	local var1 = getProxy(PlayerProxy):getRawData():getSkinTicket()
	local var2 = (var1 < var0 and "<color=" .. COLOR_RED .. ">" or "") .. var1 .. (var1 < var0 and "</color>" or "")

	arg0.experienceTxt.text = var2 .. "/" .. var0
end

function var0.UpdateCommodityPrice(arg0, arg1)
	local var0 = arg1:GetPrice()
	local var1 = arg1:getConfig("resource_num")

	arg0.consumeRealPriceTxt.text = var0
	arg0.consumePriceTxt.text = var1

	setActive(tf(go(arg0.consumePriceTxt)).parent, var0 ~= var1)
end

function var0.UpdateFurniturePrice(arg0, arg1)
	local var0 = Goods.Id2FurnitureId(arg1.id)
	local var1 = Furniture.New({
		id = var0
	})
	local var2 = var1:getConfig("gem_price")

	arg0.consumePriceTxt.text = var2

	local var3 = var1:getPrice(PlayerConst.ResDiamond)

	arg0.consumeRealPriceTxt.text = var3

	setActive(tf(go(arg0.consumePriceTxt)).parent, var2 ~= var3)
end

function var0.FlushObtainBtn(arg0, arg1)
	local var0 = arg0:GetObtainBtnState(arg1)
	local var1 = arg0.obtainBtnSprites[var0]

	if not var1 then
		var1 = GetSpriteFromAtlas("ui/skinshopui_atlas", var12(var0))
		arg0.obtainBtnSprites[var0] = var1
	end

	arg0.obtainBtnImg.sprite = var1

	arg0.obtainBtnImg:SetNativeSize()
	setActive(arg0.giftTag, var0 == var11)
	setActive(arg0.giftItem, var0 == var11)

	if var0 == var11 then
		arg0:FlushGift(arg1)
	else
		arg0.giftText.text = ""
	end

	onButton(arg0, arg0.obtainBtn, function()
		if var0 == var5 or var0 == var7 or var0 == var11 then
			arg0.purchaseView:ExecuteAction("Show", arg1)
		else
			arg0:OnClickBtn(var0, arg1)
		end
	end, SFX_PANEL)
end

function var0.OnClickBtn(arg0, arg1, arg2)
	if arg1 == var5 or arg1 == var7 or arg1 == var11 then
		arg0:OnPurchase(arg2)
	elseif arg1 == var10 then
		arg0:OnItemPurchase(arg2)
	elseif arg1 == var6 then
		arg0:OnActivity(arg2)
	elseif arg1 == var8 then
		arg0:OnBackyard(arg2)
	elseif arg1 == var9 then
		arg0:OnExperience(arg2)
	end
end

function var0.FlushGift(arg0, arg1)
	local var0 = arg1:GetGiftList()
	local var1 = var0[1]

	updateDrop(arg0.giftItem, {
		type = var1.type,
		id = var1.id,
		count = var1.count
	})

	local var2 = #var0 > 1 and "+" .. #var0 - 1 .. "..." or ""

	arg0.giftText.text = var2
end

function var0.OnItemPurchase(arg0, arg1)
	if arg1.type ~= Goods.TYPE_SKIN then
		return
	end

	local var0 = arg1:GetVoucherIdList()

	if #var0 <= 0 then
		return
	end

	local var1 = arg1:getSkinId()
	local var2 = pg.ship_skin_template[var1]
	local var3 = SwitchSpecialChar(var2.name, true)

	arg0.voucherMsgBox:ExecuteAction("Show", {
		itemList = var0,
		skinName = var3,
		price = arg1:GetPrice(),
		onYes = function(arg0)
			if arg0 then
				arg0:emit(NewSkinShopMediator.ON_ITEM_PURCHASE, arg0, arg1.id)
			else
				arg0:emit(NewSkinShopMediator.ON_SHOPPING, arg1.id, 1)
			end
		end
	})
end

function var0.OnPurchase(arg0, arg1)
	if arg1.type ~= Goods.TYPE_SKIN then
		return
	end

	if arg1:isDisCount() and arg1:IsItemDiscountType() then
		arg0:emit(NewSkinShopMediator.ON_SHOPPING_BY_ACT, arg1.id, 1)
	else
		arg0:emit(NewSkinShopMediator.ON_SHOPPING, arg1.id, 1)
	end
end

function var0.OnActivity(arg0, arg1)
	local var0 = arg1:getConfig("time")
	local var1 = arg1:getConfig("activity")
	local var2 = getProxy(ActivityProxy):getActivityById(var1)

	if var1 == 0 and pg.TimeMgr.GetInstance():inTime(var0) or var2 and not var2:isEnd() then
		if arg1.type == Goods.TYPE_ACTIVITY then
			arg0:emit(NewSkinShopMediator.GO_SHOPS_LAYER, arg1:getConfig("activity"))
		elseif arg1.type == Goods.TYPE_ACTIVITY_EXTRA then
			local var3 = arg1:getConfig("scene")

			if var3 and #var3 > 0 then
				arg0:emit(NewSkinShopMediator.OPEN_SCENE, var3)
			else
				arg0:emit(NewSkinShopMediator.OPEN_ACTIVITY, var1)
			end
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
	end
end

function var0.OnBackyard(arg0, arg1)
	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "BackYardMediator") then
		local var0 = pg.open_systems_limited[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0.name, var0.level))

		return
	end

	arg0:emit(NewSkinShopMediator.ON_BACKYARD_SHOP)
end

function var0.OnExperience(arg0, arg1)
	local var0 = arg1:getSkinId()
	local var1 = getProxy(ShipSkinProxy):getSkinById(var0)

	if var1 and not var1:isExpireType() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))

		return
	end

	local var2 = arg1:getConfig("resource_num")
	local var3 = arg1:getConfig("time_second") * var2
	local var4, var5, var6, var7 = pg.TimeMgr.GetInstance():parseTimeFrom(var3)
	local var8 = pg.ship_skin_template[arg1:getSkinId()].name

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("exchange_limit_skin_tip", var2, var8, var4, var5),
		onYes = function()
			if getProxy(PlayerProxy):getRawData():getSkinTicket() < var2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end

			arg0:emit(NewSkinShopMediator.ON_SHOPPING, arg1.id, 1)
		end
	})
end

function var0.FlushTag(arg0, arg1)
	local var0 = arg1:getSkinId()
	local var1 = pg.ship_skin_template[var0].tag

	arg0.uiTagList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var1[arg1 + 1]), function(arg0)
				if arg0.exited then
					return
				end

				local var0 = arg2:Find("icon"):GetComponent(typeof(Image))

				var0.sprite = arg0

				var0:SetNativeSize()
			end)
		end
	end)
	arg0.uiTagList:align(#var1)
end

function var0.FlushChar(arg0, arg1, arg2)
	if arg0.prefabName and arg0.prefabName == arg1 then
		return
	end

	arg0:ReturnChar()
	PoolMgr.GetInstance():GetSpineChar(arg1, true, function(arg0)
		arg0.spineChar = tf(arg0)
		arg0.prefabName = arg1

		local var0 = pg.skinshop_spine_scale[arg2]

		if var0 then
			arg0.spineChar.localScale = Vector3(var0.skinshop_scale, var0.skinshop_scale, 1)
		else
			arg0.spineChar.localScale = Vector3(0.9, 0.9, 1)
		end

		arg0.spineChar.localPosition = Vector3(0, 0, 0)

		pg.ViewUtils.SetLayer(arg0.spineChar, Layer.UI)
		setParent(arg0.spineChar, arg0.charContainer)
		arg0:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end)
end

function var0.FlushTimeline(arg0, arg1)
	local var0 = arg1:getSkinId()
	local var1 = false
	local var2

	if arg1:IsActivityExtra() and arg1:ShowMaintenanceTime() then
		local var3, var4 = arg1:GetMaintenanceMonthAndDay()

		function var2()
			return i18n("limit_skin_time_before_maintenance", var3, var4)
		end

		var1 = true
	elseif arg1:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		local var5 = getProxy(ShipSkinProxy):getSkinById(var0)

		var1 = var5 and var5:isExpireType() and not var5:isExpired()

		if var1 then
			function var2()
				return skinTimeStamp(var5:getRemainTime())
			end
		end
	else
		local var6, var7 = pg.TimeMgr.GetInstance():inTime(arg1:getConfig("time"))

		var1 = var7

		if var1 then
			local var8 = pg.TimeMgr.GetInstance():Table2ServerTime(var7)

			function var2()
				return skinCommdityTimeStamp(var8)
			end
		end
	end

	setActive(arg0.timeLimitTr, var1)
	arg0:ClearTimer()

	if var1 then
		arg0:AddTimer(var2)
	end
end

function var0.AddTimer(arg0, arg1)
	arg0.timer = Timer.New(function()
		arg0.timeLimitTxt.text = arg1()
	end, 1, -1)

	arg0.timer.func()
	arg0.timer:Start()
end

function var0.ClearTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.ReturnChar(arg0)
	if not IsNil(arg0.spineChar) then
		arg0.spineChar.gameObject:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefabName, arg0.spineChar.gameObject)

		arg0.spineChar = nil
		arg0.prefabName = nil
	end
end

function var0.ClosePurchaseView(arg0)
	if arg0.purchaseView and arg0.purchaseView:GetLoaded() then
		arg0.purchaseView:Hide()
	end
end

function var0.Dispose(arg0)
	arg0.exited = true

	pg.DelegateInfo.Dispose(arg0)
	arg0:ClearSwitchBgAnim()
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0:getUIName())

	if arg0.voucherMsgBox then
		arg0.voucherMsgBox:Destroy()

		arg0.voucherMsgBox = nil
	end

	if arg0.purchaseView then
		arg0.purchaseView:Destroy()

		arg0.purchaseView = nil
	end

	for iter0, iter1 in pairs(arg0.downloads) do
		iter1:Dispose()
	end

	arg0.downloads = {}

	arg0:ClearPainting()

	for iter2, iter3 in pairs(arg0.obtainBtnSprites) do
		arg0.obtainBtnSprites[iter3] = nil
	end

	arg0.obtainBtnSprites = nil

	if arg0.interactionPreview then
		arg0.interactionPreview:Dispose()

		arg0.interactionPreview = nil
	end

	arg0:ClearSwitchTween()
	arg0:disposeEvent()
	arg0:ClearTimer()
	arg0:ReturnChar()
end

return var0
