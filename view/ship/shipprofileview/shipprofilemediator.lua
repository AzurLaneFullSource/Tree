local var0 = class("ShipProfileMediator", import("...base.ContextMediator"))

var0.CLICK_ROTATE_BTN = "ShipProfileMediator:CLICK_ROTATE_BTN"
var0.OPEN_CRYPTOLALIA = "ShipProfileMediator:OPEN_CRYPTOLALIA"
var0.OPEN_EQUIP_CODE_SHARE = "ShipProfileMediator.OPEN_EQUIP_CODE_SHARE"

function var0.register(arg0)
	local var0 = getProxy(CollectionProxy)
	local var1 = getProxy(ShipSkinProxy)

	arg0.showTrans = arg0.contextData.showTrans
	arg0.groupId = arg0.contextData.groupId

	local var2 = var0:getShipGroup(arg0.groupId)

	arg0.viewComponent:setShipGroup(var2)
	arg0.viewComponent:setShowTrans(arg0.showTrans)
	arg0.viewComponent:setOwnedSkinList(var1:getSkinList())
	arg0:bind(var0.OPEN_CRYPTOLALIA, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.CRYPTOLALIA, {
			groupId = arg1
		})
	end)
	arg0:bind(var0.CLICK_ROTATE_BTN, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = ShipRotateMediator,
			viewComponent = ShipRotateLayer,
			data = {
				shipGroup = arg1,
				showTrans = arg2,
				skin = arg3
			},
			onRemoved = function()
				setActive(arg0.viewComponent._tf, true)
			end
		}))
	end)
	arg0:bind(ShipProfileScene.SHOW_SKILL_INFO, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				skillOnShip = arg2,
				skillId = arg1
			}
		}))
	end)
	arg0:bind(ShipProfileScene.SHOW_EVALUATION, function(arg0, arg1, arg2)
		if arg2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("npc_evaluation_tip"))

			return
		end

		arg0:sendNotification(GAME.FETCH_EVALUATION, arg1)
	end)
	arg0:bind(ShipProfileScene.WEDDING_REVIEW, function(arg0, arg1)
		arg0.viewComponent:onWeddingReview(true)
		arg0:addSubLayers(Context.New({
			mediator = ProposeMediator,
			viewComponent = ProposeUI,
			data = {
				review = true,
				group = arg1.group,
				skinID = arg1.skinID,
				finishCallback = function()
					arg0.viewComponent:onWeddingReview(false)
				end
			}
		}))
	end)
	arg0:bind(var0.OPEN_EQUIP_CODE_SHARE, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = EquipCodeShareMediator,
			viewComponent = EquipCodeShareLayer,
			data = {
				shipGroupId = arg1
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.FETCH_EVALUATION_DONE,
		CollectionProxy.GROUP_INFO_UPDATE,
		ShipSkinProxy.SHIP_SKINS_UPDATE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.FETCH_EVALUATION_DONE then
		arg0:addSubLayers(Context.New({
			mediator = ShipEvaluationMediator,
			viewComponent = ShipEvaluationLayer,
			data = {
				groupId = var1,
				showTrans = arg0.showTrans
			}
		}))
	elseif var0 == CollectionProxy.GROUP_INFO_UPDATE then
		local var2 = var1

		if arg0.groupId == var2 then
			local var3 = getProxy(CollectionProxy):getShipGroup(var2)

			arg0.viewComponent:setShipGroup(var3)
			arg0.viewComponent:FlushHearts()
		end
	elseif var0 == ShipSkinProxy.SHIP_SKINS_UPDATE then
		local var4 = getProxy(ShipSkinProxy)

		arg0.viewComponent:setOwnedSkinList(var4:getSkinList())
	end
end

return var0
