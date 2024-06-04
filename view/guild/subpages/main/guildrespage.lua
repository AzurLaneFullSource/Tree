local var0 = class("GuildResPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "GuildResPanel"
end

function var0.Load(arg0)
	if arg0._state ~= var0.STATES.NONE then
		return
	end

	arg0._state = var0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0 = LoadAndInstantiateSync("UI", arg0:getUIName(), true, false)

	arg0:Loaded(var0)
	arg0:Init()
end

function var0.OnLoaded(arg0)
	arg0.captailBg = arg0:findTF("captail"):GetComponent(typeof(Image))
	arg0.contributionBg = arg0:findTF("contribution"):GetComponent(typeof(Image))
	arg0.resCaptailTxt = arg0:findTF("captail/Text"):GetComponent(typeof(Text))
	arg0.resContributionTxt = arg0:findTF("contribution/Text"):GetComponent(typeof(Text))
	arg0.resourceLogBtn = arg0:findTF("captail/log")

	setActive(arg0._tf, true)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.resourceLogBtn, function()
		arg0:emit(GuildMainMediator.ON_FETCH_CAPITAL_LOG)
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1, arg2)
	arg0.resCaptailTxt.text = arg2:getCapital()
	arg0.resContributionTxt.text = arg1:getResource(8)

	local var0 = arg2:getFaction()

	if arg0.faction ~= var0 then
		local var1 = var0 == GuildConst.FACTION_TYPE_BLHX and "blue" or "red"

		arg0.contributionBg.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "res_" .. var1)
		arg0.captailBg.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "res_" .. var1)
		arg0.faction = var0
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
