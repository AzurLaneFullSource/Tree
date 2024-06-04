local var0 = class("GuildBossRankPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "GuildBossRankPage"
end

local function var1(arg0)
	return {
		numer = arg0.transform:Find("numer"):GetComponent(typeof(Text)),
		name = arg0.transform:Find("name"):GetComponent(typeof(Text)),
		damage = arg0.transform:Find("damage"):GetComponent(typeof(Text)),
		Update = function(arg0, arg1, arg2)
			arg0.numer.text = arg1
			arg0.name.text = arg2.name
			arg0.damage.text = arg2.damage
		end
	}
end

function var0.OnLoaded(arg0)
	arg0.scrollrect = arg0:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	arg0.closeBtn = arg0:findTF("frame/close")

	setText(arg0:findTF("frame/titles/num"), i18n("guild_damage_ranking"))
	setText(arg0:findTF("frame/titles/member"), i18n("guild_word_member"))
	setText(arg0:findTF("frame/titles/damage"), i18n("guild_total_damage"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	arg0.cards = {}
end

function var0.OnInitItem(arg0, arg1)
	local var0 = var1(arg1)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]
	local var1 = arg0.ranks[arg1 + 1]

	var0:Update(arg1 + 1, var1)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.ranks = arg1

	arg0.scrollrect:SetTotalCount(#arg1)
end

function var0.OnDestroy(arg0)
	return
end

return var0
