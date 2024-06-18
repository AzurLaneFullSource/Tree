local var0_0 = class("LinerReasoningPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LinerReasoningPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTF = arg0_2:findTF("clues/title")

	setText(arg0_2.titleTF, i18n("liner_event_reasoning_title"))

	arg0_2.eventNameTF = arg0_2:findTF("clues/name")
	arg0_2.cluesTF = arg0_2:findTF("clues/content")
	arg0_2.optionsTF = arg0_2:findTF("options")

	arg0_2:findTF("clues/reasoning_title"):GetComponent(typeof(Image)):SetNativeSize()
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3:findTF("mask"), function()
		arg0_3:Hide()
	end, SFX_PANEL)

	arg0_3.cluesUIList = UIItemList.New(arg0_3.cluesTF, arg0_3:findTF("tpl", arg0_3.cluesTF))

	arg0_3.cluesUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg1_5 + 1
			local var1_5 = arg0_3.clues[var0_5]

			setText(arg2_5:Find("index/Text"), var1_5:GetTitle())
			setText(arg2_5:Find("Text"), var1_5:GetReasoningDesc())
		end
	end)

	arg0_3.optionsUIList = UIItemList.New(arg0_3.optionsTF, arg0_3:findTF("tpl", arg0_3.optionsTF))

	arg0_3.optionsUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg1_6 + 1

			setText(arg2_6:Find("Text"), arg0_3.options[var0_6])
			onButton(arg0_3, arg2_6, function()
				arg0_3:emit(LinerLogBookMediator.GET_EVENT_AWARD, arg0_3.actId, arg0_3.groupIdx, var0_6, arg0_3.eventGroup:GetDrop())
				arg0_3:Hide()
			end, SFX_CONFIRM)
		end
	end)
end

function var0_0.ShowOptions(arg0_8, arg1_8, arg2_8)
	arg0_8.actId = arg1_8
	arg0_8.groupIdx = arg2_8

	local var0_8 = pg.activity_template[arg0_8.actId].config_data[3][arg0_8.groupIdx]

	arg0_8.eventGroup = LinerEventGroup.New(var0_8)

	setText(arg0_8.eventNameTF, arg0_8.eventGroup:GetTitle())

	arg0_8.clues = arg0_8.eventGroup:GetEventList()
	arg0_8.options = arg0_8.eventGroup:GetConclusions()

	arg0_8.cluesUIList:align(#arg0_8.clues)
	arg0_8:Show()

	local var1_8 = {}

	for iter0_8 = 1, #arg0_8.options do
		table.insert(var1_8, function(arg0_9)
			arg0_8:managedTween(LeanTween.delayedCall, function()
				arg0_8.optionsUIList:align(iter0_8)
				arg0_9()
			end, 0.066, nil)
		end)
	end

	seriesAsync(var1_8, function()
		return
	end)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
