local var0 = class("ShanChengPtSkinPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.shop = arg0:findTF("go", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	local var0 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0)
		return arg0:getConfig("config_client").pt_id == arg0.activity:getConfig("config_client").pt_id
	end)

	onButton(arg0, arg0.shop, function()
		arg0:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = var0 and var0.id
		})
	end)
end

return var0
