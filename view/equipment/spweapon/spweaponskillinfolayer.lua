local var0 = class("SpWeaponSkillInfoLayer", import("view.ship.SkillInfoLayer"))

function var0.getUIName(arg0)
	return "SkillInfoUI"
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
	local var1 = arg0.contextData.unlock
	local var2 = getSkillName(var0)

	if not var1 then
		var2 = setColorStr(var2, "#a2a2a2")
	end

	setText(arg0.skillInfoName, var2)

	local var3 = getSkillConfig(var0)

	assert(var3)
	LoadImageSpriteAsync("skillicon/" .. var3.icon, arg0.skillInfoIcon)
	setActive(arg0.upgradeBtn, false)
	setActive(arg0.metaBtn, false)
end

function var0.showInfo(arg0, arg1)
	arg0.isWorld = arg1

	local var0 = arg0.contextData.skillId
	local var1 = arg0.contextData.skillOnShip
	local var2 = arg0.contextData.unlock
	local var3 = var1 and var1.level or 1

	setText(arg0.skillInfoLv, "Lv." .. var3)

	local var4 = getSkillDesc(var0, var3, arg1)

	if not var2 then
		var4 = setColorStr(i18n("spweapon_tip_skill_locked") .. var4, "#a2a2a2")
	end

	setText(arg0.skillInfoIntro, var4)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
