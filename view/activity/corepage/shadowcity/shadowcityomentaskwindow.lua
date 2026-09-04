local var0_0 = class("ShadowCityOmenTaskWindow", import("view.activity.CorePage.OutPost.OutPostOmenTaskWindow"))

function var0_0.getUIName(arg0_1)
	return "ShadowCityOmenTaskWindow"
end

function var0_0.UpdateListItem(arg0_2, arg1_2, arg2_2)
	local var0_2 = findTF(arg2_2, "default")
	local var1_2 = findTF(var0_2, "day")
	local var2_2 = findTF(var0_2, "tasks")
	local var3_2 = findTF(arg2_2, "lock")
	local var4_2 = findTF(var3_2, "desc")
	local var5_2 = findTF(var3_2, "lockItem_1/desc")
	local var6_2 = findTF(var3_2, "lockItem_2/desc")
	local var7_2 = arg1_2 + 1

	setText(var1_2, "DAY " .. var7_2)

	for iter0_2 = 0, var2_2.childCount - 1 do
		local var8_2 = var2_2:GetChild(iter0_2)

		arg0_2:UpdateTaskItem(var7_2, iter0_2, var8_2)
	end

	local var9_2 = arg0_2:isTaskLock(var7_2)
	local var10_2 = var9_2 ~= 0

	setActive(var3_2, var10_2)

	GetOrAddComponent(var0_2, typeof(CanvasGroup)).alpha = var10_2 and 0.5 or 1

	switch(var9_2, {
		function()
			local var0_3, var1_3 = arg0_2:getDate(arg0_2.month, arg0_2.day + var7_2 - arg0_2.nday)

			setText(var4_2, i18n("OutPostOmenPage_task_tip1", var0_3, var1_3))
			setText(var5_2, i18n("OutPostOmenPage_task_tip1", var0_3, var1_3))
			setText(var6_2, i18n("OutPostOmenPage_task_tip1", var0_3, var1_3))
		end,
		function()
			setText(var4_2, i18n("OutPostOmenPage_task_tip2"))
			setText(var5_2, i18n("OutPostOmenPage_task_tip2"))
			setText(var6_2, i18n("OutPostOmenPage_task_tip2"))
		end
	})
end

function var0_0.UpdateTaskItem(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg2_5 + 1
	local var1_5 = arg3_5:Find("item")
	local var2_5 = arg0_5.taskGroup[arg1_5][var0_5]
	local var3_5 = arg0_5.taskProxy:getTaskById(var2_5) or arg0_5.taskProxy:getFinishTaskById(var2_5)
	local var4_5 = pg.task_data_template[var2_5]
	local var5_5 = Drop.Create(var4_5.award_display[1])

	updateDrop(var1_5, var5_5)
	onButton(arg0_5, var1_5, function()
		arg0_5:emit(BaseUI.ON_DROP, var5_5)
	end, SFX_PANEL)

	local var6_5 = var3_5 and var3_5:getProgress() or 0
	local var7_5 = var4_5.target_num

	setText(arg3_5:Find("description"), var4_5.desc)
	setSlider(arg3_5:Find("progress"), 0, var7_5, var6_5)

	local var8_5, var9_5 = var0_0:GetProgressColor()

	var6_5 = var8_5 and setColorStr(var6_5, var8_5) or var6_5
	var7_5 = var9_5 and setColorStr(var7_5, var9_5) or var7_5

	setText(arg3_5:Find("progressText"), var6_5 .. "/" .. var7_5)

	local var10_5 = arg3_5:Find("got_btn")
	local var11_5 = var3_5 and var3_5:getTaskStatus() or 0

	setActive(var10_5, var11_5 == 2)
end

function var0_0.GetProgressColor(arg0_7)
	return "#25A1FF", "#393A3C"
end

return var0_0
