local var0_0 = class("TerminalAdventurePage", import("view.base.BaseSubView"))

var0_0.BIND_PT_ACT_ID = ActivityConst.OTHER_WORLD_TERMINAL_PT_ID
var0_0.BIND_TASK_ACT_ID = ActivityConst.OTHER_WORLD_TERMINAL_TASK_ID

function var0_0.getUIName(arg0_1)
	return "TerminalAdventurePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2._tf.name = tostring(OtherworldTerminalLayer.PAGE_ADVENTURE)
	arg0_2.levelTF = arg0_2:findTF("frame/level")

	setText(arg0_2:findTF("title/content/Text", arg0_2.levelTF), i18n("adventure_award_title"))
	setText(arg0_2:findTF("progress/title", arg0_2.levelTF), i18n("adventure_progress_title"))
	setText(arg0_2:findTF("lv", arg0_2.levelTF), i18n("adventure_lv_title"))

	arg0_2.ptIconTF = arg0_2:findTF("progress/Image", arg0_2.levelTF)
	arg0_2.ptValueTF = arg0_2:findTF("progress/value", arg0_2.levelTF)
	arg0_2.ptLvTF = arg0_2:findTF("lv/Text", arg0_2.levelTF)
	arg0_2.awardView = arg0_2:findTF("awards/view", arg0_2.levelTF)
	arg0_2.awardUIList = UIItemList.New(arg0_2:findTF("content", arg0_2.awardView), arg0_2:findTF("content/tpl", arg0_2.awardView))
	arg0_2.recordTF = arg0_2:findTF("frame/record")

	setText(arg0_2:findTF("title/content/Text", arg0_2.recordTF), i18n("adventure_record_title"))
	setText(arg0_2:findTF("grade", arg0_2.recordTF), i18n("adventure_record_grade_title"))

	arg0_2.recordGradeTF = arg0_2:findTF("grade/Text", arg0_2.recordTF)
	arg0_2.taskUIList = UIItemList.New(arg0_2:findTF("form", arg0_2.recordTF), arg0_2:findTF("form/tpl", arg0_2.recordTF))

	setText(arg0_2:findTF("frame/tip"), i18n("adventure_award_end_tip"))

	arg0_2.getBtn = arg0_2:findTF("frame/get_all_btn")

	setText(arg0_2:findTF("Text", arg0_2.getBtn), i18n("adventure_get_all"))

	arg0_2.getGreyBtn = arg0_2:findTF("frame/get_all_btn_grey")

	setText(arg0_2:findTF("Text", arg0_2.getGreyBtn), i18n("adventure_get_all"))
end

function var0_0.OnInit(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityById(var0_0.BIND_PT_ACT_ID)

	assert(var0_3, "not exist bind pt act, id" .. var0_0.BIND_PT_ACT_ID)

	arg0_3.ptData = ActivityPtData.New(var0_3)
	arg0_3.taskActivity = getProxy(ActivityProxy):getActivityById(var0_0.BIND_TASK_ACT_ID)

	assert(arg0_3.taskActivity, "not exist bind task act, id" .. var0_0.BIND_TASK_ACT_ID)
	onButton(arg0_3, arg0_3.getBtn, function()
		local var0_4 = arg0_3.ptData:GetCurrTarget()

		arg0_3:emit(OtherworldTerminalMediator.ON_GET_PT_ALL_AWARD, {
			actId = var0_0.BIND_PT_ACT_ID,
			arg1 = var0_4
		})
	end, SFX_PANEL)
	arg0_3:InitPtUI()
	arg0_3:UpdatePtView()
	arg0_3:InitTaskUI()
	arg0_3:UpdateTaskView()
end

function var0_0.InitPtUI(arg0_5)
	LoadImageSpriteAsync(Drop.New(arg0_5.ptData:GetRes()):getIcon(), arg0_5.ptIconTF, false)
	arg0_5.awardUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg1_6 + 1
			local var1_6 = arg0_5.ptData.dropList[var0_6]
			local var2_6 = arg0_5.ptData.targets[var0_6]
			local var3_6 = Drop.New({
				type = var1_6[1],
				id = var1_6[2],
				count = var1_6[3]
			})

			updateDrop(arg2_6:Find("IconTpl"), var3_6, {
				hideName = true
			})
			onButton(arg0_5.binder, arg2_6:Find("IconTpl"), function()
				arg0_5:emit(BaseUI.ON_DROP, var3_6)
			end, SFX_PANEL)

			local var4_6 = arg0_5.ptData:GetLevel()

			setActive(arg2_6:Find("IconTpl/got"), var0_6 <= var4_6)
			setText(arg2_6:Find("lv"), "Lv:" .. var0_6)
			setActive(arg2_6:Find("lv0"), var0_6 == 1)

			local var5_6 = arg2_6:Find("progress")

			setActive(var5_6:Find("left"), var0_6 ~= 1)
			setActive(var5_6:Find("right"), var0_6 == #arg0_5.ptData.targets)

			if var0_6 <= var4_6 then
				setSlider(var5_6, 0, 1, 1)
			else
				local var6_6 = arg0_5.ptData.targets[var0_6]
				local var7_6 = var0_6 == 1 and 0 or arg0_5.ptData.targets[var0_6 - 1]
				local var8_6 = arg0_5.ptData.count

				setSlider(var5_6, 0, 1, (var8_6 - var7_6) / (var6_6 - var7_6))
			end
		end
	end)
end

function var0_0.UpdatePt(arg0_8, arg1_8)
	arg0_8.ptData = ActivityPtData.New(arg1_8)

	arg0_8:UpdatePtView()
end

function var0_0.UpdatePtView(arg0_9)
	local var0_9 = arg0_9.ptData:CanGetAward()

	setActive(arg0_9.getBtn, var0_9)
	setActive(arg0_9.getGreyBtn, not var0_9)

	local var1_9 = arg0_9.ptData:GetLevel()
	local var2_9, var3_9 = arg0_9.ptData:GetResProgress()

	setText(arg0_9.ptValueTF, math.max(var3_9 - var2_9, 0))
	setText(arg0_9.ptLvTF, var1_9)
	arg0_9.awardUIList:align(#arg0_9.ptData.targets)
	scrollTo(arg0_9.awardView, var1_9 / #arg0_9.ptData.targets, 0)
end

function var0_0.InitTaskUI(arg0_10)
	arg0_10.taskIds = arg0_10.taskActivity:getConfig("config_data")

	arg0_10.taskUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg0_10.taskIds[arg1_11 + 1]
			local var1_11 = getProxy(TaskProxy):getTaskById(var0_11)

			setText(arg0_10:findTF("name", arg2_11), var1_11:getConfig("desc"))
			setText(arg0_10:findTF("value", arg2_11), var1_11:getProgress())
		end
	end)
end

function var0_0.UpdateTask(arg0_12, arg1_12)
	arg0_12.taskActivity = arg1_12

	arg0_12:UpdateTaskView()
end

function var0_0.UpdateTaskView(arg0_13)
	arg0_13.taskUIList:align(#arg0_13.taskIds)
	setText(arg0_13.recordGradeTF, arg0_13:GetAdventureGrade())
end

function var0_0.GetAdventureGrade(arg0_14)
	local var0_14 = arg0_14.taskActivity:getConfig("config_client")

	for iter0_14, iter1_14 in ipairs(var0_14) do
		if #iter1_14[2] > 0 then
			for iter2_14, iter3_14 in ipairs(iter1_14[2]) do
				local var1_14 = iter3_14[1]
				local var2_14 = iter3_14[2]
				local var3_14 = getProxy(TaskProxy):getTaskById(var1_14)

				if var3_14 and var2_14 <= var3_14:getProgress() then
					return iter1_14[1]
				end
			end
		else
			return iter1_14[1]
		end
	end

	return ""
end

function var0_0.OnDestroy(arg0_15)
	return
end

function var0_0.IsTip()
	local var0_16 = getProxy(ActivityProxy):getActivityById(var0_0.BIND_PT_ACT_ID)

	if not var0_16 or var0_16:isEnd() then
		return false
	end

	return ActivityPtData.New(var0_16):CanGetAward()
end

return var0_0
