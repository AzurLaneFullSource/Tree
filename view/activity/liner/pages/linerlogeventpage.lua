local var0_0 = class("LinerLogEventPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LinerLogEventPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.leftTF = arg0_2:findTF("left")
	arg0_2.rightTF = arg0_2:findTF("right")
	arg0_2.togglesTF = arg0_2:findTF("toggles")
	arg0_2.anim = arg0_2:findTF("content"):GetComponent(typeof(Animation))

	local var0_2 = arg0_2:findTF("content/view/content")

	arg0_2.itemTFs = {
		arg0_2:findTF("1", var0_2),
		arg0_2:findTF("2", var0_2),
		(arg0_2:findTF("3", var0_2))
	}

	for iter0_2, iter1_2 in pairs(arg0_2.itemTFs) do
		arg0_2:findTF("empty", iter1_2):GetComponent(typeof(Image)):SetNativeSize()
	end

	arg0_2.eventIconTF = arg0_2:findTF("content/title/Image")
	arg0_2.awardTF = arg0_2:findTF("award/mask/IconTpl")
	arg0_2.awardDesc = arg0_2:findTF("award/Text")
	arg0_2.goBtn = arg0_2:findTF("award/go")
	arg0_2.getBtn = arg0_2:findTF("award/get")
	arg0_2.gotTF = arg0_2:findTF("award/got")

	setText(arg0_2:findTF("award/got/title"), i18n("liner_event_award_tip3"))

	arg0_2.conclusionDesc = arg0_2:findTF("award/got/Text")
end

function var0_0.OnInit(arg0_3)
	arg0_3:UpdateActivity()
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(LinerLogBookMediator.ON_START_REASONING, arg0_3.activity.id, arg0_3.curIdx)
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(LinerLogBookMediator.ON_CLOSE)
	end, SFX_CONFIRM)

	arg0_3.groupIds = arg0_3.activity:GetEventGroupIds()
	arg0_3.groups = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.groupIds) do
		arg0_3.groups[iter0_3] = LinerEventGroup.New(iter1_3)
	end

	arg0_3.toggleUIList = UIItemList.New(arg0_3.togglesTF, arg0_3:findTF("tpl", arg0_3.togglesTF))

	arg0_3.toggleUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			local var0_6 = arg1_6 + 1

			arg2_6.name = var0_6

			local var1_6 = i18n("liner_log_event_group_title" .. var0_6)

			setText(arg2_6:Find("Text"), var1_6)
			setText(arg2_6:Find("selected/Text"), var1_6)

			if var0_6 > 1 then
				local var2_6 = arg0_3:IsFinishWithGroupIdx(var0_6 - 1)

				SetCompomentEnabled(arg2_6, typeof(Toggle), var2_6)
				setActive(arg2_6:Find("lock"), not var2_6)

				if not var2_6 then
					setActive(arg2_6:Find("selected"), false)
				end
			end

			onToggle(arg0_3, arg2_6, function(arg0_7)
				if arg0_7 then
					if arg0_3.curIdx and arg0_3.curIdx == var0_6 then
						return
					end

					arg0_3.curIdx = var0_6

					arg0_3:FlushPage()
				end
			end, SFX_CONFIRM)
		elseif arg0_6 == UIItemList.EventUpdate then
			setActive(arg2_6:Find("tip"), var0_0.IsTipWithGroupId(arg0_3.activity, arg0_3.groups[arg1_6 + 1].id))
		end
	end)
	arg0_3.toggleUIList:align(#arg0_3.groupIds)
	triggerToggle(arg0_3:findTF("1", arg0_3.toggleUIList.container), true)
end

function var0_0.UpdateActivity(arg0_8, arg1_8)
	arg0_8.activity = arg1_8 or getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(arg0_8.activity and not arg0_8.activity:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	arg0_8.finishEventIds = arg0_8.activity:GetFinishEventIds()
end

function var0_0.FlushPage(arg0_9)
	arg0_9.anim:Play()
	arg0_9.toggleUIList:align(#arg0_9.groupIds)
	setImageSprite(arg0_9.eventIconTF, GetSpriteFromAtlas("ui/linermainui_atlas", "event_title" .. arg0_9.groups[arg0_9.curIdx].id), true)

	local var0_9 = false
	local var1_9 = arg0_9.groups[arg0_9.curIdx]:GetIds()

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var2_9 = arg0_9.itemTFs[iter0_9]

		setActive(var2_9, true)

		local var3_9 = arg0_9:findTF("name/Text", var2_9)
		local var4_9 = arg0_9:findTF("desc", var2_9)
		local var5_9 = arg0_9.groups[arg0_9.curIdx]:GetEvent(iter1_9)
		local var6_9 = table.contains(arg0_9.finishEventIds, iter1_9)

		setText(var3_9, var6_9 and var5_9:GetTitle() or i18n("liner_event_title" .. iter0_9))

		if not var6_9 then
			var0_9 = true
		end

		local var7_9 = var6_9 and "clue" .. iter1_9 or "empty" .. iter0_9

		setImageSprite(arg0_9:findTF("icon", var2_9), GetSpriteFromAtlas("ui/linermainui_atlas", var7_9), true)
		setText(var4_9, var6_9 and var5_9:GetLogDesc() or "")
		setActive(arg0_9:findTF("empty", var2_9), not var6_9)
	end

	for iter2_9 = #var1_9 + 1, #arg0_9.itemTFs do
		setActive(arg0_9.itemTFs[iter2_9], false)
	end

	local var8_9 = arg0_9.groups[arg0_9.curIdx]:GetDrop()

	updateDrop(arg0_9.awardTF, var8_9)
	onButton(arg0_9, arg0_9.awardTF, function()
		arg0_9:emit(BaseUI.ON_DROP, var8_9)
	end, SFX_PANEL)

	local var9_9 = arg0_9.activity:IsGotEventAward(arg0_9.curIdx)
	local var10_9 = not var9_9 and not var0_9

	setActive(arg0_9.goBtn, not var9_9 and not var10_9)
	setActive(arg0_9.getBtn, var10_9)
	setActive(arg0_9.gotTF, var9_9)
	setActive(arg0_9:findTF("mask", arg0_9.awardTF), var9_9)
	setText(arg0_9.awardDesc, var10_9 and i18n("liner_event_award_tip2") or i18n("liner_event_award_tip1"))
	setActive(arg0_9.awardDesc, not var9_9)

	if var9_9 then
		local var11_9 = arg0_9.activity:GetEventAwardFlag(arg0_9.curIdx)

		setText(arg0_9.conclusionDesc, arg0_9.groups[arg0_9.curIdx]:GetConclusions()[var11_9])
	end

	arg0_9:Show()
end

function var0_0.OnDestroy(arg0_11)
	return
end

function var0_0.IsFinishWithGroupIdx(arg0_12, arg1_12)
	return underscore.all(arg0_12.groups[arg1_12]:GetIds(), function(arg0_13)
		return table.contains(arg0_12.finishEventIds, arg0_13)
	end)
end

function var0_0.IsTipWithGroupId(arg0_14, arg1_14)
	local var0_14 = table.indexof(arg0_14:GetEventGroupIds(), arg1_14)

	if arg0_14:IsGotEventAward(var0_14) then
		return false
	end

	local var1_14 = arg0_14:GetFinishEventIds()

	return underscore.all(pg.activity_liner_event_group[arg1_14].ids, function(arg0_15)
		return table.contains(var1_14, arg0_15)
	end)
end

function var0_0.IsTip()
	local var0_16 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(var0_16 and not var0_16:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	local var1_16 = var0_16:GetEventGroupIds()

	return underscore.any(var1_16, function(arg0_17)
		return var0_0.IsTipWithGroupId(var0_16, arg0_17)
	end)
end

function var0_0.IsUnlcok()
	local var0_18 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(var0_18 and not var0_18:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	return var0_18:GetCurIdx() > 7
end

return var0_0
