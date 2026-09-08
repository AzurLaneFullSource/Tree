local var0_0 = class("MainReFluxSequence")

var0_0.GUIDE_FLAG = false

local var1_0 = {
	{
		id = "Reflux",
		condition = function()
			return true
		end,
		args = function()
			return {}
		end
	}
}

function var0_0.Execute(arg0_3, arg1_3)
	if var0_0.GUIDE_FLAG then
		MainGuideSequence.New():DoAction(var1_0, arg1_3, true)

		var0_0.GUIDE_FLAG = false

		return
	end

	if not arg0_3:ShouldHandleReflux() then
		arg1_3()

		return
	end

	seriesAsync({
		function(arg0_4)
			arg0_3:PlayReFluxCG(arg0_4)
		end,
		function(arg0_5)
			arg0_3:SkipToReFluxActivity()
			arg0_5()
		end
	})
end

function var0_0.ShouldHandleReflux(arg0_6)
	local var0_6 = getProxy(RefluxProxy)

	return var0_6:isCanSign() and var0_6:isInRefluxTime()
end

function var0_0.PlayReFluxCG(arg0_7, arg1_7)
	local var0_7 = getProxy(RefluxProxy)
	local var1_7 = var0_7:GetRefluxBgs()

	var0_0.GUIDE_FLAG = true

	if #var1_7 < 4 then
		arg1_7()

		return
	end

	if var0_7.signCount ~= 0 then
		arg1_7()

		return
	end

	local var2_7 = RefluxAnimationPlayer.New(pg.UIMgr.GetInstance().OverlayUITop)

	pg.m02:sendNotification(GAME.START_REFLUX_CG)
	var2_7:ExecuteAction("Play", var1_7, function()
		if arg0_7.player then
			var2_7:Destroy()

			arg0_7.player = nil
		end

		pg.m02:sendNotification(GAME.END_REFLUX_CG)
		arg1_7()
	end)

	arg0_7.player = var2_7
end

function var0_0.SkipToReFluxActivity(arg0_9)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.REFLUX)
end

function var0_0.Dispose(arg0_10)
	if arg0_10.player and arg0_10.player:GetLoaded() then
		arg0_10.player:Destroy()

		arg0_10.player = nil
	end
end

return var0_0
