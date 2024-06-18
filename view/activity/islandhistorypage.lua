local var0_0 = class("IslandHistoryPage")
local var1_0 = 8
local var2_0 = {
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
local var3_0 = {
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

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.historyPage = arg1_1
	arg0_1.event = arg2_1
	arg0_1.activityId = ActivityConst.ISLAND_TASK_ID
	arg0_1.finishTasks = getProxy(ActivityTaskProxy):getFinishTasksByActId(arg0_1.activityId)
	arg0_1.mapDataList = pg.activity_template[arg0_1.activityId].config_client.map_event_list or {}
	arg0_1.pageItemContent = findTF(arg0_1.historyPage, "selectPanel/page")
	arg0_1.pageItemTpl = findTF(arg0_1.historyPage, "selectPanel/page/pageItemTpl")

	setActive(arg0_1.pageItemTpl, false)

	arg0_1.mapPic = findTF(arg0_1.historyPage, "pic")
	arg0_1.mapTitle = findTF(arg0_1.historyPage, "title/desc")
	arg0_1.taskDesc = findTF(arg0_1.historyPage, "taskDesc")

	setText(arg0_1.taskDesc, i18n(IslandTaskScene.island_history_desc))

	arg0_1.pageItemTfs = {}

	for iter0_1 = 1, var1_0 do
		local var0_1 = iter0_1
		local var1_1 = tf(instantiate(arg0_1.pageItemTpl))

		setParent(var1_1, arg0_1.pageItemContent)
		setActive(var1_1, true)
		onButton(arg0_1.event, var1_1, function()
			arg0_1:selectedPage(var0_1)
		end, SFX_UI_CLICK)
		table.insert(arg0_1.pageItemTfs, var1_1)
	end

	arg0_1.startIndex = 0
	arg0_1.taskList = {}
	arg0_1.listConent = findTF(arg0_1.historyPage, "listPanel/viewcontent/content")
	arg0_1.taskListTpl = findTF(arg0_1.historyPage, "listPanel/viewcontent/content/listTpl")

	setActive(arg0_1.taskListTpl, false)

	arg0_1.gotTf = findTF(arg0_1.historyPage, "got")
	arg0_1.finalAward = findTF(arg0_1.historyPage, "finalAward")

	arg0_1:initPageUI()
	arg0_1:selectedPage(1)
end

function var0_0.selectedPage(arg0_3, arg1_3)
	if arg0_3.startIndex + arg1_3 > #arg0_3.mapDataList then
		return
	end

	arg0_3:updatePage(arg1_3)
	arg0_3:updateMap(arg1_3)
end

function var0_0.initPageUI(arg0_4)
	for iter0_4 = 1, var1_0 do
		local var0_4 = arg0_4.startIndex + iter0_4

		setText(findTF(arg0_4.pageItemTfs[iter0_4], "num"), tostring(var0_4))
		setActive(findTF(arg0_4.pageItemTfs[iter0_4], "lock"), var0_4 > #arg0_4.mapDataList)
		setActive(arg0_4.pageItemTfs[iter0_4], var0_4 <= #arg0_4.mapDataList)
		setActive(findTF(arg0_4.pageItemTfs[iter0_4], "selected"), false)

		local var1_4 = setColorStr(var0_4, "#c57053")

		setText(findTF(arg0_4.pageItemTfs[iter0_4], "num"), var1_4)
	end
end

function var0_0.updatePage(arg0_5, arg1_5)
	local var0_5

	if arg0_5.selectedPageItem then
		setActive(findTF(arg0_5.selectedPageItem, "selected"), false)

		local var1_5 = setColorStr(arg0_5.selectedIndex, "#c57053")

		setText(findTF(arg0_5.selectedPageItem, "num"), var1_5)
	end

	arg0_5.selectedPageItem = arg0_5.pageItemTfs[arg1_5]
	arg0_5.selectedIndex = arg1_5

	setActive(findTF(arg0_5.selectedPageItem, "selected"), true)

	local var2_5 = setColorStr(arg0_5.selectedIndex, "#84412A")

	setText(findTF(arg0_5.selectedPageItem, "num"), var2_5)
end

function var0_0.updateMap(arg0_6, arg1_6)
	local var0_6 = arg1_6 + arg0_6.startIndex

	arg0_6.showMapId = arg0_6.mapDataList[var0_6]

	local var1_6 = pg.activity_map_event_list[arg0_6.showMapId]

	arg0_6.mapIndex = var1_6.area

	setImageSprite(arg0_6.mapPic, LoadSprite(IslandTaskScene.ui_atlas, "map_" .. arg0_6.mapIndex), true)
	setImageSprite(arg0_6.mapTitle, LoadSprite(IslandTaskScene.ui_atlas, "map_" .. arg0_6.mapIndex .. "_desc"), true)

	arg0_6.taskDatas = var1_6.open_task

	local var2_6 = #arg0_6.taskDatas - #arg0_6.taskList

	if var2_6 > 0 then
		arg0_6:addTaskList(var2_6)
	end

	local var3_6 = true

	for iter0_6 = 1, #arg0_6.taskList do
		local var4_6 = arg0_6.taskList[iter0_6]

		if iter0_6 <= #arg0_6.taskDatas then
			setActive(var4_6, true)

			local var5_6 = pg.task_data_template[arg0_6.taskDatas[iter0_6]]

			setText(findTF(var4_6, "text"), var5_6.name)

			local var6_6 = arg0_6:checkTaskFinish(var5_6.id)

			if var3_6 and var6_6 ~= var3_6 then
				var3_6 = false
			end

			setActive(findTF(var4_6, "tag/complete"), var6_6)
		else
			setActive(var4_6, false)
		end
	end

	local var7_6 = getProxy(IslandProxy):GetNode(arg0_6.showMapId):IsCompleted()

	print("mapId :" .. arg0_6.showMapId .. " get flag = " .. tostring(var7_6))
	setActive(arg0_6.finalAward, var3_6 and not var7_6)
	setActive(arg0_6.gotTf, var3_6 and var7_6)
	setLocalPosition(findTF(arg0_6.historyPage, "finalAward"), Vector3(var2_0[arg0_6.mapIndex][1], var2_0[arg0_6.mapIndex][2], var2_0[arg0_6.mapIndex][3]))
	setLocalEulerAngles(findTF(arg0_6.historyPage, "finalAward/arrow"), Vector3(var3_0[arg0_6.mapIndex][1], var3_0[arg0_6.mapIndex][2], var3_0[arg0_6.mapIndex][3]))
end

function var0_0.addTaskList(arg0_7, arg1_7)
	for iter0_7 = 1, arg1_7 do
		local var0_7 = tf(instantiate(arg0_7.taskListTpl))

		setActive(var0_7, false)
		setParent(var0_7, arg0_7.listConent)
		table.insert(arg0_7.taskList, var0_7)
	end
end

function var0_0.checkTaskFinish(arg0_8, arg1_8)
	for iter0_8 = 1, #arg0_8.finishTasks do
		if arg0_8.finishTasks[iter0_8].id == arg1_8 then
			return true
		end
	end

	return false
end

function var0_0.setActive(arg0_9, arg1_9)
	setActive(arg0_9.historyPage, arg1_9)
end

function var0_0.dispose(arg0_10)
	return
end

return var0_0
