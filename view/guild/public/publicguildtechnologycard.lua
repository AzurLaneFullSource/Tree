local var0_0 = class("PublicGuildTechnologyCard", import("..cards.GuildTechnologyCard"))

function var0_0.Update(arg0_1, arg1_1)
	local var0_1 = arg1_1.group.id
	local var1_1 = arg1_1.group
	local var2_1 = arg1_1:getConfig("name")

	arg0_1.titleImg.text = var2_1
	arg0_1.iconImag.sprite = GetSpriteFromAtlas("GuildTechnology", var0_1)

	local var3_1 = arg1_1:GetMaxLevel()
	local var4_1 = arg1_1:GetLevel()

	if arg1_1:IsGuildMember() then
		arg0_1.levelTxt.text = "Lv." .. var4_1
	else
		arg0_1.levelTxt.text = "Lv." .. var4_1 .. "/" .. var3_1
	end

	arg0_1.descTxt.text = arg1_1:GetDesc()

	setActive(arg0_1.maxTF, var3_1 <= var4_1)
	setActive(arg0_1.upgradeTF, var4_1 < var3_1)

	local var5_1 = true

	removeOnButton(arg0_1._tf)

	if var4_1 < var3_1 then
		local var6_1, var7_1 = arg1_1:GetConsume()

		arg0_1.guildResTxt.text = var6_1
		arg0_1.goldResTxt.text = var7_1

		onButton(arg0_1, arg0_1._tf, function()
			if var4_1 >= var3_1 then
				return
			end

			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = i18n("guild_tech_consume_tip", var6_1, var7_1, var2_1),
				onYes = function()
					arg0_1.view:emit(PublicGuildMainMediator.UPGRADE_TECH, var0_1)
				end
			})
		end, SFX_PANEL)
	end

	setActive(arg0_1.guildRes, var5_1)
	setActive(arg0_1.goldRes, var5_1)
	setActive(arg0_1.upgradeBtn, var5_1)
	setActive(arg0_1.livnessTF, not var5_1)

	local var8_1 = true

	setActive(arg0_1.breakoutSlider.gameObject, var8_1)

	if var8_1 then
		local var9_1 = var1_1:GetTargetProgress()
		local var10_1 = var1_1:GetProgress()

		arg0_1.breakoutSlider.value = var10_1 / var9_1
		arg0_1.breakoutTxt.text = var10_1 .. "/" .. var9_1
	end
end

return var0_0
