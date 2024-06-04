local var0 = class("GameHallExchangePanel")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1
	arg0._parentTf = arg2
	arg0._event = arg3

	local var0 = pg.player_resource[GameRoomProxy.coin_res_id].itemid

	arg0.itemCfg = Item.getConfigData(var0)
	arg0.coinMax = pg.gameset.game_coin_max.key_value
	arg0.gameCoinGold = pg.gameset.game_coin_gold.description

	local var1 = findTF(arg0._tf, "window/single_item_panel/iconPos/icon")

	updateDrop(var1, {
		id = var0,
		type = DROP_TYPE_ITEM
	})
	setText(findTF(arg0._tf, "window/single_item_panel/name_mode/name_mask/name"), arg0.itemCfg.name)
	setText(findTF(arg0._tf, "window/single_item_panel/own/label"), i18n("word_own1"))
	onButton(arg0._event, findTF(arg0._tf, "bg"), function()
		arg0:setVisible(false)
	end)
	onButton(arg0._event, findTF(arg0._tf, "top/btnBack"), function()
		arg0:setVisible(false)
	end)
	onButton(arg0._event, findTF(arg0._tf, "window/btnCancel"), function()
		arg0:setVisible(false)
	end)
	onButton(arg0._event, findTF(arg0._tf, "window/btnConfirm"), function()
		if arg0.costPrice > arg0.myGold then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_no_gold"))
		else
			arg0:exchangeCoin()
			arg0:setVisible(false)
		end
	end)

	arg0.disCount = findTF(arg0._tf, "window/discount")
	arg0.disCountText = findTF(arg0._tf, "window/discount/Text")

	onButton(arg0._event, findTF(arg0._tf, "window/count_select/value_bg/left"), function()
		arg0.coinCount = arg0.coinCount - 1

		arg0:coinCountChange()
	end)
	onButton(arg0._event, findTF(arg0._tf, "window/count_select/value_bg/right"), function()
		arg0.coinCount = arg0.coinCount + 1

		arg0:coinCountChange()
	end)
	onButton(arg0._event, findTF(arg0._tf, "window/count_select/max"), function()
		arg0.coinCount = arg0.coinMax - arg0.myCoinCount

		arg0:coinCountChange()
	end)
	setText(findTF(arg0._tf, "window/btnConfirm/pic"), i18n("word_ok"))
	setText(findTF(arg0._tf, "window/btnCancel/pic"), i18n("word_cancel"))
	setText(findTF(arg0._tf, "top/bg/infomation/title"), i18n("title_info"))
	setActive(findTF(arg0._tf, "top/bg/infomation/title_en"), PLATFORM_CODE ~= PLATFORM_US)
end

function var0.exchangeCoin(arg0)
	if arg0.coinCount == 0 then
		return
	end

	arg0._event:emit(GameHallMediator.EXCHANGE_COIN, {
		price = arg0.costPrice,
		times = arg0.coinCount
	})
end

function var0.coinCountChange(arg0)
	if arg0.coinCount < 0 then
		arg0.coinCount = 0
	end

	if arg0.coinCount + arg0.myCoinCount > arg0.coinMax then
		arg0.coinCount = arg0.coinMax - arg0.myCoinCount
	end

	local var0 = 0

	for iter0 = 1, arg0.coinCount do
		local var1 = arg0.payCoinCount + iter0

		var0 = var0 + arg0:getPriceByCount(var1)
	end

	arg0.costPrice = var0

	local var2

	if var0 < arg0.myGold then
		var2 = COLOR_GREEN
	else
		var2 = COLOR_RED
	end

	setText(findTF(arg0._tf, "window/count_select/desc_txt"), i18n("charge_game_room_coin_tip", var0, arg0.coinCount, var2, arg0.itemCfg.name))
	setText(findTF(arg0._tf, "window/count_select/value_bg/value"), arg0.coinCount)

	local var3 = arg0:getDiscount(arg0.coinCount + arg0.payCoinCount)

	setActive(arg0.disCount, var3 ~= 0)
	setText(arg0.disCountText, var3 .. "%OFF")
end

function var0.getDiscount(arg0, arg1)
	if arg1 <= 0 then
		arg1 = 1
	end

	local var0 = arg0.gameCoinGold[#arg0.gameCoinGold][2]
	local var1 = arg0:getPriceByCount(arg1)

	if var1 ~= var0 then
		return tonumber((var0 - var1) * 100 / var0)
	end

	return 0
end

function var0.getPriceByCount(arg0, arg1)
	for iter0 = #arg0.gameCoinGold, 1, -1 do
		local var0 = arg0.gameCoinGold[iter0]

		if arg1 > var0[1] then
			return var0[2]
		end
	end

	return 0
end

function var0.updateUI(arg0)
	arg0.coinCount = 0
	arg0.myCoinCount = getProxy(GameRoomProxy):getCoin()
	arg0.myGold = getProxy(PlayerProxy):getRawData().gold
	arg0.payCoinCount = getProxy(GameRoomProxy):getPayCoinCount()

	setText(findTF(arg0._tf, "window/single_item_panel/own/Text"), arg0.myCoinCount)
	arg0:coinCountChange()
end

function var0.setVisible(arg0, arg1)
	if arg1 then
		arg0.bulrFlag = true

		pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	else
		arg0.bulrFlag = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	end

	setActive(arg0._tf, arg1)
	arg0:updateUI()
end

function var0.getVisible(arg0)
	return isActive(arg0._tf)
end

function var0.dispose(arg0)
	if arg0.bulrFlag == true then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

		arg0.bulrFlag = false
	end
end

return var0
