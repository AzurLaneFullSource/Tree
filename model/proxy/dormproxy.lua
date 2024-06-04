local var0 = class("DormProxy", import(".NetProxy"))

var0.DORM_UPDATEED = "DormProxy updated"
var0.LEVEL_UP = "DormProxy level up"
var0.FURNITURE_ADDED = "DormProxy FURNITURE ADDED"
var0.FURNITURE_UPDATED = "DormProxy FURNITURE UPDATED"
var0.SHIP_ADDED = "DormProxy ship added"
var0.SHIP_EXIT = "DormProxy ship exit"
var0.INIMACY_AND_MONEY_ADD = "DormProxy inimacy and money added"
var0.SHIPS_EXP_ADDED = "DormProxy SHIPS_EXP_ADDED"
var0.THEME_ADDED = "DormProxy THEME_ADDED"
var0.THEME_DELETED = "DormProxy THEME_DELETED"
var0.THEME_TEMPLATE_UPDATED = "DormProxy THEME_TEMPLATE_UPDATED"
var0.THEME_TEMPLATE_DELTETED = "DormProxy THEME_TEMPLATE_DELTETED"
var0.COLLECTION_THEME_TEMPLATE_ADDED = "DormProxy COLLECTION_THEME_TEMPLATE_ADDED"
var0.COLLECTION_THEME_TEMPLATE_DELETED = "DormProxy COLLECTION_THEME_TEMPLATE_DELETED"
var0.THEME_TEMPLATE_ADDED = "DormProxy THEME_TEMPLATE_ADDED"
var0.SHOP_THEME_TEMPLATE_DELETED = "DormProxy SHOP_THEME_TEMPLATE_DELETED"

function var0.register(arg0)
	arg0.TYPE = 2
	arg0.PAGE = 1
	arg0.MAX_PAGE = 10
	arg0.lastPages = {
		[2] = math.huge,
		[3] = math.huge,
		[5] = math.huge
	}
	arg0.friendData = nil
	arg0.systemThemes = {}

	arg0:on(19001, function(arg0)
		arg0:sendNotification(GAME.GET_BACKYARD_DATA, {
			isMine = true,
			data = arg0
		})
	end)

	arg0.isLoadExp = nil

	arg0:on(19009, function(arg0)
		arg0.isLoadExp = true
		arg0.data.load_exp = arg0.data.load_exp + arg0.exp
		arg0.data.load_food = arg0.data.load_food + arg0.food_consume

		arg0:updateFood(arg0.food_consume)
		arg0:sendNotification(GAME.BACKYARD_ADD_EXP, arg0.exp)
	end)
	arg0:on(19010, function(arg0)
		for iter0, iter1 in ipairs(arg0.pop_list) do
			arg0:addInimacyAndMoney(arg0.pop_list[iter0].id, arg0.pop_list[iter0].intimacy, arg0.pop_list[iter0].dorm_icon)
		end
	end)
end

function var0.GetVisitorShip(arg0)
	return arg0.visitorShip
end

function var0.SetVisitorShip(arg0, arg1)
	arg0.visitorShip = arg1
end

function var0.getBackYardShips(arg0)
	local var0 = {}
	local var1 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg0.data.shipIds) do
		local var2 = var1:getShipById(iter1)

		if var2 then
			var0[var2.id] = var2
		else
			print("not found ship >>>", iter1)
		end
	end

	return var0
end

function var0.addShip(arg0, arg1)
	arg0.data:addShip(arg1)
	arg0:updateDrom(arg0.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0.exitYardById(arg0, arg1)
	local var0 = arg0:getShipById(arg1)

	assert(var0, "ship should exist")
	arg0.data:deleteShip(arg1)
	arg0:sendNotification(var0.SHIP_EXIT, var0)
	arg0:updateDrom(arg0.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0.getShipById(arg0, arg1)
	local var0 = arg0:getBackYardShips()

	if var0[arg1] then
		return var0[arg1]
	end
end

function var0.getShipsByState(arg0, arg1)
	local var0 = arg0:getBackYardShips()
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		if iter1.state == arg1 then
			var1[iter1.id] = iter1
		end
	end

	return var1
end

function var0.getTrainShipIds(arg0)
	return _.keys(arg0:getShipsByState(Ship.STATE_TRAIN) or {})
end

function var0.getRestShipIds(arg0)
	return _.keys(arg0:getShipsByState(Ship.STATE_REST) or {})
end

function var0.getTrainShipCount(arg0)
	return #arg0:getTrainShipIds()
end

function var0.addInimacyAndMoney(arg0, arg1, arg2, arg3)
	local var0 = getProxy(BayProxy)
	local var1 = var0:getShipById(arg1)

	if not var1 then
		return
	end

	var1:updateStateInfo34(arg2, arg3)
	var0:updateShip(var1)
	arg0:sendNotification(var0.INIMACY_AND_MONEY_ADD, {
		id = arg1,
		intimacy = arg2,
		money = arg3
	})
	arg0:updateDrom(arg0.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0.UpdateInimacyAndMoney(arg0)
	arg0:updateDrom(arg0.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0.clearInimacyAndMoney(arg0, arg1)
	local var0 = getProxy(BayProxy)
	local var1 = var0:getShipById(arg1)

	if not var1 then
		return
	end

	var1:addLikability(var1.state_info_3)
	getProxy(PlayerProxy):getRawData():addResources({
		dormMoney = var1.state_info_4
	})
	var1:updateStateInfo34(0, 0)
	var0:updateShip(var1)
	arg0:updateDrom(arg0.data, BackYardConst.DORM_UPDATE_TYPE_SHIP)
end

function var0.isLackOfFood(arg0)
	if arg0:getTrainShipCount() == 0 then
		return false
	end

	local var0 = arg0:getRestFood()

	if not arg0.isLoadExp then
		var0 = var0 - arg0.data.load_food
	end

	return var0 <= 0
end

function var0.havePopEvent(arg0)
	local var0 = arg0:getBackYardShips()

	for iter0, iter1 in pairs(var0) do
		if iter1:hasStateInfo3Or4() then
			return true
		end
	end

	return false
end

function var0.AddFurniture(arg0, arg1)
	assert(isa(arg1, Furniture))
	arg0.data:AddFurniture(arg1)
	arg0:updateDrom(arg0.data, BackYardConst.DORM_UPDATE_TYPE_FURNITURE)
end

function var0.AddFurnitrues(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = Furniture.New({
			count = 1,
			id = iter1
		})

		arg0.data:AddFurniture(var0)
	end

	arg0:updateDrom(arg0.data, BackYardConst.DORM_UPDATE_TYPE_FURNITURE)
end

function var0.ClearNewFlag(arg0)
	local var0 = arg0.data:GetPurchasedFurnitures()

	for iter0, iter1 in pairs(var0) do
		iter1:ClearNewFlag()
	end
end

function var0._ClearNewFlag(arg0, arg1)
	local var0 = arg0.data:GetPurchasedFurnitures()[arg1]

	if var0 then
		var0:ClearNewFlag()
	end
end

function var0.addDorm(arg0, arg1)
	assert(isa(arg1, Dorm), "dorm should instance of Dorm")

	arg0.data = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inBackyard")
end

function var0.updateDrom(arg0, arg1, arg2)
	assert(isa(arg1, Dorm), "dorm should instance of Dorm")
	assert(arg1, "drom should exist")

	arg0.data = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inBackyard")
	arg0.facade:sendNotification(var0.DORM_UPDATEED, {}, arg2)
end

function var0.getData(arg0)
	return (arg0.data or Dorm.New({
		id = 1
	})):clone()
end

function var0.updateFood(arg0, arg1)
	arg0.data:consumeFood(arg1)
	arg0.data:restNextTime()
	arg0:updateDrom(arg0.data, BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD)
end

function var0.getRestFood(arg0)
	return arg0.data.food
end

function var0.GetCustomThemeTemplates(arg0)
	return arg0.customThemeTemplates
end

function var0.SetCustomThemeTemplates(arg0, arg1)
	arg0.customThemeTemplates = arg1
end

function var0.GetCustomThemeTemplateById(arg0, arg1)
	return arg0.customThemeTemplates[arg1]
end

function var0.UpdateCustomThemeTemplate(arg0, arg1)
	arg0.customThemeTemplates[arg1.id] = arg1

	arg0:sendNotification(var0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
		template = arg1
	})
end

function var0.DeleteCustomThemeTemplate(arg0, arg1)
	arg0.customThemeTemplates[arg1] = nil

	arg0:sendNotification(var0.THEME_TEMPLATE_DELTETED, {
		templateId = arg1
	})
end

function var0.AddCustomThemeTemplate(arg0, arg1)
	arg0.customThemeTemplates[arg1.id] = arg1

	arg0:sendNotification(var0.THEME_TEMPLATE_ADDED, {
		template = arg1
	})
end

function var0.GetUploadThemeTemplateCnt(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.customThemeTemplates) do
		if iter1:IsPushed() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.GetShopThemeTemplates(arg0)
	return arg0.shopThemeTemplates
end

function var0.SetShopThemeTemplates(arg0, arg1)
	arg0.shopThemeTemplates = arg1
end

function var0.GetShopThemeTemplateById(arg0, arg1)
	return arg0.shopThemeTemplates[arg1]
end

function var0.IsInitShopThemeTemplates(arg0)
	return arg0.shopThemeTemplates ~= nil
end

function var0.UpdateShopThemeTemplate(arg0, arg1)
	arg0.shopThemeTemplates[arg1.id] = arg1

	arg0:sendNotification(var0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_SHOP,
		template = arg1
	})
end

function var0.DeleteShopThemeTemplate(arg0, arg1)
	arg0.shopThemeTemplates[arg1] = nil

	arg0:sendNotification(var0.SHOP_THEME_TEMPLATE_DELETED, {
		id = arg1
	})
end

function var0.GetCollectionThemeTemplates(arg0)
	return arg0.collectionThemeTemplates
end

function var0.SetCollectionThemeTemplates(arg0, arg1)
	arg0.collectionThemeTemplates = arg1
end

function var0.GetCollectionThemeTemplateById(arg0, arg1)
	return arg0.collectionThemeTemplates[arg1]
end

function var0.AddCollectionThemeTemplate(arg0, arg1)
	arg0.collectionThemeTemplates[arg1.id] = arg1

	arg0:sendNotification(var0.COLLECTION_THEME_TEMPLATE_ADDED, {
		template = arg1
	})
end

function var0.DeleteCollectionThemeTemplate(arg0, arg1)
	arg0.collectionThemeTemplates[arg1] = nil

	arg0:sendNotification(var0.COLLECTION_THEME_TEMPLATE_DELETED, {
		id = arg1
	})
end

function var0.GetThemeTemplateCollectionCnt(arg0)
	return table.getCount(arg0.collectionThemeTemplates or {})
end

function var0.UpdateCollectionThemeTemplate(arg0, arg1)
	arg0.collectionThemeTemplates[arg1.id] = arg1

	arg0:sendNotification(var0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION,
		template = arg1
	})
end

function var0.GetTemplateNewID(arg0)
	local var0 = _.map(_.values(arg0.customThemeTemplates or {}), function(arg0)
		return arg0:GetPos()
	end)

	for iter0 = 1, 10 do
		if not table.contains(var0, iter0) then
			return iter0
		end
	end
end

function var0.GetSystemThemes(arg0)
	if not arg0.systemThemes or #arg0.systemThemes == 0 then
		local var0 = pg.backyard_theme_template

		for iter0, iter1 in ipairs(var0.all) do
			if var0[iter1].is_view == 1 then
				local var1 = BackYardSystemTheme.New({
					id = iter1
				})

				table.insert(arg0.systemThemes, var1)
			end
		end
	end

	return arg0.systemThemes
end

function var0.ResetSystemTheme(arg0, arg1)
	if not arg0.systemThemes or #arg0.systemThemes == 0 then
		return
	end

	for iter0, iter1 in ipairs(arg0.systemThemes) do
		if iter1.id == arg1 then
			arg0.systemThemes[iter0] = BackYardSystemTheme.New({
				id = arg1
			})

			break
		end
	end
end

function var0.NeedRefreshThemeTemplateShop(arg0)
	if not arg0.refreshThemeTemplateShopTime then
		arg0.refreshThemeTemplateShopTime = 0
	end

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0 > arg0.refreshThemeTemplateShopTime then
		arg0.refreshThemeTemplateShopTime = var0 + BackYardConst.AUTO_REFRESH_THEME_TEMPLATE_TIME

		return true
	end

	return false
end

function var0.NeedCollectionTip(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = PlayerPrefs.GetInt("backyard_template" .. var0, 0)
	local var2 = arg0:GetThemeTemplateCollectionCnt()

	if var2 ~= var1 then
		PlayerPrefs.SetInt("backyard_template" .. var0, var2)
		PlayerPrefs.Save()
	end

	if var2 < var1 then
		return true
	end

	return false
end

function var0.NeedShopShowHelp(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id

	if not (PlayerPrefs.GetInt("backyard_template_help" .. var0, 0) > 0) then
		PlayerPrefs.SetInt("backyard_template_help" .. var0, 1)
		PlayerPrefs.Save()

		return true
	end

	return false
end

function var0.GetTag7Furnitures(arg0)
	local var0 = {}
	local var1 = pg.furniture_data_template.get_id_list_by_tag[7]

	for iter0, iter1 in ipairs(var1) do
		local var2 = pg.furniture_shop_template[iter1]

		if var2 and var2.not_for_sale == 0 and pg.TimeMgr.GetInstance():inTime(var2.time) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.IsShowRedDot(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0.level, "CourtYardMediator")
	local var2 = getProxy(DormProxy)
	local var3 = var2:isLackOfFood()
	local var4 = var2:havePopEvent()

	return var1 and (var3 or var4 or getProxy(SettingsProxy):IsTipNewTheme() or getProxy(SettingsProxy):IsTipNewGemFurniture())
end

return var0
