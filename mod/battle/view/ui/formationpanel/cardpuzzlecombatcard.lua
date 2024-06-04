ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.CardPuzzleCombatCard = class("CardPuzzleCombatCard", CardPuzzleCardView)

local var2 = var0.Battle.CardPuzzleCombatCard

var2.__name = "CardPuzzleCombatCard"
var2.CARD_SCALE = Vector3(0.57, 0.57, 0)
var2.DRAG_SCALE = Vector3(0.65, 0.65, 0)
var2.DRAW_SCALE = Vector3(0.2, 0.2, 0)
var2.SHUFFLE_SCALE = Vector3(0.1, 0.1, 0)
var2.RECYLE_POS = Vector3(10000, 10000, 0)
var2.STATE_LOCK = "STATE_LOCK"
var2.STATE_FREE = "STATE_FREE"
var2.STATE_DRAG = "STATE_DRAG"
var2.STATE_LONG_PRESS = "STATE_LONG_PRESS"
var2.BASE_LERP = 0.2

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)

	arg0._go = arg1.gameObject
	arg1.localScale = var2.CARD_SCALE
	arg0._moveLerp = 0.2
	arg0._pos = Vector3.zero
end

function var2.GetRarityBG(arg0, arg1)
	return "battle_card_bg_" .. arg1
end

function var2.GetCardCost(arg0)
	return arg0.data:GetTotalCost()
end

function var2.UpdateView(arg0)
	var2.super.UpdateView(arg0)

	arg0._coolDown = arg0._tf:Find("cooldown")
	arg0._coolDownProgress = arg0._coolDown:GetComponent(typeof(Image))
	arg0._canvaGroup = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0._boostHint = arg0._tf:Find("boost_hint")

	arg0:UpdateTotalCost()
	arg0:UpdateBoostHint()
end

function var2.Update(arg0)
	arg0:updateCoolDown()
	arg0:MoveToRefPos()
end

function var2.ShowGray(arg0, arg1)
	setGray(arg0._tf, arg1, true)
end

function var2.SetCardInfo(arg0, arg1)
	arg0._cardInfo = arg1

	arg0:SetData(arg0._cardInfo)
end

function var2.GetCardInfo(arg0)
	return arg0._cardInfo
end

function var2.DrawAnima(arg0, arg1)
	arg0:drawAlphaAndScale()

	arg0._tf.localPosition = arg1
end

function var2.GetUIPos(arg0)
	return arg0._tf.anchoredPosition
end

function var2.SetSibling(arg0, arg1)
	arg0._tf:SetSiblingIndex(arg1)
end

function var2.SetReferencePos(arg0, arg1)
	arg0._refPos = arg1
end

function var2.SetMoveLerp(arg0, arg1)
	arg0._moveLerp = arg1 or var2.BASE_LERP
end

function var2.MoveToRefPos(arg0)
	if arg0._tf.localPosition:Equals(arg0._refPos) then
		if arg0._moveToPointCallback then
			arg0:_moveToPointCallback()

			arg0._moveToPointCallback = nil
		end

		return
	end

	if arg0._moveLerp == 1 then
		arg0._pos:Copy(arg0._refPos)
	else
		local var0 = arg0._tf.localPosition
		local var1 = Vector2.Lerp(var0, arg0._refPos, arg0._moveLerp)

		arg0._pos:Copy(var1)
	end

	arg0._tf.localPosition = arg0._pos
end

function var2.SetToObjPoolRecylePos(arg0)
	arg0._tf.localPosition = var2.RECYLE_POS
end

function var2.MoveToDeck(arg0, arg1, arg2)
	arg0:shuffleBackAlphaAndScale()
	arg0:SetMoveLerp(0.8)

	arg0._refPos = arg2
	arg0._moveToPointCallback = arg1
end

function var2.GetState(arg0)
	return arg0._state
end

function var2.ChangeState(arg0, arg1)
	arg0._state = arg1
end

function var2.ConfigOP(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0._dragDelegate = GetOrAddComponent(arg0._go, "EventTriggerListener")

	arg0._dragDelegate:AddPointUpFunc(function(arg0, arg1)
		arg6()
	end)
	arg0._dragDelegate:AddBeginDragFunc(function(arg0, arg1)
		arg0:dragAlphaAndScale()
		arg2(arg0._cardInfo)
	end)
	arg0._dragDelegate:AddDragFunc(function(arg0, arg1)
		arg3(arg1.position)
	end)
	arg0._dragDelegate:AddDragEndFunc(function(arg0, arg1)
		arg0:resetAll()
		arg4()
	end)

	arg0._longPressDelegate = GetOrAddComponent(arg0._go, "UILongPressTrigger")
	arg0._longPressDelegate.longPressThreshold = 0.5

	arg0._longPressDelegate.onLongPressed:AddListener(function()
		arg5()
	end)
end

function var2.updateCoolDown(arg0)
	if arg0._cardInfo:GetCastRemainRate() > 0 then
		setActive(arg0._coolDown, true)

		arg0._coolDownProgress.fillAmount = arg0._cardInfo:GetCastRemainRate()
	else
		setActive(arg0._coolDown, false)
	end
end

function var2.change2ScrPos(arg0, arg1)
	local var0 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg0, arg1, var0))
end

function var2.UpdateDragPosition(arg0, arg1)
	local var0 = arg0.change2ScrPos(arg0._tf.parent, arg1)

	arg0:SetReferencePos(var0)
end

function var2.BlockRayCast(arg0, arg1)
	arg0._canvaGroup.blocksRaycasts = arg1
end

function var2.UpdateTotalCost(arg0)
	if arg0._cardInfo then
		setText(arg0.costTF, arg0.data:GetTotalCost())
	end
end

function var2.UpdateBoostHint(arg0)
	if arg0._cardInfo then
		setActive(arg0._boostHint, arg0._cardInfo:IsBoost())
	end
end

function var2.dragAlphaAndScale(arg0)
	LeanTween.cancel(arg0._go)
	LeanTween.scale(arg0._go, var2.DRAG_SCALE, 0.1)
	LeanTween.alphaCanvas(arg0._canvaGroup, 0.7, 0.1)
end

function var2.drawAlphaAndScale(arg0)
	LeanTween.cancel(arg0._go)

	arg0._tf.localScale = var2.DRAW_SCALE
	arg0._canvaGroup.alpha = 0.2

	LeanTween.scale(arg0._go, var2.CARD_SCALE, 0.2)
	LeanTween.alphaCanvas(arg0._canvaGroup, 1, 0.2)
end

function var2.shuffleBackAlphaAndScale(arg0)
	arg0:resetAll()
	LeanTween.scale(arg0._go, var2.SHUFFLE_SCALE, 0.2)
	LeanTween.alphaCanvas(arg0._canvaGroup, 0, 0.2)
end

function var2.resetAll(arg0)
	LeanTween.cancel(arg0._go)

	arg0._tf.localScale = var2.CARD_SCALE
	arg0._canvaGroup.alpha = 1
end
