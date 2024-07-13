local var0_0 = class("MainActBackHillBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_minigame"
end

function var0_0.OnInit(arg0_2)
	local var0_2 = arg0_2:IsShowTip()

	setActive(arg0_2.tipTr.gameObject, var0_2)
end

function var0_0.GetActivityID(arg0_3)
	local var0_3 = checkExist(arg0_3.config, {
		"time"
	})

	if not var0_3 then
		return nil
	end

	return var0_3[1] == "default" and var0_3[2] or nil
end

function var0_0.CustomOnClick(arg0_4)
	local var0_4 = arg0_4:GetActivityID()
	local var1_4 = getProxy(ActivityProxy):getActivityById(var0_4)

	if var1_4 then
		local var2_4 = var1_4:getConfig("config_client").scene

		if var2_4 then
			arg0_4:emit(NewMainMediator.GO_SCENE, var2_4)

			return
		end
	end

	errorMsg("not bind backhill Activity id:", var0_4 or "NIL")
	arg0_4:OnClick()
end

function var0_0.IsShowTip(arg0_5)
	local var0_5 = arg0_5:GetActivityID()
	local var1_5 = getProxy(ActivityProxy):getActivityById(var0_5)

	if var1_5 then
		local var2_5 = var1_5:getConfig("config_client").scene

		if var2_5 then
			local var3_5 = Context.New()

			if IsUnityEditor then
				assert(table.Find(SCENE, function(arg0_6, arg1_6)
					return arg1_6 == var2_5
				end), "not Find name in scene.lua : " .. var2_5)
			end

			SCENE.SetSceneInfo(var3_5, var2_5)

			local var4_5 = var3_5.viewComponent.IsShowMainTip

			if var4_5 then
				return var4_5(var1_5)
			end

			errorMsg("scene has not function IsShowMainTip Tip Activity id:", var0_5 or "NIL")
		end
	end
end

return var0_0
