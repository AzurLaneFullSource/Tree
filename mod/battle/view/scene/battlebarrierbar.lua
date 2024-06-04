ys = ys or {}

local var0 = ys

var0.Battle.BattleBarrierBar = class("BattleBarrierBar")
var0.Battle.BattleBarrierBar.__name = "BattleBarrierBar"

local var1 = var0.Battle.BattleBarrierBar

var1.OFFSET = Vector3(1.8, 2.3, 0)

function var1.Ctor(arg0, arg1)
	arg0._barrierClockTF = arg1
	arg0._barrierClockGO = arg0._barrierClockTF.gameObject
	arg0._castProgress = arg0._barrierClockTF:Find("shield_progress"):GetComponent(typeof(Image))
	arg0._danger = arg0._barrierClockTF:Find("danger")
	arg0._clockCG = arg0._barrierClockTF:GetComponent(typeof(CanvasGroup))
end

function var1.Shielding(arg0, arg1)
	arg0._barrierClockTF.localScale = Vector3(0.1, 0.1, 1)

	SetActive(arg0._barrierClockTF, true)
	LeanTween.scale(rtf(arg0._barrierClockGO), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeInBack)

	arg0._barrierFinishTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1
	arg0._barrierDuration = arg1

	LeanTween.rotate(rtf(arg0._danger), 360, 5):setLoopClamp()
end

function var1.Interrupt(arg0)
	LeanTween.cancel(go(arg0._danger))
	LeanTween.scale(rtf(arg0._barrierClockGO), Vector3.New(0.1, 0.1, 1), 0.3):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
		SetActive(arg0._barrierClockTF, false)
	end))
end

function var1.UpdateBarrierClockPosition(arg0, arg1)
	arg0._barrierClockTF.position = arg1 + var1.OFFSET
end

function var1.UpdateBarrierClockProgress(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0._castProgress.fillAmount = (arg0._barrierFinishTime - var0) / arg0._barrierDuration
end

function var1.Dispose(arg0)
	Object.Destroy(arg0._barrierClockGO)

	arg0._barrierClockTF = nil
	arg0._barrierClockGO = nil
	arg0._castProgress = nil
end
