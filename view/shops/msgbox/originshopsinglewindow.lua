local var0_0 = class("OriginShopSingleWindow", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShopsUISinglebox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.itemTF = arg0_2:findTF("window/item")
	arg0_2.nameTF = arg0_2.itemTF:Find("display_panel/name_container/name/Text"):GetComponent(typeof(Text))
	arg0_2.descTF = arg0_2.itemTF:Find("display_panel/desc/Text"):GetComponent(typeof(Text))
	arg0_2.itemOwnTF = arg0_2.itemTF:Find("left/own")
	arg0_2.itemDetailTF = arg0_2.itemTF:Find("left/detail")
	arg0_2.confirmBtn = arg0_2:findTF("window/actions/confirm_btn")

	setText(arg0_2:findTF("window/actions/cancel_btn/pic"), i18n("shop_word_cancel"))
	setText(arg0_2:findTF("window/actions/confirm_btn/pic"), i18n("shop_word_exchange"))
	setText(arg0_2.itemTF:Find("ship_group/locked/Text"), i18n("tag_ship_locked"))
	setText(arg0_2.itemTF:Find("ship_group/unlocked/Text"), i18n("tag_ship_unlocked"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3:findTF("window/actions/cancel_btn"), function()
		arg0_3:Close()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Close()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("window/top/btnBack"), function()
		arg0_3:Close()
	end, SFX_CANCEL)
end

function var0_0.Open(arg0_7, arg1_7, arg2_7)
	arg0_7.opening = true

	arg0_7:Show()
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
	arg0_7:InitWindow(arg1_7, arg2_7)
end

function var0_0.InitWindow(arg0_8, arg1_8, arg2_8)
	local var0_8 = isa(arg1_8, WorldNShopCommodity) and arg1_8:GetDropInfo() or arg1_8:getDropInfo()

	updateDrop(arg0_8.itemTF:Find("left/IconTpl"), var0_8)
	UpdateOwnDisplay(arg0_8.itemOwnTF, var0_8)
	RegisterDetailButton(arg0_8, arg0_8.itemDetailTF, var0_8)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		existCall(arg2_8, arg1_8, 1)
		arg0_8:Close()
	end, SFX_CANCEL)

	local var1_8 = var0_8.type == DROP_TYPE_SHIP
	local var2_8 = arg0_8.itemTF:Find("ship_group")

	SetActive(var2_8, var1_8)

	if var1_8 then
		local var3_8 = tobool(getProxy(CollectionProxy):getShipGroup(pg.ship_data_template[var0_8.id].group_type))

		SetActive(var2_8:Find("unlocked"), var3_8)
		SetActive(var2_8:Find("locked"), not var3_8)
	end

	arg0_8.descTF.text = var0_8.desc or var0_8:getConfig("desc")
	arg0_8.nameTF.text = var0_8:getConfig("name")
end

function var0_0.Close(arg0_10)
	if arg0_10.opening then
		arg0_10.opening = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
		arg0_10:Hide()
	end
end

function var0_0.OnDestroy(arg0_11)
	if arg0_11.opening then
		arg0_11:Close()
	end
end

return var0_0
