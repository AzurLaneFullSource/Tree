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
				BackYardThemeTempalteUtil.TakePreview(var3_4, function(arg0_6)
					var1_4 = arg0_6

					arg0_5()
				end)
			end,
			function(arg0_7)
				onNextTick(arg0_7)
			end,
			function(arg0_8)
				BackYardThemeTempalteUtil.TakeIcon(var3_4, function(arg0_9)
					var2_4 = arg0_9

					arg0_8()
				end)
			end,
			function(arg0_10)
				arg0_1:sendNotification(var0_0.END_TAKE_THEME_PHOTO)
				onNextTick(arg0_10)
			end,
			function(arg0_11)
				if not var1_4 or not var2_4 then
					return
				end

				BackYardThemeTempalteUtil.SavePhoto(var0_4, var1_4, var2_4, arg0_11)
			end,
			function(arg0_12)
				onNextTick(arg0_12)
			end,
			function(arg0_13)
				local var0_13 = BackYardThemeTempalteUtil.GetMd5(var0_4)
				local var1_13 = BackYardThemeTempalteUtil.GetIconMd5(var0_4)
				local var2_13 = _courtyard:GetController():GetStoreyData()

				pg.UIMgr.GetInstance():LoadingOff()
				arg0_1:sendNotification(GAME.BACKYARD_SAVE_THEME_TEMPLATE, {
					id = arg1_4,
					name = arg2_4,
					furnitureputList = var2_13,
					iconMd5 = var1_13,
					imageMd5 = var0_13
				})
				arg0_13()
			end
		})
	end)
	arg0_1:bind(var0_0.DELETE_THEME, function(arg0_14, arg1_14)
		arg0_1:sendNotification(GAME.BACKYARD_DELETE_THEME_TEMPLATE, {
			templateId = arg1_14
		})
	end)
	arg0_1:bind(var0_0.GET_CUSTOM_THEME, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
			callback = arg1_15
		})
	end)
	arg0_1:bind(var0_0.OPEN_SHOP, function(arg0_16)
		_courtyard:GetController():SaveFurnitures()
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0_1:sendNotification(GAME.OPEN_BACKYARD_SHOP)
	end)
	arg0_1:bind(var0_0.SAVE_ALL, function(arg0_17)
		_courtyard:GetController():SaveFurnitures()
	end)
	arg0_1:bind(var0_0.ClEAR_ALL, function(arg0_18, arg1_18)
		arg0_1:sendNotification(GAME.ON_APPLY_SELF_THEME)
		_courtyard:GetController():ClearFurnitures()
	end)
	arg0_1:bind(var0_0.ADD_FURNITURE, function(arg0_19, arg1_19, arg2_19)
		local var0_19 = arg0_1:GenUniqueID(arg0_1.dorm, arg1_19.configId)

		_courtyard:GetController():AddFurniture({
			selected = true,
			id = var0_19,
			configId = arg1_19.configId,
			date = arg1_19.date
		})
		getProxy(DormProxy):getRawData():ClearNewFlagById(arg1_19.configId)

		local var1_19 = arg0_1.dorm:GetFurniture(arg1_19.configId)

		var1_19:ClearNewFlag()
		arg0_1.viewComponent:UpdateFurnitrue(var1_19)

		if arg2_19 then
			arg2_19()
		end
	end)
	arg0_1:bind(var0_0.ADD_FURNITURES, function(arg0_20, arg1_20, arg2_20, arg3_20)
		local var0_20 = {}

		table.insert(var0_20, function(arg0_21)
			arg0_1.viewComponent:emit(var0_0.ClEAR_ALL)
			onNextTick(arg0_21)
		end)

		local function var1_20(arg0_22)
			_courtyard:GetController():AddFurniture({
				id = arg0_22.id,
				configId = arg0_22.configId,
				parent = arg0_22.parent,
				position = arg0_22.position,
				dir = arg0_22.dir,
				date = arg0_22.date
			})
		end

		local var2_20 = math.ceil(#arg2_20 / 3)

		for iter0_20, iter1_20 in pairs(arg2_20) do
			assert(iter1_20.position)
			table.insert(var0_20, function(arg0_23)
				var1_20(iter1_20)

				if (iter0_20 - 1) % var2_20 == 0 then
					onNextTick(arg0_23)
				else
					arg0_23()
				end
			end)
		end

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync(var0_20, function()
			if arg3_20 then
				arg3_20(arg2_20)
			end

			arg0_1:sendNotification(GAME.ON_APPLY_SELF_THEME_DONE, {
				id = arg1_20
			})
			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end)
	arg0_1:bind(var0_0.REMOVE_PAPER, function(arg0_25, arg1_25)
		_courtyard:GetController():RemovePaper(arg1_25.id)
	end)
	arg0_1:bind(var0_0.ON_SET_UP, function(arg0_26)
		arg0_1:SetUp()
	end)
end

function var0_0.AnyFurnitureInFloor(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg1_27:GetThemeList()[arg2_27]

	if not var0_27 then
		return false
	end

	local var1_27 = var0_27:GetAllFurniture()

	return table.getCount(var1_27) > 0
end

function var0_0.GetCanPutFurnitureForTheme(arg0_28, arg1_28, arg2_28)
	local var0_28 = getProxy(DormProxy).floor
	local var1_28 = arg0_28:GetAllFloorFurnitures(arg1_28)
	local var2_28 = arg2_28:IsOccupyed(var1_28, var0_28)
	local var3_28 = {}
	local var4_28 = false

	if var2_28 then
		var3_28 = arg2_28:GetUsableFurnituresForFloor(var1_28, var0_28)
		var4_28 = false
	else
		local var5_28 = arg2_28:GetAllFurniture()

		for iter0_28, iter1_28 in pairs(var5_28) do
			table.insert(var3_28, iter1_28)
		end

		var4_28 = true
	end

	local var6_28 = arg0_28:FilterOwnCount(var3_28)

	table.sort(var6_28, BackyardThemeFurniture._LoadWeight)

	return var6_28, var4_28
end

function var0_0.FilterOwnCount(arg0_29, arg1_29)
	local var0_29 = {}
	local var1_29 = {}
	local var2_29 = {}
	local var3_29 = getProxy(DormProxy):getRawData()

	for iter0_29, iter1_29 in ipairs(arg1_29) do
		var1_29[iter1_29.configId] = (var1_29[iter1_29.configId] or 0) + 1

		if var3_29:GetOwnFurnitureCount(iter1_29.configId) >= var1_29[iter1_29.configId] then
			table.insert(var0_29, iter1_29)
		else
			table.insert(var2_29, iter1_29.id)
		end
	end

	for iter2_29, iter3_29 in ipairs(var2_29) do
		for iter4_29, iter5_29 in ipairs(var0_29) do
			if iter5_29.parent == iter3_29 then
				iter5_29.parent = 0
			end
		end
	end

	return var0_29
end

function var0_0.GetAllFloorFurnitures(arg0_30, arg1_30)
	local var0_30 = {}

	for iter0_30, iter1_30 in pairs(arg1_30:GetThemeList()) do
		for iter2_30, iter3_30 in pairs(iter1_30:GetAllFurniture()) do
			var0_30[iter2_30] = iter3_30
		end
	end

	return var0_30
end

function var0_0.GenUniqueID(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31:GetAllFloorFurnitures(arg1_31)
	local var1_31 = arg1_31:GetOwnFurnitureCount(arg2_31)

	for iter0_31 = 0, var1_31 - 1 do
		local var2_31 = BackyardThemeFurniture.GetUniqueId(arg2_31, iter0_31)

		if not var0_31[var2_31] then
			return var2_31
		end
	end

	return BackyardThemeFurniture.GetUniqueId(arg2_31, 0)
end

function var0_0.SetUp(arg0_32)
	seriesAsync({
		function(arg0_33)
			local var0_33 = getProxy(DormProxy)

			arg0_32.dorm = var0_33:getData()

			arg0_32.viewComponent:SetDorm(arg0_32.dorm)
			arg0_32.viewComponent:SetThemes(var0_33:GetCustomThemeTemplates())
			onNextTick(arg0_33)
		end,
		function(arg0_34)
			if arg0_32.viewComponent.themes then
				arg0_34()

				return
			end

			arg0_32.viewComponent:emit(BackYardDecorationMediator.GET_CUSTOM_THEME, arg0_34)
		end
	}, function()
		arg0_32.viewComponent:InitPages()
	end)
end

function var0_0.listNotificationInterests(arg0_36)
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

function var0_0.handleNotification(arg0_37, arg1_37)
	local var0_37 = arg1_37:getName()
	local var1_37 = arg1_37:getBody()

	if var0_37 == CourtYardEvent._SYN_FURNITURE then
		local var2_37 = var1_37[1]
		local var3_37 = var1_37[2]
		local var4_37 = getProxy(DormProxy).floor
		local var5_37 = arg0_37.dorm:GetTheme(var4_37)

		for iter0_37, iter1_37 in ipairs(var2_37) do
			local var6_37 = var5_37:GetFurniture(iter1_37.id)

			if var6_37 then
				var6_37:UpdatePosition(iter1_37.position)
				var6_37:UpdateDir(iter1_37.dir)
				var6_37:UpdateParent(iter1_37.parent)
				var6_37:UpdateChildList(iter1_37.child)
				var6_37:UpdateFloor(var4_37)
			else
				local var7_37 = var5_37:AddFurniture(iter1_37, var4_37)
			end

			arg0_37.viewComponent:UpdateDorm(arg0_37.dorm)
			arg0_37.viewComponent:UpdateFurnitrue(arg0_37.dorm:GetFurniture(iter1_37.configId))
		end

		for iter2_37, iter3_37 in ipairs(var3_37) do
			local var8_37 = var5_37:GetFurniture(iter3_37)

			var5_37:DeleteFurniture(iter3_37)

			if var8_37 then
				arg0_37.viewComponent:UpdateDorm(arg0_37.dorm)
				arg0_37.viewComponent:UpdateFurnitrue(arg0_37.dorm:GetFurniture(var8_37.configId))
			end
		end
	elseif var0_37 == DormProxy.THEME_TEMPLATE_ADDED then
		arg0_37.viewComponent:CustomThemeAdded(var1_37.template)
	elseif var0_37 == DormProxy.THEME_TEMPLATE_DELTETED then
		arg0_37.viewComponent:CustomThemeDeleted(var1_37.templateId)
	elseif var0_37 == GAME.BACKYARD_GET_THEME_TEMPLATE_DONE then
		local var9_37 = getProxy(DormProxy)

		arg0_37.viewComponent:SetThemes(var9_37:GetCustomThemeTemplates())
	elseif var0_37 == GAME.ON_APPLY_SELF_THEME then
		arg0_37.viewComponent:OnApplyThemeBefore()
	elseif var0_37 == GAME.ON_APPLY_SELF_THEME_DONE then
		arg0_37.viewComponent:OnApplyThemeAfter(var1_37.id)
	elseif var0_37 == CourtYardEvent._EXIT_MODE then
		arg0_37.viewComponent:emit(BaseUI.ON_CLOSE)
	elseif var0_37 == CourtYardEvent._DRAG_ITEM then
		GetOrAddComponent(arg0_37.viewComponent._tf, typeof(CanvasGroup)).blocksRaycasts = false
	elseif var0_37 == CourtYardEvent._DRAG_ITEM_END then
		GetOrAddComponent(arg0_37.viewComponent._tf, typeof(CanvasGroup)).blocksRaycasts = true
	elseif var0_37 == var0_0.START_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0_37.viewComponent._tf, typeof(CanvasGroup)).alpha = 0
	elseif var0_37 == var0_0.END_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0_37.viewComponent._tf, typeof(CanvasGroup)).alpha = 1
	elseif var0_37 == CourtYardEvent._FURNITURE_SELECTED then
		arg0_37.viewComponent:emit(BackYardDecrationLayer.INNER_SELECTED_FURNITRUE, var1_37)
	end
end

return var0_0
