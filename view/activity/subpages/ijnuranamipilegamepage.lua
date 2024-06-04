local var0 = class("IJNUranamiPileGamePage", import("view.base.BaseActivityPage"))

var0.MINIGAME_HUB_ID = 39
var0.MINIGAME_ID = 47

function var0.OnInit(arg0)
	arg0.goBtn = arg0:findTF("AD/go")
	arg0.indexTpl = arg0:findTF("AD/index")
	arg0.markContainer = arg0:findTF("AD/marks")
	arg0.markTpl = arg0:findTF("AD/marks/1")
	arg0.markTrs = {}

	for iter0 = 1, 7 do
		local var0 = cloneTplTo(arg0.markTpl, arg0.markContainer, iter0)

		table.insert(arg0.markTrs, var0)
	end
end

function var0.OnDataSetting(arg0)
	return
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0.MINIGAME_ID)
	end, SFX_PANEL)

	local var0 = getProxy(MiniGameProxy):GetHubByHubId(var0.MINIGAME_HUB_ID)

	arg0:FlushMarks(var0)
	Canvas.ForceUpdateCanvases()
	arg0:FlushIndex(var0)
end

function var0.FlushMarks(arg0, arg1)
	local var0 = arg1.usedtime
	local var1 = var0 + arg1.count

	for iter0, iter1 in ipairs(arg0.markTrs) do
		setActive(iter1, iter0 <= var1)
		setActive(iter1:Find("finish"), iter0 <= var0)
	end
end

function var0.FlushIndex(arg0, arg1)
	local var0 = arg1.usedtime

	setActive(arg0.indexTpl, var0 > 0)

	if var0 > 0 then
		local var1 = arg0.markTrs[math.min(var0, #arg0.markTrs)]
		local var2 = arg0.indexTpl.parent:InverseTransformPoint(var1.position)

		arg0.indexTpl.localPosition = Vector3(var2.x, var2.y, 0)
	end
end

function var0.OnUpdateFlush(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

return var0
