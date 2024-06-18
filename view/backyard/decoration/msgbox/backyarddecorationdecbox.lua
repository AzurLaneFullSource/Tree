local var0_0 = class("BackYardDecorationDecBox", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BackYardDecorationDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameTxt = arg0_2:findTF("name_bg/Text"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("Text"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2:findTF("icon_bg/icon"):GetComponent(typeof(Image))
	arg0_2.shipIcon = arg0_2:findTF("icon_bg/ship"):GetComponent(typeof(Image))
	arg0_2.width = arg0_2._tf.rect.width
	arg0_2.prantLeftBound = arg0_2._tf.parent.rect.width / 2
end

function var0_0.shortenString(arg0_3, arg1_3, arg2_3)
	local var0_3 = string.gmatch(arg1_3, "<color=#%w+>")()
	local var1_3, var2_3 = string.find(arg1_3, "<color=#%w+>")

	if not var1_3 then
		return shortenString(arg1_3, arg2_3)
	end

	local var3_3, var4_3 = string.find(arg1_3, "</color>")
	local var5_3 = string.sub(arg1_3, 1, var1_3 - 1)
	local var6_3 = string.sub(arg1_3, var2_3 + 1, var3_3 - 1)
	local var7_3 = string.sub(arg1_3, var4_3 + 1, string.len(arg1_3))
	local var8_3 = ""
	local var9_3 = 0

	for iter0_3, iter1_3 in ipairs({
		var5_3,
		var6_3,
		var7_3
	}) do
		var8_3 = var8_3 .. iter1_3
		var9_3 = iter0_3

		if shouldShortenString(var8_3, arg2_3) then
			break
		end
	end

	if var9_3 <= 1 then
		return shortenString(var8_3, arg2_3)
	else
		local var10_3 = shortenString(var8_3, arg2_3)

		if var5_3 == "" then
			return string.gsub(var10_3, var6_3, var0_3 .. var6_3) .. "</color>"
		else
			return string.gsub(var10_3, var5_3, var5_3 .. var0_3) .. "</color>"
		end
	end
end

function var0_0.SetUp(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg0_4.furniture ~= arg1_4 then
		arg0_4.nameTxt.text = shortenString(HXSet.hxLan(arg1_4:getConfig("name")), 10)

		local var0_4 = arg0_4:shortenString(HXSet.hxLan(arg1_4:getConfig("describe")), 41)

		arg0_4.descTxt.text = var0_4
		arg0_4.icon.sprite = LoadSprite("furnitureicon/" .. arg1_4:getConfig("icon"))

		arg0_4.icon:SetNativeSize()
	end

	arg0_4._tf.position = arg2_4

	if arg3_4 then
		local var1_4 = arg0_4._tf.localPosition

		arg0_4._tf.localPosition = Vector3(var1_4.x, var1_4.y - arg0_4._tf.rect.height, 0)
	end

	if arg0_4._tf.localPosition.x + arg0_4.width > arg0_4.prantLeftBound then
		local var2_4 = arg0_4._tf.localPosition

		arg0_4._tf.localPosition = Vector3(var2_4.x - arg0_4.width, var2_4.y, var2_4.z)
	end

	arg0_4.furniture = arg1_4

	arg0_4:UpdateSkinType()
	arg0_4:Show()
end

function var0_0.UpdateSkinType(arg0_5)
	local var0_5 = Goods.FurnitureId2Id(arg0_5.furniture.id)
	local var1_5 = Goods.ExistFurniture(var0_5)

	setActive(arg0_5.shipIcon, var1_5)

	if var1_5 then
		local var2_5 = Goods.GetFurnitureConfig(var0_5)
		local var3_5 = Goods.Id2ShipSkinId(var2_5.id)
		local var4_5 = pg.ship_skin_template[var3_5].prefab

		GetImageSpriteFromAtlasAsync("QIcon/" .. var4_5, "", arg0_5.shipIcon.gameObject)
	end
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
