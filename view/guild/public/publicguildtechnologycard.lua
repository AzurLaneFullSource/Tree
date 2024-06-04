local var0 = class("PublicGuildTechnologyCard", import("..cards.GuildTechnologyCard"))

function var0.Update(arg0, arg1)
	local var0 = arg1.group.id
	local var1 = arg1.group
	local var2 = arg1:getConfig("name")

	arg0.titleImg.text = var2
	arg0.iconImag.sprite = GetSpriteFromAtlas("GuildTechnology", var0)

	local var3 = arg1:GetMaxLevel()
	local var4 = arg1:GetLevel()

	if arg1:IsGuildMember() then
		arg0.levelTxt.text = "Lv." .. var4
	else
		arg0.levelTxt.text = "Lv." .. var4 .. "/" .. var3
	end

	arg0.descTxt.text = arg1:GetDesc()

	setActive(arg0.maxTF, var3 <= var4)
	setActive(arg0.upgradeTF, var4 < var3)

	local var5 = true

	removeOnButton(arg0._tf)

	if var4 < var3 then
		local var6, var7 = arg1:GetConsume()

		arg0.guildResTxt.text = var6
		arg0.goldResTxt.text = var7

		onButton(arg0, arg0._tf, function()
			if var4 >= var3 then
				return
			end

			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = i18n("guild_tech_consume_tip", var6, var7, var2),
				onYes = function()
					arg0.view:emit(PublicGuildMainMediator.UPGRADE_TECH, var0)
				end
			})
		end, SFX_PANEL)
	end

	setActive(arg0.guildRes, var5)
	setActive(arg0.goldRes, var5)
	setActive(arg0.upgradeBtn, var5)
	setActive(arg0.livnessTF, not var5)

	local var8 = true

	setActive(arg0.breakoutSlider.gameObject, var8)

	if var8 then
		local var9 = var1:GetTargetProgress()
		local var10 = var1:GetProgress()

		arg0.breakoutSlider.value = var10 / var9
		arg0.breakoutTxt.text = var10 .. "/" .. var9
	end
end

return var0
