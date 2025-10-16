local var0_0 = class("IslandSeasonTaskPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonTaskPanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("content")

	arg0_2.getAllBtn = var0_2:Find("get_all")

	setText(arg0_2.getAllBtn:Find("Text"), i18n("island_season_task_collectall"))

	local var1_2 = var0_2:Find("tpl")

	setActive(var1_2, false)

	arg0_2.scrollCom = var0_2:Find("view"):GetComponent("LScrollRect")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.getAllBtn, function()
		arg0_3:emit(IslandMediator.ON_SUBMIT_TASK_ONE_STEP, arg0_3.canSubmitIds)
	end, SFX_PANEL)

	function arg0_3.scrollCom.onUpdateItem(arg0_5, arg1_5)
		arg0_3:UpdateTask(arg0_5, tf(arg1_5))
	end
end

function var0_0.UpdateTask(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.taskIds[arg1_6 + 1]

	arg2_6.name = var0_6

	setText(arg2_6:Find("get/Text"), i18n("island_season_task_collect"))
	setText(arg2_6:Find("got/Text"), i18n("island_season_task_collected"))

	local var1_6 = arg0_6.taskVODic[var0_6]
	local var2_6 = pg.island_task[var0_6]

	setText(arg2_6:Find("desc"), var2_6.task_desc)
	setText(arg2_6:Find("name"), var2_6.name)

	local var3_6 = IslandTask.GetAwardsStatic(var0_6)

	UIItemList.StaticAlign(arg2_6:Find("awards"), arg2_6:Find("awards/tpl"), #var3_6, function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			updateCustomDrop(arg2_7, var3_6[arg1_7 + 1], {
				style = "island"
			})
			onButton(arg0_6, arg2_7, function()
				arg0_6.contextData:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var3_6[arg1_7 + 1]
				})
			end)
		end
	end)

	local var4_6 = pg.island_task_target[var2_6.target_id[1]].target_num
	local var5_6 = var1_6 and var1_6:GetTargetList()[1]:GetProgress() or var4_6

	setText(arg2_6:Find("progress"), var5_6 .. "/" .. var4_6)
	setActive(arg2_6:Find("get_bg"), var1_6 and var1_6:IsFinish())
	setActive(arg2_6:Find("get"), var1_6 and var1_6:IsSubmitOnUI() and var1_6:IsFinish())
	setActive(arg2_6:Find("got"), not var1_6)
	setText(arg2_6:Find("get/Text"), i18n("island_season_task_collect"))
	setText(arg2_6:Find("got/Text"), i18n("island_season_task_collected"))
	onButton(arg0_6, arg2_6:Find("get"), function()
		arg0_6:emit(IslandMediator.ON_SUBMIT_TASK, var1_6.id)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_10)
	arg0_10.super.Show(arg0_10)
	arg0_10:Flush()
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_16")
end

function var0_0.Flush(arg0_11)
	arg0_11.taskIds = arg0_11.contextData.season:GetTaskIds()
	arg0_11.taskVODic = {}

	local var0_11 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

	for iter0_11, iter1_11 in ipairs(arg0_11.contextData.season:GetTaskIds()) do
		local var1_11 = var0_11:GetTask(iter1_11)

		if var1_11 then
			arg0_11.taskVODic[iter1_11] = var1_11
		end
	end

	table.sort(arg0_11.taskIds, CompareFuncs({
		function(arg0_12)
			return arg0_11.taskVODic[arg0_12] and arg0_11.taskVODic[arg0_12]:IsFinish() and 0 or 1
		end,
		function(arg0_13)
			return arg0_11.taskVODic[arg0_13] and 0 or 1
		end,
		function(arg0_14)
			return arg0_14
		end
	}))
	arg0_11.scrollCom:SetTotalCount(#arg0_11.taskIds, -1)

	arg0_11.canSubmitIds = underscore.select(arg0_11.taskIds, function(arg0_15)
		return arg0_11.taskVODic[arg0_15] and arg0_11.taskVODic[arg0_15]:IsSubmitOnUI() and arg0_11.taskVODic[arg0_15]:IsFinish()
	end)

	setActive(arg0_11.getAllBtn, #arg0_11.canSubmitIds > 0)
end

function var0_0.OnDestroy(arg0_16)
	ClearLScrollrect(arg0_16.scrollCom)
end

return var0_0
