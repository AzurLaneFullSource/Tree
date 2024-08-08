local var0_0 = class("GameRoomCoinLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "GameRoomCoinUI"
end

function var0_0.init(arg0_2)
	arg0_2.totalCount = 0
	arg0_2.curCount = 0
	arg0_2.maxCoin = 0
end

function var0_0.didEnter(arg0_3)
	arg0_3.ad = findTF(arg0_3._tf, "ad")
	arg0_3.window = findTF(arg0_3._tf, "ad/window")
	arg0_3.text = findTF(arg0_3._tf, "ad/window/text")

	local var0_3 = arg0_3.contextData.position

	arg0_3.window.anchoredPosition = Vector2(var0_3[1], var0_3[2])
	arg0_3.maxCoin = arg0_3.contextData.coin_max

	onButton(arg0_3, findTF(arg0_3.window, "add"), function()
		if arg0_3.lockCount then
			return
		end

		arg0_3.curCount = arg0_3.curCount + 1

		arg0_3:updateCount()
	end)
	onButton(arg0_3, findTF(arg0_3.window, "sub"), function()
		if arg0_3.lockCount then
			return
		end

		arg0_3.curCount = arg0_3.curCount - 1

		arg0_3:updateCount()
	end)

	local var1_3 = getProxy(GameRoomProxy)

	if var1_3:lastMonthlyTicket() == 0 or var1_3:lastTicketMax() == 0 then
		arg0_3.curCount = 0
		arg0_3.lockCount = true
	else
		arg0_3.curCount = 1
		arg0_3.lockCount = false
	end

	arg0_3:updateUI()
end

function var0_0.changeVisible(arg0_6, arg1_6)
	setActive(arg0_6.window, arg1_6)
	arg0_6:updateUI()
end

function var0_0.updateUI(arg0_7)
	arg0_7:updateCoin()
	arg0_7:updateCount()
end

function var0_0.updateCoin(arg0_8)
	arg0_8.totalCount = getProxy(GameRoomProxy):getCoin() or 0

	if arg0_8.curCount > arg0_8.totalCount then
		arg0_8.curCount = 0
	end
end

function var0_0.updateCount(arg0_9)
	if arg0_9.curCount > arg0_9.maxCoin then
		arg0_9.curCount = arg0_9.maxCoin
	end

	if arg0_9.curCount > arg0_9.totalCount then
		arg0_9.curCount = arg0_9.totalCount
	end

	if arg0_9.curCount < 0 then
		arg0_9.curCount = 0
	end

	setText(arg0_9.text, arg0_9.curCount .. "/" .. arg0_9.totalCount)
	arg0_9:emit(GameRoomCoinMediator.CHANGE_COIN_NUM, arg0_9.curCount)
end

function var0_0.onBackPressed(arg0_10)
	return
end

function var0_0.willExit(arg0_11)
	return
end

return var0_0
