local var0 = class("MetaCharacterMediator", import("...base.ContextMediator"))

var0.OPEN_PT_PREVIEW_LAYER = "MetaCharacterMediator:OPEN_PT_PREVIEW_LAYER"
var0.OPEN_PT_GET_WAY_LAYER = "MetaCharacterMediator:OPEN_PT_GET_WAY_LAYER"
var0.OPEN_INDEX_LAYER = "MetaCharacterMediator:OPEN_INDEX_LAYER"
var0.ON_REPAIR = "MetaCharacterMediator:ON_REPAIR"
var0.ON_ENERGY = "MetaCharacterMediator:ON_ENERGY"
var0.ON_TACTICS = "MetaCharacterMediator:ON_TACTICS"
var0.ON_SYN = "MetaCharacterMediator:ON_SYN"
var0.ON_UNLOCK = "MetaCharacterMediator:ON_UNLOCK"

function var0.register(arg0)
	arg0:bind(var0.OPEN_PT_PREVIEW_LAYER, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = MetaPTAwardPreviewLayer,
			mediator = MetaPTAwardPreviewMediator,
			data = {
				metaProgressVO = arg1
			}
		}))
	end)
	arg0:bind(var0.OPEN_PT_GET_WAY_LAYER, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = MetaPTGetPreviewLayer,
			mediator = MetaPTGetPreviewMediator,
			data = {}
		}))
	end)
	arg0:bind(var0.OPEN_INDEX_LAYER, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(var0.ON_REPAIR, function(arg0, arg1, arg2)
		arg0:enbalePage(Context.New({
			viewComponent = MetaCharacterRepairLayer,
			mediator = MetaCharacterRepairMediator,
			data = {
				shipID = arg1,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_META
			},
			onRemoved = function()
				arg0.viewComponent:enterMenuPage(false)

				arg0.viewComponent.curPageIndex = nil

				arg0.viewComponent:resetToggleList()
				arg0.viewComponent:refreshBannerTF()
				arg0.viewComponent:updateRedPoints()
			end
		}), arg2)
	end)
	arg0:bind(var0.ON_ENERGY, function(arg0, arg1, arg2)
		local var0 = arg0.viewComponent.isMainOpenLayerTag and true or nil

		arg0.viewComponent.isMainOpenLayerTag = nil

		arg0:enbalePage(Context.New({
			viewComponent = MetaCharacterEnergyLayer,
			mediator = MetaCharacterEnergyMediator,
			data = {
				shipID = arg1,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_META,
				isMainOpen = var0
			},
			onRemoved = function()
				arg0.viewComponent:enterMenuPage(false)

				arg0.viewComponent.curPageIndex = nil

				arg0.viewComponent:resetToggleList()
				arg0.viewComponent:refreshBannerTF()
				arg0.viewComponent:updateRedPoints()
			end
		}), arg2)
	end)
	arg0:bind(var0.ON_TACTICS, function(arg0, arg1, arg2)
		local var0 = arg0.viewComponent.isMainOpenLayerTag and true or nil

		arg0.viewComponent.isMainOpenLayerTag = nil

		arg0:enbalePage(Context.New({
			viewComponent = MetaCharacterTacticsLayer,
			mediator = MetaCharacterTacticsMediator,
			data = {
				shipID = arg1,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_META,
				isMainOpen = var0
			},
			onRemoved = function()
				if arg0.contextData.isFromNavalMeta == true then
					arg0.viewComponent:closeView()

					arg0.contextData.isFromNavalMeta = nil
				else
					arg0.viewComponent:enterMenuPage(false)

					arg0.viewComponent.curPageIndex = nil

					arg0.viewComponent:resetToggleList()
					arg0.viewComponent:updateRedPoints()
				end
			end
		}), arg2)
	end)
	arg0:bind(var0.ON_SYN, function(arg0, arg1, arg2)
		local var0 = arg0.viewComponent.isMainOpenLayerTag and true or nil

		arg0.viewComponent.isMainOpenLayerTag = nil

		arg0:enbalePage(Context.New({
			viewComponent = MetaCharacterSynLayer,
			mediator = MetaCharacterSynMediator,
			data = {
				shipID = arg1,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_META,
				isMainOpen = var0
			},
			onRemoved = function()
				arg0.viewComponent:enterMenuPage(false)

				arg0.viewComponent.curPageIndex = nil

				arg0.viewComponent:resetToggleList()
				arg0.viewComponent:updateRedPoints()
			end
		}), arg2)
	end)
end

function var0.enbalePage(arg0, arg1, arg2)
	if arg2 then
		arg0:addSubLayers(arg1)
	else
		local var0 = getProxy(ContextProxy):getContextByMediator(arg1.mediator)

		if var0 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0
			})
		end
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ACT_NEW_PT_DONE,
		BayProxy.SHIP_ADDED,
		GAME.GET_META_PT_AWARD_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == BayProxy.SHIP_ADDED then
		local var2 = arg0.viewComponent:getCurMetaProgressVO()

		var2:updateDataAfterAddShip()

		if var2:isPassType() or var2:isBuildType() then
			arg0.viewComponent:refreshBannerTF()
			arg0.viewComponent:updateMain()
		end
	elseif var0 == GAME.GET_META_PT_AWARD_DONE then
		local function var3()
			if var1.callback then
				var1.callback()
			end

			arg0.viewComponent:refreshBannerTF()
			arg0.viewComponent:updateMain(true)
		end

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var3)
	end
end

return var0
