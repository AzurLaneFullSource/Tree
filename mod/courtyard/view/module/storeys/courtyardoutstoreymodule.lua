local var0 = class("CourtYardOutStoreyModule", import(".CourtYardStoreyModule"))
local var1 = true

function var0.OnInit(arg0)
	arg0.scrollrect = arg0._tf:Find("scrollRect")
	arg0.scroll = arg0.scrollrect:GetComponent(typeof(ScrollRect))
	arg0.rectTF = arg0._tf:Find("scrollRect/bg/rect")
	arg0.gridsTF = arg0.rectTF:Find("grids")
	arg0.rootTF = arg0._tf:Find("root")
	arg0.selectedTF = arg0._tf:Find("root/drag")
	arg0.rotationBtn = arg0.selectedTF:Find("panel/rotation")
	arg0.removeBtn = arg0.selectedTF:Find("panel/cancel")
	arg0.confirmBtn = arg0.selectedTF:Find("panel/ok")
	arg0.dragBtn = CourtYardStoreyDragBtn.New(arg0.selectedTF:Find("panel/animroot"), arg0.rectTF)
end

function var0.EnableZoom(arg0, arg1)
	arg0.scroll.enabled = arg1
end

return var0
