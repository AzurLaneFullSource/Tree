local var0 = class("SaratogaSkinPage", import(".TemplatePage.PreviewTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.shopBtn = arg0:findTF("btn_list/shop", arg0.bg)
	arg0.fightBtn = arg0:findTF("btn_list/fight", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.shopBtn, function()
		arg0:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg0.activity.id
		})
	end)
	onButton(arg0, arg0.fightBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end)
end

return var0
