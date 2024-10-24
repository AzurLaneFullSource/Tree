local var0_0 = class("BoatAdGamePopUI")
local var1_0
local var2_0

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

function var0_0.initAdWindow(arg0_12)
	arg0_12.adUI = findTF(arg0_12._tf, "pop/AdUI")

	setActive(arg0_12.adUI, false)

	arg0_12.mvContent = findTF(arg0_12.adUI, "ad/movie/view/content")
	arg0_12.btnPlay = findTF(arg0_12.adUI, "ad/movie/btnPlay")
	arg0_12.btnStop = findTF(arg0_12.adUI, "ad/movie/btnStop")
	arg0_12.btnRepeat = findTF(arg0_12.adUI, "ad/movie/btnRepeat")

	setActive(arg0_12.btnRepeat, false)
	onButton(arg0_12._event, findTF(arg0_12.adUI, "ad/bottom"), function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 1 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_12.isLoading then
			return
		end

		setActive(arg0_12.adUI, false)
		arg0_12:clearMovie()
		arg0_12._event:emit(BoatAdGameEvent.CLOSE_AD_UI)
	end, SFX_CANCEL)
	onButton(arg0_12._event, findTF(arg0_12.adUI, "ad/bgClose"), function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 2 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_12.isLoading then
			return
		end

		setActive(arg0_12.adUI, false)
		arg0_12:clearMovie()
		arg0_12._event:emit(BoatAdGameEvent.CLOSE_AD_UI)
	end, SFX_CANCEL)
	onButton(arg0_12._event, arg0_12.btnRepeat, function()
		if var2_0 and Time.realtimeSinceStartup - var2_0 < 2 then
			return
		end

		var2_0 = Time.realtimeSinceStartup

		if arg0_12.mvManaCpkUI and arg0_12.mvCompleteFlag then
			arg0_12:loadMv()
		end
	end)
end

function var0_0.clearMovie(arg0_16)
	if arg0_16.mvGo then
		arg0_16.mvManaCpkUI:SetPlayEndHandler(nil)
		arg0_16.mvManaCpkUI:StopCpk()
		destroy(arg0_16.mvGo)

		arg0_16.mvManaCpkUI = nil
		arg0_16.mvGo = nil
		arg0_16.mvName = nil
	end
end

function var0_0.loadMv(arg0_17)
	arg0_17:clearMovie()

	if arg0_17.isLoading then
		return
	end

	local var0_17 = "BoatAdMvUI"

	arg0_17.isLoading = true
	arg0_17.mvCompleteFlag = false

	PoolMgr.GetInstance():GetUI(var0_17, true, function(arg0_18)
		arg0_17.mvGo = arg0_18
		arg0_17.mvName = var0_17
		arg0_17.mvManaCpkUI = GetComponent(findTF(arg0_17.mvGo, "video/cpk"), typeof(CriManaCpkUI))

		arg0_17.mvManaCpkUI:SetPlayEndHandler(System.Action(function()
			arg0_17:mvComplete()
		end))
		arg0_17.mvManaCpkUI:PlayCpk()

		local var0_18 = PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME) or 1

		arg0_17.mvManaCpkUI.player:SetVolume(var0_18)
		setActive(arg0_17.btnPlay, false)
		setActive(arg0_17.btnStop, true)
		setActive(arg0_17.btnRepeat, false)

		if arg0_17.isLoading == false then
			arg0_17:clearMovie()
		else
			arg0_17.isLoading = false

			setParent(arg0_17.mvGo, arg0_17.mvContent)
			setActive(arg0_17.mvGo, true)
		end
	end)
end

function var0_0.mvComplete(arg0_20)
	print("播放完成")

	arg0_20.mvCompleteFlag = true

	arg0_20:onPlayerEnd()
end

function var0_0.onPlayerEnd(arg0_21)
	setActive(arg0_21.btnPlay, false)
	setActive(arg0_21.btnStop, false)
	setActive(arg0_21.btnRepeat, true)
end

function var0_0.onPlayerStop(arg0_22)
	setActive(arg0_22.btnPlay, true)
	setActive(arg0_22.btnStop, false)
	setActive(arg0_22.btnRepeat, false)
end

function var0_0.onPlayerStart(arg0_23)
	setActive(arg0_23.btnPlay, false)
	setActive(arg0_23.btnStop, true)
	setActive(arg0_23.btnRepeat, false)
end

function var0_0.oepnAd(arg0_24)
	setActive(arg0_24.adUI, true)

	var2_0 = Time.realtimeSinceStartup

	arg0_24:loadMv()
end

function var0_0.updateSettlementUI(arg0_25)
	GetComponent(findTF(arg0_25.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_25 = var1_0.GetMiniGameData():GetRuntimeData("elements")
	local var1_25 = var1_0.scoreNum
	local var2_25 = var0_25 and #var0_25 > 0 and var0_25[1] or 0

	setActive(findTF(arg0_25.settlementUI, "ad/new"), var2_25 < var1_25)

	if var2_25 < var1_25 then
		var2_25 = var1_25

		arg0_25._event:emit(SimpleMGEvent.STORE_SERVER, var2_25)
	end

	local var3_25 = findTF(arg0_25.settlementUI, "ad/highText")
	local var4_25 = findTF(arg0_25.settlementUI, "ad/currentText")

	setText(var3_25, var2_25)
	setText(var4_25, var1_25)
	arg0_25._event:emit(SimpleMGEvent.SUBMIT_GAME_SUCCESS)
end

function var0_0.backPressed(arg0_26)
	if isActive(arg0_26.pauseUI) then
		arg0_26:resumeGame()
		arg0_26._event:emit(SimpleMGEvent.PAUSE_GAME, false)
	elseif isActive(arg0_26.leaveUI) then
		arg0_26:resumeGame()
		arg0_26._event:emit(SimpleMGEvent.LEVEL_GAME, false)
	elseif not isActive(arg0_26.pauseUI) and not isActive(arg0_26.pauseUI) then
		arg0_26:popPauseUI()
		arg0_26._event:emit(SimpleMGEvent.PAUSE_GAME, true)
	else
		arg0_26:resumeGame()
	end
end

function var0_0.resumeGame(arg0_27)
	setActive(arg0_27.leaveUI, false)
	setActive(arg0_27.pauseUI, false)
end

function var0_0.popLeaveUI(arg0_28)
	if isActive(arg0_28.pauseUI) then
		setActive(arg0_28.pauseUI, false)
	end

	setActive(arg0_28.leaveUI, true)
end

function var0_0.popPauseUI(arg0_29)
	if isActive(arg0_29.leaveUI) then
		setActive(arg0_29.leaveUI, false)
	end

	setActive(arg0_29.pauseUI, true)
end

function var0_0.updateGameUI(arg0_30, arg1_30)
	setText(arg0_30.scoreTf, arg1_30.scoreNum)
	setText(arg0_30.gameTimeS, math.ceil(arg1_30.gameTime))
end

function var0_0.readyStart(arg0_31)
	arg0_31:popCountUI(true)
	arg0_31.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_COUNT_DOWN)
end

function var0_0.popCountUI(arg0_32, arg1_32)
	setActive(arg0_32.countUI, arg1_32)
end

function var0_0.popSettlementUI(arg0_33, arg1_33)
	setActive(arg0_33.settlementUI, arg1_33)
end

function var0_0.clearUI(arg0_34)
	setActive(arg0_34.settlementUI, false)
	setActive(arg0_34.countUI, false)
end

return var0_0
