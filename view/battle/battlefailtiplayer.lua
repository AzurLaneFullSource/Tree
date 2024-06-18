local var0_0 = class("BattleFailTipLayer", import("..base.BaseUI"))

var0_0.PowerUpBtn = {
	ShipBreakUp = 4,
	SkillLevelUp = 3,
	ShipLevelUp = 1,
	EquipLevelUp = 2
}

function var0_0.getUIName(arg0_1)
	return "BattleFailTipUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.battleSystem = arg0_3.contextData.battleSystem
end

function var0_0.findUI(arg0_4)
	arg0_4.powerUpTipPanel = arg0_4:findTF("Main")
	arg0_4.shipLevelUpBtn = arg0_4:findTF("ShipLevelUpBtn", arg0_4.powerUpTipPanel)
	arg0_4.equipLevelUpBtn = arg0_4:findTF("EquipLevelUpBtn", arg0_4.powerUpTipPanel)
	arg0_4.skillLevelUpBtn = arg0_4:findTF("SkillLevelUpBtn", arg0_4.powerUpTipPanel)
	arg0_4.shipBreakUpBtn = arg0_4:findTF("ShipBreakUpBtn", arg0_4.powerUpTipPanel)
	arg0_4.closeBtn = arg0_4:findTF("CloseBtn", arg0_4.powerUpTipPanel)
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.shipLevelUpBtn, function()
		if arg0_5.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fightfail_up"),
				onYes = function()
					if arg0_5.contextData.battleSystem == SYSTEM_SCENARIO then
						arg0_5.lastClickBtn = var0_0.PowerUpBtn.ShipLevelUp

						arg0_5:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						arg0_5:emit(BattleFailTipMediator.GO_HIGEST_CHAPTER)
					end
				end
			})
		else
			arg0_5:emit(BattleFailTipMediator.GO_HIGEST_CHAPTER)
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.equipLevelUpBtn, function()
		if arg0_5.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fightfail_equip"),
				onYes = function()
					if arg0_5.contextData.battleSystem == SYSTEM_SCENARIO then
						arg0_5.lastClickBtn = var0_0.PowerUpBtn.EquipLevelUp

						arg0_5:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						arg0_5:emit(BattleFailTipMediator.GO_DOCKYARD_EQUIP)
					end
				end
			})
		else
			arg0_5:emit(BattleFailTipMediator.GO_DOCKYARD_EQUIP)
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.skillLevelUpBtn, function()
		arg0_5:emit(BattleFailTipMediator.GO_NAVALTACTICS)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.shipBreakUpBtn, function()
		if arg0_5.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fight_strengthen"),
				onYes = function()
					if arg0_5.contextData.battleSystem == SYSTEM_SCENARIO then
						arg0_5.lastClickBtn = var0_0.PowerUpBtn.ShipBreakUp

						arg0_5:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						arg0_5:emit(BattleFailTipMediator.GO_DOCKYARD_SHIP)
					end
				end
			})
		else
			arg0_5:emit(BattleFailTipMediator.GO_DOCKYARD_SHIP)
		end
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_14)
	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
	arg0_14:aniBeforeEnter()
end

function var0_0.onBackPressed(arg0_15)
	arg0_15:closeView()
end

function var0_0.willExit(arg0_16)
	LeanTween.cancel(go(arg0_16._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf)
end

function var0_0.aniBeforeEnter(arg0_17)
	local var0_17 = GetComponent(arg0_17._tf, "CanvasGroup")

	LeanTween.value(go(arg0_17._tf), 0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0_18)
		var0_17.alpha = arg0_18
	end))
end

return var0_0
