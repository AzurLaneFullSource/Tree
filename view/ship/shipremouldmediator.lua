local var0 = class("ShipRemouldMediator", import("..base.ContextMediator"))

var0.REMOULD_SHIP = "ShipRemouldMediator:REMOULD_SHIP"
var0.ON_SELECTE_SHIP = "ShipRemouldMediator:ON_SELECTE_SHIP"

function var0.register(arg0)
	local var0 = getProxy(BayProxy)
	local var1 = var0:getShipById(arg0.contextData.shipId)

	arg0.viewComponent:setShipVO(var1)

	local var2 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var2)

	arg0.bagProxy = getProxy(BagProxy)

	arg0.viewComponent:setItems(arg0.bagProxy:getData())
	arg0:bind(var0.REMOULD_SHIP, function(arg0, arg1, arg2, arg3)
		if arg0.contextData.materialShipIds and #arg0.contextData.materialShipIds > 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("remould_ship_count_more"))

			return
		end

		arg0:sendNotification(GAME.REMOULD_SHIP, {
			shipId = arg1,
			remouldId = arg2,
			materialIds = arg0.contextData.materialShipIds or {}
		})
	end)
	arg0:bind(var0.ON_SELECTE_SHIP, function(arg0, arg1)
		local var0 = var0:getUpgradeShips(arg1)
		local var1 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_3, underscore.map(var0, function(arg0)
			return arg0.id
		end))

		table.insert(var1, arg1.id)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			selectedMin = 1,
			destroyCheck = true,
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
			mode = DockyardScene.MODE_REMOULD,
			hideTagFlags = ShipStatus.TAG_HIDE_DESTROY
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.REMOULD_SHIP_DONE,
		PlayerProxy.UPDATED,
		BagProxy.ITEM_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.REMOULD_SHIP_DONE then
		arg0.viewComponent:setShipVO(var1.ship)
		arg0.viewComponent:updateLines()

		if #var1.awards ~= 0 then
			arg0:addSubLayers(Context.New({
				mediator = NewShipMediator,
				viewComponent = NewShipLayer,
				data = {
					fromRemould = true,
					ship = var1.ship
				}
			}))
			arg0.viewComponent:initShipModel()
		end

		arg0.contextData.materialShipIds = nil

		pg.TipsMgr.GetInstance():ShowTips(i18n("remould_ship_ok"))
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == BagProxy.ITEM_UPDATED then
		arg0.viewComponent:setItems(arg0.bagProxy:getData())
	end
end

return var0
