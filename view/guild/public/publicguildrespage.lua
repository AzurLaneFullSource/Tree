local var0 = class("PublicGuildResPage", import("..subPages.main.GuildResPage"))

function var0.OnInit(arg0)
	local var0 = "blue"

	arg0.contributionBg.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "res_" .. var0)
	arg0.captailBg.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "res_" .. var0)

	setActive(arg0.captailBg.gameObject, false)
end

function var0.Update(arg0, arg1)
	arg0.resContributionTxt.text = arg1:getResource(8)
end

return var0
