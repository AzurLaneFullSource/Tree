local var0_0 = class("CityRebuildTasksLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CityRebuildTasksUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2:findTF("BG")
	arg0_2.Close = arg0_2.bg:Find("close")
	arg0_2.list = arg0_2.bg:Find("panel/list")
	arg0_2.frame = arg0_2.bg:Find("frame")
	arg0_2.white_closebtn = arg0_2:findTF("white_close")
	arg0_2.UIlist = UIItemList.New(arg0_2.list, arg0_2.frame)
	arg0_2.getall = arg0_2.bg:Find("get_all")
end

function var0_0.findTF(arg0_3, arg1_3, arg2_3)
	return findTF(arg2_3 or arg0_3._tf, arg1_3)
end

function var0_0.didEnter(arg0_4)
	arg0_4:InitData()
	setActive(arg0_4.frame, false)
	onButton(arg0_4, arg0_4.Close, function()
		arg0_4:closeView()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.white_closebtn, function()
		arg0_4:closeView()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.getall, function()
		arg0_4:GetAllAward()
	end)
	setText(arg0_4.getall:Find("Text"), i18n("other_world_task_get_all"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.ShouldShowTip()
	local var0_8 = ActivityConst.NINJA_CITY_SP_TASK
	local var1_8 = getProxy(TaskProxy)
	local var2_8 = getProxy(ActivityProxy):getActivityById(var0_8)
	local var3_8 = var2_8:getConfig("config_data")

	if var2_8.data3 then
		return false
	end

	local var4_8 = var2_8.data3

	if var4_8 == 0 or var4_8 == nil then
		return false
	end

	for iter0_8 = 1, #var3_8[var4_8] do
		if var1_8:getTaskVO(var3_8[var4_8][iter0_8]):getTaskStatus() == 1 then
			return true
		end
	end

	local var5_8 = ActivityConst.NINJA_CITY_NORMAL_ACTIVITY_TASK
	local var6_8 = getProxy(ActivityProxy):getActivityById(var5_8):getConfig("config_data")

	for iter1_8 = 1, #var6_8 do
		if var1_8:getTaskVO(var6_8[iter1_8]):getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

function var0_0.InitData(arg0_9)
	arg0_9.taskProxy = getProxy(TaskProxy)
	arg0_9.taskActivityId = ActivityConst.NINJA_CITY_SP_TASK
	arg0_9.taskActivityId_2 = ActivityConst.NINJA_CITY_NORMAL_ACTIVITY_TASK
	arg0_9.activity = getProxy(ActivityProxy):getActivityById(arg0_9.taskActivityId)
	arg0_9.activity_2 = getProxy(ActivityProxy):getActivityById(arg0_9.taskActivityId_2)
	arg0_9.data = arg0_9.activity:getConfig("config_data")
	arg0_9.data2 = arg0_9.activity_2:getConfig("config_data")

	updateActivityTaskStatus(arg0_9.activity)

	arg0_9.config_datas = {}
	arg0_9.nday = arg0_9.activity.data3

	if not arg0_9.config_datas then
		table.clean(arg0_9.config_datas)
	end

	for iter0_9 = 1, #arg0_9.data[arg0_9.nday] do
		table.insert(arg0_9.config_datas, arg0_9.data[arg0_9.nday][iter0_9])
	end

	for iter1_9 = 1, #arg0_9.data2 do
		table.insert(arg0_9.config_datas, arg0_9.data2[iter1_9])
	end

	arg0_9:OnSort()
	arg0_9:UpdateView()
end

function var0_0.OnSort(arg0_10)
	arg0_10.config_data = {}

	if not arg0_10.config_data then
		table.clean(arg0_10.config_data)
	end

	for iter0_10 = 1, #arg0_10.config_datas do
		arg0_10.tasks = arg0_10.taskProxy:getTaskVO(arg0_10.config_datas[iter0_10])

		if arg0_10.tasks:getTaskStatus() == 1 then
			table.insert(arg0_10.config_data, arg0_10.config_datas[iter0_10])
		end
	end

	for iter1_10 = 1, #arg0_10.config_datas do
		arg0_10.tasks = arg0_10.taskProxy:getTaskVO(arg0_10.config_datas[iter1_10])

		if arg0_10.tasks:getTaskStatus() == 0 then
			table.insert(arg0_10.config_data, arg0_10.config_datas[iter1_10])
		end
	end

	for iter2_10 = 1, #arg0_10.config_datas do
		arg0_10.tasks = arg0_10.taskProxy:getTaskVO(arg0_10.config_datas[iter2_10])

		if arg0_10.tasks:getTaskStatus() == 2 then
			table.insert(arg0_10.config_data, arg0_10.config_datas[iter2_10])
		end
	end
end

function var0_0.UpdateView(arg0_11)
	setActive(arg0_11.getall, arg0_11.ShouldShowTip())
	arg0_11.UIlist:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			arg0_11:UpdateList(arg1_12, arg2_12, arg0_11.config_data)
		end
	end)
	arg0_11.UIlist:align(#arg0_11.config_data)
end

function var0_0.GetAllAward(arg0_13)
	arg0_13.indexTask = 0

	local var0_13 = getProxy(PlayerProxy)
	local var1_13 = {}
	local var2_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13.config_data) do
		arg0_13.taskvo = arg0_13.taskProxy:getFinishTaskById(arg0_13.config_data[iter0_13])
		arg0_13.task = arg0_13.taskProxy:getTaskVO(arg0_13.config_data[iter0_13])

		if arg0_13.task:getTaskStatus() == 1 then
			for iter2_13 = 1, #arg0_13.data2 do
				if arg0_13.task.id == arg0_13.data2[iter2_13] then
					table.insert(var1_13, arg0_13.config_data[iter0_13])
				end
			end

			for iter3_13 = 1, #arg0_13.data[arg0_13.nday] do
				if arg0_13.task.id == arg0_13.data[arg0_13.nday][iter3_13] then
					table.insert(var2_13, arg0_13.task.id)
				end
			end
		end
	end

	for iter4_13 = 1, #var2_13 do
		arg0_13:emit(CityRebuildTasksMediator.ON_SUBMIT_TASK, var2_13[iter4_13])
	end

	arg0_13:emit(CityRebuildTasksMediator.ON_TASK_SUBMIT_ONESTEP, arg0_13.taskActivityId_2, var1_13)
end

function var0_0.UpdateList(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg1_14 + 1
	local var1_14 = arg2_14:Find("frame")
	local var2_14 = arg0_14.taskProxy:getTaskVO(arg3_14[var0_14])
	local var3_14 = arg2_14:Find("desc")

	setText(var3_14, var2_14:getConfig("desc"))

	local var4_14 = var2_14:getProgress()
	local var5_14 = var2_14:getConfig("target_num")

	setText(arg2_14:Find("progress"), setColorStr(var4_14, "#000000") .. "/" .. var5_14)
	setSlider(arg2_14:Find("slider"), 0, var5_14, var4_14)

	local var6_14 = arg2_14:GetChild(0)
	local var7_14 = arg2_14:Find("awards")

	arg0_14:updateAwards(var2_14:getConfig("award_display"), var7_14, var6_14)

	local var8_14 = arg2_14:Find("go_btn")
	local var9_14 = arg2_14:Find("get_btn")
	local var10_14 = arg2_14:Find("got_btn")
	local var11_14 = var2_14:getTaskStatus()

	setActive(var8_14, var11_14 == 0)
	setActive(var9_14, var11_14 == 1)
	setActive(var10_14, var11_14 == 2)
	SetActive(arg2_14:Find("tip"), var11_14 == 1)
	onButton(arg0_14, var9_14, function()
		for iter0_15 = 1, #arg0_14.data[arg0_14.nday] do
			if var2_14.id == arg0_14.data[arg0_14.nday][iter0_15] then
				arg0_14:emit(CityRebuildTasksMediator.ON_SUBMIT_TASK, var2_14.id)
			end
		end

		for iter1_15 = 1, #arg0_14.data2 do
			if var2_14.id == arg0_14.data2[iter1_15] then
				arg0_14:emit(CityRebuildTasksMediator.ON_TASK_SUBMIT_ONESTEP, arg0_14.taskActivityId_2, {
					var2_14.id
				})
			end
		end
	end, SFX_PANEL)
	onButton(arg0_14, var8_14, function()
		arg0_14:emit(CityRebuildTasksMediator.ON_TASK_GO, var2_14)
	end, SFX_PANEL)
end

function var0_0.updateAwards(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = _.slice(arg1_17, 1, 3)

	for iter0_17 = arg2_17.childCount, #var0_17 - 1 do
		cloneTplTo(arg3_17, arg2_17)
	end

	local var1_17 = arg2_17.childCount

	for iter1_17 = 1, var1_17 do
		local var2_17 = arg2_17:GetChild(iter1_17 - 1)
		local var3_17 = iter1_17 <= #var0_17

		setActive(var2_17, var3_17)

		if var3_17 then
			local var4_17 = var0_17[iter1_17]
			local var5_17 = {
				type = var4_17[1],
				id = var4_17[2],
				count = var4_17[3]
			}

			updateDrop(findTF(var2_17, "mask"), var5_17)
			onButton(arg0_17, var2_17:Find("mask"), function()
				arg0_17:emit(BaseUI.ON_DROP, var5_17)
			end, SFX_PANEL)
		end
	end
end

return var0_0
