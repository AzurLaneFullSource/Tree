local var0_0 = class("NewServerGiftPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewServerGiftPage"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
end

function var0_0.initData(arg0_3)
	arg0_3.player = getProxy(PlayerProxy):getData()
	arg0_3.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)
	arg0_3.goodIdList = arg0_3.activity:getConfig("config_data")

	arg0_3:updateGiftGoodsVOList()
end

function var0_0.initUI(arg0_4)
	arg0_4.content = arg0_4:findTF("scrollrect/content")
	arg0_4.soldOutTF = arg0_4:findTF("sold_out")

	setText(arg0_4:findTF("Text", arg0_4.soldOutTF), i18n("newserver_soldout"))
	setActive(arg0_4.soldOutTF, #arg0_4.giftGoodsVOList == 0)

	arg0_4.giftItemList = UIItemList.New(arg0_4.content, arg0_4:findTF("gift_tpl"))
	arg0_4.chargeCardTable = {}

	arg0_4.giftItemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventInit then
			arg0_4:initGift(go(arg2_5))
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_4:updateGift(go(arg2_5), arg1_5)
		end
	end)
	arg0_4.giftItemList:align(#arg0_4.giftGoodsVOList)
end

function var0_0.initGift(arg0_6, arg1_6)
	local var0_6 = ChargeCard.New(arg1_6)

	onButton(arg0_6, var0_6.tr, function()
		arg0_6:confirm(var0_6.goods)
	end, SFX_PANEL)

	arg0_6.chargeCardTable[arg1_6] = var0_6
end

function var0_0.updateGift(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.chargeCardTable[arg1_8]

	if not var0_8 then
		arg0_8.initGift(arg1_8)

		var0_8 = arg0_8.chargeCardTable[arg1_8]
	end

	local var1_8 = arg0_8.giftGoodsVOList[arg2_8]

	if var1_8 then
		var0_8:update(var1_8, arg0_8.player, arg0_8.firstChargeIds)
	end
end

function var0_0.confirm(arg0_9, arg1_9)
	if not arg1_9 then
		return
	end

	arg1_9 = Clone(arg1_9)

	local var0_9 = {}
	local var1_9 = arg1_9:getConfig("effect_args")
	local var2_9 = Item.getConfigData(var1_9[1])
	local var3_9 = var2_9.display_icon

	if type(var3_9) == "table" then
		for iter0_9, iter1_9 in ipairs(var3_9) do
			table.insert(var0_9, {
				type = iter1_9[1],
				id = iter1_9[2],
				count = iter1_9[3]
			})
		end
	end

	local var4_9 = {
		isMonthCard = false,
		isChargeType = false,
		isLocalPrice = false,
		icon = var2_9.icon,
		name = var2_9.name,
		tipExtra = i18n("charge_title_getitem"),
		extraItems = var0_9,
		price = arg1_9:getConfig("resource_num"),
		tagType = arg1_9:getConfig("tag"),
		onYes = function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("charge_scene_buy_confirm", arg1_9:getConfig("resource_num"), var2_9.name),
				onYes = function()
					arg0_9:emit(NewServerCarnivalMediator.GIFT_BUY_ITEM, arg1_9.id, 1)
				end
			})
		end
	}

	arg0_9:emit(NewServerCarnivalMediator.GIFT_OPEN_ITEM_PANEL, var4_9)
end

function var0_0.onUpdatePlayer(arg0_12, arg1_12)
	arg0_12.player = arg1_12
end

function var0_0.onUpdateGift(arg0_13)
	arg0_13:updateGiftGoodsVOList()
	arg0_13.giftItemList:align(#arg0_13.giftGoodsVOList)
	setActive(arg0_13.soldOutTF, #arg0_13.giftGoodsVOList == 0)
end

function var0_0.updateGiftGoodsVOList(arg0_14)
	arg0_14.normalList = getProxy(ShopsProxy):GetNormalList()
	arg0_14.giftGoodsVOList = {}

	local var0_14 = pg.shop_template

	for iter0_14, iter1_14 in pairs(arg0_14.goodIdList) do
		local var1_14 = Goods.Create({
			shop_id = iter1_14
		}, Goods.TYPE_NEW_SERVER)

		table.insert(arg0_14.giftGoodsVOList, var1_14)
	end

	local var2_14 = {}

	for iter2_14, iter3_14 in ipairs(arg0_14.giftGoodsVOList) do
		local var3_14 = ChargeConst.getBuyCount(arg0_14.normalList, iter3_14.id)

		iter3_14:updateBuyCount(var3_14)

		if iter3_14:canPurchase() then
			table.insert(var2_14, iter3_14)
		end
	end

	arg0_14.giftGoodsVOList = var2_14
end

function var0_0.isTip(arg0_15)
	if not arg0_15.playerId then
		arg0_15.playerId = getProxy(PlayerProxy):getData().id
	end

	return PlayerPrefs.GetInt("newserver_gift_first_" .. arg0_15.playerId) == 0
end

function var0_0.OnDestroy(arg0_16)
	return
end

return var0_0
