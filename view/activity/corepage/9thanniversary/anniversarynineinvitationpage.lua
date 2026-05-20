local var0_0 = class("AnniversaryNineInvitationPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.rtMarks = arg0_1._tf:Find("AD/progress/items")
	arg0_1.rtFinish = arg0_1._tf:Find("AD/award/got")
	arg0_1.rtBtns = arg0_1._tf:Find("AD/btn_list")
	arg0_1.goBtn = arg0_1.rtBtns:Find("go")
	arg0_1.getBtn = arg0_1.rtBtns:Find("get")
	arg0_1.gotBtn = arg0_1.rtBtns:Find("got")
	arg0_1.red = arg0_1.rtBtns:Find("red")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.curDay = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = underscore.flatten(arg0_2.activity:getConfig("config_data"))
	arg0_2.lastTaskId = table.remove(arg0_2.taskGroup)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.goBtn, function()
		local var0_4 = arg0_3.coreActivityUI:GetActivityIdByPageClass("AnniversaryNineGamePage")

		if var0_4 then
			arg0_3.coreActivityUI:verifyTabs(var0_4)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		if arg0_3.finalTaskVO and arg0_3.finalTaskVO:getTaskStatus() == 1 then
			arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.finalTaskVO)
		end
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6:RefreshTaskState()
	arg0_6:RefreshProgress()
	arg0_6:RefreshButtons()
end

function var0_0.RefreshTaskState(arg0_7)
	arg0_7.finalTaskVO = arg0_7.taskProxy:getTaskVO(arg0_7.lastTaskId)
	arg0_7.finishCount = math.max(arg0_7.activity.data3, 1) - (underscore.all(arg0_7.taskGroup, function(arg0_8)
		local var0_8 = arg0_7.taskProxy:getTaskVO(arg0_8)

		return not var0_8 or var0_8:isReceive()
	end) and 0 or 1)
end

function var0_0.RefreshProgress(arg0_9)
	local var0_9 = arg0_9.rtMarks.childCount
	local var1_9 = math.min(arg0_9.finishCount, var0_9)

	for iter0_9 = 1, var0_9 do
		local var2_9 = arg0_9.rtMarks:GetChild(iter0_9 - 1)

		setActive(var2_9:Find("mark"), iter0_9 <= var1_9)
	end
end

function var0_0.RefreshButtons(arg0_10)
	local var0_10 = arg0_10.finalTaskVO and arg0_10.finalTaskVO:getTaskStatus() or 0
	local var1_10 = var0_10 == 1
	local var2_10 = var0_10 == 2

	setActive(arg0_10.goBtn, var0_10 == 0)

	if var1_10 then
		onButton(arg0_10, arg0_10.getBtn, function()
			if arg0_10.finalTaskVO and arg0_10.finalTaskVO:getTaskStatus() == 1 then
				arg0_10:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_10.finalTaskVO)
			end
		end, SFX_PANEL)
	end

	setActive(arg0_10.getBtn, var1_10)
	setActive(arg0_10.red, var1_10)
	setActive(arg0_10.gotBtn, var2_10)
	setActive(arg0_10.rtFinish, var2_10)
end

return var0_0
