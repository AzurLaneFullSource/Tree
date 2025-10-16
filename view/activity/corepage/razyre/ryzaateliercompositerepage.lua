local var0_0 = class("RyzaAtelierCompositeRePage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	onButton(arg0_1, arg0_1._tf:Find("adapt/helpBtn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_composite_help_tip")
		})
	end)
	onButton(arg0_1, arg0_1._tf:Find("adapt/storeBtn"), function()
		local var0_3 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(CoreActivityMainMediator)

		addSubLayer(Context.New({
			mediator = AtelierStoreBaseMediator,
			viewComponent = AtelierStoreBaseScene,
			data = {
				activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)
			}
		}), var0_3)
	end)
	onButton(arg0_1, arg0_1._tf:Find("adapt/atelierBtn"), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ATELIER_COMPOSITE, {
			activityID = 50043,
			versionIndex = 1
		})
	end)
end

return var0_0
