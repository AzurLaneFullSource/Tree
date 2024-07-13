local var0_0 = class("WuQiFittingDisplayPage", import("view.base.BaseActivityPage"))

var0_0.blueprintGroupId = 39904

function var0_0.OnInit(arg0_1)
	arg0_1.btnClick = arg0_1._tf:Find("bg/click_area")
	arg0_1.rtAnim = arg0_1._tf:Find("bg/CircleBlue02")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.rtAnim:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_3)
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SHIPBLUEPRINT, {
			shipGroupId = arg0_2.blueprintGroupId
		})
	end)
	onButton(arg0_2, arg0_2.btnClick, function()
		local var0_4, var1_4 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "TechnologyMediator")

		if not var0_4 then
			pg.TipsMgr.GetInstance():ShowTips(var1_4)

			return
		end

		setActive(arg0_2.rtAnim, true)
	end, SFX_PANEL)
end

return var0_0
