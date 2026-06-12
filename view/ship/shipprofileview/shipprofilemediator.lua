local var0_0 = class("ShipProfileMediator", import("...base.ContextMediator"))

var0_0.CLICK_ROTATE_BTN = "ShipProfileMediator:CLICK_ROTATE_BTN"
var0_0.OPEN_CRYPTOLALIA = "ShipProfileMediator:OPEN_CRYPTOLALIA"
var0_0.OPEN_EQUIP_CODE_SHARE = "ShipProfileMediator.OPEN_EQUIP_CODE_SHARE"
var0_0.OPEN_PAINTING_SHOW = "ShipProfileMediator.OPEN_PAINTING_SHOW"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(CollectionProxy)
	local var1_1 = getProxy(ShipSkinProxy)

	arg0_1.showTrans = arg0_1.contextData.showTrans
	arg0_1.groupId = arg0_1.contextData.groupId

	local var2_1 = var0_1:getShipGroup(arg0_1.groupId)

	arg0_1.viewComponent:setShipGroup(var2_1)
	arg0_1.viewComponent:setShowTrans(arg0_1.showTrans)
	arg0_1.viewComponent:setOwnedSkinList(var1_1:getSkinList())
	arg0_1:bind(var0_0.OPEN_CRYPTOLALIA, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRYPTOLALIA, {
			groupId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.CLICK_ROTATE_BTN, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:addSubLayers(Context.New({
			mediator = ShipRotateMediator,
			viewComponent = ShipRotateLayer,
			data = {
				shipGroup = arg1_3,
				showTrans = arg2_3,
				skin = arg3_3
			},
			onRemoved = function()
				setActive(arg0_1.viewComponent.blurPanel, true)
				setActive(arg0_1.viewComponent._tf, true)
			end
		}))
	end)
	arg0_1:bind(ShipProfileScene.SHOW_SKILL_INFO, function(arg0_5, arg1_5, arg2_5)
		arg0_1:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				skillOnShip = arg2_5,
				skillId = arg1_5
			}
		}))
	end)
	arg0_1:bind(ShipProfileScene.SHOW_EVALUATION, function(arg0_6, arg1_6, arg2_6)
		if arg2_6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("npc_evaluation_tip"))

			return
		end

		arg0_1:sendNotification(GAME.FETCH_EVALUATION, arg1_6)
	end)
	arg0_1:bind(ShipProfileScene.WEDDING_REVIEW, function(arg0_7, arg1_7)
		arg0_1.viewComponent:onWeddingReview(true)
		arg0_1:addSubLayers(Context.New({
			mediator = ProposeMediator,
			viewComponent = ProposeUI,
			data = {
				review = true,
				group = arg1_7.group,
				skinID = arg1_7.skinID,
				finishCallback = function()
					arg0_1.viewComponent:onWeddingReview(false)
				end
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_EQUIP_CODE_SHARE, function(arg0_9, arg1_9)
		arg0_1:addSubLayers(Context.New({
			mediator = EquipCodeShareMediator,
			viewComponent = EquipCodeShareLayer,
			data = {
				shipGroupId = arg1_9
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_PAINTING_SHOW, function(arg0_10, arg1_10, arg2_10)
		arg0_1:addSubLayers(Context.New({
			mediator = PaintingShowMediator,
			viewComponent = PaintingShowScene,
			data = {
				skinId = arg1_10,
				callback = arg2_10
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_11)
	return {
		GAME.FETCH_EVALUATION_DONE,
		CollectionProxy.GROUP_INFO_UPDATE,
		ShipSkinProxy.SHIP_SKINS_UPDATE
	}
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()

	if var0_12 == GAME.FETCH_EVALUATION_DONE then
		arg0_12:addSubLayers(Context.New({
			mediator = ShipEvaluationMediator,
			viewComponent = ShipEvaluationLayer,
			data = {
				groupId = var1_12,
				showTrans = arg0_12.showTrans
			}
		}))
	elseif var0_12 == CollectionProxy.GROUP_INFO_UPDATE then
		local var2_12 = var1_12

		if arg0_12.groupId == var2_12 then
			local var3_12 = getProxy(CollectionProxy):getShipGroup(var2_12)

			arg0_12.viewComponent:setShipGroup(var3_12)
			arg0_12.viewComponent:FlushHearts()
		end
	elseif var0_12 == ShipSkinProxy.SHIP_SKINS_UPDATE then
		local var4_12 = getProxy(ShipSkinProxy)

		arg0_12.viewComponent:setOwnedSkinList(var4_12:getSkinList())
	end
end

return var0_0
