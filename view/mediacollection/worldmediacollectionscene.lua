local var0 = class("WorldMediaCollectionScene", require("view.base.BaseUI"))

var0.PAGE_MEMORTY = 1
var0.PAGE_FILE = 2
var0.PAGE_RECORD = 3

function var0.getUIName(arg0)
	return "WorldMediaCollectionUI"
end

function var0.getBGM(arg0)
	local var0 = arg0.contextData.revertBgm

	arg0.contextData.revertBgm = nil

	if var0 then
		return var0
	else
		return var0.super.getBGM(arg0)
	end
end

function var0.init(arg0)
	arg0.top = arg0._tf:Find("Top")
	arg0.viewContainer = arg0._tf:Find("Main")
	arg0.subViews = {}
end

local var1 = {
	import(".WorldMediaCollectionMemoryLayer"),
	import(".WorldMediaCollectionRecordLayer"),
	import(".WorldMediaCollectionFileLayer")
}

function var0.GetCurrentPage(arg0)
	return arg0.contextData.page and arg0.subViews[arg0.contextData.page]
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})
	onButton(arg0, arg0.top:Find("blur_panel/adapt/top/option"), function()
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0.top:Find("blur_panel/adapt/top/back_btn"), function()
		arg0:Backward()
	end, SFX_UI_CANCEL)

	local var0 = arg0.contextData.page or var0.PAGE_MEMORTY

	arg0.contextData.page = nil

	arg0:EnterPage(var0)
	arg0:UpdateView()
end

function var0.EnterPage(arg0, arg1)
	local var0 = arg1 == arg0.contextData.page
	local var1 = arg0.subViews[arg1]

	if not var1 then
		local var2 = var1[arg1]

		if not var2 then
			return
		end

		arg0.contextData[var2] = arg0.contextData[var2] or {}
		var1 = var2.New(arg0, arg0.viewContainer, arg0.event, arg0.contextData)

		var1:Load()
	end

	if arg0.contextData.page and arg0.subViews[arg0.contextData.page] and not var0 then
		arg0.subViews[arg0.contextData.page].buffer:OnDeselected()
	end

	arg0.contextData.page = arg1
	arg0.subViews[arg1] = var1

	if not var0 then
		var1.buffer:OnSelected()
	else
		var1.buffer:OnReselected()
	end
end

function var0.Backward(arg0)
	local var0 = arg0.subViews[arg0.contextData.page]
	local var1 = var0 and var0:OnBackward()

	if var1 then
		return var1
	end

	arg0:closeView()
end

function var0.onBackPressed(arg0)
	arg0:Backward()
end

function var0.Add2LayerContainer(arg0, arg1)
	setParent(arg1, arg0.viewContainer)
end

function var0.Add2TopContainer(arg0, arg1)
	setParent(arg1, arg0.top)
end

function var0.WorldRecordLock()
	local function var0()
		local var0 = getProxy(PlayerProxy):getRawData().level

		return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0, "WorldMediaCollectionRecordMediator")
	end

	return LOCK_WORLD_COLLECTION or not var0()
end

function var0.UpdateView(arg0)
	local var0 = arg0.subViews[arg0.contextData.page]

	if not var0 then
		return
	end

	var0.buffer:UpdateView()
end

function var0.willExit(arg0)
	local var0 = arg0:GetCurrentPage()

	if var0 then
		var0.buffer:Hide()
	end

	for iter0, iter1 in pairs(arg0.subViews) do
		iter1:Destroy()
	end

	table.clear(arg0.subViews)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)
end

return var0
