local var0_0 = class("PlayerVitaeShipCard", import(".PlayerVitaeBaseCard"))

function var0_0.OnInit(arg0_1)
	arg0_1.bgImage = arg0_1._tf:Find("bg"):GetComponent(typeof(Image))
	arg0_1.paintingTr = arg0_1._tf:Find("ship_icon/painting")
	arg0_1.detailTF = arg0_1._tf:Find("detail")
	arg0_1.lvTxtTF = arg0_1.detailTF:Find("top/level")
	arg0_1.lvTxt = arg0_1.lvTxtTF:GetComponent(typeof(Text))
	arg0_1.shipType = arg0_1.detailTF:Find("top/type")
	arg0_1.propsTr = arg0_1.detailTF:Find("info")
	arg0_1.nameTxt = arg0_1.detailTF:Find("name_mask/name")
	arg0_1.frame = arg0_1._tf:Find("front/frame")
	arg0_1.UIlist = UIItemList.New(arg0_1._tf:Find("front/stars"), arg0_1._tf:Find("front/stars/star_tpl"))
	arg0_1.shipState = arg0_1._tf:Find("front/flag")
	arg0_1.proposeMark = arg0_1._tf:Find("front/propose")
	arg0_1.otherBg = arg0_1._tf:Find("front/bg_other")
	arg0_1.editTr = arg0_1._tf:Find("mask")
	arg0_1.changskinBtn = arg0_1.editTr:Find("skin")
	arg0_1.changskinBtnTag = arg0_1.changskinBtn:Find("Tag")
	arg0_1.randomTr = arg0_1._tf:Find("mask1")
	arg0_1.randomSkinBtn = arg0_1.randomTr:Find("random_skin")
	arg0_1.randomShipBtn = arg0_1.randomTr:Find("random_ship")
	arg0_1.tipTime = 0
	arg0_1.nativeTr = arg0_1._tf:Find("mask_2")

	local var0_1 = arg0_1.editTr:Find("tpl")

	eachChild(arg0_1.editTr, function(arg0_2)
		if string.find(arg0_2.gameObject.name, "tpl") and arg0_2 ~= var0_1 then
			Object.Destroy(arg0_2.gameObject)
		end
	end)

	arg0_1.btns = {
		PlayerVitaeSpineBtn.New(var0_1, PlayerVitaeBaseBtn.VEC_TYPE),
		PlayerVitaeBGBtn.New(var0_1, PlayerVitaeBaseBtn.VEC_TYPE),
		PlayerVitaeLive2dBtn.New(var0_1, PlayerVitaeBaseBtn.VEC_TYPE)
	}

	onButton(arg0_1, arg0_1.changskinBtn, function()
		arg0_1:emit(PlayerVitaeMediator.CHANGE_SKIN, arg0_1.displayShip)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1._tf, function()
		if arg0_1.inEdit then
			return
		end

		if not arg0_1.canClick then
			if arg0_1:ShouldTip() then
				arg0_1:SetNextTipTime()
				pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_forbidden"))
			end

			return
		end

		arg0_1:emit(PlayerVitaeMediator.CHANGE_PAINT, arg0_1.displayShip)
	end, SFX_PANEL)

	arg0_1.eventTrigger = GetOrAddComponent(arg0_1._go, typeof(EventTriggerListener))

	arg0_1:RegisterEvent()
	setText(arg0_1.randomSkinBtn:Find("Text"), i18n("random_ship_skin_label"))
	setText(arg0_1.randomShipBtn:Find("Text"), i18n("random_ship_label"))
	setText(arg0_1.changskinBtn:Find("Text"), i18n("random_flag_ship_changskinBtn_label"))

	arg0_1.canDragFlag = true
end

function var0_0.DisableDrag(arg0_5)
	arg0_5.canDragFlag = false
end

function var0_0.EnableDrag(arg0_6)
	arg0_6.canDragFlag = true
end

function var0_0.CanDrag(arg0_7)
	return not arg0_7.inEdit and arg0_7.canDragFlag
end

function var0_0.ShouldTip(arg0_8)
	return arg0_8.tipTime <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.SetNextTipTime(arg0_9)
	arg0_9.tipTime = pg.TimeMgr.GetInstance():GetServerTime() + 3
end

function var0_0.RegisterEvent(arg0_10)
	local var0_10 = arg0_10.eventTrigger
	local var1_10 = PlayerVitaeShipsPage.GetSlotMaxCnt()

	var0_10:AddBeginDragFunc(function()
		if not arg0_10:CanDrag() then
			return
		end

		if not arg0_10.canClick then
			if arg0_10:ShouldTip() then
				arg0_10:SetNextTipTime()
				pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_forbidden"))
			end

			return
		end

		LeanTween.scale(arg0_10.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		arg0_10._tf:SetSiblingIndex(var1_10 - 1)
		arg0_10:emit(PlayerVitaeShipsPage.ON_BEGIN_DRAG_CARD, arg0_10.slotIndex)
		setButtonEnabled(arg0_10._tf, false)
	end)
	var0_10:AddDragFunc(function(arg0_12, arg1_12)
		if not arg0_10:CanDrag() then
			return
		end

		if not arg0_10.canClick then
			return
		end

		local var0_12 = arg0_10:Change2RectPos(arg0_10._tf.parent, arg1_12.position)

		arg0_10._tf.localPosition = Vector3(var0_12.x, arg0_10._tf.localPosition.y, 0)

		arg0_10:emit(PlayerVitaeShipsPage.ON_DRAGING_CARD, var0_12)
	end)
	var0_10:AddDragEndFunc(function(arg0_13, arg1_13)
		if not arg0_10:CanDrag() then
			return
		end

		if not arg0_10.canClick then
			return
		end

		LeanTween.scale(arg0_10.paintingTr, Vector3(1, 1, 0), 0.3)
		arg0_10:emit(PlayerVitaeShipsPage.ON_DRAG_END_CARD)
		setButtonEnabled(arg0_10._tf, true)
	end)
end

function var0_0.Change2RectPos(arg0_14, arg1_14, arg2_14)
	local var0_14 = GameObject.Find("OverlayCamera"):GetComponent("Camera")

	return (LuaHelper.ScreenToLocal(arg1_14, arg2_14, var0_14))
end

function var0_0.OnUpdate(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15, arg5_15)
	arg0_15.canClick = arg4_15 ~= PlayerVitaeShipsPage.RANDOM_FLAG_SHIP_PAGE
	arg0_15.slotIndex = arg1_15
	arg0_15.typeIndex = arg2_15
	arg0_15.shipIds = arg3_15
	arg0_15.pageType = arg4_15
	arg0_15.native = arg5_15

	local var0_15 = arg3_15[arg2_15]
	local var1_15 = getProxy(BayProxy):RawGetShipById(var0_15)

	if not arg0_15.displayShip or arg0_15.displayShip.skinId ~= var1_15.skinId or arg0_15.displayShip.id ~= var1_15.id then
		arg0_15:UpdateShip(var1_15)
	end

	local var2_15 = not HXSet.isHxSkin() and getProxy(ShipSkinProxy):HasFashion(var1_15)

	setActive(arg0_15.changskinBtn, var2_15)
	setActive(arg0_15.nativeTr, arg0_15.canClick and arg0_15.native)

	if var2_15 then
		arg0_15:updatePaintingTag(var1_15)
	end
end

function var0_0.Refresh(arg0_16)
	arg0_16:OnUpdate(arg0_16.slotIndex, arg0_16.typeIndex, arg0_16.shipIds, arg0_16.pageType, arg0_16.native)

	if isActive(arg0_16.editTr) then
		arg0_16:UpdateBtns()
	end
end

function var0_0.UpdateShip(arg0_17, arg1_17)
	arg0_17.displayShip = arg1_17
	arg0_17.lvTxt.text = "Lv." .. arg1_17.level

	local var0_17 = arg1_17:getMaxStar()
	local var1_17 = arg1_17:getStar()

	arg0_17.UIlist:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			setActive(arg2_18:Find("star"), arg1_18 < var1_17)
		end
	end)
	arg0_17.UIlist:align(var0_17)
	setScrollText(arg0_17.nameTxt, arg1_17:GetColorName())
	setPaintingPrefabAsync(arg0_17.paintingTr, arg1_17:getPainting(), "biandui")

	local var2_17 = arg1_17:rarity2bgPrint()

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var2_17, "", arg0_17.bgImage)

	local var3_17 = arg1_17:getShipType()

	setImageSprite(arg0_17.shipType, GetSpriteFromAtlas("shiptype", shipType2print(var3_17)))

	local var4_17, var5_17 = arg1_17:GetFrameAndEffect(true)

	setRectShipCardFrame(arg0_17.frame, var2_17, var4_17)
	setFrameEffect(arg0_17.otherBg, var5_17)
	setProposeMarkIcon(arg0_17.proposeMark, arg1_17)
	arg0_17:UpdateProps(arg1_17)
end

function var0_0.updatePaintingTag(arg0_19)
	local var0_19 = arg0_19.displayShip

	if var0_19 then
		setActive(arg0_19.changskinBtnTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0_19) > 0)
	end
end

function var0_0.UpdateProps(arg0_20, arg1_20)
	local var0_20 = arg1_20:getShipCombatPower()
	local var1_20, var2_20 = arg1_20:getIntimacyDetail()
	local var3_20 = {
		{
			i18n("word_lv"),
			arg1_20.level
		},
		{
			i18n("attribute_intimacy"),
			var2_20
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. var0_20 .. "</color>"
		}
	}

	for iter0_20 = 0, 2 do
		local var4_20 = arg0_20.propsTr:GetChild(iter0_20)

		if iter0_20 < #var3_20 then
			var4_20.gameObject:SetActive(true)

			var4_20:GetChild(0):GetComponent("Text").text = var3_20[iter0_20 + 1][1]
			var4_20:GetChild(1):GetComponent("Text").text = var3_20[iter0_20 + 1][2]
		else
			var4_20.gameObject:SetActive(false)
		end
	end
end

function var0_0.EditCard(arg0_21, arg1_21)
	if not arg0_21.displayShip then
		return
	end

	setActive(arg0_21.editTr, arg1_21)
	arg0_21:UpdateBtns()

	arg0_21.inEdit = arg1_21

	setActive(arg0_21.nativeTr, arg0_21.canClick and arg0_21.native and not arg0_21.inEdit)
end

function var0_0.UpdateBtns(arg0_22)
	local var0_22 = arg0_22.displayShip
	local var1_22 = 0

	for iter0_22, iter1_22 in ipairs(arg0_22.btns) do
		local var2_22 = iter1_22:IsActive(var0_22)

		if var2_22 then
			var1_22 = var1_22 + 1
		end

		iter1_22:Update(var2_22, var1_22, var0_22)
	end
end

function var0_0.EditCardForRandom(arg0_23, arg1_23)
	if not arg0_23.displayShip then
		return
	end

	setActive(arg0_23.randomTr, arg1_23)

	if arg1_23 then
		arg0_23:UpdateRandomBtns()
	else
		removeOnButton(arg0_23.randomSkinBtn)
		removeOnButton(arg0_23.randomShipBtn)
		arg0_23:ClearRandomFlagValue()
	end

	arg0_23.inEdit = arg1_23
	arg0_23.inRandomEdit = arg1_23
end

local function var1_0(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg1_24:Find("on")
	local var1_24 = arg1_24:Find("off")

	onButton(arg0_24, arg1_24, function()
		arg2_24 = not arg2_24

		setActive(var0_24, arg2_24)
		setActive(var1_24, not arg2_24)
		arg3_24(arg2_24)
	end, SFX_PANEL)
	setActive(var0_24, arg2_24)
	setActive(var1_24, not arg2_24)
end

function var0_0.UpdateRandomBtns(arg0_26)
	local function var0_26(arg0_27, arg1_27)
		return (arg0_27 and 1 or 0) + (arg1_27 and 2 or 0)
	end

	local var1_26 = arg0_26.slotIndex or 1
	local var2_26 = getProxy(PlayerProxy):getRawData()
	local var3_26 = var2_26:IsOpenRandomFlagShipSkinInPos(var1_26)
	local var4_26 = var2_26:IsOpenRandomFlagShipInPos(var1_26)

	var1_0(arg0_26, arg0_26.randomSkinBtn, var3_26, function(arg0_28)
		var3_26 = arg0_28
		arg0_26.randomFlagValue = var0_26(var3_26, var4_26)
	end)
	var1_0(arg0_26, arg0_26.randomShipBtn, var4_26, function(arg0_29)
		var4_26 = arg0_29
		arg0_26.randomFlagValue = var0_26(var3_26, var4_26)
	end)

	arg0_26.randomFlagValue = var0_26(var3_26, var4_26)

	setActive(arg0_26.randomShipBtn, var2_26:CanRandomFlagShipInPos(var1_26))
end

function var0_0.GetRandomFlagValue(arg0_30)
	assert(arg0_30.inRandomEdit)

	if arg0_30.randomFlagValue then
		return arg0_30.randomFlagValue
	else
		return getProxy(PlayerProxy):getRawData():RawGetRandomShipAndSkinValueInpos(arg0_30.slotIndex)
	end
end

function var0_0.ClearRandomFlagValue(arg0_31)
	arg0_31.randomFlagValue = nil
end

function var0_0.Disable(arg0_32)
	var0_0.super.Disable(arg0_32)

	arg0_32.inEdit = false
	arg0_32.inRandomEdit = false
end

function var0_0.OnDispose(arg0_33)
	local var0_33 = arg0_33.displayShip

	if var0_33 then
		retPaintingPrefab(arg0_33.paintingTr, var0_33:getPainting())
	end

	ClearEventTrigger(arg0_33.eventTrigger)

	for iter0_33, iter1_33 in ipairs(arg0_33.btns) do
		iter1_33:Dispose()
	end

	arg0_33.btns = nil

	arg0_33:Disable()
end

return var0_0
