local var0 = class("TargetItem", import("view.miniGame.gameView.RyzaMiniGame.Reactor"))
local var1 = {
	hp1 = "4",
	speed = "3",
	power = "2",
	spirit = "6",
	bomb = "1",
	hp2 = "5"
}

function var0.InitUI(arg0, arg1)
	arg0.type = arg1.type

	arg0._tf:Find("Image"):GetComponent(typeof(Animator)):Play(var1[arg0.type])
	setActive(arg0._tf:Find("Burn"), false)
	arg0._tf:Find("Burn"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:Destroy(false)
	end)
	eachChild(arg0._tf:Find("front"), function(arg0)
		arg0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)
		end)
		setActive(arg0, arg0.name == arg1.drop)
	end)
end

function var0.InitRegister(arg0, arg1)
	arg0:Register("move", function(arg0)
		if isa(arg0, MoveRyza) then
			arg0:AddItem(arg0.type)
			arg0:Destroy()
		else
			arg0:Destroy(false)
		end
	end, {
		{
			0,
			0
		}
	})
	arg0:Register("burn", function()
		arg0:DeregisterAll()
		setActive(arg0._tf:Find("Image"), false)
		setActive(arg0._tf:Find("Burn"), true)
	end, {
		{
			0,
			0
		}
	})
end

return var0
