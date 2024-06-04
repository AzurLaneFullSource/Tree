local var0 = class("ShopSingleWindow", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShopsUISinglebox"
end

function var0.OnLoaded(arg0)
	arg0.itemTF = arg0:findTF("window/item")
	arg0.nameTF = arg0.itemTF:Find("display_panel/name_container/name/Text"):GetComponent(typeof(Text))
	arg0.descTF = arg0.itemTF:Find("display_panel/desc/Text"):GetComponent(typeof(Text))
	arg0.itemOwnTF = arg0.itemTF:Find("left/own")
	arg0.itemDetailTF = arg0.itemTF:Find("left/detail")
	arg0.confirmBtn = arg0:findTF("window/actions/confirm_btn")

	setText(arg0:findTF("window/actions/cancel_btn/pic"), i18n("shop_word_cancel"))
	setText(arg0:findTF("window/actions/confirm_btn/pic"), i18n("shop_word_exchange"))
	setText(arg0.itemTF:Find("ship_group/locked/Text"), i18n("tag_ship_locked"))
	setText(arg0.itemTF:Find("ship_group/unlocked/Text"), i18n("tag_ship_unlocked"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0:findTF("window/actions/cancel_btn"), function()
		arg0:Close()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Close()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("window/top/btnBack"), function()
		arg0:Close()
	end, SFX_CANCEL)
end

function var0.Open(arg0, arg1, arg2)
	arg0.opening = true

	arg0:Show()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:InitWindow(arg1, arg2)
end

function var0.InitWindow(arg0, arg1, arg2)
	local var0 = {
		id = arg1:getConfig("commodity_id"),
		type = arg1:getConfig("commodity_type"),
		count = arg1:getConfig("num")
	}

	onButton(arg0, arg0.confirmBtn, function()
		if arg2 then
			arg2(arg1, 1, var0:getConfig("name"))
		end

		arg0:Close()
	end, SFX_CANCEL)
	updateDrop(arg0.itemTF:Find("left/IconTpl"), var0)
	UpdateOwnDisplay(arg0.itemOwnTF, var0)
	RegisterDetailButton(arg0, arg0.itemDetailTF, var0)

	local var1 = var0.type == DROP_TYPE_SHIP
	local var2 = arg0.itemTF:Find("ship_group")

	SetActive(var2, var1)

	if var1 then
		local var3 = tobool(getProxy(CollectionProxy):getShipGroup(pg.ship_data_template[var0.id].group_type))

		SetActive(var2:Find("unlocked"), var3)
		SetActive(var2:Find("locked"), not var3)
	end

	arg0.descTF.text = var0.desc or var0:getConfig("desc")
	arg0.nameTF.text = var0:getConfig("name")
end

function var0.Close(arg0)
	if arg0.opening then
		arg0.opening = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
		arg0:Hide()
	end
end

function var0.OnDestroy(arg0)
	if arg0.opening then
		arg0:Close()
	end
end

return var0
