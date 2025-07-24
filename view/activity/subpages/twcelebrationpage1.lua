local var0_0 = class("TWCelebrationPage1", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.shop = arg0_1:findTF("go", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.shop, function()
		local var0_3 = configClinet.shopLinkActID and getProxy(ActivityProxy):getActivitiesById(configClinet.shopLinkActID) or underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_4)
			return not arg0_4:isEnd()
		end)

		if not var0_3 or var0_3:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_2:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = var0_3.id
		})
	end)
end

return var0_0
