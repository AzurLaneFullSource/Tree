local var0_0 = class("NewRecommendationShopLayer", import("...base.BaseUI"))

var0_0.ACT_REMASTER_BANNER_ID = -1

local var1_0 = pg.shop_banner_template

function var0_0.getUIName(arg0_1)
	return "NewRecommendationShopUI"
end

function var0_0.getGroupName(arg0_2)
	return "NewShopMainScene"
end

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = {
		"ui/NewRecommendationShopUI"
	}
	local var1_3 = pg.TimeMgr.GetInstance()
	local var2_3 = getProxy(ShopsProxy):getChargedList()
	local var3_3 = getProxy(ShopsProxy):GetNormalList()
	local var4_3 = getProxy(ShopsProxy):GetNormalGroupList()
	local var5_3 = getProxy(PlayerProxy):getRawData()
	local var6_3 = {
		{},
		{},
		{}
	}

	for iter0_3, iter1_3 in ipairs(var1_0.all) do
		local var7_3 = var1_0[iter1_3]

		if var1_3:inTime(var7_3.time) and var7_3.relation_param ~= "" then
			local var8_3 = var7_3.relation_param[1]
			local var9_3 = var7_3.relation_param[2]
			local var10_3

			if var8_3 == 1 then
				var10_3 = Goods.Create({
					id = var9_3
				}, Goods.TYPE_CHARGE)

				var10_3:updateBuyCount(ChargeConst.getBuyCount(var2_3, var9_3))
			elseif var8_3 == 2 then
				var10_3 = Goods.Create({
					id = var9_3
				}, Goods.TYPE_GIFT_PACKAGE)

				var10_3:updateBuyCount(ChargeConst.getBuyCount(var3_3, var9_3))
				var10_3:updateGroupCount(ChargeConst.getGroupLimit(var4_3, var10_3:getConfig("group") or 0))
			elseif var8_3 == 3 then
				var10_3 = Goods.Create({
					id = var9_3
				}, Goods.TYPE_SKIN)

				var10_3:updateBuyCount(ChargeConst.getBuyCount(var3_3, var9_3))
				var10_3:updateGroupCount(ChargeConst.getGroupLimit(var4_3, var10_3:getConfig("group") or 0))
			end

			var6_3[var8_3][var9_3] = var10_3
		end
	end

	local var11_3 = {}
	local var12_3 = {}
	local var13_3 = pg.gameset.shop_banner_capacity.key_value
	local var14_3 = Clone(var1_0.get_id_list_by_name)

	var14_3.banner_big = underscore.filter(var14_3.banner_big, function(arg0_4)
		return ShopsProxy.SpecialBannerBlockCheck(var1_0[arg0_4], var5_3)
	end)

	for iter2_3, iter3_3 in pairs(var14_3) do
		table.sort(iter3_3, CompareFuncs({
			function(arg0_5)
				return -var1_0[arg0_5].order
			end,
			function(arg0_6)
				return arg0_6
			end
		}))

		for iter4_3 = #iter3_3, 1, -1 do
			local var15_3 = var1_0[iter3_3[iter4_3]]

			if not var1_3:inTime(var15_3.time) then
				table.remove(iter3_3, iter4_3)
			elseif var15_3.relation_param ~= "" then
				local var16_3 = var15_3.relation_param[1]
				local var17_3 = var15_3.relation_param[2]
				local var18_3 = var6_3[var16_3][var17_3]

				if var16_3 == 1 then
					if not var18_3 or not var18_3:inTime() or not var18_3:canPurchase() then
						table.remove(iter3_3, iter4_3)
					end
				elseif (var16_3 == 2 or var16_3 == 3) and (not var18_3 or not var18_3:inTime() or not var18_3:canPurchase() or var18_3:IsGroupLimit()) then
					table.remove(iter3_3, iter4_3)
				end
			end
		end

		if #iter3_3 > 1 then
			table.remove(iter3_3, #iter3_3)
		end

		if var13_3 < #iter3_3 then
			for iter5_3 = #iter3_3, var13_3 + 1, -1 do
				table.remove(iter3_3, iter5_3)
			end
		end

		for iter6_3, iter7_3 in ipairs(iter3_3) do
			local var19_3 = var1_0[iter7_3]

			if noEmptyStr(var19_3.pic) then
				table.insert(var11_3, var19_3.pic)
			end

			if var19_3.relation_param ~= "" then
				local var20_3 = var19_3.relation_param[1]
				local var21_3 = var19_3.relation_param[2]
				local var22_3 = var6_3[var20_3][var21_3]

				if var20_3 == 1 and var22_3 then
					local var23_3 = var22_3:getConfig("picture")

					if noEmptyStr(var23_3) then
						table.insert(var12_3, ResPathSupport.CombinePath("chargeicon", var23_3))
					end
				end
			end
		end
	end

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_3, arg1_3), var0_3, var11_3, var12_3))
end

function var0_0.init(arg0_7)
	arg0_7.resources = arg0_7._tf:Find("adapt/top/resources")
	arg0_7.banners = {}
	arg0_7.banners.banner_big = BannerScrollRectDorm3dShop.New(arg0_7._tf:Find("panel/banner_big/banner/mask/content"), arg0_7._tf:Find("panel/banner_big/banner/dots"))
	arg0_7.banners.banner_middle = BannerScrollRectDorm3dShop.New(arg0_7._tf:Find("panel/banner_middle/banner/mask/content"), arg0_7._tf:Find("panel/banner_middle/banner/dots"))
	arg0_7.banners.banner_small1 = BannerScrollRectDorm3dShop.New(arg0_7._tf:Find("panel/banner_small1/banner/mask/content"), arg0_7._tf:Find("panel/banner_small1/banner/dots"))
	arg0_7.banners.banner_small2 = BannerScrollRectDorm3dShop.New(arg0_7._tf:Find("panel/banner_small2/banner/mask/content"), arg0_7._tf:Find("panel/banner_small2/banner/dots"))
	arg0_7.banners.banner_small3 = BannerScrollRectDorm3dShop.New(arg0_7._tf:Find("panel/banner_small3/banner/mask/content"), arg0_7._tf:Find("panel/banner_small3/banner/dots"))

	setText(arg0_7._tf:Find("panel/banner_big/banner/mask/content/item/time/remainTime"), i18n("shop_new_during_time"))
	setText(arg0_7._tf:Find("panel/banner_small2/banner/mask/content/item/monthCard/day"), i18n("shop_new_daily"))
	setText(arg0_7._tf:Find("panel/banner_middle/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_7._tf:Find("panel/banner_small1/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_7._tf:Find("panel/banner_small2/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_7._tf:Find("panel/banner_small2/banner/mask/content/item/monthCard/buy/Text"), i18n("shop_new_purchase"))
	setText(arg0_7._tf:Find("panel/banner_small3/banner/mask/content/item/detail/buy/Text"), i18n("shop_new_purchase"))
end

function var0_0.didEnter(arg0_8)
	arg0_8:InitData()
	arg0_8:ShowResUI()
	arg0_8:SetPanel()
	arg0_8:OverlayPanel(arg0_8._tf)
end

function var0_0.InitData(arg0_9)
	arg0_9.shopsProxy = getProxy(ShopsProxy)

	local var0_9 = arg0_9.shopsProxy:getChargedList()
	local var1_9 = arg0_9.shopsProxy:GetNormalList()
	local var2_9 = arg0_9.shopsProxy:GetNormalGroupList()

	arg0_9.commodities = {
		{},
		{},
		{}
	}

	for iter0_9, iter1_9 in ipairs(var1_0.all) do
		local var3_9 = var1_0[iter1_9]

		if pg.TimeMgr.GetInstance():inTime(var3_9.time) and var3_9.relation_param ~= "" then
			local var4_9 = var3_9.relation_param[1]
			local var5_9 = var3_9.relation_param[2]
			local var6_9

			if var4_9 == 1 then
				var6_9 = Goods.Create({
					id = var5_9
				}, Goods.TYPE_CHARGE)

				local var7_9 = ChargeConst.getBuyCount(var0_9, var5_9)

				var6_9:updateBuyCount(var7_9)
			elseif var4_9 == 2 then
				var6_9 = Goods.Create({
					id = var5_9
				}, Goods.TYPE_GIFT_PACKAGE)

				local var8_9 = ChargeConst.getBuyCount(var1_9, var5_9)

				var6_9:updateBuyCount(var8_9)

				local var9_9 = ChargeConst.getGroupLimit(var2_9, var6_9:getConfig("group") or 0)

				var6_9:updateGroupCount(var9_9)
			elseif var4_9 == 3 then
				var6_9 = Goods.Create({
					id = var5_9
				}, Goods.TYPE_SKIN)

				local var10_9 = ChargeConst.getBuyCount(var1_9, var5_9)

				var6_9:updateBuyCount(var10_9)

				local var11_9 = ChargeConst.getGroupLimit(var2_9, var6_9:getConfig("group") or 0)

				var6_9:updateGroupCount(var11_9)
			end

			arg0_9.commodities[var4_9][var5_9] = var6_9
		end
	end

	local var12_9 = pg.gameset.shop_banner_capacity.key_value

	arg0_9.bnIds = Clone(var1_0.get_id_list_by_name)

	local var13_9 = getProxy(PlayerProxy):getRawData()

	arg0_9.bnIds.banner_big = underscore.filter(arg0_9.bnIds.banner_big, function(arg0_10)
		return ShopsProxy.SpecialBannerBlockCheck(var1_0[arg0_10], var13_9)
	end)

	if getProxy(ActivityRemasterProxy):ExistShopBanner() then
		if not arg0_9.bnIds.banner_small3 then
			arg0_9.bnIds.banner_small3 = {}
		end

		table.insert(arg0_9.bnIds.banner_small3, var0_0.ACT_REMASTER_BANNER_ID)
	end

	for iter2_9, iter3_9 in pairs(arg0_9.bnIds) do
		table.sort(iter3_9, CompareFuncs({
			function(arg0_11)
				return -arg0_9:GetBannerConfig(arg0_11).order
			end,
			function(arg0_12)
				return arg0_12
			end
		}))

		for iter4_9 = #iter3_9, 1, -1 do
			local var14_9 = arg0_9:GetBannerConfig(iter3_9[iter4_9])

			if not pg.TimeMgr.GetInstance():inTime(var14_9.time) then
				table.remove(iter3_9, iter4_9)
			elseif var14_9.relation_param ~= "" then
				local var15_9 = var14_9.relation_param[1]
				local var16_9 = var14_9.relation_param[2]
				local var17_9 = arg0_9.commodities[var15_9][var16_9]

				if var15_9 == 1 then
					if not var17_9:inTime() or not var17_9:canPurchase() then
						table.remove(iter3_9, iter4_9)
					end
				elseif (var15_9 == 2 or var15_9 == 3) and (not var17_9:inTime() or not var17_9:canPurchase() or var17_9:IsGroupLimit()) then
					table.remove(iter3_9, iter4_9)
				end
			end
		end

		if #iter3_9 > 1 then
			table.remove(iter3_9, #iter3_9)
		end

		if var12_9 < #iter3_9 then
			for iter5_9 = #iter3_9, var12_9 + 1, -1 do
				table.remove(iter3_9, iter5_9)
			end
		end
	end
end

function var0_0.ShowResUI(arg0_13)
	local var0_13 = getProxy(PlayerProxy):getRawData()

	arg0_13.goldMax = arg0_13.resources:Find("gold/max"):GetComponent(typeof(Text))
	arg0_13.goldValue = arg0_13.resources:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_13.oilMax = arg0_13.resources:Find("oil/max"):GetComponent(typeof(Text))
	arg0_13.oilValue = arg0_13.resources:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_13.gemValue = arg0_13.resources:Find("gem/Text"):GetComponent(typeof(Text))

	PlayerResUI.StaticFlush(var0_13, arg0_13.goldMax, arg0_13.goldValue, arg0_13.oilMax, arg0_13.oilValue, arg0_13.gemValue)
	onButton(arg0_13, arg0_13.resources:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.resources:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.GetBannerConfig(arg0_17, arg1_17)
	if arg1_17 == var0_0.ACT_REMASTER_BANNER_ID then
		return getProxy(ActivityRemasterProxy):GetShopBanner()
	end

	assert(var1_0[arg1_17], "no config >>>>>>>>>>>>>>>>>" .. arg1_17)

	if var1_0[arg1_17] then
		return var1_0[arg1_17]
	end
end

function var0_0.SetPanel(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.banners) do
		for iter2_18, iter3_18 in ipairs(arg0_18.bnIds[iter0_18]) do
			local var0_18 = arg0_18:GetBannerConfig(iter3_18)
			local var1_18 = iter1_18:AddChild()

			GetImageSpriteFromAtlasAsync(var0_18.pic, "", var1_18:Find("picture"))
			setActive(var1_18:Find("detail"), var0_18.relation_param ~= "")
			setActive(var1_18:Find("time"), var0_18.time_lable == 1)

			if iter0_18 == "banner_small2" then
				setActive(var1_18:Find("monthCard"), false)
				setActive(var1_18:Find("monthCardhave"), false)
			end

			if var0_18.relation_param ~= "" then
				local var2_18 = var0_18.relation_param[1]
				local var3_18 = var0_18.relation_param[2]
				local var4_18 = arg0_18.commodities[var2_18][var3_18]

				if iter0_18 == "banner_small2" and var2_18 == 1 and var4_18:isMonthCard() then
					setActive(var1_18:Find("detail"), false)
					setActive(var1_18:Find("monthCard"), true)
					setText(var1_18:Find("monthCard/name"), var4_18:getConfig("name_display"))
					GetImageSpriteFromAtlasAsync("chargeicon/" .. var4_18:getConfig("picture"), "", var1_18:Find("monthCard/icon"))
					setText(var1_18:Find("monthCard/get"), i18n("shop_new_get_now", var4_18:GetGemCnt()))

					local var5_18 = var4_18:GetDropList()

					while #var5_18 > 3 do
						table.remove(var5_18, #var5_18)
					end

					local var6_18 = UIItemList.New(var1_18:Find("monthCard/items"), var1_18:Find("monthCard/items/item"))

					var6_18:make(function(arg0_19, arg1_19, arg2_19)
						if arg0_19 == UIItemList.EventUpdate then
							local var0_19 = var5_18[arg1_19 + 1]

							updateDrop(arg2_19:Find("mask/item"), var0_19)
						end
					end)
					var6_18:align(#var5_18)

					local var7_18 = var2_18 == 1 and var4_18:getShowType() ~= ""
					local var8_18 = var4_18:isFree()

					setText(var1_18:Find("monthCard/consume/icon_rmb"), GetMoneySymbol())
					setActive(var1_18:Find("monthCard/consume/icon_rmb"), var2_18 == 1 and not var7_18)

					if PLATFORM_CODE == PLATFORM_CHT and var4_18:IsLocalPrice() then
						setActive(var1_18:Find("monthCard/consume/icon_rmb"), false)
					end

					setActive(var1_18:Find("monthCard/consume/icon_gem"), var2_18 ~= 1 and not var8_18)
					setActive(var1_18:Find("monthCard/consume/Text"), not var8_18 and not var7_18)

					if var2_18 == 1 then
						setText(var1_18:Find("monthCard/consume/Text"), var4_18:getConfig("money"))
					elseif var2_18 == 2 then
						setText(var1_18:Find("monthCard/consume/Text"), var4_18:GetPrice())
					end

					setActive(var1_18:Find("monthCard/consume/FreeText"), var8_18)
					setText(var1_18:Find("monthCard/consume/FreeText"), i18n("shop_free_tag"))

					local var9_18 = getProxy(PlayerProxy):getRawData():getCardById(VipCard.MONTH)
					local var10_18 = var9_18 and var9_18:GetLeftDay() > (var4_18:getConfig("limit_arg") or 0)

					setActive(var1_18:Find("monthCardhave"), var10_18)

					if var10_18 then
						setText(var1_18:Find("monthCardhave/Text"), i18n("shop_new_remaining_time", var9_18:GetLeftDay()))
					end
				else
					if var2_18 == 1 then
						setText(var1_18:Find("detail/name"), var4_18:getConfig("name_display"))
						GetImageSpriteFromAtlasAsync("chargeicon/" .. var4_18:getConfig("picture"), "", var1_18:Find("detail/icon"))
					elseif var2_18 == 2 then
						setText(var1_18:Find("detail/name"), var4_18:GetName())
						GetImageSpriteFromAtlasAsync(var4_18:getDropInfo():getIcon(), "", var1_18:Find("detail/icon"))
					end

					local var11_18 = var4_18:GetDropList()

					while #var11_18 > 3 do
						table.remove(var11_18, #var11_18)
					end

					local var12_18 = UIItemList.New(var1_18:Find("detail/items"), var1_18:Find("detail/items/item"))

					var12_18:make(function(arg0_20, arg1_20, arg2_20)
						if arg0_20 == UIItemList.EventUpdate then
							local var0_20 = var11_18[arg1_20 + 1]

							updateDrop(arg2_20:Find("mask/item"), var0_20)
						end
					end)
					var12_18:align(#var11_18)

					local var13_18 = var2_18 == 1 and var4_18:getShowType() ~= ""
					local var14_18 = var4_18:isFree()

					setText(var1_18:Find("detail/consume/icon_rmb"), GetMoneySymbol())
					setActive(var1_18:Find("detail/consume/icon_rmb"), var2_18 == 1 and not var13_18)

					if PLATFORM_CODE == PLATFORM_CHT and var4_18:IsLocalPrice() then
						setActive(var1_18:Find("detail/consume/icon_rmb"), false)
					end

					setActive(var1_18:Find("detail/consume/icon_gem"), var2_18 ~= 1 and not var14_18)
					setActive(var1_18:Find("detail/consume/Text"), not var14_18 and not var13_18)

					if var2_18 == 1 then
						setText(var1_18:Find("detail/consume/Text"), var4_18:getConfig("money"))
					elseif var2_18 == 2 then
						setText(var1_18:Find("detail/consume/Text"), var4_18:GetPrice())
					end

					setActive(var1_18:Find("detail/consume/FreeText"), var14_18)
					setText(var1_18:Find("detail/consume/FreeText"), i18n("shop_free_tag"))
				end
			end

			if var0_18.time_lable == 1 then
				local var15_18 = var0_18.time[2]
				local var16_18 = pg.TimeMgr.GetInstance():Table2ServerTime({
					year = var15_18[1][1],
					month = var15_18[1][2],
					day = var15_18[1][3],
					hour = var15_18[2][1],
					min = var15_18[2][2],
					sec = var15_18[2][3]
				})

				arg0_18:StartTimer(function()
					local var0_21 = pg.TimeMgr.GetInstance():GetServerTime()
					local var1_21 = var16_18 - var0_21
					local var2_21 = math.floor(var1_21 / 86400)
					local var3_21 = math.floor(var1_21 % 86400 / 3600)
					local var4_21 = math.floor(var1_21 % 86400 % 3600 / 60)

					if iter0_18 == "banner_big" then
						setText(var1_18:Find("time/text"), i18n("shop_countdown", var2_21, var3_21, var4_21))
					elseif var2_21 > 0 then
						setText(var1_18:Find("time/text"), i18n("shop_new_during_day", var2_21))
					elseif var3_21 > 0 then
						setText(var1_18:Find("time/text"), i18n("shop_new_during_hour", var3_21))
					else
						setText(var1_18:Find("time/text"), i18n("shop_new_during_minite", var4_21))
					end
				end)
			end

			onButton(arg0_18, var1_18, function()
				arg0_18:emit(NewRecommendationShopMediator.GO_SHOP, var0_18.param[1], var0_18.param[2])
			end, SFX_PANEL)
		end

		iter1_18:SetUp()
		setActive(arg0_18._tf:Find("panel/" .. iter0_18 .. "/banner/dots"), #arg0_18.bnIds[iter0_18] > 1)
	end
end

function var0_0.StartTimer(arg0_23, arg1_23)
	if not arg0_23.timers then
		arg0_23.timers = {}
	end

	arg1_23()

	local var0_23 = Timer.New(function()
		arg1_23()
	end, 1, -1)

	var0_23:Start()
	table.insert(arg0_23.timers, var0_23)
end

function var0_0.RemoveAllTimer(arg0_25)
	if arg0_25.timers then
		for iter0_25, iter1_25 in ipairs(arg0_25.timers) do
			iter1_25:Stop()

			iter1_25 = nil
		end

		arg0_25.timers = nil
	end
end

function var0_0.willExit(arg0_26)
	arg0_26:RemoveAllTimer()

	for iter0_26, iter1_26 in pairs(arg0_26.banners) do
		iter1_26:Dispose()
	end

	arg0_26.banners = nil

	arg0_26:UnOverlayPanel(arg0_26._tf)
end

function var0_0.onBackPressed(arg0_27)
	pg.m02:sendNotification(NewShopMainScene.CLOSE_VIEW)
end

return var0_0
