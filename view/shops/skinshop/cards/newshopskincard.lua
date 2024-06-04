local var0 = class("NewShopSkinCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0._content = arg0._tf:Find("frame/content")
	arg0._mask = arg0._tf:Find("frame/mask")
	arg0._icon = arg0._tf:Find("frame/content/main/bg/icon"):GetComponent(typeof(Image))
	arg0._priceTF = arg0._tf:Find("frame/content/main/bg/price")

	setActive(arg0._priceTF, false)

	arg0._priceIcon = arg0._priceTF:Find("gem"):GetComponent(typeof(Image))
	arg0._priceTxt = arg0._priceTF:Find("gem/Text"):GetComponent(typeof(Text))
	arg0._opriceTxt = arg0._priceTF:Find("originalprice"):GetComponent(typeof(Text))
	arg0.tagImg = arg0._tf:Find("frame/content/top/tag_activity"):GetComponent(typeof(Image))
	arg0.tagEnImg = arg0.tagImg.gameObject.transform:Find("Image"):GetComponent(typeof(Image))
	arg0.txt = arg0._tf:Find("frame/content/top/Text"):GetComponent(typeof(Text))
	arg0.txt.text = ""
	arg0.discountTag = arg0._tf:Find("frame/content/top/tag_discount")
	arg0.discountTagOffTxt = arg0.discountTag:Find("Text"):GetComponent(typeof(Text))
	arg0.timelimitTag = arg0._tf:Find("frame/content/top/tag_timelimit")
	arg0.isSelected = false
	arg0._icon.transform.localScale = Vector3.zero
end

local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = -1
local var7 = -2
local var8 = -3
local var9 = -4
local var10 = {
	[302053] = 39
}
local var11 = {
	[var1] = {
		"rexiao",
		"hot_sells"
	},
	[var2] = {
		"xinpin",
		"xinpin"
	},
	[var3] = {
		"tuijian",
		"tujian"
	},
	[var4] = {
		"huodong",
		"huodong"
	},
	[var5] = {
		"",
		""
	},
	[var6] = {
		"fanchang",
		""
	},
	[var7] = {
		"",
		""
	},
	[var8] = {
		"yigoumai",
		"clothing"
	},
	[var9] = {
		"",
		"clothing"
	}
}

local function var12(arg0, arg1)
	local var0 = arg0.buyCount == 0

	if arg1 and var0 then
		return var6
	end

	if arg0:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var7
	end

	if not var0 then
		return var8
	end

	local var1 = arg0:getConfig("tag")

	if (arg0:isDisCount() or var1 == var5) and not arg0:IsItemDiscountType() then
		return var5
	elseif var11[var1] then
		return var1
	else
		return var9
	end
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0.commodity = arg1
	arg0.isReturn = arg3

	local var0 = arg1:getSkinId()
	local var1 = pg.ship_skin_template

	arg0.shipSkinConfig = var1[var0]

	local var2 = var1[var0].prefab

	arg0._icon.sprite = nil
	arg0._icon.transform.localScale = Vector3.zero

	LoadSpriteAsync("shipYardIcon/" .. var2, function(arg0)
		if not IsNil(arg0._icon) then
			arg0._icon.sprite = arg0
			arg0._icon.transform.localScale = Vector3.one
		end
	end)

	local var3 = false
	local var4 = false
	local var5 = arg0.commodity.type == Goods.TYPE_SKIN

	if var5 then
		local var6 = arg1:getConfig("resource_type")

		LoadSpriteAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var6
		}):getIcon(), function(arg0)
			if IsNil(arg0._priceIcon) then
				return
			end

			arg0._priceIcon.sprite = arg0
		end)

		local var7 = arg1:getConfig("resource_num")
		local var8 = arg1:isDisCount()
		local var9, var10 = arg1:GetPrice()

		arg0._priceTxt.text = var9
		arg0._opriceTxt.text = var7

		setActive(go(arg0._opriceTxt), var8 and var10 > 0)

		local var11 = var12(arg1, arg3)

		if var11 == var5 then
			var3 = true
			arg0.discountTagOffTxt.text = string.format("%0.2f", var10) .. "%"
		elseif var11 == var7 then
			var4 = true

			setActive(arg0.timelimitTag, true)
		else
			local var12 = var11[var11][1]
			local var13 = var11[var11][2]

			arg0.tagImg.enabled = var12 and var12 ~= ""

			if arg0.tagImg.enabled then
				arg0.tagImg.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", "tag_" .. var12)
			end

			arg0.tagEnImg.enabled = var13 and var13 ~= ""

			if arg0.tagEnImg.enabled then
				arg0.tagEnImg.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", "en_text_" .. var13 .. "_text")
			end
		end
	end

	setActive(arg0.timelimitTag, var5 and var4)
	setActive(arg0.tagImg.gameObject, var5 and not var3 and not var4)
	setActive(arg0.discountTag, var5 and var3)

	local var14 = var10[var0] or 0

	setAnchoredPosition(arg0._icon.gameObject, {
		y = var14
	})
	arg0:UpdateSelected(arg2)
end

function var0.UpdateSelected(arg0, arg1)
	if arg0.isSelected ~= arg1 then
		arg0.isSelected = arg1

		local var0 = arg1 and -26 or -126

		arg0._content.localPosition = Vector3(0, var0, 0)

		local var1 = arg0.commodity.type == Goods.TYPE_SKIN

		setActive(arg0._priceTF, arg1 and var1)
		setActive(arg0._mask, not arg1)
	end
end

function var0.Dispose(arg0)
	arg0:UpdateSelected(false)

	arg0._icon.transform.localScale = Vector3.one
	arg0._go = nil
	arg0._tf = nil
end

return var0
