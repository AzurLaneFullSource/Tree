local var0_0 = class("IslandMechaTaskDescPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandMechaTaskDescPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiItemList = UIItemList.New(arg0_2._tf:Find("list/content"), arg0_2._tf:Find("list/content/tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("close"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.startTime = arg1_6
	arg0_6.nday = arg2_6
	arg0_6.taskGroup = arg3_6

	arg0_6:UpdateList()
	var0_0.super.Show(arg0_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.Hide(arg0_7)
	var0_0.super.Hide(arg0_7)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7._tf, arg0_7._parentTf)
end

function var0_0.UpdateList(arg0_8)
	arg0_8.uiItemList:make(function(arg0_9, arg1_9, arg2_9)
		local var0_9 = arg0_8.taskGroup[arg1_9 + 1] or {}

		for iter0_9, iter1_9 in ipairs(var0_9) do
			arg0_8:UpdateTask(arg1_9 + 1, iter1_9, arg2_9:Find("tpl_" .. iter0_9))
		end

		local var1_9 = arg1_9 + 1

		setText(arg2_9:Find("day"), var1_9 < 10 and "0" .. var1_9 or var1_9)
	end)
	arg0_8.uiItemList:align(#arg0_8.taskGroup)
end

function var0_0.GetDayDesc(arg0_10, arg1_10)
	local var0_10 = arg0_10.startTime + arg1_10 * 86400
	local var1_10 = pg.TimeMgr.GetInstance():STimeDescS(var0_10, "%Y/%m/%d/%H/%M/%S")
	local var2_10 = string.split(var1_10, "/")

	return var2_10[2], var2_10[3]
end

function var0_0.UpdateTask(arg0_11, arg1_11, arg2_11, arg3_11)
	if not arg3_11 then
		return
	end

	local var0_11 = IslandTask.New({
		id = arg2_11,
		process_list = {}
	})

	setText(arg3_11:Find("Text"), var0_11:getConfig("task_desc"))

	local var1_11, var2_11, var3_11 = IslandTaskActhelper.GetIslandTaskState(arg2_11)

	setText(arg3_11:Find("progress_1/Text"), var1_11 .. "/" .. var2_11)
	setFillAmount(arg3_11:Find("progress_1/bar"), var1_11 / var2_11)
	setActive(arg3_11:Find("lock"), arg1_11 > arg0_11.nday)

	local var4_11 = var0_11:GetAwards()[1]
	local var5_11 = arg3_11:Find("InventoryTpl_1")

	updateCustomDrop(var5_11, var4_11)
	onButton(arg0_11, var5_11, function()
		arg0_11:emit(IslandMediator.SHOW_MSG_BOX, {
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var4_11
		})
	end, SFX_PANEL)

	local var6_11, var7_11 = arg0_11:GetDayDesc(arg1_11 - 1)

	setText(arg3_11:Find("lock/Text"), i18n("island_mecha_task_lock_tip", var6_11, var7_11))
	setActive(arg3_11.parent:Find("finish"), var3_11 == 2)
end

function var0_0.OnDestroy(arg0_13)
	if arg0_13:isShowing() then
		arg0_13:Hide()
	end
end

return var0_0
