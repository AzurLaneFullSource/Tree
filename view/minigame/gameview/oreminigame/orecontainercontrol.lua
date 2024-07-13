local var0_0 = class("OreContainerControl")

var0_0.BREAK_MOVE_TIME = 0.5

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2:AddListener()

	arg0_2.deliverSpeed = 50
	arg0_2.mainTF = arg0_2._tf:Find("Container_1/break")
end

function var0_0.AddListener(arg0_3)
	arg0_3.binder:bind(OreGameConfig.EVENT_DELIVER, function(arg0_4, arg1_4)
		arg0_3:PlayDeliverAnim(arg1_4.status, arg1_4.pos, arg1_4.oreTF)
	end)
	arg0_3.binder:bind(OreGameConfig.EVENT_PLAY_CONTAINER_HIT, function(arg0_5, arg1_5)
		arg0_3:PlayHitAnim(arg1_5.status, arg1_5.pos, arg1_5.hitPos, arg1_5.oreTF)
	end)
end

var0_0.DeliveOffsetY = {
	-7,
	-7,
	-16
}

function var0_0.PlayDeliverAnim(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.mainTF = arg0_6._tf:Find("Container_" .. arg1_6 .. "/deliver")

	setAnchoredPosition(arg0_6.mainTF, {
		x = arg2_6.x,
		y = arg2_6.y + var0_0.DeliveOffsetY[arg1_6]
	})
	setActive(arg0_6.mainTF, true)

	local var0_6 = arg0_6.mainTF:Find("ore/pos")

	removeAllChildren(var0_6)
	cloneTplTo(arg3_6, var0_6)
	arg0_6.mainTF:Find("BK/Image"):GetComponent(typeof(Animator)):Play("Deliver_2_Lift_BK")
	arg0_6.mainTF:Find("FR/Image"):GetComponent(typeof(Animator)):Play("Deliver_2_Lift_FR")

	arg0_6.deliverTime = 0
end

var0_0.moveRata = {
	1,
	1.2,
	1.5
}

function var0_0.PlayHitAnim(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	if arg1_7 == OreAkashiControl.STATUS_NULL then
		return
	end

	arg0_7.mainTF = arg0_7._tf:Find("Container_" .. arg1_7 .. "/break")

	setAnchoredPosition(arg0_7.mainTF, arg2_7)
	setActive(arg0_7.mainTF, true)

	local var0_7 = arg0_7.mainTF.parent:Find("ore/pos")

	removeAllChildren(var0_7)

	arg0_7.orePosList = {}
	arg0_7.oreTFs = cloneTplTo(arg4_7, var0_7):Find("oreTF")
	arg0_7.hitPos = {
		x = -arg3_7.x * var0_0.moveRata[arg1_7],
		y = -arg3_7.y * var0_0.moveRata[arg1_7]
	}

	setAnchoredPosition(var0_7, Vector2(arg2_7.x + arg0_7.hitPos.x, arg2_7.y + arg0_7.hitPos.y))
	arg0_7.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Break")

	arg0_7.breakTime = 0

	eachChild(arg0_7.oreTFs, function(arg0_8)
		arg0_7.orePosList[arg0_8.name] = {
			x = math.random(50) - 25,
			y = math.random(50) - 25
		}
	end)
end

function var0_0.Reset(arg0_9)
	arg0_9.deliverTime = nil
	arg0_9.breakTime = nil
	arg0_9.oreTFs = nil

	setActive(arg0_9.mainTF, false)
	setActive(arg0_9.mainTF.parent:Find("ore/pos"), false)
	removeAllChildren(arg0_9.mainTF.parent:Find("ore/pos"))
	setAnchoredPosition(arg0_9.mainTF, Vector2(0, 0))
end

function var0_0.OnTimer(arg0_10, arg1_10)
	if arg0_10.deliverTime then
		local var0_10 = arg1_10 * arg0_10.deliverSpeed

		setAnchoredPosition(arg0_10.mainTF, {
			x = arg0_10.mainTF.anchoredPosition.x,
			y = arg0_10.mainTF.anchoredPosition.y - var0_10
		})

		arg0_10.deliverTime = arg0_10.deliverTime + arg1_10

		if arg0_10.mainTF.anchoredPosition.y < -230 then
			removeAllChildren(arg0_10.mainTF:Find("ore/pos"))
			arg0_10:Reset()
		end
	end

	if arg0_10.breakTime then
		local var1_10 = {
			x = arg0_10.mainTF.anchoredPosition.x + arg0_10.hitPos.x * arg1_10 / var0_0.BREAK_MOVE_TIME,
			y = arg0_10.mainTF.anchoredPosition.y + arg0_10.hitPos.y * arg1_10 / var0_0.BREAK_MOVE_TIME
		}

		setAnchoredPosition(arg0_10.mainTF, var1_10)

		arg0_10.breakTime = arg0_10.breakTime + arg1_10

		if arg0_10.breakTime >= var0_0.BREAK_MOVE_TIME / 3 then
			if not isActive(arg0_10.mainTF.parent:Find("ore/pos")) then
				setActive(arg0_10.mainTF.parent:Find("ore/pos"), true)
			end

			eachChild(arg0_10.oreTFs, function(arg0_11)
				local var0_11 = arg0_10.orePosList[arg0_11.name]
				local var1_11 = {
					x = arg0_11.anchoredPosition.x + var0_11.x * arg1_10 / (var0_0.BREAK_MOVE_TIME * 2 / 3),
					y = arg0_11.anchoredPosition.y + var0_11.y * arg1_10 / (var0_0.BREAK_MOVE_TIME * 2 / 3)
				}

				setAnchoredPosition(arg0_11, var1_11)
			end)
		end

		if arg0_10.breakTime >= var0_0.BREAK_MOVE_TIME then
			arg0_10:Reset()
		end
	end
end

return var0_0
