local var0_0 = class("Shrine2022View", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "Shrine2022UI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:initData()
	arg0_3:updateDataView()
	arg0_3:updateCardList()
	arg0_3:updateCardBuffTag()
	arg0_3:updateCommanderBuff()
end

function var0_0.onBackPressed(arg0_4)
	if arg0_4.shrineSelectShipView and arg0_4.shrineSelectShipView:CheckState(BaseSubView.STATES.INITED) then
		arg0_4.shrineSelectShipView:closeSelf()
	elseif arg0_4.shrineSelectBuffView and arg0_4.shrineSelectBuffView:CheckState(BaseSubView.STATES.INITED) then
		arg0_4.shrineSelectBuffView:closeMySelf()
	elseif arg0_4.shrineShipWordView and arg0_4.shrineShipWordView:CheckState(BaseSubView.STATES.INITED) then
		arg0_4.shrineShipWordView:closeMySelf()
	else
		arg0_4:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_5, arg1_5)
	local var0_5 = arg1_5.argList
	local var1_5 = var0_5[1]
	local var2_5 = var0_5[2]

	arg0_5:PrintLog("后端返回,游戏ID,操作类型", var1_5, var2_5)

	if var1_5 == arg0_5.commanderGameID then
		if var2_5 == 1 then
			arg0_5:updateDataView()
			arg0_5:updateCommanderBuff()
		elseif var2_5 == 2 then
			local var3_5 = arg0_5.playerProxy:getData()

			var3_5:consume({
				gold = arg0_5:GetMGData():getConfig("config_data")[1]
			})
			arg0_5.playerProxy:updatePlayer(var3_5)
			arg0_5:updateDataView()
			arg0_5:updateCommanderBuff(true)
		elseif var2_5 == 3 then
			local var4_5 = arg0_5.playerProxy:getData()

			var4_5:consume({
				gold = arg0_5:GetMGData():getConfig("config_data")[1]
			})
			arg0_5.playerProxy:updatePlayer(var4_5)
		end
	elseif var1_5 == arg0_5.shipGameID then
		if var2_5 == 1 then
			arg0_5:updateDataView()
			arg0_5:updateCommanderBuff()
		elseif var2_5 == 2 then
			local var5_5 = arg0_5.playerProxy:getData()

			var5_5:consume({
				gold = arg0_5:getShipGameData():getConfig("config_data")[1]
			})
			arg0_5.playerProxy:updatePlayer(var5_5)

			local var6_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHRINE)

			if var6_5 and not var6_5:isEnd() then
				var6_5.data2 = var6_5.data2 + 1

				getProxy(ActivityProxy):updateActivity(var6_5)
			end

			arg0_5:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
				arg0_5.commanderGameID,
				1
			})
			arg0_5:updateCardList()
			arg0_5:updateCardBuffTag()
			arg0_5:openFakeDrop(function()
				local var0_6 = var0_5[5]

				arg0_5:openShipWordView(var0_6)
			end)
		end
	end
end

function var0_0.OnModifyMiniGameDataDone(arg0_7, arg1_7)
	return
end

function var0_0.willExit(arg0_8)
	if arg0_8.shrineSelectShipView and arg0_8.shrineSelectShipView:CheckState(BaseSubView.STATES.INITED) then
		arg0_8.shrineSelectShipView:Destroy()
	elseif arg0_8.shrineSelectBuffView and arg0_8.shrineSelectBuffView:CheckState(BaseSubView.STATES.INITED) then
		arg0_8.shrineSelectBuffView:Destroy()
	elseif arg0_8.shrineShipWordView and arg0_8.shrineShipWordView:CheckState(BaseSubView.STATES.INITED) then
		arg0_8.shrineShipWordView:Destroy()
	end

	arg0_8:cleanManagedTween()
end

function var0_0.initData(arg0_9)
	arg0_9.playerProxy = getProxy(PlayerProxy)
	arg0_9.miniGameProxy = getProxy(MiniGameProxy)
	arg0_9.commanderGameID = arg0_9.contextData.miniGameId
	arg0_9.shipGameID = pg.mini_game[arg0_9.commanderGameID].simple_config_data.shipGameID
	arg0_9.cardPosList = {
		{
			x = -447,
			y = 205
		},
		{
			x = -154,
			y = 205
		},
		{
			x = 145,
			y = 205
		},
		{
			x = 445,
			y = 205
		},
		{
			x = -299,
			y = -160
		},
		{
			x = 0,
			y = -160
		},
		{
			x = 302,
			y = -160
		}
	}

	if not arg0_9:isInitedShipGameData() then
		arg0_9:PrintLog("请求舰娘游戏数据", arg0_9.shipGameID)
		arg0_9:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0_9.shipGameID,
			1
		})
	end

	if not arg0_9:isInitedCommanderGameData() then
		arg0_9:PrintLog("请求指挥官游戏数据", arg0_9.commanderGameID)
		arg0_9:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0_9.commanderGameID,
			1
		})
	end
end

function var0_0.findUI(arg0_10)
	local var0_10 = arg0_10:findTF("Res")
	local var1_10 = getImageSprite(arg0_10:findTF("CurBuff1", var0_10))
	local var2_10 = getImageSprite(arg0_10:findTF("CurBuff2", var0_10))
	local var3_10 = getImageSprite(arg0_10:findTF("CurBuff3", var0_10))

	arg0_10.curBuffSpriteList = {
		var1_10,
		var2_10,
		var3_10
	}

	local var4_10 = arg0_10:findTF("Adapt")

	arg0_10.tipGoldTF = arg0_10:findTF("TipGold", var4_10)
	arg0_10.backBtn = arg0_10:findTF("BackBtn", var4_10)
	arg0_10.helpBtn = arg0_10:findTF("HelpBtn", var4_10)

	local var5_10 = arg0_10:findTF("Data")

	arg0_10.countText = arg0_10:findTF("Count", var5_10)
	arg0_10.goldText = arg0_10:findTF("Gold", var5_10)
	arg0_10.countText2 = arg0_10:findTF("Count2", var5_10)
	arg0_10.cardTpl = arg0_10:findTF("CardTpl")
	arg0_10.cardContainer = arg0_10:findTF("CardContainer")
	arg0_10.cardUIItemList = UIItemList.New(arg0_10.cardContainer, arg0_10.cardTpl)
	arg0_10.selectBuffBtn = arg0_10:findTF("SelectBuffBtn")
	arg0_10.selectBuffLight = arg0_10:findTF("SelectBuffLight")
	arg0_10.curBuffTF = arg0_10:findTF("CurBuff")
	arg0_10.curBuffImg = arg0_10:findTF("BuffImg", arg0_10.curBuffTF)
end

function var0_0.addListener(arg0_11)
	onButton(arg0_11, arg0_11.backBtn, function()
		arg0_11:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.Pray_activity_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.selectBuffBtn, function()
		arg0_11:openSelectBuffView()
	end, SFX_PANEL)
end

function var0_0.updateDataView(arg0_15)
	if not arg0_15:isInitedCommanderGameData() then
		arg0_15:PrintLog("无指挥官数据,返回")

		return
	end

	arg0_15:PrintLog("刷新指挥官次数与金币")

	local var0_15 = arg0_15:GetMGData():GetRuntimeData("count")

	setText(arg0_15.countText, var0_15)

	local var1_15 = arg0_15:getShipGameData():GetRuntimeData("count")

	setText(arg0_15.countText2, var1_15)

	local var2_15 = arg0_15.playerProxy:getData().gold

	setText(arg0_15.goldText, var2_15)

	local var3_15 = arg0_15:isHaveCommanderBuff()

	setActive(arg0_15.selectBuffLight, var0_15 > 0 and not var3_15)
end

function var0_0.updateCardList(arg0_16)
	if not arg0_16:isInitedShipGameData() then
		arg0_16:PrintLog("无舰娘数据,返回")

		return
	end

	arg0_16:PrintLog("刷新舰娘显示")

	arg0_16.cardTFList = {}

	arg0_16.cardUIItemList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg1_17 + 1

			arg0_16.cardTFList[var0_17] = arg2_17

			arg0_16:updateCardImg(var0_17)
			setLocalPosition(arg2_17, arg0_16.cardPosList[var0_17])

			local var1_17 = arg0_16:findTF("Empty", arg2_17)

			onButton(arg0_16, var1_17, function()
				arg0_16:openSelectShipView(var0_17)
			end, SFX_PANEL)

			local var2_17 = arg0_16:findTF("Ship", arg2_17)

			onButton(arg0_16, var2_17, function()
				local var0_19 = arg0_16:getSelectedShipByCardIndex(var0_17)

				arg0_16:openShipWordView(var0_19)
			end, SFX_PANEL)
		end
	end)

	local var0_16 = arg0_16:getShipGameData():GetRuntimeData("count")
	local var1_16 = arg0_16:getSelectedShipCount()
	local var2_16 = #arg0_16:getShipGameData():getConfig("config_data")[2]
	local var3_16 = var2_16 < var0_16 + var1_16 and var2_16 or var0_16 + var1_16

	arg0_16:PrintLog("舰娘次数相关", var0_16, var1_16, var3_16)
	arg0_16.cardUIItemList:align(var3_16)
end

function var0_0.updateCardImg(arg0_20, arg1_20)
	local var0_20 = arg0_20.cardTFList[arg1_20]
	local var1_20 = arg0_20:findTF("Empty", var0_20)
	local var2_20 = arg0_20:findTF("Ship", var0_20)
	local var3_20 = arg0_20:getSelectedShipByCardIndex(arg1_20)

	if var3_20 > 0 then
		local var4_20 = "shipcard_" .. var3_20
		local var5_20 = "Shrine2022/" .. var4_20

		setImageSprite(var2_20, LoadSprite(var5_20, var4_20), true)
	end

	setActive(var1_20, var3_20 == 0)
	setActive(var2_20, var3_20 > 0)
end

function var0_0.updateCardSelecting(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.cardTFList[arg1_21]
	local var1_21 = arg0_21:findTF("Selecting", var0_21)

	setActive(var1_21, arg2_21)
end

function var0_0.updateCardBuffTag(arg0_22)
	if not arg0_22:isInitedShipGameData() then
		arg0_22:PrintLog("无舰娘数据,返回")

		return
	end

	arg0_22:PrintLog("刷新舰娘BuffTtag")

	for iter0_22, iter1_22 in ipairs(arg0_22.cardTFList) do
		local var0_22 = arg0_22:findTF("Ship/Buff", iter1_22)

		setActive(var0_22, false)
	end

	local var1_22 = arg0_22.playerProxy:getData().buff_list
	local var2_22 = arg0_22:getShipGameData():getConfig("config_data")[2]
	local var3_22

	for iter2_22, iter3_22 in ipairs(var1_22) do
		local var4_22 = table.indexof(var2_22, iter3_22.id, 1)

		if var4_22 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter3_22.timestamp then
				local var5_22 = arg0_22:getCardIndexByShip(var4_22)
				local var6_22 = arg0_22.cardTFList[var5_22]
				local var7_22 = arg0_22:findTF("Ship/Buff", var6_22)

				setActive(var7_22, true)

				break
			end

			local var8_22

			break
		end
	end
end

function var0_0.updateCommanderBuff(arg0_23, arg1_23)
	if not arg0_23:isInitedCommanderGameData() then
		arg0_23:PrintLog("无指挥官数据,返回")

		return
	end

	arg0_23:PrintLog("刷新指挥官Buff")

	local var0_23 = arg0_23.playerProxy:getData().buff_list
	local var1_23 = arg0_23:GetMGData():getConfig("config_data")[2]
	local var2_23

	for iter0_23, iter1_23 in ipairs(var0_23) do
		var2_23 = table.indexof(var1_23, iter1_23.id, 1)

		if var2_23 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter1_23.timestamp then
				setImageSprite(arg0_23.curBuffImg, arg0_23.curBuffSpriteList[var2_23])
				setActive(arg0_23.curBuffTF, true)

				break
			end

			var2_23 = nil

			break
		end
	end

	if not var2_23 then
		setActive(arg0_23.curBuffTF, false)
	elseif arg1_23 then
		local var3_23 = 160
		local var4_23 = -70
		local var5_23 = 0.5
		local var6_23 = {
			x = rtf(arg0_23.curBuffTF).localPosition.x,
			y = var3_23
		}

		setLocalPosition(arg0_23.curBuffTF, var6_23)
		arg0_23:managedTween(LeanTween.value, nil, go(arg0_23.curBuffTF), 0, 1, var5_23):setEase(LeanTweenType.easeOutBack):setOnUpdate(System.Action_float(function(arg0_24)
			local var0_24 = var3_23 + (var4_23 - var3_23) * arg0_24

			var6_23.y = var0_24

			setAnchoredPosition(arg0_23.curBuffTF, var6_23)
		end))
	end
end

function var0_0.openSelectShipView(arg0_25, arg1_25)
	local var0_25 = arg0_25.playerProxy:getData()

	if arg0_25:getShipGameData():getConfig("config_data")[1] > var0_25.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	arg0_25:updateCardSelecting(arg1_25, true)
	setActive(arg0_25.tipGoldTF, false)

	local var1_25 = {
		shipGameID = arg0_25.shipGameID,
		selectingCardIndex = arg1_25,
		onClose = function()
			arg0_25:updateCardSelecting(arg1_25, false)
			setActive(arg0_25.tipGoldTF, true)

			local var0_26 = arg0_25.cardTFList[arg1_25]
			local var1_26 = arg0_25:findTF("Empty", var0_26)
			local var2_26 = arg0_25:findTF("Ship", var0_26)

			setActive(var1_26, true)
			setActive(var2_26, false)
		end,
		onSelect = function(arg0_27)
			local var0_27 = arg0_25.cardTFList[arg1_25]
			local var1_27 = arg0_25:findTF("Empty", var0_27)
			local var2_27 = arg0_25:findTF("Ship", var0_27)
			local var3_27 = "shipcard_" .. arg0_27
			local var4_27 = "Shrine2022/" .. var3_27

			setImageSprite(var2_27, LoadSprite(var4_27, var3_27), true)
			setActive(var1_27, false)
			setActive(var2_27, true)
		end,
		onConfirm = function(arg0_28)
			local var0_28 = arg0_25:getShipGameData()

			if var0_28:GetRuntimeData("count") <= 0 then
				arg0_25:PrintLog("Error, count <= 0")
			else
				local var1_28 = var0_28:getConfig("config_data")[2][arg0_28]

				arg0_25:PrintLog("发送选船操作", arg0_25.shipGameID, 2, var1_28, arg1_25, arg0_28)
				arg0_25:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0_25.shipGameID,
					2,
					var1_28,
					arg1_25,
					arg0_28
				})
			end
		end
	}

	arg0_25.shrineSelectShipView = Shrine2022SelectShipView.New(arg0_25._tf.parent, arg0_25.event, var1_25)

	arg0_25.shrineSelectShipView:Reset()
	arg0_25.shrineSelectShipView:Load()
end

function var0_0.openSelectBuffView(arg0_29)
	local var0_29 = arg0_29.playerProxy:getData()

	if arg0_29:GetMGData():getConfig("config_data")[1] > var0_29.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if arg0_29:GetMGData():GetRuntimeData("count") <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("pray_cant_tips"))

		return
	end

	local var1_29 = {
		onClose = function()
			return
		end,
		onSelect = function(arg0_31)
			local var0_31 = arg0_29:GetMGData()

			if var0_31:GetRuntimeData("count") <= 0 then
				arg0_29:PrintLog("Error, count <= 0")
			else
				local var1_31 = var0_31:getConfig("config_data")[2][arg0_31]

				arg0_29:PrintLog("发送选Buff操作", arg0_29.commanderGameID, 2, var1_31)
				arg0_29:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0_29.commanderGameID,
					2,
					var1_31
				})
			end
		end
	}

	arg0_29.shrineSelectBuffView = Shrine2022SelectBuffView.New(arg0_29._tf.parent, arg0_29.event, var1_29)

	arg0_29.shrineSelectBuffView:Reset()
	arg0_29.shrineSelectBuffView:Load()
end

function var0_0.openShipWordView(arg0_32, arg1_32)
	local var0_32 = {
		curSelectShip = arg1_32
	}

	arg0_32.shrineShipWordView = Shrine2022ShipWordView.New(arg0_32._tf, arg0_32.event, var0_32)

	arg0_32.shrineShipWordView:Reset()
	arg0_32.shrineShipWordView:Load()
end

function var0_0.openFakeDrop(arg0_33, arg1_33)
	local var0_33 = arg0_33:getShipGameData():getConfig("simple_config_data")
	local var1_33 = {
		type = var0_33[1],
		id = var0_33[2],
		count = var0_33[3]
	}

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = AwardInfoMediator,
		viewComponent = AwardInfoLayer,
		data = {
			items = {
				var1_33
			}
		},
		onRemoved = function()
			if arg1_33 then
				arg1_33()
			end
		end
	}))
end

function var0_0.isInitedCommanderGameData(arg0_35)
	if not arg0_35:GetMGData():GetRuntimeData("isInited") then
		return false
	else
		return true
	end
end

function var0_0.isInitedShipGameData(arg0_36)
	if not arg0_36:getShipGameData():GetRuntimeData("isInited") then
		return false
	else
		return true
	end
end

function var0_0.isHaveCommanderBuff(arg0_37)
	local var0_37 = arg0_37.playerProxy:getData().buff_list
	local var1_37 = arg0_37:GetMGData():getConfig("config_data")[2]
	local var2_37

	for iter0_37, iter1_37 in ipairs(var0_37) do
		var2_37 = table.indexof(var1_37, iter1_37.id, 1)

		if var2_37 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter1_37.timestamp then
				return var2_37
			else
				return nil
			end
		end
	end

	return var2_37
end

function var0_0.getSelectedShipByCardIndex(arg0_38, arg1_38)
	local var0_38 = arg0_38:getShipGameData():GetRuntimeData("kvpElements")[1]

	for iter0_38, iter1_38 in ipairs(var0_38) do
		if iter1_38.key == arg1_38 then
			return iter1_38.value
		end
	end

	return 0
end

function var0_0.getCardIndexByShip(arg0_39, arg1_39)
	local var0_39 = arg0_39:getShipGameData():GetRuntimeData("kvpElements")[1]

	for iter0_39, iter1_39 in ipairs(var0_39) do
		if iter1_39.value == arg1_39 then
			return iter1_39.key
		end
	end

	return 0
end

function var0_0.getSelectedShipCount(arg0_40)
	local var0_40 = 0

	return #arg0_40:getShipGameData():GetRuntimeData("kvpElements")[1]
end

function var0_0.getShipGameData(arg0_41)
	return arg0_41.miniGameProxy:GetMiniGameData(arg0_41.shipGameID)
end

function var0_0.PrintLog(arg0_42, ...)
	if IsUnityEditor then
		print(...)
	end
end

function var0_0.IsNeedShowTipWithoutActivityFinalReward()
	local var0_43 = false
	local var1_43 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var1_43 then
		var0_43 = (var1_43:GetRuntimeData("count") or 0) > 0
	end

	local var2_43
	local var3_43 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var3_43 then
		local var4_43 = getProxy(PlayerProxy):getData()
		local var5_43 = var3_43:getConfig("config_data")[2]

		for iter0_43, iter1_43 in ipairs(var4_43.buff_list) do
			var2_43 = table.indexof(var5_43, iter1_43.id, 1)

			if var2_43 then
				if pg.TimeMgr.GetInstance():GetServerTime() > iter1_43.timestamp then
					var2_43 = nil
				end

				break
			end
		end
	end

	if var2_43 then
		var0_43 = false
	end

	local var6_43 = false
	local var7_43 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var7_43 then
		var6_43 = (var7_43:GetRuntimeData("count") or 0) > 0
	end

	local var8_43
	local var9_43 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var9_43 then
		local var10_43 = getProxy(PlayerProxy):getData()
		local var11_43 = var9_43:getConfig("config_data")[2]

		for iter2_43, iter3_43 in ipairs(var10_43.buff_list) do
			var8_43 = table.indexof(var11_43, iter3_43.id, 1)

			if var8_43 then
				if pg.TimeMgr.GetInstance():GetServerTime() > iter3_43.timestamp then
					var8_43 = nil
				end

				break
			end
		end
	end

	if var8_43 then
		var6_43 = false
	end

	return var0_43 or var6_43
end

return var0_0
