local var0_0 = class("ShopMultiWindow", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShopsUIMsgbox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.topItem = arg0_2:findTF("item/panel_bg")
	arg0_2.ownerTF = arg0_2.topItem:Find("left/own")
	arg0_2.detailTF = arg0_2.topItem:Find("left/detail")
	arg0_2.nameTF = arg0_2.topItem:Find("display_panel/name_container/name/Text"):GetComponent(typeof(Text))
	arg0_2.descTF = arg0_2.topItem:Find("display_panel/desc/Text"):GetComponent(typeof(Text))
	arg0_2.timeLimitTF = arg0_2.topItem:Find("time_limit")
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
		arg0_3:Close()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Close()
	end, SFX_PANEL)
end

function var0_0.Open(arg0_6, arg1_6, arg2_6)
	arg0_6.opening = true

	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
	arg0_6:InitWindow(arg1_6, arg2_6)
	arg0_6:Show()
end

function var0_0.InitWindow(arg0_7, arg1_7, arg2_7)
	local var0_7 = {
		id = arg1_7:getConfig("commodity_id"),
		type = arg1_7:getConfig("commodity_type"),
		count = arg1_7:getConfig("num")
	}

	if isa(arg1_7, ActivityCommodity) then
		local var1_7, var2_7, var3_7 = arg1_7:CheckTimeLimit()

		setActive(arg0_7.timeLimitTF, var1_7)

		if var1_7 and var2_7 then
			local var4_7 = getProxy(ActivityProxy):getActivityById(Item.getConfigData(var0_7.id).link_id)

			setText(arg0_7:findTF("Text", arg0_7.timeLimitTF), i18n("eventshop_time_hint", var4_7:GetEndTimeStrByConfig()))
		end
	end

	local var5_7 = Drop.New({
		type = arg1_7:getConfig("resource_category"),
		id = arg1_7:getConfig("resource_type")
	}):getOwnedCount()
	local var6_7 = math.max(math.floor(var5_7 / arg1_7:getConfig("resource_num")), 1)

	if arg1_7:getConfig("num_limit") ~= 0 or isa(arg1_7, QuotaCommodity) then
		local var7_7 = arg1_7:GetPurchasableCnt()

		var6_7 = math.min(var6_7, math.max(0, var7_7))
	end

	local function var8_7(arg0_8)
		arg0_8 = math.max(arg0_8, 1)
		arg0_8 = math.min(arg0_8, var6_7)
		arg0_7.countTF.text = arg0_8
		arg0_7.curCount = arg0_8
		arg0_7.itemCountTF.text = arg0_8 * arg1_7:getConfig("num")
	end

	var8_7(1)
	updateDrop(arg0_7.topItem:Find("left/IconTpl"), var0_7)
	UpdateOwnDisplay(arg0_7.ownerTF, var0_7)
	RegisterDetailButton(arg0_7, arg0_7.detailTF, var0_7)

	arg0_7.nameTF.text = var0_7:getConfig("name")
	arg0_7.descTF.text = var0_7.desc or var0_7:getConfig("desc")

	updateDrop(arg0_7.bottomItem, var0_7)
	onButton(arg0_7, arg0_7.confirmBtn, function()
		if arg2_7 then
			arg2_7(arg1_7, arg0_7.curCount, var0_7:getConfig("name"))
		end

		arg0_7:Close()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.leftBtn, function()
		var8_7(arg0_7.curCount - 1)
	end)
	onButton(arg0_7, arg0_7.rightBtn, function()
		var8_7(arg0_7.curCount + 1)
	end)
	onButton(arg0_7, arg0_7.maxBtn, function()
		var8_7(var6_7)
	end)
end

function var0_0.Close(arg0_13)
	if arg0_13.opening then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf, arg0_13._parentTf)
		arg0_13:Hide()

		arg0_13.opening = false
	end
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14.opening then
		arg0_14:Close()
	end
end

return var0_0
