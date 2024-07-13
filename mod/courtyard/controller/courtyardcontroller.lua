local var0_0 = class("CourtYardController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.bridge = arg1_1
	arg0_1.system = arg2_1.system
	arg0_1.storeyId = arg2_1.storeyId
	arg0_1.storeyDatas = arg2_1.storeys
	arg0_1.storey = arg0_1:System2Storey(arg2_1)
	arg0_1.isInit = false
end

function var0_0.GetBridge(arg0_2)
	return arg0_2.bridge
end

function var0_0.IsLoaed(arg0_3)
	return arg0_3.isInit
end

function var0_0.SetUp(arg0_4)
	local var0_4 = arg0_4.storeyDatas[arg0_4.storeyId]

	arg0_4.storey:SetLevel(var0_4.level)

	local var1_4 = var0_4.furnitures[1]

	if not var1_4 or not var0_0.IsFloorPaper(var1_4) then
		arg0_4.storey:SetFloorPaper(nil)
	end

	local var2_4 = math.ceil(#var0_4.furnitures / 3)
	local var3_4 = {}

	for iter0_4, iter1_4 in ipairs(var0_4.furnitures) do
		table.insert(var3_4, function(arg0_5)
			arg0_4:AddFurniture({
				id = iter1_4.id,
				configId = iter1_4.configId,
				dir = iter1_4.dir,
				parent = iter1_4.parent,
				position = iter1_4.position,
				date = iter1_4.date
			}, true)

			if (iter0_4 - 1) % var2_4 == 0 then
				onNextTick(arg0_5)
			else
				arg0_5()
			end
		end)
	end

	for iter2_4, iter3_4 in ipairs(var0_4.ships) do
		table.insert(var3_4, function(arg0_6)
			arg0_4:AddShip(iter3_4)
			onNextTick(arg0_6)
		end)
	end

	seriesAsync(var3_4, function()
		if arg0_4.storey then
			arg0_4.storey:DispatchEvent(CourtYardEvent.INITED)
		end

		arg0_4.isInit = true

		arg0_4:SendNotification(CourtYardEvent._INITED)
	end)
end

function var0_0.Update(arg0_8)
	if arg0_8.storey then
		arg0_8.storey:Update()
	end
end

function var0_0.GetStorey(arg0_9)
	return arg0_9.storey
end

function var0_0.AddFurniture(arg0_10, arg1_10, arg2_10)
	if not arg0_10.storey then
		return
	end

	local function var0_10(arg0_11, arg1_11)
		local var0_11 = arg0_10:DataToFurnitureVO(arg1_10)

		var0_11:Init(arg1_11, arg1_10.dir or 1)

		return arg0_10.storey:IsLegalAreaForFurniture(var0_11, arg1_11)
	end

	local var1_10 = arg0_10:DataToFurnitureVO(arg1_10)

	var1_10.selectedFlag = arg1_10.selected

	if not arg0_10.storey:CanAddFurniture(var1_10) then
		return
	end

	local var2_10 = var1_10:GetType()

	if arg1_10.parent and arg1_10.parent ~= 0 then
		var1_10:Init(arg1_10.position, arg1_10.dir or 1)
		arg0_10.storey:AddChildFurniture(var1_10, arg1_10.parent)
	elseif var2_10 == Furniture.TYPE_WALLPAPER or var2_10 == Furniture.TYPE_FLOORPAPER then
		arg0_10.storey:AddPaper(var1_10)
	else
		local var3_10 = arg1_10.position or arg0_10.storey:GetEmptyArea(var1_10)

		if not var3_10 then
			arg0_10.storey:DispatchEvent(CourtYardEvent.ADD_ITEM_FAILED)
		elseif var3_10 and var0_10(var1_10, var3_10) then
			var1_10:Init(var3_10, arg1_10.dir or 1)
			arg0_10.storey:AddFurniture(var1_10, arg2_10)
		else
			arg0_10:SendNotification(CourtYardEvent._ADD_ITEM_FAILED, var1_10.id)
		end
	end

	arg0_10:CheckChange()
end

function var0_0.AddShip(arg0_12, arg1_12)
	if not arg0_12.storey then
		return
	end

	local var0_12 = arg0_12:DataToShip(arg1_12)
	local var1_12 = arg0_12.storey:GetRandomPosition(var0_12)

	if var1_12 then
		var0_12:SetPosition(var1_12)
		arg0_12.storey:AddShip(var0_12)
	else
		arg0_12:SendNotification(CourtYardEvent._NO_POS_TO_ADD_SHIP, var0_12.id)
	end
end

function var0_0.AddVisitorShip(arg0_13, arg1_13)
	if not arg0_13.storey then
		return
	end

	local var0_13 = arg0_13:DataToVisitorShip(arg1_13)
	local var1_13 = arg0_13.storey:GetRandomPosition(var0_13)

	if var1_13 then
		var0_13:SetPosition(var1_13)
		arg0_13.storey:AddShip(var0_13)
	end
end

function var0_0.ExitShip(arg0_14, arg1_14)
	arg0_14.storey:ExitShip(arg1_14)
end

function var0_0.Extend(arg0_15)
	arg0_15:SendNotification(CourtYardEvent._EXTEND)
end

function var0_0.LevelUp(arg0_16)
	arg0_16.storey:LevelUp(id)
end

function var0_0.DragShip(arg0_17, arg1_17)
	arg0_17.storey:DragShip(arg1_17)
	arg0_17:SendNotification(CourtYardEvent._DRAG_ITEM)
end

function var0_0.DragingShip(arg0_18, arg1_18, arg2_18)
	arg0_18.storey:DragingShip(arg1_18, arg2_18)
end

function var0_0.DragShipEnd(arg0_19, arg1_19, arg2_19)
	arg0_19.storey:DragShipEnd(arg1_19, arg2_19)
	arg0_19:SendNotification(CourtYardEvent._DRAG_ITEM_END)
end

function var0_0.TouchShip(arg0_20, arg1_20)
	arg0_20.storey:TouchShip(arg1_20)
	arg0_20:SendNotification(CourtYardEvent._TOUCH_SHIP, arg1_20)
end

function var0_0.GetShipInimacy(arg0_21, arg1_21)
	arg0_21:SendNotification(GAME.BACKYARD_ADD_INTIMACY, arg1_21)
end

function var0_0.GetShipCoin(arg0_22, arg1_22)
	arg0_22:SendNotification(GAME.BACKYARD_ADD_MONEY, arg1_22)
end

function var0_0.ClearShipCoin(arg0_23, arg1_23)
	arg0_23.storey:ClearShipCoin(arg1_23)
end

function var0_0.ClearShipIntimacy(arg0_24, arg1_24)
	arg0_24.storey:ClearShipIntimacy(arg1_24)
end

function var0_0.UpdateShipCoinAndIntimacy(arg0_25, arg1_25, arg2_25, arg3_25)
	arg0_25.storey:UpdateShipCoin(arg1_25, arg2_25)
	arg0_25.storey:UpdateShipIntimacy(arg1_25, arg3_25)
end

function var0_0.AddShipExp(arg0_26, arg1_26, arg2_26)
	arg0_26.storey:AddShipExp(arg1_26, arg2_26)
end

function var0_0.ShipAnimtionFinish(arg0_27, arg1_27, arg2_27)
	arg0_27.storey:ShipAnimtionFinish(arg1_27, arg2_27)
end

function var0_0.GetMaxCntForShip(arg0_28)
	return #arg0_28.storey:GetEmptyPositions(CourtYardShip.New(arg0_28, Ship.New({
		id = 999,
		configId = 100001
	}))) + table.getCount(arg0_28.storey:GetShips())
end

function var0_0.SelectFurnitureByConfigId(arg0_29, arg1_29)
	if arg0_29.storey.wallPaper and arg0_29.storey.wallPaper.configId == arg1_29 then
		return
	end

	if arg0_29.storey.floorPaper and arg0_29.storey.floorPaper.configId == arg1_29 then
		return
	end

	local var0_29

	for iter0_29, iter1_29 in pairs(arg0_29.storey.furnitures) do
		if iter1_29.configId == arg1_29 then
			var0_29 = iter1_29

			break
		end
	end

	if var0_29 then
		arg0_29:SelectFurniture(var0_29.id)
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("courtyard_tip_furniture_not_in_layer"))
	end
end

function var0_0.SelectFurniture(arg0_30, arg1_30)
	if arg0_30.storey:InEidtMode() then
		arg0_30.storey:SelectFurniture(arg1_30)

		local var0_30 = arg0_30.storey:GetFurniture(arg1_30)

		if var0_30:GetOpFlag() then
			arg0_30:SendNotification(CourtYardEvent._FURNITURE_SELECTED, var0_30.configId)
		end
	else
		arg0_30.storey:ClickFurniture(arg1_30)
	end
end

function var0_0.PlayFurnitureVoice(arg0_31, arg1_31)
	arg0_31.storey:PlayFurnitureVoice(arg1_31)
end

function var0_0.PlayMusicalInstruments(arg0_32, arg1_32)
	arg0_32.storey:PlayMusicalInstruments(arg1_32)
end

function var0_0.StopPlayMusicalInstruments(arg0_33, arg1_33)
	arg0_33.storey:StopPlayMusicalInstruments(arg1_33)
end

function var0_0.PlayFurnitureBg(arg0_34, arg1_34)
	arg0_34.storey:PlayFurnitureBg(arg1_34)
end

function var0_0.UnSelectFurniture(arg0_35, arg1_35)
	arg0_35.storey:UnSelectFurniture(arg1_35)

	if not arg0_35.storey:GetFurniture(arg1_35):GetOpFlag() then
		arg0_35:SendNotification(CourtYardEvent._FURNITURE_SELECTED, -99999)
	end
end

function var0_0.BeginDragFurniture(arg0_36, arg1_36)
	arg0_36.storey:BeginDragFurniture(arg1_36)
	arg0_36:SendNotification(CourtYardEvent._DRAG_ITEM)
end

function var0_0.DragingFurniture(arg0_37, arg1_37, arg2_37)
	arg0_37.storey:DragingFurniture(arg1_37, arg2_37)
end

function var0_0.DragFurnitureEnd(arg0_38, arg1_38, arg2_38)
	arg0_38.storey:DragFurnitureEnd(arg1_38, arg2_38)
	arg0_38:CheckChange()
	arg0_38:SendNotification(CourtYardEvent._DRAG_ITEM_END)
end

function var0_0.FurnitureAnimtionFinish(arg0_39, arg1_39, arg2_39)
	arg0_39.storey:FurnitureAnimtionFinish(arg1_39, arg2_39)
end

function var0_0.RotateFurniture(arg0_40, arg1_40)
	arg0_40.storey:RotateFurniture(arg1_40)
	arg0_40:CheckChange()
end

function var0_0.RemoveFurniture(arg0_41, arg1_41)
	arg0_41.storey:RemoveFurniture(arg1_41)
	arg0_41:CheckChange()
end

function var0_0.RemovePaper(arg0_42, arg1_42)
	arg0_42.storey:RemovePaper(arg1_42)
	arg0_42:CheckChange()
end

function var0_0.ClearFurnitures(arg0_43)
	arg0_43.storey:RemoveAllFurniture()
	arg0_43:CheckChange()
end

function var0_0.SaveFurnitures(arg0_44)
	if arg0_44.storey.recoder:HasChange() then
		local var0_44 = arg0_44.storey:ToTable()

		arg0_44:SendNotification(GAME.PUT_FURNITURE, {
			tip = true,
			furnsPos = var0_44
		})
	end

	arg0_44:ExitEditMode()
end

function var0_0.GetStoreyData(arg0_45)
	return (arg0_45.storey:ToTable())
end

function var0_0.RestoreFurnitures(arg0_46)
	arg0_46:ClearFurnitures()

	local var0_46 = arg0_46.storey.recoder:GetHeadSample()

	for iter0_46, iter1_46 in ipairs(var0_46) do
		arg0_46:AddFurniture(iter1_46)
	end

	arg0_46:ExitEditMode()
end

function var0_0.EnterEditMode(arg0_47)
	arg0_47.storey:EnterEditMode()
	arg0_47:SendNotification(CourtYardEvent._ENTER_MODE)
end

function var0_0.ExitEditMode(arg0_48)
	arg0_48.storey:ExitEditMode()
	arg0_48:SendNotification(CourtYardEvent._EXIT_MODE)
end

function var0_0.CheckChange(arg0_49)
	local var0_49, var1_49 = arg0_49.storey:GetDirty()

	if var0_49 and var1_49 then
		arg0_49:SendNotification(CourtYardEvent._SYN_FURNITURE, {
			var0_49,
			var1_49
		})
	end
end

function var0_0.Quit(arg0_50)
	if arg0_50.storey:InEidtMode() then
		if arg0_50.storey.recoder:HasChange() then
			arg0_50.storey:DispatchEvent(CourtYardEvent.REMIND_SAVE)
		else
			arg0_50:ExitEditMode()
		end
	else
		arg0_50:SendNotification(CourtYardEvent._QUIT)
	end
end

function var0_0.IsVisit(arg0_51)
	return arg0_51.system == CourtYardConst.SYSTEM_VISIT
end

function var0_0.IsFeast(arg0_52)
	return arg0_52.system == CourtYardConst.SYSTEM_FEAST
end

function var0_0.IsEditModeOrIsVisit(arg0_53)
	return arg0_53:IsVisit() or arg0_53.storey:InEidtMode()
end

function var0_0.Receive(arg0_54, arg1_54, ...)
	if not arg0_54.storey then
		return
	end

	arg0_54[arg1_54](arg0_54, ...)
end

function var0_0.OnTakeThemePhoto(arg0_55)
	if arg0_55.storey then
		arg0_55.storey:DispatchEvent(CourtYardEvent.TAKE_PHOTO)
	end
end

function var0_0.OnEndTakeThemePhoto(arg0_56)
	if arg0_56.storey then
		arg0_56.storey:DispatchEvent(CourtYardEvent.END_TAKE_PHOTO)
	end
end

function var0_0.OnApplicationPaused(arg0_57)
	if arg0_57.storey then
		arg0_57.storey:StopAllDragState()
		arg0_57:SendNotification(CourtYardEvent._DRAG_ITEM_END)
	end
end

function var0_0.OnOpenLayerOrCloseLayer(arg0_58, arg1_58, arg2_58)
	if not arg2_58 or not arg0_58.storey then
		return
	end

	arg0_58.storey:DispatchEvent(CourtYardEvent.OPEN_LAYER, arg1_58)
end

function var0_0.OnBackPressed(arg0_59)
	if arg0_59.storey then
		arg0_59.storey:DispatchEvent(CourtYardEvent.BACK_PRESSED)
	end
end

function var0_0.Dispose(arg0_60)
	if arg0_60.storey then
		arg0_60.storey:Dispose()

		arg0_60.storey = nil
	end
end

function var0_0.IsFloorPaper(arg0_61)
	return pg.furniture_data_template[arg0_61.configId].type == Furniture.TYPE_FLOORPAPER
end

function var0_0.DataToFurnitureVO(arg0_62, arg1_62)
	local var0_62 = pg.furniture_data_template[arg1_62.configId]

	if var0_62.type == Furniture.TYPE_WALLPAPER or var0_62.type == Furniture.TYPE_FLOORPAPER then
		return CourtYardPaper.New(arg0_62, arg1_62)
	elseif var0_62.type == Furniture.TYPE_FOLLOWER then
		return CourtYardFollowerFurniture.New(arg0_62, arg1_62)
	elseif var0_62.type == Furniture.TYPE_RANDOM_CONTROLLER then
		return CourtYardRandomControllerFurniture.New(arg0_62, arg1_62)
	elseif var0_62.type == Furniture.TYPE_MAT then
		return CourtYardMatFurniture.New(arg0_62, arg1_62)
	elseif var0_62.type == Furniture.TYPE_TRANSPORT then
		return CourtYardTransportFurniture.New(arg0_62, arg1_62)
	elseif var0_62.type == Furniture.TYPE_WALL_MAT then
		return CourtYardWallMatFurniture.New(arg0_62, arg1_62)
	elseif var0_62.type == Furniture.TYPE_STAGE or var0_62.type == Furniture.TYPE_ARCH then
		return CourtYardStageFurniture.New(arg0_62, arg1_62)
	elseif var0_62.type == Furniture.TYPE_MOVEABLE then
		return CourtYardMoveableFurniture.New(arg0_62, arg1_62)
	elseif var0_62.belong == 1 and var0_62.canputon == 1 then
		return CourtYardCanPutFurniture.New(arg0_62, arg1_62)
	elseif var0_62.belong > 1 then
		return CourtYardWallFurniture.New(arg0_62, arg1_62)
	else
		return CourtYardFurniture.New(arg0_62, arg1_62)
	end
end

function var0_0.DataToShip(arg0_63, arg1_63)
	if arg0_63.system == CourtYardConst.SYSTEM_FEAST then
		return CourtYardFeastShip.New(arg0_63, arg1_63)
	else
		return CourtYardShip.New(arg0_63, arg1_63)
	end
end

function var0_0.DataToVisitorShip(arg0_64, arg1_64)
	return CourtYardVisitorShip.New(arg0_64, arg1_64)
end

function var0_0.System2Storey(arg0_65, arg1_65)
	local var0_65 = Vector4(arg1_65.mapSize.z + 1, arg1_65.mapSize.w + 1, arg1_65.mapSize.x, arg1_65.mapSize.y)

	if arg1_65.system == CourtYardConst.SYSTEM_OUTSIDE then
		return CourtYardOutStorey.New(arg0_65, arg1_65.storeyId, arg1_65.style, var0_65)
	else
		return CourtYardStorey.New(arg0_65, arg1_65.storeyId, arg1_65.style, var0_65)
	end
end

function var0_0.SendNotification(arg0_66, ...)
	if arg0_66.bridge then
		arg0_66.bridge:SendNotification(...)
	end
end

return var0_0
