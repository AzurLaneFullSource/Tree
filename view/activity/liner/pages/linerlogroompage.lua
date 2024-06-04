local var0 = class("LinerLogRoomPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "LinerLogRoomPage"
end

function var0.OnLoaded(arg0)
	arg0.leftTF = arg0:findTF("left")
	arg0.rightTF = arg0:findTF("right")
	arg0.togglesTF = arg0:findTF("toggles")
	arg0.anim = arg0:findTF("view"):GetComponent(typeof(Animation))

	local var0 = arg0:findTF("view/content")

	arg0.itemTFs = {
		arg0:findTF("1", var0),
		arg0:findTF("2", var0),
		arg0:findTF("3", var0),
		(arg0:findTF("4", var0))
	}

	for iter0, iter1 in pairs(arg0.itemTFs) do
		arg0:findTF("empty", iter1):GetComponent(typeof(Image)):SetNativeSize()
	end

	arg0.awardTF = arg0:findTF("award/mask/IconTpl")
	arg0.awardDesc = arg0:findTF("award/Text")

	setText(arg0.awardDesc, i18n("liner_room_award_tip"))

	arg0.goBtn = arg0:findTF("award/go")
	arg0.getBtn = arg0:findTF("award/get")
	arg0.gotTF = arg0:findTF("award/got")
end

function var0.OnInit(arg0)
	arg0:UpdateActivity()
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(LinerLogBookMediator.GET_ROOM_AWARD, arg0.activity.id, arg0.curIdx, arg0.groups[arg0.curIdx]:GetDrop())
	end, SFX_CONFIRM)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(LinerLogBookMediator.ON_CLOSE)
	end, SFX_CONFIRM)

	arg0.groupIds = arg0.activity:getConfig("config_data")[2]
	arg0.groups = {}

	for iter0, iter1 in ipairs(arg0.groupIds) do
		arg0.groups[iter0] = LinerRoomGroup.New(iter1)
	end

	arg0.toggleUIList = UIItemList.New(arg0.togglesTF, arg0:findTF("tpl", arg0.togglesTF))

	arg0.toggleUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg1 + 1

			arg2.name = var0

			local var1 = "PAGE " .. string.format("%02d", var0)

			setText(arg2:Find("Text"), var1)
			setText(arg2:Find("selected/Text"), var1)
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

	arg0.finishRoomIds = arg0.activity:GetExploredRoomIds()
end

function var0.FlushPage(arg0)
	arg0.anim:Play()
	arg0.toggleUIList:align(#arg0.groupIds)

	local var0 = false
	local var1 = arg0.groups[arg0.curIdx]:GetIds()

	for iter0, iter1 in ipairs(var1) do
		local var2 = arg0.itemTFs[iter0]

		if var2 then
			setActive(var2, true)

			local var3 = arg0:findTF("name/Text", var2)
			local var4 = arg0:findTF("desc", var2)
			local var5 = arg0.groups[arg0.curIdx]:GetRoom(iter1)

			setText(var3, var5:GetName())
			setImageSprite(arg0:findTF("icon", var2), GetSpriteFromAtlas("ui/linermainui_atlas", "area" .. iter1, true))

			local var6 = table.contains(arg0.finishRoomIds, iter1)

			if not var6 then
				var0 = true
			end

			setText(var4, var6 and var5:GetDesc() or "")
			setActive(arg0:findTF("empty", var2), not var6)
		end
	end

	for iter2 = #var1 + 1, #arg0.itemTFs do
		setActive(arg0.itemTFs[iter2], false)
	end

	local var7 = arg0.groups[arg0.curIdx]:GetDrop()

	updateDrop(arg0.awardTF, var7)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var7)
	end, SFX_PANEL)

	local var8 = arg0.activity:IsGotRoomAward(arg0.curIdx)
	local var9 = not var8 and not var0

	setActive(arg0.goBtn, not var8 and not var9)
	setActive(arg0.gotTF, var8)
	setActive(arg0:findTF("mask", arg0.awardTF), var8)
	setActive(arg0.getBtn, var9)
	arg0:Show()
end

function var0.OnDestroy(arg0)
	return
end

function var0.IsTipWithGroupId(arg0, arg1)
	local var0 = table.indexof(arg0:GetRoomGroupIds(), arg1)

	if arg0:IsGotRoomAward(var0) then
		return false
	end

	local var1 = arg0:GetExploredRoomIds()

	return underscore.all(pg.activity_liner_room_group[arg1].ids, function(arg0)
		return table.contains(var1, arg0)
	end)
end

function var0.IsTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(var0 and not var0:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	local var1 = var0:GetRoomGroupIds()

	return underscore.any(var1, function(arg0)
		return var0.IsTipWithGroupId(var0, arg0)
	end)
end

return var0
