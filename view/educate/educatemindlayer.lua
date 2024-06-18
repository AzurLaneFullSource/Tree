local var0_0 = class("EducateMindLayer", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateMindUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.taskProxy = getProxy(EducateProxy):GetTaskProxy()
	arg0_3.taskVOs = arg0_3.taskProxy:GetTasksBySystem(EducateTask.SYSTEM_TYPE_MIND)
end

function var0_0.findUI(arg0_4)
	arg0_4.anim = arg0_4:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_4.animEvent = arg0_4:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_4.animEvent:SetEndEvent(function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end)

	arg0_4.windowTF = arg0_4:findTF("anim_root/window")
	arg0_4.scrollview = arg0_4:findTF("scrollview", arg0_4.windowTF)
	arg0_4.emptyTF = arg0_4:findTF("empty", arg0_4.scrollview)

	setText(arg0_4:findTF("Text", arg0_4.emptyTF), i18n("child_mind_empty_tip"))

	arg0_4.contentTF = arg0_4:findTF("view/content", arg0_4.scrollview)
	arg0_4.finishListTF = arg0_4:findTF("finish_list", arg0_4.contentTF)
	arg0_4.finishUIList = UIItemList.New(arg0_4:findTF("list", arg0_4.finishListTF), arg0_4:findTF("list/tpl", arg0_4.finishListTF))

	setText(arg0_4:findTF("title/Text", arg0_4.finishListTF), i18n("child_mind_finish_title"))
	setText(arg0_4:findTF("list/tpl/get_btn/Text", arg0_4.finishListTF), i18n("word_take"))

	arg0_4.unFinishListTF = arg0_4:findTF("unfinish_list", arg0_4.contentTF)
	arg0_4.unFinishUIList = UIItemList.New(arg0_4:findTF("list", arg0_4.unFinishListTF), arg0_4:findTF("list/tpl", arg0_4.unFinishListTF))

	setText(arg0_4:findTF("title/Text", arg0_4.unFinishListTF), i18n("child_mind_processing_title"))
	setText(arg0_4:findTF("list/tpl/time_desc", arg0_4.unFinishListTF), i18n("child_mind_time_title"))
end

function var0_0.addListener(arg0_6)
	onButton(arg0_6, arg0_6:findTF("anim_root/bg"), function()
		arg0_6:_close()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_8)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8._tf, {
		groupName = arg0_8:getGroupNameFromData(),
		weight = arg0_8:getWeightFromData() + 1
	})
	arg0_8.finishUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			GetOrAddComponent(arg2_9, "CanvasGroup").alpha = 1

			arg0_8:updateFinishItem(arg1_9, arg2_9)
		end
	end)
	arg0_8.unFinishUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg0_8:updateUnfinishItem(arg1_10, arg2_10)
		end
	end)
	arg0_8:updateItems()
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_MIND_TASK)
end

function var0_0.sumbitTask(arg0_11, arg1_11)
	arg0_11:emit(EducateMindMediator.ON_TASK_SUBMIT, arg1_11)
end

function var0_0.updateItems(arg0_12)
	local var0_12 = getProxy(EducateProxy):GetCurTime()

	arg0_12.taskVOs = underscore.select(arg0_12.taskVOs, function(arg0_13)
		return arg0_13:InTime(var0_12)
	end)
	arg0_12.finishTaskVOs = {}
	arg0_12.unFinishTaskVOs = {}

	underscore.each(arg0_12.taskVOs, function(arg0_14)
		if arg0_14:IsFinish() then
			table.insert(arg0_12.finishTaskVOs, arg0_14)
		else
			table.insert(arg0_12.unFinishTaskVOs, arg0_14)
		end
	end)

	local var1_12 = CompareFuncs({
		function(arg0_15)
			return arg0_15:GetRemainTime(var0_12)
		end,
		function(arg0_16)
			return arg0_16.id
		end
	})

	table.sort(arg0_12.finishTaskVOs, var1_12)
	table.sort(arg0_12.unFinishTaskVOs, var1_12)
	setActive(arg0_12.finishListTF, #arg0_12.finishTaskVOs > 0)
	arg0_12.finishUIList:align(#arg0_12.finishTaskVOs)
	setActive(arg0_12.unFinishListTF, #arg0_12.unFinishTaskVOs > 0)
	arg0_12.unFinishUIList:align(#arg0_12.unFinishTaskVOs)
	setActive(arg0_12.emptyTF, #arg0_12.finishTaskVOs <= 0 and #arg0_12.unFinishTaskVOs <= 0)
end

function var0_0.updateFinishItem(arg0_17, arg1_17, arg2_17)
	if LeanTween.isTweening(arg2_17.gameObject) then
		LeanTween.cancel(arg2_17.gameObject)
	end

	GetOrAddComponent(arg2_17, "CanvasGroup").alpha = 1

	setActive(arg2_17, true)

	local var0_17 = arg0_17.finishTaskVOs[arg1_17 + 1]

	setText(arg0_17:findTF("desc", arg2_17), var0_17:getConfig("name"))
	onButton(arg0_17, arg0_17:findTF("get_btn", arg2_17), function()
		if not arg0_17.isClick then
			arg0_17.isClick = true

			arg0_17:doAnim(arg2_17, function()
				return
			end)
			onDelayTick(function()
				arg0_17.isClick = nil

				arg0_17:sumbitTask(var0_17)
			end, 0.165)
		end
	end, SFX_PANEL)
end

function var0_0.updateUnfinishItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.unFinishTaskVOs[arg1_21 + 1]

	setText(arg0_21:findTF("desc", arg2_21), var0_21:getConfig("name"))

	local var1_21 = var0_21:GetRemainTime()
	local var2_21 = var1_21 < 7 and 0 or math.floor(var1_21 / 7)

	setText(arg0_21:findTF("time_desc/time", arg2_21), var2_21 .. i18n("word_week"))
end

function var0_0.doAnim(arg0_22, arg1_22, arg2_22)
	local var0_22 = GetOrAddComponent(arg1_22, "CanvasGroup")
	local var1_22 = arg1_22.transform.localPosition

	LeanTween.alphaCanvas(var0_22, 0, 0.198):setFrom(1)
	LeanTween.value(go(arg1_22), var1_22.x, var1_22.x + 200, 0.264):setOnUpdate(System.Action_float(function(arg0_23)
		arg1_22.transform.localPosition = Vector3(arg0_23, var1_22.y, var1_22.z)
	end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
		arg1_22.transform.localPosition = var1_22

		setActive(arg1_22, false)
		arg2_22()
	end))
end

function var0_0.updateView(arg0_25)
	arg0_25:initData()
	arg0_25:updateItems()
end

function var0_0._close(arg0_26)
	if arg0_26.isClick then
		return
	end

	arg0_26.anim:Play("anim_educate_mind_out")
end

function var0_0.onBackPressed(arg0_27)
	arg0_27:_close()
end

function var0_0.willExit(arg0_28)
	arg0_28.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_28._tf)

	if arg0_28.contextData.onExit then
		arg0_28.contextData.onExit()
	end
end

return var0_0
