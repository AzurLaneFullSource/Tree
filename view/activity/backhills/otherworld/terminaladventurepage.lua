local var0 = class("TerminalAdventurePage", import("view.base.BaseSubView"))

var0.BIND_PT_ACT_ID = ActivityConst.OTHER_WORLD_TERMINAL_PT_ID
var0.BIND_TASK_ACT_ID = ActivityConst.OTHER_WORLD_TERMINAL_TASK_ID

function var0.getUIName(arg0)
	return "TerminalAdventurePage"
end

function var0.OnLoaded(arg0)
	arg0._tf.name = tostring(OtherworldTerminalLayer.PAGE_ADVENTURE)
	arg0.levelTF = arg0:findTF("frame/level")

	setText(arg0:findTF("title/content/Text", arg0.levelTF), i18n("adventure_award_title"))
	setText(arg0:findTF("progress/title", arg0.levelTF), i18n("adventure_progress_title"))
	setText(arg0:findTF("lv", arg0.levelTF), i18n("adventure_lv_title"))

	arg0.ptIconTF = arg0:findTF("progress/Image", arg0.levelTF)
	arg0.ptValueTF = arg0:findTF("progress/value", arg0.levelTF)
	arg0.ptLvTF = arg0:findTF("lv/Text", arg0.levelTF)
	arg0.awardView = arg0:findTF("awards/view", arg0.levelTF)
	arg0.awardUIList = UIItemList.New(arg0:findTF("content", arg0.awardView), arg0:findTF("content/tpl", arg0.awardView))
	arg0.recordTF = arg0:findTF("frame/record")

	setText(arg0:findTF("title/content/Text", arg0.recordTF), i18n("adventure_record_title"))
	setText(arg0:findTF("grade", arg0.recordTF), i18n("adventure_record_grade_title"))

	arg0.recordGradeTF = arg0:findTF("grade/Text", arg0.recordTF)
	arg0.taskUIList = UIItemList.New(arg0:findTF("form", arg0.recordTF), arg0:findTF("form/tpl", arg0.recordTF))

	setText(arg0:findTF("frame/tip"), i18n("adventure_award_end_tip"))

	arg0.getBtn = arg0:findTF("frame/get_all_btn")

	setText(arg0:findTF("Text", arg0.getBtn), i18n("adventure_get_all"))

	arg0.getGreyBtn = arg0:findTF("frame/get_all_btn_grey")

	setText(arg0:findTF("Text", arg0.getGreyBtn), i18n("adventure_get_all"))
end

function var0.OnInit(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(var0.BIND_PT_ACT_ID)

	assert(var0, "not exist bind pt act, id" .. var0.BIND_PT_ACT_ID)

	arg0.ptData = ActivityPtData.New(var0)
	arg0.taskActivity = getProxy(ActivityProxy):getActivityById(var0.BIND_TASK_ACT_ID)

	assert(arg0.taskActivity, "not exist bind task act, id" .. var0.BIND_TASK_ACT_ID)
	onButton(arg0, arg0.getBtn, function()
		local var0 = arg0.ptData:GetCurrTarget()

		arg0:emit(OtherworldTerminalMediator.ON_GET_PT_ALL_AWARD, {
			actId = var0.BIND_PT_ACT_ID,
			arg1 = var0
		})
	end, SFX_PANEL)
	arg0:InitPtUI()
	arg0:UpdatePtView()
	arg0:InitTaskUI()
	arg0:UpdateTaskView()
end

function var0.InitPtUI(arg0)
	LoadImageSpriteAsync(Drop.New(arg0.ptData:GetRes()):getIcon(), arg0.ptIconTF, false)
	arg0.awardUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0.ptData.dropList[var0]
			local var2 = arg0.ptData.targets[var0]
			local var3 = Drop.New({
				type = var1[1],
				id = var1[2],
				count = var1[3]
			})

			updateDrop(arg2:Find("IconTpl"), var3, {
				hideName = true
			})
			onButton(arg0.binder, arg2:Find("IconTpl"), function()
				arg0:emit(BaseUI.ON_DROP, var3)
			end, SFX_PANEL)

			local var4 = arg0.ptData:GetLevel()

			setActive(arg2:Find("IconTpl/got"), var0 <= var4)
			setText(arg2:Find("lv"), "Lv:" .. var0)
			setActive(arg2:Find("lv0"), var0 == 1)

			local var5 = arg2:Find("progress")

			setActive(var5:Find("left"), var0 ~= 1)
			setActive(var5:Find("right"), var0 == #arg0.ptData.targets)

			if var0 <= var4 then
				setSlider(var5, 0, 1, 1)
			else
				local var6 = arg0.ptData.targets[var0]
				local var7 = var0 == 1 and 0 or arg0.ptData.targets[var0 - 1]
				local var8 = arg0.ptData.count

				setSlider(var5, 0, 1, (var8 - var7) / (var6 - var7))
			end
		end
	end)
end

function var0.UpdatePt(arg0, arg1)
	arg0.ptData = ActivityPtData.New(arg1)

	arg0:UpdatePtView()
end

function var0.UpdatePtView(arg0)
	local var0 = arg0.ptData:CanGetAward()

	setActive(arg0.getBtn, var0)
	setActive(arg0.getGreyBtn, not var0)

	local var1 = arg0.ptData:GetLevel()
	local var2, var3 = arg0.ptData:GetResProgress()

	setText(arg0.ptValueTF, math.max(var3 - var2, 0))
	setText(arg0.ptLvTF, var1)
	arg0.awardUIList:align(#arg0.ptData.targets)
	scrollTo(arg0.awardView, var1 / #arg0.ptData.targets, 0)
end

function var0.InitTaskUI(arg0)
	arg0.taskIds = arg0.taskActivity:getConfig("config_data")

	arg0.taskUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.taskIds[arg1 + 1]
			local var1 = getProxy(TaskProxy):getTaskById(var0)

			setText(arg0:findTF("name", arg2), var1:getConfig("desc"))
			setText(arg0:findTF("value", arg2), var1:getProgress())
		end
	end)
end

function var0.UpdateTask(arg0, arg1)
	arg0.taskActivity = arg1

	arg0:UpdateTaskView()
end

function var0.UpdateTaskView(arg0)
	arg0.taskUIList:align(#arg0.taskIds)
	setText(arg0.recordGradeTF, arg0:GetAdventureGrade())
end

function var0.GetAdventureGrade(arg0)
	local var0 = arg0.taskActivity:getConfig("config_client")

	for iter0, iter1 in ipairs(var0) do
		if #iter1[2] > 0 then
			for iter2, iter3 in ipairs(iter1[2]) do
				local var1 = iter3[1]
				local var2 = iter3[2]
				local var3 = getProxy(TaskProxy):getTaskById(var1)

				if var3 and var2 <= var3:getProgress() then
					return iter1[1]
				end
			end
		else
			return iter1[1]
		end
	end

	return ""
end

function var0.OnDestroy(arg0)
	return
end

function var0.IsTip()
	local var0 = getProxy(ActivityProxy):getActivityById(var0.BIND_PT_ACT_ID)

	if not var0 or var0:isEnd() then
		return false
	end

	return ActivityPtData.New(var0):CanGetAward()
end

return var0
