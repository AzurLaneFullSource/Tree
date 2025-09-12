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

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	setActive(arg0_3.frame, false)
	onButton(arg0_3, arg0_3.Close, function()
		arg0_3:closeView()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.white_closebtn, function()
		arg0_3:closeView()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getall, function()
		arg0_3:GetAllAward()
	end)
	setText(arg0_3.getall:Find("Text"), i18n("other_world_task_get_all"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false)
end

function var0_0.ShouldShowTip()
	local var0_7 = ActivityConst.NINJA_CITY_SP_TASK
	local var1_7 = getProxy(TaskProxy)
	local var2_7 = getProxy(ActivityProxy):getActivityById(var0_7)
	local var3_7 = var2_7:getConfig("config_data")
	local var4_7 = var2_7.data3

	for iter0_7 = 1, #var3_7[var4_7] do
		if var1_7:getTaskVO(var3_7[var4_7][iter0_7]):getTaskStatus() == 1 then
			return true
		end
	end

	local var5_7 = ActivityConst.NINJA_CITY_NORMAL_ACTIVITY_TASK
	local var6_7 = getProxy(ActivityProxy):getActivityById(var5_7):getConfig("config_data")

	for iter1_7 = 1, #var6_7 do
		if var1_7:getTaskVO(var6_7[iter1_7]):getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

function var0_0.InitData(arg0_8)
	arg0_8.taskProxy = getProxy(TaskProxy)
	arg0_8.taskActivityId = ActivityConst.NINJA_CITY_SP_TASK
	arg0_8.taskActivityId_2 = ActivityConst.NINJA_CITY_NORMAL_ACTIVITY_TASK
	arg0_8.activity = getProxy(ActivityProxy):getActivityById(arg0_8.taskActivityId)
	arg0_8.activity_2 = getProxy(ActivityProxy):getActivityById(arg0_8.taskActivityId_2)
	arg0_8.data = arg0_8.activity:getConfig("config_data")
	arg0_8.data2 = arg0_8.activity_2:getConfig("config_data")

	updateActivityTaskStatus(arg0_8.activity)

	arg0_8.config_datas = {}
	arg0_8.nday = arg0_8.activity.data3

	if not arg0_8.config_datas then
		table.clean(arg0_8.config_datas)
	end

	for iter0_8 = 1, #arg0_8.data[arg0_8.nday] do
		table.insert(arg0_8.config_datas, arg0_8.data[arg0_8.nday][iter0_8])
	end

	for iter1_8 = 1, #arg0_8.data2 do
		table.insert(arg0_8.config_datas, arg0_8.data2[iter1_8])
	end

	arg0_8:OnSort()
	arg0_8:UpdateView()
end

function var0_0.OnSort(arg0_9)
	arg0_9.config_data = {}

	if not arg0_9.config_data then
		table.clean(arg0_9.config_data)
	end

	for iter0_9 = 1, #arg0_9.config_datas do
		arg0_9.tasks = arg0_9.taskProxy:getTaskVO(arg0_9.config_datas[iter0_9])

		if arg0_9.tasks:getTaskStatus() == 1 then
			table.insert(arg0_9.config_data, arg0_9.config_datas[iter0_9])
		end
	end

	for iter1_9 = 1, #arg0_9.config_datas do
		arg0_9.tasks = arg0_9.taskProxy:getTaskVO(arg0_9.config_datas[iter1_9])

		if arg0_9.tasks:getTaskStatus() == 0 then
			table.insert(arg0_9.config_data, arg0_9.config_datas[iter1_9])
		end
	end

	for iter2_9 = 1, #arg0_9.config_datas do
		arg0_9.tasks = arg0_9.taskProxy:getTaskVO(arg0_9.config_datas[iter2_9])

		if arg0_9.tasks:getTaskStatus() == 2 then
			table.insert(arg0_9.config_data, arg0_9.config_datas[iter2_9])
		end
	end
end

function var0_0.UpdateView(arg0_10)
	setActive(arg0_10.getall, arg0_10.ShouldShowTip())
	arg0_10.UIlist:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_10:UpdateList(arg1_11, arg2_11, arg0_10.config_data)
		end
	end)
	arg0_10.UIlist:align(#arg0_10.config_data)
end

function var0_0.GetAllAward(arg0_12)
	arg0_12.indexTask = 0

	local var0_12 = getProxy(PlayerProxy)
	local var1_12 = {}
	local var2_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.config_data) do
		arg0_12.taskvo = arg0_12.taskProxy:getFinishTaskById(arg0_12.config_data[iter0_12])
		arg0_12.task = arg0_12.taskProxy:getTaskVO(arg0_12.config_data[iter0_12])

		if arg0_12.task:getTaskStatus() == 1 then
			for iter2_12 = 1, #arg0_12.data2 do
				if arg0_12.task.id == arg0_12.data2[iter2_12] then
					table.insert(var1_12, arg0_12.config_data[iter0_12])
				end
			end

			for iter3_12 = 1, #arg0_12.data[arg0_12.nday] do
				if arg0_12.task.id == arg0_12.data[arg0_12.nday][iter3_12] then
					table.insert(var2_12, arg0_12.task.id)
				end
			end
		end
	end

	for iter4_12 = 1, #var2_12 do
		arg0_12:emit(CityRebuildTasksMediator.ON_SUBMIT_TASK, var2_12[iter4_12])
	end

	arg0_12:emit(CityRebuildTasksMediator.ON_TASK_SUBMIT_ONESTEP, arg0_12.taskActivityId_2, var1_12)
end

function var0_0.UpdateList(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg1_13 + 1
	local var1_13 = arg0_13:findTF("frame", arg2_13)
	local var2_13 = arg0_13.taskProxy:getTaskVO(arg3_13[var0_13])
	local var3_13 = arg2_13:Find("desc")

	setText(var3_13, var2_13:getConfig("desc"))

	local var4_13 = var2_13:getProgress()
	local var5_13 = var2_13:getConfig("target_num")

	setText(arg2_13:Find("progress"), setColorStr(var4_13, "#000000") .. "/" .. var5_13)
	setSlider(arg2_13:Find("slider"), 0, var5_13, var4_13)

	local var6_13 = arg2_13:GetChild(0)
	local var7_13 = arg2_13:Find("awards")

	arg0_13:updateAwards(var2_13:getConfig("award_display"), var7_13, var6_13)

	local var8_13 = arg0_13:findTF("go_btn", arg2_13)
	local var9_13 = arg0_13:findTF("get_btn", arg2_13)
	local var10_13 = arg0_13:findTF("got_btn", arg2_13)
	local var11_13 = var2_13:getTaskStatus()

	setActive(var8_13, var11_13 == 0)
	setActive(var9_13, var11_13 == 1)
	setActive(var10_13, var11_13 == 2)
	SetActive(arg2_13:Find("tip"), var11_13 == 1)
	onButton(arg0_13, var9_13, function()
		for iter0_14 = 1, #arg0_13.data[arg0_13.nday] do
			if var2_13.id == arg0_13.data[arg0_13.nday][iter0_14] then
				arg0_13:emit(CityRebuildTasksMediator.ON_SUBMIT_TASK, var2_13.id)
			end
		end

		for iter1_14 = 1, #arg0_13.data2 do
			if var2_13.id == arg0_13.data2[iter1_14] then
				arg0_13:emit(CityRebuildTasksMediator.ON_TASK_SUBMIT_ONESTEP, arg0_13.taskActivityId_2, {
					var2_13.id
				})
			end
		end
	end, SFX_PANEL)
	onButton(arg0_13, var8_13, function()
		arg0_13:emit(CityRebuildTasksMediator.ON_TASK_GO, var2_13)
	end, SFX_PANEL)
end

function var0_0.updateAwards(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = _.slice(arg1_16, 1, 3)

	for iter0_16 = arg2_16.childCount, #var0_16 - 1 do
		cloneTplTo(arg3_16, arg2_16)
	end

	local var1_16 = arg2_16.childCount

	for iter1_16 = 1, var1_16 do
		local var2_16 = arg2_16:GetChild(iter1_16 - 1)
		local var3_16 = iter1_16 <= #var0_16

		setActive(var2_16, var3_16)

		if var3_16 then
			local var4_16 = var0_16[iter1_16]
			local var5_16 = {
				type = var4_16[1],
				id = var4_16[2],
				count = var4_16[3]
			}

			updateDrop(findTF(var2_16, "mask"), var5_16)
			onButton(arg0_16, var2_16:Find("mask"), function()
				arg0_16:emit(BaseUI.ON_DROP, var5_16)
			end, SFX_PANEL)
		end
	end
end

return var0_0
