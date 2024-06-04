local var0 = class("BattleChallengeResultLayer", import(".BattleResultLayer"))

var0.DURATION_WIN_FADE_IN = 0.5
var0.DURATION_LOSE_FADE_IN = 1.5
var0.DURATION_GRADE_LAST = 1.5
var0.DURATION_MOVE = 0.7
var0.DURATION_WIN_SCALE = 0.7
var0.STATE_DEFEAT = "state_defeat"
var0.STATE_CLEAR = "state_clear"
var0.STATE_CONTINUE = "state_continue"
var0.STATE_QUIT = "state_quit"

function var0.getUIName(arg0)
	return "BattleResultUI"
end

function var0.setChallengeInfo(arg0, arg1, arg2)
	arg0.challenge = arg1
	arg0.challengeExpire = arg2
end

function var0.setShips(arg0, arg1)
	arg0.shipVOs = arg1
end

function var0.isTotalClear(arg0)
	return arg0.challenge:getMode() == ChallengeProxy.MODE_CASUAL and arg0.challenge:IsFinish() or arg0:isFail()
end

function var0.isFail(arg0)
	return arg0.contextData.score < ys.Battle.BattleConst.BattleScore.S
end

function var0.init(arg0)
	var0.super.init(arg0)

	arg0._challengeBottomPanel = arg0:findTF("challenge_confirm", arg0._blurConatiner)

	setText(findTF(arg0._challengeBottomPanel, "continue_btn/text"), i18n("battle_result_continue_battle"))
	setText(findTF(arg0._challengeBottomPanel, "quit_btn/text"), i18n("battle_result_quit_battle"))
	setText(findTF(arg0._challengeBottomPanel, "share_btn/text"), i18n("battle_result_share_battle"))

	arg0._shareBtn = arg0:findTF("share_btn", arg0._challengeBottomPanel)
	arg0._continueBtn = arg0:findTF("continue_btn", arg0._challengeBottomPanel)
	arg0._quitBtn = arg0:findTF("quit_btn", arg0._challengeBottomPanel)
	arg0._expire = arg0:findTF("challenge_expire", arg0._main)
	arg0._expireTxt = arg0:findTF("text", arg0._expire)
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	onButton(arg0, arg0._skipBtn, function()
		arg0:skip()
	end, SFX_CONFIRM)
end

function var0.setStageName(arg0)
	if arg0.contextData.system and arg0.contextData.system == SYSTEM_DUEL then
		setText(arg0._levelText, arg0.rivalVO.name)
	else
		local var0 = arg0.contextData.stageId
		local var1 = pg.expedition_data_template[var0]
	end

	if arg0.challenge:getMode() == ChallengeProxy.MODE_INFINITE then
		local var2 = arg0.contextData.stageId
		local var3 = pg.expedition_data_template[var2].name .. " - ROUND " .. arg0.challenge:getLevel()

		setText(arg0._levelText, var3)
	else
		var0.super.setStageName(arg0)
	end
end

function var0.rankAnimaFinish(arg0)
	local var0 = arg0:findTF("main/conditions")

	if arg0.challenge:getMode() == ChallengeProxy.MODE_INFINITE then
		SetActive(var0, false)

		arg0._stateFlag = var0.STATE_REPORTED
	else
		SetActive(var0, true)
		arg0:setCondition(i18n("challenge_combat_score", arg0.challenge:getLastScore()), true)
		arg0:setCondition(i18n("challenge_current_score", arg0.challenge:getScore()), true)

		local var1 = LeanTween.delayedCall(1, System.Action(function()
			arg0._stateFlag = var0.STATE_REPORTED

			SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)
		end))

		table.insert(arg0._delayLeanList, var1.id)

		arg0._stateFlag = var0.STATE_REPORT
	end
end

function var0.displayDefeat(arg0)
	local function var0()
		arg0:skip()
	end

	if arg0:isFail() then
		arg0._stateFlag = var0.STATE_QUIT

		var0()
	else
		arg0:emit(BattleResultMediator.ON_CHALLENGE_DEFEAT_SCENE, {
			callback = var0
		})
	end
end

function var0.showRightBottomPanel(arg0)
	SetActive(arg0._expire, arg0.challengeExpire)
	setText(arg0._expireTxt, i18n("challenge_expire_warn"))
	SetActive(arg0._skipBtn, false)

	if not arg0:isTotalClear() then
		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), false)
	end

	SetActive(arg0._challengeBottomPanel, true)

	if arg0:isTotalClear() then
		SetActive(arg0._continueBtn, false)
		SetActive(arg0._quitBtn, false)
		SetActive(arg0._shareBtn, true)
		onButton(arg0, arg0._shareBtn, function()
			arg0:emit(BattleResultMediator.ON_CHALLENGE_SHARE)
		end, SFX_CONFIRM)
		onButton(arg0, arg0._bg, function()
			arg0:skip()

			arg0._stateFlag = var0.STATE_CLEAR
		end)
	else
		SetActive(arg0._continueBtn, true)
		SetActive(arg0._quitBtn, true)
		SetActive(arg0._shareBtn, false)
		onButton(arg0, arg0._continueBtn, function()
			arg0:skip()

			arg0._stateFlag = var0.STATE_CONTINUE
		end, SFX_CONFIRM)
		onButton(arg0, arg0._quitBtn, function()
			arg0:skip()

			arg0._stateFlag = var0.STATE_QUIT
		end, SFX_CONFIRM)
	end

	arg0._stateFlag = var0.STATE_DEFEAT
end

function var0.onBackPressed(arg0)
	arg0:skip()
end

function var0.skip(arg0)
	for iter0, iter1 in ipairs(arg0._delayLeanList) do
		LeanTween.cancel(iter1)
	end

	if arg0._stateFlag == var0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0._stateFlag == var0.STATE_REPORT then
		local var0 = arg0._conditionContainer.childCount

		while var0 > 0 do
			SetActive(arg0._conditionContainer:GetChild(var0 - 1), true)

			var0 = var0 - 1
		end

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)

		arg0._stateFlag = var0.STATE_REPORTED
	elseif arg0._stateFlag == var0.STATE_REPORTED then
		arg0:showRightBottomPanel()
	elseif arg0._stateFlag == var0.STATE_DEFEAT then
		if arg0:isTotalClear() then
			arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE, {
				goToNext = false
			})
		else
			arg0:displayDefeat()
		end
	elseif arg0._stateFlag == var0.STATE_CONTINUE then
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE, {
			goToNext = true
		})
	elseif arg0._stateFlag == var0.STATE_QUIT or arg0._stateFlag == var0.STATE_CLEAR then
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE, {
			goToNext = false
		})
	end
end

function var0.willExit(arg0)
	var0.super.willExit(arg0)
	LeanTween.cancel(go(arg0._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
