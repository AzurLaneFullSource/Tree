local var0_0 = class("RPSGameLayer", import("..base.BaseUI"))
local var1_0 = 600000000
local var2_0 = "ui/rpsgameui_atlas"
local var3_0 = 75
local var4_0 = 1
local var5_0 = 2
local var6_0 = 3
local var7_0 = 4
local var8_0 = 5
local var9_0 = 5
local var10_0 = 3
local var11_0 = 0.1
local var12_0 = 0.1
local var13_0 = 2
local var14_0 = 5
local var15_0 = 0.7
local var16_0 = 140 * var15_0
local var17_0 = "event show panel closed"
local var18_0 = "event take card"
local var19_0 = "event compared card end"
local var20_0 = {
	["12"] = "action2",
	["13"] = "action3",
	["33"] = "action4",
	["23"] = "action9",
	["11"] = "action1",
	["32"] = "action6",
	["22"] = "action7",
	["21"] = "action8",
	["31"] = "action5"
}

local function var21_0(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1 = {
		Ctor = function(arg0_2)
			arg0_2._tf = arg0_1
			arg0_2._event = arg1_1
			arg0_2._topCardTpl = arg3_1
			arg0_2._bottomCardTpl = arg2_1

			setActive(arg0_2._tf, false)

			arg0_2._topContent = findTF(arg0_2._tf, "top/content")
			arg0_2._bottomContent = findTF(arg0_2._tf, "bottom/content")
			arg0_2.topCards = {}
			arg0_2.bottomCards = {}

			for iter0_2 = 1, var8_0 do
				local var0_2 = tf(instantiate(arg0_2._topCardTpl))
				local var1_2 = tf(instantiate(arg0_2._bottomCardTpl))

				SetParent(var0_2, arg0_2._topContent)
				SetParent(var1_2, arg0_2._bottomContent)
				setActive(var0_2, true)
				setActive(var1_2, true)
				table.insert(arg0_2.topCards, var0_2)
				table.insert(arg0_2.bottomCards, var1_2)
			end
		end,
		setCardData = function(arg0_3, arg1_3)
			local var0_3 = arg1_3.my_cards
			local var1_3 = arg1_3.other_cards

			for iter0_3 = 1, var8_0 do
				arg0_3:setCardChildsVisible(findTF(arg0_3.topCards[iter0_3], "ad"), false)
				arg0_3:setCardChildsVisible(findTF(arg0_3.bottomCards[iter0_3], "ad"), false)
				setActive(findTF(arg0_3.topCards[iter0_3], "ad/" .. var0_3[iter0_3]), true)
				setActive(findTF(arg0_3.bottomCards[iter0_3], "ad/" .. var1_3[iter0_3]), true)
			end
		end,
		setCardChildsVisible = function(arg0_4, arg1_4, arg2_4)
			for iter0_4 = 1, arg1_4.childCount do
				setActive(arg1_4:GetChild(iter0_4 - 1), arg2_4)
			end
		end,
		start = function(arg0_5)
			arg0_5._countTime = var9_0

			arg0_5:setVisible(true)
		end,
		step = function(arg0_6, arg1_6)
			if arg0_6._countTime then
				arg0_6._countTime = arg0_6._countTime - arg1_6

				if arg0_6._countTime <= 0 then
					arg0_6._countTime = nil

					arg0_6:setVisible(false)
					arg0_6._event:emit(var17_0)

					return
				end
			end
		end,
		setVisible = function(arg0_7, arg1_7)
			setActive(arg0_7._tf, arg1_7)
		end
	}

	var0_1:Ctor()

	return var0_1
end

local function var22_0(arg0_8, arg1_8)
	local var0_8 = {
		Ctor = function(arg0_9)
			arg0_9._tf = arg0_8
			arg0_9._event = arg1_8
			arg0_9.btnTake = findTF(arg0_9._tf, "btnTake")

			setText(findTF(arg0_9.btnTake, "txt"), i18n("rps_game_take_card"))
			onButton(arg0_9._event, arg0_9.btnTake, function()
				arg0_9:takeMyCard()
			end, SFX_CONFIRM)

			arg0_9.myCardTfs = {}

			for iter0_9 = 1, var8_0 do
				local var0_9 = findTF(arg0_9._tf, "bottomCard/cardContent/" .. iter0_9)

				table.insert(arg0_9.myCardTfs, var0_9)
				onButton(arg0_9._event, var0_9, function()
					if arg0_9.lockSelect then
						return
					end

					arg0_9.cardSelectIndex = iter0_9

					arg0_9:updateSelectCard()
				end, SFX_CONFIRM)
			end

			arg0_9.otherCardTfs = {}

			for iter1_9 = 1, var8_0 do
				table.insert(arg0_9.otherCardTfs, findTF(arg0_9._tf, "topCard/cardContent/" .. iter1_9))
			end

			arg0_9.myHearts = {}
			arg0_9.otherHearts = {}

			for iter2_9 = 1, var10_0 do
				table.insert(arg0_9.myHearts, findTF(arg0_9._tf, "bottomStatus/heart/" .. iter2_9))
				table.insert(arg0_9.otherHearts, findTF(arg0_9._tf, "topStatus/heart/" .. iter2_9))
			end

			arg0_9.takeTimeText = findTF(arg0_9._tf, "takeTime/text")
			arg0_9.compareTf = findTF(arg0_9._tf, "compare")
			arg0_9.spineAnimTf = findTF(arg0_9._tf, "compare/mask/RPSSpine")
			arg0_9.spineAnim = GetComponent(arg0_9.spineAnimTf, typeof(SpineAnimUI))
		end,
		updateSelectCard = function(arg0_12)
			for iter0_12 = 1, #arg0_12.myCardTfs do
				local var0_12 = arg0_12.myCardTfs[iter0_12].anchoredPosition

				if arg0_12.cardSelectIndex and arg0_12.cardSelectIndex == iter0_12 then
					arg0_12.myCardTfs[iter0_12].anchoredPosition = Vector2(var0_12.x, 100)

					setActive(findTF(arg0_12.myCardTfs[iter0_12], "AD/select"), true)
				else
					arg0_12.myCardTfs[iter0_12].anchoredPosition = Vector2(var0_12.x, 0)

					setActive(findTF(arg0_12.myCardTfs[iter0_12], "AD/select"), false)
				end
			end
		end,
		updateDetail = function(arg0_13, arg1_13)
			local var0_13 = arg1_13.my_cards
			local var1_13 = arg1_13.other_cards
			local var2_13 = arg1_13.my_heart
			local var3_13 = arg1_13.other_heart

			arg0_13.myCardNum = #var0_13
			arg0_13.otherCardNum = #var1_13

			setActive(arg0_13.btnTake, #var0_13 ~= 0)

			for iter0_13 = 1, #arg0_13.myCardTfs do
				if iter0_13 <= #var0_13 then
					arg0_13:updateCardIndex(arg0_13.myCardTfs[iter0_13], var0_13[iter0_13], false)
				end

				setActive(arg0_13.myCardTfs[iter0_13], iter0_13 <= #var0_13)
			end

			for iter1_13 = 1, #arg0_13.otherCardTfs do
				arg0_13:updateCardCount(arg0_13.otherCardTfs[iter1_13], #var1_13)

				if arg0_13.otherCardNum <= 0 then
					setActive(arg0_13.otherCardTfs[iter1_13], false)
				else
					setActive(arg0_13.otherCardTfs[iter1_13], iter1_13 <= 1)
				end
			end

			for iter2_13 = 1, #arg0_13.myHearts do
				setActive(arg0_13.myHearts[iter2_13], iter2_13 <= var2_13)
			end

			for iter3_13 = 1, #arg0_13.otherHearts do
				setActive(arg0_13.otherHearts[iter3_13], iter3_13 <= var3_13)
			end

			arg0_13.takeTimeText.anchoredPosition = Vector2(-(var8_0 - arg0_13.myCardNum) * var16_0, 0)
		end,
		updateCardCount = function(arg0_14, arg1_14, arg2_14)
			setText(findTF(arg1_14, "text"), tostring(arg2_14))
		end,
		updateCardIndex = function(arg0_15, arg1_15, arg2_15)
			arg0_15:setCardChildsVisible(findTF(arg1_15, "AD"), false)
			setActive(findTF(arg1_15, "AD/" .. arg2_15), true)
		end,
		setCardChildsVisible = function(arg0_16, arg1_16, arg2_16)
			for iter0_16 = 1, arg1_16.childCount do
				setActive(arg1_16:GetChild(iter0_16 - 1), arg2_16)
			end
		end,
		start = function(arg0_17)
			arg0_17.cardSelectIndex = nil

			arg0_17:updateLock(false)
			arg0_17:setVisible(false)
			setActive(arg0_17.compareTf, false)
		end,
		step = function(arg0_18, arg1_18)
			if arg0_18.myCardTime and not arg0_18.myCardCompared and arg0_18.myCardTime > 0 then
				arg0_18.myCardTime = arg0_18.myCardTime - arg1_18

				if arg0_18.myCardTime <= 0 then
					arg0_18.myCardTime = nil
					arg0_18.cardSelectIndex = math.random(1, arg0_18.myCardNum)

					arg0_18:takeMyCard()
				end
			end

			if not arg0_18.comparedShowTime and arg0_18.myCardCompared and arg0_18.otherCardCompared then
				arg0_18.comparedShowTime = var11_0
			end

			if arg0_18.comparedShowTime and arg0_18.comparedShowTime > 0 then
				arg0_18.comparedShowTime = arg0_18.comparedShowTime - arg1_18

				if arg0_18.comparedShowTime <= 0 then
					arg0_18.comparedShowTime = 0

					setActive(arg0_18.compareTf, true)
					arg0_18:SetActionWithFinishCallback(arg0_18.spineAnim, var20_0[arg0_18.myCardCompared .. arg0_18.otherCardCompared], 0, function()
						setActive(arg0_18.compareTf, false)

						arg0_18.comparedStepTime = var12_0
					end, true, function()
						return
					end)
				end
			end

			if arg0_18.comparedStepTime and arg0_18.comparedStepTime > 0 then
				arg0_18.comparedStepTime = arg0_18.comparedStepTime - arg1_18

				if arg0_18.comparedStepTime and arg0_18.comparedStepTime <= 0 then
					arg0_18.comparedStepTime = nil
					arg0_18.comparedShowTime = nil
					arg0_18.myCardCompared = nil
					arg0_18.otherCardCompared = nil

					arg0_18._event:emit(var19_0)
				end
			end

			if arg0_18.myCardTime then
				setText(arg0_18.takeTimeText, tostring(math.ceil(arg0_18.myCardTime)))
			else
				setText(arg0_18.takeTimeText, "")
			end

			if arg0_18.myCardCompared and isActive(arg0_18.btnTake) then
				setActive(arg0_18.btnTake, false)
			elseif not arg0_18.myCardCompared and not isActive(arg0_18.btnTake) then
				setActive(arg0_18.btnTake, true)
			end
		end,
		startUp = function(arg0_21)
			arg0_21.myCardTime = var14_0

			arg0_21:setVisible(true)
		end,
		setMyCompareCard = function(arg0_22, arg1_22)
			arg0_22.myCardCompared = arg1_22
		end,
		setOtherCompareCard = function(arg0_23, arg1_23)
			arg0_23.otherCardCompared = arg1_23
		end,
		takeMyCard = function(arg0_24)
			if arg0_24.lockSelect then
				return
			end

			if arg0_24.myCardNum == 1 and not arg0_24.cardSelectIndex then
				arg0_24.cardSelectIndex = 1
			end

			if arg0_24.cardSelectIndex then
				arg0_24._event:emit(var18_0, arg0_24.cardSelectIndex)

				arg0_24.cardSelectIndex = nil

				arg0_24:updateLock(true)
				arg0_24:updateSelectCard()
			end
		end,
		updateLock = function(arg0_25, arg1_25)
			arg0_25.myCardTime = not arg1_25 and var14_0 or nil
			arg0_25.lockSelect = arg1_25
		end,
		setVisible = function(arg0_26, arg1_26)
			setActive(arg0_26._tf, arg1_26)
		end,
		SetActionWithFinishCallback = function(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27, arg6_27)
			if arg4_27 or arg6_27 then
				arg1_27:SetActionCallBack(function(arg0_28)
					if arg0_28 == "finish" and arg4_27 then
						arg1_27:SetActionCallBack(nil)
						arg4_27()
					elseif arg0_28 == "action" and arg6_27 then
						arg6_27()
					end
				end)
			else
				arg1_27:SetActionCallBack(nil)
			end

			arg1_27:SetAction(arg2_27, arg3_27)
		end,
		dispose = function(arg0_29)
			arg0_29.spineAnim:SetActionCallBack(nil)
		end
	}

	var0_8:Ctor()

	return var0_8
end

function var0_0.getUIName(arg0_30)
	return "RPSGameUI"
end

function var0_0.didEnter(arg0_31)
	arg0_31:initEvent()
	arg0_31:initData()
	arg0_31:initUI()
	arg0_31:initGameUI()
	arg0_31:readyStart()
end

function var0_0.initEvent(arg0_32)
	arg0_32:bind(var19_0, function(arg0_33, arg1_33, arg2_33)
		if arg0_32.myTakeCard == arg0_32.otherTakeCard + 1 or arg0_32.myTakeCard + 2 == arg0_32.otherTakeCard then
			arg0_32.gameData.my_heart = arg0_32.gameData.my_heart - 1

			arg0_32:sendGamingNotice(2)
		elseif arg0_32.myTakeCard ~= arg0_32.otherTakeCard then
			arg0_32.gameData.other_heart = arg0_32.gameData.other_heart - 1

			arg0_32:sendGamingNotice(1)
		else
			arg0_32:sendGamingNotice(3)
		end

		arg0_32.detailPanel:updateDetail(arg0_32.gameData)

		if arg0_32.gameData.my_heart == 0 or arg0_32.gameData.other_heart == 0 or #arg0_32.gameData.my_cards == 0 then
			arg0_32.gameState = var7_0
			arg0_32.gameStartFlag = false

			arg0_32:showSettlement()
		else
			arg0_32.gameState = var5_0
			arg0_32.myTakeCard, arg0_32.otherTakeCard = nil

			arg0_32.detailPanel:updateLock(false)
		end
	end)
	arg0_32:bind(var17_0, function(arg0_34, arg1_34, arg2_34)
		arg0_32.gameState = var5_0

		if arg0_32.detailPanel then
			arg0_32.detailPanel:startUp()
		end
	end)
	arg0_32:bind(var18_0, function(arg0_35, arg1_35, arg2_35)
		if arg0_32.gameState == var5_0 then
			arg0_32.gameState = var6_0
			arg0_32.myTakeCard = table.remove(arg0_32.gameData.my_cards, arg1_35)

			arg0_32.detailPanel:setMyCompareCard(arg0_32.myTakeCard)
			arg0_32.detailPanel:updateDetail(arg0_32.gameData)
		end
	end)
end

function var0_0.sendGamingNotice(arg0_36, arg1_36)
	arg0_36:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
		operationCode = "GAME_RPS_RESULT",
		index = arg1_36,
		miniGameId = var3_0
	})
end

function var0_0.initData(arg0_37)
	local var0_37 = Application.targetFrameRate <= 60 and Application.targetFrameRate or 60

	arg0_37.stepCount = 1 / var0_37
	arg0_37.realTimeStartUp = Time.realtimeSinceStartup
	arg0_37.timer = Timer.New(function()
		if Time.realtimeSinceStartup - arg0_37.realTimeStartUp > arg0_37.stepCount then
			arg0_37:onTimer()

			arg0_37.realTimeStartUp = Time.realtimeSinceStartup
		end
	end, 1 / var0_37, -1)
end

function var0_0.initUI(arg0_39)
	arg0_39.backSceneTf = findTF(arg0_39._tf, "scene_container/scene_background")
	arg0_39.sceneTf = findTF(arg0_39._tf, "scene_container/scene")
	arg0_39.bgTf = findTF(arg0_39._tf, "bg")
	arg0_39.clickMask = findTF(arg0_39._tf, "clickMask")
	arg0_39.settlementUI = findTF(arg0_39._tf, "pop/SettleMentUI")

	onButton(arg0_39, findTF(arg0_39.settlementUI, "btnOver"), function()
		arg0_39:checkGameExit()
	end, SFX_CANCEL)
	SetActive(arg0_39.settlementUI, false)
end

function var0_0.initGameUI(arg0_41)
	arg0_41.gameUI = findTF(arg0_41._tf, "ui/gameUI")

	onButton(arg0_41, findTF(arg0_41.gameUI, "btnLeave"), function()
		arg0_41:checkGameExit()
	end)

	arg0_41.dragDelegate = GetOrAddComponent(arg0_41.sceneTf, "EventTriggerListener")
	arg0_41.dragDelegate.enabled = true

	arg0_41.dragDelegate:AddPointDownFunc(function(arg0_43, arg1_43)
		return
	end)

	arg0_41.showPanel = var21_0(findTF(arg0_41.sceneTf, "showPanel"), arg0_41, findTF(arg0_41.sceneTf, "tpls/card_1"), findTF(arg0_41.sceneTf, "tpls/card_2"))
	arg0_41.detailPanel = var22_0(findTF(arg0_41.sceneTf, "detailPanel"), arg0_41)
end

function var0_0.Update(arg0_44)
	if arg0_44.gameStop or arg0_44.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.clearUI(arg0_45)
	setActive(arg0_45.sceneTf, false)
	setActive(arg0_45.settlementUI, false)
	setActive(arg0_45.gameUI, false)
end

function var0_0.readyStart(arg0_46)
	arg0_46:gameStart()
end

function var0_0.gameStart(arg0_47)
	setActive(findTF(arg0_47._tf, "scene_container"), true)
	setActive(findTF(arg0_47.bgTf, "on"), false)
	setActive(arg0_47.gameUI, true)

	arg0_47.gameStartFlag = true
	arg0_47.scoreNum = 0
	arg0_47.gameStepTime = 0
	arg0_47.gameTime = var1_0
	arg0_47.gameData = arg0_47:createGameData()
	arg0_47.gameState = var4_0

	arg0_47.showPanel:setCardData(arg0_47.gameData)
	arg0_47.detailPanel:updateDetail(arg0_47.gameData)
	arg0_47:updateGameUI()
	arg0_47:timerStart()

	if arg0_47.showPanel then
		arg0_47.showPanel:start()
	end

	if arg0_47.detailPanel then
		arg0_47.detailPanel:start()
	end
end

function var0_0.createGameData(arg0_48)
	local var0_48 = {
		1,
		2,
		3
	}
	local var1_48 = {
		1,
		2,
		3
	}

	for iter0_48 = 4, var8_0 do
		table.insert(var0_48, math.random(1, 3))
		table.insert(var1_48, math.random(1, 3))
	end

	table.sort(var0_48, function(arg0_49, arg1_49)
		return arg0_49 < arg1_49
	end)
	table.sort(var1_48, function(arg0_50, arg1_50)
		return arg0_50 < arg1_50
	end)

	return {
		other_cards = var0_48,
		my_cards = var1_48,
		my_heart = var10_0,
		other_heart = var10_0
	}
end

function var0_0.transformColor(arg0_51, arg1_51)
	local var0_51 = tonumber(string.sub(arg1_51, 1, 2), 16)
	local var1_51 = tonumber(string.sub(arg1_51, 3, 4), 16)
	local var2_51 = tonumber(string.sub(arg1_51, 5, 6), 16)

	return Color.New(var0_51 / 255, var1_51 / 255, var2_51 / 255)
end

function var0_0.onTimer(arg0_52)
	arg0_52:gameStep()
end

function var0_0.gameStep(arg0_53)
	arg0_53.deltaTime = Time.realtimeSinceStartup - arg0_53.realTimeStartUp
	arg0_53.gameTime = arg0_53.gameTime - arg0_53.deltaTime
	arg0_53.gameStepTime = arg0_53.gameStepTime + arg0_53.deltaTime

	if arg0_53.gameTime < 0 then
		arg0_53.gameTime = 0
	end

	arg0_53:updateGameUI()

	if arg0_53.showPanel then
		arg0_53.showPanel:step(arg0_53.deltaTime)
	end

	if arg0_53.detailPanel then
		arg0_53.detailPanel:step(arg0_53.deltaTime)
	end

	arg0_53:updateOtherTakeCard()

	if arg0_53.gameTime <= 0 then
		arg0_53:onGameOver(0)

		return
	end
end

function var0_0.updateOtherTakeCard(arg0_54)
	if arg0_54.gameState == var5_0 or arg0_54.gameState == var6_0 then
		if not arg0_54.otherTakeCard and not arg0_54.otherTakeTime then
			arg0_54.otherTakeTime = math.random(1, var13_0)
		end

		if arg0_54.otherTakeTime and arg0_54.otherTakeTime > 0 then
			arg0_54.otherTakeTime = arg0_54.otherTakeTime - arg0_54.deltaTime

			if arg0_54.otherTakeTime <= 0 then
				arg0_54.otherTakeCard = table.remove(arg0_54.gameData.other_cards, math.random(1, #arg0_54.gameData.other_cards))

				arg0_54.detailPanel:updateDetail(arg0_54.gameData)
				arg0_54.detailPanel:setOtherCompareCard(arg0_54.otherTakeCard)

				arg0_54.otherTakeTime = nil
			end
		end
	end
end

function var0_0.timerStart(arg0_55)
	if not arg0_55.timer.running then
		arg0_55.realTimeStartUp = Time.realtimeSinceStartup

		arg0_55.timer:Start()
	end
end

function var0_0.timerStop(arg0_56)
	if arg0_56.timer.running then
		arg0_56.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_57)
	return
end

function var0_0.onGameOver(arg0_58, arg1_58)
	if arg0_58.settlementFlag then
		return
	end

	arg0_58:timerStop()

	arg0_58.settlementFlag = true

	setActive(arg0_58.clickMask, true)
	setActive(findTF(arg0_58._tf, "scene_container"), false)
	setActive(arg0_58.gameUI, false)
	LeanTween.delayedCall(go(arg0_58._tf), arg1_58, System.Action(function()
		arg0_58.settlementFlag = false
		arg0_58.gameStartFlag = false

		setActive(arg0_58.clickMask, false)
		arg0_58:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_60)
	local var0_60 = var10_0 - arg0_60.gameData.other_heart
	local var1_60 = var10_0 - arg0_60.gameData.my_heart

	setText(findTF(arg0_60.settlementUI, "ad/score/score_1"), var0_60)
	setText(findTF(arg0_60.settlementUI, "ad/score/score_2"), var1_60)
	setActive(findTF(arg0_60.settlementUI, "ad/win"), var1_60 <= var0_60)
	setActive(findTF(arg0_60.settlementUI, "ad/defeat"), var0_60 < var1_60)
	arg0_60.detailPanel:setVisible(false)

	local var2_60 = getProxy(PlayerProxy):getPlayerId()
	local var3_60 = PlayerPrefs.GetInt("mg_score_" .. tostring(var2_60) .. "_" .. var3_0) or 0

	if var3_60 <= var0_60 then
		var3_60 = var0_60

		PlayerPrefs.SetInt("mg_score_" .. tostring(var2_60) .. "_" .. var3_0, var3_60)
	end

	arg0_60:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
		operationCode = "GAME_RESULT",
		win = var1_60 <= var0_60,
		score = var0_60,
		high_score = var3_60,
		miniGameId = var3_0
	})
	setActive(arg0_60.settlementUI, true)
end

function var0_0.resumeGame(arg0_61)
	arg0_61.gameStop = false

	arg0_61:timerStart()
end

function var0_0.stopGame(arg0_62)
	arg0_62.gameStop = true

	arg0_62:timerStop()
end

function var0_0.getMiniGameData(arg0_63)
	if not arg0_63._mgData then
		arg0_63._mgData = getProxy(MiniGameProxy):GetMiniGameData(var3_0)
	end

	return arg0_63._mgData
end

function var0_0.onBackPressed(arg0_64)
	arg0_64:checkGameExit()
end

function var0_0.checkGameExit(arg0_65)
	if not arg0_65.gameStartFlag then
		arg0_65:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
			operationCode = "GAME_CLOSE",
			doTrack = true,
			miniGameId = var3_0
		})
		arg0_65:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_65.gameStop then
			return
		end

		arg0_65:stopGame()

		if arg0_65.contextData.isDorm3d then
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
				contentText = i18n("mini_game_leave"),
				onConfirm = function()
					arg0_65:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
						operationCode = "GAME_CLOSE",
						doTrack = false,
						miniGameId = var3_0
					})
					arg0_65:emit(var0_0.ON_BACK_PRESSED)
				end,
				onClose = function()
					arg0_65:resumeGame()
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("mini_game_leave"),
				onYes = function()
					arg0_65:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
						operationCode = "GAME_CLOSE",
						doTrack = false,
						miniGameId = var3_0
					})
					arg0_65:emit(var0_0.ON_BACK_PRESSED)
				end,
				onNo = function()
					arg0_65:resumeGame()
				end
			})
		end
	end
end

function var0_0.willExit(arg0_70)
	if arg0_70.detailPanel then
		arg0_70.detailPanel:dispose()
	end

	if arg0_70._tf and LeanTween.isTweening(go(arg0_70._tf)) then
		LeanTween.cancel(go(arg0_70._tf))
	end

	if arg0_70.timer and arg0_70.timer.running then
		arg0_70.timer:Stop()
	end

	Time.timeScale = 1
	arg0_70.timer = nil
end

return var0_0
