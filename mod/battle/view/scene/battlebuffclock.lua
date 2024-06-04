ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffClock = class("BattleBuffClock")
var0.Battle.BattleBuffClock.__name = "BattleBuffClock"

local var1 = var0.Battle.BattleBuffClock

var1.OFFSET = Vector3(1.8, 2.3, 0)
var1.TYPE_INDEX = 3

function var1.Ctor(arg0, arg1)
	arg0._castClockTF = arg1
	arg0._castClockGO = arg0._castClockTF.gameObject
	arg0._bgList = arg0._castClockTF:Find("bg")
	arg0._danger = arg0._castClockTF:Find("danger")
	arg0._interrupt = arg0._castClockTF:Find("interrupt")
	arg0._casting = arg0._castClockTF:Find("casting")
	arg0._progressProtected = arg0._castClockTF:Find("progress/protected")
	arg0._progressInterrupt = arg0._castClockTF:Find("progress/interrupt")
	arg0._clockCG = arg0._castClockTF:GetComponent(typeof(CanvasGroup))
end

function var1.switchToIndex(arg0, arg1, arg2)
	for iter0 = 1, var1.TYPE_INDEX do
		local var0 = arg1:Find(tostring(iter0))

		SetActive(var0, arg2 == iter0)
	end
end

function var1.IsActive(arg0)
	return arg0._buffEffect ~= nil
end

function var1.Casting(arg0, arg1)
	LeanTween.cancel(arg0._castClockGO)

	arg0._castClockTF.localScale = Vector3(0.1, 0.1, 1)

	local var0 = arg1.iconType

	arg0:switchToIndex(arg0._bgList, var0)
	arg0:switchToIndex(arg0._danger, var0)
	arg0:switchToIndex(arg0._interrupt, var0)
	arg0:switchToIndex(arg0._casting, var0)
	SetActive(arg0._progressInterrupt, arg1.interrupt)
	SetActive(arg0._progressProtected, not arg1.interrupt)

	arg0._castProgress = arg1.interrupt and arg0._progressInterrupt:GetComponent(typeof(Image)) or arg0._progressProtected:GetComponent(typeof(Image))

	SetActive(arg0._castClockTF, true)
	SetActive(arg0._casting, true)
	SetActive(arg0._interrupt, false)
	LeanTween.scale(rtf(arg0._castClockGO), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeInBack)
	LeanTween.rotate(rtf(arg0._danger), 360, 5):setLoopClamp()

	arg0._buffEffect = arg1.buffEffect
end

function var1.Interrupt(arg0, arg1)
	if arg1.interrupt then
		SetActive(arg0._casting, false)
		SetActive(arg0._interrupt, true)
	end

	LeanTween.cancel(go(arg0._danger))

	for iter0 = 1, 2 do
		LeanTween.alphaCanvas(arg0._clockCG, 0.3, 0.3):setFrom(1):setDelay(0.3 * (iter0 - 1))
		LeanTween.alphaCanvas(arg0._clockCG, 1, 0.3):setDelay(0.3 * iter0)
	end

	LeanTween.scale(rtf(arg0._castClockGO), Vector3.New(0.1, 0.1, 1), 0.3):setEase(LeanTweenType.easeInBack):setDelay(1.25):setOnComplete(System.Action(function()
		arg0._buffEffect = nil

		SetActive(arg0._castClockTF, false)
	end))
end

function var1.UpdateCastClockPosition(arg0, arg1)
	arg0._castClockTF.position = arg1 + var1.OFFSET
end

function var1.UpdateCastClock(arg0)
	arg0._castProgress.fillAmount = arg0._buffEffect:GetCountProgress()
end

function var1.Dispose(arg0)
	arg0._buffEffect = nil

	Object.Destroy(arg0._castClockGO)

	arg0._castClockTF = nil
	arg0._castClockGO = nil
	arg0._castProgress = nil
	arg0._interrupt = nil
	arg0._casting = nil
	arg0._bgList = nil
	arg0._danger = nil
	arg0._progressInterrupt = nil
	arg0._progressProtected = nil
end
