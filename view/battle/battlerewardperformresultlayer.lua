local var0_0 = class("BattleRewardRerformResultLayer", import(".BattleResultLayer"))

function var0_0.didEnter(arg0_1)
	local var0_1 = arg0_1.contextData.stageId
	local var1_1 = pg.expedition_data_template[var0_1]

	setText(arg0_1._levelText, var1_1.name)

	local var2_1 = rtf(arg0_1._grade)

	arg0_1._gradeUpperLeftPos = var2_1.localPosition
	var2_1.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0_1._tf)

	arg0_1._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0_1._grade, Vector3(0.88, 0.88, 1), var0_0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0_1._levelText, true)
		arg0_1:rankAnimaFinish()
	end))

	arg0_1._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	arg0_1._stateFlag = BattleResultLayer.STATE_RANK_ANIMA

	onButton(arg0_1, arg0_1._skipBtn, function()
		arg0_1:skip()
	end, SFX_CONFIRM)
end

function var0_0.skip(arg0_4)
	if arg0_4._stateFlag == BattleResultLayer.STATE_REPORTED then
		arg0_4:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end
end

function var0_0.onBackPressed(arg0_5)
	triggerButton(arg0_5._skipBtn)
end

function var0_0.willExit(arg0_6)
	LeanTween.cancel(go(arg0_6._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0_6._tf)
end

return var0_0
