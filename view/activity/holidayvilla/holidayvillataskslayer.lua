local var0_0 = class("HolidayVillaTasksLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "HolidayVillaTasksUI"
end

function var0_0.init(arg0_2)
	arg0_2.white_closebtn = arg0_2._tf:Find("white_close")
	arg0_2.bg = arg0_2._tf:Find("BG")
	arg0_2.Close = arg0_2.bg:Find("close")
	arg0_2.list = arg0_2.bg:Find("panel/list")
	arg0_2.frame = arg0_2.bg:Find("frame")
	arg0_2.UIlist = UIItemList.New(arg0_2.list, arg0_2.frame)
	arg0_2.getall = arg0_2.bg:Find("get_all")
end

function var0_0.ShouldShowTip()
	local var0_3 = ActivityConst.HOLIDAY_TASK
	local var1_3 = getProxy(TaskProxy)
	local var2_3 = getProxy(ActivityProxy):getActivityById(var0_3):getConfig("config_data")

	for iter0_3 = 1, #var2_3 do
		if var1_3:getTaskVO(var2_3[iter0_3]):getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

function var0_0.didEnter(arg0_4)
	arg0_4:InitData()
	arg0_4:SortData()
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

function var0_0.UpdateView(arg0_8)
	for iter0_8 = 1, #arg0_8.config_client do
		for iter1_8 = 1, #arg0_8.config_client[iter0_8] do
			arg0_8.task = arg0_8.taskProxy:getTaskVO(arg0_8.config_client[iter0_8][iter1_8])
			arg0_8.isGottask = arg0_8:ISGot(arg0_8.task, arg0_8.config_client[iter0_8][iter1_8])

			if arg0_8.isGottask ~= 2 then
				table.insert(arg0_8.config_data, arg0_8.config_client[iter0_8][iter1_8])

				break
			elseif arg0_8.isGottask == 2 and iter1_8 == #arg0_8.config_client[iter0_8] then
				table.insert(arg0_8.config_data, arg0_8.config_client[iter0_8][iter1_8])
			end
		end
	end

	arg0_8:SortData()
	setActive(arg0_8.getall, arg0_8.ShouldShowTip())
	arg0_8.UIlist:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_8:UpdateList(arg1_9, arg2_9, arg0_8.config_data)
		end
	end)
	arg0_8.UIlist:align(#arg0_8.config_data)
end

function var0_0.SortData(arg0_10)
	local var0_10 = {}
	local var1_10 = {}
	local var2_10 = {}

	for iter0_10 = 1, #arg0_10.config_data do
		arg0_10.taskvo = arg0_10.taskProxy:getFinishTaskById(arg0_10.config_data[iter0_10])
		arg0_10.task = arg0_10.taskProxy:getTaskVO(arg0_10.config_data[iter0_10])

		if arg0_10.task:getTaskStatus() == 1 then
			table.insert(var0_10, arg0_10.config_data[iter0_10])
		elseif arg0_10.task:getTaskStatus() == 0 then
			table.insert(var2_10, arg0_10.config_data[iter0_10])
		elseif arg0_10.task:getTaskStatus() == 2 then
			table.insert(var1_10, arg0_10.config_data[iter0_10])
		end
	end

	for iter1_10 = 1, #arg0_10.config_data do
		table.remove(arg0_10.config_data)
	end

	for iter2_10 = 1, #var0_10 do
		table.insert(arg0_10.config_data, var0_10[iter2_10])
	end

	for iter3_10 = 1, #var2_10 do
		table.insert(arg0_10.config_data, var2_10[iter3_10])
	end

	for iter4_10 = 1, #var1_10 do
		table.insert(arg0_10.config_data, var1_10[iter4_10])
	end
end

function var0_0.GetAllAward(arg0_11)
	local var0_11 = getProxy(PlayerProxy)
	local var1_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.config_data) do
		arg0_11.taskvo = arg0_11.taskProxy:getFinishTaskById(arg0_11.config_data[iter0_11])
		arg0_11.task = arg0_11.taskProxy:getTaskVO(arg0_11.config_data[iter0_11])

		if arg0_11.task:getTaskStatus() == 1 then
			table.insert(var1_11, arg0_11.config_data[iter0_11])
		end
	end

	arg0_11:emit(HolidayVillaTasksMediator.ON_TASK_SUBMIT_ONESTEP, arg0_11.taskActivityId, var1_11)
end

function var0_0.ISGot(arg0_12, arg1_12, arg2_12)
	arg1_12 = arg0_12.taskProxy:getTaskVO(arg2_12)

	return arg1_12:getTaskStatus()
end

function var0_0.InitData(arg0_13)
	arg0_13.taskActivityId = ActivityConst.HOLIDAY_TASK
	arg0_13.taskProxy = getProxy(TaskProxy)
	arg0_13.activity = getProxy(ActivityProxy):getActivityById(arg0_13.taskActivityId)
	arg0_13.config_data = {}

	if #arg0_13.config_data == 0 then
		-- block empty
	else
		for iter0_13 = 1, #arg0_13.config_data do
			table.remove(arg0_13.config_data)
		end
	end

	arg0_13.config_client = arg0_13.activity:getConfig("config_client").task

	arg0_13:UpdateView()
end

function var0_0.UpdateList(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg1_14 + 1
	local var1_14 = arg2_14:Find("frame")
	local var2_14 = arg0_14.taskProxy:getTaskVO(arg3_14[var0_14])
	local var3_14 = arg2_14:Find("desc")

	setText(var3_14, var2_14:getConfig("desc"))

	local var4_14 = var2_14:getProgress()
	local var5_14 = var2_14:getConfig("target_num")

	setText(arg2_14:Find("progress"), var4_14 .. "/" .. var5_14)
	setSlider(arg2_14:Find("slider"), 0, var5_14, var4_14)

	local var6_14 = arg2_14:GetChild(0)
	local var7_14 = arg2_14:Find("awards")

	arg0_14:updateAwards(var2_14:getConfig("award_display"), var7_14, var6_14)

	local var8_14 = arg2_14:Find("go_btn")
	local var9_14 = arg2_14:Find("get_btn")
	local var10_14 = arg2_14:Find("got_btn")

	setText(arg2_14:Find("go_btn/text"), i18n("other_world_task_go"))
	setText(arg2_14:Find("get_btn/text"), i18n("other_world_task_get"))
	setText(arg2_14:Find("got_btn/text"), i18n("other_world_task_got"))

	local var11_14 = var2_14:getTaskStatus()

	setActive(var8_14, var11_14 == 0)
	setActive(var9_14, var11_14 == 1)
	setActive(var10_14, var11_14 == 2)
	SetActive(arg2_14:Find("tip"), var11_14 == 1)
	onButton(arg0_14, var9_14, function()
		arg0_14:emit(HolidayVillaTasksMediator.ON_TASK_SUBMIT_ONESTEP, arg0_14.taskActivityId, {
			var2_14.id
		})
	end, SFX_PANEL)
	onButton(arg0_14, var8_14, function()
		arg0_14:emit(HolidayVillaTasksMediator.ON_TASK_GO, var2_14)
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
				arg0_17:emit(BaseUI.ON_ITEM, var5_17)
			end, SFX_PANEL)
		end
	end
end

return var0_0
