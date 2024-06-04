local var0 = class("LinerLogBookLayer", import("view.base.BaseUI"))

var0.PAGE_SCHEDULE = 1
var0.PAGE_ROOM = 2
var0.PAGE_EVENT = 3

local var1 = {
	"liner_log_schedule_title",
	"liner_log_room_title",
	"liner_log_event_title"
}
local var2 = var0.PAGE_SCHEDULE

function var0.getUIName(arg0)
	return "LinerLogBookUI"
end

function var0.init(arg0)
	arg0.anim = arg0._tf:GetComponent(typeof(Animation))
	arg0.animEvent = arg0._tf:GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.togglesTF = arg0:findTF("frame/toggles")

	local var0 = arg0:findTF("frame/pages")

	arg0.schedulePage = LinerLogSchedulePage.New(var0, arg0)
	arg0.roomPage = LinerLogRoomPage.New(var0, arg0)
	arg0.eventPage = LinerLogEventPage.New(var0, arg0)
	arg0.pages = {
		[var0.PAGE_SCHEDULE] = arg0.schedulePage,
		[var0.PAGE_ROOM] = arg0.roomPage,
		[var0.PAGE_EVENT] = arg0.eventPage
	}
	arg0.reasoningPage = LinerReasoningPage.New(arg0:findTF("pages"), arg0)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("frame/close"), function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("mask"), function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	eachChild(arg0.togglesTF, function(arg0)
		setText(arg0:findTF("Text", arg0), i18n(var1[tonumber(arg0.name)]))
		onButton(arg0, arg0, function()
			local var0 = tonumber(arg0.name)

			if var0 == var0.PAGE_EVENT and not LinerLogEventPage.IsUnlcok() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("liner_event_lock"))
			else
				if arg0.curPageIdx and arg0.curPageIdx == var0 then
					return
				end

				arg0.curPageIdx = var0

				arg0:SwitchPage()
				arg0:SetAsLastSibling()
				arg0:UpdateToggles()
			end
		end)
	end)

	local var0 = arg0.contextData.page or var2

	triggerButton(arg0:findTF(tostring(var0), arg0.togglesTF), true)
	arg0:UpdateTips()
end

function var0.UpdateToggles(arg0)
	setActive(arg0:findTF("3/lock", arg0.togglesTF), not LinerLogEventPage.IsUnlcok())
	eachChild(arg0.togglesTF, function(arg0)
		setActive(arg0:findTF("selected", arg0), tonumber(arg0.name) == arg0.curPageIdx)
	end)
end

function var0.SwitchPage(arg0)
	for iter0, iter1 in pairs(arg0.pages) do
		if iter0 == arg0.curPageIdx then
			iter1:ExecuteAction("FlushPage")

			arg0.curPage = iter1
		else
			iter1:ExecuteAction("Hide")
		end
	end
end

function var0.UpdateView(arg0)
	for iter0, iter1 in pairs(arg0.pages) do
		iter1:ExecuteAction("UpdateActivity")
	end

	arg0.curPage:ExecuteAction("FlushPage")
	arg0:UpdateTips()
end

function var0.UpdateTips(arg0)
	eachChild(arg0.togglesTF, function(arg0)
		local var0 = tonumber(arg0.name)

		setActive(arg0:findTF("tip", arg0), arg0.pages[var0].IsTip())
	end)
end

function var0.OnStartReasoning(arg0, arg1, arg2)
	arg0.reasoningPage:ExecuteAction("ShowOptions", arg1, arg2)
end

function var0.onBackPressed(arg0)
	arg0.anim:Play("anim_liner_logbook_out")
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)

	for iter0, iter1 in pairs(arg0.pages) do
		iter1:Destroy()

		iter1 = nil
	end

	arg0.reasoningPage:Destroy()

	arg0.reasoningPage = nil

	if arg0.contextData.onExit then
		arg0.contextData.onExit()

		arg0.contextData.onExit = nil
	end
end

function var0.IsTip()
	return LinerLogSchedulePage.IsTip() or LinerLogRoomPage.IsTip() or LinerLogEventPage.IsTip()
end

return var0
