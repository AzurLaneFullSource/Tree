ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent
local var4_0 = var0_0.Battle.BattleFormulas
local var5_0 = var0_0.Battle.BattleConst
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = var0_0.Battle.BattleCardPuzzleConfig
local var8_0 = var0_0.Battle.BattleAttr
local var9_0 = var0_0.Battle.BattleDataFunction
local var10_0 = var0_0.Battle.CardPuzzleBoardClicker
local var11_0 = var0_0.Battle.BattleVariable
local var12_0 = class("BattleFleetCardPuzzleComponent")

var0_0.Battle.BattleFleetCardPuzzleComponent = var12_0
var12_0.__name = "BattleFleetCardPuzzleComponent"
var12_0.CARD_PILE_INDEX_DISCARD = -1
var12_0.CARD_PILE_INDEX_HAND = 0
var12_0.CARD_PILE_INDEX_DECK = 1
var12_0.CARD_PILE_INDEX_MOVE_DECK = 2

function var12_0.Ctor(arg0_1, arg1_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._fleetVO = arg1_1

	arg0_1:init()
end

function var12_0.CustomConfigID(arg0_2, arg1_2)
	arg0_2._customCombatID = arg1_2

	arg0_2._energy:CustomConfig(arg0_2._customCombatID)
	arg0_2._moveDeck:CustomConfig(arg0_2._customCombatID)
end

function var12_0.Dispose(arg0_3)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_3)
	var0_0.EventListener.DetachEventListener(arg0_3)

	arg0_3._fleetVO = nil
end

function var12_0.GetPuzzleDungeonID(arg0_4)
	return arg0_4._customCombatID
end

function var12_0.GetTotalCommonHP(arg0_5)
	return arg0_5._maxCommonHP
end

function var12_0.GetCurrentCommonHP(arg0_6)
	return arg0_6._currentCommonHP
end

function var12_0.GetEnergy(arg0_7)
	return arg0_7._energy
end

function var12_0.EnergyUpdate(arg0_8)
	arg0_8._fleetAttr:SetAttr("BaseEnergy", arg0_8._energy:GetCurrentEnergy())
end

function var12_0.AppendUnit(arg0_9, arg1_9)
	arg1_9:RegisterEventListener(arg0_9, var3_0.UPDATE_COMMON_HP, arg0_9.onUpdateCommonHP)

	arg0_9._maxCommonHP = arg0_9._maxCommonHP + arg1_9:GetAttrByName("maxHP")
	arg0_9._currentCommonHP = arg0_9._maxCommonHP

	local var0_9

	arg0_9._cardPuzzleAA:AppendCrewUnit(arg1_9)

	if arg1_9:IsMainFleetUnit() then
		arg0_9._mainUnit = arg1_9
		var0_9 = TeamType.TeamPos.FLAG_SHIP
	else
		arg0_9._scoutUnit = arg1_9

		arg0_9._cardPuzzleAA:SwitchHost(arg1_9)

		var0_9 = TeamType.TeamPos.LEADER
	end

	local var1_9 = var0_0.Event.New(var3_0.UPDATE_FLEET_SHIP, {
		teamType = var0_9
	})

	arg0_9:DispatchEvent(var1_9)
end

function var12_0.InitCardPuzzleData(arg0_10, arg1_10)
	arg0_10._fleetVO:GetUnitBound():SwtichDBRGL()

	local var0_10 = arg1_10.relicList

	for iter0_10, iter1_10 in ipairs(var0_10) do
		table.insert(arg0_10._relicList, iter1_10)

		local var1_10 = iter1_10:GetEffects()

		for iter2_10, iter3_10 in ipairs(var1_10) do
			if iter3_10.type == CardPuzzleGift.EFFECT_TYPE.BATTLE_BUFF then
				for iter4_10, iter5_10 in ipairs(iter3_10.arg_list) do
					local var2_10 = var0_0.Battle.BattleFleetBuffUnit.New(iter5_10)

					arg0_10._fleetBuff:AttachCardPuzzleBuff(var2_10)
				end
			end
		end
	end
end

function var12_0.RemoveUnit(arg0_11, arg1_11)
	arg1_11:UnregisterEventListener(arg0_11, var3_0.UPDATE_COMMON_HP)
end

function var12_0.GetMainUnit(arg0_12)
	return arg0_12._mainUnit
end

function var12_0.GetScoutUnit(arg0_13)
	return arg0_13._scoutUnit
end

function var12_0.AttachMoveController(arg0_14, arg1_14)
	arg0_14._moveController = arg1_14
end

function var12_0.TakeoverMovecontroller(arg0_15, arg1_15, arg2_15)
	arg0_15._moveController:InputTargetPoint(arg1_15, arg2_15)
	arg0_15._fleetVO:DispatchEvent(var0_0.Event.New(var3_0.FLEET_MOVE_TO, {
		pos = arg1_15
	}))
end

function var12_0.ReturnMovecontroller(arg0_16)
	arg0_16._fleetVO:DispatchEvent(var0_0.Event.New(var3_0.FLEET_MOVE_TO, {}))
end

function var12_0.PlayCard(arg0_17, arg1_17)
	if arg0_17:CheckCardCastable(arg1_17) then
		local function var0_17()
			local var0_18 = arg1_17:GetTotalCost()

			arg0_17._energy:ConsumeEnergy(var0_18)
			arg0_17._hand:Remove(arg1_17)
			arg0_17._hand:EnterCoolDownByType(arg1_17:GetCardType(), arg1_17:GetCardCD())

			if arg1_17:GetMoveAfterCast() == var12_0.CARD_PILE_INDEX_DISCARD then
				arg0_17._discard:Add(arg1_17)
			end

			arg0_17:TryDrawCard()
		end

		arg1_17:Precast(var0_17)

		return true
	else
		return false
	end
end

function var12_0.ReturnCard(arg0_19, arg1_19)
	if arg0_19:CheckCardReturnable(arg1_19) then
		local function var0_19()
			local var0_20 = arg1_19:GetReturnCost()

			arg0_19._energy:ConsumeEnergy(var0_20)
			arg0_19._hand:Remove(arg1_19)
			arg0_19:TryDrawCard()
		end

		arg1_19:Retrun(var0_19)

		return true
	else
		return false
	end
end

function var12_0.PlayMoveCard(arg0_21, arg1_21)
	arg1_21:SetInputPoint(arg0_21._clickToScenePoint)
	arg1_21:Precast()
	arg0_21._moveDeck:Remove(arg1_21)
end

function var12_0.CheckCardCastable(arg0_22, arg1_22)
	local var0_22 = arg1_22:GetTotalCost()
	local var1_22 = arg1_22:GetCastCondition() ~= false

	if var0_22 <= arg0_22._energy:GetCurrentEnergy() and var1_22 then
		return true
	end
end

function var12_0.CheckCardReturnable(arg0_23, arg1_23)
	local var0_23 = arg1_23:GetReturnCost()

	if var0_23 and var0_23 <= arg0_23._energy:GetCurrentEnergy() then
		return true
	end
end

function var12_0.SetDragingCard(arg0_24, arg1_24)
	arg0_24._dragingCard = arg1_24
end

function var12_0.GetDragingCard(arg0_25)
	return arg0_25._dragingCard
end

function var12_0.SendUpdateAim(arg0_26)
	local var0_26 = arg0_26._dragingCard and arg0_26._dragingCard:GetCardInfo():GetCardEffectTargetFilterList() or {}

	arg0_26._fleetVO:DispatchEvent(var0_0.Event.New(var3_0.UPDATE_CARD_TARGET_FILTER, {
		targetFilterList = var0_26
	}))
end

function var12_0.Start(arg0_27)
	arg0_27._fleetBuff:Trigger(var5_0.BuffEffectType.ON_START_GAME)

	for iter0_27, iter1_27 in pairs(var7_0.CustomAttrInitList) do
		arg0_27._fleetAttr:AddBaseAttr(iter0_27, iter1_27)
	end

	if arg0_27._customCombatID and var9_0.GetPuzzleDungeonTemplate(arg0_27._customCombatID) then
		local var0_27 = var9_0.GetPuzzleDungeonTemplate(arg0_27._customCombatID)
		local var1_27 = var0_27.deck

		for iter2_27, iter3_27 in ipairs(var1_27) do
			local var2_27 = arg0_27:GenerateCard(iter3_27)

			arg0_27._deck:Add(var2_27)
		end

		local var3_27 = var0_27.init_move
		local var4_27 = 0

		while var4_27 < var3_27 do
			local var5_27 = arg0_27:GenerateCard(var7_0.BASE_MOVE_ID)

			arg0_27._moveDeck:Add(var5_27)

			var4_27 = var4_27 + 1
		end

		if var0_27.init_shuffle ~= var0_0.Battle.BattleFleetCardPuzzleDeck.NOT_INIT_SHUFFLE then
			arg0_27._deck:Shuffle()
		end
	else
		arg0_27._deck:Shuffle()
	end

	arg0_27._energy:Start()
	arg0_27:TryDrawCard()
	arg0_27:SetClickEnable(true)
end

function var12_0.Update(arg0_28, arg1_28)
	arg0_28._energy:Update(arg1_28)
	arg0_28._fleetBuff:Update(arg1_28)
	arg0_28._cardPuzzleAA:Update(arg1_28)
	arg0_28:updateMoveDeck(arg1_28)
	arg0_28._hand:Update(arg1_28)
end

function var12_0.UpdateClickPos(arg0_29, arg1_29, arg2_29, arg3_29)
	var10_0 = var10_0 or var0_0.Battle.CardPuzzleBoardClicker

	if arg3_29 == var10_0.CLICK_STATE_CLICK then
		arg0_29._uiPoint:Set(arg1_29, arg2_29)
		var0_0.Battle.BattleVariable.UIPosToScenePos(arg0_29._uiPoint, arg0_29._clickToScenePoint)
		arg0_29._fleetVO:GetUnitBound():FixCardPuzzleInput(arg0_29._clickToScenePoint)
		arg0_29._clickToScenePointCache:Copy(arg0_29._clickToScenePoint)
		arg0_29._fleetVO:DispatchEvent(var0_0.Event.New(var3_0.ON_BOARD_CLICK, {
			click = arg3_29
		}))
	elseif arg3_29 == var10_0.CLICK_STATE_DRAG then
		arg0_29._uiPoint:Set(arg1_29, arg2_29)
		var0_0.Battle.BattleVariable.UIPosToScenePos(arg0_29._uiPoint, arg0_29._clickToScenePoint)
		arg0_29._fleetVO:GetUnitBound():FixCardPuzzleInput(arg0_29._clickToScenePoint)

		if not arg0_29._clickToScenePointCache:Equals(arg0_29._clickToScenePoint) then
			arg0_29._fleetVO:DispatchEvent(var0_0.Event.New(var3_0.ON_BOARD_CLICK, {
				click = arg3_29
			}))
		end

		arg0_29._clickToScenePointCache:Copy(arg0_29._clickToScenePoint)
	elseif arg3_29 == var10_0.CLICK_STATE_RELEASE then
		if arg0_29._clickEnable then
			local var0_29 = arg0_29._moveDeck:TryPlayTopMoveCard()

			if var0_29 then
				arg0_29:PlayMoveCard(var0_29)
			end
		end

		arg0_29._fleetVO:DispatchEvent(var0_0.Event.New(var3_0.ON_BOARD_CLICK, {
			click = arg3_29
		}))
	end
end

function var12_0.SetClickEnable(arg0_30, arg1_30)
	arg0_30._clickEnable = arg1_30
end

function var12_0.GetClickEnable(arg0_31)
	return arg0_31._clickEnable
end

function var12_0.BlockComponentByCard(arg0_32, arg1_32)
	arg1_32 = not arg1_32

	arg0_32:SetClickEnable(arg1_32)
	arg0_32:DispatchEvent(var0_0.Event.New(var3_0.COMMON_BUTTON_ENABLE, {
		flag = arg1_32
	}))
end

function var12_0.LongPressCard(arg0_33, arg1_33, arg2_33)
	if arg2_33 then
		arg0_33:DispatchEvent(var0_0.Event.New(var3_0.SHOW_CARD_DETAIL, {
			card = arg1_33
		}))
		arg0_33:DispatchBulletTime(0.1)
	else
		arg0_33:DispatchEvent(var0_0.Event.New(var3_0.SHOW_CARD_DETAIL, {}))
		arg0_33:DispatchBulletTime()
	end
end

function var12_0.DispatchBulletTime(arg0_34, arg1_34)
	if arg1_34 then
		var11_0.AppendIFFFactor(var6_0.FOE_CODE, "check_card", arg1_34)
		var11_0.AppendIFFFactor(var6_0.FRIENDLY_CODE, "check_card", arg1_34)
	else
		var11_0.RemoveIFFFactor(var6_0.FOE_CODE, "check_card")
		var11_0.RemoveIFFFactor(var6_0.FRIENDLY_CODE, "check_card")
	end

	arg0_34:DispatchEvent(var0_0.Event.New(var3_0.LONG_PRESS_BULLET_TIME, {
		timeScale = arg1_34
	}))
end

function var12_0.dispatchClick(arg0_35, arg1_35)
	if arg0_35._clickEnable then
		arg0_35._fleetVO:DispatchEvent(var0_0.Event.New(var3_0.ON_BOARD_CLICK, {
			click = arg1_35
		}))
	end
end

function var12_0.GetHand(arg0_36)
	return arg0_36._hand
end

function var12_0.GetDeck(arg0_37)
	return arg0_37._deck
end

function var12_0.GetRelicList(arg0_38)
	return arg0_38._relicList
end

function var12_0.GetTouchScreenPoint(arg0_39)
	return arg0_39._clickToScenePoint
end

function var12_0.GetMoveDeck(arg0_40)
	return arg0_40._moveDeck
end

function var12_0.GetCardPileByIndex(arg0_41, arg1_41)
	return arg0_41._cardPileList[arg1_41]
end

function var12_0.GetFleetVO(arg0_42)
	return arg0_42._fleetVO
end

function var12_0.GetAttrManager(arg0_43)
	return arg0_43._fleetAttr
end

function var12_0.GetBuffManager(arg0_44)
	return arg0_44._fleetBuff
end

function var12_0.GetCardPuzzleAAUnit(arg0_45)
	return arg0_45._cardPuzzleAA
end

function var12_0.TryDrawCard(arg0_46)
	while not arg0_46._hand:IsFull() and arg0_46._deck:GetLength() > 0 do
		local var0_46 = arg0_46._deck:Pop()

		arg0_46._hand:Add(var0_46)

		local var1_46 = var0_46:GetTotalCost()
		local var2_46 = arg0_46._energy:FillToCooldown(var1_46)

		var0_46:SetBaseEnergyFillDuration(var2_46)
	end
end

function var12_0.FlushHandOverheat(arg0_47)
	local var0_47 = arg0_47._hand:GetCardList()

	for iter0_47, iter1_47 in ipairs(var0_47) do
		local var1_47 = iter1_47:GetTotalCost()
		local var2_47 = arg0_47._energy:FillToCooldown(var1_47)

		iter1_47:SetBaseEnergyFillDuration(var2_47)
	end
end

function var12_0.HoldForInput(arg0_48, arg1_48)
	arg0_48._holdingCard = arg1_48
end

function var12_0.GenerateCard(arg0_49, arg1_49)
	local var0_49 = var0_0.Battle.BattleCardPuzzleCard.New(arg0_49)

	var0_49:SetCardTemplate(arg1_49)

	return var0_49
end

function var12_0.UpdateAttrByBuff(arg0_50, arg1_50, arg2_50)
	return
end

function var12_0.AddAttrBySkill(arg0_51, arg1_51, arg2_51)
	arg0_51._fleetAttr:AddBaseAttr(arg1_51, arg2_51)
end

function var12_0.UpdateAttrBySet(arg0_52, arg1_52, arg2_52)
	arg0_52._fleetAttr:SetAttr(arg1_52, arg2_52)
end

function var12_0.DispatchUpdateAttr(arg0_53, arg1_53)
	local var0_53 = var0_0.Event.New(var3_0.UPDATE_FLEET_ATTR, {
		attrName = arg1_53
	})

	arg0_53:DispatchEvent(var0_53)

	if arg0_53._dragingCard then
		arg0_53:SendUpdateAim()
	end
end

function var12_0.IsAAActive(arg0_54)
	return arg0_54._fleetAttr:GetCurrent("CardAntiaircraft") > 0
end

function var12_0.ConsumeAACounter(arg0_55, arg1_55)
	local var0_55 = (arg1_55 or 1) * -1

	arg0_55._fleetAttr:AddBaseAttr("CardAntiaircraft", var0_55)
end

function var12_0.init(arg0_56)
	arg0_56._maxCommonHP = 0
	arg0_56._currentCommonHP = 0
	arg0_56._fleetAttr = var0_0.Battle.BattleFleetCardPuzzleAttribute.New(arg0_56)
	arg0_56._fleetBuff = var0_0.Battle.BattleFleetCardPuzzleFleetBuffManager.New(arg0_56)
	arg0_56._energy = var0_0.Battle.BattleFleetCardPuzzleEnergy.New(arg0_56)
	arg0_56._deck = var0_0.Battle.BattleFleetCardPuzzleDeck.New(arg0_56, var12_0.CARD_PILE_INDEX_DECK)
	arg0_56._hand = var0_0.Battle.BattleFleetCardPuzzleHand.New(arg0_56, var12_0.CARD_PILE_INDEX_HAND)
	arg0_56._discard = var0_0.Battle.BattleFleetCardPuzzleDiscard.New(arg0_56, var12_0.CARD_PILE_INDEX_DISCARD)
	arg0_56._moveDeck = var0_0.Battle.BattleFleetCardPuzzleMoveDeck.New(arg0_56, var12_0.CARD_PILE_INDEX_MOVE_DECK)
	arg0_56._cardPileList = {
		[var12_0.CARD_PILE_INDEX_DISCARD] = arg0_56._discard,
		[var12_0.CARD_PILE_INDEX_HAND] = arg0_56._hand,
		[var12_0.CARD_PILE_INDEX_DECK] = arg0_56._deck,
		[var12_0.CARD_PILE_INDEX_MOVE_DECK] = arg0_56._moveDeck
	}
	arg0_56._uiPoint = Vector2.New(0, 0)
	arg0_56._clickToScenePoint = Vector3.New(0, 0, 0)
	arg0_56._clickToScenePointCache = Vector3.New(0, 0, 0)
	arg0_56._scoutUnit = nil
	arg0_56._mainUnit = nil
	arg0_56._relicList = {}
	arg0_56._cardPuzzleAA = var0_0.Battle.BattleFleetCardPuzzleAntiAirUnit.New(arg0_56)

	function arg0_56._fleetVO.GetFleetAntiAirWeapon()
		return arg0_56._cardPuzzleAA
	end

	arg0_56:initEvent()
end

function var12_0.initEvent(arg0_58)
	arg0_58._hand:RegisterEventListener(arg0_58, var3_0.UPDATE_CARDS, arg0_58.onUpdateHands)
	arg0_58._deck:RegisterEventListener(arg0_58, var3_0.UPDATE_CARDS, arg0_58.onUpdateDeck)
end

function var12_0.onUpdateHands(arg0_59, arg1_59)
	local var0_59 = arg0_59._hand:GetCardList()
	local var1_59 = {}

	for iter0_59, iter1_59 in ipairs(var0_59) do
		local var2_59 = iter1_59:GetLabels()

		for iter2_59, iter3_59 in ipairs(var2_59) do
			var1_59[iter3_59] = (var1_59[iter3_59] or 0) + 1
		end
	end

	arg0_59._fleetAttr:SetAttr("HandCount", #var0_59)

	for iter4_59, iter5_59 in pairs(var1_59) do
		arg0_59._fleetAttr:SetAttr(iter4_59 .. "LabelInHand", iter5_59)
	end

	local var3_59 = var0_0.Event.New(var3_0.UPDATE_FLEET_ATTR, {})

	arg0_59:DispatchEvent(var3_59)
end

function var12_0.onUpdateDeck(arg0_60, arg1_60)
	local var0_60 = arg0_60._deck:GetCardList()

	arg0_60._fleetAttr:SetAttr("DeckCount", #var0_60)

	local var1_60 = arg1_60.Data

	if var1_60.type == var0_0.Battle.BattleFleetCardPuzzleCardManageComponent.FUNC_NAME_ADD or var1_60.type == var0_0.Battle.BattleFleetCardPuzzleCardManageComponent.FUNC_NAME_BOTTOM then
		arg0_60:TryDrawCard()
	end
end

function var12_0.updateMoveDeck(arg0_61, arg1_61)
	arg0_61._moveDeck:Update(arg1_61)

	if arg0_61._moveDeck:GetGeneratePorcess() >= 1 then
		arg0_61._moveDeck:RestartGenrate()

		local var0_61 = arg0_61:GenerateCard(var7_0.BASE_MOVE_ID)

		arg0_61._moveDeck:Add(var0_61)
	end
end

function var12_0.onUpdateCommonHP(arg0_62, arg1_62)
	local var0_62 = arg1_62.Data.dHP

	arg0_62._currentCommonHP = math.clamp(arg0_62._currentCommonHP + var0_62, 0, arg0_62._maxCommonHP)
end
