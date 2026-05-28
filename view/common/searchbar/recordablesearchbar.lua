local var0_0 = class("RecordableSearchBar")

function var0_0.CreateData(arg0_1)
	local var0_1 = {}

	assert(arg0_1.key, "key is required")
	assert(arg0_1.parent, "parent is required")

	var0_1.uiName = arg0_1.uiName or "RecordableSearchBarUI"
	var0_1.synPosition = arg0_1.synPosition
	var0_1.position = arg0_1.position or Vector3.zero
	var0_1.anchoredPosition = arg0_1.anchoredPosition or Vector3.zero
	var0_1.holder = arg0_1.holder or "..."
	var0_1.onSearch = arg0_1.onSearch
	var0_1.onActive = arg0_1.onActive
	var0_1.onInputChanged = arg0_1.onInputChanged
	var0_1.enabledFlag = arg0_1.enabledFlag
	var0_1.expandParent = arg0_1.expand_parent
	var0_1.refreshPosWhenExpand = arg0_1.refresh_pos_when_expand
	var0_1.key = arg0_1.key .. "_SearchBar_"
	var0_1.parent = arg0_1.parent

	return var0_1
end

local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.Ctor(arg0_2, arg1_2)
	pg.DelegateInfo.New(arg0_2)

	arg0_2.enabledFlag = arg1_2.enabledFlag
	arg0_2.state = var1_0
	arg0_2.data = arg1_2

	arg0_2:Load()
end

function var0_0.IsEmpty(arg0_3)
	return arg0_3.state == var1_0 or arg0_3.state == var4_0
end

function var0_0.IsLoaded(arg0_4)
	return arg0_4.state == var3_0
end

function var0_0.IsDestory(arg0_5)
	return arg0_5.state == var4_0
end

function var0_0.Load(arg0_6)
	if not arg0_6:IsEmpty() then
		return
	end

	arg0_6.state = var2_0

	local var0_6 = arg0_6.data

	LoadAndInstantiateAsync("ui", var0_6.uiName, function(arg0_7)
		if arg0_6:IsDestory() then
			arg0_6:Unload(arg0_7)

			return
		end

		arg0_6:Init(arg0_7)
	end, true, true)
end

function var0_0.Init(arg0_8, arg1_8)
	arg0_8._go = arg1_8

	local var0_8 = arg0_8.data

	arg1_8.transform:SetParent(var0_8.parent, false)
	arg0_8:InitToggle()
	arg0_8:UpdatePosition()
	arg0_8:UpdateAnchoredPosition()

	if var0_8.synPosition then
		arg0_8:SyncPosition()
	end

	if arg0_8.enabledFlag ~= nil then
		setActive(arg0_8._go, arg0_8.enabledFlag)

		arg0_8.enabledFlag = nil
	end

	arg0_8.state = var3_0
end

function var0_0.InitToggle(arg0_9)
	local var0_9 = arg0_9.data

	arg0_9.toggle = arg0_9._go.transform:Find("button/Image")
	arg0_9.onTr = arg0_9._go.transform:Find("button/Image/on")
	arg0_9.offTr = arg0_9._go.transform:Find("button/Image/off")
	arg0_9.searchTr = arg0_9._go.transform:Find("button/search")
	arg0_9.holder = arg0_9._go.transform:Find("button/search/holder"):GetComponent(typeof(Text))
	arg0_9.noDrawGraphicCom = arg0_9._go:GetComponent("NoDrawingGraphic")
	arg0_9.historyTr = arg0_9._go.transform:Find("button/history")
	arg0_9.uiHistoryList = UIItemList.New(arg0_9.historyTr, arg0_9.historyTr:Find("Text"))
	arg0_9.mainBtnTr = arg0_9._go.transform:Find("button")
	arg0_9.isSelected = false

	onToggle(arg0_9, arg0_9.toggle, function(arg0_10)
		setActive(arg0_9.onTr, arg0_10)
		setActive(arg0_9.searchTr, arg0_10)
		setActive(arg0_9.offTr, not arg0_10)

		if var0_9.onActive then
			var0_9.onActive(arg0_10)
		end

		if not arg0_10 then
			arg0_9:OnUnSelectedInputField()
		end

		arg0_9:Reparent(arg0_10)
	end, SFX_PANEL)
	triggerToggle(arg0_9.toggle, false)

	arg0_9.etl = arg0_9.searchTr:GetComponent(typeof(EventTriggerListener))

	arg0_9.etl:AddSelectFunc(function(arg0_11, arg1_11)
		arg0_9:OnSelectedInputField()
	end)
	onInputEndEdit(arg0_9, arg0_9.searchTr, function()
		local var0_12 = getInputText(arg0_9.searchTr)

		arg0_9:RecordSearch(var0_12)

		if var0_9.onSearch then
			var0_9.onSearch(var0_12)
		end
	end)
	onInputChanged(arg0_9, arg0_9.searchTr, function()
		if var0_9.onInputChanged then
			var0_9.onInputChanged(str)
		end
	end)
	onButton(arg0_9, arg0_9._go, function()
		local var0_14 = getInputText(arg0_9.searchTr)

		arg0_9:RecordSearch(var0_14)
		arg0_9:OnUnSelectedInputField()
	end, SFX_PANEL)
	arg0_9:UpdateHolder(var0_9.holder)
end

function var0_0.Reparent(arg0_15, arg1_15)
	local var0_15 = arg0_15.data

	if var0_15.expandParent then
		local var1_15 = arg1_15 and var0_15.expandParent or var0_15.parent

		arg0_15._go.transform:SetParent(var1_15, false)

		if var0_15.refreshPosWhenExpand then
			if arg1_15 then
				arg0_15.mainBtnTr.position = var0_15.parent.position
			else
				arg0_15:UpdateAnchoredPosition()
			end
		end
	end
end

function var0_0.UpdatePosition(arg0_16)
	local var0_16 = arg0_16.data

	if not var0_16.position then
		return
	end

	local var1_16 = arg0_16._go.transform:InverseTransformPoint(var0_16.position)

	arg0_16.mainBtnTr.localPosition = Vector3(var1_16.x, var1_16.y, 0)
end

function var0_0.UpdateAnchoredPosition(arg0_17)
	local var0_17 = arg0_17.data

	if not var0_17.anchoredPosition then
		return
	end

	arg0_17.mainBtnTr.anchoredPosition = var0_17.anchoredPosition
end

function var0_0.SyncPosition(arg0_18)
	arg0_18:RemoveSyncPosition()

	arg0_18.timer = Timer.New(function()
		arg0_18:UpdatePosition()
	end, 0.1, -1)

	arg0_18.timer:Start()
end

function var0_0.RemoveSyncPosition(arg0_20)
	if arg0_20.timer then
		arg0_20.timer:Stop()

		arg0_20.timer = nil
	end
end

function var0_0.RecordSearch(arg0_21, arg1_21)
	if not arg1_21 or arg1_21 == "" then
		return
	end

	local var0_21 = arg0_21.data.key
	local var1_21 = arg0_21:GetHistorySearch()

	if table.contains(var1_21, arg1_21) then
		return
	end

	table.insert(var1_21, 1, arg1_21)

	local var2_21 = {}
	local var3_21 = math.min(#var1_21, 3)

	for iter0_21 = 1, var3_21 do
		table.insert(var2_21, var1_21[iter0_21])
	end

	local var4_21 = table.concat(var2_21, "#")

	PlayerPrefs.SetString(var0_21, var4_21)
	PlayerPrefs.Save()
end

function var0_0.GetHistorySearch(arg0_22)
	local var0_22 = arg0_22.data.key
	local var1_22 = PlayerPrefs.GetString(var0_22, "")

	if not var1_22 or var1_22 == "" then
		return {}
	end

	local var2_22 = {}
	local var3_22 = string.split(var1_22, "#")

	for iter0_22, iter1_22 in ipairs(var3_22) do
		if iter1_22 ~= "" then
			table.insert(var2_22, iter1_22)
		end
	end

	return var2_22
end

function var0_0.OnSelectedInputField(arg0_23)
	local var0_23 = arg0_23:GetHistorySearch()

	if arg0_23.isSelected or #var0_23 <= 0 then
		return
	end

	arg0_23.isSelected = true
	arg0_23.noDrawGraphicCom.raycastTarget = true

	arg0_23:InitHistorySearch(var0_23)
end

function var0_0.OnUnSelectedInputField(arg0_24)
	if not arg0_24.isSelected then
		return
	end

	arg0_24.isSelected = false
	arg0_24.noDrawGraphicCom.raycastTarget = false

	arg0_24:CloseHistorySearch()
end

function var0_0.InitHistorySearch(arg0_25, arg1_25)
	local var0_25 = arg0_25.data

	setActive(arg0_25.historyTr, true)

	local var1_25 = arg0_25:GetHistorySearch()

	arg0_25.uiHistoryList:make(function(arg0_26, arg1_26, arg2_26)
		local var0_26 = arg1_26 + 1

		if arg0_26 == UIItemList.EventUpdate then
			setText(arg2_26, var1_25[var0_26])
			onButton(arg0_25, arg2_26, function()
				setInputText(arg0_25.searchTr, var1_25[var0_26])

				if var0_25.onSearch then
					var0_25.onSearch(var1_25[var0_26])
				end

				arg0_25:OnUnSelectedInputField()
			end, SFX_PANEL)
			setActive(arg2_26:Find("Image"), var0_26 ~= #var1_25)
		end
	end)
	arg0_25.uiHistoryList:align(#var1_25)
end

function var0_0.CloseHistorySearch(arg0_28)
	setActive(arg0_28.historyTr, false)
end

function var0_0.GetInputText(arg0_29)
	if not arg0_29:IsLoaded() then
		return ""
	end

	return getInputText(arg0_29.searchTr)
end

function var0_0.UpdateHolder(arg0_30, arg1_30)
	if not arg0_30:IsLoaded() then
		return
	end

	setText(arg0_30.holder, arg1_30)
end

function var0_0.ClearInputText(arg0_31)
	if not arg0_31:IsLoaded() then
		return
	end

	setInputText(arg0_31.searchTr, "")
end

function var0_0.Unload(arg0_32, arg1_32)
	Object.Destroy(arg1_32)
end

function var0_0.EnableOrDisable(arg0_33, arg1_33)
	if arg0_33:IsLoaded() then
		setActive(arg0_33._go, arg1_33)
	else
		arg0_33.enabledFlag = arg1_33
	end
end

function var0_0.Dispose(arg0_34)
	pg.DelegateInfo.Dispose(arg0_34)

	if arg0_34:IsLoaded() then
		arg0_34:Unload(arg0_34._go)
		arg0_34:OnUnSelectedInputField()

		if arg0_34.etl then
			ClearEventTrigger(arg0_34.etl)
		end

		setInputText(arg0_34.searchTr, "")
		arg0_34:RemoveSyncPosition()
	end

	arg0_34.state = var4_0
	arg0_34.data = nil
	arg0_34.enabledFlag = nil
	arg0_34._go = nil
end

return var0_0
