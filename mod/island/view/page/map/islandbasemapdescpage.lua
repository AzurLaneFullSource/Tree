local var0_0 = class("IslandBaseMapDescPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandMapDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameTxt = arg0_2._tf:Find("frame/title/name/Text"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2._tf:Find("frame/Text"):GetComponent(typeof(Text))
	arg0_2.goBtn = arg0_2._tf:Find("frame/go")
	arg0_2.uiProductionList = UIItemList.New(arg0_2._tf:Find("frame/scrollrect/list"), arg0_2._tf:Find("frame/scrollrect/list/tpl"))
	arg0_2.iconTr = arg0_2._tf:Find("frame/icon")
	arg0_2.fullMark = arg0_2._tf:Find("frame/icon/tag")

	setText(arg0_2._tf:Find("frame/go/Text"), i18n("island_word_go"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
		arg0_3:emit(IslandBaseMapPage.HIDE_DESC)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5, arg1_5)
	local var0_5 = pg.island_map[arg1_5]

	arg0_5.nameTxt.text = var0_5.name
	arg0_5.descTxt.text = var0_5.desc

	LoadImageSpriteAtlasAsync("island/IslandMapIcon/" .. arg1_5, "", arg0_5.iconTr)
	onButton(arg0_5, arg0_5.goBtn, function()
		arg0_5:GoMap(arg1_5)
	end, SFX_PANEL)
	setActive(arg0_5.fullMark, false)
end

function var0_0.GoMap(arg0_7, arg1_7)
	local var0_7 = pg.island_map[arg1_7]

	arg0_7:emitCoreController(ISLAND_EVT.SWITCH_MAP)
	arg0_7:emit(IslandBaseMediator.SWITCH_MAP, arg1_7, var0_7.born_object)
	arg0_7:emit(IslandBaseMapPage.CLOSE)
end

return var0_0
