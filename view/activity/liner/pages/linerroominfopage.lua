local var0 = class("LinerRoomInfoPage", import("view.base.BaseSubView"))

var0.TYPEWRITE_SPEED = 0.03
var0.TYPE_EXPLORE = 1
var0.TYPE_EVENT = 2
var0.MODE_EVENT_DESC = 1
var0.MODE_OPTION_DESC = 2
var0.MODE_ROOM_DESC = 3
var0.TIME_DIFF_LIST = {
	1,
	2,
	3,
	4,
	5,
	6,
	12,
	13,
	14
}
var0.ICON_LIST = {
	2,
	5,
	6,
	12,
	13,
	14
}

function var0.getUIName(arg0)
	return "LinerRoomInfoPage"
end

function var0.OnLoaded(arg0)
	arg0.dotTF = arg0:findTF("frame/bottom/name/Image")
	arg0.nameTF = arg0:findTF("frame/bottom/name/Text")
	arg0.iconTF = arg0:findTF("frame/bottom/icon/mask/Image")
	arg0.descTF = arg0:findTF("frame/bottom/Text")
	arg0.nextTF = arg0:findTF("frame/bottom/next")
	arg0.typewrite = GetComponent(arg0.descTF, typeof(Typewriter))

	arg0.typewrite:setSpeed(var0.TYPEWRITE_SPEED)

	arg0.optionsTF = arg0:findTF("frame/options")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0:findTF("mask"), function()
		arg0:OnClick()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("frame/bottom"), function()
		arg0:OnClick()
	end, SFX_PANEL)

	function arg0.typewrite.endFunc()
		if arg0.curIndex == #arg0.descList then
			switch(arg0.mode, {
				[var0.MODE_EVENT_DESC] = function()
					setActive(arg0.optionsTF, true)
					arg0:ShowOptionsAnim()
				end,
				[var0.MODE_OPTION_DESC] = function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("liner_event_get_tip", arg0.eventName))
				end,
				[var0.MODE_ROOM_DESC] = function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("liner_room_get_tip", arg0.room:GetName()))
				end
			})
		end

		arg0.isWriting = false
		arg0.curIndex = arg0.curIndex + 1
	end

	arg0.optionsUIList = UIItemList.New(arg0.optionsTF, arg0:findTF("tpl", arg0.optionsTF))

	arg0.optionsUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0.events[var0]

			setText(arg2:Find("Text"), var1:GetOptionName())
			onButton(arg0, arg2, function()
				if table.contains(arg0.finishEventIds, var1.id) then
					return
				end

				arg0.isClickEvent = true

				arg0:emit(LinerMediator.CLICK_EVENT, {
					actId = arg0.activity.id,
					roomId = arg0.room.id,
					eventId = var1.id,
					callback = function()
						arg0.eventName = var1:GetTitle()

						arg0:SetContent(var1:GetOptionDisplay(), var0.MODE_OPTION_DESC)
						table.insert(arg0.finishEventIds, var1.id)
						table.remove(arg0.events, var0)
						arg0.optionsUIList:align(#arg0.events)
					end
				})
			end, SFX_CONFIRM)
		end
	end)
end

function var0.ShowInfo(arg0, arg1, arg2, arg3)
	arg0.activity = arg1
	arg0.curTime = arg0.activity:GetCurTime()
	arg0.room = LinerRoom.New(arg2)
	arg0.callback = arg3

	setText(arg0.nameTF, arg0.room:GetName())

	local var0 = tostring(arg2)

	setLocalScale(arg0.iconTF, {
		x = 0.7,
		y = 0.7
	})

	if table.contains(var0.TIME_DIFF_LIST, arg2) then
		local var1 = arg0.curTime:GetBgType()

		var0 = var0 .. "_" .. var1
	end

	if table.contains(var0.ICON_LIST, arg2) then
		var0 = "icon_" .. var0

		setLocalScale(arg0.iconTF, {
			x = 1,
			y = 1
		})
	end

	setImageSprite(arg0.iconTF, GetSpriteFromAtlas("ui/linermainui_atlas", var0), true)
	switch(arg0.curTime:GetType(), {
		[LinerTime.TYPE.EXPLORE] = function()
			arg0:ShowRoomInfos()
		end,
		[LinerTime.TYPE.EVENT] = function()
			arg0:ShowEventInfos()
		end
	})
	arg0:Show()
end

function var0.ShowRoomInfos(arg0)
	setImageColor(arg0.dotTF, Color.NewHex("FE9400"))
	setActive(arg0.optionsTF, false)
	arg0:emit(LinerMediator.CLICK_ROOM, arg0.activity.id, arg0.room.id)
	arg0:SetContent(arg0.room:GetDescList(), var0.MODE_ROOM_DESC)
end

function var0.ShowEventInfos(arg0)
	setImageColor(arg0.dotTF, Color.NewHex("4E5BFF"))

	local var0 = ""

	arg0.events = {}
	arg0.finishEventIds = arg0.activity:GetCurEventInfo()[arg0.room.id] or {}

	for iter0, iter1 in ipairs(arg0.curTime:GetParamInfo()) do
		if iter1[1] == arg0.room.id then
			var0 = HXSet.hxLan(iter1[3])

			for iter2, iter3 in ipairs(iter1[4]) do
				if not table.contains(arg0.finishEventIds, iter3) then
					table.insert(arg0.events, LinerEvent.New(iter3))
				end
			end
		end
	end

	arg0:SetContent({
		var0
	}, var0.MODE_EVENT_DESC)
	setActive(arg0.optionsTF, false)
end

function var0.ShowOptionsAnim(arg0)
	local var0 = {}

	for iter0 = 1, #arg0.events do
		table.insert(var0, function(arg0)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0.optionsUIList:align(#arg0.events)
				arg0()
			end, 0.066, nil)
		end)
	end

	seriesAsync(var0, function()
		return
	end)
end

function var0.SetContent(arg0, arg1, arg2)
	arg0.mode = arg2
	arg0.curIndex = 1
	arg0.descList = arg1

	arg0:SetOnePage()
end

function var0.SetOnePage(arg0)
	arg0.isWriting = true

	setActive(arg0.nextTF, arg0.curIndex < #arg0.descList)
	setText(arg0.descTF, arg0.descList[arg0.curIndex])
	arg0.typewrite:Play()
end

function var0.OnClick(arg0)
	if arg0.isWriting then
		return
	end

	if #arg0.descList >= arg0.curIndex then
		arg0:SetOnePage()

		return
	end

	if arg0.events and #arg0.events > 0 then
		return
	end

	arg0:Hide()

	if arg0.callback and (arg0.isClickEvent or arg0.curTime:GetType() == LinerTime.TYPE.EXPLORE) then
		arg0.callback()

		arg0.callback = nil
		arg0.isClickEvent = nil
	end
end

return var0
