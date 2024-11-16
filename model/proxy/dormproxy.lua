local var0_0 = class("DormProxy", import(".NetProxy"))

var0_0.DORM_UPDATEED = "DormProxy updated"
var0_0.LEVEL_UP = "DormProxy level up"
var0_0.FURNITURE_ADDED = "DormProxy FURNITURE ADDED"
var0_0.FURNITURE_UPDATED = "DormProxy FURNITURE UPDATED"
var0_0.SHIP_ADDED = "DormProxy ship added"
var0_0.SHIP_EXIT = "DormProxy ship exit"
var0_0.INIMACY_AND_MONEY_ADD = "DormProxy inimacy and money added"
var0_0.SHIPS_EXP_ADDED = "DormProxy SHIPS_EXP_ADDED"
var0_0.THEME_ADDED = "DormProxy THEME_ADDED"
var0_0.THEME_DELETED = "DormProxy THEME_DELETED"
var0_0.THEME_TEMPLATE_UPDATED = "DormProxy THEME_TEMPLATE_UPDATED"
var0_0.THEME_TEMPLATE_DELTETED = "DormProxy THEME_TEMPLATE_DELTETED"
var0_0.COLLECTION_THEME_TEMPLATE_ADDED = "DormProxy COLLECTION_THEME_TEMPLATE_ADDED"
var0_0.COLLECTION_THEME_TEMPLATE_DELETED = "DormProxy COLLECTION_THEME_TEMPLATE_DELETED"
var0_0.THEME_TEMPLATE_ADDED = "DormProxy THEME_TEMPLATE_ADDED"
var0_0.SHOP_THEME_TEMPLATE_DELETED = "DormProxy SHOP_THEME_TEMPLATE_DELETED"

function var0_0.register(arg0_1)
	arg0_1.TYPE = 2
	arg0_1.PAGE = 1
	arg0_1.MAX_PAGE = 10
	arg0_1.lastPages = {
		[2] = math.huge,
		[3] = math.huge,
		[5] = math.huge
	}
	arg0_1.friendData = nil
	arg0_1.systemThemes = {}

	arg0_1:on(19001, function(arg0_2)
		arg0_1:sendNotification(GAME.GET_BACKYARD_DATA, {
			isMine = true,
			data = arg0_2
		})
	end)

	arg0_1.isLoadExp = nil

	arg0_1:on(19009, function(arg0_3)
		arg0_1.isLoadExp = true
		arg0_1.data.load_exp = arg0_1.data.load_exp + arg0_3.exp
		arg0_1.data.load_food = arg0_1.data.load_food + arg0_3.food_consume

		arg0_1:updateFood(arg0_3.food_consume)
		arg0_1:sendNotification(GAME.BACKYARD_ADD_EXP, arg0_3.exp)
	end)
	arg0_1:on(19010, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4.pop_list) do
			arg0_1:addInimacyAndMoney(arg0_4.pop_list[iter0_4].id, arg0_4.pop_list[iter0_4].intimacy, arg0_4.pop_list[iter0_4].dorm_icon)
		end
	end)
end

function var0_0.GetVisitorShip(arg0_5)
	return arg0_5.visitorShip
end

function var0_0.SetVisitorShip(arg0_6, arg1_6)
	arg0_6.visitorShip = arg1_6
end

function var0_0.getBackYardShips(arg0_7)
	local var0_7 = {}
	local var1_7 = getProxy(BayProxy)

	for iter0_7, iter1_7 in ipairs(arg0_7.data.shipIds) do
		local var2_7 = var1_7:getShipById(iter1_7)

		if var2_7 then
			var0_7[var2_7.id] = var2_7
		else
			print("not found ship >>>", iter1_7)
		end
	end

	return var0_7
end

function var0_0.addShip(arg0_8, arg1_8)
	arg0_8.data:addShip(arg1_8)
	arg0_8:updateDrom(arg0_8.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0_0.exitYardById(arg0_9, arg1_9)
	local var0_9 = arg0_9:getShipById(arg1_9)

	assert(var0_9, "ship should exist")
	arg0_9.data:deleteShip(arg1_9)
	arg0_9:sendNotification(var0_0.SHIP_EXIT, var0_9)
	arg0_9:updateDrom(arg0_9.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0_0.getShipById(arg0_10, arg1_10)
	local var0_10 = arg0_10:getBackYardShips()

	if var0_10[arg1_10] then
		return var0_10[arg1_10]
	end
end

function var0_0.getShipsByState(arg0_11, arg1_11)
	local var0_11 = arg0_11:getBackYardShips()
	local var1_11 = {}

	for iter0_11, iter1_11 in pairs(var0_11) do
		if iter1_11.state == arg1_11 then
			var1_11[iter1_11.id] = iter1_11
		end
	end

	return var1_11
end

function var0_0.getTrainShipIds(arg0_12)
	return _.keys(arg0_12:getShipsByState(Ship.STATE_TRAIN) or {})
end

function var0_0.getRestShipIds(arg0_13)
	return _.keys(arg0_13:getShipsByState(Ship.STATE_REST) or {})
end

function var0_0.getTrainShipCount(arg0_14)
	return #arg0_14:getTrainShipIds()
end

function var0_0.addInimacyAndMoney(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = getProxy(BayProxy)
	local var1_15 = var0_15:getShipById(arg1_15)

	if not var1_15 then
		return
	end

	var1_15:updateStateInfo34(arg2_15, arg3_15)
	var0_15:updateShip(var1_15)
	arg0_15:sendNotification(var0_0.INIMACY_AND_MONEY_ADD, {
		id = arg1_15,
		intimacy = arg2_15,
		money = arg3_15
	})
	arg0_15:updateDrom(arg0_15.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0_0.UpdateInimacyAndMoney(arg0_16)
	arg0_16:updateDrom(arg0_16.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0_0.clearInimacyAndMoney(arg0_17, arg1_17)
	local var0_17 = getProxy(BayProxy)
	local var1_17 = var0_17:getShipById(arg1_17)

	if not var1_17 then
		return
	end

	var1_17:addLikability(var1_17.state_info_3)
	getProxy(PlayerProxy):getRawData():addResources({
		dormMoney = var1_17.state_info_4
	})
	var1_17:updateStateInfo34(0, 0)
	var0_17:updateShip(var1_17)
	arg0_17:updateDrom(arg0_17.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0_0.isLackOfFood(arg0_18)
	if arg0_18:getTrainShipCount() == 0 then
		return false
	end

	local var0_18 = arg0_18:getRestFood()

	if not arg0_18.isLoadExp then
		var0_18 = var0_18 - arg0_18.data.load_food
	end

	return var0_18 <= 0
end

function var0_0.havePopEvent(arg0_19)
	local var0_19 = arg0_19:getBackYardShips()

	for iter0_19, iter1_19 in pairs(var0_19) do
		if iter1_19:hasStateInfo3Or4() then
			return true
		end
	end

	return false
end

function var0_0.AddFurniture(arg0_20, arg1_20)
	assert(isa(arg1_20, Furniture))
	arg0_20.data:AddFurniture(arg1_20)
	arg0_20:updateDrom(arg0_20.data, BackYardConst.DORM_UPDATE_TYPE_FURNITURE)
end

function var0_0.AddFurnitrues(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg1_21) do
		local var0_21 = Furniture.New({
			count = 1,
			id = iter1_21
		})

		arg0_21.data:AddFurniture(var0_21)
	end

	arg0_21:updateDrom(arg0_21.data, BackYardConst.DORM_UPDATE_TYPE_FURNITURE)
end

function var0_0.ClearNewFlag(arg0_22)
	local var0_22 = arg0_22.data:GetPurchasedFurnitures()

	for iter0_22, iter1_22 in pairs(var0_22) do
		iter1_22:ClearNewFlag()
	end
end

function var0_0._ClearNewFlag(arg0_23, arg1_23)
	local var0_23 = arg0_23.data:GetPurchasedFurnitures()[arg1_23]

	if var0_23 then
		var0_23:ClearNewFlag()
	end
end

function var0_0.addDorm(arg0_24, arg1_24)
	assert(isa(arg1_24, Dorm), "dorm should instance of Dorm")

	arg0_24.data = arg1_24

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inBackyard")
end

function var0_0.updateDrom(arg0_25, arg1_25, arg2_25)
	assert(isa(arg1_25, Dorm), "dorm should instance of Dorm")
	assert(arg1_25, "drom should exist")

	arg0_25.data = arg1_25

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inBackyard")
	arg0_25.facade:sendNotification(var0_0.DORM_UPDATEED, {}, arg2_25)
end

function var0_0.getData(arg0_26)
	return (arg0_26.data or Dorm.New({
		id = 1
	})):clone()
end

function var0_0.updateFood(arg0_27, arg1_27)
	arg0_27.data:consumeFood(arg1_27)
	arg0_27.data:restNextTime()
	arg0_27:updateDrom(arg0_27.data, BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD)
end

function var0_0.getRestFood(arg0_28)
	return arg0_28.data.food
end

function var0_0.GetCustomThemeTemplates(arg0_29)
	return arg0_29.customThemeTemplates
end

function var0_0.SetCustomThemeTemplates(arg0_30, arg1_30)
	arg0_30.customThemeTemplates = arg1_30
end

function var0_0.GetCustomThemeTemplateById(arg0_31, arg1_31)
	return arg0_31.customThemeTemplates[arg1_31]
end

function var0_0.UpdateCustomThemeTemplate(arg0_32, arg1_32)
	arg0_32.customThemeTemplates[arg1_32.id] = arg1_32

	arg0_32:sendNotification(var0_0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
		template = arg1_32
	})
end

function var0_0.DeleteCustomThemeTemplate(arg0_33, arg1_33)
	arg0_33.customThemeTemplates[arg1_33] = nil

	arg0_33:sendNotification(var0_0.THEME_TEMPLATE_DELTETED, {
		templateId = arg1_33
	})
end

function var0_0.AddCustomThemeTemplate(arg0_34, arg1_34)
	arg0_34.customThemeTemplates[arg1_34.id] = arg1_34

	arg0_34:sendNotification(var0_0.THEME_TEMPLATE_ADDED, {
		template = arg1_34
	})
end

function var0_0.GetUploadThemeTemplateCnt(arg0_35)
	local var0_35 = 0

	for iter0_35, iter1_35 in pairs(arg0_35.customThemeTemplates) do
		if iter1_35:IsPushed() then
			var0_35 = var0_35 + 1
		end
	end

	return var0_35
end

function var0_0.GetShopThemeTemplates(arg0_36)
	return arg0_36.shopThemeTemplates
end

function var0_0.SetShopThemeTemplates(arg0_37, arg1_37)
	arg0_37.shopThemeTemplates = arg1_37
end

function var0_0.GetShopThemeTemplateById(arg0_38, arg1_38)
	return arg0_38.shopThemeTemplates[arg1_38]
end

function var0_0.IsInitShopThemeTemplates(arg0_39)
	return arg0_39.shopThemeTemplates ~= nil
end

function var0_0.UpdateShopThemeTemplate(arg0_40, arg1_40)
	arg0_40.shopThemeTemplates[arg1_40.id] = arg1_40

	arg0_40:sendNotification(var0_0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_SHOP,
		template = arg1_40
	})
end

function var0_0.DeleteShopThemeTemplate(arg0_41, arg1_41)
	arg0_41.shopThemeTemplates[arg1_41] = nil

	arg0_41:sendNotification(var0_0.SHOP_THEME_TEMPLATE_DELETED, {
		id = arg1_41
	})
end

function var0_0.GetCollectionThemeTemplates(arg0_42)
	return arg0_42.collectionThemeTemplates
end

function var0_0.SetCollectionThemeTemplates(arg0_43, arg1_43)
	arg0_43.collectionThemeTemplates = arg1_43
end

function var0_0.GetCollectionThemeTemplateById(arg0_44, arg1_44)
	return arg0_44.collectionThemeTemplates[arg1_44]
end

function var0_0.AddCollectionThemeTemplate(arg0_45, arg1_45)
	arg0_45.collectionThemeTemplates[arg1_45.id] = arg1_45

	arg0_45:sendNotification(var0_0.COLLECTION_THEME_TEMPLATE_ADDED, {
		template = arg1_45
	})
end

function var0_0.DeleteCollectionThemeTemplate(arg0_46, arg1_46)
	arg0_46.collectionThemeTemplates[arg1_46] = nil

	arg0_46:sendNotification(var0_0.COLLECTION_THEME_TEMPLATE_DELETED, {
		id = arg1_46
	})
end

function var0_0.GetThemeTemplateCollectionCnt(arg0_47)
	return table.getCount(arg0_47.collectionThemeTemplates or {})
end

function var0_0.UpdateCollectionThemeTemplate(arg0_48, arg1_48)
	arg0_48.collectionThemeTemplates[arg1_48.id] = arg1_48

	arg0_48:sendNotification(var0_0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION,
		template = arg1_48
	})
end

function var0_0.GetTemplateNewID(arg0_49)
	local var0_49 = _.map(_.values(arg0_49.customThemeTemplates or {}), function(arg0_50)
		return arg0_50:GetPos()
	end)

	for iter0_49 = 1, 10 do
		if not table.contains(var0_49, iter0_49) then
			return iter0_49
		end
	end
end

function var0_0.GetSystemThemes(arg0_51)
	if not arg0_51.systemThemes or #arg0_51.systemThemes == 0 then
		local var0_51 = pg.backyard_theme_template

		for iter0_51, iter1_51 in ipairs(var0_51.all) do
			if var0_51[iter1_51].is_view == 1 then
				local var1_51 = BackYardSystemTheme.New({
					id = iter1_51
				})

				table.insert(arg0_51.systemThemes, var1_51)
			end
		end
	end

	return arg0_51.systemThemes
end

function var0_0.ResetSystemTheme(arg0_52, arg1_52)
	if not arg0_52.systemThemes or #arg0_52.systemThemes == 0 then
		return
	end

	for iter0_52, iter1_52 in ipairs(arg0_52.systemThemes) do
		if iter1_52.id == arg1_52 then
			arg0_52.systemThemes[iter0_52] = BackYardSystemTheme.New({
				id = arg1_52
			})

			break
		end
	end
end

function var0_0.NeedRefreshThemeTemplateShop(arg0_53)
	if not arg0_53.refreshThemeTemplateShopTime then
		arg0_53.refreshThemeTemplateShopTime = 0
	end

	local var0_53 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0_53 > arg0_53.refreshThemeTemplateShopTime then
		arg0_53.refreshThemeTemplateShopTime = var0_53 + BackYardConst.AUTO_REFRESH_THEME_TEMPLATE_TIME

		return true
	end

	return false
end

function var0_0.NeedCollectionTip(arg0_54)
	local var0_54 = getProxy(PlayerProxy):getRawData().id
	local var1_54 = PlayerPrefs.GetInt("backyard_template" .. var0_54, 0)
	local var2_54 = arg0_54:GetThemeTemplateCollectionCnt()

	if var2_54 ~= var1_54 then
		PlayerPrefs.SetInt("backyard_template" .. var0_54, var2_54)
		PlayerPrefs.Save()
	end

	if var2_54 < var1_54 then
		return true
	end

	return false
end

function var0_0.NeedShopShowHelp(arg0_55)
	local var0_55 = getProxy(PlayerProxy):getRawData().id

	if not (PlayerPrefs.GetInt("backyard_template_help" .. var0_55, 0) > 0) then
		PlayerPrefs.SetInt("backyard_template_help" .. var0_55, 1)
		PlayerPrefs.Save()

		return true
	end

	return false
end

function var0_0.GetTag7Furnitures(arg0_56)
	local var0_56 = {}
	local var1_56 = pg.furniture_data_template.get_id_list_by_tag[7]

	for iter0_56, iter1_56 in ipairs(var1_56) do
		local var2_56 = pg.furniture_shop_template[iter1_56]

		if var2_56 and var2_56.not_for_sale == 0 and pg.TimeMgr.GetInstance():inTime(var2_56.time) then
			table.insert(var0_56, iter1_56)
		end
	end

	return var0_56
end

function var0_0.IsShowRedDot(arg0_57)
	local var0_57 = getProxy(PlayerProxy):getRawData()
	local var1_57 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_57.level, "CourtYardMediator")
	local var2_57 = getProxy(DormProxy)
	local var3_57 = var2_57:isLackOfFood()
	local var4_57 = var2_57:havePopEvent()

	return var1_57 and (var3_57 or var4_57 or getProxy(SettingsProxy):IsTipNewTheme() or getProxy(SettingsProxy):IsTipNewGemFurniture())
end

function var0_0.CheckDeviceRAMEnough()
	local var0_58 = SystemInfo.systemMemorySize
	local var1_58 = getDorm3dGameset("drom3d_memory_limit")[1]

	if var0_58 ~= 0 and var0_58 < var1_58 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("drom3d_memory_limit_tip"))
	end
end

return var0_0
