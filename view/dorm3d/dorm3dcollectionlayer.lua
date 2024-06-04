local var0 = class("Dorm3dCollectionLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dCollectionUI"
end

function var0.SetApartment(arg0, arg1)
	arg0.contextData.apartment = arg1
end

function var0.init(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SFX_PANEL)

	local var0 = arg0._tf:Find("window")

	eachChild(var0:Find("toggles"), function(arg0)
		onToggle(arg0, arg0, function(arg0)
			if arg0 then
				arg0:SetPage(arg0.name)
			end
		end, SFX_PANEL)
	end)

	local var1 = var0:Find("content")

	arg0.memoryView = Dorm3dMemorySubView.New(nil, arg0.event, arg0.contextData)

	arg0.memoryView:SetExtra(var1:Find("memory"))

	arg0.collectItemView = Dorm3dCollectionItemSubView.New(nil, arg0.event, arg0.contextData)

	arg0.collectItemView:SetExtra(var1:Find("item"))
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.SetPage(arg0, arg1)
	for iter0, iter1 in pairs({
		memory = arg0.memoryView,
		item = arg0.collectItemView
	}) do
		if iter0 == arg1 then
			iter1:ExecuteAction("Show")
		elseif iter1:isShowing() then
			iter1:Hide()
		end
	end
end

function var0.didEnter(arg0)
	triggerToggle(arg0._tf:Find("window/toggles/memory"), true)
end

function var0.onBackPressed(arg0)
	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	arg0.memoryView:Destroy()
	arg0.collectItemView:Destroy()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
