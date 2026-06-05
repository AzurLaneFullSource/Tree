local var0_0 = class("IslandShipDressDescBox", import("view.base.BaseSubView"))

var0_0.TYPE = {
	SKIN = 2,
	DRESS = 1
}
var0_0.DRESS_TGA_TWINS = 1
var0_0.DRESS_TAG_SP_ANIMATOR = 2
var0_0.TAG2NAME = {
	[var0_0.DRESS_TGA_TWINS] = i18n("island_dress_tag_twins"),
	[var0_0.DRESS_TAG_SP_ANIMATOR] = i18n("island_dress_tag_sp_animator")
}

function var0_0.getUIName(arg0_1)
	return "IslandShipDressDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.tagUIList = UIItemList.New(arg0_2.uiTagsTF, arg0_2.uiTagsTF:Find("tpl"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.tagUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.tagList[arg1_4 + 1]

			setScrollText(arg2_4:Find("mask/Text"), var0_0.TAG2NAME[var0_4])
		end
	end)
end

function var0_0.Show(arg0_5, arg1_5, arg2_5, arg3_5)
	setAnchoredPosition(arg0_5.uiPanelTF, arg3_5)

	arg0_5.type = arg1_5
	arg0_5.id = arg2_5
	arg0_5.cfg = arg0_5.type == var0_0.TYPE.DRESS and pg.island_dress_template[arg2_5] or pg.island_skin_template[arg2_5]

	setText(arg0_5.uiNameText, arg0_5.cfg.name)
	setText(arg0_5.uiDescText, arg0_5.cfg.desc)

	arg0_5.tagList = {}

	if arg0_5.cfg.tag and type(arg0_5.cfg.tag) == "table" then
		for iter0_5, iter1_5 in ipairs(arg0_5.cfg.tag) do
			table.insert(arg0_5.tagList, iter1_5)
		end
	end

	setActive(arg0_5.uiTagsTF, #arg0_5.tagList > 0)
	arg0_5.tagUIList:align(#arg0_5.tagList)
	arg0_5.super.Show(arg0_5)
end

return var0_0
