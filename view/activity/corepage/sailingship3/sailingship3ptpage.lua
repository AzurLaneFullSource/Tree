local var0_0 = class("SailingShip3PtPage", import("view.activity.CorePage.CorePageNewPtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	setText(arg0_1.get, i18n("word_got"))
end

function var0_0.OnShowFlush(arg0_2)
	setCanvasGroupAlpha(arg0_2._tf, 1)
end

return var0_0
