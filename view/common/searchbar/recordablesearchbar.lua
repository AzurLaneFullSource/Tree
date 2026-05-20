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

function var0_0.UpdatePosition(arg0_15)
	local var0_15 = arg0_15.data

	if not var0_15.position then
		return
	end

	local var1_15 = arg0_15._go.transform:InverseTransformPoint(var0_15.position)

	arg0_15.mainBtnTr.localPosition = Vector3(var1_15.x, var1_15.y, 0)
end

function var0_0.UpdateAnchoredPosition(arg0_16)
	local var0_16 = arg0_16.data

	if not var0_16.anchoredPosition then
		return
	end

	arg0_16.mainBtnTr.anchoredPosition = var0_16.anchoredPosition
end

function var0_0.SyncPosition(arg0_17)
	arg0_17:RemoveSyncPosition()

	arg0_17.timer = Timer.New(function()
		arg0_17:UpdatePosition()
	end, 0.1, -1)

	arg0_17.timer:Start()
end

function var0_0.RemoveSyncPosition(arg0_19)
	if arg0_19.timer then
		arg0_19.timer:Stop()

		arg0_19.timer = nil
	end
end

function var0_0.RecordSearch(arg0_20, arg1_20)
	if not arg1_20 or arg1_20 == "" then
		return
	end

	local var0_20 = arg0_20.data.key
	local var1_20 = arg0_20:GetHistorySearch()

	if table.contains(var1_20, arg1_20) then
		return
	end

	table.insert(var1_20, 1, arg1_20)

	local var2_20 = {}
	local var3_20 = math.min(#var1_20, 3)

	for iter0_20 = 1, var3_20 do
		table.insert(var2_20, var1_20[iter0_20])
	end

	local var4_20 = table.concat(var2_20, "#")

	PlayerPrefs.SetString(var0_20, var4_20)
	PlayerPrefs.Save()
end

function var0_0.GetHistorySearch(arg0_21)
	local var0_21 = arg0_21.data.key
	local var1_21 = PlayerPrefs.GetString(var0_21, "")

	if not var1_21 or var1_21 == "" then
		return {}
	end

	local var2_21 = {}
	local var3_21 = string.split(var1_21, "#")

	for iter0_21, iter1_21 in ipairs(var3_21) do
		if iter1_21 ~= "" then
			table.insert(var2_21, iter1_21)
		end
	end

	return var2_21
end

function var0_0.OnSelectedInputField(arg0_22)
	local var0_22 = arg0_22:GetHistorySearch()

	if arg0_22.isSelected or #var0_22 <= 0 then
		return
	end

	arg0_22.isSelected = true
	arg0_22.noDrawGraphicCom.raycastTarget = true

	arg0_22:InitHistorySearch(var0_22)
end

function var0_0.OnUnSelectedInputField(arg0_23)
	if not arg0_23.isSelected then
		return
	end

	arg0_23.isSelected = false
	arg0_23.noDrawGraphicCom.raycastTarget = false

	arg0_23:CloseHistorySearch()
end

function var0_0.InitHistorySearch(arg0_24, arg1_24)
	local var0_24 = arg0_24.data

	setActive(arg0_24.historyTr, true)

	local var1_24 = arg0_24:GetHistorySearch()

	arg0_24.uiHistoryList:make(function(arg0_25, arg1_25, arg2_25)
		local var0_25 = arg1_25 + 1

		if arg0_25 == UIItemList.EventUpdate then
			setText(arg2_25, var1_24[var0_25])
			onButton(arg0_24, arg2_25, function()
				setInputText(arg0_24.searchTr, var1_24[var0_25])

				if var0_24.onSearch then
					var0_24.onSearch(var1_24[var0_25])
				end

				arg0_24:OnUnSelectedInputField()
			end, SFX_PANEL)
			setActive(arg2_25:Find("Image"), var0_25 ~= #var1_24)
		end
	end)
	arg0_24.uiHistoryList:align(#var1_24)
end

function var0_0.CloseHistorySearch(arg0_27)
	setActive(arg0_27.historyTr, false)
end

function var0_0.GetInputText(arg0_28)
	if not arg0_28:IsLoaded() then
		return ""
	end

	return getInputText(arg0_28.searchTr)
end

function var0_0.UpdateHolder(arg0_29, arg1_29)
	if not arg0_29:IsLoaded() then
		return
	end

	setText(arg0_29.holder, arg1_29)
end

function var0_0.ClearInputText(arg0_30)
	if not arg0_30:IsLoaded() then
		return
	end

	setInputText(arg0_30.searchTr, "")
end

function var0_0.Unload(arg0_31, arg1_31)
	Object.Destroy(arg1_31)
end

function var0_0.EnableOrDisable(arg0_32, arg1_32)
	if arg0_32:IsLoaded() then
		setActive(arg0_32._go, arg1_32)
	else
		arg0_32.enabledFlag = arg1_32
	end
end

function var0_0.Dispose(arg0_33)
	if arg0_33:IsLoaded() then
		arg0_33:Unload(arg0_33._go)

		arg0_33._go = nil
	end

	arg0_33:OnUnSelectedInputField()

	arg0_33.state = var4_0

	pg.DelegateInfo.Dispose(arg0_33)
	ClearEventTrigger(arg0_33.etl)
	setInputText(arg0_33.searchTr, "")
	arg0_33:RemoveSyncPosition()

	arg0_33.data = nil
	arg0_33.enabledFlag = nil
end

return var0_0
