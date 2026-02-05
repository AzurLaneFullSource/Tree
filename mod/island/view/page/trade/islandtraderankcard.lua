local var0_0 = class("IslandTradeRankCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1.transform
	arg0_1.mainTr = arg0_1._tf:Find("main")
	arg0_1.iconTF = arg0_1.mainTr:Find("icon_bg/icon")
	arg0_1.nameTxt = arg0_1.mainTr:Find("name"):GetComponent(typeof(Text))
	arg0_1.lvTxt = arg0_1.mainTr:Find("level"):GetComponent(typeof(Text))
	arg0_1.numImg = arg0_1.mainTr:Find("num")
	arg0_1.numTxt = arg0_1.mainTr:Find("num_text"):GetComponent(typeof(Text))
	arg0_1.valueTxt = arg0_1.mainTr:Find("price/Text"):GetComponent(typeof(Text))
	arg0_1.visitBtn = arg0_1.mainTr:Find("visit")
	arg0_1.inviteBtn = arg0_1.mainTr:Find("invite")

	setText(arg0_1.mainTr:Find("island"), i18n("island_trade_rank_level_label"))

	arg0_1.cg = GetOrAddComponent(arg0_1.mainTr, typeof(CanvasGroup))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.id = arg2_2.id

	if arg1_2 <= 3 then
		GetImageSpriteFromAtlasAsync("ui/islandseasonrankui_atlas", "rank-0" .. arg1_2, arg0_2.numImg)
		GetImageSpriteFromAtlasAsync("ui/islandseasonrankui_atlas", "rank-0" .. arg1_2 .. "bg", arg0_2.mainTr)
	else
		GetImageSpriteFromAtlasAsync("ui/islandseasonrankui_atlas", "rank04bg", arg0_2.mainTr)
	end

	arg0_2.valueTxt.text = arg2_2.value > 0 and arg2_2.value or "-"
	arg0_2.numTxt.text = arg1_2 < 10 and "0" .. arg1_2 or arg1_2
	arg0_2.nameTxt.text = arg2_2.name
	arg0_2.lvTxt.text = "lv." .. arg2_2.islandLevel

	local var0_2 = "qicon/" .. pg.ship_skin_template[arg2_2.skinId].prefab

	GetImageSpriteFromAtlasAsync(var0_2, "", arg0_2.iconTF)

	local var1_2 = arg2_2:IsSelf()

	setActive(arg0_2.visitBtn, not var1_2)
	setActive(arg0_2.inviteBtn, var1_2)
	setActive(arg0_2.numTxt.gameObject, arg1_2 > 3)
	setActive(arg0_2.numImg, arg1_2 <= 3)
end

function var0_0.CancelAnimation(arg0_3)
	if arg0_3.timer then
		arg0_3.timer:Stop()

		arg0_3.timer = nil
	end
end

function var0_0.PlayAnimation(arg0_4)
	return
end

function var0_0.Dispose(arg0_5)
	arg0_5:CancelAnimation()
end

return var0_0
