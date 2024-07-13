local var0_0 = class("CourtYardOutStoreyModule", import(".CourtYardStoreyModule"))
local var1_0 = true

function var0_0.OnInit(arg0_1)
	arg0_1.scrollrect = arg0_1._tf:Find("scrollRect")
	arg0_1.scroll = arg0_1.scrollrect:GetComponent(typeof(ScrollRect))
	arg0_1.rectTF = arg0_1._tf:Find("scrollRect/bg/rect")
	arg0_1.gridsTF = arg0_1.rectTF:Find("grids")
	arg0_1.rootTF = arg0_1._tf:Find("root")
	arg0_1.selectedTF = arg0_1._tf:Find("root/drag")
	arg0_1.rotationBtn = arg0_1.selectedTF:Find("panel/rotation")
	arg0_1.removeBtn = arg0_1.selectedTF:Find("panel/cancel")
	arg0_1.confirmBtn = arg0_1.selectedTF:Find("panel/ok")
	arg0_1.dragBtn = CourtYardStoreyDragBtn.New(arg0_1.selectedTF:Find("panel/animroot"), arg0_1.rectTF)
end

function var0_0.EnableZoom(arg0_2, arg1_2)
	arg0_2.scroll.enabled = arg1_2
end

return var0_0
