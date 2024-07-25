local var0_0 = class("SpWeaponSkillInfoLayer", import("view.ship.SkillInfoLayer"))

function var0_0.getUIName(arg0_1)
	return "SkillInfoUI"
end

function var0_0.didEnter(arg0_2)
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.backBtn, function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2:findTF("panel/buttonList/ok_button"), function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.upgradeBtn, function()
		arg0_2:emit(SkillInfoMediator.WARP_TO_TACTIC)
	end, SFX_UI_CLICK)
	onButton(arg0_2, arg0_2.metaBtn, function()
		local var0_7 = arg0_2.contextData.shipId
		local var1_7
		local var2_7

		if var0_7 then
			var2_7 = getProxy(BayProxy):getShipById(arg0_2.contextData.shipId)
			var1_7 = var2_7:isMetaShip()
		end

		if var1_7 then
			arg0_2:emit(SkillInfoMediator.WARP_TO_META_TACTICS, var2_7.configId)
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnTypeNormal, function()
		arg0_2:showInfo(false)
		arg0_2:flushTypeBtn()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnTypeWorld, function()
		arg0_2:showInfo(true)
		arg0_2:flushTypeBtn()
	end, SFX_PANEL)

	if tobool(pg.skill_world_display[arg0_2.contextData.skillId]) then
		arg0_2:flushTypeBtn()
	else
		setActive(arg0_2.btnTypeNormal, false)
		setActive(arg0_2.btnTypeWorld, false)
	end

	arg0_2:showBase()
	arg0_2:showInfo(false)
	setText(arg0_2:findTF("panel/top/title_list/infomation/title"), i18n("words_information"))
	setText(arg0_2.buttonList:Find("ok_button/Image"), i18n("text_confirm"))
	setText(arg0_2.buttonList:Find("level_button/Image"), i18n("msgbox_text_upgrade"))
end

function var0_0.flushTypeBtn(arg0_10)
	setActive(arg0_10.btnTypeNormal, arg0_10.isWorld)
	setActive(arg0_10.btnTypeWorld, not arg0_10.isWorld)
end

function var0_0.showBase(arg0_11)
	local var0_11 = arg0_11.contextData.skillId
	local var1_11 = arg0_11.contextData.unlock
	local var2_11 = getSkillName(var0_11)

	if not var1_11 then
		var2_11 = setColorStr(var2_11, "#a2a2a2")
	end

	setText(arg0_11.skillInfoName, var2_11)

	local var3_11 = getSkillConfig(var0_11)

	assert(var3_11)
	LoadImageSpriteAsync("skillicon/" .. var3_11.icon, arg0_11.skillInfoIcon)
	setActive(arg0_11.upgradeBtn, false)
	setActive(arg0_11.metaBtn, false)
end

function var0_0.showInfo(arg0_12, arg1_12)
	arg0_12.isWorld = arg1_12

	local var0_12 = arg0_12.contextData.skillId
	local var1_12 = arg0_12.contextData.skillOnShip
	local var2_12 = arg0_12.contextData.unlock
	local var3_12 = var1_12 and var1_12.level or 1

	setText(arg0_12.skillInfoLv, "Lv." .. var3_12)

	local var4_12 = getSkillDesc(var0_12, var3_12, arg1_12)

	if not var2_12 then
		var4_12 = setColorStr(i18n("spweapon_tip_skill_locked") .. var4_12, "#a2a2a2")
	end

	setText(arg0_12.skillInfoIntro, var4_12)
end

function var0_0.willExit(arg0_13)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf)

	if arg0_13.contextData.onExit then
		arg0_13.contextData.onExit()
	end
end

return var0_0
