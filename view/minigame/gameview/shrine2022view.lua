local var0_0 = class("Shrine2022View", import("..BaseMiniGameView"))

var0_0.SHRINE_SELECT_SHIP_VIEW_CLS = Shrine2022SelectShipView
var0_0.SHRINE_SHIP_WORD_VIEW_CLS = Shrine2022ShipWordView
var0_0.SHRINE_SELECT_BUFF_VIEW_CLS = Shrine2022SelectBuffView

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

function var0_0.setUIData(arg0_9)
	local var0_9 = arg0_9._tf:Find("Res")
	local var1_9 = getImageSprite(var0_9:Find("CurBuff1"))
	local var2_9 = getImageSprite(var0_9:Find("CurBuff2"))
	local var3_9 = getImageSprite(var0_9:Find("CurBuff3"))

	arg0_9.curBuffSpriteList = {
		var1_9,
		var2_9,
		var3_9
	}
	arg0_9.shipCardSpriteList = {}

	for iter0_9 = 1, 7 do
		local var4_9 = "shipcard_" .. iter0_9
		local var5_9 = "Shrine2022/" .. var4_9
		local var6_9 = LoadSprite(var5_9, var4_9)

		table.insert(arg0_9.shipCardSpriteList, var6_9)
	end

	arg0_9.curBuffPosStart = 160
	arg0_9.curBuffPosEnd = -70
end

function var0_0.updateShipCardUI(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.shipCardSpriteList[arg2_10]

	setImageSprite(arg1_10, var0_10, true)
end

function var0_0.initData(arg0_11)
	arg0_11.playerProxy = getProxy(PlayerProxy)
	arg0_11.miniGameProxy = getProxy(MiniGameProxy)
	arg0_11.commanderGameID = arg0_11.contextData.miniGameId
	arg0_11.shipGameID = pg.mini_game[arg0_11.commanderGameID].simple_config_data.shipGameID
	arg0_11.cardPosList = {
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

	if not arg0_11:isInitedShipGameData() then
		arg0_11:PrintLog("请求舰娘游戏数据", arg0_11.shipGameID)
		arg0_11:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0_11.shipGameID,
			1
		})
	end

	if not arg0_11:isInitedCommanderGameData() then
		arg0_11:PrintLog("请求指挥官游戏数据", arg0_11.commanderGameID)
		arg0_11:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0_11.commanderGameID,
			1
		})
	end
end

function var0_0.findUI(arg0_12)
	local var0_12 = arg0_12._tf:Find("Adapt")

	arg0_12.tipGoldTF = var0_12:Find("TipGold")
	arg0_12.backBtn = var0_12:Find("BackBtn")
	arg0_12.helpBtn = var0_12:Find("HelpBtn")

	local var1_12 = arg0_12._tf:Find("Data")

	arg0_12.countText = var1_12:Find("Count")
	arg0_12.goldText = var1_12:Find("Gold")
	arg0_12.countText2 = var1_12:Find("Count2")
	arg0_12.cardTpl = arg0_12._tf:Find("CardTpl")
	arg0_12.cardContainer = arg0_12._tf:Find("CardContainer")
	arg0_12.cardUIItemList = UIItemList.New(arg0_12.cardContainer, arg0_12.cardTpl)
	arg0_12.selectBuffBtn = arg0_12._tf:Find("Decorate/String/SelectBuffBtn")
	arg0_12.selectBuffLight = arg0_12._tf:Find("Decorate/String/SelectBuffLight")
	arg0_12.curBuffTF = arg0_12._tf:Find("Decorate/String/SelectBuffBtn/CurBuff")
	arg0_12.curBuffImg = arg0_12.curBuffTF:Find("BuffImg")

	arg0_12:setUIData()
end

function var0_0.addListener(arg0_13)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.Pray_activity_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.selectBuffBtn, function()
		arg0_13:openSelectBuffView()
	end, SFX_PANEL)
end

function var0_0.updateDataView(arg0_17)
	if not arg0_17:isInitedCommanderGameData() then
		arg0_17:PrintLog("无指挥官数据,返回")

		return
	end

	arg0_17:PrintLog("刷新指挥官次数与金币")

	local var0_17 = arg0_17:GetMGData():GetRuntimeData("count")

	setText(arg0_17.countText, var0_17)

	local var1_17 = arg0_17:getShipGameData():GetRuntimeData("count")

	setText(arg0_17.countText2, var1_17)

	local var2_17 = arg0_17.playerProxy:getData().gold

	setText(arg0_17.goldText, var2_17)

	local var3_17 = arg0_17:isHaveCommanderBuff()

	setActive(arg0_17.selectBuffLight, var0_17 > 0 and not var3_17)
end

function var0_0.updateCardList(arg0_18)
	if not arg0_18:isInitedShipGameData() then
		arg0_18:PrintLog("无舰娘数据,返回")

		return
	end

	arg0_18:PrintLog("刷新舰娘显示")

	arg0_18.cardTFList = {}

	arg0_18.cardUIItemList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = arg1_19 + 1

			arg0_18.cardTFList[var0_19] = arg2_19

			arg0_18:updateCardImg(var0_19)
			setLocalPosition(arg2_19, arg0_18.cardPosList[var0_19])

			local var1_19 = arg2_19:Find("Empty")

			onButton(arg0_18, var1_19, function()
				arg0_18:openSelectShipView(var0_19)
			end, SFX_PANEL)

			local var2_19 = arg2_19:Find("Ship")

			onButton(arg0_18, var2_19, function()
				local var0_21 = arg0_18:getSelectedShipByCardIndex(var0_19)

				arg0_18:openShipWordView(var0_21)
			end, SFX_PANEL)
		end
	end)

	local var0_18 = arg0_18:getShipGameData():GetRuntimeData("count")
	local var1_18 = arg0_18:getSelectedShipCount()
	local var2_18 = #arg0_18:getShipGameData():getConfig("config_data")[2]
	local var3_18 = var2_18 < var0_18 + var1_18 and var2_18 or var0_18 + var1_18

	arg0_18:PrintLog("舰娘次数相关", var0_18, var1_18, var3_18)
	arg0_18.cardUIItemList:align(var3_18)
end

function var0_0.updateCardImg(arg0_22, arg1_22)
	local var0_22 = arg0_22.cardTFList[arg1_22]
	local var1_22 = var0_22:Find("Empty")
	local var2_22 = var0_22:Find("Ship")
	local var3_22 = arg0_22:getSelectedShipByCardIndex(arg1_22)

	if var3_22 > 0 then
		arg0_22:updateShipCardUI(var2_22, var3_22)
	end

	setActive(var1_22, var3_22 == 0)
	setActive(var2_22, var3_22 > 0)
end

function var0_0.updateCardSelecting(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.cardTFList[arg1_23]:Find("Selecting")

	setActive(var0_23, arg2_23)
end

function var0_0.updateCardBuffTag(arg0_24)
	if not arg0_24:isInitedShipGameData() then
		arg0_24:PrintLog("无舰娘数据,返回")

		return
	end

	arg0_24:PrintLog("刷新舰娘BuffTtag")

	for iter0_24, iter1_24 in ipairs(arg0_24.cardTFList) do
		local var0_24 = iter1_24:Find("Ship/Buff")

		setActive(var0_24, false)
	end

	local var1_24 = arg0_24.playerProxy:getData().buff_list
	local var2_24 = arg0_24:getShipGameData():getConfig("config_data")[2]
	local var3_24

	for iter2_24, iter3_24 in ipairs(var1_24) do
		local var4_24 = table.indexof(var2_24, iter3_24.id, 1)

		if var4_24 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter3_24.timestamp then
				local var5_24 = arg0_24:getCardIndexByShip(var4_24)
				local var6_24 = arg0_24.cardTFList[var5_24]:Find("Ship/Buff")

				setActive(var6_24, true)

				break
			end

			local var7_24

			break
		end
	end
end

function var0_0.updateCommanderBuff(arg0_25, arg1_25)
	if not arg0_25:isInitedCommanderGameData() then
		arg0_25:PrintLog("无指挥官数据,返回")

		return
	end

	arg0_25:PrintLog("刷新指挥官Buff")

	local var0_25 = arg0_25.playerProxy:getData().buff_list
	local var1_25 = arg0_25:GetMGData():getConfig("config_data")[2]
	local var2_25

	for iter0_25, iter1_25 in ipairs(var0_25) do
		var2_25 = table.indexof(var1_25, iter1_25.id, 1)

		if var2_25 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter1_25.timestamp then
				setImageSprite(arg0_25.curBuffImg, arg0_25.curBuffSpriteList[var2_25])
				setActive(arg0_25.curBuffTF, true)

				break
			end

			var2_25 = nil

			break
		end
	end

	if not var2_25 then
		setActive(arg0_25.curBuffTF, false)
	elseif arg1_25 then
		local var3_25 = arg0_25.curBuffPosStart
		local var4_25 = arg0_25.curBuffPosEnd
		local var5_25 = 0.5
		local var6_25 = {
			x = rtf(arg0_25.curBuffTF).localPosition.x,
			y = var3_25
		}

		setLocalPosition(arg0_25.curBuffTF, var6_25)
		arg0_25:managedTween(LeanTween.value, nil, go(arg0_25.curBuffTF), 0, 1, var5_25):setEase(LeanTweenType.easeOutBack):setOnUpdate(System.Action_float(function(arg0_26)
			local var0_26 = var3_25 + (var4_25 - var3_25) * arg0_26

			var6_25.y = var0_26

			setAnchoredPosition(arg0_25.curBuffTF, var6_25)
		end))
	end
end

function var0_0.openSelectShipView(arg0_27, arg1_27)
	local var0_27 = arg0_27.playerProxy:getData()

	if arg0_27:getShipGameData():getConfig("config_data")[1] > var0_27.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	arg0_27:updateCardSelecting(arg1_27, true)
	setActive(arg0_27.tipGoldTF, false)

	local var1_27 = {
		shipGameID = arg0_27.shipGameID,
		selectingCardIndex = arg1_27,
		onClose = function()
			arg0_27:updateCardSelecting(arg1_27, false)
			setActive(arg0_27.tipGoldTF, true)

			local var0_28 = arg0_27.cardTFList[arg1_27]
			local var1_28 = var0_28:Find("Empty")
			local var2_28 = var0_28:Find("Ship")

			setActive(var1_28, true)
			setActive(var2_28, false)
		end,
		onSelect = function(arg0_29)
			local var0_29 = arg0_27.cardTFList[arg1_27]
			local var1_29 = var0_29:Find("Empty")
			local var2_29 = var0_29:Find("Ship")

			arg0_27:updateShipCardUI(var2_29, arg0_29)
			setActive(var1_29, false)
			setActive(var2_29, true)
		end,
		onConfirm = function(arg0_30)
			local var0_30 = arg0_27:getShipGameData()

			if var0_30:GetRuntimeData("count") <= 0 then
				arg0_27:PrintLog("Error, count <= 0")
			else
				local var1_30 = var0_30:getConfig("config_data")[2][arg0_30]

				arg0_27:PrintLog("发送选船操作", arg0_27.shipGameID, 2, var1_30, arg1_27, arg0_30)
				arg0_27:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0_27.shipGameID,
					2,
					var1_30,
					arg1_27,
					arg0_30
				})
			end
		end
	}

	arg0_27.shrineSelectShipView = arg0_27.SHRINE_SELECT_SHIP_VIEW_CLS.New(arg0_27._tf.parent, arg0_27.event, var1_27)

	arg0_27.shrineSelectShipView:Reset()
	arg0_27.shrineSelectShipView:Load()
end

function var0_0.openSelectBuffView(arg0_31)
	local var0_31 = arg0_31.playerProxy:getData()

	if arg0_31:GetMGData():getConfig("config_data")[1] > var0_31.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if arg0_31:GetMGData():GetRuntimeData("count") <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("pray_cant_tips"))

		return
	end

	local var1_31 = {
		onClose = function()
			return
		end,
		onSelect = function(arg0_33)
			local var0_33 = arg0_31:GetMGData()

			if var0_33:GetRuntimeData("count") <= 0 then
				arg0_31:PrintLog("Error, count <= 0")
			else
				local var1_33 = var0_33:getConfig("config_data")[2][arg0_33]

				arg0_31:PrintLog("发送选Buff操作", arg0_31.commanderGameID, 2, var1_33)
				arg0_31:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0_31.commanderGameID,
					2,
					var1_33
				})
			end
		end
	}

	arg0_31.shrineSelectBuffView = arg0_31.SHRINE_SELECT_BUFF_VIEW_CLS.New(arg0_31._tf.parent, arg0_31.event, var1_31)

	arg0_31.shrineSelectBuffView:Reset()
	arg0_31.shrineSelectBuffView:Load()
end

function var0_0.openShipWordView(arg0_34, arg1_34)
	local var0_34 = {
		curSelectShip = arg1_34
	}

	arg0_34.shrineShipWordView = arg0_34.SHRINE_SHIP_WORD_VIEW_CLS.New(arg0_34._tf, arg0_34.event, var0_34)

	arg0_34.shrineShipWordView:Reset()
	arg0_34.shrineShipWordView:Load()
end

function var0_0.openFakeDrop(arg0_35, arg1_35)
	local var0_35 = arg0_35:getShipGameData():getConfig("simple_config_data")
	local var1_35 = {
		type = var0_35[1],
		id = var0_35[2],
		count = var0_35[3]
	}

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = AwardInfoMediator,
		viewComponent = AwardInfoLayer,
		data = {
			items = {
				var1_35
			}
		},
		onRemoved = function()
			if arg1_35 then
				arg1_35()
			end
		end
	}))
end

function var0_0.isInitedCommanderGameData(arg0_37)
	if not arg0_37:GetMGData():GetRuntimeData("isInited") then
		return false
	else
		return true
	end
end

function var0_0.isInitedShipGameData(arg0_38)
	if not arg0_38:getShipGameData():GetRuntimeData("isInited") then
		return false
	else
		return true
	end
end

function var0_0.isHaveCommanderBuff(arg0_39)
	local var0_39 = arg0_39.playerProxy:getData().buff_list
	local var1_39 = arg0_39:GetMGData():getConfig("config_data")[2]
	local var2_39

	for iter0_39, iter1_39 in ipairs(var0_39) do
		var2_39 = table.indexof(var1_39, iter1_39.id, 1)

		if var2_39 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter1_39.timestamp then
				return var2_39
			else
				return nil
			end
		end
	end

	return var2_39
end

function var0_0.getSelectedShipByCardIndex(arg0_40, arg1_40)
	local var0_40 = arg0_40:getShipGameData():GetRuntimeData("kvpElements")[1]

	for iter0_40, iter1_40 in ipairs(var0_40) do
		if iter1_40.key == arg1_40 then
			return iter1_40.value
		end
	end

	return 0
end

function var0_0.getCardIndexByShip(arg0_41, arg1_41)
	local var0_41 = arg0_41:getShipGameData():GetRuntimeData("kvpElements")[1]

	for iter0_41, iter1_41 in ipairs(var0_41) do
		if iter1_41.value == arg1_41 then
			return iter1_41.key
		end
	end

	return 0
end

function var0_0.getSelectedShipCount(arg0_42)
	local var0_42 = 0

	return #arg0_42:getShipGameData():GetRuntimeData("kvpElements")[1]
end

function var0_0.getShipGameData(arg0_43)
	return arg0_43.miniGameProxy:GetMiniGameData(arg0_43.shipGameID)
end

function var0_0.PrintLog(arg0_44, ...)
	if IsUnityEditor then
		print(...)
	end
end

function var0_0.IsNeedShowTipWithoutActivityFinalReward()
	local var0_45 = false
	local var1_45 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var1_45 then
		var0_45 = (var1_45:GetRuntimeData("count") or 0) > 0
	end

	local var2_45
	local var3_45 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var3_45 then
		local var4_45 = getProxy(PlayerProxy):getData()
		local var5_45 = var3_45:getConfig("config_data")[2]

		for iter0_45, iter1_45 in ipairs(var4_45.buff_list) do
			var2_45 = table.indexof(var5_45, iter1_45.id, 1)

			if var2_45 then
				if pg.TimeMgr.GetInstance():GetServerTime() > iter1_45.timestamp then
					var2_45 = nil
				end

				break
			end
		end
	end

	if var2_45 then
		var0_45 = false
	end

	local var6_45 = false
	local var7_45 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var7_45 then
		var6_45 = (var7_45:GetRuntimeData("count") or 0) > 0
	end

	local var8_45
	local var9_45 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var9_45 then
		local var10_45 = getProxy(PlayerProxy):getData()
		local var11_45 = var9_45:getConfig("config_data")[2]

		for iter2_45, iter3_45 in ipairs(var10_45.buff_list) do
			var8_45 = table.indexof(var11_45, iter3_45.id, 1)

			if var8_45 then
				if pg.TimeMgr.GetInstance():GetServerTime() > iter3_45.timestamp then
					var8_45 = nil
				end

				break
			end
		end
	end

	if var8_45 then
		var6_45 = false
	end

	return var0_45 or var6_45
end

function var0_0.IsNeedShowTipForShipCount()
	local var0_46 = false
	local var1_46 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var1_46 then
		var0_46 = (var1_46:GetRuntimeData("count") or 0) > 0
	end

	local var2_46
	local var3_46 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var3_46 then
		local var4_46 = getProxy(PlayerProxy):getData()
		local var5_46 = var3_46:getConfig("config_data")[2]

		for iter0_46, iter1_46 in ipairs(var4_46.buff_list) do
			var2_46 = table.indexof(var5_46, iter1_46.id, 1)

			if var2_46 then
				if pg.TimeMgr.GetInstance():GetServerTime() > iter1_46.timestamp then
					var2_46 = nil
				end

				break
			end
		end
	end

	if var2_46 then
		var0_46 = false
	end

	return var0_46
end

return var0_0
