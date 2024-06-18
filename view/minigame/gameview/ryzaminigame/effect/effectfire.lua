local var0_0 = class("EffectFire", import("view.miniGame.gameView.RyzaMiniGame.effect.TargetEffect"))

function var0_0.GetBaseOrder(arg0_1)
	return "floor"
end

local var1_0 = {
	"S",
	"E",
	"N",
	"W"
}

function var0_0.InitUI(arg0_2, arg1_2)
	arg0_2.power = arg1_2.power

	eachChild(arg0_2._tf, function(arg0_3)
		setActive(arg0_3, arg0_3.name == "C")
	end)

	local var0_2 = arg0_2._tf:Find("C/Image"):GetComponent(typeof(DftAniEvent))

	var0_2:SetTriggerEvent(function()
		arg0_2.triggerCount = defaultValue(arg0_2.triggerCount, 0) + 1

		switch(arg0_2.triggerCount, {
			function()
				local var0_5, var1_5, var2_5 = arg0_2.responder:GetCrossFire(arg0_2.pos, arg0_2.power)

				for iter0_5, iter1_5 in ipairs(var0_5) do
					local var3_5 = arg0_2._tf:Find(var1_0[iter0_5])

					for iter2_5 = var3_5.childCount + 1, iter1_5 do
						local var4_5 = cloneTplTo(var3_5:Find("7"), var3_5, iter2_5)

						if iter0_5 < 3 then
							var4_5:SetAsLastSibling()
						end
					end

					local var5_5 = var3_5.childCount

					for iter3_5 = 1, var5_5 do
						setActive(var3_5:Find(iter3_5), iter3_5 <= iter1_5)
					end

					setActive(var3_5, true)
				end

				arg0_2:Calling("burn", {}, var1_5)

				arg0_2.lenList = var0_5

				arg0_2:Register("move", function(arg0_6)
					arg0_2:Calling("burn", {}, arg0_6)
				end, var1_5)

				for iter4_5, iter5_5 in pairs(var2_5) do
					arg0_2:Calling("block", {
						iter5_5[2]
					}, iter5_5[1])
				end
			end,
			function()
				arg0_2.lenList = nil

				arg0_2:Deregister("move")
			end
		})
	end)
	var0_2:SetEndEvent(function()
		arg0_2:Destroy()
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-bomb")
end

function var0_0.GetCollideRange(arg0_9)
	if arg0_9.lenList then
		return {
			{
				{
					-0.5 - arg0_9.lenList[4],
					0.5 + arg0_9.lenList[2]
				},
				{
					-0.5,
					0.5
				}
			},
			{
				{
					-0.5,
					0.5
				},
				{
					-0.5 - arg0_9.lenList[3],
					0.5 + arg0_9.lenList[1]
				}
			}
		}
	else
		return {}
	end
end

return var0_0
