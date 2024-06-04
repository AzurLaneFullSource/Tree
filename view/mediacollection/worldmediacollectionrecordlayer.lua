local var0 = class("WorldMediaCollectionRecordLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionRecordUI"
end

function var0.OnInit(arg0)
	arg0._top = arg0:findTF("Top")
	arg0.memoryMask = arg0:findTF("StoryMask", arg0._top)
end

function var0.OnSelected(arg0)
	var0.super.OnSelected(arg0)

	if arg0.contextData.recordGroup then
		arg0:ShowRecordGroup(arg0.contextData.recordGroup)
	else
		arg0:OpenGroupLayer()
	end
end

function var0.Backward(arg0)
	if not arg0.contextData.recordGroup then
		return
	end

	arg0.contextData.recordGroup = nil

	arg0:OpenGroupLayer()

	return true
end

function var0.OnBackward(arg0)
	return arg0:Backward()
end

function var0.OnReselected(arg0)
	arg0:Backward()
end

function var0.OnDeselected(arg0)
	arg0.contextData.recordGroup = nil

	var0.super.OnDeselected(arg0)
end

function var0.Hide(arg0)
	arg0:HideDetailLayer()
	arg0:HideGroupLayer()
	var0.super.Hide(arg0)
end

function var0.GetDetailLayer(arg0)
	if not arg0.detailUI then
		arg0.detailUI = WorldMediaCollectionRecordDetailLayer.New(arg0, arg0._tf, arg0.event, arg0.contextData)

		arg0.detailUI:Load()
		arg0.detailUI:SetStoryMask(arg0.memoryMask)
	end

	return arg0.detailUI
end

function var0.ShowRecordGroup(arg0, arg1)
	local var0 = arg0:GetDetailLayer()

	var0.buffer:Show()
	var0.buffer:ShowRecordGroup(arg1)
	arg0:HideGroupLayer()
end

function var0.HideDetailLayer(arg0)
	if not arg0.detailUI then
		return
	end

	arg0.detailUI.buffer:Hide()
end

function var0.CloseDetailLayer(arg0)
	if arg0.detailUI then
		arg0.detailUI:Destroy()

		arg0.detailUI = nil
	end
end

function var0.OpenGroupLayer(arg0)
	local var0 = arg0:GetGroupLayer()

	var0.buffer:Show()
	var0.buffer:RecordFilter()
	arg0:HideDetailLayer()
end

function var0.GetGroupLayer(arg0)
	if not arg0.groupUI then
		arg0.groupUI = WorldMediaCollectionRecordGroupLayer.New(arg0, arg0._tf, arg0.event, arg0.contextData)

		arg0.groupUI:Load()
	end

	return arg0.groupUI
end

function var0.HideGroupLayer(arg0)
	if not arg0.groupUI then
		return
	end

	arg0.groupUI.buffer:Hide()
end

function var0.CloseGroupLayer(arg0)
	if arg0.groupUI then
		arg0.groupUI:Destroy()

		arg0.groupUI = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:CloseDetailLayer()
	arg0:CloseGroupLayer()
	var0.super.OnDestroy(arg0)
end

return var0
