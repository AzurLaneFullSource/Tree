local var0_0 = class("MallSiteBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MallSiteBox"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.uiCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)

	local var0_5 = pg.activity_mall_story[arg1_5]

	setText(arg0_5.uiNameText, var0_5.name)
	setText(arg0_5.uiDescText, var0_5.desc)
	setImageSprite(arg0_5.uiIconImage, LoadSprite("ui/mallstorylineui_atlas", var0_5.icon .. "_l"), true)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
