local var0_0 = class("USDefTaskWindowView", import("...base.BaseSubView"))

function var0_0.Load(arg0_1)
	arg0_1._tf = findTF(arg0_1._parentTf, "USDefTaskWindow")
	arg0_1._go = go(arg0_1._tf)

	pg.DelegateInfo.New(arg0_1)
	arg0_1:OnInit()
end

function var0_0.Destroy(arg0_2)
	arg0_2:Hide()
end

function var0_0.OnInit(arg0_3)
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:updateProgress()
	arg0_3:updateTaskList()
	arg0_3:Show()
end

function var0_0.OnDestroy(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	local var0_5 = arg0_5.contextData:getConfig("config_client")[1]

	arg0_5.taskIDList = Clone(pg.task_data_template[var0_5].target_id)
	arg0_5.taskProxy = getProxy(TaskProxy)
	arg0_5.taskVOList = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.taskIDList) do
		local var1_5 = arg0_5.taskProxy:getTaskVO(iter1_5)

		table.insert(arg0_5.taskVOList, var1_5)
	end
end

function var0_0.initUI(arg0_6)
	arg0_6.bg = arg0_6:findTF("BG")
	arg0_6.curNumTextTF = arg0_6:findTF("ProgressPanel/CurNumText")
	arg0_6.totalNumText = arg0_6:findTF("ProgressPanel/TotalNumText")
	arg0_6.taskTpl = arg0_6:findTF("TaskTpl")
	arg0_6.taskContainer = arg0_6:findTF("TaskList/Viewport/Content")
	arg0_6.taskList = UIItemList.New(arg0_6.taskContainer, arg0_6.taskTpl)

	onButton(arg0_6, arg0_6.bg, function()
		arg0_6:Destroy()
	end, SFX_CANCEL)
end

function var0_0.updateProgress(arg0_8)
	local var0_8 = #arg0_8.taskIDList
	local var1_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8.taskVOList) do
		if iter1_8:getTaskStatus() >= 1 then
			var1_8 = var1_8 + 1
		end
	end

	setText(arg0_8.curNumTextTF, string.format("%2d", var1_8))
	setText(arg0_8.totalNumText, string.format("%2d", var0_8))
end

function var0_0.updateTaskList(arg0_9)
	arg0_9.taskList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg1_10 = arg1_10 + 1

			local var0_10 = arg0_9.taskVOList[arg1_10]
			local var1_10 = arg0_9:findTF("IndexText", arg2_10)
			local var2_10 = arg0_9:findTF("TaskIndexText", arg2_10)
			local var3_10 = arg0_9:findTF("DescText", arg2_10)
			local var4_10 = arg0_9:findTF("ItemBG/Icon", arg2_10)
			local var5_10 = arg0_9:findTF("ItemBG/Finished", arg2_10)

			setText(var1_10, string.format("%02d", arg1_10))
			setText(var2_10, "TASK-" .. string.format("%02d", arg1_10))

			local var6_10 = var0_10:getConfig("desc")

			setText(var3_10, var6_10)

			local var7_10 = tonumber(var0_10:getConfig("target_id"))

			if not pg.ship_data_statistics[var7_10] then
				var7_10 = 205054
			end

			local var8_10 = pg.ship_data_statistics[var7_10].skin_id
			local var9_10 = pg.ship_skin_template[var8_10].painting

			LoadImageSpriteAsync("SquareIcon/" .. var9_10, var4_10)

			local var10_10 = var0_10:getTaskStatus()

			setActive(var5_10, var10_10 >= 1)
		end
	end)
	arg0_9.taskList:align(#arg0_9.taskIDList)
end

return var0_0
