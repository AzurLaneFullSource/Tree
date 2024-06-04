local var0 = class("EducateTargetLayer", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateTargetUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.taskProxy = getProxy(EducateProxy):GetTaskProxy()
	arg0.targetId = arg0.taskProxy:GetTargetId()
	arg0.mainTaskVOs = arg0.taskProxy:FilterByGroup(arg0.taskProxy:GetMainTasksForShow())
	arg0.otherTaskVOs = arg0.taskProxy:FilterByGroup(arg0.taskProxy:GetTargetTasksForShow())
	arg0.canGetTargetAward = arg0.taskProxy:CanGetTargetAward()
end

function var0.findUI(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.windowTF = arg0:findTF("anim_root/window")
	arg0.leftTF = arg0:findTF("left/content", arg0.windowTF)
	arg0.leftEmptyTF = arg0:findTF("left/empty", arg0.windowTF)

	setText(arg0:findTF("target_info/Text", arg0.leftEmptyTF), i18n("child_target_set_empty"))

	arg0.targetSetBtn = arg0:findTF("target_info/target_set_btn", arg0.leftEmptyTF)

	setText(arg0:findTF("skip_title", arg0.targetSetBtn), i18n("child_target_set_skip"))

	arg0.targetInfoTF = arg0:findTF("target_info", arg0.leftTF)
	arg0.iconTF = arg0:findTF("icon", arg0.targetInfoTF)
	arg0.nameTF = arg0:findTF("name_bg/name", arg0.targetInfoTF)
	arg0.unfinishTF = arg0:findTF("unfinish", arg0.targetInfoTF)
	arg0.sliderTF = arg0:findTF("progress", arg0.unfinishTF)
	arg0.progressWhiteTF = arg0:findTF("white", arg0.sliderTF)

	setActive(arg0.progressWhiteTF, true)
	setText(arg0:findTF("progress/title", arg0.unfinishTF), i18n("child_target_progress"))

	arg0.progressTextTF = arg0:findTF("progress/title/Text", arg0.unfinishTF)
	arg0.targetAwardTF = arg0:findTF("award", arg0.unfinishTF)
	arg0.finishTF = arg0:findTF("finish", arg0.targetInfoTF)

	setText(arg0:findTF("Text", arg0.finishTF), i18n("child_target_finish_tip"))
	setText(arg0:findTF("time/title", arg0.leftTF), i18n("child_target_time_title"))

	arg0.timeTF = arg0:findTF("time/Text", arg0.leftTF)
	arg0.taskContentTF = arg0:findTF("task_scrollview/content", arg0.windowTF)
	arg0.mainTaskTF = arg0:findTF("main_list", arg0.taskContentTF)

	setText(arg0:findTF("list/tpl/status/get/btn/Text", arg0.mainTaskTF), i18n("word_take"))

	arg0.mainTaskUIList = UIItemList.New(arg0:findTF("list", arg0.mainTaskTF), arg0:findTF("list/tpl", arg0.mainTaskTF))
	arg0.mainTitleTF = arg0:findTF("title/Text", arg0.mainTaskTF)

	setText(arg0.mainTitleTF, i18n("child_target_title1"))

	arg0.mainProgressTF = arg0:findTF("title/progress", arg0.mainTaskTF)

	setActive(arg0.mainProgressTF, false)

	arg0.otherTaskTF = arg0:findTF("other_list", arg0.taskContentTF)

	setText(arg0:findTF("list/tpl/status/get/btn/Text", arg0.otherTaskTF), i18n("word_take"))

	arg0.otherTaskUIList = UIItemList.New(arg0:findTF("list", arg0.otherTaskTF), arg0:findTF("list/tpl", arg0.otherTaskTF))
	arg0.otherTitleTF = arg0:findTF("title/Text", arg0.otherTaskTF)

	setText(arg0.otherTitleTF, i18n("child_target_title2"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0:findTF("anim_root/close"), function()
		arg0:_close()
	end, SFX_PANEL)
	onButton(arg0, arg0.targetSetBtn, function()
		function arg0.onExit()
			getProxy(EducateProxy):MainAddLayer(Context.New({
				viewComponent = EducateTargetSetLayer,
				mediator = EducateTargetSetMediator
			}))
		end

		arg0:_close()
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})
	arg0:initLeft()
	arg0.mainTaskUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateItem(arg1, arg2, "main")
		end
	end)
	arg0.otherTaskUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateItem(arg1, arg2, "other")
		end
	end)
	arg0:updateItems()
	EducateGuideSequence.CheckGuide(arg0.__cname, function()
		return
	end)
end

function var0.sumbitTask(arg0, arg1)
	arg0:emit(EducateTargetMediator.ON_TASK_SUBMIT, arg1)
end

function var0.initLeft(arg0)
	setActive(arg0.leftTF, arg0.targetId ~= 0)
	setActive(arg0.leftEmptyTF, arg0.targetId == 0)

	if arg0.targetId ~= 0 then
		local var0 = pg.child_target_set[arg0.targetId]

		LoadImageSpriteAsync("educatetarget/" .. var0.icon, arg0.iconTF, true)
		setText(arg0.nameTF, var0.name)

		local var1 = var0.drop_display
		local var2 = {
			type = var1[1],
			id = var1[2],
			number = var1[3]
		}

		EducateHelper.UpdateDropShow(arg0.targetAwardTF, var2)
		onButton(arg0, arg0.targetAwardTF, function()
			if arg0.canGetFinishAward then
				arg0:emit(EducateTargetMediator.ON_GET_TARGET_AWARD)
			else
				arg0:emit(var0.EDUCATE_ON_ITEM, {
					drop = var2
				})
			end
		end, SFX_PANEL)

		local var3 = getProxy(EducateProxy):GetCharData():GetStageReaminWeek(var0.stage)
		local var4 = var3 <= 1 and i18n("word_in_one_week") or var3 .. i18n("word_week")

		setText(arg0.timeTF, var4)
	end

	arg0:updataTarget()
end

function var0.updataTarget(arg0)
	local var0, var1 = getProxy(EducateProxy):GetTaskProxy():GetOtherTargetTaskProgress()
	local var2 = var0 / var1

	if var2 > 1 then
		var2 = 1
	end

	if var1 == 0 then
		var2 = 1
	end

	setText(arg0.progressTextTF, var0 .. "/" .. var1)

	if not arg0.lastProgress or var2 <= arg0.lastProgress then
		setSlider(arg0.sliderTF, 0, 1, var2)

		arg0.lastProgress = var2
	else
		arg0:playProgressAnim(var2)

		arg0.lastProgress = var2
	end

	local var3 = var2 >= 1

	arg0.canGetFinishAward = var3 and arg0.canGetTargetAward

	setActive(arg0.unfinishTF, not var3 or arg0.canGetFinishAward)
	setActive(arg0:findTF("receiveVX", arg0.targetAwardTF), arg0.canGetFinishAward)
	setActive(arg0:findTF("tip", arg0.unfinishTF), arg0.canGetFinishAward)
	setActive(arg0.finishTF, var3 and not arg0.canGetTargetAward)
end

function var0.playProgressAnim(arg0, arg1)
	arg0:cleanManagedTween()

	local var0 = arg0.sliderTF:GetComponent(typeof(Slider)).value
	local var1 = arg0.sliderTF.rect

	arg0.progressWhiteTF.sizeDelta = Vector2(var1.width * arg1, var1.height)

	arg0.sliderTF:GetComponent(typeof(Animation)):Play("anim_educate_target_progress_add")
	arg0:managedTween(LeanTween.delayedCall, function()
		arg0:managedTween(LeanTween.value, nil, go(arg0.sliderTF), var0, arg1, 0.264):setOnUpdate(System.Action_float(function(arg0)
			setSlider(arg0.sliderTF, 0, 1, arg0)
		end)):setEase(LeanTweenType.easeInCubic)
	end, 0.132, nil)
end

function var0.updateItems(arg0)
	setActive(arg0.mainTaskTF, #arg0.mainTaskVOs > 0)
	arg0.mainTaskUIList:align(#arg0.mainTaskVOs)
	setActive(arg0.otherTaskTF, #arg0.otherTaskVOs > 0)
	arg0.otherTaskUIList:align(#arg0.otherTaskVOs)
end

function var0.updateItem(arg0, arg1, arg2, arg3)
	local var0 = arg3 == "main" and arg0.mainTaskVOs[arg1 + 1] or arg0.otherTaskVOs[arg1 + 1]

	setText(arg0:findTF("desc", arg2), var0:getConfig("name"))
	setText(arg0:findTF("status/go/btn/Text", arg2), var0:GetProgress() .. "/" .. var0:GetFinishNum())

	local var1 = var0:GetTaskStatus()

	setActive(arg0:findTF("status/go", arg2), var1 == EducateTask.STATUS_UNFINISH)
	setActive(arg0:findTF("status/get", arg2), var1 == EducateTask.STATUS_FINISH)
	setActive(arg0:findTF("status/got", arg2), var1 == EducateTask.STATUS_RECEIVE)

	local var2 = var0:GetAwardShow()

	EducateHelper.UpdateDropShow(arg0:findTF("award", arg2), var2)
	onButton(arg0, arg0:findTF("award", arg2), function()
		arg0:emit(var0.EDUCATE_ON_ITEM, {
			drop = var2
		})
	end)
	onButton(arg0, arg0:findTF("status/get", arg2), function()
		if arg0.isClick then
			return
		end

		arg0.isClick = true

		local var0 = var0:IsMain() and "anim_educate_target_tpl_maingot" or "anim_educate_target_tpl_othergot"

		arg2:GetComponent(typeof(Animation)):Play(var0)
		onDelayTick(function()
			arg0.isClick = nil

			arg0:sumbitTask(var0)
			var0:SetRecieve()
		end, 0.5)
	end, SFX_PANEL)
end

function var0.updateView(arg0)
	arg0:initData()
	arg0:updateItems()
	arg0:updataTarget()
end

function var0._close(arg0)
	if arg0.isClick then
		return
	end

	arg0.anim:Play("anim_educate_target_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)

	if arg0.onExit then
		arg0.onExit()
	elseif getProxy(EducateProxy):GetCurTime().month == 2 then
		getProxy(EducateProxy):CheckGuide("EducateScene")
	end
end

return var0
