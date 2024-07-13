local var0_0 = class("GuildResPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildResPanel"
end

function var0_0.Load(arg0_2)
	if arg0_2._state ~= var0_0.STATES.NONE then
		return
	end

	arg0_2._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_2 = LoadAndInstantiateSync("UI", arg0_2:getUIName(), true, false)

	arg0_2:Loaded(var0_2)
	arg0_2:Init()
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.captailBg = arg0_3:findTF("captail"):GetComponent(typeof(Image))
	arg0_3.contributionBg = arg0_3:findTF("contribution"):GetComponent(typeof(Image))
	arg0_3.resCaptailTxt = arg0_3:findTF("captail/Text"):GetComponent(typeof(Text))
	arg0_3.resContributionTxt = arg0_3:findTF("contribution/Text"):GetComponent(typeof(Text))
	arg0_3.resourceLogBtn = arg0_3:findTF("captail/log")

	setActive(arg0_3._tf, true)
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.resourceLogBtn, function()
		arg0_4:emit(GuildMainMediator.ON_FETCH_CAPITAL_LOG)
	end, SFX_PANEL)
end

function var0_0.Update(arg0_6, arg1_6, arg2_6)
	arg0_6.resCaptailTxt.text = arg2_6:getCapital()
	arg0_6.resContributionTxt.text = arg1_6:getResource(8)

	local var0_6 = arg2_6:getFaction()

	if arg0_6.faction ~= var0_6 then
		local var1_6 = var0_6 == GuildConst.FACTION_TYPE_BLHX and "blue" or "red"

		arg0_6.contributionBg.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "res_" .. var1_6)
		arg0_6.captailBg.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "res_" .. var1_6)
		arg0_6.faction = var0_6
	end
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
