local var0 = class("GuildTaskCard")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0._go = go(arg1)
	arg0.acceptBtn = arg0._tf:Find("accept")
	arg0.icon = arg0._tf:Find("icon"):GetComponent(typeof(Image))
	arg0.descTxt = arg0._tf:Find("desc/Text"):GetComponent(typeof(Text))
	arg0.publicResTxt = arg0._tf:Find("res_1/Text"):GetComponent(typeof(Text))
	arg0.privateResTxt = arg0._tf:Find("res_2/Text"):GetComponent(typeof(Text))
	arg0._tf:Find("res_1/label"):GetComponent(typeof(Text)).text = i18n("guild_public_awards")
	arg0._tf:Find("res_2/label"):GetComponent(typeof(Text)).text = i18n("guild_private_awards")
end

function var0.Update(arg0, arg1)
	arg0.task = arg1
	arg0.icon.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "frame_" .. arg1:GetScale())
	arg0.descTxt.text = arg1:GetDesc()
	arg0.publicResTxt.text = arg1:GetCaptailAward()
	arg0.privateResTxt.text = arg1:GetPrivateAward()
end

function var0.Destroy(arg0)
	return
end

return var0
