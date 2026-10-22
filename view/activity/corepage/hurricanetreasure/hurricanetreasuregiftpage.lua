local var0_0 = class("HurricaneTreasureGiftPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"ui/hurricanetreasuregiftpage_atlas"
	}

	table.insertto(var0_1, var0_0.super.getResource(arg0_1, arg1_1))

	return var0_1
end

function var0_0.OnInit(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.itemListTF = arg0_2.bg:Find("scrollView/Viewport/Content")
	arg0_2.itemTpl = arg0_2.bg:Find("scrollView/Viewport/Content/tpl")
	arg0_2.uiList = UIItemList.New(arg0_2.itemListTF, arg0_2.itemTpl)

	arg0_2.uiList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_2:UpdateGiftItem(arg1_3 + 1, arg2_3)
		end
	end)
end

function var0_0.OnDataSetting(arg0_4)
	if not arg0_4.idLists then
		arg0_4.idLists = arg0_4.activity:getConfig("config_client").gifts

		assert(#arg0_4.idLists[1] == #arg0_4.idLists[2])
	end

	arg0_4.nday = math.min(#arg0_4.idLists[1], arg0_4.activity:getNDay())

	local var0_4 = getProxy(ShopsProxy)

	arg0_4.dataList = {}

	for iter0_4 = 1, #arg0_4.idLists[1] do
		local var1_4 = var0_4:GetGiftCommodity(arg0_4.idLists[1][iter0_4], Goods.TYPE_CHARGE)
		local var2_4 = var0_4:GetGiftCommodity(arg0_4.idLists[2][iter0_4], Goods.TYPE_GIFT_PACKAGE)

		var1_4.dayIdx = iter0_4
		var2_4.dayIdx = iter0_4

		table.insert(arg0_4.dataList, var1_4)
		table.insert(arg0_4.dataList, var2_4)
	end

	local function var3_4(arg0_5, arg1_5)
		local function var0_5(arg0_6)
			if not arg0_6:canPurchase() then
				return 1
			elseif arg0_6.dayIdx > arg0_4.nday then
				return 2
			elseif arg0_6.dayIdx == arg0_4.nday then
				return 4
			else
				return 3
			end
		end

		local var1_5 = var0_5(arg0_5)
		local var2_5 = var0_5(arg1_5)

		if var1_5 ~= var2_5 then
			return var2_5 < var1_5
		end

		if var1_5 == 3 and var2_5 == 3 and arg0_5.dayIdx ~= arg1_5.dayIdx then
			return arg0_5.dayIdx > arg1_5.dayIdx
		end

		if arg0_5.dayIdx ~= arg1_5.dayIdx then
			return arg0_5.dayIdx < arg1_5.dayIdx
		end

		local var3_5 = arg0_5:isChargeType() and 0 or 1
		local var4_5 = arg1_5:isChargeType() and 0 or 1

		if var3_5 ~= var4_5 then
			return var4_5 < var3_5
		end

		if arg0_5.id ~= arg1_5.id then
			return arg0_5.id < arg1_5.id
		end

		return arg0_5.type < arg1_5.type
	end

	table.sort(arg0_4.dataList, var3_4)
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7.uiList:align(#arg0_7.dataList)
end

function var0_0.UpdateGiftItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.dataList[arg1_8]
	local var1_8 = arg0_8:getCommodityData(var0_8)
	local var2_8 = var0_8.dayIdx
	local var3_8 = var1_8.isFree and var1_8.price == 0
	local var4_8 = arg2_8:Find("limit/text")
	local var5_8 = arg2_8:Find("lock")
	local var6_8 = arg2_8:Find("lock/day")
	local var7_8 = arg2_8:Find("lock/hour")
	local var8_8 = arg2_8:Find("btnGet")
	local var9_8 = arg2_8:Find("btnBuy")
	local var10_8 = arg2_8:Find("got")

	UIItemList.StaticAlign(arg2_8:Find("awards"), arg2_8:Find("awards/item"), #var1_8.items, function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = var1_8.items[arg1_9 + 1]

			updateDrop(arg2_9, var0_9)
			onButton(arg0_8, arg2_9, function()
				arg0_8:emit(BaseUI.ON_DROP, var0_9)
			end, SFX_PANEL)
		end
	end)
	setText(var4_8, var1_8.count)
	GetImageSpriteFromAtlasAsync("ui/hurricanetreasuregiftpage_atlas", string.format("tpl_title_%s_%d", var3_8 and "free" or "day", var2_8), arg2_8:Find("title"))
	LoadSpriteAsync(var3_8 and "chargeicon/fengfanv4_free" or "chargeicon/" .. var0_8:getConfig("picture"), function(arg0_11)
		local var0_11 = arg2_8:Find("icon")

		if arg0_11 and not IsNil(var0_11) then
			setImageSprite(var0_11, arg0_11, true)
		end
	end)

	local var11_8 = var0_8:canPurchase()

	setActive(var8_8, var11_8 and var3_8)
	setActive(var9_8, var11_8 and not var3_8)
	setActive(var10_8, not var11_8)

	local var12_8 = var2_8 <= arg0_8.nday
	local var13_8 = pg.TimeMgr.GetInstance():STimeDescC(var0_8:getTimeStamp(), "*t")

	setActive(var5_8, not var12_8)
	setText(var6_8, var13_8.day)
	setText(var7_8, var13_8.hour)
	onButton(arg0_8, var3_8 and var8_8 or var9_8, function()
		if not var12_8 then
			local var0_12 = pg.TimeMgr.GetInstance():STimeDescC(var0_8:getTimeStamp(), "%m.%d")

			pg.TipsMgr.GetInstance():ShowTips(i18n("blackfriday_pack_lock", var0_12))
		elseif not var0_8:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))
		else
			arg0_8:OnCharge(var0_8)
		end
	end, SFX_PANEL)
end

function var0_0.getCommodityData(arg0_13, arg1_13)
	local var0_13

	if arg1_13:isChargeType() then
		var0_13 = {
			isFree = false,
			name = arg1_13:getConfig("name_display"),
			price = arg1_13:getConfig("money"),
			count = arg1_13:GetLimitDesc(),
			desc = arg1_13:getConfig("descrip"),
			free = i18n("shop_free_tag"),
			purchased = i18n("blackfriday_pack_purchased"),
			icon = "ChargeIcon/" .. arg1_13:getConfig("picture"),
			items = underscore(arg1_13:getConfig("display")):chain():first(3):map(function(arg0_14)
				local var0_14 = {}

				var0_14.type, var0_14.id, var0_14.count = unpack(arg0_14)

				return var0_14
			end):value()
		}
	else
		local var1_13 = Item.getConfigData(arg1_13:getConfig("effect_args")[1])

		var0_13 = {
			isFree = true,
			name = var1_13.name,
			price = arg1_13:getConfig("resource_num"),
			count = arg1_13:GetLimitDesc(),
			desc = var1_13.display,
			free = i18n("shop_free_tag"),
			purchased = i18n("blackfriday_pack_purchased"),
			icon = var1_13.icon,
			items = underscore(var1_13.display_icon):chain():first(3):map(function(arg0_15)
				local var0_15 = {}

				var0_15.type, var0_15.id, var0_15.count = unpack(arg0_15)

				return var0_15
			end):value()
		}
	end

	return var0_13
end

function var0_0.OnCharge(arg0_16, arg1_16)
	if arg1_16:isChargeType() then
		local var0_16 = arg1_16:getConfig("tag")
		local var1_16 = arg1_16:GetExtraServiceItem()
		local var2_16
		local var3_16
		local var4_16 = i18n("charge_title_getitem")
		local var5_16
		local var6_16 = {
			isChargeType = true,
			commodity = arg1_16,
			infoTip = arg1_16:GetInfoTip(),
			icon = "chargeicon/" .. arg1_16:getConfig("picture"),
			name = arg1_16:getConfig("name_display"),
			tipExtra = var4_16,
			extraItems = var1_16,
			price = arg1_16:getConfig("money"),
			isLocalPrice = arg1_16:IsLocalPrice(),
			tagType = var0_16,
			isMonthCard = arg1_16:isMonthCard(),
			tipBonus = var5_16,
			bonusItem = var3_16,
			extraDrop = var2_16,
			descExtra = arg1_16:getConfig("descrip_extra"),
			limitArgs = arg1_16:getConfig("limit_args"),
			onYes = function()
				if ChargeConst.isNeedSetBirth() then
					arg0_16:emit(ActivityMediator.OPEN_CHARGE_BIRTHDAY)
				else
					arg0_16:emit(ActivityMediator.CHARGE, arg1_16.id)
				end
			end
		}

		arg0_16:emit(ActivityMediator.OPEN_CHARGE_ITEM_PANEL, var6_16)
	else
		local var7_16 = {}
		local var8_16 = arg1_16:getConfig("effect_args")
		local var9_16 = Item.getConfigData(var8_16[1])
		local var10_16 = var9_16.display_icon

		if type(var10_16) == "table" then
			for iter0_16, iter1_16 in ipairs(var10_16) do
				table.insert(var7_16, Drop.New({
					type = iter1_16[1],
					id = iter1_16[2],
					count = iter1_16[3]
				}))
			end
		end

		local var11_16 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			commodity = arg1_16,
			icon = var9_16.icon,
			name = var9_16.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var7_16,
			price = arg1_16:getConfig("resource_num"),
			tagType = arg1_16:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_16:getConfig("resource_num"), var9_16.name),
					onYes = function()
						arg0_16:emit(ActivityMediator.BUY_ITEM, arg1_16.id, 1)
					end
				})
			end
		}

		arg0_16:emit(ActivityMediator.OPEN_CHARGE_ITEM_PANEL, var11_16)
	end
end

function var0_0.OnDestroy(arg0_20)
	return
end

return var0_0
