local var0_0 = class("EffectLaser", import("view.miniGame.gameView.RyzaMiniGame.effect.TargetEffect"))

function var0_0.GetBaseOrder(arg0_1)
	if arg0_1.mark == "N" then
		return var0_0.super.GetBaseOrder(arg0_1)
	else
		return 500
	end
end

function var0_0.InitUI(arg0_2, arg1_2)
	arg0_2.mark = arg1_2.mark

	arg0_2:UpdatePos(arg0_2.pos)

	local var0_2 = arg0_2._tf:Find("scale/" .. arg0_2.mark)

	setActive(var0_2, true)
	var0_2:Find("base"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_2:Destroy()
	end)

	if arg0_2.responder:CollideRyza(arg0_2) then
		arg0_2:Calling("hit", {
			1,
			arg0_2.realPos
		}, MoveRyza)
	end
end

function var0_0.GetCollideRange(arg0_4)
	local var0_4

	switch(arg0_4.mark, {
		N = function()
			var0_4 = {
				{
					-0.5,
					0.5
				},
				{
					-25,
					-0.5
				}
			}
		end,
		S = function()
			var0_4 = {
				{
					-0.5,
					0.5
				},
				{
					0.5,
					25
				}
			}
		end,
		W = function()
			var0_4 = {
				{
					-25,
					-0.5
				},
				{
					-0.5,
					0.5
				}
			}
		end,
		E = function()
			var0_4 = {
				{
					0.5,
					25
				},
				{
					-0.5,
					0.5
				}
			}
		end
	})

	return {
		var0_4
	}
end

return var0_0
