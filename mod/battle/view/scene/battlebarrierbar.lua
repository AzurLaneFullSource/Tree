ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBarrierBar = class("BattleBarrierBar")
var0_0.Battle.BattleBarrierBar.__name = "BattleBarrierBar"

local var1_0 = var0_0.Battle.BattleBarrierBar

var1_0.OFFSET = Vector3(1.8, 2.3, 0)

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._barrierClockTF = arg1_1
	arg0_1._barrierClockGO = arg0_1._barrierClockTF.gameObject
	arg0_1._castProgress = arg0_1._barrierClockTF:Find("shield_progress"):GetComponent(typeof(Image))
	arg0_1._danger = arg0_1._barrierClockTF:Find("danger")
	arg0_1._clockCG = arg0_1._barrierClockTF:GetComponent(typeof(CanvasGroup))
end

function var1_0.Shielding(arg0_2, arg1_2)
	arg0_2._barrierClockTF.localScale = Vector3(0.1, 0.1, 1)

	SetActive(arg0_2._barrierClockTF, true)
	LeanTween.scale(rtf(arg0_2._barrierClockGO), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeInBack)

	arg0_2._barrierFinishTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1_2
	arg0_2._barrierDuration = arg1_2

	LeanTween.rotate(rtf(arg0_2._danger), 360, 5):setLoopClamp()
end

function var1_0.Interrupt(arg0_3)
	LeanTween.cancel(go(arg0_3._danger))
	LeanTween.scale(rtf(arg0_3._barrierClockGO), Vector3.New(0.1, 0.1, 1), 0.3):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
		SetActive(arg0_3._barrierClockTF, false)
	end))
end

function var1_0.UpdateBarrierClockPosition(arg0_5, arg1_5)
	arg0_5._barrierClockTF.position = arg1_5 + var1_0.OFFSET
end

function var1_0.UpdateBarrierClockProgress(arg0_6)
	local var0_6 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_6._castProgress.fillAmount = (arg0_6._barrierFinishTime - var0_6) / arg0_6._barrierDuration
end

function var1_0.Dispose(arg0_7)
	Object.Destroy(arg0_7._barrierClockGO)

	arg0_7._barrierClockTF = nil
	arg0_7._barrierClockGO = nil
	arg0_7._castProgress = nil
end
