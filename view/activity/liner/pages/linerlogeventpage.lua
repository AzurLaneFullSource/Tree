local var0 = class("LinerLogEventPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "LinerLogEventPage"
end

function var0.OnLoaded(arg0)
	arg0.leftTF = arg0:findTF("left")
	arg0.rightTF = arg0:findTF("right")
	arg0.togglesTF = arg0:findTF("toggles")
	arg0.anim = arg0:findTF("content"):GetComponent(typeof(Animation))

	local var0 = arg0:findTF("content/view/content")

	arg0.itemTFs = {
		arg0:findTF("1", var0),
		arg0:findTF("2", var0),
		(arg0:findTF("3", var0))
	}

	for iter0, iter1 in pairs(arg0.itemTFs) do
		arg0:findTF("empty", iter1):GetComponent(typeof(Image)):SetNativeSize()
	end

	arg0.eventIconTF = arg0:findTF("content/title/Image")
	arg0.awardTF = arg0:findTF("award/mask/IconTpl")
	arg0.awardDesc = arg0:findTF("award/Text")
	arg0.goBtn = arg0:findTF("award/go")
	arg0.getBtn = arg0:findTF("award/get")
	arg0.gotTF = arg0:findTF("award/got")

	setText(arg0:findTF("award/got/title"), i18n("liner_event_award_tip3"))

	arg0.conclusionDesc = arg0:findTF("award/got/Text")
end

function var0.OnInit(arg0)
	arg0:UpdateActivity()
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(LinerLogBookMediator.ON_START_REASONING, arg0.activity.id, arg0.curIdx)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(LinerLogBookMediator.ON_CLOSE)
	end, SFX_CONFIRM)

	arg0.groupIds = arg0.activity:GetEventGroupIds()
	arg0.groups = {}

	for iter0, iter1 in ipairs(arg0.groupIds) do
		arg0.groups[iter0] = LinerEventGroup.New(iter1)
	end

	arg0.toggleUIList = UIItemList.New(arg0.togglesTF, arg0:findTF("tpl", arg0.togglesTF))

	arg0.toggleUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg1 + 1

			arg2.name = var0

			local var1 = i18n("liner_log_event_group_title" .. var0)

			setText(arg2:Find("Text"), var1)
			setText(arg2:Find("selected/Text"), var1)

			if var0 > 1 then
				local var2 = arg0:IsFinishWithGroupIdx(var0 - 1)

				SetCompomentEnabled(arg2, typeof(Toggle), var2)
				setActive(arg2:Find("lock"), not var2)

				if not var2 then
					setActive(arg2:Find("selected"), false)
				end
			end

			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					if arg0.curIdx and arg0.curIdx == var0 then
						return
					end

					arg0.curIdx = var0

					arg0:FlushPage()
				end
			end, SFX_CONFIRM)
		elseif arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("tip"), var0.IsTipWithGroupId(arg0.activity, arg0.groups[arg1 + 1].id))
		end
	end)
	arg0.toggleUIList:align(#arg0.groupIds)
	triggerToggle(arg0:findTF("1", arg0.toggleUIList.container), true)
end

function var0.UpdateActivity(arg0, arg1)
	arg0.activity = arg1 or getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(arg0.activity and not arg0.activity:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	arg0.finishEventIds = arg0.activity:GetFinishEventIds()
end

function var0.FlushPage(arg0)
	arg0.anim:Play()
	arg0.toggleUIList:align(#arg0.groupIds)
	setImageSprite(arg0.eventIconTF, GetSpriteFromAtlas("ui/linermainui_atlas", "event_title" .. arg0.groups[arg0.curIdx].id), true)

	local var0 = false
	local var1 = arg0.groups[arg0.curIdx]:GetIds()

	for iter0, iter1 in ipairs(var1) do
		local var2 = arg0.itemTFs[iter0]

		setActive(var2, true)

		local var3 = arg0:findTF("name/Text", var2)
		local var4 = arg0:findTF("desc", var2)
		local var5 = arg0.groups[arg0.curIdx]:GetEvent(iter1)
		local var6 = table.contains(arg0.finishEventIds, iter1)

		setText(var3, var6 and var5:GetTitle() or i18n("liner_event_title" .. iter0))

		if not var6 then
			var0 = true
		end

		local var7 = var6 and "clue" .. iter1 or "empty" .. iter0

		setImageSprite(arg0:findTF("icon", var2), GetSpriteFromAtlas("ui/linermainui_atlas", var7), true)
		setText(var4, var6 and var5:GetLogDesc() or "")
		setActive(arg0:findTF("empty", var2), not var6)
	end

	for iter2 = #var1 + 1, #arg0.itemTFs do
		setActive(arg0.itemTFs[iter2], false)
	end

	local var8 = arg0.groups[arg0.curIdx]:GetDrop()

	updateDrop(arg0.awardTF, var8)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var8)
	end, SFX_PANEL)

	local var9 = arg0.activity:IsGotEventAward(arg0.curIdx)
	local var10 = not var9 and not var0

	setActive(arg0.goBtn, not var9 and not var10)
	setActive(arg0.getBtn, var10)
	setActive(arg0.gotTF, var9)
	setActive(arg0:findTF("mask", arg0.awardTF), var9)
	setText(arg0.awardDesc, var10 and i18n("liner_event_award_tip2") or i18n("liner_event_award_tip1"))
	setActive(arg0.awardDesc, not var9)

	if var9 then
		local var11 = arg0.activity:GetEventAwardFlag(arg0.curIdx)

		setText(arg0.conclusionDesc, arg0.groups[arg0.curIdx]:GetConclusions()[var11])
	end

	arg0:Show()
end

function var0.OnDestroy(arg0)
	return
end

function var0.IsFinishWithGroupIdx(arg0, arg1)
	return underscore.all(arg0.groups[arg1]:GetIds(), function(arg0)
		return table.contains(arg0.finishEventIds, arg0)
	end)
end

function var0.IsTipWithGroupId(arg0, arg1)
	local var0 = table.indexof(arg0:GetEventGroupIds(), arg1)

	if arg0:IsGotEventAward(var0) then
		return false
	end

	local var1 = arg0:GetFinishEventIds()

	return underscore.all(pg.activity_liner_event_group[arg1].ids, function(arg0)
		return table.contains(var1, arg0)
	end)
end

function var0.IsTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(var0 and not var0:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	local var1 = var0:GetEventGroupIds()

	return underscore.any(var1, function(arg0)
		return var0.IsTipWithGroupId(var0, arg0)
	end)
end

function var0.IsUnlcok()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(var0 and not var0:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	return var0:GetCurIdx() > 7
end

return var0
