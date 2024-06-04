local var0 = class("UrExchangeTaskPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.uilist = UIItemList.New(arg0:findTF("AD/task_list/content"), arg0:findTF("AD/task_list/content/tpl"))
	arg0.getBtn = arg0:findTF("AD/get_btn")
	arg0.gotBtn = arg0:findTF("AD/got_btn")
	arg0.unfinishBtn = arg0:findTF("AD/unfinish_btn")
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity
	local var1 = var0:getConfig("config_data")[1][1]

	if not arg0:GetTaskById(var1) then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = var0.id
		})

		return true
	else
		return false
	end
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity:getConfig("config_data")[1]
	local var1 = _.map(var0, function(arg0)
		return arg0:GetTaskById(arg0)
	end)
	local var2 = table.remove(var1, #var1)

	local function var3(arg0)
		if arg0:isFinish() and not arg0:isReceive() then
			return 0
		elseif arg0:isReceive() then
			return 2
		else
			return 1
		end
	end

	table.sort(var1, function(arg0, arg1)
		return var3(arg0) < var3(arg1)
	end)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTask(arg2, var1[arg1 + 1])
		end
	end)
	arg0.uilist:align(#var1)

	local var4 = var2:isFinish()
	local var5 = var2:isReceive()
	local var6 = _.all(var1, function(arg0)
		return arg0:isFinish() and arg0:isReceive()
	end)
	local var7 = var4 and not var5 and var6

	onButton(arg0, arg0.getBtn, function()
		if var7 then
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var2)
		end
	end, SFX_PANEL)
	setActive(arg0.getBtn, var7)
	setActive(arg0.unfinishBtn, not var7 and not var5)
	setActive(arg0.gotBtn, var5)
end

function var0.GetTaskById(arg0, arg1)
	return getProxy(TaskProxy):getTaskById(arg1) or getProxy(TaskProxy):getFinishTaskById(arg1)
end

function var0.UpdateTask(arg0, arg1, arg2)
	assert(arg2)
	setText(arg1:Find("Text"), arg2:getConfig("desc"))

	local var0 = arg2:getConfig("award_display")[1]

	assert(var0, arg2.id)
	assert(var0)

	local var1 = {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}
	local var2 = arg1:Find("item")

	updateDrop(var2, var1)
	onButton(arg0, var2, function()
		arg0:emit(BaseUI.ON_DROP, var1)
	end, SFX_PANEL)

	local var3 = arg2:isFinish()
	local var4 = arg2:isReceive()

	setActive(arg1:Find("mark"), var3 and not var4)

	if var3 and not var4 then
		onButton(arg0, arg1, function()
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, arg2)
		end, SFX_PANEL)
	else
		removeOnButton(arg1)
	end

	setActive(arg1:Find("progress_finish"), var3 and var4)

	local var5 = arg2:getProgress()
	local var6 = arg2:getConfig("target_num")

	setSlider(arg1:Find("progress"), 0, 1, var5 / var6)

	local var7 = var3 and "" or var5 .. "/" .. var6

	setText(arg1:Find("progress/Text"), var7)
end

return var0
