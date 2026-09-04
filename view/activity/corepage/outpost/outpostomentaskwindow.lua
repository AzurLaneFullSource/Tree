local var0_0 = class("OutPostOmenTaskWindow", import("view.base.BaseSubView"))

var0_0.SKIP_TYPE_SCENE = 2
var0_0.SKIP_TYPE_ACTIVITY = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
end

function var0_0.getUIName(arg0_2)
	return "OutPostOmenTaskWindow"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.bg = arg0_3._tf:Find("bg")
	arg0_3.btnClose = arg0_3._tf:Find("window/btnClose")

	onButton(arg0_3, arg0_3.btnClose, function()
		arg0_3:Hide()
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3.bg, function()
		arg0_3:Hide()
	end, SOUND_BACK)
end

function var0_0.OnInit(arg0_6)
	arg0_6.page = findTF(arg0_6._tf, "window")
	arg0_6.list = findTF(arg0_6.page, "list/Viewport/Content")
	arg0_6.list_tpl = findTF(arg0_6.page, "list_tpl")
	arg0_6.uilist = UIItemList.New(arg0_6.list, arg0_6.list_tpl)

	arg0_6.uilist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_6:UpdateListItem(arg1_7, arg2_7)
		end
	end)

	local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0_6.year, arg0_6.month, arg0_6.day = ChineseCalendar.GetCurrYearMonthDay(var0_6)
end

function var0_0.Show(arg0_8, arg1_8)
	var0_0.super.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf, {
		staticBlur = true
	})

	arg0_8.activity = arg1_8
	arg0_8.nday = arg0_8.activity:getNDay()
	arg0_8.taskProxy = getProxy(TaskProxy)
	arg0_8.taskGroup = arg0_8.activity:getConfig("config_client").unlock_task

	arg0_8.uilist:align(#arg0_8.taskGroup)
end

function var0_0.UpdateListItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = findTF(arg2_9, "default")
	local var1_9 = findTF(var0_9, "day")
	local var2_9 = findTF(var0_9, "tasks")
	local var3_9 = findTF(arg2_9, "lock")
	local var4_9 = findTF(var3_9, "desc")
	local var5_9 = arg1_9 + 1

	setText(var1_9, "DAY " .. var5_9)

	for iter0_9 = 0, var2_9.childCount - 1 do
		local var6_9 = var2_9:GetChild(iter0_9)

		arg0_9:UpdateTaskItem(var5_9, iter0_9, var6_9)
	end

	local var7_9 = arg0_9:isTaskLock(var5_9)
	local var8_9 = var7_9 ~= 0

	setActive(var3_9, var8_9)

	GetOrAddComponent(var0_9, typeof(CanvasGroup)).alpha = var8_9 and 0.5 or 1

	switch(var7_9, {
		function()
			local var0_10, var1_10 = arg0_9:getDate(arg0_9.month, arg0_9.day + var5_9 - arg0_9.nday)

			setText(var4_9, i18n("OutPostOmenPage_task_tip1", var0_10, var1_10))
		end,
		function()
			setText(var4_9, i18n("OutPostOmenPage_task_tip2"))
		end
	})
end

function var0_0.GetProgressColor(arg0_12)
	return nil
end

function var0_0.UpdateTaskItem(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg2_13 + 1
	local var1_13 = arg3_13:Find("item")
	local var2_13 = arg0_13.taskGroup[arg1_13][var0_13]
	local var3_13 = arg0_13.taskProxy:getTaskById(var2_13) or arg0_13.taskProxy:getFinishTaskById(var2_13)
	local var4_13 = pg.task_data_template[var2_13]
	local var5_13 = Drop.Create(var4_13.award_display[1])

	updateDrop(var1_13, var5_13)
	onButton(arg0_13, var1_13, function()
		arg0_13:emit(BaseUI.ON_DROP, var5_13)
	end, SFX_PANEL)

	local var6_13 = var3_13 and var3_13:getProgress() or 0
	local var7_13 = var4_13.target_num

	setText(arg3_13:Find("description"), var4_13.desc)
	setSlider(arg3_13:Find("progress"), 0, var7_13, var6_13)

	local var8_13, var9_13 = var0_0:GetProgressColor()

	var6_13 = var8_13 and setColorStr(var6_13, var8_13) or var6_13
	var7_13 = var9_13 and setColorStr(var7_13, var9_13) or var7_13

	setText(arg3_13:Find("progressText"), var6_13 .. "/" .. var7_13)
end

function var0_0.getDate(arg0_15, arg1_15, arg2_15)
	local var0_15 = pg.TimeMgr.GetInstance():CalcMonthDays(arg0_15.year, arg1_15)

	if var0_15 < arg2_15 then
		arg2_15 = arg2_15 - var0_15
		arg1_15 = arg1_15 + 1

		if arg1_15 > 12 then
			arg1_15 = 1
			arg0_15.year = arg0_15.year + 1
		end
	end

	return arg1_15, arg2_15
end

function var0_0.GetProgressColor(arg0_16)
	return nil
end

function var0_0.isTaskLock(arg0_17, arg1_17)
	if arg1_17 > arg0_17.nday then
		return 1
	end

	for iter0_17 = 1, arg1_17 - 1 do
		local var0_17 = arg0_17.taskGroup[iter0_17]

		for iter1_17, iter2_17 in ipairs(var0_17) do
			if (arg0_17.taskProxy:getTaskById(iter2_17) or arg0_17.taskProxy:getFinishTaskById(iter2_17)):getTaskStatus() ~= 2 then
				return 2
			end
		end
	end

	return 0
end

function var0_0.Hide(arg0_18)
	if arg0_18:isShowing() then
		var0_0.super.Hide(arg0_18)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_18._tf, arg0_18._parentTf)
	end
end

return var0_0
