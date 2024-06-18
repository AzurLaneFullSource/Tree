local var0_0 = class("NewBattleResultDuelAniamtion")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1.playerExp = arg1_1
	arg0_1.playerExpBar = arg2_1
	arg0_1.nextPoint = arg3_1
	arg0_1.oldRank = arg4_1
	arg0_1.season = arg5_1
end

function var0_0.SetUp(arg0_2, arg1_2)
	parallelAsync({
		function(arg0_3)
			arg0_2:ScoreAnimation(arg0_3)
		end,
		function(arg0_4)
			arg0_2:ScoreBarAnimation(arg0_4)
		end
	}, arg1_2)
end

function var0_0.ScoreAnimation(arg0_5, arg1_5)
	local var0_5 = NewBattleResultUtil.GetSeasonScoreOffset(arg0_5.oldRank, arg0_5.season)

	LeanTween.value(arg0_5.playerExp.gameObject, 0, var0_5, 1.5):setOnUpdate(System.Action_float(function(arg0_6)
		arg0_5.playerExp.text = "+" .. math.ceil(arg0_6)
	end)):setOnComplete(System.Action(arg1_5))
end

function var0_0.ScoreBarAnimation(arg0_7, arg1_7)
	local var0_7 = arg0_7.season.score / arg0_7.nextPoint

	LeanTween.value(arg0_7.playerExpBar.gameObject, 0, var0_7, 1.5):setOnUpdate(System.Action_float(function(arg0_8)
		arg0_7.playerExpBar.fillAmount = arg0_8
	end)):setOnComplete(System.Action(arg1_7))
end

function var0_0.Dispose(arg0_9)
	if LeanTween.isTweening(arg0_9.playerExp.gameObject) then
		LeanTween.cancel(arg0_9.playerExp.gameObject)
	end

	if LeanTween.isTweening(arg0_9.playerExpBar.gameObject) then
		LeanTween.cancel(arg0_9.playerExpBar.gameObject)
	end
end

return var0_0
