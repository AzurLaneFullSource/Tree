local var0 = class("SkinTemplatePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.dayTF = arg0:findTF("day", arg0.bg)
	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)

	setActive(arg0.item, false)
end

function var0.OnDataSetting(arg0)
	arg0.nday = 0
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskGroup = arg0.activity:getConfig("config_data")

	return updateActivityTaskStatus(arg0.activity)
end

function var0.OnFirstFlush(arg0)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTask(arg1, arg2)
		end
	end)
end

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

	setText(arg0:findTF("progressText", arg2), var9 .. var10)
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

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data3

	arg0:PlayStory()

	if arg0.dayTF then
		setText(arg0.dayTF, tostring(arg0.nday))
	end

	arg0.uilist:align(#arg0.taskGroup[arg0.nday])
end

function var0.PlayStory(arg0)
	local var0 = arg0.activity:getConfig("config_client").story

	if checkExist(var0, {
		arg0.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0[arg0.nday][1])
	end
end

function var0.OnDestroy(arg0)
	eachChild(arg0.items, function(arg0)
		Destroy(arg0)
	end)
end

function var0.GetProgressColor(arg0)
	return nil
end

return var0
