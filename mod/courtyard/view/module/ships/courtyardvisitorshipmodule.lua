local var0_0 = class("CourtYardVisitorShipModule", import(".CourtYardShipModule"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.nameTF = arg0_1._tf:Find("name")

	setText(arg0_1.nameTF, arg0_1.data:GetName())
end

function var0_0.InitAttachment(arg0_2)
	return
end

function var0_0.OnBeginDrag(arg0_3)
	return
end

function var0_0.OnDragging(arg0_4, arg1_4)
	return
end

function var0_0.OnDragEnd(arg0_5, arg1_5)
	return
end

function var0_0.OnInimacyChange(arg0_6, arg1_6)
	return
end

function var0_0.OnCoinChange(arg0_7, arg1_7)
	return
end

return var0_0
