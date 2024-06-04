local var0 = class("GameHallScene", import("..base.BaseUI"))

var0.open_with_list = false

function var0.getUIName(arg0)
	return "GameHallUI"
end

function var0.init(arg0)
	return
end

function var0.didEnter(arg0)
	arg0:initTopUI()
	arg0:initHomeUI()

	local var0 = findTF(arg0._tf, "ad/container")

	arg0.charController = GameHallContainerUI.New(var0)
	arg0.freeCoinTf = findTF(var0, "content/top/free")

	onButton(arg0, arg0.freeCoinTf, function()
		local var0 = getProxy(GameRoomProxy):getCoin()
		local var1 = pg.gameset.game_coin_max.key_value - var0
		local var2 = pg.gameset.game_coin_initial.key_value

		if var1 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("game_icon_max_full"))
		elseif var1 < var2 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("game_icon_max"),
				onYes = function()
					arg0:emit(GameHallMediator.GET_WEEKLY_COIN)
				end,
				onNo = function()
					return
				end
			})
		else
			arg0:emit(GameHallMediator.GET_WEEKLY_COIN)
		end
	end, SFX_CONFIRM)

	arg0.listPanelTf = findTF(arg0._tf, "ad/listPanel")
	arg0.listPanel = GameHallListPanel.New(arg0.listPanelTf, arg0)

	arg0.listPanel:setVisible(GameHallScene.open_with_list)

	GameHallScene.open_with_list = false
	arg0.exchangePanelTf = findTF(arg0._tf, "ad/exchangePanel")
	arg0.parentTf = findTF(arg0._tf, "ad")
	arg0.exchangePanel = GameHallExchangePanel.New(arg0.exchangePanelTf, arg0.parentTf, arg0)

	arg0:openExchangePanel(false)
	arg0:changeTitle(false)

	local var1 = Application.targetFrameRate or 60

	if var1 > 60 then
		var1 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var1, -1)

	arg0.timer:Start()
	arg0:updateUI()
end

function var0.initTopUI(arg0)
	arg0.btnBack = findTF(arg0._tf, "ad/topPanel/btnBack")
	arg0.btnHome = findTF(arg0._tf, "ad/topPanel/btnHome")
	arg0.btnHelp = findTF(arg0._tf, "ad/topPanel/btnHelp")
	arg0.btnCoin = findTF(arg0._tf, "ad/topPanel/coin")
	arg0.textCoin = findTF(arg0._tf, "ad/topPanel/coin/text")
	arg0.coinMax = pg.gameset.game_coin_max.key_value
	arg0.textCoinMaxTF = findTF(arg0._tf, "ad/topPanel/coin/max")

	setText(arg0.textCoinMaxTF, "MAX:" .. arg0.coinMax)
	onButton(arg0, arg0.btnCoin, function()
		arg0:openExchangePanel(true)
	end)
	onButton(arg0, arg0.btnBack, function()
		if arg0.listPanel:getVisible() then
			arg0.listPanel:setVisible(false)
			arg0:changeTitle(false)
			pg.SystemGuideMgr.GetInstance():Play(arg0)

			return
		end

		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnHome, function()
		arg0:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.game_room_help.tip
		})
	end, SFX_CANCEL)
end

function var0.openExchangePanel(arg0, arg1)
	arg0.exchangePanel:setVisible(arg1)
end

function var0.ResUISettings(arg0)
	return {
		showType = bit.bor(PlayerResUI.TYPE_OIL, PlayerResUI.TYPE_GOLD)
	}
end

function var0.initHomeUI(arg0)
	arg0.btnShop = findTF(arg0._tf, "ad/btnShop")
	arg0.btnPlay = findTF(arg0._tf, "ad/btnPlay")

	onButton(arg0, arg0.btnPlay, function()
		arg0.listPanel:setVisible(true)
		arg0:changeTitle(true)
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnShop, function()
		arg0:emit(GameHallMediator.OPEN_GAME_SHOP)
	end, SFX_CANCEL)

	arg0.topShop = findTF(arg0._tf, "ad/container/content/top/btnShop")
	arg0.topGame = findTF(arg0._tf, "ad/container/content/top/btnGameList")

	onButton(arg0, arg0.topGame, function()
		arg0.listPanel:setVisible(true)
		arg0:changeTitle(true)
	end, SFX_CANCEL)
	onButton(arg0, arg0.topShop, function()
		arg0:emit(GameHallMediator.OPEN_GAME_SHOP)
	end, SFX_CANCEL)
end

function var0.updateUI(arg0)
	local var0 = getProxy(GameRoomProxy):getWeekly()

	setActive(arg0.freeCoinTf, var0)

	local var1 = getProxy(GameRoomProxy):getCoin()

	setText(arg0.textCoin, var1)
end

function var0.onTimer(arg0)
	arg0.charController:step()
end

function var0.changeTitle(arg0, arg1)
	setActive(findTF(arg0._tf, "ad/topPanel/title_list"), arg1)
	setActive(findTF(arg0._tf, "ad/topPanel/title_main"), not arg1)
end

function var0.onBackPressed(arg0)
	if arg0.listPanel:getVisible() then
		arg0.listPanel:setVisible(false)
		arg0:changeTitle(false)

		return
	end

	if arg0.exchangePanel:getVisible() then
		arg0.exchangePanel:setVisible(false)

		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

function var0.willExit(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	if arg0.listPanel:getVisible() then
		GameHallScene.open_with_list = true
	end

	arg0.exchangePanel:dispose()
	arg0.listPanel:dispose()
end

return var0
