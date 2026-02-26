local var0_0 = class("IslandAutoCollectAwardDisplayWindow", import(".IslandAwardDisplayWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandAutoCollectAwardDisplayUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.textTF = arg0_2._tf:Find("frame/Board/Top/text/text")

	setActive(arg0_2.textTF, false)
end

return var0_0
