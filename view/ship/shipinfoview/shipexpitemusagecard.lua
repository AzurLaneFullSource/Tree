local var0 = class("ShipExpItemUsageCard")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.nameTxt = arg1:Find("name"):GetComponent(typeof(Text))
	arg0.itemTF = arg1:Find("item")
	arg0.valueTxt = arg1:Find("value/Text"):GetComponent(typeof(Text))
	arg0.value = 0

	pressPersistTrigger(arg1:Find("m10"), 0.5, function()
		arg0.value = arg0.value - 10

		arg0:UpdateValue(true)
	end, nil, true, true, 0.15, SFX_PANEL)
	pressPersistTrigger(arg1:Find("a10"), 0.5, function()
		arg0.value = arg0.value + 10

		arg0:UpdateValue()
	end, nil, true, true, 0.15, SFX_PANEL)
	pressPersistTrigger(arg1:Find("a1"), 0.5, function()
		arg0.value = arg0.value + 1

		arg0:UpdateValue()
	end, nil, true, true, 0.15, SFX_PANEL)
	pressPersistTrigger(arg1:Find("m1"), 0.5, function()
		arg0.value = arg0.value - 1

		arg0:UpdateValue(true)
	end, nil, true, true, 0.15, SFX_PANEL)
end

function var0.SetCallBack(arg0, arg1)
	arg0.callback = arg1
end

function var0.GetItem(arg0, arg1)
	return getProxy(BagProxy):getItemById(arg1) or Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = arg1
	})
end

function var0.Update(arg0, arg1)
	arg0.value = 0

	local var0 = arg0:GetItem(arg1)

	arg0.item = var0

	updateDrop(arg0.itemTF, {
		type = DROP_TYPE_ITEM,
		id = arg1,
		count = var0.count
	})

	if var0.count == 0 then
		setText(arg0.itemTF:Find("icon_bg/count"), 0)
	end

	arg0.nameTxt.text = string.format("<color=#%s>%s</color>", ItemRarity.Rarity2HexColor(var0:getConfig("rarity")), var0:getConfig("name"))

	arg0:UpdateValue()
end

function var0.UpdateValue(arg0, arg1)
	arg0.value = math.min(arg0.value, arg0.item.count)
	arg0.value = math.max(arg0.value, 0)
	arg0.valueTxt.text = arg0.value

	if arg0.callback then
		arg0.callback(arg0, arg0.item.id, arg0.value, arg1)
	end
end

function var0.ForceUpdateValue(arg0, arg1)
	arg0.value = arg1
	arg0.valueTxt.text = arg0.value
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
