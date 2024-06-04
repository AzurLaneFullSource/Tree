pg = pg or {}

local var0 = pg
local var1 = singletonClass("BrightnessMgr")

var0.BrightnessMgr = var1
var1.AutoIntoDarkModeTime = 10
var1.DarkModeBrightness = 0.1
var1.BrightnessMode = {
	AUTO_ANDROID = 1,
	MANUAL_ANDROID = 0,
	MANUAL_IOS = 2
}

function var1.Init(arg0, arg1)
	GlobalClickEventMgr.Inst:AddPointerDownFunc(function()
		if not arg0.manulStatus then
			return
		end

		arg0:AwakeForAWhile()
	end)

	arg0.manulStatus = false
	arg0.originalBrightnessValue = 0
	arg0.originalBrightnessMode = 0
	arg0.sleepTimeOutCounter = 0

	arg1()
end

function var1.AwakeForAWhile(arg0)
	if not arg0:IsPermissionGranted() then
		arg0:ExitManualMode()

		return
	end

	BrightnessHelper.SetScreenBrightness(arg0.originalBrightnessValue)
	arg0:SetDelayTask()
end

function var1.SetDelayTask(arg0)
	arg0:ClearTask()

	arg0.task = Timer.New(function()
		BrightnessHelper.SetScreenBrightness(math.min(var1.DarkModeBrightness, arg0.originalBrightnessValue))
	end, var1.AutoIntoDarkModeTime)

	arg0.task:Start()
end

function var1.ClearTask(arg0)
	if not arg0.task then
		return
	end

	arg0.task:Stop()

	arg0.task = nil
end

function var1.EnterManualMode(arg0)
	if arg0.manulStatus then
		return
	end

	local var0 = BrightnessHelper.GetValue()

	arg0.originalBrightnessValue = var0

	BrightnessHelper.SetScreenBrightness(math.min(var1.DarkModeBrightness, var0))

	arg0.manulStatus = true
end

function var1.ExitManualMode(arg0)
	if not arg0.manulStatus then
		return
	end

	BrightnessHelper.SetScreenBrightness(arg0.originalBrightnessValue)
	arg0:ClearTask()

	arg0.manulStatus = false
end

function var1.IsPermissionGranted(arg0)
	return BrightnessHelper.IsHavePermission()
end

function var1.RequestPremission(arg0, arg1)
	BrightnessHelper.SetScreenBrightness(BrightnessHelper.GetValue())

	if arg1 then
		FrameTimer.New(function()
			arg1(arg0:IsPermissionGranted())
		end, 2):Start()
	end
end

function var1.SetScreenNeverSleep(arg0, arg1)
	arg1 = tobool(arg1)

	if arg1 then
		if arg0.sleepTimeOutCounter == 0 then
			Screen.sleepTimeout = SleepTimeout.NeverSleep
		end

		arg0.sleepTimeOutCounter = arg0.sleepTimeOutCounter + 1
	else
		arg0.sleepTimeOutCounter = arg0.sleepTimeOutCounter - 1

		assert(arg0.sleepTimeOutCounter >= 0, "InCorrect Call of SetScreenNeverSleep")

		arg0.sleepTimeOutCounter = math.max(0, arg0.sleepTimeOutCounter)

		if arg0.sleepTimeOutCounter == 0 then
			Screen.sleepTimeout = SleepTimeout.SystemSetting
		end
	end
end
