local var0_0 = class("Dorm3dCollectionLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dCollectionUI"
end

function var0_0.SetApartment(arg0_2, arg1_2)
	arg0_2.contextData.apartment = arg1_2
end

function var0_0.init(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:closeView()
	end, SFX_PANEL)

	local var0_3 = arg0_3._tf:Find("window")

	eachChild(var0_3:Find("toggles"), function(arg0_5)
		onToggle(arg0_3, arg0_5, function(arg0_6)
			if arg0_6 then
				arg0_3:SetPage(arg0_5.name)
			end
		end, SFX_PANEL)
	end)

	local var1_3 = var0_3:Find("content")

	arg0_3.memoryView = Dorm3dMemorySubView.New(nil, arg0_3.event, arg0_3.contextData)

	arg0_3.memoryView:SetExtra(var1_3:Find("memory"))

	arg0_3.collectItemView = Dorm3dCollectionItemSubView.New(nil, arg0_3.event, arg0_3.contextData)

	arg0_3.collectItemView:SetExtra(var1_3:Find("item"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.SetPage(arg0_7, arg1_7)
	for iter0_7, iter1_7 in pairs({
		memory = arg0_7.memoryView,
		item = arg0_7.collectItemView
	}) do
		if iter0_7 == arg1_7 then
			iter1_7:ExecuteAction("Show")
		elseif iter1_7:isShowing() then
			iter1_7:Hide()
		end
	end
end

function var0_0.didEnter(arg0_8)
	triggerToggle(arg0_8._tf:Find("window/toggles/memory"), true)
end

function var0_0.onBackPressed(arg0_9)
	var0_0.super.onBackPressed(arg0_9)
end

function var0_0.willExit(arg0_10)
	arg0_10.memoryView:Destroy()
	arg0_10.collectItemView:Destroy()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf)
end

return var0_0
