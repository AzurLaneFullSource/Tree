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
end

function var0_0.GetPanels(arg0_5)
	local var0_5 = {
		SettingsFpsPanle,
		SettingsNotificationPanel,
		SettingsWorldPanle,
		SettingsRandomFlagShipAndSkinPanel,
		SettingsStoryAutoPlayPanel,
		SettingsStorySpeedPanel,
		SettingsMainScenePanel,
		SettingsOtherPanel
	}

	if arg0_5:NeedAdjustScreen() then
		table.insert(var0_5, 1, SettingsAdjustScreenPanle)
	end

	return var0_5
end

function var0_0.NeedAdjustScreen(arg0_6)
	return Screen.width / Screen.height - 0.001 > ADAPT_NOTICE
end

function var0_0.GetPanel(arg0_7, arg1_7)
	if not arg0_7.panels then
		return nil
	end

	return _.detect(arg0_7.panels, function(arg0_8)
		return isa(arg0_8, arg1_7)
	end)
end

function var0_0.InitPanels(arg0_9)
	local var0_9 = {}
	local var1_9 = GetOrAddComponent(arg0_9.contentSizeFitter, typeof(CanvasGroup))

	arg0_9.scrollrect.enabled = false

	for iter0_9, iter1_9 in ipairs(arg0_9.panels) do
		table.insert(var0_9, function(arg0_10)
			iter1_9:Init(arg0_10)
		end)
	end

	seriesAsync(var0_9, function()
		arg0_9.scrollrect.enabled = true

		arg0_9:OnInitPanle()
	end)
end

function var0_0.RebuildLayout(arg0_12, arg1_12)
	onDelayTick(function()
		arg0_12.contentSizeFitter.enabled = false
		arg0_12.contentSizeFitter.enabled = true

		arg1_12()
	end, 0.05)
end

function var0_0.OnInitPanle(arg0_14)
	if arg0_14.contextData.scroll then
		local var0_14

		if arg0_14.contextData.scroll == "world_settings" then
			local var1_14 = arg0_14:GetPanel(SettingsWorldPanle)
		else
			local var2_14 = arg0_14:GetPanel(arg0_14.contextData.scroll)
		end

		local var3_14 = arg0_14:GetPanel(arg0_14.contextData.scroll)

		if var3_14 then
			arg0_14:ScrollToPanel(var3_14)
		end
	end
end

function var0_0.ScrollToPanel(arg0_15, arg1_15)
	local var0_15 = arg0_15.panelContainer:InverseTransformPoint(arg1_15._tf.position)

	setAnchoredPosition(arg0_15.panelContainer, {
		y = -var0_15.y
	})
end

function var0_0.OnDestroy(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.panels) do
		iter1_16:Dispose()
	end

	arg0_16.panels = nil
end

function var0_0.Show(arg0_17)
	arg0_17.cg.blocksRaycasts = true
	arg0_17.cg.alpha = 1
end

function var0_0.Hide(arg0_18)
	arg0_18.cg.blocksRaycasts = false
	arg0_18.cg.alpha = 0
end

return var0_0
