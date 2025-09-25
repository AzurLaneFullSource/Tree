local var0_0 = class("ShipGiftItem", import("view.base.BasePanel"))

var0_0.SELECT_ITEM = "ShipGiftItem::selectItem"
var0_0.REFRESH_USE_ITEM_CNT = "ShipGiftItem::refreshUseItemCnt"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.item = arg0_2:findTF("IconTpl")
	arg0_2.nameText = arg0_2:findTF("name")
	arg0_2.valueText = arg0_2:findTF("numberTitle/value")
	arg0_2.useCntText = arg0_2:findTF("count/value")
	arg0_2.selectImg = arg0_2:findTF("select")
	arg0_2.countPanel = arg0_2:findTF("count")
	arg0_2.maxBtn = arg0_2:findTF("count/maxBtn")
	arg0_2.addBtn = arg0_2:findTF("count/addBtn")
	arg0_2.subtractBtn = arg0_2:findTF("count/subtractBtn")
	arg0_2.favoriteTF = arg0_2:findTF("favorite", arg0_2.item)

	setText(arg0_2:findTF("numberTitle"), i18n("ship_gift_cnt"))
	pressPersistTrigger(arg0_2.addBtn, 0.5, function(arg0_3)
		if arg0_2.selectCnt >= arg0_2.maxCnt then
			return
		end

		arg0_2.selectCnt = arg0_2.selectCnt + 1

		arg0_2:emit(ShipGiftItem.REFRESH_USE_ITEM_CNT, arg0_2.selectCnt)
		arg0_2:RefreshUseCnt()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_2.subtractBtn, 0.5, function(arg0_4)
		if arg0_2.selectCnt <= (arg0_2.itemVO.count > 0 and 1 or 0) then
			return
		end

		arg0_2.selectCnt = arg0_2.selectCnt - 1

		arg0_2:emit(ShipGiftItem.REFRESH_USE_ITEM_CNT, arg0_2.selectCnt)
		arg0_2:RefreshUseCnt()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_2, arg0_2.maxBtn, function()
		arg0_2.selectCnt = arg0_2.maxCnt

		arg0_2:emit(ShipGiftItem.REFRESH_USE_ITEM_CNT, arg0_2.selectCnt)
		arg0_2:RefreshUseCnt()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.item, function()
		arg0_2:emit(BaseUI.ON_ITEM, arg0_2.itemVO.id)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf, function()
		if arg0_2.selectIndex == arg0_2.index then
			return
		end

		arg0_2:emit(ShipGiftItem.SELECT_ITEM, arg0_2.index)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8, arg5_8)
	arg0_8:RefreshData(arg1_8, arg2_8, arg3_8, arg4_8)
	updateItem(arg0_8.item, arg2_8)
	setText(arg0_8.nameText, arg2_8:getConfig("name"))
	setText(arg0_8.valueText, arg2_8.count or 0)
	setActive(findTF(arg0_8.item, "icon_bg/count"), false)

	local var0_8 = ShipGiftTools.GetItemFavoriteState(arg1_8, arg2_8)
	local var1_8 = GetSpriteFromAtlas("energy", ShipGiftTools.GetItemIntimacySpriteName(arg1_8, arg2_8))

	setImageSprite(arg0_8.favoriteTF, var1_8)
	arg0_8:RefreshSelect(arg5_8, arg4_8)
end

function var0_0.RefreshData(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	arg0_9.shipVO = arg1_9
	arg0_9.index = arg3_9
	arg0_9.itemVO = arg2_9
	arg0_9.selectCnt = arg4_9
	arg0_9.maxCnt = ShipGiftTools.GetNeedMaxCnt(arg1_9, arg2_9)
end

function var0_0.RefreshSelect(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.index == arg1_10

	arg0_10.selectIndex = arg1_10

	setActive(arg0_10.selectImg, var0_10)
	setActive(arg0_10.countPanel, var0_10)

	arg0_10.selectCnt = arg2_10

	if var0_10 == true then
		arg0_10:RefreshUseCnt()
	end
end

function var0_0.RefreshUI(arg0_11, arg1_11, arg2_11)
	arg0_11:RefreshSelect(arg1_11, arg2_11)
end

function var0_0.RefreshUseCnt(arg0_12)
	if arg0_12.selectCnt >= arg0_12.maxCnt then
		arg0_12.selectCnt = arg0_12.maxCnt

		setGray(arg0_12.addBtn, true)
	else
		setGray(arg0_12.addBtn, false)
	end

	if arg0_12.selectCnt <= (arg0_12.itemVO.count > 0 and 1 or 0) then
		setGray(arg0_12.subtractBtn, true)
	else
		setGray(arg0_12.subtractBtn, false)
	end

	setText(arg0_12.useCntText, arg0_12.selectCnt)
end

function var0_0.willExit(arg0_13)
	return
end

function var0_0.Dispose(arg0_14)
	arg0_14:detach()
end

return var0_0
