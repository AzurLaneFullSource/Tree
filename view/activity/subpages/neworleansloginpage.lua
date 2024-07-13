local var0_0 = class("NewOrleansLoginPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.showItemTpl = arg0_1:findTF("ShowItem", arg0_1.bg)
	arg0_1.showItemContainer = arg0_1:findTF("ItemShowList", arg0_1.bg)
	arg0_1.itemList = UIItemList.New(arg0_1.showItemContainer, arg0_1.showItemTpl)

	setActive(arg0_1.showItemTpl, false)

	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)

	setActive(arg0_1.item, false)

	arg0_1.stepText = arg0_1:findTF("step_text", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client").act_id

	arg0_2.linkActivity = getProxy(ActivityProxy):getActivityById(var0_2)
	arg0_2.nday = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.linkActivity:getConfig("config_data")
	arg0_2.config = pg.activity_7_day_sign[arg0_2.activity:getConfig("config_id")]
	arg0_2.Day = #arg0_2.config.front_drops
	arg0_2.curDay = 0

	return updateActivityTaskStatus(arg0_2.linkActivity)
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.uilist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg1_4 + 1
			local var1_4 = arg0_3:findTF("item", arg2_4)
			local var2_4 = arg0_3.taskGroup[arg0_3.nday][var0_4]
			local var3_4 = arg0_3.taskProxy:getTaskById(var2_4) or arg0_3.taskProxy:getFinishTaskById(var2_4)

			assert(var3_4, "without this task by id: " .. var2_4)

			local var4_4 = var3_4:getConfig("award_display")[1]
			local var5_4 = {
				type = var4_4[1],
				id = var4_4[2],
				count = var4_4[3]
			}

			updateDrop(var1_4, var5_4)
			onButton(arg0_3, var1_4, function()
				arg0_3:emit(BaseUI.ON_DROP, var5_4)
			end, SFX_PANEL)

			local var6_4 = var3_4:getProgress()
			local var7_4 = var3_4:getConfig("target_num")

			setText(arg0_3:findTF("description", arg2_4), var3_4:getConfig("desc"))
			setText(arg0_3:findTF("progressText", arg2_4), var6_4 .. "/" .. var7_4)
			setSlider(arg0_3:findTF("progress", arg2_4), 0, var7_4, var6_4)

			local var8_4 = arg0_3:findTF("go_btn", arg2_4)
			local var9_4 = arg0_3:findTF("get_btn", arg2_4)
			local var10_4 = arg0_3:findTF("got_btn", arg2_4)
			local var11_4 = var3_4:getTaskStatus()

			setActive(var8_4, var11_4 == 0)
			setActive(var9_4, var11_4 == 1)
			setActive(var10_4, var11_4 == 2)
			onButton(arg0_3, var8_4, function()
				arg0_3:emit(ActivityMediator.ON_TASK_GO, var3_4)
			end, SFX_PANEL)
			onButton(arg0_3, var9_4, function()
				arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, var3_4)
			end, SFX_PANEL)
		end
	end)
	arg0_3.itemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventInit then
			local var0_8 = arg0_3.config.front_drops[arg1_8 + 1]
			local var1_8 = {
				type = var0_8[1],
				id = var0_8[2],
				count = var0_8[3]
			}

			updateDrop(arg2_8, var1_8)
			onButton(arg0_3, arg2_8, function()
				arg0_3:emit(BaseUI.ON_DROP, var1_8)
			end, SFX_PANEL)
		elseif arg0_8 == UIItemList.EventUpdate then
			local var2_8 = arg0_3:findTF("icon_mask", arg2_8)

			setActive(var2_8, arg1_8 < arg0_3.curDay)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_10)
	arg0_10.nday = arg0_10.linkActivity.data3

	local var0_10 = arg0_10.linkActivity:getConfig("config_client").story

	if checkExist(var0_10, {
		arg0_10.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_10[arg0_10.nday][1])
	end

	if arg0_10.stepText then
		setText(arg0_10.stepText, tostring(arg0_10.nday))
	end

	arg0_10.uilist:align(#arg0_10.taskGroup[arg0_10.nday])

	arg0_10.curDay = arg0_10.activity.data1

	arg0_10.itemList:align(arg0_10.Day)
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
