local var0 = class("PiratePage", import("view.base.BaseActivityPage"))

var0.PROGRESS_TEXT = "%d/7"
var0.DIALOG_DELAY = 15

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.progress = arg0:findTF("progress", arg0.bg)
	arg0.progressText = arg0:findTF("Text", arg0.progress)
	arg0.complete = arg0:findTF("complete", arg0.bg)
	arg0.goBtn = arg0:findTF("go_btn", arg0.bg)
	arg0.red = arg0:findTF("red", arg0.goBtn)
	arg0.dialogTf = arg0:findTF("dialog", arg0.bg)
	arg0.dialogText = arg0:findTF("Text", arg0.dialogTf)
end

function var0.OnDataSetting(arg0)
	arg0.count = 0
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskGroup = arg0.activity:getConfig("config_data")
	arg0.totoalCount = #arg0.taskGroup
	arg0.dialog_progress = arg0.activity:getConfig("config_client").shipyard_phase_1
	arg0.dialog_complete = arg0.activity:getConfig("config_client").shipyard_phase_2

	return updateActivityTaskStatus(arg0.activity)
end

function var0.OnShowFlush(arg0)
	setActive(arg0.dialogTf, true)
	setImageAlpha(arg0.dialogTf, 1)
	setText(arg0.dialogText, not arg0.activity:canPermanentFinish() and arg0.dialog_progress[math.random(#arg0.dialog_progress)] or arg0.dialog_complete[math.random(#arg0.dialog_complete)])
	LeanTween.alpha(arg0.dialogTf, 0, 0.5):setDelay(var0.DIALOG_DELAY):setOnComplete(System.Action(function()
		SetActive(arg0.dialogTf, false)
	end))
end

function var0.OnHideFlush(arg0)
	LeanTween.cancel(arg0.dialogTf)
end

function var0.OnFirstFlush(arg0)
	arg0.count = arg0.activity.data3

	setActive(arg0.red, arg0:CheckRed())
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SECRET_SHIPYARD)
	end, SFX_PANEL)
end

function var0.CheckRed(arg0)
	local var0 = false

	if arg0.activity:readyToAchieve() then
		var0 = true
	end

	local var1 = arg0.activity:getNDay()

	if var1 < 8 and PlayerPrefs.GetInt("PiratePage" .. var1, 0) == 0 then
		PlayerPrefs.SetInt("PiratePage" .. var1, 1)

		var0 = true
	end

	return var0
end

function var0.OnUpdateFlush(arg0)
	arg0.count = arg0.activity.data3

	if arg0.progress then
		setText(arg0.progressText, string.format(var0.PROGRESS_TEXT, arg0.count))
		setActive(arg0.progress, not arg0.activity:canPermanentFinish())
		setActive(arg0.complete, arg0.activity:canPermanentFinish())
	end
end

return var0
