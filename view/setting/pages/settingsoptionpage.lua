local var0 = class("SettingsOptionPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "SettingsCombinationPage"
end

function var0.OnLoaded(arg0)
	arg0:OnBindEvent()

	arg0.panelContainer = arg0:findTF("content")

	local var0 = arg0:GetPanels()

	arg0.panels = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg0.panels, iter1.New(arg0.panelContainer))
	end

	arg0.contentSizeFitter = arg0.panelContainer:GetComponent(typeof(ContentSizeFitter))
	arg0.cg = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.scrollrect = arg0._tf:GetComponent(typeof(ScrollRect))

	arg0:InitPanels()
	setActive(arg0._tf, true)
end

function var0.OnBindEvent(arg0)
	arg0:bind(SettingsRandomFlagShipAndSkinPanel.EVT_UPDTAE, function()
		local var0 = arg0:GetPanel(SettingsRandomFlagShipAndSkinPanel)

		if var0 then
			var0:OnRandomFlagshipFlagUpdate()
		end
	end)
end

function var0.GetPanels(arg0)
	local var0 = {
		SettingsFpsPanle,
		SettingsNotificationPanel,
		SettingsWorldPanle,
		SettingsRandomFlagShipAndSkinPanel,
		SettingsStoryAutoPlayPanel,
		SettingsStorySpeedPanel,
		SettingsOtherPanel
	}

	if arg0:NeedAdjustScreen() then
		table.insert(var0, 1, SettingsAdjustScreenPanle)
	end

	return var0
end

function var0.NeedAdjustScreen(arg0)
	return Screen.width / Screen.height - 0.001 > ADAPT_NOTICE
end

function var0.GetPanel(arg0, arg1)
	if not arg0.panels then
		return nil
	end

	return _.detect(arg0.panels, function(arg0)
		return isa(arg0, arg1)
	end)
end

function var0.InitPanels(arg0)
	local var0 = {}
	local var1 = GetOrAddComponent(arg0.contentSizeFitter, typeof(CanvasGroup))

	arg0.scrollrect.enabled = false

	for iter0, iter1 in ipairs(arg0.panels) do
		table.insert(var0, function(arg0)
			iter1:Init(arg0)
		end)
	end

	seriesAsync(var0, function()
		arg0.scrollrect.enabled = true

		arg0:OnInitPanle()
	end)
end

function var0.RebuildLayout(arg0, arg1)
	onDelayTick(function()
		arg0.contentSizeFitter.enabled = false
		arg0.contentSizeFitter.enabled = true

		arg1()
	end, 0.05)
end

function var0.OnInitPanle(arg0)
	if arg0.contextData.scroll then
		local var0

		if arg0.contextData.scroll == "world_settings" then
			local var1 = arg0:GetPanel(SettingsWorldPanle)
		else
			local var2 = arg0:GetPanel(arg0.contextData.scroll)
		end

		local var3 = arg0:GetPanel(arg0.contextData.scroll)

		if var3 then
			arg0:ScrollToPanel(var3)
		end
	end
end

function var0.ScrollToPanel(arg0, arg1)
	local var0 = arg0.panelContainer:InverseTransformPoint(arg1._tf.position)

	setAnchoredPosition(arg0.panelContainer, {
		y = -var0.y
	})
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:Dispose()
	end

	arg0.panels = nil
end

function var0.Show(arg0)
	arg0.cg.blocksRaycasts = true
	arg0.cg.alpha = 1
end

function var0.Hide(arg0)
	arg0.cg.blocksRaycasts = false
	arg0.cg.alpha = 0
end

return var0
