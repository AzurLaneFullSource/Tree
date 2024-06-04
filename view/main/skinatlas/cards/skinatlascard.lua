local var0 = class("SkinAtlasCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.usingTr = findTF(arg0._tf, "using")
	arg0.unavailableTr = findTF(arg0._tf, "unavailable")
	arg0.icon = findTF(arg0._tf, "mask/icon"):GetComponent(typeof(Image))
	arg0.name = findTF(arg0._tf, "name/Text"):GetComponent(typeof(Text))
	arg0.tags = {
		findTF(arg0._tf, "tags/icon")
	}
end

function var0.Update(arg0, arg1, arg2)
	arg0.index = arg2
	arg0.skin = arg1

	LoadSpriteAtlasAsync("shipYardIcon/" .. arg1:getConfig("painting"), "", function(arg0)
		if arg0.exited then
			return
		end

		arg0.icon.sprite = arg0
	end)

	local var0 = arg1:getConfig("ship_group")
	local var1 = getProxy(BayProxy):findShipsByGroup(var0)
	local var2 = _.any(var1, function(arg0)
		return arg0.skinId == arg1.id
	end)

	setActive(arg0.usingTr, #var1 > 0 and var2)

	local var3 = getProxy(CollectionProxy).shipGroups[var0] == nil

	setActive(arg0.unavailableTr, #var1 == 0 or var3)

	local var4 = arg1:getConfig("name")

	arg0.name.text = shortenString(var4, 7)

	arg0:FlushTags(arg1:getConfig("tag"))
end

function var0.FlushTags(arg0, arg1)
	local var0 = -10
	local var1 = arg0.tags[1]

	for iter0 = #arg0.tags + 1, #arg1 do
		local var2 = Object.Instantiate(var1, var1.parent)

		arg0.tags[iter0] = var2
	end

	for iter1 = 1, #arg1 do
		local var3 = arg0.tags[iter1]

		setActive(var3, true)
		LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(arg1[iter1]), function(arg0)
			if arg0.exited then
				return
			end

			var3:GetComponent(typeof(Image)).sprite = arg0
		end)

		local var4 = var1.localPosition.y - (iter1 - 1) * (var1.sizeDelta.x + var0)

		var3.localPosition = Vector3(var3.localPosition.x, var4, 0)
	end

	for iter2 = #arg1 + 1, #arg0.tags do
		setActive(arg0.tags[iter2], false)
	end
end

function var0.Dispose(arg0)
	arg0.exited = true
end

return var0
