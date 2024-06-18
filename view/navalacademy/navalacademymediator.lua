local var0_0 = class("NavalAcademyMediator", import("..base.ContextMediator"))

var0_0.ON_OPEN_CLASSROOM = "NavalAcademyMediator:ON_OPEN_CLASSROOM"
var0_0.ON_OPEN_COMMANDER = "NavalAcademyMediator:ON_OPEN_COMMANDER"
var0_0.ON_OPEN_COLLECTION = "NavalAcademyMediator:ON_OPEN_COLLECTION"
var0_0.ON_OPEN_OILRESFIELD = "NavalAcademyMediator:ON_OPEN_OILRESFIELD"
var0_0.ON_OPEN_GOLDRESFIELD = "NavalAcademyMediator:ON_OPEN_GOLDRESFIELD"
var0_0.ON_OPEN_SUPPLYSHOP = "NavalAcademyMediator:ON_OPEN_SUPPLYSHOP"
var0_0.ON_OPEN_TACTICROOM = "NavalAcademyMediator:ON_OPEN_TACTICROOM"
var0_0.ON_OPEN_MINIGAMEHALL = "NavalAcademyMediator:ON_OPEN_MINIGAMEHALL"
var0_0.UPGRADE_FIELD = "NavalAcademyMediator:UPGRADE_FIELD"
var0_0.GO_SCENE = "NavalAcademyMediator:GO_SCENE"
var0_0.OPEN_ACTIVITY_PANEL = "NavalAcademyMediator:OPEN_ACTIVITY_PANEL"
var0_0.OPEN_ACTIVITY_SHOP = "NavalAcademyMediator:OPEN_ACTIVITY_SHOP"
var0_0.OPEN_SCROLL = "NavalAcademyMediator:OPEN_SCROLL"
var0_0.ACTIVITY_OP = "NavalAcademyMediator:ACTIVITY_OP"
var0_0.TASK_GO = "NavalAcademyMediator:TASK_GO"
var0_0.GO_TASK_SCENE = "NavalAcademyMediator:GO_TASK_SCENE"
var0_0.ON_GET_CLASS_RES = "NavalAcademyMediator:ON_GET_CLASS_RES"
var0_0.ON_GET_RES = "NavalAcademyMediator:ON_GET_RES"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_GET_CLASS_RES, function(arg0_2)
		arg0_1:sendNotification(GAME.HARVEST_CLASS_RES)
	end)
	arg0_1:bind(var0_0.ON_GET_RES, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.HARVEST_RES, arg1_3)
	end)
	arg0_1:bind(var0_0.GO_TASK_SCENE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TASK, arg1_4)
	end)
	arg0_1:bind(var0_0.TASK_GO, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.TASK_GO, arg1_5)
	end)
	arg0_1:bind(var0_0.ACTIVITY_OP, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_6)
	end)
	arg0_1:bind(var0_0.OPEN_SCROLL, function(arg0_7, arg1_7)
		assert(false, "问卷系统已废弃")
	end)
	arg0_1:bind(var0_0.OPEN_ACTIVITY_SHOP, function(arg0_8)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_1:bind(var0_0.OPEN_ACTIVITY_PANEL, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1_9
		})
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_10[1], arg1_10[2])
	end)
	arg0_1:bind(var0_0.UPGRADE_FIELD, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = arg1_11
		})
	end)
	arg0_1:bind(var0_0.ON_OPEN_CLASSROOM, function(arg0_12)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CLASS)
	end)
	arg0_1:bind(var0_0.ON_OPEN_COMMANDER, function(arg0_13)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
	end)
	arg0_1:bind(var0_0.ON_OPEN_COLLECTION, function(arg0_14)
		arg0_1:addSubLayers(Context.New({
			mediator = TrophyGalleryMediator,
			viewComponent = TrophyGalleryLayer
		}))
	end)
	arg0_1:bind(var0_0.ON_OPEN_GOLDRESFIELD, function(arg0_15)
		arg0_1.viewComponent:OpenGoldResField()
	end)
	arg0_1:bind(var0_0.ON_OPEN_OILRESFIELD, function(arg0_16)
		arg0_1.viewComponent:OpenOilResField()
	end)
	arg0_1:bind(var0_0.ON_OPEN_SUPPLYSHOP, function(arg0_17)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
	arg0_1:bind(var0_0.ON_OPEN_TACTICROOM, function(arg0_18)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
			shipToLesson = arg0_1.contextData.shipToLesson
		})

		arg0_1.contextData.shipToLesson = nil
	end)
	arg0_1:bind(var0_0.ON_OPEN_MINIGAMEHALL, function(arg0_19)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.GAME_HALL)
	end)

	local var0_1 = getProxy(NavalAcademyProxy)

	arg0_1.viewComponent:SetOilResField(var0_1:GetOilVO())
	arg0_1.viewComponent:SetGoldResField(var0_1:GetGoldVO())
	arg0_1.viewComponent:SetClassResField(var0_1:GetClassVO())

	local var1_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:SetPlayer(var1_1)
end

function var0_0.listNotificationInterests(arg0_20)
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

function var0_0.handleNotification(arg0_21, arg1_21)
	local var0_21 = arg1_21:getName()
	local var1_21 = arg1_21:getBody()

	if var0_21 == GAME.LOAD_LAYERS then
		arg0_21.viewComponent:OnAddLayer()
	elseif var0_21 == GAME.REMOVE_LAYERS then
		arg0_21.viewComponent:OnRemoveLayer(var1_21)
	elseif var0_21 == GAME.HARVEST_RES_DONE then
		arg0_21.viewComponent:OnGetRes(var1_21.type, var1_21.outPut)
		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelMediator_ok_takeResource"))
	elseif var0_21 == PlayerProxy.UPDATED then
		arg0_21.viewComponent:UpdatePlayer(var1_21)
	elseif var0_21 == NavalAcademyProxy.RESOURCE_UPGRADE then
		arg0_21.viewComponent:UpdatePlayer(getProxy(PlayerProxy):getData())
		arg0_21.viewComponent:OnStartUpgradeResField(var1_21.resVO)
	elseif var0_21 == NavalAcademyProxy.RESOURCE_UPGRADE_DONE then
		local var2_21 = var1_21.field

		if isa(var2_21, GoldResourceField) then
			local var3_21 = pg.navalacademy_data_template[3].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_upgrade_complete", var3_21, var1_21.value))
		elseif isa(var2_21, OilResourceField) then
			local var4_21 = pg.navalacademy_data_template[4].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_upgrade_complete", var4_21, var1_21.value))
		elseif isa(var2_21, ClassResourceField) then
			local var5_21 = pg.navalacademy_data_template[1].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_class_upgrade_complete", var5_21, var1_21.value, var1_21.rate, var1_21.exp))
		end

		arg0_21.viewComponent:OnResFieldLevelUp(var2_21)
	elseif var0_21 == CollectionProxy.TROPHY_UPDATE then
		arg0_21.viewComponent:OnCollectionUpdate()
	elseif var0_21 == GAME.BEGIN_STAGE_DONE then
		arg0_21:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_21)
	elseif var0_21 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_21.viewComponent:RefreshChars()
	elseif var0_21 == GAME.HARVEST_CLASS_RES_DONE then
		arg0_21.viewComponent:OnGetRes(3, var1_21.value)
	end
end

return var0_0
