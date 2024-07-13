ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.CardPuzzleCombatCard = class("CardPuzzleCombatCard", CardPuzzleCardView)

local var2_0 = var0_0.Battle.CardPuzzleCombatCard

var2_0.__name = "CardPuzzleCombatCard"
var2_0.CARD_SCALE = Vector3(0.57, 0.57, 0)
var2_0.DRAG_SCALE = Vector3(0.65, 0.65, 0)
var2_0.DRAW_SCALE = Vector3(0.2, 0.2, 0)
var2_0.SHUFFLE_SCALE = Vector3(0.1, 0.1, 0)
var2_0.RECYLE_POS = Vector3(10000, 10000, 0)
var2_0.STATE_LOCK = "STATE_LOCK"
var2_0.STATE_FREE = "STATE_FREE"
var2_0.STATE_DRAG = "STATE_DRAG"
var2_0.STATE_LONG_PRESS = "STATE_LONG_PRESS"
var2_0.BASE_LERP = 0.2

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._go = arg1_1.gameObject
	arg1_1.localScale = var2_0.CARD_SCALE
	arg0_1._moveLerp = 0.2
	arg0_1._pos = Vector3.zero
end

function var2_0.GetRarityBG(arg0_2, arg1_2)
	return "battle_card_bg_" .. arg1_2
end

function var2_0.GetCardCost(arg0_3)
	return arg0_3.data:GetTotalCost()
end

function var2_0.UpdateView(arg0_4)
	var2_0.super.UpdateView(arg0_4)

	arg0_4._coolDown = arg0_4._tf:Find("cooldown")
	arg0_4._coolDownProgress = arg0_4._coolDown:GetComponent(typeof(Image))
	arg0_4._canvaGroup = arg0_4._tf:GetComponent(typeof(CanvasGroup))
	arg0_4._boostHint = arg0_4._tf:Find("boost_hint")

	arg0_4:UpdateTotalCost()
	arg0_4:UpdateBoostHint()
end

function var2_0.Update(arg0_5)
	arg0_5:updateCoolDown()
	arg0_5:MoveToRefPos()
end

function var2_0.ShowGray(arg0_6, arg1_6)
	setGray(arg0_6._tf, arg1_6, true)
end

function var2_0.SetCardInfo(arg0_7, arg1_7)
	arg0_7._cardInfo = arg1_7

	arg0_7:SetData(arg0_7._cardInfo)
end

function var2_0.GetCardInfo(arg0_8)
	return arg0_8._cardInfo
end

function var2_0.DrawAnima(arg0_9, arg1_9)
	arg0_9:drawAlphaAndScale()

	arg0_9._tf.localPosition = arg1_9
end

function var2_0.GetUIPos(arg0_10)
	return arg0_10._tf.anchoredPosition
end

function var2_0.SetSibling(arg0_11, arg1_11)
	arg0_11._tf:SetSiblingIndex(arg1_11)
end

function var2_0.SetReferencePos(arg0_12, arg1_12)
	arg0_12._refPos = arg1_12
end

function var2_0.SetMoveLerp(arg0_13, arg1_13)
	arg0_13._moveLerp = arg1_13 or var2_0.BASE_LERP
end

function var2_0.MoveToRefPos(arg0_14)
	if arg0_14._tf.localPosition:Equals(arg0_14._refPos) then
		if arg0_14._moveToPointCallback then
			arg0_14:_moveToPointCallback()

			arg0_14._moveToPointCallback = nil
		end

		return
	end

	if arg0_14._moveLerp == 1 then
		arg0_14._pos:Copy(arg0_14._refPos)
	else
		local var0_14 = arg0_14._tf.localPosition
		local var1_14 = Vector2.Lerp(var0_14, arg0_14._refPos, arg0_14._moveLerp)

		arg0_14._pos:Copy(var1_14)
	end

	arg0_14._tf.localPosition = arg0_14._pos
end

function var2_0.SetToObjPoolRecylePos(arg0_15)
	arg0_15._tf.localPosition = var2_0.RECYLE_POS
end

function var2_0.MoveToDeck(arg0_16, arg1_16, arg2_16)
	arg0_16:shuffleBackAlphaAndScale()
	arg0_16:SetMoveLerp(0.8)

	arg0_16._refPos = arg2_16
	arg0_16._moveToPointCallback = arg1_16
end

function var2_0.GetState(arg0_17)
	return arg0_17._state
end

function var2_0.ChangeState(arg0_18, arg1_18)
	arg0_18._state = arg1_18
end

function var2_0.ConfigOP(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19, arg6_19)
	arg0_19._dragDelegate = GetOrAddComponent(arg0_19._go, "EventTriggerListener")

	arg0_19._dragDelegate:AddPointUpFunc(function(arg0_20, arg1_20)
		arg6_19()
	end)
	arg0_19._dragDelegate:AddBeginDragFunc(function(arg0_21, arg1_21)
		arg0_19:dragAlphaAndScale()
		arg2_19(arg0_19._cardInfo)
	end)
	arg0_19._dragDelegate:AddDragFunc(function(arg0_22, arg1_22)
		arg3_19(arg1_22.position)
	end)
	arg0_19._dragDelegate:AddDragEndFunc(function(arg0_23, arg1_23)
		arg0_19:resetAll()
		arg4_19()
	end)

	arg0_19._longPressDelegate = GetOrAddComponent(arg0_19._go, "UILongPressTrigger")
	arg0_19._longPressDelegate.longPressThreshold = 0.5

	arg0_19._longPressDelegate.onLongPressed:AddListener(function()
		arg5_19()
	end)
end

function var2_0.updateCoolDown(arg0_25)
	if arg0_25._cardInfo:GetCastRemainRate() > 0 then
		setActive(arg0_25._coolDown, true)

		arg0_25._coolDownProgress.fillAmount = arg0_25._cardInfo:GetCastRemainRate()
	else
		setActive(arg0_25._coolDown, false)
	end
end

function var2_0.change2ScrPos(arg0_26, arg1_26)
	local var0_26 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg0_26, arg1_26, var0_26))
end

function var2_0.UpdateDragPosition(arg0_27, arg1_27)
	local var0_27 = arg0_27.change2ScrPos(arg0_27._tf.parent, arg1_27)

	arg0_27:SetReferencePos(var0_27)
end

function var2_0.BlockRayCast(arg0_28, arg1_28)
	arg0_28._canvaGroup.blocksRaycasts = arg1_28
end

function var2_0.UpdateTotalCost(arg0_29)
	if arg0_29._cardInfo then
		setText(arg0_29.costTF, arg0_29.data:GetTotalCost())
	end
end

function var2_0.UpdateBoostHint(arg0_30)
	if arg0_30._cardInfo then
		setActive(arg0_30._boostHint, arg0_30._cardInfo:IsBoost())
	end
end

function var2_0.dragAlphaAndScale(arg0_31)
	LeanTween.cancel(arg0_31._go)
	LeanTween.scale(arg0_31._go, var2_0.DRAG_SCALE, 0.1)
	LeanTween.alphaCanvas(arg0_31._canvaGroup, 0.7, 0.1)
end

function var2_0.drawAlphaAndScale(arg0_32)
	LeanTween.cancel(arg0_32._go)

	arg0_32._tf.localScale = var2_0.DRAW_SCALE
	arg0_32._canvaGroup.alpha = 0.2

	LeanTween.scale(arg0_32._go, var2_0.CARD_SCALE, 0.2)
	LeanTween.alphaCanvas(arg0_32._canvaGroup, 1, 0.2)
end

function var2_0.shuffleBackAlphaAndScale(arg0_33)
	arg0_33:resetAll()
	LeanTween.scale(arg0_33._go, var2_0.SHUFFLE_SCALE, 0.2)
	LeanTween.alphaCanvas(arg0_33._canvaGroup, 0, 0.2)
end

function var2_0.resetAll(arg0_34)
	LeanTween.cancel(arg0_34._go)

	arg0_34._tf.localScale = var2_0.CARD_SCALE
	arg0_34._canvaGroup.alpha = 1
end
