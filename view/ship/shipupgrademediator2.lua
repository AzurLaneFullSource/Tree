local var0_0 = class("ShipUpgradeMediator2", import("..base.ContextMediator"))

var0_0.UPGRADE_SHIP = "ShipUpgradeMediator2:UPGRADE_SHIP"
var0_0.ON_SELECT_SHIP = "ShipUpgradeMediator2:ON_SELECT_SHIP"
var0_0.NEXTSHIP = "ShipUpgradeMediator2:NEXTSHIP"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = getProxy(BagProxy)

	arg0_1.viewComponent:setItems(var1_1:getData())

	local var2_1 = getProxy(BayProxy)
	local var3_1 = var2_1:getShipById(arg0_1.contextData.shipId)

	arg0_1.viewComponent:setShip(var3_1)
	arg0_1:bind(var0_0.UPGRADE_SHIP, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.UPGRADE_STAR, {
			shipId = arg0_1.contextData.shipId,
			shipIds = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_SHIP, function(arg0_3, arg1_3, arg2_3)
		local var0_3 = var2_1:getUpgradeShips(arg1_3)
		local var1_3 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_3, underscore.map(var0_3, function(arg0_4)
			return arg0_4.id
		end))

		table.insert(var1_3, arg1_3.id)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			destroyCheck = true,
			leftTopInfo = i18n("word_upgrade"),
			mode = DockyardScene.MODE_UPGRADE,
			selectedMax = arg2_3 or 1,
			selectedMin = arg2_3 or 1,
			shipVOs = var0_3,
			ignoredIds = var1_3,
			selectedIds = arg0_1.contextData.materialShipIds or {},
			onShip = function(arg0_5, arg1_5)
				if arg0_5:getFlag("inAdmiral") then
					return false, i18n("confirm_unlock_ship_main")
				elseif arg0_5:GetLockState() == Ship.LOCK_STATE_LOCK then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						yseBtnLetf = true,
						content = i18n("confirm_unlock_lv", "Lv." .. arg0_5.level, arg0_5:getName()),
						onYes = function()
							pg.m02:sendNotification(GAME.UPDATE_LOCK, {
								ship_id_list = {
									arg0_5.id
								},
								is_locked = Ship.LOCK_STATE_UNLOCK
							})
						end,
						yesText = i18n("msgbox_text_unlock")
					})

					return false, nil
				else
					return ShipStatus.canDestroyShip(arg0_5, arg1_5)
				end
			end,
			onSelected = function(arg0_7)
				arg0_1.contextData.materialShipIds = arg0_7
			end,
			hideTagFlags = ShipStatus.TAG_HIDE_DESTROY
		})
	end)
	arg0_1:bind(var0_0.NEXTSHIP, function(arg0_8, arg1_8)
		arg0_1:sendNotification(var0_0.NEXTSHIP, arg1_8)
	end)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		GAME.UPGRADE_STAR_DONE,
		BagProxy.ITEM_UPDATED,
		BayProxy.SHIP_REMOVED,
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == PlayerProxy.UPDATED then
		arg0_10.viewComponent:setPlayer(var1_10)
	elseif var0_10 == GAME.UPGRADE_STAR_DONE then
		arg0_10.contextData.materialShipIds = nil

		arg0_10.viewComponent:setShip(var1_10.newShip)
		arg0_10.viewComponent:updateStagesScrollView()
		arg0_10:addSubLayers(Context.New({
			viewComponent = ShipBreakResultLayer,
			mediator = ShipBreakResultMediator,
			data = {
				newShip = var1_10.newShip,
				oldShip = var1_10.oldShip
			}
		}))
	elseif var0_10 == BagProxy.ITEM_UPDATED then
		local var2_10 = getProxy(BagProxy)

		arg0_10.viewComponent:setItems(var2_10:getRawData())
	end
end

return var0_0
