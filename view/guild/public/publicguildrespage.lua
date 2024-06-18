local var0_0 = class("PublicGuildResPage", import("..subPages.main.GuildResPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = "blue"

	arg0_1.contributionBg.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "res_" .. var0_1)
	arg0_1.captailBg.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "res_" .. var0_1)

	setActive(arg0_1.captailBg.gameObject, false)
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.resContributionTxt.text = arg1_2:getResource(8)
end

return var0_0
