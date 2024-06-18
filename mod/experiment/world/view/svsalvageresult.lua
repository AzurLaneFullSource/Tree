local var0_0 = class("SVSalvageResult", import("view.base.BaseSubView"))

var0_0.HideView = "SVSalvageResult.HideView"

function var0_0.getUIName(arg0_1)
	return "SVSalvageResult"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.rtPanel = arg0_3._tf:Find("window/display_panel")

	setText(arg0_3.rtPanel:Find("info/Text"), i18n("world_catsearch_help_1"))
	setText(arg0_3.rtPanel:Find("info/items_btn/Text"), i18n("world_catsearch_help_2"))
	onButton(arg0_3, arg0_3.rtPanel:Find("info/items_btn"), function()
		arg0_3:emit(BaseUI.ON_DROP_LIST, {
			item2Row = true,
			itemList = _.map(pg.gameset.world_catsearchdrop_show.description, function(arg0_5)
				return {
					type = arg0_5[1],
					id = arg0_5[2],
					count = arg0_5[3]
				}
			end),
			content = i18n("world_catsearch_help_6")
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_CANCEL)

	arg0_3.btnBack = arg0_3._tf:Find("window/top/btnBack")

	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:Hide()
	end, SFX_CANCEL)

	arg0_3.btnCanel = arg0_3._tf:Find("window/button_container/custom_button_2")

	onButton(arg0_3, arg0_3.btnCanel, function()
		arg0_3:Hide()
	end, SFX_CANCEL)

	arg0_3.btnHelp = arg0_3.rtPanel:Find("info/help")

	onButton(arg0_3, arg0_3.btnHelp, function()
		arg0_3:Hide()
		arg0_3:emit(WorldScene.SceneOp, "OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = 3,
				pageId = 10
			}
		}))
	end, SFX_PANEL)

	arg0_3.btnConfirm = arg0_3._tf:Find("window/button_container/custom_button_1")

	onButton(arg0_3, arg0_3.btnConfirm, function()
		arg0_3:Hide()
		arg0_3:emit(WorldScene.SceneOp, "OpReqCatSalvage", arg0_3.fleetId)
	end, SFX_CONFIRM)
end

function var0_0.OnDestroy(arg0_11)
	return
end

function var0_0.Show(arg0_12)
	setActive(arg0_12._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
end

function var0_0.Hide(arg0_13)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf, arg0_13._parentTf)
	setActive(arg0_13._tf, false)
end

function var0_0.Setup(arg0_14, arg1_14)
	arg0_14.fleetId = arg1_14
end

return var0_0
