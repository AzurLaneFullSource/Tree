local var0 = class("NewBattleResultDuelAniamtion")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.playerExp = arg1
	arg0.playerExpBar = arg2
	arg0.nextPoint = arg3
	arg0.oldRank = arg4
	arg0.season = arg5
end

function var0.SetUp(arg0, arg1)
	parallelAsync({
		function(arg0)
			arg0:ScoreAnimation(arg0)
		end,
		function(arg0)
			arg0:ScoreBarAnimation(arg0)
		end
	}, arg1)
end

function var0.ScoreAnimation(arg0, arg1)
	local var0 = NewBattleResultUtil.GetSeasonScoreOffset(arg0.oldRank, arg0.season)

	LeanTween.value(arg0.playerExp.gameObject, 0, var0, 1.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.playerExp.text = "+" .. math.ceil(arg0)
	end)):setOnComplete(System.Action(arg1))
end

function var0.ScoreBarAnimation(arg0, arg1)
	local var0 = arg0.season.score / arg0.nextPoint

	LeanTween.value(arg0.playerExpBar.gameObject, 0, var0, 1.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.playerExpBar.fillAmount = arg0
	end)):setOnComplete(System.Action(arg1))
end

function var0.Dispose(arg0)
	if LeanTween.isTweening(arg0.playerExp.gameObject) then
		LeanTween.cancel(arg0.playerExp.gameObject)
	end

	if LeanTween.isTweening(arg0.playerExpBar.gameObject) then
		LeanTween.cancel(arg0.playerExpBar.gameObject)
	end
end

return var0
