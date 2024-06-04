local var0 = class("MainUrgencySceneSequence")

function var0.Execute(arg0, arg1)
	local var0 = {
		"SkipToActivity",
		"SkipToReFluxActivity",
		"SkipToTechnology"
	}

	arg0:NextOne(1, var0, arg1)
end

function var0.NextOne(arg0, arg1, arg2, arg3)
	local var0 = arg0[arg2[arg1]](arg0)

	if not var0 then
		return
	end

	if var0 and arg1 < #arg2 then
		arg0:NextOne(arg1 + 1, arg2, arg3)
	else
		arg3()
	end
end

function var0.SkipToActivity(arg0)
	if getProxy(ActivityProxy):findNextAutoActivity() then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)

		return false
	end

	return true
end

function var0.SkipToReFluxActivity(arg0)
	local var0 = getProxy(RefluxProxy)

	if var0:isCanSign() and var0:isInRefluxTime() then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.REFLUX)

		return false
	end

	return true
end

function var0.SkipToTechnology(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().level

	if not LOCK_TECHNOLOGY and pg.SystemOpenMgr.GetInstance():isOpenSystem(var0, "TechnologyMediator") and not pg.NewStoryMgr.GetInstance():IsPlayed("FANGAN1") then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SELTECHNOLOGY)
		pg.NewStoryMgr.GetInstance():Play("FANGAN1", function()
			return
		end, true)

		return false
	end

	return true
end

return var0
