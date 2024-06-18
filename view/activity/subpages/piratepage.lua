local var0_0 = class("PiratePage", import("view.base.BaseActivityPage"))

var0_0.PROGRESS_TEXT = "%d/7"
var0_0.DIALOG_DELAY = 15

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.progressText = arg0_1:findTF("Text", arg0_1.progress)
	arg0_1.complete = arg0_1:findTF("complete", arg0_1.bg)
	arg0_1.goBtn = arg0_1:findTF("go_btn", arg0_1.bg)
	arg0_1.red = arg0_1:findTF("red", arg0_1.goBtn)
	arg0_1.dialogTf = arg0_1:findTF("dialog", arg0_1.bg)
	arg0_1.dialogText = arg0_1:findTF("Text", arg0_1.dialogTf)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.count = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_data")
	arg0_2.totoalCount = #arg0_2.taskGroup
	arg0_2.dialog_progress = arg0_2.activity:getConfig("config_client").shipyard_phase_1
	arg0_2.dialog_complete = arg0_2.activity:getConfig("config_client").shipyard_phase_2

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnShowFlush(arg0_3)
	setActive(arg0_3.dialogTf, true)
	setImageAlpha(arg0_3.dialogTf, 1)
	setText(arg0_3.dialogText, not arg0_3.activity:canPermanentFinish() and arg0_3.dialog_progress[math.random(#arg0_3.dialog_progress)] or arg0_3.dialog_complete[math.random(#arg0_3.dialog_complete)])
	LeanTween.alpha(arg0_3.dialogTf, 0, 0.5):setDelay(var0_0.DIALOG_DELAY):setOnComplete(System.Action(function()
		SetActive(arg0_3.dialogTf, false)
	end))
end

function var0_0.OnHideFlush(arg0_5)
	LeanTween.cancel(arg0_5.dialogTf)
end

function var0_0.OnFirstFlush(arg0_6)
	arg0_6.count = arg0_6.activity.data3

	setActive(arg0_6.red, arg0_6:CheckRed())
	onButton(arg0_6, arg0_6.goBtn, function()
		arg0_6:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SECRET_SHIPYARD)
	end, SFX_PANEL)
end

function var0_0.CheckRed(arg0_8)
	local var0_8 = false

	if arg0_8.activity:readyToAchieve() then
		var0_8 = true
	end

	local var1_8 = arg0_8.activity:getNDay()

	if var1_8 < 8 and PlayerPrefs.GetInt("PiratePage" .. var1_8, 0) == 0 then
		PlayerPrefs.SetInt("PiratePage" .. var1_8, 1)

		var0_8 = true
	end

	return var0_8
end

function var0_0.OnUpdateFlush(arg0_9)
	arg0_9.count = arg0_9.activity.data3

	if arg0_9.progress then
		setText(arg0_9.progressText, string.format(var0_0.PROGRESS_TEXT, arg0_9.count))
		setActive(arg0_9.progress, not arg0_9.activity:canPermanentFinish())
		setActive(arg0_9.complete, arg0_9.activity:canPermanentFinish())
	end
end

return var0_0
