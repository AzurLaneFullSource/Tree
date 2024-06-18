pg = pg or {}

local var0_0 = pg
local var1_0 = singletonClass("BrightnessMgr")

var0_0.BrightnessMgr = var1_0
var1_0.AutoIntoDarkModeTime = 10
var1_0.DarkModeBrightness = 0.1
var1_0.BrightnessMode = {
	AUTO_ANDROID = 1,
	MANUAL_ANDROID = 0,
	MANUAL_IOS = 2
}

function var1_0.Init(arg0_1, arg1_1)
	GlobalClickEventMgr.Inst:AddPointerDownFunc(function()
		if not arg0_1.manulStatus then
			return
		end

		arg0_1:AwakeForAWhile()
	end)

	arg0_1.manulStatus = false
	arg0_1.originalBrightnessValue = 0
	arg0_1.originalBrightnessMode = 0
	arg0_1.sleepTimeOutCounter = 0

	arg1_1()
end

function var1_0.AwakeForAWhile(arg0_3)
	if not arg0_3:IsPermissionGranted() then
		arg0_3:ExitManualMode()

		return
	end

	BrightnessHelper.SetScreenBrightness(arg0_3.originalBrightnessValue)
	arg0_3:SetDelayTask()
end

function var1_0.SetDelayTask(arg0_4)
	arg0_4:ClearTask()

	arg0_4.task = Timer.New(function()
		BrightnessHelper.SetScreenBrightness(math.min(var1_0.DarkModeBrightness, arg0_4.originalBrightnessValue))
	end, var1_0.AutoIntoDarkModeTime)

	arg0_4.task:Start()
end

function var1_0.ClearTask(arg0_6)
	if not arg0_6.task then
		return
	end

	arg0_6.task:Stop()

	arg0_6.task = nil
end

function var1_0.EnterManualMode(arg0_7)
	if arg0_7.manulStatus then
		return
	end

	local var0_7 = BrightnessHelper.GetValue()

	arg0_7.originalBrightnessValue = var0_7

	BrightnessHelper.SetScreenBrightness(math.min(var1_0.DarkModeBrightness, var0_7))

	arg0_7.manulStatus = true
end

function var1_0.ExitManualMode(arg0_8)
	if not arg0_8.manulStatus then
		return
	end

	BrightnessHelper.SetScreenBrightness(arg0_8.originalBrightnessValue)
	arg0_8:ClearTask()

	arg0_8.manulStatus = false
end

function var1_0.IsPermissionGranted(arg0_9)
	return BrightnessHelper.IsHavePermission()
end

function var1_0.RequestPremission(arg0_10, arg1_10)
	BrightnessHelper.SetScreenBrightness(BrightnessHelper.GetValue())

	if arg1_10 then
		FrameTimer.New(function()
			arg1_10(arg0_10:IsPermissionGranted())
		end, 2):Start()
	end
end

function var1_0.SetScreenNeverSleep(arg0_12, arg1_12)
	arg1_12 = tobool(arg1_12)

	if arg1_12 then
		if arg0_12.sleepTimeOutCounter == 0 then
			Screen.sleepTimeout = SleepTimeout.NeverSleep
		end

		arg0_12.sleepTimeOutCounter = arg0_12.sleepTimeOutCounter + 1
	else
		arg0_12.sleepTimeOutCounter = arg0_12.sleepTimeOutCounter - 1

		assert(arg0_12.sleepTimeOutCounter >= 0, "InCorrect Call of SetScreenNeverSleep")

		arg0_12.sleepTimeOutCounter = math.max(0, arg0_12.sleepTimeOutCounter)

		if arg0_12.sleepTimeOutCounter == 0 then
			Screen.sleepTimeout = SleepTimeout.SystemSetting
		end
	end
end
