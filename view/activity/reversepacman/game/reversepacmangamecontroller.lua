local var0_0 = class("ReversePacmanGameController")

var0_0.MAX_DIALOGUE_CNT = 30

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1

	arg0_1:InitTF()
	arg0_1:InitControl()
	arg0_1:AddListener()
	arg0_1:InitTimer()
end

function var0_0.InitTF(arg0_2, arg1_2)
	arg0_2.timeText = arg0_2._tf:Find("time/Text"):GetComponent(typeof(Text))
	arg0_2.dialogueTpl = arg0_2._tf:Find("panel/tpl")

	setActive(arg0_2.dialogueTpl, false)

	arg0_2.dialogueContainer = arg0_2._tf:Find("panel/view/content")
end

function var0_0.SetUp(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	arg0_3.levelId = arg1_3
	arg0_3.shipIds = arg2_3
	arg0_3.buffIds = arg3_3
	arg0_3.buffCnts = arg4_3
	arg0_3.eduBuffCnt = arg5_3

	arg0_3.mapControl:SetUp(arg0_3.levelId)
	arg0_3.roleControl:SetUp(arg0_3.shipIds, arg0_3.mapControl, arg0_3.eduBuffCnt)
	arg0_3.buffControl:SetUp(arg0_3.buffIds, arg0_3.buffCnts, arg0_3.mapControl, arg0_3)

	arg0_3.durationTime = arg0_3.mapControl:GetDuration()
	arg0_3.remainTime = arg0_3.durationTime
	arg0_3.ratingThresholds = arg0_3.mapControl:GetRatingThresholds()
	arg0_3.gameplayTimeScale = ReversePacmanConst.GetGameplayTimeScale(arg0_3.remainTime)
	arg0_3.fastGameplayTipShown = false

	arg0_3:StartGame()
end

function var0_0.InitControl(arg0_4)
	arg0_4.mapControl = ReversePacmanMapControl.New(arg0_4.binder, arg0_4._tf)
	arg0_4.roleControl = ReversePacmanRoleControl.New(arg0_4.binder, arg0_4._tf)
	arg0_4.buffControl = ReversePacmanBuffControl.New(arg0_4.binder, arg0_4._tf)
end

function var0_0.AddListener(arg0_5)
	arg0_5.binder:bind(ReversePacmanConst.EVENT.CAPTURE, function(arg0_6, arg1_6)
		if arg0_5.roleControl:CheckGameEnd() then
			arg0_5:EndGame(ReversePacmanConst.RESULT_TYPE.SUCCESS)
		end
	end)
	arg0_5.binder:bind(ReversePacmanConst.EVENT.GRAPH_CHANGED, function(arg0_7, arg1_7)
		if arg0_5.roleControl:CheckAllMonstersTrapped() then
			arg0_5:EndGame(ReversePacmanConst.RESULT_TYPE.SUCCESS)
		end
	end)
	arg0_5.binder:bind(ReversePacmanConst.EVENT.SHIP_PERFORMANCE, function(arg0_8, arg1_8)
		arg0_5:AddDialogue(arg1_8)
	end)
	arg0_5.binder:bind(ReversePacmanConst.EVENT.PICK, function(arg0_9, arg1_9)
		arg0_5:PauseGame()
		LeanTween.delayedCall(arg0_5:GetGameplayDuration(1), System.Action(function()
			arg0_5:ResumeGame()
		end))
	end)
end

function var0_0.InitTimer(arg0_11)
	arg0_11.timer = Timer.New(function()
		arg0_11:OnTimer(ReversePacmanConst.TIME_INTERVAL)
	end, ReversePacmanConst.TIME_INTERVAL, -1)
end

function var0_0.UpdateTimeUI(arg0_13)
	arg0_13.timeText.text = pg.TimeMgr.GetInstance():DescCDTimeForMinute(arg0_13.remainTime)
end

function var0_0.AddDialogue(arg0_14, arg1_14)
	arg0_14.dialogueCount = (arg0_14.dialogueCount or 0) + 1

	local var0_14 = cloneTplTo(arg0_14.dialogueTpl, arg0_14.dialogueContainer, "dialogue_" .. arg0_14.dialogueCount)
	local var1_14 = arg1_14.ship:GetWordByType(arg1_14.type)
	local var2_14 = arg1_14.shipId and pg.activity_chasing_character[arg1_14.shipId]

	if var2_14 then
		LoadImageSpriteAsync(var2_14.sd_avatar, var0_14:Find("icon"))
	end

	setText(var0_14:Find("dialogue/Text"), var1_14)
	scrollToBottom(arg0_14.dialogueContainer)

	arg0_14.dialogues = arg0_14.dialogues or {}

	table.insert(arg0_14.dialogues, var0_14)

	if #arg0_14.dialogues > var0_0.MAX_DIALOGUE_CNT then
		local var3_14 = table.remove(arg0_14.dialogues, 1)

		if var3_14 then
			Destroy(var3_14.gameObject)
		end
	end
end

function var0_0.StartGame(arg0_15)
	arg0_15.gameEnded = false
	arg0_15.isPause = false

	arg0_15:StartTimer()
end

function var0_0.EndGame(arg0_16, arg1_16)
	if arg0_16.gameEnded then
		return
	end

	arg0_16.gameEnded = true

	if arg0_16.roleControl then
		arg0_16.roleControl:SetGameEnded(true)
	end

	arg0_16:PauseGame()
	LeanTween.delayedCall(arg0_16:GetGameplayDuration(1), System.Action(function()
		arg0_16.roleControl:Hide()
		arg0_16.binder:GameOver({
			result = arg1_16,
			useTime = calcFloor(arg0_16.durationTime - arg0_16.remainTime),
			grade = ReversePacmanConst.GetGrade(arg0_16.remainTime, arg0_16.durationTime, arg0_16.ratingThresholds),
			shipCnt = arg0_16.roleControl:GetShipCnt(),
			monsterCnt = arg0_16.roleControl:GetCapturedMonsterCnt()
		})
	end))
end

function var0_0.CanCastBuff(arg0_18, arg1_18, arg2_18)
	if not arg2_18 or not arg0_18.mapControl:IsWalkable(arg2_18.x, arg2_18.y) then
		return false
	end

	if arg1_18 == ReversePacmanConst.BUFF.BLOCK and arg0_18.roleControl:IsCellOccupied(arg2_18) then
		return false
	end

	return true
end

function var0_0.IsAllMonstersTrapped(arg0_19)
	return arg0_19.roleControl:CheckAllMonstersTrapped()
end

function var0_0.StartTimer(arg0_20)
	if not arg0_20.timer.running then
		arg0_20.timer:Start()
	end
end

function var0_0.StopTimer(arg0_21)
	if arg0_21.timer.running then
		arg0_21.timer:Stop()
	end
end

function var0_0.PauseGame(arg0_22)
	arg0_22.isPause = true

	arg0_22:StopTimer()
end

function var0_0.ResumeGame(arg0_23)
	if arg0_23.gameEnded then
		return
	end

	arg0_23.isPause = false

	arg0_23:StartTimer()
end

function var0_0.IsPause(arg0_24)
	return arg0_24.isPause
end

function var0_0.OnTimer(arg0_25, arg1_25)
	if arg0_25.gameEnded then
		return
	end

	local var0_25 = arg0_25.gameplayTimeScale or ReversePacmanConst.GAMEPLAY_TIME_SCALE.NORMAL

	arg0_25.gameplayTimeScale = ReversePacmanConst.GetGameplayTimeScale(arg0_25.remainTime)

	if not arg0_25.fastGameplayTipShown and var0_25 ~= ReversePacmanConst.GAMEPLAY_TIME_SCALE.FAST and arg0_25.gameplayTimeScale == ReversePacmanConst.GAMEPLAY_TIME_SCALE.FAST then
		arg0_25.fastGameplayTipShown = true

		pg.TipsMgr.GetInstance():ShowTips(i18n("reverse_pacman_game_speed_up_tip"))
	end

	local var1_25 = arg1_25 * arg0_25.gameplayTimeScale

	arg0_25.remainTime = arg0_25.remainTime - var1_25

	arg0_25:UpdateTimeUI()

	if arg0_25.remainTime <= 0 then
		arg0_25.remainTime = 0

		arg0_25:UpdateTimeUI()
		arg0_25:EndGame(ReversePacmanConst.RESULT_TYPE.FAIL)

		return
	end

	arg0_25.mapControl:Update(var1_25)
	arg0_25.roleControl:Update(var1_25)
	arg0_25.buffControl:Update(var1_25)
end

function var0_0.GetGameplayTimeScale(arg0_26)
	return arg0_26.gameplayTimeScale or ReversePacmanConst.GAMEPLAY_TIME_SCALE.NORMAL
end

function var0_0.GetGameplayDuration(arg0_27, arg1_27)
	return arg1_27 / arg0_27:GetGameplayTimeScale()
end

function var0_0.Dispose(arg0_28)
	if arg0_28.timer then
		if arg0_28.timer.running then
			arg0_28.timer:Stop()
		end

		arg0_28.timer = nil
	end

	arg0_28.mapControl:Dispose()
	arg0_28.roleControl:Dispose()
	arg0_28.buffControl:Dispose()
end

return var0_0
