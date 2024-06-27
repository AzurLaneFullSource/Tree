local var0_0 = class("BossRushAlvitPassedLayer", import("view.activity.BossRush.BossRushPassedLayer"))

var0_0.GROW_TIME = 0.55

function var0_0.getUIName(arg0_1)
	return "BossRushAlvitPassedUI"
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)

	local var0_2 = arg0_2:findTF("Image")
	local var1_2 = math.random(1, var0_2.childCount)

	eachChild(var0_2, function(arg0_3)
		setActive(arg0_3, tonumber(arg0_3.name) == var1_2)
	end)
end

return var0_0
