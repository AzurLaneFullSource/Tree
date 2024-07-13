local var0_0 = class("WorldMediaCollectionScene", require("view.base.BaseUI"))

var0_0.PAGE_MEMORTY = 1
var0_0.PAGE_FILE = 2
var0_0.PAGE_RECORD = 3

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionUI"
end

function var0_0.getBGM(arg0_2)
	local var0_2 = arg0_2.contextData.revertBgm

	arg0_2.contextData.revertBgm = nil

	if var0_2 then
		return var0_2
	else
		return var0_0.super.getBGM(arg0_2)
	end
end

function var0_0.init(arg0_3)
	arg0_3.top = arg0_3._tf:Find("Top")
	arg0_3.viewContainer = arg0_3._tf:Find("Main")
	arg0_3.subViews = {}
end

local var1_0 = {
	import(".WorldMediaCollectionMemoryLayer"),
	import(".WorldMediaCollectionRecordLayer"),
	import(".WorldMediaCollectionFileLayer")
}

function var0_0.GetCurrentPage(arg0_4)
	return arg0_4.contextData.page and arg0_4.subViews[arg0_4.contextData.page]
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5.top, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})
	onButton(arg0_5, arg0_5.top:Find("blur_panel/adapt/top/option"), function()
		arg0_5:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.top:Find("blur_panel/adapt/top/back_btn"), function()
		arg0_5:Backward()
	end, SFX_UI_CANCEL)

	local var0_5 = arg0_5.contextData.page or var0_0.PAGE_MEMORTY

	arg0_5.contextData.page = nil

	arg0_5:EnterPage(var0_5)
	arg0_5:UpdateView()
end

function var0_0.EnterPage(arg0_8, arg1_8)
	local var0_8 = arg1_8 == arg0_8.contextData.page
	local var1_8 = arg0_8.subViews[arg1_8]

	if not var1_8 then
		local var2_8 = var1_0[arg1_8]

		if not var2_8 then
			return
		end

		arg0_8.contextData[var2_8] = arg0_8.contextData[var2_8] or {}
		var1_8 = var2_8.New(arg0_8, arg0_8.viewContainer, arg0_8.event, arg0_8.contextData)

		var1_8:Load()
	end

	if arg0_8.contextData.page and arg0_8.subViews[arg0_8.contextData.page] and not var0_8 then
		arg0_8.subViews[arg0_8.contextData.page].buffer:OnDeselected()
	end

	arg0_8.contextData.page = arg1_8
	arg0_8.subViews[arg1_8] = var1_8

	if not var0_8 then
		var1_8.buffer:OnSelected()
	else
		var1_8.buffer:OnReselected()
	end
end

function var0_0.Backward(arg0_9)
	local var0_9 = arg0_9.subViews[arg0_9.contextData.page]
	local var1_9 = var0_9 and var0_9:OnBackward()

	if var1_9 then
		return var1_9
	end

	arg0_9:closeView()
end

function var0_0.onBackPressed(arg0_10)
	arg0_10:Backward()
end

function var0_0.Add2LayerContainer(arg0_11, arg1_11)
	setParent(arg1_11, arg0_11.viewContainer)
end

function var0_0.Add2TopContainer(arg0_12, arg1_12)
	setParent(arg1_12, arg0_12.top)
end

function var0_0.WorldRecordLock()
	local function var0_13()
		local var0_14 = getProxy(PlayerProxy):getRawData().level

		return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_14, "WorldMediaCollectionRecordMediator")
	end

	return LOCK_WORLD_COLLECTION or not var0_13()
end

function var0_0.UpdateView(arg0_15)
	local var0_15 = arg0_15.subViews[arg0_15.contextData.page]

	if not var0_15 then
		return
	end

	var0_15.buffer:UpdateView()
end

function var0_0.willExit(arg0_16)
	local var0_16 = arg0_16:GetCurrentPage()

	if var0_16 then
		var0_16.buffer:Hide()
	end

	for iter0_16, iter1_16 in pairs(arg0_16.subViews) do
		iter1_16:Destroy()
	end

	table.clear(arg0_16.subViews)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_16.top, arg0_16._tf)
end

return var0_0
