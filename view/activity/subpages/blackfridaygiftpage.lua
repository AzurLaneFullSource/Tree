local var0_0 = class("BlackFridayGiftPage", import("...base.BaseActivityPage"))

var0_0.DAY_COLOR = {
	"110C08",
	"C8A471"
}

function var0_0.OnInit(arg0_1)
	arg0_1.rtGift = arg0_1._tf:Find("AD/gift")
	arg0_1.rtFreeGift = arg0_1._tf:Find("AD/gift_free")

	local var0_1 = arg0_1._tf:Find("AD/days")

	arg0_1.uiList = UIItemList.New(var0_1, var0_1:Find("day"))

	arg0_1.uiList:make(function(arg0_2, arg1_2, arg2_2)
		arg1_2 = arg1_2 + 1

		if arg0_2 == UIItemList.EventUpdate then
			setText(arg2_2:Find("Text"), "DAY" .. arg1_2)
			setTextColor(arg2_2:Find("Text"), Color.NewHex(arg0_1.DAY_COLOR[2]))
			setActive(arg2_2:Find("lock"), arg1_2 > arg0_1.nday)
			setActive(arg2_2:Find("tip"), arg1_2 <= arg0_1.nday and arg0_1.freeGifts[arg1_2]:canPurchase())
			onToggle(arg0_1, arg2_2, function(arg0_3)
				if arg0_3 then
					arg0_1.index = arg1_2

					arg0_1:ShowGifts(arg1_2)
				end

				setTextColor(arg2_2:Find("Text"), Color.NewHex(arg0_1.DAY_COLOR[arg0_3 and 1 or 2]))
			end, SFX_PANEL)
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

	arg0_4.gifts = underscore.map(arg0_4.idLists[1], function(arg0_5)
		return var0_4:GetGiftCommodity(arg0_5, Goods.TYPE_CHARGE)
	end)
	arg0_4.freeGifts = underscore.map(arg0_4.idLists[2], function(arg0_6)
		return var0_4:GetGiftCommodity(arg0_6, Goods.TYPE_GIFT_PACKAGE)
	end)
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7.uiList:align(#arg0_7.idLists[1])

	if not arg0_7.index then
		arg0_7.index = arg0_7.nday

		while arg0_7.index > 0 and not arg0_7.gifts[arg0_7.index]:canPurchase() and not arg0_7.freeGifts[arg0_7.index]:canPurchase() do
			arg0_7.index = arg0_7.index - 1
		end

		arg0_7.index = (arg0_7.index - 1) % arg0_7.nday + 1

		triggerToggle(arg0_7.uiList.container:GetChild(arg0_7.index - 1), true)
	else
		arg0_7:ShowGifts(arg0_7.index)
	end
end

function var0_0.ShowGifts(arg0_8, arg1_8)
	arg0_8:UpdateCard(arg0_8.rtGift, arg0_8.gifts[arg0_8.index])
	arg0_8:UpdateCard(arg0_8.rtFreeGift, arg0_8.freeGifts[arg0_8.index])
end

local function var1_0(arg0_9)
	return ({
		"hot",
		"new_tag",
		"tuijian",
		"shuangbei_tag",
		"activity",
		"xianshi"
	})[arg0_9] or "hot"
end

function var0_0.UpdateCard(arg0_10, arg1_10, arg2_10)
	local var0_10

	if arg2_10:isChargeType() then
		var0_10 = {
			isFree = false,
			name = arg2_10:getConfig("name_display"),
			price = arg2_10:getConfig("money"),
			count = arg2_10:GetLimitDesc(),
			desc = arg2_10:getConfig("descrip"),
			free = i18n("shop_free_tag"),
			purchased = i18n("blackfriday_pack_purchased"),
			icon = "ChargeIcon/" .. arg2_10:getConfig("picture"),
			items = underscore(arg2_10:getConfig("display")):chain():first(3):map(function(arg0_11)
				local var0_11 = {}

				var0_11.type, var0_11.id, var0_11.count = unpack(arg0_11)

				return var0_11
			end):value()
		}
	else
		local var1_10 = Item.getConfigData(arg2_10:getConfig("effect_args")[1])

		var0_10 = {
			isFree = true,
			name = var1_10.name,
			price = arg2_10:getConfig("resource_num"),
			count = arg2_10:GetLimitDesc(),
			desc = var1_10.display,
			free = i18n("shop_free_tag"),
			purchased = i18n("blackfriday_pack_purchased"),
			icon = var1_10.icon,
			items = underscore(var1_10.display_icon):chain():first(3):map(function(arg0_12)
				local var0_12 = {}

				var0_12.type, var0_12.id, var0_12.count = unpack(arg0_12)

				return var0_12
			end):value()
		}
	end

	setText(arg1_10:Find("name/Text"), var0_10.name)

	local var2_10 = var0_10.isFree

	if not tonumber(var0_10.price) then
		setText(arg1_10:Find("price"), var0_10.price)
	else
		setText(arg1_10:Find("price"), GetMoneySymbol() .. var0_10.price)
	end

	setText(arg1_10:Find("count"), var0_10.count)
	setText(arg1_10:Find("desc"), var0_10.desc)
	setText(arg1_10:Find("free"), var0_10.free)
	setText(arg1_10:Find("purchased"), var0_10.purchased)

	local var3_10 = arg2_10:inTime()

	setActive(arg1_10:Find("mask_lock"), not var3_10)

	local var4_10 = arg2_10:canPurchase()

	setActive(arg1_10:Find("mask_purchased"), not var4_10)
	setActive(arg1_10:Find("purchased"), not var4_10)
	setActive(arg1_10:Find("free"), var4_10 and var2_10)
	setActive(arg1_10:Find("price"), var4_10 and not var2_10)
	GetImageSpriteFromAtlasAsync(var0_10.icon, "", arg1_10:Find("icon/Image"), true)
	GetImageSpriteFromAtlasAsync("chargeTag", var1_0(arg2_10:getConfig("tag")), arg1_10:Find("icon/tag"), true)
	UIItemList.StaticAlign(arg1_10:Find("awards"), arg1_10:Find("awards/award"), #var0_10.items, function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var0_10.items[arg1_13 + 1]

			updateDrop(arg2_13, var0_13)
			onButton(arg0_10, arg2_13, function()
				arg0_10:emit(BaseUI.ON_DROP, var0_13)
			end, SFX_PANEL)
		end
	end)

	local var5_10 = arg1_10:Find("tip")

	if var5_10 then
		setActive(var5_10, var3_10 and var4_10)
	end

	local var6_10 = arg2_10:getTimeStamp()
	local var7_10 = pg.TimeMgr.GetInstance():STimeDescS(var6_10, "%m.%d")

	onButton(arg0_10, arg1_10, function()
		if not var3_10 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("blackfriday_pack_lock", var7_10))
		elseif not arg2_10:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))
		else
			arg0_10:OnCharge(arg2_10)
		end
	end, SFX_PANEL)
end

function var0_0.OnCharge(arg0_16, arg1_16)
	if arg1_16:isChargeType() then
		local var0_16 = arg1_16:getConfig("tag")
		local var1_16 = underscore.map(arg1_16:getConfig("extra_service_item"), function(arg0_17)
			return {
				type = arg0_17[1],
				id = arg0_17[2],
				count = arg0_17[3]
			}
		end)
		local var2_16
		local var3_16
		local var4_16 = arg1_16:getConfig("gem") + arg1_16:getConfig("extra_gem")

		if var4_16 > 0 then
			table.insert(var1_16, {
				id = 4,
				type = 1,
				count = var4_16
			})
		end

		local var5_16 = i18n("charge_title_getitem")
		local var6_16
		local var7_16 = {
			isChargeType = true,
			icon = "chargeicon/" .. arg1_16:getConfig("picture"),
			name = arg1_16:getConfig("name_display"),
			tipExtra = var5_16,
			extraItems = var1_16,
			price = arg1_16:getConfig("money"),
			isLocalPrice = arg1_16:IsLocalPrice(),
			tagType = var0_16,
			isMonthCard = arg1_16:isMonthCard(),
			tipBonus = var6_16,
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

		arg0_16:emit(ActivityMediator.OPEN_CHARGE_ITEM_PANEL, var7_16)
	else
		local var8_16 = {}
		local var9_16 = arg1_16:getConfig("effect_args")
		local var10_16 = Item.getConfigData(var9_16[1])
		local var11_16 = var10_16.display_icon

		if type(var11_16) == "table" then
			for iter0_16, iter1_16 in ipairs(var11_16) do
				table.insert(var8_16, {
					type = iter1_16[1],
					id = iter1_16[2],
					count = iter1_16[3]
				})
			end
		end

		local var12_16 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var10_16.icon,
			name = var10_16.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var8_16,
			price = arg1_16:getConfig("resource_num"),
			tagType = arg1_16:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_16:getConfig("resource_num"), var10_16.name),
					onYes = function()
						arg0_16:emit(ActivityMediator.BUY_ITEM, arg1_16.id, 1)
					end
				})
			end
		}

		arg0_16:emit(ActivityMediator.OPEN_CHARGE_ITEM_PANEL, var12_16)
	end
end

function var0_0.OnDestroy(arg0_21)
	return
end

return var0_0
