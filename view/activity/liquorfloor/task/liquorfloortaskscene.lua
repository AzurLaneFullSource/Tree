local var0_0 = class("LiquorFloorTaskScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LiquorFloorTaskUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	setText(arg0_2.uiTitleText, i18n("LiquorFloorTaskUI_title"))

	arg0_2.itemList = {}
	arg0_2.uiLScroll = GetComponent(arg0_2.uiScroll, "LScrollRect")
	arg0_2.onInitItemHandler = handler(arg0_2, arg0_2.OnInitItem)
	arg0_2.onUpdateItemHandler = handler(arg0_2, arg0_2.OnUpdateItem)
	arg0_2.uiLScroll.onInitItem = arg0_2.onInitItemHandler
	arg0_2.uiLScroll.onUpdateItem = arg0_2.onUpdateItemHandler
end

function var0_0.didEnter(arg0_5)
	arg0_5:BlurView()
	arg0_5:RefreshUI()
end

function var0_0.willExit(arg0_6)
	arg0_6:UnBlurView()

	arg0_6.uiLScroll.onInitItem = nil
	arg0_6.uiLScroll.onUpdateItem = nil
	arg0_6.onInitItemHandler = nil
	arg0_6.onUpdateItemHandler = nil
end

function var0_0.BlurView(arg0_7)
	arg0_7:BlurPanel(arg0_7._tf)
end

function var0_0.UnBlurView(arg0_8)
	arg0_8:UnOverlayPanel(arg0_8._tf)
end

function var0_0.GetTaskList(arg0_9)
	local var0_9 = getProxy(TaskProxy)
	local var1_9 = getProxy(ActivityProxy):getActivityById(arg0_9.contextData.activityID):getConfig("config_client").taskActivityID
	local var2_9 = getProxy(ActivityProxy):getActivityById(var1_9)
	local var3_9 = pg.activity_template[var1_9].config_data
	local var4_9 = {}
	local var5_9 = getProxy(TaskProxy)

	for iter0_9, iter1_9 in ipairs(var3_9) do
		table.insert(var4_9, var5_9:getTaskVO(iter1_9))
	end

	return var4_9
end

function var0_0.RefreshUI(arg0_10)
	arg0_10.taskList = arg0_10:GetTaskList()

	arg0_10:Sort(arg0_10.taskList)
	arg0_10.uiLScroll:SetTotalCount(#arg0_10.taskList)
end

function var0_0.OnInitItem(arg0_11, arg1_11)
	arg0_11.itemList[arg1_11] = LiquorFloorTaskItem.New(tf(arg1_11), arg0_11)
end

function var0_0.OnUpdateItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.itemList[arg2_12]

	if var0_12 == nil then
		arg0_12:OnInitItem(arg2_12)

		var0_12 = arg0_12.itemList[arg2_12]
	end

	local var1_12 = arg0_12.taskList[arg1_12 + 1]

	var0_12:SetData(var1_12)
end

function var0_0.Sort(arg0_13)
	local function var0_13(arg0_14, arg1_14, arg2_14)
		local function var0_14(arg0_15)
			for iter0_15, iter1_15 in ipairs(arg2_14) do
				if arg0_15 == iter1_15 then
					return iter0_15
				end
			end
		end

		return var0_14(arg0_14) < var0_14(arg1_14)
	end

	table.sort(arg0_13.taskList, function(arg0_16, arg1_16)
		local var0_16 = arg0_16:getTaskStatus()
		local var1_16 = arg1_16:getTaskStatus()

		if var0_16 == var1_16 then
			return arg0_16.id < arg1_16.id
		end

		return var0_13(var0_16, var1_16, {
			1,
			0,
			2,
			-1
		})
	end)
end

return var0_0
