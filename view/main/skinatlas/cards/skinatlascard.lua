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
	arg0_1.changeSkinUI = findTF(arg0_1._tf, "changeSkin")
	arg0_1.changeSkinToggle = nil
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
		return ShipGroup.IsSameChangeSkinGroup(arg0_4.skinId, arg1_2.id) or arg0_4.skinId == arg1_2.id
	end)

	setActive(arg0_2.usingTr, #var1_2 > 0 and var2_2)

	local var3_2 = getProxy(CollectionProxy).shipGroups[var0_2] == nil

	setActive(arg0_2.unavailableTr, #var1_2 == 0 or var3_2)

	local var4_2 = arg1_2:getConfig("name")

	arg0_2.name.text = shortenString(var4_2, 7)

	local var5_2 = ShipGroup.GetChangeSkinData(arg0_2.skin.id)

	setActive(arg0_2.changeSkinUI, var5_2 and true or false)

	if var5_2 then
		if not arg0_2.changeSkinToggle then
			arg0_2.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_2.changeSkinUI, "ChangeSkinToggleUI"))
		end

		arg0_2.changeSkinToggle:setSkinData(arg0_2.skin.id)
	end

	arg0_2:FlushTags(arg1_2:getConfig("tag"))
end

function var0_0.changeSkinNext(arg0_5)
	if ShipGroup.GetChangeSkinData(arg0_5.skin.id) then
		local var0_5 = ShipGroup.GetChangeSkinNextId(arg0_5.skin.id)
		local var1_5 = ShipSkin.New({
			id = var0_5
		})

		arg0_5:Update(var1_5, arg0_5.index)
	end
end

function var0_0.FlushTags(arg0_6, arg1_6)
	local var0_6 = -10
	local var1_6 = arg0_6.tags[1]

	for iter0_6 = #arg0_6.tags + 1, #arg1_6 do
		local var2_6 = Object.Instantiate(var1_6, var1_6.parent)

		arg0_6.tags[iter0_6] = var2_6
	end

	for iter1_6 = 1, #arg1_6 do
		local var3_6 = arg0_6.tags[iter1_6]

		setActive(var3_6, true)
		LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(arg1_6[iter1_6]), function(arg0_7)
			if arg0_6.exited then
				return
			end

			var3_6:GetComponent(typeof(Image)).sprite = arg0_7
		end)

		local var4_6 = var1_6.localPosition.y - (iter1_6 - 1) * (var1_6.sizeDelta.x + var0_6)

		var3_6.localPosition = Vector3(var3_6.localPosition.x, var4_6, 0)
	end

	for iter2_6 = #arg1_6 + 1, #arg0_6.tags do
		setActive(arg0_6.tags[iter2_6], false)
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8.exited = true
end

return var0_0
