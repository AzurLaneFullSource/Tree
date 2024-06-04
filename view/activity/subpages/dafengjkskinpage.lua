local var0 = class("DaFengJKSkinPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.getBtn = arg0:findTF("available", arg0.bg)
	arg0.unavailableTF = arg0:findTF("unavailable", arg0.bg)
	arg0.phaseTF = arg0:findTF("phase", arg0.bg)
	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.itemList = UIItemList.New(arg0.items, arg0.item)
end

function var0.OnDataSetting(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskList = arg0.activity:getConfig("config_data")[1]
	arg0.submitVO = nil
end

function var0.OnFirstFlush(arg0)
	setActive(arg0.item, false)
	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		local var0 = arg0.taskList[arg1]
		local var1 = arg0.taskProxy:getTaskById(var0) or arg0.taskProxy:getFinishTaskById(var0)

		assert(var1, "without this task by id: " .. var0)

		if arg0 == UIItemList.EventInit then
			local var2 = arg0:findTF("item", arg2)
			local var3 = var1:getConfig("award_display")[1]
			local var4 = {
				type = var3[1],
				id = var3[2],
				count = var3[3]
			}

			updateDrop(var2, var4)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var4)
			end, SFX_PANEL)
		elseif arg0 == UIItemList.EventUpdate then
			local var5 = var1:getTaskStatus()
			local var6 = arg0:findTF("got", arg2)

			setActive(var6, var5 == 2)
		end
	end)
	onButton(arg0, arg0.getBtn, function()
		if arg0.submitVO then
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, arg0.submitVO)
		end
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.taskList) do
		local var2 = arg0.taskProxy:getTaskById(iter1) or arg0.taskProxy:getFinishTaskById(iter1)

		assert(var2, "without this task by id: " .. iter1)

		if var2:getTaskStatus() == 1 then
			var0 = var0 + 1

			if not arg0.submitVO then
				arg0.submitVO = var2
			end
		end

		if var2:getTaskStatus() == 2 then
			var1 = var1 + 1
		end
	end

	setActive(arg0.getBtn, var0 > 0)
	setActive(arg0.unavailableTF, var0 <= 0)
	eachChild(arg0.phaseTF, function(arg0)
		setActive(arg0, tonumber(arg0.name) <= var0 + var1)
	end)
	arg0.itemList:align(#arg0.taskList)
end

function var0.OnDestroy(arg0)
	return
end

return var0
