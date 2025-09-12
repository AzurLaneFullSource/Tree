local var0_0 = class("NewRecommendationShopLayer", import("...base.BaseUI"))
local var1_0 = pg.shop_banner_template

function var0_0.getUIName(arg0_1)
	return "NewRecommendationShopUI"
end

function var0_0.init(arg0_2)
	arg0_2.resources = arg0_2._tf:Find("adapt/top/resources")
	arg0_2.banners = {}
	arg0_2.banners.banner_big = BannerScrollRectDorm3dShop.New(arg0_2._tf:Find("panel/banner_big/banner/mask/content"), arg0_2._tf:Find("panel/banner_big/banner/dots"))
	arg0_2.banners.banner_middle = BannerScrollRectDorm3dShop.New(arg0_2._tf:Find("panel/banner_middle/banner/mask/content"), arg0_2._tf:Find("panel/banner_middle/banner/dots"))
	arg0_2.banners.banner_small1 = BannerScrollRectDorm3dShop.New(arg0_2._tf:Find("panel/banner_small1/banner/mask/content"), arg0_2._tf:Find("panel/banner_small1/banner/dots"))
	arg0_2.banners.banner_small2 = BannerScrollRectDorm3dShop.New(arg0_2._tf:Find("panel/banner_small2/banner/mask/content"), arg0_2._tf:Find("panel/banner_small2/banner/dots"))
	arg0_2.banners.banner_small3 = BannerScrollRectDorm3dShop.New(arg0_2._tf:Find("panel/banner_small3/banner/mask/content"), arg0_2._tf:Find("panel/banner_small3/banner/dots"))

	setText(arg0_2._tf:Find("panel/banner_big/banner/mask/content/item/time/remainTime"), i18n("shop_new_during_time"))
	setText(arg0_2._tf:Find("panel/banner_small2/banner/mask/content/item/monthCard/day"), i18n("shop_new_daily"))
	setText(arg0_2._tf:Find("panel/banner_middle/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_2._tf:Find("panel/banner_small1/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_2._tf:Find("panel/banner_small2/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_2._tf:Find("panel/banner_small2/banner/mask/content/item/monthCard/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_2._tf:Find("panel/banner_small3/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	arg0_3:ShowResUI()
	arg0_3:SetPanel()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf, {
		groupName = "shop"
	})
end

function var0_0.InitData(arg0_4)
	arg0_4.shopsProxy = getProxy(ShopsProxy)

	local var0_4 = arg0_4.shopsProxy:getChargedList()
	local var1_4 = arg0_4.shopsProxy:GetNormalList()
	local var2_4 = arg0_4.shopsProxy:GetNormalGroupList()

	arg0_4.commodities = {
		{},
		{},
		{}
	}

	for iter0_4, iter1_4 in ipairs(var1_0.all) do
		local var3_4 = var1_0[iter1_4]

		if pg.TimeMgr.GetInstance():inTime(var3_4.time) and var3_4.relation_param ~= "" then
			local var4_4 = var3_4.relation_param[1]
			local var5_4 = var3_4.relation_param[2]
			local var6_4

			if var4_4 == 1 then
				var6_4 = Goods.Create({
					id = var5_4
				}, Goods.TYPE_CHARGE)

				local var7_4 = ChargeConst.getBuyCount(var0_4, var5_4)

				var6_4:updateBuyCount(var7_4)
			elseif var4_4 == 2 then
				var6_4 = Goods.Create({
					id = var5_4
				}, Goods.TYPE_GIFT_PACKAGE)

				local var8_4 = ChargeConst.getBuyCount(var1_4, var5_4)

				var6_4:updateBuyCount(var8_4)

				local var9_4 = ChargeConst.getGroupLimit(var2_4, var6_4:getConfig("group") or 0)

				var6_4:updateGroupCount(var9_4)
			elseif var4_4 == 3 then
				var6_4 = Goods.Create({
					id = var5_4
				}, Goods.TYPE_SKIN)

				local var10_4 = ChargeConst.getBuyCount(var1_4, var5_4)

				var6_4:updateBuyCount(var10_4)

				local var11_4 = ChargeConst.getGroupLimit(var2_4, var6_4:getConfig("group") or 0)

				var6_4:updateGroupCount(var11_4)
			end

			arg0_4.commodities[var4_4][var5_4] = var6_4
		end
	end

	local var12_4 = pg.gameset.shop_banner_capacity.key_value

	arg0_4.bnIds = Clone(var1_0.get_id_list_by_name)

	local var13_4 = getProxy(PlayerProxy):getRawData()

	arg0_4.bnIds.banner_big = underscore.filter(arg0_4.bnIds.banner_big, function(arg0_5)
		return ShopsProxy.SpecialBannerBlockCheck(var1_0[arg0_5], var13_4)
	end)

	for iter2_4, iter3_4 in pairs(arg0_4.bnIds) do
		table.sort(iter3_4, CompareFuncs({
			function(arg0_6)
				return -var1_0[arg0_6].order
			end,
			function(arg0_7)
				return arg0_7
			end
		}))

		for iter4_4 = #iter3_4, 1, -1 do
			local var14_4 = var1_0[iter3_4[iter4_4]]

			if not pg.TimeMgr.GetInstance():inTime(var14_4.time) then
				table.remove(iter3_4, iter4_4)
			elseif var14_4.relation_param ~= "" then
				local var15_4 = var14_4.relation_param[1]
				local var16_4 = var14_4.relation_param[2]
				local var17_4 = arg0_4.commodities[var15_4][var16_4]

				if var15_4 == 1 then
					if not var17_4:inTime() or not var17_4:canPurchase() then
						table.remove(iter3_4, iter4_4)
					end
				elseif (var15_4 == 2 or var15_4 == 3) and (not var17_4:inTime() or not var17_4:canPurchase() or var17_4:IsGroupLimit()) then
					table.remove(iter3_4, iter4_4)
				end
			end
		end

		if #iter3_4 > 1 then
			table.remove(iter3_4, #iter3_4)
		end

		if var12_4 < #iter3_4 then
			for iter5_4 = #iter3_4, var12_4 + 1, -1 do
				table.remove(iter3_4, iter5_4)
			end
		end
	end
end

function var0_0.ShowResUI(arg0_8)
	local var0_8 = getProxy(PlayerProxy):getRawData()

	arg0_8.goldMax = arg0_8.resources:Find("gold/max"):GetComponent(typeof(Text))
	arg0_8.goldValue = arg0_8.resources:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_8.oilMax = arg0_8.resources:Find("oil/max"):GetComponent(typeof(Text))
	arg0_8.oilValue = arg0_8.resources:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_8.gemValue = arg0_8.resources:Find("gem/Text"):GetComponent(typeof(Text))

	PlayerResUI.StaticFlush(var0_8, arg0_8.goldMax, arg0_8.goldValue, arg0_8.oilMax, arg0_8.oilValue, arg0_8.gemValue)
	onButton(arg0_8, arg0_8.resources:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.resources:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.SetPanel(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.banners) do
		for iter2_12, iter3_12 in ipairs(arg0_12.bnIds[iter0_12]) do
			local var0_12 = var1_0[iter3_12]
			local var1_12 = iter1_12:AddChild()

			GetImageSpriteFromAtlasAsync(var0_12.pic, "", var1_12:Find("picture"))
			setActive(var1_12:Find("detail"), var0_12.relation_param ~= "")
			setActive(var1_12:Find("time"), var0_12.time_lable == 1)

			if iter0_12 == "banner_small2" then
				setActive(var1_12:Find("monthCard"), false)
				setActive(var1_12:Find("monthCardhave"), false)
			end

			if var0_12.relation_param ~= "" then
				local var2_12 = var0_12.relation_param[1]
				local var3_12 = var0_12.relation_param[2]
				local var4_12 = arg0_12.commodities[var2_12][var3_12]

				if iter0_12 == "banner_small2" and var2_12 == 1 and var4_12:isMonthCard() then
					setActive(var1_12:Find("detail"), false)
					setActive(var1_12:Find("monthCard"), true)
					setText(var1_12:Find("monthCard/name"), var4_12:getConfig("name_display"))
					GetImageSpriteFromAtlasAsync("chargeicon/" .. var4_12:getConfig("picture"), "", var1_12:Find("monthCard/icon"))
					setText(var1_12:Find("monthCard/get"), i18n("shop_new_get_now", var4_12:GetGemCnt()))

					local var5_12 = var4_12:GetDropList()

					while #var5_12 > 3 do
						table.remove(var5_12, #var5_12)
					end

					local var6_12 = UIItemList.New(var1_12:Find("monthCard/items"), var1_12:Find("monthCard/items/item"))

					var6_12:make(function(arg0_13, arg1_13, arg2_13)
						if arg0_13 == UIItemList.EventUpdate then
							local var0_13 = var5_12[arg1_13 + 1]

							updateDrop(arg2_13:Find("mask/item"), var0_13)
						end
					end)
					var6_12:align(#var5_12)

					local var7_12 = var2_12 == 1 and var4_12:getShowType() ~= ""
					local var8_12 = var4_12:isFree()

					setText(var1_12:Find("monthCard/consume/icon_rmb"), GetMoneySymbol())
					setActive(var1_12:Find("monthCard/consume/icon_rmb"), var2_12 == 1 and not var7_12)

					if PLATFORM_CODE == PLATFORM_CHT and var4_12:IsLocalPrice() then
						setActive(var1_12:Find("monthCard/consume/icon_rmb"), false)
					end

					setActive(var1_12:Find("monthCard/consume/icon_gem"), var2_12 ~= 1 and not var8_12)
					setActive(var1_12:Find("monthCard/consume/Text"), not var8_12 and not var7_12)

					if var2_12 == 1 then
						setText(var1_12:Find("monthCard/consume/Text"), var4_12:getConfig("money"))
					elseif var2_12 == 2 then
						setText(var1_12:Find("monthCard/consume/Text"), var4_12:GetPrice())
					end

					setActive(var1_12:Find("monthCard/consume/FreeText"), var8_12)
					setText(var1_12:Find("monthCard/consume/FreeText"), i18n("shop_free_tag"))

					local var9_12 = getProxy(PlayerProxy):getRawData():getCardById(VipCard.MONTH)
					local var10_12 = var9_12 and var9_12:GetLeftDay() > (var4_12:getConfig("limit_arg") or 0)

					setActive(var1_12:Find("monthCardhave"), var10_12)

					if var10_12 then
						setText(var1_12:Find("monthCardhave/Text"), i18n("shop_new_remaining_time", var9_12:GetLeftDay()))
					end
				else
					if var2_12 == 1 then
						setText(var1_12:Find("detail/name"), var4_12:getConfig("name_display"))
						GetImageSpriteFromAtlasAsync("chargeicon/" .. var4_12:getConfig("picture"), "", var1_12:Find("detail/icon"))
					elseif var2_12 == 2 then
						setText(var1_12:Find("detail/name"), var4_12:GetName())
						GetImageSpriteFromAtlasAsync(var4_12:getDropInfo():getIcon(), "", var1_12:Find("detail/icon"))
					end

					local var11_12 = var4_12:GetDropList()

					while #var11_12 > 3 do
						table.remove(var11_12, #var11_12)
					end

					local var12_12 = UIItemList.New(var1_12:Find("detail/items"), var1_12:Find("detail/items/item"))

					var12_12:make(function(arg0_14, arg1_14, arg2_14)
						if arg0_14 == UIItemList.EventUpdate then
							local var0_14 = var11_12[arg1_14 + 1]

							updateDrop(arg2_14:Find("mask/item"), var0_14)
						end
					end)
					var12_12:align(#var11_12)

					local var13_12 = var2_12 == 1 and var4_12:getShowType() ~= ""
					local var14_12 = var4_12:isFree()

					setText(var1_12:Find("detail/consume/icon_rmb"), GetMoneySymbol())
					setActive(var1_12:Find("detail/consume/icon_rmb"), var2_12 == 1 and not var13_12)

					if PLATFORM_CODE == PLATFORM_CHT and var4_12:IsLocalPrice() then
						setActive(var1_12:Find("detail/consume/icon_rmb"), false)
					end

					setActive(var1_12:Find("detail/consume/icon_gem"), var2_12 ~= 1 and not var14_12)
					setActive(var1_12:Find("detail/consume/Text"), not var14_12 and not var13_12)

					if var2_12 == 1 then
						setText(var1_12:Find("detail/consume/Text"), var4_12:getConfig("money"))
					elseif var2_12 == 2 then
						setText(var1_12:Find("detail/consume/Text"), var4_12:GetPrice())
					end

					setActive(var1_12:Find("detail/consume/FreeText"), var14_12)
					setText(var1_12:Find("detail/consume/FreeText"), i18n("shop_free_tag"))
				end
			end

			if var0_12.time_lable == 1 then
				local var15_12 = var0_12.time[2]
				local var16_12 = pg.TimeMgr.GetInstance():Table2ServerTime({
					year = var15_12[1][1],
					month = var15_12[1][2],
					day = var15_12[1][3],
					hour = var15_12[2][1],
					min = var15_12[2][2],
					sec = var15_12[2][3]
				})

				arg0_12:StartTimer(function()
					local var0_15 = pg.TimeMgr.GetInstance():GetServerTime()
					local var1_15 = var16_12 - var0_15
					local var2_15 = math.floor(var1_15 / 86400)
					local var3_15 = math.floor(var1_15 % 86400 / 3600)
					local var4_15 = math.floor(var1_15 % 86400 % 3600 / 60)

					if iter0_12 == "banner_big" then
						setText(var1_12:Find("time/text"), i18n("shop_countdown", var2_15, var3_15, var4_15))
					elseif var2_15 > 0 then
						setText(var1_12:Find("time/text"), i18n("shop_new_during_day", var2_15))
					elseif var3_15 > 0 then
						setText(var1_12:Find("time/text"), i18n("shop_new_during_hour", var3_15))
					else
						setText(var1_12:Find("time/text"), i18n("shop_new_during_minite", var4_15))
					end
				end)
			end

			onButton(arg0_12, var1_12, function()
				arg0_12:emit(NewRecommendationShopMediator.GO_SHOP, var0_12.param[1], var0_12.param[2])
			end, SFX_PANEL)
		end

		iter1_12:SetUp()
		setActive(arg0_12._tf:Find("panel/" .. iter0_12 .. "/banner/dots"), #arg0_12.bnIds[iter0_12] > 1)
	end
end

function var0_0.StartTimer(arg0_17, arg1_17)
	if not arg0_17.timers then
		arg0_17.timers = {}
	end

	arg1_17()

	local var0_17 = Timer.New(function()
		arg1_17()
	end, 1, -1)

	var0_17:Start()
	table.insert(arg0_17.timers, var0_17)
end

function var0_0.RemoveAllTimer(arg0_19)
	if arg0_19.timers then
		for iter0_19, iter1_19 in ipairs(arg0_19.timers) do
			iter1_19:Stop()

			iter1_19 = nil
		end

		arg0_19.timers = nil
	end
end

function var0_0.willExit(arg0_20)
	arg0_20:RemoveAllTimer()

	for iter0_20, iter1_20 in pairs(arg0_20.banners) do
		iter1_20:Dispose()
	end

	arg0_20.banners = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_20._tf)
end

function var0_0.onBackPressed(arg0_21)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
