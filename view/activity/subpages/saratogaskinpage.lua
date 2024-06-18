local var0_0 = class("SaratogaSkinPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.shopBtn = arg0_1:findTF("btn_list/shop", arg0_1.bg)
	arg0_1.fightBtn = arg0_1:findTF("btn_list/fight", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.shopBtn, function()
		arg0_2:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg0_2.activity.id
		})
	end)
	onButton(arg0_2, arg0_2.fightBtn, function()
		arg0_2:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end)
end

return var0_0
