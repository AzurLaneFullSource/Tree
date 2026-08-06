local var0_0 = class("MainCardItem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.isLoaded = false

	arg0_1:Init(arg1_1, arg2_1, arg3_1)
end

function var0_0.Init(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.key = arg1_2.key
	arg0_2.id = arg1_2.id
	arg0_2.index = arg1_2.index
	arg0_2.hasSend = false
	arg0_2.cardPoolMgr = arg2_2

	if arg1_2.allCount then
		arg0_2:SetAllCount(arg1_2.allCount)
	end

	if arg3_2 then
		arg0_2:SetUIRoot(arg3_2)
	end

	arg0_2.mainPlayerSeat = arg1_2.mainPlayerSeat

	local function var0_2(arg0_3)
		arg0_2.tf = tf(arg0_3)
		arg0_2.isLoaded = true
		arg0_2.selectedCardTf = arg0_2.tf:Find("vfx_bar_kapai01")
		arg0_2.unSelectedCardTf = arg0_2.tf:Find("vfx_bar_kapai02")

		arg0_2:SetSelected(false)

		local var0_3 = GetOrAddComponent(arg0_3, typeof(CheaterTavernCard))

		var0_3.key = arg0_2.key
		var0_3.parm = arg0_2.id

		arg0_2:InitCardView()
	end

	arg0_2.cardPoolMgr:GetCardGameObjectById(arg0_2.id, var0_2)
end

function var0_0.SetIndex(arg0_4, arg1_4)
	arg0_4.index = arg1_4
end

function var0_0.SetUIRoot(arg0_5, arg1_5)
	arg0_5.rootTransform = arg1_5
end

function var0_0.SetAllCount(arg0_6, arg1_6)
	arg0_6.allCount = arg1_6
end

function var0_0.SetCurveOffsetY(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.cureveX = arg1_7
	arg0_7.cureveY = arg2_7
	arg0_7.cureveZ = arg3_7
end

function var0_0.InitCardView(arg0_8)
	if arg0_8.hasSend then
		return
	end

	setActive(arg0_8.tf.gameObject, true)

	local var0_8 = 0.001
	local var1_8 = arg0_8.index

	setParent(arg0_8.tf, arg0_8.rootTransform, false)

	local var2_8 = var1_8 - (arg0_8.allCount + 1) / 2
	local var3_8 = math.ceil(math.abs(var2_8)) * IslandCheaterTavernConst.cardRoationOffset

	if var2_8 < 0 then
		var3_8 = -var3_8
	end

	setLocalRotation(arg0_8.tf, Quaternion.Euler(0, 180, var3_8))

	local var4_8 = arg0_8.allCount
	local var5_8 = IslandCheaterTavernConst.cardWidth
	local var6_8 = IslandCheaterTavernConst.cardSpace
	local var7_8 = -(var4_8 * var5_8 + (var4_8 - 1) * var6_8) / 2 + var5_8 / 2 + (var1_8 - 1) * (var5_8 + var6_8)
	local var8_8 = 0.01
	local var9_8 = -(var2_8 * var2_8) * var8_8

	setLocalPosition(arg0_8.tf, Vector3(var7_8, var9_8, -var0_8 * (var1_8 - 1)))
	setLocalScale(arg0_8.tf, Vector3(1, 1, 1))
end

function var0_0.SetSelected(arg0_9, arg1_9)
	arg0_9.isSelected = arg1_9

	if arg0_9.isSelected then
		setLocalPosition(arg0_9.tf, Vector3(arg0_9.tf.localPosition.x, arg0_9.tf.localPosition.y + 0.02, arg0_9.tf.localPosition.z))
		setActive(arg0_9.selectedCardTf, true)
		setActive(arg0_9.unSelectedCardTf, false)
	else
		setLocalPosition(arg0_9.tf, Vector3(arg0_9.tf.localPosition.x, arg0_9.tf.localPosition.y - 0.02, arg0_9.tf.localPosition.z))
		setActive(arg0_9.selectedCardTf, false)
		setActive(arg0_9.unSelectedCardTf, true)
	end
end

function var0_0.Update(arg0_10)
	if not arg0_10.isLoaded then
		return
	end

	arg0_10:UpdateMoveToTable()
	arg0_10:UpdateFlipTableCard()
end

function var0_0.UpdateMoveToTable(arg0_11)
	if not arg0_11.moveToTable then
		return
	end

	if not arg0_11.isLoaded then
		return
	end

	arg0_11.deltaTime = Time.deltaTime + arg0_11.deltaTime

	local var0_11 = arg0_11.deltaTime / IslandCheaterTavernConst.moveToTableTime
	local var1_11 = arg0_11.cureveZ:Evaluate(var0_11)
	local var2_11 = Vector3.Lerp(arg0_11.startPos, arg0_11.endPos, var1_11)

	if arg0_11.mainPlayerSeat == 1 then
		var2_11.z = var2_11.z + arg0_11.cureveX:Evaluate(var0_11) * 0.3
	elseif arg0_11.mainPlayerSeat == 2 then
		var2_11.x = var2_11.x + arg0_11.cureveX:Evaluate(var0_11) * 0.3
	elseif arg0_11.mainPlayerSeat == 3 then
		var2_11.z = var2_11.z - arg0_11.cureveX:Evaluate(var0_11) * 0.3
	else
		var2_11.x = var2_11.x - arg0_11.cureveX:Evaluate(var0_11) * 0.3
	end

	var2_11.y = var2_11.y + arg0_11.cureveY:Evaluate(var0_11) * 0.3
	arg0_11.tf.position = var2_11
	arg0_11.tf.rotation = Quaternion.Slerp(arg0_11.startRotation, arg0_11.endRotation, var1_11)
	arg0_11.tf.localScale = Vector3.Lerp(arg0_11.startScale, arg0_11.endScale, var1_11)

	if var0_11 >= 1 then
		arg0_11.moveToTable = false

		if IslandCheaterTavernConst.putCardTest then
			onDelayTick(function()
				arg0_11.tf.position = arg0_11.startPos

				arg0_11:SetSelected(false)

				arg0_11.tf.rotation = arg0_11.startRotation
				arg0_11.tf.localScale = arg0_11.startScale
			end, 1)
		end
	end
end

function var0_0.MoveToTable(arg0_13, arg1_13, arg2_13)
	if not arg0_13.isLoaded then
		return
	end

	setActive(arg0_13.selectedCardTf, false)

	arg0_13.hasSend = true
	arg0_13.moveToTable = true
	arg0_13.deltaTime = 0
	arg0_13.startPos = arg0_13.tf.position
	arg0_13.startScale = arg0_13.tf.localScale
	arg0_13.startRotation = arg0_13.tf.rotation

	local var0_13 = IslandCheaterTavernConst.cardWidth * 2
	local var1_13 = 0
	local var2_13 = -(arg2_13 * var0_13 + (arg2_13 - 1) * var1_13) / 2 + var0_13 / 2 + (arg1_13 - 1) * (var0_13 + var1_13)
	local var3_13 = 0
	local var4_13 = 0
	local var5_13 = 0.001 * arg1_13

	if arg0_13.mainPlayerSeat % 2 == 0 then
		var3_13 = var2_13
	else
		var4_13 = var2_13
	end

	arg0_13.endPos = Vector3(6.29 + var3_13, 0.92 + var5_13, 2.11 + var4_13)

	local var6_13 = IslandCheaterTavernConst.seatRotatonY[arg0_13.mainPlayerSeat]

	arg0_13.endRotation = Quaternion.Euler(90, var6_13, 0)
	arg0_13.endScale = Vector3(2, 2, 2)
end

function var0_0.UpdateFlipTableCard(arg0_14)
	if not arg0_14.isFliping then
		return
	end

	arg0_14.flipDeltaTime = arg0_14.flipDeltaTime + Time.deltaTime

	local var0_14 = math.min(arg0_14.flipDeltaTime / IslandCheaterTavernConst.FlipCardTime, 1)
	local var1_14 = Mathf.Lerp(0, 180, var0_14)

	arg0_14.tf.rotation = arg0_14.startFlipRotation * Quaternion.AngleAxis(var1_14, arg0_14.localUp)

	if var0_14 >= 1 then
		arg0_14.isFliping = false
	end
end

function var0_0.FlipTableCard(arg0_15, arg1_15, arg2_15, arg3_15)
	if arg0_15.id ~= arg1_15 then
		local var0_15 = arg0_15.tf.position
		local var1_15 = arg0_15.tf.rotation
		local var2_15 = arg0_15.tf.localScale

		arg0_15.cardPoolMgr:ReturnGameObjectById(arg0_15.id, arg0_15.tf.gameObject)

		arg0_15.tf = nil

		local function var3_15(arg0_16)
			arg0_15.tf = arg0_16.transform
			arg0_15.selectedCardTf = arg0_15.tf:Find("vfx_bar_kapai01")

			setActive(arg0_15.selectedCardTf, false)

			arg0_15.tf.position = var0_15
			arg0_15.tf.rotation = var1_15
			arg0_15.tf.localScale = var2_15
		end

		arg0_15.cardPoolMgr:GetCardGameObjectById(arg1_15, var3_15, true)

		arg0_15.id = arg1_15
	end

	setParent(arg0_15.tf, nil)

	arg0_15.isFliping = true
	arg0_15.deltaTime = 0
	arg0_15.flipDeltaTime = 0
	arg0_15.startPos = arg0_15.tf.position

	local var4_15 = IslandCheaterTavernConst.seatRotatonY[arg0_15.mainPlayerSeat]

	arg0_15.startFlipRotation = Quaternion.Euler(90, var4_15, 0)
	arg0_15.localUp = arg0_15.startFlipRotation * Vector3.forward

	local var5_15 = IslandCheaterTavernConst.cardWidth * 2
	local var6_15 = 0
	local var7_15 = -(arg3_15 * var5_15 + (arg3_15 - 1) * var6_15) / 2 + var5_15 / 2 + (arg2_15 - 1) * (var5_15 + var6_15)
	local var8_15 = 0
	local var9_15 = 0
	local var10_15 = 0.001 * arg2_15

	if arg0_15.mainPlayerSeat % 2 == 0 then
		var8_15 = var7_15
	else
		var9_15 = var7_15
	end

	arg0_15.tf.position = Vector3(6.29 + var8_15, 0.92 + var10_15, 2.11 + var9_15)
end

function var0_0.SetActive(arg0_17, arg1_17)
	setActive(arg0_17.tf, arg1_17)
end

function var0_0.Destroy(arg0_18)
	if IsNil(arg0_18.tf) then
		return
	end

	arg0_18.selectedCardTf = nil
	arg0_18.unSelectedCardTf = nil

	arg0_18.cardPoolMgr:ReturnGameObjectById(arg0_18.id, arg0_18.tf.gameObject)

	arg0_18.tf = nil
end

return var0_0
