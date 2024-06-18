local var0_0 = class("MedalShopMultiWindow", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShopsUIMsgbox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.topItem = arg0_2:findTF("item/panel_bg")
	arg0_2.ownerTF = arg0_2.topItem:Find("left/own")
	arg0_2.detailTF = arg0_2.topItem:Find("left/detail")
	arg0_2.nameTF = arg0_2.topItem:Find("display_panel/name_container/name/Text"):GetComponent(typeof(Text))
	arg0_2.descTF = arg0_2.topItem:Find("display_panel/desc/Text"):GetComponent(typeof(Text))
	arg0_2.bottomItem = arg0_2:findTF("got/panel_bg/list/item")
	arg0_2.itemCountTF = arg0_2.bottomItem:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0_2.maxBtn = arg0_2:findTF("count/max")
	arg0_2.leftBtn = arg0_2:findTF("count/number_panel/left")
	arg0_2.rightBtn = arg0_2:findTF("count/number_panel/right")
	arg0_2.countTF = arg0_2:findTF("count/number_panel/value"):GetComponent(typeof(Text))
	arg0_2.cancelBtn = arg0_2:findTF("actions/cancel_button")
	arg0_2.confirmBtn = arg0_2:findTF("actions/confirm_button")

	setText(arg0_2:findTF("got/panel_bg/got_text"), i18n("shops_msgbox_output"))
	setText(arg0_2:findTF("count/image_text"), i18n("shops_msgbox_exchange_count"))
	setText(arg0_2:findTF("actions/cancel_button/label"), i18n("shop_word_cancel"))
	setText(arg0_2:findTF("actions/confirm_button/label"), i18n("shop_word_exchange"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	arg0_6:InitWindow(arg1_6, arg2_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
	var0_0.super.Show(arg0_6)
end

function var0_0.Hide(arg0_7)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf, arg0_7._parentTf)
	var0_0.super.Hide(arg0_7)
end

function var0_0.InitWindow(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8:GetDropInfo()
	local var1_8 = getProxy(BagProxy):getItemCountById(ITEM_ID_SILVER_HOOK)
	local var2_8 = math.max(math.floor(var1_8 / arg1_8:getConfig("price")), 1)

	if arg1_8:GetLimit() ~= 0 then
		var2_8 = math.min(var2_8, arg1_8:GetMaxCnt())
	end

	local function var3_8(arg0_9)
		arg0_9 = math.max(arg0_9, 1)
		arg0_9 = math.min(arg0_9, var2_8)
		arg0_8.countTF.text = arg0_9
		arg0_8.curCount = arg0_9
		arg0_8.itemCountTF.text = arg0_9 * arg1_8:getConfig("num")
	end

	var3_8(1)
	updateDrop(arg0_8.topItem:Find("left/IconTpl"), var0_8)
	UpdateOwnDisplay(arg0_8.ownerTF, var0_8)
	RegisterDetailButton(arg0_8, arg0_8.detailTF, var0_8)

	arg0_8.nameTF.text = var0_8:getConfig("name")
	arg0_8.descTF.text = var0_8.desc or var0_8:getConfig("desc")

	updateDrop(arg0_8.bottomItem, var0_8)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		if arg2_8 then
			arg2_8(arg0_8.curCount)
		end

		arg0_8:Hide()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.leftBtn, function()
		var3_8(arg0_8.curCount - 1)
	end)
	onButton(arg0_8, arg0_8.rightBtn, function()
		var3_8(arg0_8.curCount + 1)
	end)
	onButton(arg0_8, arg0_8.maxBtn, function()
		var3_8(var2_8)
	end)
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14:isShowing() then
		arg0_14:Hide()
	end
end

return var0_0
