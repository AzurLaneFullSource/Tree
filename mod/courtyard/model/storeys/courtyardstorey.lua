local var0 = class("CourtYardStorey", import("..map.CourtYardPlaceableArea"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.super.Ctor(arg0, arg1, arg4)

	arg0.id = arg2
	arg0.style = arg3
	arg0.level = 1
	arg0.furnitures = {}
	arg0.ships = {}
	arg0.canEidt = false
	arg0.recoder = CourtYardStoreyRecorder.New(arg0)
	arg0.composeChecker = CourtYardStoreyComposeChecker.New(arg0)
end

function var0.GetStyle(arg0)
	return arg0.style
end

function var0.SetLevel(arg0, arg1)
	arg0.level = arg1

	local var0 = CourtYardConst.MAX_STOREY_LEVEL * CourtYardConst.OPEN_AREA_PRE_LEVEL - (arg0.level - 1) * CourtYardConst.OPEN_AREA_PRE_LEVEL

	arg0:UpdateMinRange(Vector2(var0, var0))
	arg0:DispatchEvent(CourtYardEvent.UPDATE_STOREY, arg1)
end

function var0.LevelUp(arg0)
	local var0 = arg0.level + 1

	arg0:SetLevel(var0)
	arg0:DispatchEvent(CourtYardEvent.UPDATE_FLOORPAPER, arg0.floorPaper)
	arg0:DispatchEvent(CourtYardEvent.UPDATE_WALLPAPER, arg0.wallPaper)
end

function var0.SetWallPaper(arg0, arg1)
	arg0.wallPaper = arg1

	arg0:DispatchEvent(CourtYardEvent.UPDATE_WALLPAPER, arg1)
	arg0.composeChecker:Check()
end

function var0.SetFloorPaper(arg0, arg1)
	arg0.floorPaper = arg1

	arg0:DispatchEvent(CourtYardEvent.UPDATE_FLOORPAPER, arg1)
	arg0.composeChecker:Check()
end

function var0.GetWallPaper(arg0)
	return arg0.wallPaper
end

function var0.GetFloorPaper(arg0)
	return arg0.floorPaper
end

function var0.GetFurnitures(arg0)
	return arg0.furnitures
end

function var0.GetAllFurniture(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.furnitures) do
		var0[iter1.id] = iter1
	end

	if arg0.floorPaper then
		var0[arg0.floorPaper.id] = arg0.floorPaper
	end

	if arg0.wallPaper then
		var0[arg0.wallPaper.id] = arg0.wallPaper
	end

	return var0
end

function var0.GetShips(arg0)
	return arg0.ships
end

function var0.GetShip(arg0, arg1)
	return arg0.ships[arg1]
end

function var0.GetFurniture(arg0, arg1)
	return arg0.furnitures[arg1]
end

function var0.CanAddFurniture(arg0, arg1)
	return true
end

function var0.AddFurniture(arg0, arg1, arg2)
	arg0.furnitures[arg1.id] = arg1

	arg0:DispatchEvent(CourtYardEvent.CREATE_ITEM, arg1, arg2)
	arg0:AddItem(arg1)
	arg0.composeChecker:Check()

	if arg1:CanTouch() and arg1:TriggerTouchDefault() then
		arg0:ClickFurniture(arg1.id)
	end
end

function var0.AddPaper(arg0, arg1)
	local var0 = arg1:GetType()

	if var0 == Furniture.TYPE_WALLPAPER then
		arg0:SetWallPaper(arg1)
	elseif var0 == Furniture.TYPE_FLOORPAPER then
		arg0:SetFloorPaper(arg1)
	end
end

function var0.AddChildFurniture(arg0, arg1, arg2)
	arg0.furnitures[arg1.id] = arg1

	arg0:DispatchEvent(CourtYardEvent.CREATE_ITEM, arg1)

	local var0 = arg0.furnitures[arg2]

	arg0:DispatchEvent(CourtYardEvent.CHILD_ITEM, arg1, var0)
	var0:AddChild(arg1)
end

function var0.Update(arg0)
	arg0:CheckShipState()
	arg0:CheckFurnitureState()
end

function var0.AddShip(arg0, arg1)
	arg1:ChangeState(CourtYardShip.STATE_IDLE)

	arg0.ships[arg1.id] = arg1

	arg0:DispatchEvent(CourtYardEvent.CREATE_ITEM, arg1)
	arg0:AddItem(arg1)
end

function var0.GetPlaceableArea(arg0, arg1)
	return arg1:HasParent() and arg1:GetParent():GetPlaceableArea() or arg0
end

function var0.RemoveShip(arg0, arg1)
	arg0:GetPlaceableArea(arg1):RemoveItem(arg1)
	arg0.ships[arg1.id]:Dispose()

	arg0.ships[arg1.id] = nil

	arg0:DispatchEvent(CourtYardEvent.DETORY_ITEM, arg1)
end

function var0.ExitShip(arg0, arg1)
	local var0 = arg0.ships[arg1]

	if var0 then
		arg0:RemoveShip(var0)
	end
end

function var0.CheckShipState(arg0)
	for iter0, iter1 in pairs(arg0:GetShips()) do
		local var0 = iter1:GetState()

		if var0 == CourtYardShip.STATE_MOVE then
			arg0:ReadyMoveShip(iter1.id)
		elseif var0 == CourtYardShip.STATE_MOVING_HALF then
			arg0:MoveShipToNextPosition(iter1.id)
		end
	end
end

function var0.ReadyMoveShip(arg0, arg1)
	local var0 = arg0.ships[arg1]
	local var1 = false
	local var2 = false
	local var3 = false

	if CourtYardCalcUtil.HalfProbability() then
		if var0:HasParent() and var0:GetParent():IsType(Furniture.TYPE_ARCH) then
			var1 = arg0:ShipExitArch(var0)
		else
			var2 = arg0:ShipEnterArch(var0)

			if not var2 then
				var3 = arg0:ShipAddFollower(var0)
			end
		end
	end

	if not var1 and not var2 and not var3 then
		arg0:RandomNextShipPosition(arg1)
	end
end

function var0.ShipAddFollower(arg0, arg1)
	local var0 = arg0:GetFurnituresByType(Furniture.TYPE_FOLLOWER)

	local function var1(arg0)
		return _.detect(var0, function(arg0)
			local var0 = arg0:GetArea()

			return _.any(var0, function(arg0)
				return arg0 == arg0
			end)
		end)
	end

	local function var2()
		local var0 = arg1:GetInterActionData()

		if var0 ~= nil then
			var0:Stop()
		end
	end

	for iter0, iter1 in ipairs(arg1:GetAroundPositions()) do
		local var3 = var1(iter1)

		if var3 and var3:CanFollower(arg1) then
			var2()
			arg0:RemoveItemAndRefresh(var3)
			var3:GetInteractionSlot():Occupy(var3, arg1, arg0)

			return true
		end
	end

	return false
end

function var0.ShipExitArch(arg0, arg1)
	local var0 = arg0:GetNextPositionForMove(arg1)

	if var0 then
		local var1 = arg1:GetParent()

		var1:RemoveChild(arg1)
		arg0:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, arg1, var1)
		arg0:DispatchEvent(CourtYardEvent.EXIT_ARCH, arg1, var1)
		arg0:LockPosition(var0)
		arg1:UnClear(true)
		arg1:Move(var0)

		return true
	end

	return false
end

function var0.ShipEnterArch(arg0, arg1)
	local function var0(arg0, arg1)
		arg0:RemoveItem(arg1)
		arg0:DispatchEvent(CourtYardEvent.CHILD_ITEM, arg1, arg0)
		arg0:DispatchEvent(CourtYardEvent.ENTER_ARCH, arg1, arg0)
		arg0:AddChild(arg1)
		arg1:Move(arg1)
	end

	for iter0, iter1 in ipairs(arg1:GetAroundPositions()) do
		local var1 = arg0:GetParentForItem(arg1, iter1)

		if var1 and var1:IsType(Furniture.TYPE_ARCH) then
			var0(var1, iter1)

			return true
		end
	end

	return false
end

function var0.RandomNextShipPosition(arg0, arg1)
	local var0 = arg0.ships[arg1]
	local var1 = arg0:GetPlaceableArea(var0)
	local var2 = var1:GetNextPositionForMove(var0)

	if not var2 then
		var0:ChangeState(CourtYardShip.STATE_IDLE)

		return
	end

	var1:LockPosition(var2)
	var0:Move(var2)
end

function var0.MoveShipToNextPosition(arg0, arg1)
	local var0 = arg0.ships[arg1]
	local var1 = arg0:GetPlaceableArea(var0)
	local var2 = var0:GetMarkPosition()

	var1:_ClearLockPosition(var0)

	if var0:IsUnClear() then
		var0:UnClear(false)
	else
		var1:RemoveItem(var0)
	end

	var0:SetPosition(var2)
	var1:AddItem(var0)
	var0:ChangeState(CourtYardShip.STATE_MOVING_ONE)
end

function var0.DragShip(arg0, arg1)
	local var0 = arg0.ships[arg1]

	arg0:GetPlaceableArea(var0):_ClearLockPosition(var0)

	local var1 = var0:GetPosition()
	local var2 = var0:GetInterActionData()

	if var2 ~= nil or var0:GetState() == CourtYardShip.STATE_INTERACT then
		if isa(var2, CourtYardFollowerSlot) then
			arg0:RemoveItem(var0)
		end

		var2:Stop()
	elseif var0:HasParent() then
		local var3 = var0:GetParent()

		var3:RemoveChild(var0)
		var0:ChangeState(CourtYardShip.STATE_IDLE)
		arg0:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, var0, var3)
	else
		arg0:RemoveItem(var0)
	end

	var0:ChangeState(CourtYardShip.STATE_DRAG)

	local var4 = arg0:AreaWithInfo(var0, var1, var0:GetOffset())

	var0:UpdateOpFlag(true)
	arg0:DispatchEvent(CourtYardEvent.SELETED_ITEM, var0, var4)
	arg0:DispatchEvent(CourtYardEvent.DRAG_ITEM, var0)
end

function var0.DragingShip(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if not var0:GetOpFlag() then
		return
	end

	local var1 = arg0:GetParentForItem(var0, arg2)
	local var2 = arg0:GetInterActionFurniture(var0, arg2)
	local var3 = var1 and var1:RawGetOffset() or var0:GetOffset()
	local var4 = arg0:AreaWithInfo(var0, arg2, var3, var2 or var1)

	arg0:DispatchEvent(CourtYardEvent.DRAGING_ITEM, var0, var4, arg2, var3)
end

function var0.DragShipEnd(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if not var0:GetOpFlag() then
		return
	end

	local var1 = arg0:LegalPosition(arg2, var0)
	local var2 = arg0:GetInterActionFurniture(var0, arg2)
	local var3 = arg0:GetParentForItem(var0, arg2)
	local var4

	if not var1 and var2 then
		if isa(var2, CourtYardFollowerFurniture) then
			arg0:RemoveItemAndRefresh(var2)
			arg0:ResetShip(var0, arg2)
			var0:ChangeState(CourtYardShip.STATE_MOVE)
		end

		var2:GetInteractionSlot():Occupy(var2, var0, arg0)
	elseif not var1 and var3 then
		var0:SetPosition(arg2)
		arg0:DispatchEvent(CourtYardEvent.CHILD_ITEM, var0, var3)
		var3:AddChild(var0)
		var0:ChangeState(CourtYardShip.STATE_IDLE)

		var4 = var3:AreaWithInfo(var0, arg2, var3:RawGetOffset(), true)
	else
		local var5 = var1 and arg2 or var0:GetPosition()

		arg0:ResetShip(var0, var5)

		var4 = arg0:AreaWithInfo(var0, var5, var0:GetOffset(), true)
	end

	var0:UpdateOpFlag(false)
	arg0:DispatchEvent(CourtYardEvent.DRAG_ITEM_END, var4)
	arg0:DispatchEvent(CourtYardEvent.UNSELETED_ITEM, var0)
end

function var0.GetInterActionFurniture(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg0.furnitures) do
		if iter1:CanInterAction(arg1) and iter1:IsOverlap(arg2) then
			return iter1
		end
	end

	return nil
end

function var0.TouchShip(arg0, arg1)
	local var0 = arg0.ships[arg1]

	arg0:GetPlaceableArea(var0):_ClearLockPosition(var0)
	var0:ChangeState(CourtYardShip.STATE_TOUCH)
end

function var0.UpdateShipIntimacy(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if not var0 then
		return
	end

	var0:ChangeInimacy(arg2)
end

function var0.UpdateShipCoin(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if not var0 then
		return
	end

	var0:ChangeCoin(arg2)
end

function var0.ClearShipIntimacy(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if not var0 then
		return
	end

	arg0:GetPlaceableArea(var0):_ClearLockPosition(var0)
	var0:ClearInimacy(arg2)
end

function var0.ClearShipCoin(arg0, arg1)
	local var0 = arg0.ships[arg1]

	if not var0 then
		return
	end

	arg0:GetPlaceableArea(var0):_ClearLockPosition(var0)
	var0:ClearCoin(value)
end

function var0.AddShipExp(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if not var0 then
		return
	end

	var0:AddExp(arg2)
end

function var0.ShipAnimtionFinish(arg0, arg1, arg2)
	local var0 = arg0.ships[arg1]

	if arg2 == CourtYardShip.STATE_TOUCH or arg2 == CourtYardShip.STATE_GETAWARD then
		var0:ChangeState(CourtYardShip.STATE_IDLE)
	elseif arg2 == CourtYardShip.STATE_INTERACT then
		local var1 = var0:GetInterActionData()

		if var1 then
			var1:Continue(var0)
		end
	end
end

function var0.ResetShip(arg0, arg1, arg2)
	local function var0(arg0, arg1)
		arg0:SetPosition(arg1)
		arg0:ChangeState(CourtYardShip.STATE_IDLE)
		arg0:AddItem(arg0)
	end

	if arg0:LegalPosition(arg2, arg1) then
		var0(arg1, arg2)
	else
		local var1 = arg0:GetRandomPosition(arg1)

		if var1 then
			var0(arg1, var1)
		else
			arg0:RemoveShip(arg1)
			arg0:GetHost():SendNotification(CourtYardEvent._NO_POS_TO_ADD_SHIP, arg1.id)
		end
	end
end

function var0.SelectFurniture(arg0, arg1)
	if not arg0.canEidt then
		return
	end

	local var0 = arg0.furnitures[arg1]

	if var0:GetOpFlag() then
		return
	end

	local var1 = _.detect(_.values(arg0.furnitures), function(arg0)
		return arg0:GetOpFlag()
	end)

	if var1 then
		arg0:UnSelectFurniture(var1.id)
	end

	local var2 = var0:GetPosition()
	local var3 = arg0:AreaWithInfo(var0, var2, var0:GetOffset(), true)

	var0:UpdateOpFlag(true)
	arg0:DispatchEvent(CourtYardEvent.SELETED_ITEM, var0, var3)
end

function var0.ClickFurniture(arg0, arg1)
	local var0 = arg0.furnitures[arg1]

	if var0:HasDescription() then
		arg0:DispatchEvent(CourtYardEvent.SHOW_FURNITURE_DESC, var0)
	elseif var0:CanTouch() then
		if var0:GetTouchBg() then
			arg0:CheckFurnitureTouchBG(var0)
		end

		if not var0:IsTouchState() then
			var0:ChangeState(CourtYardFurniture.STATE_TOUCH)
			arg0:DispatchEvent(CourtYardEvent.ON_TOUCH_ITEM, var0)
		else
			var0:ChangeState(CourtYardFurniture.STATE_IDLE)
			arg0:DispatchEvent(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, var0)
		end
	end
end

function var0.CheckFurnitureTouchBG(arg0, arg1)
	for iter0, iter1 in pairs(arg0.furnitures) do
		if iter1.id ~= arg1.id and iter1:IsTouchState() and iter1:GetTouchBg() then
			iter1:ChangeState(CourtYardFurniture.STATE_IDLE)
			arg0:DispatchEvent(CourtYardEvent.ON_CANCEL_TOUCH_ITEM, iter1)
		end
	end
end

function var0.PlayMusicalInstruments(arg0, arg1)
	local var0 = arg0.furnitures[arg1]

	arg0:MuteAll()
	arg0:DispatchEvent(CourtYardEvent.FURNITURE_PLAY_MUSICALINSTRUMENTS, var0)
end

function var0.StopPlayMusicalInstruments(arg0, arg1)
	local var0 = arg0.furnitures[arg1]

	arg0:DispatchEvent(CourtYardEvent.FURNITURE_STOP_PLAY_MUSICALINSTRUMENTS, var0)
end

function var0.PlayFurnitureVoice(arg0, arg1)
	local var0 = arg0.furnitures[arg1]
	local var1 = _.select(var0.musicDatas, function(arg0)
		return arg0.voiceType == 1
	end)

	if #var1 > 0 then
		local var2 = var1[math.random(1, #var1)]

		arg0:DispatchEvent(CourtYardEvent.ON_ITEM_PLAY_MUSIC, var2.voice, var2.voiceType)
	end
end

function var0.PlayFurnitureBg(arg0, arg1)
	local var0 = arg0.furnitures[arg1]
	local var1 = arg0:StopPrevFurnitureVoice()

	if var1 and var1.id == var0.id then
		return
	end

	var0:ChangeState(CourtYardFurniture.STATE_PLAY_MUSIC)

	local var2 = var0:GetMusicData()

	if var2 then
		arg0:DispatchEvent(CourtYardEvent.ON_ITEM_PLAY_MUSIC, var2.voice, var2.voiceType)
	end
end

function var0.MuteAll(arg0)
	for iter0, iter1 in pairs(arg0.furnitures) do
		if iter1:GetMusicData() then
			local var0 = iter1:GetMusicData()

			arg0:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var0.voice, var0.voiceType)
			iter1:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
		end
	end

	arg0:DispatchEvent(CourtYardEvent.FURNITURE_MUTE_ALL)
end

function var0.StopPrevFurnitureVoice(arg0)
	local var0

	for iter0, iter1 in pairs(arg0.furnitures) do
		local var1 = iter1:GetMusicData()

		if var1 and var1.voiceType == 2 then
			var0 = iter1
		end
	end

	if var0 then
		local var2 = var0:GetMusicData()

		arg0:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var2.voice, var2.voiceType)
		var0:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
	end

	return var0
end

function var0.FurnitureAnimtionFinish(arg0, arg1, arg2)
	local var0 = arg0.furnitures[arg1]

	if arg2 == CourtYardFurniture.STATE_TOUCH then
		var0:ChangeState(CourtYardFurniture.STATE_IDLE)
	elseif arg2 == CourtYardFurniture.STATE_INTERACT then
		local var1 = var0:GetUsingSlots()

		_.each(var1, function(arg0)
			arg0:Continue(var0)
		end)
	elseif arg2 == CourtYardFurniture.STATE_TOUCH_PREPARE then
		var0:_ChangeState(CourtYardFurniture.STATE_TOUCH)
	end
end

function var0.BeginDragFurniture(arg0, arg1)
	if not arg0.canEidt then
		return
	end

	local var0 = arg0.furnitures[arg1]

	if not var0:GetOpFlag() then
		return
	end

	var0:ChangeState(CourtYardFurniture.STATE_DRAG)

	if var0:HasParent() then
		local var1 = var0:GetParent()

		var1:RemoveChild(var0)
		arg0:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, var0, var1)
	else
		arg0:RemoveItem(var0)
		arg0:DispatchEvent(CourtYardEvent.DRAG_ITEM, var0)
	end
end

function var0.DragingFurniture(arg0, arg1, arg2)
	if not arg0.canEidt then
		return
	end

	local var0 = arg0.furnitures[arg1]

	if not var0:GetOpFlag() then
		return
	end

	if isa(var0, CourtYardWallFurniture) then
		arg2 = var0:NormalizePosition(arg2, arg0.minSizeX)
	end

	local var1 = arg0:GetParentForItem(var0, arg2)
	local var2 = var1 and var1:RawGetOffset() or var0:GetOffset()
	local var3 = var1 and var1:AreaWithInfo(var0, arg2, var2) or arg0:AreaWithInfo(var0, arg2, var2)

	arg0:DispatchEvent(CourtYardEvent.DRAGING_ITEM, var0, var3, arg2, var2)
end

function var0.GetParentForItem(arg0, arg1, arg2)
	local var0 = _.select(_.values(arg0.furnitures), function(arg0)
		return isa(arg0, CourtYardCanPutFurniture) and arg0:CanPutChildInPosition(arg1, arg2)
	end)

	table.sort(var0, function(arg0, arg1)
		return (arg0.parent and 1 or 0) > (arg1.parent and 1 or 0)
	end)

	return var0[1]
end

function var0.DragFurnitureEnd(arg0, arg1, arg2)
	if not arg0.canEidt then
		return
	end

	local var0 = arg0.furnitures[arg1]

	if not var0:GetOpFlag() then
		return
	end

	var0:ChangeState(CourtYardFurniture.STATE_IDLE)

	if isa(var0, CourtYardWallFurniture) then
		arg2 = var0:NormalizePosition(arg2, arg0.minSizeX)
	end

	local var1 = arg0:VerifyDragPositionForFurniture(var0, arg2)

	if not var1 then
		arg0:RemoveFurniture(arg1)
		arg0:DispatchEvent(CourtYardEvent.REMOVE_ILLEGALITY_ITEM)

		return
	end

	if isa(var0, CourtYardWallFurniture) then
		var0:UpdatePosition(var1)
	else
		var0:SetPosition(var1)
	end

	local var2 = arg0:GetParentForItem(var0, var1)
	local var3

	if var2 then
		arg0:DispatchEvent(CourtYardEvent.CHILD_ITEM, var0, var2)
		var2:AddChild(var0)

		var3 = var2:AreaWithInfo(var0, var1, var2:RawGetOffset(), true)
	else
		arg0:AddItem(var0)

		var3 = arg0:AreaWithInfo(var0, var1, var0:GetOffset(), true)
	end

	arg0:DispatchEvent(CourtYardEvent.DRAG_ITEM_END, var0, var3)
end

function var0.IsLegalAreaForFurniture(arg0, arg1, arg2)
	return _.all(arg1:GetAreaByPosition(arg2), function(arg0)
		return arg0:LegalPosition(arg0, arg1)
	end) or arg0:GetParentForItem(arg1, arg2) ~= nil
end

function var0.VerifyDragPositionForFurniture(arg0, arg1, arg2)
	local var0

	if arg0:IsLegalAreaForFurniture(arg1, arg2) then
		var0 = arg2
	else
		local var1 = arg1:GetPosition()

		if var1 and isa(arg1, CourtYardWallFurniture) then
			arg1:UpdatePosition(var1)
		end

		if var1 and arg0:IsLegalAreaForFurniture(arg1, var1) then
			var0 = var1
		else
			if var1 and isa(arg1, CourtYardWallFurniture) then
				arg1:UpdatePosition(arg2)
			end

			var0 = arg0:GetEmptyArea(arg1)
		end
	end

	return var0
end

function var0.UnSelectFurniture(arg0, arg1)
	local var0 = arg0.furnitures[arg1]

	if not var0:GetOpFlag() then
		return
	end

	var0:UpdateOpFlag(false)
	arg0:DispatchEvent(CourtYardEvent.UNSELETED_ITEM, var0)
end

function var0.RotateFurniture(arg0, arg1)
	local var0 = arg0.furnitures[arg1]

	if var0:DisableRotation() then
		arg0:DispatchEvent(CourtYardEvent.DISABLE_ROTATE_ITEM)
	elseif not arg0:CanRotateItem(var0) then
		arg0:DispatchEvent(CourtYardEvent.ROTATE_ITEM_FAILED)
	else
		local var1 = var0:HasParent()

		if not var1 then
			arg0:RemoveItem(var0)
		end

		var0:Rotate()

		local var2 = arg0:AreaWithInfo(var0, var0:GetPosition(), var0:GetOffset())

		if not var1 then
			arg0:AddItem(var0)
		end

		arg0:DispatchEvent(CourtYardEvent.ROTATE_ITEM, var0, var2)
	end
end

function var0.RemoveFurniture(arg0, arg1)
	local var0 = arg0.furnitures[arg1]
	local var1 = var0:HasParent()

	if var1 then
		var0:GetParent():RemoveChild(var0)
	end

	local var2 = var0.childs or {}

	for iter0 = #var2, 1, -1 do
		arg0:RemoveFurniture(var2[iter0].id)
	end

	if not var1 then
		arg0:RemoveItem(var0)
	end

	local var3 = var0:GetMusicData()

	if var3 then
		arg0:DispatchEvent(CourtYardEvent.ON_ITEM_STOP_MUSIC, var3.voice, var3.voiceType)
		var0:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
	end

	arg0:UnSelectFurniture(arg1)
	arg0.furnitures[arg1]:Dispose()

	arg0.furnitures[arg1] = nil

	arg0:DispatchEvent(CourtYardEvent.DETORY_ITEM, var0)
	arg0.composeChecker:Check()
end

function var0.RemoveAllFurniture(arg0)
	for iter0, iter1 in pairs(arg0.furnitures) do
		if not iter1:HasParent() then
			arg0:RemoveFurniture(iter1.id)
		end
	end

	arg0:SetWallPaper(nil)
	arg0:SetFloorPaper(nil)
end

function var0.RemovePaper(arg0, arg1)
	local var0 = arg0:GetWallPaper()

	if var0 and var0.id == arg1 then
		arg0:SetWallPaper(nil)
	end

	local var1 = arg0:GetFloorPaper()

	if var1 and var1.id == arg1 then
		arg0:SetFloorPaper(nil)
	end
end

function var0.CheckFurnitureState(arg0)
	for iter0, iter1 in pairs(arg0.furnitures) do
		if iter1:IsType(Furniture.TYPE_MOVEABLE) and iter1:IsReadyMove() then
			arg0:ReadyMoveFurniture(iter1.id)
		end
	end
end

function var0.ReadyMoveFurniture(arg0, arg1)
	local var0 = arg0.furnitures[arg1]
	local var1 = arg0:GetNextPositionForMove(var0)

	if not var1 then
		var0:Rest()

		return
	end

	if var0:IsDifferentDirection(var1) and arg0:CanRotateItem(var0) then
		arg0:RotateFurniture(arg1)
	end

	var0:Move(var1)
	arg0:RemoveItem(var0)
	var0:SetPosition(var1)
	arg0:AddItemAndRefresh(var0)
end

function var0.GetFurnituresByType(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.furnitures) do
		if iter1:IsType(arg1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.EnterEditMode(arg0)
	arg0.canEidt = true

	for iter0, iter1 in pairs(arg0.ships) do
		if iter1:GetState() == CourtYardShip.STATE_DRAG then
			arg0:DragShipEnd(iter1.id, Vector2(-1, -1))
		end

		arg0:GetPlaceableArea(iter1):_ClearLockPosition(iter1)

		if iter1:HasParent() then
			local var0 = iter1:GetParent()

			var0:RemoveChild(iter1)
			arg0:DispatchEvent(CourtYardEvent.UN_CHILD_ITEM, iter1, var0)
		else
			arg0:RemoveItem(iter1)
		end

		iter1:ChangeState(CourtYardShip.STATE_STOP)
	end

	for iter2, iter3 in pairs(arg0.furnitures) do
		if iter3:IsType(Furniture.TYPE_TRANSPORT) and iter3:IsUsing() then
			iter3:Stop()
		end

		if iter3:IsType(Furniture.TYPE_FOLLOWER) and iter3:IsUsing() then
			iter3:Stop()
		end

		if iter3:IsType(Furniture.TYPE_MOVEABLE) and iter3:IsMoving() then
			iter3:Stop()
		end

		if iter3:IsTouchState() then
			arg0:ClickFurniture(iter3.id)
		end
	end

	arg0.recoder:BeginCheckChange()
	arg0:DispatchEvent(CourtYardEvent.ENTER_EDIT_MODE)
end

function var0.ExitEditMode(arg0)
	for iter0, iter1 in pairs(arg0.ships) do
		if iter1:ShouldResetPosition() then
			local var0 = iter1:GetPosition()

			arg0:ResetShip(iter1, var0)
		end
	end

	for iter2, iter3 in pairs(arg0.furnitures) do
		if iter3:IsType(Furniture.TYPE_MOVEABLE) and iter3:IsStop() then
			iter3:ReStart()

			if iter3:CanTouch() then
				arg0:ClickFurniture(iter3.id)
			end
		end
	end

	local var1 = _.detect(_.values(arg0.furnitures), function(arg0)
		return arg0:GetOpFlag()
	end)

	if var1 then
		arg0:UnSelectFurniture(var1.id)
	end

	arg0.canEidt = false

	arg0.recoder:EndCheckChange()
	arg0:DispatchEvent(CourtYardEvent.EXIT_EDIT_MODE)
end

function var0.InEidtMode(arg0)
	return arg0.canEidt
end

function var0.StopAllDragState(arg0)
	local function var0()
		for iter0, iter1 in pairs(arg0.ships) do
			if iter1:GetState() == CourtYardShip.STATE_DRAG then
				arg0:DragShipEnd(iter1.id, Vector2(-1, -1))
			end
		end
	end

	local function var1()
		for iter0, iter1 in pairs(arg0.furnitures) do
			if iter1:IsDragingState() then
				arg0:DragFurnitureEnd(iter1.id, Vector2(-1, -1))
				arg0:UnSelectFurniture(iter1.id)
			end
		end
	end

	if not arg0:InEidtMode() then
		var0()
	else
		var1()
	end
end

function var0.StartInteraction(arg0, arg1)
	local var0 = arg1:GetUser()
	local var1 = arg1:GetOwner()

	if isa(var1, CourtYardFurniture) and var1:GetInterActionBgm() then
		for iter0, iter1 in pairs(arg0.furnitures) do
			if iter1:IsPlayMusicState() then
				iter1:ChangeState(CourtYardFurniture.STATE_STOP_MUSIC)
			end
		end
	end

	arg0:DispatchEvent(CourtYardEvent.ITEM_INTERACTION, var0, var1, arg1)
end

function var0.WillClearInteraction(arg0, arg1, arg2)
	local var0 = arg1:GetUser()
	local var1 = arg1:GetOwner()

	arg0:DispatchEvent(CourtYardEvent.CLEAR_ITEM_INTERACTION, var0, var1, arg1)
end

function var0.ClearInteraction(arg0, arg1, arg2)
	local var0 = arg1:GetUser()
	local var1 = arg1:GetOwner()

	if isa(var0, CourtYardFollowerFurniture) then
		arg0:ClearInteractionForFollower(var0, var1, arg1, arg2)
	elseif not arg2 then
		if isa(var1, CourtYardTransportFurniture) then
			arg0:ClearInteractionForTransPort(var0, var1, arg1)
		else
			arg0:ResetShip(var0, var0:GetPosition())
		end
	end
end

function var0.ClearInteractionForFollower(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:GetAroundEmptyArea(arg1, arg2:GetPosition())

	if not var0 then
		arg0:DispatchEvent(CourtYardEvent.REMOVE_ILLEGALITY_ITEM)
		arg0:RemoveFurniture(arg1.id)

		return
	end

	arg1:SetPosition(var0)
	arg0:AddItemAndRefresh(arg1)
end

function var0.ClearInteractionForTransPort(arg0, arg1, arg2, arg3)
	if arg3:IsFirstTime() then
		local var0 = arg0:GetFurnituresByType(Furniture.TYPE_TRANSPORT)
		local var1 = _.select(var0, function(arg0)
			return arg0.id ~= arg2.id
		end)
		local var2 = var1[math.random(1, #var1)]

		if var2 and var2:CanInterAction(arg1) then
			var2:GetInteractionSlot():Link(var2, arg1, arg0)
		else
			arg0:ResetShip(arg1, arg0:GetRandomPosition(arg1))
		end
	else
		arg0:ResetShip(arg1, arg0:GetAroundEmptyPosition(arg2))
	end
end

function var0.LegalPosition(arg0, arg1, arg2)
	return var0.super.LegalPosition(arg0, arg1, arg2) and arg2:InActivityRange(arg1)
end

function var0.GetLevel(arg0)
	return arg0.level
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0.recoder:Dispose()

	arg0.recoder = nil

	arg0.composeChecker:Dispose()

	arg0.composeChecker = nil

	for iter0, iter1 in pairs(arg0.ships) do
		iter1:Dispose()
	end

	for iter2, iter3 in pairs(arg0.furnitures) do
		iter3:Dispose()
	end

	arg0.ships = nil
	arg0.furnitures = nil
end

function var0.GetDirty(arg0)
	return arg0.recoder:TakeSample()
end

function var0.ToTable(arg0)
	local var0 = {}

	local function var1(arg0)
		arg0.floor = arg0.id
		var0[arg0.id] = arg0
	end

	for iter0, iter1 in pairs(arg0.furnitures) do
		var1(iter1:ToTable())
	end

	if arg0.wallPaper then
		var1(arg0.wallPaper:ToTable())
	end

	if arg0.floorPaper then
		var1(arg0.floorPaper:ToTable())
	end

	return var0
end

return var0
