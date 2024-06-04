local var0 = class("BattleFailTipLayer", import("..base.BaseUI"))

var0.PowerUpBtn = {
	ShipBreakUp = 4,
	SkillLevelUp = 3,
	ShipLevelUp = 1,
	EquipLevelUp = 2
}

function var0.getUIName(arg0)
	return "BattleFailTipUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.battleSystem = arg0.contextData.battleSystem
end

function var0.findUI(arg0)
	arg0.powerUpTipPanel = arg0:findTF("Main")
	arg0.shipLevelUpBtn = arg0:findTF("ShipLevelUpBtn", arg0.powerUpTipPanel)
	arg0.equipLevelUpBtn = arg0:findTF("EquipLevelUpBtn", arg0.powerUpTipPanel)
	arg0.skillLevelUpBtn = arg0:findTF("SkillLevelUpBtn", arg0.powerUpTipPanel)
	arg0.shipBreakUpBtn = arg0:findTF("ShipBreakUpBtn", arg0.powerUpTipPanel)
	arg0.closeBtn = arg0:findTF("CloseBtn", arg0.powerUpTipPanel)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.shipLevelUpBtn, function()
		if arg0.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fightfail_up"),
				onYes = function()
					if arg0.contextData.battleSystem == SYSTEM_SCENARIO then
						arg0.lastClickBtn = var0.PowerUpBtn.ShipLevelUp

						arg0:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						arg0:emit(BattleFailTipMediator.GO_HIGEST_CHAPTER)
					end
				end
			})
		else
			arg0:emit(BattleFailTipMediator.GO_HIGEST_CHAPTER)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.equipLevelUpBtn, function()
		if arg0.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fightfail_equip"),
				onYes = function()
					if arg0.contextData.battleSystem == SYSTEM_SCENARIO then
						arg0.lastClickBtn = var0.PowerUpBtn.EquipLevelUp

						arg0:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						arg0:emit(BattleFailTipMediator.GO_DOCKYARD_EQUIP)
					end
				end
			})
		else
			arg0:emit(BattleFailTipMediator.GO_DOCKYARD_EQUIP)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.skillLevelUpBtn, function()
		arg0:emit(BattleFailTipMediator.GO_NAVALTACTICS)
	end, SFX_PANEL)
	onButton(arg0, arg0.shipBreakUpBtn, function()
		if arg0.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fight_strengthen"),
				onYes = function()
					if arg0.contextData.battleSystem == SYSTEM_SCENARIO then
						arg0.lastClickBtn = var0.PowerUpBtn.ShipBreakUp

						arg0:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						arg0:emit(BattleFailTipMediator.GO_DOCKYARD_SHIP)
					end
				end
			})
		else
			arg0:emit(BattleFailTipMediator.GO_DOCKYARD_SHIP)
		end
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:aniBeforeEnter()
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.aniBeforeEnter(arg0)
	local var0 = GetComponent(arg0._tf, "CanvasGroup")

	LeanTween.value(go(arg0._tf), 0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end))
end

return var0
