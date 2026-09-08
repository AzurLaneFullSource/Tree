local var0_0 = class("ReversePacmanTaskScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ReversePacmanTaskUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.uiGetAllBtn, function()
		local var0_5 = {}

		for iter0_5, iter1_5 in ipairs(arg0_2.taskList) do
			if iter1_5:getTaskStatus() == 1 then
				table.insert(var0_5, iter1_5.id)
			end
		end

		if #var0_5 <= 0 then
			return
		end

		arg0_2:emit(ReversePacmanTaskMediator.ON_ACTIVITY_TASK_SUBMIT_ONESTEP, arg0_2.taskActivityID, var0_5)
	end, SFX_PANEL)

	arg0_2.itemList = {}
	arg0_2.uiLScroll = GetComponent(arg0_2.uiScroll, "LScrollRect")
	arg0_2.onInitItemHandler = handler(arg0_2, arg0_2.OnInitItem)
	arg0_2.onUpdateItemHandler = handler(arg0_2, arg0_2.OnUpdateItem)
	arg0_2.uiLScroll.onInitItem = arg0_2.onInitItemHandler
	arg0_2.uiLScroll.onUpdateItem = arg0_2.onUpdateItemHandler
end

function var0_0.didEnter(arg0_6)
	arg0_6:BlurView()
	arg0_6:RefreshUI()
end

function var0_0.willExit(arg0_7)
	arg0_7:UnBlurView()

	arg0_7.uiLScroll.onInitItem = nil
	arg0_7.uiLScroll.onUpdateItem = nil
	arg0_7.onInitItemHandler = nil
	arg0_7.onUpdateItemHandler = nil
end

function var0_0.BlurView(arg0_8)
	arg0_8:BlurPanel(arg0_8._tf)
end

function var0_0.UnBlurView(arg0_9)
	arg0_9:UnOverlayPanel(arg0_9._tf)
end

function var0_0.GetTaskList(arg0_10)
	local var0_10 = getProxy(TaskProxy)
	local var1_10 = ReversePacmanTools.GetActivity():getConfig("config_client").taskActivityID
	local var2_10 = getProxy(ActivityProxy):getActivityById(var1_10)
	local var3_10 = pg.activity_template[var1_10].config_data

	arg0_10.taskActivityID = var1_10

	local var4_10 = {}
	local var5_10 = getProxy(TaskProxy)

	for iter0_10, iter1_10 in ipairs(var3_10) do
		table.insert(var4_10, var5_10:getTaskVO(iter1_10))
	end

	return var4_10
end

function var0_0.RefreshUI(arg0_11)
	arg0_11.taskList = arg0_11:GetTaskList()

	arg0_11:Sort(arg0_11.taskList)
	arg0_11.uiLScroll:SetTotalCount(#arg0_11.taskList)

	if arg0_11.contextData.taskID then
		arg0_11:ScrollToTask(arg0_11.contextData.taskID)

		arg0_11.contextData.taskID = nil
	end

	setGray(arg0_11.uiGetAllBtn, not arg0_11:IsTip())
end

function var0_0.ScrollToTask(arg0_12, arg1_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.taskList) do
		if iter1_12.id == arg1_12 then
			local var0_12 = arg0_12.uiLScroll:HeadIndexToValue(iter0_12 - 1)

			arg0_12.uiLScroll:ScrollTo(math.clamp(var0_12, 0, 1))

			return
		end
	end
end

function var0_0.OnInitItem(arg0_13, arg1_13)
	arg0_13.itemList[arg1_13] = ReversePacmanTaskItem.New(tf(arg1_13), arg0_13)
end

function var0_0.OnUpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.itemList[arg2_14]

	if var0_14 == nil then
		arg0_14:OnInitItem(arg2_14)

		var0_14 = arg0_14.itemList[arg2_14]
	end

	local var1_14 = arg0_14.taskList[arg1_14 + 1]

	var0_14:SetData(var1_14)
end

function var0_0.Sort(arg0_15)
	local function var0_15(arg0_16, arg1_16, arg2_16)
		local function var0_16(arg0_17)
			for iter0_17, iter1_17 in ipairs(arg2_16) do
				if arg0_17 == iter1_17 then
					return iter0_17
				end
			end
		end

		return var0_16(arg0_16) < var0_16(arg1_16)
	end

	table.sort(arg0_15.taskList, function(arg0_18, arg1_18)
		local var0_18 = arg0_18:getTaskStatus()
		local var1_18 = arg1_18:getTaskStatus()

		if var0_18 == var1_18 then
			return arg0_18.id < arg1_18.id
		end

		return var0_15(var0_18, var1_18, {
			1,
			0,
			2,
			-1
		})
	end)
end

function var0_0.IsTip(arg0_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.taskList) do
		if iter1_19:getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

return var0_0
