local var0_0 = class("NewRecommendationShopLayer", import("...base.BaseUI"))
local var1_0 = pg.shop_banner_template

function var0_0.getUIName(arg0_1)
	return "NewRecommendationShopUI"
end

function var0_0.getGroupName(arg0_2)
	return "NewShopMainScene"
end

function var0_0.init(arg0_3)
	arg0_3.resources = arg0_3._tf:Find("adapt/top/resources")
	arg0_3.banners = {}
	arg0_3.banners.banner_big = BannerScrollRectDorm3dShop.New(arg0_3._tf:Find("panel/banner_big/banner/mask/content"), arg0_3._tf:Find("panel/banner_big/banner/dots"))
	arg0_3.banners.banner_middle = BannerScrollRectDorm3dShop.New(arg0_3._tf:Find("panel/banner_middle/banner/mask/content"), arg0_3._tf:Find("panel/banner_middle/banner/dots"))
	arg0_3.banners.banner_small1 = BannerScrollRectDorm3dShop.New(arg0_3._tf:Find("panel/banner_small1/banner/mask/content"), arg0_3._tf:Find("panel/banner_small1/banner/dots"))
	arg0_3.banners.banner_small2 = BannerScrollRectDorm3dShop.New(arg0_3._tf:Find("panel/banner_small2/banner/mask/content"), arg0_3._tf:Find("panel/banner_small2/banner/dots"))
	arg0_3.banners.banner_small3 = BannerScrollRectDorm3dShop.New(arg0_3._tf:Find("panel/banner_small3/banner/mask/content"), arg0_3._tf:Find("panel/banner_small3/banner/dots"))

	setText(arg0_3._tf:Find("panel/banner_big/banner/mask/content/item/time/remainTime"), i18n("shop_new_during_time"))
	setText(arg0_3._tf:Find("panel/banner_small2/banner/mask/content/item/monthCard/day"), i18n("shop_new_daily"))
	setText(arg0_3._tf:Find("panel/banner_middle/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_3._tf:Find("panel/banner_small1/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_3._tf:Find("panel/banner_small2/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_3._tf:Find("panel/banner_small2/banner/mask/content/item/monthCard/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_3._tf:Find("panel/banner_small3/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
end

function var0_0.didEnter(arg0_4)
	arg0_4:InitData()
	arg0_4:ShowResUI()
	arg0_4:SetPanel()
	arg0_4:OverlayPanel(arg0_4._tf)
end

function var0_0.InitData(arg0_5)
	arg0_5.shopsProxy = getProxy(ShopsProxy)

	local var0_5 = arg0_5.shopsProxy:getChargedList()
	local var1_5 = arg0_5.shopsProxy:GetNormalList()
	local var2_5 = arg0_5.shopsProxy:GetNormalGroupList()

	arg0_5.commodities = {
		{},
		{},
		{}
	}

	for iter0_5, iter1_5 in ipairs(var1_0.all) do
		local var3_5 = var1_0[iter1_5]

		if pg.TimeMgr.GetInstance():inTime(var3_5.time) and var3_5.relation_param ~= "" then
			local var4_5 = var3_5.relation_param[1]
			local var5_5 = var3_5.relation_param[2]
			local var6_5

			if var4_5 == 1 then
				var6_5 = Goods.Create({
					id = var5_5
				}, Goods.TYPE_CHARGE)

				local var7_5 = ChargeConst.getBuyCount(var0_5, var5_5)

				var6_5:updateBuyCount(var7_5)
			elseif var4_5 == 2 then
				var6_5 = Goods.Create({
					id = var5_5
				}, Goods.TYPE_GIFT_PACKAGE)

				local var8_5 = ChargeConst.getBuyCount(var1_5, var5_5)

				var6_5:updateBuyCount(var8_5)

				local var9_5 = ChargeConst.getGroupLimit(var2_5, var6_5:getConfig("group") or 0)

				var6_5:updateGroupCount(var9_5)
			elseif var4_5 == 3 then
				var6_5 = Goods.Create({
					id = var5_5
				}, Goods.TYPE_SKIN)

				local var10_5 = ChargeConst.getBuyCount(var1_5, var5_5)

				var6_5:updateBuyCount(var10_5)

				local var11_5 = ChargeConst.getGroupLimit(var2_5, var6_5:getConfig("group") or 0)

				var6_5:updateGroupCount(var11_5)
			end

			arg0_5.commodities[var4_5][var5_5] = var6_5
		end
	end

	local var12_5 = pg.gameset.shop_banner_capacity.key_value

	arg0_5.bnIds = Clone(var1_0.get_id_list_by_name)

	local var13_5 = getProxy(PlayerProxy):getRawData()

	arg0_5.bnIds.banner_big = underscore.filter(arg0_5.bnIds.banner_big, function(arg0_6)
		return ShopsProxy.SpecialBannerBlockCheck(var1_0[arg0_6], var13_5)
	end)

	for iter2_5, iter3_5 in pairs(arg0_5.bnIds) do
		table.sort(iter3_5, CompareFuncs({
			function(arg0_7)
				return -var1_0[arg0_7].order
			end,
			function(arg0_8)
				return arg0_8
			end
		}))

		for iter4_5 = #iter3_5, 1, -1 do
			local var14_5 = var1_0[iter3_5[iter4_5]]

			if not pg.TimeMgr.GetInstance():inTime(var14_5.time) then
				table.remove(iter3_5, iter4_5)
			elseif var14_5.relation_param ~= "" then
				local var15_5 = var14_5.relation_param[1]
				local var16_5 = var14_5.relation_param[2]
				local var17_5 = arg0_5.commodities[var15_5][var16_5]

				if var15_5 == 1 then
					if not var17_5:inTime() or not var17_5:canPurchase() then
						table.remove(iter3_5, iter4_5)
					end
				elseif (var15_5 == 2 or var15_5 == 3) and (not var17_5:inTime() or not var17_5:canPurchase() or var17_5:IsGroupLimit()) then
					table.remove(iter3_5, iter4_5)
				end
			end
		end

		if #iter3_5 > 1 then
			table.remove(iter3_5, #iter3_5)
		end

		if var12_5 < #iter3_5 then
			for iter5_5 = #iter3_5, var12_5 + 1, -1 do
				table.remove(iter3_5, iter5_5)
			end
		end
	end
end

function var0_0.ShowResUI(arg0_9)
	local var0_9 = getProxy(PlayerProxy):getRawData()

	arg0_9.goldMax = arg0_9.resources:Find("gold/max"):GetComponent(typeof(Text))
	arg0_9.goldValue = arg0_9.resources:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_9.oilMax = arg0_9.resources:Find("oil/max"):GetComponent(typeof(Text))
	arg0_9.oilValue = arg0_9.resources:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_9.gemValue = arg0_9.resources:Find("gem/Text"):GetComponent(typeof(Text))

	PlayerResUI.StaticFlush(var0_9, arg0_9.goldMax, arg0_9.goldValue, arg0_9.oilMax, arg0_9.oilValue, arg0_9.gemValue)
	onButton(arg0_9, arg0_9.resources:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.resources:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.SetPanel(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.banners) do
		for iter2_13, iter3_13 in ipairs(arg0_13.bnIds[iter0_13]) do
			local var0_13 = var1_0[iter3_13]
			local var1_13 = iter1_13:AddChild()

			GetImageSpriteFromAtlasAsync(var0_13.pic, "", var1_13:Find("picture"))
			setActive(var1_13:Find("detail"), var0_13.relation_param ~= "")
			setActive(var1_13:Find("time"), var0_13.time_lable == 1)

			if iter0_13 == "banner_small2" then
				setActive(var1_13:Find("monthCard"), false)
				setActive(var1_13:Find("monthCardhave"), false)
			end

			if var0_13.relation_param ~= "" then
				local var2_13 = var0_13.relation_param[1]
				local var3_13 = var0_13.relation_param[2]
				local var4_13 = arg0_13.commodities[var2_13][var3_13]

				if iter0_13 == "banner_small2" and var2_13 == 1 and var4_13:isMonthCard() then
					setActive(var1_13:Find("detail"), false)
					setActive(var1_13:Find("monthCard"), true)
					setText(var1_13:Find("monthCard/name"), var4_13:getConfig("name_display"))
					GetImageSpriteFromAtlasAsync("chargeicon/" .. var4_13:getConfig("picture"), "", var1_13:Find("monthCard/icon"))
					setText(var1_13:Find("monthCard/get"), i18n("shop_new_get_now", var4_13:GetGemCnt()))

					local var5_13 = var4_13:GetDropList()

					while #var5_13 > 3 do
						table.remove(var5_13, #var5_13)
					end

					local var6_13 = UIItemList.New(var1_13:Find("monthCard/items"), var1_13:Find("monthCard/items/item"))

					var6_13:make(function(arg0_14, arg1_14, arg2_14)
						if arg0_14 == UIItemList.EventUpdate then
							local var0_14 = var5_13[arg1_14 + 1]

							updateDrop(arg2_14:Find("mask/item"), var0_14)
						end
					end)
					var6_13:align(#var5_13)

					local var7_13 = var2_13 == 1 and var4_13:getShowType() ~= ""
					local var8_13 = var4_13:isFree()

					setText(var1_13:Find("monthCard/consume/icon_rmb"), GetMoneySymbol())
					setActive(var1_13:Find("monthCard/consume/icon_rmb"), var2_13 == 1 and not var7_13)

					if PLATFORM_CODE == PLATFORM_CHT and var4_13:IsLocalPrice() then
						setActive(var1_13:Find("monthCard/consume/icon_rmb"), false)
					end

					setActive(var1_13:Find("monthCard/consume/icon_gem"), var2_13 ~= 1 and not var8_13)
					setActive(var1_13:Find("monthCard/consume/Text"), not var8_13 and not var7_13)

					if var2_13 == 1 then
						setText(var1_13:Find("monthCard/consume/Text"), var4_13:getConfig("money"))
					elseif var2_13 == 2 then
						setText(var1_13:Find("monthCard/consume/Text"), var4_13:GetPrice())
					end

					setActive(var1_13:Find("monthCard/consume/FreeText"), var8_13)
					setText(var1_13:Find("monthCard/consume/FreeText"), i18n("shop_free_tag"))

					local var9_13 = getProxy(PlayerProxy):getRawData():getCardById(VipCard.MONTH)
					local var10_13 = var9_13 and var9_13:GetLeftDay() > (var4_13:getConfig("limit_arg") or 0)

					setActive(var1_13:Find("monthCardhave"), var10_13)

					if var10_13 then
						setText(var1_13:Find("monthCardhave/Text"), i18n("shop_new_remaining_time", var9_13:GetLeftDay()))
					end
				else
					if var2_13 == 1 then
						setText(var1_13:Find("detail/name"), var4_13:getConfig("name_display"))
						GetImageSpriteFromAtlasAsync("chargeicon/" .. var4_13:getConfig("picture"), "", var1_13:Find("detail/icon"))
					elseif var2_13 == 2 then
						setText(var1_13:Find("detail/name"), var4_13:GetName())
						GetImageSpriteFromAtlasAsync(var4_13:getDropInfo():getIcon(), "", var1_13:Find("detail/icon"))
					end

					local var11_13 = var4_13:GetDropList()

					while #var11_13 > 3 do
						table.remove(var11_13, #var11_13)
					end

					local var12_13 = UIItemList.New(var1_13:Find("detail/items"), var1_13:Find("detail/items/item"))

					var12_13:make(function(arg0_15, arg1_15, arg2_15)
						if arg0_15 == UIItemList.EventUpdate then
							local var0_15 = var11_13[arg1_15 + 1]

							updateDrop(arg2_15:Find("mask/item"), var0_15)
						end
					end)
					var12_13:align(#var11_13)

					local var13_13 = var2_13 == 1 and var4_13:getShowType() ~= ""
					local var14_13 = var4_13:isFree()

					setText(var1_13:Find("detail/consume/icon_rmb"), GetMoneySymbol())
					setActive(var1_13:Find("detail/consume/icon_rmb"), var2_13 == 1 and not var13_13)

					if PLATFORM_CODE == PLATFORM_CHT and var4_13:IsLocalPrice() then
						setActive(var1_13:Find("detail/consume/icon_rmb"), false)
					end

					setActive(var1_13:Find("detail/consume/icon_gem"), var2_13 ~= 1 and not var14_13)
					setActive(var1_13:Find("detail/consume/Text"), not var14_13 and not var13_13)

					if var2_13 == 1 then
						setText(var1_13:Find("detail/consume/Text"), var4_13:getConfig("money"))
					elseif var2_13 == 2 then
						setText(var1_13:Find("detail/consume/Text"), var4_13:GetPrice())
					end

					setActive(var1_13:Find("detail/consume/FreeText"), var14_13)
					setText(var1_13:Find("detail/consume/FreeText"), i18n("shop_free_tag"))
				end
			end

			if var0_13.time_lable == 1 then
				local var15_13 = var0_13.time[2]
				local var16_13 = pg.TimeMgr.GetInstance():Table2ServerTime({
					year = var15_13[1][1],
					month = var15_13[1][2],
					day = var15_13[1][3],
					hour = var15_13[2][1],
					min = var15_13[2][2],
					sec = var15_13[2][3]
				})

				arg0_13:StartTimer(function()
					local var0_16 = pg.TimeMgr.GetInstance():GetServerTime()
					local var1_16 = var16_13 - var0_16
					local var2_16 = math.floor(var1_16 / 86400)
					local var3_16 = math.floor(var1_16 % 86400 / 3600)
					local var4_16 = math.floor(var1_16 % 86400 % 3600 / 60)

					if iter0_13 == "banner_big" then
						setText(var1_13:Find("time/text"), i18n("shop_countdown", var2_16, var3_16, var4_16))
					elseif var2_16 > 0 then
						setText(var1_13:Find("time/text"), i18n("shop_new_during_day", var2_16))
					elseif var3_16 > 0 then
						setText(var1_13:Find("time/text"), i18n("shop_new_during_hour", var3_16))
					else
						setText(var1_13:Find("time/text"), i18n("shop_new_during_minite", var4_16))
					end
				end)
			end

			onButton(arg0_13, var1_13, function()
				arg0_13:emit(NewRecommendationShopMediator.GO_SHOP, var0_13.param[1], var0_13.param[2])
			end, SFX_PANEL)
		end

		iter1_13:SetUp()
		setActive(arg0_13._tf:Find("panel/" .. iter0_13 .. "/banner/dots"), #arg0_13.bnIds[iter0_13] > 1)
	end
end

function var0_0.StartTimer(arg0_18, arg1_18)
	if not arg0_18.timers then
		arg0_18.timers = {}
	end

	arg1_18()

	local var0_18 = Timer.New(function()
		arg1_18()
	end, 1, -1)

	var0_18:Start()
	table.insert(arg0_18.timers, var0_18)
end

function var0_0.RemoveAllTimer(arg0_20)
	if arg0_20.timers then
		for iter0_20, iter1_20 in ipairs(arg0_20.timers) do
			iter1_20:Stop()

			iter1_20 = nil
		end

		arg0_20.timers = nil
	end
end

function var0_0.willExit(arg0_21)
	arg0_21:RemoveAllTimer()

	for iter0_21, iter1_21 in pairs(arg0_21.banners) do
		iter1_21:Dispose()
	end

	arg0_21.banners = nil

	arg0_21:UnOverlayPanel(arg0_21._tf)
end

function var0_0.onBackPressed(arg0_22)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
