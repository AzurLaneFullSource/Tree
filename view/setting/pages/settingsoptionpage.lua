local var0_0 = class("SettingsOptionPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SettingsCombinationPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2:OnBindEvent()

	arg0_2.panelContainer = arg0_2:findTF("content")

	local var0_2 = arg0_2:GetPanels()

	arg0_2.panels = {}

	for iter0_2, iter1_2 in ipairs(var0_2) do
		table.insert(arg0_2.panels, iter1_2.New(arg0_2.panelContainer))
	end

	arg0_2.contentSizeFitter = arg0_2.panelContainer:GetComponent(typeof(ContentSizeFitter))
	arg0_2.cg = arg0_2._tf:GetComponent(typeof(CanvasGroup))
	arg0_2.scrollrect = arg0_2._tf:GetComponent(typeof(ScrollRect))

	arg0_2:InitPanels()
	setActive(arg0_2._tf, true)
end

function var0_0.OnBindEvent(arg0_3)
	arg0_3:bind(SettingsRandomFlagShipAndSkinPanel.EVT_UPDTAE, function()
		local var0_4 = arg0_3:GetPanel(SettingsRandomFlagShipAndSkinPanel)

		if var0_4 then
			var0_4:OnRandomFlagshipFlagUpdate()
		end
	end)
	arg0_3:bind(SettingsNotificationPanel.UPDATE_ALARM_PANEL, function()
		local var0_5 = arg0_3:GetPanel(SettingsNotificationPanel)

		if var0_5 then
			var0_5:UpdateAndroidAlarm()
		end
	end)
end

function var0_0.GetPanels(arg0_6)
	local var0_6 = {
		SettingsFpsPanle,
		SettingsNotificationPanel,
		SettingsWorldPanle,
		SettingsRandomFlagShipAndSkinPanel,
		SettingsStoryAutoPlayPanel,
		SettingsStorySpeedPanel,
		SettingsMainScenePanel,
		SettingsOtherPanel
	}

	if arg0_6:NeedAdjustScreen() then
		table.insert(var0_6, 1, SettingsAdjustScreenPanle)
	end

	return var0_6
end

function var0_0.NeedAdjustScreen(arg0_7)
	return Screen.width / Screen.height - 0.001 > ADAPT_NOTICE
end

function var0_0.GetPanel(arg0_8, arg1_8)
	if not arg0_8.panels then
		return nil
	end

	return _.detect(arg0_8.panels, function(arg0_9)
		return isa(arg0_9, arg1_8)
	end)
end

function var0_0.InitPanels(arg0_10)
	local var0_10 = {}
	local var1_10 = GetOrAddComponent(arg0_10.contentSizeFitter, typeof(CanvasGroup))

	arg0_10.scrollrect.enabled = false

	for iter0_10, iter1_10 in ipairs(arg0_10.panels) do
		table.insert(var0_10, function(arg0_11)
			iter1_10:Init(arg0_11)
		end)
	end

	seriesAsync(var0_10, function()
		arg0_10.scrollrect.enabled = true

		arg0_10:OnInitPanle()
	end)
end

function var0_0.RebuildLayout(arg0_13, arg1_13)
	onDelayTick(function()
		arg0_13.contentSizeFitter.enabled = false
		arg0_13.contentSizeFitter.enabled = true

		arg1_13()
	end, 0.05)
end

function var0_0.OnInitPanle(arg0_15)
	if arg0_15.contextData.scroll then
		local var0_15

		if arg0_15.contextData.scroll == "world_settings" then
			local var1_15 = arg0_15:GetPanel(SettingsWorldPanle)
		else
			local var2_15 = arg0_15:GetPanel(arg0_15.contextData.scroll)
		end

		local var3_15 = arg0_15:GetPanel(arg0_15.contextData.scroll)

		if var3_15 then
			arg0_15:ScrollToPanel(var3_15)
		end
	end
end

function var0_0.ScrollToPanel(arg0_16, arg1_16)
	local var0_16 = arg0_16.panelContainer:InverseTransformPoint(arg1_16._tf.position)

	setAnchoredPosition(arg0_16.panelContainer, {
		y = -var0_16.y
	})
end

function var0_0.OnDestroy(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.panels) do
		iter1_17:Dispose()
	end

	arg0_17.panels = nil
end

function var0_0.Show(arg0_18)
	arg0_18.cg.blocksRaycasts = true
	arg0_18.cg.alpha = 1
end

function var0_0.Hide(arg0_19)
	arg0_19.cg.blocksRaycasts = false
	arg0_19.cg.alpha = 0
end

return var0_0
