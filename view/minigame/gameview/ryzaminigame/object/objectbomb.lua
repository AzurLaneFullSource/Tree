local var0_0 = class("ObjectBomb", import("view.miniGame.gameView.RyzaMiniGame.object.TargetObject"))

function var0_0.FirePassability(arg0_1)
	return 0
end

function var0_0.InTimeRiver(arg0_2)
	return true
end

function var0_0.InitUI(arg0_3, arg1_3)
	arg0_3.cooldown = arg1_3.cooldown or 3
	arg0_3.power = arg1_3.power

	arg0_3:Calling("move", {
		arg0_3
	}, {
		{
			0,
			0
		}
	})
end

function var0_0.InitRegister(arg0_4, arg1_4)
	arg0_4:Register("burn", function()
		arg0_4:Burning()
	end, {
		{
			0,
			0
		}
	})
end

function var0_0.Burning(arg0_6)
	if arg0_6.burst then
		return
	else
		arg0_6.burst = true
	end

	arg0_6.cooldown = 0

	arg0_6:DeregisterAll()
	arg0_6:Calling("leave", {
		arg0_6
	}, {
		{
			0,
			0
		}
	})
	arg0_6:Calling("feedback", {}, MoveRyza)
	arg0_6.responder:Create({
		name = "Fire",
		pos = {
			arg0_6.pos.x,
			arg0_6.pos.y
		},
		power = arg0_6.power
	})
	arg0_6:Destroy()
end

function var0_0.TimeUpdate(arg0_7, arg1_7)
	if arg0_7.cooldown > 0 then
		if arg0_7.cooldown > 2.87 and arg0_7.cooldown - arg1_7 <= 2.87 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-blasting fuse")
		end

		arg0_7.cooldown = arg0_7.cooldown - arg1_7

		if arg0_7.cooldown <= 0 then
			arg0_7:Burning()
		end
	end
end

function var0_0.SetHide(arg0_8, arg1_8)
	arg0_8.hide = arg1_8
end

return var0_0
