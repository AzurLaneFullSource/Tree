local var0 = class("GameRoomCoinLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "GameRoomCoinUI"
end

function var0.init(arg0)
	arg0.totalCount = 0
	arg0.curCount = 0
	arg0.maxCoin = 0
end

function var0.didEnter(arg0)
	arg0.window = findTF(arg0._tf, "ad/window")
	arg0.text = findTF(arg0._tf, "ad/window/text")

	local var0 = arg0.contextData.position

	arg0.window.anchoredPosition = Vector2(var0[1], var0[2])
	arg0.maxCoin = arg0.contextData.coin_max

	onButton(arg0, findTF(arg0.window, "add"), function()
		if arg0.lockCount then
			return
		end

		arg0.curCount = arg0.curCount + 1

		arg0:updateCount()
	end)
	onButton(arg0, findTF(arg0.window, "sub"), function()
		if arg0.lockCount then
			return
		end

		arg0.curCount = arg0.curCount - 1

		arg0:updateCount()
	end)

	local var1 = getProxy(GameRoomProxy)

	if var1:lastMonthlyTicket() == 0 or var1:lastTicketMax() == 0 then
		arg0.curCount = 0
		arg0.lockCount = true
	else
		arg0.curCount = 1
		arg0.lockCount = false
	end

	arg0:updateUI()
end

function var0.changeVisible(arg0, arg1)
	setActive(arg0.window, arg1)
	arg0:updateUI()
end

function var0.updateUI(arg0)
	arg0:updateCoin()
	arg0:updateCount()
end

function var0.updateCoin(arg0)
	arg0.totalCount = getProxy(GameRoomProxy):getCoin() or 0

	if arg0.curCount > arg0.totalCount then
		arg0.curCount = 0
	end
end

function var0.updateCount(arg0)
	if arg0.curCount > arg0.maxCoin then
		arg0.curCount = arg0.maxCoin
	end

	if arg0.curCount > arg0.totalCount then
		arg0.curCount = arg0.totalCount
	end

	if arg0.curCount < 0 then
		arg0.curCount = 0
	end

	setText(arg0.text, arg0.curCount .. "/" .. arg0.totalCount)
	arg0:emit(GameRoomCoinMediator.CHANGE_COIN_NUM, arg0.curCount)
end

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	return
end

return var0
