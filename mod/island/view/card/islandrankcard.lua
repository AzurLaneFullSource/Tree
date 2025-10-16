local var0_0 = class("IslandRankCard")

var0_0.TYPE_SELF = 1
var0_0.TYPE_OTHER = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._type = arg2_1
	arg0_1.parent = arg3_1
	arg0_1.bgTF = arg0_1._tf:Find("bg")
	arg0_1.rankText = arg0_1._tf:Find("rank"):GetComponent(typeof(Text))
	arg0_1.notOnTF = arg0_1._tf:Find("not_on")
	arg0_1.iconTF = arg0_1._tf:Find("icon_bg/icon")
	arg0_1.nameText = arg0_1._tf:Find("name"):GetComponent(typeof(Text))
	arg0_1.levelText = arg0_1._tf:Find("level"):GetComponent(typeof(Text))
	arg0_1.ptText = arg0_1._tf:Find("pt"):GetComponent(typeof(Text))

	setText(arg0_1._tf:Find("island"), i18n("island_season_charts_level"))

	arg0_1.awardsTF = arg0_1._tf:Find("awards")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.rankVO = arg1_2
	arg0_2.rankText.text = arg1_2.rank > 9 and arg1_2.rank or "0" .. arg1_2.rank
	arg0_2.nameText.text = arg1_2.name
	arg0_2.levelText.text = "Lv." .. arg1_2.arenaRank
	arg0_2.ptText.text = arg1_2.power

	local var0_2 = arg1_2.rank < 4 and arg1_2.rank or 0

	GetImageSpriteFromAtlasAsync("ui/islandseasonrankui_atlas", "bg" .. var0_2, arg0_2.bgTF)

	local var1_2 = arg0_2._type ~= var0_0.TYPE_SELF or arg1_2.rank > 0

	setActive(arg0_2.rankText, var1_2 and arg1_2.rank > 3)
	setActive(arg0_2.notOnTF, not var1_2)

	local var2_2 = "qicon/" .. pg.ship_skin_template[arg1_2.skinId].prefab

	GetImageSpriteFromAtlasAsync(var2_2, "", arg0_2.iconTF)

	local var3_2 = IslandSeason.GetAwardsByRank(arg2_2, arg1_2.rank)

	UIItemList.StaticAlign(arg0_2.awardsTF, arg0_2.awardsTF:Find("tpl"), #var3_2, function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			updateCustomDrop(arg2_3, var3_2[arg1_3 + 1])
			onButton(arg0_2.parent, arg2_3, function()
				arg0_2.parent.contextData:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var3_2[arg1_3 + 1]
				})
			end)
		end
	end)
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
