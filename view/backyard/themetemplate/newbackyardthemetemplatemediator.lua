local var0 = class("NewBackYardThemeTemplateMediator", import("...base.ContextMediator"))

var0.FETCH_ALL_THEME = "NewBackYardThemeTemplateMediator:FETCH_ALL_THEME"
var0.ON_CHARGE = "NewBackYardThemeTemplateMediator:ON_CHARGE"
var0.ON_SHOPPING = "NewBackYardShopMediator:ON_SHOPPING"
var0.ON_LIKE_THEME = "NewBackYardThemeTemplateMediator:ON_LIKE_THEME"
var0.ON_COLECT_THEME = "NewBackYardThemeTemplateMediator:ON_COLECT_THEME"
var0.ON_APPLY_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_APPLY_TEMPLATE"
var0.ON_UPLOAD_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_UPLOAD_TEMPLATE"
var0.ON_CANCEL_UPLOAD_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_CANCEL_UPLOAD_TEMPLATE"
var0.ON_DELETE_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_DELETE_TEMPLATE"
var0.GET_TEMPLATE_PLAYERINFO = "NewBackYardThemeTemplateMediator:GET_TEMPLATE_PLAYERINFO"
var0.ON_DISPLAY_PLAYER_INFO = "NewBackYardThemeTemplateMediator:ON_DISPLAY_PLAYER_INFO"
var0.ON_SEARCH = "NewBackYardThemeTemplateMediator:ON_SEARCH"
var0.ON_REFRESH = "NewBackYardThemeTemplateMediator:ON_REFRESH"
var0.ON_GET_THEMPLATE_DATA = "NewBackYardThemeTemplateMediator:ON_GET_THEMPLATE_DATA"
var0.ON_GET_SPCAIL_TYPE_TEMPLATE = "NewBackYardThemeTemplateMediator:ON_GET_SPCAIL_TYPE_TEMPLATE"
var0.GO_DECORATION = "NewBackYardThemeTemplateMediator:GO_DECORATION"

function var0.register(arg0)
	arg0:bind(var0.GO_DECORATION, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD, {
			openDecoration = true
		})
	end)
	arg0:bind(var0.ON_GET_SPCAIL_TYPE_TEMPLATE, function(arg0, arg1)
		arg0:sendNotification(GAME.BACKYARD_GET_SPECIFIED_TYPE_TEMPLATE, {
			type = arg1
		})
	end)
	arg0:bind(var0.ON_GET_THEMPLATE_DATA, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DATA, {
			templateId = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_REFRESH, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.BACKYARD_REFRESH_SHOP_TEMPLATE, {
			timeType = arg3,
			type = arg1,
			page = arg2,
			force = arg4
		})
	end)
	arg0:bind(var0.ON_SEARCH, function(arg0, arg1, arg2)
		if arg1 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM or arg1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
			arg0.viewComponent:SearchKeyChange(arg2)
		elseif arg1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			arg0:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE, {
				str = arg2
			})
		end
	end)
	arg0:bind(var0.ON_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BUY_FURNITURE, {
			furnitureIds = arg1,
			type = arg2
		})
	end)
	arg0:bind(var0.ON_DISPLAY_PLAYER_INFO, function(arg0, arg1, arg2, arg3)
		arg0.contextData.pos = arg2
		arg0.contextData.themeName = arg3

		arg0:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1
		})
	end)
	arg0:bind(var0.GET_TEMPLATE_PLAYERINFO, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_PLAYE_INFO, {
			type = arg1,
			templateId = arg2.id,
			userId = arg2:GetUserId()
		})
	end)
	arg0:bind(var0.ON_UPLOAD_TEMPLATE, function(arg0, arg1)
		local var0 = getProxy(PlayerProxy):getData()

		if not var0:CanUploadBackYardThemeTemplate() then
			local var1 = var0:GetBanUploadBackYardThemeTemplateTime()

			arg0.contextData.msgBox:ExecuteAction("SetUp", {
				hideNo = true,
				content = i18n("backyard_theme_ban_upload_tip", var1)
			})

			return
		end

		if getProxy(DormProxy):GetUploadThemeTemplateCnt() >= BackYardConst.MAX_UPLOAD_THEME_CNT then
			arg0.contextData.msgBox:ExecuteAction("SetUp", {
				hideNo = true,
				content = i18n("backyard_theme_upload_over_maxcnt")
			})

			return
		end

		arg0:sendNotification(GAME.BACKYARD_UPLOAD_THEME_TEMPLATE, {
			templateId = arg1.id
		})
	end)
	arg0:bind(var0.ON_CANCEL_UPLOAD_TEMPLATE, function(arg0, arg1)
		arg0.contextData.msgBox:ExecuteAction("SetUp", {
			content = i18n("backyard_theme_cancel_template_upload_tip"),
			onYes = function()
				arg0:sendNotification(GAME.BACKYARD_UNLOAD_THEME_TEMPLATE, {
					templateId = arg1.id
				})
			end
		})
	end)
	arg0:bind(var0.ON_DELETE_TEMPLATE, function(arg0, arg1)
		arg0.contextData.msgBox:ExecuteAction("SetUp", {
			content = i18n("backyard_theme_delete_themplate_tip"),
			onYes = function()
				arg0:sendNotification(GAME.BACKYARD_DELETE_THEME_TEMPLATE, {
					templateId = arg1.id
				})
			end
		})
	end)
	arg0:bind(var0.ON_APPLY_TEMPLATE, function(arg0, arg1, arg2)
		local var0 = arg1:OwnThemeTemplateFurniture()

		local function var1()
			arg0:sendNotification(GAME.BACKYARD_APPLY_THEME_TEMPLATE, {
				template = arg1
			})
		end

		if not var0 then
			arg0.contextData.msgBox:ExecuteAction("SetUp", {
				type = BackYardThemeTemplateMsgBox.TYPE_IMAGE,
				content = i18n("backyard_theme_apply_tip1"),
				srpiteName = arg1:GetTextureIconName(),
				md5 = arg1:GetIconMd5(),
				confirmTxt = i18n("backyard_theme_word_buy"),
				cancelTxt = i18n("backyard_theme_word_apply"),
				onYes = arg2,
				onCancel = var1
			})

			return
		end

		var1()
	end)
	arg0:bind(var0.ON_LIKE_THEME, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BACKYARD_LIKE_THEME_TEMPLATE, {
			templateId = arg1.id,
			uploadTime = arg2
		})
	end)
	arg0:bind(var0.ON_COLECT_THEME, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.BACKYARD_COLLECT_THEME_TEMPLATE, {
			templateId = arg1.id,
			isCancel = arg2,
			uploadTime = arg3
		})
	end)
	arg0:bind(var0.ON_CHARGE, function(arg0, arg1)
		if arg1 == PlayerConst.ResDiamond then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		elseif arg1 == PlayerConst.ResDormMoney then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		end
	end)
	arg0:bind(var0.FETCH_ALL_THEME, function(arg0, arg1)
		arg0:sendNotification(GAME.GET_ALL_BACKYARD_THEME_TEMPLATE, {
			callback = function(arg0, arg1, arg2)
				arg0.viewComponent:SetShopThemeTemplate(arg0)
				arg0.viewComponent:SetCustomThemeTemplate(arg1)
				arg0.viewComponent:SetCollectionThemeTemplate(arg2)
				arg1()
			end
		})
	end)
	arg0.viewComponent:SetDorm(getProxy(DormProxy):getData())
	arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getData())
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:PlayerUpdated(var1)
	elseif var0 == DormProxy.THEME_TEMPLATE_UPDATED then
		local var3 = getProxy(DormProxy)
		local var4 = var1.type
		local var5 = var1.template

		if var4 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			arg0.viewComponent:ShopThemeTemplateUpdate(var5)
		elseif var4 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
			arg0.viewComponent:CollectionThemeTemplateUpdate(var5)
		elseif var4 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			arg0.viewComponent:CustomThemeTemplateUpdate(var5)
		end
	elseif var0 == GAME.FRIEND_SEARCH_DONE then
		if var1.list[1] then
			arg0:addSubLayers(Context.New({
				viewComponent = FriendInfoLayer,
				mediator = FriendInfoMediator,
				data = {
					backyardView = true,
					friend = var1.list[1],
					pos = arg0.contextData.pos,
					msg = arg0.contextData.themeName
				}
			}))

			arg0.contextData.pos = nil
			arg0.contextData.themeName = nil
		end
	elseif var0 == GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_DONE then
		if var1.existNew then
			BackYardThemeTempalteUtil.ClearAllCacheAsyn()
		end

		local var6 = getProxy(DormProxy):GetShopThemeTemplates()

		arg0.viewComponent:OnShopTemplatesUpdated(var6)
	elseif var0 == DormProxy.DORM_UPDATEED then
		local var7 = getProxy(DormProxy)

		arg0.viewComponent:UpdateDorm(var7:getData())
	elseif var0 == GAME.BUY_FURNITURE_DONE then
		arg0.viewComponent:FurnituresUpdated(var2)
	elseif var0 == GAME.BACKYARD_APPLY_THEME_TEMPLATE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_apply_success"))
	elseif var0 == GAME.BACKYARD_SEARCH_THEME_TEMPLATE_DONE then
		arg0.viewComponent:ShopSearchKeyChange(var1.template)
	elseif var0 == GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO then
		arg0.viewComponent:ClearShopSearchKey()
	elseif var0 == GAME.BACKYARD_UNLOAD_THEME_TEMPLATE_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_unload_success"))
	elseif var0 == DormProxy.THEME_TEMPLATE_DELTETED then
		arg0.viewComponent:DeleteCustomThemeTemplate(var1.templateId)
	elseif var0 == GAME.BACKYARD_DELETE_THEME_TEMPLATE_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_delete_success"))
	elseif var0 == GAME.BACKYARD_UPLOAD_THEME_TEMPLATE_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_upload_success"))
	elseif var0 == DormProxy.COLLECTION_THEME_TEMPLATE_ADDED then
		arg0.viewComponent:AddCollectionThemeTemplate(var1.template)
	elseif var0 == DormProxy.COLLECTION_THEME_TEMPLATE_DELETED then
		arg0.viewComponent:DeleteCollectionThemeTemplate(var1.id)
	elseif var0 == DormProxy.SHOP_THEME_TEMPLATE_DELETED then
		arg0.viewComponent:DeleteShopThemeTemplate(var1.id)
	elseif var0 == GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_ERRO then
		arg0.viewComponent:OnShopTemplatesErro()
	end
end

return var0
