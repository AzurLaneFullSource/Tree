local var0_0 = class("NewEducateRankCard")

var0_0.TYPE_SELF = 1
var0_0.TYPE_OTHER = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._type = arg2_1
	arg0_1.parent = arg3_1
	arg0_1.bg1TF = arg0_1._tf:Find("1")
	arg0_1.bg2TF = arg0_1._tf:Find("2")
	arg0_1.bg3TF = arg0_1._tf:Find("3")
	arg0_1.rankText = arg0_1._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_1.notOnTF = arg0_1._tf:Find("not_on")

	setText(arg0_1.notOnTF, i18n("child2_rank_not_on"))

	arg0_1.iconTF = arg0_1._tf:Find("icon_bg/icon")
	arg0_1.callNameText = arg0_1._tf:Find("call_name"):GetComponent(typeof(Text))
	arg0_1.playerNameText = arg0_1._tf:Find("player_name/Text"):GetComponent(typeof(Text))
	arg0_1.valueText = arg0_1._tf:Find("value"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.rankVO = arg1_2

	local var0_2 = arg1_2.rank

	arg0_2.rankText.text = var0_2 > 9 and var0_2 or "0" .. var0_2

	local var1_2 = arg1_2.power

	if arg2_2 == PowerRank.TYPE_TB_ENDLESS_WAVE then
		var1_2 = math.max(0, var1_2 - getProxy(NewEducateProxy):GetCurChar():GetRoundData():GetGameRoundCnt())
	end

	arg0_2.valueText.text = var1_2

	local var2_2 = string.split(arg1_2.name, "|")

	arg0_2.callNameText.text = var2_2[2]
	arg0_2.playerNameText.text = var2_2[1]

	setActive(arg0_2.bg1TF, var0_2 == 1)
	setActive(arg0_2.bg2TF, var0_2 == 2)
	setActive(arg0_2.bg3TF, var0_2 == 3)

	local var3_2 = arg0_2._type ~= var0_0.TYPE_SELF or var0_2 > 0

	setActive(arg0_2.rankText, var3_2 and var0_2 > 3)
	setActive(arg0_2.notOnTF, not var3_2)

	local var4_2 = "qicon/" .. pg.ship_skin_template[arg1_2.skinId].prefab

	GetImageSpriteFromAtlasAsync(var4_2, "", arg0_2.iconTF)
end

function var0_0.Dispose(arg0_3)
	return
end

return var0_0
