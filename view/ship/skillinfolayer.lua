local var0 = class("SkillInfoLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "SkillInfoUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = arg0:getWeightFromData()
	})

	arg0.backBtn = arg0:findTF("panel/top/btnBack")
	arg0.skillInfoName = arg0:findTF("panel/bg/skill_name")
	arg0.skillInfoLv = arg0:findTF("panel/bg/skill_lv")
	arg0.skillInfoIntro = arg0:findTF("panel/bg/help_panel/skill_intro")
	arg0.skillInfoIcon = arg0:findTF("panel/bg/skill_icon")
	arg0.btnTypeNormal = arg0:findTF("panel/bg/btn_type_normal")
	arg0.btnTypeWorld = arg0:findTF("panel/bg/btn_type_world")
	arg0.buttonList = arg0:findTF("panel/buttonList")
	arg0.upgradeBtn = arg0:findTF("panel/buttonList/level_button")
	arg0.metaBtn = arg0:findTF("panel/buttonList/meta_button")

	setText(arg0:findTF("Image", arg0.metaBtn), i18n("meta_skillbtn_tactics"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("panel/buttonList/ok_button"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.upgradeBtn, function()
		arg0:emit(SkillInfoMediator.WARP_TO_TACTIC)
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.metaBtn, function()
		local var0 = arg0.contextData.shipId
		local var1
		local var2

		if var0 then
			var2 = getProxy(BayProxy):getShipById(arg0.contextData.shipId)
			var1 = var2:isMetaShip()
		end

		if var1 then
			arg0:emit(SkillInfoMediator.WARP_TO_META_TACTICS, var2.configId)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.btnTypeNormal, function()
		arg0:showInfo(false)
		arg0:flushTypeBtn()
	end, SFX_PANEL)
	onButton(arg0, arg0.btnTypeWorld, function()
		arg0:showInfo(true)
		arg0:flushTypeBtn()
	end, SFX_PANEL)

	if tobool(pg.skill_world_display[arg0.contextData.skillId]) then
		arg0:flushTypeBtn()
	else
		setActive(arg0.btnTypeNormal, false)
		setActive(arg0.btnTypeWorld, false)
	end

	arg0:showBase()
	arg0:showInfo(false)
end

function var0.flushTypeBtn(arg0)
	setActive(arg0.btnTypeNormal, arg0.isWorld)
	setActive(arg0.btnTypeWorld, not arg0.isWorld)
end

function var0.showBase(arg0)
	local var0 = arg0.contextData.skillId
	local var1 = arg0.contextData.skillOnShip

	setText(arg0.skillInfoName, getSkillName(var0))

	local var2 = getSkillConfig(var0)

	LoadImageSpriteAsync("skillicon/" .. var2.icon, arg0.skillInfoIcon)

	local var3 = not arg0.contextData.fromNewShip and var1 and var1.level < #var2 and var1.id ~= 22262 and var1.id ~= 22261

	setActive(arg0.upgradeBtn, var3)

	local var4 = arg0.contextData.shipId
	local var5
	local var6

	if var4 then
		var5 = getProxy(BayProxy):getShipById(arg0.contextData.shipId):isMetaShip()
	end

	local var7 = MetaCharacterConst.isMetaTaskSkillID(var0)

	setActive(arg0.metaBtn, var5 and var7)

	if var5 then
		setActive(arg0.upgradeBtn, false)
	end
end

function var0.showInfo(arg0, arg1)
	arg0.isWorld = arg1

	local var0 = arg0.contextData.skillId
	local var1 = arg0.contextData.skillOnShip
	local var2 = var1 and var1.level or 1

	setText(arg0.skillInfoLv, "Lv." .. var2)

	if arg0.contextData.fromNewShip then
		setText(arg0.skillInfoIntro, getSkillDescGet(var0, arg1))
	else
		setText(arg0.skillInfoIntro, getSkillDesc(var0, var2, arg1))
	end
end

function var0.close(arg0)
	arg0:emit(var0.ON_CLOSE)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
