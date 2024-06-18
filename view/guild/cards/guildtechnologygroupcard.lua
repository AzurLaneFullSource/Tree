local var0_0 = class("GuildTechnologyGroupCard", import(".GuildTechnologyCard"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.devBtn = arg0_1.breakoutTF:Find("dev_btn")
	arg0_1.cancelBtn = arg0_1.breakoutTF:Find("cancel_btn")
	arg0_1.devBtnTxt = arg0_1.devBtn:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg1_2.id

	arg0_2.titleImg.text = arg1_2:getConfig("name")
	arg0_2.iconImag.sprite = GetSpriteFromAtlas("GuildTechnology", var0_2)
	arg0_2.descTxt.text = arg1_2:GetDesc()

	local var1_2 = arg1_2:GetMaxLevel()
	local var2_2 = arg1_2:GetLevel()
	local var3_2 = arg1_2:GetState()

	setActive(arg0_2.maxTF, var1_2 <= var2_2)
	setActive(arg0_2.breakoutTF, var2_2 < var1_2)
	setActive(arg0_2.devBtn, var3_2 == GuildTechnologyGroup.STATE_STOP and var2_2 < var1_2)
	setActive(arg0_2.breakoutSlider.gameObject, var3_2 == GuildTechnologyGroup.STATE_START)
	setActive(arg0_2.cancelBtn, false)

	if var2_2 < var1_2 then
		onButton(arg0_2, arg0_2._tf, function()
			if not arg3_2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_non_admin"))

				return
			end

			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = i18n("guild_start_tech_group_tip", arg1_2:getConfig("name")),
				onYes = function()
					arg0_2.view:emit(GuildTechnologyMediator.ON_START, var0_2)
				end
			})
		end, SFX_PANEL)

		arg0_2.levelTxt.text = "Lv." .. var2_2 .. "/" .. var1_2
	else
		arg0_2.levelTxt.text = "Lv." .. var1_2 .. "/" .. var1_2
	end

	if var3_2 == GuildTechnologyGroup.STATE_START then
		local var4_2 = arg1_2:GetTargetProgress()
		local var5_2 = arg1_2:GetProgress()

		arg0_2.breakoutSlider.value = var5_2 / var4_2
		arg0_2.breakoutTxt.text = var5_2 .. "/" .. var4_2
	end

	onButton(arg0_2, arg0_2.cancelBtn, function()
		if not arg3_2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_non_admin"))

			return
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_cancel_tech_tip", arg1_2:getConfig("name")),
			onYes = function()
				arg0_2.view:emit(GuildTechnologyMediator.ON_CANCEL_TECH, var0_2)
			end
		})
	end, SFX_PANEL)

	arg0_2.devBtnTxt.text = i18n("guild_tech_donate_target", arg1_2:GetTargetProgress())
end

return var0_0
