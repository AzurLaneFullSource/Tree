local var0 = class("OreContainerControl")

var0.BREAK_MOVE_TIME = 0.5

function var0.Ctor(arg0, arg1, arg2)
	arg0.binder = arg1
	arg0._tf = arg2

	arg0:Init()
end

function var0.Init(arg0)
	arg0:AddListener()

	arg0.deliverSpeed = 50
	arg0.mainTF = arg0._tf:Find("Container_1/break")
end

function var0.AddListener(arg0)
	arg0.binder:bind(OreGameConfig.EVENT_DELIVER, function(arg0, arg1)
		arg0:PlayDeliverAnim(arg1.status, arg1.pos, arg1.oreTF)
	end)
	arg0.binder:bind(OreGameConfig.EVENT_PLAY_CONTAINER_HIT, function(arg0, arg1)
		arg0:PlayHitAnim(arg1.status, arg1.pos, arg1.hitPos, arg1.oreTF)
	end)
end

var0.DeliveOffsetY = {
	-7,
	-7,
	-16
}

function var0.PlayDeliverAnim(arg0, arg1, arg2, arg3)
	arg0.mainTF = arg0._tf:Find("Container_" .. arg1 .. "/deliver")

	setAnchoredPosition(arg0.mainTF, {
		x = arg2.x,
		y = arg2.y + var0.DeliveOffsetY[arg1]
	})
	setActive(arg0.mainTF, true)

	local var0 = arg0.mainTF:Find("ore/pos")

	removeAllChildren(var0)
	cloneTplTo(arg3, var0)
	arg0.mainTF:Find("BK/Image"):GetComponent(typeof(Animator)):Play("Deliver_2_Lift_BK")
	arg0.mainTF:Find("FR/Image"):GetComponent(typeof(Animator)):Play("Deliver_2_Lift_FR")

	arg0.deliverTime = 0
end

var0.moveRata = {
	1,
	1.2,
	1.5
}

function var0.PlayHitAnim(arg0, arg1, arg2, arg3, arg4)
	if arg1 == OreAkashiControl.STATUS_NULL then
		return
	end

	arg0.mainTF = arg0._tf:Find("Container_" .. arg1 .. "/break")

	setAnchoredPosition(arg0.mainTF, arg2)
	setActive(arg0.mainTF, true)

	local var0 = arg0.mainTF.parent:Find("ore/pos")

	removeAllChildren(var0)

	arg0.orePosList = {}
	arg0.oreTFs = cloneTplTo(arg4, var0):Find("oreTF")
	arg0.hitPos = {
		x = -arg3.x * var0.moveRata[arg1],
		y = -arg3.y * var0.moveRata[arg1]
	}

	setAnchoredPosition(var0, Vector2(arg2.x + arg0.hitPos.x, arg2.y + arg0.hitPos.y))
	arg0.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Break")

	arg0.breakTime = 0

	eachChild(arg0.oreTFs, function(arg0)
		arg0.orePosList[arg0.name] = {
			x = math.random(50) - 25,
			y = math.random(50) - 25
		}
	end)
end

function var0.Reset(arg0)
	arg0.deliverTime = nil
	arg0.breakTime = nil
	arg0.oreTFs = nil

	setActive(arg0.mainTF, false)
	setActive(arg0.mainTF.parent:Find("ore/pos"), false)
	removeAllChildren(arg0.mainTF.parent:Find("ore/pos"))
	setAnchoredPosition(arg0.mainTF, Vector2(0, 0))
end

function var0.OnTimer(arg0, arg1)
	if arg0.deliverTime then
		local var0 = arg1 * arg0.deliverSpeed

		setAnchoredPosition(arg0.mainTF, {
			x = arg0.mainTF.anchoredPosition.x,
			y = arg0.mainTF.anchoredPosition.y - var0
		})

		arg0.deliverTime = arg0.deliverTime + arg1

		if arg0.mainTF.anchoredPosition.y < -230 then
			removeAllChildren(arg0.mainTF:Find("ore/pos"))
			arg0:Reset()
		end
	end

	if arg0.breakTime then
		local var1 = {
			x = arg0.mainTF.anchoredPosition.x + arg0.hitPos.x * arg1 / var0.BREAK_MOVE_TIME,
			y = arg0.mainTF.anchoredPosition.y + arg0.hitPos.y * arg1 / var0.BREAK_MOVE_TIME
		}

		setAnchoredPosition(arg0.mainTF, var1)

		arg0.breakTime = arg0.breakTime + arg1

		if arg0.breakTime >= var0.BREAK_MOVE_TIME / 3 then
			if not isActive(arg0.mainTF.parent:Find("ore/pos")) then
				setActive(arg0.mainTF.parent:Find("ore/pos"), true)
			end

			eachChild(arg0.oreTFs, function(arg0)
				local var0 = arg0.orePosList[arg0.name]
				local var1 = {
					x = arg0.anchoredPosition.x + var0.x * arg1 / (var0.BREAK_MOVE_TIME * 2 / 3),
					y = arg0.anchoredPosition.y + var0.y * arg1 / (var0.BREAK_MOVE_TIME * 2 / 3)
				}

				setAnchoredPosition(arg0, var1)
			end)
		end

		if arg0.breakTime >= var0.BREAK_MOVE_TIME then
			arg0:Reset()
		end
	end
end

return var0
