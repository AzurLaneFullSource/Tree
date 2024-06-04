local var0 = class("SailBoatGamePopUI")
local var1

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	var1 = SailBoatGameVo

	arg0:initCountUI()
	arg0:initLeavelUI()
	arg0:initPauseUI()
	arg0:initSettlementUI()
end

function var0.initCountUI(arg0)
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetOrAddComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		arg0._event:emit(SailBoatGameView.COUNT_DOWN)
	end)
end

function var0.initLeavelUI(arg0)
	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	setActive(arg0.leaveUI, false)
	onButton(arg0._event, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0._event:emit(SailBoatGameView.LEVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
		arg0._event:emit(SailBoatGameView.LEVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0.initPauseUI(arg0)
	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	setActive(arg0.pauseUI, false)
	onButton(arg0._event, findTF(arg0.pauseUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0._event:emit(SailBoatGameView.PAUSE_GAME, false)
	end, SFX_CANCEL)
end

function var0.initSettlementUI(arg0)
	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	setActive(arg0.settlementUI, false)
	onButton(arg0._event, findTF(arg0.settlementUI, "ad/btnOver"), function()
		arg0:clearUI()
		arg0._event:emit(SailBoatGameView.BACK_MENU)
	end, SFX_CANCEL)
end

function var0.updateSettlementUI(arg0)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = var1.GetMiniGameData():GetRuntimeData("elements")
	local var1 = var1.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var2 < var1)

	if var2 < var1 then
		var2 = var1

		arg0._event:emit(SailBoatGameView.STORE_SERVER, var2)
	end

	local var3 = findTF(arg0.settlementUI, "ad/highText")
	local var4 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var3, var2)
	setText(var4, var1)
	arg0._event:emit(SailBoatGameView.SUBMIT_GAME_SUCCESS)
end

function var0.backPressed(arg0)
	if isActive(arg0.pauseUI) then
		arg0:resumeGame()
		arg0._event:emit(SailBoatGameView.PAUSE_GAME, false)
	elseif isActive(arg0.leaveUI) then
		arg0:resumeGame()
		arg0._event:emit(SailBoatGameView.LEVEL_GAME, false)
	elseif not isActive(arg0.pauseUI) and not isActive(arg0.pauseUI) then
		arg0:popPauseUI()
		arg0._event:emit(SailBoatGameView.PAUSE_GAME, true)
	else
		arg0:resumeGame()
	end
end

function var0.resumeGame(arg0)
	setActive(arg0.leaveUI, false)
	setActive(arg0.pauseUI, false)
end

function var0.popLeaveUI(arg0)
	if isActive(arg0.pauseUI) then
		setActive(arg0.pauseUI, false)
	end

	setActive(arg0.leaveUI, true)
end

function var0.popPauseUI(arg0)
	if isActive(arg0.leaveUI) then
		setActive(arg0.leaveUI, false)
	end

	setActive(arg0.pauseUI, true)
end

function var0.updateGameUI(arg0, arg1)
	setText(arg0.scoreTf, arg1.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg1.gameTime))
end

function var0.readyStart(arg0)
	arg0:popCountUI(true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1.SFX_COUNT_DOWN)
end

function var0.popCountUI(arg0, arg1)
	setActive(arg0.countUI, arg1)
end

function var0.popSettlementUI(arg0, arg1)
	setActive(arg0.settlementUI, arg1)
end

function var0.clearUI(arg0)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
end

return var0
