local var0 = class("UnicornStardustPage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.textProgress = arg0.bg:Find("progress_text")
	arg0.btnGo = arg0.bg:Find("btn_go")
	arg0.got = arg0.bg:Find("got")
end

function var0.OnDataSetting(arg0)
	local var0 = getProxy(TaskProxy)

	arg0.taskList = arg0.activity:getConfig("config_data")
	arg0.taskIndex = #arg0.taskList
	arg0.taskVO = nil

	while arg0.taskIndex > 0 do
		arg0.taskVO = var0:getTaskVO(arg0.taskList[arg0.taskIndex])

		if arg0.taskVO then
			break
		end

		arg0.taskIndex = arg0.taskIndex - 1
	end
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.btnGo, function()
		if arg0.taskVO and not arg0.taskVO:isReceive() then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
		else
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NAVALACADEMYSCENE)
		end
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	setText(arg0.textProgress, arg0.taskIndex .. "/" .. #arg0.taskList)
	setButtonEnabled(arg0.btnGo, arg0.taskIndex < #arg0.taskList)
	setActive(arg0.got, arg0.taskIndex == #arg0.taskList)
end

function var0.OnDestroy(arg0)
	return
end

return var0
