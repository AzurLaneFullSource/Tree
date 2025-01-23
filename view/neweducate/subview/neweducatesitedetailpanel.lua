local var0_0 = class("NewEducateSiteDetailPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewEducateSiteDetailPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.shopTF = arg0_2.rootTF:Find("shop")

	local var0_2 = arg0_2.shopTF:Find("goods/content")

	arg0_2.goodsUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))
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
	arg0_3.goodsUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_3:UpdateGoodsItem(arg1_8, arg2_8)
		end
	end)
end

function var0_0.Show(arg0_9, arg1_9)
	var0_0.super.Show(arg0_9)

	arg0_9.siteId = arg1_9

	arg0_9:Flush()
end

function var0_0.Flush(arg0_10)
	local var0_10 = pg.child2_site_display[arg0_10.siteId]

	if var0_10.type == NewEducateConst.SITE_TYPE.SHOP then
		setText(arg0_10.shopTF:Find("title"), var0_10.title)
		arg0_10:ShowShop()
	else
		arg0_10:ShowNormal(var0_10)
	end
end

function var0_0.UpdateCost(arg0_11, arg1_11, arg2_11)
	local var0_11 = NewEducateHelper.GetDropConfig(arg2_11).icon

	LoadImageSpriteAsync("neweducateicon/" .. var0_11, arg1_11:Find("Image"))
	setText(arg1_11:Find("Text"), "-" .. arg2_11.number)
end

function var0_0.ShowNormal(arg0_12, arg1_12)
	setActive(arg0_12.shopTF, false)
	setActive(arg0_12.normalTF, true)
	setText(arg0_12.titleTF, arg1_12.title)
	LoadImageSpriteAsync("neweducateicon/" .. arg1_12.banner, arg0_12.picTF, true)
	setText(arg0_12.nameTF, arg1_12.title)
	setText(arg0_12.descTF, arg1_12.desc)

	local var0_12, var1_12 = NewEducateHelper.GetSiteColors(arg1_12.id)

	setTextColor(arg0_12.nameTF, var1_12)
	underscore.each(arg0_12.imageColorTFs, function(arg0_13)
		setImageColor(arg0_13, var0_12)
	end)

	local var2_12 = {}
	local var3_12 = ""

	local function var4_12()
		return
	end

	switch(arg1_12.type, {
		[NewEducateConst.SITE_TYPE.WORK] = function()
			local var0_15 = arg0_12.contextData.char:GetNormalIdByType(NewEducateConst.SITE_NORMAL_TYPE.WORK)
			local var1_15 = pg.child2_site_normal[var0_15]

			var3_12 = var1_15.title
			var2_12 = NewEducateHelper.Config2Drop(var1_15.cost)

			function var4_12()
				arg0_12:emit(NewEducateMapMediator.ON_SITE_NORMAL, var1_15.id)
			end
		end,
		[NewEducateConst.SITE_TYPE.TRAVEL] = function()
			local var0_17 = arg0_12.contextData.char:GetNormalIdByType(NewEducateConst.SITE_NORMAL_TYPE.TRAVEL)
			local var1_17 = pg.child2_site_normal[var0_17]

			var3_12 = var1_17.title
			var2_12 = NewEducateHelper.Config2Drop(var1_17.cost)

			function var4_12()
				arg0_12:emit(NewEducateMapMediator.ON_SITE_NORMAL, var1_17.id)
			end
		end,
		[NewEducateConst.SITE_TYPE.SHIP] = function()
			local var0_19 = pg.child2_site_character[arg1_12.param]

			var3_12 = var0_19.option_name
			var2_12 = NewEducateHelper.Config2Drop(var0_19.cost)

			function var4_12()
				arg0_12:emit(NewEducateMapMediator.ON_SITE_SHIP, var0_19.id)
			end
		end,
		[NewEducateConst.SITE_TYPE.EVENT] = function()
			local var0_21 = pg.child2_site_event_group[arg1_12.param]

			var3_12 = var0_21.option_word
			var2_12 = NewEducateHelper.Config2Drop(var0_21.event_cost)

			function var4_12()
				arg0_12:emit(NewEducateMapMediator.ON_SITE_EVENT, var0_21.id)
			end
		end
	})
	setScrollText(arg0_12.enterTF:Find("mask/Text"), var3_12)
	arg0_12:UpdateCost(arg0_12.enterTF:Find("cost"), var2_12)

	var2_12.operator = ">="

	local var5_12 = not arg0_12.contextData.char:IsMatch(var2_12)

	setImageColor(arg0_12.enterTF, Color.NewHex(var5_12 and "C8CAD5" or "FFFFFF"))
	setTextColor(arg0_12.enterTF:Find("mask/Text"), Color.NewHex(var5_12 and "717171" or "393A3C"))

	if not var5_12 then
		onButton(arg0_12, arg0_12.enterTF, function()
			var4_12()
			arg0_12:Hide(true)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_12.enterTF)
	end
end

function var0_0.ShowShop(arg0_24)
	arg0_24.discountInfos = arg0_24.contextData.char:GetGoodsDiscountInfos()
	arg0_24.goods = arg0_24.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.MAP):GetGoodList()

	table.sort(arg0_24.goods, CompareFuncs({
		function(arg0_25)
			local var0_25 = pg.child2_shop[arg0_25.id].limit_num

			return arg0_25:GetRemainCnt() > 0 and 0 or 1
		end,
		function(arg0_26)
			return arg0_26:IsLimitCnt() and 0 or 1
		end,
		function(arg0_27)
			return arg0_27.id
		end
	}))
	setActive(arg0_24.shopTF, true)
	setActive(arg0_24.normalTF, false)
	arg0_24.goodsUIList:align(#arg0_24.goods)
end

function var0_0.UpdateGoodsItem(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.goods[arg1_28 + 1]

	arg2_28.name = var0_28.id

	LoadImageSpriteAsync("neweducateicon/" .. var0_28:getConfig("icon"), arg2_28:Find("frame/icon"))
	setText(arg2_28:Find("name"), var0_28:getConfig("name"))
	setText(arg2_28:Find("frame/count_bg/count"), "x" .. var0_28:getConfig("goods_num"))
	setText(arg2_28:Find("desc"), var0_28:getConfig("desc"))
	setActive(arg2_28:Find("limit_time"), var0_28:IsLimitTime())
	setActive(arg2_28:Find("limit_cnt"), var0_28:IsLimitCnt())

	if var0_28:IsLimitCnt() then
		setText(arg2_28:Find("limit_cnt"), i18n("child2_shop_limit_cnt") .. var0_28:GetRemainCnt() .. "/" .. var0_28:GetLimitCnt())
	end

	local var1_28 = var0_28:GetRemainCnt() <= 0

	setActive(arg2_28:Find("sold_out"), var1_28)

	local var2_28 = var0_28:GetCostCondition()
	local var3_28 = var0_28:GetCostWithBenefit(arg0_28.discountInfos)
	local var4_28 = var3_28.number ~= var2_28.number and "(" .. var3_28.number .. ")" or ""

	setText(arg2_28:Find("price"), var2_28.number .. var4_28)

	if var1_28 then
		removeOnButton(arg2_28)
	else
		local var5_28 = arg0_28.contextData.char:IsMatch(var3_28)

		onButton(arg0_28, arg2_28, function()
			if var5_28 then
				arg0_28:emit(NewEducateBaseUI.ON_SHOP, {
					shopId = var0_28.id,
					price = var3_28.number,
					onBuy = function()
						arg0_28:OnClickBuy(var0_28)
					end
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
			end
		end, SFX_PANEL)
	end
end

function var0_0.OnClickBuy(arg0_31, arg1_31)
	seriesAsync({
		function(arg0_32)
			local var0_32, var1_32, var2_32 = arg0_31:CheckBenefit(arg1_31)

			if var0_32 then
				arg0_31:emit(NewEducateBaseUI.ON_BOX, {
					content = i18n(var2_32, var1_32),
					onYes = arg0_32
				})
			else
				arg0_32()
			end
		end,
		function(arg0_33)
			if arg0_31:CheckPoint(arg1_31) then
				arg0_31:emit(NewEducateBaseUI.ON_BOX, {
					content = i18n("child2_shop_point_sure"),
					onYes = arg0_33
				})
			else
				arg0_33()
			end
		end
	}, function()
		arg0_31:emit(NewEducateMapMediator.ON_SHOPPING, arg1_31.id)
	end)
end

function var0_0.CheckBenefit(arg0_35, arg1_35)
	if arg1_35:IsBenefitType() then
		local var0_35 = arg0_35.contextData.char:GetStatus(arg1_35:getConfig("goods_id"))

		if var0_35 and var0_35:getConfig("is_tip") == 0 then
			local var1_35 = var0_35:getConfig("during_time") == -1 and "child2_shop_benefit_sure2" or "child2_shop_benefit_sure"

			return true, var0_35:GetEndRound() - arg0_35.contextData.char:GetRoundData().round, var1_35
		else
			return false
		end
	end

	return false
end

function var0_0.CheckPoint(arg0_36, arg1_36)
	if arg1_36:IsResType() then
		local var0_36 = arg0_36.contextData.char:GetResIdByType(NewEducateChar.RES_TYPE.ACTION)

		if arg1_36:getConfig("goods_id") == var0_36 then
			if arg0_36.contextData.char:GetPoint(var0_36) + arg1_36:getConfig("goods_num") > pg.child2_resource[var0_36].max_value then
				return true
			else
				return false
			end
		else
			return false
		end
	end

	return false
end

function var0_0.FlushShop(arg0_37)
	arg0_37:ShowShop()
end

function var0_0.Hide(arg0_38, arg1_38)
	if not arg1_38 then
		existCall(arg0_38.contextData.onHide)
	end

	arg0_38.super.Hide(arg0_38)
end

function var0_0.OnDestroy(arg0_39)
	return
end

return var0_0
