local var0_0 = class("CourtYardShip", import("..map.CourtYardDepthItem"))

var0_0.STATE_IDLE = 0
var0_0.STATE_MOVE = 1
var0_0.STATE_MOVING_ZERO = 2
var0_0.STATE_MOVING_HALF = 3
var0_0.STATE_MOVING_ONE = 4
var0_0.STATE_DRAG = 5
var0_0.STATE_TOUCH = 6
var0_0.STATE_GETAWARD = 7
var0_0.STATE_STOP = 8
var0_0.STATE_INTERACT = 9
var0_0.STATE_CANCEL_INTERACT = 10

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.id = arg2_1.id
	arg0_1.configId = arg2_1.configId
	arg0_1.prefab = arg2_1:getPrefab()
	arg0_1.attachments = arg2_1:getAttachmentPrefab()
	arg0_1.inimacy = arg4_1 or 0
	arg0_1.coin = arg3_1 or 0
	arg0_1.skinId = arg2_1.skinId
	arg0_1.groupId = arg2_1.groupId
	arg0_1.config = pg.ship_data_statistics[arg0_1.configId]
	arg0_1.moveTime = math.floor(1 / arg0_1.config.backyard_speed)

	var0_0.super.Ctor(arg0_1, arg1_1, arg0_1.id, 1, 1)

	arg0_1.state = var0_0.STATE_IDLE
	arg0_1.moveCnt = 0
	arg0_1.sideIndex = 0
end

function var0_0.GetLevel(arg0_2)
	return 2
end

function var0_0.GetSkinID(arg0_3)
	return arg0_3.skinId
end

function var0_0.GetGroupID(arg0_4)
	return arg0_4.groupId
end

function var0_0.GetObjType(arg0_5)
	return CourtYardConst.OBJ_TYPE_SHIP
end

function var0_0.SetPosition(arg0_6, arg1_6)
	var0_0.super.SetPosition(arg0_6, arg1_6)

	if arg0_6.state == CourtYardShip.STATE_MOVING_HALF then
		return
	end

	arg0_6:DispatchEvent(CourtYardEvent.SHIP_POSITION_CHANGE, arg1_6, arg0_6:GetOffset())
end

function var0_0.InActivityRange(arg0_7, arg1_7)
	local var0_7 = arg0_7:GetHost():GetStorey():GetRange()

	return arg1_7.x < var0_7.x and arg1_7.y < var0_7.y and arg1_7.x >= 0 and arg1_7.y >= 0
end

function var0_0.GetDeathType(arg0_8)
	return CourtYardConst.DEPTH_TYPE_SHIP
end

function var0_0.GetShipType(arg0_9)
	return CourtYardConst.SHIP_TYPE_SELF
end

function var0_0._ChangeState(arg0_10, arg1_10, arg2_10)
	arg0_10.state = arg1_10

	arg0_10:DispatchEvent(CourtYardEvent.SHIP_STATE_CHANGE, arg1_10, arg2_10)
end

function var0_0.ChangeState(arg0_11, arg1_11, arg2_11)
	arg0_11:Clear()

	if arg1_11 == var0_0.STATE_IDLE then
		arg0_11:OnStateIdle()
	elseif arg1_11 == var0_0.STATE_MOVING_ONE then
		arg0_11:OnStateMoveOne()
	elseif (arg1_11 == var0_0.STATE_STOP or arg1_11 == var0_0.STATE_TOUCH or arg1_11 == var0_0.STATE_GETAWARD) and arg0_11.state == var0_0.STATE_INTERACT then
		-- block empty
	elseif arg1_11 == var0_0.STATE_INTERACT then
		arg0_11:OnInterAction(arg2_11)
	else
		arg0_11:_ChangeState(arg1_11)
	end
end

function var0_0.ShouldResetPosition(arg0_12)
	return arg0_12.state == var0_0.STATE_STOP or arg0_12.state == var0_0.STATE_CANCEL_INTERACT
end

function var0_0.WillInteraction(arg0_13)
	arg0_13:DispatchEvent(CourtYardEvent.SHIP_WILL_INTERACTION, slot)
end

function var0_0.StartInteraction(arg0_14, arg1_14, arg2_14)
	if arg2_14 then
		arg0_14.interactionSlot = arg1_14
	else
		arg0_14:ChangeState(CourtYardShip.STATE_INTERACT, arg1_14)
	end
end

function var0_0.OnPreheatActionEnd(arg0_15)
	return
end

function var0_0.UpdateInteraction(arg0_16, ...)
	arg0_16:DispatchEvent(CourtYardEvent.SHIP_UPDATE_INTERACTION, ...)
end

function var0_0.ClearInteraction(arg0_17, arg1_17, arg2_17, arg3_17)
	arg0_17.interactionSlot = nil

	if not arg3_17 then
		arg0_17:ChangeState(var0_0.STATE_CANCEL_INTERACT)
		arg0_17:DispatchEvent(CourtYardEvent.SHIP_STOP_INTERACTION, arg1_17)
	end
end

function var0_0.OnStateIdle(arg0_18)
	arg0_18:_ChangeState(var0_0.STATE_IDLE)

	arg0_18.timer = Timer.New(function()
		arg0_18.moveCnt = math.random(1, 5)

		arg0_18:_ChangeState(var0_0.STATE_MOVE)
	end, math.random(10, 20), 1)

	arg0_18.timer:Start()
end

function var0_0.OnStateMoveOne(arg0_20)
	arg0_20:_ChangeState(var0_0.STATE_MOVING_ONE)
	arg0_20:ClearMarkPosition()

	arg0_20.timer = Timer.New(function()
		arg0_20.moveCnt = arg0_20.moveCnt - 1

		if arg0_20.moveCnt <= 0 then
			arg0_20:ChangeState(var0_0.STATE_IDLE)
		else
			arg0_20:_ChangeState(var0_0.STATE_MOVE)
		end
	end, arg0_20.moveTime * 0.5, 1)

	arg0_20.timer:Start()
end

function var0_0.OnInterAction(arg0_22, arg1_22)
	arg0_22.interactionSlot = arg1_22

	arg0_22:_ChangeState(var0_0.STATE_INTERACT)
	arg0_22:DispatchEvent(CourtYardEvent.SHIP_START_INTERACTION, arg1_22)
end

function var0_0.GetInterActionData(arg0_23)
	return arg0_23.interactionSlot
end

function var0_0.Move(arg0_24, arg1_24)
	arg0_24:MarkPosition(arg1_24)
	arg0_24:ChangeState(var0_0.STATE_MOVING_ZERO)

	arg0_24.timer = Timer.New(function()
		arg0_24:ChangeState(var0_0.STATE_MOVING_HALF)
	end, arg0_24.moveTime * 0.5, 1)

	arg0_24.timer:Start()
	arg0_24:DispatchEvent(CourtYardEvent.SHIP_MOVE, arg1_24, arg0_24:GetOffset())
end

function var0_0.GetState(arg0_26)
	return arg0_26.state
end

function var0_0.GetPrefab(arg0_27)
	local var0_27 = pg.ship_skin_template[arg0_27.skinId]

	assert(var0_27, "ship_skin_template not exist: " .. arg0_27.configId .. " " .. arg0_27.skinId)

	if var0_27.double_char and var0_27.double_char == 1 and arg0_27.sideIndex and arg0_27.sideIndex ~= 0 then
		local var1_27

		if arg0_27.sideIndex == 1 then
			return arg0_27.prefab .. "_L"
		elseif arg0_27.sideIndex == 2 then
			return arg0_27.prefab .. "_R"
		end
	end

	return arg0_27.prefab
end

function var0_0.getPrefab(arg0_28)
	return arg0_28:GetPrefab()
end

function var0_0.SetSide(arg0_29, arg1_29)
	arg0_29.sideIndex = arg1_29
end

function var0_0.GetSide(arg0_30, arg1_30)
	return arg0_30.sideIndex
end

function var0_0.IsDoubleSkin(arg0_31)
	local var0_31 = pg.ship_skin_template[arg0_31.skinId]

	assert(var0_31, "ship_skin_template not exist: " .. arg0_31.configId .. " " .. arg0_31.skinId)

	return var0_31.double_char and var0_31.double_char == 1 or false
end

function var0_0.getAttachmentPrefab(arg0_32)
	return arg0_32.attachments
end

function var0_0.GetMoveTime(arg0_33)
	return arg0_33.moveTime
end

function var0_0.Clear(arg0_34)
	if arg0_34.timer then
		arg0_34.timer:Stop()

		arg0_34.timer = nil
	end
end

function var0_0.ChangeInimacy(arg0_35, arg1_35)
	arg0_35.inimacy = arg1_35

	arg0_35:DispatchEvent(CourtYardEvent.SHIP_INIMACY_CHANGE, arg1_35)
end

function var0_0.ChangeCoin(arg0_36, arg1_36)
	arg0_36.coin = arg1_36

	arg0_36:DispatchEvent(CourtYardEvent.SHIP_COIN_CHANGE, arg1_36)
end

function var0_0.ClearInimacy(arg0_37)
	local var0_37 = arg0_37.inimacy

	if var0_37 <= 0 then
		return
	end

	arg0_37:ChangeInimacy(0)
	arg0_37:ChangeState(var0_0.STATE_GETAWARD)
	arg0_37:DispatchEvent(CourtYardEvent.SHIP_GET_AWARD, var0_37, 2)
end

function var0_0.ClearCoin(arg0_38)
	local var0_38 = arg0_38.coin

	if var0_38 <= 0 then
		return
	end

	arg0_38:ChangeCoin(0)
	arg0_38:ChangeState(var0_0.STATE_GETAWARD)
	arg0_38:DispatchEvent(CourtYardEvent.SHIP_GET_AWARD, var0_38, 1)
end

function var0_0.AddExp(arg0_39, arg1_39)
	arg0_39:DispatchEvent(CourtYardEvent.SHIP_GET_AWARD, arg1_39, 3)
end

function var0_0.GetInterActionBgm(arg0_40)
	return nil
end

function var0_0.Dispose(arg0_41)
	var0_0.super.Dispose(arg0_41)
	arg0_41:Clear()

	local var0_41 = arg0_41:GetInterActionData()

	if var0_41 then
		var0_41:Stop()
	end
end

return var0_0
