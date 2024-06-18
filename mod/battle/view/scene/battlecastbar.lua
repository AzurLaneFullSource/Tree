ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleCastBar = class("BattleCastBar")
var0_0.Battle.BattleCastBar.__name = "BattleCastBar"

local var1_0 = var0_0.Battle.BattleCastBar

var1_0.OFFSET = Vector3(1.8, 2.3, 0)

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._castClockTF = arg1_1
	arg0_1._castClockGO = arg0_1._castClockTF.gameObject
	arg0_1._castProgress = arg0_1._castClockTF:Find("cast_progress"):GetComponent(typeof(Image))
	arg0_1._interrupt = arg0_1._castClockTF:Find("interrupt")
	arg0_1._casting = arg0_1._castClockTF:Find("casting")
	arg0_1._danger = arg0_1._castClockTF:Find("danger")
	arg0_1._clockCG = arg0_1._castClockTF:GetComponent(typeof(CanvasGroup))
end

function var1_0.Casting(arg0_2, arg1_2, arg2_2)
	LeanTween.cancel(arg0_2._castClockGO)

	arg0_2._castClockTF.localScale = Vector3(0.1, 0.1, 1)

	SetActive(arg0_2._castClockTF, true)
	SetActive(arg0_2._casting, true)
	SetActive(arg0_2._interrupt, false)
	LeanTween.scale(rtf(arg0_2._castClockGO), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeInBack)

	arg0_2._castFinishTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1_2
	arg0_2._castDuration = arg1_2

	LeanTween.rotate(rtf(arg0_2._danger), 360, 5):setLoopClamp()

	arg0_2._weapon = arg2_2
end

function var1_0.Interrupt(arg0_3, arg1_3)
	arg0_3._weapon = nil

	if arg1_3 then
		SetActive(arg0_3._casting, false)
		SetActive(arg0_3._interrupt, true)
	end

	LeanTween.cancel(go(arg0_3._danger))

	for iter0_3 = 1, 2 do
		LeanTween.alphaCanvas(arg0_3._clockCG, 0.3, 0.3):setFrom(1):setDelay(0.3 * (iter0_3 - 1))
		LeanTween.alphaCanvas(arg0_3._clockCG, 1, 0.3):setDelay(0.3 * iter0_3)
	end

	LeanTween.scale(rtf(arg0_3._castClockGO), Vector3.New(0.1, 0.1, 1), 0.3):setEase(LeanTweenType.easeInBack):setDelay(1.25):setOnComplete(System.Action(function()
		SetActive(arg0_3._castClockTF, false)
	end))
end

function var1_0.GetCastingWeapon(arg0_5)
	return arg0_5._weapon
end

function var1_0.UpdateCastClockPosition(arg0_6, arg1_6)
	arg0_6._castClockTF.position = arg1_6 + var1_0.OFFSET
end

function var1_0.UpdateCastClock(arg0_7)
	local var0_7 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_7._castProgress.fillAmount = 1 - (arg0_7._castFinishTime - var0_7) / arg0_7._castDuration
end

function var1_0.Dispose(arg0_8)
	arg0_8._weapon = nil

	Object.Destroy(arg0_8._castClockGO)

	arg0_8._castClockTF = nil
	arg0_8._castClockGO = nil
	arg0_8._castProgress = nil
	arg0_8._interrupt = nil
	arg0_8._casting = nil
end
