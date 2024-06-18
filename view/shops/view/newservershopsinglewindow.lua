local var0_0 = class("NewServerShopSingleWindow", import("..msgbox.ShopSingleWindow"))

function var0_0.InitWindow(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		id = arg1_1:getConfig("goods")[1],
		type = arg1_1:getConfig("type"),
		count = arg1_1:getConfig("num")
	}

	onButton(arg0_1, arg0_1.confirmBtn, function()
		if arg2_1 then
			arg2_1(arg1_1, 1, var0_1:getConfig("name"))
		end

		arg0_1:Close()
	end, SFX_CANCEL)
	updateDrop(arg0_1.itemTF:Find("left/IconTpl"), var0_1)
	UpdateOwnDisplay(arg0_1.itemOwnTF, var0_1)
	RegisterDetailButton(arg0_1, arg0_1.itemDetailTF, var0_1)

	local var1_1 = var0_1.type == DROP_TYPE_SHIP
	local var2_1 = arg0_1.itemTF:Find("ship_group")

	SetActive(var2_1, var1_1)

	if var1_1 then
		local var3_1 = tobool(getProxy(CollectionProxy):getShipGroup(pg.ship_data_template[var0_1.id].group_type))

		SetActive(var2_1:Find("unlocked"), var3_1)
		SetActive(var2_1:Find("locked"), not var3_1)
	end

	arg0_1.descTF.text = var0_1.desc or var0_1:getConfig("desc")
	arg0_1.nameTF.text = var0_1:getConfig("name")
end

return var0_0
