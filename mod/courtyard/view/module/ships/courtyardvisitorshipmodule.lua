local var0 = class("CourtYardVisitorShipModule", import(".CourtYardShipModule"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.nameTF = arg0._tf:Find("name")

	setText(arg0.nameTF, arg0.data:GetName())
end

function var0.InitAttachment(arg0)
	return
end

function var0.OnBeginDrag(arg0)
	return
end

function var0.OnDragging(arg0, arg1)
	return
end

function var0.OnDragEnd(arg0, arg1)
	return
end

function var0.OnInimacyChange(arg0, arg1)
	return
end

function var0.OnCoinChange(arg0, arg1)
	return
end

return var0
