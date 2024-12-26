local var0_0 = class("NengDaiScheduleGameView", import("view.base.BaseUI"))
local var1_0 = 70
local var2_0 = 105
local var3_0 = 3
local var4_0 = 10
local var5_0 = 2
local var6_0 = 7
local var7_0 = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12
}
local var8_0 = {
	"read",
	"draw",
	"study",
	"dance",
	"volleyball",
	"run",
	"clean",
	"cook",
	"washClothes",
	"game",
	"walk",
	"sleep"
}
local var9_0 = {
	"study",
	"study",
	"study",
	"sport",
	"sport",
	"sport",
	"housework",
	"housework",
	"housework",
	"entertainment",
	"entertainment",
	"entertainment"
}
local var10_0 = {
	"阅读",
	"画画",
	"学习",
	"舞蹈",
	"排球",
	"跑步",
	"打扫",
	"做饭",
	"洗衣服",
	"游戏",
	"散步",
	"睡觉"
}
local var11_0 = {
	study = "学习",
	sport = "运动",
	housework = "家务",
	entertainment = "娱乐"
}

function var0_0.getUIName(arg0_1)
	return "NengDaiScheduleGameView"
end

function var0_0.didEnter(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:readyStart()
	arg0_2:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
		operationCode = "GAME_READY",
		miniGameId = var1_0
	})
end

function var0_0.initData(arg0_3)
	local var0_3 = Application.targetFrameRate or 60

	if var0_3 > 60 then
		var0_3 = 60
	end

	arg0_3.stepCount = 1 / var0_3 * 0.9
	arg0_3.realTimeStartUp = Time.realtimeSinceStartup
	arg0_3.timer = Timer.New(function()
		if Time.realtimeSinceStartup - arg0_3.realTimeStartUp > arg0_3.stepCount then
			arg0_3:onTimer()

			arg0_3.realTimeStartUp = Time.realtimeSinceStartup
		end
	end, 1 / var0_3, -1)

	for iter0_3 = 1, #var10_0 do
		var10_0[iter0_3] = i18n("dorm3d_nengdai_minigame_behavior" .. iter0_3)
	end

	var11_0.study = i18n("dorm3d_nengdai_minigame_behavior_type1")
	var11_0.sport = i18n("dorm3d_nengdai_minigame_behavior_type2")
	var11_0.housework = i18n("dorm3d_nengdai_minigame_behavior_type3")
	var11_0.entertainment = i18n("dorm3d_nengdai_minigame_behavior_type4")
end

function var0_0.onTimer(arg0_5)
	arg0_5.deltaTime = Time.realtimeSinceStartup - arg0_5.realTimeStartUp

	if not arg0_5.startSettlement then
		arg0_5.gameTime = arg0_5.gameTime - arg0_5.deltaTime
		arg0_5.gameStepTime = arg0_5.gameStepTime + arg0_5.deltaTime

		if arg0_5.gameTime < 0 then
			arg0_5.gameTime = 0
		end
	end

	if arg0_5.showFlag then
		arg0_5.showTime = arg0_5.showTime + arg0_5.deltaTime

		if arg0_5.showTime >= var3_0 then
			arg0_5.showTime = arg0_5.showTime - var3_0

			arg0_5:ChangeMotion()
		end
	end

	if arg0_5.chooseFlag then
		arg0_5.chooseTime = arg0_5.chooseTime - arg0_5.deltaTime

		if arg0_5.chooseTime <= 0 then
			if #arg0_5.playerChoosedScheduleList < 3 * arg0_5.round then
				for iter0_5 = #arg0_5.playerChoosedScheduleList + 1, 3 * arg0_5.round do
					arg0_5.playerChoosedScheduleList[iter0_5] = 0
				end
			end

			arg0_5:ChangeMotion()
		end
	end

	if arg0_5.roundSettleFlag then
		arg0_5.roundSettleTime = arg0_5.roundSettleTime + arg0_5.deltaTime

		if arg0_5.roundSettleTime >= var5_0 then
			arg0_5.roundSettleTime = arg0_5.roundSettleTime - var5_0

			arg0_5:ChangeMotion()
		end
	end

	local var0_5 = math.ceil(arg0_5.gameTime)
	local var1_5 = math.floor(var0_5 / 60)
	local var2_5 = var0_5 % 60

	setText(arg0_5.gameUITime, string.format("%02d", var1_5) .. ":" .. string.format("%02d", var2_5))
	arg0_5:GamingLogic()

	if arg0_5.gameTime <= 0 then
		arg0_5:onGameOver()
	end
end

function var0_0.initUI(arg0_6)
	arg0_6.bgTf = arg0_6:findTF("bg")
	arg0_6.clickMask = arg0_6:findTF("clickMask")
	arg0_6.gameUI = arg0_6:findTF("ui/gameUI")
	arg0_6.gameTop = arg0_6:findTF("top", arg0_6.gameUI)
	arg0_6.gameUIScore = arg0_6:findTF("score/text", arg0_6.gameTop)
	arg0_6.gameUITime = arg0_6:findTF("time/text", arg0_6.gameTop)
	arg0_6.gameUILeave = arg0_6:findTF("btnLeave", arg0_6.gameUI)

	setActive(arg0_6.gameTop, false)
	onButton(arg0_6, arg0_6.gameUILeave, function()
		arg0_6:checkGameExit()
	end, SFX_PANEL)

	arg0_6.gamingUI = arg0_6:findTF("gamingUI")
	arg0_6.gamingShow = arg0_6:findTF("show", arg0_6.gamingUI)
	arg0_6.gamingChoose = arg0_6:findTF("choose", arg0_6.gamingUI)
	arg0_6.gamingSettlement = arg0_6:findTF("settlement", arg0_6.gamingUI)

	setActive(arg0_6.gamingShow, true)
	setActive(arg0_6.gamingChoose, true)
	setActive(arg0_6.gamingSettlement, false)
	setActive(arg0_6.gamingUI, false)
	setText(arg0_6:findTF("dayList/Monday", arg0_6.gamingSettlement), i18n("dorm3d_nengdai_minigame_day1"))
	setText(arg0_6:findTF("dayList/Tuesday", arg0_6.gamingSettlement), i18n("dorm3d_nengdai_minigame_day2"))
	setText(arg0_6:findTF("dayList/Wednesday", arg0_6.gamingSettlement), i18n("dorm3d_nengdai_minigame_day3"))
	setText(arg0_6:findTF("dayList/Thursday", arg0_6.gamingSettlement), i18n("dorm3d_nengdai_minigame_day4"))
	setText(arg0_6:findTF("dayList/Friday", arg0_6.gamingSettlement), i18n("dorm3d_nengdai_minigame_day5"))
	setText(arg0_6:findTF("dayList/Saturday", arg0_6.gamingSettlement), i18n("dorm3d_nengdai_minigame_day6"))
	setText(arg0_6:findTF("dayList/Sunday", arg0_6.gamingSettlement), i18n("dorm3d_nengdai_minigame_day7"))
	setText(arg0_6:findTF("state1", arg0_6.gamingChoose), i18n("dorm3d_nengdai_minigame_remember"))
	setText(arg0_6:findTF("state2/text", arg0_6.gamingChoose), i18n("dorm3d_nengdai_minigame_choose"))

	for iter0_6 = 0, 8 do
		local var0_6 = arg0_6:findTF("scheduleList", arg0_6.gamingChoose):GetChild(iter0_6):GetChild(0)

		for iter1_6 = 0, 11 do
			setText(var0_6:GetChild(iter1_6):GetChild(0), var10_0[iter1_6 + 1])
		end
	end

	arg0_6.count = arg0_6:findTF("count")

	setActive(arg0_6.count, true)
	arg0_6.count:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_6:gameStart()
	end)
end

function var0_0.GamingLogic(arg0_9)
	if not arg0_9.hasDone then
		arg0_9.hasDone = true

		if arg0_9.showFlag then
			setActive(arg0_9:findTF("state1", arg0_9.gamingChoose), true)
			setActive(arg0_9:findTF("state2", arg0_9.gamingChoose), false)
			arg0_9:ShowSchedule(arg0_9:findTF("morningSchedule", arg0_9.gamingShow):GetChild(0), true, 1)
			arg0_9:ShowSchedule(arg0_9:findTF("noonSchedule", arg0_9.gamingShow):GetChild(0), true, 1)
			arg0_9:ShowSchedule(arg0_9:findTF("nightSchedule", arg0_9.gamingShow):GetChild(0), true, 1)
			arg0_9:SetScheduleFrame(arg0_9:findTF("morningSchedule", arg0_9.gamingShow):GetChild(0), "")
			arg0_9:SetScheduleFrame(arg0_9:findTF("noonSchedule", arg0_9.gamingShow):GetChild(0), "")
			arg0_9:SetScheduleFrame(arg0_9:findTF("nightSchedule", arg0_9.gamingShow):GetChild(0), "")
			setText(arg0_9:findTF("day", arg0_9.gamingShow), i18n("dorm3d_nengdai_minigame_day" .. arg0_9.round))

			for iter0_9 = 0, 6 do
				setActive(arg0_9:findTF("dayEng", arg0_9.gamingShow):GetChild(iter0_9), iter0_9 + 1 == arg0_9.round)
			end

			for iter1_9 = 0, 8 do
				arg0_9:SetScheduleFrame(arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter1_9):GetChild(0), "")
			end

			for iter2_9 = 0, 8 do
				arg0_9:ShowSchedule(arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter2_9):GetChild(0), false)
			end

			setActive(arg0_9:findTF("scoreAdd", arg0_9.gamingShow), false)
		elseif arg0_9.chooseFlag then
			setActive(arg0_9:findTF("state1", arg0_9.gamingChoose), false)
			setActive(arg0_9:findTF("state2", arg0_9.gamingChoose), true)
			arg0_9:ShowSchedule(arg0_9:findTF("morningSchedule", arg0_9.gamingShow):GetChild(0), true, 0, 0)
			arg0_9:ShowSchedule(arg0_9:findTF("noonSchedule", arg0_9.gamingShow):GetChild(0), true, 0, 0)
			arg0_9:ShowSchedule(arg0_9:findTF("nightSchedule", arg0_9.gamingShow):GetChild(0), true, 0, 0)

			local var0_9 = {}
			local var1_9 = {
				0,
				1,
				2,
				3,
				4,
				5,
				6,
				7,
				8
			}

			while #var0_9 < 3 do
				local var2_9 = math.random(#var1_9)

				table.insert(var0_9, table.remove(var1_9, var2_9))
			end

			local var3_9 = 1

			for iter3_9 = 0, 8 do
				if table.contains(var0_9, iter3_9) then
					arg0_9:ShowSchedule(arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter3_9):GetChild(0), true, 2, arg0_9.showScheduleList[3 * (arg0_9.round - 1) + var3_9])

					var3_9 = var3_9 + 1
				else
					arg0_9:ShowSchedule(arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter3_9):GetChild(0), true, 2)
				end

				onButton(arg0_9, arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter3_9), function()
					if not arg0_9:IsShowing(arg0_9:findTF("morningSchedule", arg0_9.gamingShow):GetChild(0)) then
						arg0_9:ShowSchedule(arg0_9:findTF("morningSchedule", arg0_9.gamingShow):GetChild(0), true, 3, arg0_9.chooseScheduleList[iter3_9 + 1])
						arg0_9:SetScheduleFrame(arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter3_9):GetChild(0), "morningChoose")
					elseif not arg0_9:IsShowing(arg0_9:findTF("noonSchedule", arg0_9.gamingShow):GetChild(0)) then
						arg0_9:ShowSchedule(arg0_9:findTF("noonSchedule", arg0_9.gamingShow):GetChild(0), true, 3, arg0_9.chooseScheduleList[iter3_9 + 1])
						arg0_9:SetScheduleFrame(arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter3_9):GetChild(0), "noonChoose")
					elseif not arg0_9:IsShowing(arg0_9:findTF("nightSchedule", arg0_9.gamingShow):GetChild(0)) then
						arg0_9:ShowSchedule(arg0_9:findTF("nightSchedule", arg0_9.gamingShow):GetChild(0), true, 3, arg0_9.chooseScheduleList[iter3_9 + 1])
						arg0_9:SetScheduleFrame(arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter3_9):GetChild(0), "nightChoose")
						arg0_9:ChangeMotion()
					end

					removeOnButton(arg0_9:findTF("scheduleList", arg0_9.gamingChoose):GetChild(iter3_9))
				end, SFX_PANEL)
			end
		elseif arg0_9.roundSettleFlag then
			setActive(arg0_9:findTF("state1", arg0_9.gamingChoose), false)
			setActive(arg0_9:findTF("state2", arg0_9.gamingChoose), false)
			arg0_9:ShowSchedule(arg0_9:findTF("morningSchedule", arg0_9.gamingShow):GetChild(0), true, 0, arg0_9.showScheduleList[3 * (arg0_9.round - 1) + 1])
			arg0_9:ShowSchedule(arg0_9:findTF("noonSchedule", arg0_9.gamingShow):GetChild(0), true, 0, arg0_9.showScheduleList[3 * (arg0_9.round - 1) + 2])
			arg0_9:ShowSchedule(arg0_9:findTF("nightSchedule", arg0_9.gamingShow):GetChild(0), true, 0, arg0_9.showScheduleList[3 * (arg0_9.round - 1) + 3])

			local var4_9 = 0

			for iter4_9 = 1, 3 do
				local var5_9 = "wrong"

				if arg0_9.showScheduleList[3 * (arg0_9.round - 1) + iter4_9] == arg0_9.playerChoosedScheduleList[3 * (arg0_9.round - 1) + iter4_9] then
					var4_9 = var4_9 + 100
					var5_9 = "right"
				end

				if iter4_9 == 1 then
					arg0_9:SetScheduleFrame(arg0_9:findTF("morningSchedule", arg0_9.gamingShow):GetChild(0), var5_9)
				elseif iter4_9 == 2 then
					arg0_9:SetScheduleFrame(arg0_9:findTF("noonSchedule", arg0_9.gamingShow):GetChild(0), var5_9)
				elseif iter4_9 == 3 then
					arg0_9:SetScheduleFrame(arg0_9:findTF("nightSchedule", arg0_9.gamingShow):GetChild(0), var5_9)
				end
			end

			arg0_9.scoreNum = arg0_9.scoreNum + var4_9

			setText(arg0_9.gameUIScore, arg0_9.scoreNum)
			setActive(arg0_9:findTF("scoreAdd", arg0_9.gamingShow), true)

			for iter5_9 = 0, 3 do
				setActive(arg0_9:findTF("scoreAdd", arg0_9.gamingShow):GetChild(iter5_9), var4_9 == 100 * iter5_9)
			end

			arg0_9:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
				operationCode = "ROUND_RESULT",
				success = var4_9 >= 200,
				miniGameId = var1_0
			})
		end
	end

	if arg0_9.showFlag then
		setSlider(arg0_9:findTF("timeSlider", arg0_9.gamingChoose), 0, var3_0, var3_0 - arg0_9.showTime)
	end

	if arg0_9.chooseFlag then
		setText(arg0_9:findTF("state2/chooseTime", arg0_9.gamingChoose), math.ceil(arg0_9.chooseTime))
		setSlider(arg0_9:findTF("timeSlider", arg0_9.gamingChoose), 0, var4_0, arg0_9.chooseTime)
	end
end

function var0_0.ChangeMotion(arg0_11)
	if arg0_11.showFlag then
		arg0_11.hasDone = false
		arg0_11.showFlag = false
		arg0_11.chooseFlag = true
		arg0_11.roundSettleFlag = false
		arg0_11.chooseTime = 10

		table.insertto(arg0_11.RandomPool, var7_0)
	elseif arg0_11.chooseFlag then
		arg0_11.hasDone = false
		arg0_11.showFlag = false
		arg0_11.chooseFlag = false
		arg0_11.roundSettleFlag = true
	elseif arg0_11.roundSettleFlag then
		if arg0_11.round == 7 then
			arg0_11:onGameOver()
		else
			arg0_11.hasDone = false
			arg0_11.showFlag = true
			arg0_11.chooseFlag = false
			arg0_11.roundSettleFlag = false
			arg0_11.round = arg0_11.round + 1
			arg0_11.chooseScheduleList = {}
			arg0_11.RandomPool = Clone(var7_0)
		end
	end
end

function var0_0.ShowSchedule(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	if arg2_12 then
		if not arg4_12 then
			local var0_12 = math.random(#arg0_12.RandomPool)

			arg4_12 = arg0_12.RandomPool[var0_12]

			table.remove(arg0_12.RandomPool, var0_12)
		end

		if arg3_12 == 1 then
			table.insert(arg0_12.showScheduleList, arg4_12)
		end

		if arg3_12 == 2 then
			table.insert(arg0_12.chooseScheduleList, arg4_12)
		end

		if arg3_12 == 3 then
			table.insert(arg0_12.playerChoosedScheduleList, arg4_12)
		end

		for iter0_12 = 0, 11 do
			setActive(arg1_12:GetChild(iter0_12), iter0_12 == arg4_12 - 1)
		end

		setActive(arg1_12:GetChild(12), false)

		if arg4_12 == 0 then
			setActive(arg1_12:GetChild(12), true)
		end
	else
		setActive(arg1_12:GetChild(12), true)
	end
end

function var0_0.SetScheduleFrame(arg0_13, arg1_13, arg2_13)
	for iter0_13 = 13, arg1_13.childCount - 1 do
		setActive(arg1_13:GetChild(iter0_13), arg1_13:GetChild(iter0_13).name == arg2_13)
	end
end

function var0_0.IsShowing(arg0_14, arg1_14)
	return not isActive(arg1_14:GetChild(12))
end

function var0_0.readyStart(arg0_15)
	arg0_15.scoreNum = 0
	arg0_15.gameTime = var2_0
	arg0_15.gameStepTime = 0
	arg0_15.showTime = 0
	arg0_15.roundSettleTime = 0
	arg0_15.hasDone = false
	arg0_15.showFlag = true
	arg0_15.chooseFlag = false
	arg0_15.roundSettleFlag = false
	arg0_15.showScheduleList = {}
	arg0_15.chooseScheduleList = {}
	arg0_15.playerChoosedScheduleList = {}
	arg0_15.RandomPool = Clone(var7_0)
	arg0_15.round = 1

	arg0_15.count:GetComponent(typeof(Animator)):Play("count")
end

function var0_0.gameStart(arg0_16)
	arg0_16.gameStartFlag = true

	setActive(arg0_16.count, false)
	setActive(arg0_16.gameTop, true)
	setActive(arg0_16.gamingUI, true)
	setText(arg0_16.gameUIScore, arg0_16.scoreNum)
	arg0_16:timerStart()
end

function var0_0.timerStart(arg0_17)
	if not arg0_17.timer.running then
		arg0_17.realTimeStartUp = Time.realtimeSinceStartup

		arg0_17.timer:Start()
	end
end

function var0_0.timerStop(arg0_18)
	if arg0_18.timer.running then
		arg0_18.timer:Stop()
	end
end

function var0_0.pauseGame(arg0_19)
	arg0_19.gameStop = true

	arg0_19:timerStop()
end

function var0_0.resumeGame(arg0_20)
	arg0_20.gameStop = false

	arg0_20:timerStart()
end

function var0_0.onGameOver(arg0_21)
	arg0_21:timerStop()
	setActive(arg0_21.clickMask, true)
	setActive(arg0_21.gameTop, false)
	LeanTween.delayedCall(go(arg0_21._tf), 0.1, System.Action(function()
		arg0_21.gameStartFlag = false

		setActive(arg0_21.clickMask, false)
		arg0_21:GameSettlement()
		arg0_21:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
			operationCode = "GAME_RESULT",
			score = arg0_21.scoreNum,
			miniGameId = var1_0
		})
	end))
end

function var0_0.GameSettlement(arg0_23)
	setActive(arg0_23.gamingShow, false)
	setActive(arg0_23.gamingChoose, false)
	setActive(arg0_23.gamingSettlement, true)

	for iter0_23 = 0, 20 do
		arg0_23:ShowSchedule(arg0_23:findTF("scheduleResultList", arg0_23.gamingSettlement):GetChild(iter0_23):GetChild(0), true, 0, arg0_23.playerChoosedScheduleList[iter0_23 + 1])
	end

	arg0_23.scoreNum = arg0_23.scoreNum + 10 * math.ceil(arg0_23.gameTime)

	setText(arg0_23:findTF("currentScore/Text", arg0_23.gamingSettlement), arg0_23.scoreNum)

	local var0_23 = getProxy(PlayerProxy):getPlayerId()
	local var1_23 = PlayerPrefs.GetInt("mg_score_" .. tostring(var0_23) .. "_" .. var1_0) or 0

	setActive(arg0_23:findTF("currentScore/new", arg0_23.gamingSettlement), var1_23 < arg0_23.scoreNum)

	if var1_23 < arg0_23.scoreNum then
		var1_23 = arg0_23.scoreNum

		PlayerPrefs.SetInt("mg_score_" .. tostring(var0_23) .. "_" .. var1_0, var1_23)
	end

	setText(arg0_23:findTF("highestScore/Text", arg0_23.gamingSettlement), var1_23)

	local var2_23 = math.ceil(arg0_23.gameTime)
	local var3_23 = math.floor(var2_23 / 60)
	local var4_23 = var2_23 % 60

	setText(arg0_23:findTF("remainingTime/Text", arg0_23.gamingSettlement), string.format("%02d", var3_23) .. ":" .. string.format("%02d", var4_23))
	setText(arg0_23:findTF("result/Text", arg0_23.gamingSettlement), arg0_23:GetEvaluation())
end

function var0_0.GetEvaluation(arg0_24)
	local var0_24 = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
	local var1_24 = {
		study = 0,
		sport = 0,
		housework = 0,
		entertainment = 0
	}

	for iter0_24, iter1_24 in ipairs(arg0_24.playerChoosedScheduleList) do
		if iter1_24 ~= 0 then
			var0_24[iter1_24] = var0_24[iter1_24] + 1

			local var2_24 = var9_0[iter1_24]

			var1_24[var2_24] = var1_24[var2_24] + 1
		end
	end

	for iter2_24, iter3_24 in ipairs(var0_24) do
		if iter3_24 > 16 then
			return var10_0[iter2_24] .. i18n("dorm3d_nengdai_minigame_evaluate2")
		elseif iter3_24 > 11 then
			return var10_0[iter2_24] .. i18n("dorm3d_nengdai_minigame_evaluate1")
		end
	end

	for iter4_24, iter5_24 in pairs(var1_24) do
		if iter5_24 > 20 then
			return i18n("dorm3d_nengdai_minigame_evaluate4") .. var11_0[iter4_24]
		elseif iter5_24 > 11 then
			return i18n("dorm3d_nengdai_minigame_evaluate3") .. var11_0[iter4_24]
		end
	end

	return i18n("dorm3d_nengdai_minigame_evaluate5")
end

function var0_0.checkGameExit(arg0_25)
	if not arg0_25.gameStartFlag then
		arg0_25:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
			operationCode = "GAME_CLOSE",
			doTrack = true,
			miniGameId = var1_0
		})
		arg0_25:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_25.gameStop then
			return
		end

		arg0_25:pauseGame()

		if arg0_25.contextData.isDorm3d then
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
				contentText = i18n("mini_game_leave"),
				onConfirm = function()
					arg0_25:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
						operationCode = "GAME_CLOSE",
						doTrack = false,
						miniGameId = var1_0
					})
					arg0_25:emit(var0_0.ON_BACK_PRESSED)
				end,
				onClose = function()
					arg0_25:resumeGame()
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("mini_game_leave"),
				onYes = function()
					arg0_25:emit(Dorm3dMiniGameMediator.GAME_OPERATION, {
						operationCode = "GAME_CLOSE",
						doTrack = false,
						miniGameId = var1_0
					})
					arg0_25:emit(var0_0.ON_BACK_PRESSED)
				end,
				onNo = function()
					arg0_25:resumeGame()
				end
			})
		end
	end
end

function var0_0.getMiniGameData(arg0_30)
	if not arg0_30._mgData then
		arg0_30._mgData = getProxy(MiniGameProxy):GetMiniGameData(var1_0)
	end

	return arg0_30._mgData
end

function var0_0.onBackPressed(arg0_31)
	arg0_31:checkGameExit()
end

function var0_0.willExit(arg0_32)
	if arg0_32.timer and arg0_32.timer.running then
		arg0_32.timer:Stop()
	end

	arg0_32.timer = nil
end

return var0_0
