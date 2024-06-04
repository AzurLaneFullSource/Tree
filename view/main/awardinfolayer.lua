local var0 = class("AwardInfoLayer", import("..base.BaseUI"))

var0.TITLE = {
	COMMANDER = "commander",
	RYZA = "ryza",
	ITEM = "item",
	SHIP = "ship",
	REVERT = "revert",
	ESCORT = "escort"
}

local var1 = 0.15
local var2 = 340
local var3 = 564

function var0.getUIName(arg0)
	return "AwardInfoUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0.awards = _.select(arg0.contextData.items or {}, function(arg0)
		return arg0.type ~= DROP_TYPE_ICON_FRAME and arg0.type ~= DROP_TYPE_CHAT_FRAME
	end)
	arg0._itemsWindow = arg0._tf:Find("items")
	arg0.spriteMask = arg0._itemsWindow:Find("SpriteMask")
	arg0.title = arg0.contextData.title or var0.TITLE.ITEM

	for iter0, iter1 in pairs(var0.TITLE) do
		setActive(arg0._itemsWindow:Find("titles/title_" .. iter1), arg0.title == iter1)
	end

	if arg0.title == var0.TITLE.COMMANDER then
		eachChild(arg0._itemsWindow:Find("titles/title_commander"), function(arg0)
			setActive(arg0, arg0.name == arg0.contextData.titleExtra)
		end)
	end

	local var0 = {
		items_scroll = arg0._itemsWindow:Find("items_scroll/content"),
		ships = arg0._itemsWindow:Find("ships")
	}

	if arg0.title == var0.TITLE.SHIP then
		arg0.container = var0.ships
	else
		arg0.container = var0.items_scroll

		scrollTo(arg0.container, nil, 1)

		arg0.windowLayout = arg0._itemsWindow:Find("items_scroll"):GetComponent(typeof(LayoutElement))
	end

	GetOrAddComponent(arg0.container, "CanvasGroup").alpha = 1

	for iter2, iter3 in pairs(var0) do
		setActive(arg0._itemsWindow:Find(iter2), arg0.container == iter3)
	end

	setLocalScale(arg0._itemsWindow, Vector3(0.5, 0.5, 0.5))

	arg0.itemTpl = arg0._itemsWindow:Find("item_tpl")
	arg0.shipTpl = arg0._itemsWindow:Find("ship_tpl")
	arg0.extraBouns = arg0._itemsWindow:Find("titles/extra_bouns")

	setActive(arg0.extraBouns, arg0.contextData.extraBonus)

	arg0.continueBtn = arg0:findTF("items/close")

	local var1 = arg0._tf:Find("decorations")

	if arg0.title == var0.TITLE.SHIP then
		setLocalScale(var1, Vector3.New(1.25, 1.25, 1))
	else
		setLocalScale(var1, Vector3.one)
	end

	arg0.blinks = {}
	arg0.tweenItems = {}
	arg0.shipCardTpl = arg0._tf:GetComponent("ItemList").prefabItem[0]

	arg0._tf:SetAsLastSibling()

	arg0.metaRepeatAwardTF = arg0:findTF("MetaShipRepeatAward")
end

function var0.doAnim(arg0, arg1)
	LeanTween.scale(rtf(arg0._itemsWindow), Vector3(1, 1, 1), 0.15):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
		if arg0.exited then
			return
		end

		arg1()
	end))
end

function var0.playAnim(arg0, arg1)
	local var0 = {}

	for iter0 = 1, #arg0.awards do
		table.insert(var0, function(arg0)
			setActive(arg0.container:GetChild(iter0 - 1), true)

			if arg0.windowLayout then
				if iter0 > 5 and arg0.windowLayout.preferredHeight ~= var3 then
					arg0.windowLayout.preferredHeight = var3

					arg0:updateSpriteMaskScale()
				end

				if iter0 % 5 == 1 then
					scrollTo(arg0.container, nil, 0)
				end
			end

			arg0.tweeningId = LeanTween.delayedCall(var1, System.Action(arg0)).uniqueId
		end)
	end

	seriesAsync(var0, function()
		arg0.tweeningId = nil

		if arg1 then
			arg1()
		end
	end)
end

function var0.didEnter(arg0)
	setActive(arg0.spriteMask, true)
	onButton(arg0, arg0._tf, function()
		local var0 = function()
			if arg0.tweeningId then
				LeanTween.cancel(arg0.tweeningId)

				arg0.tweeningId = nil
			end

			arg0:emit(var0.ON_CLOSE)
		end

		arg0:checkPaintingRes(var0)
	end, SFX_CANCEL, {
		noShip = not arg0.hasShip
	})
	onButton(arg0, arg0.continueBtn, function()
		triggerButton(arg0._tf)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_GETITEM)

	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:doAnim(arg0)
	end)
	arg0:displayAwards()

	if arg0.contextData.animation then
		eachChild(arg0.container, function(arg0)
			setActive(arg0, false)
		end)

		GetOrAddComponent(arg0.container, "CanvasGroup").alpha = 0

		table.insert(var0, function(arg0)
			GetOrAddComponent(arg0.container, "CanvasGroup").alpha = 1

			arg0:playAnim(arg0)
		end)
	end

	if arg0.windowLayout then
		arg0.windowLayout.preferredHeight = not arg0.contextData.animation and #arg0.awards > 5 and var3 or var2

		arg0:updateSpriteMaskScale()
	end

	seriesAsync(var0, function()
		if arg0.exited then
			return
		end

		if arg0.contextData.closeOnCompleted then
			triggerButton(arg0._tf)
		end

		if arg0.enterCallback then
			arg0.enterCallback()

			arg0.enterCallback = nil
		end
	end)
end

function var0.onUIAnimEnd(arg0, arg1)
	arg0.enterCallback = arg1
end

function var0.onBackPressed(arg0)
	if LeanTween.isTweening(go(arg0._itemsWindow)) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0._tf)
end

local function var4(arg0, arg1)
	local var0 = pg.ship_data_statistics[arg1.id]
	local var1 = Ship.New({
		configId = arg1.id
	})

	var1.virgin = arg1.virgin

	setScrollText(findTF(arg0, "content/info/name_mask/name"), var1:GetColorName())
	flushShipCard(arg0, var1)

	local var2 = findTF(arg0, "content/front/new")

	setActive(var2, arg1.virgin)
end

function var0.displayAwards(arg0)
	assert(#arg0.awards ~= 0, "items数量不能为0")
	removeAllChildren(arg0.container)

	for iter0 = 1, #arg0.awards do
		if arg0.title ~= var0.TITLE.SHIP then
			cloneTplTo(arg0.itemTpl, arg0.container)
		else
			local var0 = cloneTplTo(arg0.shipTpl, arg0.container)

			cloneTplTo(arg0.shipCardTpl, var0, "ship_tpl")
		end
	end

	if arg0.title ~= var0.TITLE.SHIP then
		for iter1 = 1, #arg0.awards do
			local var1 = arg0.container:GetChild(iter1 - 1):Find("bg")
			local var2 = arg0.awards[iter1]

			if var2.type == DROP_TYPE_SHIP then
				arg0.hasShip = true
			end

			updateDrop(var1, var2, {
				fromAwardLayer = true
			})
			setActive(findTF(var1, "icon_bg/bonus"), var2.riraty)
			setActive(findTF(var1, "icon_bg/bonus_catchup"), var2.catchupTag)
			setActive(findTF(var1, "icon_bg/bonus_event"), var2.catchupActTag)

			local var3 = findTF(var1, "name")
			local var4 = findTF(var1, "name_mask")

			setActive(var3, false)
			setActive(var4, true)
			setScrollText(findTF(var1, "name_mask/name"), var2.name or getText(var3))
			onButton(arg0, var1, function()
				if arg0.tweeningId then
					return
				end

				arg0:emit(AwardInfoMediator.ON_DROP, var2)
			end, SFX_PANEL)
		end
	else
		for iter2 = 1, #arg0.awards do
			local var5 = arg0.container:GetChild(iter2 - 1):Find("ship_tpl")
			local var6 = arg0.awards[iter2]

			var4(var5, var6)

			local var7 = var6.reMetaSpecialItemVO

			if var7 then
				local var8 = cloneTplTo(arg0.metaRepeatAwardTF, var5)

				setLocalPosition(var8, Vector3.zero)
				setLocalScale(var8, Vector3.zero)

				local var9 = arg0:findTF("item_tpl/bg", var8)

				updateDrop(var9, var7)
				setActive(var9:Find("name"), false)
				setActive(var9:Find("name_mask"), true)
				var9:Find("name_mask/name"):GetComponent("ScrollText"):SetText(var7.cfg.name)

				local function var10()
					arg0:managedTween(LeanTween.value, nil, go(var8), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
						setLocalScale(var8, {
							x = arg0,
							y = arg0
						})
					end)):setOnComplete(System.Action(function()
						setLocalScale(var8, Vector3.one)
					end))
				end

				arg0:managedTween(LeanTween.delayedCall, var10, 0.3, nil)
			end

			if #arg0.awards > 5 then
				if iter2 <= 5 then
					var5.anchoredPosition = Vector2.New(-50, 0)
				else
					var5.anchoredPosition = Vector2.New(50, 0)
				end
			end
		end
	end
end

function var0.ShowOrHideSpriteMask(arg0, arg1)
	if isActive(arg0.spriteMask) == arg1 then
		return
	end

	setActive(arg0.spriteMask, arg1)
end

function var0.willExit(arg0)
	setActive(arg0.spriteMask, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.title ~= var0.TITLE.SHIP then
		for iter0 = 0, arg0.container.childCount - 1 do
			clearDrop(arg0.container:GetChild(iter0):Find("bg"))
		end
	end

	if arg0.blinks and #arg0.blinks > 0 then
		for iter1, iter2 in pairs(arg0.blinks) do
			if not IsNil(iter2) then
				Destroy(iter2)
			end
		end
	end

	if arg0.contextData.removeFunc then
		arg0.contextData.removeFunc()

		arg0.contextData.removeFunc = nil
	end
end

function var0.updateSpriteMaskScale(arg0)
	onNextTick(function()
		if arg0.exited then
			return
		end

		setLocalScale(arg0.spriteMask, Vector3(arg0.spriteMask.rect.width / WHITE_DOT_SIZE * PIXEL_PER_UNIT, arg0.spriteMask.rect.height / WHITE_DOT_SIZE * PIXEL_PER_UNIT, 1))
	end)
end

function var0.checkPaintingRes(arg0, arg1)
	local var0 = PaintingGroupConst.GetPaintingNameListForAwardList(arg0.awards)
	local var1 = {
		isShowBox = false,
		paintingNameList = var0,
		finishFunc = arg1
	}

	PaintingGroupConst.PaintingDownload(var1)
end

return var0
