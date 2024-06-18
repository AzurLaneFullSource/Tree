local var0_0 = class("SkinAtlasCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.usingTr = findTF(arg0_1._tf, "using")
	arg0_1.unavailableTr = findTF(arg0_1._tf, "unavailable")
	arg0_1.icon = findTF(arg0_1._tf, "mask/icon"):GetComponent(typeof(Image))
	arg0_1.name = findTF(arg0_1._tf, "name/Text"):GetComponent(typeof(Text))
	arg0_1.tags = {
		findTF(arg0_1._tf, "tags/icon")
	}
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.index = arg2_2
	arg0_2.skin = arg1_2

	LoadSpriteAtlasAsync("shipYardIcon/" .. arg1_2:getConfig("painting"), "", function(arg0_3)
		if arg0_2.exited then
			return
		end

		arg0_2.icon.sprite = arg0_3
	end)

	local var0_2 = arg1_2:getConfig("ship_group")
	local var1_2 = getProxy(BayProxy):findShipsByGroup(var0_2)
	local var2_2 = _.any(var1_2, function(arg0_4)
		return arg0_4.skinId == arg1_2.id
	end)

	setActive(arg0_2.usingTr, #var1_2 > 0 and var2_2)

	local var3_2 = getProxy(CollectionProxy).shipGroups[var0_2] == nil

	setActive(arg0_2.unavailableTr, #var1_2 == 0 or var3_2)

	local var4_2 = arg1_2:getConfig("name")

	arg0_2.name.text = shortenString(var4_2, 7)

	arg0_2:FlushTags(arg1_2:getConfig("tag"))
end

function var0_0.FlushTags(arg0_5, arg1_5)
	local var0_5 = -10
	local var1_5 = arg0_5.tags[1]

	for iter0_5 = #arg0_5.tags + 1, #arg1_5 do
		local var2_5 = Object.Instantiate(var1_5, var1_5.parent)

		arg0_5.tags[iter0_5] = var2_5
	end

	for iter1_5 = 1, #arg1_5 do
		local var3_5 = arg0_5.tags[iter1_5]

		setActive(var3_5, true)
		LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(arg1_5[iter1_5]), function(arg0_6)
			if arg0_5.exited then
				return
			end

			var3_5:GetComponent(typeof(Image)).sprite = arg0_6
		end)

		local var4_5 = var1_5.localPosition.y - (iter1_5 - 1) * (var1_5.sizeDelta.x + var0_5)

		var3_5.localPosition = Vector3(var3_5.localPosition.x, var4_5, 0)
	end

	for iter2_5 = #arg1_5 + 1, #arg0_5.tags do
		setActive(arg0_5.tags[iter2_5], false)
	end
end

function var0_0.Dispose(arg0_7)
	arg0_7.exited = true
end

return var0_0
