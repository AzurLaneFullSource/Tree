local var0_0 = class("UrExchangeTaskPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.uilist = UIItemList.New(arg0_1:findTF("AD/task_list/content"), arg0_1:findTF("AD/task_list/content/tpl"))
	arg0_1.getBtn = arg0_1:findTF("AD/get_btn")
	arg0_1.gotBtn = arg0_1:findTF("AD/got_btn")
	arg0_1.unfinishBtn = arg0_1:findTF("AD/unfinish_btn")
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity
	local var1_2 = var0_2:getConfig("config_data")[1][1]

	if not arg0_2:GetTaskById(var1_2) then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = var0_2.id
		})

		return true
	else
		return false
	end
end

function var0_0.OnUpdateFlush(arg0_3)
	local var0_3 = arg0_3.activity:getConfig("config_data")[1]
	local var1_3 = _.map(var0_3, function(arg0_4)
		return arg0_3:GetTaskById(arg0_4)
	end)
	local var2_3 = table.remove(var1_3, #var1_3)

	local function var3_3(arg0_5)
		if arg0_5:isFinish() and not arg0_5:isReceive() then
			return 0
		elseif arg0_5:isReceive() then
			return 2
		else
			return 1
		end
	end

	table.sort(var1_3, function(arg0_6, arg1_6)
		return var3_3(arg0_6) < var3_3(arg1_6)
	end)
	arg0_3.uilist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_3:UpdateTask(arg2_7, var1_3[arg1_7 + 1])
		end
	end)
	arg0_3.uilist:align(#var1_3)

	local var4_3 = var2_3:isFinish()
	local var5_3 = var2_3:isReceive()
	local var6_3 = _.all(var1_3, function(arg0_8)
		return arg0_8:isFinish() and arg0_8:isReceive()
	end)
	local var7_3 = var4_3 and not var5_3 and var6_3

	onButton(arg0_3, arg0_3.getBtn, function()
		if var7_3 then
			arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, var2_3)
		end
	end, SFX_PANEL)
	setActive(arg0_3.getBtn, var7_3)
	setActive(arg0_3.unfinishBtn, not var7_3 and not var5_3)
	setActive(arg0_3.gotBtn, var5_3)
end

function var0_0.GetTaskById(arg0_10, arg1_10)
	return getProxy(TaskProxy):getTaskById(arg1_10) or getProxy(TaskProxy):getFinishTaskById(arg1_10)
end

function var0_0.UpdateTask(arg0_11, arg1_11, arg2_11)
	assert(arg2_11)
	setText(arg1_11:Find("Text"), arg2_11:getConfig("desc"))

	local var0_11 = arg2_11:getConfig("award_display")[1]

	assert(var0_11, arg2_11.id)
	assert(var0_11)

	local var1_11 = {
		type = var0_11[1],
		id = var0_11[2],
		count = var0_11[3]
	}
	local var2_11 = arg1_11:Find("item")

	updateDrop(var2_11, var1_11)
	onButton(arg0_11, var2_11, function()
		arg0_11:emit(BaseUI.ON_DROP, var1_11)
	end, SFX_PANEL)

	local var3_11 = arg2_11:isFinish()
	local var4_11 = arg2_11:isReceive()

	setActive(arg1_11:Find("mark"), var3_11 and not var4_11)

	if var3_11 and not var4_11 then
		onButton(arg0_11, arg1_11, function()
			arg0_11:emit(ActivityMediator.ON_TASK_SUBMIT, arg2_11)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_11)
	end

	setActive(arg1_11:Find("progress_finish"), var3_11 and var4_11)

	local var5_11 = arg2_11:getProgress()
	local var6_11 = arg2_11:getConfig("target_num")

	setSlider(arg1_11:Find("progress"), 0, 1, var5_11 / var6_11)

	local var7_11 = var3_11 and "" or var5_11 .. "/" .. var6_11

	setText(arg1_11:Find("progress/Text"), var7_11)
end

return var0_0
