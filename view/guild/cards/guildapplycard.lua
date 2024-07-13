local var0_0 = class("GuildApplyCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = tf(arg1_1)
	arg0_1.nameTF = arg0_1.tf:Find("bg/name_bg/Text"):GetComponent(typeof(Text))
	arg0_1.lvTF = arg0_1.tf:Find("bg/level/Text"):GetComponent(typeof(Text))
	arg0_1.lvLabelTF = arg0_1.tf:Find("bg/level"):GetComponent(typeof(Text))
	arg0_1.countTF = arg0_1.tf:Find("bg/count/Text"):GetComponent(typeof(Text))
	arg0_1.applyBtn = arg0_1.tf:Find("bg/apply_btn")
	arg0_1.flagName = arg0_1.tf:Find("bg/info/name"):GetComponent(typeof(Text))
	arg0_1.flagLabel = arg0_1.tf:Find("bg/info/label1"):GetComponent(typeof(Text))
	arg0_1.policy = arg0_1.tf:Find("bg/info/policy"):GetComponent(typeof(Text))
	arg0_1.policyLabel = arg0_1.tf:Find("bg/info/label2"):GetComponent(typeof(Text))
	arg0_1.iconTF = arg0_1.tf:Find("bg/icon"):GetComponent(typeof(Image))
	arg0_1.nameBG = arg0_1.tf:Find("bg/name_bg"):GetComponent(typeof(Image))
	arg0_1.print = arg0_1.tf:Find("bg/print"):GetComponent(typeof(Image))
	arg0_1.bg = arg0_1.tf:Find("bg"):GetComponent(typeof(Image))
	arg0_1.applyBg = arg0_1.applyBtn:GetComponent(typeof(Image))
	arg0_1.colorRed = Color(0.752941176470588, 0.43921568627451, 0.462745098039216)
	arg0_1.colorBlue = Color(0.627450980392157, 0.705882352941177, 0.976470588235294)
end

function var0_0.Update(arg0_2, arg1_2)
	if not arg1_2 then
		return
	end

	local var0_2
	local var1_2 = arg1_2:getFaction()

	if var1_2 == GuildConst.FACTION_TYPE_BLHX then
		var0_2 = "blue"
	elseif var1_2 == GuildConst.FACTION_TYPE_CSZZ then
		var0_2 = "red"
	end

	arg0_2.bg.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "bar_" .. var0_2)
	arg0_2.applyBg.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "apply_" .. var0_2)
	arg0_2.iconTF.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "icon_" .. var0_2)
	arg0_2.nameBG.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "name_" .. var0_2)
	arg0_2.print.sprite = GetSpriteFromAtlas("ui/JoinGuildUI_atlas", "bar_bg_" .. var0_2)

	local var2_2 = var0_2 == "red" and arg0_2.colorRed or arg0_2.colorBlue

	arg0_2.lvTF.color = var2_2
	arg0_2.lvLabelTF.color = var2_2
	arg0_2.flagLabel.color = var2_2
	arg0_2.policyLabel.color = var2_2
	arg0_2.guildVO = arg1_2
	arg0_2.nameTF.text = arg1_2:getName()
	arg0_2.lvTF.text = arg1_2.level <= 9 and "0" .. arg1_2.level or arg1_2.level
	arg0_2.countTF.text = arg1_2.memberCount .. "/" .. arg1_2:getMaxMember()
	arg0_2.flagName.text = arg1_2:getCommader().name
	arg0_2.policy.text = arg1_2:getPolicyName()
end

function var0_0.Dispose(arg0_3)
	return
end

return var0_0
