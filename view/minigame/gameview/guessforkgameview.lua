local var0_0 = class("GuessForkGameView", import("..BaseMiniGameView"))
local var1_0 = {
	100,
	50
}
local var2_0 = {
	10
}
local var3_0 = {
	20
}
local var4_0 = {
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
local var5_0 = {
	1000,
	200
}
local var6_0 = 10000
local var7_0 = 2
local var8_0 = 2
local var9_0 = "event:/ui/ddldaoshu2"
local var10_0 = "event:/ui/taosheng"
local var11_0 = "event:/ui/zhengque"
local var12_0 = "event:/ui/shibai"
local var13_0 = "backyard"
local var14_0 = {
	"Cup_B",
	"Cup_G",
	"Cup_P",
	"Cup_R",
	"Cup_Y"
}
local var15_0 = 3
local var16_0 = 0.5
local var17_0 = "Thinking_Loop"
local var18_0 = {
	"Select_L",
	"Select_M",
	"Select_R"
}
local var19_0 = {
	"Correct_L",
	"Correct_M",
	"Correct_R"
}
local var20_0 = {
	"Incorrect_L",
	"Incorrect_M",
	"Incorrect_R"
}
local var21_0 = "Manjuu_Correct"
local var22_0 = {
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

function var0_0.getUIName(arg0_1)
	return "GuessForkGameUI"
end

function var0_0.getBGM(arg0_2)
	return var13_0
end

function var0_0.init(arg0_3)
	arg0_3.countUI = arg0_3:findTF("count_ui")
	arg0_3.countAnimator = arg0_3:findTF("count_bg/count", arg0_3.countUI):GetComponent(typeof(Animator))
	arg0_3.countDft = arg0_3:findTF("count_bg/count", arg0_3.countUI):GetComponent(typeof(DftAniEvent))

	arg0_3.countDft:SetEndEvent(function()
		setActive(arg0_3.countUI, false)
		arg0_3:startGame()
	end)

	arg0_3.pauseUI = arg0_3:findTF("pause_ui")
	arg0_3.resuemBtn = arg0_3:findTF("box/sure_btn", arg0_3.pauseUI)

	setText(arg0_3:findTF("box/content", arg0_3.pauseUI), i18n("idolmaster_game_tip1"))

	arg0_3.exitUI = arg0_3:findTF("exit_ui")
	arg0_3.exitSureBtn = arg0_3:findTF("box/sure_btn", arg0_3.exitUI)
	arg0_3.exitCancelBtn = arg0_3:findTF("box/cancel_btn", arg0_3.exitUI)

	setText(arg0_3:findTF("box/content", arg0_3.exitUI), i18n("idolmaster_game_tip2"))

	arg0_3.endUI = arg0_3:findTF("end_ui")
	arg0_3.endSureBtn = arg0_3:findTF("box/sure_btn", arg0_3.endUI)

	setText(arg0_3:findTF("box/cur_score", arg0_3.endUI), i18n("idolmaster_game_tip3"))

	arg0_3.endScoreTxt = arg0_3:findTF("box/cur_score/score", arg0_3.endUI)
	arg0_3.newTag = arg0_3:findTF("new", arg0_3.endScoreTxt)

	setText(arg0_3:findTF("box/highest_score", arg0_3.endUI), i18n("idolmaster_game_tip4"))

	arg0_3.highestScoreTxt = arg0_3:findTF("box/highest_score/score", arg0_3.endUI)
	arg0_3.gameUI = arg0_3:findTF("game_ui")
	arg0_3.returnBtn = arg0_3:findTF("top/return_btn", arg0_3.gameUI)
	arg0_3.pauseBtn = arg0_3:findTF("top/pause_btn", arg0_3.gameUI)
	arg0_3.roundTxt = arg0_3:findTF("top/title/round/num", arg0_3.gameUI)
	arg0_3.roundNum = 0
	arg0_3.curScoreTxt = arg0_3:findTF("top/title/score_title/score", arg0_3.gameUI)
	arg0_3.curScore = 0

	setText(arg0_3.curScoreTxt, arg0_3.curScore)

	arg0_3.curTimeTxt = arg0_3:findTF("top/time_bg/time", arg0_3.gameUI)
	arg0_3.curTime = 0

	setText(arg0_3:findTF("top/title/score_title", arg0_3.gameUI), i18n("idolmaster_game_tip5"))

	arg0_3.correctBar = arg0_3:findTF("correct_bar", arg0_3.gameUI)
	arg0_3.failBar = arg0_3:findTF("fail_bar", arg0_3.gameUI)
	arg0_3.manjuu = arg0_3:findTF("play/manjuu", arg0_3.gameUI)
	arg0_3.manjuuAnimator = arg0_3.manjuu:GetComponent(typeof(Animator))
	arg0_3.manjuuDft = arg0_3.manjuu:GetComponent(typeof(DftAniEvent))
	arg0_3.result = arg0_3:findTF("result", arg0_3.gameUI)
	arg0_3.resultAnimator = arg0_3.result:GetComponent(typeof(Animator))
	arg0_3.resultDft = arg0_3.result:GetComponent(typeof(DftAniEvent))
	arg0_3.scoreAni = arg0_3:findTF("score", arg0_3.gameUI)
	arg0_3.cupContainer = arg0_3:findTF("cup_container", arg0_3.gameUI)
	arg0_3.fork = arg0_3:findTF("fork", arg0_3.gameUI)
	arg0_3.isGuessTime = false
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.pauseBtn, function()
		setActive(arg0_5.pauseUI, true)
		arg0_5:pauseGame()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.resuemBtn, function()
		setActive(arg0_5.pauseUI, false)
		arg0_5:resumeGame()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.returnBtn, function()
		setActive(arg0_5.exitUI, true)
		arg0_5:pauseGame()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.exitSureBtn, function()
		setActive(arg0_5.exitUI, false)
		arg0_5:enterResultUI()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.exitCancelBtn, function()
		setActive(arg0_5.exitUI, false)
		arg0_5:resumeGame()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.endSureBtn, function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	eachChild(arg0_5.cupContainer, function(arg0_12)
		onButton(arg0_5, arg0_12, function()
			if not arg0_5.isGuessTime then
				return
			end

			setActive(arg0_5:findTF("select", arg0_12), true)

			arg0_5.isGuessTime = false

			local var0_13 = string.gsub(arg0_12.name, "cup_", "")

			arg0_5.selectIndex = tonumber(var0_13)

			arg0_5:endRound(arg0_5.selectIndex == arg0_5.forkIndex)
		end, SFX_PANEL)
	end)
	arg0_5:initGameData()
	setActive(arg0_5.countUI, true)
	arg0_5.countAnimator:Play("countDown")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var9_0)
end

function var0_0.initGameData(arg0_14)
	local var0_14 = math.random(#var14_0)
	local var1_14 = var14_0[var0_14]

	eachChild(arg0_14.cupContainer, function(arg0_15)
		GetSpriteFromAtlasAsync("ui/minigameui/guessforkgameui", var1_14, function(arg0_16)
			setImageSprite(arg0_14:findTF("front", arg0_15), arg0_16, true)
		end)
	end)

	arg0_14.forkIndex = math.random(var15_0)
	arg0_14.selectIndex = nil
	arg0_14.roundNum = arg0_14.roundNum + 1

	setText(arg0_14.roundTxt, arg0_14.roundNum)

	arg0_14.curTime = var3_0[arg0_14.roundNum] or var3_0[#var3_0]

	setText(arg0_14.curTimeTxt, arg0_14.curTime)
	setActive(arg0_14.result, false)
end

function var0_0.startGame(arg0_17)
	arg0_17.manjuuAnimator:Play(var17_0)

	local var0_17 = var4_0[arg0_17.roundNum] or var4_0[#var4_0]

	arg0_17:playForkAni(function()
		arg0_17:startSwap(var0_17)
	end)

	arg0_17.gameStartFlag = true
end

function var0_0.playForkAni(arg0_19, arg1_19)
	local var0_19 = arg0_19:findTF("cup_" .. arg0_19.forkIndex, arg0_19.cupContainer)

	setParent(arg0_19.fork, arg0_19:findTF("fork_node", var0_19), false)
	setLocalScale(arg0_19.fork, Vector3.one)
	setLocalPosition(arg0_19.fork, Vector3(0, 50, 0))
	setActive(arg0_19.fork, true)
	arg0_19:managedTween(LeanTween.delayedCall, function()
		arg0_19:managedTween(LeanTween.moveY, function()
			setActive(arg0_19.fork, false)

			if arg1_19 then
				arg1_19()
			end
		end, arg0_19.fork, -20, var16_0):setEase(LeanTweenType.linear)
	end, 0.5, nil)
end

function var0_0.startSwap(arg0_22, arg1_22)
	if arg1_22 < 1 then
		arg0_22.isGuessTime = true

		arg0_22:startTimer()

		return
	end

	local var0_22 = {
		1,
		2,
		3
	}
	local var1_22 = math.random(#var0_22)

	table.remove(var0_22, var1_22)

	local var2_22 = arg0_22:findTF("cup_" .. var0_22[1], arg0_22.cupContainer)
	local var3_22 = arg0_22:findTF("cup_" .. var0_22[2], arg0_22.cupContainer)

	arg0_22:swapCup(var2_22, var3_22, function()
		arg0_22:startSwap(arg1_22 - 1)
	end)
end

function var0_0.swapCup(arg0_24, arg1_24, arg2_24, arg3_24)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var10_0)

	local var0_24 = var5_0[1] + (arg0_24.roundNum - 1) * var5_0[2]
	local var1_24 = var0_24 < var6_0 and var0_24 or var6_0
	local var2_24 = arg2_24.anchoredPosition
	local var3_24 = arg1_24.anchoredPosition
	local var4_24 = math.abs(var2_24.x - var3_24.x) / var1_24

	arg0_24:managedTween(LeanTween.moveX, nil, arg1_24, var2_24.x, var4_24):setEase(LeanTweenType.linear)
	arg0_24:managedTween(LeanTween.moveX, function()
		if arg3_24 then
			arg3_24()
		end
	end, arg2_24, var3_24.x, var4_24):setEase(LeanTweenType.linear)
end

function var0_0.startTimer(arg0_26)
	local var0_26 = arg0_26.curTime

	arg0_26.timer = Timer.New(function()
		arg0_26.curTime = arg0_26.curTime - 1

		if arg0_26.curTime <= 0 then
			arg0_26:endRound(false)
		end

		setText(arg0_26.curTimeTxt, arg0_26.curTime)
	end, 1, -1)

	arg0_26.timer:Start()
end

function var0_0.stopTimer(arg0_28)
	if arg0_28.timer then
		arg0_28.timer:Stop()

		arg0_28.timer = nil
	end
end

function var0_0.pauseGame(arg0_29)
	arg0_29:pauseManagedTween()

	if arg0_29.timer then
		arg0_29.timer:Pause()
	end

	arg0_29.manjuuAnimator.speed = 0
	arg0_29.resultAnimator.speed = 0
end

function var0_0.resumeGame(arg0_30)
	arg0_30:resumeManagedTween()

	if arg0_30.timer then
		arg0_30.timer:Resume()
	end

	arg0_30.manjuuAnimator.speed = 1
	arg0_30.resultAnimator.speed = 1
end

function var0_0.endRound(arg0_31, arg1_31)
	arg0_31:stopTimer()

	if arg0_31.selectIndex then
		arg0_31:playManjuuAni(arg1_31)
	else
		arg0_31:playTimeOutAni()
		arg0_31:endGame()
	end
end

function var0_0.playManjuuAni(arg0_32, arg1_32)
	local var0_32 = arg0_32:findTF("cup_" .. arg0_32.selectIndex, arg0_32.cupContainer)
	local var1_32 = (var0_32.anchoredPosition.x + 480) / 480 + 1

	arg0_32.manjuuAnimator:Play(var18_0[var1_32])
	arg0_32.manjuuDft:SetEndEvent(function()
		arg0_32.manjuuDft:SetEndEvent(nil)

		local var0_33 = arg1_32 and var19_0[var1_32] or var20_0[var1_32]

		setActive(arg0_32:findTF("select", var0_32), false)
		arg0_32.manjuuAnimator:Play(var0_33)
		arg0_32:playResultAni(arg1_32)
	end)
end

function var0_0.playResultAni(arg0_34, arg1_34)
	local var0_34 = arg0_34:findTF("cup_" .. arg0_34.selectIndex, arg0_34.cupContainer)

	setParent(arg0_34.result, arg0_34:findTF("result_node", var0_34), false)
	setLocalScale(arg0_34.result, Vector3.one)
	setLocalPosition(arg0_34.result, Vector3.zero)
	setActive(arg0_34.result, true)

	if arg1_34 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var11_0)
		arg0_34.resultAnimator:Play(var21_0)
		arg0_34.resultDft:SetEndEvent(function()
			arg0_34.resultDft:SetEndEvent(nil)
			arg0_34:showCorrectBar()
		end)
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var12_0)

		local var1_34 = var22_0[math.random(#var22_0)]

		arg0_34.resultAnimator:Play(var1_34)
		arg0_34.resultDft:SetEndEvent(function()
			arg0_34.resultDft:SetEndEvent(nil)
			arg0_34:endGame()
		end)
	end
end

function var0_0.showCorrectBar(arg0_37)
	setActive(arg0_37.correctBar, true)

	local var0_37 = var1_0[1] + (arg0_37.roundNum - 1) * var1_0[2]

	arg0_37.curScore = arg0_37.curScore + var0_37

	setText(arg0_37.curScoreTxt, arg0_37.curScore)
	setLocalPosition(arg0_37.scoreAni, Vector3(0, 250, 0))
	setText(arg0_37.scoreAni, "+" .. var0_37)
	setActive(arg0_37.scoreAni, true)
	LeanTween.moveY(arg0_37.scoreAni, 300, 1):setOnComplete(System.Action(function()
		setActive(arg0_37.scoreAni, false)
	end))

	local var1_37 = 0.5
	local var2_37 = var2_0[arg0_37.roundNum] or var2_0[#var2_0]
	local var3_37 = arg0_37.curScore + var2_37 * arg0_37.curTime

	LeanTween.value(go(arg0_37.curScoreTxt), arg0_37.curScore, var3_37, var1_37):setOnUpdate(System.Action_float(function(arg0_39)
		setText(arg0_37.curScoreTxt, math.ceil(arg0_39))
	end)):setOnComplete(System.Action(function()
		arg0_37.curScore = var3_37

		setText(arg0_37.curScoreTxt, arg0_37.curScore)
	end))
	LeanTween.value(go(arg0_37.curTimeTxt), arg0_37.curTime, 0, var1_37):setOnUpdate(System.Action_float(function(arg0_41)
		setText(arg0_37.curTimeTxt, math.ceil(arg0_41))
	end)):setOnComplete(System.Action(function()
		arg0_37.curScore = var3_37

		setText(arg0_37.curTimeTxt, 0)
	end))
	onButton(arg0_37, arg0_37.correctBar, function()
		setActive(arg0_37.correctBar, false)
		setActive(arg0_37.scoreAni, false)
		arg0_37:initGameData()
		arg0_37:startGame()
	end, SFX_PANEL)
	arg0_37:managedTween(LeanTween.delayedCall, function()
		if isActive(arg0_37.correctBar) then
			triggerButton(arg0_37.correctBar)
		end
	end, var7_0, nil)
end

function var0_0.playTimeOutAni(arg0_45)
	local var0_45 = arg0_45:findTF("cup_" .. arg0_45.forkIndex, arg0_45.cupContainer)

	setParent(arg0_45.result, arg0_45:findTF("result_node", var0_45), false)
	setLocalScale(arg0_45.result, Vector3.one)
	setLocalPosition(arg0_45.result, Vector3.zero)
	setActive(arg0_45.result, true)
	arg0_45.resultAnimator:Play(var21_0)
	arg0_45.resultDft:SetEndEvent(function()
		arg0_45.resultDft:SetEndEvent(nil)
	end)
end

function var0_0.endGame(arg0_47)
	setActive(arg0_47.failBar, true)
	onButton(arg0_47, arg0_47.failBar, function()
		setActive(arg0_47.failBar, false)
		arg0_47:enterResultUI()
	end, SFX_PANEL)
	arg0_47:managedTween(LeanTween.delayedCall, function()
		if isActive(arg0_47.failBar) then
			triggerButton(arg0_47.failBar)
		end
	end, var7_0, nil)
end

function var0_0.enterResultUI(arg0_50)
	arg0_50.gameStartFlag = false

	setActive(arg0_50.endUI, true)
	setText(arg0_50.endScoreTxt, arg0_50.curScore)

	local var0_50 = arg0_50:GetMGData():GetRuntimeData("elements")
	local var1_50 = var0_50 and #var0_50 > 0 and var0_50[1] or 0

	setActive(arg0_50.newTag, var1_50 < arg0_50.curScore)

	if var1_50 <= arg0_50.curScore then
		var1_50 = arg0_50.curScore

		arg0_50:StoreDataToServer({
			var1_50
		})
	end

	setText(arg0_50.highestScoreTxt, var1_50)

	if arg0_50:GetMGHubData().count > 0 then
		arg0_50:SendSuccess(0)
	end
end

function var0_0.OnGetAwardDone(arg0_51, arg1_51)
	if arg1_51.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0_51 = arg0_51:GetMGHubData()

		if var0_51.ultimate == 0 and var0_51.usedtime >= var0_51:getConfig("reward_need") then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0_51.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	end
end

function var0_0.onBackPressed(arg0_52)
	if not arg0_52.gameStartFlag then
		arg0_52:emit(var0_0.ON_BACK_PRESSED)
	else
		setActive(arg0_52.exitUI, true)
		arg0_52:pauseGame()
	end
end

return var0_0
