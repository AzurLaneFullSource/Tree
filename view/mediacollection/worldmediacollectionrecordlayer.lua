local var0_0 = class("WorldMediaCollectionRecordLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionRecordUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2._top = arg0_2:findTF("Top")
	arg0_2.memoryMask = arg0_2:findTF("StoryMask", arg0_2._top)
end

function var0_0.OnSelected(arg0_3)
	var0_0.super.OnSelected(arg0_3)

	if arg0_3.contextData.recordGroup then
		arg0_3:ShowRecordGroup(arg0_3.contextData.recordGroup)
	else
		arg0_3:OpenGroupLayer()
	end
end

function var0_0.Backward(arg0_4)
	if not arg0_4.contextData.recordGroup then
		return
	end

	arg0_4.contextData.recordGroup = nil

	arg0_4:OpenGroupLayer()

	return true
end

function var0_0.OnBackward(arg0_5)
	return arg0_5:Backward()
end

function var0_0.OnReselected(arg0_6)
	arg0_6:Backward()
end

function var0_0.OnDeselected(arg0_7)
	arg0_7.contextData.recordGroup = nil

	var0_0.super.OnDeselected(arg0_7)
end

function var0_0.Hide(arg0_8)
	arg0_8:HideDetailLayer()
	arg0_8:HideGroupLayer()
	var0_0.super.Hide(arg0_8)
end

function var0_0.GetDetailLayer(arg0_9)
	if not arg0_9.detailUI then
		arg0_9.detailUI = WorldMediaCollectionRecordDetailLayer.New(arg0_9, arg0_9._tf, arg0_9.event, arg0_9.contextData)

		arg0_9.detailUI:Load()
		arg0_9.detailUI:SetStoryMask(arg0_9.memoryMask)
	end

	return arg0_9.detailUI
end

function var0_0.ShowRecordGroup(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetDetailLayer()

	var0_10.buffer:Show()
	var0_10.buffer:ShowRecordGroup(arg1_10)
	arg0_10:HideGroupLayer()
end

function var0_0.HideDetailLayer(arg0_11)
	if not arg0_11.detailUI then
		return
	end

	arg0_11.detailUI.buffer:Hide()
end

function var0_0.CloseDetailLayer(arg0_12)
	if arg0_12.detailUI then
		arg0_12.detailUI:Destroy()

		arg0_12.detailUI = nil
	end
end

function var0_0.OpenGroupLayer(arg0_13)
	local var0_13 = arg0_13:GetGroupLayer()

	var0_13.buffer:Show()
	var0_13.buffer:RecordFilter()
	arg0_13:HideDetailLayer()
end

function var0_0.GetGroupLayer(arg0_14)
	if not arg0_14.groupUI then
		arg0_14.groupUI = WorldMediaCollectionRecordGroupLayer.New(arg0_14, arg0_14._tf, arg0_14.event, arg0_14.contextData)

		arg0_14.groupUI:Load()
	end

	return arg0_14.groupUI
end

function var0_0.HideGroupLayer(arg0_15)
	if not arg0_15.groupUI then
		return
	end

	arg0_15.groupUI.buffer:Hide()
end

function var0_0.CloseGroupLayer(arg0_16)
	if arg0_16.groupUI then
		arg0_16.groupUI:Destroy()

		arg0_16.groupUI = nil
	end
end

function var0_0.OnDestroy(arg0_17)
	arg0_17:CloseDetailLayer()
	arg0_17:CloseGroupLayer()
	var0_0.super.OnDestroy(arg0_17)
end

return var0_0
