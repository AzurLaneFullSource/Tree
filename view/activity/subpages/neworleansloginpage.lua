local var0 = class("NewOrleansLoginPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.showItemTpl = arg0:findTF("ShowItem", arg0.bg)
	arg0.showItemContainer = arg0:findTF("ItemShowList", arg0.bg)
	arg0.itemList = UIItemList.New(arg0.showItemContainer, arg0.showItemTpl)

	setActive(arg0.showItemTpl, false)

	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)

	setActive(arg0.item, false)

	arg0.stepText = arg0:findTF("step_text", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_client").act_id

	arg0.linkActivity = getProxy(ActivityProxy):getActivityById(var0)
	arg0.nday = 0
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskGroup = arg0.linkActivity:getConfig("config_data")
	arg0.config = pg.activity_7_day_sign[arg0.activity:getConfig("config_id")]
	arg0.Day = #arg0.config.front_drops
	arg0.curDay = 0

	return updateActivityTaskStatus(arg0.linkActivity)
end

function var0.OnFirstFlush(arg0)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0:findTF("item", arg2)
			local var2 = arg0.taskGroup[arg0.nday][var0]
			local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

			assert(var3, "without this task by id: " .. var2)

			local var4 = var3:getConfig("award_display")[1]
			local var5 = {
				type = var4[1],
				id = var4[2],
				count = var4[3]
			}

			updateDrop(var1, var5)
			onButton(arg0, var1, function()
				arg0:emit(BaseUI.ON_DROP, var5)
			end, SFX_PANEL)

			local var6 = var3:getProgress()
			local var7 = var3:getConfig("target_num")

			setText(arg0:findTF("description", arg2), var3:getConfig("desc"))
			setText(arg0:findTF("progressText", arg2), var6 .. "/" .. var7)
			setSlider(arg0:findTF("progress", arg2), 0, var7, var6)

			local var8 = arg0:findTF("go_btn", arg2)
			local var9 = arg0:findTF("get_btn", arg2)
			local var10 = arg0:findTF("got_btn", arg2)
			local var11 = var3:getTaskStatus()

			setActive(var8, var11 == 0)
			setActive(var9, var11 == 1)
			setActive(var10, var11 == 2)
			onButton(arg0, var8, function()
				arg0:emit(ActivityMediator.ON_TASK_GO, var3)
			end, SFX_PANEL)
			onButton(arg0, var9, function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
			end, SFX_PANEL)
		end
	end)
	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg0.config.front_drops[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		elseif arg0 == UIItemList.EventUpdate then
			local var2 = arg0:findTF("icon_mask", arg2)

			setActive(var2, arg1 < arg0.curDay)
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.linkActivity.data3

	local var0 = arg0.linkActivity:getConfig("config_client").story

	if checkExist(var0, {
		arg0.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0[arg0.nday][1])
	end

	if arg0.stepText then
		setText(arg0.stepText, tostring(arg0.nday))
	end

	arg0.uilist:align(#arg0.taskGroup[arg0.nday])

	arg0.curDay = arg0.activity.data1

	arg0.itemList:align(arg0.Day)
end

function var0.OnDestroy(arg0)
	return
end

return var0
