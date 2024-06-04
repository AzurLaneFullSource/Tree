local var0 = class("WuQiFittingDisplayPage", import("view.base.BaseActivityPage"))

var0.blueprintGroupId = 39904

function var0.OnInit(arg0)
	arg0.btnClick = arg0._tf:Find("bg/click_area")
	arg0.rtAnim = arg0._tf:Find("bg/CircleBlue02")
end

function var0.OnFirstFlush(arg0)
	arg0.rtAnim:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SHIPBLUEPRINT, {
			shipGroupId = arg0.blueprintGroupId
		})
	end)
	onButton(arg0, arg0.btnClick, function()
		local var0, var1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "TechnologyMediator")

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		setActive(arg0.rtAnim, true)
	end, SFX_PANEL)
end

return var0
