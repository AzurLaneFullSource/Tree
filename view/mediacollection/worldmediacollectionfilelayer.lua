local var0_0 = class("WorldMediaCollectionFileLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionFileUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2._top = arg0_2:findTF("Top")
end

function var0_0.GetDetailLayer(arg0_3)
	if not arg0_3.detailLayer then
		arg0_3.detailLayer = WorldMediaCollectionFileDetailLayer.New(arg0_3, arg0_3._tf, arg0_3.event, arg0_3.contextData)

		arg0_3.detailLayer:Load()
	end

	return arg0_3.detailLayer
end

function var0_0.OpenDetailLayer(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4:GetDetailLayer()

	arg0_4.contextData.FileGroupIndex = arg1_4

	var0_4.buffer:Show()

	if arg2_4 then
		var0_4.buffer:Openning()
	else
		var0_4.buffer:Enter()
	end

	arg0_4:HideGroupLayer()
end

function var0_0.HideDetailLayer(arg0_5)
	if not arg0_5.detailLayer then
		return
	end

	arg0_5.detailLayer.buffer:Hide()
end

function var0_0.CloseDetailLayer(arg0_6)
	if arg0_6.detailLayer then
		arg0_6.detailLayer:Destroy()

		arg0_6.detailLayer = nil
	end
end

function var0_0.GetGroupLayer(arg0_7)
	if not arg0_7.groupLayer then
		arg0_7.groupLayer = WorldMediaCollectionFileGroupLayer.New(arg0_7, arg0_7._tf, arg0_7.event, arg0_7.contextData)

		arg0_7.groupLayer:Load()
	end

	return arg0_7.groupLayer
end

function var0_0.OpenGroupLayer(arg0_8)
	local var0_8 = arg0_8:GetGroupLayer()

	var0_8.buffer:Show()
	var0_8.buffer:UpdateGroupList()
	arg0_8:HideDetailLayer()
end

function var0_0.HideGroupLayer(arg0_9)
	if not arg0_9.groupLayer then
		return
	end

	arg0_9.groupLayer.buffer:Hide()
end

function var0_0.CloseGroupLayer(arg0_10)
	if arg0_10.groupLayer then
		arg0_10.groupLayer:Destroy()

		arg0_10.groupLayer = nil
	end
end

function var0_0.OnSelected(arg0_11)
	var0_0.super.OnSelected(arg0_11)

	if arg0_11.contextData.FileGroupIndex then
		arg0_11:OpenDetailLayer(arg0_11.contextData.FileGroupIndex)
	else
		arg0_11:OpenGroupLayer()
	end
end

function var0_0.OnReselected(arg0_12)
	var0_0.super.OnReselected(arg0_12)
	arg0_12:Backward()
end

function var0_0.OnDeselected(arg0_13)
	arg0_13.contextData.FileGroupIndex = nil
	arg0_13.contextData.SelectedFile = nil

	var0_0.super.OnDeselected(arg0_13)
end

function var0_0.Hide(arg0_14)
	arg0_14:HideDetailLayer()
	arg0_14:HideGroupLayer()
	var0_0.super.Hide(arg0_14)
end

function var0_0.Backward(arg0_15)
	if not arg0_15.contextData.FileGroupIndex then
		return
	end

	arg0_15.contextData.FileGroupIndex = nil
	arg0_15.contextData.SelectedFile = nil

	arg0_15:OpenGroupLayer()

	return true
end

function var0_0.OnBackward(arg0_16)
	return arg0_16:Backward()
end

function var0_0.OnDestroy(arg0_17)
	arg0_17:CloseDetailLayer()
	arg0_17:CloseGroupLayer()
	var0_0.super.OnDestroy(arg0_17)
end

return var0_0
