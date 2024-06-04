local var0 = class("MainActBackHillBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_minigame"
end

function var0.OnInit(arg0)
	local var0 = arg0:IsShowTip()

	setActive(arg0.tipTr.gameObject, var0)
end

function var0.GetActivityID(arg0)
	local var0 = checkExist(arg0.config, {
		"time"
	})

	if not var0 then
		return nil
	end

	return var0[1] == "default" and var0[2] or nil
end

function var0.CustomOnClick(arg0)
	local var0 = arg0:GetActivityID()
	local var1 = getProxy(ActivityProxy):getActivityById(var0)

	if var1 then
		local var2 = var1:getConfig("config_client").scene

		if var2 then
			arg0:emit(NewMainMediator.GO_SCENE, var2)

			return
		end
	end

	errorMsg("not bind backhill Activity id:", var0 or "NIL")
	arg0:OnClick()
end

function var0.IsShowTip(arg0)
	local var0 = arg0:GetActivityID()
	local var1 = getProxy(ActivityProxy):getActivityById(var0)

	if var1 then
		local var2 = var1:getConfig("config_client").scene

		if var2 then
			local var3 = Context.New()

			if IsUnityEditor then
				assert(table.Find(SCENE, function(arg0, arg1)
					return arg1 == var2
				end), "not Find name in scene.lua : " .. var2)
			end

			SCENE.SetSceneInfo(var3, var2)

			local var4 = var3.viewComponent.IsShowMainTip

			if var4 then
				return var4(var1)
			end

			errorMsg("scene has not function IsShowMainTip Tip Activity id:", var0 or "NIL")
		end
	end
end

return var0
