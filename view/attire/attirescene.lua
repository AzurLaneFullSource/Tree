local var0 = class("AttireScene", import("..base.BaseUI"))

var0.PAGE_ICONFRAME = 1
var0.PAGE_CHATFRAME = 2
var0.PAGE_ACHIEVEMENT = 3

function var0.getUIName(arg0)
	return "AttireUI"
end

function var0.setAttires(arg0, arg1)
	arg0.rawAttireVOs = arg1

	arg0:updateTips(getProxy(AttireProxy):needTip())
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back_btn")
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.toggles = {
		arg0:findTF("adapt/left_length/frame/tagRoot/iconframe", arg0.blurPanel),
		arg0:findTF("adapt/left_length/frame/tagRoot/chatframe", arg0.blurPanel),
		arg0:findTF("adapt/left_length/frame/tagRoot/achievement", arg0.blurPanel)
	}
	arg0.panels = {
		AttireIconFramePanel.New(arg0._tf, arg0.event, arg0.contextData),
		AttireChatFramePanel.New(arg0._tf, arg0.event, arg0.contextData),
		AttireAchievementPanel.New(arg0._tf, arg0.event, arg0.contextData)
	}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)

	for iter0, iter1 in ipairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				arg0:switchPage(iter0)
			end
		end, SFX_PANEL)
	end

	local var0 = arg0.contextData.index or var0.PAGE_ICONFRAME

	triggerToggle(arg0.toggles[var0], true)
end

function var0.switchPage(arg0, arg1)
	if arg0.page then
		arg0.panels[arg0.page]:ActionInvoke("Hide")
	end

	arg0.page = arg1

	arg0.panels[arg0.page]:Load()
	arg0.panels[arg0.page]:ActionInvoke("Show")
	arg0:updateCurrPage()
end

function var0.updateCurrPage(arg0)
	assert(arg0.page)
	arg0.panels[arg0.page]:ActionInvoke("Update", arg0.rawAttireVOs, arg0.playerVO)
end

function var0.updateTips(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		setActive(arg0.toggles[iter0]:Find("tip"), iter1)
	end
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:Destroy()
	end
end

return var0
