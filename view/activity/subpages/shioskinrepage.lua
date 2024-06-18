local var0_0 = class("ShioSkinRePage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.dayTF = arg0_1:findTF("day", arg0_1.bg)
	arg0_1.item1TF = arg0_1:findTF("item1", arg0_1.bg)
	arg0_1.item2TF = arg0_1:findTF("item2", arg0_1.bg)
	arg0_1.itemTFList = {
		arg0_1.item1TF,
		arg0_1.item2TF
	}
end

function var0_0.OnFirstFlush(arg0_2)
	return
end

function var0_0.OnUpdateFlush(arg0_3)
	arg0_3.nday = arg0_3.activity.data3

	local var0_3 = #arg0_3.activity:getConfig("config_data")

	if arg0_3.dayTF then
		setText(arg0_3.dayTF, arg0_3.nday .. "/" .. var0_3)
	end

	local var1_3 = arg0_3.activity:getConfig("config_client").story

	if checkExist(var1_3, {
		arg0_3.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1_3[arg0_3.nday][1])
	end

	for iter0_3 = 1, 2 do
		local var2_3 = arg0_3.itemTFList[iter0_3]
		local var3_3 = iter0_3
		local var4_3 = arg0_3:findTF("item", var2_3)
		local var5_3 = arg0_3.taskGroup[arg0_3.nday][iter0_3]
		local var6_3 = arg0_3.taskProxy:getTaskById(var5_3) or arg0_3.taskProxy:getFinishTaskById(var5_3)

		assert(var6_3, "without this task by id: " .. var5_3)

		local var7_3 = var6_3:getConfig("award_display")[1]
		local var8_3 = {
			type = var7_3[1],
			id = var7_3[2],
			count = var7_3[3]
		}

		updateDrop(var4_3, var8_3)
		onButton(arg0_3, var4_3, function()
			arg0_3:emit(BaseUI.ON_DROP, var8_3)
		end, SFX_PANEL)

		local var9_3 = var6_3:getProgress()
		local var10_3 = var6_3:getConfig("target_num")

		setText(arg0_3:findTF("description", var2_3), var6_3:getConfig("desc"))
		setText(arg0_3:findTF("progressText", var2_3), var9_3 .. "/" .. var10_3)
		setSlider(arg0_3:findTF("progress", var2_3), 0, var10_3, var9_3)

		local var11_3 = arg0_3:findTF("go_btn", var2_3)
		local var12_3 = arg0_3:findTF("get_btn", var2_3)
		local var13_3 = arg0_3:findTF("got_btn", var2_3)
		local var14_3 = var6_3:getTaskStatus()

		setActive(var11_3, var14_3 == 0)
		setActive(var12_3, var14_3 == 1)
		setActive(var13_3, var14_3 == 2)
		onButton(arg0_3, var11_3, function()
			arg0_3:emit(ActivityMediator.ON_TASK_GO, var6_3)
		end, SFX_PANEL)
		onButton(arg0_3, var12_3, function()
			arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, var6_3)
		end, SFX_PANEL)
	end
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
