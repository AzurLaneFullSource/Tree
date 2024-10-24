local var0_0 = class("BoatAdGamePopUI")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	var1_0 = BoatAdGameVo

	arg0_1:initCountUI()
	arg0_1:initLeavelUI()
	arg0_1:initPauseUI()
	arg0_1:initSettlementUI()
	arg0_1:initAdWindow()
end

function var0_0.initCountUI(arg0_2)
	arg0_2.countUI = findTF(arg0_2._tf, "pop/CountUI")
	arg0_2.countAnimator = GetComponent(findTF(arg0_2.countUI, "count"), typeof(Animator))
	arg0_2.countDft = GetOrAddComponent(findTF(arg0_2.countUI, "count"), typeof(DftAniEvent))

	arg0_2.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_2.countDft:SetEndEvent(function()
		arg0_2._event:emit(SimpleMGEvent.COUNT_DOWN)
	end)
end

function var0_0.initLeavelUI(arg0_5)
	arg0_5.leaveUI = findTF(arg0_5._tf, "pop/LeaveUI")

	GetComponent(findTF(arg0_5.leaveUI, "ad/desc"), typeof(Image)):SetNativeSize()
	setActive(arg0_5.leaveUI, false)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnOk"), function()
		arg0_5:resumeGame()
		arg0_5._event:emit(SimpleMGEvent.LEVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0_5._event, findTF(arg0_5.leaveUI, "ad/btnCancel"), function()
		arg0_5:resumeGame()
		arg0_5._event:emit(SimpleMGEvent.LEVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initPauseUI(arg0_8)
	arg0_8.pauseUI = findTF(arg0_8._tf, "pop/pauseUI")

	GetComponent(findTF(arg0_8.pauseUI, "ad/desc"), typeof(Image)):SetNativeSize()
	setActive(arg0_8.pauseUI, false)
	onButton(arg0_8._event, findTF(arg0_8.pauseUI, "ad/btnOk"), function()
		arg0_8:resumeGame()
		arg0_8._event:emit(SimpleMGEvent.PAUSE_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initSettlementUI(arg0_10)
	arg0_10.settlementUI = findTF(arg0_10._tf, "pop/SettleMentUI")

	setActive(arg0_10.settlementUI, false)
	onButton(arg0_10._event, findTF(arg0_10.settlementUI, "ad/btnOver"), function()
		arg0_10:clearUI()
		arg0_10._event:emit(SimpleMGEvent.BACK_MENU)
	end, SFX_CANCEL)
end

local var2_0

function var0_0.initAdWindow(arg0_12)
	arg0_12.adUI = findTF(arg0_12._tf, "pop/AdUI")

	setActive(arg0_12.adUI, false)

	arg0_12.mvContent = findTF(arg0_12.adUI, "ad/movie/view/content")
	arg0_12.btnPlay = findTF(arg0_12.adUI, "ad/movie/btnPlay")
	arg0_12.btnStop = findTF(arg0_12.adUI, "ad/movie/btnStop")
	arg0_12.btnRepeat = findTF(arg0_12.adUI, "ad/movie/btnRepeat")

	onButton(arg0_12._event, findTF(arg0_12.adUI, "ad/bottom"), function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_12.isLoading then
			return
		end

		if arg0_12.playHandle then
			arg0_12.playHandle()

			arg0_12.playHandle = nil
		end

		setActive(arg0_12.adUI, false)
		arg0_12:clearMovie()
		arg0_12._event:emit(BoatAdGameEvent.CLOSE_AD_UI)
	end, SFX_CANCEL)
	onButton(arg0_12._event, findTF(arg0_12.adUI, "ad/bgClose"), function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_12.isLoading then
			return
		end

		if arg0_12.playHandle then
			arg0_12.playHandle()

			arg0_12.playHandle = nil
		end

		setActive(arg0_12.adUI, false)
		arg0_12:clearMovie()
		arg0_12._event:emit(BoatAdGameEvent.CLOSE_AD_UI)
	end, SFX_CANCEL)
	onButton(arg0_12._event, arg0_12.btnPlay, function()
		return
	end)
	onButton(arg0_12._event, arg0_12.btnStop, function()
		return
	end)
	onButton(arg0_12._event, arg0_12.btnRepeat, function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_12.mvManaCpkUI and arg0_12.mvCompleteFlag then
			print("重新播放")
			arg0_12:loadMv()
		end
	end)
end

function var0_0.clearMovie(arg0_18)
	if arg0_18.mvGo then
		arg0_18.mvManaCpkUI:SetPlayEndHandler(nil)
		arg0_18.mvManaCpkUI:StopCpk()
		destroy(arg0_18.mvGo)

		arg0_18.mvManaCpkUI = nil
		arg0_18.mvGo = nil
		arg0_18.mvName = nil
	end
end

function var0_0.loadMv(arg0_19)
	arg0_19:clearMovie()

	if arg0_19.isLoading then
		return
	end

	local var0_19 = "BoatAdMvUI"

	arg0_19.isLoading = true

	PoolMgr.GetInstance():GetUI(var0_19, true, function(arg0_20)
		arg0_19.mvGo = arg0_20
		arg0_19.mvName = var0_19
		arg0_19.mvManaCpkUI = GetComponent(findTF(arg0_19.mvGo, "video/cpk"), typeof(CriManaCpkUI))

		arg0_19.mvManaCpkUI:SetPlayEndHandler(System.Action(function()
			arg0_19:mvComplete()

			if arg0_19.playHandle then
				arg0_19.playHandle()

				arg0_19.playHandle = nil
			end
		end))
		arg0_19.mvManaCpkUI.player:SetVolume(PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME))
		setActive(arg0_19.btnPlay, false)
		setActive(arg0_19.btnStop, true)
		setActive(arg0_19.btnRepeat, false)

		if arg0_19.isLoading == false then
			arg0_19:clearMovie()
		else
			arg0_19.isLoading = false

			setParent(arg0_19.mvGo, arg0_19.mvContent)
			setActive(arg0_19.mvGo, true)
		end

		arg0_19.mvCompleteFlag = false

		arg0_19.mvManaCpkUI:PlayCpk()
	end)
end

function var0_0.mvComplete(arg0_22)
	print("播放完成")

	arg0_22.mvCompleteFlag = true

	arg0_22:onPlayerEnd()

	if arg0_22.mvIndex == arg0_22.nday then
		-- block empty
	end
end

function var0_0.onPlayerEnd(arg0_23)
	setActive(arg0_23.btnPlay, false)
	setActive(arg0_23.btnStop, false)
	setActive(arg0_23.btnRepeat, true)
end

function var0_0.onPlayerStop(arg0_24)
	setActive(arg0_24.btnPlay, true)
	setActive(arg0_24.btnStop, false)
	setActive(arg0_24.btnRepeat, false)
end

function var0_0.onPlayerStart(arg0_25)
	setActive(arg0_25.btnPlay, false)
	setActive(arg0_25.btnStop, true)
	setActive(arg0_25.btnRepeat, false)
end

function var0_0.oepnAd(arg0_26)
	setActive(arg0_26.adUI, true)
	arg0_26:loadMv()
end

function var0_0.updateSettlementUI(arg0_27)
	GetComponent(findTF(arg0_27.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_27 = var1_0.GetMiniGameData():GetRuntimeData("elements")
	local var1_27 = var1_0.scoreNum
	local var2_27 = var0_27 and #var0_27 > 0 and var0_27[1] or 0

	setActive(findTF(arg0_27.settlementUI, "ad/new"), var2_27 < var1_27)

	if var2_27 < var1_27 then
		var2_27 = var1_27

		arg0_27._event:emit(SimpleMGEvent.STORE_SERVER, var2_27)
	end

	local var3_27 = findTF(arg0_27.settlementUI, "ad/highText")
	local var4_27 = findTF(arg0_27.settlementUI, "ad/currentText")

	setText(var3_27, var2_27)
	setText(var4_27, var1_27)
	arg0_27._event:emit(SimpleMGEvent.SUBMIT_GAME_SUCCESS)
end

function var0_0.backPressed(arg0_28)
	if isActive(arg0_28.pauseUI) then
		arg0_28:resumeGame()
		arg0_28._event:emit(SimpleMGEvent.PAUSE_GAME, false)
	elseif isActive(arg0_28.leaveUI) then
		arg0_28:resumeGame()
		arg0_28._event:emit(SimpleMGEvent.LEVEL_GAME, false)
	elseif not isActive(arg0_28.pauseUI) and not isActive(arg0_28.pauseUI) then
		arg0_28:popPauseUI()
		arg0_28._event:emit(SimpleMGEvent.PAUSE_GAME, true)
	else
		arg0_28:resumeGame()
	end
end

function var0_0.resumeGame(arg0_29)
	setActive(arg0_29.leaveUI, false)
	setActive(arg0_29.pauseUI, false)
end

function var0_0.popLeaveUI(arg0_30)
	if isActive(arg0_30.pauseUI) then
		setActive(arg0_30.pauseUI, false)
	end

	setActive(arg0_30.leaveUI, true)
end

function var0_0.popPauseUI(arg0_31)
	if isActive(arg0_31.leaveUI) then
		setActive(arg0_31.leaveUI, false)
	end

	setActive(arg0_31.pauseUI, true)
end

function var0_0.updateGameUI(arg0_32, arg1_32)
	setText(arg0_32.scoreTf, arg1_32.scoreNum)
	setText(arg0_32.gameTimeS, math.ceil(arg1_32.gameTime))
end

function var0_0.readyStart(arg0_33)
	arg0_33:popCountUI(true)
	arg0_33.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_COUNT_DOWN)
end

function var0_0.popCountUI(arg0_34, arg1_34)
	setActive(arg0_34.countUI, arg1_34)
end

function var0_0.popSettlementUI(arg0_35, arg1_35)
	setActive(arg0_35.settlementUI, arg1_35)
end

function var0_0.clearUI(arg0_36)
	setActive(arg0_36.settlementUI, false)
	setActive(arg0_36.countUI, false)
end

return var0_0
