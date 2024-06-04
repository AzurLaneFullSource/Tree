local var0 = class("GuessForkGameView", import("..BaseMiniGameView"))
local var1 = {
	100,
	50
}
local var2 = {
	10
}
local var3 = {
	20
}
local var4 = {
	3,
	3,
	3,
	4,
	4,
	4,
	5,
	5,
	5,
	6,
	6,
	6,
	7,
	7,
	7,
	8,
	8,
	8,
	8,
	9,
	9,
	9,
	9,
	9,
	10,
	10,
	10,
	10,
	10,
	10,
	11,
	11,
	11,
	11,
	11,
	12
}
local var5 = {
	1000,
	200
}
local var6 = 10000
local var7 = 2
local var8 = 2
local var9 = "event:/ui/ddldaoshu2"
local var10 = "event:/ui/taosheng"
local var11 = "event:/ui/zhengque"
local var12 = "event:/ui/shibai"
local var13 = "backyard"
local var14 = {
	"Cup_B",
	"Cup_G",
	"Cup_P",
	"Cup_R",
	"Cup_Y"
}
local var15 = 3
local var16 = 0.5
local var17 = "Thinking_Loop"
local var18 = {
	"Select_L",
	"Select_M",
	"Select_R"
}
local var19 = {
	"Correct_L",
	"Correct_M",
	"Correct_R"
}
local var20 = {
	"Incorrect_L",
	"Incorrect_M",
	"Incorrect_R"
}
local var21 = "Manjuu_Correct"
local var22 = {
	"Ayanami",
	"Cheshire",
	"Eldridge",
	"Formidable",
	"Javelin",
	"Laffey",
	"LeMalin",
	"Merkuria",
	"PingHai",
	"Roon",
	"Saratoga",
	"Shiratsuyu",
	"Yukikaze",
	"Z23"
}

function var0.getUIName(arg0)
	return "GuessForkGameUI"
end

function var0.getBGM(arg0)
	return var13
end

function var0.init(arg0)
	arg0.countUI = arg0:findTF("count_ui")
	arg0.countAnimator = arg0:findTF("count_bg/count", arg0.countUI):GetComponent(typeof(Animator))
	arg0.countDft = arg0:findTF("count_bg/count", arg0.countUI):GetComponent(typeof(DftAniEvent))

	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:startGame()
	end)

	arg0.pauseUI = arg0:findTF("pause_ui")
	arg0.resuemBtn = arg0:findTF("box/sure_btn", arg0.pauseUI)

	setText(arg0:findTF("box/content", arg0.pauseUI), i18n("idolmaster_game_tip1"))

	arg0.exitUI = arg0:findTF("exit_ui")
	arg0.exitSureBtn = arg0:findTF("box/sure_btn", arg0.exitUI)
	arg0.exitCancelBtn = arg0:findTF("box/cancel_btn", arg0.exitUI)

	setText(arg0:findTF("box/content", arg0.exitUI), i18n("idolmaster_game_tip2"))

	arg0.endUI = arg0:findTF("end_ui")
	arg0.endSureBtn = arg0:findTF("box/sure_btn", arg0.endUI)

	setText(arg0:findTF("box/cur_score", arg0.endUI), i18n("idolmaster_game_tip3"))

	arg0.endScoreTxt = arg0:findTF("box/cur_score/score", arg0.endUI)
	arg0.newTag = arg0:findTF("new", arg0.endScoreTxt)

	setText(arg0:findTF("box/highest_score", arg0.endUI), i18n("idolmaster_game_tip4"))

	arg0.highestScoreTxt = arg0:findTF("box/highest_score/score", arg0.endUI)
	arg0.gameUI = arg0:findTF("game_ui")
	arg0.returnBtn = arg0:findTF("top/return_btn", arg0.gameUI)
	arg0.pauseBtn = arg0:findTF("top/pause_btn", arg0.gameUI)
	arg0.roundTxt = arg0:findTF("top/title/round/num", arg0.gameUI)
	arg0.roundNum = 0
	arg0.curScoreTxt = arg0:findTF("top/title/score_title/score", arg0.gameUI)
	arg0.curScore = 0

	setText(arg0.curScoreTxt, arg0.curScore)

	arg0.curTimeTxt = arg0:findTF("top/time_bg/time", arg0.gameUI)
	arg0.curTime = 0

	setText(arg0:findTF("top/title/score_title", arg0.gameUI), i18n("idolmaster_game_tip5"))

	arg0.correctBar = arg0:findTF("correct_bar", arg0.gameUI)
	arg0.failBar = arg0:findTF("fail_bar", arg0.gameUI)
	arg0.manjuu = arg0:findTF("play/manjuu", arg0.gameUI)
	arg0.manjuuAnimator = arg0.manjuu:GetComponent(typeof(Animator))
	arg0.manjuuDft = arg0.manjuu:GetComponent(typeof(DftAniEvent))
	arg0.result = arg0:findTF("result", arg0.gameUI)
	arg0.resultAnimator = arg0.result:GetComponent(typeof(Animator))
	arg0.resultDft = arg0.result:GetComponent(typeof(DftAniEvent))
	arg0.scoreAni = arg0:findTF("score", arg0.gameUI)
	arg0.cupContainer = arg0:findTF("cup_container", arg0.gameUI)
	arg0.fork = arg0:findTF("fork", arg0.gameUI)
	arg0.isGuessTime = false
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.pauseBtn, function()
		setActive(arg0.pauseUI, true)
		arg0:pauseGame()
	end, SFX_PANEL)
	onButton(arg0, arg0.resuemBtn, function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_PANEL)
	onButton(arg0, arg0.returnBtn, function()
		setActive(arg0.exitUI, true)
		arg0:pauseGame()
	end, SFX_PANEL)
	onButton(arg0, arg0.exitSureBtn, function()
		setActive(arg0.exitUI, false)
		arg0:enterResultUI()
	end, SFX_PANEL)
	onButton(arg0, arg0.exitCancelBtn, function()
		setActive(arg0.exitUI, false)
		arg0:resumeGame()
	end, SFX_PANEL)
	onButton(arg0, arg0.endSureBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	eachChild(arg0.cupContainer, function(arg0)
		onButton(arg0, arg0, function()
			if not arg0.isGuessTime then
				return
			end

			setActive(arg0:findTF("select", arg0), true)

			arg0.isGuessTime = false

			local var0 = string.gsub(arg0.name, "cup_", "")

			arg0.selectIndex = tonumber(var0)

			arg0:endRound(arg0.selectIndex == arg0.forkIndex)
		end, SFX_PANEL)
	end)
	arg0:initGameData()
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("countDown")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var9)
end

function var0.initGameData(arg0)
	local var0 = math.random(#var14)
	local var1 = var14[var0]

	eachChild(arg0.cupContainer, function(arg0)
		GetSpriteFromAtlasAsync("ui/minigameui/guessforkgameui", var1, function(arg0)
			setImageSprite(arg0:findTF("front", arg0), arg0, true)
		end)
	end)

	arg0.forkIndex = math.random(var15)
	arg0.selectIndex = nil
	arg0.roundNum = arg0.roundNum + 1

	setText(arg0.roundTxt, arg0.roundNum)

	arg0.curTime = var3[arg0.roundNum] or var3[#var3]

	setText(arg0.curTimeTxt, arg0.curTime)
	setActive(arg0.result, false)
end

function var0.startGame(arg0)
	arg0.manjuuAnimator:Play(var17)

	local var0 = var4[arg0.roundNum] or var4[#var4]

	arg0:playForkAni(function()
		arg0:startSwap(var0)
	end)

	arg0.gameStartFlag = true
end

function var0.playForkAni(arg0, arg1)
	local var0 = arg0:findTF("cup_" .. arg0.forkIndex, arg0.cupContainer)

	setParent(arg0.fork, arg0:findTF("fork_node", var0), false)
	setLocalScale(arg0.fork, Vector3.one)
	setLocalPosition(arg0.fork, Vector3(0, 50, 0))
	setActive(arg0.fork, true)
	arg0:managedTween(LeanTween.delayedCall, function()
		arg0:managedTween(LeanTween.moveY, function()
			setActive(arg0.fork, false)

			if arg1 then
				arg1()
			end
		end, arg0.fork, -20, var16):setEase(LeanTweenType.linear)
	end, 0.5, nil)
end

function var0.startSwap(arg0, arg1)
	if arg1 < 1 then
		arg0.isGuessTime = true

		arg0:startTimer()

		return
	end

	local var0 = {
		1,
		2,
		3
	}
	local var1 = math.random(#var0)

	table.remove(var0, var1)

	local var2 = arg0:findTF("cup_" .. var0[1], arg0.cupContainer)
	local var3 = arg0:findTF("cup_" .. var0[2], arg0.cupContainer)

	arg0:swapCup(var2, var3, function()
		arg0:startSwap(arg1 - 1)
	end)
end

function var0.swapCup(arg0, arg1, arg2, arg3)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var10)

	local var0 = var5[1] + (arg0.roundNum - 1) * var5[2]
	local var1 = var0 < var6 and var0 or var6
	local var2 = arg2.anchoredPosition
	local var3 = arg1.anchoredPosition
	local var4 = math.abs(var2.x - var3.x) / var1

	arg0:managedTween(LeanTween.moveX, nil, arg1, var2.x, var4):setEase(LeanTweenType.linear)
	arg0:managedTween(LeanTween.moveX, function()
		if arg3 then
			arg3()
		end
	end, arg2, var3.x, var4):setEase(LeanTweenType.linear)
end

function var0.startTimer(arg0)
	local var0 = arg0.curTime

	arg0.timer = Timer.New(function()
		arg0.curTime = arg0.curTime - 1

		if arg0.curTime <= 0 then
			arg0:endRound(false)
		end

		setText(arg0.curTimeTxt, arg0.curTime)
	end, 1, -1)

	arg0.timer:Start()
end

function var0.stopTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.pauseGame(arg0)
	arg0:pauseManagedTween()

	if arg0.timer then
		arg0.timer:Pause()
	end

	arg0.manjuuAnimator.speed = 0
	arg0.resultAnimator.speed = 0
end

function var0.resumeGame(arg0)
	arg0:resumeManagedTween()

	if arg0.timer then
		arg0.timer:Resume()
	end

	arg0.manjuuAnimator.speed = 1
	arg0.resultAnimator.speed = 1
end

function var0.endRound(arg0, arg1)
	arg0:stopTimer()

	if arg0.selectIndex then
		arg0:playManjuuAni(arg1)
	else
		arg0:playTimeOutAni()
		arg0:endGame()
	end
end

function var0.playManjuuAni(arg0, arg1)
	local var0 = arg0:findTF("cup_" .. arg0.selectIndex, arg0.cupContainer)
	local var1 = (var0.anchoredPosition.x + 480) / 480 + 1

	arg0.manjuuAnimator:Play(var18[var1])
	arg0.manjuuDft:SetEndEvent(function()
		arg0.manjuuDft:SetEndEvent(nil)

		local var0 = arg1 and var19[var1] or var20[var1]

		setActive(arg0:findTF("select", var0), false)
		arg0.manjuuAnimator:Play(var0)
		arg0:playResultAni(arg1)
	end)
end

function var0.playResultAni(arg0, arg1)
	local var0 = arg0:findTF("cup_" .. arg0.selectIndex, arg0.cupContainer)

	setParent(arg0.result, arg0:findTF("result_node", var0), false)
	setLocalScale(arg0.result, Vector3.one)
	setLocalPosition(arg0.result, Vector3.zero)
	setActive(arg0.result, true)

	if arg1 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var11)
		arg0.resultAnimator:Play(var21)
		arg0.resultDft:SetEndEvent(function()
			arg0.resultDft:SetEndEvent(nil)
			arg0:showCorrectBar()
		end)
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var12)

		local var1 = var22[math.random(#var22)]

		arg0.resultAnimator:Play(var1)
		arg0.resultDft:SetEndEvent(function()
			arg0.resultDft:SetEndEvent(nil)
			arg0:endGame()
		end)
	end
end

function var0.showCorrectBar(arg0)
	setActive(arg0.correctBar, true)

	local var0 = var1[1] + (arg0.roundNum - 1) * var1[2]

	arg0.curScore = arg0.curScore + var0

	setText(arg0.curScoreTxt, arg0.curScore)
	setLocalPosition(arg0.scoreAni, Vector3(0, 250, 0))
	setText(arg0.scoreAni, "+" .. var0)
	setActive(arg0.scoreAni, true)
	LeanTween.moveY(arg0.scoreAni, 300, 1):setOnComplete(System.Action(function()
		setActive(arg0.scoreAni, false)
	end))

	local var1 = 0.5
	local var2 = var2[arg0.roundNum] or var2[#var2]
	local var3 = arg0.curScore + var2 * arg0.curTime

	LeanTween.value(go(arg0.curScoreTxt), arg0.curScore, var3, var1):setOnUpdate(System.Action_float(function(arg0)
		setText(arg0.curScoreTxt, math.ceil(arg0))
	end)):setOnComplete(System.Action(function()
		arg0.curScore = var3

		setText(arg0.curScoreTxt, arg0.curScore)
	end))
	LeanTween.value(go(arg0.curTimeTxt), arg0.curTime, 0, var1):setOnUpdate(System.Action_float(function(arg0)
		setText(arg0.curTimeTxt, math.ceil(arg0))
	end)):setOnComplete(System.Action(function()
		arg0.curScore = var3

		setText(arg0.curTimeTxt, 0)
	end))
	onButton(arg0, arg0.correctBar, function()
		setActive(arg0.correctBar, false)
		setActive(arg0.scoreAni, false)
		arg0:initGameData()
		arg0:startGame()
	end, SFX_PANEL)
	arg0:managedTween(LeanTween.delayedCall, function()
		if isActive(arg0.correctBar) then
			triggerButton(arg0.correctBar)
		end
	end, var7, nil)
end

function var0.playTimeOutAni(arg0)
	local var0 = arg0:findTF("cup_" .. arg0.forkIndex, arg0.cupContainer)

	setParent(arg0.result, arg0:findTF("result_node", var0), false)
	setLocalScale(arg0.result, Vector3.one)
	setLocalPosition(arg0.result, Vector3.zero)
	setActive(arg0.result, true)
	arg0.resultAnimator:Play(var21)
	arg0.resultDft:SetEndEvent(function()
		arg0.resultDft:SetEndEvent(nil)
	end)
end

function var0.endGame(arg0)
	setActive(arg0.failBar, true)
	onButton(arg0, arg0.failBar, function()
		setActive(arg0.failBar, false)
		arg0:enterResultUI()
	end, SFX_PANEL)
	arg0:managedTween(LeanTween.delayedCall, function()
		if isActive(arg0.failBar) then
			triggerButton(arg0.failBar)
		end
	end, var7, nil)
end

function var0.enterResultUI(arg0)
	arg0.gameStartFlag = false

	setActive(arg0.endUI, true)
	setText(arg0.endScoreTxt, arg0.curScore)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = var0 and #var0 > 0 and var0[1] or 0

	setActive(arg0.newTag, var1 < arg0.curScore)

	if var1 <= arg0.curScore then
		var1 = arg0.curScore

		arg0:StoreDataToServer({
			var1
		})
	end

	setText(arg0.highestScoreTxt, var1)

	if arg0:GetMGHubData().count > 0 then
		arg0:SendSuccess(0)
	end
end

function var0.OnGetAwardDone(arg0, arg1)
	if arg1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0 = arg0:GetMGHubData()

		if var0.ultimate == 0 and var0.usedtime >= var0:getConfig("reward_need") then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	end
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		setActive(arg0.exitUI, true)
		arg0:pauseGame()
	end
end

return var0
