local var0_0 = class("LinerLogBookLayer", import("view.base.BaseUI"))

var0_0.PAGE_SCHEDULE = 1
var0_0.PAGE_ROOM = 2
var0_0.PAGE_EVENT = 3

local var1_0 = {
	"liner_log_schedule_title",
	"liner_log_room_title",
	"liner_log_event_title"
}
local var2_0 = var0_0.PAGE_SCHEDULE

function var0_0.getUIName(arg0_1)
	return "LinerLogBookUI"
end

function var0_0.init(arg0_2)
	arg0_2.anim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end)

	arg0_2.togglesTF = arg0_2:findTF("frame/toggles")

	local var0_2 = arg0_2:findTF("frame/pages")

	arg0_2.schedulePage = LinerLogSchedulePage.New(var0_2, arg0_2)
	arg0_2.roomPage = LinerLogRoomPage.New(var0_2, arg0_2)
	arg0_2.eventPage = LinerLogEventPage.New(var0_2, arg0_2)
	arg0_2.pages = {
		[var0_0.PAGE_SCHEDULE] = arg0_2.schedulePage,
		[var0_0.PAGE_ROOM] = arg0_2.roomPage,
		[var0_0.PAGE_EVENT] = arg0_2.eventPage
	}
	arg0_2.reasoningPage = LinerReasoningPage.New(arg0_2:findTF("pages"), arg0_2)
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("frame/close"), function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4:findTF("mask"), function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)
	eachChild(arg0_4.togglesTF, function(arg0_7)
		setText(arg0_4:findTF("Text", arg0_7), i18n(var1_0[tonumber(arg0_7.name)]))
		onButton(arg0_4, arg0_7, function()
			local var0_8 = tonumber(arg0_7.name)

			if var0_8 == var0_0.PAGE_EVENT and not LinerLogEventPage.IsUnlcok() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("liner_event_lock"))
			else
				if arg0_4.curPageIdx and arg0_4.curPageIdx == var0_8 then
					return
				end

				arg0_4.curPageIdx = var0_8

				arg0_4:SwitchPage()
				arg0_7:SetAsLastSibling()
				arg0_4:UpdateToggles()
			end
		end)
	end)

	local var0_4 = arg0_4.contextData.page or var2_0

	triggerButton(arg0_4:findTF(tostring(var0_4), arg0_4.togglesTF), true)
	arg0_4:UpdateTips()
end

function var0_0.UpdateToggles(arg0_9)
	setActive(arg0_9:findTF("3/lock", arg0_9.togglesTF), not LinerLogEventPage.IsUnlcok())
	eachChild(arg0_9.togglesTF, function(arg0_10)
		setActive(arg0_9:findTF("selected", arg0_10), tonumber(arg0_10.name) == arg0_9.curPageIdx)
	end)
end

function var0_0.SwitchPage(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.pages) do
		if iter0_11 == arg0_11.curPageIdx then
			iter1_11:ExecuteAction("FlushPage")

			arg0_11.curPage = iter1_11
		else
			iter1_11:ExecuteAction("Hide")
		end
	end
end

function var0_0.UpdateView(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.pages) do
		iter1_12:ExecuteAction("UpdateActivity")
	end

	arg0_12.curPage:ExecuteAction("FlushPage")
	arg0_12:UpdateTips()
end

function var0_0.UpdateTips(arg0_13)
	eachChild(arg0_13.togglesTF, function(arg0_14)
		local var0_14 = tonumber(arg0_14.name)

		setActive(arg0_13:findTF("tip", arg0_14), arg0_13.pages[var0_14].IsTip())
	end)
end

function var0_0.OnStartReasoning(arg0_15, arg1_15, arg2_15)
	arg0_15.reasoningPage:ExecuteAction("ShowOptions", arg1_15, arg2_15)
end

function var0_0.onBackPressed(arg0_16)
	arg0_16.anim:Play("anim_liner_logbook_out")
end

function var0_0.willExit(arg0_17)
	arg0_17.animEvent:SetEndEvent(nil)

	for iter0_17, iter1_17 in pairs(arg0_17.pages) do
		iter1_17:Destroy()

		iter1_17 = nil
	end

	arg0_17.reasoningPage:Destroy()

	arg0_17.reasoningPage = nil

	if arg0_17.contextData.onExit then
		arg0_17.contextData.onExit()

		arg0_17.contextData.onExit = nil
	end
end

function var0_0.IsTip()
	return LinerLogSchedulePage.IsTip() or LinerLogRoomPage.IsTip() or LinerLogEventPage.IsTip()
end

return var0_0
