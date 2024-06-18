local var0_0 = class("YinDiMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.btnList = arg0_1:findTF("btn_list", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, findTF(arg0_2.bg, "btn_list/shop"), function()
		arg0_2:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg0_2.activity.id
		})
	end)
end

return var0_0
