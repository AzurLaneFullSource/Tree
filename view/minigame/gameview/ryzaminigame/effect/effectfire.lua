local var0 = class("EffectFire", import("view.miniGame.gameView.RyzaMiniGame.effect.TargetEffect"))

function var0.GetBaseOrder(arg0)
	return "floor"
end

local var1 = {
	"S",
	"E",
	"N",
	"W"
}

function var0.InitUI(arg0, arg1)
	arg0.power = arg1.power

	eachChild(arg0._tf, function(arg0)
		setActive(arg0, arg0.name == "C")
	end)

	local var0 = arg0._tf:Find("C/Image"):GetComponent(typeof(DftAniEvent))

	var0:SetTriggerEvent(function()
		arg0.triggerCount = defaultValue(arg0.triggerCount, 0) + 1

		switch(arg0.triggerCount, {
			function()
				local var0, var1, var2 = arg0.responder:GetCrossFire(arg0.pos, arg0.power)

				for iter0, iter1 in ipairs(var0) do
					local var3 = arg0._tf:Find(var1[iter0])

					for iter2 = var3.childCount + 1, iter1 do
						local var4 = cloneTplTo(var3:Find("7"), var3, iter2)

						if iter0 < 3 then
							var4:SetAsLastSibling()
						end
					end

					local var5 = var3.childCount

					for iter3 = 1, var5 do
						setActive(var3:Find(iter3), iter3 <= iter1)
					end

					setActive(var3, true)
				end

				arg0:Calling("burn", {}, var1)

				arg0.lenList = var0

				arg0:Register("move", function(arg0)
					arg0:Calling("burn", {}, arg0)
				end, var1)

				for iter4, iter5 in pairs(var2) do
					arg0:Calling("block", {
						iter5[2]
					}, iter5[1])
				end
			end,
			function()
				arg0.lenList = nil

				arg0:Deregister("move")
			end
		})
	end)
	var0:SetEndEvent(function()
		arg0:Destroy()
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-bomb")
end

function var0.GetCollideRange(arg0)
	if arg0.lenList then
		return {
			{
				{
					-0.5 - arg0.lenList[4],
					0.5 + arg0.lenList[2]
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
					-0.5 - arg0.lenList[3],
					0.5 + arg0.lenList[1]
				}
			}
		}
	else
		return {}
	end
end

return var0
