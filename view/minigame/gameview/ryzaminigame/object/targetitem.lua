local var0_0 = class("TargetItem", import("view.miniGame.gameView.RyzaMiniGame.Reactor"))
local var1_0 = {
	hp1 = "4",
	speed = "3",
	power = "2",
	spirit = "6",
	bomb = "1",
	hp2 = "5"
}

function var0_0.InitUI(arg0_1, arg1_1)
	arg0_1.type = arg1_1.type

	arg0_1._tf:Find("Image"):GetComponent(typeof(Animator)):Play(var1_0[arg0_1.type])
	setActive(arg0_1._tf:Find("Burn"), false)
	arg0_1._tf:Find("Burn"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_1:Destroy(false)
	end)
	eachChild(arg0_1._tf:Find("front"), function(arg0_3)
		arg0_3:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_3, false)
		end)
		setActive(arg0_3, arg0_3.name == arg1_1.drop)
	end)
end

function var0_0.InitRegister(arg0_5, arg1_5)
	arg0_5:Register("move", function(arg0_6)
		if isa(arg0_6, MoveRyza) then
			arg0_6:AddItem(arg0_5.type)
			arg0_5:Destroy()
		else
			arg0_5:Destroy(false)
		end
	end, {
		{
			0,
			0
		}
	})
	arg0_5:Register("burn", function()
		arg0_5:DeregisterAll()
		setActive(arg0_5._tf:Find("Image"), false)
		setActive(arg0_5._tf:Find("Burn"), true)
	end, {
		{
			0,
			0
		}
	})
end

return var0_0
