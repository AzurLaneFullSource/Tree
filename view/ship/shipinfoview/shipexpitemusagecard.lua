local var0_0 = class("ShipExpItemUsageCard")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.nameTxt = arg1_1:Find("name"):GetComponent(typeof(Text))
	arg0_1.itemTF = arg1_1:Find("item")
	arg0_1.valueTxt = arg1_1:Find("value/Text"):GetComponent(typeof(Text))
	arg0_1.value = 0

	pressPersistTrigger(arg1_1:Find("m10"), 0.5, function()
		arg0_1.value = arg0_1.value - 10

		arg0_1:UpdateValue(true)
	end, nil, true, true, 0.15, SFX_PANEL)
	pressPersistTrigger(arg1_1:Find("a10"), 0.5, function()
		arg0_1.value = arg0_1.value + 10

		arg0_1:UpdateValue()
	end, nil, true, true, 0.15, SFX_PANEL)
	pressPersistTrigger(arg1_1:Find("a1"), 0.5, function()
		arg0_1.value = arg0_1.value + 1

		arg0_1:UpdateValue()
	end, nil, true, true, 0.15, SFX_PANEL)
	pressPersistTrigger(arg1_1:Find("m1"), 0.5, function()
		arg0_1.value = arg0_1.value - 1

		arg0_1:UpdateValue(true)
	end, nil, true, true, 0.15, SFX_PANEL)
end

function var0_0.SetCallBack(arg0_6, arg1_6)
	arg0_6.callback = arg1_6
end

function var0_0.GetItem(arg0_7, arg1_7)
	return getProxy(BagProxy):getItemById(arg1_7) or Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = arg1_7
	})
end

function var0_0.Update(arg0_8, arg1_8)
	arg0_8.value = 0

	local var0_8 = arg0_8:GetItem(arg1_8)

	arg0_8.item = var0_8

	updateDrop(arg0_8.itemTF, {
		type = DROP_TYPE_ITEM,
		id = arg1_8,
		count = var0_8.count
	})

	if var0_8.count == 0 then
		setText(arg0_8.itemTF:Find("icon_bg/count"), 0)
	end

	arg0_8.nameTxt.text = string.format("<color=#%s>%s</color>", ItemRarity.Rarity2HexColor(var0_8:getConfig("rarity")), var0_8:getConfig("name"))

	arg0_8:UpdateValue()
end

function var0_0.UpdateValue(arg0_9, arg1_9)
	arg0_9.value = math.min(arg0_9.value, arg0_9.item.count)
	arg0_9.value = math.max(arg0_9.value, 0)
	arg0_9.valueTxt.text = arg0_9.value

	if arg0_9.callback then
		arg0_9.callback(arg0_9, arg0_9.item.id, arg0_9.value, arg1_9)
	end
end

function var0_0.ForceUpdateValue(arg0_10, arg1_10)
	arg0_10.value = arg1_10
	arg0_10.valueTxt.text = arg0_10.value
end

function var0_0.Dispose(arg0_11)
	pg.DelegateInfo.Dispose(arg0_11)
end

return var0_0
