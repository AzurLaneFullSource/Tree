local var0_0 = class("ObjectBush", import("view.miniGame.gameView.RyzaMiniGame.object.TargetObject"))

function var0_0.GetBaseOrder(arg0_1)
	return 3
end

function var0_0.CellPassability(arg0_2)
	return true
end

function var0_0.FirePassability(arg0_3)
	return 0
end

function var0_0.InitUI(arg0_4, arg1_4)
	arg0_4.hideCount = 0
end

function var0_0.InitRegister(arg0_5, arg1_5)
	local var0_5 = arg0_5._tf:Find("Image"):GetComponent(typeof(Animator))

	arg0_5:Register("burn", function()
		var0_5:Play("New State")
		var0_5:Play("Burn_A")
	end, {
		{
			0,
			0
		}
	})
	arg0_5:Register("move", function(arg0_7)
		var0_5:Play("New State")
		var0_5:Play("Sway")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-grass")
		arg0_7:SetHide(true)

		if not isa(arg0_7, MoveEnemy) then
			arg0_5:ChangeHide(true)
		end
	end, {
		{
			0,
			0
		}
	})
	arg0_5:Register("leave", function(arg0_8)
		var0_5:Play("New State")
		var0_5:Play("Sway")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-grass")
		arg0_8:SetHide(false)

		if not isa(arg0_8, MoveEnemy) then
			arg0_5:ChangeHide(false)
		end
	end, {
		{
			0,
			0
		}
	})
end

function var0_0.ChangeHide(arg0_9, arg1_9)
	arg0_9.hideCount = arg0_9.hideCount + (arg1_9 and 1 or -1)
	GetOrAddComponent(arg0_9._tf, typeof(CanvasGroup)).alpha = arg0_9.hideCount > 0 and 0.5 or 1
end

return var0_0
