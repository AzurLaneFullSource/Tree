local var0 = class("GuildApplyCard")

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tf = tf(arg1)
	arg0.nameTF = arg0.tf:Find("bg/name_bg/Text"):GetComponent(typeof(Text))
	arg0.lvTF = arg0.tf:Find("bg/level/Text"):GetComponent(typeof(Text))
	arg0.lvLabelTF = arg0.tf:Find("bg/level"):GetComponent(typeof(Text))
	arg0.countTF = arg0.tf:Find("bg/count/Text"):GetComponent(typeof(Text))
	arg0.applyBtn = arg0.tf:Find("bg/apply_btn")
	arg0.flagName = arg0.tf:Find("bg/info/name"):GetComponent(typeof(Text))
	arg0.flagLabel = arg0.tf:Find("bg/info/label1"):GetComponent(typeof(Text))
	arg0.policy = arg0.tf:Find("bg/info/policy"):GetComponent(typeof(Text))
	arg0.policyLabel = arg0.tf:Find("bg/info/label2"):GetComponent(typeof(Text))
	arg0.iconTF = arg0.tf:Find("bg/icon"):GetComponent(typeof(Image))
	arg0.nameBG = arg0.tf:Find("bg/name_bg"):GetComponent(typeof(Image))
	arg0.print = arg0.tf:Find("bg/print"):GetComponent(typeof(Image))
	arg0.bg = arg0.tf:Find("bg"):GetComponent(typeof(Image))
	arg0.applyBg = arg0.applyBtn:GetComponent(typeof(Image))
	arg0.colorRed = Color(0.752941176470588, 0.43921568627451, 0.462745098039216)
	arg0.colorBlue = Color(0.627450980392157, 0.705882352941177, 0.976470588235294)
end

function var0.Update(arg0, arg1)
	if not arg1 then
		return
	end

	local var0
	local var1 = arg1:getFaction()

	if var1 == GuildConst.FACTION_TYPE_BLHX then
		var0 = "blue"
	elseif var1 == GuildConst.FACTION_TYPE_CSZZ then
		var0 = "red"
	end

	arg0.bg.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "bar_" .. var0)
	arg0.applyBg.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "apply_" .. var0)
	arg0.iconTF.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "icon_" .. var0)
	arg0.nameBG.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "name_" .. var0)
	arg0.print.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "bar_bg_" .. var0)

	local var2 = var0 == "red" and arg0.colorRed or arg0.colorBlue

	arg0.lvTF.color = var2
	arg0.lvLabelTF.color = var2
	arg0.flagLabel.color = var2
	arg0.policyLabel.color = var2
	arg0.guildVO = arg1
	arg0.nameTF.text = arg1:getName()
	arg0.lvTF.text = arg1.level <= 9 and "0" .. arg1.level or arg1.level
	arg0.countTF.text = arg1.memberCount .. "/" .. arg1:getMaxMember()
	arg0.flagName.text = arg1:getCommader().name
	arg0.policy.text = arg1:getPolicyName()
end

function var0.Dispose(arg0)
	return
end

return var0
