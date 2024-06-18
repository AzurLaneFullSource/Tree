local var0_0 = class("CardPairsScene", import("..base.BaseUI"))

var0_0.CARD_NUM = 18
var0_0.GAME_STATE_BEGIN = 0
var0_0.GAME_STATE_GAMING = 1
var0_0.GAME_STATE_END = 2
var0_0.config_init = false

function var0_0.getUIName(arg0_1)
	return "CardPairsUI"
end

function var0_0.setPlayerData(arg0_2, arg1_2)
	arg0_2.playerData = arg1_2
end

function var0_0.setActivityData(arg0_3, arg1_3)
	arg0_3.activityData = arg1_3

	if not arg0_3.config_init then
		local var0_3 = arg0_3.activityData:getConfig("config_client")[2]

		if var0_3 then
			arg0_3.firstShowingTime = var0_3.firstShowingTime
			arg0_3.showingTime = var0_3.showingTime
			arg0_3.aniTime = var0_3.aniTime
			arg0_3.cardEffectTimesMax = arg0_3.activityData:getConfig("config_data")[4]
		else
			arg0_3.firstShowingTime = 2
			arg0_3.showingTime = 0.3
			arg0_3.aniTime = 0.2
			arg0_3.cardEffectTimesMax = 7
		end

		CardPairsCard.ANI_TIME = arg0_3.aniTime
		arg0_3.config_init = true
	end

	arg0_3:updateTimes()

	if arg0_3.activityData.data4 <= 0 then
		setText(arg0_3.bestTxt, "--'--'--")
	else
		setText(arg0_3.bestTxt, arg0_3:getTimeFormat(arg0_3.activityData.data4))
	end
end

function var0_0.checkActivityEnd(arg0_4)
	return
end

function var0_0.init(arg0_5)
	arg0_5.backBtn = arg0_5:findTF("top/back", arg0_5._tf)
	arg0_5.cardTpl = arg0_5:findTF("res/card", arg0_5._tf)
	arg0_5.cardCon = arg0_5:findTF("card_con/layout", arg0_5._tf)
	arg0_5.pics = arg0_5:findTF("res/pics", arg0_5._tf)
	arg0_5.helpBtn = arg0_5:findTF("top/help_btn", arg0_5._tf)
	arg0_5.timesTxt = arg0_5:findTF("num_txt", arg0_5._tf)
	arg0_5.timeTxt = arg0_5:findTF("time_txt", arg0_5._tf)
	arg0_5.bestTxt = arg0_5:findTF("best_txt", arg0_5._tf)
	arg0_5.maskBtn = arg0_5:findTF("mask_btn", arg0_5._tf)
	arg0_5.endTips = arg0_5:findTF("end_tips", arg0_5._tf)

	arg0_5:hideChild(arg0_5:findTF("res", arg0_5._tf))
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("card_pairs_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.maskBtn, function()
		if arg0_6.lastTimes > 0 then
			arg0_6:gameInit()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("card_pairs_tips"),
				onYes = function()
					arg0_6:gameInit()
				end
			})
		end
	end, SFX_PANEL)

	arg0_6.updateTimer = Timer.New(function()
		arg0_6:updateTimes()
	end, 10, -1)

	arg0_6.updateTimer:Start()

	arg0_6.showCards = {}
	arg0_6.showingCards = {}
	arg0_6.cardList = {}
	arg0_6.cardUIList = UIItemList.New(arg0_6.cardCon, arg0_6.cardTpl)

	arg0_6.cardUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_6.cardList[arg1_12 + 1]

			if var0_12 ~= nil then
				var0_12:initCard(arg0_6.cardIndexList[arg1_12 + 1][1])
			else
				table.insert(arg0_6.cardList, arg1_12 + 1, CardPairsCard.New(arg2_12, arg0_6.pics, arg0_6.cardIndexList[arg1_12 + 1][1], function(arg0_13)
					if arg0_6.gameState == arg0_6.GAME_STATE_GAMING then
						if arg0_6.isFrist then
							arg0_6.isFrist = false
							arg0_6.beginTime = Time.realtimeSinceStartup
							arg0_6.countTimer = Timer.New(function()
								local var0_14 = math.floor((Time.realtimeSinceStartup - arg0_6.beginTime) * 1000)

								arg0_6:setTimeTxt(var0_14)
							end, 0.12, -1)

							arg0_6.countTimer:Start()
						end

						if arg0_13.canClick and arg0_13.enable and #arg0_6.showCards < 2 then
							arg0_13:aniShowBack(arg0_13.cardState == CardPairsCard.CARD_STATE_BACK)
						end
					end
				end, function(arg0_15, arg1_15)
					if arg0_6.gameState == arg0_6.GAME_STATE_GAMING then
						arg0_15:setEnable(false)

						if arg1_15 then
							table.insert(arg0_6.showCards, #arg0_6.showCards + 1, arg0_15)

							if #arg0_6.showCards == 2 then
								arg0_6:setAllCardEnale(false)
							end
						end
					end
				end, function(arg0_16, arg1_16)
					if arg0_6.gameState == arg0_6.GAME_STATE_GAMING then
						if arg1_16 then
							arg0_16:setOutline(true)
							table.insert(arg0_6.showingCards, #arg0_6.showingCards + 1, arg0_16)

							if #arg0_6.showingCards % 2 == 0 then
								local var0_16 = #arg0_6.showingCards
								local var1_16 = #arg0_6.showingCards - 1
								local var2_16 = arg0_6.showingCards[var1_16]
								local var3_16 = arg0_6.showingCards[var0_16]

								table.remove(arg0_6.showingCards, var0_16)
								table.remove(arg0_6.showingCards, var1_16)

								if var2_16:getCardIndex() == var3_16:getCardIndex() then
									var2_16:setClear(true)
									var3_16:setClear(true)

									arg0_6.curValue = arg0_6.curValue + 2

									if arg0_6.curValue >= arg0_6.CARD_NUM then
										arg0_6:gameEndHandler()
									else
										for iter0_16 = #arg0_6.showCards, 0, -1 do
											table.remove(arg0_6.showCards, iter0_16)
										end

										arg0_6:setAllCardEnale(true)
									end
								else
									var2_16:aniShowBack(false, false, arg0_6.showingTime)
									var3_16:aniShowBack(false, false, arg0_6.showingTime)
								end
							end
						else
							table.remove(arg0_6.showCards, #arg0_6.showCards)
							arg0_6:setAllCardEnale(#arg0_6.showingCards == 0)
						end
					end
				end))
			end
		end
	end)

	if not arg0_6:tryFirstPlayStory() then
		triggerButton(arg0_6.maskBtn)
	end
end

function var0_0.setAllCardEnale(arg0_17, arg1_17)
	for iter0_17, iter1_17 in pairs(arg0_17.cardList) do
		iter1_17:setEnable(arg1_17)
	end
end

function var0_0.setTimeTxt(arg0_18, arg1_18)
	setText(arg0_18.timeTxt, arg0_18:getTimeFormat(arg1_18))
end

function var0_0.getTimeFormat(arg0_19, arg1_19)
	local var0_19 = math.floor(arg1_19 / 60000)

	var0_19 = var0_19 >= 10 and var0_19 or "0" .. var0_19

	local var1_19 = math.floor(arg1_19 % 60000 / 1000)

	var1_19 = var1_19 >= 10 and var1_19 or "0" .. var1_19

	local var2_19 = math.floor(arg1_19 % 1000 / 10)

	var2_19 = var2_19 >= 10 and var2_19 or "0" .. var2_19

	return var0_19 .. "'" .. var1_19 .. "'" .. var2_19
end

function var0_0.updateTimes(arg0_20)
	local var0_20 = os.difftime(pg.TimeMgr.GetInstance():GetServerTime(), arg0_20.activityData.data3)
	local var1_20 = math.ceil(var0_20 / 86400)

	var1_20 = var1_20 < 0 and 0 or var1_20
	var1_20 = var1_20 > arg0_20.cardEffectTimesMax and arg0_20.cardEffectTimesMax or var1_20
	arg0_20.lastTimes = var1_20 - arg0_20.activityData.data2

	setText(arg0_20.timesTxt, arg0_20.lastTimes >= 0 and arg0_20.lastTimes or 0)
end

function var0_0.gameInit(arg0_21)
	setActive(arg0_21.maskBtn, false)
	setActive(arg0_21.endTips, false)

	arg0_21.isFrist = true
	arg0_21.curValue = 0
	arg0_21.showCards = {}
	arg0_21.showingCards = {}
	arg0_21.cardIndexList = {}

	for iter0_21 = 1, arg0_21.CARD_NUM / 2 do
		table.insert(arg0_21.cardIndexList, #arg0_21.cardIndexList + 1, {
			iter0_21,
			math.random(0, 100)
		})
		table.insert(arg0_21.cardIndexList, #arg0_21.cardIndexList + 1, {
			iter0_21,
			math.random(0, 100)
		})
	end

	table.sort(arg0_21.cardIndexList, function(arg0_22, arg1_22)
		if arg0_22[2] > arg1_22[2] then
			return true
		end

		return false
	end)
	arg0_21:setTimeTxt(0)
	arg0_21:clearCountTimer()
	arg0_21:clearAllCard()
	arg0_21.cardUIList:align(arg0_21.CARD_NUM)

	arg0_21.gameState = arg0_21.GAME_STATE_BEGIN

	arg0_21:checkGameState()
end

function var0_0.checkGameState(arg0_23)
	if arg0_23.gameState == arg0_23.GAME_STATE_BEGIN then
		arg0_23:showAllCard()
	elseif arg0_23.gameState == arg0_23.GAME_STATE_GAMING then
		-- block empty
	elseif arg0_23.gameState == arg0_23.GAME_STATE_END then
		arg0_23:clearCountTimer()
	end
end

function var0_0.gameEndHandler(arg0_24)
	arg0_24.gameState = arg0_24.GAME_STATE_END

	arg0_24:checkGameState()
	setActive(arg0_24.maskBtn, true)

	local var0_24 = math.floor((Time.realtimeSinceStartup - arg0_24.beginTime) * 1000)

	var0_24 = var0_24 < 0 and 9 * arg0_24.aniTime or var0_24

	arg0_24:setTimeTxt(var0_24)

	local var1_24 = arg0_24.lastTimes > 0 and arg0_24.activityData.data2 + 1 or arg0_24.activityData.data2

	var1_24 = var1_24 > arg0_24.cardEffectTimesMax and arg0_24.cardEffectTimesMax or var1_24

	if arg0_24.lastTimes > 0 or var0_24 < arg0_24.activityData.data4 then
		arg0_24:emit(CardPairsMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_24.activityData.id,
			arg1 = var1_24,
			arg2 = var0_24
		})
	end

	setActive(arg0_24.endTips, true)
end

function var0_0.showAllCard(arg0_25)
	arg0_25:setAllCardEnale(false)

	arg0_25.timer = Timer.New(function()
		for iter0_26, iter1_26 in pairs(arg0_25.cardList) do
			iter1_26:aniShowBack(true)
		end

		arg0_25.timer = Timer.New(function()
			for iter0_27, iter1_27 in pairs(arg0_25.cardList) do
				iter1_27:aniShowBack()
			end

			arg0_25.timer = Timer.New(function()
				arg0_25.gameState = arg0_25.GAME_STATE_GAMING

				arg0_25:checkGameState()
				arg0_25:setAllCardEnale(true)
			end, arg0_25.aniTime, 1)

			arg0_25.timer:Start()
		end, arg0_25.firstShowingTime, 1)

		arg0_25.timer:Start()
	end, 0.5, 1)

	arg0_25.timer:Start()
end

function var0_0.clearAllCard(arg0_29, arg1_29)
	if arg0_29.timer ~= nil then
		arg0_29.timer:Stop()

		arg0_29.timer = nil
	end

	if arg1_29 then
		for iter0_29, iter1_29 in pairs(arg0_29.cardList) do
			iter1_29:destroy()
		end

		arg0_29.cardList = {}
	else
		for iter2_29, iter3_29 in pairs(arg0_29.cardList) do
			iter3_29:clear()
		end
	end
end

function var0_0.hideChild(arg0_30, arg1_30)
	local var0_30 = arg1_30.childCount

	for iter0_30 = 0, var0_30 - 1 do
		local var1_30 = arg1_30:GetChild(iter0_30)

		setActive(var1_30, false)
	end
end

function var0_0.tryFirstPlayStory(arg0_31)
	if arg0_31.activityData:getConfig("config_client")[1] then
		local var0_31 = arg0_31.activityData:getConfig("config_client")[1][1]

		if var0_31 ~= nil and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_31) then
			pg.NewStoryMgr.GetInstance():Play(var0_31, function()
				triggerButton(arg0_31.maskBtn)
			end)

			return true
		end

		return false
	else
		return false
	end
end

function var0_0.clearCountTimer(arg0_33)
	if arg0_33.countTimer ~= nil then
		arg0_33.countTimer:Stop()

		arg0_33.countTimer = nil
	end
end

function var0_0.willExit(arg0_34)
	arg0_34:clearAllCard(true)
	arg0_34:clearCountTimer()

	if arg0_34.updateTimer ~= nil then
		arg0_34.updateTimer:Stop()

		arg0_34.updateTimer = nil
	end
end

return var0_0
