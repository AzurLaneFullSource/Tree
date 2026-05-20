local var0_0 = class("SortGamingUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1

	arg0_1:initUI()
end

function var0_0.initUI(arg0_2)
	arg0_2._gameUI = findTF(arg0_2._tf, "ui/gamingUI")
	arg0_2.btnBack = findTF(arg0_2._gameUI, "back")
	arg0_2.btnPause = findTF(arg0_2._gameUI, "pause")
	arg0_2.timeTF = findTF(arg0_2._gameUI, "time/ad/time")
	arg0_2.scoreTextTf = findTF(arg0_2._gameUI, "scoreText/ad/score")

	onButton(arg0_2._event, arg0_2.btnBack, function()
		if not arg0_2._gameVo.startSettlement then
			arg0_2._event:emit(SimpleMGEvent.PAUSE_GAME, true)
			arg0_2._event:emit(SimpleMGEvent.OPEN_LEVEL_UI)
		end
	end, SFX_CONFIRM)
	onButton(arg0_2._event, arg0_2.btnPause, function()
		if not arg0_2._gameVo.startSettlement then
			arg0_2._event:emit(SimpleMGEvent.PAUSE_GAME, true)
			arg0_2._event:emit(SimpleMGEvent.OPEN_PAUSE_UI)
		end
	end, SFX_CONFIRM)
	setText(findTF(arg0_2._gameUI, "time/ad/time_desc"), i18n("pac_game_gaming_time_desc"))
	setText(findTF(arg0_2._gameUI, "scoreText/ad/score_desc"), i18n("pac_game_gaming_score"))

	arg0_2._comboTF = findTF(arg0_2._gameUI, "combo")

	setActive(findTF(arg0_2._gameUI, "combo"), false)

	arg0_2._comboProgressSlider = GetComponent(findTF(arg0_2._gameUI, "combo/ad/progress"), typeof(Slider))
	arg0_2._wantedTF = findTF(arg0_2._gameUI, "wanted")
	arg0_2._wantedProgressSlider = GetComponent(findTF(arg0_2._gameUI, "wanted/ad/Slider"), typeof(Slider))
	arg0_2._wantedItemIcon = findTF(arg0_2._gameUI, "wanted/ad/Slider/icon")
	arg0_2._wantedPlayerIcon = findTF(arg0_2._gameUI, "wanted/ad/Icon/mask/icon")
	arg0_2._playerSpeakIcon = findTF(arg0_2._gameUI, "playerSpeak/ad/mask/icon")
	arg0_2._playerSpeakTF = findTF(arg0_2._gameUI, "playerSpeak")
	arg0_2._playerSpeakText = findTF(arg0_2._gameUI, "speak_panel/ad/chat/text")
	arg0_2._playerSpeakPanel = findTF(arg0_2._gameUI, "speak_panel")
	arg0_2._scoreTpl = findTF(arg0_2._gameUI, "score_tpl")

	setActive(arg0_2._scoreTpl, false)

	arg0_2._scoreContent = findTF(arg0_2._gameUI, "scoreContent")
	arg0_2._scoreTfPool = {}
	arg0_2._scoreTfTweenDic = {}
	arg0_2.comboEffectTf = {
		findTF(arg0_2._comboTF, "ad/vx_combo01"),
		findTF(arg0_2._comboTF, "ad/vx_combo02"),
		findTF(arg0_2._comboTF, "ad/vx_combo03")
	}

	for iter0_2 = 1, #arg0_2.comboEffectTf do
		setActive(arg0_2.comboEffectTf[iter0_2], false)
	end
end

function var0_0.CreateScoreTF(arg0_5, arg1_5, arg2_5)
	local var0_5

	if #arg0_5._scoreTfPool > 0 then
		var0_5 = table.remove(arg0_5._scoreTfPool, 1)

		setActive(var0_5, true)
	else
		var0_5 = tf(Instantiate(arg0_5._scoreTpl))

		local var1_5 = GetComponent(findTF(var0_5, "ad"), typeof(DftAniEvent))

		setParent(var0_5, arg0_5._scoreContent)
		setActive(var0_5, true)
		var1_5:SetEndEvent(function()
			setActive(var0_5, false)
		end)
	end

	table.insert(arg0_5._scoreTfTweenDic, {
		finish = false,
		show = 0.3,
		step = 0,
		tf = var0_5,
		start = arg2_5
	})

	var0_5.position = arg2_5

	local var2_5 = math.floor(arg1_5 / 1000)
	local var3_5 = math.floor(arg1_5 % 1000 / 100)
	local var4_5 = math.floor(arg1_5 % 100 / 10)
	local var5_5 = math.floor(arg1_5 % 10)

	arg0_5:SetScoreText(var0_5, "thousand", arg1_5 >= 1000 and var2_5 or nil)
	arg0_5:SetScoreText(var0_5, "hundred", arg1_5 >= 100 and var3_5 or nil)
	arg0_5:SetScoreText(var0_5, "ten", arg1_5 >= 10 and var4_5 or nil)
	arg0_5:SetScoreText(var0_5, "one", arg1_5 >= 0 and var5_5 or nil)
end

function var0_0.SetScoreText(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = findTF(arg1_7, "ad/" .. arg2_7)

	if not arg3_7 then
		setActive(var0_7, false)

		return
	end

	for iter0_7 = 0, 9 do
		setActive(findTF(var0_7, "num_" .. tostring(iter0_7)), iter0_7 == arg3_7)
	end
end

function var0_0.Show(arg0_8, arg1_8)
	setActive(arg0_8._gameUI, arg1_8)
end

function var0_0.Update(arg0_9)
	return
end

function var0_0.UpdatePlayer(arg0_10, arg1_10)
	LoadSpriteAtlasAsync("qicon/" .. arg1_10, nil, function(arg0_11)
		setImageSprite(arg0_10._wantedPlayerIcon, arg0_11, true)
	end)
	LoadSpriteAtlasAsync("qicon/" .. arg1_10, nil, function(arg0_12)
		setImageSprite(arg0_10._playerSpeakIcon, arg0_12, true)
	end)
end

function var0_0.Start(arg0_13)
	arg0_13.subGameStepTime = 0

	arg0_13:Show(true)

	arg0_13._editorFlag = arg0_13._gameVo:GetEditor()

	local var0_13 = getProxy(MiniGameProxy):GetHighScore(arg0_13._gameVo:GetGameId())

	if not var0_13 or not (#var0_13 > 0) or not var0_13[1] then
		local var1_13 = 0
	end

	setText(arg0_13.scoreTextTf, 0)

	arg0_13._score = 0
	arg0_13._time = -1
	arg0_13._comboIndex = 0

	setActive(arg0_13._wantedTF, false)

	arg0_13._playerSpeakTime = nil
	arg0_13._comboTime = nil
	arg0_13._wantedStepTime = nil

	setActive(arg0_13._comboTF, false)
	setActive(arg0_13._wantedTF, false)
	setActive(arg0_13._playerSpeakPanel, false)
	setActive(arg0_13._playerSpeakTF, false)
end

function var0_0.Step(arg0_14, arg1_14)
	if arg0_14._time ~= arg0_14._gameVo:GetTimeInteger() then
		arg0_14._time = arg0_14._gameVo:GetTimeInteger()

		if arg0_14._time < 0 then
			arg0_14._time = 0
		end

		local var0_14 = math.floor(arg0_14._time / 60)
		local var1_14 = math.floor(arg0_14._time % 60)

		setText(arg0_14.timeTF, string.format("%02d : %02d", var0_14, var1_14))
	end

	if arg0_14._comboTime and arg0_14._comboTime >= 0 then
		arg0_14._comboTime = arg0_14._comboTime - arg1_14

		if arg0_14._comboTime and arg0_14._comboTime <= 0 then
			arg0_14._comboTime = nil

			setActive(findTF(arg0_14._gameUI, "combo"), false)
		else
			arg0_14._comboProgressSlider.value = arg0_14._comboTime / SortGameConst.combo_time
		end
	end

	if arg0_14._wantedStepTime and arg0_14._wantedStepTime >= 0 then
		arg0_14._wantedStepTime = arg0_14._wantedStepTime - arg1_14

		if arg0_14._wantedStepTime and arg0_14._wantedStepTime <= 0 then
			arg0_14._wantedStepTime = nil
		else
			arg0_14._wantedProgressSlider.value = arg0_14._wantedStepTime / SortGameConst.wanted_step_time
		end
	end

	if arg0_14._playerSpeakTime and arg0_14._playerSpeakTime >= 0 then
		arg0_14._playerSpeakTime = arg0_14._playerSpeakTime - arg1_14

		if arg0_14._playerSpeakTime and arg0_14._playerSpeakTime <= 0 then
			arg0_14._playerSpeakTime = nil

			setActive(arg0_14._playerSpeakPanel, false)
			setActive(arg0_14._playerSpeakTF, false)
		end
	end

	arg0_14:StepScoreTween(arg1_14)
end

function var0_0.StepScoreTween(arg0_15, arg1_15)
	for iter0_15 = #arg0_15._scoreTfTweenDic, 1, -1 do
		local var0_15 = arg0_15._scoreTfTweenDic[iter0_15]

		if var0_15 and not var0_15.finish then
			if var0_15.show and var0_15.show > 0 then
				var0_15.show = var0_15.show - arg1_15

				if var0_15.show <= 0 then
					var0_15.show = nil
				end
			else
				local var1_15, var2_15, var3_15, var4_15 = arg0_15:GetSmoothOffset(var0_15.start, arg0_15.scoreTextTf.position, arg1_15, 0.75, var0_15.state)

				if var0_15.tf then
					var0_15.tf.position = var2_15
				end

				var0_15.state = var4_15

				if var3_15 then
					var0_15.finish = true

					if var0_15.tf then
						GetComponent(findTF(var0_15.tf, "ad"), typeof(Animator)):SetTrigger("hide")
						table.insert(arg0_15._scoreTfPool, var0_15.tf)
						arg0_15:UpdateScore()
					end

					table.remove(arg0_15._scoreTfTweenDic, iter0_15)
				end
			end
		end
	end
end

function var0_0.UpdateScore(arg0_16)
	if arg0_16._score ~= arg0_16._gameVo:GetScore() then
		arg0_16._score = arg0_16._gameVo:GetScore()

		setText(arg0_16.scoreTextTf, arg0_16._score)
	end
end

function var0_0.AddScore(arg0_17, arg1_17)
	if arg1_17 and arg1_17.position and arg1_17.num then
		arg0_17:CreateScoreTF(arg1_17.num, arg1_17.position)
	else
		arg0_17:UpdateScore()
	end

	if arg1_17 and arg1_17.combo then
		arg0_17:SetCombo(arg1_17.combo)
	end
end

function var0_0.RefreshWantedItem(arg0_18, arg1_18, arg2_18)
	if arg1_18 then
		setActive(arg0_18._wantedTF, true)
		GetSpriteFromAtlasAsync(SortGameConst.ui_atlas, "item_" .. arg1_18, function(arg0_19)
			if arg0_19 then
				arg0_18._wantedStepTime = SortGameConst.wanted_step_time

				setImageSprite(arg0_18._wantedItemIcon, arg0_19, true)
				setActive(arg0_18._wantedItemIcon, true)
			end
		end)
		arg0_18:UpdatePlayer(arg2_18)
	else
		setActive(arg0_18._wantedTF, false)
	end
end

function var0_0.SetCombo(arg0_20, arg1_20)
	if arg1_20 == 0 then
		setActive(findTF(arg0_20._gameUI, "combo"), false)

		return
	end

	arg0_20._comboIndex = arg1_20

	for iter0_20 = 1, #arg0_20.comboEffectTf do
		setActive(arg0_20.comboEffectTf[iter0_20], false)
	end

	for iter1_20 = #SortGameConst.combo_effect_count, 1, -1 do
		if arg1_20 >= SortGameConst.combo_effect_count[iter1_20] then
			setActive(arg0_20.comboEffectTf[iter1_20], true)

			break
		end
	end

	arg0_20._comboTime = SortGameConst.combo_time

	setActive(findTF(arg0_20._gameUI, "combo"), false)
	setActive(findTF(arg0_20._gameUI, "combo"), true)
	setText(findTF(arg0_20._gameUI, "combo/ad/combo_img/combo_desc"), "X " .. arg1_20)
end

function var0_0.SetPlayerSpeak(arg0_21, arg1_21)
	if arg0_21._playerSpeakTime then
		return
	end

	if arg1_21 and arg1_21.text then
		setActive(arg0_21._playerSpeakPanel, true)
		setActive(arg0_21._playerSpeakTF, true)
		setText(arg0_21._playerSpeakText, arg1_21.text)

		arg0_21._playerSpeakTime = arg1_21.time

		local var0_21 = arg1_21.icon or nil

		if var0_21 then
			arg0_21:UpdatePlayer(var0_21)
		end
	else
		setActive(arg0_21._playerSpeakPanel, false)
		setActive(arg0_21._playerSpeakTF, false)
	end
end

function var0_0.StepTimeToScore(arg0_22)
	if arg0_22._timeToScoreTimer then
		return
	end

	local var0_22 = SortGameConst.time_trans_score * arg0_22._gameVo:GetTimeInteger()
	local var1_22 = 3
	local var2_22 = arg0_22._gameVo:GetTimeInteger() / var1_22

	arg0_22._timeToScoreStep = var1_22 * SortGameConst.time_trans_score
	arg0_22._timeToScoreTimer = Timer.New(function()
		var2_22 = var2_22 - 1

		if var2_22 <= 0 then
			if arg0_22._timeToScoreTimer then
				arg0_22._timeToScoreTimer:Stop()

				arg0_22._timeToScoreTimer = nil
			end

			arg0_22._event:emit(SimpleMGEvent.ADD_SCORE, {
				combo = 0,
				num = var0_22
			})
			setText(arg0_22.timeTF, string.format("%02d : %02d", 0, 0))
			setText(arg0_22.scoreTextTf, arg0_22._gameVo:GetScore())
			arg0_22._event:emit(SimpleMGEvent.GAME_OVER)

			return
		end

		arg0_22._time = arg0_22._time - var1_22

		local var0_23 = math.floor(arg0_22._time / 60)
		local var1_23 = math.floor(arg0_22._time % 60)

		setText(arg0_22.timeTF, string.format("%02d : %02d", var0_23, var1_23))

		arg0_22._score = arg0_22._score + arg0_22._timeToScoreStep

		setText(arg0_22.scoreTextTf, arg0_22._score)
		arg0_22:StepScoreTween(0.05)
	end, 0.05, -1)

	arg0_22._timeToScoreTimer:Start()
end

function var0_0.SetChildVisible(arg0_24, arg1_24, arg2_24)
	for iter0_24 = 1, arg1_24.childCount do
		local var0_24 = arg1_24:GetChild(iter0_24 - 1)

		setActive(var0_24, arg2_24)
	end
end

function var0_0.Press(arg0_25, arg1_25, arg2_25)
	return
end

function var0_0.GameOver(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26._scoreTfTweenDic) do
		if iter1_26.tf then
			setActive(iter1_26.tf, false)
			table.insert(arg0_26._scoreTfPool, iter1_26.tf)
		end
	end

	arg0_26._scoreTfTweenDic = {}
end

function var0_0.Dispose(arg0_27)
	for iter0_27 = 1, #arg0_27._scoreTfPool do
		GetComponent(findTF(arg0_27._scoreTfPool[iter0_27], "ad"), typeof(DftAniEvent)):SetEndEvent(nil)
	end
end

function var0_0.GetSmoothOffset(arg0_28, arg1_28, arg2_28, arg3_28, arg4_28, arg5_28)
	local function var0_28(arg0_29)
		return {
			x = arg0_29.x or 0,
			y = arg0_29.y or 0,
			z = arg0_29.z
		}
	end

	if not arg1_28 or not arg2_28 then
		return {
			z = 0,
			x = 0,
			y = 0
		}, nil, true, arg5_28
	end

	local var1_28 = math.max(arg4_28 or 0, 0.0001)

	arg5_28 = arg5_28 or {
		elapsed = 0,
		currentPos = var0_28(arg1_28)
	}

	local var2_28 = arg1_28.x or 0
	local var3_28 = arg1_28.y or 0
	local var4_28 = arg1_28.z
	local var5_28 = arg2_28.x or 0
	local var6_28 = arg2_28.y or 0
	local var7_28 = arg2_28.z

	arg5_28.elapsed = math.min(arg5_28.elapsed + (arg3_28 or 0), var1_28)

	local var8_28 = arg5_28.elapsed / var1_28
	local var9_28 = 0.5 - 0.5 * math.cos(math.pi * var8_28)
	local var10_28 = {
		x = var2_28 + (var5_28 - var2_28) * var9_28,
		y = var3_28 + (var6_28 - var3_28) * var9_28
	}

	if var4_28 ~= nil or var7_28 ~= nil then
		local var11_28 = var4_28 or 0

		var10_28.z = var11_28 + ((var7_28 or 0) - var11_28) * var9_28
	end

	local var12_28 = {
		x = var10_28.x - (arg5_28.currentPos.x or 0),
		y = var10_28.y - (arg5_28.currentPos.y or 0)
	}

	if var10_28.z ~= nil then
		var12_28.z = var10_28.z - (arg5_28.currentPos.z or 0)
	end

	arg5_28.currentPos = var10_28

	local var13_28 = var1_28 <= arg5_28.elapsed

	if var13_28 then
		var12_28.x = var5_28 - (arg5_28.currentPos.x - var12_28.x)
		var12_28.y = var6_28 - (arg5_28.currentPos.y - var12_28.y)
		arg5_28.currentPos.x = var5_28
		arg5_28.currentPos.y = var6_28

		if var10_28.z ~= nil then
			local var14_28 = var7_28 or 0

			var12_28.z = var14_28 - ((arg5_28.currentPos.z or 0) - (var12_28.z or 0))
			arg5_28.currentPos.z = var14_28
		end
	end

	return var12_28, var0_28(arg5_28.currentPos), var13_28, arg5_28
end

return var0_0
