pg = pg or {}

local var0_0 = pg

var0_0.YongshiDeepLinkingMgr = singletonClass("YongshiDeepLinkingMgr")

local var1_0 = var0_0.YongshiDeepLinkingMgr
local var2_0 = true

local function var3_0(arg0_1)
	if var2_0 then
		originalPrint(arg0_1)
	end
end

function var1_0.SetData(arg0_2, arg1_2)
	var3_0("SetData......")

	arg0_2.deepLinking = arg1_2

	arg0_2:SwitchScene()
end

function var1_0.ShouldSwitchScene(arg0_3)
	if arg0_3.deepLinking == nil or arg0_3.deepLinking:IsEmpty() then
		var3_0("deepLinking is empty")

		return false
	end

	if not var0_0.m02 then
		var3_0("game is not start")

		return false
	end

	local var0_3 = getProxy(ContextProxy):getCurrentContext()

	if not var0_3 then
		var3_0("game is not start")

		return false
	end

	if var0_3.mediator == LoginMediator then
		var3_0("player is not created")

		return false
	end

	if var0_3.mediator == CombatLoadMediator or var0_3.mediator == BattleMediator then
		var3_0("game is in battle")
		arg0_3:Clear()

		return false
	end

	return true
end

local function var4_0(arg0_4, arg1_4)
	var3_0("Switch......" .. arg0_4 .. "-" .. arg1_4)

	if arg0_4 == "1" then
		var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD)
	end
end

function var1_0.SwitchScene(arg0_5)
	var3_0("SwitchScene......")

	if arg0_5:ShouldSwitchScene() then
		local var0_5 = arg0_5.deepLinking.page
		local var1_5 = arg0_5.deepLinking.arg

		var4_0(var0_5, var1_5)
		arg0_5:Clear()
	end
end

function var1_0.Clear(arg0_6)
	var3_0("Clear......")
	arg0_6.deepLinking:Clear()

	arg0_6.deepLinking = nil
end
