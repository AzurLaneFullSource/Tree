local var0 = class("TaiyuanAlterItemPage", import(".TemplatePage.SkinTemplatePage"))

function var0.UpdateTask(arg0, arg1, arg2)
	local var0 = arg1 + 1
	local var1 = arg0:findTF("item", arg2)
	local var2 = arg0.taskGroup[arg0.nday][var0]
	local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

	assert(var3, "without this task by id: " .. var2)

	local var4 = Drop.Create(var3:getConfig("award_display")[1])

	updateDrop(var1, var4)
	onButton(arg0, var1, function()
		arg0:emit(BaseUI.ON_DROP, var4)
	end, SFX_PANEL)

	local var5 = var3:getProgress()
	local var6 = var3:getConfig("target_num")

	setText(arg0:findTF("description", arg2), var3:getConfig("desc"))

	local var7, var8 = arg0:GetProgressColor()
	local var9

	var9 = var7 and setColorStr(var5, var7) or var5

	local var10

	var10 = var8 and setColorStr("/" .. var6, var8) or "/" .. var6

	setText(arg0:findTF("progressText", arg2), "<color=#E95545>" .. var9 .. "</color><color=#6D8189>" .. var10 .. "</color>")
	setSlider(arg0:findTF("progress", arg2), 0, var6, var5)

	local var11 = arg0:findTF("go_btn", arg2)
	local var12 = arg0:findTF("get_btn", arg2)
	local var13 = arg0:findTF("got_btn", arg2)
	local var14 = var3:getTaskStatus()

	setActive(var11, var14 == 0)
	setActive(var12, var14 == 1)
	setActive(var13, var14 == 2)
	onButton(arg0, var11, function()
		arg0:emit(ActivityMediator.ON_TASK_GO, var3)
	end, SFX_PANEL)
	onButton(arg0, var12, function()
		arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
	end, SFX_PANEL)
end

return var0
