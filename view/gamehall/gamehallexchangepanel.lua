local var0_0 = class("GameHallExchangePanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._parentTf = arg2_1
	arg0_1._event = arg3_1

	local var0_1 = pg.player_resource[GameRoomProxy.coin_res_id].itemid

	arg0_1.itemCfg = Item.getConfigData(var0_1)
	arg0_1.coinMax = pg.gameset.game_coin_max.key_value
	arg0_1.gameCoinGold = pg.gameset.game_coin_gold.description

	local var1_1 = findTF(arg0_1._tf, "window/single_item_panel/iconPos/icon")

	updateDrop(var1_1, {
		id = var0_1,
		type = DROP_TYPE_ITEM
	})
	setText(findTF(arg0_1._tf, "window/single_item_panel/name_mode/name_mask/name"), arg0_1.itemCfg.name)
	setText(findTF(arg0_1._tf, "window/single_item_panel/own/label"), i18n("word_own1"))
	onButton(arg0_1._event, findTF(arg0_1._tf, "bg"), function()
		arg0_1:setVisible(false)
	end)
	onButton(arg0_1._event, findTF(arg0_1._tf, "top/btnBack"), function()
		arg0_1:setVisible(false)
	end)
	onButton(arg0_1._event, findTF(arg0_1._tf, "window/btnCancel"), function()
		arg0_1:setVisible(false)
	end)
	onButton(arg0_1._event, findTF(arg0_1._tf, "window/btnConfirm"), function()
		if arg0_1.costPrice > arg0_1.myGold then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_no_gold"))
		else
			arg0_1:exchangeCoin()
			arg0_1:setVisible(false)
		end
	end)

	arg0_1.disCount = findTF(arg0_1._tf, "window/discount")
	arg0_1.disCountText = findTF(arg0_1._tf, "window/discount/Text")

	onButton(arg0_1._event, findTF(arg0_1._tf, "window/count_select/value_bg/left"), function()
		arg0_1.coinCount = arg0_1.coinCount - 1

		arg0_1:coinCountChange()
	end)
	onButton(arg0_1._event, findTF(arg0_1._tf, "window/count_select/value_bg/right"), function()
		arg0_1.coinCount = arg0_1.coinCount + 1

		arg0_1:coinCountChange()
	end)
	onButton(arg0_1._event, findTF(arg0_1._tf, "window/count_select/max"), function()
		arg0_1.coinCount = arg0_1.coinMax - arg0_1.myCoinCount

		arg0_1:coinCountChange()
	end)
	setText(findTF(arg0_1._tf, "window/btnConfirm/pic"), i18n("word_ok"))
	setText(findTF(arg0_1._tf, "window/btnCancel/pic"), i18n("word_cancel"))
	setText(findTF(arg0_1._tf, "top/bg/infomation/title"), i18n("title_info"))
	setActive(findTF(arg0_1._tf, "top/bg/infomation/title_en"), PLATFORM_CODE ~= PLATFORM_US)
end

function var0_0.exchangeCoin(arg0_9)
	if arg0_9.coinCount == 0 then
		return
	end

	arg0_9._event:emit(GameHallMediator.EXCHANGE_COIN, {
		price = arg0_9.costPrice,
		times = arg0_9.coinCount
	})
end

function var0_0.coinCountChange(arg0_10)
	if arg0_10.coinCount < 0 then
		arg0_10.coinCount = 0
	end

	if arg0_10.coinCount + arg0_10.myCoinCount > arg0_10.coinMax then
		arg0_10.coinCount = arg0_10.coinMax - arg0_10.myCoinCount
	end

	local var0_10 = 0

	for iter0_10 = 1, arg0_10.coinCount do
		local var1_10 = arg0_10.payCoinCount + iter0_10

		var0_10 = var0_10 + arg0_10:getPriceByCount(var1_10)
	end

	arg0_10.costPrice = var0_10

	local var2_10

	if var0_10 < arg0_10.myGold then
		var2_10 = COLOR_GREEN
	else
		var2_10 = COLOR_RED
	end

	setText(findTF(arg0_10._tf, "window/count_select/desc_txt"), i18n("charge_game_room_coin_tip", var0_10, arg0_10.coinCount, var2_10, arg0_10.itemCfg.name))
	setText(findTF(arg0_10._tf, "window/count_select/value_bg/value"), arg0_10.coinCount)

	local var3_10 = arg0_10:getDiscount(arg0_10.coinCount + arg0_10.payCoinCount)

	setActive(arg0_10.disCount, var3_10 ~= 0)
	setText(arg0_10.disCountText, var3_10 .. "%OFF")
end

function var0_0.getDiscount(arg0_11, arg1_11)
	if arg1_11 <= 0 then
		arg1_11 = 1
	end

	local var0_11 = arg0_11.gameCoinGold[#arg0_11.gameCoinGold][2]
	local var1_11 = arg0_11:getPriceByCount(arg1_11)

	if var1_11 ~= var0_11 then
		return tonumber((var0_11 - var1_11) * 100 / var0_11)
	end

	return 0
end

function var0_0.getPriceByCount(arg0_12, arg1_12)
	for iter0_12 = #arg0_12.gameCoinGold, 1, -1 do
		local var0_12 = arg0_12.gameCoinGold[iter0_12]

		if arg1_12 > var0_12[1] then
			return var0_12[2]
		end
	end

	return 0
end

function var0_0.updateUI(arg0_13)
	arg0_13.coinCount = 0
	arg0_13.myCoinCount = getProxy(GameRoomProxy):getCoin()
	arg0_13.myGold = getProxy(PlayerProxy):getRawData().gold
	arg0_13.payCoinCount = getProxy(GameRoomProxy):getPayCoinCount()

	setText(findTF(arg0_13._tf, "window/single_item_panel/own/Text"), arg0_13.myCoinCount)
	arg0_13:coinCountChange()
end

function var0_0.setVisible(arg0_14, arg1_14)
	if arg1_14 then
		arg0_14.bulrFlag = true

		pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
	else
		arg0_14.bulrFlag = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf, arg0_14._parentTf)
	end

	setActive(arg0_14._tf, arg1_14)
	arg0_14:updateUI()
end

function var0_0.getVisible(arg0_15)
	return isActive(arg0_15._tf)
end

function var0_0.dispose(arg0_16)
	if arg0_16.bulrFlag == true then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf, arg0_16._parentTf)

		arg0_16.bulrFlag = false
	end
end

return var0_0
