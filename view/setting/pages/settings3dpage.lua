local var0_0 = class("Settings3DPage", import("...base.BaseSubView"))

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
	arg0_3:bind(SettingsOtherGraphicsPanle.EVT_UPDTAE, function()
		local var0_4 = arg0_3:GetPanel(SettingsOtherGraphicsPanle)

		if var0_4 then
			var0_4:RefreshPanelByGraphcLevel()
			arg0_3:RebuildLayout(function()
				return
			end)
		end
	end)
	arg0_3:bind(SettingsGraphicsPanle.EVT_UPDTAE, function()
		local var0_6 = arg0_3:GetPanel(SettingsGraphicsPanle)

		if var0_6 then
			var0_6:OnUpdate()
		end
	end)
end

function var0_0.GetPanels(arg0_7)
	local var0_7 = {
		SettingsGraphicsPanle,
		SettingsOtherGraphicsPanle
	}

	if arg0_7:NeedAdjustScreen() then
		table.insert(var0_7, 1, SettingsAdjustScreenPanle)
	end

	return var0_7
end

function var0_0.NeedAdjustScreen(arg0_8)
	return Screen.width / Screen.height - 0.001 > ADAPT_NOTICE
end

function var0_0.GetPanel(arg0_9, arg1_9)
	if not arg0_9.panels then
		return nil
	end

	return _.detect(arg0_9.panels, function(arg0_10)
		return isa(arg0_10, arg1_9)
	end)
end

function var0_0.InitPanels(arg0_11)
	local var0_11 = {}
	local var1_11 = GetOrAddComponent(arg0_11.contentSizeFitter, typeof(CanvasGroup))

	arg0_11.scrollrect.enabled = false

	for iter0_11, iter1_11 in ipairs(arg0_11.panels) do
		table.insert(var0_11, function(arg0_12)
			iter1_11:Init(arg0_12)
		end)
	end

	seriesAsync(var0_11, function()
		arg0_11.scrollrect.enabled = true

		arg0_11:OnInitPanle()
	end)
end

function var0_0.RebuildLayout(arg0_14, arg1_14)
	onDelayTick(function()
		arg0_14.contentSizeFitter.enabled = false
		arg0_14.contentSizeFitter.enabled = true

		arg1_14()
	end, 0.05)
end

function var0_0.OnInitPanle(arg0_16)
	if arg0_16.contextData.scroll then
		local var0_16

		if arg0_16.contextData.scroll == "world_settings" then
			local var1_16 = arg0_16:GetPanel(SettingsWorldPanle)
		else
			local var2_16 = arg0_16:GetPanel(arg0_16.contextData.scroll)
		end

		local var3_16 = arg0_16:GetPanel(arg0_16.contextData.scroll)

		if var3_16 then
			arg0_16:ScrollToPanel(var3_16)
		end
	end
end

function var0_0.ScrollToPanel(arg0_17, arg1_17)
	local var0_17 = arg0_17.panelContainer:InverseTransformPoint(arg1_17._tf.position)

	setAnchoredPosition(arg0_17.panelContainer, {
		y = -var0_17.y
	})
end

function var0_0.OnDestroy(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.panels) do
		iter1_18:Dispose()
	end

	arg0_18.panels = nil
end

function var0_0.Show(arg0_19)
	arg0_19.cg.blocksRaycasts = true
	arg0_19.cg.alpha = 1
end

function var0_0.Hide(arg0_20)
	arg0_20.cg.blocksRaycasts = false
	arg0_20.cg.alpha = 0
end

return var0_0
