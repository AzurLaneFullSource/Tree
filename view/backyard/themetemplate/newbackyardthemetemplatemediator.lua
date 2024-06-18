local var0_0 = class("NewBackYardThemeTemplateMediator", import("...base.ContextMediator"))

var0_0.FETCH_ALL_THEME = "NewBackYardThemeTemplateMediator:FETCH_ALL_THEME"
var0_0.ON_CHARGE = "NewBackYardThemeTemplateMediator:ON_CHARGE"
var0_0.ON_SHOPPING = "NewBackYardShopMediator:ON_SHOPPING"
var0_0.ON_LIKE_THEME = "NewBackYardThemeTemplateMediator:ON_LIKE_THEME"
var0_0.ON_COLECT_THEME = "NewBackYardThemeTemplateMediator:ON_COLECT_THEME"
var0_0.ON_APPLY_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_APPLY_TEMPLATE"
var0_0.ON_UPLOAD_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_UPLOAD_TEMPLATE"
var0_0.ON_CANCEL_UPLOAD_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_CANCEL_UPLOAD_TEMPLATE"
var0_0.ON_DELETE_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_DELETE_TEMPLATE"
var0_0.GET_TEMPLATE_PLAYERINFO = "NewBackYardThemeTemplateMediator:GET_TEMPLATE_PLAYERINFO"
var0_0.ON_DISPLAY_PLAYER_INFO = "NewBackYardThemeTemplateMediator:ON_DISPLAY_PLAYER_INFO"
var0_0.ON_SEARCH = "NewBackYardThemeTemplateMediator:ON_SEARCH"
var0_0.ON_REFRESH = "NewBackYardThemeTemplateMediator:ON_REFRESH"
var0_0.ON_GET_THEMPLATE_DATA = "NewBackYardThemeTemplateMediator:ON_GET_THEMPLATE_DATA"
var0_0.ON_GET_SPCAIL_TYPE_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_GET_SPCAIL_TYPE_TEMPLATE"
var0_0.GO_DECORATION = "NewBackYardThemeTemplateMediator:GO_DECORATION"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_DECORATION, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD, {
			openDecoration = true
		})
	end)
	arg0_1:bind(var0_0.ON_GET_SPCAIL_TYPE_TEMPLATE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.BACKYARD_GET_SPECIFIED_TYPE_TEMPLATE, {
			type = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_GET_THEMPLATE_DATA, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DATA, {
			templateId = arg1_4,
			callback = arg2_4
		})
	end)
	arg0_1:bind(var0_0.ON_REFRESH, function(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
		arg0_1:sendNotification(GAME.BACKYARD_REFRESH_SHOP_TEMPLATE, {
			timeType = arg3_5,
			type = arg1_5,
			page = arg2_5,
			force = arg4_5
		})
	end)
	arg0_1:bind(var0_0.ON_SEARCH, function(arg0_6, arg1_6, arg2_6)
		if arg1_6 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM or arg1_6 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
			arg0_1.viewComponent:SearchKeyChange(arg2_6)
		elseif arg1_6 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			arg0_1:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE, {
				str = arg2_6
			})
		end
	end)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.BUY_FURNITURE, {
			furnitureIds = arg1_7,
			type = arg2_7
		})
	end)
	arg0_1:bind(var0_0.ON_DISPLAY_PLAYER_INFO, function(arg0_8, arg1_8, arg2_8, arg3_8)
		arg0_1.contextData.pos = arg2_8
		arg0_1.contextData.themeName = arg3_8

		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1_8
		})
	end)
	arg0_1:bind(var0_0.GET_TEMPLATE_PLAYERINFO, function(arg0_9, arg1_9, arg2_9)
		arg0_1:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_PLAYE_INFO, {
			type = arg1_9,
			templateId = arg2_9.id,
			userId = arg2_9:GetUserId()
		})
	end)
	arg0_1:bind(var0_0.ON_UPLOAD_TEMPLATE, function(arg0_10, arg1_10)
		local var0_10 = getProxy(PlayerProxy):getData()

		if not var0_10:CanUploadBackYardThemeTemplate() then
			local var1_10 = var0_10:GetBanUploadBackYardThemeTemplateTime()

			arg0_1.contextData.msgBox:ExecuteAction("SetUp", {
				hideNo = true,
				content = i18n("backyard_theme_ban_upload_tip", var1_10)
			})

			return
		end

		if getProxy(DormProxy):GetUploadThemeTemplateCnt() >= BackYardConst.MAX_UPLOAD_THEME_CNT then
			arg0_1.contextData.msgBox:ExecuteAction("SetUp", {
				hideNo = true,
				content = i18n("backyard_theme_upload_over_maxcnt")
			})

			return
		end

		arg0_1:sendNotification(GAME.BACKYARD_UPLOAD_THEME_TEMPLATE, {
			templateId = arg1_10.id
		})
	end)
	arg0_1:bind(var0_0.ON_CANCEL_UPLOAD_TEMPLATE, function(arg0_11, arg1_11)
		arg0_1.contextData.msgBox:ExecuteAction("SetUp", {
			content = i18n("backyard_theme_cancel_template_upload_tip"),
			onYes = function()
				arg0_1:sendNotification(GAME.BACKYARD_UNLOAD_THEME_TEMPLATE, {
					templateId = arg1_11.id
				})
			end
		})
	end)
	arg0_1:bind(var0_0.ON_DELETE_TEMPLATE, function(arg0_13, arg1_13)
		arg0_1.contextData.msgBox:ExecuteAction("SetUp", {
			content = i18n("backyard_theme_delete_themplate_tip"),
			onYes = function()
				arg0_1:sendNotification(GAME.BACKYARD_DELETE_THEME_TEMPLATE, {
					templateId = arg1_13.id
				})
			end
		})
	end)
	arg0_1:bind(var0_0.ON_APPLY_TEMPLATE, function(arg0_15, arg1_15, arg2_15)
		local var0_15 = arg1_15:OwnThemeTemplateFurniture()

		local function var1_15()
			arg0_1:sendNotification(GAME.BACKYARD_APPLY_THEME_TEMPLATE, {
				template = arg1_15
			})
		end

		if not var0_15 then
			arg0_1.contextData.msgBox:ExecuteAction("SetUp", {
				type = BackYardThemeTemplateMsgBox.TYPE_IMAGE,
				content = i18n("backyard_theme_apply_tip1"),
				srpiteName = arg1_15:GetTextureIconName(),
				md5 = arg1_15:GetIconMd5(),
				confirmTxt = i18n("backyard_theme_word_buy"),
				cancelTxt = i18n("backyard_theme_word_apply"),
				onYes = arg2_15,
				onCancel = var1_15
			})

			return
		end

		var1_15()
	end)
	arg0_1:bind(var0_0.ON_LIKE_THEME, function(arg0_17, arg1_17, arg2_17)
		arg0_1:sendNotification(GAME.BACKYARD_LIKE_THEME_TEMPLATE, {
			templateId = arg1_17.id,
			uploadTime = arg2_17
		})
	end)
	arg0_1:bind(var0_0.ON_COLECT_THEME, function(arg0_18, arg1_18, arg2_18, arg3_18)
		arg0_1:sendNotification(GAME.BACKYARD_COLLECT_THEME_TEMPLATE, {
			templateId = arg1_18.id,
			isCancel = arg2_18,
			uploadTime = arg3_18
		})
	end)
	arg0_1:bind(var0_0.ON_CHARGE, function(arg0_19, arg1_19)
		if arg1_19 == PlayerConst.ResDiamond then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		elseif arg1_19 == PlayerConst.ResDormMoney then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		end
	end)
	arg0_1:bind(var0_0.FETCH_ALL_THEME, function(arg0_20, arg1_20)
		arg0_1:sendNotification(GAME.GET_ALL_BACKYARD_THEME_TEMPLATE, {
			callback = function(arg0_21, arg1_21, arg2_21)
				arg0_1.viewComponent:SetShopThemeTemplate(arg0_21)
				arg0_1.viewComponent:SetCustomThemeTemplate(arg1_21)
				arg0_1.viewComponent:SetCollectionThemeTemplate(arg2_21)
				arg1_20()
			end
		})
	end)
	arg0_1.viewComponent:SetDorm(getProxy(DormProxy):getData())
	arg0_1.viewComponent:SetPlayer(getProxy(PlayerProxy):getData())
end

function var0_0.listNotificationInterests(arg0_22)
	return {
		PlayerProxy.UPDATED,
		GAME.FRIEND_SEARCH_DONE,
		GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_DONE,
		GAME.BACKYARD_GET_SPECIFIED_TYPE_TEMPLATE_DONE,
		GAME.BUY_FURNITURE_DONE,
		GAME.BACKYARD_APPLY_THEME_TEMPLATE_DONE,
		GAME.BACKYARD_SEARCH_THEME_TEMPLATE_DONE,
		GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO,
		GAME.BACKYARD_UNLOAD_THEME_TEMPLATE_DONE,
		GAME.BACKYARD_DELETE_THEME_TEMPLATE_DONE,
		GAME.BACKYARD_UPLOAD_THEME_TEMPLATE_DONE,
		DormProxy.THEME_TEMPLATE_UPDATED,
		DormProxy.DORM_UPDATEED,
		DormProxy.THEME_TEMPLATE_DELTETED,
		DormProxy.COLLECTION_THEME_TEMPLATE_ADDED,
		DormProxy.COLLECTION_THEME_TEMPLATE_DELETED,
		DormProxy.SHOP_THEME_TEMPLATE_DELETED,
		GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_ERRO
	}
end

function var0_0.handleNotification(arg0_23, arg1_23)
	local var0_23 = arg1_23:getName()
	local var1_23 = arg1_23:getBody()
	local var2_23 = arg1_23:getType()

	if var0_23 == PlayerProxy.UPDATED then
		arg0_23.viewComponent:PlayerUpdated(var1_23)
	elseif var0_23 == DormProxy.THEME_TEMPLATE_UPDATED then
		local var3_23 = getProxy(DormProxy)
		local var4_23 = var1_23.type
		local var5_23 = var1_23.template

		if var4_23 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			arg0_23.viewComponent:ShopThemeTemplateUpdate(var5_23)
		elseif var4_23 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
			arg0_23.viewComponent:CollectionThemeTemplateUpdate(var5_23)
		elseif var4_23 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			arg0_23.viewComponent:CustomThemeTemplateUpdate(var5_23)
		end
	elseif var0_23 == GAME.FRIEND_SEARCH_DONE then
		if var1_23.list[1] then
			arg0_23:addSubLayers(Context.New({
				viewComponent = FriendInfoLayer,
				mediator = FriendInfoMediator,
				data = {
					backyardView = true,
					friend = var1_23.list[1],
					pos = arg0_23.contextData.pos,
					msg = arg0_23.contextData.themeName
				}
			}))

			arg0_23.contextData.pos = nil
			arg0_23.contextData.themeName = nil
		end
	elseif var0_23 == GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_DONE then
		if var1_23.existNew then
			BackYardThemeTempalteUtil.ClearAllCacheAsyn()
		end

		local var6_23 = getProxy(DormProxy):GetShopThemeTemplates()

		arg0_23.viewComponent:OnShopTemplatesUpdated(var6_23)
	elseif var0_23 == DormProxy.DORM_UPDATEED then
		local var7_23 = getProxy(DormProxy)

		arg0_23.viewComponent:UpdateDorm(var7_23:getData())
	elseif var0_23 == GAME.BUY_FURNITURE_DONE then
		arg0_23.viewComponent:FurnituresUpdated(var2_23)
	elseif var0_23 == GAME.BACKYARD_APPLY_THEME_TEMPLATE_DONE then
		arg0_23:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_apply_success"))
	elseif var0_23 == GAME.BACKYARD_SEARCH_THEME_TEMPLATE_DONE then
		arg0_23.viewComponent:ShopSearchKeyChange(var1_23.template)
	elseif var0_23 == GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO then
		arg0_23.viewComponent:ClearShopSearchKey()
	elseif var0_23 == GAME.BACKYARD_UNLOAD_THEME_TEMPLATE_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_unload_success"))
	elseif var0_23 == DormProxy.THEME_TEMPLATE_DELTETED then
		arg0_23.viewComponent:DeleteCustomThemeTemplate(var1_23.templateId)
	elseif var0_23 == GAME.BACKYARD_DELETE_THEME_TEMPLATE_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_delete_success"))
	elseif var0_23 == GAME.BACKYARD_UPLOAD_THEME_TEMPLATE_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_upload_success"))
	elseif var0_23 == DormProxy.COLLECTION_THEME_TEMPLATE_ADDED then
		arg0_23.viewComponent:AddCollectionThemeTemplate(var1_23.template)
	elseif var0_23 == DormProxy.COLLECTION_THEME_TEMPLATE_DELETED then
		arg0_23.viewComponent:DeleteCollectionThemeTemplate(var1_23.id)
	elseif var0_23 == DormProxy.SHOP_THEME_TEMPLATE_DELETED then
		arg0_23.viewComponent:DeleteShopThemeTemplate(var1_23.id)
	elseif var0_23 == GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_ERRO then
		arg0_23.viewComponent:OnShopTemplatesErro()
	end
end

return var0_0
