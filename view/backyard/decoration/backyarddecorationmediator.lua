local var0 = class("BackYardDecorationMediator", import("...base.ContextMediator"))

var0.ADD_FURNITURE = "BackYardDecorationMediator:ADD_FURNITURE"
var0.REMOVE_PAPER = "BackYardDecorationMediator:REMOVE_PAPER"
var0.SAVE_ALL = "BackYardDecorationMediator:SAVE_ALL"
var0.ClEAR_ALL = "BackYardDecorationMediator:ClEAR_ALL"
var0.OPEN_SHOP = "BackYardDecorationMediator:OPEN_SHOP"
var0.GET_CUSTOM_THEME = "BackYardDecorationMediator:GET_CUSTOM_THEME"
var0.DELETE_THEME = "BackYardDecorationMediator:DELETE_THEME"
var0.SAVE_THEME = "BackYardDecorationMediator:SAVE_THEME"
var0.APPLY_THEME = "BackYardDecorationMediator:APPLY_THEME"
var0.ADD_FURNITURES = "BackYardDecorationMediator:ADD_FURNITURES"
var0.ON_SELECTED_FURNITRUE = "BackYardDecorationMediator:ON_SELECTED_FURNITRUE"
var0.GET_CURR_FURNITURE = "BackYardDecorationMediator:GET_CURR_FURNITURE"
var0.GET_OTHER_FURNITURE = "BackYardDecorationMediator:GET_OTHER_FURNITURE"
var0.GET_ALL_FURNITURE = "BackYardDecorationMediator:GET_ALL_FURNITURE"
var0.START_TAKE_THEME_PHOTO = "BackYardDecorationMediator:START_TAKE_THEME_PHOTO"
var0.END_TAKE_THEME_PHOTO = "BackYardDecorationMediator:END_TAKE_THEME_PHOTO"
var0.ON_SET_UP = "BackYardDecorationMediator:ON_SET_UP"

function var0.register(arg0)
	arg0:bind(var0.ON_SELECTED_FURNITRUE, function(arg0, arg1)
		_courtyard:GetController():SelectFurnitureByConfigId(arg1)
	end)
	arg0:bind(var0.APPLY_THEME, function(arg0, arg1, arg2)
		local var0, var1 = arg0:GetCanPutFurnitureForTheme(arg0.dorm, arg1)

		if arg2 then
			arg2(var1, var0)
		end
	end)
	arg0:bind(var0.SAVE_THEME, function(arg0, arg1, arg2)
		if not arg0:AnyFurnitureInFloor(arg0.dorm, getProxy(DormProxy).floor) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_save_empty_theme"))

			return
		end

		pg.UIMgr.GetInstance():LoadingOn()

		local var0 = BackYardBaseThemeTemplate.BuildId(arg1)
		local var1
		local var2
		local var3 = pg.UIMgr.GetInstance().uiCamera:GetComponent(typeof(Camera))

		seriesAsync({
			function(arg0)
				arg0:sendNotification(var0.START_TAKE_THEME_PHOTO)

				var1 = BackYardThemeTempalteUtil.TakePhoto(var3)
				var2 = BackYardThemeTempalteUtil.TakeIcon(var3)

				arg0:sendNotification(var0.END_TAKE_THEME_PHOTO)
				arg0()
			end,
			function(arg0)
				onNextTick(arg0)
			end,
			function(arg0)
				if not var1 or not var2 then
					return
				end

				BackYardThemeTempalteUtil.SavePhoto(var0, var1, var2, arg0)
			end,
			function(arg0)
				onNextTick(arg0)
			end,
			function(arg0)
				local var0 = BackYardThemeTempalteUtil.GetMd5(var0)
				local var1 = BackYardThemeTempalteUtil.GetIconMd5(var0)
				local var2 = _courtyard:GetController():GetStoreyData()

				pg.UIMgr.GetInstance():LoadingOff()
				arg0:sendNotification(GAME.BACKYARD_SAVE_THEME_TEMPLATE, {
					id = arg1,
					name = arg2,
					furnitureputList = var2,
					iconMd5 = var1,
					imageMd5 = var0
				})
				arg0()
			end
		})
	end)
	arg0:bind(var0.DELETE_THEME, function(arg0, arg1)
		arg0:sendNotification(GAME.BACKYARD_DELETE_THEME_TEMPLATE, {
			templateId = arg1
		})
	end)
	arg0:bind(var0.GET_CUSTOM_THEME, function(arg0, arg1)
		arg0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
			callback = arg1
		})
	end)
	arg0:bind(var0.OPEN_SHOP, function(arg0)
		_courtyard:GetController():SaveFurnitures()
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0:sendNotification(GAME.OPEN_BACKYARD_SHOP)
	end)
	arg0:bind(var0.SAVE_ALL, function(arg0)
		_courtyard:GetController():SaveFurnitures()
	end)
	arg0:bind(var0.ClEAR_ALL, function(arg0, arg1)
		arg0:sendNotification(GAME.ON_APPLY_SELF_THEME)
		_courtyard:GetController():ClearFurnitures()
	end)
	arg0:bind(var0.ADD_FURNITURE, function(arg0, arg1, arg2)
		local var0 = arg0:GenUniqueID(arg0.dorm, arg1.configId)

		_courtyard:GetController():AddFurniture({
			selected = true,
			id = var0,
			configId = arg1.configId,
			date = arg1.date
		})
		getProxy(DormProxy):_ClearNewFlag(arg1.configId)

		local var1 = arg0.dorm:GetFurniture(arg1.configId)

		var1:ClearNewFlag()
		arg0.viewComponent:UpdateFurnitrue(var1)

		if arg2 then
			arg2()
		end
	end)
	arg0:bind(var0.ADD_FURNITURES, function(arg0, arg1, arg2, arg3)
		local var0 = {}

		table.insert(var0, function(arg0)
			arg0.viewComponent:emit(var0.ClEAR_ALL)
			onNextTick(arg0)
		end)

		local function var1(arg0)
			_courtyard:GetController():AddFurniture({
				id = arg0.id,
				configId = arg0.configId,
				parent = arg0.parent,
				position = arg0.position,
				dir = arg0.dir,
				date = arg0.date
			})
		end

		local var2 = math.ceil(#arg2 / 3)

		for iter0, iter1 in pairs(arg2) do
			assert(iter1.position)
			table.insert(var0, function(arg0)
				var1(iter1)

				if (iter0 - 1) % var2 == 0 then
					onNextTick(arg0)
				else
					arg0()
				end
			end)
		end

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync(var0, function()
			if arg3 then
				arg3(arg2)
			end

			arg0:sendNotification(GAME.ON_APPLY_SELF_THEME_DONE, {
				id = arg1
			})
			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end)
	arg0:bind(var0.REMOVE_PAPER, function(arg0, arg1)
		_courtyard:GetController():RemovePaper(arg1.id)
	end)
	arg0:bind(var0.ON_SET_UP, function(arg0)
		arg0:SetUp()
	end)
end

function var0.AnyFurnitureInFloor(arg0, arg1, arg2)
	local var0 = arg1:GetThemeList()[arg2]

	if not var0 then
		return false
	end

	local var1 = var0:GetAllFurniture()

	return table.getCount(var1) > 0
end

function var0.GetCanPutFurnitureForTheme(arg0, arg1, arg2)
	local var0 = getProxy(DormProxy).floor
	local var1 = arg0:GetAllFloorFurnitures(arg1)
	local var2 = arg2:IsOccupyed(var1, var0)
	local var3 = {}
	local var4 = false

	if var2 then
		var3 = arg2:GetUsableFurnituresForFloor(var1, var0)
		var4 = false
	else
		local var5 = arg2:GetAllFurniture()

		for iter0, iter1 in pairs(var5) do
			table.insert(var3, iter1)
		end

		var4 = true
	end

	local var6 = arg0:FilterOwnCount(var3)

	table.sort(var6, BackyardThemeFurniture._LoadWeight)

	return var6, var4
end

function var0.FilterOwnCount(arg0, arg1)
	local var0 = {}
	local var1 = {}
	local var2 = {}
	local var3 = getProxy(DormProxy):getRawData()

	for iter0, iter1 in ipairs(arg1) do
		var1[iter1.configId] = (var1[iter1.configId] or 0) + 1

		if var3:GetOwnFurnitureCount(iter1.configId) >= var1[iter1.configId] then
			table.insert(var0, iter1)
		else
			table.insert(var2, iter1.id)
		end
	end

	for iter2, iter3 in ipairs(var2) do
		for iter4, iter5 in ipairs(var0) do
			if iter5.parent == iter3 then
				iter5.parent = 0
			end
		end
	end

	return var0
end

function var0.GetAllFloorFurnitures(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg1:GetThemeList()) do
		for iter2, iter3 in pairs(iter1:GetAllFurniture()) do
			var0[iter2] = iter3
		end
	end

	return var0
end

function var0.GenUniqueID(arg0, arg1, arg2)
	local var0 = arg0:GetAllFloorFurnitures(arg1)
	local var1 = arg1:GetOwnFurnitureCount(arg2)

	for iter0 = 0, var1 - 1 do
		local var2 = BackyardThemeFurniture.GetUniqueId(arg2, iter0)

		if not var0[var2] then
			return var2
		end
	end

	return BackyardThemeFurniture.GetUniqueId(arg2, 0)
end

function var0.SetUp(arg0)
	seriesAsync({
		function(arg0)
			local var0 = getProxy(DormProxy)

			arg0.dorm = var0:getData()

			arg0.viewComponent:SetDorm(arg0.dorm)
			arg0.viewComponent:SetThemes(var0:GetCustomThemeTemplates())
			onNextTick(arg0)
		end,
		function(arg0)
			if arg0.viewComponent.themes then
				arg0()

				return
			end

			arg0.viewComponent:emit(BackYardDecorationMediator.GET_CUSTOM_THEME, arg0)
		end
	}, function()
		arg0.viewComponent:InitPages()
	end)
end

function var0.listNotificationInterests(arg0)
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
		var0.START_TAKE_THEME_PHOTO,
		var0.END_TAKE_THEME_PHOTO
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == CourtYardEvent._SYN_FURNITURE then
		local var2 = var1[1]
		local var3 = var1[2]
		local var4 = getProxy(DormProxy).floor
		local var5 = arg0.dorm:GetTheme(var4)

		for iter0, iter1 in ipairs(var2) do
			local var6 = var5:GetFurniture(iter1.id)

			if var6 then
				var6:UpdatePosition(iter1.position)
				var6:UpdateDir(iter1.dir)
				var6:UpdateParent(iter1.parent)
				var6:UpdateChildList(iter1.child)
				var6:UpdateFloor(var4)
			else
				local var7 = var5:AddFurniture(iter1, var4)
			end

			arg0.viewComponent:UpdateDorm(arg0.dorm)
			arg0.viewComponent:UpdateFurnitrue(arg0.dorm:GetFurniture(iter1.configId))
		end

		for iter2, iter3 in ipairs(var3) do
			local var8 = var5:GetFurniture(iter3)

			var5:DeleteFurniture(iter3)

			if var8 then
				arg0.viewComponent:UpdateDorm(arg0.dorm)
				arg0.viewComponent:UpdateFurnitrue(arg0.dorm:GetFurniture(var8.configId))
			end
		end
	elseif var0 == DormProxy.THEME_TEMPLATE_ADDED then
		arg0.viewComponent:CustomThemeAdded(var1.template)
	elseif var0 == DormProxy.THEME_TEMPLATE_DELTETED then
		arg0.viewComponent:CustomThemeDeleted(var1.templateId)
	elseif var0 == GAME.BACKYARD_GET_THEME_TEMPLATE_DONE then
		local var9 = getProxy(DormProxy)

		arg0.viewComponent:SetThemes(var9:GetCustomThemeTemplates())
	elseif var0 == GAME.ON_APPLY_SELF_THEME then
		arg0.viewComponent:OnApplyThemeBefore()
	elseif var0 == GAME.ON_APPLY_SELF_THEME_DONE then
		arg0.viewComponent:OnApplyThemeAfter(var1.id)
	elseif var0 == CourtYardEvent._EXIT_MODE then
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	elseif var0 == CourtYardEvent._DRAG_ITEM then
		GetOrAddComponent(arg0.viewComponent._tf, typeof(CanvasGroup)).blocksRaycasts = false
	elseif var0 == CourtYardEvent._DRAG_ITEM_END then
		GetOrAddComponent(arg0.viewComponent._tf, typeof(CanvasGroup)).blocksRaycasts = true
	elseif var0 == var0.START_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0.viewComponent._tf, typeof(CanvasGroup)).alpha = 0
	elseif var0 == var0.END_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0.viewComponent._tf, typeof(CanvasGroup)).alpha = 1
	elseif var0 == CourtYardEvent._FURNITURE_SELECTED then
		arg0.viewComponent:emit(BackYardDecrationLayer.INNER_SELECTED_FURNITRUE, var1)
	end
end

return var0
