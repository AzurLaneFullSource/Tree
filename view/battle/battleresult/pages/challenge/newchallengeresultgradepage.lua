local var0 = class("NewChallengeResultGradePage", import("..NewBattleResultGradePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.challenge = getProxy(ChallengeProxy):getUserChallengeInfo(arg0.contextData.mode)
	arg0.challengeExpire = getProxy(ChallengeProxy):userSeaonExpire(arg0.contextData.mode)
end

function var0.isTotalClear(arg0)
	return arg0.challenge:getMode() == ChallengeProxy.MODE_CASUAL and arg0.challenge:IsFinish() or arg0:isFail()
end

function var0.isFail(arg0)
	return arg0.contextData.score < ys.Battle.BattleConst.BattleScore.S
end

function var0.GetGetObjectives(arg0)
	local var0 = arg0.contextData
	local var1 = getProxy(ChallengeProxy):getUserChallengeInfo(var0.mode)

	if var1:getMode() == ChallengeProxy.MODE_INFINITE then
		return {}
	else
		local var2 = {}
		local var3 = i18n("challenge_combat_score", var1:getLastScore())
		local var4, var5 = NewBattleResultUtil.ColorObjective(true)

		table.insert(var2, {
			text = setColorStr(var3, var5),
			icon = var4
		})

		local var6 = i18n("challenge_current_score", var1:getScore())

		table.insert(var2, {
			text = setColorStr(var6, var5),
			icon = var4
		})

		return var2
	end
end

function var0.UpdateChapterName(arg0)
	local var0 = arg0.contextData

	if getProxy(ChallengeProxy):getUserChallengeInfo(var0.mode) == ChallengeProxy.MODE_INFINITE then
		local var1 = pg.expedition_data_template[var0.stageId].name .. " - ROUND " .. getProxy(ChallengeProxy):getUserChallengeInfo(var0.mode):getLevel()

		setText(arg0.gradeChapterName, var1)
	else
		var0.super.UpdateChapterName(arg0)
	end
end

function var0.LoadChallengeRes(arg0, arg1)
	setActive(arg0.bgTr:Find("ResultEffect/Tips"), false)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/Challenge", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			if arg1 then
				arg1()
			end

			return
		end

		arg0:UpdateChallengeInfo(Object.Instantiate(arg0, arg0._tf).transform)

		if arg1 then
			arg1()
		end
	end), true, true)
end

function var0.UpdateChallengeInfo(arg0, arg1)
	setText(arg1:Find("expire"), arg0.challengeExpire and i18n("challenge_expire_warn") or "")
	setText(findTF(arg1, "continue_btn/text"), i18n("battle_result_continue_battle"))
	setText(findTF(arg1, "quit_btn/text"), i18n("battle_result_quit_battle"))
	setText(findTF(arg1, "share_btn/text"), i18n("battle_result_share_battle"))

	arg0.continueBtn = findTF(arg1, "continue_btn")
	arg0.quitBtn = findTF(arg1, "quit_btn")
	arg0.shareBtn = findTF(arg1, "share_btn")

	local var0 = arg0:isTotalClear()

	SetActive(arg0.continueBtn, not var0)
	SetActive(arg0.quitBtn, not var0)
	SetActive(arg0.shareBtn, var0)
end

function var0.RegisterEvent(arg0, arg1)
	seriesAsync({
		function(arg0)
			var0.super.RegisterEvent(arg0, arg0)
		end,
		function(arg0)
			removeOnButton(arg0._tf)
			arg0:LoadChallengeRes(arg0)
		end,
		function(arg0)
			arg0:RegisterChallengeEvent(arg1)
		end
	})
end

function var0.RegisterChallengeEvent(arg0, arg1)
	if arg0:isTotalClear() then
		onButton(arg0, arg0.shareBtn, function()
			arg0:emit(NewBattleResultMediator.CHALLENGE_SHARE)
		end, SFX_CONFIRM)
		onButton(arg0, arg0._tf, arg1, SFX_CONFIRM)
	else
		onButton(arg0, arg0.continueBtn, function()
			arg0:OnContinue(arg1)
		end, SFX_CONFIRM)
		onButton(arg0, arg0.quitBtn, function()
			arg0:OnQuit(arg1)
		end, SFX_CONFIRM)
	end
end

function var0.OnContinue(arg0, arg1)
	if arg0:isFail() then
		arg1()
	else
		arg0.contextData.goToNext = true

		arg0:emit(NewBattleResultMediator.CHALLENGE_DEFEAT_SCENE, {
			callback = arg1
		})
	end
end

function var0.OnQuit(arg0, arg1)
	if arg0:isFail() then
		arg1()
	else
		arg0:emit(NewBattleResultMediator.CHALLENGE_DEFEAT_SCENE, {
			callback = arg1
		})
	end
end

return var0
