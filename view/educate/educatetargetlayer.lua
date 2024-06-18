local var0_0 = class("EducateTargetLayer", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateTargetUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.taskProxy = getProxy(EducateProxy):GetTaskProxy()
	arg0_3.targetId = arg0_3.taskProxy:GetTargetId()
	arg0_3.mainTaskVOs = arg0_3.taskProxy:FilterByGroup(arg0_3.taskProxy:GetMainTasksForShow())
	arg0_3.otherTaskVOs = arg0_3.taskProxy:FilterByGroup(arg0_3.taskProxy:GetTargetTasksForShow())
	arg0_3.canGetTargetAward = arg0_3.taskProxy:CanGetTargetAward()
end

function var0_0.findUI(arg0_4)
	arg0_4.anim = arg0_4:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_4.animEvent = arg0_4:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_4.animEvent:SetEndEvent(function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end)

	arg0_4.windowTF = arg0_4:findTF("anim_root/window")
	arg0_4.leftTF = arg0_4:findTF("left/content", arg0_4.windowTF)
	arg0_4.leftEmptyTF = arg0_4:findTF("left/empty", arg0_4.windowTF)

	setText(arg0_4:findTF("target_info/Text", arg0_4.leftEmptyTF), i18n("child_target_set_empty"))

	arg0_4.targetSetBtn = arg0_4:findTF("target_info/target_set_btn", arg0_4.leftEmptyTF)

	setText(arg0_4:findTF("skip_title", arg0_4.targetSetBtn), i18n("child_target_set_skip"))

	arg0_4.targetInfoTF = arg0_4:findTF("target_info", arg0_4.leftTF)
	arg0_4.iconTF = arg0_4:findTF("icon", arg0_4.targetInfoTF)
	arg0_4.nameTF = arg0_4:findTF("name_bg/name", arg0_4.targetInfoTF)
	arg0_4.unfinishTF = arg0_4:findTF("unfinish", arg0_4.targetInfoTF)
	arg0_4.sliderTF = arg0_4:findTF("progress", arg0_4.unfinishTF)
	arg0_4.progressWhiteTF = arg0_4:findTF("white", arg0_4.sliderTF)

	setActive(arg0_4.progressWhiteTF, true)
	setText(arg0_4:findTF("progress/title", arg0_4.unfinishTF), i18n("child_target_progress"))

	arg0_4.progressTextTF = arg0_4:findTF("progress/title/Text", arg0_4.unfinishTF)
	arg0_4.targetAwardTF = arg0_4:findTF("award", arg0_4.unfinishTF)
	arg0_4.finishTF = arg0_4:findTF("finish", arg0_4.targetInfoTF)

	setText(arg0_4:findTF("Text", arg0_4.finishTF), i18n("child_target_finish_tip"))
	setText(arg0_4:findTF("time/title", arg0_4.leftTF), i18n("child_target_time_title"))

	arg0_4.timeTF = arg0_4:findTF("time/Text", arg0_4.leftTF)
	arg0_4.taskContentTF = arg0_4:findTF("task_scrollview/content", arg0_4.windowTF)
	arg0_4.mainTaskTF = arg0_4:findTF("main_list", arg0_4.taskContentTF)

	setText(arg0_4:findTF("list/tpl/status/get/btn/Text", arg0_4.mainTaskTF), i18n("word_take"))

	arg0_4.mainTaskUIList = UIItemList.New(arg0_4:findTF("list", arg0_4.mainTaskTF), arg0_4:findTF("list/tpl", arg0_4.mainTaskTF))
	arg0_4.mainTitleTF = arg0_4:findTF("title/Text", arg0_4.mainTaskTF)

	setText(arg0_4.mainTitleTF, i18n("child_target_title1"))

	arg0_4.mainProgressTF = arg0_4:findTF("title/progress", arg0_4.mainTaskTF)

	setActive(arg0_4.mainProgressTF, false)

	arg0_4.otherTaskTF = arg0_4:findTF("other_list", arg0_4.taskContentTF)

	setText(arg0_4:findTF("list/tpl/status/get/btn/Text", arg0_4.otherTaskTF), i18n("word_take"))

	arg0_4.otherTaskUIList = UIItemList.New(arg0_4:findTF("list", arg0_4.otherTaskTF), arg0_4:findTF("list/tpl", arg0_4.otherTaskTF))
	arg0_4.otherTitleTF = arg0_4:findTF("title/Text", arg0_4.otherTaskTF)

	setText(arg0_4.otherTitleTF, i18n("child_target_title2"))
end

function var0_0.addListener(arg0_6)
	onButton(arg0_6, arg0_6:findTF("anim_root/close"), function()
		arg0_6:_close()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.targetSetBtn, function()
		function arg0_6.onExit()
			getProxy(EducateProxy):MainAddLayer(Context.New({
				viewComponent = EducateTargetSetLayer,
				mediator = EducateTargetSetMediator
			}))
		end

		arg0_6:_close()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_10)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_10._tf, {
		groupName = arg0_10:getGroupNameFromData(),
		weight = arg0_10:getWeightFromData() + 1
	})
	arg0_10:initLeft()
	arg0_10.mainTaskUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_10:updateItem(arg1_11, arg2_11, "main")
		end
	end)
	arg0_10.otherTaskUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			arg0_10:updateItem(arg1_12, arg2_12, "other")
		end
	end)
	arg0_10:updateItems()
	EducateGuideSequence.CheckGuide(arg0_10.__cname, function()
		return
	end)
end

function var0_0.sumbitTask(arg0_14, arg1_14)
	arg0_14:emit(EducateTargetMediator.ON_TASK_SUBMIT, arg1_14)
end

function var0_0.initLeft(arg0_15)
	setActive(arg0_15.leftTF, arg0_15.targetId ~= 0)
	setActive(arg0_15.leftEmptyTF, arg0_15.targetId == 0)

	if arg0_15.targetId ~= 0 then
		local var0_15 = pg.child_target_set[arg0_15.targetId]

		LoadImageSpriteAsync("educatetarget/" .. var0_15.icon, arg0_15.iconTF, true)
		setText(arg0_15.nameTF, var0_15.name)

		local var1_15 = var0_15.drop_display
		local var2_15 = {
			type = var1_15[1],
			id = var1_15[2],
			number = var1_15[3]
		}

		EducateHelper.UpdateDropShow(arg0_15.targetAwardTF, var2_15)
		onButton(arg0_15, arg0_15.targetAwardTF, function()
			if arg0_15.canGetFinishAward then
				arg0_15:emit(EducateTargetMediator.ON_GET_TARGET_AWARD)
			else
				arg0_15:emit(var0_0.EDUCATE_ON_ITEM, {
					drop = var2_15
				})
			end
		end, SFX_PANEL)

		local var3_15 = getProxy(EducateProxy):GetCharData():GetStageReaminWeek(var0_15.stage)
		local var4_15 = var3_15 <= 1 and i18n("word_in_one_week") or var3_15 .. i18n("word_week")

		setText(arg0_15.timeTF, var4_15)
	end

	arg0_15:updataTarget()
end

function var0_0.updataTarget(arg0_17)
	local var0_17, var1_17 = getProxy(EducateProxy):GetTaskProxy():GetOtherTargetTaskProgress()
	local var2_17 = var0_17 / var1_17

	if var2_17 > 1 then
		var2_17 = 1
	end

	if var1_17 == 0 then
		var2_17 = 1
	end

	setText(arg0_17.progressTextTF, var0_17 .. "/" .. var1_17)

	if not arg0_17.lastProgress or var2_17 <= arg0_17.lastProgress then
		setSlider(arg0_17.sliderTF, 0, 1, var2_17)

		arg0_17.lastProgress = var2_17
	else
		arg0_17:playProgressAnim(var2_17)

		arg0_17.lastProgress = var2_17
	end

	local var3_17 = var2_17 >= 1

	arg0_17.canGetFinishAward = var3_17 and arg0_17.canGetTargetAward

	setActive(arg0_17.unfinishTF, not var3_17 or arg0_17.canGetFinishAward)
	setActive(arg0_17:findTF("receiveVX", arg0_17.targetAwardTF), arg0_17.canGetFinishAward)
	setActive(arg0_17:findTF("tip", arg0_17.unfinishTF), arg0_17.canGetFinishAward)
	setActive(arg0_17.finishTF, var3_17 and not arg0_17.canGetTargetAward)
end

function var0_0.playProgressAnim(arg0_18, arg1_18)
	arg0_18:cleanManagedTween()

	local var0_18 = arg0_18.sliderTF:GetComponent(typeof(Slider)).value
	local var1_18 = arg0_18.sliderTF.rect

	arg0_18.progressWhiteTF.sizeDelta = Vector2(var1_18.width * arg1_18, var1_18.height)

	arg0_18.sliderTF:GetComponent(typeof(Animation)):Play("anim_educate_target_progress_add")
	arg0_18:managedTween(LeanTween.delayedCall, function()
		arg0_18:managedTween(LeanTween.value, nil, go(arg0_18.sliderTF), var0_18, arg1_18, 0.264):setOnUpdate(System.Action_float(function(arg0_20)
			setSlider(arg0_18.sliderTF, 0, 1, arg0_20)
		end)):setEase(LeanTweenType.easeInCubic)
	end, 0.132, nil)
end

function var0_0.updateItems(arg0_21)
	setActive(arg0_21.mainTaskTF, #arg0_21.mainTaskVOs > 0)
	arg0_21.mainTaskUIList:align(#arg0_21.mainTaskVOs)
	setActive(arg0_21.otherTaskTF, #arg0_21.otherTaskVOs > 0)
	arg0_21.otherTaskUIList:align(#arg0_21.otherTaskVOs)
end

function var0_0.updateItem(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg3_22 == "main" and arg0_22.mainTaskVOs[arg1_22 + 1] or arg0_22.otherTaskVOs[arg1_22 + 1]

	setText(arg0_22:findTF("desc", arg2_22), var0_22:getConfig("name"))
	setText(arg0_22:findTF("status/go/btn/Text", arg2_22), var0_22:GetProgress() .. "/" .. var0_22:GetFinishNum())

	local var1_22 = var0_22:GetTaskStatus()

	setActive(arg0_22:findTF("status/go", arg2_22), var1_22 == EducateTask.STATUS_UNFINISH)
	setActive(arg0_22:findTF("status/get", arg2_22), var1_22 == EducateTask.STATUS_FINISH)
	setActive(arg0_22:findTF("status/got", arg2_22), var1_22 == EducateTask.STATUS_RECEIVE)

	local var2_22 = var0_22:GetAwardShow()

	EducateHelper.UpdateDropShow(arg0_22:findTF("award", arg2_22), var2_22)
	onButton(arg0_22, arg0_22:findTF("award", arg2_22), function()
		arg0_22:emit(var0_0.EDUCATE_ON_ITEM, {
			drop = var2_22
		})
	end)
	onButton(arg0_22, arg0_22:findTF("status/get", arg2_22), function()
		if arg0_22.isClick then
			return
		end

		arg0_22.isClick = true

		local var0_24 = var0_22:IsMain() and "anim_educate_target_tpl_maingot" or "anim_educate_target_tpl_othergot"

		arg2_22:GetComponent(typeof(Animation)):Play(var0_24)
		onDelayTick(function()
			arg0_22.isClick = nil

			arg0_22:sumbitTask(var0_22)
			var0_22:SetRecieve()
		end, 0.5)
	end, SFX_PANEL)
end

function var0_0.updateView(arg0_26)
	arg0_26:initData()
	arg0_26:updateItems()
	arg0_26:updataTarget()
end

function var0_0._close(arg0_27)
	if arg0_27.isClick then
		return
	end

	arg0_27.anim:Play("anim_educate_target_out")
end

function var0_0.onBackPressed(arg0_28)
	arg0_28:_close()
end

function var0_0.willExit(arg0_29)
	arg0_29.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_29._tf)

	if arg0_29.onExit then
		arg0_29.onExit()
	elseif getProxy(EducateProxy):GetCurTime().month == 2 then
		getProxy(EducateProxy):CheckGuide("EducateScene")
	end
end

return var0_0
