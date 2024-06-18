local var0_0 = class("GameHallScene", import("..base.BaseUI"))

var0_0.open_with_list = false

function var0_0.getUIName(arg0_1)
	return "GameHallUI"
end

function var0_0.init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	arg0_3:initTopUI()
	arg0_3:initHomeUI()

	local var0_3 = findTF(arg0_3._tf, "ad/container")

	arg0_3.charController = GameHallContainerUI.New(var0_3)
	arg0_3.freeCoinTf = findTF(var0_3, "content/top/free")

	onButton(arg0_3, arg0_3.freeCoinTf, function()
		local var0_4 = getProxy(GameRoomProxy):getCoin()
		local var1_4 = pg.gameset.game_coin_max.key_value - var0_4
		local var2_4 = pg.gameset.game_coin_initial.key_value

		if var1_4 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("game_icon_max_full"))
		elseif var1_4 < var2_4 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("game_icon_max"),
				onYes = function()
					arg0_3:emit(GameHallMediator.GET_WEEKLY_COIN)
				end,
				onNo = function()
					return
				end
			})
		else
			arg0_3:emit(GameHallMediator.GET_WEEKLY_COIN)
		end
	end, SFX_CONFIRM)

	arg0_3.listPanelTf = findTF(arg0_3._tf, "ad/listPanel")
	arg0_3.listPanel = GameHallListPanel.New(arg0_3.listPanelTf, arg0_3)

	arg0_3.listPanel:setVisible(GameHallScene.open_with_list)

	GameHallScene.open_with_list = false
	arg0_3.exchangePanelTf = findTF(arg0_3._tf, "ad/exchangePanel")
	arg0_3.parentTf = findTF(arg0_3._tf, "ad")
	arg0_3.exchangePanel = GameHallExchangePanel.New(arg0_3.exchangePanelTf, arg0_3.parentTf, arg0_3)

	arg0_3:openExchangePanel(false)
	arg0_3:changeTitle(false)

	local var1_3 = Application.targetFrameRate or 60

	if var1_3 > 60 then
		var1_3 = 60
	end

	arg0_3.timer = Timer.New(function()
		arg0_3:onTimer()
	end, 1 / var1_3, -1)

	arg0_3.timer:Start()
	arg0_3:updateUI()
end

function var0_0.initTopUI(arg0_8)
	arg0_8.btnBack = findTF(arg0_8._tf, "ad/topPanel/btnBack")
	arg0_8.btnHome = findTF(arg0_8._tf, "ad/topPanel/btnHome")
	arg0_8.btnHelp = findTF(arg0_8._tf, "ad/topPanel/btnHelp")
	arg0_8.btnCoin = findTF(arg0_8._tf, "ad/topPanel/coin")
	arg0_8.textCoin = findTF(arg0_8._tf, "ad/topPanel/coin/text")
	arg0_8.coinMax = pg.gameset.game_coin_max.key_value
	arg0_8.textCoinMaxTF = findTF(arg0_8._tf, "ad/topPanel/coin/max")

	setText(arg0_8.textCoinMaxTF, "MAX:" .. arg0_8.coinMax)
	onButton(arg0_8, arg0_8.btnCoin, function()
		arg0_8:openExchangePanel(true)
	end)
	onButton(arg0_8, arg0_8.btnBack, function()
		if arg0_8.listPanel:getVisible() then
			arg0_8.listPanel:setVisible(false)
			arg0_8:changeTitle(false)
			pg.SystemGuideMgr.GetInstance():Play(arg0_8)

			return
		end

		arg0_8:closeView()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.btnHome, function()
		arg0_8:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.game_room_help.tip
		})
	end, SFX_CANCEL)
end

function var0_0.openExchangePanel(arg0_13, arg1_13)
	arg0_13.exchangePanel:setVisible(arg1_13)
end

function var0_0.ResUISettings(arg0_14)
	return {
		showType = bit.bor(PlayerResUI.TYPE_OIL, PlayerResUI.TYPE_GOLD)
	}
end

function var0_0.initHomeUI(arg0_15)
	arg0_15.btnShop = findTF(arg0_15._tf, "ad/btnShop")
	arg0_15.btnPlay = findTF(arg0_15._tf, "ad/btnPlay")

	onButton(arg0_15, arg0_15.btnPlay, function()
		arg0_15.listPanel:setVisible(true)
		arg0_15:changeTitle(true)
	end, SFX_CANCEL)
	onButton(arg0_15, arg0_15.btnShop, function()
		arg0_15:emit(GameHallMediator.OPEN_GAME_SHOP)
	end, SFX_CANCEL)

	arg0_15.topShop = findTF(arg0_15._tf, "ad/container/content/top/btnShop")
	arg0_15.topGame = findTF(arg0_15._tf, "ad/container/content/top/btnGameList")

	onButton(arg0_15, arg0_15.topGame, function()
		arg0_15.listPanel:setVisible(true)
		arg0_15:changeTitle(true)
	end, SFX_CANCEL)
	onButton(arg0_15, arg0_15.topShop, function()
		arg0_15:emit(GameHallMediator.OPEN_GAME_SHOP)
	end, SFX_CANCEL)
end

function var0_0.updateUI(arg0_20)
	local var0_20 = getProxy(GameRoomProxy):getWeekly()

	setActive(arg0_20.freeCoinTf, var0_20)

	local var1_20 = getProxy(GameRoomProxy):getCoin()

	setText(arg0_20.textCoin, var1_20)
end

function var0_0.onTimer(arg0_21)
	arg0_21.charController:step()
end

function var0_0.changeTitle(arg0_22, arg1_22)
	setActive(findTF(arg0_22._tf, "ad/topPanel/title_list"), arg1_22)
	setActive(findTF(arg0_22._tf, "ad/topPanel/title_main"), not arg1_22)
end

function var0_0.onBackPressed(arg0_23)
	if arg0_23.listPanel:getVisible() then
		arg0_23.listPanel:setVisible(false)
		arg0_23:changeTitle(false)

		return
	end

	if arg0_23.exchangePanel:getVisible() then
		arg0_23.exchangePanel:setVisible(false)

		return
	end

	arg0_23:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_24)
	if arg0_24.timer then
		arg0_24.timer:Stop()

		arg0_24.timer = nil
	end

	if arg0_24.listPanel:getVisible() then
		GameHallScene.open_with_list = true
	end

	arg0_24.exchangePanel:dispose()
	arg0_24.listPanel:dispose()
end

return var0_0
