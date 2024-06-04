local var0 = class("CourtYardController")

function var0.Ctor(arg0, arg1, arg2)
	arg0.bridge = arg1
	arg0.system = arg2.system
	arg0.storeyId = arg2.storeyId
	arg0.storeyDatas = arg2.storeys
	arg0.storey = arg0:System2Storey(arg2)
	arg0.isInit = false
end

function var0.GetBridge(arg0)
	return arg0.bridge
end

function var0.IsLoaed(arg0)
	return arg0.isInit
end

function var0.SetUp(arg0)
	local var0 = arg0.storeyDatas[arg0.storeyId]

	arg0.storey:SetLevel(var0.level)

	local var1 = var0.furnitures[1]

	if not var1 or not var0.IsFloorPaper(var1) then
		arg0.storey:SetFloorPaper(nil)
	end

	local var2 = math.ceil(#var0.furnitures / 3)
	local var3 = {}

	for iter0, iter1 in ipairs(var0.furnitures) do
		table.insert(var3, function(arg0)
			arg0:AddFurniture({
				id = iter1.id,
				configId = iter1.configId,
				dir = iter1.dir,
				parent = iter1.parent,
				position = iter1.position,
				date = iter1.date
			}, true)

			if (iter0 - 1) % var2 == 0 then
				onNextTick(arg0)
			else
				arg0()
			end
		end)
	end

	for iter2, iter3 in ipairs(var0.ships) do
		table.insert(var3, function(arg0)
			arg0:AddShip(iter3)
			onNextTick(arg0)
		end)
	end

	seriesAsync(var3, function()
		if arg0.storey then
			arg0.storey:DispatchEvent(CourtYardEvent.INITED)
		end

		arg0.isInit = true

		arg0:SendNotification(CourtYardEvent._INITED)
	end)
end

function var0.Update(arg0)
	if arg0.storey then
		arg0.storey:Update()
	end
end

function var0.GetStorey(arg0)
	return arg0.storey
end

function var0.AddFurniture(arg0, arg1, arg2)
	if not arg0.storey then
		return
	end

	local function var0(arg0, arg1)
		local var0 = arg0:DataToFurnitureVO(arg1)

		var0:Init(arg1, arg1.dir or 1)

		return arg0.storey:IsLegalAreaForFurniture(var0, arg1)
	end

	local var1 = arg0:DataToFurnitureVO(arg1)

	var1.selectedFlag = arg1.selected

	if not arg0.storey:CanAddFurniture(var1) then
		return
	end

	local var2 = var1:GetType()

	if arg1.parent and arg1.parent ~= 0 then
		var1:Init(arg1.position, arg1.dir or 1)
		arg0.storey:AddChildFurniture(var1, arg1.parent)
	elseif var2 == Furniture.TYPE_WALLPAPER or var2 == Furniture.TYPE_FLOORPAPER then
		arg0.storey:AddPaper(var1)
	else
		local var3 = arg1.position or arg0.storey:GetEmptyArea(var1)

		if not var3 then
			arg0.storey:DispatchEvent(CourtYardEvent.ADD_ITEM_FAILED)
		elseif var3 and var0(var1, var3) then
			var1:Init(var3, arg1.dir or 1)
			arg0.storey:AddFurniture(var1, arg2)
		else
			arg0:SendNotification(CourtYardEvent._ADD_ITEM_FAILED, var1.id)
		end
	end

	arg0:CheckChange()
end

function var0.AddShip(arg0, arg1)
	if not arg0.storey then
		return
	end

	local var0 = arg0:DataToShip(arg1)
	local var1 = arg0.storey:GetRandomPosition(var0)

	if var1 then
		var0:SetPosition(var1)
		arg0.storey:AddShip(var0)
	else
		arg0:SendNotification(CourtYardEvent._NO_POS_TO_ADD_SHIP, var0.id)
	end
end

function var0.AddVisitorShip(arg0, arg1)
	if not arg0.storey then
		return
	end

	local var0 = arg0:DataToVisitorShip(arg1)
	local var1 = arg0.storey:GetRandomPosition(var0)

	if var1 then
		var0:SetPosition(var1)
		arg0.storey:AddShip(var0)
	end
end

function var0.ExitShip(arg0, arg1)
	arg0.storey:ExitShip(arg1)
end

function var0.Extend(arg0)
	arg0:SendNotification(CourtYardEvent._EXTEND)
end

function var0.LevelUp(arg0)
	arg0.storey:LevelUp(id)
end

function var0.DragShip(arg0, arg1)
	arg0.storey:DragShip(arg1)
	arg0:SendNotification(CourtYardEvent._DRAG_ITEM)
end

function var0.DragingShip(arg0, arg1, arg2)
	arg0.storey:DragingShip(arg1, arg2)
end

function var0.DragShipEnd(arg0, arg1, arg2)
	arg0.storey:DragShipEnd(arg1, arg2)
	arg0:SendNotification(CourtYardEvent._DRAG_ITEM_END)
end

function var0.TouchShip(arg0, arg1)
	arg0.storey:TouchShip(arg1)
	arg0:SendNotification(CourtYardEvent._TOUCH_SHIP, arg1)
end

function var0.GetShipInimacy(arg0, arg1)
	arg0:SendNotification(GAME.BACKYARD_ADD_INTIMACY, arg1)
end

function var0.GetShipCoin(arg0, arg1)
	arg0:SendNotification(GAME.BACKYARD_ADD_MONEY, arg1)
end

function var0.ClearShipCoin(arg0, arg1)
	arg0.storey:ClearShipCoin(arg1)
end

function var0.ClearShipIntimacy(arg0, arg1)
	arg0.storey:ClearShipIntimacy(arg1)
end

function var0.UpdateShipCoinAndIntimacy(arg0, arg1, arg2, arg3)
	arg0.storey:UpdateShipCoin(arg1, arg2)
	arg0.storey:UpdateShipIntimacy(arg1, arg3)
end

function var0.AddShipExp(arg0, arg1, arg2)
	arg0.storey:AddShipExp(arg1, arg2)
end

function var0.ShipAnimtionFinish(arg0, arg1, arg2)
	arg0.storey:ShipAnimtionFinish(arg1, arg2)
end

function var0.GetMaxCntForShip(arg0)
	return #arg0.storey:GetEmptyPositions(CourtYardShip.New(arg0, Ship.New({
		id = 999,
		configId = 100001
	}))) + table.getCount(arg0.storey:GetShips())
end

function var0.SelectFurnitureByConfigId(arg0, arg1)
	if arg0.storey.wallPaper and arg0.storey.wallPaper.configId == arg1 then
		return
	end

	if arg0.storey.floorPaper and arg0.storey.floorPaper.configId == arg1 then
		return
	end

	local var0

	for iter0, iter1 in pairs(arg0.storey.furnitures) do
		if iter1.configId == arg1 then
			var0 = iter1

			break
		end
	end

	if var0 then
		arg0:SelectFurniture(var0.id)
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("courtyard_tip_furniture_not_in_layer"))
	end
end

function var0.SelectFurniture(arg0, arg1)
	if arg0.storey:InEidtMode() then
		arg0.storey:SelectFurniture(arg1)

		local var0 = arg0.storey:GetFurniture(arg1)

		if var0:GetOpFlag() then
			arg0:SendNotification(CourtYardEvent._FURNITURE_SELECTED, var0.configId)
		end
	else
		arg0.storey:ClickFurniture(arg1)
	end
end

function var0.PlayFurnitureVoice(arg0, arg1)
	arg0.storey:PlayFurnitureVoice(arg1)
end

function var0.PlayMusicalInstruments(arg0, arg1)
	arg0.storey:PlayMusicalInstruments(arg1)
end

function var0.StopPlayMusicalInstruments(arg0, arg1)
	arg0.storey:StopPlayMusicalInstruments(arg1)
end

function var0.PlayFurnitureBg(arg0, arg1)
	arg0.storey:PlayFurnitureBg(arg1)
end

function var0.UnSelectFurniture(arg0, arg1)
	arg0.storey:UnSelectFurniture(arg1)

	if not arg0.storey:GetFurniture(arg1):GetOpFlag() then
		arg0:SendNotification(CourtYardEvent._FURNITURE_SELECTED, -99999)
	end
end

function var0.BeginDragFurniture(arg0, arg1)
	arg0.storey:BeginDragFurniture(arg1)
	arg0:SendNotification(CourtYardEvent._DRAG_ITEM)
end

function var0.DragingFurniture(arg0, arg1, arg2)
	arg0.storey:DragingFurniture(arg1, arg2)
end

function var0.DragFurnitureEnd(arg0, arg1, arg2)
	arg0.storey:DragFurnitureEnd(arg1, arg2)
	arg0:CheckChange()
	arg0:SendNotification(CourtYardEvent._DRAG_ITEM_END)
end

function var0.FurnitureAnimtionFinish(arg0, arg1, arg2)
	arg0.storey:FurnitureAnimtionFinish(arg1, arg2)
end

function var0.RotateFurniture(arg0, arg1)
	arg0.storey:RotateFurniture(arg1)
	arg0:CheckChange()
end

function var0.RemoveFurniture(arg0, arg1)
	arg0.storey:RemoveFurniture(arg1)
	arg0:CheckChange()
end

function var0.RemovePaper(arg0, arg1)
	arg0.storey:RemovePaper(arg1)
	arg0:CheckChange()
end

function var0.ClearFurnitures(arg0)
	arg0.storey:RemoveAllFurniture()
	arg0:CheckChange()
end

function var0.SaveFurnitures(arg0)
	if arg0.storey.recoder:HasChange() then
		local var0 = arg0.storey:ToTable()

		arg0:SendNotification(GAME.PUT_FURNITURE, {
			tip = true,
			furnsPos = var0
		})
	end

	arg0:ExitEditMode()
end

function var0.GetStoreyData(arg0)
	return (arg0.storey:ToTable())
end

function var0.RestoreFurnitures(arg0)
	arg0:ClearFurnitures()

	local var0 = arg0.storey.recoder:GetHeadSample()

	for iter0, iter1 in ipairs(var0) do
		arg0:AddFurniture(iter1)
	end

	arg0:ExitEditMode()
end

function var0.EnterEditMode(arg0)
	arg0.storey:EnterEditMode()
	arg0:SendNotification(CourtYardEvent._ENTER_MODE)
end

function var0.ExitEditMode(arg0)
	arg0.storey:ExitEditMode()
	arg0:SendNotification(CourtYardEvent._EXIT_MODE)
end

function var0.CheckChange(arg0)
	local var0, var1 = arg0.storey:GetDirty()

	if var0 and var1 then
		arg0:SendNotification(CourtYardEvent._SYN_FURNITURE, {
			var0,
			var1
		})
	end
end

function var0.Quit(arg0)
	if arg0.storey:InEidtMode() then
		if arg0.storey.recoder:HasChange() then
			arg0.storey:DispatchEvent(CourtYardEvent.REMIND_SAVE)
		else
			arg0:ExitEditMode()
		end
	else
		arg0:SendNotification(CourtYardEvent._QUIT)
	end
end

function var0.IsVisit(arg0)
	return arg0.system == CourtYardConst.SYSTEM_VISIT
end

function var0.IsFeast(arg0)
	return arg0.system == CourtYardConst.SYSTEM_FEAST
end

function var0.IsEditModeOrIsVisit(arg0)
	return arg0:IsVisit() or arg0.storey:InEidtMode()
end

function var0.Receive(arg0, arg1, ...)
	if not arg0.storey then
		return
	end

	arg0[arg1](arg0, ...)
end

function var0.OnTakeThemePhoto(arg0)
	if arg0.storey then
		arg0.storey:DispatchEvent(CourtYardEvent.TAKE_PHOTO)
	end
end

function var0.OnEndTakeThemePhoto(arg0)
	if arg0.storey then
		arg0.storey:DispatchEvent(CourtYardEvent.END_TAKE_PHOTO)
	end
end

function var0.OnApplicationPaused(arg0)
	if arg0.storey then
		arg0.storey:StopAllDragState()
		arg0:SendNotification(CourtYardEvent._DRAG_ITEM_END)
	end
end

function var0.OnOpenLayerOrCloseLayer(arg0, arg1, arg2)
	if not arg2 or not arg0.storey then
		return
	end

	arg0.storey:DispatchEvent(CourtYardEvent.OPEN_LAYER, arg1)
end

function var0.OnBackPressed(arg0)
	if arg0.storey then
		arg0.storey:DispatchEvent(CourtYardEvent.BACK_PRESSED)
	end
end

function var0.Dispose(arg0)
	if arg0.storey then
		arg0.storey:Dispose()

		arg0.storey = nil
	end
end

function var0.IsFloorPaper(arg0)
	return pg.furniture_data_template[arg0.configId].type == Furniture.TYPE_FLOORPAPER
end

function var0.DataToFurnitureVO(arg0, arg1)
	local var0 = pg.furniture_data_template[arg1.configId]

	if var0.type == Furniture.TYPE_WALLPAPER or var0.type == Furniture.TYPE_FLOORPAPER then
		return CourtYardPaper.New(arg0, arg1)
	elseif var0.type == Furniture.TYPE_FOLLOWER then
		return CourtYardFollowerFurniture.New(arg0, arg1)
	elseif var0.type == Furniture.TYPE_RANDOM_CONTROLLER then
		return CourtYardRandomControllerFurniture.New(arg0, arg1)
	elseif var0.type == Furniture.TYPE_MAT then
		return CourtYardMatFurniture.New(arg0, arg1)
	elseif var0.type == Furniture.TYPE_TRANSPORT then
		return CourtYardTransportFurniture.New(arg0, arg1)
	elseif var0.type == Furniture.TYPE_WALL_MAT then
		return CourtYardWallMatFurniture.New(arg0, arg1)
	elseif var0.type == Furniture.TYPE_STAGE or var0.type == Furniture.TYPE_ARCH then
		return CourtYardStageFurniture.New(arg0, arg1)
	elseif var0.type == Furniture.TYPE_MOVEABLE then
		return CourtYardMoveableFurniture.New(arg0, arg1)
	elseif var0.belong == 1 and var0.canputon == 1 then
		return CourtYardCanPutFurniture.New(arg0, arg1)
	elseif var0.belong > 1 then
		return CourtYardWallFurniture.New(arg0, arg1)
	else
		return CourtYardFurniture.New(arg0, arg1)
	end
end

function var0.DataToShip(arg0, arg1)
	if arg0.system == CourtYardConst.SYSTEM_FEAST then
		return CourtYardFeastShip.New(arg0, arg1)
	else
		return CourtYardShip.New(arg0, arg1)
	end
end

function var0.DataToVisitorShip(arg0, arg1)
	return CourtYardVisitorShip.New(arg0, arg1)
end

function var0.System2Storey(arg0, arg1)
	local var0 = Vector4(arg1.mapSize.z + 1, arg1.mapSize.w + 1, arg1.mapSize.x, arg1.mapSize.y)

	if arg1.system == CourtYardConst.SYSTEM_OUTSIDE then
		return CourtYardOutStorey.New(arg0, arg1.storeyId, arg1.style, var0)
	else
		return CourtYardStorey.New(arg0, arg1.storeyId, arg1.style, var0)
	end
end

function var0.SendNotification(arg0, ...)
	if arg0.bridge then
		arg0.bridge:SendNotification(...)
	end
end

return var0
