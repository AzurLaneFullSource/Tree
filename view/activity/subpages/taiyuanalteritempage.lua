local var0_0 = class("TaiyuanAlterItemPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.UpdateTask(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1 + 1
	local var1_1 = arg0_1:findTF("item", arg2_1)
	local var2_1 = arg0_1.taskGroup[arg0_1.nday][var0_1]
	local var3_1 = arg0_1.taskProxy:getTaskById(var2_1) or arg0_1.taskProxy:getFinishTaskById(var2_1)

	assert(var3_1, "without this task by id: " .. var2_1)

	local var4_1 = Drop.Create(var3_1:getConfig("award_display")[1])

	updateDrop(var1_1, var4_1)
	onButton(arg0_1, var1_1, function()
		arg0_1:emit(BaseUI.ON_DROP, var4_1)
	end, SFX_PANEL)

	local var5_1 = var3_1:getProgress()
	local var6_1 = var3_1:getConfig("target_num")

	setText(arg0_1:findTF("description", arg2_1), var3_1:getConfig("desc"))

	local var7_1, var8_1 = arg0_1:GetProgressColor()
	local var9_1

	var9_1 = var7_1 and setColorStr(var5_1, var7_1) or var5_1

	local var10_1

	var10_1 = var8_1 and setColorStr("/" .. var6_1, var8_1) or "/" .. var6_1

	setText(arg0_1:findTF("progressText", arg2_1), "<color=#E95545>" .. var9_1 .. "</color><color=#6D8189>" .. var10_1 .. "</color>")
	setSlider(arg0_1:findTF("progress", arg2_1), 0, var6_1, var5_1)

	local var11_1 = arg0_1:findTF("go_btn", arg2_1)
	local var12_1 = arg0_1:findTF("get_btn", arg2_1)
	local var13_1 = arg0_1:findTF("got_btn", arg2_1)
	local var14_1 = var3_1:getTaskStatus()

	setActive(var11_1, var14_1 == 0)
	setActive(var12_1, var14_1 == 1)
	setActive(var13_1, var14_1 == 2)
	onButton(arg0_1, var11_1, function()
		arg0_1:emit(ActivityMediator.ON_TASK_GO, var3_1)
	end, SFX_PANEL)
	onButton(arg0_1, var12_1, function()
		arg0_1:emit(ActivityMediator.ON_TASK_SUBMIT, var3_1)
	end, SFX_PANEL)
end

return var0_0
