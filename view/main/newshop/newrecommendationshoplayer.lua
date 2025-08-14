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

	for iter2_4, iter3_4 in pairs(arg0_4.bnIds) do
		table.sort(iter3_4, CompareFuncs({
			function(arg0_5)
				return -var1_0[arg0_5].order
			end,
			function(arg0_6)
				return arg0_6
			end
		}))

		for iter4_4 = #iter3_4, 1, -1 do
			local var13_4 = var1_0[iter3_4[iter4_4]]

			if not pg.TimeMgr.GetInstance():inTime(var13_4.time) then
				table.remove(iter3_4, iter4_4)
			elseif var13_4.relation_param ~= "" then
				local var14_4 = var13_4.relation_param[1]
				local var15_4 = var13_4.relation_param[2]
				local var16_4 = arg0_4.commodities[var14_4][var15_4]

				if var14_4 == 1 then
					if not var16_4:inTime() or not var16_4:canPurchase() then
						table.remove(iter3_4, iter4_4)
					end
				elseif (var14_4 == 2 or var14_4 == 3) and (not var16_4:inTime() or not var16_4:canPurchase() or var16_4:IsGroupLimit()) then
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

function var0_0.ShowResUI(arg0_7)
	local var0_7 = getProxy(PlayerProxy):getRawData()

	arg0_7.goldMax = arg0_7.resources:Find("gold/max"):GetComponent(typeof(Text))
	arg0_7.goldValue = arg0_7.resources:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_7.oilMax = arg0_7.resources:Find("oil/max"):GetComponent(typeof(Text))
	arg0_7.oilValue = arg0_7.resources:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_7.gemValue = arg0_7.resources:Find("gem/Text"):GetComponent(typeof(Text))

	PlayerResUI.StaticFlush(var0_7, arg0_7.goldMax, arg0_7.goldValue, arg0_7.oilMax, arg0_7.oilValue, arg0_7.gemValue)
	onButton(arg0_7, arg0_7.resources:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.resources:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.SetPanel(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.banners) do
		for iter2_11, iter3_11 in ipairs(arg0_11.bnIds[iter0_11]) do
			local var0_11 = var1_0[iter3_11]
			local var1_11 = iter1_11:AddChild()

			GetImageSpriteFromAtlasAsync(var0_11.pic, "", var1_11:Find("picture"))
			setActive(var1_11:Find("detail"), var0_11.relation_param ~= "")
			setActive(var1_11:Find("time"), var0_11.time_lable == 1)

			if iter0_11 == "banner_small2" then
				setActive(var1_11:Find("monthCard"), false)
				setActive(var1_11:Find("monthCardhave"), false)
			end

			if var0_11.relation_param ~= "" then
				local var2_11 = var0_11.relation_param[1]
				local var3_11 = var0_11.relation_param[2]
				local var4_11 = arg0_11.commodities[var2_11][var3_11]

				if iter0_11 == "banner_small2" and var2_11 == 1 and var4_11:isMonthCard() then
					setActive(var1_11:Find("detail"), false)
					setActive(var1_11:Find("monthCard"), true)
					setText(var1_11:Find("monthCard/name"), var4_11:getConfig("name_display"))
					GetImageSpriteFromAtlasAsync("chargeicon/" .. var4_11:getConfig("picture"), "", var1_11:Find("monthCard/icon"))
					setText(var1_11:Find("monthCard/get"), i18n("shop_new_get_now", var4_11:GetGemCnt()))

					local var5_11 = var4_11:GetDropList()

					while #var5_11 > 3 do
						table.remove(var5_11, #var5_11)
					end

					local var6_11 = UIItemList.New(var1_11:Find("monthCard/items"), var1_11:Find("monthCard/items/item"))

					var6_11:make(function(arg0_12, arg1_12, arg2_12)
						if arg0_12 == UIItemList.EventUpdate then
							local var0_12 = var5_11[arg1_12 + 1]

							updateDrop(arg2_12:Find("mask/item"), var0_12)
						end
					end)
					var6_11:align(#var5_11)

					local var7_11 = var2_11 == 1 and var4_11:getShowType() ~= ""
					local var8_11 = var4_11:isFree()

					setText(var1_11:Find("monthCard/consume/icon_rmb"), GetMoneySymbol())
					setActive(var1_11:Find("monthCard/consume/icon_rmb"), var2_11 == 1 and not var7_11)

					if PLATFORM_CODE == PLATFORM_CHT and var4_11:IsLocalPrice() then
						setActive(var1_11:Find("monthCard/consume/icon_rmb"), false)
					end

					setActive(var1_11:Find("monthCard/consume/icon_gem"), var2_11 ~= 1 and not var8_11)
					setActive(var1_11:Find("monthCard/consume/Text"), not var8_11 and not var7_11)

					if var2_11 == 1 then
						setText(var1_11:Find("monthCard/consume/Text"), var4_11:getConfig("money"))
					elseif var2_11 == 2 then
						setText(var1_11:Find("monthCard/consume/Text"), var4_11:GetPrice())
					end

					setActive(var1_11:Find("monthCard/consume/FreeText"), var8_11)
					setText(var1_11:Find("monthCard/consume/FreeText"), i18n("shop_free_tag"))

					local var9_11 = getProxy(PlayerProxy):getRawData():getCardById(VipCard.MONTH)
					local var10_11 = var9_11 and var9_11:GetLeftDay() > (var4_11:getConfig("limit_arg") or 0)

					setActive(var1_11:Find("monthCardhave"), var10_11)

					if var10_11 then
						setText(var1_11:Find("monthCardhave/Text"), i18n("shop_new_remaining_time", var9_11:GetLeftDay()))
					end
				else
					if var2_11 == 1 then
						setText(var1_11:Find("detail/name"), var4_11:getConfig("name_display"))
						GetImageSpriteFromAtlasAsync("chargeicon/" .. var4_11:getConfig("picture"), "", var1_11:Find("detail/icon"))
					elseif var2_11 == 2 then
						setText(var1_11:Find("detail/name"), var4_11:GetName())
						GetImageSpriteFromAtlasAsync(var4_11:getDropInfo():getIcon(), "", var1_11:Find("detail/icon"))
					end

					local var11_11 = var4_11:GetDropList()

					while #var11_11 > 3 do
						table.remove(var11_11, #var11_11)
					end

					local var12_11 = UIItemList.New(var1_11:Find("detail/items"), var1_11:Find("detail/items/item"))

					var12_11:make(function(arg0_13, arg1_13, arg2_13)
						if arg0_13 == UIItemList.EventUpdate then
							local var0_13 = var11_11[arg1_13 + 1]

							updateDrop(arg2_13:Find("mask/item"), var0_13)
						end
					end)
					var12_11:align(#var11_11)

					local var13_11 = var2_11 == 1 and var4_11:getShowType() ~= ""
					local var14_11 = var4_11:isFree()

					setText(var1_11:Find("detail/consume/icon_rmb"), GetMoneySymbol())
					setActive(var1_11:Find("detail/consume/icon_rmb"), var2_11 == 1 and not var13_11)

					if PLATFORM_CODE == PLATFORM_CHT and var4_11:IsLocalPrice() then
						setActive(var1_11:Find("detail/consume/icon_rmb"), false)
					end

					setActive(var1_11:Find("detail/consume/icon_gem"), var2_11 ~= 1 and not var14_11)
					setActive(var1_11:Find("detail/consume/Text"), not var14_11 and not var13_11)

					if var2_11 == 1 then
						setText(var1_11:Find("detail/consume/Text"), var4_11:getConfig("money"))
					elseif var2_11 == 2 then
						setText(var1_11:Find("detail/consume/Text"), var4_11:GetPrice())
					end

					setActive(var1_11:Find("detail/consume/FreeText"), var14_11)
					setText(var1_11:Find("detail/consume/FreeText"), i18n("shop_free_tag"))
				end
			end

			if var0_11.time_lable == 1 then
				local var15_11 = var0_11.time[2]
				local var16_11 = pg.TimeMgr.GetInstance():Table2ServerTime({
					year = var15_11[1][1],
					month = var15_11[1][2],
					day = var15_11[1][3],
					hour = var15_11[2][1],
					min = var15_11[2][2],
					sec = var15_11[2][3]
				})

				arg0_11:StartTimer(function()
					local var0_14 = pg.TimeMgr.GetInstance():GetServerTime()
					local var1_14 = var16_11 - var0_14
					local var2_14 = math.floor(var1_14 / 86400)
					local var3_14 = math.floor(var1_14 % 86400 / 3600)
					local var4_14 = math.floor(var1_14 % 86400 % 3600 / 60)

					if iter0_11 == "banner_big" then
						setText(var1_11:Find("time/text"), i18n("shop_countdown", var2_14, var3_14, var4_14))
					elseif var2_14 > 0 then
						setText(var1_11:Find("time/text"), i18n("shop_new_during_day", var2_14))
					elseif var3_14 > 0 then
						setText(var1_11:Find("time/text"), i18n("shop_new_during_hour", var3_14))
					else
						setText(var1_11:Find("time/text"), i18n("shop_new_during_minite", var4_14))
					end
				end)
			end

			onButton(arg0_11, var1_11, function()
				arg0_11:emit(NewRecommendationShopMediator.GO_SHOP, var0_11.param[1], var0_11.param[2])
			end, SFX_PANEL)
		end

		iter1_11:SetUp()
		setActive(arg0_11._tf:Find("panel/" .. iter0_11 .. "/banner/dots"), #arg0_11.bnIds[iter0_11] > 1)
	end
end

function var0_0.StartTimer(arg0_16, arg1_16)
	if not arg0_16.timers then
		arg0_16.timers = {}
	end

	arg1_16()

	local var0_16 = Timer.New(function()
		arg1_16()
	end, 1, -1)

	var0_16:Start()
	table.insert(arg0_16.timers, var0_16)
end

function var0_0.RemoveAllTimer(arg0_18)
	if arg0_18.timers then
		for iter0_18, iter1_18 in ipairs(arg0_18.timers) do
			iter1_18:Stop()

			iter1_18 = nil
		end

		arg0_18.timers = nil
	end
end

function var0_0.willExit(arg0_19)
	arg0_19:RemoveAllTimer()

	for iter0_19, iter1_19 in pairs(arg0_19.banners) do
		iter1_19:Dispose()
	end

	arg0_19.banners = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19._tf)
end

function var0_0.onBackPressed(arg0_20)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
