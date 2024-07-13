ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffClock = class("BattleBuffClock")
var0_0.Battle.BattleBuffClock.__name = "BattleBuffClock"

local var1_0 = var0_0.Battle.BattleBuffClock

var1_0.OFFSET = Vector3(1.8, 2.3, 0)
var1_0.TYPE_INDEX = 3

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._castClockTF = arg1_1
	arg0_1._castClockGO = arg0_1._castClockTF.gameObject
	arg0_1._bgList = arg0_1._castClockTF:Find("bg")
	arg0_1._danger = arg0_1._castClockTF:Find("danger")
	arg0_1._interrupt = arg0_1._castClockTF:Find("interrupt")
	arg0_1._casting = arg0_1._castClockTF:Find("casting")
	arg0_1._progressProtected = arg0_1._castClockTF:Find("progress/protected")
	arg0_1._progressInterrupt = arg0_1._castClockTF:Find("progress/interrupt")
	arg0_1._clockCG = arg0_1._castClockTF:GetComponent(typeof(CanvasGroup))
end

function var1_0.switchToIndex(arg0_2, arg1_2, arg2_2)
	for iter0_2 = 1, var1_0.TYPE_INDEX do
		local var0_2 = arg1_2:Find(tostring(iter0_2))

		SetActive(var0_2, arg2_2 == iter0_2)
	end
end

function var1_0.IsActive(arg0_3)
	return arg0_3._buffEffect ~= nil
end

function var1_0.Casting(arg0_4, arg1_4)
	LeanTween.cancel(arg0_4._castClockGO)

	arg0_4._castClockTF.localScale = Vector3(0.1, 0.1, 1)

	local var0_4 = arg1_4.iconType

	arg0_4:switchToIndex(arg0_4._bgList, var0_4)
	arg0_4:switchToIndex(arg0_4._danger, var0_4)
	arg0_4:switchToIndex(arg0_4._interrupt, var0_4)
	arg0_4:switchToIndex(arg0_4._casting, var0_4)
	SetActive(arg0_4._progressInterrupt, arg1_4.interrupt)
	SetActive(arg0_4._progressProtected, not arg1_4.interrupt)

	arg0_4._castProgress = arg1_4.interrupt and arg0_4._progressInterrupt:GetComponent(typeof(Image)) or arg0_4._progressProtected:GetComponent(typeof(Image))

	SetActive(arg0_4._castClockTF, true)
	SetActive(arg0_4._casting, true)
	SetActive(arg0_4._interrupt, false)
	LeanTween.scale(rtf(arg0_4._castClockGO), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeInBack)
	LeanTween.rotate(rtf(arg0_4._danger), 360, 5):setLoopClamp()

	arg0_4._buffEffect = arg1_4.buffEffect
end

function var1_0.Interrupt(arg0_5, arg1_5)
	if arg1_5.interrupt then
		SetActive(arg0_5._casting, false)
		SetActive(arg0_5._interrupt, true)
	end

	LeanTween.cancel(go(arg0_5._danger))

	for iter0_5 = 1, 2 do
		LeanTween.alphaCanvas(arg0_5._clockCG, 0.3, 0.3):setFrom(1):setDelay(0.3 * (iter0_5 - 1))
		LeanTween.alphaCanvas(arg0_5._clockCG, 1, 0.3):setDelay(0.3 * iter0_5)
	end

	LeanTween.scale(rtf(arg0_5._castClockGO), Vector3.New(0.1, 0.1, 1), 0.3):setEase(LeanTweenType.easeInBack):setDelay(1.25):setOnComplete(System.Action(function()
		arg0_5._buffEffect = nil

		SetActive(arg0_5._castClockTF, false)
	end))
end

function var1_0.UpdateCastClockPosition(arg0_7, arg1_7)
	arg0_7._castClockTF.position = arg1_7 + var1_0.OFFSET
end

function var1_0.UpdateCastClock(arg0_8)
	arg0_8._castProgress.fillAmount = arg0_8._buffEffect:GetCountProgress()
end

function var1_0.Dispose(arg0_9)
	arg0_9._buffEffect = nil

	Object.Destroy(arg0_9._castClockGO)

	arg0_9._castClockTF = nil
	arg0_9._castClockGO = nil
	arg0_9._castProgress = nil
	arg0_9._interrupt = nil
	arg0_9._casting = nil
	arg0_9._bgList = nil
	arg0_9._danger = nil
	arg0_9._progressInterrupt = nil
	arg0_9._progressProtected = nil
end
