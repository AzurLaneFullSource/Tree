local var0 = class("ShopSkinCard")
local var1 = pg.ship_data_group
local var2 = pg.shop_template
local var3 = pg.skin_page_template
local var4 = pg.ship_skin_template

function var0.Ctor(arg0, arg1, arg2)
	arg0.view = arg2
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0._content = arg0._tf:Find("ship/content")
	arg0._mask = arg0._tf:Find("ship/mask")
	arg0._icon = arg0._tf:Find("ship/content/main/bg/icon"):GetComponent(typeof(Image))
	arg0._priceTF = arg0._tf:Find("ship/content/main/bg/price")

	setActive(arg0._priceTF, false)

	arg0._priceIcon = arg0._priceTF:Find("gem"):GetComponent(typeof(Image))
	arg0._priceTxt = arg0._priceTF:Find("gem/Text"):GetComponent(typeof(Text))
	arg0._opriceTxt = arg0._priceTF:Find("originalprice"):GetComponent(typeof(Text))
	arg0._tagTFs = {
		arg0._tf:Find("ship/content/top/tags/tag_hot"),
		arg0._tf:Find("ship/content/top/tags/tag_new"),
		arg0._tf:Find("ship/content/top/tags/tag_advice"),
		arg0._tf:Find("ship/content/top/tags/tag_activity"),
		arg0._tf:Find("ship/content/top/tags/tag_discount"),
		arg0._tf:Find("ship/content/top/tags/tag_nothing"),
		arg0._tf:Find("ship/content/top/tags/tag_bought"),
		arg0._tf:Find("ship/content/top/tags/tag_limit"),
		arg0._tf:Find("ship/content/top/tags/tag_timelimit"),
		arg0._tf:Find("ship/content/top/tags/tag_return")
	}

	onButton(nil, arg0._go, function()
		arg0.view:emit(SkinShopScene.EVENT_ON_CARD_CLICK, arg0)
	end, SFX_PANEL)
end

function var0.update(arg0, arg1)
	arg0.goodsVO = arg1

	local var0 = arg1:getSkinId()

	arg0.shipSkinConfig = var4[var0]

	local var1 = var4[var0].prefab

	arg0._icon.sprite = nil

	LoadSpriteAsync("shipYardIcon/" .. var1, function(arg0)
		if not IsNil(arg0._icon) then
			arg0._icon.sprite = arg0
		end
	end)

	for iter0, iter1 in pairs(arg0._tagTFs) do
		setActive(iter1, false)
	end

	if arg0.goodsVO.type == Goods.TYPE_SKIN then
		local var2 = arg1:getConfig("resource_type")

		arg0._priceIcon.sprite = LoadSprite(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var2
		}):getIcon())

		local var3 = arg1:getConfig("resource_num")
		local var4 = arg1:isDisCount()
		local var5, var6 = arg1:GetPrice()

		arg0._priceTxt.text = var5
		arg0._opriceTxt.text = var3

		setActive(go(arg0._opriceTxt), var4 and var6 > 0)

		local var7 = arg1.buyCount == 0
		local var8 = arg1:getConfig("genre") == ShopArgs.SkinShopTimeLimit

		if arg0.view.encoreSkinMap[arg1.id] and var7 then
			setActive(arg0._tagTFs[10], true)
		elseif var8 then
			setActive(arg0._tagTFs[9], true)
		elseif var7 then
			local var9 = arg0.goodsVO:getConfig("tag")

			if var4 or var9 == 5 then
				local var10 = arg0._tagTFs[5]

				setText(var10:Find("Text"), string.format("%0.2f", var6) .. "%")
				setActive(arg0._tagTFs[5], true)
			elseif arg0._tagTFs[var9] then
				setActive(arg0._tagTFs[var9], true)
			else
				setActive(arg0._tagTFs[6], true)
			end
		else
			setActive(arg0._tagTFs[7], true)
		end
	end

	local var11 = 0

	if var0 == 302053 then
		var11 = 39
	elseif var0 == 502052 then
		var11 = 60
	end

	setAnchoredPosition(arg0._icon.gameObject, {
		y = var11
	})
end

function var0.updateSelected(arg0, arg1)
	local var0 = arg1 and -26 or -126

	arg0._content.localPosition = Vector3(0, var0, 0)

	local var1 = arg0.goodsVO.type == Goods.TYPE_SKIN

	setActive(arg0._priceTF, arg1 and var1)
	setActive(arg0._mask, not arg1)
end

function var0.Dispose(arg0)
	removeOnButton(arg0._go)

	arg0._go = nil
	arg0._tf = nil
	arg0._tagTFs = nil
end

return var0
