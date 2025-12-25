local var0_0 = class("SkinAtlasCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.usingTr = findTF(arg0_1._tf, "using")
	arg0_1.unavailableTr = findTF(arg0_1._tf, "unavailable")
	arg0_1.have = arg0_1._tf:Find("have")
	arg0_1.icon = findTF(arg0_1._tf, "mask/icon")
	arg0_1.name = findTF(arg0_1._tf, "name/Text"):GetComponent(typeof(Text))
	arg0_1.enName = findTF(arg0_1._tf, "name/en"):GetComponent(typeof(Text))
	arg0_1.tags = findTF(arg0_1._tf, "tags")
	arg0_1.changeSkinUI = findTF(arg0_1._tf, "changeSkin")
	arg0_1.changeSkinToggle = nil

	setText(arg0_1.usingTr:Find("Text"), i18n("shop_new_in_use"))
	setText(arg0_1.unavailableTr:Find("Text"), i18n("shop_new_unable_to_use"))
	setText(arg0_1.have:Find("Text"), i18n("shop_new_owned"))
	setActive()
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.index = arg2_2
	arg0_2.skin = arg1_2

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. arg1_2:getConfig("painting"), "", arg0_2.icon)

	local var0_2 = pg.ship_skin_template[arg0_2.skin.id]
	local var1_2 = false
	local var2_2 = false

	if var0_2.skin_type ~= ShipSkin.SKIN_TYPE_TB then
		local var3_2 = arg1_2:getConfig("ship_group")
		local var4_2 = getProxy(BayProxy):findShipsByGroup(var3_2)
		local var5_2 = not arg1_2:WithoutUse()
		local var6_2

		var6_2 = #var4_2 == 0 or getProxy(CollectionProxy).shipGroups[var3_2] == nil
	end

	setActive(arg0_2.usingTr, var1_2)
	setActive(arg0_2.unavailableTr, var2_2)

	if arg3_2 then
		local var7_2 = getProxy(ShipSkinProxy):hasSkin(arg0_2.skin.id)

		setActive(arg0_2.have, var7_2)
	else
		setActive(arg0_2.have, false)
	end

	local var8_2 = arg1_2:getConfig("name")

	arg0_2.name.text = shortenString(var8_2, 7)

	if var0_2.skin_type == ShipSkin.SKIN_TYPE_TB then
		arg0_2.enName.text = NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_2.skinId))
	else
		local var9_2 = ShipGroup.getDefaultShipConfig(var0_2.ship_group)

		arg0_2.enName.text = var9_2.english_name
	end

	local var10_2 = ShipSkin.GetChangeSkinData(arg0_2.skin.id)

	setActive(arg0_2.changeSkinUI, var10_2 and true or false)

	if var10_2 then
		if not arg0_2.changeSkinToggle then
			arg0_2.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_2.changeSkinUI, "ChangeSkinToggleUI"))
		end

		arg0_2.changeSkinToggle:setSkinData(arg0_2.skin.id)
		setActive(arg0_2.changeSkinUI, not arg0_2.changeSkinToggle:IsAsmrSkin())
	end

	arg0_2:FlushTags(arg1_2:getConfig("tag"))
end

function var0_0.changeSkinNext(arg0_3)
	if ShipSkin.GetChangeSkinData(arg0_3.skin.id) then
		local var0_3 = ShipSkin.GetChangeSkinNextId(arg0_3.skin.id)
		local var1_3 = ShipSkin.New({
			id = var0_3
		})

		arg0_3:Update(var1_3, arg0_3.index)
	end
end

function var0_0.FlushTags(arg0_4, arg1_4)
	local var0_4 = -10
	local var1_4 = findTF(arg0_4._tf, "tags/icon")

	if #arg1_4 > arg0_4.tags.childCount then
		for iter0_4 = arg0_4.tags.childCount + 1, #arg1_4 do
			local var2_4 = Object.Instantiate(var1_4, var1_4.parent)
		end
	end

	for iter1_4 = 1, #arg1_4 do
		local var3_4 = arg0_4.tags:GetChild(iter1_4 - 1)

		setActive(var3_4, true)
		LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(arg1_4[iter1_4]) .. "_own", function(arg0_5)
			if arg0_4.exited then
				return
			end

			local var0_5 = var3_4:GetComponent(typeof(Image))

			var0_5.sprite = arg0_5

			var0_5:SetNativeSize()
		end)

		local var4_4 = var1_4.localPosition.y - (iter1_4 - 1) * (var1_4.sizeDelta.y + var0_4)

		var3_4.localPosition = Vector3(var3_4.localPosition.x, var4_4, 0)
	end

	if arg0_4.tags.childCount > #arg1_4 then
		for iter2_4 = #arg1_4 + 1, arg0_4.tags.childCount do
			setActive(arg0_4.tags:GetChild(iter2_4 - 1), false)
		end
	end
end

function var0_0.Dispose(arg0_6)
	arg0_6.exited = true
end

return var0_0
