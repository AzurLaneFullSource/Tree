ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleCardPuzzleEvent
local var4 = var0.Battle.BattleFormulas
local var5 = var0.Battle.BattleConst
local var6 = var0.Battle.BattleConfig
local var7 = var0.Battle.BattleCardPuzzleConfig
local var8 = var0.Battle.BattleAttr
local var9 = var0.Battle.BattleDataFunction
local var10 = var0.Battle.CardPuzzleBoardClicker
local var11 = var0.Battle.BattleVariable
local var12 = class("BattleFleetCardPuzzleComponent")

var0.Battle.BattleFleetCardPuzzleComponent = var12
var12.__name = "BattleFleetCardPuzzleComponent"
var12.CARD_PILE_INDEX_DISCARD = -1
var12.CARD_PILE_INDEX_HAND = 0
var12.CARD_PILE_INDEX_DECK = 1
var12.CARD_PILE_INDEX_MOVE_DECK = 2

function var12.Ctor(arg0, arg1)
	var0.EventDispatcher.AttachEventDispatcher(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0._fleetVO = arg1

	arg0:init()
end

function var12.CustomConfigID(arg0, arg1)
	arg0._customCombatID = arg1

	arg0._energy:CustomConfig(arg0._customCombatID)
	arg0._moveDeck:CustomConfig(arg0._customCombatID)
end

function var12.Dispose(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
	var0.EventListener.DetachEventListener(arg0)

	arg0._fleetVO = nil
end

function var12.GetPuzzleDungeonID(arg0)
	return arg0._customCombatID
end

function var12.GetTotalCommonHP(arg0)
	return arg0._maxCommonHP
end

function var12.GetCurrentCommonHP(arg0)
	return arg0._currentCommonHP
end

function var12.GetEnergy(arg0)
	return arg0._energy
end

function var12.EnergyUpdate(arg0)
	arg0._fleetAttr:SetAttr("BaseEnergy", arg0._energy:GetCurrentEnergy())
end

function var12.AppendUnit(arg0, arg1)
	arg1:RegisterEventListener(arg0, var3.UPDATE_COMMON_HP, arg0.onUpdateCommonHP)

	arg0._maxCommonHP = arg0._maxCommonHP + arg1:GetAttrByName("maxHP")
	arg0._currentCommonHP = arg0._maxCommonHP

	local var0

	arg0._cardPuzzleAA:AppendCrewUnit(arg1)

	if arg1:IsMainFleetUnit() then
		arg0._mainUnit = arg1
		var0 = TeamType.TeamPos.FLAG_SHIP
	else
		arg0._scoutUnit = arg1

		arg0._cardPuzzleAA:SwitchHost(arg1)

		var0 = TeamType.TeamPos.LEADER
	end

	local var1 = var0.Event.New(var3.UPDATE_FLEET_SHIP, {
		teamType = var0
	})

	arg0:DispatchEvent(var1)
end

function var12.InitCardPuzzleData(arg0, arg1)
	arg0._fleetVO:GetUnitBound():SwtichDBRGL()

	local var0 = arg1.relicList

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg0._relicList, iter1)

		local var1 = iter1:GetEffects()

		for iter2, iter3 in ipairs(var1) do
			if iter3.type == CardPuzzleGift.EFFECT_TYPE.BATTLE_BUFF then
				for iter4, iter5 in ipairs(iter3.arg_list) do
					local var2 = var0.Battle.BattleFleetBuffUnit.New(iter5)

					arg0._fleetBuff:AttachCardPuzzleBuff(var2)
				end
			end
		end
	end
end

function var12.RemoveUnit(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var3.UPDATE_COMMON_HP)
end

function var12.GetMainUnit(arg0)
	return arg0._mainUnit
end

function var12.GetScoutUnit(arg0)
	return arg0._scoutUnit
end

function var12.AttachMoveController(arg0, arg1)
	arg0._moveController = arg1
end

function var12.TakeoverMovecontroller(arg0, arg1, arg2)
	arg0._moveController:InputTargetPoint(arg1, arg2)
	arg0._fleetVO:DispatchEvent(var0.Event.New(var3.FLEET_MOVE_TO, {
		pos = arg1
	}))
end

function var12.ReturnMovecontroller(arg0)
	arg0._fleetVO:DispatchEvent(var0.Event.New(var3.FLEET_MOVE_TO, {}))
end

function var12.PlayCard(arg0, arg1)
	if arg0:CheckCardCastable(arg1) then
		local function var0()
			local var0 = arg1:GetTotalCost()

			arg0._energy:ConsumeEnergy(var0)
			arg0._hand:Remove(arg1)
			arg0._hand:EnterCoolDownByType(arg1:GetCardType(), arg1:GetCardCD())

			if arg1:GetMoveAfterCast() == var12.CARD_PILE_INDEX_DISCARD then
				arg0._discard:Add(arg1)
			end

			arg0:TryDrawCard()
		end

		arg1:Precast(var0)

		return true
	else
		return false
	end
end

function var12.ReturnCard(arg0, arg1)
	if arg0:CheckCardReturnable(arg1) then
		local function var0()
			local var0 = arg1:GetReturnCost()

			arg0._energy:ConsumeEnergy(var0)
			arg0._hand:Remove(arg1)
			arg0:TryDrawCard()
		end

		arg1:Retrun(var0)

		return true
	else
		return false
	end
end

function var12.PlayMoveCard(arg0, arg1)
	arg1:SetInputPoint(arg0._clickToScenePoint)
	arg1:Precast()
	arg0._moveDeck:Remove(arg1)
end

function var12.CheckCardCastable(arg0, arg1)
	local var0 = arg1:GetTotalCost()
	local var1 = arg1:GetCastCondition() ~= false

	if var0 <= arg0._energy:GetCurrentEnergy() and var1 then
		return true
	end
end

function var12.CheckCardReturnable(arg0, arg1)
	local var0 = arg1:GetReturnCost()

	if var0 and var0 <= arg0._energy:GetCurrentEnergy() then
		return true
	end
end

function var12.SetDragingCard(arg0, arg1)
	arg0._dragingCard = arg1
end

function var12.GetDragingCard(arg0)
	return arg0._dragingCard
end

function var12.SendUpdateAim(arg0)
	local var0 = arg0._dragingCard and arg0._dragingCard:GetCardInfo():GetCardEffectTargetFilterList() or {}

	arg0._fleetVO:DispatchEvent(var0.Event.New(var3.UPDATE_CARD_TARGET_FILTER, {
		targetFilterList = var0
	}))
end

function var12.Start(arg0)
	arg0._fleetBuff:Trigger(var5.BuffEffectType.ON_START_GAME)

	for iter0, iter1 in pairs(var7.CustomAttrInitList) do
		arg0._fleetAttr:AddBaseAttr(iter0, iter1)
	end

	if arg0._customCombatID and var9.GetPuzzleDungeonTemplate(arg0._customCombatID) then
		local var0 = var9.GetPuzzleDungeonTemplate(arg0._customCombatID)
		local var1 = var0.deck

		for iter2, iter3 in ipairs(var1) do
			local var2 = arg0:GenerateCard(iter3)

			arg0._deck:Add(var2)
		end

		local var3 = var0.init_move
		local var4 = 0

		while var4 < var3 do
			local var5 = arg0:GenerateCard(var7.BASE_MOVE_ID)

			arg0._moveDeck:Add(var5)

			var4 = var4 + 1
		end

		if var0.init_shuffle ~= var0.Battle.BattleFleetCardPuzzleDeck.NOT_INIT_SHUFFLE then
			arg0._deck:Shuffle()
		end
	else
		arg0._deck:Shuffle()
	end

	arg0._energy:Start()
	arg0:TryDrawCard()
	arg0:SetClickEnable(true)
end

function var12.Update(arg0, arg1)
	arg0._energy:Update(arg1)
	arg0._fleetBuff:Update(arg1)
	arg0._cardPuzzleAA:Update(arg1)
	arg0:updateMoveDeck(arg1)
	arg0._hand:Update(arg1)
end

function var12.UpdateClickPos(arg0, arg1, arg2, arg3)
	var10 = var10 or var0.Battle.CardPuzzleBoardClicker

	if arg3 == var10.CLICK_STATE_CLICK then
		arg0._uiPoint:Set(arg1, arg2)
		var0.Battle.BattleVariable.UIPosToScenePos(arg0._uiPoint, arg0._clickToScenePoint)
		arg0._fleetVO:GetUnitBound():FixCardPuzzleInput(arg0._clickToScenePoint)
		arg0._clickToScenePointCache:Copy(arg0._clickToScenePoint)
		arg0._fleetVO:DispatchEvent(var0.Event.New(var3.ON_BOARD_CLICK, {
			click = arg3
		}))
	elseif arg3 == var10.CLICK_STATE_DRAG then
		arg0._uiPoint:Set(arg1, arg2)
		var0.Battle.BattleVariable.UIPosToScenePos(arg0._uiPoint, arg0._clickToScenePoint)
		arg0._fleetVO:GetUnitBound():FixCardPuzzleInput(arg0._clickToScenePoint)

		if not arg0._clickToScenePointCache:Equals(arg0._clickToScenePoint) then
			arg0._fleetVO:DispatchEvent(var0.Event.New(var3.ON_BOARD_CLICK, {
				click = arg3
			}))
		end

		arg0._clickToScenePointCache:Copy(arg0._clickToScenePoint)
	elseif arg3 == var10.CLICK_STATE_RELEASE then
		if arg0._clickEnable then
			local var0 = arg0._moveDeck:TryPlayTopMoveCard()

			if var0 then
				arg0:PlayMoveCard(var0)
			end
		end

		arg0._fleetVO:DispatchEvent(var0.Event.New(var3.ON_BOARD_CLICK, {
			click = arg3
		}))
	end
end

function var12.SetClickEnable(arg0, arg1)
	arg0._clickEnable = arg1
end

function var12.GetClickEnable(arg0)
	return arg0._clickEnable
end

function var12.BlockComponentByCard(arg0, arg1)
	arg1 = not arg1

	arg0:SetClickEnable(arg1)
	arg0:DispatchEvent(var0.Event.New(var3.COMMON_BUTTON_ENABLE, {
		flag = arg1
	}))
end

function var12.LongPressCard(arg0, arg1, arg2)
	if arg2 then
		arg0:DispatchEvent(var0.Event.New(var3.SHOW_CARD_DETAIL, {
			card = arg1
		}))
		arg0:DispatchBulletTime(0.1)
	else
		arg0:DispatchEvent(var0.Event.New(var3.SHOW_CARD_DETAIL, {}))
		arg0:DispatchBulletTime()
	end
end

function var12.DispatchBulletTime(arg0, arg1)
	if arg1 then
		var11.AppendIFFFactor(var6.FOE_CODE, "check_card", arg1)
		var11.AppendIFFFactor(var6.FRIENDLY_CODE, "check_card", arg1)
	else
		var11.RemoveIFFFactor(var6.FOE_CODE, "check_card")
		var11.RemoveIFFFactor(var6.FRIENDLY_CODE, "check_card")
	end

	arg0:DispatchEvent(var0.Event.New(var3.LONG_PRESS_BULLET_TIME, {
		timeScale = arg1
	}))
end

function var12.dispatchClick(arg0, arg1)
	if arg0._clickEnable then
		arg0._fleetVO:DispatchEvent(var0.Event.New(var3.ON_BOARD_CLICK, {
			click = arg1
		}))
	end
end

function var12.GetHand(arg0)
	return arg0._hand
end

function var12.GetDeck(arg0)
	return arg0._deck
end

function var12.GetRelicList(arg0)
	return arg0._relicList
end

function var12.GetTouchScreenPoint(arg0)
	return arg0._clickToScenePoint
end

function var12.GetMoveDeck(arg0)
	return arg0._moveDeck
end

function var12.GetCardPileByIndex(arg0, arg1)
	return arg0._cardPileList[arg1]
end

function var12.GetFleetVO(arg0)
	return arg0._fleetVO
end

function var12.GetAttrManager(arg0)
	return arg0._fleetAttr
end

function var12.GetBuffManager(arg0)
	return arg0._fleetBuff
end

function var12.GetCardPuzzleAAUnit(arg0)
	return arg0._cardPuzzleAA
end

function var12.TryDrawCard(arg0)
	while not arg0._hand:IsFull() and arg0._deck:GetLength() > 0 do
		local var0 = arg0._deck:Pop()

		arg0._hand:Add(var0)

		local var1 = var0:GetTotalCost()
		local var2 = arg0._energy:FillToCooldown(var1)

		var0:SetBaseEnergyFillDuration(var2)
	end
end

function var12.FlushHandOverheat(arg0)
	local var0 = arg0._hand:GetCardList()

	for iter0, iter1 in ipairs(var0) do
		local var1 = iter1:GetTotalCost()
		local var2 = arg0._energy:FillToCooldown(var1)

		iter1:SetBaseEnergyFillDuration(var2)
	end
end

function var12.HoldForInput(arg0, arg1)
	arg0._holdingCard = arg1
end

function var12.GenerateCard(arg0, arg1)
	local var0 = var0.Battle.BattleCardPuzzleCard.New(arg0)

	var0:SetCardTemplate(arg1)

	return var0
end

function var12.UpdateAttrByBuff(arg0, arg1, arg2)
	return
end

function var12.AddAttrBySkill(arg0, arg1, arg2)
	arg0._fleetAttr:AddBaseAttr(arg1, arg2)
end

function var12.UpdateAttrBySet(arg0, arg1, arg2)
	arg0._fleetAttr:SetAttr(arg1, arg2)
end

function var12.DispatchUpdateAttr(arg0, arg1)
	local var0 = var0.Event.New(var3.UPDATE_FLEET_ATTR, {
		attrName = arg1
	})

	arg0:DispatchEvent(var0)

	if arg0._dragingCard then
		arg0:SendUpdateAim()
	end
end

function var12.IsAAActive(arg0)
	return arg0._fleetAttr:GetCurrent("CardAntiaircraft") > 0
end

function var12.ConsumeAACounter(arg0, arg1)
	local var0 = (arg1 or 1) * -1

	arg0._fleetAttr:AddBaseAttr("CardAntiaircraft", var0)
end

function var12.init(arg0)
	arg0._maxCommonHP = 0
	arg0._currentCommonHP = 0
	arg0._fleetAttr = var0.Battle.BattleFleetCardPuzzleAttribute.New(arg0)
	arg0._fleetBuff = var0.Battle.BattleFleetCardPuzzleFleetBuffManager.New(arg0)
	arg0._energy = var0.Battle.BattleFleetCardPuzzleEnergy.New(arg0)
	arg0._deck = var0.Battle.BattleFleetCardPuzzleDeck.New(arg0, var12.CARD_PILE_INDEX_DECK)
	arg0._hand = var0.Battle.BattleFleetCardPuzzleHand.New(arg0, var12.CARD_PILE_INDEX_HAND)
	arg0._discard = var0.Battle.BattleFleetCardPuzzleDiscard.New(arg0, var12.CARD_PILE_INDEX_DISCARD)
	arg0._moveDeck = var0.Battle.BattleFleetCardPuzzleMoveDeck.New(arg0, var12.CARD_PILE_INDEX_MOVE_DECK)
	arg0._cardPileList = {
		[var12.CARD_PILE_INDEX_DISCARD] = arg0._discard,
		[var12.CARD_PILE_INDEX_HAND] = arg0._hand,
		[var12.CARD_PILE_INDEX_DECK] = arg0._deck,
		[var12.CARD_PILE_INDEX_MOVE_DECK] = arg0._moveDeck
	}
	arg0._uiPoint = Vector2.New(0, 0)
	arg0._clickToScenePoint = Vector3.New(0, 0, 0)
	arg0._clickToScenePointCache = Vector3.New(0, 0, 0)
	arg0._scoutUnit = nil
	arg0._mainUnit = nil
	arg0._relicList = {}
	arg0._cardPuzzleAA = var0.Battle.BattleFleetCardPuzzleAntiAirUnit.New(arg0)

	function arg0._fleetVO.GetFleetAntiAirWeapon()
		return arg0._cardPuzzleAA
	end

	arg0:initEvent()
end

function var12.initEvent(arg0)
	arg0._hand:RegisterEventListener(arg0, var3.UPDATE_CARDS, arg0.onUpdateHands)
	arg0._deck:RegisterEventListener(arg0, var3.UPDATE_CARDS, arg0.onUpdateDeck)
end

function var12.onUpdateHands(arg0, arg1)
	local var0 = arg0._hand:GetCardList()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1:GetLabels()

		for iter2, iter3 in ipairs(var2) do
			var1[iter3] = (var1[iter3] or 0) + 1
		end
	end

	arg0._fleetAttr:SetAttr("HandCount", #var0)

	for iter4, iter5 in pairs(var1) do
		arg0._fleetAttr:SetAttr(iter4 .. "LabelInHand", iter5)
	end

	local var3 = var0.Event.New(var3.UPDATE_FLEET_ATTR, {})

	arg0:DispatchEvent(var3)
end

function var12.onUpdateDeck(arg0, arg1)
	local var0 = arg0._deck:GetCardList()

	arg0._fleetAttr:SetAttr("DeckCount", #var0)

	local var1 = arg1.Data

	if var1.type == var0.Battle.BattleFleetCardPuzzleCardManageComponent.FUNC_NAME_ADD or var1.type == var0.Battle.BattleFleetCardPuzzleCardManageComponent.FUNC_NAME_BOTTOM then
		arg0:TryDrawCard()
	end
end

function var12.updateMoveDeck(arg0, arg1)
	arg0._moveDeck:Update(arg1)

	if arg0._moveDeck:GetGeneratePorcess() >= 1 then
		arg0._moveDeck:RestartGenrate()

		local var0 = arg0:GenerateCard(var7.BASE_MOVE_ID)

		arg0._moveDeck:Add(var0)
	end
end

function var12.onUpdateCommonHP(arg0, arg1)
	local var0 = arg1.Data.dHP

	arg0._currentCommonHP = math.clamp(arg0._currentCommonHP + var0, 0, arg0._maxCommonHP)
end
