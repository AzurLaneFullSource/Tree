local var0_0 = class("BeachGuardUIlua")
local var1_0 = "event:/ui/ddldaoshu2"
local var2_0 = "event:/ui/break_out_full"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg3_1
	arg0_1._gameData = arg2_1

	arg0_1:initCountUI()
	arg0_1:initLeavelUI()
	arg0_1:initPauseUI()
	arg0_1:initSettlementUI()
end

function var0_0.initCountUI(arg0_2)
	arg0_2.countUI = findTF(arg0_2._tf, "pop/CountUI")
	arg0_2.countAnimator = GetComponent(findTF(arg0_2.countUI, "count"), typeof(Animator))
	arg0_2.countDft = GetOrAddComponent(findTF(arg0_2.countUI, "count"), typeof(DftAniEvent))

	arg0_2.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_2.countDft:SetEndEvent(function()
		arg0_2._event:emit(BeachGuardGameView.COUNT_DOWN)
	end)
end

function var0_0.initLeavelUI(arg0_5)
	arg0_5.leaveUI = findTF(arg0_5._tf, "pop/LeaveUI")

	GetComponent(findTF(arg0_5.leaveUI, "ad/desc"), typeof(Image)):SetNativeSize()
	setActive(arg0_5.leaveUI, false)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnOk"), function()
		arg0_5:resumeGame()
		arg0_5._event:emit(BeachGuardGameView.LEVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnCancel"), function()
		arg0_5:resumeGame()
		arg0_5._event:emit(BeachGuardGameView.LEVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initPauseUI(arg0_8)
	arg0_8.pauseUI = findTF(arg0_8._tf, "pop/pauseUI")

	GetComponent(findTF(arg0_8.pauseUI, "ad/desc"), typeof(Image)):SetNativeSize()
	setActive(arg0_8.pauseUI, false)
	onButton(arg0_8._event, findTF(arg0_8.pauseUI, "ad/btnOk"), function()
		arg0_8:resumeGame()
		arg0_8._event:emit(BeachGuardGameView.PAUSE_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initSettlementUI(arg0_10)
	arg0_10.settlementUI = findTF(arg0_10._tf, "pop/SettleMentUI")

	setActive(arg0_10.settlementUI, false)
	onButton(arg0_10._event, findTF(arg0_10.settlementUI, "ad/btnOver"), function()
		arg0_10:clearUI()
		arg0_10._event:emit(BeachGuardGameView.BACK_MENU)
	end, SFX_CANCEL)
end

function var0_0.updateSettlementUI(arg0_12, arg1_12, arg2_12, arg3_12)
	GetComponent(findTF(arg0_12.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_12 = arg1_12:GetRuntimeData("elements")
	local var1_12 = arg3_12.scoreNum
	local var2_12 = var0_12 and #var0_12 > 0 and var0_12[1] or 0

	setActive(findTF(arg0_12.settlementUI, "ad/new"), var2_12 < var1_12)

	if var2_12 < var1_12 then
		var2_12 = var1_12

		arg0_12._event:emit(BeachGuardGameView.STORE_SERVER, var2_12)
	end

	local var3_12 = findTF(arg0_12.settlementUI, "ad/highText")
	local var4_12 = findTF(arg0_12.settlementUI, "ad/currentText")

	setText(var3_12, var2_12)
	setText(var4_12, var1_12)

	local var5_12 = arg0_12:getGameTimes(arg2_12)

	if var5_12 and var5_12 > 0 and not arg0_12.sendSuccessFlag then
		arg0_12._event:emit(BeachGuardGameView.SUBMIT_GAME_SUCCESS)
	end
end

function var0_0.backPressed(arg0_13)
	if isActive(arg0_13.pauseUI) then
		arg0_13:resumeGame()
		arg0_13._event:emit(BeachGuardGameView.PAUSE_GAME, false)
	elseif isActive(arg0_13.leaveUI) then
		arg0_13:resumeGame()
		arg0_13._event:emit(BeachGuardGameView.LEVEL_GAME, false)
	elseif not isActive(arg0_13.pauseUI) and not isActive(arg0_13.pauseUI) then
		arg0_13:popPauseUI()
		arg0_13._event:emit(BeachGuardGameView.PAUSE_GAME, true)
	else
		arg0_13:resumeGame()
	end
end

function var0_0.resumeGame(arg0_14)
	setActive(arg0_14.leaveUI, false)
	setActive(arg0_14.pauseUI, false)
end

function var0_0.popLeaveUI(arg0_15)
	if isActive(arg0_15.pauseUI) then
		setActive(arg0_15.pauseUI, false)
	end

	setActive(arg0_15.leaveUI, true)
end

function var0_0.popPauseUI(arg0_16)
	if isActive(arg0_16.leaveUI) then
		setActive(arg0_16.leaveUI, false)
	end

	setActive(arg0_16.pauseUI, true)
end

function var0_0.updateGameUI(arg0_17, arg1_17)
	setText(arg0_17.scoreTf, arg1_17.scoreNum)
	setText(arg0_17.gameTimeS, math.ceil(arg1_17.gameTime))
end

function var0_0.readyStart(arg0_18)
	arg0_18:popCountUI(true)
	arg0_18.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0)
end

function var0_0.popCountUI(arg0_19, arg1_19)
	setActive(arg0_19.countUI, arg1_19)
end

function var0_0.openSettlementUI(arg0_20, arg1_20)
	setActive(arg0_20.settlementUI, arg1_20)
end

function var0_0.clearUI(arg0_21)
	setActive(arg0_21.settlementUI, false)
	setActive(arg0_21.countUI, false)
end

function var0_0.getGameTimes(arg0_22, arg1_22)
	return arg1_22.count
end

return var0_0
