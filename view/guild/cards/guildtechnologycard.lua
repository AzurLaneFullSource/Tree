local var0_0 = class("GuildTechnologyCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg2_1

	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.titleImg = arg0_1._tf:Find("title"):GetComponent(typeof(Text))
	arg0_1.iconImag = arg0_1._tf:Find("icon"):GetComponent(typeof(Image))
	arg0_1.levelTxt = arg0_1._tf:Find("level"):GetComponent(typeof(Text))
	arg0_1.descTxt = arg0_1._tf:Find("desc"):GetComponent(typeof(Text))
	arg0_1.upgradeTF = arg0_1._tf:Find("upgrade")
	arg0_1.guildRes = arg0_1.upgradeTF:Find("cion")
	arg0_1.guildResTxt = arg0_1.upgradeTF:Find("cion/Text"):GetComponent(typeof(Text))
	arg0_1.goldRes = arg0_1.upgradeTF:Find("gold")
	arg0_1.goldResTxt = arg0_1.upgradeTF:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_1.upgradeBtn = arg0_1.upgradeTF:Find("upgrade_btn")
	arg0_1.maxTF = arg0_1._tf:Find("max")
	arg0_1.breakoutTF = arg0_1._tf:Find("breakout")
	arg0_1.breakoutSlider = arg0_1._tf:Find("progress"):GetComponent(typeof(Slider))
	arg0_1.breakoutTxt = arg0_1._tf:Find("progress/Text"):GetComponent(typeof(Text))
	arg0_1.livnessTF = arg0_1.upgradeTF:Find("livness")

	setActive(arg0_1.breakoutSlider.gameObject, false)
	setActive(arg0_1.upgradeTF, false)
	setActive(arg0_1.maxTF, false)
	setActive(arg0_1.breakoutTF, false)
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2.group.id
	local var1_2 = arg1_2:getConfig("name")

	arg0_2.titleImg.text = var1_2
	arg0_2.iconImag.sprite = GetSpriteFromAtlas("GuildTechnology", var0_2)

	local var2_2 = arg1_2:GetMaxLevel()
	local var3_2 = arg1_2:GetLevel()
	local var4_2 = arg1_2.group:GetFakeLevel()
	local var5_2 = math.max(var2_2, var4_2)

	if arg1_2:IsGuildMember() then
		arg0_2.levelTxt.text = "Lv." .. var3_2
	else
		local var6_2 = string.format(" [%s+%s]", var2_2, math.max(0, var4_2 - var2_2))

		arg0_2.levelTxt.text = "Lv." .. var3_2 .. "/" .. var5_2 .. var6_2
	end

	arg0_2.descTxt.text = arg1_2:GetDesc()

	setActive(arg0_2.maxTF, var5_2 <= var3_2)
	setActive(arg0_2.upgradeTF, var3_2 < var5_2)

	local var7_2 = arg1_2:_ReachTargetLiveness_()
	local var8_2 = arg1_2:CanUpgrade()

	removeOnButton(arg0_2._tf)

	if var8_2 then
		var7_2 = true

		local var9_2, var10_2 = arg1_2:GetConsume()

		arg0_2.guildResTxt.text = var9_2
		arg0_2.goldResTxt.text = var10_2

		onButton(arg0_2, arg0_2._tf, function()
			if var3_2 >= var5_2 then
				return
			end

			arg0_2:DoUprade(arg1_2)
		end, SFX_PANEL)
	elseif not var7_2 then
		setText(arg0_2.livnessTF, i18n("guild_tech_livness_no_enough_label", arg1_2:GetTargetLivness()))
	end

	setActive(arg0_2.guildRes, var7_2)
	setActive(arg0_2.goldRes, var7_2)
	setActive(arg0_2.upgradeBtn, var7_2)
	setActive(arg0_2.livnessTF, not var7_2)

	local var11_2 = arg2_2 and arg2_2.id == var0_2

	setActive(arg0_2.breakoutSlider.gameObject, var11_2)

	if var11_2 then
		local var12_2 = arg2_2:GetTargetProgress()
		local var13_2 = arg2_2:GetProgress()

		arg0_2.breakoutSlider.value = var13_2 / var12_2
		arg0_2.breakoutTxt.text = var13_2 .. "/" .. var12_2
	end
end

function var0_0.DoUprade(arg0_4, arg1_4)
	local function var0_4()
		local var0_5 = arg1_4:getConfig("name")
		local var1_5, var2_5 = arg1_4:GetConsume()

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_tech_consume_tip", var1_5, var2_5, var0_5),
			onYes = function()
				arg0_4.view:emit(GuildTechnologyMediator.ON_UPGRADE, arg1_4.group.id)
			end
		})
	end

	local function var1_4(arg0_7)
		if arg1_4:IsRiseInPrice() then
			local var0_7, var1_7, var2_7 = arg1_4:CanUpgradeBySelf()
			local var3_7 = i18n("guild_tech_price_inc_tip")

			if var2_7 and not var1_7 then
				local var4_7 = arg1_4:GetLivenessOffset()

				var3_7 = i18n("guild_tech_livness_no_enough", var4_7)
			end

			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = var3_7,
				onYes = arg0_7
			})
		else
			arg0_7()
		end
	end

	seriesAsync({
		function(arg0_8)
			var1_4(arg0_8)
		end,
		function(arg0_9)
			var0_4()
		end
	})
end

function var0_0.Destroy(arg0_10)
	pg.DelegateInfo.Dispose(arg0_10)
end

return var0_0
