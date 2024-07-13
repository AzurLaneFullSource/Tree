local var0_0 = class("MetaCharacterMediator", import("...base.ContextMediator"))

var0_0.OPEN_PT_PREVIEW_LAYER = "MetaCharacterMediator:OPEN_PT_PREVIEW_LAYER"
var0_0.OPEN_PT_GET_WAY_LAYER = "MetaCharacterMediator:OPEN_PT_GET_WAY_LAYER"
var0_0.OPEN_INDEX_LAYER = "MetaCharacterMediator:OPEN_INDEX_LAYER"
var0_0.ON_REPAIR = "MetaCharacterMediator:ON_REPAIR"
var0_0.ON_ENERGY = "MetaCharacterMediator:ON_ENERGY"
var0_0.ON_TACTICS = "MetaCharacterMediator:ON_TACTICS"
var0_0.ON_SYN = "MetaCharacterMediator:ON_SYN"
var0_0.ON_UNLOCK = "MetaCharacterMediator:ON_UNLOCK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_PT_PREVIEW_LAYER, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = MetaPTAwardPreviewLayer,
			mediator = MetaPTAwardPreviewMediator,
			data = {
				metaProgressVO = arg1_2
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_PT_GET_WAY_LAYER, function(arg0_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = MetaPTGetPreviewLayer,
			mediator = MetaPTGetPreviewMediator,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_INDEX_LAYER, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_4
		}))
	end)
	arg0_1:bind(var0_0.ON_REPAIR, function(arg0_5, arg1_5, arg2_5)
		arg0_1:enbalePage(Context.New({
			viewComponent = MetaCharacterRepairLayer,
			mediator = MetaCharacterRepairMediator,
			data = {
				shipID = arg1_5,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_META
			},
			onRemoved = function()
				arg0_1.viewComponent:enterMenuPage(false)

				arg0_1.viewComponent.curPageIndex = nil

				arg0_1.viewComponent:resetToggleList()
				arg0_1.viewComponent:refreshBannerTF()
				arg0_1.viewComponent:updateRedPoints()
			end
		}), arg2_5)
	end)
	arg0_1:bind(var0_0.ON_ENERGY, function(arg0_7, arg1_7, arg2_7)
		local var0_7 = arg0_1.viewComponent.isMainOpenLayerTag and true or nil

		arg0_1.viewComponent.isMainOpenLayerTag = nil

		arg0_1:enbalePage(Context.New({
			viewComponent = MetaCharacterEnergyLayer,
			mediator = MetaCharacterEnergyMediator,
			data = {
				shipID = arg1_7,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_META,
				isMainOpen = var0_7
			},
			onRemoved = function()
				arg0_1.viewComponent:enterMenuPage(false)

				arg0_1.viewComponent.curPageIndex = nil

				arg0_1.viewComponent:resetToggleList()
				arg0_1.viewComponent:refreshBannerTF()
				arg0_1.viewComponent:updateRedPoints()
			end
		}), arg2_7)
	end)
	arg0_1:bind(var0_0.ON_TACTICS, function(arg0_9, arg1_9, arg2_9)
		local var0_9 = arg0_1.viewComponent.isMainOpenLayerTag and true or nil

		arg0_1.viewComponent.isMainOpenLayerTag = nil

		arg0_1:enbalePage(Context.New({
			viewComponent = MetaCharacterTacticsLayer,
			mediator = MetaCharacterTacticsMediator,
			data = {
				shipID = arg1_9,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_META,
				isMainOpen = var0_9
			},
			onRemoved = function()
				if arg0_1.contextData.isFromNavalMeta == true then
					arg0_1.viewComponent:closeView()

					arg0_1.contextData.isFromNavalMeta = nil
				else
					arg0_1.viewComponent:enterMenuPage(false)

					arg0_1.viewComponent.curPageIndex = nil

					arg0_1.viewComponent:resetToggleList()
					arg0_1.viewComponent:updateRedPoints()
				end
			end
		}), arg2_9)
	end)
	arg0_1:bind(var0_0.ON_SYN, function(arg0_11, arg1_11, arg2_11)
		local var0_11 = arg0_1.viewComponent.isMainOpenLayerTag and true or nil

		arg0_1.viewComponent.isMainOpenLayerTag = nil

		arg0_1:enbalePage(Context.New({
			viewComponent = MetaCharacterSynLayer,
			mediator = MetaCharacterSynMediator,
			data = {
				shipID = arg1_11,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_META,
				isMainOpen = var0_11
			},
			onRemoved = function()
				arg0_1.viewComponent:enterMenuPage(false)

				arg0_1.viewComponent.curPageIndex = nil

				arg0_1.viewComponent:resetToggleList()
				arg0_1.viewComponent:updateRedPoints()
			end
		}), arg2_11)
	end)
end

function var0_0.enbalePage(arg0_13, arg1_13, arg2_13)
	if arg2_13 then
		arg0_13:addSubLayers(arg1_13)
	else
		local var0_13 = getProxy(ContextProxy):getContextByMediator(arg1_13.mediator)

		if var0_13 then
			arg0_13:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_13
			})
		end
	end
end

function var0_0.listNotificationInterests(arg0_14)
	return {
		GAME.ACT_NEW_PT_DONE,
		BayProxy.SHIP_ADDED,
		GAME.GET_META_PT_AWARD_DONE
	}
end

function var0_0.handleNotification(arg0_15, arg1_15)
	local var0_15 = arg1_15:getName()
	local var1_15 = arg1_15:getBody()

	if var0_15 == BayProxy.SHIP_ADDED then
		local var2_15 = arg0_15.viewComponent:getCurMetaProgressVO()

		var2_15:updateDataAfterAddShip()

		if var2_15:isPassType() or var2_15:isBuildType() then
			arg0_15.viewComponent:refreshBannerTF()
			arg0_15.viewComponent:updateMain()
		end
	elseif var0_15 == GAME.GET_META_PT_AWARD_DONE then
		local function var3_15()
			if var1_15.callback then
				var1_15.callback()
			end

			arg0_15.viewComponent:refreshBannerTF()
			arg0_15.viewComponent:updateMain(true)
		end

		arg0_15.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_15.awards, var3_15)
	end
end

return var0_0
