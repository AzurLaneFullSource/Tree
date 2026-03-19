local var0_0 = class("NewEducateSiteDetailPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewEducateSiteDetailPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.shopTF = arg0_2.rootTF:Find("shop")

	local var0_2 = arg0_2.shopTF:Find("goods/content")

	arg0_2.goodsUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))
	arg0_2.shopRefreshTF = arg0_2.shopTF:Find("refresh")
	arg0_2.normalTF = arg0_2.rootTF:Find("normal")
	arg0_2.titleTF = arg0_2.normalTF:Find("title/Text")
	arg0_2.picTF = arg0_2.normalTF:Find("content/icon_bg/icon_mask/icon")
	arg0_2.nameTF = arg0_2.normalTF:Find("content/name")
	arg0_2.descTF = arg0_2.normalTF:Find("content/desc_view/mask/desc")
	arg0_2.enterTF = arg0_2.normalTF:Find("options/enter")

	setScrollText(arg0_2.normalTF:Find("options/exit/mask/Text"), i18n("child2_site_exit"))

	arg0_2.imageColorTFs = {
		arg0_2.normalTF:Find("title"),
		arg0_2.normalTF:Find("line"),
		arg0_2.normalTF:Find("content/azurlane"),
		arg0_2.normalTF:Find("content/name/Image")
	}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.rootTF:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.shopTF:Find("close_btn"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.normalTF:Find("close_btn"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.normalTF:Find("options/exit"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.shopRefreshTF, function()
		arg0_3:emit(NewEducateMapMediator.ON_REFRESH_SHOP)
	end, SFX_PANEL)
	arg0_3.goodsUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_3:UpdateGoodsItem(arg1_9, arg2_9)
		end
	end)

	arg0_3.shopRefreshCost = pg.gameset.child2_shop_refresh_price.key_value
	arg0_3.shopRefreshSellCnt = pg.gameset.child2_shop_refresh_count.key_value
end

function var0_0.Show(arg0_10, arg1_10)
	var0_0.super.Show(arg0_10)

	arg0_10.siteId = arg1_10

	arg0_10:Flush()
end

function var0_0.Flush(arg0_11)
	local var0_11 = pg.child2_site_display[arg0_11.siteId]

	if var0_11.type == NewEducateConst.SITE_TYPE.SHOP then
		setText(arg0_11.shopTF:Find("title"), var0_11.title)
		setText(arg0_11.shopRefreshTF:Find("cost/Text"), arg0_11.shopRefreshCost)
		arg0_11:ShowShop()
	else
		arg0_11:ShowNormal(var0_11)
	end
end

function var0_0.UpdateCost(arg0_12, arg1_12, arg2_12)
	local var0_12 = NewEducateHelper.GetDropConfig(arg2_12).icon

	LoadImageSpriteAsync("neweducateicon/" .. var0_12, arg1_12:Find("Image"))
	setText(arg1_12:Find("Text"), "-" .. arg2_12.number)
end

function var0_0.ShowNormal(arg0_13, arg1_13)
	setActive(arg0_13.shopTF, false)
	setActive(arg0_13.normalTF, true)
	setText(arg0_13.titleTF, arg1_13.title)
	LoadImageSpriteAsync("neweducateicon/" .. arg1_13.banner, arg0_13.picTF, true)
	setText(arg0_13.nameTF, arg1_13.title)
	setText(arg0_13.descTF, arg1_13.desc)

	local var0_13, var1_13 = NewEducateHelper.GetSiteColors(arg1_13.id)

	setTextColor(arg0_13.nameTF, var1_13)
	underscore.each(arg0_13.imageColorTFs, function(arg0_14)
		setImageColor(arg0_14, var0_13)
	end)

	local var2_13 = {}
	local var3_13 = ""

	local function var4_13()
		return
	end

	switch(arg1_13.type, {
		[NewEducateConst.SITE_TYPE.WORK] = function()
			local var0_16 = arg0_13.contextData.char:GetNormalIdByType(NewEducateConst.SITE_NORMAL_TYPE.WORK)
			local var1_16 = pg.child2_site_normal[var0_16]

			var3_13 = var1_16.title
			var2_13 = NewEducateHelper.Config2Drop(var1_16.cost)

			function var4_13()
				arg0_13:emit(NewEducateMapMediator.ON_SITE_NORMAL, var1_16.id)
			end
		end,
		[NewEducateConst.SITE_TYPE.TRAVEL] = function()
			local var0_18 = arg0_13.contextData.char:GetNormalIdByType(NewEducateConst.SITE_NORMAL_TYPE.TRAVEL)
			local var1_18 = pg.child2_site_normal[var0_18]

			var3_13 = var1_18.title
			var2_13 = NewEducateHelper.Config2Drop(var1_18.cost)

			function var4_13()
				arg0_13:emit(NewEducateMapMediator.ON_SITE_NORMAL, var1_18.id)
			end
		end,
		[NewEducateConst.SITE_TYPE.SHIP] = function()
			local var0_20 = pg.child2_site_character[arg1_13.param]

			var3_13 = var0_20.option_name
			var2_13 = NewEducateHelper.Config2Drop(var0_20.cost)

			function var4_13()
				arg0_13:emit(NewEducateMapMediator.ON_SITE_SHIP, var0_20.id)
			end
		end,
		[NewEducateConst.SITE_TYPE.EVENT] = function()
			local var0_22 = pg.child2_site_event_group[arg1_13.param]

			var3_13 = var0_22.option_word
			var2_13 = NewEducateHelper.Config2Drop(var0_22.event_cost)

			function var4_13()
				arg0_13:emit(NewEducateMapMediator.ON_SITE_EVENT, var0_22.id)
			end
		end
	})
	setScrollText(arg0_13.enterTF:Find("mask/Text"), var3_13)
	arg0_13:UpdateCost(arg0_13.enterTF:Find("cost"), var2_13)

	var2_13.operator = ">="

	local var5_13 = not arg0_13.contextData.char:IsMatch(var2_13)

	setImageColor(arg0_13.enterTF, Color.NewHex(var5_13 and "C8CAD5" or "FFFFFF"))
	setTextColor(arg0_13.enterTF:Find("mask/Text"), Color.NewHex(var5_13 and "717171" or "393A3C"))

	if not var5_13 then
		onButton(arg0_13, arg0_13.enterTF, function()
			var4_13()
			arg0_13:Hide(true)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_13.enterTF)
	end
end

function var0_0.ShowShop(arg0_25)
	arg0_25.discountInfos = arg0_25.contextData.char:GetGoodsDiscountInfos()

	local var0_25 = arg0_25.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.MAP)

	arg0_25.goods = var0_25:GetGoodList()

	table.sort(arg0_25.goods, CompareFuncs({
		function(arg0_26)
			local var0_26 = pg.child2_shop[arg0_26.id].limit_num

			return arg0_26:GetRemainCnt() > 0 and 0 or 1
		end,
		function(arg0_27)
			return arg0_27:IsLimitCnt() and 0 or 1
		end,
		function(arg0_28)
			return arg0_28.id
		end
	}))
	setActive(arg0_25.shopTF, true)
	setActive(arg0_25.normalTF, false)
	arg0_25.goodsUIList:align(#arg0_25.goods)
	arg0_25:UpdateShopRefreshInfos(var0_25:GetRefreshShopCnt())
end

function var0_0.UpdateShopRefreshInfos(arg0_29, arg1_29)
	local var0_29 = arg0_29.contextData.char:GetResByType(NewEducateChar.RES_TYPE.REFRESH_SHOP)

	setText(arg0_29.shopRefreshTF:Find("Text"), var0_29)
	setActive(arg0_29.shopRefreshTF, var0_29 > 0 or arg1_29 < arg0_29.shopRefreshSellCnt)
	setActive(arg0_29.shopRefreshTF:Find("Text"), var0_29 > 0)
	setActive(arg0_29.shopRefreshTF:Find("cost"), var0_29 <= 0 and arg1_29 < arg0_29.shopRefreshSellCnt)
end

function var0_0.UpdateGoodsItem(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.goods[arg1_30 + 1]

	arg2_30.name = var0_30.id

	LoadImageSpriteAsync("neweducateicon/" .. var0_30:getConfig("icon"), arg2_30:Find("frame/icon"))
	setText(arg2_30:Find("name"), var0_30:getConfig("name"))
	setText(arg2_30:Find("frame/count_bg/count"), "x" .. var0_30:getConfig("goods_num"))
	setText(arg2_30:Find("desc"), var0_30:getConfig("desc"))
	setActive(arg2_30:Find("limit_time"), var0_30:IsLimitTime())
	setActive(arg2_30:Find("limit_cnt"), var0_30:IsLimitCnt())

	if var0_30:IsLimitCnt() then
		setText(arg2_30:Find("limit_cnt"), i18n("child2_shop_limit_cnt") .. var0_30:GetRemainCnt() .. "/" .. var0_30:GetLimitCnt())
	end

	local var1_30 = var0_30:GetRemainCnt() <= 0

	setActive(arg2_30:Find("sold_out"), var1_30)

	local var2_30 = var0_30:GetCostCondition()
	local var3_30 = var0_30:GetCostWithBenefit(arg0_30.discountInfos)
	local var4_30 = var3_30.number ~= var2_30.number and "(" .. var3_30.number .. ")" or ""

	setText(arg2_30:Find("price"), var2_30.number .. var4_30)

	if var1_30 then
		removeOnButton(arg2_30)
	else
		onButton(arg0_30, arg2_30, function()
			arg0_30:emit(NewEducateBaseUI.ON_SHOP, {
				shopId = var0_30.id,
				price = var3_30.number,
				onBuy = function()
					arg0_30:OnClickBuy(var0_30)
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.SendBuyProto(arg0_33, arg1_33)
	arg0_33:emit(NewEducateMapMediator.ON_SHOPPING, arg1_33.id)
end

function var0_0.OnClickBuy(arg0_34, arg1_34)
	local var0_34 = arg1_34:getConfig("goods_type")

	if var0_34 == NewEducateGoods.TYPE.BENEFIT then
		arg0_34:ClickBenefitGood(arg1_34)
	elseif var0_34 == NewEducateGoods.TYPE.RES then
		arg0_34:ClickResGood(arg1_34)
	elseif var0_34 == NewEducateGoods.TYPE.UP_ENTRY then
		existCall(arg0_34.contextData.onClickUpEntryGood, arg1_34)
	else
		arg0_34:SendBuyProto(arg1_34)
	end
end

function var0_0.ClickBenefitGood(arg0_35, arg1_35)
	local var0_35 = {}
	local var1_35 = arg1_35:getConfig("goods_id")
	local var2_35 = arg0_35.contextData.char:GetStatus(arg1_35:getConfig("goods_id"))

	if var2_35 and var2_35:getConfig("is_tip") == 0 then
		local var3_35 = var2_35:GetEndRound() - arg0_35.contextData.char:GetRoundData().round
		local var4_35 = var2_35:getConfig("during_time") == -1 and "child2_shop_benefit_sure2" or "child2_shop_benefit_sure"

		table.insert(var0_35, function(arg0_36)
			arg0_35:emit(NewEducateBaseUI.ON_BOX, {
				content = i18n(var4_35, var3_35),
				onYes = arg0_36
			})
		end)
	end

	seriesAsync(var0_35, function()
		arg0_35:SendBuyProto(arg1_35)
	end)
end

function var0_0.ClickResGood(arg0_38, arg1_38)
	local var0_38 = {}
	local var1_38 = arg0_38.contextData.char:GetResIdByType(NewEducateChar.RES_TYPE.ACTION)

	if arg1_38:getConfig("goods_id") == var1_38 and arg0_38.contextData.char:GetPoint(var1_38) + arg1_38:getConfig("goods_num") > pg.child2_resource[var1_38].max_value then
		table.insert(var0_38, function(arg0_39)
			arg0_38:emit(NewEducateBaseUI.ON_BOX, {
				content = i18n("child2_shop_point_sure"),
				onYes = arg0_39
			})
		end)
	end

	seriesAsync(var0_38, function()
		arg0_38:SendBuyProto(arg1_38)
	end)
end

function var0_0.FlushShop(arg0_41)
	arg0_41:ShowShop()
end

function var0_0.Hide(arg0_42, arg1_42)
	if not arg1_42 then
		existCall(arg0_42.contextData.onHide)
	end

	arg0_42.super.Hide(arg0_42)
end

function var0_0.OnDestroy(arg0_43)
	return
end

return var0_0
