local var0 = class("PlayerVitaeShipCard", import(".PlayerVitaeBaseCard"))

function var0.OnInit(arg0)
	arg0.bgImage = arg0._tf:Find("bg"):GetComponent(typeof(Image))
	arg0.paintingTr = arg0._tf:Find("ship_icon/painting")
	arg0.detailTF = arg0._tf:Find("detail")
	arg0.lvTxtTF = arg0.detailTF:Find("top/level")
	arg0.lvTxt = arg0.lvTxtTF:GetComponent(typeof(Text))
	arg0.shipType = arg0.detailTF:Find("top/type")
	arg0.propsTr = arg0.detailTF:Find("info")
	arg0.nameTxt = arg0.detailTF:Find("name_mask/name")
	arg0.frame = arg0._tf:Find("front/frame")
	arg0.UIlist = UIItemList.New(arg0._tf:Find("front/stars"), arg0._tf:Find("front/stars/star_tpl"))
	arg0.shipState = arg0._tf:Find("front/flag")
	arg0.proposeMark = arg0._tf:Find("front/propose")
	arg0.otherBg = arg0._tf:Find("front/bg_other")
	arg0.editTr = arg0._tf:Find("mask")
	arg0.changskinBtn = arg0.editTr:Find("skin")
	arg0.changskinBtnTag = arg0.changskinBtn:Find("Tag")
	arg0.randomTr = arg0._tf:Find("mask1")
	arg0.randomSkinBtn = arg0.randomTr:Find("random_skin")
	arg0.randomShipBtn = arg0.randomTr:Find("random_ship")
	arg0.tipTime = 0
	arg0.nativeTr = arg0._tf:Find("mask_2")

	local var0 = arg0.editTr:Find("tpl")

	eachChild(arg0.editTr, function(arg0)
		if string.find(arg0.gameObject.name, "tpl") and arg0 ~= var0 then
			Object.Destroy(arg0.gameObject)
		end
	end)

	arg0.btns = {
		PlayerVitaeSpineBtn.New(var0, PlayerVitaeBaseBtn.VEC_TYPE),
		PlayerVitaeBGBtn.New(var0, PlayerVitaeBaseBtn.VEC_TYPE),
		PlayerVitaeLive2dBtn.New(var0, PlayerVitaeBaseBtn.VEC_TYPE)
	}

	onButton(arg0, arg0.changskinBtn, function()
		arg0:emit(PlayerVitaeMediator.CHANGE_SKIN, arg0.displayShip)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		if arg0.inEdit then
			return
		end

		if not arg0.canClick then
			if arg0:ShouldTip() then
				arg0:SetNextTipTime()
				pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_forbidden"))
			end

			return
		end

		arg0:emit(PlayerVitaeMediator.CHANGE_PAINT, arg0.displayShip)
	end, SFX_PANEL)

	arg0.eventTrigger = GetOrAddComponent(arg0._go, typeof(EventTriggerListener))

	arg0:RegisterEvent()
	setText(arg0.randomSkinBtn:Find("Text"), i18n("random_ship_skin_label"))
	setText(arg0.randomShipBtn:Find("Text"), i18n("random_ship_label"))
	setText(arg0.changskinBtn:Find("Text"), i18n("random_flag_ship_changskinBtn_label"))

	arg0.canDragFlag = true
end

function var0.DisableDrag(arg0)
	arg0.canDragFlag = false
end

function var0.EnableDrag(arg0)
	arg0.canDragFlag = true
end

function var0.CanDrag(arg0)
	return not arg0.inEdit and arg0.canDragFlag
end

function var0.ShouldTip(arg0)
	return arg0.tipTime <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.SetNextTipTime(arg0)
	arg0.tipTime = pg.TimeMgr.GetInstance():GetServerTime() + 3
end

function var0.RegisterEvent(arg0)
	local var0 = arg0.eventTrigger
	local var1 = PlayerVitaeShipsPage.GetSlotMaxCnt()

	var0:AddBeginDragFunc(function()
		if not arg0:CanDrag() then
			return
		end

		if not arg0.canClick then
			if arg0:ShouldTip() then
				arg0:SetNextTipTime()
				pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_forbidden"))
			end

			return
		end

		LeanTween.scale(arg0.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		arg0._tf:SetSiblingIndex(var1 - 1)
		arg0:emit(PlayerVitaeShipsPage.ON_BEGIN_DRAG_CARD, arg0.slotIndex)
		setButtonEnabled(arg0._tf, false)
	end)
	var0:AddDragFunc(function(arg0, arg1)
		if not arg0:CanDrag() then
			return
		end

		if not arg0.canClick then
			return
		end

		local var0 = arg0:Change2RectPos(arg0._tf.parent, arg1.position)

		arg0._tf.localPosition = Vector3(var0.x, arg0._tf.localPosition.y, 0)

		arg0:emit(PlayerVitaeShipsPage.ON_DRAGING_CARD, var0)
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if not arg0:CanDrag() then
			return
		end

		if not arg0.canClick then
			return
		end

		LeanTween.scale(arg0.paintingTr, Vector3(1, 1, 0), 0.3)
		arg0:emit(PlayerVitaeShipsPage.ON_DRAG_END_CARD)
		setButtonEnabled(arg0._tf, true)
	end)
end

function var0.Change2RectPos(arg0, arg1, arg2)
	local var0 = GameObject.Find("OverlayCamera"):GetComponent("Camera")

	return (LuaHelper.ScreenToLocal(arg1, arg2, var0))
end

function var0.OnUpdate(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.canClick = arg4 ~= PlayerVitaeShipsPage.RANDOM_FLAG_SHIP_PAGE
	arg0.slotIndex = arg1
	arg0.typeIndex = arg2
	arg0.shipIds = arg3
	arg0.pageType = arg4
	arg0.native = arg5

	local var0 = arg3[arg2]
	local var1 = getProxy(BayProxy):RawGetShipById(var0)

	if not arg0.displayShip or arg0.displayShip.skinId ~= var1.skinId or arg0.displayShip.id ~= var1.id then
		arg0:UpdateShip(var1)
	end

	local var2 = not HXSet.isHxSkin() and getProxy(ShipSkinProxy):HasFashion(var1)

	setActive(arg0.changskinBtn, var2)
	setActive(arg0.nativeTr, arg0.canClick and arg0.native)

	if var2 then
		arg0:updatePaintingTag(var1)
	end
end

function var0.Refresh(arg0)
	arg0:OnUpdate(arg0.slotIndex, arg0.typeIndex, arg0.shipIds, arg0.pageType, arg0.native)

	if isActive(arg0.editTr) then
		arg0:UpdateBtns()
	end
end

function var0.UpdateShip(arg0, arg1)
	arg0.displayShip = arg1
	arg0.lvTxt.text = "Lv." .. arg1.level

	local var0 = arg1:getMaxStar()
	local var1 = arg1:getStar()

	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("star"), arg1 < var1)
		end
	end)
	arg0.UIlist:align(var0)
	setScrollText(arg0.nameTxt, arg1:GetColorName())
	setPaintingPrefabAsync(arg0.paintingTr, arg1:getPainting(), "biandui")

	local var2 = arg1:rarity2bgPrint()

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var2, "", arg0.bgImage)

	local var3 = arg1:getShipType()

	setImageSprite(arg0.shipType, GetSpriteFromAtlas("shiptype", shipType2print(var3)))

	local var4, var5 = arg1:GetFrameAndEffect(true)

	setRectShipCardFrame(arg0.frame, var2, var4)
	setFrameEffect(arg0.otherBg, var5)
	setProposeMarkIcon(arg0.proposeMark, arg1)
	arg0:UpdateProps(arg1)
end

function var0.updatePaintingTag(arg0)
	local var0 = arg0.displayShip

	if var0 then
		setActive(arg0.changskinBtnTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0) > 0)
	end
end

function var0.UpdateProps(arg0, arg1)
	local var0 = arg1:getShipCombatPower()
	local var1, var2 = arg1:getIntimacyDetail()
	local var3 = {
		{
			i18n("word_lv"),
			arg1.level
		},
		{
			i18n("attribute_intimacy"),
			var2
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. var0 .. "</color>"
		}
	}

	for iter0 = 0, 2 do
		local var4 = arg0.propsTr:GetChild(iter0)

		if iter0 < #var3 then
			var4.gameObject:SetActive(true)

			var4:GetChild(0):GetComponent("Text").text = var3[iter0 + 1][1]
			var4:GetChild(1):GetComponent("Text").text = var3[iter0 + 1][2]
		else
			var4.gameObject:SetActive(false)
		end
	end
end

function var0.EditCard(arg0, arg1)
	if not arg0.displayShip then
		return
	end

	setActive(arg0.editTr, arg1)
	arg0:UpdateBtns()

	arg0.inEdit = arg1

	setActive(arg0.nativeTr, arg0.canClick and arg0.native and not arg0.inEdit)
end

function var0.UpdateBtns(arg0)
	local var0 = arg0.displayShip
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.btns) do
		local var2 = iter1:IsActive(var0)

		if var2 then
			var1 = var1 + 1
		end

		iter1:Update(var2, var1, var0)
	end
end

function var0.EditCardForRandom(arg0, arg1)
	if not arg0.displayShip then
		return
	end

	setActive(arg0.randomTr, arg1)

	if arg1 then
		arg0:UpdateRandomBtns()
	else
		removeOnButton(arg0.randomSkinBtn)
		removeOnButton(arg0.randomShipBtn)
		arg0:ClearRandomFlagValue()
	end

	arg0.inEdit = arg1
	arg0.inRandomEdit = arg1
end

local function var1(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("on")
	local var1 = arg1:Find("off")

	onButton(arg0, arg1, function()
		arg2 = not arg2

		setActive(var0, arg2)
		setActive(var1, not arg2)
		arg3(arg2)
	end, SFX_PANEL)
	setActive(var0, arg2)
	setActive(var1, not arg2)
end

function var0.UpdateRandomBtns(arg0)
	local function var0(arg0, arg1)
		return (arg0 and 1 or 0) + (arg1 and 2 or 0)
	end

	local var1 = arg0.slotIndex or 1
	local var2 = getProxy(PlayerProxy):getRawData()
	local var3 = var2:IsOpenRandomFlagShipSkinInPos(var1)
	local var4 = var2:IsOpenRandomFlagShipInPos(var1)

	var1(arg0, arg0.randomSkinBtn, var3, function(arg0)
		var3 = arg0
		arg0.randomFlagValue = var0(var3, var4)
	end)
	var1(arg0, arg0.randomShipBtn, var4, function(arg0)
		var4 = arg0
		arg0.randomFlagValue = var0(var3, var4)
	end)

	arg0.randomFlagValue = var0(var3, var4)

	setActive(arg0.randomShipBtn, var2:CanRandomFlagShipInPos(var1))
end

function var0.GetRandomFlagValue(arg0)
	assert(arg0.inRandomEdit)

	if arg0.randomFlagValue then
		return arg0.randomFlagValue
	else
		return getProxy(PlayerProxy):getRawData():RawGetRandomShipAndSkinValueInpos(arg0.slotIndex)
	end
end

function var0.ClearRandomFlagValue(arg0)
	arg0.randomFlagValue = nil
end

function var0.Disable(arg0)
	var0.super.Disable(arg0)

	arg0.inEdit = false
	arg0.inRandomEdit = false
end

function var0.OnDispose(arg0)
	local var0 = arg0.displayShip

	if var0 then
		retPaintingPrefab(arg0.paintingTr, var0:getPainting())
	end

	ClearEventTrigger(arg0.eventTrigger)

	for iter0, iter1 in ipairs(arg0.btns) do
		iter1:Dispose()
	end

	arg0.btns = nil

	arg0:Disable()
end

return var0
