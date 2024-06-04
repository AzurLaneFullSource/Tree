local var0 = class("NewServerGiftPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewServerGiftPage"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
end

function var0.initData(arg0)
	arg0.player = getProxy(PlayerProxy):getData()
	arg0.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)
	arg0.goodIdList = arg0.activity:getConfig("config_data")

	arg0:updateGiftGoodsVOList()
end

function var0.initUI(arg0)
	arg0.content = arg0:findTF("scrollrect/content")
	arg0.soldOutTF = arg0:findTF("sold_out")

	setText(arg0:findTF("Text", arg0.soldOutTF), i18n("newserver_soldout"))
	setActive(arg0.soldOutTF, #arg0.giftGoodsVOList == 0)

	arg0.giftItemList = UIItemList.New(arg0.content, arg0:findTF("gift_tpl"))
	arg0.chargeCardTable = {}

	arg0.giftItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventInit then
			arg0:initGift(go(arg2))
		elseif arg0 == UIItemList.EventUpdate then
			arg0:updateGift(go(arg2), arg1)
		end
	end)
	arg0.giftItemList:align(#arg0.giftGoodsVOList)
end

function var0.initGift(arg0, arg1)
	local var0 = ChargeCard.New(arg1)

	onButton(arg0, var0.tr, function()
		arg0:confirm(var0.goods)
	end, SFX_PANEL)

	arg0.chargeCardTable[arg1] = var0
end

function var0.updateGift(arg0, arg1, arg2)
	local var0 = arg0.chargeCardTable[arg1]

	if not var0 then
		arg0.initGift(arg1)

		var0 = arg0.chargeCardTable[arg1]
	end

	local var1 = arg0.giftGoodsVOList[arg2]

	if var1 then
		var0:update(var1, arg0.player, arg0.firstChargeIds)
	end
end

function var0.confirm(arg0, arg1)
	if not arg1 then
		return
	end

	arg1 = Clone(arg1)

	local var0 = {}
	local var1 = arg1:getConfig("effect_args")
	local var2 = Item.getConfigData(var1[1])
	local var3 = var2.display_icon

	if type(var3) == "table" then
		for iter0, iter1 in ipairs(var3) do
			table.insert(var0, {
				type = iter1[1],
				id = iter1[2],
				count = iter1[3]
			})
		end
	end

	local var4 = {
		isMonthCard = false,
		isChargeType = false,
		isLocalPrice = false,
		icon = var2.icon,
		name = var2.name,
		tipExtra = i18n("charge_title_getitem"),
		extraItems = var0,
		price = arg1:getConfig("resource_num"),
		tagType = arg1:getConfig("tag"),
		onYes = function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("charge_scene_buy_confirm", arg1:getConfig("resource_num"), var2.name),
				onYes = function()
					arg0:emit(NewServerCarnivalMediator.GIFT_BUY_ITEM, arg1.id, 1)
				end
			})
		end
	}

	arg0:emit(NewServerCarnivalMediator.GIFT_OPEN_ITEM_PANEL, var4)
end

function var0.onUpdatePlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.onUpdateGift(arg0)
	arg0:updateGiftGoodsVOList()
	arg0.giftItemList:align(#arg0.giftGoodsVOList)
	setActive(arg0.soldOutTF, #arg0.giftGoodsVOList == 0)
end

function var0.updateGiftGoodsVOList(arg0)
	arg0.normalList = getProxy(ShopsProxy):GetNormalList()
	arg0.giftGoodsVOList = {}

	local var0 = pg.shop_template

	for iter0, iter1 in pairs(arg0.goodIdList) do
		local var1 = Goods.Create({
			shop_id = iter1
		}, Goods.TYPE_NEW_SERVER)

		table.insert(arg0.giftGoodsVOList, var1)
	end

	local var2 = {}

	for iter2, iter3 in ipairs(arg0.giftGoodsVOList) do
		local var3 = ChargeConst.getBuyCount(arg0.normalList, iter3.id)

		iter3:updateBuyCount(var3)

		if iter3:canPurchase() then
			table.insert(var2, iter3)
		end
	end

	arg0.giftGoodsVOList = var2
end

function var0.isTip(arg0)
	if not arg0.playerId then
		arg0.playerId = getProxy(PlayerProxy):getData().id
	end

	return PlayerPrefs.GetInt("newserver_gift_first_" .. arg0.playerId) == 0
end

function var0.OnDestroy(arg0)
	return
end

return var0
