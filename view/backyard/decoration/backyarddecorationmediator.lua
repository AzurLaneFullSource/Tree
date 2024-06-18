local var0_0 = class("BackYardDecorationMediator", import("...base.ContextMediator"))

var0_0.ADD_FURNITURE = "BackYardDecorationMediator:ADD_FURNITURE"
var0_0.REMOVE_PAPER = "BackYardDecorationMediator:REMOVE_PAPER"
var0_0.SAVE_ALL = "BackYardDecorationMediator:SAVE_ALL"
var0_0.ClEAR_ALL = "BackYardDecorationMediator:ClEAR_ALL"
var0_0.OPEN_SHOP = "BackYardDecorationMediator:OPEN_SHOP"
var0_0.GET_CUSTOM_THEME = "BackYardDecorationMediator:GET_CUSTOM_THEME"
var0_0.DELETE_THEME = "BackYardDecorationMediator:DELETE_THEME"
var0_0.SAVE_THEME = "BackYardDecorationMediator:SAVE_THEME"
var0_0.APPLY_THEME = "BackYardDecorationMediator:APPLY_THEME"
var0_0.ADD_FURNITURES = "BackYardDecorationMediator:ADD_FURNITURES"
var0_0.ON_SELECTED_FURNITRUE = "BackYardDecorationMediator:ON_SELECTED_FURNITRUE"
var0_0.GET_CURR_FURNITURE = "BackYardDecorationMediator:GET_CURR_FURNITURE"
var0_0.GET_OTHER_FURNITURE = "BackYardDecorationMediator:GET_OTHER_FURNITURE"
var0_0.GET_ALL_FURNITURE = "BackYardDecorationMediator:GET_ALL_FURNITURE"
var0_0.START_TAKE_THEME_PHOTO = "BackYardDecorationMediator:START_TAKE_THEME_PHOTO"
var0_0.END_TAKE_THEME_PHOTO = "BackYardDecorationMediator:END_TAKE_THEME_PHOTO"
var0_0.ON_SET_UP = "BackYardDecorationMediator:ON_SET_UP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SELECTED_FURNITRUE, function(arg0_2, arg1_2)
		_courtyard:GetController():SelectFurnitureByConfigId(arg1_2)
	end)
	arg0_1:bind(var0_0.APPLY_THEME, function(arg0_3, arg1_3, arg2_3)
		local var0_3, var1_3 = arg0_1:GetCanPutFurnitureForTheme(arg0_1.dorm, arg1_3)

		if arg2_3 then
			arg2_3(var1_3, var0_3)
		end
	end)
	arg0_1:bind(var0_0.SAVE_THEME, function(arg0_4, arg1_4, arg2_4)
		if not arg0_1:AnyFurnitureInFloor(arg0_1.dorm, getProxy(DormProxy).floor) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_save_empty_theme"))

			return
		end

		pg.UIMgr.GetInstance():LoadingOn()

		local var0_4 = BackYardBaseThemeTemplate.BuildId(arg1_4)
		local var1_4
		local var2_4
		local var3_4 = pg.UIMgr.GetInstance().uiCamera:GetComponent(typeof(Camera))

		seriesAsync({
			function(arg0_5)
				arg0_1:sendNotification(var0_0.START_TAKE_THEME_PHOTO)

				var1_4 = BackYardThemeTempalteUtil.TakePhoto(var3_4)
				var2_4 = BackYardThemeTempalteUtil.TakeIcon(var3_4)

				arg0_1:sendNotification(var0_0.END_TAKE_THEME_PHOTO)
				arg0_5()
			end,
			function(arg0_6)
				onNextTick(arg0_6)
			end,
			function(arg0_7)
				if not var1_4 or not var2_4 then
					return
				end

				BackYardThemeTempalteUtil.SavePhoto(var0_4, var1_4, var2_4, arg0_7)
			end,
			function(arg0_8)
				onNextTick(arg0_8)
			end,
			function(arg0_9)
				local var0_9 = BackYardThemeTempalteUtil.GetMd5(var0_4)
				local var1_9 = BackYardThemeTempalteUtil.GetIconMd5(var0_4)
				local var2_9 = _courtyard:GetController():GetStoreyData()

				pg.UIMgr.GetInstance():LoadingOff()
				arg0_1:sendNotification(GAME.BACKYARD_SAVE_THEME_TEMPLATE, {
					id = arg1_4,
					name = arg2_4,
					furnitureputList = var2_9,
					iconMd5 = var1_9,
					imageMd5 = var0_9
				})
				arg0_9()
			end
		})
	end)
	arg0_1:bind(var0_0.DELETE_THEME, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.BACKYARD_DELETE_THEME_TEMPLATE, {
			templateId = arg1_10
		})
	end)
	arg0_1:bind(var0_0.GET_CUSTOM_THEME, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
			callback = arg1_11
		})
	end)
	arg0_1:bind(var0_0.OPEN_SHOP, function(arg0_12)
		_courtyard:GetController():SaveFurnitures()
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0_1:sendNotification(GAME.OPEN_BACKYARD_SHOP)
	end)
	arg0_1:bind(var0_0.SAVE_ALL, function(arg0_13)
		_courtyard:GetController():SaveFurnitures()
	end)
	arg0_1:bind(var0_0.ClEAR_ALL, function(arg0_14, arg1_14)
		arg0_1:sendNotification(GAME.ON_APPLY_SELF_THEME)
		_courtyard:GetController():ClearFurnitures()
	end)
	arg0_1:bind(var0_0.ADD_FURNITURE, function(arg0_15, arg1_15, arg2_15)
		local var0_15 = arg0_1:GenUniqueID(arg0_1.dorm, arg1_15.configId)

		_courtyard:GetController():AddFurniture({
			selected = true,
			id = var0_15,
			configId = arg1_15.configId,
			date = arg1_15.date
		})
		getProxy(DormProxy):_ClearNewFlag(arg1_15.configId)

		local var1_15 = arg0_1.dorm:GetFurniture(arg1_15.configId)

		var1_15:ClearNewFlag()
		arg0_1.viewComponent:UpdateFurnitrue(var1_15)

		if arg2_15 then
			arg2_15()
		end
	end)
	arg0_1:bind(var0_0.ADD_FURNITURES, function(arg0_16, arg1_16, arg2_16, arg3_16)
		local var0_16 = {}

		table.insert(var0_16, function(arg0_17)
			arg0_1.viewComponent:emit(var0_0.ClEAR_ALL)
			onNextTick(arg0_17)
		end)

		local function var1_16(arg0_18)
			_courtyard:GetController():AddFurniture({
				id = arg0_18.id,
				configId = arg0_18.configId,
				parent = arg0_18.parent,
				position = arg0_18.position,
				dir = arg0_18.dir,
				date = arg0_18.date
			})
		end

		local var2_16 = math.ceil(#arg2_16 / 3)

		for iter0_16, iter1_16 in pairs(arg2_16) do
			assert(iter1_16.position)
			table.insert(var0_16, function(arg0_19)
				var1_16(iter1_16)

				if (iter0_16 - 1) % var2_16 == 0 then
					onNextTick(arg0_19)
				else
					arg0_19()
				end
			end)
		end

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync(var0_16, function()
			if arg3_16 then
				arg3_16(arg2_16)
			end

			arg0_1:sendNotification(GAME.ON_APPLY_SELF_THEME_DONE, {
				id = arg1_16
			})
			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end)
	arg0_1:bind(var0_0.REMOVE_PAPER, function(arg0_21, arg1_21)
		_courtyard:GetController():RemovePaper(arg1_21.id)
	end)
	arg0_1:bind(var0_0.ON_SET_UP, function(arg0_22)
		arg0_1:SetUp()
	end)
end

function var0_0.AnyFurnitureInFloor(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23:GetThemeList()[arg2_23]

	if not var0_23 then
		return false
	end

	local var1_23 = var0_23:GetAllFurniture()

	return table.getCount(var1_23) > 0
end

function var0_0.GetCanPutFurnitureForTheme(arg0_24, arg1_24, arg2_24)
	local var0_24 = getProxy(DormProxy).floor
	local var1_24 = arg0_24:GetAllFloorFurnitures(arg1_24)
	local var2_24 = arg2_24:IsOccupyed(var1_24, var0_24)
	local var3_24 = {}
	local var4_24 = false

	if var2_24 then
		var3_24 = arg2_24:GetUsableFurnituresForFloor(var1_24, var0_24)
		var4_24 = false
	else
		local var5_24 = arg2_24:GetAllFurniture()

		for iter0_24, iter1_24 in pairs(var5_24) do
			table.insert(var3_24, iter1_24)
		end

		var4_24 = true
	end

	local var6_24 = arg0_24:FilterOwnCount(var3_24)

	table.sort(var6_24, BackyardThemeFurniture._LoadWeight)

	return var6_24, var4_24
end

function var0_0.FilterOwnCount(arg0_25, arg1_25)
	local var0_25 = {}
	local var1_25 = {}
	local var2_25 = {}
	local var3_25 = getProxy(DormProxy):getRawData()

	for iter0_25, iter1_25 in ipairs(arg1_25) do
		var1_25[iter1_25.configId] = (var1_25[iter1_25.configId] or 0) + 1

		if var3_25:GetOwnFurnitureCount(iter1_25.configId) >= var1_25[iter1_25.configId] then
			table.insert(var0_25, iter1_25)
		else
			table.insert(var2_25, iter1_25.id)
		end
	end

	for iter2_25, iter3_25 in ipairs(var2_25) do
		for iter4_25, iter5_25 in ipairs(var0_25) do
			if iter5_25.parent == iter3_25 then
				iter5_25.parent = 0
			end
		end
	end

	return var0_25
end

function var0_0.GetAllFloorFurnitures(arg0_26, arg1_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg1_26:GetThemeList()) do
		for iter2_26, iter3_26 in pairs(iter1_26:GetAllFurniture()) do
			var0_26[iter2_26] = iter3_26
		end
	end

	return var0_26
end

function var0_0.GenUniqueID(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27:GetAllFloorFurnitures(arg1_27)
	local var1_27 = arg1_27:GetOwnFurnitureCount(arg2_27)

	for iter0_27 = 0, var1_27 - 1 do
		local var2_27 = BackyardThemeFurniture.GetUniqueId(arg2_27, iter0_27)

		if not var0_27[var2_27] then
			return var2_27
		end
	end

	return BackyardThemeFurniture.GetUniqueId(arg2_27, 0)
end

function var0_0.SetUp(arg0_28)
	seriesAsync({
		function(arg0_29)
			local var0_29 = getProxy(DormProxy)

			arg0_28.dorm = var0_29:getData()

			arg0_28.viewComponent:SetDorm(arg0_28.dorm)
			arg0_28.viewComponent:SetThemes(var0_29:GetCustomThemeTemplates())
			onNextTick(arg0_29)
		end,
		function(arg0_30)
			if arg0_28.viewComponent.themes then
				arg0_30()

				return
			end

			arg0_28.viewComponent:emit(BackYardDecorationMediator.GET_CUSTOM_THEME, arg0_30)
		end
	}, function()
		arg0_28.viewComponent:InitPages()
	end)
end

function var0_0.listNotificationInterests(arg0_32)
	return {
		CourtYardEvent._SYN_FURNITURE,
		CourtYardEvent._EXIT_MODE,
		CourtYardEvent._FURNITURE_SELECTED,
		DormProxy.THEME_TEMPLATE_ADDED,
		DormProxy.THEME_TEMPLATE_DELTETED,
		GAME.BACKYARD_GET_THEME_TEMPLATE_DONE,
		GAME.ON_APPLY_SELF_THEME,
		GAME.ON_APPLY_SELF_THEME_DONE,
		CourtYardEvent._DRAG_ITEM,
		CourtYardEvent._DRAG_ITEM_END,
		var0_0.START_TAKE_THEME_PHOTO,
		var0_0.END_TAKE_THEME_PHOTO
	}
end

function var0_0.handleNotification(arg0_33, arg1_33)
	local var0_33 = arg1_33:getName()
	local var1_33 = arg1_33:getBody()

	if var0_33 == CourtYardEvent._SYN_FURNITURE then
		local var2_33 = var1_33[1]
		local var3_33 = var1_33[2]
		local var4_33 = getProxy(DormProxy).floor
		local var5_33 = arg0_33.dorm:GetTheme(var4_33)

		for iter0_33, iter1_33 in ipairs(var2_33) do
			local var6_33 = var5_33:GetFurniture(iter1_33.id)

			if var6_33 then
				var6_33:UpdatePosition(iter1_33.position)
				var6_33:UpdateDir(iter1_33.dir)
				var6_33:UpdateParent(iter1_33.parent)
				var6_33:UpdateChildList(iter1_33.child)
				var6_33:UpdateFloor(var4_33)
			else
				local var7_33 = var5_33:AddFurniture(iter1_33, var4_33)
			end

			arg0_33.viewComponent:UpdateDorm(arg0_33.dorm)
			arg0_33.viewComponent:UpdateFurnitrue(arg0_33.dorm:GetFurniture(iter1_33.configId))
		end

		for iter2_33, iter3_33 in ipairs(var3_33) do
			local var8_33 = var5_33:GetFurniture(iter3_33)

			var5_33:DeleteFurniture(iter3_33)

			if var8_33 then
				arg0_33.viewComponent:UpdateDorm(arg0_33.dorm)
				arg0_33.viewComponent:UpdateFurnitrue(arg0_33.dorm:GetFurniture(var8_33.configId))
			end
		end
	elseif var0_33 == DormProxy.THEME_TEMPLATE_ADDED then
		arg0_33.viewComponent:CustomThemeAdded(var1_33.template)
	elseif var0_33 == DormProxy.THEME_TEMPLATE_DELTETED then
		arg0_33.viewComponent:CustomThemeDeleted(var1_33.templateId)
	elseif var0_33 == GAME.BACKYARD_GET_THEME_TEMPLATE_DONE then
		local var9_33 = getProxy(DormProxy)

		arg0_33.viewComponent:SetThemes(var9_33:GetCustomThemeTemplates())
	elseif var0_33 == GAME.ON_APPLY_SELF_THEME then
		arg0_33.viewComponent:OnApplyThemeBefore()
	elseif var0_33 == GAME.ON_APPLY_SELF_THEME_DONE then
		arg0_33.viewComponent:OnApplyThemeAfter(var1_33.id)
	elseif var0_33 == CourtYardEvent._EXIT_MODE then
		arg0_33.viewComponent:emit(BaseUI.ON_CLOSE)
	elseif var0_33 == CourtYardEvent._DRAG_ITEM then
		GetOrAddComponent(arg0_33.viewComponent._tf, typeof(CanvasGroup)).blocksRaycasts = false
	elseif var0_33 == CourtYardEvent._DRAG_ITEM_END then
		GetOrAddComponent(arg0_33.viewComponent._tf, typeof(CanvasGroup)).blocksRaycasts = true
	elseif var0_33 == var0_0.START_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0_33.viewComponent._tf, typeof(CanvasGroup)).alpha = 0
	elseif var0_33 == var0_0.END_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0_33.viewComponent._tf, typeof(CanvasGroup)).alpha = 1
	elseif var0_33 == CourtYardEvent._FURNITURE_SELECTED then
		arg0_33.viewComponent:emit(BackYardDecrationLayer.INNER_SELECTED_FURNITRUE, var1_33)
	end
end

return var0_0
