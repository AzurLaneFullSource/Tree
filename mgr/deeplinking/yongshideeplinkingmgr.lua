pg = pg or {}

local var0 = pg

var0.YongshiDeepLinkingMgr = singletonClass("YongshiDeepLinkingMgr")

local var1 = var0.YongshiDeepLinkingMgr
local var2 = true

local function var3(arg0)
	if var2 then
		originalPrint(arg0)
	end
end

function var1.SetData(arg0, arg1)
	var3("SetData......")

	arg0.deepLinking = arg1

	arg0:SwitchScene()
end

function var1.ShouldSwitchScene(arg0)
	if arg0.deepLinking == nil or arg0.deepLinking:IsEmpty() then
		var3("deepLinking is empty")

		return false
	end

	if not var0.m02 then
		var3("game is not start")

		return false
	end

	local var0 = getProxy(ContextProxy):getCurrentContext()

	if not var0 then
		var3("game is not start")

		return false
	end

	if var0.mediator == LoginMediator then
		var3("player is not created")

		return false
	end

	if var0.mediator == CombatLoadMediator or var0.mediator == BattleMediator then
		var3("game is in battle")
		arg0:Clear()

		return false
	end

	return true
end

local function var4(arg0, arg1)
	var3("Switch......" .. arg0 .. "-" .. arg1)

	if arg0 == "1" then
		var0.m02:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD)
	end
end

function var1.SwitchScene(arg0)
	var3("SwitchScene......")

	if arg0:ShouldSwitchScene() then
		local var0 = arg0.deepLinking.page
		local var1 = arg0.deepLinking.arg

		var4(var0, var1)
		arg0:Clear()
	end
end

function var1.Clear(arg0)
	var3("Clear......")
	arg0.deepLinking:Clear()

	arg0.deepLinking = nil
end
