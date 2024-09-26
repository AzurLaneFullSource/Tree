local var0_0 = class("Dorm3dCollectionLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dCollectionUI"
end

function var0_0.SetApartment(arg0_2, arg1_2)
	arg0_2.contextData.apartment = arg1_2
end

function var0_0.SetRoom(arg0_3, arg1_3)
	arg0_3.room = getProxy(ApartmentProxy):getRoom(arg1_3)
end

function var0_0.init(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		arg0_4:closeView()
	end, SFX_PANEL)

	local var0_4 = arg0_4._tf:Find("window")

	eachChild(var0_4:Find("toggles"), function(arg0_6)
		onToggle(arg0_4, arg0_6, function(arg0_7)
			if arg0_7 then
				arg0_4:SetPage(arg0_6.name)
			end
		end, SFX_PANEL)
	end)

	local var1_4 = var0_4:Find("content")

	arg0_4.memoryView = Dorm3dMemorySubView.New(nil, arg0_4.event, arg0_4.contextData)

	arg0_4.memoryView:SetExtra(var1_4:Find("memory"))

	arg0_4.collectItemView = Dorm3dCollectionItemSubView.New(nil, arg0_4.event, arg0_4.contextData)

	arg0_4.collectItemView:SetExtra(var1_4:Find("item"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.SetPage(arg0_8, arg1_8)
	for iter0_8, iter1_8 in pairs({
		memory = arg0_8.memoryView,
		item = arg0_8.collectItemView
	}) do
		if iter0_8 == arg1_8 then
			iter1_8:ExecuteAction("Show")
		elseif iter1_8:isShowing() then
			iter1_8:Hide()
		end
	end
end

function var0_0.didEnter(arg0_9)
	if arg0_9.room:isPersonalRoom() then
		triggerToggle(arg0_9._tf:Find("window/toggles/memory"), true)
	else
		triggerToggle(arg0_9._tf:Find("window/toggles/item"), true)
		setActive(arg0_9._tf:Find("window/toggles/memory"), false)
	end
end

function var0_0.onBackPressed(arg0_10)
	var0_0.super.onBackPressed(arg0_10)
end

function var0_0.willExit(arg0_11)
	arg0_11.memoryView:Destroy()
	arg0_11.collectItemView:Destroy()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf)
end

return var0_0
