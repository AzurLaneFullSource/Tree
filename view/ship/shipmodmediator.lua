local var0_0 = class("ShipModMediator", import("..base.ContextMediator"))

var0_0.ON_SELECT_MATERIAL_SHIPS = "ShipModMediator:ON_SELECT_MATERIAL_SHIPS"
var0_0.ON_AUTO_SELECT_SHIP = "ShipModMediator:ON_AUTO_SELECT_SHIP"
var0_0.MOD_SHIP = "ShipModMediator:MOD_SHIP"
var0_0.ON_SKILL = "ShipModMediator:ON_SKILL"
var0_0.LOADEND = "ShipModMediator:LOADEND"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(BayProxy)
	local var1_1 = var0_1:getRawData()

	arg0_1.viewComponent:setShipVOs(var1_1)

	local var2_1 = var0_1:getShipById(arg0_1.contextData.shipId)

	arg0_1.viewComponent:setShip(var2_1)
	arg0_1:bind(var0_0.ON_SELECT_MATERIAL_SHIPS, function(arg0_2)
		local var0_2 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_1)

		table.insert(var0_2, 1, arg0_1.contextData.shipId)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			blockLock = true,
			destroyCheck = true,
			selectedMin = 0,
			selectedMax = 12,
			leftTopInfo = i18n("word_equipment_intensify"),
			mode = DockyardScene.MODE_MOD,
			onShip = ShipStatus.canDestroyShip,
			ignoredIds = var0_2,
			selectedIds = arg0_1.contextData.materialShipIds,
			onSelected = function(arg0_3)
				arg0_1.contextData.materialShipIds = arg0_3
			end,
			sortData = {
				Asc = true,
				sort = 1
			},
			hideTagFlags = ShipStatus.TAG_HIDE_DESTROY
		})
	end)
	arg0_1:bind(var0_0.ON_AUTO_SELECT_SHIP, function(arg0_4)
		local var0_4 = var0_1:getModRecommendShip(arg0_1.viewComponent.shipVO, arg0_1.contextData.materialShipIds or {})

		if #var0_4 > 0 then
			arg0_1.contextData.materialShipIds = var0_4

			arg0_1.viewComponent:initSelectedShips()
			arg0_1.viewComponent:initAttrs()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_selected_ship"))
		end
	end)
	arg0_1:bind(var0_0.MOD_SHIP, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.MOD_SHIP, {
			shipId = arg1_5,
			shipIds = arg0_1.contextData.materialShipIds
		})
	end)
	arg0_1:bind(var0_0.ON_SKILL, function(arg0_6, arg1_6, arg2_6)
		arg0_1:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				skillOnShip = arg2_6,
				skillId = arg1_6
			}
		}))
	end)
	arg0_1:bind(var0_0.LOADEND, function(arg0_7, arg1_7)
		arg0_1:sendNotification(var0_0.LOADEND, arg1_7)
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.MOD_SHIP_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.MOD_SHIP_DONE then
		arg0_9.contextData.materialShipIds = nil

		arg0_9.viewComponent:setShip(var1_9.newShip)
		arg0_9.viewComponent:modAttrAnim(var1_9.newShip, var1_9.oldShip)
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipModLayer_modSuccess"))

		if table.getCount(var1_9.equipments) > 0 then
			local var2_9 = {}

			for iter0_9, iter1_9 in pairs(var1_9.equipments) do
				table.insert(var2_9, iter1_9)
			end

			arg0_9:addSubLayers(Context.New({
				viewComponent = ResolveEquipmentLayer,
				mediator = ResolveEquipmentMediator,
				data = {
					Equipments = var2_9
				}
			}))
		end
	end
end

return var0_0
