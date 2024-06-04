local var0 = class("OriginShopMultiWindow", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShopsUIMsgbox"
end

function var0.OnLoaded(arg0)
	arg0.topItem = arg0:findTF("item/panel_bg")
	arg0.ownerTF = arg0.topItem:Find("left/own")
	arg0.detailTF = arg0.topItem:Find("left/detail")
	arg0.nameTF = arg0.topItem:Find("display_panel/name_container/name/Text"):GetComponent(typeof(Text))
	arg0.descTF = arg0.topItem:Find("display_panel/desc/Text"):GetComponent(typeof(Text))
	arg0.bottomItem = arg0:findTF("got/panel_bg/list/item")
	arg0.itemCountTF = arg0.bottomItem:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0.maxBtn = arg0:findTF("count/max")
	arg0.leftBtn = arg0:findTF("count/number_panel/left")
	arg0.rightBtn = arg0:findTF("count/number_panel/right")
	arg0.countTF = arg0:findTF("count/number_panel/value"):GetComponent(typeof(Text))
	arg0.cancelBtn = arg0:findTF("actions/cancel_button")
	arg0.confirmBtn = arg0:findTF("actions/confirm_button")

	setText(arg0:findTF("got/panel_bg/got_text"), i18n("shops_msgbox_output"))
	setText(arg0:findTF("count/image_text"), i18n("shops_msgbox_exchange_count"))
	setText(arg0:findTF("actions/cancel_button/label"), i18n("shop_word_cancel"))
	setText(arg0:findTF("actions/confirm_button/label"), i18n("shop_word_exchange"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Close()
	end, SFX_PANEL)
end

function var0.Open(arg0, arg1, arg2)
	arg0.opening = true

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:InitWindow(arg1, arg2)
	arg0:Show()
end

function var0.InitWindow(arg0, arg1, arg2)
	local var0
	local var1
	local var2

	if isa(arg1, WorldNShopCommodity) then
		var0 = arg1:GetDropInfo()
		var1 = arg1:GetPriceInfo()
		var2 = arg1:GetLimitGoodCount()
	else
		var0 = arg1:getDropInfo()
		var1 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = arg1:getConfig("resource_type"),
			count = arg1:getConfig("resource_num")
		})
		var2 = arg1:getLimitCount()
	end

	local var3 = math.max(math.floor(var1:getOwnedCount() / var1.count), 1)

	if var2 ~= 0 then
		var3 = math.min(var3, var2 - arg1.buyCount)
	end

	local function var4(arg0)
		arg0 = math.max(arg0, 1)
		arg0 = math.min(arg0, var3)
		arg0.countTF.text = arg0
		arg0.curCount = arg0
		arg0.itemCountTF.text = arg0 * var0.count
	end

	var4(1)
	updateDrop(arg0.topItem:Find("left/IconTpl"), var0)
	UpdateOwnDisplay(arg0.ownerTF, var0)
	RegisterDetailButton(arg0, arg0.detailTF, var0)

	arg0.nameTF.text = var0:getConfig("name")
	arg0.descTF.text = var0.desc or var0:getConfig("desc")

	updateDrop(arg0.bottomItem, var0)
	onButton(arg0, arg0.confirmBtn, function()
		existCall(arg2, arg1, arg0.curCount)
		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0.leftBtn, function()
		var4(arg0.curCount - 1)
	end)
	onButton(arg0, arg0.rightBtn, function()
		var4(arg0.curCount + 1)
	end)
	onButton(arg0, arg0.maxBtn, function()
		var4(var3)
	end)
end

function var0.Close(arg0)
	if arg0.opening then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
		arg0:Hide()

		arg0.opening = false
	end
end

function var0.OnDestroy(arg0)
	if arg0.opening then
		arg0:Close()
	end
end

return var0
