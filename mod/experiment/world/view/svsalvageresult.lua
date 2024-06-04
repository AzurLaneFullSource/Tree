local var0 = class("SVSalvageResult", import("view.base.BaseSubView"))

var0.HideView = "SVSalvageResult.HideView"

function var0.getUIName(arg0)
	return "SVSalvageResult"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.rtPanel = arg0._tf:Find("window/display_panel")

	setText(arg0.rtPanel:Find("info/Text"), i18n("world_catsearch_help_1"))
	setText(arg0.rtPanel:Find("info/items_btn/Text"), i18n("world_catsearch_help_2"))
	onButton(arg0, arg0.rtPanel:Find("info/items_btn"), function()
		arg0:emit(BaseUI.ON_DROP_LIST, {
			item2Row = true,
			itemList = _.map(pg.gameset.world_catsearchdrop_show.description, function(arg0)
				return {
					type = arg0[1],
					id = arg0[2],
					count = arg0[3]
				}
			end),
			content = i18n("world_catsearch_help_6")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_CANCEL)

	arg0.btnBack = arg0._tf:Find("window/top/btnBack")

	onButton(arg0, arg0.btnBack, function()
		arg0:Hide()
	end, SFX_CANCEL)

	arg0.btnCanel = arg0._tf:Find("window/button_container/custom_button_2")

	onButton(arg0, arg0.btnCanel, function()
		arg0:Hide()
	end, SFX_CANCEL)

	arg0.btnHelp = arg0.rtPanel:Find("info/help")

	onButton(arg0, arg0.btnHelp, function()
		arg0:Hide()
		arg0:emit(WorldScene.SceneOp, "OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = 3,
				pageId = 10
			}
		}))
	end, SFX_PANEL)

	arg0.btnConfirm = arg0._tf:Find("window/button_container/custom_button_1")

	onButton(arg0, arg0.btnConfirm, function()
		arg0:Hide()
		arg0:emit(WorldScene.SceneOp, "OpReqCatSalvage", arg0.fleetId)
	end, SFX_CONFIRM)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0)
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.Setup(arg0, arg1)
	arg0.fleetId = arg1
end

return var0
