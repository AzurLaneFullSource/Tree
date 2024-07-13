local var0_0 = class("SkinKisaragiPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.textProgress = arg0_1.bg:Find("progress_text")
	arg0_1.btnGo = arg0_1.bg:Find("btn_go")
	arg0_1.markGot = arg0_1.bg:Find("got")
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = getProxy(TaskProxy)

	arg0_2.taskList = arg0_2.activity:getConfig("config_data")
	arg0_2.taskIndex = #arg0_2.taskList
	arg0_2.taskVO = nil

	while arg0_2.taskIndex > 0 do
		arg0_2.taskVO = var0_2:getTaskVO(arg0_2.taskList[arg0_2.taskIndex])

		if arg0_2.taskVO then
			break
		end

		arg0_2.taskIndex = arg0_2.taskIndex - 1
	end
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.btnGo, function()
		if arg0_3.taskVO and not arg0_3.taskVO:isReceive() then
			arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
		else
			arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NAVALACADEMYSCENE)
		end
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	setText(arg0_5.textProgress, arg0_5.taskIndex .. "/" .. #arg0_5.taskList)
	setActive(arg0_5.btnGo, arg0_5.taskIndex < #arg0_5.taskList)
	setActive(arg0_5.markGot, arg0_5.taskIndex == #arg0_5.taskList)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
