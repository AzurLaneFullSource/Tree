local var0 = class("CardPairsScene", import("..base.BaseUI"))

var0.CARD_NUM = 18
var0.GAME_STATE_BEGIN = 0
var0.GAME_STATE_GAMING = 1
var0.GAME_STATE_END = 2
var0.config_init = false

function var0.getUIName(arg0)
	return "CardPairsUI"
end

function var0.setPlayerData(arg0, arg1)
	arg0.playerData = arg1
end

function var0.setActivityData(arg0, arg1)
	arg0.activityData = arg1

	if not arg0.config_init then
		local var0 = arg0.activityData:getConfig("config_client")[2]

		if var0 then
			arg0.firstShowingTime = var0.firstShowingTime
			arg0.showingTime = var0.showingTime
			arg0.aniTime = var0.aniTime
			arg0.cardEffectTimesMax = arg0.activityData:getConfig("config_data")[4]
		else
			arg0.firstShowingTime = 2
			arg0.showingTime = 0.3
			arg0.aniTime = 0.2
			arg0.cardEffectTimesMax = 7
		end

		CardPairsCard.ANI_TIME = arg0.aniTime
		arg0.config_init = true
	end

	arg0:updateTimes()

	if arg0.activityData.data4 <= 0 then
		setText(arg0.bestTxt, "--'--'--")
	else
		setText(arg0.bestTxt, arg0:getTimeFormat(arg0.activityData.data4))
	end
end

function var0.checkActivityEnd(arg0)
	return
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("top/back", arg0._tf)
	arg0.cardTpl = arg0:findTF("res/card", arg0._tf)
	arg0.cardCon = arg0:findTF("card_con/layout", arg0._tf)
	arg0.pics = arg0:findTF("res/pics", arg0._tf)
	arg0.helpBtn = arg0:findTF("top/help_btn", arg0._tf)
	arg0.timesTxt = arg0:findTF("num_txt", arg0._tf)
	arg0.timeTxt = arg0:findTF("time_txt", arg0._tf)
	arg0.bestTxt = arg0:findTF("best_txt", arg0._tf)
	arg0.maskBtn = arg0:findTF("mask_btn", arg0._tf)
	arg0.endTips = arg0:findTF("end_tips", arg0._tf)

	arg0:hideChild(arg0:findTF("res", arg0._tf))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("card_pairs_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.maskBtn, function()
		if arg0.lastTimes > 0 then
			arg0:gameInit()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("card_pairs_tips"),
				onYes = function()
					arg0:gameInit()
				end
			})
		end
	end, SFX_PANEL)

	arg0.updateTimer = Timer.New(function()
		arg0:updateTimes()
	end, 10, -1)

	arg0.updateTimer:Start()

	arg0.showCards = {}
	arg0.showingCards = {}
	arg0.cardList = {}
	arg0.cardUIList = UIItemList.New(arg0.cardCon, arg0.cardTpl)

	arg0.cardUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.cardList[arg1 + 1]

			if var0 ~= nil then
				var0:initCard(arg0.cardIndexList[arg1 + 1][1])
			else
				table.insert(arg0.cardList, arg1 + 1, CardPairsCard.New(arg2, arg0.pics, arg0.cardIndexList[arg1 + 1][1], function(arg0)
					if arg0.gameState == arg0.GAME_STATE_GAMING then
						if arg0.isFrist then
							arg0.isFrist = false
							arg0.beginTime = Time.realtimeSinceStartup
							arg0.countTimer = Timer.New(function()
								local var0 = math.floor((Time.realtimeSinceStartup - arg0.beginTime) * 1000)

								arg0:setTimeTxt(var0)
							end, 0.12, -1)

							arg0.countTimer:Start()
						end

						if arg0.canClick and arg0.enable and #arg0.showCards < 2 then
							arg0:aniShowBack(arg0.cardState == CardPairsCard.CARD_STATE_BACK)
						end
					end
				end, function(arg0, arg1)
					if arg0.gameState == arg0.GAME_STATE_GAMING then
						arg0:setEnable(false)

						if arg1 then
							table.insert(arg0.showCards, #arg0.showCards + 1, arg0)

							if #arg0.showCards == 2 then
								arg0:setAllCardEnale(false)
							end
						end
					end
				end, function(arg0, arg1)
					if arg0.gameState == arg0.GAME_STATE_GAMING then
						if arg1 then
							arg0:setOutline(true)
							table.insert(arg0.showingCards, #arg0.showingCards + 1, arg0)

							if #arg0.showingCards % 2 == 0 then
								local var0 = #arg0.showingCards
								local var1 = #arg0.showingCards - 1
								local var2 = arg0.showingCards[var1]
								local var3 = arg0.showingCards[var0]

								table.remove(arg0.showingCards, var0)
								table.remove(arg0.showingCards, var1)

								if var2:getCardIndex() == var3:getCardIndex() then
									var2:setClear(true)
									var3:setClear(true)

									arg0.curValue = arg0.curValue + 2

									if arg0.curValue >= arg0.CARD_NUM then
										arg0:gameEndHandler()
									else
										for iter0 = #arg0.showCards, 0, -1 do
											table.remove(arg0.showCards, iter0)
										end

										arg0:setAllCardEnale(true)
									end
								else
									var2:aniShowBack(false, false, arg0.showingTime)
									var3:aniShowBack(false, false, arg0.showingTime)
								end
							end
						else
							table.remove(arg0.showCards, #arg0.showCards)
							arg0:setAllCardEnale(#arg0.showingCards == 0)
						end
					end
				end))
			end
		end
	end)

	if not arg0:tryFirstPlayStory() then
		triggerButton(arg0.maskBtn)
	end
end

function var0.setAllCardEnale(arg0, arg1)
	for iter0, iter1 in pairs(arg0.cardList) do
		iter1:setEnable(arg1)
	end
end

function var0.setTimeTxt(arg0, arg1)
	setText(arg0.timeTxt, arg0:getTimeFormat(arg1))
end

function var0.getTimeFormat(arg0, arg1)
	local var0 = math.floor(arg1 / 60000)

	var0 = var0 >= 10 and var0 or "0" .. var0

	local var1 = math.floor(arg1 % 60000 / 1000)

	var1 = var1 >= 10 and var1 or "0" .. var1

	local var2 = math.floor(arg1 % 1000 / 10)

	var2 = var2 >= 10 and var2 or "0" .. var2

	return var0 .. "'" .. var1 .. "'" .. var2
end

function var0.updateTimes(arg0)
	local var0 = os.difftime(pg.TimeMgr.GetInstance():GetServerTime(), arg0.activityData.data3)
	local var1 = math.ceil(var0 / 86400)

	var1 = var1 < 0 and 0 or var1
	var1 = var1 > arg0.cardEffectTimesMax and arg0.cardEffectTimesMax or var1
	arg0.lastTimes = var1 - arg0.activityData.data2

	setText(arg0.timesTxt, arg0.lastTimes >= 0 and arg0.lastTimes or 0)
end

function var0.gameInit(arg0)
	setActive(arg0.maskBtn, false)
	setActive(arg0.endTips, false)

	arg0.isFrist = true
	arg0.curValue = 0
	arg0.showCards = {}
	arg0.showingCards = {}
	arg0.cardIndexList = {}

	for iter0 = 1, arg0.CARD_NUM / 2 do
		table.insert(arg0.cardIndexList, #arg0.cardIndexList + 1, {
			iter0,
			math.random(0, 100)
		})
		table.insert(arg0.cardIndexList, #arg0.cardIndexList + 1, {
			iter0,
			math.random(0, 100)
		})
	end

	table.sort(arg0.cardIndexList, function(arg0, arg1)
		if arg0[2] > arg1[2] then
			return true
		end

		return false
	end)
	arg0:setTimeTxt(0)
	arg0:clearCountTimer()
	arg0:clearAllCard()
	arg0.cardUIList:align(arg0.CARD_NUM)

	arg0.gameState = arg0.GAME_STATE_BEGIN

	arg0:checkGameState()
end

function var0.checkGameState(arg0)
	if arg0.gameState == arg0.GAME_STATE_BEGIN then
		arg0:showAllCard()
	elseif arg0.gameState == arg0.GAME_STATE_GAMING then
		-- block empty
	elseif arg0.gameState == arg0.GAME_STATE_END then
		arg0:clearCountTimer()
	end
end

function var0.gameEndHandler(arg0)
	arg0.gameState = arg0.GAME_STATE_END

	arg0:checkGameState()
	setActive(arg0.maskBtn, true)

	local var0 = math.floor((Time.realtimeSinceStartup - arg0.beginTime) * 1000)

	var0 = var0 < 0 and 9 * arg0.aniTime or var0

	arg0:setTimeTxt(var0)

	local var1 = arg0.lastTimes > 0 and arg0.activityData.data2 + 1 or arg0.activityData.data2

	var1 = var1 > arg0.cardEffectTimesMax and arg0.cardEffectTimesMax or var1

	if arg0.lastTimes > 0 or var0 < arg0.activityData.data4 then
		arg0:emit(CardPairsMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activityData.id,
			arg1 = var1,
			arg2 = var0
		})
	end

	setActive(arg0.endTips, true)
end

function var0.showAllCard(arg0)
	arg0:setAllCardEnale(false)

	arg0.timer = Timer.New(function()
		for iter0, iter1 in pairs(arg0.cardList) do
			iter1:aniShowBack(true)
		end

		arg0.timer = Timer.New(function()
			for iter0, iter1 in pairs(arg0.cardList) do
				iter1:aniShowBack()
			end

			arg0.timer = Timer.New(function()
				arg0.gameState = arg0.GAME_STATE_GAMING

				arg0:checkGameState()
				arg0:setAllCardEnale(true)
			end, arg0.aniTime, 1)

			arg0.timer:Start()
		end, arg0.firstShowingTime, 1)

		arg0.timer:Start()
	end, 0.5, 1)

	arg0.timer:Start()
end

function var0.clearAllCard(arg0, arg1)
	if arg0.timer ~= nil then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	if arg1 then
		for iter0, iter1 in pairs(arg0.cardList) do
			iter1:destroy()
		end

		arg0.cardList = {}
	else
		for iter2, iter3 in pairs(arg0.cardList) do
			iter3:clear()
		end
	end
end

function var0.hideChild(arg0, arg1)
	local var0 = arg1.childCount

	for iter0 = 0, var0 - 1 do
		local var1 = arg1:GetChild(iter0)

		setActive(var1, false)
	end
end

function var0.tryFirstPlayStory(arg0)
	if arg0.activityData:getConfig("config_client")[1] then
		local var0 = arg0.activityData:getConfig("config_client")[1][1]

		if var0 ~= nil and not pg.NewStoryMgr.GetInstance():IsPlayed(var0) then
			pg.NewStoryMgr.GetInstance():Play(var0, function()
				triggerButton(arg0.maskBtn)
			end)

			return true
		end

		return false
	else
		return false
	end
end

function var0.clearCountTimer(arg0)
	if arg0.countTimer ~= nil then
		arg0.countTimer:Stop()

		arg0.countTimer = nil
	end
end

function var0.willExit(arg0)
	arg0:clearAllCard(true)
	arg0:clearCountTimer()

	if arg0.updateTimer ~= nil then
		arg0.updateTimer:Stop()

		arg0.updateTimer = nil
	end
end

return var0
