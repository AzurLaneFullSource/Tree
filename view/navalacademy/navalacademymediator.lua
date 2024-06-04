local var0 = class("NavalAcademyMediator", import("..base.ContextMediator"))

var0.ON_OPEN_CLASSROOM = "NavalAcademyMediator:ON_OPEN_CLASSROOM"
var0.ON_OPEN_COMMANDER = "NavalAcademyMediator:ON_OPEN_COMMANDER"
var0.ON_OPEN_COLLECTION = "NavalAcademyMediator:ON_OPEN_COLLECTION"
var0.ON_OPEN_OILRESFIELD = "NavalAcademyMediator:ON_OPEN_OILRESFIELD"
var0.ON_OPEN_GOLDRESFIELD = "NavalAcademyMediator:ON_OPEN_GOLDRESFIELD"
var0.ON_OPEN_SUPPLYSHOP = "NavalAcademyMediator:ON_OPEN_SUPPLYSHOP"
var0.ON_OPEN_TACTICROOM = "NavalAcademyMediator:ON_OPEN_TACTICROOM"
var0.ON_OPEN_MINIGAMEHALL = "NavalAcademyMediator:ON_OPEN_MINIGAMEHALL"
var0.UPGRADE_FIELD = "NavalAcademyMediator:UPGRADE_FIELD"
var0.GO_SCENE = "NavalAcademyMediator:GO_SCENE"
var0.OPEN_ACTIVITY_PANEL = "NavalAcademyMediator:OPEN_ACTIVITY_PANEL"
var0.OPEN_ACTIVITY_SHOP = "NavalAcademyMediator:OPEN_ACTIVITY_SHOP"
var0.OPEN_SCROLL = "NavalAcademyMediator:OPEN_SCROLL"
var0.ACTIVITY_OP = "NavalAcademyMediator:ACTIVITY_OP"
var0.TASK_GO = "NavalAcademyMediator:TASK_GO"
var0.GO_TASK_SCENE = "NavalAcademyMediator:GO_TASK_SCENE"
var0.ON_GET_CLASS_RES = "NavalAcademyMediator:ON_GET_CLASS_RES"
var0.ON_GET_RES = "NavalAcademyMediator:ON_GET_RES"

function var0.register(arg0)
	arg0:bind(var0.ON_GET_CLASS_RES, function(arg0)
		arg0:sendNotification(GAME.HARVEST_CLASS_RES)
	end)
	arg0:bind(var0.ON_GET_RES, function(arg0, arg1)
		arg0:sendNotification(GAME.HARVEST_RES, arg1)
	end)
	arg0:bind(var0.GO_TASK_SCENE, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.TASK, arg1)
	end)
	arg0:bind(var0.TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, arg1)
	end)
	arg0:bind(var0.ACTIVITY_OP, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
	arg0:bind(var0.OPEN_SCROLL, function(arg0, arg1)
		assert(false, "问卷系统已废弃")
	end)
	arg0:bind(var0.OPEN_ACTIVITY_SHOP, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0:bind(var0.OPEN_ACTIVITY_PANEL, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1
		})
	end)
	arg0:bind(var0.GO_SCENE, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, arg1[1], arg1[2])
	end)
	arg0:bind(var0.UPGRADE_FIELD, function(arg0, arg1)
		arg0:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = arg1
		})
	end)
	arg0:bind(var0.ON_OPEN_CLASSROOM, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.CLASS)
	end)
	arg0:bind(var0.ON_OPEN_COMMANDER, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
	end)
	arg0:bind(var0.ON_OPEN_COLLECTION, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = TrophyGalleryMediator,
			viewComponent = TrophyGalleryLayer
		}))
	end)
	arg0:bind(var0.ON_OPEN_GOLDRESFIELD, function(arg0)
		arg0.viewComponent:OpenGoldResField()
	end)
	arg0:bind(var0.ON_OPEN_OILRESFIELD, function(arg0)
		arg0.viewComponent:OpenOilResField()
	end)
	arg0:bind(var0.ON_OPEN_SUPPLYSHOP, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
	arg0:bind(var0.ON_OPEN_TACTICROOM, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
			shipToLesson = arg0.contextData.shipToLesson
		})

		arg0.contextData.shipToLesson = nil
	end)
	arg0:bind(var0.ON_OPEN_MINIGAMEHALL, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.GAME_HALL)
	end)

	local var0 = getProxy(NavalAcademyProxy)

	arg0.viewComponent:SetOilResField(var0:GetOilVO())
	arg0.viewComponent:SetGoldResField(var0:GetGoldVO())
	arg0.viewComponent:SetClassResField(var0:GetClassVO())

	local var1 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:SetPlayer(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.LOAD_LAYERS,
		GAME.REMOVE_LAYERS,
		GAME.HARVEST_RES_DONE,
		PlayerProxy.UPDATED,
		NavalAcademyProxy.RESOURCE_UPGRADE,
		NavalAcademyProxy.RESOURCE_UPGRADE_DONE,
		CollectionProxy.TROPHY_UPDATE,
		GAME.BEGIN_STAGE_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		GAME.HARVEST_CLASS_RES_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.LOAD_LAYERS then
		arg0.viewComponent:OnAddLayer()
	elseif var0 == GAME.REMOVE_LAYERS then
		arg0.viewComponent:OnRemoveLayer(var1)
	elseif var0 == GAME.HARVEST_RES_DONE then
		arg0.viewComponent:OnGetRes(var1.type, var1.outPut)
		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelMediator_ok_takeResource"))
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:UpdatePlayer(var1)
	elseif var0 == NavalAcademyProxy.RESOURCE_UPGRADE then
		arg0.viewComponent:UpdatePlayer(getProxy(PlayerProxy):getData())
		arg0.viewComponent:OnStartUpgradeResField(var1.resVO)
	elseif var0 == NavalAcademyProxy.RESOURCE_UPGRADE_DONE then
		local var2 = var1.field

		if isa(var2, GoldResourceField) then
			local var3 = pg.navalacademy_data_template[3].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_upgrade_complete", var3, var1.value))
		elseif isa(var2, OilResourceField) then
			local var4 = pg.navalacademy_data_template[4].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_upgrade_complete", var4, var1.value))
		elseif isa(var2, ClassResourceField) then
			local var5 = pg.navalacademy_data_template[1].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_class_upgrade_complete", var5, var1.value, var1.rate, var1.exp))
		end

		arg0.viewComponent:OnResFieldLevelUp(var2)
	elseif var0 == CollectionProxy.TROPHY_UPDATE then
		arg0.viewComponent:OnCollectionUpdate()
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0.viewComponent:RefreshChars()
	elseif var0 == GAME.HARVEST_CLASS_RES_DONE then
		arg0.viewComponent:OnGetRes(3, var1.value)
	end
end

return var0
