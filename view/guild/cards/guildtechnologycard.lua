local var0 = class("GuildTechnologyCard")

function var0.Ctor(arg0, arg1, arg2)
	arg0.view = arg2

	pg.DelegateInfo.New(arg0)

	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.titleImg = arg0._tf:Find("title"):GetComponent(typeof(Text))
	arg0.iconImag = arg0._tf:Find("icon"):GetComponent(typeof(Image))
	arg0.levelTxt = arg0._tf:Find("level"):GetComponent(typeof(Text))
	arg0.descTxt = arg0._tf:Find("desc"):GetComponent(typeof(Text))
	arg0.upgradeTF = arg0._tf:Find("upgrade")
	arg0.guildRes = arg0.upgradeTF:Find("cion")
	arg0.guildResTxt = arg0.upgradeTF:Find("cion/Text"):GetComponent(typeof(Text))
	arg0.goldRes = arg0.upgradeTF:Find("gold")
	arg0.goldResTxt = arg0.upgradeTF:Find("gold/Text"):GetComponent(typeof(Text))
	arg0.upgradeBtn = arg0.upgradeTF:Find("upgrade_btn")
	arg0.maxTF = arg0._tf:Find("max")
	arg0.breakoutTF = arg0._tf:Find("breakout")
	arg0.breakoutSlider = arg0._tf:Find("progress"):GetComponent(typeof(Slider))
	arg0.breakoutTxt = arg0._tf:Find("progress/Text"):GetComponent(typeof(Text))
	arg0.livnessTF = arg0.upgradeTF:Find("livness")

	setActive(arg0.breakoutSlider.gameObject, false)
	setActive(arg0.upgradeTF, false)
	setActive(arg0.maxTF, false)
	setActive(arg0.breakoutTF, false)
end

function var0.Update(arg0, arg1, arg2)
	local var0 = arg1.group.id
	local var1 = arg1:getConfig("name")

	arg0.titleImg.text = var1
	arg0.iconImag.sprite = GetSpriteFromAtlas("GuildTechnology", var0)

	local var2 = arg1:GetMaxLevel()
	local var3 = arg1:GetLevel()
	local var4 = arg1.group:GetFakeLevel()
	local var5 = math.max(var2, var4)

	if arg1:IsGuildMember() then
		arg0.levelTxt.text = "Lv." .. var3
	else
		local var6 = string.format(" [%s+%s]", var2, math.max(0, var4 - var2))

		arg0.levelTxt.text = "Lv." .. var3 .. "/" .. var5 .. var6
	end

	arg0.descTxt.text = arg1:GetDesc()

	setActive(arg0.maxTF, var5 <= var3)
	setActive(arg0.upgradeTF, var3 < var5)

	local var7 = arg1:_ReachTargetLiveness_()
	local var8 = arg1:CanUpgrade()

	removeOnButton(arg0._tf)

	if var8 then
		var7 = true

		local var9, var10 = arg1:GetConsume()

		arg0.guildResTxt.text = var9
		arg0.goldResTxt.text = var10

		onButton(arg0, arg0._tf, function()
			if var3 >= var5 then
				return
			end

			arg0:DoUprade(arg1)
		end, SFX_PANEL)
	elseif not var7 then
		setText(arg0.livnessTF, i18n("guild_tech_livness_no_enough_label", arg1:GetTargetLivness()))
	end

	setActive(arg0.guildRes, var7)
	setActive(arg0.goldRes, var7)
	setActive(arg0.upgradeBtn, var7)
	setActive(arg0.livnessTF, not var7)

	local var11 = arg2 and arg2.id == var0

	setActive(arg0.breakoutSlider.gameObject, var11)

	if var11 then
		local var12 = arg2:GetTargetProgress()
		local var13 = arg2:GetProgress()

		arg0.breakoutSlider.value = var13 / var12
		arg0.breakoutTxt.text = var13 .. "/" .. var12
	end
end

function var0.DoUprade(arg0, arg1)
	local function var0()
		local var0 = arg1:getConfig("name")
		local var1, var2 = arg1:GetConsume()

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_tech_consume_tip", var1, var2, var0),
			onYes = function()
				arg0.view:emit(GuildTechnologyMediator.ON_UPGRADE, arg1.group.id)
			end
		})
	end

	local function var1(arg0)
		if arg1:IsRiseInPrice() then
			local var0, var1, var2 = arg1:CanUpgradeBySelf()
			local var3 = i18n("guild_tech_price_inc_tip")

			if var2 and not var1 then
				local var4 = arg1:GetLivenessOffset()

				var3 = i18n("guild_tech_livness_no_enough", var4)
			end

			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = var3,
				onYes = arg0
			})
		else
			arg0()
		end
	end

	seriesAsync({
		function(arg0)
			var1(arg0)
		end,
		function(arg0)
			var0()
		end
	})
end

function var0.Destroy(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
