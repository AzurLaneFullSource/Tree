local var0_0 = class("CoreStoryTemplatePage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("bg_story")
	arg0_1.ad = arg0_1:findTF("AD")
	arg0_1.goBtn = arg0_1:findTF("AD/go_btn")
	arg0_1.scenario = CoreScenarioTemplatePage.New(arg0_1._tf)

	arg0_1.scenario:SetCoreStoryPage(arg0_1)

	arg0_1.loader = AutoLoader.New()
	arg0_1.mapGroup = {}
	arg0_1.currentBG = nil
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.goBtn, function()
		arg0_2.scenario:Load()
		arg0_2.scenario:SetActivity(arg0_2.activity)
		arg0_2.scenario:UpdateStoryTask()
		arg0_2.scenario:ActionInvoke("UpdateView")
		arg0_2:ShowScenarioLayer(true)
	end, SFX_PANEL)
end

function var0_0.OnShowFlush(arg0_4)
	var0_0.super.OnShowFlush(arg0_4)

	if arg0_4.coreActivityUI.contextData.activeScenario then
		triggerButton(arg0_4.goBtn)
	end
end

function var0_0.SwitchBG(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg1_5 or #arg1_5 <= 0 then
		existCall(arg2_5)

		return
	elseif arg3_5 then
		-- block empty
	elseif table.equal(arg0_5.currentBG, arg1_5) then
		return
	end

	arg0_5.currentBG = arg1_5

	for iter0_5, iter1_5 in ipairs(arg0_5.mapGroup) do
		arg0_5.loader:ClearRequest(iter1_5)
	end

	table.clear(arg0_5.mapGroup)

	local var0_5 = arg0_5.loader:GetSpriteDirect("bg/" .. arg1_5[1].BG, "", function(arg0_6)
		setImageSprite(arg0_5.bg, arg0_6)
		SetActive(arg0_5.bg, true)
	end)

	table.insert(arg0_5.mapGroup, var0_5)
end

function var0_0.ShowScenarioLayer(arg0_7, arg1_7)
	if arg1_7 then
		arg0_7.scenario:ActionInvoke("Show")
		arg0_7.coreActivityUI:ActiveScenarioLayer(true)
		SetActive(arg0_7.ad, false)
		SetActive(arg0_7.bg, true)
	else
		arg0_7.scenario:Hide()
		arg0_7.coreActivityUI:ActiveScenarioLayer(false)
		SetActive(arg0_7.ad, true)
		SetActive(arg0_7.bg, false)
	end
end

function var0_0.IsShowingPopWindow(arg0_8)
	return arg0_8.scenario:isShowing()
end

function var0_0.ClosePopWindow(arg0_9)
	arg0_9.scenario:Hide()
	arg0_9:ShowScenarioLayer(false)
end

return var0_0
