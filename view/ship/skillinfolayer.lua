local var0_0 = class("SkillInfoLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SkillInfoUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = arg0_2:getWeightFromData()
	})

	arg0_2.backBtn = arg0_2:findTF("panel/top/btnBack")
	arg0_2.skillInfoName = arg0_2:findTF("panel/bg/skill_name")
	arg0_2.skillInfoLv = arg0_2:findTF("panel/bg/skill_lv")
	arg0_2.skillInfoIntro = arg0_2:findTF("panel/bg/help_panel/skill_intro")
	arg0_2.skillInfoIcon = arg0_2:findTF("panel/bg/skill_icon")
	arg0_2.btnTypeNormal = arg0_2:findTF("panel/bg/btn_type_normal")
	arg0_2.btnTypeWorld = arg0_2:findTF("panel/bg/btn_type_world")
	arg0_2.buttonList = arg0_2:findTF("panel/buttonList")
	arg0_2.upgradeBtn = arg0_2:findTF("panel/buttonList/level_button")
	arg0_2.metaBtn = arg0_2:findTF("panel/buttonList/meta_button")

	setText(arg0_2:findTF("Image", arg0_2.metaBtn), i18n("meta_skillbtn_tactics"))
	setText(arg0_2:findTF("panel/top/title_list/infomation/title"), i18n("words_information"))
	setText(arg0_2.buttonList:Find("ok_button/Image"), i18n("text_confirm"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("panel/buttonList/ok_button"), function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		arg0_3:emit(SkillInfoMediator.WARP_TO_TACTIC)
	end, SFX_UI_CLICK)
	onButton(arg0_3, arg0_3.metaBtn, function()
		local var0_8 = arg0_3.contextData.shipId
		local var1_8
		local var2_8

		if var0_8 then
			var2_8 = getProxy(BayProxy):getShipById(arg0_3.contextData.shipId)
			var1_8 = var2_8:isMetaShip()
		end

		if var1_8 then
			arg0_3:emit(SkillInfoMediator.WARP_TO_META_TACTICS, var2_8.configId)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnTypeNormal, function()
		arg0_3:showInfo(false)
		arg0_3:flushTypeBtn()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnTypeWorld, function()
		arg0_3:showInfo(true)
		arg0_3:flushTypeBtn()
	end, SFX_PANEL)

	if tobool(pg.skill_world_display[arg0_3.contextData.skillId]) then
		arg0_3:flushTypeBtn()
	else
		setActive(arg0_3.btnTypeNormal, false)
		setActive(arg0_3.btnTypeWorld, false)
	end

	arg0_3:showBase()
	arg0_3:showInfo(false)
end

function var0_0.flushTypeBtn(arg0_11)
	setActive(arg0_11.btnTypeNormal, arg0_11.isWorld)
	setActive(arg0_11.btnTypeWorld, not arg0_11.isWorld)
end

function var0_0.showBase(arg0_12)
	local var0_12 = arg0_12.contextData.skillId
	local var1_12 = arg0_12.contextData.skillOnShip

	setText(arg0_12.skillInfoName, getSkillName(var0_12))

	local var2_12 = getSkillConfig(var0_12)

	LoadImageSpriteAsync("skillicon/" .. var2_12.icon, arg0_12.skillInfoIcon)

	local var3_12 = not arg0_12.contextData.fromNewShip and var1_12 and var1_12.level < #var2_12 and var1_12.id ~= 22262 and var1_12.id ~= 22261

	setActive(arg0_12.upgradeBtn, var3_12)

	local var4_12 = arg0_12.contextData.shipId
	local var5_12
	local var6_12

	if var4_12 then
		var5_12 = getProxy(BayProxy):getShipById(arg0_12.contextData.shipId):isMetaShip()
	end

	local var7_12 = MetaCharacterConst.isMetaTaskSkillID(var0_12)

	setActive(arg0_12.metaBtn, var5_12 and var7_12)

	if var5_12 then
		setActive(arg0_12.upgradeBtn, false)
	end
end

function var0_0.showInfo(arg0_13, arg1_13)
	arg0_13.isWorld = arg1_13

	local var0_13 = arg0_13.contextData.skillId
	local var1_13 = arg0_13.contextData.skillOnShip
	local var2_13 = var1_13 and var1_13.level or 1

	setText(arg0_13.skillInfoLv, "Lv." .. var2_13)

	if arg0_13.contextData.fromNewShip then
		setText(arg0_13.skillInfoIntro, getSkillDescGet(var0_13, arg1_13))
	else
		setText(arg0_13.skillInfoIntro, getSkillDesc(var0_13, var2_13, arg1_13))
	end
end

function var0_0.close(arg0_14)
	arg0_14:emit(var0_0.ON_CLOSE)
end

function var0_0.willExit(arg0_15)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_15._tf)

	if arg0_15.contextData.onExit then
		arg0_15.contextData.onExit()
	end
end

function var0_0.inOutAnim(arg0_16, arg1_16, arg2_16)
	if arg1_16 then
		local var0_16 = arg0_16:findTF("panel/bg_decorations"):GetComponent(typeof(Animation))

		var0_16:Stop()
		var0_16:Play("anim_window_bg")

		local var1_16 = arg0_16:findTF("panel/top"):GetComponent(typeof(Animation))

		var1_16:Stop()
		var1_16:Play("anim_top")

		local var2_16 = arg0_16:findTF("panel/bg"):GetComponent(typeof(Animation))

		var2_16:Stop()
		var2_16:Play("anim_content")

		local var3_16 = arg0_16:findTF("bg"):GetComponent(typeof(Animation))

		var3_16:Stop()
		var3_16:Play("anim_bg_plus")

		local var4_16 = arg0_16:findTF("panel/buttonList"):GetComponent(typeof(Animation))

		var4_16:Stop()
		var4_16:Play("anim_button_container")
	end

	arg2_16()
end

return var0_0
