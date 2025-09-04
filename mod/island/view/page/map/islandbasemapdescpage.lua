local var0_0 = class("IslandBaseMapDescPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandMapDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameTxt = arg0_2:findTF("frame/title/name/Text"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0_2.goBtn = arg0_2:findTF("frame/go")
	arg0_2.uiProductionList = UIItemList.New(arg0_2:findTF("frame/list"), arg0_2:findTF("frame/list/tpl"))
	arg0_2.iconTr = arg0_2:findTF("frame/icon")
	arg0_2.fullMark = arg0_2:findTF("frame/icon/tag")

	setText(arg0_2:findTF("frame/go/Text"), i18n("island_word_go"))

	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3.dftAniEvent:SetEndEvent(function()
			arg0_3.dftAniEvent:SetEndEvent(nil)
			arg0_3:Hide()
		end)
		arg0_3.animationPlayer:Play("IslandMapDescUI_out")
		arg0_3:emit(IslandBaseMapPage.HIDE_DESC)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_6, arg1_6)
	local var0_6 = pg.island_map[arg1_6]

	arg0_6.nameTxt.text = var0_6.name
	arg0_6.descTxt.text = var0_6.desc

	LoadImageSpriteAtlasAsync("island/IslandMapIcon/" .. arg1_6, "", arg0_6.iconTr)
	onButton(arg0_6, arg0_6.goBtn, function()
		arg0_6:GoMap(arg1_6)
	end, SFX_PANEL)
	setActive(arg0_6.fullMark, false)
end

function var0_0.GoMap(arg0_8, arg1_8)
	local var0_8 = pg.island_map[arg1_8]

	arg0_8:emit(IslandBaseMediator.SWITCH_MAP, arg1_8, var0_8.born_object)
	arg0_8:emit(IslandBaseMapPage.CLOSE)
end

return var0_0
