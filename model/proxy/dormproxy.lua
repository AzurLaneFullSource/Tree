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
	arg0_1:RequestPopEvent()
end

function var0_0.OnEnterBackyard(arg0_3)
	arg0_3:SettlementShipExp()
end

function var0_0.OnExitBackyard(arg0_4)
	arg0_4:ClearRequestShipExp()
end

function var0_0.SettlementShipExp(arg0_5)
	arg0_5:ClearRequestShipExp()

	if arg0_5.data:ShouldRequestShipExp() then
		arg0_5:sendNotification(GAME.BACKYARD_REQUEST_SHIP_EXP)
	else
		arg0_5:RequestShipExp()
	end
end

function var0_0.RequestShipExp(arg0_6)
	local var0_6 = arg0_6.data:GetNextSettlementShipExpTime() - pg.TimeMgr.GetInstance():GetServerTime()

	arg0_6.requestShipExpTimer = Timer.New(function()
		arg0_6:ClearRequestShipExp()
		arg0_6:sendNotification(GAME.BACKYARD_REQUEST_SHIP_EXP)
	end, var0_6, 1)

	arg0_6.requestShipExpTimer:Start()
end

function var0_0.ClearRequestShipExp(arg0_8)
	if arg0_8.requestShipExpTimer then
		arg0_8.requestShipExpTimer:Stop()

		arg0_8.requestShipExpTimer = nil
	end
end

function var0_0.RequestPopEvent(arg0_9)
	arg0_9:ClearRequestPopEvent()

	local var0_9 = pg.gameset.dorm_pop_time.key_value

	arg0_9.requestEventTimer = Timer.New(function()
		arg0_9:sendNotification(GAME.BACKYARD_REQUEST_POP_EVENT)
	end, var0_9, -1)

	arg0_9.requestEventTimer:Start()
end

function var0_0.ClearRequestPopEvent(arg0_11)
	if arg0_11.requestEventTimer then
		arg0_11.requestEventTimer:Stop()

		arg0_11.requestEventTimer = nil
	end
end

function var0_0.GetVisitorShip(arg0_12)
	return arg0_12.visitorShip
end

function var0_0.SetVisitorShip(arg0_13, arg1_13)
	arg0_13.visitorShip = arg1_13
end

function var0_0.addDorm(arg0_14, arg1_14)
	assert(isa(arg1_14, Dorm), "dorm should instance of Dorm")

	arg0_14.data = arg1_14

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inBackyard")
end

function var0_0.updateDrom(arg0_15, arg1_15, arg2_15)
	assert(isa(arg1_15, Dorm), "dorm should instance of Dorm")
	assert(arg1_15, "drom should exist")

	arg0_15.data = arg1_15

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inBackyard")
	arg0_15.facade:sendNotification(var0_0.DORM_UPDATEED, {}, arg2_15)
end

function var0_0.getData(arg0_16)
	return (arg0_16.data or Dorm.New({
		id = 1
	})):clone()
end

function var0_0.GetCustomThemeTemplates(arg0_17)
	return arg0_17.customThemeTemplates
end

function var0_0.SetCustomThemeTemplates(arg0_18, arg1_18)
	arg0_18.customThemeTemplates = arg1_18
end

function var0_0.GetCustomThemeTemplateById(arg0_19, arg1_19)
	return arg0_19.customThemeTemplates[arg1_19]
end

function var0_0.UpdateCustomThemeTemplate(arg0_20, arg1_20)
	arg0_20.customThemeTemplates[arg1_20.id] = arg1_20

	arg0_20:sendNotification(var0_0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
		template = arg1_20
	})
end

function var0_0.DeleteCustomThemeTemplate(arg0_21, arg1_21)
	arg0_21.customThemeTemplates[arg1_21] = nil

	arg0_21:sendNotification(var0_0.THEME_TEMPLATE_DELTETED, {
		templateId = arg1_21
	})
end

function var0_0.AddCustomThemeTemplate(arg0_22, arg1_22)
	arg0_22.customThemeTemplates[arg1_22.id] = arg1_22

	arg0_22:sendNotification(var0_0.THEME_TEMPLATE_ADDED, {
		template = arg1_22
	})
end

function var0_0.GetUploadThemeTemplateCnt(arg0_23)
	local var0_23 = 0

	for iter0_23, iter1_23 in pairs(arg0_23.customThemeTemplates) do
		if iter1_23:IsPushed() then
			var0_23 = var0_23 + 1
		end
	end

	return var0_23
end

function var0_0.GetShopThemeTemplates(arg0_24)
	return arg0_24.shopThemeTemplates
end

function var0_0.SetShopThemeTemplates(arg0_25, arg1_25)
	arg0_25.shopThemeTemplates = arg1_25
end

function var0_0.GetShopThemeTemplateById(arg0_26, arg1_26)
	return arg0_26.shopThemeTemplates[arg1_26]
end

function var0_0.IsInitShopThemeTemplates(arg0_27)
	return arg0_27.shopThemeTemplates ~= nil
end

function var0_0.UpdateShopThemeTemplate(arg0_28, arg1_28)
	arg0_28.shopThemeTemplates[arg1_28.id] = arg1_28

	arg0_28:sendNotification(var0_0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_SHOP,
		template = arg1_28
	})
end

function var0_0.DeleteShopThemeTemplate(arg0_29, arg1_29)
	arg0_29.shopThemeTemplates[arg1_29] = nil

	arg0_29:sendNotification(var0_0.SHOP_THEME_TEMPLATE_DELETED, {
		id = arg1_29
	})
end

function var0_0.GetCollectionThemeTemplates(arg0_30)
	return arg0_30.collectionThemeTemplates
end

function var0_0.SetCollectionThemeTemplates(arg0_31, arg1_31)
	arg0_31.collectionThemeTemplates = arg1_31
end

function var0_0.GetCollectionThemeTemplateById(arg0_32, arg1_32)
	return arg0_32.collectionThemeTemplates[arg1_32]
end

function var0_0.AddCollectionThemeTemplate(arg0_33, arg1_33)
	arg0_33.collectionThemeTemplates[arg1_33.id] = arg1_33

	arg0_33:sendNotification(var0_0.COLLECTION_THEME_TEMPLATE_ADDED, {
		template = arg1_33
	})
end

function var0_0.DeleteCollectionThemeTemplate(arg0_34, arg1_34)
	arg0_34.collectionThemeTemplates[arg1_34] = nil

	arg0_34:sendNotification(var0_0.COLLECTION_THEME_TEMPLATE_DELETED, {
		id = arg1_34
	})
end

function var0_0.GetThemeTemplateCollectionCnt(arg0_35)
	return table.getCount(arg0_35.collectionThemeTemplates or {})
end

function var0_0.UpdateCollectionThemeTemplate(arg0_36, arg1_36)
	arg0_36.collectionThemeTemplates[arg1_36.id] = arg1_36

	arg0_36:sendNotification(var0_0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION,
		template = arg1_36
	})
end

function var0_0.GetTemplateNewID(arg0_37)
	local var0_37 = _.map(_.values(arg0_37.customThemeTemplates or {}), function(arg0_38)
		return arg0_38:GetPos()
	end)

	for iter0_37 = 1, 10 do
		if not table.contains(var0_37, iter0_37) then
			return iter0_37
		end
	end
end

function var0_0.GetSystemThemes(arg0_39)
	if not arg0_39.systemThemes or #arg0_39.systemThemes == 0 then
		local var0_39 = pg.backyard_theme_template

		for iter0_39, iter1_39 in ipairs(var0_39.all) do
			if var0_39[iter1_39].is_view == 1 then
				local var1_39 = BackYardSystemTheme.New({
					id = iter1_39
				})

				table.insert(arg0_39.systemThemes, var1_39)
			end
		end
	end

	return arg0_39.systemThemes
end

function var0_0.ResetSystemTheme(arg0_40, arg1_40)
	if not arg0_40.systemThemes or #arg0_40.systemThemes == 0 then
		return
	end

	for iter0_40, iter1_40 in ipairs(arg0_40.systemThemes) do
		if iter1_40.id == arg1_40 then
			arg0_40.systemThemes[iter0_40] = BackYardSystemTheme.New({
				id = arg1_40
			})

			break
		end
	end
end

function var0_0.NeedRefreshThemeTemplateShop(arg0_41)
	if not arg0_41.refreshThemeTemplateShopTime then
		arg0_41.refreshThemeTemplateShopTime = 0
	end

	local var0_41 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0_41 > arg0_41.refreshThemeTemplateShopTime then
		arg0_41.refreshThemeTemplateShopTime = var0_41 + BackYardConst.AUTO_REFRESH_THEME_TEMPLATE_TIME

		return true
	end

	return false
end

function var0_0.NeedCollectionTip(arg0_42)
	local var0_42 = getProxy(PlayerProxy):getRawData().id
	local var1_42 = PlayerPrefs.GetInt("backyard_template" .. var0_42, 0)
	local var2_42 = arg0_42:GetThemeTemplateCollectionCnt()

	if var2_42 ~= var1_42 then
		PlayerPrefs.SetInt("backyard_template" .. var0_42, var2_42)
		PlayerPrefs.Save()
	end

	if var2_42 < var1_42 then
		return true
	end

	return false
end

function var0_0.NeedShopShowHelp(arg0_43)
	local var0_43 = getProxy(PlayerProxy):getRawData().id

	if not (PlayerPrefs.GetInt("backyard_template_help" .. var0_43, 0) > 0) then
		PlayerPrefs.SetInt("backyard_template_help" .. var0_43, 1)
		PlayerPrefs.Save()

		return true
	end

	return false
end

function var0_0.GetTag7Furnitures(arg0_44)
	local var0_44 = {}
	local var1_44 = pg.furniture_data_template.get_id_list_by_tag[7]

	for iter0_44, iter1_44 in ipairs(var1_44) do
		local var2_44 = pg.furniture_shop_template[iter1_44]

		if var2_44 and var2_44.not_for_sale == 0 and pg.TimeMgr.GetInstance():inTime(var2_44.time) then
			table.insert(var0_44, iter1_44)
		end
	end

	return var0_44
end

function var0_0.IsShowRedDot(arg0_45)
	local var0_45 = getProxy(PlayerProxy):getRawData()
	local var1_45 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_45.level, "CourtYardMediator")
	local var2_45 = getProxy(DormProxy):getRawData()
	local var3_45 = var2_45:IsLackOfFood()
	local var4_45 = var2_45:AnyShipExistIntimacyOrMoney()

	return var1_45 and (var3_45 or var4_45 or getProxy(SettingsProxy):IsTipNewTheme() or getProxy(SettingsProxy):IsTipNewGemFurniture())
end

function var0_0.remove(arg0_46)
	arg0_46:ClearRequestPopEvent()
	arg0_46:ClearRequestShipExp()
end

return var0_0
