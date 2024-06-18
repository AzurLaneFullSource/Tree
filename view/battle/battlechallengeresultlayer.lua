local var0_0 = class("BattleChallengeResultLayer", import(".BattleResultLayer"))

var0_0.DURATION_WIN_FADE_IN = 0.5
var0_0.DURATION_LOSE_FADE_IN = 1.5
var0_0.DURATION_GRADE_LAST = 1.5
var0_0.DURATION_MOVE = 0.7
var0_0.DURATION_WIN_SCALE = 0.7
var0_0.STATE_DEFEAT = "state_defeat"
var0_0.STATE_CLEAR = "state_clear"
var0_0.STATE_CONTINUE = "state_continue"
var0_0.STATE_QUIT = "state_quit"

function var0_0.getUIName(arg0_1)
	return "BattleResultUI"
end

function var0_0.setChallengeInfo(arg0_2, arg1_2, arg2_2)
	arg0_2.challenge = arg1_2
	arg0_2.challengeExpire = arg2_2
end

function var0_0.setShips(arg0_3, arg1_3)
	arg0_3.shipVOs = arg1_3
end

function var0_0.isTotalClear(arg0_4)
	return arg0_4.challenge:getMode() == ChallengeProxy.MODE_CASUAL and arg0_4.challenge:IsFinish() or arg0_4:isFail()
end

function var0_0.isFail(arg0_5)
	return arg0_5.contextData.score < ys.Battle.BattleConst.BattleScore.S
end

function var0_0.init(arg0_6)
	var0_0.super.init(arg0_6)

	arg0_6._challengeBottomPanel = arg0_6:findTF("challenge_confirm", arg0_6._blurConatiner)

	setText(findTF(arg0_6._challengeBottomPanel, "continue_btn/text"), i18n("battle_result_continue_battle"))
	setText(findTF(arg0_6._challengeBottomPanel, "quit_btn/text"), i18n("battle_result_quit_battle"))
	setText(findTF(arg0_6._challengeBottomPanel, "share_btn/text"), i18n("battle_result_share_battle"))

	arg0_6._shareBtn = arg0_6:findTF("share_btn", arg0_6._challengeBottomPanel)
	arg0_6._continueBtn = arg0_6:findTF("continue_btn", arg0_6._challengeBottomPanel)
	arg0_6._quitBtn = arg0_6:findTF("quit_btn", arg0_6._challengeBottomPanel)
	arg0_6._expire = arg0_6:findTF("challenge_expire", arg0_6._main)
	arg0_6._expireTxt = arg0_6:findTF("text", arg0_6._expire)
end

function var0_0.didEnter(arg0_7)
	var0_0.super.didEnter(arg0_7)
	onButton(arg0_7, arg0_7._skipBtn, function()
		arg0_7:skip()
	end, SFX_CONFIRM)
end

function var0_0.setStageName(arg0_9)
	if arg0_9.contextData.system and arg0_9.contextData.system == SYSTEM_DUEL then
		setText(arg0_9._levelText, arg0_9.rivalVO.name)
	else
		local var0_9 = arg0_9.contextData.stageId
		local var1_9 = pg.expedition_data_template[var0_9]
	end

	if arg0_9.challenge:getMode() == ChallengeProxy.MODE_INFINITE then
		local var2_9 = arg0_9.contextData.stageId
		local var3_9 = pg.expedition_data_template[var2_9].name .. " - ROUND " .. arg0_9.challenge:getLevel()

		setText(arg0_9._levelText, var3_9)
	else
		var0_0.super.setStageName(arg0_9)
	end
end

function var0_0.rankAnimaFinish(arg0_10)
	local var0_10 = arg0_10:findTF("main/conditions")

	if arg0_10.challenge:getMode() == ChallengeProxy.MODE_INFINITE then
		SetActive(var0_10, false)

		arg0_10._stateFlag = var0_0.STATE_REPORTED
	else
		SetActive(var0_10, true)
		arg0_10:setCondition(i18n("challenge_combat_score", arg0_10.challenge:getLastScore()), true)
		arg0_10:setCondition(i18n("challenge_current_score", arg0_10.challenge:getScore()), true)

		local var1_10 = LeanTween.delayedCall(1, System.Action(function()
			arg0_10._stateFlag = var0_0.STATE_REPORTED

			SetActive(arg0_10:findTF("jieuan01/tips", arg0_10._bg), true)
		end))

		table.insert(arg0_10._delayLeanList, var1_10.id)

		arg0_10._stateFlag = var0_0.STATE_REPORT
	end
end

function var0_0.displayDefeat(arg0_12)
	local function var0_12()
		arg0_12:skip()
	end

	if arg0_12:isFail() then
		arg0_12._stateFlag = var0_0.STATE_QUIT

		var0_12()
	else
		arg0_12:emit(BattleResultMediator.ON_CHALLENGE_DEFEAT_SCENE, {
			callback = var0_12
		})
	end
end

function var0_0.showRightBottomPanel(arg0_14)
	SetActive(arg0_14._expire, arg0_14.challengeExpire)
	setText(arg0_14._expireTxt, i18n("challenge_expire_warn"))
	SetActive(arg0_14._skipBtn, false)

	if not arg0_14:isTotalClear() then
		SetActive(arg0_14:findTF("jieuan01/tips", arg0_14._bg), false)
	end

	SetActive(arg0_14._challengeBottomPanel, true)

	if arg0_14:isTotalClear() then
		SetActive(arg0_14._continueBtn, false)
		SetActive(arg0_14._quitBtn, false)
		SetActive(arg0_14._shareBtn, true)
		onButton(arg0_14, arg0_14._shareBtn, function()
			arg0_14:emit(BattleResultMediator.ON_CHALLENGE_SHARE)
		end, SFX_CONFIRM)
		onButton(arg0_14, arg0_14._bg, function()
			arg0_14:skip()

			arg0_14._stateFlag = var0_0.STATE_CLEAR
		end)
	else
		SetActive(arg0_14._continueBtn, true)
		SetActive(arg0_14._quitBtn, true)
		SetActive(arg0_14._shareBtn, false)
		onButton(arg0_14, arg0_14._continueBtn, function()
			arg0_14:skip()

			arg0_14._stateFlag = var0_0.STATE_CONTINUE
		end, SFX_CONFIRM)
		onButton(arg0_14, arg0_14._quitBtn, function()
			arg0_14:skip()

			arg0_14._stateFlag = var0_0.STATE_QUIT
		end, SFX_CONFIRM)
	end

	arg0_14._stateFlag = var0_0.STATE_DEFEAT
end

function var0_0.onBackPressed(arg0_19)
	arg0_19:skip()
end

function var0_0.skip(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20._delayLeanList) do
		LeanTween.cancel(iter1_20)
	end

	if arg0_20._stateFlag == var0_0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0_20._stateFlag == var0_0.STATE_REPORT then
		local var0_20 = arg0_20._conditionContainer.childCount

		while var0_20 > 0 do
			SetActive(arg0_20._conditionContainer:GetChild(var0_20 - 1), true)

			var0_20 = var0_20 - 1
		end

		SetActive(arg0_20:findTF("jieuan01/tips", arg0_20._bg), true)

		arg0_20._stateFlag = var0_0.STATE_REPORTED
	elseif arg0_20._stateFlag == var0_0.STATE_REPORTED then
		arg0_20:showRightBottomPanel()
	elseif arg0_20._stateFlag == var0_0.STATE_DEFEAT then
		if arg0_20:isTotalClear() then
			arg0_20:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE, {
				goToNext = false
			})
		else
			arg0_20:displayDefeat()
		end
	elseif arg0_20._stateFlag == var0_0.STATE_CONTINUE then
		arg0_20:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE, {
			goToNext = true
		})
	elseif arg0_20._stateFlag == var0_0.STATE_QUIT or arg0_20._stateFlag == var0_0.STATE_CLEAR then
		arg0_20:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE, {
			goToNext = false
		})
	end
end

function var0_0.willExit(arg0_21)
	var0_0.super.willExit(arg0_21)
	LeanTween.cancel(go(arg0_21._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf)
end

return var0_0
