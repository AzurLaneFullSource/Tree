local var0 = class("WorldMediaCollectionFileLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionFileUI"
end

function var0.OnInit(arg0)
	arg0._top = arg0:findTF("Top")
end

function var0.GetDetailLayer(arg0)
	if not arg0.detailLayer then
		arg0.detailLayer = WorldMediaCollectionFileDetailLayer.New(arg0, arg0._tf, arg0.event, arg0.contextData)

		arg0.detailLayer:Load()
	end

	return arg0.detailLayer
end

function var0.OpenDetailLayer(arg0, arg1, arg2)
	local var0 = arg0:GetDetailLayer()

	arg0.contextData.FileGroupIndex = arg1

	var0.buffer:Show()

	if arg2 then
		var0.buffer:Openning()
	else
		var0.buffer:Enter()
	end

	arg0:HideGroupLayer()
end

function var0.HideDetailLayer(arg0)
	if not arg0.detailLayer then
		return
	end

	arg0.detailLayer.buffer:Hide()
end

function var0.CloseDetailLayer(arg0)
	if arg0.detailLayer then
		arg0.detailLayer:Destroy()

		arg0.detailLayer = nil
	end
end

function var0.GetGroupLayer(arg0)
	if not arg0.groupLayer then
		arg0.groupLayer = WorldMediaCollectionFileGroupLayer.New(arg0, arg0._tf, arg0.event, arg0.contextData)

		arg0.groupLayer:Load()
	end

	return arg0.groupLayer
end

function var0.OpenGroupLayer(arg0)
	local var0 = arg0:GetGroupLayer()

	var0.buffer:Show()
	var0.buffer:UpdateGroupList()
	arg0:HideDetailLayer()
end

function var0.HideGroupLayer(arg0)
	if not arg0.groupLayer then
		return
	end

	arg0.groupLayer.buffer:Hide()
end

function var0.CloseGroupLayer(arg0)
	if arg0.groupLayer then
		arg0.groupLayer:Destroy()

		arg0.groupLayer = nil
	end
end

function var0.OnSelected(arg0)
	var0.super.OnSelected(arg0)

	if arg0.contextData.FileGroupIndex then
		arg0:OpenDetailLayer(arg0.contextData.FileGroupIndex)
	else
		arg0:OpenGroupLayer()
	end
end

function var0.OnReselected(arg0)
	var0.super.OnReselected(arg0)
	arg0:Backward()
end

function var0.OnDeselected(arg0)
	arg0.contextData.FileGroupIndex = nil
	arg0.contextData.SelectedFile = nil

	var0.super.OnDeselected(arg0)
end

function var0.Hide(arg0)
	arg0:HideDetailLayer()
	arg0:HideGroupLayer()
	var0.super.Hide(arg0)
end

function var0.Backward(arg0)
	if not arg0.contextData.FileGroupIndex then
		return
	end

	arg0.contextData.FileGroupIndex = nil
	arg0.contextData.SelectedFile = nil

	arg0:OpenGroupLayer()

	return true
end

function var0.OnBackward(arg0)
	return arg0:Backward()
end

function var0.OnDestroy(arg0)
	arg0:CloseDetailLayer()
	arg0:CloseGroupLayer()
	var0.super.OnDestroy(arg0)
end

return var0
