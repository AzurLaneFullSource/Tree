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

	if not arg2_15 then
		arg0_15:RefreshCombineFruniture(arg1_15.configId)
	end
end

function var0_0.RefreshCombineFruniture(arg0_16, arg1_16)
	local var0_16 = pg.furniture_data_template[arg1_16]
	local var1_16 = {
		arg1_16
	}

	if type(var0_16.spine_combine_action_replace) == "table" then
		for iter0_16, iter1_16 in pairs(var0_16.spine_combine_action_replace) do
			for iter2_16, iter3_16 in ipairs(iter1_16[1]) do
				table.insert(var1_16, iter3_16)
			end
		end
	end

	for iter4_16, iter5_16 in pairs(arg0_16.furnitures) do
		if table.contains(var1_16, iter5_16.configId) then
			iter5_16:RefreshState()
		end
	end
end

function var0_0.AddPaper(arg0_17, arg1_17)
	local var0_17 = arg1_17:GetType()

	if var0_17 == Furniture.TYPE_WALLPAPER then
		arg0_17:SetWallPaper(arg1_17)
	elseif var0_17 == Furniture.TYPE_FLOORPAPER then
		arg0_17:SetFloorPaper(arg1_17)
	end
end

function var0_0.AddChildFurniture(arg0_18, arg1_18, arg2_18)
	arg0_18.furnitures[arg1_18.id] = arg1_18

	arg0_18:DispatchEvent(CourtYardEvent.CREATE_ITEM, arg1_18)

	local var0_18 = arg0_18.furnitures[arg2_18]

	arg0_18:DispatchEvent(CourtYardEvent.CHILD_ITEM, arg1_18, var0_18)
	var0_18:AddChild(arg1_18)
end

function var0_0.Update(arg0_19)
	arg0_19:CheckShipState()
	arg0_19:CheckFurnitureState()
end

function var0_0.AddShip(arg0_20, arg1_20)
	arg1_20:ChangeState(CourtYardShip.STATE_IDLE)

	arg0_20.ships[arg1_20.id] = arg1_20

	arg0_20:DispatchEvent(CourtYardEvent.CREATE_ITEM, arg1_20)
	arg0_20:AddItem(arg1_20)
end

function var0_0.GetPlaceableArea(arg0_21, arg1_21)
	return arg1_21:HasParent() and arg1_21:GetParent():GetPlaceableArea() or arg0_21
end

function var0_0.RemoveShip(arg0_22, arg1_22)
	arg0_22:GetPlaceableArea(arg1_22):RemoveItem(arg1_22)
	arg0_22.ships[arg1_22.id]:Dispose()

	arg0_22.ships[arg1_22.id] = nil

	arg0_22:DispatchEvent(CourtYardEvent.DETORY_ITEM, arg1_22)

	if arg0_22.ships[arg1_22.id + CourtYardConst.DOUBLE_SKIN_ADD] then
		arg0_22:RemoveShip(arg0_22.ships[arg1_22.id + CourtYardConst.DOUBLE_SKIN_ADD])
	end
end

function var0_0.ExitShip(arg0_23, arg1_23)
	local var0_23 = arg0_23.ships[arg1_23]

	if var0_23 then
		arg0_23:RemoveShip(var0_23)
	end
end

function var0_0.CheckShipState(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24:GetShips()) do
		local var0_24 = iter1_24:GetState()

		if var0_24 == CourtYardShip.STATE_MOVE then
			arg0_24:ReadyMoveShip(iter1_24.id)
		elseif var0_24 == CourtYardShip.STATE_MOVING_HALF then
			arg0_24:MoveShipToNextPosition(iter1_24.id)
		end
	end
end

function var0_0.ReadyMoveShip(arg0_25, arg1_25)
	local var0_25 = arg0_25.ships[arg1_25]
	local var1_25 = false
	local var2_25 = false
	local var3_25 = false

	if CourtYardCalcUtil.HalfProbability() then
		if var0_25:HasParent() and var0_25:GetParent():IsType(Furniture.TYPE_ARCH) then
			var1_25 = arg0_25:ShipExitArch(var0_25)
		else
			var2_25 = arg0_25:ShipEnterArch(var0_25)

			if not var2_25 then
				var3_25 = arg0_25:ShipAddFollower(var0_25)
			end
		end
	end

	if not var1_25 and not var2_25 and not var3_25 then
		arg0_25:RandomNextShipPosition(arg1_25)
	end
end

function var0_0.ShipAddFollower(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetFurnituresByType(Furniture.TYPE_FOLLOWER)

	local function var1_26(arg0_27)
		return _.detect(var0_26, function(arg0_28)
			local var0_28 = arg0_28:GetArea()

			return _.any(var0_28, function(arg0_29)
				return arg0_29 == arg0_27
			end)
		end)
	end

	local function var2_26()
		local var0_30 = arg1_26:GetInterActionData()

		if var0_30 ~= nil then
			var0_30:Stop()
		end
	end

	for iter0_26, iter1_26 in ipairs(arg1_26:GetAroundPositions()) do
		local var3_26 = var1_26(iter1_26)

		if var3_26 and var3_26:CanFollower(arg1_26) then
			var2_26()
			arg0_26:RemoveItemAndRefresh(var3_26)
			var3_26:GetInteractionSlot():Occupy(var3_26, arg1_26, arg0_26)

			return true
		end
	end

	return false
end

function var0_0.ShipExitArch(arg0_31, arg1_31)
	local var0_31 = arg0_31:GetNextPositionForMove(arg1_31)

	if var0_31 then
		local var1_31 = arg1_31:GetParent()

		var1_31:RemoveChild(arg1_31)
		arg0_31:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, arg1_31, var1_31)
		arg0_31:DispatchEvent(CourtYardEvent.EXIT_ARCH, arg1_31, var1_31)
		arg0_31:LockPosition(var0_31)
		arg1_31:UnClear(true)
		arg1_31:Move(var0_31)

		return true
	end

	return false
end

function var0_0.ShipEnterArch(arg0_32, arg1_32)
	local function var0_32(arg0_33, arg1_33)
		arg0_32:RemoveItem(arg1_32)
		arg0_32:DispatchEvent(CourtYardEvent.CHILD_ITEM, arg1_32, arg0_33)
		arg0_32:DispatchEvent(CourtYardEvent.ENTER_ARCH, arg1_32, arg0_33)
		arg0_33:AddChild(arg1_32)
		arg1_32:Move(arg1_33)
	end

	for iter0_32, iter1_32 in ipairs(arg1_32:GetAroundPositions()) do
		local var1_32 = arg0_32:GetParentForItem(arg1_32, iter1_32)

		if var1_32 and var1_32:IsType(Furniture.TYPE_ARCH) then
			var0_32(var1_32, iter1_32)

			return true
		end
	end

	return false
end

function var0_0.RandomNextShipPosition(arg0_34, arg1_34)
	local var0_34 = arg0_34.ships[arg1_34]
	local var1_34 = arg0_34:GetPlaceableArea(var0_34)
	local var2_34 = var1_34:GetNextPositionForMove(var0_34)

	if not var2_34 then
		var0_34:ChangeState(CourtYardShip.STATE_IDLE)

		return
	end

	var1_34:LockPosition(var2_34)
	var0_34:Move(var2_34)
end

function var0_0.MoveShipToNextPosition(arg0_35, arg1_35)
	local var0_35 = arg0_35.ships[arg1_35]
	local var1_35 = arg0_35:GetPlaceableArea(var0_35)
	local var2_35 = var0_35:GetMarkPosition()

	var1_35:_ClearLockPosition(var0_35)

	if var0_35:IsUnClear() then
		var0_35:UnClear(false)
	else
		var1_35:RemoveItem(var0_35)
	end

	var0_35:SetPosition(var2_35)
	var1_35:AddItem(var0_35)
	var0_35:ChangeState(CourtYardShip.STATE_MOVING_ONE)
end

function var0_0.DragShip(arg0_36, arg1_36)
	local var0_36 = arg0_36.ships[arg1_36]

	arg0_36:GetPlaceableArea(var0_36):_ClearLockPosition(var0_36)

	local var1_36 = var0_36:GetPosition()
	local var2_36 = var0_36:GetInterActionData()

	if var2_36 ~= nil or var0_36:GetState() == CourtYardShip.STATE_INTERACT then
		if isa(var2_36, CourtYardFollowerSlot) then
			arg0_36:RemoveItem(var0_36)
		end

		var2_36:Stop()
	elseif var0_36:HasParent() then
		local var3_36 = var0_36:GetParent()

		var3_36:RemoveChild(var0_36)
		var0_36:ChangeState(CourtYardShip.STATE_IDLE)
		arg0_36:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, var0_36, var3_36)
	else
		arg0_36:RemoveItem(var0_36)
	end

	var0_36:ChangeState(CourtYardShip.STATE_DRAG)

	local var4_36 = arg0_36:AreaWithInfo(var0_36, var1_36, var0_36:GetOffset())

	var0_36:UpdateOpFlag(true)
	arg0_36:DispatchEvent(CourtYardEvent.SELETED_ITEM, var0_36, var4_36)
	arg0_36:DispatchEvent(CourtYardEvent.DRAG_ITEM, var0_36)
end

function var0_0.DragingShip(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37.ships[arg1_37]

	if not var0_37:GetOpFlag() then
		return
	end

	local var1_37 = arg0_37:GetParentForItem(var0_37, arg2_37)
	local var2_37 = arg0_37:GetInterActionFurniture(var0_37, arg2_37)
	local var3_37 = var1_37 and var1_37:RawGetOffset() or var0_37:GetOffset()
	local var4_37 = arg0_37:AreaWithInfo(var0_37, arg2_37, var3_37, var2_37 or var1_37)

	arg0_37:DispatchEvent(CourtYardEvent.DRAGING_ITEM, var0_37, var4_37, arg2_37, var3_37)
end

function var0_0.DragShipEnd(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38.ships[arg1_38]

	if not var0_38:GetOpFlag() then
		return
	end

	local var1_38 = arg0_38:LegalPosition(arg2_38, var0_38)
	local var2_38 = arg0_38:GetInterActionFurniture(var0_38, arg2_38)
	local var3_38 = arg0_38:GetParentForItem(var0_38, arg2_38)
	local var4_38

	if not var1_38 and var2_38 then
		if isa(var2_38, CourtYardFollowerFurniture) then
			arg0_38:RemoveItemAndRefresh(var2_38)
			arg0_38:ResetShip(var0_38, arg2_38)
			var0_38:ChangeState(CourtYardShip.STATE_MOVE)
		end

		var2_38:GetInteractionSlot():Occupy(var2_38, var0_38, arg0_38)
	elseif not var1_38 and var3_38 then
		var0_38:SetPosition(arg2_38)
		arg0_38:DispatchEvent(CourtYardEvent.CHILD_ITEM, var0_38, var3_38)
		var3_38:AddChild(var0_38)
		var0_38:ChangeState(CourtYardShip.STATE_IDLE)

		var4_38 = var3_38:AreaWithInfo(var0_38, arg2_38, var3_38:RawGetOffset(), true)
	else
		local var5_38 = var1_38 and arg2_38 or var0_38:GetPosition()

		arg0_38:ResetShip(var0_38, var5_38)

		var4_38 = arg0_38:AreaWithInfo(var0_38, var5_38, var0_38:GetOffset(), true)
	end

	var0_38:UpdateOpFlag(false)
	arg0_38:DispatchEvent(CourtYardEvent.DRAG_ITEM_END, var4_38)
	arg0_38:DispatchEvent(CourtYardEvent.UNSELETED_ITEM, var0_38)
end

function var0_0.GetInterActionFurniture(arg0_39, arg1_39, arg2_39)
	for iter0_39, iter1_39 in pairs(arg0_39.furnitures) do
		if iter1_39:CanInterAction(arg1_39) and iter1_39:IsOverlap(arg2_39) then
			return iter1_39
		end
	end

	return nil
end

function var0_0.TouchShip(arg0_40, arg1_40)
	local var0_40 = arg0_40.ships[arg1_40]

	arg0_40:GetPlaceableArea(var0_40):_ClearLockPosition(var0_40)
	var0_40:ChangeState(CourtYardShip.STATE_TOUCH)
end

function var0_0.UpdateShipIntimacy(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.ships[arg1_41]

	if not var0_41 then
		return
	end

	var0_41:ChangeInimacy(arg2_41)
end

function var0_0.UpdateShipCoin(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg0_42.ships[arg1_42]

	if not var0_42 then
		return
	end

	var0_42:ChangeCoin(arg2_42)
end

function var0_0.ClearShipIntimacy(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.ships[arg1_43]

	if not var0_43 then
		return
	end

	arg0_43:GetPlaceableArea(var0_43):_ClearLockPosition(var0_43)
	var0_43:ClearInimacy(arg2_43)
end

function var0_0.ClearShipCoin(arg0_44, arg1_44)
	local var0_44 = arg0_44.ships[arg1_44]

	if not var0_44 then
		return
	end

	arg0_44:GetPlaceableArea(var0_44):_ClearLockPosition(var0_44)
	var0_44:ClearCoin(value)
end

function var0_0.AddShipExp(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg0_45.ships[arg1_45]

	if not var0_45 then
		return
	end

	var0_45:AddExp(arg2_45)
end

function var0_0.ShipAnimtionFinish(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg0_46.ships[arg1_46]

	if arg2_46 == CourtYardShip.STATE_TOUCH or arg2_46 == CourtYardShip.STATE_GETAWARD then
		var0_46:ChangeState(CourtYardShip.STATE_IDLE)
	elseif arg2_46 == CourtYardShip.STATE_INTERACT then
		local var1_46 = var0_46:GetInterActionData()

		if var1_46 then
			var1_46:Continue(var0_46)
		end
	end
end

function var0_0.ResetShip(arg0_47, arg1_47, arg2_47)
	local function var0_47(arg0_48, arg1_48)
		arg0_48:SetPosition(arg1_48)
		arg0_48:ChangeState(CourtYardShip.STATE_IDLE)
		arg0_47:AddItem(arg0_48)
	end

	if arg0_47:LegalPosition(arg2_47, arg1_47) then
		var0_47(arg1_47, arg2_47)
	else
		local var1_47 = arg0_47:GetRandomPosition(arg1_47)

		if var1_47 then
			var0_47(arg1_47, var1_47)
		else
			arg0_47:RemoveShip(arg1_47)
			arg0_47:GetHost():SendNotification(CourtYardEvent._NO_POS_TO_ADD_SHIP, arg1_47.id)
		end
	end
end

function var0_0.SelectFurniture(arg0_49, arg1_49)
	if not arg0_49.canEidt then
		return
	end

	local var0_49 = arg0_49.furnitures[arg1_49]

	if var0_49:GetOpFlag() then
		return
	end

	local var1_49 = _.detect(_.values(arg0_49.furnitures), function(arg0_50)
		return arg0_50:GetOpFlag()
	end)

	if var1_49 then
		arg0_49:UnSelectFurniture(var1_49.id)
	end

	local var2_49 = var0_49:GetPosition()
	local var3_49 = arg0_49:AreaWithInfo(var0_49, var2_49, var0_49:GetOffset(), true)

	var0_49:UpdateOpFlag(true)
	arg0_49:DispatchEvent(CourtYardEvent.SELETED_ITEM, var0_49, var3_49)
end

function var0_0.ClickFurniture(arg0_51, arg1_51)
	local var0_51 = arg0_51.furnitures[arg1_51]

	if var0_51:HasDescription() then
		arg0_51:DispatchEvent(CourtYardEvent.SHOW_FURNITURE_DESC, var0_51)
	elseif var0_51:CanTouch() then
		if var0_51:GetTouchBg() then
			arg0_51:CheckFurnitureTouchBG(var0_51)
		end

		if not var0_51:IsTouchState() then
			var0_51:ChangeState(CourtYardFurniture.STATE_TOUCH)
			arg0_51:DispatchEvent(CourtYardEvent.ON_TOUCH_ITEM, var0_51)
		else
			var0_51:ChangeState(CourtYardFurniture.STATE_IDLE)
			arg0_51:DispatchEvent(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, var0_51)
		end
	end
end

function var0_0.CheckFurnitureTouchBG(arg0_52, arg1_52)
	for iter0_52, iter1_52 in pairs(arg0_52.furnitures) do
		if iter1_52.id ~= arg1_52.id and iter1_52:IsTouchState() and iter1_52:GetTouchBg() then
			iter1_52:ChangeState(CourtYardFurniture.STATE_IDLE)
			arg0_52:DispatchEvent(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, iter1_52)
		end
	end
end

function var0_0.PlayMusicalInstruments(arg0_53, arg1_53)
	local var0_53 = arg0_53.furnitures[arg1_53]

	arg0_53:MuteAll()
	arg0_53:DispatchEvent(CourtYardEvent.FURNITURE_PLAY_MUSICALINSTRUMENTS, var0_53)
end

function var0_0.StopPlayMusicalInstruments(arg0_54, arg1_54)
	local var0_54 = arg0_54.furnitures[arg1_54]

	arg0_54:DispatchEvent(CourtYardEvent.FURNITURE_STOP_PLAY_MUSICALINSTRUMENTS, var0_54)
end

function var0_0.PlayFurnitureVoice(arg0_55, arg1_55)
	local var0_55 = arg0_55.furnitures[arg1_55]
	local var1_55 = _.select(var0_55.musicDatas, function(arg0_56)
		return arg0_56.voiceType == 1
	end)

	if #var1_55 > 0 then
		local var2_55 = var1_55[math.random(1, #var1_55)]

		arg0_55:DispatchEvent(CourtYardEvent.ON_ITEM_PLAY_MUSIC, var2_55.voice, var2_55.voiceType)
	end
end

function var0_0.PlayFurnitureBg(arg0_57, arg1_57)
	local var0_57 = arg0_57.furnitures[arg1_57]
	local var1_57 = arg0_57:StopPrevFurnitureVoice()

	if var1_57 and var1_57.id == var0_57.id then
		return
	end

	var0_57:ChangeState(CourtYardFurniture.STATE_PLAY_MUSIC)

	local var2_57 = var0_57:GetMusicData()

	if var2_57 then
		arg0_57:DispatchEvent(CourtYardEvent.ON_ITEM_PLAY_MUSIC, var2_57.voice, var2_57.voiceType)
	end
end

function var0_0.MuteAll(arg0_58)
	for iter0_58, iter1_58 in pairs(arg0_58.furnitures) do
		if iter1_58:GetMusicData() then
			local var0_58 = iter1_58:GetMusicData()

			arg0_58:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var0_58.voice, var0_58.voiceType)
			iter1_58:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
		end
	end

	arg0_58:DispatchEvent(CourtYardEvent.FURNITURE_MUTE_ALL)
end

function var0_0.StopPrevFurnitureVoice(arg0_59)
	local var0_59

	for iter0_59, iter1_59 in pairs(arg0_59.furnitures) do
		local var1_59 = iter1_59:GetMusicData()

		if var1_59 and var1_59.voiceType == 2 then
			var0_59 = iter1_59
		end
	end

	if var0_59 then
		local var2_59 = var0_59:GetMusicData()

		arg0_59:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var2_59.voice, var2_59.voiceType)
		var0_59:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
	end

	return var0_59
end

function var0_0.FurnitureAnimtionFinish(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg0_60.furnitures[arg1_60]

	if arg2_60 == CourtYardFurniture.STATE_TOUCH then
		var0_60:ChangeState(CourtYardFurniture.STATE_IDLE)
	elseif arg2_60 == CourtYardFurniture.STATE_INTERACT then
		local var1_60 = var0_60:GetUsingSlots()

		_.each(var1_60, function(arg0_61)
			arg0_61:Continue(var0_60)
		end)
	elseif arg2_60 == CourtYardFurniture.STATE_TOUCH_PREPARE then
		var0_60:_ChangeState(CourtYardFurniture.STATE_TOUCH)
	end
end

function var0_0.BeginDragFurniture(arg0_62, arg1_62)
	if not arg0_62.canEidt then
		return
	end

	local var0_62 = arg0_62.furnitures[arg1_62]

	if not var0_62:GetOpFlag() then
		return
	end

	var0_62:ChangeState(CourtYardFurniture.STATE_DRAG)

	if var0_62:HasParent() then
		local var1_62 = var0_62:GetParent()

		var1_62:RemoveChild(var0_62)
		arg0_62:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, var0_62, var1_62)
	else
		arg0_62:RemoveItem(var0_62)
		arg0_62:DispatchEvent(CourtYardEvent.DRAG_ITEM, var0_62)
	end
end

function var0_0.DragingFurniture(arg0_63, arg1_63, arg2_63)
	if not arg0_63.canEidt then
		return
	end

	local var0_63 = arg0_63.furnitures[arg1_63]

	if not var0_63:GetOpFlag() then
		return
	end

	if isa(var0_63, CourtYardWallFurniture) then
		arg2_63 = var0_63:NormalizePosition(arg2_63, arg0_63.minSizeX)
	end

	local var1_63 = arg0_63:GetParentForItem(var0_63, arg2_63)
	local var2_63 = var1_63 and var1_63:RawGetOffset() or var0_63:GetOffset()
	local var3_63 = var1_63 and var1_63:AreaWithInfo(var0_63, arg2_63, var2_63) or arg0_63:AreaWithInfo(var0_63, arg2_63, var2_63)

	arg0_63:DispatchEvent(CourtYardEvent.DRAGING_ITEM, var0_63, var3_63, arg2_63, var2_63)
end

function var0_0.GetParentForItem(arg0_64, arg1_64, arg2_64)
	local var0_64 = _.select(_.values(arg0_64.furnitures), function(arg0_65)
		return isa(arg0_65, CourtYardCanPutFurniture) and arg0_65:CanPutChildInPosition(arg1_64, arg2_64)
	end)

	table.sort(var0_64, function(arg0_66, arg1_66)
		return (arg0_66.parent and 1 or 0) > (arg1_66.parent and 1 or 0)
	end)

	return var0_64[1]
end

function var0_0.DragFurnitureEnd(arg0_67, arg1_67, arg2_67)
	if not arg0_67.canEidt then
		return
	end

	local var0_67 = arg0_67.furnitures[arg1_67]

	if not var0_67:GetOpFlag() then
		return
	end

	var0_67:ChangeState(CourtYardFurniture.STATE_IDLE)

	if isa(var0_67, CourtYardWallFurniture) then
		arg2_67 = var0_67:NormalizePosition(arg2_67, arg0_67.minSizeX)
	end

	local var1_67 = arg0_67:VerifyDragPositionForFurniture(var0_67, arg2_67)

	if not var1_67 then
		arg0_67:RemoveFurniture(arg1_67)
		arg0_67:DispatchEvent(CourtYardEvent.REMOVE_ILLEGALITY_ITEM)

		return
	end

	if isa(var0_67, CourtYardWallFurniture) then
		var0_67:UpdatePosition(var1_67)
	else
		var0_67:SetPosition(var1_67)
	end

	local var2_67 = arg0_67:GetParentForItem(var0_67, var1_67)
	local var3_67

	if var2_67 then
		arg0_67:DispatchEvent(CourtYardEvent.CHILD_ITEM, var0_67, var2_67)
		var2_67:AddChild(var0_67)

		var3_67 = var2_67:AreaWithInfo(var0_67, var1_67, var2_67:RawGetOffset(), true)
	else
		arg0_67:AddItem(var0_67)

		var3_67 = arg0_67:AreaWithInfo(var0_67, var1_67, var0_67:GetOffset(), true)
	end

	arg0_67:DispatchEvent(CourtYardEvent.DRAG_ITEM_END, var0_67, var3_67)
end

function var0_0.IsLegalAreaForFurniture(arg0_68, arg1_68, arg2_68)
	return _.all(arg1_68:GetAreaByPosition(arg2_68), function(arg0_69)
		return arg0_68:LegalPosition(arg0_69, arg1_68)
	end) or arg0_68:GetParentForItem(arg1_68, arg2_68) ~= nil
end

function var0_0.VerifyDragPositionForFurniture(arg0_70, arg1_70, arg2_70)
	local var0_70

	if arg0_70:IsLegalAreaForFurniture(arg1_70, arg2_70) then
		var0_70 = arg2_70
	else
		local var1_70 = arg1_70:GetPosition()

		if var1_70 and isa(arg1_70, CourtYardWallFurniture) then
			arg1_70:UpdatePosition(var1_70)
		end

		if var1_70 and arg0_70:IsLegalAreaForFurniture(arg1_70, var1_70) then
			var0_70 = var1_70
		else
			if var1_70 and isa(arg1_70, CourtYardWallFurniture) then
				arg1_70:UpdatePosition(arg2_70)
			end

			var0_70 = arg0_70:GetEmptyArea(arg1_70)
		end
	end

	return var0_70
end

function var0_0.UnSelectFurniture(arg0_71, arg1_71)
	local var0_71 = arg0_71.furnitures[arg1_71]

	if not var0_71:GetOpFlag() then
		return
	end

	var0_71:UpdateOpFlag(false)
	arg0_71:DispatchEvent(CourtYardEvent.UNSELETED_ITEM, var0_71)
end

function var0_0.RotateFurniture(arg0_72, arg1_72)
	local var0_72 = arg0_72.furnitures[arg1_72]

	if var0_72:DisableRotation() then
		arg0_72:DispatchEvent(CourtYardEvent.DISABLE_ROTATE_ITEM)
	elseif not arg0_72:CanRotateItem(var0_72) then
		arg0_72:DispatchEvent(CourtYardEvent.ROTATE_ITEM_FAILED)
	else
		local var1_72 = var0_72:HasParent()

		if not var1_72 then
			arg0_72:RemoveItem(var0_72)
		end

		var0_72:Rotate()

		local var2_72 = arg0_72:AreaWithInfo(var0_72, var0_72:GetPosition(), var0_72:GetOffset())

		if not var1_72 then
			arg0_72:AddItem(var0_72)
		end

		arg0_72:DispatchEvent(CourtYardEvent.ROTATE_ITEM, var0_72, var2_72)
	end
end

function var0_0.RemoveFurniture(arg0_73, arg1_73)
	local var0_73 = arg0_73.furnitures[arg1_73]
	local var1_73 = var0_73:HasParent()

	if var1_73 then
		var0_73:GetParent():RemoveChild(var0_73)
	end

	local var2_73 = var0_73.childs or {}

	for iter0_73 = #var2_73, 1, -1 do
		arg0_73:RemoveFurniture(var2_73[iter0_73].id)
	end

	if not var1_73 then
		arg0_73:RemoveItem(var0_73)
	end

	local var3_73 = var0_73:GetMusicData()

	if var3_73 then
		arg0_73:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var3_73.voice, var3_73.voiceType)
		var0_73:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
	end

	arg0_73:UnSelectFurniture(arg1_73)

	local var4_73 = var0_73.configId

	arg0_73.furnitures[arg1_73]:Dispose()

	arg0_73.furnitures[arg1_73] = nil

	arg0_73:DispatchEvent(CourtYardEvent.DETORY_ITEM, var0_73)
	arg0_73.composeChecker:Check()
	arg0_73:RefreshCombineFruniture(var4_73)
end

function var0_0.RemoveAllFurniture(arg0_74)
	for iter0_74, iter1_74 in pairs(arg0_74.furnitures) do
		if not iter1_74:HasParent() then
			arg0_74:RemoveFurniture(iter1_74.id)
		end
	end

	arg0_74:SetWallPaper(nil)
	arg0_74:SetFloorPaper(nil)
end

function var0_0.RemovePaper(arg0_75, arg1_75)
	local var0_75 = arg0_75:GetWallPaper()

	if var0_75 and var0_75.id == arg1_75 then
		arg0_75:SetWallPaper(nil)
	end

	local var1_75 = arg0_75:GetFloorPaper()

	if var1_75 and var1_75.id == arg1_75 then
		arg0_75:SetFloorPaper(nil)
	end
end

function var0_0.CheckFurnitureState(arg0_76)
	for iter0_76, iter1_76 in pairs(arg0_76.furnitures) do
		if iter1_76:IsType(Furniture.TYPE_MOVEABLE) and iter1_76:IsReadyMove() then
			arg0_76:ReadyMoveFurniture(iter1_76.id)
		end
	end
end

function var0_0.ReadyMoveFurniture(arg0_77, arg1_77)
	local var0_77 = arg0_77.furnitures[arg1_77]
	local var1_77 = arg0_77:GetNextPositionForMove(var0_77)

	if not var1_77 then
		var0_77:Rest()

		return
	end

	if var0_77:IsDifferentDirection(var1_77) and arg0_77:CanRotateItem(var0_77) then
		arg0_77:RotateFurniture(arg1_77)
	end

	var0_77:Move(var1_77)
	arg0_77:RemoveItem(var0_77)
	var0_77:SetPosition(var1_77)
	arg0_77:AddItemAndRefresh(var0_77)
end

function var0_0.GetFurnituresByType(arg0_78, arg1_78)
	local var0_78 = {}

	for iter0_78, iter1_78 in pairs(arg0_78.furnitures) do
		if iter1_78:IsType(arg1_78) then
			table.insert(var0_78, iter1_78)
		end
	end

	return var0_78
end

function var0_0.EnterEditMode(arg0_79)
	arg0_79.canEidt = true

	for iter0_79, iter1_79 in pairs(arg0_79.ships) do
		if iter1_79:GetState() == CourtYardShip.STATE_DRAG then
			arg0_79:DragShipEnd(iter1_79.id, Vector2(-1, -1))
		end

		arg0_79:GetPlaceableArea(iter1_79):_ClearLockPosition(iter1_79)

		if iter1_79:HasParent() then
			local var0_79 = iter1_79:GetParent()

			var0_79:RemoveChild(iter1_79)
			arg0_79:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, iter1_79, var0_79)
		else
			arg0_79:RemoveItem(iter1_79)
		end

		iter1_79:ChangeState(CourtYardShip.STATE_STOP)
	end

	for iter2_79, iter3_79 in pairs(arg0_79.furnitures) do
		if iter3_79:IsType(Furniture.TYPE_TRANSPORT) and iter3_79:IsUsing() then
			iter3_79:Stop()
		end

		if iter3_79:IsType(Furniture.TYPE_FOLLOWER) and iter3_79:IsUsing() then
			iter3_79:Stop()
		end

		if iter3_79:IsType(Furniture.TYPE_MOVEABLE) and iter3_79:IsMoving() then
			iter3_79:Stop()
		end

		if iter3_79:IsTouchState() then
			arg0_79:ClickFurniture(iter3_79.id)
		end
	end

	arg0_79.recoder:BeginCheckChange()
	arg0_79:DispatchEvent(CourtYardEvent.ENTER_EDIT_MODE)
end

function var0_0.ExitEditMode(arg0_80)
	for iter0_80, iter1_80 in pairs(arg0_80.ships) do
		if iter1_80:ShouldResetPosition() then
			local var0_80 = iter1_80:GetPosition()

			arg0_80:ResetShip(iter1_80, var0_80)
		end
	end

	for iter2_80, iter3_80 in pairs(arg0_80.furnitures) do
		if iter3_80:IsType(Furniture.TYPE_MOVEABLE) and iter3_80:IsStop() then
			iter3_80:ReStart()

			if iter3_80:CanTouch() then
				arg0_80:ClickFurniture(iter3_80.id)
			end
		end
	end

	local var1_80 = _.detect(_.values(arg0_80.furnitures), function(arg0_81)
		return arg0_81:GetOpFlag()
	end)

	if var1_80 then
		arg0_80:UnSelectFurniture(var1_80.id)
	end

	arg0_80.canEidt = false

	arg0_80.recoder:EndCheckChange()
	arg0_80:DispatchEvent(CourtYardEvent.EXIT_EDIT_MODE)
end

function var0_0.InEidtMode(arg0_82)
	return arg0_82.canEidt
end

function var0_0.StopAllDragState(arg0_83)
	local function var0_83()
		for iter0_84, iter1_84 in pairs(arg0_83.ships) do
			if iter1_84:GetState() == CourtYardShip.STATE_DRAG then
				arg0_83:DragShipEnd(iter1_84.id, Vector2(-1, -1))
			end
		end
	end

	local function var1_83()
		for iter0_85, iter1_85 in pairs(arg0_83.furnitures) do
			if iter1_85:IsDragingState() then
				arg0_83:DragFurnitureEnd(iter1_85.id, Vector2(-1, -1))
				arg0_83:UnSelectFurniture(iter1_85.id)
			end
		end
	end

	if not arg0_83:InEidtMode() then
		var0_83()
	else
		var1_83()
	end
end

function var0_0.StartInteraction(arg0_86, arg1_86)
	local var0_86 = arg1_86:GetUser()
	local var1_86 = arg1_86:GetOwner()

	if isa(var1_86, CourtYardFurniture) and var1_86:GetInterActionBgm() then
		for iter0_86, iter1_86 in pairs(arg0_86.furnitures) do
			if iter1_86:IsPlayMusicState() then
				iter1_86:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
			end
		end
	end

	arg0_86:DispatchEvent(CourtYardEvent.ITEM_INTERACTION, var0_86, var1_86, arg1_86)
end

function var0_0.WillClearInteraction(arg0_87, arg1_87, arg2_87)
	local var0_87 = arg1_87:GetUser()
	local var1_87 = arg1_87:GetOwner()

	arg0_87:DispatchEvent(CourtYardEvent.CLEAR_ITEM_INTERACTION, var0_87, var1_87, arg1_87)
end

function var0_0.ClearInteraction(arg0_88, arg1_88, arg2_88)
	local var0_88 = arg1_88:GetUser()
	local var1_88 = arg1_88:GetOwner()

	if isa(var0_88, CourtYardFollowerFurniture) then
		arg0_88:ClearInteractionForFollower(var0_88, var1_88, arg1_88, arg2_88)
	elseif not arg2_88 then
		if isa(var1_88, CourtYardTransportFurniture) then
			arg0_88:ClearInteractionForTransPort(var0_88, var1_88, arg1_88)
		else
			arg0_88:ResetShip(var0_88, var0_88:GetPosition())
		end
	end
end

function var0_0.ClearInteractionForFollower(arg0_89, arg1_89, arg2_89, arg3_89, arg4_89)
	local var0_89 = arg0_89:GetAroundEmptyArea(arg1_89, arg2_89:GetPosition())

	if not var0_89 then
		arg0_89:DispatchEvent(CourtYardEvent.REMOVE_ILLEGALITY_ITEM)
		arg0_89:RemoveFurniture(arg1_89.id)

		return
	end

	arg1_89:SetPosition(var0_89)
	arg0_89:AddItemAndRefresh(arg1_89)
end

function var0_0.ClearInteractionForTransPort(arg0_90, arg1_90, arg2_90, arg3_90)
	if arg3_90:IsFirstTime() then
		local var0_90 = arg0_90:GetFurnituresByType(Furniture.TYPE_TRANSPORT)
		local var1_90 = _.select(var0_90, function(arg0_91)
			return arg0_91.id ~= arg2_90.id
		end)
		local var2_90 = var1_90[math.random(1, #var1_90)]

		if var2_90 and var2_90:CanInterAction(arg1_90) then
			var2_90:GetInteractionSlot():Link(var2_90, arg1_90, arg0_90)
		else
			arg0_90:ResetShip(arg1_90, arg0_90:GetRandomPosition(arg1_90))
		end
	else
		arg0_90:ResetShip(arg1_90, arg0_90:GetAroundEmptyPosition(arg2_90))
	end
end

function var0_0.LegalPosition(arg0_92, arg1_92, arg2_92)
	return var0_0.super.LegalPosition(arg0_92, arg1_92, arg2_92) and arg2_92:InActivityRange(arg1_92)
end

function var0_0.GetLevel(arg0_93)
	return arg0_93.level
end

function var0_0.Dispose(arg0_94)
	var0_0.super.Dispose(arg0_94)
	arg0_94.recoder:Dispose()

	arg0_94.recoder = nil

	arg0_94.composeChecker:Dispose()

	arg0_94.composeChecker = nil

	for iter0_94, iter1_94 in pairs(arg0_94.ships) do
		iter1_94:Dispose()
	end

	for iter2_94, iter3_94 in pairs(arg0_94.furnitures) do
		iter3_94:Dispose()
	end

	arg0_94.ships = nil
	arg0_94.furnitures = nil
end

function var0_0.GetDirty(arg0_95)
	return arg0_95.recoder:TakeSample()
end

function var0_0.ToTable(arg0_96)
	local var0_96 = {}

	local function var1_96(arg0_97)
		arg0_97.floor = arg0_96.id
		var0_96[arg0_97.id] = arg0_97
	end

	for iter0_96, iter1_96 in pairs(arg0_96.furnitures) do
		var1_96(iter1_96:ToTable())
	end

	if arg0_96.wallPaper then
		var1_96(arg0_96.wallPaper:ToTable())
	end

	if arg0_96.floorPaper then
		var1_96(arg0_96.floorPaper:ToTable())
	end

	return var0_96
end

return var0_0
