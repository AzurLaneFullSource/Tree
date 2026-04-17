local var0_0 = class("IslandCheaterTavernCardViewManager")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.uiContainer = arg1_1

	arg0_1:CreateCardMainRoot()
	arg0_1:CreateOtherCardRoot()

	if not arg0_1.luHandle then
		arg0_1.luHandle = UpdateBeat:CreateListener(arg0_1.UpDateHandler, arg0_1)

		UpdateBeat:AddListener(arg0_1.luHandle)
	end

	arg0_1.layerMask = LayerMask.GetMask("Island")
	arg0_1.cardPoolMgr = CardPoolMgr.New()
	arg0_1.curveX = LoadAny("island/jumpcurve/CardCurveX", "", typeof(JumpCurve)).curve
	arg0_1.curveY = LoadAny("island/jumpcurve/CardCurveY", "", typeof(JumpCurve)).curve
	arg0_1.curveZ = LoadAny("island/jumpcurve/CardCurveZ", "", typeof(JumpCurve)).curve
end

function var0_0.SetMainPlayerSeat(arg0_2, arg1_2)
	arg0_2.mainPlayerSeat = arg1_2
end

function var0_0.UpDateHandler(arg0_3)
	for iter0_3, iter1_3 in pairs(arg0_3.cardKeyDic or {}) do
		iter1_3:Update()
	end

	for iter2_3, iter3_3 in pairs(arg0_3.otherPlayerCardDic or {}) do
		for iter4_3, iter5_3 in pairs(iter3_3) do
			iter5_3:Update()
		end
	end

	for iter6_3, iter7_3 in ipairs(arg0_3.tableCardList or {}) do
		iter7_3:Update()
	end

	arg0_3:UpdateCardMainRootPos()

	if not Input.GetMouseButtonDown(0) then
		return
	end

	if not IsNil(UnityEngine.EventSystems.EventSystem.current.currentSelectedGameObject) and UnityEngine.EventSystems.EventSystem.current:IsPointerOverGameObject() then
		return
	end

	local var0_3 = Input.mousePosition
	local var1_3 = CheatTavernCameraMgr.instance._mainCamera:ScreenPointToRay(var0_3)
	local var2_3, var3_3 = Physics.Raycast(var1_3, hit, 1000, arg0_3.layerMask)

	if var2_3 then
		local var4_3 = var3_3.collider.gameObject:GetComponent(typeof(CheaterTavernCard))

		if var4_3 == nil then
			return
		end

		local var5_3 = var4_3.key

		if var4_3.parm == 0 then
			return
		end

		local var6_3 = arg0_3.selectCardKey[var5_3] or false

		if not var6_3 then
			local var7_3 = 0

			for iter8_3, iter9_3 in pairs(arg0_3.selectCardKey) do
				if iter9_3 then
					var7_3 = var7_3 + 1
				end
			end

			if var7_3 >= IslandCheaterTavernConst.putCountMax then
				return
			end
		end

		arg0_3:UpdateSelectCard(var5_3, not var6_3)
	end
end

function var0_0.UpdateSelectCard(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.cardKeyDic[arg1_4]

	if var0_4 == nil then
		return
	end

	arg0_4.selectCardKey[arg1_4] = arg2_4

	var0_4:SetSelected(arg2_4)
end

function var0_0.GetSelectCardKeyList(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.selectCardKey) do
		if iter1_5 and arg0_5.cardKeyDic[iter0_5] then
			table.insert(var0_5, iter0_5)
		end
	end

	arg0_5.selectCardKey = {}

	return var0_5
end

function var0_0.InitMainCard(arg0_6, arg1_6)
	arg0_6.tableCardList = {}
	arg0_6.selectCardKey = {}
	arg0_6.cardDataList = arg1_6
	arg0_6.cardKeyDic = {}

	local var0_6 = #arg1_6

	for iter0_6, iter1_6 in ipairs(arg1_6) do
		local var1_6 = iter1_6.id
		local var2_6 = iter1_6.key
		local var3_6 = MainCardItem.New({
			id = var1_6,
			key = var2_6,
			index = iter0_6,
			mainPlayerSeat = arg0_6.mainPlayerSeat,
			allCount = var0_6
		}, arg0_6.cardPoolMgr, arg0_6.CardMainRoot.transform)

		arg0_6.cardKeyDic[var2_6] = var3_6

		var3_6:SetCurveOffsetY(arg0_6.curveX, arg0_6.curveY, arg0_6.curveZ)
	end
end

function var0_0.InitOtherPlayerCard(arg0_7, arg1_7)
	for iter0_7, iter1_7 in pairs(arg0_7.otherPlayerCardDic or {}) do
		for iter2_7, iter3_7 in pairs(iter1_7 or {}) do
			iter3_7:Destroy()
		end
	end

	arg0_7.otherPlayerCardDic = {}

	for iter4_7, iter5_7 in ipairs(arg1_7) do
		if not iter5_7:IsOut() then
			local var0_7 = iter5_7.seat

			arg0_7.otherPlayerCardDic[iter5_7.user_id] = {}

			local var1_7 = iter5_7:GetCardNum()

			for iter6_7 = 1, var1_7 do
				local var2_7 = arg0_7.seatOherRootDic[var0_7]
				local var3_7 = MainCardItem.New({
					id = 0,
					key = 0,
					index = iter6_7,
					mainPlayerSeat = arg0_7.mainPlayerSeat,
					allCount = var1_7
				}, arg0_7.cardPoolMgr, var2_7)

				var3_7:SetCurveOffsetY(arg0_7.curveX, arg0_7.curveY, arg0_7.curveZ)

				arg0_7.otherPlayerCardDic[iter5_7.user_id][iter6_7] = var3_7
			end
		end
	end
end

function var0_0.RefreshMainCard(arg0_8, arg1_8)
	local var0_8 = #arg1_8

	arg0_8.cardDataList = arg1_8

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var1_8 = iter1_8.key
		local var2_8 = arg0_8.cardKeyDic[var1_8]

		var2_8:SetIndex(iter0_8)
		var2_8:SetAllCount(var0_8)
		var2_8:InitCardView()
	end
end

function var0_0.PutDownMainCard(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg1_9) do
		local var0_9 = arg0_9.cardKeyDic[iter1_9]

		if var0_9 then
			var0_9:MoveToTable(iter0_9, #arg1_9)

			if not IslandCheaterTavernConst.putCardTest then
				arg0_9.cardKeyDic[iter1_9] = nil

				table.insert(arg0_9.tableCardList, var0_9)
			end
		end
	end
end

function var0_0.OtherPlayerPutCard(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.otherPlayerCardDic[arg1_10] or {}
	local var1_10 = #var0_10
	local var2_10 = var1_10 - arg2_10 + 1
	local var3_10 = 1

	for iter0_10 = var2_10, var1_10 do
		local var4_10 = var0_10[iter0_10]

		if var4_10 then
			var4_10:MoveToTable(var3_10, arg2_10)

			var3_10 = var3_10 + 1
			var0_10[iter0_10] = nil

			table.insert(arg0_10.tableCardList, var4_10)
		end
	end
end

function var0_0.OtherPlayerCardDestroy(arg0_11, arg1_11)
	local var0_11 = arg0_11.otherPlayerCardDic[arg1_11] or {}

	for iter0_11, iter1_11 in pairs(var0_11) do
		iter1_11:Destroy()
	end

	arg0_11.otherPlayerCardDic[arg1_11] = {}
end

function var0_0.PlayerCardSetActive(arg0_12, arg1_12, arg2_12)
	if getProxy(PlayerProxy):getRawData().id == arg1_12 then
		for iter0_12, iter1_12 in pairs(arg0_12.cardKeyDic or {}) do
			iter1_12:SetActive(arg2_12)
		end
	else
		local var0_12 = arg0_12.otherPlayerCardDic[arg1_12] or {}

		for iter2_12, iter3_12 in pairs(var0_12) do
			iter3_12:SetActive(arg2_12)
		end
	end
end

function var0_0.FlipTableCard(arg0_13, arg1_13)
	local var0_13 = #arg0_13.tableCardList

	for iter0_13, iter1_13 in ipairs(arg0_13.tableCardList) do
		local var1_13 = arg1_13[iter0_13]

		iter1_13:FlipTableCard(var1_13, iter0_13, var0_13)
	end
end

function var0_0.ClearTableCard(arg0_14)
	if arg0_14.tableCardList == nil then
		return
	end

	for iter0_14, iter1_14 in ipairs(arg0_14.tableCardList) do
		iter1_14:Destroy()
	end

	table.clear(arg0_14.tableCardList)
end

function var0_0.DestroyMainCard(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.cardKeyDic or {}) do
		iter1_15:Destroy()
	end

	arg0_15.cardKeyDic = {}
	arg0_15.selectCardKey = {}
	arg0_15.cardDataList = {}
end

function var0_0.CreateCardMainRoot(arg0_16)
	arg0_16.CardMainRoot = GameObject.New("CardMainRoot")

	arg0_16:UpdateCardMainRootPos()
end

function var0_0.CreateOtherCardRoot(arg0_17)
	arg0_17.seatOherRootDic = {}

	for iter0_17 = 1, 4 do
		local var0_17 = iter0_17

		arg0_17.seatOherRootDic[iter0_17] = GameObject.New(tostring(iter0_17)).transform

		local var1_17 = 10110000 + iter0_17
		local var2_17 = pg.island_world_objects[var1_17]
		local var3_17 = var2_17.param.position[1]
		local var4_17 = var2_17.param.position[3]
		local var5_17 = {
			1,
			0,
			-1,
			0
		}
		local var6_17 = {
			0,
			-1,
			0,
			1
		}
		local var7_17 = var3_17 + var5_17[var0_17] * IslandCheaterTavernConst.horOffset
		local var8_17 = var4_17 + var6_17[var0_17] * IslandCheaterTavernConst.horOffset
		local var9_17 = {
			-90,
			0,
			90,
			180
		}
		local var10_17 = Vector3(var7_17, IslandCheaterTavernConst.verOffset, var8_17)

		arg0_17.seatOherRootDic[iter0_17].position = var10_17
		arg0_17.seatOherRootDic[iter0_17].rotation = Quaternion.Euler(var2_17.param.rotation[1], var9_17[var0_17], var2_17.param.rotation[3])
	end
end

function var0_0.UpdateCardMainRootPos(arg0_18)
	local var0_18 = GameObject.Find("UICamera"):GetComponent(typeof(Camera)):WorldToScreenPoint(arg0_18.uiContainer.position)
	local var1_18 = IslandCheaterTavernConst.cardOffsetToCamara
	local var2_18 = CheatTavernCameraMgr.instance._mainCamera:ScreenToWorldPoint(Vector3(var0_18.x, var0_18.y, var1_18))

	arg0_18.CardMainRoot.transform.localPosition = Vector3(var2_18.x, var2_18.y, var2_18.z)
	arg0_18.CardMainRoot.transform.rotation = CheatTavernCameraMgr.instance._mainCamera.transform.rotation
end

function var0_0.Destroy(arg0_19)
	UpdateBeat:RemoveListener(arg0_19.luHandle)

	if arg0_19.CardMainRoot then
		GameObject.Destroy(arg0_19.CardMainRoot)

		arg0_19.CardMainRoot = nil
	end

	for iter0_19, iter1_19 in pairs(arg0_19.seatOherRootDic) do
		if iter1_19 then
			GameObject.Destroy(iter1_19.gameObject)
		end
	end

	arg0_19.seatOherRootDic = {}

	for iter2_19, iter3_19 in pairs(arg0_19.otherPlayerCardDic or {}) do
		for iter4_19, iter5_19 in pairs(iter3_19) do
			iter5_19:Destroy()
		end
	end

	for iter6_19, iter7_19 in pairs(arg0_19.cardKeyDic or {}) do
		iter7_19:Destroy()
	end

	for iter8_19, iter9_19 in ipairs(arg0_19.tableCardList or {}) do
		iter9_19:Destroy()
	end

	arg0_19.cardPoolMgr:Destroy()
end

return var0_0
