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

function var0_0.getUIName(arg0_1)
	return "AwardInfoUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0_2.awards = _.select(arg0_2.contextData.items or {}, function(arg0_3)
		return arg0_3.type ~= DROP_TYPE_ICON_FRAME and arg0_3.type ~= DROP_TYPE_CHAT_FRAME and arg0_3.type ~= DROP_TYPE_LIVINGAREA_COVER
	end)
	arg0_2._itemsWindow = arg0_2._tf:Find("items")
	arg0_2.spriteMask = arg0_2._itemsWindow:Find("SpriteMask")
	arg0_2.title = arg0_2.contextData.title or var0_0.TITLE.ITEM

	for iter0_2, iter1_2 in pairs(var0_0.TITLE) do
		setActive(arg0_2._itemsWindow:Find("titles/title_" .. iter1_2), arg0_2.title == iter1_2)
	end

	if arg0_2.title == var0_0.TITLE.COMMANDER then
		eachChild(arg0_2._itemsWindow:Find("titles/title_commander"), function(arg0_4)
			setActive(arg0_4, arg0_4.name == arg0_2.contextData.titleExtra)
		end)
	end

	local var0_2 = {
		items_scroll = arg0_2._itemsWindow:Find("items_scroll/content"),
		ships = arg0_2._itemsWindow:Find("ships")
	}

	if arg0_2.title == var0_0.TITLE.SHIP then
		arg0_2.container = var0_2.ships
	else
		arg0_2.container = var0_2.items_scroll

		scrollTo(arg0_2.container, nil, 1)

		arg0_2.windowLayout = arg0_2._itemsWindow:Find("items_scroll"):GetComponent(typeof(LayoutElement))
	end

	GetOrAddComponent(arg0_2.container, "CanvasGroup").alpha = 1

	for iter2_2, iter3_2 in pairs(var0_2) do
		setActive(arg0_2._itemsWindow:Find(iter2_2), arg0_2.container == iter3_2)
	end

	setLocalScale(arg0_2._itemsWindow, Vector3(0.5, 0.5, 0.5))

	arg0_2.itemTpl = arg0_2._itemsWindow:Find("item_tpl")
	arg0_2.shipTpl = arg0_2._itemsWindow:Find("ship_tpl")
	arg0_2.extraBouns = arg0_2._itemsWindow:Find("titles/extra_bouns")

	setActive(arg0_2.extraBouns, arg0_2.contextData.extraBonus)

	arg0_2.continueBtn = arg0_2:findTF("items/close")

	local var1_2 = arg0_2._tf:Find("decorations")

	if arg0_2.title == var0_0.TITLE.SHIP then
		setLocalScale(var1_2, Vector3.New(1.25, 1.25, 1))
	else
		setLocalScale(var1_2, Vector3.one)
	end

	arg0_2.blinks = {}
	arg0_2.tweenItems = {}
	arg0_2.shipCardTpl = arg0_2._tf:GetComponent("ItemList").prefabItem[0]

	arg0_2._tf:SetAsLastSibling()

	arg0_2.metaRepeatAwardTF = arg0_2:findTF("MetaShipRepeatAward")
end

function var0_0.doAnim(arg0_5, arg1_5)
	LeanTween.scale(rtf(arg0_5._itemsWindow), Vector3(1, 1, 1), 0.15):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
		if arg0_5.exited then
			return
		end

		arg1_5()
	end))
end

function var0_0.playAnim(arg0_7, arg1_7)
	local var0_7 = {}

	for iter0_7 = 1, #arg0_7.awards do
		table.insert(var0_7, function(arg0_8)
			setActive(arg0_7.container:GetChild(iter0_7 - 1), true)

			if arg0_7.windowLayout then
				if iter0_7 > 5 and arg0_7.windowLayout.preferredHeight ~= var3_0 then
					arg0_7.windowLayout.preferredHeight = var3_0

					arg0_7:updateSpriteMaskScale()
				end

				if iter0_7 % 5 == 1 then
					scrollTo(arg0_7.container, nil, 0)
				end
			end

			arg0_7.tweeningId = LeanTween.delayedCall(var1_0, System.Action(arg0_8)).uniqueId
		end)
	end

	seriesAsync(var0_7, function()
		arg0_7.tweeningId = nil

		if arg1_7 then
			arg1_7()
		end
	end)
end

function var0_0.didEnter(arg0_10)
	setActive(arg0_10.spriteMask, true)
	onButton(arg0_10, arg0_10._tf, function()
		local function var0_11()
			if arg0_10.tweeningId then
				LeanTween.cancel(arg0_10.tweeningId)

				arg0_10.tweeningId = nil
			end

			arg0_10:emit(var0_0.ON_CLOSE)
		end

		arg0_10:checkPaintingRes(var0_11)
	end, SFX_CANCEL, {
		noShip = not arg0_10.hasShip
	})
	onButton(arg0_10, arg0_10.continueBtn, function()
		triggerButton(arg0_10._tf)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_GETITEM)

	local var0_10 = {}

	table.insert(var0_10, function(arg0_14)
		arg0_10:doAnim(arg0_14)
	end)
	arg0_10:displayAwards()

	if arg0_10.contextData.animation then
		eachChild(arg0_10.container, function(arg0_15)
			setActive(arg0_15, false)
		end)

		GetOrAddComponent(arg0_10.container, "CanvasGroup").alpha = 0

		table.insert(var0_10, function(arg0_16)
			GetOrAddComponent(arg0_10.container, "CanvasGroup").alpha = 1

			arg0_10:playAnim(arg0_16)
		end)
	end

	if arg0_10.windowLayout then
		arg0_10.windowLayout.preferredHeight = not arg0_10.contextData.animation and #arg0_10.awards > 5 and var3_0 or var2_0

		arg0_10:updateSpriteMaskScale()
	end

	seriesAsync(var0_10, function()
		if arg0_10.exited then
			return
		end

		if arg0_10.contextData.closeOnCompleted then
			triggerButton(arg0_10._tf)
		end

		if arg0_10.enterCallback then
			arg0_10.enterCallback()

			arg0_10.enterCallback = nil
		end
	end)

	if arg0_10.contextData.auto then
		arg0_10:AddCloseTimer()
	end
end

function var0_0.RemoveCloseTimer(arg0_18)
	if arg0_18.closeTimer then
		arg0_18.closeTimer:Stop()

		arg0_18.closeTimer = nil
	end
end

function var0_0.AddCloseTimer(arg0_19)
	arg0_19:RemoveCloseTimer()

	arg0_19.closeTimer = Timer.New(function()
		arg0_19:RemoveCloseTimer()
		triggerButton(arg0_19._tf)
	end, arg0_19.contextData.auto or 2, 1)

	arg0_19.closeTimer:Start()
end

function var0_0.onUIAnimEnd(arg0_21, arg1_21)
	arg0_21.enterCallback = arg1_21
end

function var0_0.onBackPressed(arg0_22)
	if LeanTween.isTweening(go(arg0_22._itemsWindow)) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_22._tf)
end

local function var4_0(arg0_23, arg1_23)
	local var0_23 = pg.ship_data_statistics[arg1_23.id]
	local var1_23 = Ship.New({
		configId = arg1_23.id
	})

	var1_23.virgin = arg1_23.virgin

	setScrollText(findTF(arg0_23, "content/info/name_mask/name"), var1_23:GetColorName())
	flushShipCard(arg0_23, var1_23)

	local var2_23 = findTF(arg0_23, "content/front/new")

	setActive(var2_23, arg1_23.virgin)
end

function var0_0.displayAwards(arg0_24)
	assert(#arg0_24.awards ~= 0, "items数量不能为0")
	removeAllChildren(arg0_24.container)

	for iter0_24 = 1, #arg0_24.awards do
		if arg0_24.title ~= var0_0.TITLE.SHIP then
			cloneTplTo(arg0_24.itemTpl, arg0_24.container)
		else
			local var0_24 = cloneTplTo(arg0_24.shipTpl, arg0_24.container)

			cloneTplTo(arg0_24.shipCardTpl, var0_24, "ship_tpl")
		end
	end

	if arg0_24.title ~= var0_0.TITLE.SHIP then
		for iter1_24 = 1, #arg0_24.awards do
			local var1_24 = arg0_24.container:GetChild(iter1_24 - 1):Find("bg")
			local var2_24 = arg0_24.awards[iter1_24]

			if var2_24.type == DROP_TYPE_SHIP then
				arg0_24.hasShip = true
			end

			updateDrop(var1_24, var2_24, {
				fromAwardLayer = true
			})
			setActive(findTF(var1_24, "icon_bg/bonus"), var2_24.riraty)
			setActive(findTF(var1_24, "icon_bg/bonus_catchup"), var2_24.catchupTag)
			setActive(findTF(var1_24, "icon_bg/bonus_event"), var2_24.catchupActTag)

			local var3_24 = findTF(var1_24, "name")
			local var4_24 = findTF(var1_24, "name_mask")

			setActive(var3_24, false)
			setActive(var4_24, true)
			setScrollText(findTF(var1_24, "name_mask/name"), var2_24.name or getText(var3_24))
			onButton(arg0_24, var1_24, function()
				if arg0_24.tweeningId then
					return
				end

				arg0_24:emit(AwardInfoMediator.ON_DROP, var2_24)
			end, SFX_PANEL)
		end
	else
		for iter2_24 = 1, #arg0_24.awards do
			local var5_24 = arg0_24.container:GetChild(iter2_24 - 1):Find("ship_tpl")
			local var6_24 = arg0_24.awards[iter2_24]

			var4_0(var5_24, var6_24)

			local var7_24 = var6_24.reMetaSpecialItemVO

			if var7_24 then
				local var8_24 = cloneTplTo(arg0_24.metaRepeatAwardTF, var5_24)

				setLocalPosition(var8_24, Vector3.zero)
				setLocalScale(var8_24, Vector3.zero)

				local var9_24 = arg0_24:findTF("item_tpl/bg", var8_24)

				updateDrop(var9_24, var7_24)
				setActive(var9_24:Find("name"), false)
				setActive(var9_24:Find("name_mask"), true)
				var9_24:Find("name_mask/name"):GetComponent("ScrollText"):SetText(var7_24.cfg.name)

				local function var10_24()
					arg0_24:managedTween(LeanTween.value, nil, go(var8_24), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_27)
						setLocalScale(var8_24, {
							x = arg0_27,
							y = arg0_27
						})
					end)):setOnComplete(System.Action(function()
						setLocalScale(var8_24, Vector3.one)
					end))
				end

				arg0_24:managedTween(LeanTween.delayedCall, var10_24, 0.3, nil)
			end

			if #arg0_24.awards > 5 then
				if iter2_24 <= 5 then
					var5_24.anchoredPosition = Vector2.New(-50, 0)
				else
					var5_24.anchoredPosition = Vector2.New(50, 0)
				end
			end
		end
	end
end

function var0_0.ShowOrHideSpriteMask(arg0_29, arg1_29)
	if isActive(arg0_29.spriteMask) == arg1_29 then
		return
	end

	setActive(arg0_29.spriteMask, arg1_29)
end

function var0_0.willExit(arg0_30)
	arg0_30:RemoveCloseTimer()
	setActive(arg0_30.spriteMask, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_30._tf)

	if arg0_30.title ~= var0_0.TITLE.SHIP then
		for iter0_30 = 0, arg0_30.container.childCount - 1 do
			clearDrop(arg0_30.container:GetChild(iter0_30):Find("bg"))
		end
	end

	if arg0_30.blinks and #arg0_30.blinks > 0 then
		for iter1_30, iter2_30 in pairs(arg0_30.blinks) do
			if not IsNil(iter2_30) then
				Destroy(iter2_30)
			end
		end
	end

	if arg0_30.contextData.removeFunc then
		arg0_30.contextData.removeFunc()

		arg0_30.contextData.removeFunc = nil
	end
end

function var0_0.updateSpriteMaskScale(arg0_31)
	onNextTick(function()
		if arg0_31.exited then
			return
		end

		setLocalScale(arg0_31.spriteMask, Vector3(arg0_31.spriteMask.rect.width / WHITE_DOT_SIZE * PIXEL_PER_UNIT, arg0_31.spriteMask.rect.height / WHITE_DOT_SIZE * PIXEL_PER_UNIT, 1))
	end)
end

function var0_0.checkPaintingRes(arg0_33, arg1_33)
	local var0_33 = PaintingGroupConst.GetPaintingNameListForAwardList(arg0_33.awards)
	local var1_33 = {
		isShowBox = false,
		paintingNameList = var0_33,
		finishFunc = arg1_33
	}

	PaintingGroupConst.PaintingDownload(var1_33)
end

return var0_0
