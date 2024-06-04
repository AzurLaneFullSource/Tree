local var0 = class("ObjectBomb", import("view.miniGame.gameView.RyzaMiniGame.object.TargetObject"))

function var0.FirePassability(arg0)
	return 0
end

function var0.InTimeRiver(arg0)
	return true
end

function var0.InitUI(arg0, arg1)
	arg0.cooldown = arg1.cooldown or 3
	arg0.power = arg1.power

	arg0:Calling("move", {
		arg0
	}, {
		{
			0,
			0
		}
	})
end

function var0.InitRegister(arg0, arg1)
	arg0:Register("burn", function()
		arg0:Burning()
	end, {
		{
			0,
			0
		}
	})
end

function var0.Burning(arg0)
	if arg0.burst then
		return
	else
		arg0.burst = true
	end

	arg0.cooldown = 0

	arg0:DeregisterAll()
	arg0:Calling("leave", {
		arg0
	}, {
		{
			0,
			0
		}
	})
	arg0:Calling("feedback", {}, MoveRyza)
	arg0.responder:Create({
		name = "Fire",
		pos = {
			arg0.pos.x,
			arg0.pos.y
		},
		power = arg0.power
	})
	arg0:Destroy()
end

function var0.TimeUpdate(arg0, arg1)
	if arg0.cooldown > 0 then
		if arg0.cooldown > 2.87 and arg0.cooldown - arg1 <= 2.87 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-blasting fuse")
		end

		arg0.cooldown = arg0.cooldown - arg1

		if arg0.cooldown <= 0 then
			arg0:Burning()
		end
	end
end

function var0.SetHide(arg0, arg1)
	arg0.hide = arg1
end

return var0
