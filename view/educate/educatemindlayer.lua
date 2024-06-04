local var0 = class("EducateMindLayer", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateMindUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.taskProxy = getProxy(EducateProxy):GetTaskProxy()
	arg0.taskVOs = arg0.taskProxy:GetTasksBySystem(EducateTask.SYSTEM_TYPE_MIND)
end

function var0.findUI(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.windowTF = arg0:findTF("anim_root/window")
	arg0.scrollview = arg0:findTF("scrollview", arg0.windowTF)
	arg0.emptyTF = arg0:findTF("empty", arg0.scrollview)

	setText(arg0:findTF("Text", arg0.emptyTF), i18n("child_mind_empty_tip"))

	arg0.contentTF = arg0:findTF("view/content", arg0.scrollview)
	arg0.finishListTF = arg0:findTF("finish_list", arg0.contentTF)
	arg0.finishUIList = UIItemList.New(arg0:findTF("list", arg0.finishListTF), arg0:findTF("list/tpl", arg0.finishListTF))

	setText(arg0:findTF("title/Text", arg0.finishListTF), i18n("child_mind_finish_title"))
	setText(arg0:findTF("list/tpl/get_btn/Text", arg0.finishListTF), i18n("word_take"))

	arg0.unFinishListTF = arg0:findTF("unfinish_list", arg0.contentTF)
	arg0.unFinishUIList = UIItemList.New(arg0:findTF("list", arg0.unFinishListTF), arg0:findTF("list/tpl", arg0.unFinishListTF))

	setText(arg0:findTF("title/Text", arg0.unFinishListTF), i18n("child_mind_processing_title"))
	setText(arg0:findTF("list/tpl/time_desc", arg0.unFinishListTF), i18n("child_mind_time_title"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0:findTF("anim_root/bg"), function()
		arg0:_close()
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})
	arg0.finishUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			GetOrAddComponent(arg2, "CanvasGroup").alpha = 1

			arg0:updateFinishItem(arg1, arg2)
		end
	end)
	arg0.unFinishUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateUnfinishItem(arg1, arg2)
		end
	end)
	arg0:updateItems()
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_MIND_TASK)
end

function var0.sumbitTask(arg0, arg1)
	arg0:emit(EducateMindMediator.ON_TASK_SUBMIT, arg1)
end

function var0.updateItems(arg0)
	local var0 = getProxy(EducateProxy):GetCurTime()

	arg0.taskVOs = underscore.select(arg0.taskVOs, function(arg0)
		return arg0:InTime(var0)
	end)
	arg0.finishTaskVOs = {}
	arg0.unFinishTaskVOs = {}

	underscore.each(arg0.taskVOs, function(arg0)
		if arg0:IsFinish() then
			table.insert(arg0.finishTaskVOs, arg0)
		else
			table.insert(arg0.unFinishTaskVOs, arg0)
		end
	end)

	local var1 = CompareFuncs({
		function(arg0)
			return arg0:GetRemainTime(var0)
		end,
		function(arg0)
			return arg0.id
		end
	})

	table.sort(arg0.finishTaskVOs, var1)
	table.sort(arg0.unFinishTaskVOs, var1)
	setActive(arg0.finishListTF, #arg0.finishTaskVOs > 0)
	arg0.finishUIList:align(#arg0.finishTaskVOs)
	setActive(arg0.unFinishListTF, #arg0.unFinishTaskVOs > 0)
	arg0.unFinishUIList:align(#arg0.unFinishTaskVOs)
	setActive(arg0.emptyTF, #arg0.finishTaskVOs <= 0 and #arg0.unFinishTaskVOs <= 0)
end

function var0.updateFinishItem(arg0, arg1, arg2)
	if LeanTween.isTweening(arg2.gameObject) then
		LeanTween.cancel(arg2.gameObject)
	end

	GetOrAddComponent(arg2, "CanvasGroup").alpha = 1

	setActive(arg2, true)

	local var0 = arg0.finishTaskVOs[arg1 + 1]

	setText(arg0:findTF("desc", arg2), var0:getConfig("name"))
	onButton(arg0, arg0:findTF("get_btn", arg2), function()
		if not arg0.isClick then
			arg0.isClick = true

			arg0:doAnim(arg2, function()
				return
			end)
			onDelayTick(function()
				arg0.isClick = nil

				arg0:sumbitTask(var0)
			end, 0.165)
		end
	end, SFX_PANEL)
end

function var0.updateUnfinishItem(arg0, arg1, arg2)
	local var0 = arg0.unFinishTaskVOs[arg1 + 1]

	setText(arg0:findTF("desc", arg2), var0:getConfig("name"))

	local var1 = var0:GetRemainTime()
	local var2 = var1 < 7 and 0 or math.floor(var1 / 7)

	setText(arg0:findTF("time_desc/time", arg2), var2 .. i18n("word_week"))
end

function var0.doAnim(arg0, arg1, arg2)
	local var0 = GetOrAddComponent(arg1, "CanvasGroup")
	local var1 = arg1.transform.localPosition

	LeanTween.alphaCanvas(var0, 0, 0.198):setFrom(1)
	LeanTween.value(go(arg1), var1.x, var1.x + 200, 0.264):setOnUpdate(System.Action_float(function(arg0)
		arg1.transform.localPosition = Vector3(arg0, var1.y, var1.z)
	end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
		arg1.transform.localPosition = var1

		setActive(arg1, false)
		arg2()
	end))
end

function var0.updateView(arg0)
	arg0:initData()
	arg0:updateItems()
end

function var0._close(arg0)
	if arg0.isClick then
		return
	end

	arg0.anim:Play("anim_educate_mind_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
