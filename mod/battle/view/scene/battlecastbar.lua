ys = ys or {}

local var0 = ys

var0.Battle.BattleCastBar = class("BattleCastBar")
var0.Battle.BattleCastBar.__name = "BattleCastBar"

local var1 = var0.Battle.BattleCastBar

var1.OFFSET = Vector3(1.8, 2.3, 0)

function var1.Ctor(arg0, arg1)
	arg0._castClockTF = arg1
	arg0._castClockGO = arg0._castClockTF.gameObject
	arg0._castProgress = arg0._castClockTF:Find("cast_progress"):GetComponent(typeof(Image))
	arg0._interrupt = arg0._castClockTF:Find("interrupt")
	arg0._casting = arg0._castClockTF:Find("casting")
	arg0._danger = arg0._castClockTF:Find("danger")
	arg0._clockCG = arg0._castClockTF:GetComponent(typeof(CanvasGroup))
end

function var1.Casting(arg0, arg1, arg2)
	LeanTween.cancel(arg0._castClockGO)

	arg0._castClockTF.localScale = Vector3(0.1, 0.1, 1)

	SetActive(arg0._castClockTF, true)
	SetActive(arg0._casting, true)
	SetActive(arg0._interrupt, false)
	LeanTween.scale(rtf(arg0._castClockGO), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeInBack)

	arg0._castFinishTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1
	arg0._castDuration = arg1

	LeanTween.rotate(rtf(arg0._danger), 360, 5):setLoopClamp()

	arg0._weapon = arg2
end

function var1.Interrupt(arg0, arg1)
	arg0._weapon = nil

	if arg1 then
		SetActive(arg0._casting, false)
		SetActive(arg0._interrupt, true)
	end

	LeanTween.cancel(go(arg0._danger))

	for iter0 = 1, 2 do
		LeanTween.alphaCanvas(arg0._clockCG, 0.3, 0.3):setFrom(1):setDelay(0.3 * (iter0 - 1))
		LeanTween.alphaCanvas(arg0._clockCG, 1, 0.3):setDelay(0.3 * iter0)
	end

	LeanTween.scale(rtf(arg0._castClockGO), Vector3.New(0.1, 0.1, 1), 0.3):setEase(LeanTweenType.easeInBack):setDelay(1.25):setOnComplete(System.Action(function()
		SetActive(arg0._castClockTF, false)
	end))
end

function var1.GetCastingWeapon(arg0)
	return arg0._weapon
end

function var1.UpdateCastClockPosition(arg0, arg1)
	arg0._castClockTF.position = arg1 + var1.OFFSET
end

function var1.UpdateCastClock(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0._castProgress.fillAmount = 1 - (arg0._castFinishTime - var0) / arg0._castDuration
end

function var1.Dispose(arg0)
	arg0._weapon = nil

	Object.Destroy(arg0._castClockGO)

	arg0._castClockTF = nil
	arg0._castClockGO = nil
	arg0._castProgress = nil
	arg0._interrupt = nil
	arg0._casting = nil
end
