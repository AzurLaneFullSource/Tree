local var0_0 = class("AwardInfoLayer", import("..base.BaseUI"))

var0_0.TITLE = {
	COMMANDER = "commander",
	RYZA = "ryza",
	ITEM = "item",
	SHIP = "ship",
	REVERT = "revert",
	ESCORT = "escort"
}

local var1_0 = 0.15
local var2_0 = 340
local var3_0 = 564

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"ui/item_duang5"
	}

	table.insertto(var0_1, var0_0.super.getResource(arg0_1))

	return var0_1
end

function var0_0.getUIName(arg0_2)
	return "AwardInfoUI"
end

function var0_0.init(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)

	arg0_3.awards = _.select(arg0_3.contextData.items or {}, function(arg0_4)
		return arg0_4.type ~= DROP_TYPE_ICON_FRAME and arg0_4.type ~= DROP_TYPE_CHAT_FRAME and arg0_4.type ~= DROP_TYPE_LIVINGAREA_COVER
	end)
	arg0_3._itemsWindow = arg0_3._tf:Find("items")
	arg0_3.spriteMask = arg0_3._itemsWindow:Find("SpriteMask")
	arg0_3.title = arg0_3.contextData.title or var0_0.TITLE.ITEM

	for iter0_3, iter1_3 in pairs(var0_0.TITLE) do
		setActive(arg0_3._itemsWindow:Find("titles/title_" .. iter1_3), arg0_3.title == iter1_3)
	end

	if arg0_3.title == var0_0.TITLE.COMMANDER then
		eachChild(arg0_3._itemsWindow:Find("titles/title_commander"), function(arg0_5)
			setActive(arg0_5, arg0_5.name == arg0_3.contextData.titleExtra)
		end)
	end

	local var0_3 = {
		items_scroll = arg0_3._itemsWindow:Find("items_scroll/content"),
		ships = arg0_3._itemsWindow:Find("ships")
	}

	if arg0_3.title == var0_0.TITLE.SHIP then
		arg0_3.container = var0_3.ships
	else
		arg0_3.container = var0_3.items_scroll

		scrollTo(arg0_3.container, nil, 1)

		arg0_3.windowLayout = arg0_3._itemsWindow:Find("items_scroll"):GetComponent(typeof(LayoutElement))
	end

	GetOrAddComponent(arg0_3.container, "CanvasGroup").alpha = 1

	for iter2_3, iter3_3 in pairs(var0_3) do
		setActive(arg0_3._itemsWindow:Find(iter2_3), arg0_3.container == iter3_3)
	end

	setLocalScale(arg0_3._itemsWindow, Vector3(0.5, 0.5, 0.5))

	arg0_3.itemTpl = arg0_3._itemsWindow:Find("item_tpl")
	arg0_3.shipTpl = arg0_3._itemsWindow:Find("ship_tpl")
	arg0_3.extraBouns = arg0_3._itemsWindow:Find("titles/extra_bouns")

	setActive(arg0_3.extraBouns, arg0_3.contextData.extraBonus)

	arg0_3.continueBtn = arg0_3._tf:Find("items/close")

	local var1_3 = arg0_3._tf:Find("decorations")

	if arg0_3.title == var0_0.TITLE.SHIP then
		setLocalScale(var1_3, Vector3.New(1.25, 1.25, 1))
	else
		setLocalScale(var1_3, Vector3.one)
	end

	arg0_3.blinks = {}
	arg0_3.tweenItems = {}
	arg0_3.shipCardTpl = arg0_3._tf:Find("ShipCardTpl")

	arg0_3._tf:SetAsLastSibling()

	arg0_3.metaRepeatAwardTF = arg0_3._tf:Find("MetaShipRepeatAward")
end

function var0_0.doAnim(arg0_6, arg1_6)
	LeanTween.scale(rtf(arg0_6._itemsWindow), Vector3(1, 1, 1), 0.15):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
		if arg0_6.exited then
			return
		end

		arg1_6()
	end))
end

function var0_0.playAnim(arg0_8, arg1_8)
	local var0_8 = {}

	for iter0_8 = 1, #arg0_8.awards do
		table.insert(var0_8, function(arg0_9)
			setActive(arg0_8.container:GetChild(iter0_8 - 1), true)

			if arg0_8.windowLayout then
				if iter0_8 > 5 and arg0_8.windowLayout.preferredHeight ~= var3_0 then
					arg0_8.windowLayout.preferredHeight = var3_0

					arg0_8:updateSpriteMaskScale()
				end

				if iter0_8 % 5 == 1 then
					scrollTo(arg0_8.container, nil, 0)
				end
			end

			arg0_8.tweeningId = LeanTween.delayedCall(var1_0, System.Action(arg0_9)).uniqueId
		end)
	end

	seriesAsync(var0_8, function()
		arg0_8.tweeningId = nil

		if arg1_8 then
			arg1_8()
		end
	end)
end

function var0_0.didEnter(arg0_11)
	setActive(arg0_11.spriteMask, true)
	onButton(arg0_11, arg0_11._tf, function()
		local function var0_12()
			if arg0_11.tweeningId then
				LeanTween.cancel(arg0_11.tweeningId)

				arg0_11.tweeningId = nil
			end

			arg0_11:emit(var0_0.ON_CLOSE)
		end

		arg0_11:checkPaintingRes(var0_12)
	end, SFX_CANCEL, {
		noShip = not arg0_11.hasShip
	})
	onButton(arg0_11, arg0_11.continueBtn, function()
		triggerButton(arg0_11._tf)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_GETITEM)

	local var0_11 = {}

	table.insert(var0_11, function(arg0_15)
		arg0_11:doAnim(arg0_15)
	end)
	arg0_11:displayAwards()

	if arg0_11.contextData.animation then
		eachChild(arg0_11.container, function(arg0_16)
			setActive(arg0_16, false)
		end)

		GetOrAddComponent(arg0_11.container, "CanvasGroup").alpha = 0

		table.insert(var0_11, function(arg0_17)
			GetOrAddComponent(arg0_11.container, "CanvasGroup").alpha = 1

			arg0_11:playAnim(arg0_17)
		end)
	end

	if arg0_11.windowLayout then
		arg0_11.windowLayout.preferredHeight = not arg0_11.contextData.animation and #arg0_11.awards > 5 and var3_0 or var2_0

		arg0_11:updateSpriteMaskScale()
	end

	seriesAsync(var0_11, function()
		if arg0_11.exited then
			return
		end

		if arg0_11.contextData.closeOnCompleted then
			triggerButton(arg0_11._tf)
		end

		if arg0_11.enterCallback then
			arg0_11.enterCallback()

			arg0_11.enterCallback = nil
		end
	end)

	if arg0_11.contextData.auto then
		arg0_11:AddCloseTimer()
	end
end

function var0_0.RemoveCloseTimer(arg0_19)
	if arg0_19.closeTimer then
		arg0_19.closeTimer:Stop()

		arg0_19.closeTimer = nil
	end
end

function var0_0.AddCloseTimer(arg0_20)
	arg0_20:RemoveCloseTimer()

	arg0_20.closeTimer = Timer.New(function()
		arg0_20:RemoveCloseTimer()
		triggerButton(arg0_20._tf)
	end, arg0_20.contextData.auto or 2, 1)

	arg0_20.closeTimer:Start()
end

function var0_0.onUIAnimEnd(arg0_22, arg1_22)
	arg0_22.enterCallback = arg1_22
end

function var0_0.onBackPressed(arg0_23)
	if LeanTween.isTweening(go(arg0_23._itemsWindow)) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_23._tf)
end

local function var4_0(arg0_24, arg1_24)
	local var0_24 = pg.ship_data_statistics[arg1_24.id]
	local var1_24 = Ship.New({
		configId = arg1_24.id
	})

	var1_24.virgin = arg1_24.virgin

	setScrollText(findTF(arg0_24, "content/info/name_mask/name"), var1_24:GetColorName())
	flushShipCard(arg0_24, var1_24)

	local var2_24 = findTF(arg0_24, "content/front/new")

	setActive(var2_24, arg1_24.virgin)
end

function var0_0.displayAwards(arg0_25)
	assert(#arg0_25.awards ~= 0, "items数量不能为0")
	removeAllChildren(arg0_25.container)

	for iter0_25 = 1, #arg0_25.awards do
		if arg0_25.title ~= var0_0.TITLE.SHIP then
			cloneTplTo(arg0_25.itemTpl, arg0_25.container)
		else
			local var0_25 = cloneTplTo(arg0_25.shipTpl, arg0_25.container)

			setActive(cloneTplTo(arg0_25.shipCardTpl, var0_25, "ship_tpl"), true)
		end
	end

	if arg0_25.title ~= var0_0.TITLE.SHIP then
		for iter1_25 = 1, #arg0_25.awards do
			local var1_25 = arg0_25.container:GetChild(iter1_25 - 1):Find("bg")
			local var2_25 = arg0_25.awards[iter1_25]

			if var2_25.type == DROP_TYPE_SHIP then
				arg0_25.hasShip = true
			end

			updateDrop(var1_25, var2_25, {
				fromAwardLayer = true
			})
			setActive(findTF(var1_25, "icon_bg/bonus"), var2_25.riraty)
			setActive(findTF(var1_25, "icon_bg/bonus_catchup"), var2_25.catchupTag)
			setActive(findTF(var1_25, "icon_bg/bonus_event"), var2_25.catchupActTag)

			local var3_25 = findTF(var1_25, "name")
			local var4_25 = findTF(var1_25, "name_mask")

			setActive(var3_25, false)
			setActive(var4_25, true)
			setScrollText(findTF(var1_25, "name_mask/name"), var2_25.name or getText(var3_25))
			onButton(arg0_25, var1_25, function()
				if arg0_25.tweeningId then
					return
				end

				arg0_25:emit(AwardInfoMediator.ON_DROP, var2_25)
			end, SFX_PANEL)
		end
	else
		for iter2_25 = 1, #arg0_25.awards do
			local var5_25 = arg0_25.container:GetChild(iter2_25 - 1):Find("ship_tpl")
			local var6_25 = arg0_25.awards[iter2_25]

			var4_0(var5_25, var6_25)

			local var7_25 = var6_25.reMetaSpecialItemVO

			if var7_25 then
				local var8_25 = cloneTplTo(arg0_25.metaRepeatAwardTF, var5_25)

				setLocalPosition(var8_25, Vector3.zero)
				setLocalScale(var8_25, Vector3.zero)

				local var9_25 = var8_25:Find("item_tpl/bg")

				updateDrop(var9_25, var7_25)
				setActive(var9_25:Find("name"), false)
				setActive(var9_25:Find("name_mask"), true)
				var9_25:Find("name_mask/name"):GetComponent("ScrollText"):SetText(var7_25.cfg.name)

				local function var10_25()
					arg0_25:managedTween(LeanTween.value, nil, go(var8_25), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_28)
						setLocalScale(var8_25, {
							x = arg0_28,
							y = arg0_28
						})
					end)):setOnComplete(System.Action(function()
						setLocalScale(var8_25, Vector3.one)
					end))
				end

				arg0_25:managedTween(LeanTween.delayedCall, var10_25, 0.3, nil)
			end

			if #arg0_25.awards > 5 then
				if iter2_25 <= 5 then
					var5_25.anchoredPosition = Vector2.New(-50, 0)
				else
					var5_25.anchoredPosition = Vector2.New(50, 0)
				end
			end
		end
	end
end

function var0_0.ShowOrHideSpriteMask(arg0_30, arg1_30)
	if isActive(arg0_30.spriteMask) == arg1_30 then
		return
	end

	setActive(arg0_30.spriteMask, arg1_30)
end

function var0_0.willExit(arg0_31)
	arg0_31:RemoveCloseTimer()
	setActive(arg0_31.spriteMask, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_31._tf)

	if arg0_31.title ~= var0_0.TITLE.SHIP then
		for iter0_31 = 0, arg0_31.container.childCount - 1 do
			clearDrop(arg0_31.container:GetChild(iter0_31):Find("bg"))
		end
	end

	if arg0_31.blinks and #arg0_31.blinks > 0 then
		for iter1_31, iter2_31 in pairs(arg0_31.blinks) do
			if not IsNil(iter2_31) then
				Destroy(iter2_31)
			end
		end
	end

	if arg0_31.contextData.removeFunc then
		arg0_31.contextData.removeFunc()

		arg0_31.contextData.removeFunc = nil
	end
end

function var0_0.updateSpriteMaskScale(arg0_32)
	onNextTick(function()
		if arg0_32.exited then
			return
		end

		setLocalScale(arg0_32.spriteMask, Vector3(arg0_32.spriteMask.rect.width / WHITE_DOT_SIZE * PIXEL_PER_UNIT, arg0_32.spriteMask.rect.height / WHITE_DOT_SIZE * PIXEL_PER_UNIT, 1))
	end)
end

function var0_0.checkPaintingRes(arg0_34, arg1_34)
	local var0_34 = PaintingGroupConst.GetPaintingNameListForAwardList(arg0_34.awards)
	local var1_34 = {
		isShowBox = false,
		paintingNameList = var0_34,
		finishFunc = arg1_34
	}

	PaintingGroupConst.PaintingDownload(var1_34)
end

return var0_0
