local var0 = class("ShioSkinRePage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.dayTF = arg0:findTF("day", arg0.bg)
	arg0.item1TF = arg0:findTF("item1", arg0.bg)
	arg0.item2TF = arg0:findTF("item2", arg0.bg)
	arg0.itemTFList = {
		arg0.item1TF,
		arg0.item2TF
	}
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data3

	local var0 = #arg0.activity:getConfig("config_data")

	if arg0.dayTF then
		setText(arg0.dayTF, arg0.nday .. "/" .. var0)
	end

	local var1 = arg0.activity:getConfig("config_client").story

	if checkExist(var1, {
		arg0.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1[arg0.nday][1])
	end

	for iter0 = 1, 2 do
		local var2 = arg0.itemTFList[iter0]
		local var3 = iter0
		local var4 = arg0:findTF("item", var2)
		local var5 = arg0.taskGroup[arg0.nday][iter0]
		local var6 = arg0.taskProxy:getTaskById(var5) or arg0.taskProxy:getFinishTaskById(var5)

		assert(var6, "without this task by id: " .. var5)

		local var7 = var6:getConfig("award_display")[1]
		local var8 = {
			type = var7[1],
			id = var7[2],
			count = var7[3]
		}

		updateDrop(var4, var8)
		onButton(arg0, var4, function()
			arg0:emit(BaseUI.ON_DROP, var8)
		end, SFX_PANEL)

		local var9 = var6:getProgress()
		local var10 = var6:getConfig("target_num")

		setText(arg0:findTF("description", var2), var6:getConfig("desc"))
		setText(arg0:findTF("progressText", var2), var9 .. "/" .. var10)
		setSlider(arg0:findTF("progress", var2), 0, var10, var9)

		local var11 = arg0:findTF("go_btn", var2)
		local var12 = arg0:findTF("get_btn", var2)
		local var13 = arg0:findTF("got_btn", var2)
		local var14 = var6:getTaskStatus()

		setActive(var11, var14 == 0)
		setActive(var12, var14 == 1)
		setActive(var13, var14 == 2)
		onButton(arg0, var11, function()
			arg0:emit(ActivityMediator.ON_TASK_GO, var6)
		end, SFX_PANEL)
		onButton(arg0, var12, function()
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var6)
		end, SFX_PANEL)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
