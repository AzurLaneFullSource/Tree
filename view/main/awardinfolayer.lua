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
		return arg0_3.type ~= DROP_TYPE_ICON_FRAME and arg0_3.type ~= DROP_TYPE_CHAT_FRAME
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
end

function var0_0.onUIAnimEnd(arg0_18, arg1_18)
	arg0_18.enterCallback = arg1_18
end

function var0_0.onBackPressed(arg0_19)
	if LeanTween.isTweening(go(arg0_19._itemsWindow)) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_19._tf)
end

local function var4_0(arg0_20, arg1_20)
	local var0_20 = pg.ship_data_statistics[arg1_20.id]
	local var1_20 = Ship.New({
		configId = arg1_20.id
	})

	var1_20.virgin = arg1_20.virgin

	setScrollText(findTF(arg0_20, "content/info/name_mask/name"), var1_20:GetColorName())
	flushShipCard(arg0_20, var1_20)

	local var2_20 = findTF(arg0_20, "content/front/new")

	setActive(var2_20, arg1_20.virgin)
end

function var0_0.displayAwards(arg0_21)
	assert(#arg0_21.awards ~= 0, "items数量不能为0")
	removeAllChildren(arg0_21.container)

	for iter0_21 = 1, #arg0_21.awards do
		if arg0_21.title ~= var0_0.TITLE.SHIP then
			cloneTplTo(arg0_21.itemTpl, arg0_21.container)
		else
			local var0_21 = cloneTplTo(arg0_21.shipTpl, arg0_21.container)

			cloneTplTo(arg0_21.shipCardTpl, var0_21, "ship_tpl")
		end
	end

	if arg0_21.title ~= var0_0.TITLE.SHIP then
		for iter1_21 = 1, #arg0_21.awards do
			local var1_21 = arg0_21.container:GetChild(iter1_21 - 1):Find("bg")
			local var2_21 = arg0_21.awards[iter1_21]

			if var2_21.type == DROP_TYPE_SHIP then
				arg0_21.hasShip = true
			end

			updateDrop(var1_21, var2_21, {
				fromAwardLayer = true
			})
			setActive(findTF(var1_21, "icon_bg/bonus"), var2_21.riraty)
			setActive(findTF(var1_21, "icon_bg/bonus_catchup"), var2_21.catchupTag)
			setActive(findTF(var1_21, "icon_bg/bonus_event"), var2_21.catchupActTag)

			local var3_21 = findTF(var1_21, "name")
			local var4_21 = findTF(var1_21, "name_mask")

			setActive(var3_21, false)
			setActive(var4_21, true)
			setScrollText(findTF(var1_21, "name_mask/name"), var2_21.name or getText(var3_21))
			onButton(arg0_21, var1_21, function()
				if arg0_21.tweeningId then
					return
				end

				arg0_21:emit(AwardInfoMediator.ON_DROP, var2_21)
			end, SFX_PANEL)
		end
	else
		for iter2_21 = 1, #arg0_21.awards do
			local var5_21 = arg0_21.container:GetChild(iter2_21 - 1):Find("ship_tpl")
			local var6_21 = arg0_21.awards[iter2_21]

			var4_0(var5_21, var6_21)

			local var7_21 = var6_21.reMetaSpecialItemVO

			if var7_21 then
				local var8_21 = cloneTplTo(arg0_21.metaRepeatAwardTF, var5_21)

				setLocalPosition(var8_21, Vector3.zero)
				setLocalScale(var8_21, Vector3.zero)

				local var9_21 = arg0_21:findTF("item_tpl/bg", var8_21)

				updateDrop(var9_21, var7_21)
				setActive(var9_21:Find("name"), false)
				setActive(var9_21:Find("name_mask"), true)
				var9_21:Find("name_mask/name"):GetComponent("ScrollText"):SetText(var7_21.cfg.name)

				local function var10_21()
					arg0_21:managedTween(LeanTween.value, nil, go(var8_21), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_24)
						setLocalScale(var8_21, {
							x = arg0_24,
							y = arg0_24
						})
					end)):setOnComplete(System.Action(function()
						setLocalScale(var8_21, Vector3.one)
					end))
				end

				arg0_21:managedTween(LeanTween.delayedCall, var10_21, 0.3, nil)
			end

			if #arg0_21.awards > 5 then
				if iter2_21 <= 5 then
					var5_21.anchoredPosition = Vector2.New(-50, 0)
				else
					var5_21.anchoredPosition = Vector2.New(50, 0)
				end
			end
		end
	end
end

function var0_0.ShowOrHideSpriteMask(arg0_26, arg1_26)
	if isActive(arg0_26.spriteMask) == arg1_26 then
		return
	end

	setActive(arg0_26.spriteMask, arg1_26)
end

function var0_0.willExit(arg0_27)
	setActive(arg0_27.spriteMask, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_27._tf)

	if arg0_27.title ~= var0_0.TITLE.SHIP then
		for iter0_27 = 0, arg0_27.container.childCount - 1 do
			clearDrop(arg0_27.container:GetChild(iter0_27):Find("bg"))
		end
	end

	if arg0_27.blinks and #arg0_27.blinks > 0 then
		for iter1_27, iter2_27 in pairs(arg0_27.blinks) do
			if not IsNil(iter2_27) then
				Destroy(iter2_27)
			end
		end
	end

	if arg0_27.contextData.removeFunc then
		arg0_27.contextData.removeFunc()

		arg0_27.contextData.removeFunc = nil
	end
end

function var0_0.updateSpriteMaskScale(arg0_28)
	onNextTick(function()
		if arg0_28.exited then
			return
		end

		setLocalScale(arg0_28.spriteMask, Vector3(arg0_28.spriteMask.rect.width / WHITE_DOT_SIZE * PIXEL_PER_UNIT, arg0_28.spriteMask.rect.height / WHITE_DOT_SIZE * PIXEL_PER_UNIT, 1))
	end)
end

function var0_0.checkPaintingRes(arg0_30, arg1_30)
	local var0_30 = PaintingGroupConst.GetPaintingNameListForAwardList(arg0_30.awards)
	local var1_30 = {
		isShowBox = false,
		paintingNameList = var0_30,
		finishFunc = arg1_30
	}

	PaintingGroupConst.PaintingDownload(var1_30)
end

return var0_0
