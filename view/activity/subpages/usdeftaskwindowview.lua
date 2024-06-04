local var0 = class("USDefTaskWindowView", import("...base.BaseSubView"))

function var0.Load(arg0)
	arg0._tf = findTF(arg0._parentTf, "USDefTaskWindow")
	arg0._go = go(arg0._tf)

	pg.DelegateInfo.New(arg0)
	arg0:OnInit()
end

function var0.Destroy(arg0)
	arg0:Hide()
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateProgress()
	arg0:updateTaskList()
	arg0:Show()
end

function var0.OnDestroy(arg0)
	return
end

function var0.initData(arg0)
	local var0 = arg0.contextData:getConfig("config_client")[1]

	arg0.taskIDList = Clone(pg.task_data_template[var0].target_id)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskVOList = {}

	for iter0, iter1 in ipairs(arg0.taskIDList) do
		local var1 = arg0.taskProxy:getTaskVO(iter1)

		table.insert(arg0.taskVOList, var1)
	end
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.curNumTextTF = arg0:findTF("ProgressPanel/CurNumText")
	arg0.totalNumText = arg0:findTF("ProgressPanel/TotalNumText")
	arg0.taskTpl = arg0:findTF("TaskTpl")
	arg0.taskContainer = arg0:findTF("TaskList/Viewport/Content")
	arg0.taskList = UIItemList.New(arg0.taskContainer, arg0.taskTpl)

	onButton(arg0, arg0.bg, function()
		arg0:Destroy()
	end, SFX_CANCEL)
end

function var0.updateProgress(arg0)
	local var0 = #arg0.taskIDList
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.taskVOList) do
		if iter1:getTaskStatus() >= 1 then
			var1 = var1 + 1
		end
	end

	setText(arg0.curNumTextTF, string.format("%2d", var1))
	setText(arg0.totalNumText, string.format("%2d", var0))
end

function var0.updateTaskList(arg0)
	arg0.taskList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = arg0.taskVOList[arg1]
			local var1 = arg0:findTF("IndexText", arg2)
			local var2 = arg0:findTF("TaskIndexText", arg2)
			local var3 = arg0:findTF("DescText", arg2)
			local var4 = arg0:findTF("ItemBG/Icon", arg2)
			local var5 = arg0:findTF("ItemBG/Finished", arg2)

			setText(var1, string.format("%02d", arg1))
			setText(var2, "TASK-" .. string.format("%02d", arg1))

			local var6 = var0:getConfig("desc")

			setText(var3, var6)

			local var7 = tonumber(var0:getConfig("target_id"))

			if not pg.ship_data_statistics[var7] then
				var7 = 205054
			end

			local var8 = pg.ship_data_statistics[var7].skin_id
			local var9 = pg.ship_skin_template[var8].painting

			LoadImageSpriteAsync("SquareIcon/" .. var9, var4)

			local var10 = var0:getTaskStatus()

			setActive(var5, var10 >= 1)
		end
	end)
	arg0.taskList:align(#arg0.taskIDList)
end

return var0
