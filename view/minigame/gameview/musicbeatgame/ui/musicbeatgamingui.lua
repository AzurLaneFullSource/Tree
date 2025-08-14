local var0_0 = class("MusicBeatGamingUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")

	onButton(arg0_1._event, arg0_1.btnBack, function()
		if not arg0_1._gameVo.startSettlement then
			arg0_1._event:emit(MusicBeatGameEvent.PAUSE_GAME, true)
			arg0_1._event:emit(MusicBeatGameEvent.OPEN_LEVEL_UI)
		end
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnPause, function()
		if not arg0_1._gameVo.startSettlement then
			arg0_1._event:emit(MusicBeatGameEvent.PAUSE_GAME, true)
			arg0_1._event:emit(MusicBeatGameEvent.OPEN_PAUSE_UI)
		end
	end, SFX_CONFIRM)

	arg0_1.scoreCurrent = findTF(arg0_1._gameUI, "score/text")
end

function var0_0.show(arg0_4, arg1_4)
	setActive(arg0_4._gameUI, arg1_4)
end

function var0_0.update(arg0_5)
	return
end

function var0_0.start(arg0_6)
	arg0_6.subGameStepTime = 0

	arg0_6:show(true)

	local var0_6 = getProxy(MiniGameProxy):GetHighScore(arg0_6._gameVo.gameId)

	if not var0_6 or not (#var0_6 > 0) or not var0_6[1] then
		local var1_6 = 0
	end

	setText(arg0_6.scoreCurrent, 0)
end

function var0_0.addScore(arg0_7, arg1_7)
	setText(arg0_7.scoreCurrent, arg0_7._gameVo.scoreNum)
end

function var0_0.step(arg0_8, arg1_8)
	local var0_8 = arg0_8._gameVo.gameTime
end

function var0_0.setChildVisible(arg0_9, arg1_9, arg2_9)
	for iter0_9 = 1, arg1_9.childCount do
		local var0_9 = arg1_9:GetChild(iter0_9 - 1)

		setActive(var0_9, arg2_9)
	end
end

function var0_0.press(arg0_10, arg1_10, arg2_10)
	if arg1_10 == KeyCode.A then
		-- block empty
	elseif arg1_10 == KeyCode.D then
		-- block empty
	end
end

return var0_0
