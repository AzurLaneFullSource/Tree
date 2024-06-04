local var0 = class("IslandHistoryPage")
local var1 = 8
local var2 = {
	{
		-291,
		-6
	},
	{
		-408,
		25
	},
	{
		0,
		0
	},
	{
		-428,
		157
	},
	{
		-341,
		15
	},
	{
		0,
		0
	},
	{
		-414,
		48
	},
	{
		0,
		0
	}
}
local var3 = {
	{
		0,
		0,
		-118
	},
	{
		0,
		0,
		-172
	},
	{
		0,
		0,
		0
	},
	{
		0,
		0,
		-121
	},
	{
		0,
		0,
		-163
	},
	{
		0,
		0,
		0
	},
	{
		0,
		0,
		-256
	},
	{
		0,
		0,
		0
	}
}

function var0.Ctor(arg0, arg1, arg2)
	arg0.historyPage = arg1
	arg0.event = arg2
	arg0.activityId = ActivityConst.ISLAND_TASK_ID
	arg0.finishTasks = getProxy(ActivityTaskProxy):getFinishTasksByActId(arg0.activityId)
	arg0.mapDataList = pg.activity_template[arg0.activityId].config_client.map_event_list or {}
	arg0.pageItemContent = findTF(arg0.historyPage, "selectPanel/page")
	arg0.pageItemTpl = findTF(arg0.historyPage, "selectPanel/page/pageItemTpl")

	setActive(arg0.pageItemTpl, false)

	arg0.mapPic = findTF(arg0.historyPage, "pic")
	arg0.mapTitle = findTF(arg0.historyPage, "title/desc")
	arg0.taskDesc = findTF(arg0.historyPage, "taskDesc")

	setText(arg0.taskDesc, i18n(IslandTaskScene.island_history_desc))

	arg0.pageItemTfs = {}

	for iter0 = 1, var1 do
		local var0 = iter0
		local var1 = tf(instantiate(arg0.pageItemTpl))

		setParent(var1, arg0.pageItemContent)
		setActive(var1, true)
		onButton(arg0.event, var1, function()
			arg0:selectedPage(var0)
		end, SFX_UI_CLICK)
		table.insert(arg0.pageItemTfs, var1)
	end

	arg0.startIndex = 0
	arg0.taskList = {}
	arg0.listConent = findTF(arg0.historyPage, "listPanel/viewcontent/content")
	arg0.taskListTpl = findTF(arg0.historyPage, "listPanel/viewcontent/content/listTpl")

	setActive(arg0.taskListTpl, false)

	arg0.gotTf = findTF(arg0.historyPage, "got")
	arg0.finalAward = findTF(arg0.historyPage, "finalAward")

	arg0:initPageUI()
	arg0:selectedPage(1)
end

function var0.selectedPage(arg0, arg1)
	if arg0.startIndex + arg1 > #arg0.mapDataList then
		return
	end

	arg0:updatePage(arg1)
	arg0:updateMap(arg1)
end

function var0.initPageUI(arg0)
	for iter0 = 1, var1 do
		local var0 = arg0.startIndex + iter0

		setText(findTF(arg0.pageItemTfs[iter0], "num"), tostring(var0))
		setActive(findTF(arg0.pageItemTfs[iter0], "lock"), var0 > #arg0.mapDataList)
		setActive(arg0.pageItemTfs[iter0], var0 <= #arg0.mapDataList)
		setActive(findTF(arg0.pageItemTfs[iter0], "selected"), false)

		local var1 = setColorStr(var0, "#c57053")

		setText(findTF(arg0.pageItemTfs[iter0], "num"), var1)
	end
end

function var0.updatePage(arg0, arg1)
	local var0

	if arg0.selectedPageItem then
		setActive(findTF(arg0.selectedPageItem, "selected"), false)

		local var1 = setColorStr(arg0.selectedIndex, "#c57053")

		setText(findTF(arg0.selectedPageItem, "num"), var1)
	end

	arg0.selectedPageItem = arg0.pageItemTfs[arg1]
	arg0.selectedIndex = arg1

	setActive(findTF(arg0.selectedPageItem, "selected"), true)

	local var2 = setColorStr(arg0.selectedIndex, "#84412A")

	setText(findTF(arg0.selectedPageItem, "num"), var2)
end

function var0.updateMap(arg0, arg1)
	local var0 = arg1 + arg0.startIndex

	arg0.showMapId = arg0.mapDataList[var0]

	local var1 = pg.activity_map_event_list[arg0.showMapId]

	arg0.mapIndex = var1.area

	setImageSprite(arg0.mapPic, LoadSprite(IslandTaskScene.ui_atlas, "map_" .. arg0.mapIndex), true)
	setImageSprite(arg0.mapTitle, LoadSprite(IslandTaskScene.ui_atlas, "map_" .. arg0.mapIndex .. "_desc"), true)

	arg0.taskDatas = var1.open_task

	local var2 = #arg0.taskDatas - #arg0.taskList

	if var2 > 0 then
		arg0:addTaskList(var2)
	end

	local var3 = true

	for iter0 = 1, #arg0.taskList do
		local var4 = arg0.taskList[iter0]

		if iter0 <= #arg0.taskDatas then
			setActive(var4, true)

			local var5 = pg.task_data_template[arg0.taskDatas[iter0]]

			setText(findTF(var4, "text"), var5.name)

			local var6 = arg0:checkTaskFinish(var5.id)

			if var3 and var6 ~= var3 then
				var3 = false
			end

			setActive(findTF(var4, "tag/complete"), var6)
		else
			setActive(var4, false)
		end
	end

	local var7 = getProxy(IslandProxy):GetNode(arg0.showMapId):IsCompleted()

	print("mapId :" .. arg0.showMapId .. " get flag = " .. tostring(var7))
	setActive(arg0.finalAward, var3 and not var7)
	setActive(arg0.gotTf, var3 and var7)
	setLocalPosition(findTF(arg0.historyPage, "finalAward"), Vector3(var2[arg0.mapIndex][1], var2[arg0.mapIndex][2], var2[arg0.mapIndex][3]))
	setLocalEulerAngles(findTF(arg0.historyPage, "finalAward/arrow"), Vector3(var3[arg0.mapIndex][1], var3[arg0.mapIndex][2], var3[arg0.mapIndex][3]))
end

function var0.addTaskList(arg0, arg1)
	for iter0 = 1, arg1 do
		local var0 = tf(instantiate(arg0.taskListTpl))

		setActive(var0, false)
		setParent(var0, arg0.listConent)
		table.insert(arg0.taskList, var0)
	end
end

function var0.checkTaskFinish(arg0, arg1)
	for iter0 = 1, #arg0.finishTasks do
		if arg0.finishTasks[iter0].id == arg1 then
			return true
		end
	end

	return false
end

function var0.setActive(arg0, arg1)
	setActive(arg0.historyPage, arg1)
end

function var0.dispose(arg0)
	return
end

return var0
