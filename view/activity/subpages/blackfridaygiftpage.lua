local var0 = class("BlackFridayGiftPage", import("...base.BaseActivityPage"))

var0.DAY_COLOR = {
	"110C08",
	"C8A471"
}

function var0.OnInit(arg0)
	arg0.rtGift = arg0._tf:Find("AD/gift")
	arg0.rtFreeGift = arg0._tf:Find("AD/gift_free")

	local var0 = arg0._tf:Find("AD/days")

	arg0.uiList = UIItemList.New(var0, var0:Find("day"))

	arg0.uiList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			setText(arg2:Find("Text"), "DAY" .. arg1)
			setTextColor(arg2:Find("Text"), Color.NewHex(arg0.DAY_COLOR[2]))
			setActive(arg2:Find("lock"), arg1 > arg0.nday)
			setActive(arg2:Find("tip"), arg1 <= arg0.nday and arg0.freeGifts[arg1]:canPurchase())
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.index = arg1

					arg0:ShowGifts(arg1)
				end

				setTextColor(arg2:Find("Text"), Color.NewHex(arg0.DAY_COLOR[arg0 and 1 or 2]))
			end, SFX_PANEL)
		end
	end)
end

function var0.OnDataSetting(arg0)
	if not arg0.idLists then
		arg0.idLists = arg0.activity:getConfig("config_client").gifts

		assert(#arg0.idLists[1] == #arg0.idLists[2])
	end

	arg0.nday = math.min(#arg0.idLists[1], arg0.activity:getNDay())

	local var0 = getProxy(ShopsProxy)

	arg0.gifts = underscore.map(arg0.idLists[1], function(arg0)
		return var0:GetGiftCommodity(arg0, Goods.TYPE_CHARGE)
	end)
	arg0.freeGifts = underscore.map(arg0.idLists[2], function(arg0)
		return var0:GetGiftCommodity(arg0, Goods.TYPE_GIFT_PACKAGE)
	end)
end

function var0.OnUpdateFlush(arg0)
	arg0.uiList:align(#arg0.idLists[1])

	if not arg0.index then
		arg0.index = arg0.nday

		while arg0.index > 0 and not arg0.gifts[arg0.index]:canPurchase() and not arg0.freeGifts[arg0.index]:canPurchase() do
			arg0.index = arg0.index - 1
		end

		arg0.index = (arg0.index - 1) % arg0.nday + 1

		triggerToggle(arg0.uiList.container:GetChild(arg0.index - 1), true)
	else
		arg0:ShowGifts(arg0.index)
	end
end

function var0.ShowGifts(arg0, arg1)
	arg0:UpdateCard(arg0.rtGift, arg0.gifts[arg0.index])
	arg0:UpdateCard(arg0.rtFreeGift, arg0.freeGifts[arg0.index])
end

local function var1(arg0)
	return ({
		"hot",
		"new_tag",
		"tuijian",
		"shuangbei_tag",
		"activity",
		"xianshi"
	})[arg0] or "hot"
end

function var0.UpdateCard(arg0, arg1, arg2)
	local var0

	if arg2:isChargeType() then
		var0 = {
			isFree = false,
			name = arg2:getConfig("name_display"),
			price = arg2:getConfig("money"),
			count = arg2:GetLimitDesc(),
			desc = arg2:getConfig("descrip"),
			free = i18n("shop_free_tag"),
			purchased = i18n("blackfriday_pack_purchased"),
			icon = "ChargeIcon/" .. arg2:getConfig("picture"),
			items = underscore(arg2:getConfig("display")):chain():first(3):map(function(arg0)
				local var0 = {}

				var0.type, var0.id, var0.count = unpack(arg0)

				return var0
			end):value()
		}
	else
		local var1 = Item.getConfigData(arg2:getConfig("effect_args")[1])

		var0 = {
			isFree = true,
			name = var1.name,
			price = arg2:getConfig("resource_num"),
			count = arg2:GetLimitDesc(),
			desc = var1.display,
			free = i18n("shop_free_tag"),
			purchased = i18n("blackfriday_pack_purchased"),
			icon = var1.icon,
			items = underscore(var1.display_icon):chain():first(3):map(function(arg0)
				local var0 = {}

				var0.type, var0.id, var0.count = unpack(arg0)

				return var0
			end):value()
		}
	end

	setText(arg1:Find("name/Text"), var0.name)

	local var2 = var0.isFree

	if not tonumber(var0.price) then
		setText(arg1:Find("price"), var0.price)
	else
		setText(arg1:Find("price"), GetMoneySymbol() .. var0.price)
	end

	setText(arg1:Find("count"), var0.count)
	setText(arg1:Find("desc"), var0.desc)
	setText(arg1:Find("free"), var0.free)
	setText(arg1:Find("purchased"), var0.purchased)

	local var3 = arg2:inTime()

	setActive(arg1:Find("mask_lock"), not var3)

	local var4 = arg2:canPurchase()

	setActive(arg1:Find("mask_purchased"), not var4)
	setActive(arg1:Find("purchased"), not var4)
	setActive(arg1:Find("free"), var4 and var2)
	setActive(arg1:Find("price"), var4 and not var2)
	GetImageSpriteFromAtlasAsync(var0.icon, "", arg1:Find("icon/Image"), true)
	GetImageSpriteFromAtlasAsync("chargeTag", var1(arg2:getConfig("tag")), arg1:Find("icon/tag"), true)
	UIItemList.StaticAlign(arg1:Find("awards"), arg1:Find("awards/award"), #var0.items, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0.items[arg1 + 1]

			updateDrop(arg2, var0)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var0)
			end, SFX_PANEL)
		end
	end)

	local var5 = arg1:Find("tip")

	if var5 then
		setActive(var5, var3 and var4)
	end

	local var6 = arg2:getTimeStamp()
	local var7 = pg.TimeMgr.GetInstance():STimeDescS(var6, "%m.%d")

	onButton(arg0, arg1, function()
		if not var3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("blackfriday_pack_lock", var7))
		elseif not arg2:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))
		else
			arg0:OnCharge(arg2)
		end
	end, SFX_PANEL)
end

function var0.OnCharge(arg0, arg1)
	if arg1:isChargeType() then
		local var0 = arg1:getConfig("tag")
		local var1 = underscore.map(arg1:getConfig("extra_service_item"), function(arg0)
			return {
				type = arg0[1],
				id = arg0[2],
				count = arg0[3]
			}
		end)
		local var2
		local var3
		local var4 = arg1:getConfig("gem") + arg1:getConfig("extra_gem")

		if var4 > 0 then
			table.insert(var1, {
				id = 4,
				type = 1,
				count = var4
			})
		end

		local var5 = i18n("charge_title_getitem")
		local var6
		local var7 = {
			isChargeType = true,
			icon = "chargeicon/" .. arg1:getConfig("picture"),
			name = arg1:getConfig("name_display"),
			tipExtra = var5,
			extraItems = var1,
			price = arg1:getConfig("money"),
			isLocalPrice = arg1:IsLocalPrice(),
			tagType = var0,
			isMonthCard = arg1:isMonthCard(),
			tipBonus = var6,
			bonusItem = var3,
			extraDrop = var2,
			descExtra = arg1:getConfig("descrip_extra"),
			limitArgs = arg1:getConfig("limit_args"),
			onYes = function()
				if ChargeConst.isNeedSetBirth() then
					arg0:emit(ActivityMediator.OPEN_CHARGE_BIRTHDAY)
				else
					arg0:emit(ActivityMediator.CHARGE, arg1.id)
				end
			end
		}

		arg0:emit(ActivityMediator.OPEN_CHARGE_ITEM_PANEL, var7)
	else
		local var8 = {}
		local var9 = arg1:getConfig("effect_args")
		local var10 = Item.getConfigData(var9[1])
		local var11 = var10.display_icon

		if type(var11) == "table" then
			for iter0, iter1 in ipairs(var11) do
				table.insert(var8, {
					type = iter1[1],
					id = iter1[2],
					count = iter1[3]
				})
			end
		end

		local var12 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var10.icon,
			name = var10.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var8,
			price = arg1:getConfig("resource_num"),
			tagType = arg1:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1:getConfig("resource_num"), var10.name),
					onYes = function()
						arg0:emit(ActivityMediator.BUY_ITEM, arg1.id, 1)
					end
				})
			end
		}

		arg0:emit(ActivityMediator.OPEN_CHARGE_ITEM_PANEL, var12)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
