local var0 = class("BackYardDecorationDecBox", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "BackYardDecorationDescUI"
end

function var0.OnLoaded(arg0)
	arg0.nameTxt = arg0:findTF("name_bg/Text"):GetComponent(typeof(Text))
	arg0.descTxt = arg0:findTF("Text"):GetComponent(typeof(Text))
	arg0.icon = arg0:findTF("icon_bg/icon"):GetComponent(typeof(Image))
	arg0.shipIcon = arg0:findTF("icon_bg/ship"):GetComponent(typeof(Image))
	arg0.width = arg0._tf.rect.width
	arg0.prantLeftBound = arg0._tf.parent.rect.width / 2
end

function var0.shortenString(arg0, arg1, arg2)
	local var0 = string.gmatch(arg1, "<color=#%w+>")()
	local var1, var2 = string.find(arg1, "<color=#%w+>")

	if not var1 then
		return shortenString(arg1, arg2)
	end

	local var3, var4 = string.find(arg1, "</color>")
	local var5 = string.sub(arg1, 1, var1 - 1)
	local var6 = string.sub(arg1, var2 + 1, var3 - 1)
	local var7 = string.sub(arg1, var4 + 1, string.len(arg1))
	local var8 = ""
	local var9 = 0

	for iter0, iter1 in ipairs({
		var5,
		var6,
		var7
	}) do
		var8 = var8 .. iter1
		var9 = iter0

		if shouldShortenString(var8, arg2) then
			break
		end
	end

	if var9 <= 1 then
		return shortenString(var8, arg2)
	else
		local var10 = shortenString(var8, arg2)

		if var5 == "" then
			return string.gsub(var10, var6, var0 .. var6) .. "</color>"
		else
			return string.gsub(var10, var5, var5 .. var0) .. "</color>"
		end
	end
end

function var0.SetUp(arg0, arg1, arg2, arg3)
	if arg0.furniture ~= arg1 then
		arg0.nameTxt.text = shortenString(HXSet.hxLan(arg1:getConfig("name")), 10)

		local var0 = arg0:shortenString(HXSet.hxLan(arg1:getConfig("describe")), 41)

		arg0.descTxt.text = var0
		arg0.icon.sprite = LoadSprite("furnitureicon/" .. arg1:getConfig("icon"))

		arg0.icon:SetNativeSize()
	end

	arg0._tf.position = arg2

	if arg3 then
		local var1 = arg0._tf.localPosition

		arg0._tf.localPosition = Vector3(var1.x, var1.y - arg0._tf.rect.height, 0)
	end

	if arg0._tf.localPosition.x + arg0.width > arg0.prantLeftBound then
		local var2 = arg0._tf.localPosition

		arg0._tf.localPosition = Vector3(var2.x - arg0.width, var2.y, var2.z)
	end

	arg0.furniture = arg1

	arg0:UpdateSkinType()
	arg0:Show()
end

function var0.UpdateSkinType(arg0)
	local var0 = Goods.FurnitureId2Id(arg0.furniture.id)
	local var1 = Goods.ExistFurniture(var0)

	setActive(arg0.shipIcon, var1)

	if var1 then
		local var2 = Goods.GetFurnitureConfig(var0)
		local var3 = Goods.Id2ShipSkinId(var2.id)
		local var4 = pg.ship_skin_template[var3].prefab

		GetImageSpriteFromAtlasAsync("QIcon/" .. var4, "", arg0.shipIcon.gameObject)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
