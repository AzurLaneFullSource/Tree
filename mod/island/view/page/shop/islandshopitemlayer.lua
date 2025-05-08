local var0_0 = class("IslandShopItemLayer", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.showType = arg4_1
end

function var0_0.getUIName(arg0_2)
	if arg0_2.showType == IslandConst.COMMODITY_SHOW_ITEM_FULL then
		return "IslandShopItemFullUI"
	else
		return "IslandShopItemHalfUI"
	end
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.topItem = arg0_3:findTF("item/panel_bg")
	arg0_3.icon = arg0_3:findTF("icon", arg0_3.topItem)
	arg0_3.name = arg0_3:findTF("display_panel/name_container/name/Text", arg0_3.topItem)
	arg0_3.desc = arg0_3:findTF("display_panel/desc/Text", arg0_3.topItem)
	arg0_3.count = arg0_3:findTF("count/number_panel/value")
	arg0_3.leftBtn = arg0_3:findTF("count/number_panel/left")
	arg0_3.rightBtn = arg0_3:findTF("count/number_panel/right")
	arg0_3.maxBtn = arg0_3:findTF("count/max")
	arg0_3.bottomItemList = UIItemList.New(arg0_3:findTF("got/panel_bg/list"), arg0_3:findTF("got/panel_bg/list/item"))
	arg0_3.cancelBtn = arg0_3:findTF("actions/cancel_button")
	arg0_3.confirmBtn = arg0_3:findTF("actions/confirm_button")
	arg0_3.consumeIcon = arg0_3:findTF("consumeIcon", arg0_3.confirmBtn)
	arg0_3.consumeCount = arg0_3:findTF("consumeCount", arg0_3.confirmBtn)

	setText(arg0_3:findTF("got/panel_bg/got_text"), i18n("shops_msgbox_output"))
	setText(arg0_3:findTF("count/image_text"), i18n("shops_msgbox_exchange_count"))
	setText(arg0_3:findTF("actions/cancel_button/label"), i18n("shop_word_cancel"))
	setText(arg0_3:findTF("actions/confirm_button/label"), i18n("shop_word_exchange"))
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.cancelBtn, function()
		arg0_4:Close()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		arg0_4:Close()
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_7, arg1_7, arg2_7)
	GetImageSpriteFromAtlasAsync(arg2_7:GetIcon(), "", arg0_7.icon)
	setText(arg0_7.name, arg2_7:GetName())
	setText(arg0_7.desc, arg2_7:GetDescription())

	local var0_7 = arg2_7:GetMaxNum() - arg2_7.purchasedNum

	if arg2_7:GetMaxNum() == 0 then
		var0_7 = 99
	end

	local var1_7 = arg2_7:GetItems()
	local var2_7 = arg2_7:GetResourceConsume()

	local function var3_7(arg0_8)
		arg0_8 = math.max(arg0_8, 1)
		arg0_8 = math.min(arg0_8, var0_7)
		arg0_7.curCount = arg0_8

		setText(arg0_7.count, arg0_8)

		for iter0_8 = 1, #arg0_7.itemsCountTFs do
			local var0_8 = arg0_7.itemsCountTFs[iter0_8]

			setText(var0_8, var1_7[iter0_8][3] * arg0_7.curCount)
		end

		setText(arg0_7.consumeCount, math.ceil((100 - arg2_7:GetDiscount()) / 100 * var2_7[3]) * arg0_7.curCount)
	end

	onButton(arg0_7, arg0_7.leftBtn, function()
		var3_7(arg0_7.curCount - 1)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.rightBtn, function()
		var3_7(arg0_7.curCount + 1)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.maxBtn, function()
		var3_7(var0_7)
	end, SFX_PANEL)

	arg0_7.itemsCountTFs = {}

	arg0_7.bottomItemList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var1_7[arg1_12 + 1]
			local var1_12 = {
				type = var0_12[1],
				id = var0_12[2],
				count = var0_12[3]
			}

			updateDrop(arg2_12:Find("IslandItemTpl"), var1_12)
			setText(arg2_12:Find("name"), pg.island_item_data_template[var0_12[2]].name)
			table.insert(arg0_7.itemsCountTFs, arg2_12:Find("icon_bg/count"))
		end
	end)
	arg0_7.bottomItemList:align(#var1_7)
	var3_7(1)
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var2_7[1],
		id = var2_7[2]
	}):getIcon(), "", arg0_7.consumeIcon)
	onButton(arg0_7, arg0_7.confirmBtn, function()
		arg0_7:emit(IslandMediator.BUY_COMMODITY, arg1_7, arg2_7.id, arg0_7.curCount)
	end, SFX_PANEL)
end

function var0_0.Open(arg0_14, arg1_14, arg2_14)
	arg0_14.opening = true

	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
	arg0_14:SetUp(arg1_14, arg2_14)
	arg0_14:Show()
end

function var0_0.Close(arg0_15)
	if arg0_15.opening then
		arg0_15.opening = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0_15._tf, arg0_15._parentTf)
		arg0_15:Hide()
	end
end

function var0_0.OnDestroy(arg0_16)
	return
end

return var0_0
