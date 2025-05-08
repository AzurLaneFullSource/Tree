pg = pg or {}

local var0_0 = pg
local var1_0 = singletonClass("BrightnessMgr")

var0_0.BrightnessMgr = var1_0

local var2_0 = YSNormalTool.BrightnessTool

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

	var2_0.SetBrightnessValue(arg0_3.originalBrightnessValue)
	arg0_3:SetDelayTask()
end

function var1_0.SetDelayTask(arg0_4)
	arg0_4:ClearTask()

	arg0_4.task = Timer.New(function()
		var2_0.SetBrightnessValue(math.min(var1_0.DarkModeBrightness, arg0_4.originalBrightnessValue))
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

	local var0_7 = var2_0.GetBrightnessValue()

	arg0_7.originalBrightnessValue = var0_7

	var2_0.SetBrightnessValue(math.min(var1_0.DarkModeBrightness, var0_7))

	arg0_7.manulStatus = true
end

function var1_0.ExitManualMode(arg0_8)
	if not arg0_8.manulStatus then
		return
	end

	var2_0.SetBrightnessValue(arg0_8.originalBrightnessValue)
	arg0_8:ClearTask()

	arg0_8.manulStatus = false
end

function var1_0.IsPermissionGranted(arg0_9)
	return var2_0.CanWriteSetting()
end

function var1_0.OpenPermissionSettings(arg0_10)
	YSNormalTool.OtherTool.OpenAndroidWriteSettings()
end

function var1_0.RequestPremission(arg0_11, arg1_11)
	arg0_11:OpenPermissionSettings()

	if arg1_11 then
		FrameTimer.New(function()
			arg1_11(arg0_11:IsPermissionGranted())
		end, 2):Start()
	end
end

function var1_0.SetScreenNeverSleep(arg0_13, arg1_13)
	arg1_13 = tobool(arg1_13)

	if arg1_13 then
		if arg0_13.sleepTimeOutCounter == 0 then
			Screen.sleepTimeout = SleepTimeout.NeverSleep
		end

		arg0_13.sleepTimeOutCounter = arg0_13.sleepTimeOutCounter + 1
	else
		arg0_13.sleepTimeOutCounter = arg0_13.sleepTimeOutCounter - 1

		assert(arg0_13.sleepTimeOutCounter >= 0, "InCorrect Call of SetScreenNeverSleep")

		arg0_13.sleepTimeOutCounter = math.max(0, arg0_13.sleepTimeOutCounter)

		if arg0_13.sleepTimeOutCounter == 0 then
			Screen.sleepTimeout = SleepTimeout.SystemSetting
		end
	end
end
