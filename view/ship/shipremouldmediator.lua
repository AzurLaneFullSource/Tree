local var0_0 = class("ShipRemouldMediator", import("..base.ContextMediator"))

var0_0.REMOULD_SHIP = "ShipRemouldMediator:REMOULD_SHIP"
var0_0.ON_SELECTE_SHIP = "ShipRemouldMediator:ON_SELECTE_SHIP"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(BayProxy)
	local var1_1 = var0_1:getShipById(arg0_1.contextData.shipId)

	arg0_1.viewComponent:setShipVO(var1_1)

	local var2_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var2_1)

	arg0_1.bagProxy = getProxy(BagProxy)

	arg0_1.viewComponent:setItems(arg0_1.bagProxy:getData())
	arg0_1:bind(var0_0.REMOULD_SHIP, function(arg0_2, arg1_2, arg2_2, arg3_2)
		if arg0_1.contextData.materialShipIds and #arg0_1.contextData.materialShipIds > 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("remould_ship_count_more"))

			return
		end

		arg0_1:sendNotification(GAME.REMOULD_SHIP, {
			shipId = arg1_2,
			remouldId = arg2_2,
			materialIds = arg0_1.contextData.materialShipIds or {}
		})
	end)
	arg0_1:bind(var0_0.ON_SELECTE_SHIP, function(arg0_3, arg1_3)
		local var0_3 = var0_1:getUpgradeShips(arg1_3)
		local var1_3 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_3, underscore.map(var0_3, function(arg0_4)
			return arg0_4.id
		end))

		table.insert(var1_3, arg1_3.id)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			selectedMin = 1,
			destroyCheck = true,
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
			mode = DockyardScene.MODE_REMOULD,
			hideTagFlags = ShipStatus.TAG_HIDE_DESTROY
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.REMOULD_SHIP_DONE,
		PlayerProxy.UPDATED,
		BagProxy.ITEM_UPDATED
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.REMOULD_SHIP_DONE then
		arg0_9.viewComponent:setShipVO(var1_9.ship)
		arg0_9.viewComponent:updateLines()

		if #var1_9.awards ~= 0 then
			arg0_9:addSubLayers(Context.New({
				mediator = NewShipMediator,
				viewComponent = NewShipLayer,
				data = {
					fromRemould = true,
					ship = var1_9.ship
				}
			}))
			arg0_9.viewComponent:initShipModel()
		end

		arg0_9.contextData.materialShipIds = nil

		pg.TipsMgr.GetInstance():ShowTips(i18n("remould_ship_ok"))
	elseif var0_9 == PlayerProxy.UPDATED then
		arg0_9.viewComponent:setPlayer(var1_9)
	elseif var0_9 == BagProxy.ITEM_UPDATED then
		arg0_9.viewComponent:setItems(arg0_9.bagProxy:getData())
	end
end

return var0_0
