local var0 = class("LinerReasoningPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "LinerReasoningPage"
end

function var0.OnLoaded(arg0)
	arg0.titleTF = arg0:findTF("clues/title")

	setText(arg0.titleTF, i18n("liner_event_reasoning_title"))

	arg0.eventNameTF = arg0:findTF("clues/name")
	arg0.cluesTF = arg0:findTF("clues/content")
	arg0.optionsTF = arg0:findTF("options")

	arg0:findTF("clues/reasoning_title"):GetComponent(typeof(Image)):SetNativeSize()
end

function var0.OnInit(arg0)
	onButton(arg0, arg0:findTF("mask"), function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.cluesUIList = UIItemList.New(arg0.cluesTF, arg0:findTF("tpl", arg0.cluesTF))

	arg0.cluesUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0.clues[var0]

			setText(arg2:Find("index/Text"), var1:GetTitle())
			setText(arg2:Find("Text"), var1:GetReasoningDesc())
		end
	end)

	arg0.optionsUIList = UIItemList.New(arg0.optionsTF, arg0:findTF("tpl", arg0.optionsTF))

	arg0.optionsUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1

			setText(arg2:Find("Text"), arg0.options[var0])
			onButton(arg0, arg2, function()
				arg0:emit(LinerLogBookMediator.GET_EVENT_AWARD, arg0.actId, arg0.groupIdx, var0, arg0.eventGroup:GetDrop())
				arg0:Hide()
			end, SFX_CONFIRM)
		end
	end)
end

function var0.ShowOptions(arg0, arg1, arg2)
	arg0.actId = arg1
	arg0.groupIdx = arg2

	local var0 = pg.activity_template[arg0.actId].config_data[3][arg0.groupIdx]

	arg0.eventGroup = LinerEventGroup.New(var0)

	setText(arg0.eventNameTF, arg0.eventGroup:GetTitle())

	arg0.clues = arg0.eventGroup:GetEventList()
	arg0.options = arg0.eventGroup:GetConclusions()

	arg0.cluesUIList:align(#arg0.clues)
	arg0:Show()

	local var1 = {}

	for iter0 = 1, #arg0.options do
		table.insert(var1, function(arg0)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0.optionsUIList:align(iter0)
				arg0()
			end, 0.066, nil)
		end)
	end

	seriesAsync(var1, function()
		return
	end)
end

function var0.OnDestroy(arg0)
	return
end

return var0
