local var0_0 = class("BeachGamePage", import("view.base.BaseActivityPage"))

var0_0.MINIGAME_HUB_ID = 37
var0_0.MINIGAME_ID = 44

function var0_0.OnInit(arg0_1)
	arg0_1.goBtn = arg0_1:findTF("AD/go")
	arg0_1.indexTpl = arg0_1:findTF("AD/index")
	arg0_1.markContainer = arg0_1:findTF("AD/marks")
	arg0_1.markTpl = arg0_1:findTF("AD/marks/1")
	arg0_1.markTrs = {}

	for iter0_1 = 1, 7 do
		local var0_1 = cloneTplTo(arg0_1.markTpl, arg0_1.markContainer, iter0_1)

		setActive(var0_1:Find("open"), iter0_1 ~= 7)
		setActive(var0_1:Find("openL"), iter0_1 == 7)
		table.insert(arg0_1.markTrs, var0_1)
	end
end

function var0_0.OnDataSetting(arg0_2)
	return
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_0.MINIGAME_ID)
	end, SFX_PANEL)

	local var0_3 = getProxy(MiniGameProxy):GetHubByHubId(var0_0.MINIGAME_HUB_ID)

	arg0_3:FlushMarks(var0_3)
	Canvas.ForceUpdateCanvases()
	arg0_3:FlushIndex(var0_3)
end

function var0_0.FlushMarks(arg0_5, arg1_5)
	local var0_5 = arg1_5.usedtime
	local var1_5 = var0_5 + arg1_5.count

	for iter0_5, iter1_5 in ipairs(arg0_5.markTrs) do
		setActive(iter1_5, iter0_5 <= var1_5)
		setActive(iter1_5:Find("finish"), iter0_5 <= var0_5 and iter0_5 ~= 7)
		setActive(iter1_5:Find("finishL"), iter0_5 <= var0_5 and iter0_5 == 7)
	end
end

function var0_0.FlushIndex(arg0_6, arg1_6)
	local var0_6 = arg1_6.usedtime

	setActive(arg0_6.indexTpl, var0_6 > 0)

	if var0_6 > 0 then
		local var1_6 = arg0_6.markTrs[math.min(var0_6, #arg0_6.markTrs)]
		local var2_6 = arg0_6.indexTpl.parent:InverseTransformPoint(var1_6.position)

		arg0_6.indexTpl.localPosition = Vector3(var2_6.x, var2_6.y, 0)
	end
end

function var0_0.OnUpdateFlush(arg0_7)
	return
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
