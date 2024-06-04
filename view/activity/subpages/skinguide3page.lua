local var0 = class("SkinGuide3Page", import("...base.BaseActivityPage"))
local var1 = "ui/activityuipage/skinguide3page_atlas"
local var2 = {
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

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.countTF = arg0:findTF("count", arg0.bg)
	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.itemList = UIItemList.New(arg0.items, arg0.item)
end

function var0.OnDataSetting(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskList = arg0.activity:getConfig("config_data")
	arg0.totalCnt = #arg0.taskList
end

function var0.OnFirstFlush(arg0)
	arg0.usedCnt = arg0.activity:getData1()
	arg0.unlockCnt = pg.TimeMgr.GetInstance():DiffDay(arg0.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0.unlockCnt = arg0.unlockCnt > arg0.totalCnt and arg0.totalCnt or arg0.unlockCnt
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt

	setActive(arg0.item, false)
	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		local var0 = arg0.taskList[arg1]
		local var1 = arg0.taskProxy:getTaskById(var0) or arg0.taskProxy:getFinishTaskById(var0)

		assert(var1, "without this task by id: " .. var0)

		if arg0 == UIItemList.EventInit then
			local var2 = arg0:findTF("item", arg2)

			arg2.anchoredPosition = Vector2(var2[arg1][1], var2[arg1][2])

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
			local var7 = arg0:findTF("get", arg2)

			setActive(var7, var5 == 1 and arg0.remainCnt > 0)
			setActive(var6, var5 == 2)
			onButton(arg0, var7, function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var1)
			end, SFX_PANEL)
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.taskList) do
		if arg0.taskProxy:getFinishTaskById(iter1) ~= nil then
			var0 = var0 + 1
		end
	end

	if arg0.usedCnt ~= var0 then
		arg0.usedCnt = var0

		local var1 = arg0.activity

		var1.data1 = arg0.usedCnt

		getProxy(ActivityProxy):updateActivity(var1)
	end

	arg0.unlockCnt = (pg.TimeMgr.GetInstance():DiffDay(arg0.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1) * arg0.activity:getConfig("config_id")
	arg0.unlockCnt = arg0.unlockCnt > arg0.totalCnt and arg0.totalCnt or arg0.unlockCnt
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt

	setText(arg0.countTF, string.format("%02d", arg0.remainCnt))

	local var2 = arg0.activity:getConfig("config_client").story

	for iter2, iter3 in ipairs(arg0.taskList) do
		if arg0.taskProxy:getFinishTaskById(iter3) and checkExist(var2, {
			iter2
		}, {
			1
		}) then
			pg.NewStoryMgr.GetInstance():Play(var2[iter2][1])
		end
	end

	arg0.itemList:align(#arg0.taskList)
end

function var0.OnLoadLayers(arg0)
	arg0.itemList:each(function(arg0, arg1)
		setActive(arg1, false)
	end)
end

function var0.OnRemoveLayers(arg0)
	arg0.itemList:each(function(arg0, arg1)
		setActive(arg1, true)
	end)
end

function var0.OnShowFlush(arg0)
	arg0.itemList:each(function(arg0, arg1)
		setActive(arg1, true)
	end)
end

function var0.OnDestroy(arg0)
	return
end

return var0
