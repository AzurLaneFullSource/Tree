local var0 = class("GuildTechnologyGroupCard", import(".GuildTechnologyCard"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.devBtn = arg0.breakoutTF:Find("dev_btn")
	arg0.cancelBtn = arg0.breakoutTF:Find("cancel_btn")
	arg0.devBtnTxt = arg0.devBtn:Find("Text"):GetComponent(typeof(Text))
end

function var0.Update(arg0, arg1, arg2, arg3)
	local var0 = arg1.id

	arg0.titleImg.text = arg1:getConfig("name")
	arg0.iconImag.sprite = GetSpriteFromAtlas("GuildTechnology", var0)
	arg0.descTxt.text = arg1:GetDesc()

	local var1 = arg1:GetMaxLevel()
	local var2 = arg1:GetLevel()
	local var3 = arg1:GetState()

	setActive(arg0.maxTF, var1 <= var2)
	setActive(arg0.breakoutTF, var2 < var1)
	setActive(arg0.devBtn, var3 == GuildTechnologyGroup.STATE_STOP and var2 < var1)
	setActive(arg0.breakoutSlider.gameObject, var3 == GuildTechnologyGroup.STATE_START)
	setActive(arg0.cancelBtn, false)

	if var2 < var1 then
		onButton(arg0, arg0._tf, function()
			if not arg3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_non_admin"))

				return
			end

			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = i18n("guild_start_tech_group_tip", arg1:getConfig("name")),
				onYes = function()
					arg0.view:emit(GuildTechnologyMediator.ON_START, var0)
				end
			})
		end, SFX_PANEL)

		arg0.levelTxt.text = "Lv." .. var2 .. "/" .. var1
	else
		arg0.levelTxt.text = "Lv." .. var1 .. "/" .. var1
	end

	if var3 == GuildTechnologyGroup.STATE_START then
		local var4 = arg1:GetTargetProgress()
		local var5 = arg1:GetProgress()

		arg0.breakoutSlider.value = var5 / var4
		arg0.breakoutTxt.text = var5 .. "/" .. var4
	end

	onButton(arg0, arg0.cancelBtn, function()
		if not arg3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_non_admin"))

			return
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_cancel_tech_tip", arg1:getConfig("name")),
			onYes = function()
				arg0.view:emit(GuildTechnologyMediator.ON_CANCEL_TECH, var0)
			end
		})
	end, SFX_PANEL)

	arg0.devBtnTxt.text = i18n("guild_tech_donate_target", arg1:GetTargetProgress())
end

return var0
