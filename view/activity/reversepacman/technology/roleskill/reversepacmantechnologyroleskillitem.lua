local var0_0 = class("ReversePacmanTechnologyRoleSkillItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1
	arg0_1.id = arg3_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
	arg0_1:didEnter()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiBuyBtn, function()
		local var0_3 = pg.activity_shop_template[arg0_2.id]

		arg0_2:emit(ReversePacmanTechnologyMediator.BUY_SHOP_ITEM, {
			activityID = var0_3.activity,
			shopID = arg0_2.id
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiIconBtn, function()
		local var0_4 = pg.activity_shop_template[arg0_2.id]
		local var1_4 = Drop.New({
			type = var0_4.commodity_type,
			id = var0_4.commodity_id
		})

		arg0_2:emit(BaseUI.ON_DROP, var1_4)
	end, SFX_PANEL)
	setText(arg0_2.uiBuyText, i18n("reverse_pacman_buy"))
	setText(arg0_2.uiBuyText2, i18n("reverse_pacman_buy"))
	setText(arg0_2.uiSoldOutText, i18n("reverse_pacman_sold_out"))
end

function var0_0.didEnter(arg0_5)
	arg0_5:RefreshUI()
end

function var0_0.RefreshUI(arg0_6)
	local var0_6 = pg.activity_shop_template[arg0_6.id]
	local var1_6 = Drop.New({
		type = var0_6.commodity_type,
		id = var0_6.commodity_id
	})
	local var2_6 = ReversePacmanTools.GetActivity():getConfig("config_client").shopActivityID
	local var3_6 = getProxy(ShopsProxy):getActivityShopById(var2_6).goods[arg0_6.id]

	setText(arg0_6.uiNameText, var1_6:getConfig("name") .. string.format("(%s/%s)", var3_6:getBuyCount(), var0_6.num_limit))
	setText(arg0_6.uiDescText, var1_6:getConfig("display"))

	local var4_6 = GetSpriteFromAtlas(var1_6:getIcon(), "")

	setImageSprite(arg0_6.uiIconImage, var4_6)

	local var5_6 = Drop.New({
		type = var0_6.resource_category,
		id = var0_6.resource_type
	})
	local var6_6 = getProxy(ShopsProxy):getActivityShopById(var0_6.activity):getGoodsById(arg0_6.id)

	setText(arg0_6.uiCurrencyCntText, var0_6.resource_num)

	if not var6_6:CheckCntLimit() then
		setTextColor(arg0_6.uiCurrencyCntText, Color.NewHex("#313131"))
		setActive(arg0_6.uiSoldOutGo, true)
		setActive(arg0_6.uiGreyGo, false)
		setActive(arg0_6.uiBuyGo, false)
	elseif var5_6:getOwnedCount() < var0_6.resource_num then
		setTextColor(arg0_6.uiCurrencyCntText, Color.NewHex("#d45e5e"))
		setActive(arg0_6.uiSoldOutGo, false)
		setActive(arg0_6.uiGreyGo, true)
		setActive(arg0_6.uiBuyGo, false)
	else
		setTextColor(arg0_6.uiCurrencyCntText, Color.NewHex("#313131"))
		setActive(arg0_6.uiSoldOutGo, false)
		setActive(arg0_6.uiGreyGo, false)
		setActive(arg0_6.uiBuyGo, true)
	end

	setImageSprite(arg0_6.uiCurrencyImage, GetSpriteFromAtlas(var5_6:getIcon(), ""))
end

function var0_0.willExit(arg0_7)
	arg0_7:detach()
	Object.Destroy(arg0_7._go)

	arg0_7._go = nil
	arg0_7._tf = nil
end

return var0_0
