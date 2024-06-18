local var0_0 = class("LinerLogRoomPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LinerLogRoomPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.leftTF = arg0_2:findTF("left")
	arg0_2.rightTF = arg0_2:findTF("right")
	arg0_2.togglesTF = arg0_2:findTF("toggles")
	arg0_2.anim = arg0_2:findTF("view"):GetComponent(typeof(Animation))

	local var0_2 = arg0_2:findTF("view/content")

	arg0_2.itemTFs = {
		arg0_2:findTF("1", var0_2),
		arg0_2:findTF("2", var0_2),
		arg0_2:findTF("3", var0_2),
		(arg0_2:findTF("4", var0_2))
	}

	for iter0_2, iter1_2 in pairs(arg0_2.itemTFs) do
		arg0_2:findTF("empty", iter1_2):GetComponent(typeof(Image)):SetNativeSize()
	end

	arg0_2.awardTF = arg0_2:findTF("award/mask/IconTpl")
	arg0_2.awardDesc = arg0_2:findTF("award/Text")

	setText(arg0_2.awardDesc, i18n("liner_room_award_tip"))

	arg0_2.goBtn = arg0_2:findTF("award/go")
	arg0_2.getBtn = arg0_2:findTF("award/get")
	arg0_2.gotTF = arg0_2:findTF("award/got")
end

function var0_0.OnInit(arg0_3)
	arg0_3:UpdateActivity()
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(LinerLogBookMediator.GET_ROOM_AWARD, arg0_3.activity.id, arg0_3.curIdx, arg0_3.groups[arg0_3.curIdx]:GetDrop())
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(LinerLogBookMediator.ON_CLOSE)
	end, SFX_CONFIRM)

	arg0_3.groupIds = arg0_3.activity:getConfig("config_data")[2]
	arg0_3.groups = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.groupIds) do
		arg0_3.groups[iter0_3] = LinerRoomGroup.New(iter1_3)
	end

	arg0_3.toggleUIList = UIItemList.New(arg0_3.togglesTF, arg0_3:findTF("tpl", arg0_3.togglesTF))

	arg0_3.toggleUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			local var0_6 = arg1_6 + 1

			arg2_6.name = var0_6

			local var1_6 = "PAGE " .. string.format("%02d", var0_6)

			setText(arg2_6:Find("Text"), var1_6)
			setText(arg2_6:Find("selected/Text"), var1_6)
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

	arg0_8.finishRoomIds = arg0_8.activity:GetExploredRoomIds()
end

function var0_0.FlushPage(arg0_9)
	arg0_9.anim:Play()
	arg0_9.toggleUIList:align(#arg0_9.groupIds)

	local var0_9 = false
	local var1_9 = arg0_9.groups[arg0_9.curIdx]:GetIds()

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var2_9 = arg0_9.itemTFs[iter0_9]

		if var2_9 then
			setActive(var2_9, true)

			local var3_9 = arg0_9:findTF("name/Text", var2_9)
			local var4_9 = arg0_9:findTF("desc", var2_9)
			local var5_9 = arg0_9.groups[arg0_9.curIdx]:GetRoom(iter1_9)

			setText(var3_9, var5_9:GetName())
			setImageSprite(arg0_9:findTF("icon", var2_9), GetSpriteFromAtlas("ui/linermainui_atlas", "area" .. iter1_9, true))

			local var6_9 = table.contains(arg0_9.finishRoomIds, iter1_9)

			if not var6_9 then
				var0_9 = true
			end

			setText(var4_9, var6_9 and var5_9:GetDesc() or "")
			setActive(arg0_9:findTF("empty", var2_9), not var6_9)
		end
	end

	for iter2_9 = #var1_9 + 1, #arg0_9.itemTFs do
		setActive(arg0_9.itemTFs[iter2_9], false)
	end

	local var7_9 = arg0_9.groups[arg0_9.curIdx]:GetDrop()

	updateDrop(arg0_9.awardTF, var7_9)
	onButton(arg0_9, arg0_9.awardTF, function()
		arg0_9:emit(BaseUI.ON_DROP, var7_9)
	end, SFX_PANEL)

	local var8_9 = arg0_9.activity:IsGotRoomAward(arg0_9.curIdx)
	local var9_9 = not var8_9 and not var0_9

	setActive(arg0_9.goBtn, not var8_9 and not var9_9)
	setActive(arg0_9.gotTF, var8_9)
	setActive(arg0_9:findTF("mask", arg0_9.awardTF), var8_9)
	setActive(arg0_9.getBtn, var9_9)
	arg0_9:Show()
end

function var0_0.OnDestroy(arg0_11)
	return
end

function var0_0.IsTipWithGroupId(arg0_12, arg1_12)
	local var0_12 = table.indexof(arg0_12:GetRoomGroupIds(), arg1_12)

	if arg0_12:IsGotRoomAward(var0_12) then
		return false
	end

	local var1_12 = arg0_12:GetExploredRoomIds()

	return underscore.all(pg.activity_liner_room_group[arg1_12].ids, function(arg0_13)
		return table.contains(var1_12, arg0_13)
	end)
end

function var0_0.IsTip()
	local var0_14 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(var0_14 and not var0_14:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	local var1_14 = var0_14:GetRoomGroupIds()

	return underscore.any(var1_14, function(arg0_15)
		return var0_0.IsTipWithGroupId(var0_14, arg0_15)
	end)
end

return var0_0
