local var0_0 = class("ShopSkinCard")
local var1_0 = pg.ship_data_group
local var2_0 = pg.shop_template
local var3_0 = pg.skin_page_template
local var4_0 = pg.ship_skin_template

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1._content = arg0_1._tf:Find("ship/content")
	arg0_1._mask = arg0_1._tf:Find("ship/mask")
	arg0_1._icon = arg0_1._tf:Find("ship/content/main/bg/icon"):GetComponent(typeof(Image))
	arg0_1._priceTF = arg0_1._tf:Find("ship/content/main/bg/price")

	setActive(arg0_1._priceTF, false)

	arg0_1._priceIcon = arg0_1._priceTF:Find("gem"):GetComponent(typeof(Image))
	arg0_1._priceTxt = arg0_1._priceTF:Find("gem/Text"):GetComponent(typeof(Text))
	arg0_1._opriceTxt = arg0_1._priceTF:Find("originalprice"):GetComponent(typeof(Text))
	arg0_1._tagTFs = {
		arg0_1._tf:Find("ship/content/top/tags/tag_hot"),
		arg0_1._tf:Find("ship/content/top/tags/tag_new"),
		arg0_1._tf:Find("ship/content/top/tags/tag_advice"),
		arg0_1._tf:Find("ship/content/top/tags/tag_activity"),
		arg0_1._tf:Find("ship/content/top/tags/tag_discount"),
		arg0_1._tf:Find("ship/content/top/tags/tag_nothing"),
		arg0_1._tf:Find("ship/content/top/tags/tag_bought"),
		arg0_1._tf:Find("ship/content/top/tags/tag_limit"),
		arg0_1._tf:Find("ship/content/top/tags/tag_timelimit"),
		arg0_1._tf:Find("ship/content/top/tags/tag_return")
	}

	onButton(nil, arg0_1._go, function()
		arg0_1.view:emit(SkinShopScene.EVENT_ON_CARD_CLICK, arg0_1)
	end, SFX_PANEL)
end

function var0_0.update(arg0_3, arg1_3)
	arg0_3.goodsVO = arg1_3

	local var0_3 = arg1_3:getSkinId()

	arg0_3.shipSkinConfig = var4_0[var0_3]

	local var1_3 = var4_0[var0_3].prefab

	arg0_3._icon.sprite = nil

	LoadSpriteAsync("shipYardIcon/" .. var1_3, function(arg0_4)
		if not IsNil(arg0_3._icon) then
			arg0_3._icon.sprite = arg0_4
		end
	end)

	for iter0_3, iter1_3 in pairs(arg0_3._tagTFs) do
		setActive(iter1_3, false)
	end

	if arg0_3.goodsVO.type == Goods.TYPE_SKIN then
		local var2_3 = arg1_3:getConfig("resource_type")

		arg0_3._priceIcon.sprite = LoadSprite(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var2_3
		}):getIcon())

		local var3_3 = arg1_3:getConfig("resource_num")
		local var4_3 = arg1_3:isDisCount()
		local var5_3, var6_3 = arg1_3:GetPrice()

		arg0_3._priceTxt.text = var5_3
		arg0_3._opriceTxt.text = var3_3

		setActive(go(arg0_3._opriceTxt), var4_3 and var6_3 > 0)

		local var7_3 = arg1_3.buyCount == 0
		local var8_3 = arg1_3:getConfig("genre") == ShopArgs.SkinShopTimeLimit

		if arg0_3.view.encoreSkinMap[arg1_3.id] and var7_3 then
			setActive(arg0_3._tagTFs[10], true)
		elseif var8_3 then
			setActive(arg0_3._tagTFs[9], true)
		elseif var7_3 then
			local var9_3 = arg0_3.goodsVO:getConfig("tag")

			if var4_3 or var9_3 == 5 then
				local var10_3 = arg0_3._tagTFs[5]

				setText(var10_3:Find("Text"), string.format("%0.2f", var6_3) .. "%")
				setActive(arg0_3._tagTFs[5], true)
			elseif arg0_3._tagTFs[var9_3] then
				setActive(arg0_3._tagTFs[var9_3], true)
			else
				setActive(arg0_3._tagTFs[6], true)
			end
		else
			setActive(arg0_3._tagTFs[7], true)
		end
	end

	local var11_3 = 0

	if var0_3 == 302053 then
		var11_3 = 39
	elseif var0_3 == 502052 then
		var11_3 = 60
	end

	setAnchoredPosition(arg0_3._icon.gameObject, {
		y = var11_3
	})
end

function var0_0.updateSelected(arg0_5, arg1_5)
	local var0_5 = arg1_5 and -26 or -126

	arg0_5._content.localPosition = Vector3(0, var0_5, 0)

	local var1_5 = arg0_5.goodsVO.type == Goods.TYPE_SKIN

	setActive(arg0_5._priceTF, arg1_5 and var1_5)
	setActive(arg0_5._mask, not arg1_5)
end

function var0_0.Dispose(arg0_6)
	removeOnButton(arg0_6._go)

	arg0_6._go = nil
	arg0_6._tf = nil
	arg0_6._tagTFs = nil
end

return var0_0
