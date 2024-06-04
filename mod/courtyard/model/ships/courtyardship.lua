local var0 = class("CourtYardShip", import("..map.CourtYardDepthItem"))

var0.STATE_IDLE = 0
var0.STATE_MOVE = 1
var0.STATE_MOVING_ZERO = 2
var0.STATE_MOVING_HALF = 3
var0.STATE_MOVING_ONE = 4
var0.STATE_DRAG = 5
var0.STATE_TOUCH = 6
var0.STATE_GETAWARD = 7
var0.STATE_STOP = 8
var0.STATE_INTERACT = 9
var0.STATE_CANCEL_INTERACT = 10

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg2.id
	arg0.configId = arg2.configId
	arg0.prefab = arg2:getPrefab()
	arg0.attachments = arg2:getAttachmentPrefab()
	arg0.inimacy = arg2.state_info_3 or 0
	arg0.coin = arg2.state_info_4 or 0
	arg0.skinId = arg2.skinId
	arg0.groupId = arg2.groupId
	arg0.config = pg.ship_data_statistics[arg0.configId]
	arg0.moveTime = math.floor(1 / arg0.config.backyard_speed)

	var0.super.Ctor(arg0, arg1, arg0.id, 1, 1)

	arg0.state = var0.STATE_IDLE
	arg0.moveCnt = 0
end

function var0.GetLevel(arg0)
	return 2
end

function var0.GetSkinID(arg0)
	return arg0.skinId
end

function var0.GetGroupID(arg0)
	return arg0.groupId
end

function var0.GetObjType(arg0)
	return CourtYardConst.OBJ_TYPE_SHIP
end

function var0.SetPosition(arg0, arg1)
	var0.super.SetPosition(arg0, arg1)

	if arg0.state == CourtYardShip.STATE_MOVING_HALF then
		return
	end

	arg0:DispatchEvent(CourtYardEvent.SHIP_POSITION_CHANGE, arg1, arg0:GetOffset())
end

function var0.InActivityRange(arg0, arg1)
	local var0 = arg0:GetHost():GetStorey():GetRange()

	return arg1.x < var0.x and arg1.y < var0.y and arg1.x >= 0 and arg1.y >= 0
end

function var0.GetDeathType(arg0)
	return CourtYardConst.DEPTH_TYPE_SHIP
end

function var0.GetShipType(arg0)
	return CourtYardConst.SHIP_TYPE_SELF
end

function var0._ChangeState(arg0, arg1, arg2)
	arg0.state = arg1

	arg0:DispatchEvent(CourtYardEvent.SHIP_STATE_CHANGE, arg1, arg2)
end

function var0.ChangeState(arg0, arg1, arg2)
	arg0:Clear()

	if arg1 == var0.STATE_IDLE then
		arg0:OnStateIdle()
	elseif arg1 == var0.STATE_MOVING_ONE then
		arg0:OnStateMoveOne()
	elseif (arg1 == var0.STATE_STOP or arg1 == var0.STATE_TOUCH or arg1 == var0.STATE_GETAWARD) and arg0.state == var0.STATE_INTERACT then
		-- block empty
	elseif arg1 == var0.STATE_INTERACT then
		arg0:OnInterAction(arg2)
	else
		arg0:_ChangeState(arg1)
	end
end

function var0.ShouldResetPosition(arg0)
	return arg0.state == var0.STATE_STOP or arg0.state == var0.STATE_CANCEL_INTERACT
end

function var0.WillInteraction(arg0)
	arg0:DispatchEvent(CourtYardEvent.SHIP_WILL_INTERACTION, slot)
end

function var0.StartInteraction(arg0, arg1, arg2)
	if arg2 then
		arg0.interactionSlot = arg1
	else
		arg0:ChangeState(CourtYardShip.STATE_INTERACT, arg1)
	end
end

function var0.UpdateInteraction(arg0, ...)
	arg0:DispatchEvent(CourtYardEvent.SHIP_UPDATE_INTERACTION, ...)
end

function var0.ClearInteraction(arg0, arg1, arg2, arg3)
	arg0.interactionSlot = nil

	if not arg3 then
		arg0:ChangeState(var0.STATE_CANCEL_INTERACT)
		arg0:DispatchEvent(CourtYardEvent.SHIP_STOP_INTERACTION, arg1)
	end
end

function var0.OnStateIdle(arg0)
	arg0:_ChangeState(var0.STATE_IDLE)

	arg0.timer = Timer.New(function()
		arg0.moveCnt = math.random(1, 5)

		arg0:_ChangeState(var0.STATE_MOVE)
	end, math.random(10, 20), 1)

	arg0.timer:Start()
end

function var0.OnStateMoveOne(arg0)
	arg0:_ChangeState(var0.STATE_MOVING_ONE)
	arg0:ClearMarkPosition()

	arg0.timer = Timer.New(function()
		arg0.moveCnt = arg0.moveCnt - 1

		if arg0.moveCnt <= 0 then
			arg0:ChangeState(var0.STATE_IDLE)
		else
			arg0:_ChangeState(var0.STATE_MOVE)
		end
	end, arg0.moveTime * 0.5, 1)

	arg0.timer:Start()
end

function var0.OnInterAction(arg0, arg1)
	arg0.interactionSlot = arg1

	arg0:_ChangeState(var0.STATE_INTERACT)
	arg0:DispatchEvent(CourtYardEvent.SHIP_START_INTERACTION, arg1)
end

function var0.GetInterActionData(arg0)
	return arg0.interactionSlot
end

function var0.Move(arg0, arg1)
	arg0:MarkPosition(arg1)
	arg0:ChangeState(var0.STATE_MOVING_ZERO)

	arg0.timer = Timer.New(function()
		arg0:ChangeState(var0.STATE_MOVING_HALF)
	end, arg0.moveTime * 0.5, 1)

	arg0.timer:Start()
	arg0:DispatchEvent(CourtYardEvent.SHIP_MOVE, arg1, arg0:GetOffset())
end

function var0.GetState(arg0)
	return arg0.state
end

function var0.GetPrefab(arg0)
	return arg0.prefab
end

function var0.getPrefab(arg0)
	return arg0:GetPrefab()
end

function var0.getAttachmentPrefab(arg0)
	return arg0.attachments
end

function var0.GetMoveTime(arg0)
	return arg0.moveTime
end

function var0.Clear(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.ChangeInimacy(arg0, arg1)
	arg0.inimacy = arg1

	arg0:DispatchEvent(CourtYardEvent.SHIP_INIMACY_CHANGE, arg1)
end

function var0.ChangeCoin(arg0, arg1)
	arg0.coin = arg1

	arg0:DispatchEvent(CourtYardEvent.SHIP_COIN_CHANGE, arg1)
end

function var0.ClearInimacy(arg0)
	local var0 = arg0.inimacy

	if var0 <= 0 then
		return
	end

	arg0:ChangeInimacy(0)
	arg0:ChangeState(var0.STATE_GETAWARD)
	arg0:DispatchEvent(CourtYardEvent.SHIP_GET_AWARD, var0, 2)
end

function var0.ClearCoin(arg0)
	local var0 = arg0.coin

	if var0 <= 0 then
		return
	end

	arg0:ChangeCoin(0)
	arg0:ChangeState(var0.STATE_GETAWARD)
	arg0:DispatchEvent(CourtYardEvent.SHIP_GET_AWARD, var0, 1)
end

function var0.AddExp(arg0, arg1)
	arg0:DispatchEvent(CourtYardEvent.SHIP_GET_AWARD, arg1, 3)
end

function var0.GetInterActionBgm(arg0)
	return nil
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:Clear()

	local var0 = arg0:GetInterActionData()

	if var0 then
		var0:Stop()
	end
end

return var0
