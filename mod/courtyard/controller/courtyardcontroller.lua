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
			local var0_6 = var0_4.popList[iter3_4.id] or {}

			arg0_4:AddShip(iter3_4, var0_6[1] or 0, var0_6[2] or 0)
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

function var0_0.AddShip(arg0_12, arg1_12, arg2_12, arg3_12)
	if not arg0_12.storey then
		return
	end

	local var0_12 = arg0_12:DataToShip(arg1_12, arg2_12, arg3_12)

	if arg1_12:IsDoubleSkin() then
		var0_12:SetSide(1)

		local var1_12 = arg0_12:DataToShip(arg1_12, 0, 0)

		var1_12.id = var1_12.id + CourtYardConst.DOUBLE_SKIN_ADD

		var1_12:SetSide(2)
		arg0_12:CreateShip(var0_12)
		arg0_12:CreateShip(var1_12)
	else
		arg0_12:CreateShip(var0_12)
	end
end

function var0_0.CreateShip(arg0_13, arg1_13)
	local var0_13 = arg0_13.storey:GetRandomPosition(arg1_13)

	if var0_13 then
		arg1_13:SetPosition(var0_13)
		arg0_13.storey:AddShip(arg1_13)
	else
		arg0_13:SendNotification(CourtYardEvent._NO_POS_TO_ADD_SHIP, arg1_13.id)
	end
end

function var0_0.AddVisitorShip(arg0_14, arg1_14)
	if not arg0_14.storey then
		return
	end

	local var0_14 = arg0_14:DataToVisitorShip(arg1_14)
	local var1_14 = arg0_14.storey:GetRandomPosition(var0_14)

	if var1_14 then
		var0_14:SetPosition(var1_14)
		arg0_14.storey:AddShip(var0_14)
	end
end

function var0_0.ExitShip(arg0_15, arg1_15)
	arg0_15.storey:ExitShip(arg1_15)
end

function var0_0.Extend(arg0_16)
	arg0_16:SendNotification(CourtYardEvent._EXTEND)
end

function var0_0.LevelUp(arg0_17)
	arg0_17.storey:LevelUp(id)
end

function var0_0.DragShip(arg0_18, arg1_18)
	arg0_18.storey:DragShip(arg1_18)
	arg0_18:SendNotification(CourtYardEvent._DRAG_ITEM)
end

function var0_0.DragingShip(arg0_19, arg1_19, arg2_19)
	arg0_19.storey:DragingShip(arg1_19, arg2_19)
end

function var0_0.DragShipEnd(arg0_20, arg1_20, arg2_20)
	arg0_20.storey:DragShipEnd(arg1_20, arg2_20)
	arg0_20:SendNotification(CourtYardEvent._DRAG_ITEM_END)
end

function var0_0.TouchShip(arg0_21, arg1_21)
	arg0_21.storey:TouchShip(arg1_21)
	arg0_21:SendNotification(CourtYardEvent._TOUCH_SHIP, arg1_21)
end

function var0_0.GetShipInimacy(arg0_22, arg1_22)
	arg0_22:SendNotification(GAME.BACKYARD_ADD_INTIMACY, arg1_22)
end

function var0_0.GetShipCoin(arg0_23, arg1_23)
	arg0_23:SendNotification(GAME.BACKYARD_ADD_MONEY, arg1_23)
end

function var0_0.ClearShipCoin(arg0_24, arg1_24)
	arg0_24.storey:ClearShipCoin(arg1_24)
end

function var0_0.ClearShipIntimacy(arg0_25, arg1_25)
	arg0_25.storey:ClearShipIntimacy(arg1_25)
end

function var0_0.UpdateShipCoinAndIntimacy(arg0_26, arg1_26, arg2_26, arg3_26)
	arg0_26.storey:UpdateShipCoin(arg1_26, arg2_26)
	arg0_26.storey:UpdateShipIntimacy(arg1_26, arg3_26)
end

function var0_0.AddShipExp(arg0_27, arg1_27, arg2_27)
	arg0_27.storey:AddShipExp(arg1_27, arg2_27)
end

function var0_0.ShipAnimtionFinish(arg0_28, arg1_28, arg2_28)
	arg0_28.storey:ShipAnimtionFinish(arg1_28, arg2_28)
end

function var0_0.GetMaxCntForShip(arg0_29)
	return #arg0_29.storey:GetEmptyPositions(CourtYardShip.New(arg0_29, Ship.New({
		id = 999,
		configId = 100001
	}))) + table.getCount(arg0_29.storey:GetShips())
end

function var0_0.SelectFurnitureByConfigId(arg0_30, arg1_30)
	if arg0_30.storey.wallPaper and arg0_30.storey.wallPaper.configId == arg1_30 then
		return
	end

	if arg0_30.storey.floorPaper and arg0_30.storey.floorPaper.configId == arg1_30 then
		return
	end

	local var0_30

	for iter0_30, iter1_30 in pairs(arg0_30.storey.furnitures) do
		if iter1_30.configId == arg1_30 then
			var0_30 = iter1_30

			break
		end
	end

	if var0_30 then
		arg0_30:SelectFurniture(var0_30.id)
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("courtyard_tip_furniture_not_in_layer"))
	end
end

function var0_0.SelectFurniture(arg0_31, arg1_31)
	if arg0_31.storey:InEidtMode() then
		arg0_31.storey:SelectFurniture(arg1_31)

		local var0_31 = arg0_31.storey:GetFurniture(arg1_31)

		if var0_31:GetOpFlag() then
			arg0_31:SendNotification(CourtYardEvent._FURNITURE_SELECTED, var0_31.configId)
		end
	else
		arg0_31.storey:ClickFurniture(arg1_31)
	end
end

function var0_0.PlayFurnitureVoice(arg0_32, arg1_32)
	arg0_32.storey:PlayFurnitureVoice(arg1_32)
end

function var0_0.PlayMusicalInstruments(arg0_33, arg1_33)
	arg0_33.storey:PlayMusicalInstruments(arg1_33)
end

function var0_0.StopPlayMusicalInstruments(arg0_34, arg1_34)
	arg0_34.storey:StopPlayMusicalInstruments(arg1_34)
end

function var0_0.PlayFurnitureBg(arg0_35, arg1_35)
	arg0_35.storey:PlayFurnitureBg(arg1_35)
end

function var0_0.UnSelectFurniture(arg0_36, arg1_36)
	arg0_36.storey:UnSelectFurniture(arg1_36)

	if not arg0_36.storey:GetFurniture(arg1_36):GetOpFlag() then
		arg0_36:SendNotification(CourtYardEvent._FURNITURE_SELECTED, -99999)
	end
end

function var0_0.BeginDragFurniture(arg0_37, arg1_37)
	arg0_37.storey:BeginDragFurniture(arg1_37)
	arg0_37:SendNotification(CourtYardEvent._DRAG_ITEM)
end

function var0_0.DragingFurniture(arg0_38, arg1_38, arg2_38)
	arg0_38.storey:DragingFurniture(arg1_38, arg2_38)
end

function var0_0.DragFurnitureEnd(arg0_39, arg1_39, arg2_39)
	arg0_39.storey:DragFurnitureEnd(arg1_39, arg2_39)
	arg0_39:CheckChange()
	arg0_39:SendNotification(CourtYardEvent._DRAG_ITEM_END)
end

function var0_0.FurnitureAnimtionFinish(arg0_40, arg1_40, arg2_40)
	arg0_40.storey:FurnitureAnimtionFinish(arg1_40, arg2_40)
end

function var0_0.RotateFurniture(arg0_41, arg1_41)
	arg0_41.storey:RotateFurniture(arg1_41)
	arg0_41:CheckChange()
end

function var0_0.RemoveFurniture(arg0_42, arg1_42)
	arg0_42.storey:RemoveFurniture(arg1_42)
	arg0_42:CheckChange()
end

function var0_0.RemovePaper(arg0_43, arg1_43)
	arg0_43.storey:RemovePaper(arg1_43)
	arg0_43:CheckChange()
end

function var0_0.ClearFurnitures(arg0_44)
	arg0_44.storey:RemoveAllFurniture()
	arg0_44:CheckChange()
end

function var0_0.SaveFurnitures(arg0_45)
	if arg0_45.storey.recoder:HasChange() then
		local var0_45 = arg0_45.storey:ToTable()

		arg0_45:SendNotification(GAME.PUT_FURNITURE, {
			tip = true,
			furnsPos = var0_45
		})
	end

	arg0_45:ExitEditMode()
end

function var0_0.GetStoreyData(arg0_46)
	return (arg0_46.storey:ToTable())
end

function var0_0.RestoreFurnitures(arg0_47)
	arg0_47:ClearFurnitures()

	local var0_47 = arg0_47.storey.recoder:GetHeadSample()

	for iter0_47, iter1_47 in ipairs(var0_47) do
		arg0_47:AddFurniture(iter1_47)
	end

	arg0_47:ExitEditMode()
end

function var0_0.EnterEditMode(arg0_48)
	arg0_48.storey:EnterEditMode()
	arg0_48:SendNotification(CourtYardEvent._ENTER_MODE)
end

function var0_0.ExitEditMode(arg0_49)
	arg0_49.storey:ExitEditMode()
	arg0_49:SendNotification(CourtYardEvent._EXIT_MODE)
end

function var0_0.CheckChange(arg0_50)
	local var0_50, var1_50 = arg0_50.storey:GetDirty()

	if var0_50 and var1_50 then
		arg0_50:SendNotification(CourtYardEvent._SYN_FURNITURE, {
			var0_50,
			var1_50
		})
	end
end

function var0_0.Quit(arg0_51)
	if arg0_51.storey:InEidtMode() then
		if arg0_51.storey.recoder:HasChange() then
			arg0_51.storey:DispatchEvent(CourtYardEvent.REMIND_SAVE)
		else
			arg0_51:ExitEditMode()
		end
	else
		arg0_51:SendNotification(CourtYardEvent._QUIT)
	end
end

function var0_0.IsVisit(arg0_52)
	return arg0_52.system == CourtYardConst.SYSTEM_VISIT
end

function var0_0.IsFeast(arg0_53)
	return arg0_53.system == CourtYardConst.SYSTEM_FEAST
end

function var0_0.IsEditModeOrIsVisit(arg0_54)
	return arg0_54:IsVisit() or arg0_54.storey:InEidtMode()
end

function var0_0.Receive(arg0_55, arg1_55, ...)
	if not arg0_55.storey then
		return
	end

	arg0_55[arg1_55](arg0_55, ...)
end

function var0_0.OnTakeThemePhoto(arg0_56)
	if arg0_56.storey then
		arg0_56.storey:DispatchEvent(CourtYardEvent.TAKE_PHOTO)
	end
end

function var0_0.OnEndTakeThemePhoto(arg0_57)
	if arg0_57.storey then
		arg0_57.storey:DispatchEvent(CourtYardEvent.END_TAKE_PHOTO)
	end
end

function var0_0.OnApplicationPaused(arg0_58)
	if arg0_58.storey then
		arg0_58.storey:StopAllDragState()
		arg0_58:SendNotification(CourtYardEvent._DRAG_ITEM_END)
	end
end

function var0_0.OnOpenLayerOrCloseLayer(arg0_59, arg1_59, arg2_59)
	if not arg0_59.storey then
		return
	end

	arg0_59.storey:DispatchEvent(CourtYardEvent.OPEN_LAYER, arg1_59)
end

function var0_0.OnBackPressed(arg0_60)
	if arg0_60.storey then
		arg0_60.storey:DispatchEvent(CourtYardEvent.BACK_PRESSED)
	end
end

function var0_0.Dispose(arg0_61)
	if arg0_61.storey then
		arg0_61.storey:Dispose()

		arg0_61.storey = nil
	end
end

function var0_0.IsFloorPaper(arg0_62)
	return pg.furniture_data_template[arg0_62.configId].type == Furniture.TYPE_FLOORPAPER
end

function var0_0.DataToFurnitureVO(arg0_63, arg1_63)
	local var0_63 = pg.furniture_data_template[arg1_63.configId]

	if var0_63.type == Furniture.TYPE_WALLPAPER or var0_63.type == Furniture.TYPE_FLOORPAPER then
		return CourtYardPaper.New(arg0_63, arg1_63)
	elseif var0_63.type == Furniture.TYPE_FOLLOWER then
		return CourtYardFollowerFurniture.New(arg0_63, arg1_63)
	elseif var0_63.type == Furniture.TYPE_RANDOM_CONTROLLER then
		return CourtYardRandomControllerFurniture.New(arg0_63, arg1_63)
	elseif var0_63.type == Furniture.TYPE_MAT then
		return CourtYardMatFurniture.New(arg0_63, arg1_63)
	elseif var0_63.type == Furniture.TYPE_TRANSPORT then
		return CourtYardTransportFurniture.New(arg0_63, arg1_63)
	elseif var0_63.type == Furniture.TYPE_WALL_MAT then
		return CourtYardWallMatFurniture.New(arg0_63, arg1_63)
	elseif var0_63.type == Furniture.TYPE_STAGE or var0_63.type == Furniture.TYPE_ARCH then
		return CourtYardStageFurniture.New(arg0_63, arg1_63)
	elseif var0_63.type == Furniture.TYPE_MOVEABLE then
		return CourtYardMoveableFurniture.New(arg0_63, arg1_63)
	elseif var0_63.belong == 1 and var0_63.canputon == 1 then
		return CourtYardCanPutFurniture.New(arg0_63, arg1_63)
	elseif var0_63.belong > 1 then
		return CourtYardWallFurniture.New(arg0_63, arg1_63)
	else
		return CourtYardFurniture.New(arg0_63, arg1_63)
	end
end

function var0_0.DataToShip(arg0_64, arg1_64, arg2_64, arg3_64)
	if arg0_64.system == CourtYardConst.SYSTEM_FEAST then
		return CourtYardFeastShip.New(arg0_64, arg1_64)
	else
		return CourtYardShip.New(arg0_64, arg1_64, arg2_64, arg3_64)
	end
end

function var0_0.DataToVisitorShip(arg0_65, arg1_65)
	return CourtYardVisitorShip.New(arg0_65, arg1_65)
end

function var0_0.System2Storey(arg0_66, arg1_66)
	local var0_66 = Vector4(arg1_66.mapSize.z + 1, arg1_66.mapSize.w + 1, arg1_66.mapSize.x, arg1_66.mapSize.y)

	if arg1_66.system == CourtYardConst.SYSTEM_OUTSIDE then
		return CourtYardOutStorey.New(arg0_66, arg1_66.storeyId, arg1_66.style, var0_66)
	else
		return CourtYardStorey.New(arg0_66, arg1_66.storeyId, arg1_66.style, var0_66)
	end
end

function var0_0.SendNotification(arg0_67, ...)
	if arg0_67.bridge then
		arg0_67.bridge:SendNotification(...)
	end
end

return var0_0
