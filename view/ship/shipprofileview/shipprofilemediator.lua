local var0_0 = class("ShipProfileMediator", import("...base.ContextMediator"))

var0_0.CLICK_ROTATE_BTN = "ShipProfileMediator:CLICK_ROTATE_BTN"
var0_0.OPEN_CRYPTOLALIA = "ShipProfileMediator:OPEN_CRYPTOLALIA"
var0_0.OPEN_EQUIP_CODE_SHARE = "ShipProfileMediator.OPEN_EQUIP_CODE_SHARE"

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
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		GAME.FETCH_EVALUATION_DONE,
		CollectionProxy.GROUP_INFO_UPDATE,
		ShipSkinProxy.SHIP_SKINS_UPDATE
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == GAME.FETCH_EVALUATION_DONE then
		arg0_11:addSubLayers(Context.New({
			mediator = ShipEvaluationMediator,
			viewComponent = ShipEvaluationLayer,
			data = {
				groupId = var1_11,
				showTrans = arg0_11.showTrans
			}
		}))
	elseif var0_11 == CollectionProxy.GROUP_INFO_UPDATE then
		local var2_11 = var1_11

		if arg0_11.groupId == var2_11 then
			local var3_11 = getProxy(CollectionProxy):getShipGroup(var2_11)

			arg0_11.viewComponent:setShipGroup(var3_11)
			arg0_11.viewComponent:FlushHearts()
		end
	elseif var0_11 == ShipSkinProxy.SHIP_SKINS_UPDATE then
		local var4_11 = getProxy(ShipSkinProxy)

		arg0_11.viewComponent:setOwnedSkinList(var4_11:getSkinList())
	end
end

return var0_0
