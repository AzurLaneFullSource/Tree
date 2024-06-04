local var0 = class("NewServerShopSingleWindow", import("..msgbox.ShopSingleWindow"))

function var0.InitWindow(arg0, arg1, arg2)
	local var0 = {
		id = arg1:getConfig("goods")[1],
		type = arg1:getConfig("type"),
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

return var0
