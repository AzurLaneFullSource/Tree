local var0 = class("EffectLaser", import("view.miniGame.gameView.RyzaMiniGame.effect.TargetEffect"))

function var0.GetBaseOrder(arg0)
	if arg0.mark == "N" then
		return var0.super.GetBaseOrder(arg0)
	else
		return 500
	end
end

function var0.InitUI(arg0, arg1)
	arg0.mark = arg1.mark

	arg0:UpdatePos(arg0.pos)

	local var0 = arg0._tf:Find("scale/" .. arg0.mark)

	setActive(var0, true)
	var0:Find("base"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:Destroy()
	end)

	if arg0.responder:CollideRyza(arg0) then
		arg0:Calling("hit", {
			1,
			arg0.realPos
		}, MoveRyza)
	end
end

function var0.GetCollideRange(arg0)
	local var0

	switch(arg0.mark, {
		N = function()
			var0 = {
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
			var0 = {
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
			var0 = {
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
			var0 = {
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
		var0
	}
end

return var0
