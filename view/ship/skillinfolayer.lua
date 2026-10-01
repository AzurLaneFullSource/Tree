local var0_0 = class("SkillInfoLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SkillInfoUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = arg1_2.skillId
	local var2_2 = getSkillConfig(var1_2)
	local var3_2 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.ShipSkillIcon, var2_2.icon)

	table.insert(var0_2, var3_2)

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2))
end

function var0_0.init(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)

	arg0_3.backBtn = arg0_3._tf:Find("panel/top/btnBack")
	arg0_3.skillInfoName = arg0_3._tf:Find("panel/bg/skill_name")
	arg0_3.skillInfoLv = arg0_3._tf:Find("panel/bg/skill_lv")
	arg0_3.skillInfoIntro = arg0_3._tf:Find("panel/bg/help_panel/skill_intro")
	arg0_3.skillInfoIcon = arg0_3._tf:Find("panel/bg/skill_icon")
	arg0_3.btnTypeNormal = arg0_3._tf:Find("panel/bg/btn_type_normal")
	arg0_3.btnTypeWorld = arg0_3._tf:Find("panel/bg/btn_type_world")
	arg0_3.buttonList = arg0_3._tf:Find("panel/buttonList")
	arg0_3.upgradeBtn = arg0_3._tf:Find("panel/buttonList/level_button")
	arg0_3.metaBtn = arg0_3._tf:Find("panel/buttonList/meta_button")

	setText(arg0_3.metaBtn:Find("Image"), i18n("meta_skillbtn_tactics"))
	setText(arg0_3._tf:Find("panel/top/title_list/infomation/title"), i18n("words_information"))
	setText(arg0_3.buttonList:Find("ok_button/Image"), i18n("text_confirm"))

	if PLATFORM_CODE == PLATFORM_JP then
		setText(arg0_3.buttonList:Find("level_button/Image"), i18n("msgbox_text_noPos_intensify"))
	else
		setText(arg0_3.buttonList:Find("level_button/Image"), i18n("msgbox_text_upgrade"))
	end
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4._tf:Find("panel/buttonList/ok_button"), function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(arg0_4, arg0_4.upgradeBtn, function()
		arg0_4:emit(SkillInfoMediator.WARP_TO_TACTIC)
	end, SFX_UI_CLICK)
	onButton(arg0_4, arg0_4.metaBtn, function()
		local var0_9 = arg0_4.contextData.shipId
		local var1_9
		local var2_9

		if var0_9 then
			var2_9 = getProxy(BayProxy):getShipById(arg0_4.contextData.shipId)
			var1_9 = var2_9:isMetaShip()
		end

		if var1_9 then
			arg0_4:emit(SkillInfoMediator.WARP_TO_META_TACTICS, var2_9.configId)
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnTypeNormal, function()
		arg0_4:showInfo(false)
		arg0_4:flushTypeBtn()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnTypeWorld, function()
		arg0_4:showInfo(true)
		arg0_4:flushTypeBtn()
	end, SFX_PANEL)

	if tobool(pg.skill_world_display[arg0_4.contextData.skillId]) then
		arg0_4:flushTypeBtn()
	else
		setActive(arg0_4.btnTypeNormal, false)
		setActive(arg0_4.btnTypeWorld, false)
	end

	arg0_4:showBase()
	arg0_4:showInfo(false)
end

function var0_0.flushTypeBtn(arg0_12)
	setActive(arg0_12.btnTypeNormal, arg0_12.isWorld)
	setActive(arg0_12.btnTypeWorld, not arg0_12.isWorld)
end

function var0_0.showBase(arg0_13)
	local var0_13 = arg0_13.contextData.skillId
	local var1_13 = arg0_13.contextData.skillOnShip

	setText(arg0_13.skillInfoName, getSkillName(var0_13))

	local var2_13 = getSkillConfig(var0_13)

	LoadImageSpriteAsync("skillicon/" .. var2_13.icon, arg0_13.skillInfoIcon)

	local var3_13 = not arg0_13.contextData.fromNewShip and var1_13 and var1_13.level < #var2_13 and var1_13.id ~= 22262 and var1_13.id ~= 22261

	setActive(arg0_13.upgradeBtn, var3_13)

	local var4_13 = arg0_13.contextData.shipId
	local var5_13
	local var6_13

	if var4_13 then
		var5_13 = getProxy(BayProxy):getShipById(arg0_13.contextData.shipId):isMetaShip()
	end

	local var7_13 = MetaCharacterConst.isMetaTaskSkillID(var0_13)

	setActive(arg0_13.metaBtn, var5_13 and var7_13)

	if var5_13 then
		setActive(arg0_13.upgradeBtn, false)
	end
end

function var0_0.showInfo(arg0_14, arg1_14)
	arg0_14.isWorld = arg1_14

	local var0_14 = arg0_14.contextData.skillId
	local var1_14 = arg0_14.contextData.skillOnShip
	local var2_14 = var1_14 and var1_14.level or 1

	setText(arg0_14.skillInfoLv, "Lv." .. var2_14)

	if arg0_14.contextData.fromNewShip then
		setText(arg0_14.skillInfoIntro, getSkillDescGet(var0_14, arg1_14))
	else
		setText(arg0_14.skillInfoIntro, getSkillDesc(var0_14, var2_14, arg1_14))
	end
end

function var0_0.close(arg0_15)
	arg0_15:emit(var0_0.ON_CLOSE)
end

function var0_0.willExit(arg0_16)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_16._tf)

	if arg0_16.contextData.onExit then
		arg0_16.contextData.onExit()
	end
end

function var0_0.inOutAnim(arg0_17, arg1_17, arg2_17)
	if arg1_17 then
		local var0_17 = arg0_17._tf:Find("panel/bg_decorations"):GetComponent(typeof(Animation))

		var0_17:Stop()
		var0_17:Play("anim_window_bg")

		local var1_17 = arg0_17._tf:Find("panel/top"):GetComponent(typeof(Animation))

		var1_17:Stop()
		var1_17:Play("anim_top")

		local var2_17 = arg0_17._tf:Find("panel/bg"):GetComponent(typeof(Animation))

		var2_17:Stop()
		var2_17:Play("anim_content")

		local var3_17 = arg0_17._tf:Find("bg"):GetComponent(typeof(Animation))

		var3_17:Stop()
		var3_17:Play("anim_bg_plus")

		local var4_17 = arg0_17._tf:Find("panel/buttonList"):GetComponent(typeof(Animation))

		var4_17:Stop()
		var4_17:Play("anim_button_container")
	end

	arg2_17()
end

return var0_0
