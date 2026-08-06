local var0_0 = class("StarsCityOmenTaskWindow", import("view.base.BaseSubView"))

var0_0.SKIP_TYPE_SCENE = 2
var0_0.SKIP_TYPE_ACTIVITY = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
end

function var0_0.getUIName(arg0_2)
	return "StarsCityOmenTaskWindow"
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
	local var5_9 = findTF(var3_9, "lockText1")
	local var6_9 = findTF(var3_9, "lockText2")
	local var7_9 = arg1_9 + 1

	setText(var1_9, "DAY " .. var7_9)

	for iter0_9 = 0, var2_9.childCount - 1 do
		local var8_9 = var2_9:GetChild(iter0_9)

		arg0_9:UpdateTaskItem(var7_9, iter0_9, var8_9)
	end

	local var9_9 = arg0_9:isTaskLock(var7_9)
	local var10_9 = var9_9 ~= 0

	setActive(var3_9, var10_9)

	GetOrAddComponent(var0_9, typeof(CanvasGroup)).alpha = var10_9 and 0.5 or 1

	switch(var9_9, {
		function()
			local var0_10, var1_10 = arg0_9:getDate(arg0_9.month, arg0_9.day + var7_9 - arg0_9.nday)

			setText(var5_9:Find("Text"), i18n("OutPostOmenPage_task_tip1", var0_10, var1_10))
			setText(var6_9:Find("Text"), i18n("OutPostOmenPage_task_tip1", var0_10, var1_10))
			setActive(var4_9, false)
			setActive(var5_9, true)
			setActive(var6_9, true)
		end,
		function()
			setText(var4_9, i18n("OutPostOmenPage_task_tip2"))
			setActive(var4_9, true)
			setActive(var5_9, false)
			setActive(var6_9, false)
		end
	})
end

function var0_0.UpdateTaskItem(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg2_12 + 1
	local var1_12 = arg3_12:Find("item")
	local var2_12 = arg0_12.taskGroup[arg1_12][var0_12]
	local var3_12 = arg0_12.taskProxy:getTaskById(var2_12) or arg0_12.taskProxy:getFinishTaskById(var2_12)
	local var4_12 = pg.task_data_template[var2_12]
	local var5_12 = arg3_12:Find("got_mask")
	local var6_12 = Drop.Create(var4_12.award_display[1])

	updateDrop(var1_12, var6_12)
	onButton(arg0_12, var1_12, function()
		arg0_12:emit(BaseUI.ON_DROP, var6_12)
	end, SFX_PANEL)

	local var7_12 = var3_12 and var3_12:getProgress() or 0
	local var8_12 = var4_12.target_num

	setText(arg3_12:Find("description"), var4_12.desc)
	setSlider(arg3_12:Find("progress"), 0, var8_12, var7_12)

	local var9_12, var10_12 = arg0_12:GetProgressColor()
	local var11_12 = setColorStr(var7_12, var9_12)
	local var12_12 = setColorStr("/" .. var8_12, var10_12)

	setText(arg3_12:Find("progressText"), var11_12 .. var12_12)

	if var3_12:getTaskStatus() == 2 then
		setActive(var5_12, true)
	end
end

function var0_0.getDate(arg0_14, arg1_14, arg2_14)
	local var0_14 = pg.TimeMgr.GetInstance():CalcMonthDays(arg0_14.year, arg1_14)

	if var0_14 < arg2_14 then
		arg2_14 = arg2_14 - var0_14
		arg1_14 = arg1_14 + 1

		if arg1_14 > 12 then
			arg1_14 = 1
			arg0_14.year = arg0_14.year + 1
		end
	end

	return arg1_14, arg2_14
end

function var0_0.GetProgressColor(arg0_15)
	return "#FFFFFF", "#C3C3C3"
end

function var0_0.isTaskLock(arg0_16, arg1_16)
	if arg1_16 > arg0_16.nday then
		return 1
	end

	for iter0_16 = 1, arg1_16 - 1 do
		local var0_16 = arg0_16.taskGroup[iter0_16]

		for iter1_16, iter2_16 in ipairs(var0_16) do
			if (arg0_16.taskProxy:getTaskById(iter2_16) or arg0_16.taskProxy:getFinishTaskById(iter2_16)):getTaskStatus() ~= 2 then
				return 2
			end
		end
	end

	return 0
end

function var0_0.Hide(arg0_17)
	if arg0_17:isShowing() then
		var0_0.super.Hide(arg0_17)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_17._tf, arg0_17._parentTf)
	end
end

return var0_0
