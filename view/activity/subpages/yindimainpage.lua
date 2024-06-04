local var0 = class("YinDiMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.btnList = arg0:findTF("btn_list", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, findTF(arg0.bg, "btn_list/shop"), function()
		arg0:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg0.activity.id
		})
	end)
end

return var0
