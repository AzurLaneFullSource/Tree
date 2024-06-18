local var0_0 = class("SkinGuide4Page", import("...base.BaseActivityPage"))
local var1_0 = "ui/activityuipage/skinguide3page_atlas"
local var2_0 = {
	{
		50,
		-50
	},
	{
		426,
		-50
	},
	{
		794,
		-50
	}
}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.countTF = arg0_1:findTF("count", arg0_1.bg)
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskList = arg0_2.activity:getConfig("config_data")
	arg0_2.totalCnt = #arg0_2.taskList
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.usedCnt = arg0_3.activity:getData1()
	arg0_3.unlockCnt = pg.TimeMgr.GetInstance():DiffDay(arg0_3.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0_3.unlockCnt = arg0_3.unlockCnt > arg0_3.totalCnt and arg0_3.totalCnt or arg0_3.unlockCnt
	arg0_3.remainCnt = arg0_3.usedCnt >= arg0_3.totalCnt and 0 or arg0_3.unlockCnt - arg0_3.usedCnt

	setActive(arg0_3.item, false)
	arg0_3.itemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		local var0_4 = arg0_3.taskList[arg1_4]
		local var1_4 = arg0_3.taskProxy:getTaskById(var0_4) or arg0_3.taskProxy:getFinishTaskById(var0_4)

		assert(var1_4, "without this task by id: " .. var0_4)

		if arg0_4 == UIItemList.EventInit then
			local var2_4 = arg0_3:findTF("item", arg2_4)

			arg2_4.anchoredPosition = Vector2(var2_0[arg1_4][1], var2_0[arg1_4][2])

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
			local var7_4 = arg0_3:findTF("get", arg2_4)

			setActive(var7_4, var5_4 == 1 and arg0_3.remainCnt > 0)
			setActive(var6_4, var5_4 == 2)
			onButton(arg0_3, var7_4, function()
				arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, var1_4)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_7)
	local var0_7 = 0

	for iter0_7, iter1_7 in ipairs(arg0_7.taskList) do
		if arg0_7.taskProxy:getFinishTaskById(iter1_7) ~= nil then
			var0_7 = var0_7 + 1
		end
	end

	if arg0_7.usedCnt ~= var0_7 then
		arg0_7.usedCnt = var0_7

		local var1_7 = arg0_7.activity

		var1_7.data1 = arg0_7.usedCnt

		getProxy(ActivityProxy):updateActivity(var1_7)
	end

	arg0_7.unlockCnt = (pg.TimeMgr.GetInstance():DiffDay(arg0_7.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1) * arg0_7.activity:getConfig("config_id")
	arg0_7.unlockCnt = arg0_7.unlockCnt > arg0_7.totalCnt and arg0_7.totalCnt or arg0_7.unlockCnt
	arg0_7.remainCnt = arg0_7.usedCnt >= arg0_7.totalCnt and 0 or arg0_7.unlockCnt - arg0_7.usedCnt

	setText(arg0_7.countTF, arg0_7.remainCnt)

	local var2_7 = arg0_7.activity:getConfig("config_client").story

	for iter2_7, iter3_7 in ipairs(arg0_7.taskList) do
		if arg0_7.taskProxy:getFinishTaskById(iter3_7) and checkExist(var2_7, {
			iter2_7
		}, {
			1
		}) then
			pg.NewStoryMgr.GetInstance():Play(var2_7[iter2_7][1])
		end
	end

	arg0_7.itemList:align(#arg0_7.taskList)
end

function var0_0.OnLoadLayers(arg0_8)
	arg0_8.itemList:each(function(arg0_9, arg1_9)
		setActive(arg1_9, false)
	end)
end

function var0_0.OnRemoveLayers(arg0_10)
	arg0_10.itemList:each(function(arg0_11, arg1_11)
		setActive(arg1_11, true)
	end)
end

function var0_0.OnShowFlush(arg0_12)
	arg0_12.itemList:each(function(arg0_13, arg1_13)
		setActive(arg1_13, true)
	end)
end

function var0_0.OnDestroy(arg0_14)
	return
end

return var0_0
