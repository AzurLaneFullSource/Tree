local var0_0 = class("DaFengJKSkinPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.getBtn = arg0_1:findTF("available", arg0_1.bg)
	arg0_1.unavailableTF = arg0_1:findTF("unavailable", arg0_1.bg)
	arg0_1.phaseTF = arg0_1:findTF("phase", arg0_1.bg)
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskList = arg0_2.activity:getConfig("config_data")[1]
	arg0_2.submitVO = nil
end

function var0_0.OnFirstFlush(arg0_3)
	setActive(arg0_3.item, false)
	arg0_3.itemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		local var0_4 = arg0_3.taskList[arg1_4]
		local var1_4 = arg0_3.taskProxy:getTaskById(var0_4) or arg0_3.taskProxy:getFinishTaskById(var0_4)

		assert(var1_4, "without this task by id: " .. var0_4)

		if arg0_4 == UIItemList.EventInit then
			local var2_4 = arg0_3:findTF("item", arg2_4)
			local var3_4 = var1_4:getConfig("award_display")[1]
			local var4_4 = {
				type = var3_4[1],
				id = var3_4[2],
				count = var3_4[3]
			}

			updateDrop(var2_4, var4_4)
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(BaseUI.ON_DROP, var4_4)
			end, SFX_PANEL)
		elseif arg0_4 == UIItemList.EventUpdate then
			local var5_4 = var1_4:getTaskStatus()
			local var6_4 = arg0_3:findTF("got", arg2_4)

			setActive(var6_4, var5_4 == 2)
		end
	end)
	onButton(arg0_3, arg0_3.getBtn, function()
		if arg0_3.submitVO then
			arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.submitVO)
		end
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_7)
	local var0_7 = 0
	local var1_7 = 0

	for iter0_7, iter1_7 in ipairs(arg0_7.taskList) do
		local var2_7 = arg0_7.taskProxy:getTaskById(iter1_7) or arg0_7.taskProxy:getFinishTaskById(iter1_7)

		assert(var2_7, "without this task by id: " .. iter1_7)

		if var2_7:getTaskStatus() == 1 then
			var0_7 = var0_7 + 1

			if not arg0_7.submitVO then
				arg0_7.submitVO = var2_7
			end
		end

		if var2_7:getTaskStatus() == 2 then
			var1_7 = var1_7 + 1
		end
	end

	setActive(arg0_7.getBtn, var0_7 > 0)
	setActive(arg0_7.unavailableTF, var0_7 <= 0)
	eachChild(arg0_7.phaseTF, function(arg0_8)
		setActive(arg0_8, tonumber(arg0_8.name) <= var0_7 + var1_7)
	end)
	arg0_7.itemList:align(#arg0_7.taskList)
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
