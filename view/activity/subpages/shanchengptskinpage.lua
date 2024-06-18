local var0_0 = class("ShanChengPtSkinPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.shop = arg0_1:findTF("go", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	local var0_2 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_3)
		return arg0_3:getConfig("config_client").pt_id == arg0_2.activity:getConfig("config_client").pt_id
	end)

	onButton(arg0_2, arg0_2.shop, function()
		arg0_2:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = var0_2 and var0_2.id
		})
	end)
end

return var0_0
