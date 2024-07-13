local var0_0 = class("GuildBossRankPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildBossRankPage"
end

local function var1_0(arg0_2)
	return {
		numer = arg0_2.transform:Find("numer"):GetComponent(typeof(Text)),
		name = arg0_2.transform:Find("name"):GetComponent(typeof(Text)),
		damage = arg0_2.transform:Find("damage"):GetComponent(typeof(Text)),
		Update = function(arg0_3, arg1_3, arg2_3)
			arg0_3.numer.text = arg1_3
			arg0_3.name.text = arg2_3.name
			arg0_3.damage.text = arg2_3.damage
		end
	}
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.scrollrect = arg0_4:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	arg0_4.closeBtn = arg0_4:findTF("frame/close")

	setText(arg0_4:findTF("frame/titles/num"), i18n("guild_damage_ranking"))
	setText(arg0_4:findTF("frame/titles/member"), i18n("guild_word_member"))
	setText(arg0_4:findTF("frame/titles/damage"), i18n("guild_total_damage"))
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)

	function arg0_5.scrollrect.onInitItem(arg0_8)
		arg0_5:OnInitItem(arg0_8)
	end

	function arg0_5.scrollrect.onUpdateItem(arg0_9, arg1_9)
		arg0_5:OnUpdateItem(arg0_9, arg1_9)
	end

	arg0_5.cards = {}
end

function var0_0.OnInitItem(arg0_10, arg1_10)
	local var0_10 = var1_0(arg1_10)

	arg0_10.cards[arg1_10] = var0_10
end

function var0_0.OnUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.cards[arg2_11]
	local var1_11 = arg0_11.ranks[arg1_11 + 1]

	var0_11:Update(arg1_11 + 1, var1_11)
end

function var0_0.Show(arg0_12, arg1_12)
	var0_0.super.Show(arg0_12)

	arg0_12.ranks = arg1_12

	arg0_12.scrollrect:SetTotalCount(#arg1_12)
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
