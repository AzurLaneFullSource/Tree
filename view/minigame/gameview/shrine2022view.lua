local var0 = class("Shrine2022View", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "Shrine2022UI"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:initData()
	arg0:updateDataView()
	arg0:updateCardList()
	arg0:updateCardBuffTag()
	arg0:updateCommanderBuff()
end

function var0.onBackPressed(arg0)
	if arg0.shrineSelectShipView and arg0.shrineSelectShipView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineSelectShipView:closeSelf()
	elseif arg0.shrineSelectBuffView and arg0.shrineSelectBuffView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineSelectBuffView:closeMySelf()
	elseif arg0.shrineShipWordView and arg0.shrineShipWordView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineShipWordView:closeMySelf()
	else
		arg0:emit(var0.ON_BACK_PRESSED)
	end
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	local var0 = arg1.argList
	local var1 = var0[1]
	local var2 = var0[2]

	arg0:PrintLog("后端返回,游戏ID,操作类型", var1, var2)

	if var1 == arg0.commanderGameID then
		if var2 == 1 then
			arg0:updateDataView()
			arg0:updateCommanderBuff()
		elseif var2 == 2 then
			local var3 = arg0.playerProxy:getData()

			var3:consume({
				gold = arg0:GetMGData():getConfig("config_data")[1]
			})
			arg0.playerProxy:updatePlayer(var3)
			arg0:updateDataView()
			arg0:updateCommanderBuff(true)
		elseif var2 == 3 then
			local var4 = arg0.playerProxy:getData()

			var4:consume({
				gold = arg0:GetMGData():getConfig("config_data")[1]
			})
			arg0.playerProxy:updatePlayer(var4)
		end
	elseif var1 == arg0.shipGameID then
		if var2 == 1 then
			arg0:updateDataView()
			arg0:updateCommanderBuff()
		elseif var2 == 2 then
			local var5 = arg0.playerProxy:getData()

			var5:consume({
				gold = arg0:getShipGameData():getConfig("config_data")[1]
			})
			arg0.playerProxy:updatePlayer(var5)

			local var6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHRINE)

			if var6 and not var6:isEnd() then
				var6.data2 = var6.data2 + 1

				getProxy(ActivityProxy):updateActivity(var6)
			end

			arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
				arg0.commanderGameID,
				1
			})
			arg0:updateCardList()
			arg0:updateCardBuffTag()
			arg0:openFakeDrop(function()
				local var0 = var0[5]

				arg0:openShipWordView(var0)
			end)
		end
	end
end

function var0.OnModifyMiniGameDataDone(arg0, arg1)
	return
end

function var0.willExit(arg0)
	if arg0.shrineSelectShipView and arg0.shrineSelectShipView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineSelectShipView:Destroy()
	elseif arg0.shrineSelectBuffView and arg0.shrineSelectBuffView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineSelectBuffView:Destroy()
	elseif arg0.shrineShipWordView and arg0.shrineShipWordView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineShipWordView:Destroy()
	end

	arg0:cleanManagedTween()
end

function var0.initData(arg0)
	arg0.playerProxy = getProxy(PlayerProxy)
	arg0.miniGameProxy = getProxy(MiniGameProxy)
	arg0.commanderGameID = arg0.contextData.miniGameId
	arg0.shipGameID = pg.mini_game[arg0.commanderGameID].simple_config_data.shipGameID
	arg0.cardPosList = {
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

	if not arg0:isInitedShipGameData() then
		arg0:PrintLog("请求舰娘游戏数据", arg0.shipGameID)
		arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0.shipGameID,
			1
		})
	end

	if not arg0:isInitedCommanderGameData() then
		arg0:PrintLog("请求指挥官游戏数据", arg0.commanderGameID)
		arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0.commanderGameID,
			1
		})
	end
end

function var0.findUI(arg0)
	local var0 = arg0:findTF("Res")
	local var1 = getImageSprite(arg0:findTF("CurBuff1", var0))
	local var2 = getImageSprite(arg0:findTF("CurBuff2", var0))
	local var3 = getImageSprite(arg0:findTF("CurBuff3", var0))

	arg0.curBuffSpriteList = {
		var1,
		var2,
		var3
	}

	local var4 = arg0:findTF("Adapt")

	arg0.tipGoldTF = arg0:findTF("TipGold", var4)
	arg0.backBtn = arg0:findTF("BackBtn", var4)
	arg0.helpBtn = arg0:findTF("HelpBtn", var4)

	local var5 = arg0:findTF("Data")

	arg0.countText = arg0:findTF("Count", var5)
	arg0.goldText = arg0:findTF("Gold", var5)
	arg0.countText2 = arg0:findTF("Count2", var5)
	arg0.cardTpl = arg0:findTF("CardTpl")
	arg0.cardContainer = arg0:findTF("CardContainer")
	arg0.cardUIItemList = UIItemList.New(arg0.cardContainer, arg0.cardTpl)
	arg0.selectBuffBtn = arg0:findTF("SelectBuffBtn")
	arg0.selectBuffLight = arg0:findTF("SelectBuffLight")
	arg0.curBuffTF = arg0:findTF("CurBuff")
	arg0.curBuffImg = arg0:findTF("BuffImg", arg0.curBuffTF)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.Pray_activity_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.selectBuffBtn, function()
		arg0:openSelectBuffView()
	end, SFX_PANEL)
end

function var0.updateDataView(arg0)
	if not arg0:isInitedCommanderGameData() then
		arg0:PrintLog("无指挥官数据,返回")

		return
	end

	arg0:PrintLog("刷新指挥官次数与金币")

	local var0 = arg0:GetMGData():GetRuntimeData("count")

	setText(arg0.countText, var0)

	local var1 = arg0:getShipGameData():GetRuntimeData("count")

	setText(arg0.countText2, var1)

	local var2 = arg0.playerProxy:getData().gold

	setText(arg0.goldText, var2)

	local var3 = arg0:isHaveCommanderBuff()

	setActive(arg0.selectBuffLight, var0 > 0 and not var3)
end

function var0.updateCardList(arg0)
	if not arg0:isInitedShipGameData() then
		arg0:PrintLog("无舰娘数据,返回")

		return
	end

	arg0:PrintLog("刷新舰娘显示")

	arg0.cardTFList = {}

	arg0.cardUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1

			arg0.cardTFList[var0] = arg2

			arg0:updateCardImg(var0)
			setLocalPosition(arg2, arg0.cardPosList[var0])

			local var1 = arg0:findTF("Empty", arg2)

			onButton(arg0, var1, function()
				arg0:openSelectShipView(var0)
			end, SFX_PANEL)

			local var2 = arg0:findTF("Ship", arg2)

			onButton(arg0, var2, function()
				local var0 = arg0:getSelectedShipByCardIndex(var0)

				arg0:openShipWordView(var0)
			end, SFX_PANEL)
		end
	end)

	local var0 = arg0:getShipGameData():GetRuntimeData("count")
	local var1 = arg0:getSelectedShipCount()
	local var2 = #arg0:getShipGameData():getConfig("config_data")[2]
	local var3 = var2 < var0 + var1 and var2 or var0 + var1

	arg0:PrintLog("舰娘次数相关", var0, var1, var3)
	arg0.cardUIItemList:align(var3)
end

function var0.updateCardImg(arg0, arg1)
	local var0 = arg0.cardTFList[arg1]
	local var1 = arg0:findTF("Empty", var0)
	local var2 = arg0:findTF("Ship", var0)
	local var3 = arg0:getSelectedShipByCardIndex(arg1)

	if var3 > 0 then
		local var4 = "shipcard_" .. var3
		local var5 = "Shrine2022/" .. var4

		setImageSprite(var2, LoadSprite(var5, var4), true)
	end

	setActive(var1, var3 == 0)
	setActive(var2, var3 > 0)
end

function var0.updateCardSelecting(arg0, arg1, arg2)
	local var0 = arg0.cardTFList[arg1]
	local var1 = arg0:findTF("Selecting", var0)

	setActive(var1, arg2)
end

function var0.updateCardBuffTag(arg0)
	if not arg0:isInitedShipGameData() then
		arg0:PrintLog("无舰娘数据,返回")

		return
	end

	arg0:PrintLog("刷新舰娘BuffTtag")

	for iter0, iter1 in ipairs(arg0.cardTFList) do
		local var0 = arg0:findTF("Ship/Buff", iter1)

		setActive(var0, false)
	end

	local var1 = arg0.playerProxy:getData().buff_list
	local var2 = arg0:getShipGameData():getConfig("config_data")[2]
	local var3

	for iter2, iter3 in ipairs(var1) do
		local var4 = table.indexof(var2, iter3.id, 1)

		if var4 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter3.timestamp then
				local var5 = arg0:getCardIndexByShip(var4)
				local var6 = arg0.cardTFList[var5]
				local var7 = arg0:findTF("Ship/Buff", var6)

				setActive(var7, true)

				break
			end

			local var8

			break
		end
	end
end

function var0.updateCommanderBuff(arg0, arg1)
	if not arg0:isInitedCommanderGameData() then
		arg0:PrintLog("无指挥官数据,返回")

		return
	end

	arg0:PrintLog("刷新指挥官Buff")

	local var0 = arg0.playerProxy:getData().buff_list
	local var1 = arg0:GetMGData():getConfig("config_data")[2]
	local var2

	for iter0, iter1 in ipairs(var0) do
		var2 = table.indexof(var1, iter1.id, 1)

		if var2 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter1.timestamp then
				setImageSprite(arg0.curBuffImg, arg0.curBuffSpriteList[var2])
				setActive(arg0.curBuffTF, true)

				break
			end

			var2 = nil

			break
		end
	end

	if not var2 then
		setActive(arg0.curBuffTF, false)
	elseif arg1 then
		local var3 = 160
		local var4 = -70
		local var5 = 0.5
		local var6 = {
			x = rtf(arg0.curBuffTF).localPosition.x,
			y = var3
		}

		setLocalPosition(arg0.curBuffTF, var6)
		arg0:managedTween(LeanTween.value, nil, go(arg0.curBuffTF), 0, 1, var5):setEase(LeanTweenType.easeOutBack):setOnUpdate(System.Action_float(function(arg0)
			local var0 = var3 + (var4 - var3) * arg0

			var6.y = var0

			setAnchoredPosition(arg0.curBuffTF, var6)
		end))
	end
end

function var0.openSelectShipView(arg0, arg1)
	local var0 = arg0.playerProxy:getData()

	if arg0:getShipGameData():getConfig("config_data")[1] > var0.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	arg0:updateCardSelecting(arg1, true)
	setActive(arg0.tipGoldTF, false)

	local var1 = {
		shipGameID = arg0.shipGameID,
		selectingCardIndex = arg1,
		onClose = function()
			arg0:updateCardSelecting(arg1, false)
			setActive(arg0.tipGoldTF, true)

			local var0 = arg0.cardTFList[arg1]
			local var1 = arg0:findTF("Empty", var0)
			local var2 = arg0:findTF("Ship", var0)

			setActive(var1, true)
			setActive(var2, false)
		end,
		onSelect = function(arg0)
			local var0 = arg0.cardTFList[arg1]
			local var1 = arg0:findTF("Empty", var0)
			local var2 = arg0:findTF("Ship", var0)
			local var3 = "shipcard_" .. arg0
			local var4 = "Shrine2022/" .. var3

			setImageSprite(var2, LoadSprite(var4, var3), true)
			setActive(var1, false)
			setActive(var2, true)
		end,
		onConfirm = function(arg0)
			local var0 = arg0:getShipGameData()

			if var0:GetRuntimeData("count") <= 0 then
				arg0:PrintLog("Error, count <= 0")
			else
				local var1 = var0:getConfig("config_data")[2][arg0]

				arg0:PrintLog("发送选船操作", arg0.shipGameID, 2, var1, arg1, arg0)
				arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0.shipGameID,
					2,
					var1,
					arg1,
					arg0
				})
			end
		end
	}

	arg0.shrineSelectShipView = Shrine2022SelectShipView.New(arg0._tf.parent, arg0.event, var1)

	arg0.shrineSelectShipView:Reset()
	arg0.shrineSelectShipView:Load()
end

function var0.openSelectBuffView(arg0)
	local var0 = arg0.playerProxy:getData()

	if arg0:GetMGData():getConfig("config_data")[1] > var0.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if arg0:GetMGData():GetRuntimeData("count") <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("pray_cant_tips"))

		return
	end

	local var1 = {
		onClose = function()
			return
		end,
		onSelect = function(arg0)
			local var0 = arg0:GetMGData()

			if var0:GetRuntimeData("count") <= 0 then
				arg0:PrintLog("Error, count <= 0")
			else
				local var1 = var0:getConfig("config_data")[2][arg0]

				arg0:PrintLog("发送选Buff操作", arg0.commanderGameID, 2, var1)
				arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0.commanderGameID,
					2,
					var1
				})
			end
		end
	}

	arg0.shrineSelectBuffView = Shrine2022SelectBuffView.New(arg0._tf.parent, arg0.event, var1)

	arg0.shrineSelectBuffView:Reset()
	arg0.shrineSelectBuffView:Load()
end

function var0.openShipWordView(arg0, arg1)
	local var0 = {
		curSelectShip = arg1
	}

	arg0.shrineShipWordView = Shrine2022ShipWordView.New(arg0._tf, arg0.event, var0)

	arg0.shrineShipWordView:Reset()
	arg0.shrineShipWordView:Load()
end

function var0.openFakeDrop(arg0, arg1)
	local var0 = arg0:getShipGameData():getConfig("simple_config_data")
	local var1 = {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = AwardInfoMediator,
		viewComponent = AwardInfoLayer,
		data = {
			items = {
				var1
			}
		},
		onRemoved = function()
			if arg1 then
				arg1()
			end
		end
	}))
end

function var0.isInitedCommanderGameData(arg0)
	if not arg0:GetMGData():GetRuntimeData("isInited") then
		return false
	else
		return true
	end
end

function var0.isInitedShipGameData(arg0)
	if not arg0:getShipGameData():GetRuntimeData("isInited") then
		return false
	else
		return true
	end
end

function var0.isHaveCommanderBuff(arg0)
	local var0 = arg0.playerProxy:getData().buff_list
	local var1 = arg0:GetMGData():getConfig("config_data")[2]
	local var2

	for iter0, iter1 in ipairs(var0) do
		var2 = table.indexof(var1, iter1.id, 1)

		if var2 then
			if pg.TimeMgr.GetInstance():GetServerTime() < iter1.timestamp then
				return var2
			else
				return nil
			end
		end
	end

	return var2
end

function var0.getSelectedShipByCardIndex(arg0, arg1)
	local var0 = arg0:getShipGameData():GetRuntimeData("kvpElements")[1]

	for iter0, iter1 in ipairs(var0) do
		if iter1.key == arg1 then
			return iter1.value
		end
	end

	return 0
end

function var0.getCardIndexByShip(arg0, arg1)
	local var0 = arg0:getShipGameData():GetRuntimeData("kvpElements")[1]

	for iter0, iter1 in ipairs(var0) do
		if iter1.value == arg1 then
			return iter1.key
		end
	end

	return 0
end

function var0.getSelectedShipCount(arg0)
	local var0 = 0

	return #arg0:getShipGameData():GetRuntimeData("kvpElements")[1]
end

function var0.getShipGameData(arg0)
	return arg0.miniGameProxy:GetMiniGameData(arg0.shipGameID)
end

function var0.PrintLog(arg0, ...)
	if IsUnityEditor then
		print(...)
	end
end

function var0.IsNeedShowTipWithoutActivityFinalReward()
	local var0 = false
	local var1 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var1 then
		var0 = (var1:GetRuntimeData("count") or 0) > 0
	end

	local var2
	local var3 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var3 then
		local var4 = getProxy(PlayerProxy):getData()
		local var5 = var3:getConfig("config_data")[2]

		for iter0, iter1 in ipairs(var4.buff_list) do
			var2 = table.indexof(var5, iter1.id, 1)

			if var2 then
				if pg.TimeMgr.GetInstance():GetServerTime() > iter1.timestamp then
					var2 = nil
				end

				break
			end
		end
	end

	if var2 then
		var0 = false
	end

	local var6 = false
	local var7 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var7 then
		var6 = (var7:GetRuntimeData("count") or 0) > 0
	end

	local var8
	local var9 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var9 then
		local var10 = getProxy(PlayerProxy):getData()
		local var11 = var9:getConfig("config_data")[2]

		for iter2, iter3 in ipairs(var10.buff_list) do
			var8 = table.indexof(var11, iter3.id, 1)

			if var8 then
				if pg.TimeMgr.GetInstance():GetServerTime() > iter3.timestamp then
					var8 = nil
				end

				break
			end
		end
	end

	if var8 then
		var6 = false
	end

	return var0 or var6
end

return var0
