local var0_0 = class("CourtYardStorey", import("..map.CourtYardPlaceableArea"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg4_1)

	arg0_1.id = arg2_1
	arg0_1.style = arg3_1
	arg0_1.level = 1
	arg0_1.furnitures = {}
	arg0_1.ships = {}
	arg0_1.canEidt = false
	arg0_1.recoder = CourtYardStoreyRecorder.New(arg0_1)
	arg0_1.composeChecker = CourtYardStoreyComposeChecker.New(arg0_1)
end

function var0_0.GetStyle(arg0_2)
	return arg0_2.style
end

function var0_0.SetLevel(arg0_3, arg1_3)
	arg0_3.level = arg1_3

	local var0_3 = CourtYardConst.MAX_STOREY_LEVEL * CourtYardConst.OPEN_AREA_PRE_LEVEL - (arg0_3.level - 1) * CourtYardConst.OPEN_AREA_PRE_LEVEL

	arg0_3:UpdateMinRange(Vector2(var0_3, var0_3))
	arg0_3:DispatchEvent(CourtYardEvent.UPDATE_STOREY, arg1_3)
end

function var0_0.LevelUp(arg0_4)
	local var0_4 = arg0_4.level + 1

	arg0_4:SetLevel(var0_4)
	arg0_4:DispatchEvent(CourtYardEvent.UPDATE_FLOORPAPER, arg0_4.floorPaper)
	arg0_4:DispatchEvent(CourtYardEvent.UPDATE_WALLPAPER, arg0_4.wallPaper)
end

function var0_0.SetWallPaper(arg0_5, arg1_5)
	arg0_5.wallPaper = arg1_5

	arg0_5:DispatchEvent(CourtYardEvent.UPDATE_WALLPAPER, arg1_5)
	arg0_5.composeChecker:Check()
end

function var0_0.SetFloorPaper(arg0_6, arg1_6)
	arg0_6.floorPaper = arg1_6

	arg0_6:DispatchEvent(CourtYardEvent.UPDATE_FLOORPAPER, arg1_6)
	arg0_6.composeChecker:Check()
end

function var0_0.GetWallPaper(arg0_7)
	return arg0_7.wallPaper
end

function var0_0.GetFloorPaper(arg0_8)
	return arg0_8.floorPaper
end

function var0_0.GetFurnitures(arg0_9)
	return arg0_9.furnitures
end

function var0_0.GetAllFurniture(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.furnitures) do
		var0_10[iter1_10.id] = iter1_10
	end

	if arg0_10.floorPaper then
		var0_10[arg0_10.floorPaper.id] = arg0_10.floorPaper
	end

	if arg0_10.wallPaper then
		var0_10[arg0_10.wallPaper.id] = arg0_10.wallPaper
	end

	return var0_10
end

function var0_0.GetShips(arg0_11)
	return arg0_11.ships
end

function var0_0.GetShip(arg0_12, arg1_12)
	return arg0_12.ships[arg1_12]
end

function var0_0.GetFurniture(arg0_13, arg1_13)
	return arg0_13.furnitures[arg1_13]
end

function var0_0.CanAddFurniture(arg0_14, arg1_14)
	return true
end

function var0_0.AddFurniture(arg0_15, arg1_15, arg2_15)
	arg0_15.furnitures[arg1_15.id] = arg1_15

	arg0_15:DispatchEvent(CourtYardEvent.CREATE_ITEM, arg1_15, arg2_15)
	arg0_15:AddItem(arg1_15)
	arg0_15.composeChecker:Check()

	if arg1_15:CanTouch() and arg1_15:TriggerTouchDefault() then
		arg0_15:ClickFurniture(arg1_15.id)
	end
end

function var0_0.AddPaper(arg0_16, arg1_16)
	local var0_16 = arg1_16:GetType()

	if var0_16 == Furniture.TYPE_WALLPAPER then
		arg0_16:SetWallPaper(arg1_16)
	elseif var0_16 == Furniture.TYPE_FLOORPAPER then
		arg0_16:SetFloorPaper(arg1_16)
	end
end

function var0_0.AddChildFurniture(arg0_17, arg1_17, arg2_17)
	arg0_17.furnitures[arg1_17.id] = arg1_17

	arg0_17:DispatchEvent(CourtYardEvent.CREATE_ITEM, arg1_17)

	local var0_17 = arg0_17.furnitures[arg2_17]

	arg0_17:DispatchEvent(CourtYardEvent.CHILD_ITEM, arg1_17, var0_17)
	var0_17:AddChild(arg1_17)
end

function var0_0.Update(arg0_18)
	arg0_18:CheckShipState()
	arg0_18:CheckFurnitureState()
end

function var0_0.AddShip(arg0_19, arg1_19)
	arg1_19:ChangeState(CourtYardShip.STATE_IDLE)

	arg0_19.ships[arg1_19.id] = arg1_19

	arg0_19:DispatchEvent(CourtYardEvent.CREATE_ITEM, arg1_19)
	arg0_19:AddItem(arg1_19)
end

function var0_0.GetPlaceableArea(arg0_20, arg1_20)
	return arg1_20:HasParent() and arg1_20:GetParent():GetPlaceableArea() or arg0_20
end

function var0_0.RemoveShip(arg0_21, arg1_21)
	arg0_21:GetPlaceableArea(arg1_21):RemoveItem(arg1_21)
	arg0_21.ships[arg1_21.id]:Dispose()

	arg0_21.ships[arg1_21.id] = nil

	arg0_21:DispatchEvent(CourtYardEvent.DETORY_ITEM, arg1_21)
end

function var0_0.ExitShip(arg0_22, arg1_22)
	local var0_22 = arg0_22.ships[arg1_22]

	if var0_22 then
		arg0_22:RemoveShip(var0_22)
	end
end

function var0_0.CheckShipState(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23:GetShips()) do
		local var0_23 = iter1_23:GetState()

		if var0_23 == CourtYardShip.STATE_MOVE then
			arg0_23:ReadyMoveShip(iter1_23.id)
		elseif var0_23 == CourtYardShip.STATE_MOVING_HALF then
			arg0_23:MoveShipToNextPosition(iter1_23.id)
		end
	end
end

function var0_0.ReadyMoveShip(arg0_24, arg1_24)
	local var0_24 = arg0_24.ships[arg1_24]
	local var1_24 = false
	local var2_24 = false
	local var3_24 = false

	if CourtYardCalcUtil.HalfProbability() then
		if var0_24:HasParent() and var0_24:GetParent():IsType(Furniture.TYPE_ARCH) then
			var1_24 = arg0_24:ShipExitArch(var0_24)
		else
			var2_24 = arg0_24:ShipEnterArch(var0_24)

			if not var2_24 then
				var3_24 = arg0_24:ShipAddFollower(var0_24)
			end
		end
	end

	if not var1_24 and not var2_24 and not var3_24 then
		arg0_24:RandomNextShipPosition(arg1_24)
	end
end

function var0_0.ShipAddFollower(arg0_25, arg1_25)
	local var0_25 = arg0_25:GetFurnituresByType(Furniture.TYPE_FOLLOWER)

	local function var1_25(arg0_26)
		return _.detect(var0_25, function(arg0_27)
			local var0_27 = arg0_27:GetArea()

			return _.any(var0_27, function(arg0_28)
				return arg0_28 == arg0_26
			end)
		end)
	end

	local function var2_25()
		local var0_29 = arg1_25:GetInterActionData()

		if var0_29 ~= nil then
			var0_29:Stop()
		end
	end

	for iter0_25, iter1_25 in ipairs(arg1_25:GetAroundPositions()) do
		local var3_25 = var1_25(iter1_25)

		if var3_25 and var3_25:CanFollower(arg1_25) then
			var2_25()
			arg0_25:RemoveItemAndRefresh(var3_25)
			var3_25:GetInteractionSlot():Occupy(var3_25, arg1_25, arg0_25)

			return true
		end
	end

	return false
end

function var0_0.ShipExitArch(arg0_30, arg1_30)
	local var0_30 = arg0_30:GetNextPositionForMove(arg1_30)

	if var0_30 then
		local var1_30 = arg1_30:GetParent()

		var1_30:RemoveChild(arg1_30)
		arg0_30:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, arg1_30, var1_30)
		arg0_30:DispatchEvent(CourtYardEvent.EXIT_ARCH, arg1_30, var1_30)
		arg0_30:LockPosition(var0_30)
		arg1_30:UnClear(true)
		arg1_30:Move(var0_30)

		return true
	end

	return false
end

function var0_0.ShipEnterArch(arg0_31, arg1_31)
	local function var0_31(arg0_32, arg1_32)
		arg0_31:RemoveItem(arg1_31)
		arg0_31:DispatchEvent(CourtYardEvent.CHILD_ITEM, arg1_31, arg0_32)
		arg0_31:DispatchEvent(CourtYardEvent.ENTER_ARCH, arg1_31, arg0_32)
		arg0_32:AddChild(arg1_31)
		arg1_31:Move(arg1_32)
	end

	for iter0_31, iter1_31 in ipairs(arg1_31:GetAroundPositions()) do
		local var1_31 = arg0_31:GetParentForItem(arg1_31, iter1_31)

		if var1_31 and var1_31:IsType(Furniture.TYPE_ARCH) then
			var0_31(var1_31, iter1_31)

			return true
		end
	end

	return false
end

function var0_0.RandomNextShipPosition(arg0_33, arg1_33)
	local var0_33 = arg0_33.ships[arg1_33]
	local var1_33 = arg0_33:GetPlaceableArea(var0_33)
	local var2_33 = var1_33:GetNextPositionForMove(var0_33)

	if not var2_33 then
		var0_33:ChangeState(CourtYardShip.STATE_IDLE)

		return
	end

	var1_33:LockPosition(var2_33)
	var0_33:Move(var2_33)
end

function var0_0.MoveShipToNextPosition(arg0_34, arg1_34)
	local var0_34 = arg0_34.ships[arg1_34]
	local var1_34 = arg0_34:GetPlaceableArea(var0_34)
	local var2_34 = var0_34:GetMarkPosition()

	var1_34:_ClearLockPosition(var0_34)

	if var0_34:IsUnClear() then
		var0_34:UnClear(false)
	else
		var1_34:RemoveItem(var0_34)
	end

	var0_34:SetPosition(var2_34)
	var1_34:AddItem(var0_34)
	var0_34:ChangeState(CourtYardShip.STATE_MOVING_ONE)
end

function var0_0.DragShip(arg0_35, arg1_35)
	local var0_35 = arg0_35.ships[arg1_35]

	arg0_35:GetPlaceableArea(var0_35):_ClearLockPosition(var0_35)

	local var1_35 = var0_35:GetPosition()
	local var2_35 = var0_35:GetInterActionData()

	if var2_35 ~= nil or var0_35:GetState() == CourtYardShip.STATE_INTERACT then
		if isa(var2_35, CourtYardFollowerSlot) then
			arg0_35:RemoveItem(var0_35)
		end

		var2_35:Stop()
	elseif var0_35:HasParent() then
		local var3_35 = var0_35:GetParent()

		var3_35:RemoveChild(var0_35)
		var0_35:ChangeState(CourtYardShip.STATE_IDLE)
		arg0_35:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, var0_35, var3_35)
	else
		arg0_35:RemoveItem(var0_35)
	end

	var0_35:ChangeState(CourtYardShip.STATE_DRAG)

	local var4_35 = arg0_35:AreaWithInfo(var0_35, var1_35, var0_35:GetOffset())

	var0_35:UpdateOpFlag(true)
	arg0_35:DispatchEvent(CourtYardEvent.SELETED_ITEM, var0_35, var4_35)
	arg0_35:DispatchEvent(CourtYardEvent.DRAG_ITEM, var0_35)
end

function var0_0.DragingShip(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36.ships[arg1_36]

	if not var0_36:GetOpFlag() then
		return
	end

	local var1_36 = arg0_36:GetParentForItem(var0_36, arg2_36)
	local var2_36 = arg0_36:GetInterActionFurniture(var0_36, arg2_36)
	local var3_36 = var1_36 and var1_36:RawGetOffset() or var0_36:GetOffset()
	local var4_36 = arg0_36:AreaWithInfo(var0_36, arg2_36, var3_36, var2_36 or var1_36)

	arg0_36:DispatchEvent(CourtYardEvent.DRAGING_ITEM, var0_36, var4_36, arg2_36, var3_36)
end

function var0_0.DragShipEnd(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37.ships[arg1_37]

	if not var0_37:GetOpFlag() then
		return
	end

	local var1_37 = arg0_37:LegalPosition(arg2_37, var0_37)
	local var2_37 = arg0_37:GetInterActionFurniture(var0_37, arg2_37)
	local var3_37 = arg0_37:GetParentForItem(var0_37, arg2_37)
	local var4_37

	if not var1_37 and var2_37 then
		if isa(var2_37, CourtYardFollowerFurniture) then
			arg0_37:RemoveItemAndRefresh(var2_37)
			arg0_37:ResetShip(var0_37, arg2_37)
			var0_37:ChangeState(CourtYardShip.STATE_MOVE)
		end

		var2_37:GetInteractionSlot():Occupy(var2_37, var0_37, arg0_37)
	elseif not var1_37 and var3_37 then
		var0_37:SetPosition(arg2_37)
		arg0_37:DispatchEvent(CourtYardEvent.CHILD_ITEM, var0_37, var3_37)
		var3_37:AddChild(var0_37)
		var0_37:ChangeState(CourtYardShip.STATE_IDLE)

		var4_37 = var3_37:AreaWithInfo(var0_37, arg2_37, var3_37:RawGetOffset(), true)
	else
		local var5_37 = var1_37 and arg2_37 or var0_37:GetPosition()

		arg0_37:ResetShip(var0_37, var5_37)

		var4_37 = arg0_37:AreaWithInfo(var0_37, var5_37, var0_37:GetOffset(), true)
	end

	var0_37:UpdateOpFlag(false)
	arg0_37:DispatchEvent(CourtYardEvent.DRAG_ITEM_END, var4_37)
	arg0_37:DispatchEvent(CourtYardEvent.UNSELETED_ITEM, var0_37)
end

function var0_0.GetInterActionFurniture(arg0_38, arg1_38, arg2_38)
	for iter0_38, iter1_38 in pairs(arg0_38.furnitures) do
		if iter1_38:CanInterAction(arg1_38) and iter1_38:IsOverlap(arg2_38) then
			return iter1_38
		end
	end

	return nil
end

function var0_0.TouchShip(arg0_39, arg1_39)
	local var0_39 = arg0_39.ships[arg1_39]

	arg0_39:GetPlaceableArea(var0_39):_ClearLockPosition(var0_39)
	var0_39:ChangeState(CourtYardShip.STATE_TOUCH)
end

function var0_0.UpdateShipIntimacy(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40.ships[arg1_40]

	if not var0_40 then
		return
	end

	var0_40:ChangeInimacy(arg2_40)
end

function var0_0.UpdateShipCoin(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.ships[arg1_41]

	if not var0_41 then
		return
	end

	var0_41:ChangeCoin(arg2_41)
end

function var0_0.ClearShipIntimacy(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg0_42.ships[arg1_42]

	if not var0_42 then
		return
	end

	arg0_42:GetPlaceableArea(var0_42):_ClearLockPosition(var0_42)
	var0_42:ClearInimacy(arg2_42)
end

function var0_0.ClearShipCoin(arg0_43, arg1_43)
	local var0_43 = arg0_43.ships[arg1_43]

	if not var0_43 then
		return
	end

	arg0_43:GetPlaceableArea(var0_43):_ClearLockPosition(var0_43)
	var0_43:ClearCoin(value)
end

function var0_0.AddShipExp(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.ships[arg1_44]

	if not var0_44 then
		return
	end

	var0_44:AddExp(arg2_44)
end

function var0_0.ShipAnimtionFinish(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg0_45.ships[arg1_45]

	if arg2_45 == CourtYardShip.STATE_TOUCH or arg2_45 == CourtYardShip.STATE_GETAWARD then
		var0_45:ChangeState(CourtYardShip.STATE_IDLE)
	elseif arg2_45 == CourtYardShip.STATE_INTERACT then
		local var1_45 = var0_45:GetInterActionData()

		if var1_45 then
			var1_45:Continue(var0_45)
		end
	end
end

function var0_0.ResetShip(arg0_46, arg1_46, arg2_46)
	local function var0_46(arg0_47, arg1_47)
		arg0_47:SetPosition(arg1_47)
		arg0_47:ChangeState(CourtYardShip.STATE_IDLE)
		arg0_46:AddItem(arg0_47)
	end

	if arg0_46:LegalPosition(arg2_46, arg1_46) then
		var0_46(arg1_46, arg2_46)
	else
		local var1_46 = arg0_46:GetRandomPosition(arg1_46)

		if var1_46 then
			var0_46(arg1_46, var1_46)
		else
			arg0_46:RemoveShip(arg1_46)
			arg0_46:GetHost():SendNotification(CourtYardEvent._NO_POS_TO_ADD_SHIP, arg1_46.id)
		end
	end
end

function var0_0.SelectFurniture(arg0_48, arg1_48)
	if not arg0_48.canEidt then
		return
	end

	local var0_48 = arg0_48.furnitures[arg1_48]

	if var0_48:GetOpFlag() then
		return
	end

	local var1_48 = _.detect(_.values(arg0_48.furnitures), function(arg0_49)
		return arg0_49:GetOpFlag()
	end)

	if var1_48 then
		arg0_48:UnSelectFurniture(var1_48.id)
	end

	local var2_48 = var0_48:GetPosition()
	local var3_48 = arg0_48:AreaWithInfo(var0_48, var2_48, var0_48:GetOffset(), true)

	var0_48:UpdateOpFlag(true)
	arg0_48:DispatchEvent(CourtYardEvent.SELETED_ITEM, var0_48, var3_48)
end

function var0_0.ClickFurniture(arg0_50, arg1_50)
	local var0_50 = arg0_50.furnitures[arg1_50]

	if var0_50:HasDescription() then
		arg0_50:DispatchEvent(CourtYardEvent.SHOW_FURNITURE_DESC, var0_50)
	elseif var0_50:CanTouch() then
		if var0_50:GetTouchBg() then
			arg0_50:CheckFurnitureTouchBG(var0_50)
		end

		if not var0_50:IsTouchState() then
			var0_50:ChangeState(CourtYardFurniture.STATE_TOUCH)
			arg0_50:DispatchEvent(CourtYardEvent.ON_TOUCH_ITEM, var0_50)
		else
			var0_50:ChangeState(CourtYardFurniture.STATE_IDLE)
			arg0_50:DispatchEvent(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, var0_50)
		end
	end
end

function var0_0.CheckFurnitureTouchBG(arg0_51, arg1_51)
	for iter0_51, iter1_51 in pairs(arg0_51.furnitures) do
		if iter1_51.id ~= arg1_51.id and iter1_51:IsTouchState() and iter1_51:GetTouchBg() then
			iter1_51:ChangeState(CourtYardFurniture.STATE_IDLE)
			arg0_51:DispatchEvent(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, iter1_51)
		end
	end
end

function var0_0.PlayMusicalInstruments(arg0_52, arg1_52)
	local var0_52 = arg0_52.furnitures[arg1_52]

	arg0_52:MuteAll()
	arg0_52:DispatchEvent(CourtYardEvent.FURNITURE_PLAY_MUSICALINSTRUMENTS, var0_52)
end

function var0_0.StopPlayMusicalInstruments(arg0_53, arg1_53)
	local var0_53 = arg0_53.furnitures[arg1_53]

	arg0_53:DispatchEvent(CourtYardEvent.FURNITURE_STOP_PLAY_MUSICALINSTRUMENTS, var0_53)
end

function var0_0.PlayFurnitureVoice(arg0_54, arg1_54)
	local var0_54 = arg0_54.furnitures[arg1_54]
	local var1_54 = _.select(var0_54.musicDatas, function(arg0_55)
		return arg0_55.voiceType == 1
	end)

	if #var1_54 > 0 then
		local var2_54 = var1_54[math.random(1, #var1_54)]

		arg0_54:DispatchEvent(CourtYardEvent.ON_ITEM_PLAY_MUSIC, var2_54.voice, var2_54.voiceType)
	end
end

function var0_0.PlayFurnitureBg(arg0_56, arg1_56)
	local var0_56 = arg0_56.furnitures[arg1_56]
	local var1_56 = arg0_56:StopPrevFurnitureVoice()

	if var1_56 and var1_56.id == var0_56.id then
		return
	end

	var0_56:ChangeState(CourtYardFurniture.STATE_PLAY_MUSIC)

	local var2_56 = var0_56:GetMusicData()

	if var2_56 then
		arg0_56:DispatchEvent(CourtYardEvent.ON_ITEM_PLAY_MUSIC, var2_56.voice, var2_56.voiceType)
	end
end

function var0_0.MuteAll(arg0_57)
	for iter0_57, iter1_57 in pairs(arg0_57.furnitures) do
		if iter1_57:GetMusicData() then
			local var0_57 = iter1_57:GetMusicData()

			arg0_57:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var0_57.voice, var0_57.voiceType)
			iter1_57:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
		end
	end

	arg0_57:DispatchEvent(CourtYardEvent.FURNITURE_MUTE_ALL)
end

function var0_0.StopPrevFurnitureVoice(arg0_58)
	local var0_58

	for iter0_58, iter1_58 in pairs(arg0_58.furnitures) do
		local var1_58 = iter1_58:GetMusicData()

		if var1_58 and var1_58.voiceType == 2 then
			var0_58 = iter1_58
		end
	end

	if var0_58 then
		local var2_58 = var0_58:GetMusicData()

		arg0_58:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var2_58.voice, var2_58.voiceType)
		var0_58:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
	end

	return var0_58
end

function var0_0.FurnitureAnimtionFinish(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg0_59.furnitures[arg1_59]

	if arg2_59 == CourtYardFurniture.STATE_TOUCH then
		var0_59:ChangeState(CourtYardFurniture.STATE_IDLE)
	elseif arg2_59 == CourtYardFurniture.STATE_INTERACT then
		local var1_59 = var0_59:GetUsingSlots()

		_.each(var1_59, function(arg0_60)
			arg0_60:Continue(var0_59)
		end)
	elseif arg2_59 == CourtYardFurniture.STATE_TOUCH_PREPARE then
		var0_59:_ChangeState(CourtYardFurniture.STATE_TOUCH)
	end
end

function var0_0.BeginDragFurniture(arg0_61, arg1_61)
	if not arg0_61.canEidt then
		return
	end

	local var0_61 = arg0_61.furnitures[arg1_61]

	if not var0_61:GetOpFlag() then
		return
	end

	var0_61:ChangeState(CourtYardFurniture.STATE_DRAG)

	if var0_61:HasParent() then
		local var1_61 = var0_61:GetParent()

		var1_61:RemoveChild(var0_61)
		arg0_61:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, var0_61, var1_61)
	else
		arg0_61:RemoveItem(var0_61)
		arg0_61:DispatchEvent(CourtYardEvent.DRAG_ITEM, var0_61)
	end
end

function var0_0.DragingFurniture(arg0_62, arg1_62, arg2_62)
	if not arg0_62.canEidt then
		return
	end

	local var0_62 = arg0_62.furnitures[arg1_62]

	if not var0_62:GetOpFlag() then
		return
	end

	if isa(var0_62, CourtYardWallFurniture) then
		arg2_62 = var0_62:NormalizePosition(arg2_62, arg0_62.minSizeX)
	end

	local var1_62 = arg0_62:GetParentForItem(var0_62, arg2_62)
	local var2_62 = var1_62 and var1_62:RawGetOffset() or var0_62:GetOffset()
	local var3_62 = var1_62 and var1_62:AreaWithInfo(var0_62, arg2_62, var2_62) or arg0_62:AreaWithInfo(var0_62, arg2_62, var2_62)

	arg0_62:DispatchEvent(CourtYardEvent.DRAGING_ITEM, var0_62, var3_62, arg2_62, var2_62)
end

function var0_0.GetParentForItem(arg0_63, arg1_63, arg2_63)
	local var0_63 = _.select(_.values(arg0_63.furnitures), function(arg0_64)
		return isa(arg0_64, CourtYardCanPutFurniture) and arg0_64:CanPutChildInPosition(arg1_63, arg2_63)
	end)

	table.sort(var0_63, function(arg0_65, arg1_65)
		return (arg0_65.parent and 1 or 0) > (arg1_65.parent and 1 or 0)
	end)

	return var0_63[1]
end

function var0_0.DragFurnitureEnd(arg0_66, arg1_66, arg2_66)
	if not arg0_66.canEidt then
		return
	end

	local var0_66 = arg0_66.furnitures[arg1_66]

	if not var0_66:GetOpFlag() then
		return
	end

	var0_66:ChangeState(CourtYardFurniture.STATE_IDLE)

	if isa(var0_66, CourtYardWallFurniture) then
		arg2_66 = var0_66:NormalizePosition(arg2_66, arg0_66.minSizeX)
	end

	local var1_66 = arg0_66:VerifyDragPositionForFurniture(var0_66, arg2_66)

	if not var1_66 then
		arg0_66:RemoveFurniture(arg1_66)
		arg0_66:DispatchEvent(CourtYardEvent.REMOVE_ILLEGALITY_ITEM)

		return
	end

	if isa(var0_66, CourtYardWallFurniture) then
		var0_66:UpdatePosition(var1_66)
	else
		var0_66:SetPosition(var1_66)
	end

	local var2_66 = arg0_66:GetParentForItem(var0_66, var1_66)
	local var3_66

	if var2_66 then
		arg0_66:DispatchEvent(CourtYardEvent.CHILD_ITEM, var0_66, var2_66)
		var2_66:AddChild(var0_66)

		var3_66 = var2_66:AreaWithInfo(var0_66, var1_66, var2_66:RawGetOffset(), true)
	else
		arg0_66:AddItem(var0_66)

		var3_66 = arg0_66:AreaWithInfo(var0_66, var1_66, var0_66:GetOffset(), true)
	end

	arg0_66:DispatchEvent(CourtYardEvent.DRAG_ITEM_END, var0_66, var3_66)
end

function var0_0.IsLegalAreaForFurniture(arg0_67, arg1_67, arg2_67)
	return _.all(arg1_67:GetAreaByPosition(arg2_67), function(arg0_68)
		return arg0_67:LegalPosition(arg0_68, arg1_67)
	end) or arg0_67:GetParentForItem(arg1_67, arg2_67) ~= nil
end

function var0_0.VerifyDragPositionForFurniture(arg0_69, arg1_69, arg2_69)
	local var0_69

	if arg0_69:IsLegalAreaForFurniture(arg1_69, arg2_69) then
		var0_69 = arg2_69
	else
		local var1_69 = arg1_69:GetPosition()

		if var1_69 and isa(arg1_69, CourtYardWallFurniture) then
			arg1_69:UpdatePosition(var1_69)
		end

		if var1_69 and arg0_69:IsLegalAreaForFurniture(arg1_69, var1_69) then
			var0_69 = var1_69
		else
			if var1_69 and isa(arg1_69, CourtYardWallFurniture) then
				arg1_69:UpdatePosition(arg2_69)
			end

			var0_69 = arg0_69:GetEmptyArea(arg1_69)
		end
	end

	return var0_69
end

function var0_0.UnSelectFurniture(arg0_70, arg1_70)
	local var0_70 = arg0_70.furnitures[arg1_70]

	if not var0_70:GetOpFlag() then
		return
	end

	var0_70:UpdateOpFlag(false)
	arg0_70:DispatchEvent(CourtYardEvent.UNSELETED_ITEM, var0_70)
end

function var0_0.RotateFurniture(arg0_71, arg1_71)
	local var0_71 = arg0_71.furnitures[arg1_71]

	if var0_71:DisableRotation() then
		arg0_71:DispatchEvent(CourtYardEvent.DISABLE_ROTATE_ITEM)
	elseif not arg0_71:CanRotateItem(var0_71) then
		arg0_71:DispatchEvent(CourtYardEvent.ROTATE_ITEM_FAILED)
	else
		local var1_71 = var0_71:HasParent()

		if not var1_71 then
			arg0_71:RemoveItem(var0_71)
		end

		var0_71:Rotate()

		local var2_71 = arg0_71:AreaWithInfo(var0_71, var0_71:GetPosition(), var0_71:GetOffset())

		if not var1_71 then
			arg0_71:AddItem(var0_71)
		end

		arg0_71:DispatchEvent(CourtYardEvent.ROTATE_ITEM, var0_71, var2_71)
	end
end

function var0_0.RemoveFurniture(arg0_72, arg1_72)
	local var0_72 = arg0_72.furnitures[arg1_72]
	local var1_72 = var0_72:HasParent()

	if var1_72 then
		var0_72:GetParent():RemoveChild(var0_72)
	end

	local var2_72 = var0_72.childs or {}

	for iter0_72 = #var2_72, 1, -1 do
		arg0_72:RemoveFurniture(var2_72[iter0_72].id)
	end

	if not var1_72 then
		arg0_72:RemoveItem(var0_72)
	end

	local var3_72 = var0_72:GetMusicData()

	if var3_72 then
		arg0_72:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var3_72.voice, var3_72.voiceType)
		var0_72:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
	end

	arg0_72:UnSelectFurniture(arg1_72)
	arg0_72.furnitures[arg1_72]:Dispose()

	arg0_72.furnitures[arg1_72] = nil

	arg0_72:DispatchEvent(CourtYardEvent.DETORY_ITEM, var0_72)
	arg0_72.composeChecker:Check()
end

function var0_0.RemoveAllFurniture(arg0_73)
	for iter0_73, iter1_73 in pairs(arg0_73.furnitures) do
		if not iter1_73:HasParent() then
			arg0_73:RemoveFurniture(iter1_73.id)
		end
	end

	arg0_73:SetWallPaper(nil)
	arg0_73:SetFloorPaper(nil)
end

function var0_0.RemovePaper(arg0_74, arg1_74)
	local var0_74 = arg0_74:GetWallPaper()

	if var0_74 and var0_74.id == arg1_74 then
		arg0_74:SetWallPaper(nil)
	end

	local var1_74 = arg0_74:GetFloorPaper()

	if var1_74 and var1_74.id == arg1_74 then
		arg0_74:SetFloorPaper(nil)
	end
end

function var0_0.CheckFurnitureState(arg0_75)
	for iter0_75, iter1_75 in pairs(arg0_75.furnitures) do
		if iter1_75:IsType(Furniture.TYPE_MOVEABLE) and iter1_75:IsReadyMove() then
			arg0_75:ReadyMoveFurniture(iter1_75.id)
		end
	end
end

function var0_0.ReadyMoveFurniture(arg0_76, arg1_76)
	local var0_76 = arg0_76.furnitures[arg1_76]
	local var1_76 = arg0_76:GetNextPositionForMove(var0_76)

	if not var1_76 then
		var0_76:Rest()

		return
	end

	if var0_76:IsDifferentDirection(var1_76) and arg0_76:CanRotateItem(var0_76) then
		arg0_76:RotateFurniture(arg1_76)
	end

	var0_76:Move(var1_76)
	arg0_76:RemoveItem(var0_76)
	var0_76:SetPosition(var1_76)
	arg0_76:AddItemAndRefresh(var0_76)
end

function var0_0.GetFurnituresByType(arg0_77, arg1_77)
	local var0_77 = {}

	for iter0_77, iter1_77 in pairs(arg0_77.furnitures) do
		if iter1_77:IsType(arg1_77) then
			table.insert(var0_77, iter1_77)
		end
	end

	return var0_77
end

function var0_0.EnterEditMode(arg0_78)
	arg0_78.canEidt = true

	for iter0_78, iter1_78 in pairs(arg0_78.ships) do
		if iter1_78:GetState() == CourtYardShip.STATE_DRAG then
			arg0_78:DragShipEnd(iter1_78.id, Vector2(-1, -1))
		end

		arg0_78:GetPlaceableArea(iter1_78):_ClearLockPosition(iter1_78)

		if iter1_78:HasParent() then
			local var0_78 = iter1_78:GetParent()

			var0_78:RemoveChild(iter1_78)
			arg0_78:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, iter1_78, var0_78)
		else
			arg0_78:RemoveItem(iter1_78)
		end

		iter1_78:ChangeState(CourtYardShip.STATE_STOP)
	end

	for iter2_78, iter3_78 in pairs(arg0_78.furnitures) do
		if iter3_78:IsType(Furniture.TYPE_TRANSPORT) and iter3_78:IsUsing() then
			iter3_78:Stop()
		end

		if iter3_78:IsType(Furniture.TYPE_FOLLOWER) and iter3_78:IsUsing() then
			iter3_78:Stop()
		end

		if iter3_78:IsType(Furniture.TYPE_MOVEABLE) and iter3_78:IsMoving() then
			iter3_78:Stop()
		end

		if iter3_78:IsTouchState() then
			arg0_78:ClickFurniture(iter3_78.id)
		end
	end

	arg0_78.recoder:BeginCheckChange()
	arg0_78:DispatchEvent(CourtYardEvent.ENTER_EDIT_MODE)
end

function var0_0.ExitEditMode(arg0_79)
	for iter0_79, iter1_79 in pairs(arg0_79.ships) do
		if iter1_79:ShouldResetPosition() then
			local var0_79 = iter1_79:GetPosition()

			arg0_79:ResetShip(iter1_79, var0_79)
		end
	end

	for iter2_79, iter3_79 in pairs(arg0_79.furnitures) do
		if iter3_79:IsType(Furniture.TYPE_MOVEABLE) and iter3_79:IsStop() then
			iter3_79:ReStart()

			if iter3_79:CanTouch() then
				arg0_79:ClickFurniture(iter3_79.id)
			end
		end
	end

	local var1_79 = _.detect(_.values(arg0_79.furnitures), function(arg0_80)
		return arg0_80:GetOpFlag()
	end)

	if var1_79 then
		arg0_79:UnSelectFurniture(var1_79.id)
	end

	arg0_79.canEidt = false

	arg0_79.recoder:EndCheckChange()
	arg0_79:DispatchEvent(CourtYardEvent.EXIT_EDIT_MODE)
end

function var0_0.InEidtMode(arg0_81)
	return arg0_81.canEidt
end

function var0_0.StopAllDragState(arg0_82)
	local function var0_82()
		for iter0_83, iter1_83 in pairs(arg0_82.ships) do
			if iter1_83:GetState() == CourtYardShip.STATE_DRAG then
				arg0_82:DragShipEnd(iter1_83.id, Vector2(-1, -1))
			end
		end
	end

	local function var1_82()
		for iter0_84, iter1_84 in pairs(arg0_82.furnitures) do
			if iter1_84:IsDragingState() then
				arg0_82:DragFurnitureEnd(iter1_84.id, Vector2(-1, -1))
				arg0_82:UnSelectFurniture(iter1_84.id)
			end
		end
	end

	if not arg0_82:InEidtMode() then
		var0_82()
	else
		var1_82()
	end
end

function var0_0.StartInteraction(arg0_85, arg1_85)
	local var0_85 = arg1_85:GetUser()
	local var1_85 = arg1_85:GetOwner()

	if isa(var1_85, CourtYardFurniture) and var1_85:GetInterActionBgm() then
		for iter0_85, iter1_85 in pairs(arg0_85.furnitures) do
			if iter1_85:IsPlayMusicState() then
				iter1_85:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
			end
		end
	end

	arg0_85:DispatchEvent(CourtYardEvent.ITEM_INTERACTION, var0_85, var1_85, arg1_85)
end

function var0_0.WillClearInteraction(arg0_86, arg1_86, arg2_86)
	local var0_86 = arg1_86:GetUser()
	local var1_86 = arg1_86:GetOwner()

	arg0_86:DispatchEvent(CourtYardEvent.CLEAR_ITEM_INTERACTION, var0_86, var1_86, arg1_86)
end

function var0_0.ClearInteraction(arg0_87, arg1_87, arg2_87)
	local var0_87 = arg1_87:GetUser()
	local var1_87 = arg1_87:GetOwner()

	if isa(var0_87, CourtYardFollowerFurniture) then
		arg0_87:ClearInteractionForFollower(var0_87, var1_87, arg1_87, arg2_87)
	elseif not arg2_87 then
		if isa(var1_87, CourtYardTransportFurniture) then
			arg0_87:ClearInteractionForTransPort(var0_87, var1_87, arg1_87)
		else
			arg0_87:ResetShip(var0_87, var0_87:GetPosition())
		end
	end
end

function var0_0.ClearInteractionForFollower(arg0_88, arg1_88, arg2_88, arg3_88, arg4_88)
	local var0_88 = arg0_88:GetAroundEmptyArea(arg1_88, arg2_88:GetPosition())

	if not var0_88 then
		arg0_88:DispatchEvent(CourtYardEvent.REMOVE_ILLEGALITY_ITEM)
		arg0_88:RemoveFurniture(arg1_88.id)

		return
	end

	arg1_88:SetPosition(var0_88)
	arg0_88:AddItemAndRefresh(arg1_88)
end

function var0_0.ClearInteractionForTransPort(arg0_89, arg1_89, arg2_89, arg3_89)
	if arg3_89:IsFirstTime() then
		local var0_89 = arg0_89:GetFurnituresByType(Furniture.TYPE_TRANSPORT)
		local var1_89 = _.select(var0_89, function(arg0_90)
			return arg0_90.id ~= arg2_89.id
		end)
		local var2_89 = var1_89[math.random(1, #var1_89)]

		if var2_89 and var2_89:CanInterAction(arg1_89) then
			var2_89:GetInteractionSlot():Link(var2_89, arg1_89, arg0_89)
		else
			arg0_89:ResetShip(arg1_89, arg0_89:GetRandomPosition(arg1_89))
		end
	else
		arg0_89:ResetShip(arg1_89, arg0_89:GetAroundEmptyPosition(arg2_89))
	end
end

function var0_0.LegalPosition(arg0_91, arg1_91, arg2_91)
	return var0_0.super.LegalPosition(arg0_91, arg1_91, arg2_91) and arg2_91:InActivityRange(arg1_91)
end

function var0_0.GetLevel(arg0_92)
	return arg0_92.level
end

function var0_0.Dispose(arg0_93)
	var0_0.super.Dispose(arg0_93)
	arg0_93.recoder:Dispose()

	arg0_93.recoder = nil

	arg0_93.composeChecker:Dispose()

	arg0_93.composeChecker = nil

	for iter0_93, iter1_93 in pairs(arg0_93.ships) do
		iter1_93:Dispose()
	end

	for iter2_93, iter3_93 in pairs(arg0_93.furnitures) do
		iter3_93:Dispose()
	end

	arg0_93.ships = nil
	arg0_93.furnitures = nil
end

function var0_0.GetDirty(arg0_94)
	return arg0_94.recoder:TakeSample()
end

function var0_0.ToTable(arg0_95)
	local var0_95 = {}

	local function var1_95(arg0_96)
		arg0_96.floor = arg0_95.id
		var0_95[arg0_96.id] = arg0_96
	end

	for iter0_95, iter1_95 in pairs(arg0_95.furnitures) do
		var1_95(iter1_95:ToTable())
	end

	if arg0_95.wallPaper then
		var1_95(arg0_95.wallPaper:ToTable())
	end

	if arg0_95.floorPaper then
		var1_95(arg0_95.floorPaper:ToTable())
	end

	return var0_95
end

return var0_0
