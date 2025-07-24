local var0_0 = class("RyzaMainRePage", import("view.activity.CorePage.CorePreviewTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)

	arg0_1.gameBtn = arg0_1:findTF("activity", arg0_1.btnList)
	arg0_1.fightBtn = arg0_1:findTF("fight", arg0_1.btnList)
	arg0_1.shopBtn = arg0_1:findTF("shop", arg0_1.btnList)

	onButton(arg0_1, arg0_1.gameBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 43)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.fightBtn, function()
		arg0_1:emit(ActivityMediator.SKIP_ACTIVITY_MAP, 50042)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.shopBtn, function()
		arg0_1:emit(ActivityMediator.GO_SHOPS_LAYER, {
			actId = 50052,
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end, SFX_PANEL)
end

return var0_0
