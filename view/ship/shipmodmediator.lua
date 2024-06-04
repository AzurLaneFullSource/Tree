local var0 = class("ShipModMediator", import("..base.ContextMediator"))

var0.ON_SELECT_MATERIAL_SHIPS = "ShipModMediator:ON_SELECT_MATERIAL_SHIPS"
var0.ON_AUTO_SELECT_SHIP = "ShipModMediator:ON_AUTO_SELECT_SHIP"
var0.MOD_SHIP = "ShipModMediator:MOD_SHIP"
var0.ON_SKILL = "ShipModMediator:ON_SKILL"
var0.LOADEND = "ShipModMediator:LOADEND"

function var0.register(arg0)
	local var0 = getProxy(BayProxy)
	local var1 = var0:getRawData()

	arg0.viewComponent:setShipVOs(var1)

	local var2 = var0:getShipById(arg0.contextData.shipId)

	arg0.viewComponent:setShip(var2)
	arg0:bind(var0.ON_SELECT_MATERIAL_SHIPS, function(arg0)
		local var0 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_1)

		table.insert(var0, 1, arg0.contextData.shipId)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			blockLock = true,
			destroyCheck = true,
			selectedMin = 0,
			selectedMax = 12,
			leftTopInfo = i18n("word_equipment_intensify"),
			mode = DockyardScene.MODE_MOD,
			onShip = ShipStatus.canDestroyShip,
			ignoredIds = var0,
			selectedIds = arg0.contextData.materialShipIds,
			onSelected = function(arg0)
				arg0.contextData.materialShipIds = arg0
			end,
			sortData = {
				Asc = true,
				sort = 1
			},
			hideTagFlags = ShipStatus.TAG_HIDE_DESTROY
		})
	end)
	arg0:bind(var0.ON_AUTO_SELECT_SHIP, function(arg0)
		local var0 = var0:getModRecommendShip(arg0.viewComponent.shipVO, arg0.contextData.materialShipIds or {})

		if #var0 > 0 then
			arg0.contextData.materialShipIds = var0

			arg0.viewComponent:initSelectedShips()
			arg0.viewComponent:initAttrs()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_selected_ship"))
		end
	end)
	arg0:bind(var0.MOD_SHIP, function(arg0, arg1)
		arg0:sendNotification(GAME.MOD_SHIP, {
			shipId = arg1,
			shipIds = arg0.contextData.materialShipIds
		})
	end)
	arg0:bind(var0.ON_SKILL, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				skillOnShip = arg2,
				skillId = arg1
			}
		}))
	end)
	arg0:bind(var0.LOADEND, function(arg0, arg1)
		arg0:sendNotification(var0.LOADEND, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.MOD_SHIP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.MOD_SHIP_DONE then
		arg0.contextData.materialShipIds = nil

		arg0.viewComponent:setShip(var1.newShip)
		arg0.viewComponent:modAttrAnim(var1.newShip, var1.oldShip)
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipModLayer_modSuccess"))

		if table.getCount(var1.equipments) > 0 then
			local var2 = {}

			for iter0, iter1 in pairs(var1.equipments) do
				table.insert(var2, iter1)
			end

			arg0:addSubLayers(Context.New({
				viewComponent = ResolveEquipmentLayer,
				mediator = ResolveEquipmentMediator,
				data = {
					Equipments = var2
				}
			}))
		end
	end
end

return var0
