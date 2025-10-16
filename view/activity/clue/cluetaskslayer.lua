local var0_0 = class("ClueTasksLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ClueTasksUI"
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
	local var0_3 = ActivityConst.Valleyhospital_TASK
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
	setActive(arg0_4.frame, false)
	onButton(arg0_4, arg0_4.Close, function()
		arg0_4:closeView()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.white_closebtn, function()
		arg0_4:closeView()
	end, SFX_PANEL)
	arg0_4:UpdateView()
	onButton(arg0_4, arg0_4.getall, function()
		arg0_4:GetAllAward()
	end)
	setText(arg0_4.getall:Find("Text"), i18n("other_world_task_get_all"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.UpdateView(arg0_8)
	setActive(arg0_8.getall, arg0_8.ShouldShowTip())
	arg0_8.UIlist:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_8:UpdateList(arg1_9, arg2_9, arg0_8.config_data)
		end
	end)
	arg0_8.UIlist:align(#arg0_8.config_data)
end

function var0_0.GetAllAward(arg0_10)
	local var0_10 = getProxy(PlayerProxy)
	local var1_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.config_data) do
		arg0_10.taskvo = arg0_10.taskProxy:getFinishTaskById(arg0_10.config_data[iter0_10])
		arg0_10.task = arg0_10.taskProxy:getTaskVO(arg0_10.config_data[iter0_10])

		if arg0_10.task:getTaskStatus() == 1 then
			table.insert(var1_10, arg0_10.config_data[iter0_10])
		end
	end

	arg0_10:emit(ClueTasksMediator.ON_TASK_SUBMIT_ONESTEP, arg0_10.taskActivityId, var1_10)
end

function var0_0.InitData(arg0_11)
	arg0_11.taskActivityId = ActivityConst.Valleyhospital_TASK
	arg0_11.taskProxy = getProxy(TaskProxy)
	arg0_11.activity = getProxy(ActivityProxy):getActivityById(arg0_11.taskActivityId)
	arg0_11.config_data = arg0_11.activity:getConfig("config_data")
end

function var0_0.UpdateList(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg1_12 + 1
	local var1_12 = arg2_12:Find("frame")
	local var2_12 = arg0_12.taskProxy:getTaskVO(arg3_12[var0_12])
	local var3_12 = arg2_12:Find("desc")

	setText(var3_12, var2_12:getConfig("desc"))

	local var4_12 = var2_12:getProgress()
	local var5_12 = var2_12:getConfig("target_num")

	setText(arg2_12:Find("progress"), var4_12 .. "/" .. var5_12)
	setSlider(arg2_12:Find("slider"), 0, var5_12, var4_12)

	local var6_12 = arg2_12:GetChild(0)
	local var7_12 = arg2_12:Find("awards")

	arg0_12:updateAwards(var2_12:getConfig("award_display"), var7_12, var6_12)

	local var8_12 = arg2_12:Find("go_btn")
	local var9_12 = arg2_12:Find("get_btn")
	local var10_12 = arg2_12:Find("got_btn")
	local var11_12 = var2_12:getTaskStatus()

	setActive(var8_12, var11_12 == 0)
	setActive(var9_12, var11_12 == 1)
	setActive(var10_12, var11_12 == 2)
	SetActive(arg2_12:Find("tip"), var11_12 == 1)
	onButton(arg0_12, var9_12, function()
		arg0_12:emit(ClueTasksMediator.ON_TASK_SUBMIT_ONESTEP, arg0_12.taskActivityId, {
			var2_12.id
		})
	end, SFX_PANEL)
	onButton(arg0_12, var8_12, function()
		arg0_12:emit(ClueTasksMediator.ON_TASK_GO, var2_12)
	end, SFX_PANEL)
end

function var0_0.updateAwards(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = _.slice(arg1_15, 1, 3)

	for iter0_15 = arg2_15.childCount, #var0_15 - 1 do
		cloneTplTo(arg3_15, arg2_15)
	end

	local var1_15 = arg2_15.childCount

	for iter1_15 = 1, var1_15 do
		local var2_15 = arg2_15:GetChild(iter1_15 - 1)
		local var3_15 = iter1_15 <= #var0_15

		setActive(var2_15, var3_15)

		if var3_15 then
			local var4_15 = var0_15[iter1_15]
			local var5_15 = {
				type = var4_15[1],
				id = var4_15[2],
				count = var4_15[3]
			}

			updateDrop(findTF(var2_15, "mask"), var5_15)
			onButton(arg0_15, var2_15:Find("mask"), function()
				arg0_15:emit(BaseUI.ON_DROP, var5_15)
			end, SFX_PANEL)
		end
	end
end

return var0_0
