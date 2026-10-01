local var0_0 = class("GameHallScene", import("..base.BaseUI"))

var0_0.open_with_list = false

function var0_0.getUIName(arg0_1)
	return "GameHallUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"char/mingshi",
		"weaponframes"
	}

	local function var1_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	if not arg0_2.charController then
		arg0_2:initContainer()
	end

	local var2_2 = arg0_2.charController.shipNames or {}

	for iter0_2, iter1_2 in pairs(var2_2) do
		var1_2("char/" .. iter1_2)
	end

	local var3_2 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter2_2, iter3_2 in ipairs(pg.game_room_template.all) do
		local var4_2 = pg.game_room_template[iter3_2]
		local var5_2 = var4_2.unlock_time

		if var3_2 > pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var5_2[1][1],
			month = var5_2[1][2],
			day = var5_2[1][3],
			hour = var5_2[2][1],
			min = var5_2[2][2],
			sec = var5_2[2][3]
		}) then
			var1_2("gamehallicon/" .. var4_2.icon)
		end
	end

	local var6_2 = pg.player_resource[GameRoomProxy.coin_res_id].itemid
	local var7_2 = Item.getConfigData(var6_2)

	if var7_2 then
		var1_2(var7_2.icon)
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_4)
	arg0_4:initContainer()
end

function var0_0.initContainer(arg0_5)
	if not arg0_5.charController then
		arg0_5.charController = GameHallContainerUI.New()
	end
end

function var0_0.didEnter(arg0_6)
	arg0_6:initTopUI()
	arg0_6:initHomeUI()

	local var0_6 = findTF(arg0_6._tf, "ad/container")

	arg0_6.charController:InitUI(var0_6)

	arg0_6.freeCoinTf = findTF(var0_6, "content/top/free")

	onButton(arg0_6, arg0_6.freeCoinTf, function()
		local var0_7 = getProxy(GameRoomProxy):getCoin()
		local var1_7 = pg.gameset.game_coin_max.key_value - var0_7
		local var2_7 = pg.gameset.game_coin_initial.key_value

		if var1_7 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("game_icon_max_full"))
		elseif var1_7 < var2_7 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("game_icon_max"),
				onYes = function()
					arg0_6:emit(GameHallMediator.GET_WEEKLY_COIN)
				end,
				onNo = function()
					return
				end
			})
		else
			arg0_6:emit(GameHallMediator.GET_WEEKLY_COIN)
		end
	end, SFX_CONFIRM)

	arg0_6.listPanelTf = findTF(arg0_6._tf, "ad/listPanel")
	arg0_6.listPanel = GameHallListPanel.New(arg0_6.listPanelTf, arg0_6)

	arg0_6.listPanel:setVisible(GameHallScene.open_with_list)

	GameHallScene.open_with_list = false
	arg0_6.exchangePanelTf = findTF(arg0_6._tf, "ad/exchangePanel")
	arg0_6.parentTf = findTF(arg0_6._tf, "ad")
	arg0_6.exchangePanel = GameHallExchangePanel.New(arg0_6.exchangePanelTf, arg0_6.parentTf, arg0_6)

	arg0_6:openExchangePanel(false)
	arg0_6:changeTitle(false)

	local var1_6 = Application.targetFrameRate or 60

	if var1_6 > 60 then
		var1_6 = 60
	end

	arg0_6.timer = Timer.New(function()
		arg0_6:onTimer()
	end, 1 / var1_6, -1)

	arg0_6.timer:Start()
	arg0_6:updateUI()
end

function var0_0.initTopUI(arg0_11)
	arg0_11.btnBack = findTF(arg0_11._tf, "ad/topPanel/btnBack")
	arg0_11.btnHome = findTF(arg0_11._tf, "ad/topPanel/btnHome")
	arg0_11.btnHelp = findTF(arg0_11._tf, "ad/topPanel/btnHelp")
	arg0_11.btnCoin = findTF(arg0_11._tf, "ad/topPanel/coin")
	arg0_11.textCoin = findTF(arg0_11._tf, "ad/topPanel/coin/text")
	arg0_11.coinMax = pg.gameset.game_coin_max.key_value
	arg0_11.textCoinMaxTF = findTF(arg0_11._tf, "ad/topPanel/coin/max")

	setText(arg0_11.textCoinMaxTF, "MAX:" .. arg0_11.coinMax)
	onButton(arg0_11, arg0_11.btnCoin, function()
		arg0_11:openExchangePanel(true)
	end)
	onButton(arg0_11, arg0_11.btnBack, function()
		if arg0_11.listPanel:getVisible() then
			arg0_11.listPanel:setVisible(false)
			arg0_11:changeTitle(false)
			pg.SystemGuideMgr.GetInstance():Play(arg0_11)

			return
		end

		arg0_11:closeView()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.btnHome, function()
		arg0_11:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.game_room_help.tip
		})
	end, SFX_CANCEL)
end

function var0_0.openExchangePanel(arg0_16, arg1_16)
	arg0_16.exchangePanel:setVisible(arg1_16)
end

function var0_0.ResUISettings(arg0_17)
	return {
		showType = bit.bor(PlayerResUI.TYPE_OIL, PlayerResUI.TYPE_GOLD)
	}
end

function var0_0.initHomeUI(arg0_18)
	arg0_18.btnShop = findTF(arg0_18._tf, "ad/btnShop")
	arg0_18.btnPlay = findTF(arg0_18._tf, "ad/btnPlay")

	onButton(arg0_18, arg0_18.btnPlay, function()
		arg0_18.listPanel:setVisible(true)
		arg0_18:changeTitle(true)
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18.btnShop, function()
		arg0_18:emit(GameHallMediator.OPEN_GAME_SHOP)
	end, SFX_CANCEL)

	arg0_18.topShop = findTF(arg0_18._tf, "ad/container/content/top/btnShop")
	arg0_18.topGame = findTF(arg0_18._tf, "ad/container/content/top/btnGameList")

	onButton(arg0_18, arg0_18.topGame, function()
		arg0_18.listPanel:setVisible(true)
		arg0_18:changeTitle(true)
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18.topShop, function()
		arg0_18:emit(GameHallMediator.OPEN_GAME_SHOP)
	end, SFX_CANCEL)
end

function var0_0.updateUI(arg0_23)
	local var0_23 = getProxy(GameRoomProxy):getWeekly()

	setActive(arg0_23.freeCoinTf, var0_23)

	local var1_23 = getProxy(GameRoomProxy):getCoin()

	setText(arg0_23.textCoin, var1_23)
end

function var0_0.onTimer(arg0_24)
	arg0_24.charController:step()
end

function var0_0.changeTitle(arg0_25, arg1_25)
	setActive(findTF(arg0_25._tf, "ad/topPanel/title_list"), arg1_25)
	setActive(findTF(arg0_25._tf, "ad/topPanel/title_main"), not arg1_25)
end

function var0_0.onBackPressed(arg0_26)
	if arg0_26.listPanel:getVisible() then
		arg0_26.listPanel:setVisible(false)
		arg0_26:changeTitle(false)

		return
	end

	if arg0_26.exchangePanel:getVisible() then
		arg0_26.exchangePanel:setVisible(false)

		return
	end

	arg0_26:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_27)
	arg0_27.charController:Dispose()

	if arg0_27.timer then
		arg0_27.timer:Stop()

		arg0_27.timer = nil
	end

	if arg0_27.listPanel:getVisible() then
		GameHallScene.open_with_list = true
	end

	arg0_27.exchangePanel:dispose()
	arg0_27.listPanel:dispose()
end

return var0_0
