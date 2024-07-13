local var0_0 = class("NewShopSkinCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1._content = arg0_1._tf:Find("frame/content")
	arg0_1._mask = arg0_1._tf:Find("frame/mask")
	arg0_1._icon = arg0_1._tf:Find("frame/content/main/bg/icon"):GetComponent(typeof(Image))
	arg0_1._priceTF = arg0_1._tf:Find("frame/content/main/bg/price")

	setActive(arg0_1._priceTF, false)

	arg0_1._priceIcon = arg0_1._priceTF:Find("gem"):GetComponent(typeof(Image))
	arg0_1._priceTxt = arg0_1._priceTF:Find("gem/Text"):GetComponent(typeof(Text))
	arg0_1._opriceTxt = arg0_1._priceTF:Find("originalprice"):GetComponent(typeof(Text))
	arg0_1.tagImg = arg0_1._tf:Find("frame/content/top/tag_activity"):GetComponent(typeof(Image))
	arg0_1.tagEnImg = arg0_1.tagImg.gameObject.transform:Find("Image"):GetComponent(typeof(Image))
	arg0_1.txt = arg0_1._tf:Find("frame/content/top/Text"):GetComponent(typeof(Text))
	arg0_1.txt.text = ""
	arg0_1.discountTag = arg0_1._tf:Find("frame/content/top/tag_discount")
	arg0_1.discountTagOffTxt = arg0_1.discountTag:Find("Text"):GetComponent(typeof(Text))
	arg0_1.timelimitTag = arg0_1._tf:Find("frame/content/top/tag_timelimit")
	arg0_1.isSelected = false
	arg0_1._icon.transform.localScale = Vector3.zero
end

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = -1
local var7_0 = -2
local var8_0 = -3
local var9_0 = -4
local var10_0 = {
	[302053] = 39
}
local var11_0 = {
	[var1_0] = {
		"rexiao",
		"hot_sells"
	},
	[var2_0] = {
		"xinpin",
		"xinpin"
	},
	[var3_0] = {
		"tuijian",
		"tujian"
	},
	[var4_0] = {
		"huodong",
		"huodong"
	},
	[var5_0] = {
		"",
		""
	},
	[var6_0] = {
		"fanchang",
		""
	},
	[var7_0] = {
		"",
		""
	},
	[var8_0] = {
		"yigoumai",
		"clothing"
	},
	[var9_0] = {
		"",
		"clothing"
	}
}

local function var12_0(arg0_2, arg1_2)
	local var0_2 = arg0_2.buyCount == 0

	if arg1_2 and var0_2 then
		return var6_0
	end

	if arg0_2:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return var7_0
	end

	if not var0_2 then
		return var8_0
	end

	local var1_2 = arg0_2:getConfig("tag")

	if (arg0_2:isDisCount() or var1_2 == var5_0) and not arg0_2:IsItemDiscountType() then
		return var5_0
	elseif var11_0[var1_2] then
		return var1_2
	else
		return var9_0
	end
end

function var0_0.Update(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3.commodity = arg1_3
	arg0_3.isReturn = arg3_3

	local var0_3 = arg1_3:getSkinId()
	local var1_3 = pg.ship_skin_template

	arg0_3.shipSkinConfig = var1_3[var0_3]

	local var2_3 = var1_3[var0_3].prefab

	arg0_3._icon.sprite = nil
	arg0_3._icon.transform.localScale = Vector3.zero

	LoadSpriteAsync("shipYardIcon/" .. var2_3, function(arg0_4)
		if not IsNil(arg0_3._icon) then
			arg0_3._icon.sprite = arg0_4
			arg0_3._icon.transform.localScale = Vector3.one
		end
	end)

	local var3_3 = false
	local var4_3 = false
	local var5_3 = arg0_3.commodity.type == Goods.TYPE_SKIN

	if var5_3 then
		local var6_3 = arg1_3:getConfig("resource_type")

		LoadSpriteAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var6_3
		}):getIcon(), function(arg0_5)
			if IsNil(arg0_3._priceIcon) then
				return
			end

			arg0_3._priceIcon.sprite = arg0_5
		end)

		local var7_3 = arg1_3:getConfig("resource_num")
		local var8_3 = arg1_3:isDisCount()
		local var9_3, var10_3 = arg1_3:GetPrice()

		arg0_3._priceTxt.text = var9_3
		arg0_3._opriceTxt.text = var7_3

		setActive(go(arg0_3._opriceTxt), var8_3 and var10_3 > 0)

		local var11_3 = var12_0(arg1_3, arg3_3)

		if var11_3 == var5_0 then
			var3_3 = true
			arg0_3.discountTagOffTxt.text = string.format("%0.2f", var10_3) .. "%"
		elseif var11_3 == var7_0 then
			var4_3 = true

			setActive(arg0_3.timelimitTag, true)
		else
			local var12_3 = var11_0[var11_3][1]
			local var13_3 = var11_0[var11_3][2]

			arg0_3.tagImg.enabled = var12_3 and var12_3 ~= ""

			if arg0_3.tagImg.enabled then
				arg0_3.tagImg.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", "tag_" .. var12_3)
			end

			arg0_3.tagEnImg.enabled = var13_3 and var13_3 ~= ""

			if arg0_3.tagEnImg.enabled then
				arg0_3.tagEnImg.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", "en_text_" .. var13_3 .. "_text")
			end
		end
	end

	setActive(arg0_3.timelimitTag, var5_3 and var4_3)
	setActive(arg0_3.tagImg.gameObject, var5_3 and not var3_3 and not var4_3)
	setActive(arg0_3.discountTag, var5_3 and var3_3)

	local var14_3 = var10_0[var0_3] or 0

	setAnchoredPosition(arg0_3._icon.gameObject, {
		y = var14_3
	})
	arg0_3:UpdateSelected(arg2_3)
end

function var0_0.UpdateSelected(arg0_6, arg1_6)
	if arg0_6.isSelected ~= arg1_6 then
		arg0_6.isSelected = arg1_6

		local var0_6 = arg1_6 and -26 or -126

		arg0_6._content.localPosition = Vector3(0, var0_6, 0)

		local var1_6 = arg0_6.commodity.type == Goods.TYPE_SKIN

		setActive(arg0_6._priceTF, arg1_6 and var1_6)
		setActive(arg0_6._mask, not arg1_6)
	end
end

function var0_0.Dispose(arg0_7)
	arg0_7:UpdateSelected(false)

	arg0_7._icon.transform.localScale = Vector3.one
	arg0_7._go = nil
	arg0_7._tf = nil
end

return var0_0
