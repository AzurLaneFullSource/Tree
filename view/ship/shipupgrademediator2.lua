local var0 = class("ShipUpgradeMediator2", import("..base.ContextMediator"))

var0.UPGRADE_SHIP = "ShipUpgradeMediator2:UPGRADE_SHIP"
var0.ON_SELECT_SHIP = "ShipUpgradeMediator2:ON_SELECT_SHIP"
var0.NEXTSHIP = "ShipUpgradeMediator2:NEXTSHIP"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var0)

	local var1 = getProxy(BagProxy)

	arg0.viewComponent:setItems(var1:getData())

	local var2 = getProxy(BayProxy)
	local var3 = var2:getShipById(arg0.contextData.shipId)

	arg0.viewComponent:setShip(var3)
	arg0:bind(var0.UPGRADE_SHIP, function(arg0, arg1)
		arg0:sendNotification(GAME.UPGRADE_STAR, {
			shipId = arg0.contextData.shipId,
			shipIds = arg1
		})
	end)
	arg0:bind(var0.ON_SELECT_SHIP, function(arg0, arg1, arg2)
		local var0 = var2:getUpgradeShips(arg1)
		local var1 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_3, underscore.map(var0, function(arg0)
			return arg0.id
		end))

		table.insert(var1, arg1.id)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			destroyCheck = true,
			leftTopInfo = i18n("word_upgrade"),
			mode = DockyardScene.MODE_UPGRADE,
			selectedMax = arg2 or 1,
			selectedMin = arg2 or 1,
			shipVOs = var0,
			ignoredIds = var1,
			selectedIds = arg0.contextData.materialShipIds or {},
			onShip = function(arg0, arg1)
				if arg0:getFlag("inAdmiral") then
					return false, i18n("confirm_unlock_ship_main")
				elseif arg0:GetLockState() == Ship.LOCK_STATE_LOCK then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						yseBtnLetf = true,
						content = i18n("confirm_unlock_lv", "Lv." .. arg0.level, arg0:getName()),
						onYes = function()
							pg.m02:sendNotification(GAME.UPDATE_LOCK, {
								ship_id_list = {
									arg0.id
								},
								is_locked = Ship.LOCK_STATE_UNLOCK
							})
						end,
						yesText = i18n("msgbox_text_unlock")
					})

					return false, nil
				else
					return ShipStatus.canDestroyShip(arg0, arg1)
				end
			end,
			onSelected = function(arg0)
				arg0.contextData.materialShipIds = arg0
			end,
			hideTagFlags = ShipStatus.TAG_HIDE_DESTROY
		})
	end)
	arg0:bind(var0.NEXTSHIP, function(arg0, arg1)
		arg0:sendNotification(var0.NEXTSHIP, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.UPGRADE_STAR_DONE,
		BagProxy.ITEM_UPDATED,
		BayProxy.SHIP_REMOVED,
		PlayerProxy.UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.UPGRADE_STAR_DONE then
		arg0.contextData.materialShipIds = nil

		arg0.viewComponent:setShip(var1.newShip)
		arg0.viewComponent:updateStagesScrollView()
		arg0:addSubLayers(Context.New({
			viewComponent = ShipBreakResultLayer,
			mediator = ShipBreakResultMediator,
			data = {
				newShip = var1.newShip,
				oldShip = var1.oldShip
			}
		}))
	elseif var0 == BagProxy.ITEM_UPDATED then
		local var2 = getProxy(BagProxy)

		arg0.viewComponent:setItems(var2:getRawData())
	end
end

return var0
