local var0_0 = class("LinerRoomInfoPage", import("view.base.BaseSubView"))

var0_0.TYPEWRITE_SPEED = 0.03
var0_0.TYPE_EXPLORE = 1
var0_0.TYPE_EVENT = 2
var0_0.MODE_EVENT_DESC = 1
var0_0.MODE_OPTION_DESC = 2
var0_0.MODE_ROOM_DESC = 3
var0_0.TIME_DIFF_LIST = {
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
var0_0.ICON_LIST = {
	2,
	5,
	6,
	12,
	13,
	14
}

function var0_0.getUIName(arg0_1)
	return "LinerRoomInfoPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.dotTF = arg0_2:findTF("frame/bottom/name/Image")
	arg0_2.nameTF = arg0_2:findTF("frame/bottom/name/Text")
	arg0_2.iconTF = arg0_2:findTF("frame/bottom/icon/mask/Image")
	arg0_2.descTF = arg0_2:findTF("frame/bottom/Text")
	arg0_2.nextTF = arg0_2:findTF("frame/bottom/next")
	arg0_2.typewrite = GetComponent(arg0_2.descTF, typeof(Typewriter))

	arg0_2.typewrite:setSpeed(var0_0.TYPEWRITE_SPEED)

	arg0_2.optionsTF = arg0_2:findTF("frame/options")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3:findTF("mask"), function()
		arg0_3:OnClick()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("frame/bottom"), function()
		arg0_3:OnClick()
	end, SFX_PANEL)

	function arg0_3.typewrite.endFunc()
		if arg0_3.curIndex == #arg0_3.descList then
			switch(arg0_3.mode, {
				[var0_0.MODE_EVENT_DESC] = function()
					setActive(arg0_3.optionsTF, true)
					arg0_3:ShowOptionsAnim()
				end,
				[var0_0.MODE_OPTION_DESC] = function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("liner_event_get_tip", arg0_3.eventName))
				end,
				[var0_0.MODE_ROOM_DESC] = function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("liner_room_get_tip", arg0_3.room:GetName()))
				end
			})
		end

		arg0_3.isWriting = false
		arg0_3.curIndex = arg0_3.curIndex + 1
	end

	arg0_3.optionsUIList = UIItemList.New(arg0_3.optionsTF, arg0_3:findTF("tpl", arg0_3.optionsTF))

	arg0_3.optionsUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg1_10 + 1
			local var1_10 = arg0_3.events[var0_10]

			setText(arg2_10:Find("Text"), var1_10:GetOptionName())
			onButton(arg0_3, arg2_10, function()
				if table.contains(arg0_3.finishEventIds, var1_10.id) then
					return
				end

				arg0_3.isClickEvent = true

				arg0_3:emit(LinerMediator.CLICK_EVENT, {
					actId = arg0_3.activity.id,
					roomId = arg0_3.room.id,
					eventId = var1_10.id,
					callback = function()
						arg0_3.eventName = var1_10:GetTitle()

						arg0_3:SetContent(var1_10:GetOptionDisplay(), var0_0.MODE_OPTION_DESC)
						table.insert(arg0_3.finishEventIds, var1_10.id)
						table.remove(arg0_3.events, var0_10)
						arg0_3.optionsUIList:align(#arg0_3.events)
					end
				})
			end, SFX_CONFIRM)
		end
	end)
end

function var0_0.ShowInfo(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13.activity = arg1_13
	arg0_13.curTime = arg0_13.activity:GetCurTime()
	arg0_13.room = LinerRoom.New(arg2_13)
	arg0_13.callback = arg3_13

	setText(arg0_13.nameTF, arg0_13.room:GetName())

	local var0_13 = tostring(arg2_13)

	setLocalScale(arg0_13.iconTF, {
		x = 0.7,
		y = 0.7
	})

	if table.contains(var0_0.TIME_DIFF_LIST, arg2_13) then
		local var1_13 = arg0_13.curTime:GetBgType()

		var0_13 = var0_13 .. "_" .. var1_13
	end

	if table.contains(var0_0.ICON_LIST, arg2_13) then
		var0_13 = "icon_" .. var0_13

		setLocalScale(arg0_13.iconTF, {
			x = 1,
			y = 1
		})
	end

	setImageSprite(arg0_13.iconTF, GetSpriteFromAtlas("ui/linermainui_atlas", var0_13), true)
	switch(arg0_13.curTime:GetType(), {
		[LinerTime.TYPE.EXPLORE] = function()
			arg0_13:ShowRoomInfos()
		end,
		[LinerTime.TYPE.EVENT] = function()
			arg0_13:ShowEventInfos()
		end
	})
	arg0_13:Show()
end

function var0_0.ShowRoomInfos(arg0_16)
	setImageColor(arg0_16.dotTF, Color.NewHex("FE9400"))
	setActive(arg0_16.optionsTF, false)
	arg0_16:emit(LinerMediator.CLICK_ROOM, arg0_16.activity.id, arg0_16.room.id)
	arg0_16:SetContent(arg0_16.room:GetDescList(), var0_0.MODE_ROOM_DESC)
end

function var0_0.ShowEventInfos(arg0_17)
	setImageColor(arg0_17.dotTF, Color.NewHex("4E5BFF"))

	local var0_17 = ""

	arg0_17.events = {}
	arg0_17.finishEventIds = arg0_17.activity:GetCurEventInfo()[arg0_17.room.id] or {}

	for iter0_17, iter1_17 in ipairs(arg0_17.curTime:GetParamInfo()) do
		if iter1_17[1] == arg0_17.room.id then
			var0_17 = HXSet.hxLan(iter1_17[3])

			for iter2_17, iter3_17 in ipairs(iter1_17[4]) do
				if not table.contains(arg0_17.finishEventIds, iter3_17) then
					table.insert(arg0_17.events, LinerEvent.New(iter3_17))
				end
			end
		end
	end

	arg0_17:SetContent({
		var0_17
	}, var0_0.MODE_EVENT_DESC)
	setActive(arg0_17.optionsTF, false)
end

function var0_0.ShowOptionsAnim(arg0_18)
	local var0_18 = {}

	for iter0_18 = 1, #arg0_18.events do
		table.insert(var0_18, function(arg0_19)
			arg0_18:managedTween(LeanTween.delayedCall, function()
				arg0_18.optionsUIList:align(#arg0_18.events)
				arg0_19()
			end, 0.066, nil)
		end)
	end

	seriesAsync(var0_18, function()
		return
	end)
end

function var0_0.SetContent(arg0_22, arg1_22, arg2_22)
	arg0_22.mode = arg2_22
	arg0_22.curIndex = 1
	arg0_22.descList = arg1_22

	arg0_22:SetOnePage()
end

function var0_0.SetOnePage(arg0_23)
	arg0_23.isWriting = true

	setActive(arg0_23.nextTF, arg0_23.curIndex < #arg0_23.descList)
	setText(arg0_23.descTF, arg0_23.descList[arg0_23.curIndex])
	arg0_23.typewrite:Play()
end

function var0_0.OnClick(arg0_24)
	if arg0_24.isWriting then
		return
	end

	if #arg0_24.descList >= arg0_24.curIndex then
		arg0_24:SetOnePage()

		return
	end

	if arg0_24.events and #arg0_24.events > 0 then
		return
	end

	arg0_24:Hide()

	if arg0_24.callback and (arg0_24.isClickEvent or arg0_24.curTime:GetType() == LinerTime.TYPE.EXPLORE) then
		arg0_24.callback()

		arg0_24.callback = nil
		arg0_24.isClickEvent = nil
	end
end

return var0_0
