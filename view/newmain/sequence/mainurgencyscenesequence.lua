local var0_0 = class("MainUrgencySceneSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = {
		"SkipToActivity",
		"SkipToReFluxActivity",
		"SkipToTechnology"
	}

	arg0_1:NextOne(1, var0_1, arg1_1)
end

function var0_0.NextOne(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg0_2[arg2_2[arg1_2]](arg0_2)

	if not var0_2 then
		return
	end

	if var0_2 and arg1_2 < #arg2_2 then
		arg0_2:NextOne(arg1_2 + 1, arg2_2, arg3_2)
	else
		arg3_2()
	end
end

function var0_0.SkipToActivity(arg0_3)
	if getProxy(ActivityProxy):findNextAutoActivity() then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)

		return false
	end

	return true
end

function var0_0.SkipToReFluxActivity(arg0_4)
	local var0_4 = getProxy(RefluxProxy)

	if var0_4:isCanSign() and var0_4:isInRefluxTime() then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.REFLUX)

		return false
	end

	return true
end

function var0_0.SkipToTechnology(arg0_5)
	local var0_5 = getProxy(PlayerProxy):getRawData().level

	if not LOCK_TECHNOLOGY and pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_5, "TechnologyMediator") and not pg.NewStoryMgr.GetInstance():IsPlayed("FANGAN1") then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SELTECHNOLOGY)
		pg.NewStoryMgr.GetInstance():Play("FANGAN1", function()
			return
		end, true)

		return false
	end

	return true
end

return var0_0
