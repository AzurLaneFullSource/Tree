local var0_0 = class("GuildTaskCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1._go = go(arg1_1)
	arg0_1.acceptBtn = arg0_1._tf:Find("accept")
	arg0_1.icon = arg0_1._tf:Find("icon"):GetComponent(typeof(Image))
	arg0_1.descTxt = arg0_1._tf:Find("desc/Text"):GetComponent(typeof(Text))
	arg0_1.publicResTxt = arg0_1._tf:Find("res_1/Text"):GetComponent(typeof(Text))
	arg0_1.privateResTxt = arg0_1._tf:Find("res_2/Text"):GetComponent(typeof(Text))
	arg0_1._tf:Find("res_1/label"):GetComponent(typeof(Text)).text = i18n("guild_public_awards")
	arg0_1._tf:Find("res_2/label"):GetComponent(typeof(Text)).text = i18n("guild_private_awards")
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.task = arg1_2
	arg0_2.icon.sprite = GetSpriteFromAtlas("ui/GuildMainUI_atlas", "frame_" .. arg1_2:GetScale())
	arg0_2.descTxt.text = arg1_2:GetDesc()
	arg0_2.publicResTxt.text = arg1_2:GetCaptailAward()
	arg0_2.privateResTxt.text = arg1_2:GetPrivateAward()
end

function var0_0.Destroy(arg0_3)
	return
end

return var0_0
