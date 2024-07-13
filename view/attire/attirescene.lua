local var0_0 = class("AttireScene", import("..base.BaseUI"))

var0_0.PAGE_ICONFRAME = 1
var0_0.PAGE_CHATFRAME = 2
var0_0.PAGE_ACHIEVEMENT = 3

function var0_0.getUIName(arg0_1)
	return "AttireUI"
end

function var0_0.setAttires(arg0_2, arg1_2)
	arg0_2.rawAttireVOs = arg1_2

	arg0_2:updateTips(getProxy(AttireProxy):needTip())
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.playerVO = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4.backBtn = arg0_4:findTF("blur_panel/adapt/top/back_btn")
	arg0_4.blurPanel = arg0_4:findTF("blur_panel")
	arg0_4.toggles = {
		arg0_4:findTF("adapt/left_length/frame/tagRoot/iconframe", arg0_4.blurPanel),
		arg0_4:findTF("adapt/left_length/frame/tagRoot/chatframe", arg0_4.blurPanel),
		arg0_4:findTF("adapt/left_length/frame/tagRoot/achievement", arg0_4.blurPanel)
	}
	arg0_4.panels = {
		AttireIconFramePanel.New(arg0_4._tf, arg0_4.event, arg0_4.contextData),
		AttireChatFramePanel.New(arg0_4._tf, arg0_4.event, arg0_4.contextData),
		AttireAchievementPanel.New(arg0_4._tf, arg0_4.event, arg0_4.contextData)
	}
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SOUND_BACK)

	for iter0_5, iter1_5 in ipairs(arg0_5.toggles) do
		onToggle(arg0_5, iter1_5, function(arg0_7)
			if arg0_7 then
				arg0_5:switchPage(iter0_5)
			end
		end, SFX_PANEL)
	end

	local var0_5 = arg0_5.contextData.index or var0_0.PAGE_ICONFRAME

	triggerToggle(arg0_5.toggles[var0_5], true)
end

function var0_0.switchPage(arg0_8, arg1_8)
	if arg0_8.page then
		arg0_8.panels[arg0_8.page]:ActionInvoke("Hide")
	end

	arg0_8.page = arg1_8

	arg0_8.panels[arg0_8.page]:Load()
	arg0_8.panels[arg0_8.page]:ActionInvoke("Show")
	arg0_8:updateCurrPage()
end

function var0_0.updateCurrPage(arg0_9)
	assert(arg0_9.page)
	arg0_9.panels[arg0_9.page]:ActionInvoke("Update", arg0_9.rawAttireVOs, arg0_9.playerVO)
end

function var0_0.updateTips(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg1_10) do
		setActive(arg0_10.toggles[iter0_10]:Find("tip"), iter1_10)
	end
end

function var0_0.willExit(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.panels) do
		iter1_11:Destroy()
	end
end

return var0_0
