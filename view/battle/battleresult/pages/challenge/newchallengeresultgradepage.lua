local var0_0 = class("NewChallengeResultGradePage", import("..NewBattleResultGradePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.challenge = getProxy(ChallengeProxy):getUserChallengeInfo(arg0_1.contextData.mode)
	arg0_1.challengeExpire = getProxy(ChallengeProxy):userSeaonExpire(arg0_1.contextData.mode)
end

function var0_0.isTotalClear(arg0_2)
	return arg0_2.challenge:getMode() == ChallengeProxy.MODE_CASUAL and arg0_2.challenge:IsFinish() or arg0_2:isFail()
end

function var0_0.isFail(arg0_3)
	return arg0_3.contextData.score < ys.Battle.BattleConst.BattleScore.S
end

function var0_0.GetGetObjectives(arg0_4)
	local var0_4 = arg0_4.contextData
	local var1_4 = getProxy(ChallengeProxy):getUserChallengeInfo(var0_4.mode)

	if var1_4:getMode() == ChallengeProxy.MODE_INFINITE then
		return {}
	else
		local var2_4 = {}
		local var3_4 = i18n("challenge_combat_score", var1_4:getLastScore())
		local var4_4, var5_4 = NewBattleResultUtil.ColorObjective(true)

		table.insert(var2_4, {
			text = setColorStr(var3_4, var5_4),
			icon = var4_4
		})

		local var6_4 = i18n("challenge_current_score", var1_4:getScore())

		table.insert(var2_4, {
			text = setColorStr(var6_4, var5_4),
			icon = var4_4
		})

		return var2_4
	end
end

function var0_0.UpdateChapterName(arg0_5)
	local var0_5 = arg0_5.contextData

	if getProxy(ChallengeProxy):getUserChallengeInfo(var0_5.mode) == ChallengeProxy.MODE_INFINITE then
		local var1_5 = pg.expedition_data_template[var0_5.stageId].name .. " - ROUND " .. getProxy(ChallengeProxy):getUserChallengeInfo(var0_5.mode):getLevel()

		setText(arg0_5.gradeChapterName, var1_5)
	else
		var0_0.super.UpdateChapterName(arg0_5)
	end
end

function var0_0.LoadChallengeRes(arg0_6, arg1_6)
	setActive(arg0_6.bgTr:Find("ResultEffect/Tips"), false)
	LoadAnyAsync("BattleResultItems/Challenge", "", nil, function(arg0_7)
		if arg0_6.exited or IsNil(arg0_7) then
			if arg1_6 then
				arg1_6()
			end

			return
		end

		arg0_6:UpdateChallengeInfo(Object.Instantiate(arg0_7, arg0_6._tf).transform)

		if arg1_6 then
			arg1_6()
		end
	end)
end

function var0_0.UpdateChallengeInfo(arg0_8, arg1_8)
	setText(arg1_8:Find("expire"), arg0_8.challengeExpire and i18n("challenge_expire_warn") or "")
	setText(findTF(arg1_8, "continue_btn/text"), i18n("battle_result_continue_battle"))
	setText(findTF(arg1_8, "quit_btn/text"), i18n("battle_result_quit_battle"))
	setText(findTF(arg1_8, "share_btn/text"), i18n("battle_result_share_battle"))

	arg0_8.continueBtn = findTF(arg1_8, "continue_btn")
	arg0_8.quitBtn = findTF(arg1_8, "quit_btn")
	arg0_8.shareBtn = findTF(arg1_8, "share_btn")

	local var0_8 = arg0_8:isTotalClear()

	SetActive(arg0_8.continueBtn, not var0_8)
	SetActive(arg0_8.quitBtn, not var0_8)
	SetActive(arg0_8.shareBtn, var0_8)
end

function var0_0.RegisterEvent(arg0_9, arg1_9)
	seriesAsync({
		function(arg0_10)
			var0_0.super.RegisterEvent(arg0_9, arg0_10)
		end,
		function(arg0_11)
			removeOnButton(arg0_9._tf)
			arg0_9:LoadChallengeRes(arg0_11)
		end,
		function(arg0_12)
			arg0_9:RegisterChallengeEvent(arg1_9)
		end
	})
end

function var0_0.RegisterChallengeEvent(arg0_13, arg1_13)
	if arg0_13:isTotalClear() then
		onButton(arg0_13, arg0_13.shareBtn, function()
			arg0_13:emit(NewBattleResultMediator.CHALLENGE_SHARE)
		end, SFX_CONFIRM)
		onButton(arg0_13, arg0_13._tf, arg1_13, SFX_CONFIRM)
	else
		onButton(arg0_13, arg0_13.continueBtn, function()
			arg0_13:OnContinue(arg1_13)
		end, SFX_CONFIRM)
		onButton(arg0_13, arg0_13.quitBtn, function()
			arg0_13:OnQuit(arg1_13)
		end, SFX_CONFIRM)
	end
end

function var0_0.OnContinue(arg0_17, arg1_17)
	if arg0_17:isFail() then
		arg1_17()
	else
		arg0_17.contextData.goToNext = true

		arg0_17:emit(NewBattleResultMediator.CHALLENGE_DEFEAT_SCENE, {
			callback = arg1_17
		})
	end
end

function var0_0.OnQuit(arg0_18, arg1_18)
	if arg0_18:isFail() then
		arg1_18()
	else
		arg0_18:emit(NewBattleResultMediator.CHALLENGE_DEFEAT_SCENE, {
			callback = arg1_18
		})
	end
end

return var0_0
