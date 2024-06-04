local var0 = class("ObjectBush", import("view.miniGame.gameView.RyzaMiniGame.object.TargetObject"))

function var0.GetBaseOrder(arg0)
	return 3
end

function var0.CellPassability(arg0)
	return true
end

function var0.FirePassability(arg0)
	return 0
end

function var0.InitUI(arg0, arg1)
	arg0.hideCount = 0
end

function var0.InitRegister(arg0, arg1)
	local var0 = arg0._tf:Find("Image"):GetComponent(typeof(Animator))

	arg0:Register("burn", function()
		var0:Play("New State")
		var0:Play("Burn_A")
	end, {
		{
			0,
			0
		}
	})
	arg0:Register("move", function(arg0)
		var0:Play("New State")
		var0:Play("Sway")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-grass")
		arg0:SetHide(true)

		if not isa(arg0, MoveEnemy) then
			arg0:ChangeHide(true)
		end
	end, {
		{
			0,
			0
		}
	})
	arg0:Register("leave", function(arg0)
		var0:Play("New State")
		var0:Play("Sway")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-grass")
		arg0:SetHide(false)

		if not isa(arg0, MoveEnemy) then
			arg0:ChangeHide(false)
		end
	end, {
		{
			0,
			0
		}
	})
end

function var0.ChangeHide(arg0, arg1)
	arg0.hideCount = arg0.hideCount + (arg1 and 1 or -1)
	GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).alpha = arg0.hideCount > 0 and 0.5 or 1
end

return var0
