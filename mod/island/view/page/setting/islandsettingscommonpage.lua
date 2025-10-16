local var0_0 = class("IslandSettingsCommonPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSettingsCommonPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.panelContainer = arg0_2._tf:Find("content")

	local var0_2 = arg0_2:GetPanels()

	arg0_2.panels = {}

	for iter0_2, iter1_2 in ipairs(var0_2) do
		table.insert(arg0_2.panels, iter1_2.New(arg0_2.panelContainer))
	end

	arg0_2.contentSizeFitter = arg0_2.panelContainer:GetComponent(typeof(ContentSizeFitter))
	arg0_2.cg = arg0_2._tf:GetComponent(typeof(CanvasGroup))
	arg0_2.scrollrect = arg0_2.panelContainer:GetComponent(typeof(ScrollRect))

	arg0_2:InitPanels()
	setActive(arg0_2._tf, true)
end

function var0_0.GetPanels(arg0_3)
	return {
		IslandSettingsCardShowPanel,
		IslandSettingsEscapePanel
	}
end

function var0_0.GetPanel(arg0_4, arg1_4)
	if not arg0_4.panels then
		return nil
	end

	return _.detect(arg0_4.panels, function(arg0_5)
		return isa(arg0_5, arg1_4)
	end)
end

function var0_0.InitPanels(arg0_6)
	local var0_6 = {}
	local var1_6 = GetOrAddComponent(arg0_6.contentSizeFitter, typeof(CanvasGroup))

	arg0_6.scrollrect.enabled = false

	for iter0_6, iter1_6 in ipairs(arg0_6.panels) do
		table.insert(var0_6, function(arg0_7)
			iter1_6:Init(arg0_7)
		end)
	end

	seriesAsync(var0_6, function()
		arg0_6.scrollrect.enabled = true

		arg0_6:Update()
	end)
end

function var0_0.Show(arg0_9)
	arg0_9.cg.blocksRaycasts = true
	arg0_9.cg.alpha = 1
end

function var0_0.Update(arg0_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.panels) do
		iter1_10:OnUpdate()
	end
end

function var0_0.Hide(arg0_11)
	arg0_11.cg.blocksRaycasts = false
	arg0_11.cg.alpha = 0
end

function var0_0.Save(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in ipairs(arg0_12.panels) do
		local var1_12 = iter1_12:GetFlags()

		var0_12 = table.mergeArray(var0_12, var1_12)
	end

	arg0_12:emit(IslandMediator.SET_SETTINGS_FLAG, var0_12)
end

function var0_0.OnDestroy(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.panels) do
		iter1_13:Dispose()
	end

	arg0_13.panels = nil
end

return var0_0
