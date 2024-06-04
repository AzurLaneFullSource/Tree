local var0 = class("BattleRewardRerformResultLayer", import(".BattleResultLayer"))

function var0.didEnter(arg0)
	local var0 = arg0.contextData.stageId
	local var1 = pg.expedition_data_template[var0]

	setText(arg0._levelText, var1.name)

	local var2 = rtf(arg0._grade)

	arg0._gradeUpperLeftPos = var2.localPosition
	var2.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0._grade, Vector3(0.88, 0.88, 1), var0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0._levelText, true)
		arg0:rankAnimaFinish()
	end))

	arg0._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	arg0._stateFlag = BattleResultLayer.STATE_RANK_ANIMA

	onButton(arg0, arg0._skipBtn, function()
		arg0:skip()
	end, SFX_CONFIRM)
end

function var0.skip(arg0)
	if arg0._stateFlag == BattleResultLayer.STATE_REPORTED then
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end
end

function var0.onBackPressed(arg0)
	triggerButton(arg0._skipBtn)
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
